1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 
87 /**
88  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
89  *
90  * These functions can be used to verify that a message was signed by the holder
91  * of the private keys of a given address.
92  */
93 library ECDSA {
94     enum RecoverError {
95         NoError,
96         InvalidSignature,
97         InvalidSignatureLength,
98         InvalidSignatureS,
99         InvalidSignatureV
100     }
101 
102     function _throwError(RecoverError error) private pure {
103         if (error == RecoverError.NoError) {
104             return; // no error: do nothing
105         } else if (error == RecoverError.InvalidSignature) {
106             revert("ECDSA: invalid signature");
107         } else if (error == RecoverError.InvalidSignatureLength) {
108             revert("ECDSA: invalid signature length");
109         } else if (error == RecoverError.InvalidSignatureS) {
110             revert("ECDSA: invalid signature 's' value");
111         } else if (error == RecoverError.InvalidSignatureV) {
112             revert("ECDSA: invalid signature 'v' value");
113         }
114     }
115 
116     /**
117      * @dev Returns the address that signed a hashed message (`hash`) with
118      * `signature` or error string. This address can then be used for verification purposes.
119      *
120      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
121      * this function rejects them by requiring the `s` value to be in the lower
122      * half order, and the `v` value to be either 27 or 28.
123      *
124      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
125      * verification to be secure: it is possible to craft signatures that
126      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
127      * this is by receiving a hash of the original message (which may otherwise
128      * be too long), and then calling {toEthSignedMessageHash} on it.
129      *
130      * Documentation for signature generation:
131      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
132      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
133      *
134      * _Available since v4.3._
135      */
136     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
137         if (signature.length == 65) {
138             bytes32 r;
139             bytes32 s;
140             uint8 v;
141             // ecrecover takes the signature parameters, and the only way to get them
142             // currently is to use assembly.
143             /// @solidity memory-safe-assembly
144             assembly {
145                 r := mload(add(signature, 0x20))
146                 s := mload(add(signature, 0x40))
147                 v := byte(0, mload(add(signature, 0x60)))
148             }
149             return tryRecover(hash, v, r, s);
150         } else {
151             return (address(0), RecoverError.InvalidSignatureLength);
152         }
153     }
154 
155     /**
156      * @dev Returns the address that signed a hashed message (`hash`) with
157      * `signature`. This address can then be used for verification purposes.
158      *
159      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
160      * this function rejects them by requiring the `s` value to be in the lower
161      * half order, and the `v` value to be either 27 or 28.
162      *
163      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
164      * verification to be secure: it is possible to craft signatures that
165      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
166      * this is by receiving a hash of the original message (which may otherwise
167      * be too long), and then calling {toEthSignedMessageHash} on it.
168      */
169     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
170         (address recovered, RecoverError error) = tryRecover(hash, signature);
171         _throwError(error);
172         return recovered;
173     }
174 
175     /**
176      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
177      *
178      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
179      *
180      * _Available since v4.3._
181      */
182     function tryRecover(
183         bytes32 hash,
184         bytes32 r,
185         bytes32 vs
186     ) internal pure returns (address, RecoverError) {
187         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
188         uint8 v = uint8((uint256(vs) >> 255) + 27);
189         return tryRecover(hash, v, r, s);
190     }
191 
192     /**
193      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
194      *
195      * _Available since v4.2._
196      */
197     function recover(
198         bytes32 hash,
199         bytes32 r,
200         bytes32 vs
201     ) internal pure returns (address) {
202         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
203         _throwError(error);
204         return recovered;
205     }
206 
207     /**
208      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
209      * `r` and `s` signature fields separately.
210      *
211      * _Available since v4.3._
212      */
213     function tryRecover(
214         bytes32 hash,
215         uint8 v,
216         bytes32 r,
217         bytes32 s
218     ) internal pure returns (address, RecoverError) {
219         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
220         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
221         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
222         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
223         //
224         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
225         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
226         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
227         // these malleable signatures as well.
228         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
229             return (address(0), RecoverError.InvalidSignatureS);
230         }
231         if (v != 27 && v != 28) {
232             return (address(0), RecoverError.InvalidSignatureV);
233         }
234 
235         // If the signature is valid (and not malleable), return the signer address
236         address signer = ecrecover(hash, v, r, s);
237         if (signer == address(0)) {
238             return (address(0), RecoverError.InvalidSignature);
239         }
240 
241         return (signer, RecoverError.NoError);
242     }
243 
244     /**
245      * @dev Overload of {ECDSA-recover} that receives the `v`,
246      * `r` and `s` signature fields separately.
247      */
248     function recover(
249         bytes32 hash,
250         uint8 v,
251         bytes32 r,
252         bytes32 s
253     ) internal pure returns (address) {
254         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
255         _throwError(error);
256         return recovered;
257     }
258 
259     /**
260      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
261      * produces hash corresponding to the one signed with the
262      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
263      * JSON-RPC method as part of EIP-191.
264      *
265      * See {recover}.
266      */
267     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
268         // 32 is the length in bytes of hash,
269         // enforced by the type signature above
270         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
271     }
272 
273     /**
274      * @dev Returns an Ethereum Signed Message, created from `s`. This
275      * produces hash corresponding to the one signed with the
276      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
277      * JSON-RPC method as part of EIP-191.
278      *
279      * See {recover}.
280      */
281     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
282         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
283     }
284 
285     /**
286      * @dev Returns an Ethereum Signed Typed Data, created from a
287      * `domainSeparator` and a `structHash`. This produces hash corresponding
288      * to the one signed with the
289      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
290      * JSON-RPC method as part of EIP-712.
291      *
292      * See {recover}.
293      */
294     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
295         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/Context.sol
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Provides information about the current execution context, including the
308  * sender of the transaction and its data. While these are generally available
309  * via msg.sender and msg.data, they should not be accessed in such a direct
310  * manner, since when dealing with meta-transactions the account sending and
311  * paying for execution may not be the actual sender (as far as an application
312  * is concerned).
313  *
314  * This contract is only required for intermediate, library-like contracts.
315  */
316 abstract contract Context {
317     function _msgSender() internal view virtual returns (address) {
318         return msg.sender;
319     }
320 
321     function _msgData() internal view virtual returns (bytes calldata) {
322         return msg.data;
323     }
324 }
325 
326 // File: @openzeppelin/contracts/access/Ownable.sol
327 
328 
329 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 
334 /**
335  * @dev Contract module which provides a basic access control mechanism, where
336  * there is an account (an owner) that can be granted exclusive access to
337  * specific functions.
338  *
339  * By default, the owner account will be the one that deploys the contract. This
340  * can later be changed with {transferOwnership}.
341  *
342  * This module is used through inheritance. It will make available the modifier
343  * `onlyOwner`, which can be applied to your functions to restrict their use to
344  * the owner.
345  */
346 abstract contract Ownable is Context {
347     address private _owner;
348 
349     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
350 
351     /**
352      * @dev Initializes the contract setting the deployer as the initial owner.
353      */
354     constructor() {
355         _transferOwnership(_msgSender());
356     }
357 
358     /**
359      * @dev Throws if called by any account other than the owner.
360      */
361     modifier onlyOwner() {
362         _checkOwner();
363         _;
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view virtual returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if the sender is not the owner.
375      */
376     function _checkOwner() internal view virtual {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378     }
379 
380     /**
381      * @dev Leaves the contract without owner. It will not be possible to call
382      * `onlyOwner` functions anymore. Can only be called by the current owner.
383      *
384      * NOTE: Renouncing ownership will leave the contract without an owner,
385      * thereby removing any functionality that is only available to the owner.
386      */
387     function renounceOwnership() public virtual onlyOwner {
388         _transferOwnership(address(0));
389     }
390 
391     /**
392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
393      * Can only be called by the current owner.
394      */
395     function transferOwnership(address newOwner) public virtual onlyOwner {
396         require(newOwner != address(0), "Ownable: new owner is the zero address");
397         _transferOwnership(newOwner);
398     }
399 
400     /**
401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
402      * Internal function without access restriction.
403      */
404     function _transferOwnership(address newOwner) internal virtual {
405         address oldOwner = _owner;
406         _owner = newOwner;
407         emit OwnershipTransferred(oldOwner, newOwner);
408     }
409 }
410 
411 // File: @openzeppelin/contracts/utils/Address.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
415 
416 pragma solidity ^0.8.1;
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * [IMPORTANT]
426      * ====
427      * It is unsafe to assume that an address for which this function returns
428      * false is an externally-owned account (EOA) and not a contract.
429      *
430      * Among others, `isContract` will return false for the following
431      * types of addresses:
432      *
433      *  - an externally-owned account
434      *  - a contract in construction
435      *  - an address where a contract will be created
436      *  - an address where a contract lived, but was destroyed
437      * ====
438      *
439      * [IMPORTANT]
440      * ====
441      * You shouldn't rely on `isContract` to protect against flash loan attacks!
442      *
443      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
444      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
445      * constructor.
446      * ====
447      */
448     function isContract(address account) internal view returns (bool) {
449         // This method relies on extcodesize/address.code.length, which returns 0
450         // for contracts in construction, since the code is only stored at the end
451         // of the constructor execution.
452 
453         return account.code.length > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         (bool success, ) = recipient.call{value: amount}("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 
479     /**
480      * @dev Performs a Solidity function call using a low level `call`. A
481      * plain `call` is an unsafe replacement for a function call: use this
482      * function instead.
483      *
484      * If `target` reverts with a revert reason, it is bubbled up by this
485      * function (like regular Solidity function calls).
486      *
487      * Returns the raw returned data. To convert to the expected return value,
488      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
489      *
490      * Requirements:
491      *
492      * - `target` must be a contract.
493      * - calling `target` with `data` must not revert.
494      *
495      * _Available since v3.1._
496      */
497     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionCall(target, data, "Address: low-level call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
503      * `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, 0, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but also transferring `value` wei to `target`.
518      *
519      * Requirements:
520      *
521      * - the calling contract must have an ETH balance of at least `value`.
522      * - the called Solidity function must be `payable`.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
536      * with `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(address(this).balance >= value, "Address: insufficient balance for call");
547         require(isContract(target), "Address: call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.call{value: value}(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
560         return functionStaticCall(target, data, "Address: low-level static call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal view returns (bytes memory) {
574         require(isContract(target), "Address: static call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.staticcall(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
587         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a delegate call.
593      *
594      * _Available since v3.4._
595      */
596     function functionDelegateCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(isContract(target), "Address: delegate call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.delegatecall(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
609      * revert reason using the provided one.
610      *
611      * _Available since v4.3._
612      */
613     function verifyCallResult(
614         bool success,
615         bytes memory returndata,
616         string memory errorMessage
617     ) internal pure returns (bytes memory) {
618         if (success) {
619             return returndata;
620         } else {
621             // Look for revert reason and bubble it up if present
622             if (returndata.length > 0) {
623                 // The easiest way to bubble the revert reason is using memory via assembly
624                 /// @solidity memory-safe-assembly
625                 assembly {
626                     let returndata_size := mload(returndata)
627                     revert(add(32, returndata), returndata_size)
628                 }
629             } else {
630                 revert(errorMessage);
631             }
632         }
633     }
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @title ERC721 token receiver interface
645  * @dev Interface for any contract that wants to support safeTransfers
646  * from ERC721 asset contracts.
647  */
648 interface IERC721Receiver {
649     /**
650      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
651      * by `operator` from `from`, this function is called.
652      *
653      * It must return its Solidity selector to confirm the token transfer.
654      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
655      *
656      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
657      */
658     function onERC721Received(
659         address operator,
660         address from,
661         uint256 tokenId,
662         bytes calldata data
663     ) external returns (bytes4);
664 }
665 
666 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Interface of the ERC165 standard, as defined in the
675  * https://eips.ethereum.org/EIPS/eip-165[EIP].
676  *
677  * Implementers can declare support of contract interfaces, which can then be
678  * queried by others ({ERC165Checker}).
679  *
680  * For an implementation, see {ERC165}.
681  */
682 interface IERC165 {
683     /**
684      * @dev Returns true if this contract implements the interface defined by
685      * `interfaceId`. See the corresponding
686      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
687      * to learn more about how these ids are created.
688      *
689      * This function call must use less than 30 000 gas.
690      */
691     function supportsInterface(bytes4 interfaceId) external view returns (bool);
692 }
693 
694 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 
702 /**
703  * @dev Implementation of the {IERC165} interface.
704  *
705  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
706  * for the additional interface id that will be supported. For example:
707  *
708  * ```solidity
709  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
710  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
711  * }
712  * ```
713  *
714  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
715  */
716 abstract contract ERC165 is IERC165 {
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
721         return interfaceId == type(IERC165).interfaceId;
722     }
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
726 
727 
728 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 /**
734  * @dev Required interface of an ERC721 compliant contract.
735  */
736 interface IERC721 is IERC165 {
737     /**
738      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
739      */
740     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
744      */
745     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
746 
747     /**
748      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
749      */
750     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
751 
752     /**
753      * @dev Returns the number of tokens in ``owner``'s account.
754      */
755     function balanceOf(address owner) external view returns (uint256 balance);
756 
757     /**
758      * @dev Returns the owner of the `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function ownerOf(uint256 tokenId) external view returns (address owner);
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes calldata data
784     ) external;
785 
786     /**
787      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
788      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Transfers `tokenId` token from `from` to `to`.
808      *
809      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must be owned by `from`.
816      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
817      *
818      * Emits a {Transfer} event.
819      */
820     function transferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) external;
825 
826     /**
827      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
828      * The approval is cleared when the token is transferred.
829      *
830      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
831      *
832      * Requirements:
833      *
834      * - The caller must own the token or be an approved operator.
835      * - `tokenId` must exist.
836      *
837      * Emits an {Approval} event.
838      */
839     function approve(address to, uint256 tokenId) external;
840 
841     /**
842      * @dev Approve or remove `operator` as an operator for the caller.
843      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
844      *
845      * Requirements:
846      *
847      * - The `operator` cannot be the caller.
848      *
849      * Emits an {ApprovalForAll} event.
850      */
851     function setApprovalForAll(address operator, bool _approved) external;
852 
853     /**
854      * @dev Returns the account approved for `tokenId` token.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      */
860     function getApproved(uint256 tokenId) external view returns (address operator);
861 
862     /**
863      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
864      *
865      * See {setApprovalForAll}
866      */
867     function isApprovedForAll(address owner, address operator) external view returns (bool);
868 }
869 
870 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
871 
872 
873 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
874 
875 pragma solidity ^0.8.0;
876 
877 
878 /**
879  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
880  * @dev See https://eips.ethereum.org/EIPS/eip-721
881  */
882 interface IERC721Metadata is IERC721 {
883     /**
884      * @dev Returns the token collection name.
885      */
886     function name() external view returns (string memory);
887 
888     /**
889      * @dev Returns the token collection symbol.
890      */
891     function symbol() external view returns (string memory);
892 
893     /**
894      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
895      */
896     function tokenURI(uint256 tokenId) external view returns (string memory);
897 }
898 
899 // File: contracts/ERC721A.sol
900 
901 
902 // Creator: Chiru Labs
903 // Version: 3.2.0
904 
905 pragma solidity ^0.8.4;
906 
907 
908 
909 
910 
911 
912 
913 
914 error ApprovalCallerNotOwnerNorApproved();
915 error ApprovalQueryForNonexistentToken();
916 error ApproveToCaller();
917 error ApprovalToCurrentOwner();
918 error BalanceQueryForZeroAddress();
919 error MintToZeroAddress();
920 error MintZeroQuantity();
921 error OwnerQueryForNonexistentToken();
922 error TransferCallerNotOwnerNorApproved();
923 error TransferFromIncorrectOwner();
924 error TransferToNonERC721ReceiverImplementer();
925 error TransferToZeroAddress();
926 error URIQueryForNonexistentToken();
927 
928 /**
929  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
930  * the Metadata extension. Built to optimize for lower gas during batch mints.
931  *
932  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
933  *
934  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
935  *
936  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
937  */
938 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
939     using Address for address;
940     using Strings for uint256;
941 
942     // Compiler will pack this into a single 256bit word.
943     struct TokenOwnership {
944         // The address of the owner.
945         address addr;
946         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
947         uint64 startTimestamp;
948         // Whether the token has been burned.
949         bool burned;
950     }
951 
952     // Compiler will pack this into a single 256bit word.
953     struct AddressData {
954         // Realistically, 2**64-1 is more than enough.
955         uint64 balance;
956         // Keeps track of mint count with minimal overhead for tokenomics.
957         uint64 numberMinted;
958         // Keeps track of burn count with minimal overhead for tokenomics.
959         uint32 numberBurned;
960 
961         uint32 mintedDay1;
962         uint32 mintedDay2;
963         uint32 mintedFree;
964         uint32 mintedPublic;
965     }
966 
967     // The tokenId of the next token to be minted.
968     uint256 internal _currentIndex;
969 
970     // The number of tokens burned.
971     uint256 internal _burnCounter;
972 
973     // Token name
974     string private _name;
975 
976     // Token symbol
977     string private _symbol;
978 
979     // Mapping from token ID to ownership details
980     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
981     mapping(uint256 => TokenOwnership) internal _ownerships;
982 
983     // Mapping owner address to address data
984     mapping(address => AddressData) private _addressData;
985 
986     // Mapping from token ID to approved address
987     mapping(uint256 => address) private _tokenApprovals;
988 
989     // Mapping from owner to operator approvals
990     mapping(address => mapping(address => bool)) private _operatorApprovals;
991 
992     constructor(string memory name_, string memory symbol_) {
993         _name = name_;
994         _symbol = symbol_;
995         _currentIndex = _startTokenId();
996     }
997 
998     /**
999      * To change the starting tokenId, please override this function.
1000      */
1001     function _startTokenId() internal view virtual returns (uint256) {
1002         return 1;
1003     }
1004 
1005     /**
1006      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1007      */
1008     function totalSupply() public view returns (uint256) {
1009         // Counter underflow is impossible as _burnCounter cannot be incremented
1010         // more than _currentIndex - _startTokenId() times
1011         unchecked {
1012             return _currentIndex - _burnCounter - _startTokenId();
1013         }
1014     }
1015 
1016     /**
1017      * Returns the total amount of tokens minted in the contract.
1018      */
1019     function _totalMinted() internal view returns (uint256) {
1020         // Counter underflow is impossible as _currentIndex does not decrement,
1021         // and it is initialized to _startTokenId()
1022         unchecked {
1023             return _currentIndex - _startTokenId();
1024         }
1025     }
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1031         return
1032             interfaceId == type(IERC721).interfaceId ||
1033             interfaceId == type(IERC721Metadata).interfaceId ||
1034             super.supportsInterface(interfaceId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-balanceOf}.
1039      */
1040     function balanceOf(address owner) public view override returns (uint256) {
1041         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1042         return uint256(_addressData[owner].balance);
1043     }
1044 
1045     /**
1046      * Returns the number of tokens minted by `owner`.
1047      */
1048     function numberMinted(address owner) public view returns (uint256) {
1049         return uint256(_addressData[owner].numberMinted);
1050     }
1051 
1052     /**
1053      * Returns the number of tokens burned by or on behalf of `owner`.
1054      */
1055     function _numberBurned(address owner) internal view returns (uint256) {
1056         return uint256(_addressData[owner].numberBurned);
1057     }
1058 
1059     /**
1060      * Mint data handlers
1061      */
1062     function getMintData(address owner) external view returns (uint mintedDay1, uint mintedDay2, uint mintedFree, uint mintedPublic) {
1063         AddressData memory addressData = _addressData[owner];
1064         return (addressData.mintedDay1, addressData.mintedDay2, addressData.mintedFree, addressData.mintedPublic);
1065     }
1066 
1067     function _addToMintDay1(address owner, uint32 amount) internal returns(uint32 newValue) {
1068         return (_addressData[owner].mintedDay1 += amount);
1069     }
1070 
1071     function _addToMintDay2(address owner, uint32 amount) internal returns(uint32 newValue) {
1072         return (_addressData[owner].mintedDay2 += amount);
1073     }
1074 
1075     function _addToMintFree(address owner, uint32 amount) internal returns(uint32 newValue) {
1076        return  (_addressData[owner].mintedFree += amount);
1077     }
1078 
1079     function _addToMintPublic(address owner, uint32 amount) internal returns(uint32 newValue) {
1080        return  (_addressData[owner].mintedPublic += amount);
1081     }
1082 
1083     /**
1084      * Gas spent here starts off proportional to the maximum mint batch size.
1085      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1086      */
1087     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1088         uint256 curr = tokenId;
1089 
1090         unchecked {
1091             if (_startTokenId() <= curr && curr < _currentIndex) {
1092                 TokenOwnership memory ownership = _ownerships[curr];
1093                 if (!ownership.burned) {
1094                     if (ownership.addr != address(0)) {
1095                         return ownership;
1096                     }
1097                     // Invariant:
1098                     // There will always be an ownership that has an address and is not burned
1099                     // before an ownership that does not have an address and is not burned.
1100                     // Hence, curr will not underflow.
1101                     while (true) {
1102                         curr--;
1103                         ownership = _ownerships[curr];
1104                         if (ownership.addr != address(0)) {
1105                             return ownership;
1106                         }
1107                     }
1108                 }
1109             }
1110         }
1111         revert OwnerQueryForNonexistentToken();
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-ownerOf}.
1116      */
1117     function ownerOf(uint256 tokenId) public view override returns (address) {
1118         return _ownershipOf(tokenId).addr;
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Metadata-name}.
1123      */
1124     function name() public view virtual override returns (string memory) {
1125         return _name;
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Metadata-symbol}.
1130      */
1131     function symbol() public view virtual override returns (string memory) {
1132         return _symbol;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Metadata-tokenURI}.
1137      */
1138     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1139         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1140 
1141         string memory baseURI = _baseURI();
1142         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1143     }
1144 
1145     /**
1146      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1147      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1148      * by default, can be overriden in child contracts.
1149      */
1150     function _baseURI() internal view virtual returns (string memory) {
1151         return '';
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-approve}.
1156      */
1157     function approve(address to, uint256 tokenId) public override {
1158         address owner = ERC721A.ownerOf(tokenId);
1159         if (to == owner) revert ApprovalToCurrentOwner();
1160 
1161         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1162             revert ApprovalCallerNotOwnerNorApproved();
1163         }
1164 
1165         _approve(to, tokenId, owner);
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-getApproved}.
1170      */
1171     function getApproved(uint256 tokenId) public view override returns (address) {
1172         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1173 
1174         return _tokenApprovals[tokenId];
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-setApprovalForAll}.
1179      */
1180     function setApprovalForAll(address operator, bool approved) public virtual override {
1181         if (operator == _msgSender()) revert ApproveToCaller();
1182 
1183         _operatorApprovals[_msgSender()][operator] = approved;
1184         emit ApprovalForAll(_msgSender(), operator, approved);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-isApprovedForAll}.
1189      */
1190     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1191         return _operatorApprovals[owner][operator];
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-transferFrom}.
1196      */
1197     function transferFrom(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) public virtual override {
1202         _transfer(from, to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-safeTransferFrom}.
1207      */
1208     function safeTransferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) public virtual override {
1213         safeTransferFrom(from, to, tokenId, '');
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-safeTransferFrom}.
1218      */
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) public virtual override {
1225         _transfer(from, to, tokenId);
1226         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1227             revert TransferToNonERC721ReceiverImplementer();
1228         }
1229     }
1230 
1231     /**
1232      * @dev Returns whether `tokenId` exists.
1233      *
1234      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1235      *
1236      * Tokens start existing when they are minted (`_mint`),
1237      */
1238     function _exists(uint256 tokenId) internal view returns (bool) {
1239         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1240     }
1241 
1242     /**
1243      * @dev Mints `quantity` tokens and transfers them to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - `to` cannot be the zero address.
1248      * - `quantity` must be greater than 0.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _mint(
1253         address to,
1254         uint256 quantity
1255     ) internal {
1256         uint256 startTokenId = _currentIndex;
1257         if (to == address(0)) revert MintToZeroAddress();
1258         if (quantity == 0) revert MintZeroQuantity();
1259 
1260         // Overflows are incredibly unrealistic.
1261         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1262         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1263         unchecked {
1264             _addressData[to].balance += uint64(quantity);
1265             _addressData[to].numberMinted += uint64(quantity);
1266 
1267             _ownerships[startTokenId].addr = to;
1268             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1269 
1270             uint256 updatedIndex = startTokenId;
1271             uint256 end = updatedIndex + quantity;
1272 
1273             do {
1274                 emit Transfer(address(0), to, updatedIndex++);
1275             } while (updatedIndex != end);
1276             _currentIndex = updatedIndex;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Transfers `tokenId` from `from` to `to`.
1282      *
1283      * Requirements:
1284      *
1285      * - `to` cannot be the zero address.
1286      * - `tokenId` token must be owned by `from`.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _transfer(
1291         address from,
1292         address to,
1293         uint256 tokenId
1294     ) private {
1295         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1296 
1297         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1298 
1299         bool isApprovedOrOwner = (_msgSender() == from ||
1300             isApprovedForAll(from, _msgSender()) ||
1301             getApproved(tokenId) == _msgSender());
1302 
1303         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1304         if (to == address(0)) revert TransferToZeroAddress();
1305 
1306         // Clear approvals from the previous owner
1307         _approve(address(0), tokenId, from);
1308 
1309         // Underflow of the sender's balance is impossible because we check for
1310         // ownership above and the recipient's balance can't realistically overflow.
1311         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1312         unchecked {
1313             _addressData[from].balance -= 1;
1314             _addressData[to].balance += 1;
1315 
1316             TokenOwnership storage currSlot = _ownerships[tokenId];
1317             currSlot.addr = to;
1318             currSlot.startTimestamp = uint64(block.timestamp);
1319 
1320             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1321             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1322             uint256 nextTokenId = tokenId + 1;
1323             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1324             if (nextSlot.addr == address(0)) {
1325                 // This will suffice for checking _exists(nextTokenId),
1326                 // as a burned slot cannot contain the zero address.
1327                 if (nextTokenId != _currentIndex) {
1328                     nextSlot.addr = from;
1329                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1330                 }
1331             }
1332         }
1333 
1334         emit Transfer(from, to, tokenId);
1335     }
1336 
1337     /**
1338      * @dev This is equivalent to _burn(tokenId, false)
1339      */
1340     function _burn(uint256 tokenId) internal virtual {
1341         _burn(tokenId, false);
1342     }
1343 
1344     /**
1345      * @dev Destroys `tokenId`.
1346      * The approval is cleared when the token is burned.
1347      *
1348      * Requirements:
1349      *
1350      * - `tokenId` must exist.
1351      *
1352      * Emits a {Transfer} event.
1353      */
1354     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1355         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1356 
1357         address from = prevOwnership.addr;
1358 
1359         if (approvalCheck) {
1360             bool isApprovedOrOwner = (_msgSender() == from ||
1361                 isApprovedForAll(from, _msgSender()) ||
1362                 getApproved(tokenId) == _msgSender());
1363 
1364             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1365         }
1366 
1367         // Clear approvals from the previous owner
1368         _approve(address(0), tokenId, from);
1369 
1370         // Underflow of the sender's balance is impossible because we check for
1371         // ownership above and the recipient's balance can't realistically overflow.
1372         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1373         unchecked {
1374             AddressData storage addressData = _addressData[from];
1375             addressData.balance -= 1;
1376             addressData.numberBurned += 1;
1377 
1378             // Keep track of who burned the token, and the timestamp of burning.
1379             TokenOwnership storage currSlot = _ownerships[tokenId];
1380             currSlot.addr = from;
1381             currSlot.startTimestamp = uint64(block.timestamp);
1382             currSlot.burned = true;
1383 
1384             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1385             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1386             uint256 nextTokenId = tokenId + 1;
1387             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1388             if (nextSlot.addr == address(0)) {
1389                 // This will suffice for checking _exists(nextTokenId),
1390                 // as a burned slot cannot contain the zero address.
1391                 if (nextTokenId != _currentIndex) {
1392                     nextSlot.addr = from;
1393                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1394                 }
1395             }
1396         }
1397 
1398         emit Transfer(from, address(0), tokenId);
1399 
1400         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1401         unchecked {
1402             _burnCounter++;
1403         }
1404     }
1405 
1406     /**
1407      * @dev Approve `to` to operate on `tokenId`
1408      *
1409      * Emits a {Approval} event.
1410      */
1411     function _approve(
1412         address to,
1413         uint256 tokenId,
1414         address owner
1415     ) private {
1416         _tokenApprovals[tokenId] = to;
1417         emit Approval(owner, to, tokenId);
1418     }
1419 
1420     /**
1421      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1422      *
1423      * @param from address representing the previous owner of the given token ID
1424      * @param to target address that will receive the tokens
1425      * @param tokenId uint256 ID of the token to be transferred
1426      * @param _data bytes optional data to send along with the call
1427      * @return bool whether the call correctly returned the expected magic value
1428      */
1429     function _checkContractOnERC721Received(
1430         address from,
1431         address to,
1432         uint256 tokenId,
1433         bytes memory _data
1434     ) private returns (bool) {
1435         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1436             return retval == IERC721Receiver(to).onERC721Received.selector;
1437         } catch (bytes memory reason) {
1438             if (reason.length == 0) {
1439                 revert TransferToNonERC721ReceiverImplementer();
1440             } else {
1441                 assembly {
1442                     revert(add(32, reason), mload(reason))
1443                 }
1444             }
1445         }
1446     }
1447 }
1448 // File: contracts/ERC721ALowCap.sol
1449 
1450 
1451 // Creator: Chiru Labs
1452 
1453 pragma solidity ^0.8.4;
1454 
1455 
1456 /**
1457  * @title ERC721A Low Cap
1458  * @dev ERC721A Helper functions for Low Cap (<= 10,000) totalSupply.
1459  */
1460 abstract contract ERC721ALowCap is ERC721A {
1461     /**
1462      * @dev Returns the tokenIds of the address. O(totalSupply) in complexity.
1463      */
1464     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1465         uint256 holdingAmount = balanceOf(owner);
1466         uint256 currSupply = _currentIndex;
1467         uint256 tokenIdsIdx;
1468         address currOwnershipAddr;
1469 
1470         uint256[] memory list = new uint256[](holdingAmount);
1471 
1472         unchecked {
1473             for (uint256 i = _startTokenId(); i < currSupply; ++i) {
1474                 TokenOwnership memory ownership = _ownerships[i];
1475 
1476                 if (ownership.burned) {
1477                     continue;
1478                 }
1479 
1480                 // Find out who owns this sequence
1481                 if (ownership.addr != address(0)) {
1482                     currOwnershipAddr = ownership.addr;
1483                 }
1484 
1485                 // Append tokens the last found owner owns in the sequence
1486                 if (currOwnershipAddr == owner) {
1487                     list[tokenIdsIdx++] = i;
1488                 }
1489 
1490                 // All tokens have been found, we don't need to keep searching
1491                 if (tokenIdsIdx == holdingAmount) {
1492                     break;
1493                 }
1494             }
1495         }
1496 
1497         return list;
1498     }
1499 }
1500 // File: contracts/MULTIVERS3.sol
1501 
1502 
1503 pragma solidity ^0.8.4;
1504 
1505 
1506 
1507 
1508 
1509 
1510 contract multivers3 is Ownable, ERC721A, ERC721ALowCap {
1511     // To concatenate the URL of an NFT
1512     using Strings for uint;
1513     // To verify mint signatures
1514     using ECDSA for bytes32;
1515 
1516     enum SaleDay { CLOSED, PRESALE_DAY_1, PRESALE_DAY_2, PUBLIC }
1517 
1518     // Used to disallow contracts from sending multiple mint transactions in one tx
1519     modifier directOnly {
1520         require(msg.sender == tx.origin);
1521         _;
1522     }
1523 
1524     // Constants
1525 
1526     uint constant public cost = 0.00 ether;
1527     uint constant public maxMintSupply = 2600;
1528     uint constant public FreeMintMaxSupply = 2600;
1529    // uint public publicMaxSupply = maxMintSupply - FreeMintMaxSupply;  // Used for public and whitelist mints
1530     uint constant public maxTxMintAmount = 4;
1531     uint constant public publicMaxTxMintAmount = 1;
1532 
1533 // add Mapping List publicMinters qui permettra d'eviter d'avoir plus d'un mint par addresse pendant le public mint
1534 //MODIF MAP
1535     address constant signer = 0xE68be8d5788646A3c9FD61fEc32C2dF27e23FE46;
1536 
1537     // Storage Variables
1538 
1539     uint public FreeMintSupplyMinted = 0;
1540 
1541     string public baseURI;
1542 
1543     bool public isFreeMintActive;
1544 
1545     /*
1546      * Values go in the order they are defined in the Enum
1547      * 0: CLOSED
1548      * 1: PRESALE_DAY_1
1549      * 2: PRESALE_DAY_2
1550      * 3: PUBLIC
1551      */
1552     SaleDay public saleDay;
1553 
1554 
1555     constructor(string memory _theBaseURI)
1556         Ownable()
1557         ERC721A(unicode"MULTIVERS3", "MULTIVERS3")
1558 
1559     {
1560         baseURI = _theBaseURI;
1561     }
1562 
1563     // Minting
1564 
1565     function freeMint(address to, uint32 amountToMint, uint maxMintsFree, uint8 v, bytes32 r, bytes32 s) external directOnly {
1566         require(isFreeMintActive, "Free mint is not active");
1567 
1568         // Mint amount limits
1569         require(amountToMint > 0 && _addToMintFree(msg.sender, amountToMint) <= maxMintsFree, "Sorry, invalid amount");
1570         require((FreeMintSupplyMinted += amountToMint) <= FreeMintMaxSupply, "Sorry, not enough NFTs remaining to mint");
1571 
1572         // Signature verification
1573         require(_verifySignature(keccak256(abi.encodePacked("multivers3Free", msg.sender, maxMintsFree)), v, r, s), "Invalid sig");
1574 
1575         // Split mints in batches of `maxTxMintAmount` to avoid having large gas-consuming loops when transfering or selling tokens
1576         uint mintedSoFar = 0;
1577         do {
1578             uint batchAmount = min(amountToMint - mintedSoFar, maxTxMintAmount);
1579             mintedSoFar += batchAmount;
1580             _mint(to, batchAmount);
1581         } while(mintedSoFar < amountToMint);
1582     }
1583 
1584     function ownerMint(address to, uint32 amountToMint) external onlyOwner {
1585 
1586         // Mint amount limits
1587         require(amountToMint > 0,"Sorry, invalid amount");
1588         require((FreeMintSupplyMinted += amountToMint) <= FreeMintMaxSupply, "Sorry, not enough NFTs remaining to mint");
1589 
1590         // Split mints in batches of `maxTxMintAmount` to avoid having large gas-consuming loops when transfering or selling tokens
1591         uint mintedSoFar = 0;
1592         do {
1593             uint batchAmount = min(amountToMint - mintedSoFar, maxTxMintAmount);
1594             mintedSoFar += batchAmount;
1595             _mint(to, batchAmount);
1596         } while(mintedSoFar < amountToMint);
1597     }
1598 
1599     function publicMint(uint32 amountToMint) external payable directOnly {
1600         require(saleDay == SaleDay.PUBLIC, "Sorry, public sale is not active");
1601         require(amountToMint > 0 && _addToMintPublic(msg.sender, amountToMint) <= publicMaxTxMintAmount, "Sorry, invalid amount");
1602 
1603         require(_totalMinted() + amountToMint <= maxMintSupply, "Sorry, not enough NFTs remaining to mint");
1604 
1605         // ETH sent verification
1606         require(msg.value >= cost * amountToMint);
1607 
1608         uint mintedSoFar = 0;
1609         do {
1610             uint batchAmount = min(amountToMint - mintedSoFar, publicMaxTxMintAmount);
1611             mintedSoFar += batchAmount;
1612             _mint(msg.sender, batchAmount);
1613         } while(mintedSoFar < amountToMint);
1614     }
1615 
1616     // View Only
1617 
1618     function tokenURI(uint _nftId) public view override returns (string memory) {
1619         require(_exists(_nftId), "This NFT doesn't exist");
1620 
1621         return string(abi.encodePacked(baseURI, _nftId.toString(), ".json"));
1622     }
1623 
1624     // Only Owner Functions
1625 
1626     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1627         baseURI = _newBaseURI;
1628     }
1629 
1630     function setMintDay(SaleDay day) external onlyOwner {
1631         saleDay = day;
1632     }
1633 
1634     function toggleFreeMintStatus() external onlyOwner {
1635         isFreeMintActive = !isFreeMintActive;
1636     }
1637 
1638     function _verifySignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns(bool) {
1639         return hash.toEthSignedMessageHash().recover(v, r, s) == signer;
1640     }
1641 
1642     function min(uint a,uint b) internal pure returns(uint) {
1643         return a < b ? a : b;
1644     }
1645 
1646 }