1 // File: @openzeppelin/contracts/utils/Counters.sol
2 // SPDX-License-Identifier: MIT
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
120 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
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
237         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
238         uint8 v = uint8((uint256(vs) >> 255) + 27);
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
349 // File: @openzeppelin/contracts/utils/Context.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Provides information about the current execution context, including the
358  * sender of the transaction and its data. While these are generally available
359  * via msg.sender and msg.data, they should not be accessed in such a direct
360  * manner, since when dealing with meta-transactions the account sending and
361  * paying for execution may not be the actual sender (as far as an application
362  * is concerned).
363  *
364  * This contract is only required for intermediate, library-like contracts.
365  */
366 abstract contract Context {
367     function _msgSender() internal view virtual returns (address) {
368         return msg.sender;
369     }
370 
371     function _msgData() internal view virtual returns (bytes calldata) {
372         return msg.data;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/access/Ownable.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 
384 /**
385  * @dev Contract module which provides a basic access control mechanism, where
386  * there is an account (an owner) that can be granted exclusive access to
387  * specific functions.
388  *
389  * By default, the owner account will be the one that deploys the contract. This
390  * can later be changed with {transferOwnership}.
391  *
392  * This module is used through inheritance. It will make available the modifier
393  * `onlyOwner`, which can be applied to your functions to restrict their use to
394  * the owner.
395  */
396 abstract contract Ownable is Context {
397     address private _owner;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor() {
405         _transferOwnership(_msgSender());
406     }
407 
408     /**
409      * @dev Returns the address of the current owner.
410      */
411     function owner() public view virtual returns (address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if called by any account other than the owner.
417      */
418     modifier onlyOwner() {
419         require(owner() == _msgSender(), "Ownable: caller is not the owner");
420         _;
421     }
422 
423     /**
424      * @dev Leaves the contract without owner. It will not be possible to call
425      * `onlyOwner` functions anymore. Can only be called by the current owner.
426      *
427      * NOTE: Renouncing ownership will leave the contract without an owner,
428      * thereby removing any functionality that is only available to the owner.
429      */
430     function renounceOwnership() public virtual onlyOwner {
431         _transferOwnership(address(0));
432     }
433 
434     /**
435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
436      * Can only be called by the current owner.
437      */
438     function transferOwnership(address newOwner) public virtual onlyOwner {
439         require(newOwner != address(0), "Ownable: new owner is the zero address");
440         _transferOwnership(newOwner);
441     }
442 
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Internal function without access restriction.
446      */
447     function _transferOwnership(address newOwner) internal virtual {
448         address oldOwner = _owner;
449         _owner = newOwner;
450         emit OwnershipTransferred(oldOwner, newOwner);
451     }
452 }
453 
454 // File: @openzeppelin/contracts/utils/Address.sol
455 
456 
457 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
458 
459 pragma solidity ^0.8.1;
460 
461 /**
462  * @dev Collection of functions related to the address type
463  */
464 library Address {
465     /**
466      * @dev Returns true if `account` is a contract.
467      *
468      * [IMPORTANT]
469      * ====
470      * It is unsafe to assume that an address for which this function returns
471      * false is an externally-owned account (EOA) and not a contract.
472      *
473      * Among others, `isContract` will return false for the following
474      * types of addresses:
475      *
476      *  - an externally-owned account
477      *  - a contract in construction
478      *  - an address where a contract will be created
479      *  - an address where a contract lived, but was destroyed
480      * ====
481      *
482      * [IMPORTANT]
483      * ====
484      * You shouldn't rely on `isContract` to protect against flash loan attacks!
485      *
486      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
487      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
488      * constructor.
489      * ====
490      */
491     function isContract(address account) internal view returns (bool) {
492         // This method relies on extcodesize/address.code.length, which returns 0
493         // for contracts in construction, since the code is only stored at the end
494         // of the constructor execution.
495 
496         return account.code.length > 0;
497     }
498 
499     /**
500      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
501      * `recipient`, forwarding all available gas and reverting on errors.
502      *
503      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
504      * of certain opcodes, possibly making contracts go over the 2300 gas limit
505      * imposed by `transfer`, making them unable to receive funds via
506      * `transfer`. {sendValue} removes this limitation.
507      *
508      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
509      *
510      * IMPORTANT: because control is transferred to `recipient`, care must be
511      * taken to not create reentrancy vulnerabilities. Consider using
512      * {ReentrancyGuard} or the
513      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
514      */
515     function sendValue(address payable recipient, uint256 amount) internal {
516         require(address(this).balance >= amount, "Address: insufficient balance");
517 
518         (bool success, ) = recipient.call{value: amount}("");
519         require(success, "Address: unable to send value, recipient may have reverted");
520     }
521 
522     /**
523      * @dev Performs a Solidity function call using a low level `call`. A
524      * plain `call` is an unsafe replacement for a function call: use this
525      * function instead.
526      *
527      * If `target` reverts with a revert reason, it is bubbled up by this
528      * function (like regular Solidity function calls).
529      *
530      * Returns the raw returned data. To convert to the expected return value,
531      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
532      *
533      * Requirements:
534      *
535      * - `target` must be a contract.
536      * - calling `target` with `data` must not revert.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
541         return functionCall(target, data, "Address: low-level call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
546      * `errorMessage` as a fallback revert reason when `target` reverts.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         return functionCallWithValue(target, data, 0, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but also transferring `value` wei to `target`.
561      *
562      * Requirements:
563      *
564      * - the calling contract must have an ETH balance of at least `value`.
565      * - the called Solidity function must be `payable`.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(
570         address target,
571         bytes memory data,
572         uint256 value
573     ) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
579      * with `errorMessage` as a fallback revert reason when `target` reverts.
580      *
581      * _Available since v3.1._
582      */
583     function functionCallWithValue(
584         address target,
585         bytes memory data,
586         uint256 value,
587         string memory errorMessage
588     ) internal returns (bytes memory) {
589         require(address(this).balance >= value, "Address: insufficient balance for call");
590         require(isContract(target), "Address: call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.call{value: value}(data);
593         return verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
603         return functionStaticCall(target, data, "Address: low-level static call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(
613         address target,
614         bytes memory data,
615         string memory errorMessage
616     ) internal view returns (bytes memory) {
617         require(isContract(target), "Address: static call to non-contract");
618 
619         (bool success, bytes memory returndata) = target.staticcall(data);
620         return verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
625      * but performing a delegate call.
626      *
627      * _Available since v3.4._
628      */
629     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
630         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
635      * but performing a delegate call.
636      *
637      * _Available since v3.4._
638      */
639     function functionDelegateCall(
640         address target,
641         bytes memory data,
642         string memory errorMessage
643     ) internal returns (bytes memory) {
644         require(isContract(target), "Address: delegate call to non-contract");
645 
646         (bool success, bytes memory returndata) = target.delegatecall(data);
647         return verifyCallResult(success, returndata, errorMessage);
648     }
649 
650     /**
651      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
652      * revert reason using the provided one.
653      *
654      * _Available since v4.3._
655      */
656     function verifyCallResult(
657         bool success,
658         bytes memory returndata,
659         string memory errorMessage
660     ) internal pure returns (bytes memory) {
661         if (success) {
662             return returndata;
663         } else {
664             // Look for revert reason and bubble it up if present
665             if (returndata.length > 0) {
666                 // The easiest way to bubble the revert reason is using memory via assembly
667 
668                 assembly {
669                     let returndata_size := mload(returndata)
670                     revert(add(32, returndata), returndata_size)
671                 }
672             } else {
673                 revert(errorMessage);
674             }
675         }
676     }
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
680 
681 
682 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @title ERC721 token receiver interface
688  * @dev Interface for any contract that wants to support safeTransfers
689  * from ERC721 asset contracts.
690  */
691 interface IERC721Receiver {
692     /**
693      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
694      * by `operator` from `from`, this function is called.
695      *
696      * It must return its Solidity selector to confirm the token transfer.
697      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
698      *
699      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
700      */
701     function onERC721Received(
702         address operator,
703         address from,
704         uint256 tokenId,
705         bytes calldata data
706     ) external returns (bytes4);
707 }
708 
709 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 /**
717  * @dev Interface of the ERC165 standard, as defined in the
718  * https://eips.ethereum.org/EIPS/eip-165[EIP].
719  *
720  * Implementers can declare support of contract interfaces, which can then be
721  * queried by others ({ERC165Checker}).
722  *
723  * For an implementation, see {ERC165}.
724  */
725 interface IERC165 {
726     /**
727      * @dev Returns true if this contract implements the interface defined by
728      * `interfaceId`. See the corresponding
729      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
730      * to learn more about how these ids are created.
731      *
732      * This function call must use less than 30 000 gas.
733      */
734     function supportsInterface(bytes4 interfaceId) external view returns (bool);
735 }
736 
737 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 /**
746  * @dev Implementation of the {IERC165} interface.
747  *
748  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
749  * for the additional interface id that will be supported. For example:
750  *
751  * ```solidity
752  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
754  * }
755  * ```
756  *
757  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
758  */
759 abstract contract ERC165 is IERC165 {
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
764         return interfaceId == type(IERC165).interfaceId;
765     }
766 }
767 
768 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
769 
770 
771 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 
776 /**
777  * @dev Required interface of an ERC721 compliant contract.
778  */
779 interface IERC721 is IERC165 {
780     /**
781      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
782      */
783     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
784 
785     /**
786      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
787      */
788     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
789 
790     /**
791      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
792      */
793     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
794 
795     /**
796      * @dev Returns the number of tokens in ``owner``'s account.
797      */
798     function balanceOf(address owner) external view returns (uint256 balance);
799 
800     /**
801      * @dev Returns the owner of the `tokenId` token.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function ownerOf(uint256 tokenId) external view returns (address owner);
808 
809     /**
810      * @dev Safely transfers `tokenId` token from `from` to `to`.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must exist and be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes calldata data
827     ) external;
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
885      * @dev Approve or remove `operator` as an operator for the caller.
886      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
887      *
888      * Requirements:
889      *
890      * - The `operator` cannot be the caller.
891      *
892      * Emits an {ApprovalForAll} event.
893      */
894     function setApprovalForAll(address operator, bool _approved) external;
895 
896     /**
897      * @dev Returns the account approved for `tokenId` token.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must exist.
902      */
903     function getApproved(uint256 tokenId) external view returns (address operator);
904 
905     /**
906      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
907      *
908      * See {setApprovalForAll}
909      */
910     function isApprovedForAll(address owner, address operator) external view returns (bool);
911 }
912 
913 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
914 
915 
916 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
917 
918 pragma solidity ^0.8.0;
919 
920 
921 /**
922  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
923  * @dev See https://eips.ethereum.org/EIPS/eip-721
924  */
925 interface IERC721Metadata is IERC721 {
926     /**
927      * @dev Returns the token collection name.
928      */
929     function name() external view returns (string memory);
930 
931     /**
932      * @dev Returns the token collection symbol.
933      */
934     function symbol() external view returns (string memory);
935 
936     /**
937      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
938      */
939     function tokenURI(uint256 tokenId) external view returns (string memory);
940 }
941 
942 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
943 
944 
945 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
946 
947 pragma solidity ^0.8.0;
948 
949 
950 
951 
952 
953 
954 
955 
956 /**
957  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
958  * the Metadata extension, but not including the Enumerable extension, which is available separately as
959  * {ERC721Enumerable}.
960  */
961 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
962     using Address for address;
963     using Strings for uint256;
964 
965     // Token name
966     string private _name;
967 
968     // Token symbol
969     string private _symbol;
970 
971     // Mapping from token ID to owner address
972     mapping(uint256 => address) private _owners;
973 
974     // Mapping owner address to token count
975     mapping(address => uint256) private _balances;
976 
977     // Mapping from token ID to approved address
978     mapping(uint256 => address) private _tokenApprovals;
979 
980     // Mapping from owner to operator approvals
981     mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983     /**
984      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
985      */
986     constructor(string memory name_, string memory symbol_) {
987         _name = name_;
988         _symbol = symbol_;
989     }
990 
991     /**
992      * @dev See {IERC165-supportsInterface}.
993      */
994     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
995         return
996             interfaceId == type(IERC721).interfaceId ||
997             interfaceId == type(IERC721Metadata).interfaceId ||
998             super.supportsInterface(interfaceId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-balanceOf}.
1003      */
1004     function balanceOf(address owner) public view virtual override returns (uint256) {
1005         require(owner != address(0), "ERC721: balance query for the zero address");
1006         return _balances[owner];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-ownerOf}.
1011      */
1012     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1013         address owner = _owners[tokenId];
1014         require(owner != address(0), "ERC721: owner query for nonexistent token");
1015         return owner;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-name}.
1020      */
1021     function name() public view virtual override returns (string memory) {
1022         return _name;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-symbol}.
1027      */
1028     function symbol() public view virtual override returns (string memory) {
1029         return _symbol;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Metadata-tokenURI}.
1034      */
1035     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1036         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1037 
1038         string memory baseURI = _baseURI();
1039         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1040     }
1041 
1042     /**
1043      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1044      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1045      * by default, can be overridden in child contracts.
1046      */
1047     function _baseURI() internal view virtual returns (string memory) {
1048         return "";
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-approve}.
1053      */
1054     function approve(address to, uint256 tokenId) public virtual override {
1055         address owner = ERC721.ownerOf(tokenId);
1056         require(to != owner, "ERC721: approval to current owner");
1057 
1058         require(
1059             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1060             "ERC721: approve caller is not owner nor approved for all"
1061         );
1062 
1063         _approve(to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-getApproved}.
1068      */
1069     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1070         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1071 
1072         return _tokenApprovals[tokenId];
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-setApprovalForAll}.
1077      */
1078     function setApprovalForAll(address operator, bool approved) public virtual override {
1079         _setApprovalForAll(_msgSender(), operator, approved);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-isApprovedForAll}.
1084      */
1085     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1086         return _operatorApprovals[owner][operator];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-transferFrom}.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         //solhint-disable-next-line max-line-length
1098         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1099 
1100         _transfer(from, to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-safeTransferFrom}.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public virtual override {
1111         safeTransferFrom(from, to, tokenId, "");
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-safeTransferFrom}.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) public virtual override {
1123         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1124         _safeTransfer(from, to, tokenId, _data);
1125     }
1126 
1127     /**
1128      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1129      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1130      *
1131      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1132      *
1133      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1134      * implement alternative mechanisms to perform token transfer, such as signature-based.
1135      *
1136      * Requirements:
1137      *
1138      * - `from` cannot be the zero address.
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must exist and be owned by `from`.
1141      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _safeTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) internal virtual {
1151         _transfer(from, to, tokenId);
1152         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1153     }
1154 
1155     /**
1156      * @dev Returns whether `tokenId` exists.
1157      *
1158      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1159      *
1160      * Tokens start existing when they are minted (`_mint`),
1161      * and stop existing when they are burned (`_burn`).
1162      */
1163     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1164         return _owners[tokenId] != address(0);
1165     }
1166 
1167     /**
1168      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1169      *
1170      * Requirements:
1171      *
1172      * - `tokenId` must exist.
1173      */
1174     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1175         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1176         address owner = ERC721.ownerOf(tokenId);
1177         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1178     }
1179 
1180     /**
1181      * @dev Safely mints `tokenId` and transfers it to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must not exist.
1186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _safeMint(address to, uint256 tokenId) internal virtual {
1191         _safeMint(to, tokenId, "");
1192     }
1193 
1194     /**
1195      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1196      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1197      */
1198     function _safeMint(
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) internal virtual {
1203         _mint(to, tokenId);
1204         require(
1205             _checkOnERC721Received(address(0), to, tokenId, _data),
1206             "ERC721: transfer to non ERC721Receiver implementer"
1207         );
1208     }
1209 
1210     /**
1211      * @dev Mints `tokenId` and transfers it to `to`.
1212      *
1213      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must not exist.
1218      * - `to` cannot be the zero address.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _mint(address to, uint256 tokenId) internal virtual {
1223         require(to != address(0), "ERC721: mint to the zero address");
1224         require(!_exists(tokenId), "ERC721: token already minted");
1225 
1226         _beforeTokenTransfer(address(0), to, tokenId);
1227 
1228         _balances[to] += 1;
1229         _owners[tokenId] = to;
1230 
1231         emit Transfer(address(0), to, tokenId);
1232 
1233         _afterTokenTransfer(address(0), to, tokenId);
1234     }
1235 
1236     /**
1237      * @dev Destroys `tokenId`.
1238      * The approval is cleared when the token is burned.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _burn(uint256 tokenId) internal virtual {
1247         address owner = ERC721.ownerOf(tokenId);
1248 
1249         _beforeTokenTransfer(owner, address(0), tokenId);
1250 
1251         // Clear approvals
1252         _approve(address(0), tokenId);
1253 
1254         _balances[owner] -= 1;
1255         delete _owners[tokenId];
1256 
1257         emit Transfer(owner, address(0), tokenId);
1258 
1259         _afterTokenTransfer(owner, address(0), tokenId);
1260     }
1261 
1262     /**
1263      * @dev Transfers `tokenId` from `from` to `to`.
1264      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1265      *
1266      * Requirements:
1267      *
1268      * - `to` cannot be the zero address.
1269      * - `tokenId` token must be owned by `from`.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _transfer(
1274         address from,
1275         address to,
1276         uint256 tokenId
1277     ) internal virtual {
1278         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1279         require(to != address(0), "ERC721: transfer to the zero address");
1280 
1281         _beforeTokenTransfer(from, to, tokenId);
1282 
1283         // Clear approvals from the previous owner
1284         _approve(address(0), tokenId);
1285 
1286         _balances[from] -= 1;
1287         _balances[to] += 1;
1288         _owners[tokenId] = to;
1289 
1290         emit Transfer(from, to, tokenId);
1291 
1292         _afterTokenTransfer(from, to, tokenId);
1293     }
1294 
1295     /**
1296      * @dev Approve `to` to operate on `tokenId`
1297      *
1298      * Emits a {Approval} event.
1299      */
1300     function _approve(address to, uint256 tokenId) internal virtual {
1301         _tokenApprovals[tokenId] = to;
1302         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1303     }
1304 
1305     /**
1306      * @dev Approve `operator` to operate on all of `owner` tokens
1307      *
1308      * Emits a {ApprovalForAll} event.
1309      */
1310     function _setApprovalForAll(
1311         address owner,
1312         address operator,
1313         bool approved
1314     ) internal virtual {
1315         require(owner != operator, "ERC721: approve to caller");
1316         _operatorApprovals[owner][operator] = approved;
1317         emit ApprovalForAll(owner, operator, approved);
1318     }
1319 
1320     /**
1321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1322      * The call is not executed if the target address is not a contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         if (to.isContract()) {
1337             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1338                 return retval == IERC721Receiver.onERC721Received.selector;
1339             } catch (bytes memory reason) {
1340                 if (reason.length == 0) {
1341                     revert("ERC721: transfer to non ERC721Receiver implementer");
1342                 } else {
1343                     assembly {
1344                         revert(add(32, reason), mload(reason))
1345                     }
1346                 }
1347             }
1348         } else {
1349             return true;
1350         }
1351     }
1352 
1353     /**
1354      * @dev Hook that is called before any token transfer. This includes minting
1355      * and burning.
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` will be minted for `to`.
1362      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1363      * - `from` and `to` are never both zero.
1364      *
1365      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1366      */
1367     function _beforeTokenTransfer(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) internal virtual {}
1372 
1373     /**
1374      * @dev Hook that is called after any transfer of tokens. This includes
1375      * minting and burning.
1376      *
1377      * Calling conditions:
1378      *
1379      * - when `from` and `to` are both non-zero.
1380      * - `from` and `to` are never both zero.
1381      *
1382      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1383      */
1384     function _afterTokenTransfer(
1385         address from,
1386         address to,
1387         uint256 tokenId
1388     ) internal virtual {}
1389 }
1390 
1391 // File: erc721a/contracts/IERC721A.sol
1392 
1393 
1394 // ERC721A Contracts v4.0.0
1395 // Creator: Chiru Labs
1396 
1397 pragma solidity ^0.8.4;
1398 
1399 /**
1400  * @dev Interface of an ERC721A compliant contract.
1401  */
1402 interface IERC721A {
1403     /**
1404      * The caller must own the token or be an approved operator.
1405      */
1406     error ApprovalCallerNotOwnerNorApproved();
1407 
1408     /**
1409      * The token does not exist.
1410      */
1411     error ApprovalQueryForNonexistentToken();
1412 
1413     /**
1414      * The caller cannot approve to their own address.
1415      */
1416     error ApproveToCaller();
1417 
1418     /**
1419      * The caller cannot approve to the current owner.
1420      */
1421     error ApprovalToCurrentOwner();
1422 
1423     /**
1424      * Cannot query the balance for the zero address.
1425      */
1426     error BalanceQueryForZeroAddress();
1427 
1428     /**
1429      * Cannot mint to the zero address.
1430      */
1431     error MintToZeroAddress();
1432 
1433     /**
1434      * The quantity of tokens minted must be more than zero.
1435      */
1436     error MintZeroQuantity();
1437 
1438     /**
1439      * The token does not exist.
1440      */
1441     error OwnerQueryForNonexistentToken();
1442 
1443     /**
1444      * The caller must own the token or be an approved operator.
1445      */
1446     error TransferCallerNotOwnerNorApproved();
1447 
1448     /**
1449      * The token must be owned by `from`.
1450      */
1451     error TransferFromIncorrectOwner();
1452 
1453     /**
1454      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1455      */
1456     error TransferToNonERC721ReceiverImplementer();
1457 
1458     /**
1459      * Cannot transfer to the zero address.
1460      */
1461     error TransferToZeroAddress();
1462 
1463     /**
1464      * The token does not exist.
1465      */
1466     error URIQueryForNonexistentToken();
1467 
1468     struct TokenOwnership {
1469         // The address of the owner.
1470         address addr;
1471         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1472         uint64 startTimestamp;
1473         // Whether the token has been burned.
1474         bool burned;
1475     }
1476 
1477     /**
1478      * @dev Returns the total amount of tokens stored by the contract.
1479      *
1480      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1481      */
1482     function totalSupply() external view returns (uint256);
1483 
1484     // ==============================
1485     //            IERC165
1486     // ==============================
1487 
1488     /**
1489      * @dev Returns true if this contract implements the interface defined by
1490      * `interfaceId`. See the corresponding
1491      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1492      * to learn more about how these ids are created.
1493      *
1494      * This function call must use less than 30 000 gas.
1495      */
1496     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1497 
1498     // ==============================
1499     //            IERC721
1500     // ==============================
1501 
1502     /**
1503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1504      */
1505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1506 
1507     /**
1508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1509      */
1510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1511 
1512     /**
1513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1514      */
1515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1516 
1517     /**
1518      * @dev Returns the number of tokens in ``owner``'s account.
1519      */
1520     function balanceOf(address owner) external view returns (uint256 balance);
1521 
1522     /**
1523      * @dev Returns the owner of the `tokenId` token.
1524      *
1525      * Requirements:
1526      *
1527      * - `tokenId` must exist.
1528      */
1529     function ownerOf(uint256 tokenId) external view returns (address owner);
1530 
1531     /**
1532      * @dev Safely transfers `tokenId` token from `from` to `to`.
1533      *
1534      * Requirements:
1535      *
1536      * - `from` cannot be the zero address.
1537      * - `to` cannot be the zero address.
1538      * - `tokenId` token must exist and be owned by `from`.
1539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1541      *
1542      * Emits a {Transfer} event.
1543      */
1544     function safeTransferFrom(
1545         address from,
1546         address to,
1547         uint256 tokenId,
1548         bytes calldata data
1549     ) external;
1550 
1551     /**
1552      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1553      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1554      *
1555      * Requirements:
1556      *
1557      * - `from` cannot be the zero address.
1558      * - `to` cannot be the zero address.
1559      * - `tokenId` token must exist and be owned by `from`.
1560      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function safeTransferFrom(
1566         address from,
1567         address to,
1568         uint256 tokenId
1569     ) external;
1570 
1571     /**
1572      * @dev Transfers `tokenId` token from `from` to `to`.
1573      *
1574      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1575      *
1576      * Requirements:
1577      *
1578      * - `from` cannot be the zero address.
1579      * - `to` cannot be the zero address.
1580      * - `tokenId` token must be owned by `from`.
1581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1582      *
1583      * Emits a {Transfer} event.
1584      */
1585     function transferFrom(
1586         address from,
1587         address to,
1588         uint256 tokenId
1589     ) external;
1590 
1591     /**
1592      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1593      * The approval is cleared when the token is transferred.
1594      *
1595      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1596      *
1597      * Requirements:
1598      *
1599      * - The caller must own the token or be an approved operator.
1600      * - `tokenId` must exist.
1601      *
1602      * Emits an {Approval} event.
1603      */
1604     function approve(address to, uint256 tokenId) external;
1605 
1606     /**
1607      * @dev Approve or remove `operator` as an operator for the caller.
1608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1609      *
1610      * Requirements:
1611      *
1612      * - The `operator` cannot be the caller.
1613      *
1614      * Emits an {ApprovalForAll} event.
1615      */
1616     function setApprovalForAll(address operator, bool _approved) external;
1617 
1618     /**
1619      * @dev Returns the account approved for `tokenId` token.
1620      *
1621      * Requirements:
1622      *
1623      * - `tokenId` must exist.
1624      */
1625     function getApproved(uint256 tokenId) external view returns (address operator);
1626 
1627     /**
1628      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1629      *
1630      * See {setApprovalForAll}
1631      */
1632     function isApprovedForAll(address owner, address operator) external view returns (bool);
1633 
1634     // ==============================
1635     //        IERC721Metadata
1636     // ==============================
1637 
1638     /**
1639      * @dev Returns the token collection name.
1640      */
1641     function name() external view returns (string memory);
1642 
1643     /**
1644      * @dev Returns the token collection symbol.
1645      */
1646     function symbol() external view returns (string memory);
1647 
1648     /**
1649      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1650      */
1651     function tokenURI(uint256 tokenId) external view returns (string memory);
1652 }
1653 
1654 // File: erc721a/contracts/ERC721A.sol
1655 
1656 
1657 // ERC721A Contracts v4.0.0
1658 // Creator: Chiru Labs
1659 
1660 pragma solidity ^0.8.4;
1661 
1662 
1663 /**
1664  * @dev ERC721 token receiver interface.
1665  */
1666 interface ERC721A__IERC721Receiver {
1667     function onERC721Received(
1668         address operator,
1669         address from,
1670         uint256 tokenId,
1671         bytes calldata data
1672     ) external returns (bytes4);
1673 }
1674 
1675 /**
1676  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1677  * the Metadata extension. Built to optimize for lower gas during batch mints.
1678  *
1679  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1680  *
1681  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1682  *
1683  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1684  */
1685 contract ERC721A is IERC721A {
1686     // Mask of an entry in packed address data.
1687     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1688 
1689     // The bit position of `numberMinted` in packed address data.
1690     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1691 
1692     // The bit position of `numberBurned` in packed address data.
1693     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1694 
1695     // The bit position of `aux` in packed address data.
1696     uint256 private constant BITPOS_AUX = 192;
1697 
1698     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1699     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1700 
1701     // The bit position of `startTimestamp` in packed ownership.
1702     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1703 
1704     // The bit mask of the `burned` bit in packed ownership.
1705     uint256 private constant BITMASK_BURNED = 1 << 224;
1706     
1707     // The bit position of the `nextInitialized` bit in packed ownership.
1708     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1709 
1710     // The bit mask of the `nextInitialized` bit in packed ownership.
1711     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1712 
1713     // The tokenId of the next token to be minted.
1714     uint256 private _currentIndex;
1715 
1716     // The number of tokens burned.
1717     uint256 private _burnCounter;
1718 
1719     // Token name
1720     string private _name;
1721 
1722     // Token symbol
1723     string private _symbol;
1724 
1725     // Mapping from token ID to ownership details
1726     // An empty struct value does not necessarily mean the token is unowned.
1727     // See `_packedOwnershipOf` implementation for details.
1728     //
1729     // Bits Layout:
1730     // - [0..159]   `addr`
1731     // - [160..223] `startTimestamp`
1732     // - [224]      `burned`
1733     // - [225]      `nextInitialized`
1734     mapping(uint256 => uint256) private _packedOwnerships;
1735 
1736     // Mapping owner address to address data.
1737     //
1738     // Bits Layout:
1739     // - [0..63]    `balance`
1740     // - [64..127]  `numberMinted`
1741     // - [128..191] `numberBurned`
1742     // - [192..255] `aux`
1743     mapping(address => uint256) private _packedAddressData;
1744 
1745     // Mapping from token ID to approved address.
1746     mapping(uint256 => address) private _tokenApprovals;
1747 
1748     // Mapping from owner to operator approvals
1749     mapping(address => mapping(address => bool)) private _operatorApprovals;
1750 
1751     constructor(string memory name_, string memory symbol_) {
1752         _name = name_;
1753         _symbol = symbol_;
1754         _currentIndex = _startTokenId();
1755     }
1756 
1757     /**
1758      * @dev Returns the starting token ID. 
1759      * To change the starting token ID, please override this function.
1760      */
1761     function _startTokenId() internal view virtual returns (uint256) {
1762         return 0;
1763     }
1764 
1765     /**
1766      * @dev Returns the next token ID to be minted.
1767      */
1768     function _nextTokenId() internal view returns (uint256) {
1769         return _currentIndex;
1770     }
1771 
1772     /**
1773      * @dev Returns the total number of tokens in existence.
1774      * Burned tokens will reduce the count. 
1775      * To get the total number of tokens minted, please see `_totalMinted`.
1776      */
1777     function totalSupply() public view override returns (uint256) {
1778         // Counter underflow is impossible as _burnCounter cannot be incremented
1779         // more than `_currentIndex - _startTokenId()` times.
1780         unchecked {
1781             return _currentIndex - _burnCounter - _startTokenId();
1782         }
1783     }
1784 
1785     /**
1786      * @dev Returns the total amount of tokens minted in the contract.
1787      */
1788     function _totalMinted() internal view returns (uint256) {
1789         // Counter underflow is impossible as _currentIndex does not decrement,
1790         // and it is initialized to `_startTokenId()`
1791         unchecked {
1792             return _currentIndex - _startTokenId();
1793         }
1794     }
1795 
1796     /**
1797      * @dev Returns the total number of tokens burned.
1798      */
1799     function _totalBurned() internal view returns (uint256) {
1800         return _burnCounter;
1801     }
1802 
1803     /**
1804      * @dev See {IERC165-supportsInterface}.
1805      */
1806     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1807         // The interface IDs are constants representing the first 4 bytes of the XOR of
1808         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1809         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1810         return
1811             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1812             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1813             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1814     }
1815 
1816     /**
1817      * @dev See {IERC721-balanceOf}.
1818      */
1819     function balanceOf(address owner) public view override returns (uint256) {
1820         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1821         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1822     }
1823 
1824     /**
1825      * Returns the number of tokens minted by `owner`.
1826      */
1827     function _numberMinted(address owner) internal view returns (uint256) {
1828         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1829     }
1830 
1831     /**
1832      * Returns the number of tokens burned by or on behalf of `owner`.
1833      */
1834     function _numberBurned(address owner) internal view returns (uint256) {
1835         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1836     }
1837 
1838     /**
1839      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1840      */
1841     function _getAux(address owner) internal view returns (uint64) {
1842         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1843     }
1844 
1845     /**
1846      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1847      * If there are multiple variables, please pack them into a uint64.
1848      */
1849     function _setAux(address owner, uint64 aux) internal {
1850         uint256 packed = _packedAddressData[owner];
1851         uint256 auxCasted;
1852         assembly { // Cast aux without masking.
1853             auxCasted := aux
1854         }
1855         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1856         _packedAddressData[owner] = packed;
1857     }
1858 
1859     /**
1860      * Returns the packed ownership data of `tokenId`.
1861      */
1862     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1863         uint256 curr = tokenId;
1864 
1865         unchecked {
1866             if (_startTokenId() <= curr)
1867                 if (curr < _currentIndex) {
1868                     uint256 packed = _packedOwnerships[curr];
1869                     // If not burned.
1870                     if (packed & BITMASK_BURNED == 0) {
1871                         // Invariant:
1872                         // There will always be an ownership that has an address and is not burned
1873                         // before an ownership that does not have an address and is not burned.
1874                         // Hence, curr will not underflow.
1875                         //
1876                         // We can directly compare the packed value.
1877                         // If the address is zero, packed is zero.
1878                         while (packed == 0) {
1879                             packed = _packedOwnerships[--curr];
1880                         }
1881                         return packed;
1882                     }
1883                 }
1884         }
1885         revert OwnerQueryForNonexistentToken();
1886     }
1887 
1888     /**
1889      * Returns the unpacked `TokenOwnership` struct from `packed`.
1890      */
1891     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1892         ownership.addr = address(uint160(packed));
1893         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1894         ownership.burned = packed & BITMASK_BURNED != 0;
1895     }
1896 
1897     /**
1898      * Returns the unpacked `TokenOwnership` struct at `index`.
1899      */
1900     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1901         return _unpackedOwnership(_packedOwnerships[index]);
1902     }
1903 
1904     /**
1905      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1906      */
1907     function _initializeOwnershipAt(uint256 index) internal {
1908         if (_packedOwnerships[index] == 0) {
1909             _packedOwnerships[index] = _packedOwnershipOf(index);
1910         }
1911     }
1912 
1913     /**
1914      * Gas spent here starts off proportional to the maximum mint batch size.
1915      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1916      */
1917     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1918         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1919     }
1920 
1921     /**
1922      * @dev See {IERC721-ownerOf}.
1923      */
1924     function ownerOf(uint256 tokenId) public view override returns (address) {
1925         return address(uint160(_packedOwnershipOf(tokenId)));
1926     }
1927 
1928     /**
1929      * @dev See {IERC721Metadata-name}.
1930      */
1931     function name() public view virtual override returns (string memory) {
1932         return _name;
1933     }
1934 
1935     /**
1936      * @dev See {IERC721Metadata-symbol}.
1937      */
1938     function symbol() public view virtual override returns (string memory) {
1939         return _symbol;
1940     }
1941 
1942     /**
1943      * @dev See {IERC721Metadata-tokenURI}.
1944      */
1945     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1946         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1947 
1948         string memory baseURI = _baseURI();
1949         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1950     }
1951 
1952     /**
1953      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1954      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1955      * by default, can be overriden in child contracts.
1956      */
1957     function _baseURI() internal view virtual returns (string memory) {
1958         return '';
1959     }
1960 
1961     /**
1962      * @dev Casts the address to uint256 without masking.
1963      */
1964     function _addressToUint256(address value) private pure returns (uint256 result) {
1965         assembly {
1966             result := value
1967         }
1968     }
1969 
1970     /**
1971      * @dev Casts the boolean to uint256 without branching.
1972      */
1973     function _boolToUint256(bool value) private pure returns (uint256 result) {
1974         assembly {
1975             result := value
1976         }
1977     }
1978 
1979     /**
1980      * @dev See {IERC721-approve}.
1981      */
1982     function approve(address to, uint256 tokenId) public override {
1983         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1984         if (to == owner) revert ApprovalToCurrentOwner();
1985 
1986         if (_msgSenderERC721A() != owner)
1987             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1988                 revert ApprovalCallerNotOwnerNorApproved();
1989             }
1990 
1991         _tokenApprovals[tokenId] = to;
1992         emit Approval(owner, to, tokenId);
1993     }
1994 
1995     /**
1996      * @dev See {IERC721-getApproved}.
1997      */
1998     function getApproved(uint256 tokenId) public view override returns (address) {
1999         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2000 
2001         return _tokenApprovals[tokenId];
2002     }
2003 
2004     /**
2005      * @dev See {IERC721-setApprovalForAll}.
2006      */
2007     function setApprovalForAll(address operator, bool approved) public virtual override {
2008         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
2009 
2010         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2011         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2012     }
2013 
2014     /**
2015      * @dev See {IERC721-isApprovedForAll}.
2016      */
2017     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2018         return _operatorApprovals[owner][operator];
2019     }
2020 
2021     /**
2022      * @dev See {IERC721-transferFrom}.
2023      */
2024     function transferFrom(
2025         address from,
2026         address to,
2027         uint256 tokenId
2028     ) public virtual override {
2029         _transfer(from, to, tokenId);
2030     }
2031 
2032     /**
2033      * @dev See {IERC721-safeTransferFrom}.
2034      */
2035     function safeTransferFrom(
2036         address from,
2037         address to,
2038         uint256 tokenId
2039     ) public virtual override {
2040         safeTransferFrom(from, to, tokenId, '');
2041     }
2042 
2043     /**
2044      * @dev See {IERC721-safeTransferFrom}.
2045      */
2046     function safeTransferFrom(
2047         address from,
2048         address to,
2049         uint256 tokenId,
2050         bytes memory _data
2051     ) public virtual override {
2052         _transfer(from, to, tokenId);
2053         if (to.code.length != 0)
2054             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2055                 revert TransferToNonERC721ReceiverImplementer();
2056             }
2057     }
2058 
2059     /**
2060      * @dev Returns whether `tokenId` exists.
2061      *
2062      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2063      *
2064      * Tokens start existing when they are minted (`_mint`),
2065      */
2066     function _exists(uint256 tokenId) internal view returns (bool) {
2067         return
2068             _startTokenId() <= tokenId &&
2069             tokenId < _currentIndex && // If within bounds,
2070             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
2071     }
2072 
2073     /**
2074      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2075      */
2076     function _safeMint(address to, uint256 quantity) internal {
2077         _safeMint(to, quantity, '');
2078     }
2079 
2080     /**
2081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2082      *
2083      * Requirements:
2084      *
2085      * - If `to` refers to a smart contract, it must implement
2086      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2087      * - `quantity` must be greater than 0.
2088      *
2089      * Emits a {Transfer} event.
2090      */
2091     function _safeMint(
2092         address to,
2093         uint256 quantity,
2094         bytes memory _data
2095     ) internal {
2096         uint256 startTokenId = _currentIndex;
2097         if (to == address(0)) revert MintToZeroAddress();
2098         if (quantity == 0) revert MintZeroQuantity();
2099 
2100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2101 
2102         // Overflows are incredibly unrealistic.
2103         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2104         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2105         unchecked {
2106             // Updates:
2107             // - `balance += quantity`.
2108             // - `numberMinted += quantity`.
2109             //
2110             // We can directly add to the balance and number minted.
2111             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
2112 
2113             // Updates:
2114             // - `address` to the owner.
2115             // - `startTimestamp` to the timestamp of minting.
2116             // - `burned` to `false`.
2117             // - `nextInitialized` to `quantity == 1`.
2118             _packedOwnerships[startTokenId] =
2119                 _addressToUint256(to) |
2120                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2121                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
2122 
2123             uint256 updatedIndex = startTokenId;
2124             uint256 end = updatedIndex + quantity;
2125 
2126             if (to.code.length != 0) {
2127                 do {
2128                     emit Transfer(address(0), to, updatedIndex);
2129                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2130                         revert TransferToNonERC721ReceiverImplementer();
2131                     }
2132                 } while (updatedIndex < end);
2133                 // Reentrancy protection
2134                 if (_currentIndex != startTokenId) revert();
2135             } else {
2136                 do {
2137                     emit Transfer(address(0), to, updatedIndex++);
2138                 } while (updatedIndex < end);
2139             }
2140             _currentIndex = updatedIndex;
2141         }
2142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2143     }
2144 
2145     /**
2146      * @dev Mints `quantity` tokens and transfers them to `to`.
2147      *
2148      * Requirements:
2149      *
2150      * - `to` cannot be the zero address.
2151      * - `quantity` must be greater than 0.
2152      *
2153      * Emits a {Transfer} event.
2154      */
2155     function _mint(address to, uint256 quantity) internal {
2156         uint256 startTokenId = _currentIndex;
2157         if (to == address(0)) revert MintToZeroAddress();
2158         if (quantity == 0) revert MintZeroQuantity();
2159 
2160         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2161 
2162         // Overflows are incredibly unrealistic.
2163         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2164         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2165         unchecked {
2166             // Updates:
2167             // - `balance += quantity`.
2168             // - `numberMinted += quantity`.
2169             //
2170             // We can directly add to the balance and number minted.
2171             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
2172 
2173             // Updates:
2174             // - `address` to the owner.
2175             // - `startTimestamp` to the timestamp of minting.
2176             // - `burned` to `false`.
2177             // - `nextInitialized` to `quantity == 1`.
2178             _packedOwnerships[startTokenId] =
2179                 _addressToUint256(to) |
2180                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2181                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
2182 
2183             uint256 updatedIndex = startTokenId;
2184             uint256 end = updatedIndex + quantity;
2185 
2186             do {
2187                 emit Transfer(address(0), to, updatedIndex++);
2188             } while (updatedIndex < end);
2189 
2190             _currentIndex = updatedIndex;
2191         }
2192         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2193     }
2194 
2195     /**
2196      * @dev Transfers `tokenId` from `from` to `to`.
2197      *
2198      * Requirements:
2199      *
2200      * - `to` cannot be the zero address.
2201      * - `tokenId` token must be owned by `from`.
2202      *
2203      * Emits a {Transfer} event.
2204      */
2205     function _transfer(
2206         address from,
2207         address to,
2208         uint256 tokenId
2209     ) private {
2210         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2211 
2212         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2213 
2214         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
2215             isApprovedForAll(from, _msgSenderERC721A()) ||
2216             getApproved(tokenId) == _msgSenderERC721A());
2217 
2218         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2219         if (to == address(0)) revert TransferToZeroAddress();
2220 
2221         _beforeTokenTransfers(from, to, tokenId, 1);
2222 
2223         // Clear approvals from the previous owner.
2224         delete _tokenApprovals[tokenId];
2225 
2226         // Underflow of the sender's balance is impossible because we check for
2227         // ownership above and the recipient's balance can't realistically overflow.
2228         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2229         unchecked {
2230             // We can directly increment and decrement the balances.
2231             --_packedAddressData[from]; // Updates: `balance -= 1`.
2232             ++_packedAddressData[to]; // Updates: `balance += 1`.
2233 
2234             // Updates:
2235             // - `address` to the next owner.
2236             // - `startTimestamp` to the timestamp of transfering.
2237             // - `burned` to `false`.
2238             // - `nextInitialized` to `true`.
2239             _packedOwnerships[tokenId] =
2240                 _addressToUint256(to) |
2241                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2242                 BITMASK_NEXT_INITIALIZED;
2243 
2244             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2245             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2246                 uint256 nextTokenId = tokenId + 1;
2247                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2248                 if (_packedOwnerships[nextTokenId] == 0) {
2249                     // If the next slot is within bounds.
2250                     if (nextTokenId != _currentIndex) {
2251                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2252                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2253                     }
2254                 }
2255             }
2256         }
2257 
2258         emit Transfer(from, to, tokenId);
2259         _afterTokenTransfers(from, to, tokenId, 1);
2260     }
2261 
2262     /**
2263      * @dev Equivalent to `_burn(tokenId, false)`.
2264      */
2265     function _burn(uint256 tokenId) internal virtual {
2266         _burn(tokenId, false);
2267     }
2268 
2269     /**
2270      * @dev Destroys `tokenId`.
2271      * The approval is cleared when the token is burned.
2272      *
2273      * Requirements:
2274      *
2275      * - `tokenId` must exist.
2276      *
2277      * Emits a {Transfer} event.
2278      */
2279     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2280         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2281 
2282         address from = address(uint160(prevOwnershipPacked));
2283 
2284         if (approvalCheck) {
2285             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
2286                 isApprovedForAll(from, _msgSenderERC721A()) ||
2287                 getApproved(tokenId) == _msgSenderERC721A());
2288 
2289             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2290         }
2291 
2292         _beforeTokenTransfers(from, address(0), tokenId, 1);
2293 
2294         // Clear approvals from the previous owner.
2295         delete _tokenApprovals[tokenId];
2296 
2297         // Underflow of the sender's balance is impossible because we check for
2298         // ownership above and the recipient's balance can't realistically overflow.
2299         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2300         unchecked {
2301             // Updates:
2302             // - `balance -= 1`.
2303             // - `numberBurned += 1`.
2304             //
2305             // We can directly decrement the balance, and increment the number burned.
2306             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
2307             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
2308 
2309             // Updates:
2310             // - `address` to the last owner.
2311             // - `startTimestamp` to the timestamp of burning.
2312             // - `burned` to `true`.
2313             // - `nextInitialized` to `true`.
2314             _packedOwnerships[tokenId] =
2315                 _addressToUint256(from) |
2316                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2317                 BITMASK_BURNED | 
2318                 BITMASK_NEXT_INITIALIZED;
2319 
2320             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2321             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2322                 uint256 nextTokenId = tokenId + 1;
2323                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2324                 if (_packedOwnerships[nextTokenId] == 0) {
2325                     // If the next slot is within bounds.
2326                     if (nextTokenId != _currentIndex) {
2327                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2328                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2329                     }
2330                 }
2331             }
2332         }
2333 
2334         emit Transfer(from, address(0), tokenId);
2335         _afterTokenTransfers(from, address(0), tokenId, 1);
2336 
2337         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2338         unchecked {
2339             _burnCounter++;
2340         }
2341     }
2342 
2343     /**
2344      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2345      *
2346      * @param from address representing the previous owner of the given token ID
2347      * @param to target address that will receive the tokens
2348      * @param tokenId uint256 ID of the token to be transferred
2349      * @param _data bytes optional data to send along with the call
2350      * @return bool whether the call correctly returned the expected magic value
2351      */
2352     function _checkContractOnERC721Received(
2353         address from,
2354         address to,
2355         uint256 tokenId,
2356         bytes memory _data
2357     ) private returns (bool) {
2358         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2359             bytes4 retval
2360         ) {
2361             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2362         } catch (bytes memory reason) {
2363             if (reason.length == 0) {
2364                 revert TransferToNonERC721ReceiverImplementer();
2365             } else {
2366                 assembly {
2367                     revert(add(32, reason), mload(reason))
2368                 }
2369             }
2370         }
2371     }
2372 
2373     /**
2374      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2375      * And also called before burning one token.
2376      *
2377      * startTokenId - the first token id to be transferred
2378      * quantity - the amount to be transferred
2379      *
2380      * Calling conditions:
2381      *
2382      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2383      * transferred to `to`.
2384      * - When `from` is zero, `tokenId` will be minted for `to`.
2385      * - When `to` is zero, `tokenId` will be burned by `from`.
2386      * - `from` and `to` are never both zero.
2387      */
2388     function _beforeTokenTransfers(
2389         address from,
2390         address to,
2391         uint256 startTokenId,
2392         uint256 quantity
2393     ) internal virtual {}
2394 
2395     /**
2396      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2397      * minting.
2398      * And also called after one token has been burned.
2399      *
2400      * startTokenId - the first token id to be transferred
2401      * quantity - the amount to be transferred
2402      *
2403      * Calling conditions:
2404      *
2405      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2406      * transferred to `to`.
2407      * - When `from` is zero, `tokenId` has been minted for `to`.
2408      * - When `to` is zero, `tokenId` has been burned by `from`.
2409      * - `from` and `to` are never both zero.
2410      */
2411     function _afterTokenTransfers(
2412         address from,
2413         address to,
2414         uint256 startTokenId,
2415         uint256 quantity
2416     ) internal virtual {}
2417 
2418     /**
2419      * @dev Returns the message sender (defaults to `msg.sender`).
2420      *
2421      * If you are writing GSN compatible contracts, you need to override this function.
2422      */
2423     function _msgSenderERC721A() internal view virtual returns (address) {
2424         return msg.sender;
2425     }
2426 
2427     /**
2428      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2429      */
2430     function _toString(uint256 value) internal pure returns (string memory ptr) {
2431         assembly {
2432             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
2433             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2434             // We will need 1 32-byte word to store the length, 
2435             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2436             ptr := add(mload(0x40), 128)
2437             // Update the free memory pointer to allocate.
2438             mstore(0x40, ptr)
2439 
2440             // Cache the end of the memory to calculate the length later.
2441             let end := ptr
2442 
2443             // We write the string from the rightmost digit to the leftmost digit.
2444             // The following is essentially a do-while loop that also handles the zero case.
2445             // Costs a bit more than early returning for the zero case,
2446             // but cheaper in terms of deployment and overall runtime costs.
2447             for { 
2448                 // Initialize and perform the first pass without check.
2449                 let temp := value
2450                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2451                 ptr := sub(ptr, 1)
2452                 // Write the character to the pointer. 48 is the ASCII index of '0'.
2453                 mstore8(ptr, add(48, mod(temp, 10)))
2454                 temp := div(temp, 10)
2455             } temp { 
2456                 // Keep dividing `temp` until zero.
2457                 temp := div(temp, 10)
2458             } { // Body of the for loop.
2459                 ptr := sub(ptr, 1)
2460                 mstore8(ptr, add(48, mod(temp, 10)))
2461             }
2462             
2463             let length := sub(end, ptr)
2464             // Move the pointer 32 bytes leftwards to make room for the length.
2465             ptr := sub(ptr, 32)
2466             // Store the length.
2467             mstore(ptr, length)
2468         }
2469     }
2470 }
2471 
2472 // File: contracts/220609.sol
2473 
2474 
2475 pragma solidity ^0.8.0;
2476 
2477 
2478 
2479 
2480 
2481 
2482 
2483 contract Soul is ERC721A, Ownable {
2484 
2485     using Counters for Counters.Counter;
2486     Counters.Counter private _tokenIdCounter;
2487 
2488     uint256 public _maxTokenSupply;
2489 	
2490     uint256 public _superMintPrice = 0.07 ether;
2491 	uint256 public _mintPrice = 0.0099 ether;
2492 	
2493 	bool 	public _saleIsActive = false;
2494     bool 	public _superSaleIsActive = false;
2495 	bool 	public _freeMintIsActive = false;
2496 
2497     uint256 public _maxNumMintPerTransact = 10;
2498     uint256 public _maxNumSuperMintPerTransact = 10;
2499 	uint256 public _maxNumFreeMintMintPerTransact = 5;
2500 	
2501     uint256 public _freeMintCount = 0;
2502     uint256 public _freeMintMax = 3000;
2503 	uint256 public _maxNumFreeMint = 5;
2504     uint256 public _mintCount = 0;
2505     uint256 public _mintMax = 2000;
2506     uint256 public _superMintCount = 0;
2507     uint256 public _superMintMax = 1000;
2508 
2509     string 	public baseURI;
2510 	
2511 	mapping (address => uint256) private _freeMintNumbers;
2512 	
2513     /*for log*/
2514     event PaymentReleased(address to, uint256 amount);
2515     
2516     /*constructor*/
2517     constructor(string memory name, string memory symbol, uint256 maxTokenSupply) ERC721A(name, symbol) {
2518         _maxTokenSupply = maxTokenSupply;        
2519     }
2520 
2521     function setMintPrice(uint256 newPrice) public onlyOwner {
2522         _mintPrice = newPrice;
2523     }
2524 	
2525 	function setSuperMintPrice(uint256 newPrice) public onlyOwner {
2526         _superMintPrice = newPrice;
2527     }
2528 	
2529 	function setMaxNumMintPerTransact(uint256 newMaxNumMintPerTransact) public onlyOwner {
2530         _maxNumMintPerTransact = newMaxNumMintPerTransact;
2531     }
2532 
2533 	function setMaxNumSuperMintPerTransact(uint256 newMaxNumSuperMintPerTransact) public onlyOwner {
2534         _maxNumSuperMintPerTransact = newMaxNumSuperMintPerTransact;
2535     }
2536 
2537 	function setMaxNumFreeMintPerTransact(uint256 newMaxNumFreeMintPerTransact) public onlyOwner {
2538         _maxNumFreeMintMintPerTransact = newMaxNumFreeMintPerTransact;
2539     }
2540 	
2541 	function setFreeMintMax(uint256 newFreeMintMax) public onlyOwner {
2542         _freeMintMax = newFreeMintMax;
2543     }
2544 	
2545 	function setMaxNumFreeMint(uint256 newFreeMintMaxNumber) public onlyOwner {
2546         _maxNumFreeMint = newFreeMintMaxNumber;
2547     }
2548 	
2549 	function setMintMax(uint256 newMintMax) public onlyOwner {
2550         _mintMax = newMintMax;
2551     }
2552 
2553     function setSuperMintMax(uint256 newSuperMintMax) public onlyOwner {
2554         _superMintMax = newSuperMintMax;
2555     }
2556 
2557 	function setBaseURI(string memory newBaseURI) public onlyOwner {
2558         baseURI = newBaseURI;
2559     }
2560 	
2561     function withdraw(uint256 amount, address payable to) public onlyOwner {
2562         require(address(this).balance >= amount, "Insufficient balance");
2563         Address.sendValue(to, amount);
2564         emit PaymentReleased(to, amount);
2565     }
2566 
2567     function reserveMint(uint256 reservedAmount, address mintAddress) public onlyOwner {                
2568         require(totalSupply() + reservedAmount <= _maxTokenSupply, "Purchase would exceed max available NFTs");
2569         _safeMint(mintAddress, reservedAmount);
2570     }
2571 
2572     function flipSaleState() public onlyOwner {
2573         _saleIsActive = !(_saleIsActive);
2574     }
2575 
2576     function flipSuperSaleState() public onlyOwner {
2577         _superSaleIsActive = !(_superSaleIsActive);
2578     }
2579 
2580     function flipFreeMintState() public onlyOwner {
2581         _freeMintIsActive = !(_freeMintIsActive);
2582     }        
2583 
2584     /*public call*/
2585     function freeMint(uint256 numberOfTokens) public payable {
2586         require(_freeMintIsActive, "Free mint is not live yet");
2587         require(numberOfTokens <= _maxNumFreeMintMintPerTransact, "Over a max of NFTs at a time");
2588 		require(totalSupply() + numberOfTokens <= _maxTokenSupply, "Purchase would exceed max available NFTs");
2589         require(_freeMintCount + numberOfTokens <= _freeMintMax, "Free mint is sold out");
2590 		require(_freeMintNumbers[msg.sender] + numberOfTokens <= _maxNumFreeMint , "You over maximum number of free mint");
2591 		
2592 		_freeMintNumbers[msg.sender] = _freeMintNumbers[msg.sender] + numberOfTokens;
2593 		
2594         _freeMintCount = _freeMintCount + numberOfTokens;
2595         _safeMint(msg.sender, numberOfTokens);        
2596     }
2597 	
2598     function mint(uint256 numberOfTokens) public payable {
2599         require(_saleIsActive, "Sale is not live yet");
2600         require(numberOfTokens <= _maxNumMintPerTransact, "Over a max of NFTs at a time");
2601 		require(totalSupply() + numberOfTokens <= _maxTokenSupply, "Purchase would exceed max available NFTs");
2602         require(_mintCount + numberOfTokens <= _mintMax, "Mint is sold out");
2603         require(_mintPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
2604 
2605         _mintCount = _mintCount + numberOfTokens;
2606         _safeMint(msg.sender, numberOfTokens);
2607     }
2608 
2609     function superMint(uint256 numberOfTokens) public payable {
2610         require(_superSaleIsActive, "Super Sale is not live yet");
2611         require(numberOfTokens <= _maxNumSuperMintPerTransact, "Over a max of NFTs at a time");
2612 		require(totalSupply() + numberOfTokens <= _maxTokenSupply, "Purchase would exceed max available NFTs");
2613         require(_superMintCount + numberOfTokens <= _superMintMax, "Super Mint is sold out");
2614         require(_superMintPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
2615         
2616         _superMintCount = _superMintCount + numberOfTokens;
2617         _safeMint(msg.sender, numberOfTokens);
2618     }
2619 
2620     function _baseURI() internal view virtual override returns (string memory) {
2621         return baseURI;
2622     }
2623 }