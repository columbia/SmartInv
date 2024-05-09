1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
81  *
82  * These functions can be used to verify that a message was signed by the holder
83  * of the private keys of a given address.
84  */
85 library ECDSA {
86     enum RecoverError {
87         NoError,
88         InvalidSignature,
89         InvalidSignatureLength,
90         InvalidSignatureS,
91         InvalidSignatureV
92     }
93 
94     function _throwError(RecoverError error) private pure {
95         if (error == RecoverError.NoError) {
96             return; // no error: do nothing
97         } else if (error == RecoverError.InvalidSignature) {
98             revert("ECDSA: invalid signature");
99         } else if (error == RecoverError.InvalidSignatureLength) {
100             revert("ECDSA: invalid signature length");
101         } else if (error == RecoverError.InvalidSignatureS) {
102             revert("ECDSA: invalid signature 's' value");
103         } else if (error == RecoverError.InvalidSignatureV) {
104             revert("ECDSA: invalid signature 'v' value");
105         }
106     }
107 
108     /**
109      * @dev Returns the address that signed a hashed message (`hash`) with
110      * `signature` or error string. This address can then be used for verification purposes.
111      *
112      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
113      * this function rejects them by requiring the `s` value to be in the lower
114      * half order, and the `v` value to be either 27 or 28.
115      *
116      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
117      * verification to be secure: it is possible to craft signatures that
118      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
119      * this is by receiving a hash of the original message (which may otherwise
120      * be too long), and then calling {toEthSignedMessageHash} on it.
121      *
122      * Documentation for signature generation:
123      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
124      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
125      *
126      * _Available since v4.3._
127      */
128     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
129         // Check the signature length
130         // - case 65: r,s,v signature (standard)
131         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
132         if (signature.length == 65) {
133             bytes32 r;
134             bytes32 s;
135             uint8 v;
136             // ecrecover takes the signature parameters, and the only way to get them
137             // currently is to use assembly.
138             /// @solidity memory-safe-assembly
139             assembly {
140                 r := mload(add(signature, 0x20))
141                 s := mload(add(signature, 0x40))
142                 v := byte(0, mload(add(signature, 0x60)))
143             }
144             return tryRecover(hash, v, r, s);
145         } else if (signature.length == 64) {
146             bytes32 r;
147             bytes32 vs;
148             // ecrecover takes the signature parameters, and the only way to get them
149             // currently is to use assembly.
150             /// @solidity memory-safe-assembly
151             assembly {
152                 r := mload(add(signature, 0x20))
153                 vs := mload(add(signature, 0x40))
154             }
155             return tryRecover(hash, r, vs);
156         } else {
157             return (address(0), RecoverError.InvalidSignatureLength);
158         }
159     }
160 
161     /**
162      * @dev Returns the address that signed a hashed message (`hash`) with
163      * `signature`. This address can then be used for verification purposes.
164      *
165      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
166      * this function rejects them by requiring the `s` value to be in the lower
167      * half order, and the `v` value to be either 27 or 28.
168      *
169      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
170      * verification to be secure: it is possible to craft signatures that
171      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
172      * this is by receiving a hash of the original message (which may otherwise
173      * be too long), and then calling {toEthSignedMessageHash} on it.
174      */
175     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
176         (address recovered, RecoverError error) = tryRecover(hash, signature);
177         _throwError(error);
178         return recovered;
179     }
180 
181     /**
182      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
183      *
184      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
185      *
186      * _Available since v4.3._
187      */
188     function tryRecover(
189         bytes32 hash,
190         bytes32 r,
191         bytes32 vs
192     ) internal pure returns (address, RecoverError) {
193         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
194         uint8 v = uint8((uint256(vs) >> 255) + 27);
195         return tryRecover(hash, v, r, s);
196     }
197 
198     /**
199      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
200      *
201      * _Available since v4.2._
202      */
203     function recover(
204         bytes32 hash,
205         bytes32 r,
206         bytes32 vs
207     ) internal pure returns (address) {
208         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
209         _throwError(error);
210         return recovered;
211     }
212 
213     /**
214      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
215      * `r` and `s` signature fields separately.
216      *
217      * _Available since v4.3._
218      */
219     function tryRecover(
220         bytes32 hash,
221         uint8 v,
222         bytes32 r,
223         bytes32 s
224     ) internal pure returns (address, RecoverError) {
225         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
226         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
227         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
228         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
229         //
230         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
231         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
232         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
233         // these malleable signatures as well.
234         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
235             return (address(0), RecoverError.InvalidSignatureS);
236         }
237         if (v != 27 && v != 28) {
238             return (address(0), RecoverError.InvalidSignatureV);
239         }
240 
241         // If the signature is valid (and not malleable), return the signer address
242         address signer = ecrecover(hash, v, r, s);
243         if (signer == address(0)) {
244             return (address(0), RecoverError.InvalidSignature);
245         }
246 
247         return (signer, RecoverError.NoError);
248     }
249 
250     /**
251      * @dev Overload of {ECDSA-recover} that receives the `v`,
252      * `r` and `s` signature fields separately.
253      */
254     function recover(
255         bytes32 hash,
256         uint8 v,
257         bytes32 r,
258         bytes32 s
259     ) internal pure returns (address) {
260         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
261         _throwError(error);
262         return recovered;
263     }
264 
265     /**
266      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
267      * produces hash corresponding to the one signed with the
268      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
269      * JSON-RPC method as part of EIP-191.
270      *
271      * See {recover}.
272      */
273     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
274         // 32 is the length in bytes of hash,
275         // enforced by the type signature above
276         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
277     }
278 
279     /**
280      * @dev Returns an Ethereum Signed Message, created from `s`. This
281      * produces hash corresponding to the one signed with the
282      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
283      * JSON-RPC method as part of EIP-191.
284      *
285      * See {recover}.
286      */
287     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
288         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
289     }
290 
291     /**
292      * @dev Returns an Ethereum Signed Typed Data, created from a
293      * `domainSeparator` and a `structHash`. This produces hash corresponding
294      * to the one signed with the
295      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
296      * JSON-RPC method as part of EIP-712.
297      *
298      * See {recover}.
299      */
300     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
301         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/Context.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Provides information about the current execution context, including the
314  * sender of the transaction and its data. While these are generally available
315  * via msg.sender and msg.data, they should not be accessed in such a direct
316  * manner, since when dealing with meta-transactions the account sending and
317  * paying for execution may not be the actual sender (as far as an application
318  * is concerned).
319  *
320  * This contract is only required for intermediate, library-like contracts.
321  */
322 abstract contract Context {
323     function _msgSender() internal view virtual returns (address) {
324         return msg.sender;
325     }
326 
327     function _msgData() internal view virtual returns (bytes calldata) {
328         return msg.data;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/access/Ownable.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 
340 /**
341  * @dev Contract module which provides a basic access control mechanism, where
342  * there is an account (an owner) that can be granted exclusive access to
343  * specific functions.
344  *
345  * By default, the owner account will be the one that deploys the contract. This
346  * can later be changed with {transferOwnership}.
347  *
348  * This module is used through inheritance. It will make available the modifier
349  * `onlyOwner`, which can be applied to your functions to restrict their use to
350  * the owner.
351  */
352 abstract contract Ownable is Context {
353     address private _owner;
354 
355     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
356 
357     /**
358      * @dev Initializes the contract setting the deployer as the initial owner.
359      */
360     constructor() {
361         _transferOwnership(_msgSender());
362     }
363 
364     /**
365      * @dev Returns the address of the current owner.
366      */
367     function owner() public view virtual returns (address) {
368         return _owner;
369     }
370 
371     /**
372      * @dev Throws if called by any account other than the owner.
373      */
374     modifier onlyOwner() {
375         require(owner() == _msgSender(), "Ownable: caller is not the owner");
376         _;
377     }
378 
379     /**
380      * @dev Leaves the contract without owner. It will not be possible to call
381      * `onlyOwner` functions anymore. Can only be called by the current owner.
382      *
383      * NOTE: Renouncing ownership will leave the contract without an owner,
384      * thereby removing any functionality that is only available to the owner.
385      */
386     function renounceOwnership() public virtual onlyOwner {
387         _transferOwnership(address(0));
388     }
389 
390     /**
391      * @dev Transfers ownership of the contract to a new account (`newOwner`).
392      * Can only be called by the current owner.
393      */
394     function transferOwnership(address newOwner) public virtual onlyOwner {
395         require(newOwner != address(0), "Ownable: new owner is the zero address");
396         _transferOwnership(newOwner);
397     }
398 
399     /**
400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
401      * Internal function without access restriction.
402      */
403     function _transferOwnership(address newOwner) internal virtual {
404         address oldOwner = _owner;
405         _owner = newOwner;
406         emit OwnershipTransferred(oldOwner, newOwner);
407     }
408 }
409 
410 // File: @openzeppelin/contracts/utils/Address.sol
411 
412 
413 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
414 
415 pragma solidity ^0.8.1;
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * [IMPORTANT]
425      * ====
426      * It is unsafe to assume that an address for which this function returns
427      * false is an externally-owned account (EOA) and not a contract.
428      *
429      * Among others, `isContract` will return false for the following
430      * types of addresses:
431      *
432      *  - an externally-owned account
433      *  - a contract in construction
434      *  - an address where a contract will be created
435      *  - an address where a contract lived, but was destroyed
436      * ====
437      *
438      * [IMPORTANT]
439      * ====
440      * You shouldn't rely on `isContract` to protect against flash loan attacks!
441      *
442      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
443      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
444      * constructor.
445      * ====
446      */
447     function isContract(address account) internal view returns (bool) {
448         // This method relies on extcodesize/address.code.length, which returns 0
449         // for contracts in construction, since the code is only stored at the end
450         // of the constructor execution.
451 
452         return account.code.length > 0;
453     }
454 
455     /**
456      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
457      * `recipient`, forwarding all available gas and reverting on errors.
458      *
459      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
460      * of certain opcodes, possibly making contracts go over the 2300 gas limit
461      * imposed by `transfer`, making them unable to receive funds via
462      * `transfer`. {sendValue} removes this limitation.
463      *
464      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
465      *
466      * IMPORTANT: because control is transferred to `recipient`, care must be
467      * taken to not create reentrancy vulnerabilities. Consider using
468      * {ReentrancyGuard} or the
469      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         (bool success, ) = recipient.call{value: amount}("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain `call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, 0, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but also transferring `value` wei to `target`.
517      *
518      * Requirements:
519      *
520      * - the calling contract must have an ETH balance of at least `value`.
521      * - the called Solidity function must be `payable`.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(
540         address target,
541         bytes memory data,
542         uint256 value,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.call{value: value}(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
559         return functionStaticCall(target, data, "Address: low-level static call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal view returns (bytes memory) {
573         require(isContract(target), "Address: static call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.staticcall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(isContract(target), "Address: delegate call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.delegatecall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
608      * revert reason using the provided one.
609      *
610      * _Available since v4.3._
611      */
612     function verifyCallResult(
613         bool success,
614         bytes memory returndata,
615         string memory errorMessage
616     ) internal pure returns (bytes memory) {
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623 
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @title ERC721 token receiver interface
644  * @dev Interface for any contract that wants to support safeTransfers
645  * from ERC721 asset contracts.
646  */
647 interface IERC721Receiver {
648     /**
649      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
650      * by `operator` from `from`, this function is called.
651      *
652      * It must return its Solidity selector to confirm the token transfer.
653      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
654      *
655      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
656      */
657     function onERC721Received(
658         address operator,
659         address from,
660         uint256 tokenId,
661         bytes calldata data
662     ) external returns (bytes4);
663 }
664 
665 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev Interface of the ERC165 standard, as defined in the
674  * https://eips.ethereum.org/EIPS/eip-165[EIP].
675  *
676  * Implementers can declare support of contract interfaces, which can then be
677  * queried by others ({ERC165Checker}).
678  *
679  * For an implementation, see {ERC165}.
680  */
681 interface IERC165 {
682     /**
683      * @dev Returns true if this contract implements the interface defined by
684      * `interfaceId`. See the corresponding
685      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
686      * to learn more about how these ids are created.
687      *
688      * This function call must use less than 30 000 gas.
689      */
690     function supportsInterface(bytes4 interfaceId) external view returns (bool);
691 }
692 
693 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Implementation of the {IERC165} interface.
703  *
704  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
705  * for the additional interface id that will be supported. For example:
706  *
707  * ```solidity
708  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
710  * }
711  * ```
712  *
713  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
714  */
715 abstract contract ERC165 is IERC165 {
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720         return interfaceId == type(IERC165).interfaceId;
721     }
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev Required interface of an ERC721 compliant contract.
734  */
735 interface IERC721 is IERC165 {
736     /**
737      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
738      */
739     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
740 
741     /**
742      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
743      */
744     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
745 
746     /**
747      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
748      */
749     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
750 
751     /**
752      * @dev Returns the number of tokens in ``owner``'s account.
753      */
754     function balanceOf(address owner) external view returns (uint256 balance);
755 
756     /**
757      * @dev Returns the owner of the `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function ownerOf(uint256 tokenId) external view returns (address owner);
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes calldata data
783     ) external;
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Transfers `tokenId` token from `from` to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
827      * The approval is cleared when the token is transferred.
828      *
829      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
830      *
831      * Requirements:
832      *
833      * - The caller must own the token or be an approved operator.
834      * - `tokenId` must exist.
835      *
836      * Emits an {Approval} event.
837      */
838     function approve(address to, uint256 tokenId) external;
839 
840     /**
841      * @dev Approve or remove `operator` as an operator for the caller.
842      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
843      *
844      * Requirements:
845      *
846      * - The `operator` cannot be the caller.
847      *
848      * Emits an {ApprovalForAll} event.
849      */
850     function setApprovalForAll(address operator, bool _approved) external;
851 
852     /**
853      * @dev Returns the account approved for `tokenId` token.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function getApproved(uint256 tokenId) external view returns (address operator);
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}
865      */
866     function isApprovedForAll(address owner, address operator) external view returns (bool);
867 }
868 
869 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
870 
871 
872 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**
878  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
879  * @dev See https://eips.ethereum.org/EIPS/eip-721
880  */
881 interface IERC721Enumerable is IERC721 {
882     /**
883      * @dev Returns the total amount of tokens stored by the contract.
884      */
885     function totalSupply() external view returns (uint256);
886 
887     /**
888      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
889      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
890      */
891     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
892 
893     /**
894      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
895      * Use along with {totalSupply} to enumerate all tokens.
896      */
897     function tokenByIndex(uint256 index) external view returns (uint256);
898 }
899 
900 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 
908 /**
909  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
910  * @dev See https://eips.ethereum.org/EIPS/eip-721
911  */
912 interface IERC721Metadata is IERC721 {
913     /**
914      * @dev Returns the token collection name.
915      */
916     function name() external view returns (string memory);
917 
918     /**
919      * @dev Returns the token collection symbol.
920      */
921     function symbol() external view returns (string memory);
922 
923     /**
924      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
925      */
926     function tokenURI(uint256 tokenId) external view returns (string memory);
927 }
928 
929 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
930 
931 
932 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 
939 
940 
941 
942 
943 /**
944  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
945  * the Metadata extension, but not including the Enumerable extension, which is available separately as
946  * {ERC721Enumerable}.
947  */
948 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
949     using Address for address;
950     using Strings for uint256;
951 
952     // Token name
953     string private _name;
954 
955     // Token symbol
956     string private _symbol;
957 
958     // Mapping from token ID to owner address
959     mapping(uint256 => address) private _owners;
960 
961     // Mapping owner address to token count
962     mapping(address => uint256) private _balances;
963 
964     // Mapping from token ID to approved address
965     mapping(uint256 => address) private _tokenApprovals;
966 
967     // Mapping from owner to operator approvals
968     mapping(address => mapping(address => bool)) private _operatorApprovals;
969 
970     /**
971      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
972      */
973     constructor(string memory name_, string memory symbol_) {
974         _name = name_;
975         _symbol = symbol_;
976     }
977 
978     /**
979      * @dev See {IERC165-supportsInterface}.
980      */
981     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
982         return
983             interfaceId == type(IERC721).interfaceId ||
984             interfaceId == type(IERC721Metadata).interfaceId ||
985             super.supportsInterface(interfaceId);
986     }
987 
988     /**
989      * @dev See {IERC721-balanceOf}.
990      */
991     function balanceOf(address owner) public view virtual override returns (uint256) {
992         require(owner != address(0), "ERC721: balance query for the zero address");
993         return _balances[owner];
994     }
995 
996     /**
997      * @dev See {IERC721-ownerOf}.
998      */
999     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1000         address owner = _owners[tokenId];
1001         require(owner != address(0), "ERC721: owner query for nonexistent token");
1002         return owner;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-name}.
1007      */
1008     function name() public view virtual override returns (string memory) {
1009         return _name;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-symbol}.
1014      */
1015     function symbol() public view virtual override returns (string memory) {
1016         return _symbol;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-tokenURI}.
1021      */
1022     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1023         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1024 
1025         string memory baseURI = _baseURI();
1026         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1027     }
1028 
1029     /**
1030      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1031      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1032      * by default, can be overridden in child contracts.
1033      */
1034     function _baseURI() internal view virtual returns (string memory) {
1035         return "";
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-approve}.
1040      */
1041     function approve(address to, uint256 tokenId) public virtual override {
1042         address owner = ERC721.ownerOf(tokenId);
1043         require(to != owner, "ERC721: approval to current owner");
1044 
1045         require(
1046             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1047             "ERC721: approve caller is not owner nor approved for all"
1048         );
1049 
1050         _approve(to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-getApproved}.
1055      */
1056     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1057         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1058 
1059         return _tokenApprovals[tokenId];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-setApprovalForAll}.
1064      */
1065     function setApprovalForAll(address operator, bool approved) public virtual override {
1066         _setApprovalForAll(_msgSender(), operator, approved);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-isApprovedForAll}.
1071      */
1072     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1073         return _operatorApprovals[owner][operator];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-transferFrom}.
1078      */
1079     function transferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) public virtual override {
1084         //solhint-disable-next-line max-line-length
1085         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1086 
1087         _transfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-safeTransferFrom}.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) public virtual override {
1098         safeTransferFrom(from, to, tokenId, "");
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) public virtual override {
1110         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1111         _safeTransfer(from, to, tokenId, _data);
1112     }
1113 
1114     /**
1115      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1116      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1117      *
1118      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1119      *
1120      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1121      * implement alternative mechanisms to perform token transfer, such as signature-based.
1122      *
1123      * Requirements:
1124      *
1125      * - `from` cannot be the zero address.
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must exist and be owned by `from`.
1128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _safeTransfer(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) internal virtual {
1138         _transfer(from, to, tokenId);
1139         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1140     }
1141 
1142     /**
1143      * @dev Returns whether `tokenId` exists.
1144      *
1145      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1146      *
1147      * Tokens start existing when they are minted (`_mint`),
1148      * and stop existing when they are burned (`_burn`).
1149      */
1150     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1151         return _owners[tokenId] != address(0);
1152     }
1153 
1154     /**
1155      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must exist.
1160      */
1161     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1162         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1163         address owner = ERC721.ownerOf(tokenId);
1164         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1165     }
1166 
1167     /**
1168      * @dev Safely mints `tokenId` and transfers it to `to`.
1169      *
1170      * Requirements:
1171      *
1172      * - `tokenId` must not exist.
1173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _safeMint(address to, uint256 tokenId) internal virtual {
1178         _safeMint(to, tokenId, "");
1179     }
1180 
1181     /**
1182      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1183      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1184      */
1185     function _safeMint(
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) internal virtual {
1190         _mint(to, tokenId);
1191         require(
1192             _checkOnERC721Received(address(0), to, tokenId, _data),
1193             "ERC721: transfer to non ERC721Receiver implementer"
1194         );
1195     }
1196 
1197     /**
1198      * @dev Mints `tokenId` and transfers it to `to`.
1199      *
1200      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must not exist.
1205      * - `to` cannot be the zero address.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _mint(address to, uint256 tokenId) internal virtual {
1210         require(to != address(0), "ERC721: mint to the zero address");
1211         require(!_exists(tokenId), "ERC721: token already minted");
1212 
1213         _beforeTokenTransfer(address(0), to, tokenId);
1214 
1215         _balances[to] += 1;
1216         _owners[tokenId] = to;
1217 
1218         emit Transfer(address(0), to, tokenId);
1219 
1220         _afterTokenTransfer(address(0), to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Destroys `tokenId`.
1225      * The approval is cleared when the token is burned.
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must exist.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _burn(uint256 tokenId) internal virtual {
1234         address owner = ERC721.ownerOf(tokenId);
1235 
1236         _beforeTokenTransfer(owner, address(0), tokenId);
1237 
1238         // Clear approvals
1239         _approve(address(0), tokenId);
1240 
1241         _balances[owner] -= 1;
1242         delete _owners[tokenId];
1243 
1244         emit Transfer(owner, address(0), tokenId);
1245 
1246         _afterTokenTransfer(owner, address(0), tokenId);
1247     }
1248 
1249     /**
1250      * @dev Transfers `tokenId` from `from` to `to`.
1251      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1252      *
1253      * Requirements:
1254      *
1255      * - `to` cannot be the zero address.
1256      * - `tokenId` token must be owned by `from`.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _transfer(
1261         address from,
1262         address to,
1263         uint256 tokenId
1264     ) internal virtual {
1265         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1266         require(to != address(0), "ERC721: transfer to the zero address");
1267 
1268         _beforeTokenTransfer(from, to, tokenId);
1269 
1270         // Clear approvals from the previous owner
1271         _approve(address(0), tokenId);
1272 
1273         _balances[from] -= 1;
1274         _balances[to] += 1;
1275         _owners[tokenId] = to;
1276 
1277         emit Transfer(from, to, tokenId);
1278 
1279         _afterTokenTransfer(from, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Approve `to` to operate on `tokenId`
1284      *
1285      * Emits a {Approval} event.
1286      */
1287     function _approve(address to, uint256 tokenId) internal virtual {
1288         _tokenApprovals[tokenId] = to;
1289         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev Approve `operator` to operate on all of `owner` tokens
1294      *
1295      * Emits a {ApprovalForAll} event.
1296      */
1297     function _setApprovalForAll(
1298         address owner,
1299         address operator,
1300         bool approved
1301     ) internal virtual {
1302         require(owner != operator, "ERC721: approve to caller");
1303         _operatorApprovals[owner][operator] = approved;
1304         emit ApprovalForAll(owner, operator, approved);
1305     }
1306 
1307     /**
1308      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1309      * The call is not executed if the target address is not a contract.
1310      *
1311      * @param from address representing the previous owner of the given token ID
1312      * @param to target address that will receive the tokens
1313      * @param tokenId uint256 ID of the token to be transferred
1314      * @param _data bytes optional data to send along with the call
1315      * @return bool whether the call correctly returned the expected magic value
1316      */
1317     function _checkOnERC721Received(
1318         address from,
1319         address to,
1320         uint256 tokenId,
1321         bytes memory _data
1322     ) private returns (bool) {
1323         if (to.isContract()) {
1324             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1325                 return retval == IERC721Receiver.onERC721Received.selector;
1326             } catch (bytes memory reason) {
1327                 if (reason.length == 0) {
1328                     revert("ERC721: transfer to non ERC721Receiver implementer");
1329                 } else {
1330                     assembly {
1331                         revert(add(32, reason), mload(reason))
1332                     }
1333                 }
1334             }
1335         } else {
1336             return true;
1337         }
1338     }
1339 
1340     /**
1341      * @dev Hook that is called before any token transfer. This includes minting
1342      * and burning.
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` will be minted for `to`.
1349      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1350      * - `from` and `to` are never both zero.
1351      *
1352      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1353      */
1354     function _beforeTokenTransfer(
1355         address from,
1356         address to,
1357         uint256 tokenId
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after any transfer of tokens. This includes
1362      * minting and burning.
1363      *
1364      * Calling conditions:
1365      *
1366      * - when `from` and `to` are both non-zero.
1367      * - `from` and `to` are never both zero.
1368      *
1369      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1370      */
1371     function _afterTokenTransfer(
1372         address from,
1373         address to,
1374         uint256 tokenId
1375     ) internal virtual {}
1376 }
1377 
1378 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1379 
1380 
1381 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 
1386 /**
1387  * @dev ERC721 token with storage based token URI management.
1388  */
1389 abstract contract ERC721URIStorage is ERC721 {
1390     using Strings for uint256;
1391 
1392     // Optional mapping for token URIs
1393     mapping(uint256 => string) private _tokenURIs;
1394 
1395     /**
1396      * @dev See {IERC721Metadata-tokenURI}.
1397      */
1398     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1399         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1400 
1401         string memory _tokenURI = _tokenURIs[tokenId];
1402         string memory base = _baseURI();
1403 
1404         // If there is no base URI, return the token URI.
1405         if (bytes(base).length == 0) {
1406             return _tokenURI;
1407         }
1408         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1409         if (bytes(_tokenURI).length > 0) {
1410             return string(abi.encodePacked(base, _tokenURI));
1411         }
1412 
1413         return super.tokenURI(tokenId);
1414     }
1415 
1416     /**
1417      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must exist.
1422      */
1423     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1424         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1425         _tokenURIs[tokenId] = _tokenURI;
1426     }
1427 
1428     /**
1429      * @dev Destroys `tokenId`.
1430      * The approval is cleared when the token is burned.
1431      *
1432      * Requirements:
1433      *
1434      * - `tokenId` must exist.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function _burn(uint256 tokenId) internal virtual override {
1439         super._burn(tokenId);
1440 
1441         if (bytes(_tokenURIs[tokenId]).length != 0) {
1442             delete _tokenURIs[tokenId];
1443         }
1444     }
1445 }
1446 
1447 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1448 
1449 
1450 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 
1455 
1456 /**
1457  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1458  * enumerability of all the token ids in the contract as well as all token ids owned by each
1459  * account.
1460  */
1461 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1462     // Mapping from owner to list of owned token IDs
1463     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1464 
1465     // Mapping from token ID to index of the owner tokens list
1466     mapping(uint256 => uint256) private _ownedTokensIndex;
1467 
1468     // Array with all token ids, used for enumeration
1469     uint256[] private _allTokens;
1470 
1471     // Mapping from token id to position in the allTokens array
1472     mapping(uint256 => uint256) private _allTokensIndex;
1473 
1474     /**
1475      * @dev See {IERC165-supportsInterface}.
1476      */
1477     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1478         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1479     }
1480 
1481     /**
1482      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1483      */
1484     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1485         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1486         return _ownedTokens[owner][index];
1487     }
1488 
1489     /**
1490      * @dev See {IERC721Enumerable-totalSupply}.
1491      */
1492     function totalSupply() public view virtual override returns (uint256) {
1493         return _allTokens.length;
1494     }
1495 
1496     /**
1497      * @dev See {IERC721Enumerable-tokenByIndex}.
1498      */
1499     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1500         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1501         return _allTokens[index];
1502     }
1503 
1504     /**
1505      * @dev Hook that is called before any token transfer. This includes minting
1506      * and burning.
1507      *
1508      * Calling conditions:
1509      *
1510      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1511      * transferred to `to`.
1512      * - When `from` is zero, `tokenId` will be minted for `to`.
1513      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1514      * - `from` cannot be the zero address.
1515      * - `to` cannot be the zero address.
1516      *
1517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1518      */
1519     function _beforeTokenTransfer(
1520         address from,
1521         address to,
1522         uint256 tokenId
1523     ) internal virtual override {
1524         super._beforeTokenTransfer(from, to, tokenId);
1525 
1526         if (from == address(0)) {
1527             _addTokenToAllTokensEnumeration(tokenId);
1528         } else if (from != to) {
1529             _removeTokenFromOwnerEnumeration(from, tokenId);
1530         }
1531         if (to == address(0)) {
1532             _removeTokenFromAllTokensEnumeration(tokenId);
1533         } else if (to != from) {
1534             _addTokenToOwnerEnumeration(to, tokenId);
1535         }
1536     }
1537 
1538     /**
1539      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1540      * @param to address representing the new owner of the given token ID
1541      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1542      */
1543     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1544         uint256 length = ERC721.balanceOf(to);
1545         _ownedTokens[to][length] = tokenId;
1546         _ownedTokensIndex[tokenId] = length;
1547     }
1548 
1549     /**
1550      * @dev Private function to add a token to this extension's token tracking data structures.
1551      * @param tokenId uint256 ID of the token to be added to the tokens list
1552      */
1553     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1554         _allTokensIndex[tokenId] = _allTokens.length;
1555         _allTokens.push(tokenId);
1556     }
1557 
1558     /**
1559      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1560      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1561      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1562      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1563      * @param from address representing the previous owner of the given token ID
1564      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1565      */
1566     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1567         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1568         // then delete the last slot (swap and pop).
1569 
1570         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1571         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1572 
1573         // When the token to delete is the last token, the swap operation is unnecessary
1574         if (tokenIndex != lastTokenIndex) {
1575             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1576 
1577             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1578             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1579         }
1580 
1581         // This also deletes the contents at the last position of the array
1582         delete _ownedTokensIndex[tokenId];
1583         delete _ownedTokens[from][lastTokenIndex];
1584     }
1585 
1586     /**
1587      * @dev Private function to remove a token from this extension's token tracking data structures.
1588      * This has O(1) time complexity, but alters the order of the _allTokens array.
1589      * @param tokenId uint256 ID of the token to be removed from the tokens list
1590      */
1591     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1592         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1593         // then delete the last slot (swap and pop).
1594 
1595         uint256 lastTokenIndex = _allTokens.length - 1;
1596         uint256 tokenIndex = _allTokensIndex[tokenId];
1597 
1598         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1599         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1600         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1601         uint256 lastTokenId = _allTokens[lastTokenIndex];
1602 
1603         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1604         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1605 
1606         // This also deletes the contents at the last position of the array
1607         delete _allTokensIndex[tokenId];
1608         _allTokens.pop();
1609     }
1610 }
1611 
1612 // File: contracts/BTC_BOT.sol
1613 
1614 
1615 pragma solidity ^0.8.4;
1616 
1617 
1618 
1619 
1620 
1621 
1622 contract BTC_BOT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
1623     string private fooo;
1624     using ECDSA for bytes32;
1625     address private _systemAddress;
1626     mapping(string => bool) public _usedNonces;
1627 
1628     
1629     constructor() ERC721("BTC BOT", "BTC_BOT") { }
1630 
1631     function safeMint(uint256 tokenId, string memory uri, string memory nonce, bytes32 hash, bytes memory signature) public payable {
1632         require(matchSigner(hash, signature), "Please mint through website");
1633         require(!_usedNonces[nonce], "Hash reused");
1634         require( hashTransaction(msg.sender, tokenId, nonce) == hash, "Hash failed");
1635         _usedNonces[nonce] = true;
1636         
1637         _safeMint(msg.sender, tokenId);
1638         _setTokenURI(tokenId, uri);
1639     }
1640 
1641     function multiMint(uint[] memory ids, string[] memory uris, string memory nonce, bytes32 hash, bytes memory signature) public payable {
1642         require(matchSigner(hash, signature), "Please mint through website");
1643         require(!_usedNonces[nonce], "Hash reused");
1644         require(hashTransaction(msg.sender, ids[0], nonce) == hash, "Hash failed");
1645         _usedNonces[nonce] = true;
1646 
1647         for (uint256 i = 0; i < ids.length; i++) {
1648             _safeMint(msg.sender, ids[i]);
1649             _setTokenURI(ids[i], uris[i]);
1650         }
1651     }
1652 
1653     function matchSigner(bytes32 hash, bytes memory signature) public view returns (bool) {
1654         return _systemAddress == hash.toEthSignedMessageHash().recover(signature);
1655     }
1656 
1657     function hashTransaction(
1658         address sender,
1659         uint256 tokenId,
1660         string memory nonce
1661     ) public view returns (bytes32) {
1662         bytes32 hash = keccak256( abi.encodePacked(sender, tokenId, nonce, address(this)) );
1663         return hash;
1664     }
1665 
1666     function setSystemAddress() public onlyOwner {
1667         _systemAddress = msg.sender;
1668     }
1669 
1670     function updateTokenURI(uint256 tokenId, string memory urii) public onlyOwner {
1671         _setTokenURI(tokenId, urii);
1672     }
1673 
1674     // The following functions are overrides required by Solidity.
1675     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1676         super._beforeTokenTransfer(from, to, tokenId);
1677     }
1678 
1679     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1680         super._burn(tokenId);
1681     }
1682 
1683     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1684         return super.tokenURI(tokenId);
1685     }
1686 
1687     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1688         return super.supportsInterface(interfaceId);
1689     }
1690 }