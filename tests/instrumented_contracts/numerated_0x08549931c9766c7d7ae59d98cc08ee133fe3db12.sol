1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60     uint8 private constant _ADDRESS_LENGTH = 20;
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
117 
118     /**
119      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
120      */
121     function toHexString(address addr) internal pure returns (string memory) {
122         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
127 
128 
129 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 
134 /**
135  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
136  *
137  * These functions can be used to verify that a message was signed by the holder
138  * of the private keys of a given address.
139  */
140 library ECDSA {
141     enum RecoverError {
142         NoError,
143         InvalidSignature,
144         InvalidSignatureLength,
145         InvalidSignatureS,
146         InvalidSignatureV
147     }
148 
149     function _throwError(RecoverError error) private pure {
150         if (error == RecoverError.NoError) {
151             return; // no error: do nothing
152         } else if (error == RecoverError.InvalidSignature) {
153             revert("ECDSA: invalid signature");
154         } else if (error == RecoverError.InvalidSignatureLength) {
155             revert("ECDSA: invalid signature length");
156         } else if (error == RecoverError.InvalidSignatureS) {
157             revert("ECDSA: invalid signature 's' value");
158         } else if (error == RecoverError.InvalidSignatureV) {
159             revert("ECDSA: invalid signature 'v' value");
160         }
161     }
162 
163     /**
164      * @dev Returns the address that signed a hashed message (`hash`) with
165      * `signature` or error string. This address can then be used for verification purposes.
166      *
167      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
168      * this function rejects them by requiring the `s` value to be in the lower
169      * half order, and the `v` value to be either 27 or 28.
170      *
171      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
172      * verification to be secure: it is possible to craft signatures that
173      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
174      * this is by receiving a hash of the original message (which may otherwise
175      * be too long), and then calling {toEthSignedMessageHash} on it.
176      *
177      * Documentation for signature generation:
178      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
179      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
180      *
181      * _Available since v4.3._
182      */
183     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
184         if (signature.length == 65) {
185             bytes32 r;
186             bytes32 s;
187             uint8 v;
188             // ecrecover takes the signature parameters, and the only way to get them
189             // currently is to use assembly.
190             /// @solidity memory-safe-assembly
191             assembly {
192                 r := mload(add(signature, 0x20))
193                 s := mload(add(signature, 0x40))
194                 v := byte(0, mload(add(signature, 0x60)))
195             }
196             return tryRecover(hash, v, r, s);
197         } else {
198             return (address(0), RecoverError.InvalidSignatureLength);
199         }
200     }
201 
202     /**
203      * @dev Returns the address that signed a hashed message (`hash`) with
204      * `signature`. This address can then be used for verification purposes.
205      *
206      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
207      * this function rejects them by requiring the `s` value to be in the lower
208      * half order, and the `v` value to be either 27 or 28.
209      *
210      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
211      * verification to be secure: it is possible to craft signatures that
212      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
213      * this is by receiving a hash of the original message (which may otherwise
214      * be too long), and then calling {toEthSignedMessageHash} on it.
215      */
216     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
217         (address recovered, RecoverError error) = tryRecover(hash, signature);
218         _throwError(error);
219         return recovered;
220     }
221 
222     /**
223      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
224      *
225      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
226      *
227      * _Available since v4.3._
228      */
229     function tryRecover(
230         bytes32 hash,
231         bytes32 r,
232         bytes32 vs
233     ) internal pure returns (address, RecoverError) {
234         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
235         uint8 v = uint8((uint256(vs) >> 255) + 27);
236         return tryRecover(hash, v, r, s);
237     }
238 
239     /**
240      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
241      *
242      * _Available since v4.2._
243      */
244     function recover(
245         bytes32 hash,
246         bytes32 r,
247         bytes32 vs
248     ) internal pure returns (address) {
249         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
250         _throwError(error);
251         return recovered;
252     }
253 
254     /**
255      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
256      * `r` and `s` signature fields separately.
257      *
258      * _Available since v4.3._
259      */
260     function tryRecover(
261         bytes32 hash,
262         uint8 v,
263         bytes32 r,
264         bytes32 s
265     ) internal pure returns (address, RecoverError) {
266         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
267         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
268         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
269         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
270         //
271         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
272         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
273         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
274         // these malleable signatures as well.
275         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
276             return (address(0), RecoverError.InvalidSignatureS);
277         }
278         if (v != 27 && v != 28) {
279             return (address(0), RecoverError.InvalidSignatureV);
280         }
281 
282         // If the signature is valid (and not malleable), return the signer address
283         address signer = ecrecover(hash, v, r, s);
284         if (signer == address(0)) {
285             return (address(0), RecoverError.InvalidSignature);
286         }
287 
288         return (signer, RecoverError.NoError);
289     }
290 
291     /**
292      * @dev Overload of {ECDSA-recover} that receives the `v`,
293      * `r` and `s` signature fields separately.
294      */
295     function recover(
296         bytes32 hash,
297         uint8 v,
298         bytes32 r,
299         bytes32 s
300     ) internal pure returns (address) {
301         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
302         _throwError(error);
303         return recovered;
304     }
305 
306     /**
307      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
308      * produces hash corresponding to the one signed with the
309      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
310      * JSON-RPC method as part of EIP-191.
311      *
312      * See {recover}.
313      */
314     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
315         // 32 is the length in bytes of hash,
316         // enforced by the type signature above
317         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
318     }
319 
320     /**
321      * @dev Returns an Ethereum Signed Message, created from `s`. This
322      * produces hash corresponding to the one signed with the
323      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
324      * JSON-RPC method as part of EIP-191.
325      *
326      * See {recover}.
327      */
328     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
329         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
330     }
331 
332     /**
333      * @dev Returns an Ethereum Signed Typed Data, created from a
334      * `domainSeparator` and a `structHash`. This produces hash corresponding
335      * to the one signed with the
336      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
337      * JSON-RPC method as part of EIP-712.
338      *
339      * See {recover}.
340      */
341     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
342         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
343     }
344 }
345 
346 // File: @openzeppelin/contracts/utils/Context.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Provides information about the current execution context, including the
355  * sender of the transaction and its data. While these are generally available
356  * via msg.sender and msg.data, they should not be accessed in such a direct
357  * manner, since when dealing with meta-transactions the account sending and
358  * paying for execution may not be the actual sender (as far as an application
359  * is concerned).
360  *
361  * This contract is only required for intermediate, library-like contracts.
362  */
363 abstract contract Context {
364     function _msgSender() internal view virtual returns (address) {
365         return msg.sender;
366     }
367 
368     function _msgData() internal view virtual returns (bytes calldata) {
369         return msg.data;
370     }
371 }
372 
373 // File: @openzeppelin/contracts/access/Ownable.sol
374 
375 
376 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
377 
378 pragma solidity ^0.8.0;
379 
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
406      * @dev Throws if called by any account other than the owner.
407      */
408     modifier onlyOwner() {
409         _checkOwner();
410         _;
411     }
412 
413     /**
414      * @dev Returns the address of the current owner.
415      */
416     function owner() public view virtual returns (address) {
417         return _owner;
418     }
419 
420     /**
421      * @dev Throws if the sender is not the owner.
422      */
423     function _checkOwner() internal view virtual {
424         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
461 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
462 
463 pragma solidity ^0.8.1;
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
485      *
486      * [IMPORTANT]
487      * ====
488      * You shouldn't rely on `isContract` to protect against flash loan attacks!
489      *
490      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
491      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
492      * constructor.
493      * ====
494      */
495     function isContract(address account) internal view returns (bool) {
496         // This method relies on extcodesize/address.code.length, which returns 0
497         // for contracts in construction, since the code is only stored at the end
498         // of the constructor execution.
499 
500         return account.code.length > 0;
501     }
502 
503     /**
504      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
505      * `recipient`, forwarding all available gas and reverting on errors.
506      *
507      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
508      * of certain opcodes, possibly making contracts go over the 2300 gas limit
509      * imposed by `transfer`, making them unable to receive funds via
510      * `transfer`. {sendValue} removes this limitation.
511      *
512      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
513      *
514      * IMPORTANT: because control is transferred to `recipient`, care must be
515      * taken to not create reentrancy vulnerabilities. Consider using
516      * {ReentrancyGuard} or the
517      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
518      */
519     function sendValue(address payable recipient, uint256 amount) internal {
520         require(address(this).balance >= amount, "Address: insufficient balance");
521 
522         (bool success, ) = recipient.call{value: amount}("");
523         require(success, "Address: unable to send value, recipient may have reverted");
524     }
525 
526     /**
527      * @dev Performs a Solidity function call using a low level `call`. A
528      * plain `call` is an unsafe replacement for a function call: use this
529      * function instead.
530      *
531      * If `target` reverts with a revert reason, it is bubbled up by this
532      * function (like regular Solidity function calls).
533      *
534      * Returns the raw returned data. To convert to the expected return value,
535      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
536      *
537      * Requirements:
538      *
539      * - `target` must be a contract.
540      * - calling `target` with `data` must not revert.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
545         return functionCall(target, data, "Address: low-level call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
550      * `errorMessage` as a fallback revert reason when `target` reverts.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, 0, errorMessage);
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
564      * but also transferring `value` wei to `target`.
565      *
566      * Requirements:
567      *
568      * - the calling contract must have an ETH balance of at least `value`.
569      * - the called Solidity function must be `payable`.
570      *
571      * _Available since v3.1._
572      */
573     function functionCallWithValue(
574         address target,
575         bytes memory data,
576         uint256 value
577     ) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
583      * with `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(address(this).balance >= value, "Address: insufficient balance for call");
594         require(isContract(target), "Address: call to non-contract");
595 
596         (bool success, bytes memory returndata) = target.call{value: value}(data);
597         return verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
607         return functionStaticCall(target, data, "Address: low-level static call failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
612      * but performing a static call.
613      *
614      * _Available since v3.3._
615      */
616     function functionStaticCall(
617         address target,
618         bytes memory data,
619         string memory errorMessage
620     ) internal view returns (bytes memory) {
621         require(isContract(target), "Address: static call to non-contract");
622 
623         (bool success, bytes memory returndata) = target.staticcall(data);
624         return verifyCallResult(success, returndata, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
634         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
639      * but performing a delegate call.
640      *
641      * _Available since v3.4._
642      */
643     function functionDelegateCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal returns (bytes memory) {
648         require(isContract(target), "Address: delegate call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.delegatecall(data);
651         return verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
656      * revert reason using the provided one.
657      *
658      * _Available since v4.3._
659      */
660     function verifyCallResult(
661         bool success,
662         bytes memory returndata,
663         string memory errorMessage
664     ) internal pure returns (bytes memory) {
665         if (success) {
666             return returndata;
667         } else {
668             // Look for revert reason and bubble it up if present
669             if (returndata.length > 0) {
670                 // The easiest way to bubble the revert reason is using memory via assembly
671                 /// @solidity memory-safe-assembly
672                 assembly {
673                     let returndata_size := mload(returndata)
674                     revert(add(32, returndata), returndata_size)
675                 }
676             } else {
677                 revert(errorMessage);
678             }
679         }
680     }
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
684 
685 
686 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @title ERC721 token receiver interface
692  * @dev Interface for any contract that wants to support safeTransfers
693  * from ERC721 asset contracts.
694  */
695 interface IERC721Receiver {
696     /**
697      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
698      * by `operator` from `from`, this function is called.
699      *
700      * It must return its Solidity selector to confirm the token transfer.
701      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
702      *
703      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
704      */
705     function onERC721Received(
706         address operator,
707         address from,
708         uint256 tokenId,
709         bytes calldata data
710     ) external returns (bytes4);
711 }
712 
713 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @dev Interface of the ERC165 standard, as defined in the
722  * https://eips.ethereum.org/EIPS/eip-165[EIP].
723  *
724  * Implementers can declare support of contract interfaces, which can then be
725  * queried by others ({ERC165Checker}).
726  *
727  * For an implementation, see {ERC165}.
728  */
729 interface IERC165 {
730     /**
731      * @dev Returns true if this contract implements the interface defined by
732      * `interfaceId`. See the corresponding
733      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
734      * to learn more about how these ids are created.
735      *
736      * This function call must use less than 30 000 gas.
737      */
738     function supportsInterface(bytes4 interfaceId) external view returns (bool);
739 }
740 
741 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
742 
743 
744 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
745 
746 pragma solidity ^0.8.0;
747 
748 
749 /**
750  * @dev Implementation of the {IERC165} interface.
751  *
752  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
753  * for the additional interface id that will be supported. For example:
754  *
755  * ```solidity
756  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
757  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
758  * }
759  * ```
760  *
761  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
762  */
763 abstract contract ERC165 is IERC165 {
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
768         return interfaceId == type(IERC165).interfaceId;
769     }
770 }
771 
772 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
773 
774 
775 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
776 
777 pragma solidity ^0.8.0;
778 
779 
780 /**
781  * @dev Required interface of an ERC721 compliant contract.
782  */
783 interface IERC721 is IERC165 {
784     /**
785      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
786      */
787     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
788 
789     /**
790      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
791      */
792     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
793 
794     /**
795      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
796      */
797     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
798 
799     /**
800      * @dev Returns the number of tokens in ``owner``'s account.
801      */
802     function balanceOf(address owner) external view returns (uint256 balance);
803 
804     /**
805      * @dev Returns the owner of the `tokenId` token.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function ownerOf(uint256 tokenId) external view returns (address owner);
812 
813     /**
814      * @dev Safely transfers `tokenId` token from `from` to `to`.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must exist and be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
823      *
824      * Emits a {Transfer} event.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes calldata data
831     ) external;
832 
833     /**
834      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
835      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
836      *
837      * Requirements:
838      *
839      * - `from` cannot be the zero address.
840      * - `to` cannot be the zero address.
841      * - `tokenId` token must exist and be owned by `from`.
842      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
843      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
844      *
845      * Emits a {Transfer} event.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) external;
852 
853     /**
854      * @dev Transfers `tokenId` token from `from` to `to`.
855      *
856      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must be owned by `from`.
863      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
864      *
865      * Emits a {Transfer} event.
866      */
867     function transferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) external;
872 
873     /**
874      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
875      * The approval is cleared when the token is transferred.
876      *
877      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
878      *
879      * Requirements:
880      *
881      * - The caller must own the token or be an approved operator.
882      * - `tokenId` must exist.
883      *
884      * Emits an {Approval} event.
885      */
886     function approve(address to, uint256 tokenId) external;
887 
888     /**
889      * @dev Approve or remove `operator` as an operator for the caller.
890      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
891      *
892      * Requirements:
893      *
894      * - The `operator` cannot be the caller.
895      *
896      * Emits an {ApprovalForAll} event.
897      */
898     function setApprovalForAll(address operator, bool _approved) external;
899 
900     /**
901      * @dev Returns the account approved for `tokenId` token.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      */
907     function getApproved(uint256 tokenId) external view returns (address operator);
908 
909     /**
910      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
911      *
912      * See {setApprovalForAll}
913      */
914     function isApprovedForAll(address owner, address operator) external view returns (bool);
915 }
916 
917 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
918 
919 
920 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
921 
922 pragma solidity ^0.8.0;
923 
924 
925 /**
926  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
927  * @dev See https://eips.ethereum.org/EIPS/eip-721
928  */
929 interface IERC721Metadata is IERC721 {
930     /**
931      * @dev Returns the token collection name.
932      */
933     function name() external view returns (string memory);
934 
935     /**
936      * @dev Returns the token collection symbol.
937      */
938     function symbol() external view returns (string memory);
939 
940     /**
941      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
942      */
943     function tokenURI(uint256 tokenId) external view returns (string memory);
944 }
945 
946 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
947 
948 
949 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
950 
951 pragma solidity ^0.8.0;
952 
953 
954 
955 
956 
957 
958 
959 
960 /**
961  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
962  * the Metadata extension, but not including the Enumerable extension, which is available separately as
963  * {ERC721Enumerable}.
964  */
965 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
966     using Address for address;
967     using Strings for uint256;
968 
969     // Token name
970     string private _name;
971 
972     // Token symbol
973     string private _symbol;
974 
975     // Mapping from token ID to owner address
976     mapping(uint256 => address) private _owners;
977 
978     // Mapping owner address to token count
979     mapping(address => uint256) private _balances;
980 
981     // Mapping from token ID to approved address
982     mapping(uint256 => address) private _tokenApprovals;
983 
984     // Mapping from owner to operator approvals
985     mapping(address => mapping(address => bool)) private _operatorApprovals;
986 
987     /**
988      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
989      */
990     constructor(string memory name_, string memory symbol_) {
991         _name = name_;
992         _symbol = symbol_;
993     }
994 
995     /**
996      * @dev See {IERC165-supportsInterface}.
997      */
998     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
999         return
1000             interfaceId == type(IERC721).interfaceId ||
1001             interfaceId == type(IERC721Metadata).interfaceId ||
1002             super.supportsInterface(interfaceId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-balanceOf}.
1007      */
1008     function balanceOf(address owner) public view virtual override returns (uint256) {
1009         require(owner != address(0), "ERC721: address zero is not a valid owner");
1010         return _balances[owner];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-ownerOf}.
1015      */
1016     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1017         address owner = _owners[tokenId];
1018         require(owner != address(0), "ERC721: invalid token ID");
1019         return owner;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-name}.
1024      */
1025     function name() public view virtual override returns (string memory) {
1026         return _name;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-symbol}.
1031      */
1032     function symbol() public view virtual override returns (string memory) {
1033         return _symbol;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-tokenURI}.
1038      */
1039     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1040         _requireMinted(tokenId);
1041 
1042         string memory baseURI = _baseURI();
1043         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1044     }
1045 
1046     /**
1047      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1048      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1049      * by default, can be overridden in child contracts.
1050      */
1051     function _baseURI() internal view virtual returns (string memory) {
1052         return "";
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-approve}.
1057      */
1058     function approve(address to, uint256 tokenId) public virtual override {
1059         address owner = ERC721.ownerOf(tokenId);
1060         require(to != owner, "ERC721: approval to current owner");
1061 
1062         require(
1063             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1064             "ERC721: approve caller is not token owner nor approved for all"
1065         );
1066 
1067         _approve(to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-getApproved}.
1072      */
1073     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1074         _requireMinted(tokenId);
1075 
1076         return _tokenApprovals[tokenId];
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-setApprovalForAll}.
1081      */
1082     function setApprovalForAll(address operator, bool approved) public virtual override {
1083         _setApprovalForAll(_msgSender(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-isApprovedForAll}.
1088      */
1089     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1090         return _operatorApprovals[owner][operator];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-transferFrom}.
1095      */
1096     function transferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) public virtual override {
1101         //solhint-disable-next-line max-line-length
1102         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1103 
1104         _transfer(from, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-safeTransferFrom}.
1109      */
1110     function safeTransferFrom(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) public virtual override {
1115         safeTransferFrom(from, to, tokenId, "");
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-safeTransferFrom}.
1120      */
1121     function safeTransferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory data
1126     ) public virtual override {
1127         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1128         _safeTransfer(from, to, tokenId, data);
1129     }
1130 
1131     /**
1132      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1133      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1134      *
1135      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1136      *
1137      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1138      * implement alternative mechanisms to perform token transfer, such as signature-based.
1139      *
1140      * Requirements:
1141      *
1142      * - `from` cannot be the zero address.
1143      * - `to` cannot be the zero address.
1144      * - `tokenId` token must exist and be owned by `from`.
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _safeTransfer(
1150         address from,
1151         address to,
1152         uint256 tokenId,
1153         bytes memory data
1154     ) internal virtual {
1155         _transfer(from, to, tokenId);
1156         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1157     }
1158 
1159     /**
1160      * @dev Returns whether `tokenId` exists.
1161      *
1162      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1163      *
1164      * Tokens start existing when they are minted (`_mint`),
1165      * and stop existing when they are burned (`_burn`).
1166      */
1167     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1168         return _owners[tokenId] != address(0);
1169     }
1170 
1171     /**
1172      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must exist.
1177      */
1178     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1179         address owner = ERC721.ownerOf(tokenId);
1180         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1181     }
1182 
1183     /**
1184      * @dev Safely mints `tokenId` and transfers it to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must not exist.
1189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _safeMint(address to, uint256 tokenId) internal virtual {
1194         _safeMint(to, tokenId, "");
1195     }
1196 
1197     /**
1198      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1199      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1200      */
1201     function _safeMint(
1202         address to,
1203         uint256 tokenId,
1204         bytes memory data
1205     ) internal virtual {
1206         _mint(to, tokenId);
1207         require(
1208             _checkOnERC721Received(address(0), to, tokenId, data),
1209             "ERC721: transfer to non ERC721Receiver implementer"
1210         );
1211     }
1212 
1213     /**
1214      * @dev Mints `tokenId` and transfers it to `to`.
1215      *
1216      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must not exist.
1221      * - `to` cannot be the zero address.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _mint(address to, uint256 tokenId) internal virtual {
1226         require(to != address(0), "ERC721: mint to the zero address");
1227         require(!_exists(tokenId), "ERC721: token already minted");
1228 
1229         _beforeTokenTransfer(address(0), to, tokenId);
1230 
1231         _balances[to] += 1;
1232         _owners[tokenId] = to;
1233 
1234         emit Transfer(address(0), to, tokenId);
1235 
1236         _afterTokenTransfer(address(0), to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev Destroys `tokenId`.
1241      * The approval is cleared when the token is burned.
1242      *
1243      * Requirements:
1244      *
1245      * - `tokenId` must exist.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function _burn(uint256 tokenId) internal virtual {
1250         address owner = ERC721.ownerOf(tokenId);
1251 
1252         _beforeTokenTransfer(owner, address(0), tokenId);
1253 
1254         // Clear approvals
1255         _approve(address(0), tokenId);
1256 
1257         _balances[owner] -= 1;
1258         delete _owners[tokenId];
1259 
1260         emit Transfer(owner, address(0), tokenId);
1261 
1262         _afterTokenTransfer(owner, address(0), tokenId);
1263     }
1264 
1265     /**
1266      * @dev Transfers `tokenId` from `from` to `to`.
1267      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1268      *
1269      * Requirements:
1270      *
1271      * - `to` cannot be the zero address.
1272      * - `tokenId` token must be owned by `from`.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _transfer(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) internal virtual {
1281         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1282         require(to != address(0), "ERC721: transfer to the zero address");
1283 
1284         _beforeTokenTransfer(from, to, tokenId);
1285 
1286         // Clear approvals from the previous owner
1287         _approve(address(0), tokenId);
1288 
1289         _balances[from] -= 1;
1290         _balances[to] += 1;
1291         _owners[tokenId] = to;
1292 
1293         emit Transfer(from, to, tokenId);
1294 
1295         _afterTokenTransfer(from, to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Approve `to` to operate on `tokenId`
1300      *
1301      * Emits an {Approval} event.
1302      */
1303     function _approve(address to, uint256 tokenId) internal virtual {
1304         _tokenApprovals[tokenId] = to;
1305         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1306     }
1307 
1308     /**
1309      * @dev Approve `operator` to operate on all of `owner` tokens
1310      *
1311      * Emits an {ApprovalForAll} event.
1312      */
1313     function _setApprovalForAll(
1314         address owner,
1315         address operator,
1316         bool approved
1317     ) internal virtual {
1318         require(owner != operator, "ERC721: approve to caller");
1319         _operatorApprovals[owner][operator] = approved;
1320         emit ApprovalForAll(owner, operator, approved);
1321     }
1322 
1323     /**
1324      * @dev Reverts if the `tokenId` has not been minted yet.
1325      */
1326     function _requireMinted(uint256 tokenId) internal view virtual {
1327         require(_exists(tokenId), "ERC721: invalid token ID");
1328     }
1329 
1330     /**
1331      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1332      * The call is not executed if the target address is not a contract.
1333      *
1334      * @param from address representing the previous owner of the given token ID
1335      * @param to target address that will receive the tokens
1336      * @param tokenId uint256 ID of the token to be transferred
1337      * @param data bytes optional data to send along with the call
1338      * @return bool whether the call correctly returned the expected magic value
1339      */
1340     function _checkOnERC721Received(
1341         address from,
1342         address to,
1343         uint256 tokenId,
1344         bytes memory data
1345     ) private returns (bool) {
1346         if (to.isContract()) {
1347             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1348                 return retval == IERC721Receiver.onERC721Received.selector;
1349             } catch (bytes memory reason) {
1350                 if (reason.length == 0) {
1351                     revert("ERC721: transfer to non ERC721Receiver implementer");
1352                 } else {
1353                     /// @solidity memory-safe-assembly
1354                     assembly {
1355                         revert(add(32, reason), mload(reason))
1356                     }
1357                 }
1358             }
1359         } else {
1360             return true;
1361         }
1362     }
1363 
1364     /**
1365      * @dev Hook that is called before any token transfer. This includes minting
1366      * and burning.
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` will be minted for `to`.
1373      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1374      * - `from` and `to` are never both zero.
1375      *
1376      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1377      */
1378     function _beforeTokenTransfer(
1379         address from,
1380         address to,
1381         uint256 tokenId
1382     ) internal virtual {}
1383 
1384     /**
1385      * @dev Hook that is called after any transfer of tokens. This includes
1386      * minting and burning.
1387      *
1388      * Calling conditions:
1389      *
1390      * - when `from` and `to` are both non-zero.
1391      * - `from` and `to` are never both zero.
1392      *
1393      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1394      */
1395     function _afterTokenTransfer(
1396         address from,
1397         address to,
1398         uint256 tokenId
1399     ) internal virtual {}
1400 }
1401 
1402 // File: contracts/GenesisPass.sol
1403 
1404 
1405 
1406 pragma solidity >=0.7.0 <0.9.0;
1407 
1408 
1409 
1410 
1411 
1412 contract SougenGenesis is ERC721, Ownable {
1413   using ECDSA for bytes32;
1414   using Strings for uint256;
1415   using Counters for Counters.Counter;
1416 
1417   address private _systemAddress = 0x5dA24Ea1db0358811cB98Be06A82108c6878355B;
1418   mapping(string => bool) public _usedNonces;
1419   mapping(address => uint) public _walletMintStatus;
1420 
1421   Counters.Counter private supply;
1422 
1423   string public hiddenMetadataUri = 'ipfs://QmRAqrSEEZ6h9Rsz1tAgBTiTQsfQ831fFLNcucoJW22XnA/hidden.json';
1424   string public uriPrefix = 'ipfs://${GENESIS__CID__}/';
1425   string public uriSuffix = '.json';
1426 
1427   uint256 public cost = 0.02 ether;
1428   uint256 public publicCost = 0.03 ether;
1429   uint256 public maxSupply = 8888;
1430   uint256 public maxMint = 3;
1431   uint256 public maxMintForGiveaway = 88;
1432 
1433   bool public paused = false;
1434   bool public wlOpen = true;
1435   bool public publicOpen = false;
1436   bool public revealed = false;
1437 
1438   event mintSuccess(address indexed _from, uint256 amount, uint256 supply);
1439 
1440   constructor() ERC721('Sougen Genesis Collection', 'SGC') {}
1441 
1442   function totalSupply() public view returns (uint256) {
1443     return supply.current();
1444   }
1445 
1446   modifier mintCompliance(uint256 _mintAmount) {
1447     require(!paused, 'Contract is paused');
1448     require(_mintAmount > 0 && _mintAmount <= maxMint, 'Invalid mint amount!');
1449     require(
1450       supply.current() + _mintAmount <= maxSupply,
1451       'Max supply exceeded!'
1452     );
1453     require(
1454       (balanceOf(msg.sender) + _mintAmount) <= maxMint,
1455       'Wallet limit exceeded!'
1456     );
1457     _;
1458   }
1459 
1460   function mint(
1461     uint256 _mintAmount,
1462     string memory nonce,
1463     bytes32 hash,
1464     bytes memory signature
1465   ) public payable mintCompliance(_mintAmount) {
1466     require(wlOpen, 'Whitelist sale is close');
1467     require(msg.value >= cost * _mintAmount, 'Insufficient funds');
1468     require(matchSigner(hash, signature), 'Plz mint through website');
1469     require(!_usedNonces[nonce], 'Hash reused');
1470     require(
1471       hashTransaction(msg.sender, _mintAmount, nonce) == hash,
1472       'Hash failed'
1473     );
1474     require(
1475       _walletMintStatus[msg.sender] + _mintAmount <= 3,
1476       'Wallet limit reached'
1477     );
1478     require(supply.current() + _mintAmount <= 4444, 'Max WL supply exceeded!');
1479 
1480     _usedNonces[nonce] = true;
1481     _walletMintStatus[msg.sender] += _mintAmount;
1482     _mintLoop(msg.sender, _mintAmount);
1483   }
1484 
1485   function publicMint(uint256 _mintAmount)
1486     public
1487     payable
1488     mintCompliance(_mintAmount)
1489   {
1490     require(publicOpen, 'Public sale is close');
1491     require(msg.value >= publicCost * _mintAmount, 'Insufficient funds!');
1492     _mintLoop(msg.sender, _mintAmount);
1493   }
1494 
1495   function matchSigner(bytes32 hash, bytes memory signature)
1496     public
1497     view
1498     returns (bool)
1499   {
1500     return _systemAddress == hash.toEthSignedMessageHash().recover(signature);
1501   }
1502 
1503   function hashTransaction(
1504     address sender,
1505     uint256 amount,
1506     string memory nonce
1507   ) public view returns (bytes32) {
1508     bytes32 hash = keccak256(
1509       abi.encodePacked(sender, amount, nonce, address(this))
1510     );
1511 
1512     return hash;
1513   }
1514 
1515   function walletOfOwner(address _owner)
1516     public
1517     view
1518     returns (uint256[] memory)
1519   {
1520     uint256 ownerTokenCount = balanceOf(_owner);
1521     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1522     uint256 currentTokenId = 1;
1523     uint256 ownedTokenIndex = 0;
1524 
1525     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1526       address currentTokenOwner = ownerOf(currentTokenId);
1527 
1528       if (currentTokenOwner == _owner) {
1529         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1530 
1531         ownedTokenIndex++;
1532       }
1533 
1534       currentTokenId++;
1535     }
1536 
1537     return ownedTokenIds;
1538   }
1539 
1540   function tokenURI(uint256 _tokenId)
1541     public
1542     view
1543     virtual
1544     override
1545     returns (string memory)
1546   {
1547     require(
1548       _exists(_tokenId),
1549       'ERC721Metadata: URI query for nonexistent token'
1550     );
1551 
1552     if (revealed == false) {
1553       return hiddenMetadataUri;
1554     }
1555 
1556     string memory currentBaseURI = _baseURI();
1557     return
1558       bytes(currentBaseURI).length > 0
1559         ? string(
1560           abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)
1561         )
1562         : '';
1563   }
1564 
1565   function setCost(uint256 _cost) public onlyOwner {
1566     cost = _cost;
1567   }
1568 
1569   function setPublicCost(uint256 _cost) public onlyOwner {
1570     publicCost = _cost;
1571   }
1572 
1573   function setMaxMint(uint256 _maxMint) public onlyOwner {
1574     maxMint = _maxMint;
1575   }
1576 
1577   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1578     uriPrefix = _uriPrefix;
1579   }
1580 
1581   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1582     uriSuffix = _uriSuffix;
1583   }
1584 
1585   function setPaused(bool _state) public onlyOwner {
1586     paused = _state;
1587   }
1588 
1589   function setPublicOpen(bool _state) public onlyOwner {
1590     publicOpen = _state;
1591   }
1592 
1593   function setWlOpen(bool _state) public onlyOwner {
1594     wlOpen = _state;
1595   }
1596 
1597   function setRevealed(bool _state) public onlyOwner {
1598     revealed = _state;
1599   }
1600 
1601   function setMaxSupply(uint256 _maxMSupply) public onlyOwner {
1602     maxSupply = _maxMSupply;
1603   }
1604 
1605   function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1606     public
1607     onlyOwner
1608   {
1609     hiddenMetadataUri = _hiddenMetadataUri;
1610   }
1611 
1612   function withdraw() public onlyOwner {
1613     (bool fs, ) = payable(0x7c8fcBEc30A1e97EBA14E8dB5d195c1eE5f63221).call{
1614       value: address(this).balance * 50 / 100
1615     }('');
1616     require(fs);
1617 
1618     (bool os, ) = payable(0xC9ce49d16030fedA01D01F7C78e2E234daA5A2e1).call{
1619       value: address(this).balance
1620     }('');
1621     require(os);
1622   }
1623 
1624   function mintForGiveaway() public onlyOwner {
1625     require(
1626       balanceOf(msg.sender) <= maxMintForGiveaway,
1627       'Wallet limit exceeded!'
1628     );
1629     _mintLoop(msg.sender, maxMintForGiveaway);
1630   }
1631 
1632   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1633     for (uint256 i = 0; i < _mintAmount; i++) {
1634       supply.increment();
1635       _safeMint(_receiver, supply.current());
1636     }
1637 
1638     emit mintSuccess(_receiver, _mintAmount, supply.current());
1639   }
1640 
1641   function _baseURI() internal view virtual override returns (string memory) {
1642     return uriPrefix;
1643   }
1644 }