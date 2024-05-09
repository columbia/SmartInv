1 // SPDX-License-Identifier: MIT
2 /*
3 888b     d888          888             888888b.                              888             
4 8888b   d8888          888             888  "88b                             888             
5 88888b.d88888          888             888  .88P                             888             
6 888Y88888P888  .d88b.  888888  8888b.  8888888K.   .d88b.   8888b.  .d8888b  888888 .d8888b  
7 888 Y888P 888 d8P  Y8b 888        "88b 888  "Y88b d8P  Y8b     "88b 88K      888    88K      
8 888  Y8P  888 88888888 888    .d888888 888    888 88888888 .d888888 "Y8888b. 888    "Y8888b. 
9 888   "   888 Y8b.     Y88b.  888  888 888   d88P Y8b.     888  888      X88 Y88b.       X88 
10 888       888  "Y8888   "Y888 "Y888888 8888888P"   "Y8888  "Y888888  88888P'  "Y888  88888P' 
11                                                                                              
12                              Coded by Devko.dev#7286
13 */
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 
16 
17 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26     uint8 private constant _ADDRESS_LENGTH = 20;
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
30      */
31     function toString(uint256 value) internal pure returns (string memory) {
32         // Inspired by OraclizeAPI's implementation - MIT licence
33         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
34 
35         if (value == 0) {
36             return "0";
37         }
38         uint256 temp = value;
39         uint256 digits;
40         while (temp != 0) {
41             digits++;
42             temp /= 10;
43         }
44         bytes memory buffer = new bytes(digits);
45         while (value != 0) {
46             digits -= 1;
47             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
48             value /= 10;
49         }
50         return string(buffer);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
55      */
56     function toHexString(uint256 value) internal pure returns (string memory) {
57         if (value == 0) {
58             return "0x00";
59         }
60         uint256 temp = value;
61         uint256 length = 0;
62         while (temp != 0) {
63             length++;
64             temp >>= 8;
65         }
66         return toHexString(value, length);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
71      */
72     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
73         bytes memory buffer = new bytes(2 * length + 2);
74         buffer[0] = "0";
75         buffer[1] = "x";
76         for (uint256 i = 2 * length + 1; i > 1; --i) {
77             buffer[i] = _HEX_SYMBOLS[value & 0xf];
78             value >>= 4;
79         }
80         require(value == 0, "Strings: hex length insufficient");
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
86      */
87     function toHexString(address addr) internal pure returns (string memory) {
88         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 
100 /**
101  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
102  *
103  * These functions can be used to verify that a message was signed by the holder
104  * of the private keys of a given address.
105  */
106 library ECDSA {
107     enum RecoverError {
108         NoError,
109         InvalidSignature,
110         InvalidSignatureLength,
111         InvalidSignatureS,
112         InvalidSignatureV
113     }
114 
115     function _throwError(RecoverError error) private pure {
116         if (error == RecoverError.NoError) {
117             return; // no error: do nothing
118         } else if (error == RecoverError.InvalidSignature) {
119             revert("ECDSA: invalid signature");
120         } else if (error == RecoverError.InvalidSignatureLength) {
121             revert("ECDSA: invalid signature length");
122         } else if (error == RecoverError.InvalidSignatureS) {
123             revert("ECDSA: invalid signature 's' value");
124         } else if (error == RecoverError.InvalidSignatureV) {
125             revert("ECDSA: invalid signature 'v' value");
126         }
127     }
128 
129     /**
130      * @dev Returns the address that signed a hashed message (`hash`) with
131      * `signature` or error string. This address can then be used for verification purposes.
132      *
133      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
134      * this function rejects them by requiring the `s` value to be in the lower
135      * half order, and the `v` value to be either 27 or 28.
136      *
137      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
138      * verification to be secure: it is possible to craft signatures that
139      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
140      * this is by receiving a hash of the original message (which may otherwise
141      * be too long), and then calling {toEthSignedMessageHash} on it.
142      *
143      * Documentation for signature generation:
144      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
145      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
146      *
147      * _Available since v4.3._
148      */
149     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
150         // Check the signature length
151         // - case 65: r,s,v signature (standard)
152         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
153         if (signature.length == 65) {
154             bytes32 r;
155             bytes32 s;
156             uint8 v;
157             // ecrecover takes the signature parameters, and the only way to get them
158             // currently is to use assembly.
159             /// @solidity memory-safe-assembly
160             assembly {
161                 r := mload(add(signature, 0x20))
162                 s := mload(add(signature, 0x40))
163                 v := byte(0, mload(add(signature, 0x60)))
164             }
165             return tryRecover(hash, v, r, s);
166         } else if (signature.length == 64) {
167             bytes32 r;
168             bytes32 vs;
169             // ecrecover takes the signature parameters, and the only way to get them
170             // currently is to use assembly.
171             /// @solidity memory-safe-assembly
172             assembly {
173                 r := mload(add(signature, 0x20))
174                 vs := mload(add(signature, 0x40))
175             }
176             return tryRecover(hash, r, vs);
177         } else {
178             return (address(0), RecoverError.InvalidSignatureLength);
179         }
180     }
181 
182     /**
183      * @dev Returns the address that signed a hashed message (`hash`) with
184      * `signature`. This address can then be used for verification purposes.
185      *
186      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
187      * this function rejects them by requiring the `s` value to be in the lower
188      * half order, and the `v` value to be either 27 or 28.
189      *
190      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
191      * verification to be secure: it is possible to craft signatures that
192      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
193      * this is by receiving a hash of the original message (which may otherwise
194      * be too long), and then calling {toEthSignedMessageHash} on it.
195      */
196     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
197         (address recovered, RecoverError error) = tryRecover(hash, signature);
198         _throwError(error);
199         return recovered;
200     }
201 
202     /**
203      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
204      *
205      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
206      *
207      * _Available since v4.3._
208      */
209     function tryRecover(
210         bytes32 hash,
211         bytes32 r,
212         bytes32 vs
213     ) internal pure returns (address, RecoverError) {
214         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
215         uint8 v = uint8((uint256(vs) >> 255) + 27);
216         return tryRecover(hash, v, r, s);
217     }
218 
219     /**
220      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
221      *
222      * _Available since v4.2._
223      */
224     function recover(
225         bytes32 hash,
226         bytes32 r,
227         bytes32 vs
228     ) internal pure returns (address) {
229         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
230         _throwError(error);
231         return recovered;
232     }
233 
234     /**
235      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
236      * `r` and `s` signature fields separately.
237      *
238      * _Available since v4.3._
239      */
240     function tryRecover(
241         bytes32 hash,
242         uint8 v,
243         bytes32 r,
244         bytes32 s
245     ) internal pure returns (address, RecoverError) {
246         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
247         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
248         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
249         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
250         //
251         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
252         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
253         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
254         // these malleable signatures as well.
255         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
256             return (address(0), RecoverError.InvalidSignatureS);
257         }
258         if (v != 27 && v != 28) {
259             return (address(0), RecoverError.InvalidSignatureV);
260         }
261 
262         // If the signature is valid (and not malleable), return the signer address
263         address signer = ecrecover(hash, v, r, s);
264         if (signer == address(0)) {
265             return (address(0), RecoverError.InvalidSignature);
266         }
267 
268         return (signer, RecoverError.NoError);
269     }
270 
271     /**
272      * @dev Overload of {ECDSA-recover} that receives the `v`,
273      * `r` and `s` signature fields separately.
274      */
275     function recover(
276         bytes32 hash,
277         uint8 v,
278         bytes32 r,
279         bytes32 s
280     ) internal pure returns (address) {
281         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
282         _throwError(error);
283         return recovered;
284     }
285 
286     /**
287      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
288      * produces hash corresponding to the one signed with the
289      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
290      * JSON-RPC method as part of EIP-191.
291      *
292      * See {recover}.
293      */
294     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
295         // 32 is the length in bytes of hash,
296         // enforced by the type signature above
297         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
298     }
299 
300     /**
301      * @dev Returns an Ethereum Signed Message, created from `s`. This
302      * produces hash corresponding to the one signed with the
303      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
304      * JSON-RPC method as part of EIP-191.
305      *
306      * See {recover}.
307      */
308     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
309         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
310     }
311 
312     /**
313      * @dev Returns an Ethereum Signed Typed Data, created from a
314      * `domainSeparator` and a `structHash`. This produces hash corresponding
315      * to the one signed with the
316      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
317      * JSON-RPC method as part of EIP-712.
318      *
319      * See {recover}.
320      */
321     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
322         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
323     }
324 }
325 
326 // File: @openzeppelin/contracts/utils/Counters.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @title Counters
335  * @author Matt Condon (@shrugs)
336  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
337  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
338  *
339  * Include with `using Counters for Counters.Counter;`
340  */
341 library Counters {
342     struct Counter {
343         // This variable should never be directly accessed by users of the library: interactions must be restricted to
344         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
345         // this feature: see https://github.com/ethereum/solidity/issues/4637
346         uint256 _value; // default: 0
347     }
348 
349     function current(Counter storage counter) internal view returns (uint256) {
350         return counter._value;
351     }
352 
353     function increment(Counter storage counter) internal {
354         unchecked {
355             counter._value += 1;
356         }
357     }
358 
359     function decrement(Counter storage counter) internal {
360         uint256 value = counter._value;
361         require(value > 0, "Counter: decrement overflow");
362         unchecked {
363             counter._value = value - 1;
364         }
365     }
366 
367     function reset(Counter storage counter) internal {
368         counter._value = 0;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/utils/Context.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Provides information about the current execution context, including the
381  * sender of the transaction and its data. While these are generally available
382  * via msg.sender and msg.data, they should not be accessed in such a direct
383  * manner, since when dealing with meta-transactions the account sending and
384  * paying for execution may not be the actual sender (as far as an application
385  * is concerned).
386  *
387  * This contract is only required for intermediate, library-like contracts.
388  */
389 abstract contract Context {
390     function _msgSender() internal view virtual returns (address) {
391         return msg.sender;
392     }
393 
394     function _msgData() internal view virtual returns (bytes calldata) {
395         return msg.data;
396     }
397 }
398 
399 // File: @openzeppelin/contracts/access/Ownable.sol
400 
401 
402 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 abstract contract Ownable is Context {
420     address private _owner;
421 
422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
423 
424     /**
425      * @dev Initializes the contract setting the deployer as the initial owner.
426      */
427     constructor() {
428         _transferOwnership(_msgSender());
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner() {
435         _checkOwner();
436         _;
437     }
438 
439     /**
440      * @dev Returns the address of the current owner.
441      */
442     function owner() public view virtual returns (address) {
443         return _owner;
444     }
445 
446     /**
447      * @dev Throws if the sender is not the owner.
448      */
449     function _checkOwner() internal view virtual {
450         require(owner() == _msgSender(), "Ownable: caller is not the owner");
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         _transferOwnership(address(0));
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public virtual onlyOwner {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         _transferOwnership(newOwner);
471     }
472 
473     /**
474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
475      * Internal function without access restriction.
476      */
477     function _transferOwnership(address newOwner) internal virtual {
478         address oldOwner = _owner;
479         _owner = newOwner;
480         emit OwnershipTransferred(oldOwner, newOwner);
481     }
482 }
483 
484 // File: @openzeppelin/contracts/utils/Address.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
488 
489 pragma solidity ^0.8.1;
490 
491 /**
492  * @dev Collection of functions related to the address type
493  */
494 library Address {
495     /**
496      * @dev Returns true if `account` is a contract.
497      *
498      * [IMPORTANT]
499      * ====
500      * It is unsafe to assume that an address for which this function returns
501      * false is an externally-owned account (EOA) and not a contract.
502      *
503      * Among others, `isContract` will return false for the following
504      * types of addresses:
505      *
506      *  - an externally-owned account
507      *  - a contract in construction
508      *  - an address where a contract will be created
509      *  - an address where a contract lived, but was destroyed
510      * ====
511      *
512      * [IMPORTANT]
513      * ====
514      * You shouldn't rely on `isContract` to protect against flash loan attacks!
515      *
516      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
517      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
518      * constructor.
519      * ====
520      */
521     function isContract(address account) internal view returns (bool) {
522         // This method relies on extcodesize/address.code.length, which returns 0
523         // for contracts in construction, since the code is only stored at the end
524         // of the constructor execution.
525 
526         return account.code.length > 0;
527     }
528 
529     /**
530      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
531      * `recipient`, forwarding all available gas and reverting on errors.
532      *
533      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
534      * of certain opcodes, possibly making contracts go over the 2300 gas limit
535      * imposed by `transfer`, making them unable to receive funds via
536      * `transfer`. {sendValue} removes this limitation.
537      *
538      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
539      *
540      * IMPORTANT: because control is transferred to `recipient`, care must be
541      * taken to not create reentrancy vulnerabilities. Consider using
542      * {ReentrancyGuard} or the
543      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
544      */
545     function sendValue(address payable recipient, uint256 amount) internal {
546         require(address(this).balance >= amount, "Address: insufficient balance");
547 
548         (bool success, ) = recipient.call{value: amount}("");
549         require(success, "Address: unable to send value, recipient may have reverted");
550     }
551 
552     /**
553      * @dev Performs a Solidity function call using a low level `call`. A
554      * plain `call` is an unsafe replacement for a function call: use this
555      * function instead.
556      *
557      * If `target` reverts with a revert reason, it is bubbled up by this
558      * function (like regular Solidity function calls).
559      *
560      * Returns the raw returned data. To convert to the expected return value,
561      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
562      *
563      * Requirements:
564      *
565      * - `target` must be a contract.
566      * - calling `target` with `data` must not revert.
567      *
568      * _Available since v3.1._
569      */
570     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
571         return functionCall(target, data, "Address: low-level call failed");
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
576      * `errorMessage` as a fallback revert reason when `target` reverts.
577      *
578      * _Available since v3.1._
579      */
580     function functionCall(
581         address target,
582         bytes memory data,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         return functionCallWithValue(target, data, 0, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but also transferring `value` wei to `target`.
591      *
592      * Requirements:
593      *
594      * - the calling contract must have an ETH balance of at least `value`.
595      * - the called Solidity function must be `payable`.
596      *
597      * _Available since v3.1._
598      */
599     function functionCallWithValue(
600         address target,
601         bytes memory data,
602         uint256 value
603     ) internal returns (bytes memory) {
604         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
609      * with `errorMessage` as a fallback revert reason when `target` reverts.
610      *
611      * _Available since v3.1._
612      */
613     function functionCallWithValue(
614         address target,
615         bytes memory data,
616         uint256 value,
617         string memory errorMessage
618     ) internal returns (bytes memory) {
619         require(address(this).balance >= value, "Address: insufficient balance for call");
620         require(isContract(target), "Address: call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.call{value: value}(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
628      * but performing a static call.
629      *
630      * _Available since v3.3._
631      */
632     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
633         return functionStaticCall(target, data, "Address: low-level static call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
638      * but performing a static call.
639      *
640      * _Available since v3.3._
641      */
642     function functionStaticCall(
643         address target,
644         bytes memory data,
645         string memory errorMessage
646     ) internal view returns (bytes memory) {
647         require(isContract(target), "Address: static call to non-contract");
648 
649         (bool success, bytes memory returndata) = target.staticcall(data);
650         return verifyCallResult(success, returndata, errorMessage);
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
660         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
665      * but performing a delegate call.
666      *
667      * _Available since v3.4._
668      */
669     function functionDelegateCall(
670         address target,
671         bytes memory data,
672         string memory errorMessage
673     ) internal returns (bytes memory) {
674         require(isContract(target), "Address: delegate call to non-contract");
675 
676         (bool success, bytes memory returndata) = target.delegatecall(data);
677         return verifyCallResult(success, returndata, errorMessage);
678     }
679 
680     /**
681      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
682      * revert reason using the provided one.
683      *
684      * _Available since v4.3._
685      */
686     function verifyCallResult(
687         bool success,
688         bytes memory returndata,
689         string memory errorMessage
690     ) internal pure returns (bytes memory) {
691         if (success) {
692             return returndata;
693         } else {
694             // Look for revert reason and bubble it up if present
695             if (returndata.length > 0) {
696                 // The easiest way to bubble the revert reason is using memory via assembly
697                 /// @solidity memory-safe-assembly
698                 assembly {
699                     let returndata_size := mload(returndata)
700                     revert(add(32, returndata), returndata_size)
701                 }
702             } else {
703                 revert(errorMessage);
704             }
705         }
706     }
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
768 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
769 
770 
771 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 
776 /**
777  * @dev _Available since v3.1._
778  */
779 interface IERC1155Receiver is IERC165 {
780     /**
781      * @dev Handles the receipt of a single ERC1155 token type. This function is
782      * called at the end of a `safeTransferFrom` after the balance has been updated.
783      *
784      * NOTE: To accept the transfer, this must return
785      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
786      * (i.e. 0xf23a6e61, or its own function selector).
787      *
788      * @param operator The address which initiated the transfer (i.e. msg.sender)
789      * @param from The address which previously owned the token
790      * @param id The ID of the token being transferred
791      * @param value The amount of tokens being transferred
792      * @param data Additional data with no specified format
793      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
794      */
795     function onERC1155Received(
796         address operator,
797         address from,
798         uint256 id,
799         uint256 value,
800         bytes calldata data
801     ) external returns (bytes4);
802 
803     /**
804      * @dev Handles the receipt of a multiple ERC1155 token types. This function
805      * is called at the end of a `safeBatchTransferFrom` after the balances have
806      * been updated.
807      *
808      * NOTE: To accept the transfer(s), this must return
809      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
810      * (i.e. 0xbc197c81, or its own function selector).
811      *
812      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
813      * @param from The address which previously owned the token
814      * @param ids An array containing ids of each token being transferred (order and length must match values array)
815      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
816      * @param data Additional data with no specified format
817      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
818      */
819     function onERC1155BatchReceived(
820         address operator,
821         address from,
822         uint256[] calldata ids,
823         uint256[] calldata values,
824         bytes calldata data
825     ) external returns (bytes4);
826 }
827 
828 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
829 
830 
831 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 
836 /**
837  * @dev Required interface of an ERC1155 compliant contract, as defined in the
838  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
839  *
840  * _Available since v3.1._
841  */
842 interface IERC1155 is IERC165 {
843     /**
844      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
845      */
846     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
847 
848     /**
849      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
850      * transfers.
851      */
852     event TransferBatch(
853         address indexed operator,
854         address indexed from,
855         address indexed to,
856         uint256[] ids,
857         uint256[] values
858     );
859 
860     /**
861      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
862      * `approved`.
863      */
864     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
865 
866     /**
867      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
868      *
869      * If an {URI} event was emitted for `id`, the standard
870      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
871      * returned by {IERC1155MetadataURI-uri}.
872      */
873     event URI(string value, uint256 indexed id);
874 
875     /**
876      * @dev Returns the amount of tokens of token type `id` owned by `account`.
877      *
878      * Requirements:
879      *
880      * - `account` cannot be the zero address.
881      */
882     function balanceOf(address account, uint256 id) external view returns (uint256);
883 
884     /**
885      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
886      *
887      * Requirements:
888      *
889      * - `accounts` and `ids` must have the same length.
890      */
891     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
892         external
893         view
894         returns (uint256[] memory);
895 
896     /**
897      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
898      *
899      * Emits an {ApprovalForAll} event.
900      *
901      * Requirements:
902      *
903      * - `operator` cannot be the caller.
904      */
905     function setApprovalForAll(address operator, bool approved) external;
906 
907     /**
908      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
909      *
910      * See {setApprovalForAll}.
911      */
912     function isApprovedForAll(address account, address operator) external view returns (bool);
913 
914     /**
915      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
916      *
917      * Emits a {TransferSingle} event.
918      *
919      * Requirements:
920      *
921      * - `to` cannot be the zero address.
922      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
923      * - `from` must have a balance of tokens of type `id` of at least `amount`.
924      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
925      * acceptance magic value.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 id,
931         uint256 amount,
932         bytes calldata data
933     ) external;
934 
935     /**
936      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
937      *
938      * Emits a {TransferBatch} event.
939      *
940      * Requirements:
941      *
942      * - `ids` and `amounts` must have the same length.
943      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
944      * acceptance magic value.
945      */
946     function safeBatchTransferFrom(
947         address from,
948         address to,
949         uint256[] calldata ids,
950         uint256[] calldata amounts,
951         bytes calldata data
952     ) external;
953 }
954 
955 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
956 
957 
958 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
959 
960 pragma solidity ^0.8.0;
961 
962 
963 /**
964  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
965  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
966  *
967  * _Available since v3.1._
968  */
969 interface IERC1155MetadataURI is IERC1155 {
970     /**
971      * @dev Returns the URI for token type `id`.
972      *
973      * If the `\{id\}` substring is present in the URI, it must be replaced by
974      * clients with the actual token type ID.
975      */
976     function uri(uint256 id) external view returns (string memory);
977 }
978 
979 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
980 
981 
982 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 
987 
988 
989 
990 
991 
992 /**
993  * @dev Implementation of the basic standard multi-token.
994  * See https://eips.ethereum.org/EIPS/eip-1155
995  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
996  *
997  * _Available since v3.1._
998  */
999 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1000     using Address for address;
1001 
1002     // Mapping from token ID to account balances
1003     mapping(uint256 => mapping(address => uint256)) private _balances;
1004 
1005     // Mapping from account to operator approvals
1006     mapping(address => mapping(address => bool)) private _operatorApprovals;
1007 
1008     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1009     string private _uri;
1010 
1011     /**
1012      * @dev See {_setURI}.
1013      */
1014     constructor(string memory uri_) {
1015         _setURI(uri_);
1016     }
1017 
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1022         return
1023             interfaceId == type(IERC1155).interfaceId ||
1024             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1025             super.supportsInterface(interfaceId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC1155MetadataURI-uri}.
1030      *
1031      * This implementation returns the same URI for *all* token types. It relies
1032      * on the token type ID substitution mechanism
1033      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1034      *
1035      * Clients calling this function must replace the `\{id\}` substring with the
1036      * actual token type ID.
1037      */
1038     function uri(uint256) public view virtual override returns (string memory) {
1039         return _uri;
1040     }
1041 
1042     /**
1043      * @dev See {IERC1155-balanceOf}.
1044      *
1045      * Requirements:
1046      *
1047      * - `account` cannot be the zero address.
1048      */
1049     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1050         require(account != address(0), "ERC1155: address zero is not a valid owner");
1051         return _balances[id][account];
1052     }
1053 
1054     /**
1055      * @dev See {IERC1155-balanceOfBatch}.
1056      *
1057      * Requirements:
1058      *
1059      * - `accounts` and `ids` must have the same length.
1060      */
1061     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1062         public
1063         view
1064         virtual
1065         override
1066         returns (uint256[] memory)
1067     {
1068         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1069 
1070         uint256[] memory batchBalances = new uint256[](accounts.length);
1071 
1072         for (uint256 i = 0; i < accounts.length; ++i) {
1073             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1074         }
1075 
1076         return batchBalances;
1077     }
1078 
1079     /**
1080      * @dev See {IERC1155-setApprovalForAll}.
1081      */
1082     function setApprovalForAll(address operator, bool approved) public virtual override {
1083         _setApprovalForAll(_msgSender(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev See {IERC1155-isApprovedForAll}.
1088      */
1089     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1090         return _operatorApprovals[account][operator];
1091     }
1092 
1093     /**
1094      * @dev See {IERC1155-safeTransferFrom}.
1095      */
1096     function safeTransferFrom(
1097         address from,
1098         address to,
1099         uint256 id,
1100         uint256 amount,
1101         bytes memory data
1102     ) public virtual override {
1103         require(
1104             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1105             "ERC1155: caller is not token owner nor approved"
1106         );
1107         _safeTransferFrom(from, to, id, amount, data);
1108     }
1109 
1110     /**
1111      * @dev See {IERC1155-safeBatchTransferFrom}.
1112      */
1113     function safeBatchTransferFrom(
1114         address from,
1115         address to,
1116         uint256[] memory ids,
1117         uint256[] memory amounts,
1118         bytes memory data
1119     ) public virtual override {
1120         require(
1121             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1122             "ERC1155: caller is not token owner nor approved"
1123         );
1124         _safeBatchTransferFrom(from, to, ids, amounts, data);
1125     }
1126 
1127     /**
1128      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1129      *
1130      * Emits a {TransferSingle} event.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1136      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1137      * acceptance magic value.
1138      */
1139     function _safeTransferFrom(
1140         address from,
1141         address to,
1142         uint256 id,
1143         uint256 amount,
1144         bytes memory data
1145     ) internal virtual {
1146         require(to != address(0), "ERC1155: transfer to the zero address");
1147 
1148         address operator = _msgSender();
1149         uint256[] memory ids = _asSingletonArray(id);
1150         uint256[] memory amounts = _asSingletonArray(amount);
1151 
1152         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1153 
1154         uint256 fromBalance = _balances[id][from];
1155         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1156         unchecked {
1157             _balances[id][from] = fromBalance - amount;
1158         }
1159         _balances[id][to] += amount;
1160 
1161         emit TransferSingle(operator, from, to, id, amount);
1162 
1163         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1164 
1165         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1166     }
1167 
1168     /**
1169      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1170      *
1171      * Emits a {TransferBatch} event.
1172      *
1173      * Requirements:
1174      *
1175      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1176      * acceptance magic value.
1177      */
1178     function _safeBatchTransferFrom(
1179         address from,
1180         address to,
1181         uint256[] memory ids,
1182         uint256[] memory amounts,
1183         bytes memory data
1184     ) internal virtual {
1185         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1186         require(to != address(0), "ERC1155: transfer to the zero address");
1187 
1188         address operator = _msgSender();
1189 
1190         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1191 
1192         for (uint256 i = 0; i < ids.length; ++i) {
1193             uint256 id = ids[i];
1194             uint256 amount = amounts[i];
1195 
1196             uint256 fromBalance = _balances[id][from];
1197             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1198             unchecked {
1199                 _balances[id][from] = fromBalance - amount;
1200             }
1201             _balances[id][to] += amount;
1202         }
1203 
1204         emit TransferBatch(operator, from, to, ids, amounts);
1205 
1206         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1207 
1208         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1209     }
1210 
1211     /**
1212      * @dev Sets a new URI for all token types, by relying on the token type ID
1213      * substitution mechanism
1214      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1215      *
1216      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1217      * URI or any of the amounts in the JSON file at said URI will be replaced by
1218      * clients with the token type ID.
1219      *
1220      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1221      * interpreted by clients as
1222      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1223      * for token type ID 0x4cce0.
1224      *
1225      * See {uri}.
1226      *
1227      * Because these URIs cannot be meaningfully represented by the {URI} event,
1228      * this function emits no events.
1229      */
1230     function _setURI(string memory newuri) internal virtual {
1231         _uri = newuri;
1232     }
1233 
1234     /**
1235      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1236      *
1237      * Emits a {TransferSingle} event.
1238      *
1239      * Requirements:
1240      *
1241      * - `to` cannot be the zero address.
1242      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1243      * acceptance magic value.
1244      */
1245     function _mint(
1246         address to,
1247         uint256 id,
1248         uint256 amount,
1249         bytes memory data
1250     ) internal virtual {
1251         require(to != address(0), "ERC1155: mint to the zero address");
1252 
1253         address operator = _msgSender();
1254         uint256[] memory ids = _asSingletonArray(id);
1255         uint256[] memory amounts = _asSingletonArray(amount);
1256 
1257         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1258 
1259         _balances[id][to] += amount;
1260         emit TransferSingle(operator, address(0), to, id, amount);
1261 
1262         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1263 
1264         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1265     }
1266 
1267     /**
1268      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1269      *
1270      * Emits a {TransferBatch} event.
1271      *
1272      * Requirements:
1273      *
1274      * - `ids` and `amounts` must have the same length.
1275      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1276      * acceptance magic value.
1277      */
1278     function _mintBatch(
1279         address to,
1280         uint256[] memory ids,
1281         uint256[] memory amounts,
1282         bytes memory data
1283     ) internal virtual {
1284         require(to != address(0), "ERC1155: mint to the zero address");
1285         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1286 
1287         address operator = _msgSender();
1288 
1289         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1290 
1291         for (uint256 i = 0; i < ids.length; i++) {
1292             _balances[ids[i]][to] += amounts[i];
1293         }
1294 
1295         emit TransferBatch(operator, address(0), to, ids, amounts);
1296 
1297         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1298 
1299         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1300     }
1301 
1302     /**
1303      * @dev Destroys `amount` tokens of token type `id` from `from`
1304      *
1305      * Emits a {TransferSingle} event.
1306      *
1307      * Requirements:
1308      *
1309      * - `from` cannot be the zero address.
1310      * - `from` must have at least `amount` tokens of token type `id`.
1311      */
1312     function _burn(
1313         address from,
1314         uint256 id,
1315         uint256 amount
1316     ) internal virtual {
1317         require(from != address(0), "ERC1155: burn from the zero address");
1318 
1319         address operator = _msgSender();
1320         uint256[] memory ids = _asSingletonArray(id);
1321         uint256[] memory amounts = _asSingletonArray(amount);
1322 
1323         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1324 
1325         uint256 fromBalance = _balances[id][from];
1326         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1327         unchecked {
1328             _balances[id][from] = fromBalance - amount;
1329         }
1330 
1331         emit TransferSingle(operator, from, address(0), id, amount);
1332 
1333         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1334     }
1335 
1336     /**
1337      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1338      *
1339      * Emits a {TransferBatch} event.
1340      *
1341      * Requirements:
1342      *
1343      * - `ids` and `amounts` must have the same length.
1344      */
1345     function _burnBatch(
1346         address from,
1347         uint256[] memory ids,
1348         uint256[] memory amounts
1349     ) internal virtual {
1350         require(from != address(0), "ERC1155: burn from the zero address");
1351         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1352 
1353         address operator = _msgSender();
1354 
1355         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1356 
1357         for (uint256 i = 0; i < ids.length; i++) {
1358             uint256 id = ids[i];
1359             uint256 amount = amounts[i];
1360 
1361             uint256 fromBalance = _balances[id][from];
1362             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1363             unchecked {
1364                 _balances[id][from] = fromBalance - amount;
1365             }
1366         }
1367 
1368         emit TransferBatch(operator, from, address(0), ids, amounts);
1369 
1370         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1371     }
1372 
1373     /**
1374      * @dev Approve `operator` to operate on all of `owner` tokens
1375      *
1376      * Emits an {ApprovalForAll} event.
1377      */
1378     function _setApprovalForAll(
1379         address owner,
1380         address operator,
1381         bool approved
1382     ) internal virtual {
1383         require(owner != operator, "ERC1155: setting approval status for self");
1384         _operatorApprovals[owner][operator] = approved;
1385         emit ApprovalForAll(owner, operator, approved);
1386     }
1387 
1388     /**
1389      * @dev Hook that is called before any token transfer. This includes minting
1390      * and burning, as well as batched variants.
1391      *
1392      * The same hook is called on both single and batched variants. For single
1393      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1394      *
1395      * Calling conditions (for each `id` and `amount` pair):
1396      *
1397      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1398      * of token type `id` will be  transferred to `to`.
1399      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1400      * for `to`.
1401      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1402      * will be burned.
1403      * - `from` and `to` are never both zero.
1404      * - `ids` and `amounts` have the same, non-zero length.
1405      *
1406      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1407      */
1408     function _beforeTokenTransfer(
1409         address operator,
1410         address from,
1411         address to,
1412         uint256[] memory ids,
1413         uint256[] memory amounts,
1414         bytes memory data
1415     ) internal virtual {}
1416 
1417     /**
1418      * @dev Hook that is called after any token transfer. This includes minting
1419      * and burning, as well as batched variants.
1420      *
1421      * The same hook is called on both single and batched variants. For single
1422      * transfers, the length of the `id` and `amount` arrays will be 1.
1423      *
1424      * Calling conditions (for each `id` and `amount` pair):
1425      *
1426      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1427      * of token type `id` will be  transferred to `to`.
1428      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1429      * for `to`.
1430      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1431      * will be burned.
1432      * - `from` and `to` are never both zero.
1433      * - `ids` and `amounts` have the same, non-zero length.
1434      *
1435      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1436      */
1437     function _afterTokenTransfer(
1438         address operator,
1439         address from,
1440         address to,
1441         uint256[] memory ids,
1442         uint256[] memory amounts,
1443         bytes memory data
1444     ) internal virtual {}
1445 
1446     function _doSafeTransferAcceptanceCheck(
1447         address operator,
1448         address from,
1449         address to,
1450         uint256 id,
1451         uint256 amount,
1452         bytes memory data
1453     ) private {
1454         if (to.isContract()) {
1455             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1456                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1457                     revert("ERC1155: ERC1155Receiver rejected tokens");
1458                 }
1459             } catch Error(string memory reason) {
1460                 revert(reason);
1461             } catch {
1462                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1463             }
1464         }
1465     }
1466 
1467     function _doSafeBatchTransferAcceptanceCheck(
1468         address operator,
1469         address from,
1470         address to,
1471         uint256[] memory ids,
1472         uint256[] memory amounts,
1473         bytes memory data
1474     ) private {
1475         if (to.isContract()) {
1476             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1477                 bytes4 response
1478             ) {
1479                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1480                     revert("ERC1155: ERC1155Receiver rejected tokens");
1481                 }
1482             } catch Error(string memory reason) {
1483                 revert(reason);
1484             } catch {
1485                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1486             }
1487         }
1488     }
1489 
1490     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1491         uint256[] memory array = new uint256[](1);
1492         array[0] = element;
1493 
1494         return array;
1495     }
1496 }
1497 
1498 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1499 
1500 
1501 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1502 
1503 pragma solidity ^0.8.0;
1504 
1505 
1506 /**
1507  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1508  *
1509  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1510  * clearly identified. Note: While a totalSupply of 1 might mean the
1511  * corresponding is an NFT, there is no guarantees that no other token with the
1512  * same id are not going to be minted.
1513  */
1514 abstract contract ERC1155Supply is ERC1155 {
1515     mapping(uint256 => uint256) private _totalSupply;
1516 
1517     /**
1518      * @dev Total amount of tokens in with a given id.
1519      */
1520     function totalSupply(uint256 id) public view virtual returns (uint256) {
1521         return _totalSupply[id];
1522     }
1523 
1524     /**
1525      * @dev Indicates whether any token exist with a given id, or not.
1526      */
1527     function exists(uint256 id) public view virtual returns (bool) {
1528         return ERC1155Supply.totalSupply(id) > 0;
1529     }
1530 
1531     /**
1532      * @dev See {ERC1155-_beforeTokenTransfer}.
1533      */
1534     function _beforeTokenTransfer(
1535         address operator,
1536         address from,
1537         address to,
1538         uint256[] memory ids,
1539         uint256[] memory amounts,
1540         bytes memory data
1541     ) internal virtual override {
1542         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1543 
1544         if (from == address(0)) {
1545             for (uint256 i = 0; i < ids.length; ++i) {
1546                 _totalSupply[ids[i]] += amounts[i];
1547             }
1548         }
1549 
1550         if (to == address(0)) {
1551             for (uint256 i = 0; i < ids.length; ++i) {
1552                 uint256 id = ids[i];
1553                 uint256 amount = amounts[i];
1554                 uint256 supply = _totalSupply[id];
1555                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1556                 unchecked {
1557                     _totalSupply[id] = supply - amount;
1558                 }
1559             }
1560         }
1561     }
1562 }
1563 
1564 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1565 
1566 
1567 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1568 
1569 pragma solidity ^0.8.0;
1570 
1571 
1572 /**
1573  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1574  * own tokens and those that they have been approved to use.
1575  *
1576  * _Available since v3.1._
1577  */
1578 abstract contract ERC1155Burnable is ERC1155 {
1579     function burn(
1580         address account,
1581         uint256 id,
1582         uint256 value
1583     ) public virtual {
1584         require(
1585             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1586             "ERC1155: caller is not token owner nor approved"
1587         );
1588 
1589         _burn(account, id, value);
1590     }
1591 
1592     function burnBatch(
1593         address account,
1594         uint256[] memory ids,
1595         uint256[] memory values
1596     ) public virtual {
1597         require(
1598             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1599             "ERC1155: caller is not token owner nor approved"
1600         );
1601 
1602         _burnBatch(account, ids, values);
1603     }
1604 }
1605 
1606 // File: contract.sol
1607 
1608 
1609 pragma solidity ^0.8.7;
1610 
1611 
1612 contract MetaBeasts is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
1613     uint256[] public _IdsLeft;
1614     mapping(uint256 => uint256) public _Limits;
1615     mapping(uint256 => uint256) public _Mints;
1616     uint256 public _Nonce;
1617     using Counters for Counters.Counter;
1618     using ECDSA for bytes32;
1619     using Strings for uint256;
1620     uint256 public MB_TEAM_RESERVE = 250;
1621     uint256 public MB_PUBLIC = 250;
1622     uint256 public MB_PRIVATE = 2000;
1623     uint256 public MB_PUBLIC_PRICE = 0.13 ether;
1624     uint256 public MB_PRIVATE_PRICE = 0.10 ether;
1625     uint256 public MB_PER_WALLET = 2;
1626     mapping(address => uint256) public P_MINTERS;
1627 
1628     address private PRIVATE_SIGNER = 0x717aD60d9de30F63Bf75df899155C332e4552CF2;
1629     string private constant MB_SIG_WORD = "MetaBeasts_PRIVATE";
1630     bytes32 private latestHashUsed = keccak256("MetaBeasts");
1631     uint256 public publicChestsMinted;
1632     uint256 public privateChestsMinted;
1633     uint256 public teamChestsMinted;
1634 
1635     bool public privateLive;
1636     bool public publicLive;
1637     address public teamWallet = 0x8F2232D2c9480fd38570562Dc2b437c9e9c7f944;
1638 
1639     constructor() ERC1155("https://gateway.pinata.cloud/ipfs/QmWSA5jL9eNg9xgjtSbRi9Dru1uCPpZZco8xgB6NcqpZm3/{id}") {
1640         for (uint256 index = 1; index <= 100; index++) {
1641             _IdsLeft.push(index);
1642         }
1643         for (uint256 index = 1; index <= 38; index++) {
1644             _Limits[index] = 65;
1645         }
1646         for (uint256 index = 39; index <= 65; index++) {
1647             _Limits[index] = 53;
1648         }
1649         for (uint256 index = 66; index <= 85; index++) {
1650             _Limits[index] = 37;
1651         }
1652         for (uint256 index = 86; index <= 95; index++) {
1653             _Limits[index] = 30;
1654         }
1655         for (uint256 index = 96; index <= 99; index++) {
1656             _Limits[index] = 13;
1657         }
1658         _Limits[100] = 7;
1659     }
1660 
1661     modifier onlyTeam() {
1662         require(msg.sender == teamWallet, "NOT_ALLOWED");
1663         _;
1664     }
1665 
1666     modifier notContract() {
1667         require((!_isContract(msg.sender)) && (msg.sender == tx.origin), "contract not allowed");
1668         _;
1669     }
1670 
1671     function _isContract(address addr) internal view returns (bool) {
1672         uint256 size;
1673         assembly {
1674             size := extcodesize(addr)
1675         }
1676         return size > 0;
1677     }
1678 
1679     function matchAddresSigner(bytes memory signature) private view returns (bool) {
1680         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(msg.sender, MB_SIG_WORD))));
1681         return PRIVATE_SIGNER == hash.recover(signature);
1682     }
1683 
1684     function setURI(string memory newuri) public onlyTeam {
1685         _setURI(newuri);
1686     }
1687 
1688     function gift(address[] calldata receivers) external onlyTeam {
1689         require(teamChestsMinted + (receivers.length / 2) <= MB_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1690         require(receivers.length % 2 == 0, "NOT_EVEN");
1691 
1692         teamChestsMinted = teamChestsMinted + (receivers.length / 2);
1693         for (uint256 i = 0; i < receivers.length; i++) {
1694             mintRandom(receivers[i], 1);
1695         }
1696     }
1697 
1698     function founderMint(uint256 tokenQuantity) external onlyTeam {
1699         require(teamChestsMinted + (tokenQuantity / 2) <= MB_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1700         require(tokenQuantity % 2 == 0, "NOT_EVEN");
1701 
1702         teamChestsMinted = teamChestsMinted + (tokenQuantity / 2);
1703         mintRandom(msg.sender, tokenQuantity);
1704     }
1705 
1706     function giftChest(address[] calldata receivers) external onlyTeam {
1707         require(teamChestsMinted + receivers.length <= MB_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1708 
1709         teamChestsMinted = teamChestsMinted + receivers.length;
1710         for (uint256 i = 0; i < receivers.length; i++) {
1711             _mint(receivers[i], 0, 1, "");
1712         }
1713     }
1714 
1715     function founderMintChest(uint256 tokenQuantity) external onlyTeam {
1716         require(teamChestsMinted + tokenQuantity <= MB_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1717 
1718         teamChestsMinted = teamChestsMinted + tokenQuantity;
1719         _mint(msg.sender, 0, tokenQuantity, "");
1720     }
1721 
1722     function buyChests(uint256 quantity) external payable notContract {
1723         require(publicLive, "MINT_CLOSED");
1724         require(publicChestsMinted + quantity <= MB_PUBLIC, "EXCEED_PUBLIC");
1725         require(MB_PUBLIC_PRICE * quantity <= msg.value, "INSUFFICIENT_ETH");
1726 
1727         publicChestsMinted = publicChestsMinted + quantity;
1728         _mint(msg.sender, 0, quantity, "");
1729     }
1730 
1731     function buyAndOpenChests(uint256 quantity) external payable notContract {
1732         require(publicLive, "MINT_CLOSED");
1733         require(publicChestsMinted + quantity <= MB_PUBLIC, "EXCEED_PUBLIC");
1734         require(MB_PUBLIC_PRICE * quantity <= msg.value, "INSUFFICIENT_ETH");
1735 
1736         publicChestsMinted = publicChestsMinted + quantity;
1737         mintRandom(msg.sender, quantity * 2);
1738     }
1739 
1740     function privateBuy(uint256 quantity, bytes memory signature) external payable notContract {
1741         require(privateLive, "MINT_CLOSED");
1742         require(privateChestsMinted + quantity <= MB_PRIVATE, "EXCEED_PRIVATE");
1743         require(P_MINTERS[msg.sender] + quantity <= MB_PER_WALLET, "EXCEED_PER_WALLET");
1744         require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
1745         require(MB_PRIVATE_PRICE * quantity <= msg.value, "INSUFFICIENT_ETH");
1746 
1747         P_MINTERS[msg.sender] = P_MINTERS[msg.sender] + quantity;
1748         privateChestsMinted = privateChestsMinted + quantity;
1749         _mint(msg.sender, 0, quantity, "");
1750     }
1751 
1752     function privateBuyAndOpenChest(uint256 quantity, bytes memory signature) external payable notContract {
1753         require(privateLive, "MINT_CLOSED");
1754         require(privateChestsMinted + quantity <= MB_PRIVATE, "EXCEED_PRIVATE");
1755         require(P_MINTERS[msg.sender] + quantity <= MB_PER_WALLET, "EXCEED_PER_WALLET");
1756         require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
1757         require(MB_PRIVATE_PRICE * quantity <= msg.value, "INSUFFICIENT_ETH");
1758 
1759         P_MINTERS[msg.sender] = P_MINTERS[msg.sender] + quantity;
1760         privateChestsMinted = privateChestsMinted + quantity;
1761         mintRandom(msg.sender, quantity * 2);
1762     }
1763 
1764     function mintRandom(address to, uint256 quantity) private {
1765         require(_IdsLeft.length > 0, "NO_TOKEN_LEFT");
1766         require(quantity > 0, "NOT_ALLOWED");
1767         for (uint256 index = 0; index < quantity; index++) {
1768             latestHashUsed = keccak256(
1769                     abi.encodePacked(
1770                         latestHashUsed,
1771                         blockhash(block.number),
1772                         blockhash(block.number - _IdsLeft.length),
1773                         block.coinbase,
1774                         block.timestamp,
1775                         block.number,
1776                         _Nonce,
1777                         block.basefee
1778                     )
1779                 );
1780             uint256 randomIndex = uint256(latestHashUsed) % (_IdsLeft.length);
1781             uint256 randomTokenId = _IdsLeft[randomIndex];
1782             _Mints[randomTokenId]++;
1783             _Nonce++;
1784             if (_Mints[randomTokenId] == _Limits[randomTokenId]) {
1785                 _IdsLeft[randomIndex] = _IdsLeft[_IdsLeft.length - 1];
1786                 _IdsLeft.pop();
1787             }
1788             _mint(to, randomTokenId, 1, "");
1789         }
1790     }
1791 
1792     function openChests(uint256 quantity) external notContract {
1793         require(this.balanceOf(msg.sender, 0) >= quantity,"INSUFFICIENT_CHESTS");
1794 
1795         _burn(msg.sender, 0, quantity);
1796         mintRandom(msg.sender, quantity * 2);
1797     }
1798 
1799     function forge(uint256 tokenId) external notContract {
1800         require(tokenId > 0, "INVALID_ID");
1801         require(tokenId <= 200, "INVALID_ID");
1802         require(this.balanceOf(msg.sender, tokenId) >= 2, "INSUFFICIENT_CARDS");
1803 
1804         _burn(msg.sender, tokenId, 2);
1805         _mint(msg.sender, tokenId + 100, 1, "");
1806     }
1807 
1808     function totalBalanceOf(address addressToCheck) public view returns (uint256) {
1809         uint256 total = 0;
1810         for (uint256 index = 1; index <= 300; index++) {
1811             total = total + balanceOf(addressToCheck, index);
1812         }
1813         return total;
1814     }
1815 
1816     function getOwnedCards(address addressToCheck) public view returns (uint256[300] memory){
1817         uint256[300] memory cardsOwned;
1818         for (uint256 index = 0; index < 300; index++) {
1819             cardsOwned[index] = balanceOf(addressToCheck, index + 1);
1820         }
1821         return cardsOwned;
1822     }
1823     
1824     function getMintedCards() public view returns (uint256[300] memory){
1825         uint256[300] memory cardsOwned;
1826         for (uint256 index = 0; index < 300; index++) {
1827             cardsOwned[index] = totalSupply(index + 1);
1828         }
1829         return cardsOwned;
1830     }
1831 
1832     function totalCardsSupply() public view returns (uint256) {
1833         uint256 total = 0;
1834         for (uint256 index = 1; index <= 300; index++) {
1835             total = total + totalSupply(index);
1836         }
1837         return total;
1838     }
1839 
1840     function totalChestsSupply() public view returns (uint256) {
1841         return totalSupply(0);
1842     }
1843 
1844     function totalTier1Supply() public view returns (uint256) {
1845         uint256 total = 0;
1846         for (uint256 index = 1; index <= 100; index++) {
1847             total = total + totalSupply(index);
1848         }
1849         return total;
1850     }
1851 
1852     function totalTier2Supply() public view returns (uint256) {
1853         uint256 total = 0;
1854         for (uint256 index = 101; index <= 200; index++) {
1855             total = total + totalSupply(index);
1856         }
1857         return total;
1858     }
1859 
1860     function totalTier3Supply() public view returns (uint256) {
1861         uint256 total = 0;
1862         for (uint256 index = 201; index <= 300; index++) {
1863             total = total + totalSupply(index);
1864         }
1865         return total;
1866     }
1867 
1868     function togglePublicMintStatus() external onlyTeam {
1869         publicLive = !publicLive;
1870     }
1871 
1872     function togglePrivateStatus() external onlyTeam {
1873         privateLive = !privateLive;
1874     }
1875 
1876     function setPrivate(uint256 newCount) external onlyTeam {
1877         MB_PRIVATE = newCount;
1878     }
1879 
1880     function setSigner(address newSigner) external onlyTeam {
1881         PRIVATE_SIGNER = newSigner;
1882     }
1883 
1884     function setPublicPrice(uint256 newPrice) external onlyTeam {
1885         MB_PUBLIC_PRICE = newPrice;
1886     }
1887 
1888     function setPrivatePrice(uint256 newPrice) external onlyTeam {
1889         MB_PRIVATE_PRICE = newPrice;
1890     }
1891 
1892     function setTeamReserve(uint256 newCount) external onlyTeam {
1893         MB_TEAM_RESERVE = newCount;
1894     }
1895 
1896     function setPublicReserve(uint256 newCount) external onlyTeam {
1897         MB_PUBLIC = newCount;
1898     }
1899 
1900     function setNewTeamWallet(address newAddress) external onlyTeam {
1901         teamWallet = newAddress;
1902     }
1903     
1904     function withdraw() external onlyTeam {
1905         uint256 currentBalance = address(this).balance;
1906         Address.sendValue(payable(0x00000040f69B8E3382734491cBAA241B6a863AB3), currentBalance * 525 / 10000);
1907         Address.sendValue(payable(0x2007261e1c354C71cC1FC9597871D5F898339126), address(this).balance);
1908     }
1909 
1910     function _beforeTokenTransfer(
1911         address operator,
1912         address from,
1913         address to,
1914         uint256[] memory ids,
1915         uint256[] memory amounts,
1916         bytes memory data
1917     ) internal override(ERC1155, ERC1155Supply) {
1918         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1919     }
1920 }