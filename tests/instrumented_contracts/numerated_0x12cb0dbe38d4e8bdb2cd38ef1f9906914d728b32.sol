1 // File: @openzeppelin/contracts@4.4.2/utils/Strings.sol
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
71 // File: @openzeppelin/contracts@4.4.2/utils/cryptography/ECDSA.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
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
138             assembly {
139                 r := mload(add(signature, 0x20))
140                 s := mload(add(signature, 0x40))
141                 v := byte(0, mload(add(signature, 0x60)))
142             }
143             return tryRecover(hash, v, r, s);
144         } else if (signature.length == 64) {
145             bytes32 r;
146             bytes32 vs;
147             // ecrecover takes the signature parameters, and the only way to get them
148             // currently is to use assembly.
149             assembly {
150                 r := mload(add(signature, 0x20))
151                 vs := mload(add(signature, 0x40))
152             }
153             return tryRecover(hash, r, vs);
154         } else {
155             return (address(0), RecoverError.InvalidSignatureLength);
156         }
157     }
158 
159     /**
160      * @dev Returns the address that signed a hashed message (`hash`) with
161      * `signature`. This address can then be used for verification purposes.
162      *
163      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
164      * this function rejects them by requiring the `s` value to be in the lower
165      * half order, and the `v` value to be either 27 or 28.
166      *
167      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
168      * verification to be secure: it is possible to craft signatures that
169      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
170      * this is by receiving a hash of the original message (which may otherwise
171      * be too long), and then calling {toEthSignedMessageHash} on it.
172      */
173     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
174         (address recovered, RecoverError error) = tryRecover(hash, signature);
175         _throwError(error);
176         return recovered;
177     }
178 
179     /**
180      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
181      *
182      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
183      *
184      * _Available since v4.3._
185      */
186     function tryRecover(
187         bytes32 hash,
188         bytes32 r,
189         bytes32 vs
190     ) internal pure returns (address, RecoverError) {
191         bytes32 s;
192         uint8 v;
193         assembly {
194             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
195             v := add(shr(255, vs), 27)
196         }
197         return tryRecover(hash, v, r, s);
198     }
199 
200     /**
201      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
202      *
203      * _Available since v4.2._
204      */
205     function recover(
206         bytes32 hash,
207         bytes32 r,
208         bytes32 vs
209     ) internal pure returns (address) {
210         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
211         _throwError(error);
212         return recovered;
213     }
214 
215     /**
216      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
217      * `r` and `s` signature fields separately.
218      *
219      * _Available since v4.3._
220      */
221     function tryRecover(
222         bytes32 hash,
223         uint8 v,
224         bytes32 r,
225         bytes32 s
226     ) internal pure returns (address, RecoverError) {
227         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
228         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
229         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
230         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
231         //
232         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
233         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
234         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
235         // these malleable signatures as well.
236         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
237             return (address(0), RecoverError.InvalidSignatureS);
238         }
239         if (v != 27 && v != 28) {
240             return (address(0), RecoverError.InvalidSignatureV);
241         }
242 
243         // If the signature is valid (and not malleable), return the signer address
244         address signer = ecrecover(hash, v, r, s);
245         if (signer == address(0)) {
246             return (address(0), RecoverError.InvalidSignature);
247         }
248 
249         return (signer, RecoverError.NoError);
250     }
251 
252     /**
253      * @dev Overload of {ECDSA-recover} that receives the `v`,
254      * `r` and `s` signature fields separately.
255      */
256     function recover(
257         bytes32 hash,
258         uint8 v,
259         bytes32 r,
260         bytes32 s
261     ) internal pure returns (address) {
262         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
263         _throwError(error);
264         return recovered;
265     }
266 
267     /**
268      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
269      * produces hash corresponding to the one signed with the
270      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
271      * JSON-RPC method as part of EIP-191.
272      *
273      * See {recover}.
274      */
275     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
276         // 32 is the length in bytes of hash,
277         // enforced by the type signature above
278         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
279     }
280 
281     /**
282      * @dev Returns an Ethereum Signed Message, created from `s`. This
283      * produces hash corresponding to the one signed with the
284      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
285      * JSON-RPC method as part of EIP-191.
286      *
287      * See {recover}.
288      */
289     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
290         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
291     }
292 
293     /**
294      * @dev Returns an Ethereum Signed Typed Data, created from a
295      * `domainSeparator` and a `structHash`. This produces hash corresponding
296      * to the one signed with the
297      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
298      * JSON-RPC method as part of EIP-712.
299      *
300      * See {recover}.
301      */
302     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
303         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
304     }
305 }
306 
307 // File: @openzeppelin/contracts@4.4.2/utils/Context.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Provides information about the current execution context, including the
316  * sender of the transaction and its data. While these are generally available
317  * via msg.sender and msg.data, they should not be accessed in such a direct
318  * manner, since when dealing with meta-transactions the account sending and
319  * paying for execution may not be the actual sender (as far as an application
320  * is concerned).
321  *
322  * This contract is only required for intermediate, library-like contracts.
323  */
324 abstract contract Context {
325     function _msgSender() internal view virtual returns (address) {
326         return msg.sender;
327     }
328 
329     function _msgData() internal view virtual returns (bytes calldata) {
330         return msg.data;
331     }
332 }
333 
334 // File: @openzeppelin/contracts@4.4.2/access/Ownable.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor() {
363         _transferOwnership(_msgSender());
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
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         _transferOwnership(address(0));
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      * Can only be called by the current owner.
395      */
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(newOwner != address(0), "Ownable: new owner is the zero address");
398         _transferOwnership(newOwner);
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Internal function without access restriction.
404      */
405     function _transferOwnership(address newOwner) internal virtual {
406         address oldOwner = _owner;
407         _owner = newOwner;
408         emit OwnershipTransferred(oldOwner, newOwner);
409     }
410 }
411 
412 // File: @openzeppelin/contracts@4.4.2/utils/Address.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 /**
420  * @dev Collection of functions related to the address type
421  */
422 library Address {
423     /**
424      * @dev Returns true if `account` is a contract.
425      *
426      * [IMPORTANT]
427      * ====
428      * It is unsafe to assume that an address for which this function returns
429      * false is an externally-owned account (EOA) and not a contract.
430      *
431      * Among others, `isContract` will return false for the following
432      * types of addresses:
433      *
434      *  - an externally-owned account
435      *  - a contract in construction
436      *  - an address where a contract will be created
437      *  - an address where a contract lived, but was destroyed
438      * ====
439      */
440     function isContract(address account) internal view returns (bool) {
441         // This method relies on extcodesize, which returns 0 for contracts in
442         // construction, since the code is only stored at the end of the
443         // constructor execution.
444 
445         uint256 size;
446         assembly {
447             size := extcodesize(account)
448         }
449         return size > 0;
450     }
451 
452     /**
453      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
454      * `recipient`, forwarding all available gas and reverting on errors.
455      *
456      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
457      * of certain opcodes, possibly making contracts go over the 2300 gas limit
458      * imposed by `transfer`, making them unable to receive funds via
459      * `transfer`. {sendValue} removes this limitation.
460      *
461      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
462      *
463      * IMPORTANT: because control is transferred to `recipient`, care must be
464      * taken to not create reentrancy vulnerabilities. Consider using
465      * {ReentrancyGuard} or the
466      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
467      */
468     function sendValue(address payable recipient, uint256 amount) internal {
469         require(address(this).balance >= amount, "Address: insufficient balance");
470 
471         (bool success, ) = recipient.call{value: amount}("");
472         require(success, "Address: unable to send value, recipient may have reverted");
473     }
474 
475     /**
476      * @dev Performs a Solidity function call using a low level `call`. A
477      * plain `call` is an unsafe replacement for a function call: use this
478      * function instead.
479      *
480      * If `target` reverts with a revert reason, it is bubbled up by this
481      * function (like regular Solidity function calls).
482      *
483      * Returns the raw returned data. To convert to the expected return value,
484      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
485      *
486      * Requirements:
487      *
488      * - `target` must be a contract.
489      * - calling `target` with `data` must not revert.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
494         return functionCall(target, data, "Address: low-level call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
499      * `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(
504         address target,
505         bytes memory data,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, 0, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but also transferring `value` wei to `target`.
514      *
515      * Requirements:
516      *
517      * - the calling contract must have an ETH balance of at least `value`.
518      * - the called Solidity function must be `payable`.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(
523         address target,
524         bytes memory data,
525         uint256 value
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
532      * with `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCallWithValue(
537         address target,
538         bytes memory data,
539         uint256 value,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         require(address(this).balance >= value, "Address: insufficient balance for call");
543         require(isContract(target), "Address: call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.call{value: value}(data);
546         return verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
556         return functionStaticCall(target, data, "Address: low-level static call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal view returns (bytes memory) {
570         require(isContract(target), "Address: static call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.staticcall(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
583         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         require(isContract(target), "Address: delegate call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.delegatecall(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
605      * revert reason using the provided one.
606      *
607      * _Available since v4.3._
608      */
609     function verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) internal pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             // Look for revert reason and bubble it up if present
618             if (returndata.length > 0) {
619                 // The easiest way to bubble the revert reason is using memory via assembly
620 
621                 assembly {
622                     let returndata_size := mload(returndata)
623                     revert(add(32, returndata), returndata_size)
624                 }
625             } else {
626                 revert(errorMessage);
627             }
628         }
629     }
630 }
631 
632 // File: @openzeppelin/contracts@4.4.2/token/ERC721/IERC721Receiver.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @title ERC721 token receiver interface
641  * @dev Interface for any contract that wants to support safeTransfers
642  * from ERC721 asset contracts.
643  */
644 interface IERC721Receiver {
645     /**
646      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
647      * by `operator` from `from`, this function is called.
648      *
649      * It must return its Solidity selector to confirm the token transfer.
650      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
651      *
652      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
653      */
654     function onERC721Received(
655         address operator,
656         address from,
657         uint256 tokenId,
658         bytes calldata data
659     ) external returns (bytes4);
660 }
661 
662 // File: @openzeppelin/contracts@4.4.2/utils/introspection/IERC165.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev Interface of the ERC165 standard, as defined in the
671  * https://eips.ethereum.org/EIPS/eip-165[EIP].
672  *
673  * Implementers can declare support of contract interfaces, which can then be
674  * queried by others ({ERC165Checker}).
675  *
676  * For an implementation, see {ERC165}.
677  */
678 interface IERC165 {
679     /**
680      * @dev Returns true if this contract implements the interface defined by
681      * `interfaceId`. See the corresponding
682      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
683      * to learn more about how these ids are created.
684      *
685      * This function call must use less than 30 000 gas.
686      */
687     function supportsInterface(bytes4 interfaceId) external view returns (bool);
688 }
689 
690 // File: @openzeppelin/contracts@4.4.2/utils/introspection/ERC165.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @dev Implementation of the {IERC165} interface.
700  *
701  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
702  * for the additional interface id that will be supported. For example:
703  *
704  * ```solidity
705  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
707  * }
708  * ```
709  *
710  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
711  */
712 abstract contract ERC165 is IERC165 {
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717         return interfaceId == type(IERC165).interfaceId;
718     }
719 }
720 
721 // File: @openzeppelin/contracts@4.4.2/token/ERC721/IERC721.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @dev Required interface of an ERC721 compliant contract.
731  */
732 interface IERC721 is IERC165 {
733     /**
734      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
735      */
736     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
740      */
741     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
742 
743     /**
744      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
747 
748     /**
749      * @dev Returns the number of tokens in ``owner``'s account.
750      */
751     function balanceOf(address owner) external view returns (uint256 balance);
752 
753     /**
754      * @dev Returns the owner of the `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function ownerOf(uint256 tokenId) external view returns (address owner);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) external;
781 
782     /**
783      * @dev Transfers `tokenId` token from `from` to `to`.
784      *
785      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must be owned by `from`.
792      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
793      *
794      * Emits a {Transfer} event.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) external;
801 
802     /**
803      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
804      * The approval is cleared when the token is transferred.
805      *
806      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
807      *
808      * Requirements:
809      *
810      * - The caller must own the token or be an approved operator.
811      * - `tokenId` must exist.
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address to, uint256 tokenId) external;
816 
817     /**
818      * @dev Returns the account approved for `tokenId` token.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function getApproved(uint256 tokenId) external view returns (address operator);
825 
826     /**
827      * @dev Approve or remove `operator` as an operator for the caller.
828      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
829      *
830      * Requirements:
831      *
832      * - The `operator` cannot be the caller.
833      *
834      * Emits an {ApprovalForAll} event.
835      */
836     function setApprovalForAll(address operator, bool _approved) external;
837 
838     /**
839      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
840      *
841      * See {setApprovalForAll}
842      */
843     function isApprovedForAll(address owner, address operator) external view returns (bool);
844 
845     /**
846      * @dev Safely transfers `tokenId` token from `from` to `to`.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must exist and be owned by `from`.
853      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes calldata data
863     ) external;
864 }
865 
866 // File: @openzeppelin/contracts@4.4.2/token/ERC721/extensions/IERC721Enumerable.sol
867 
868 
869 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 
874 /**
875  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
876  * @dev See https://eips.ethereum.org/EIPS/eip-721
877  */
878 interface IERC721Enumerable is IERC721 {
879     /**
880      * @dev Returns the total amount of tokens stored by the contract.
881      */
882     function totalSupply() external view returns (uint256);
883 
884     /**
885      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
886      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
887      */
888     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
889 
890     /**
891      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
892      * Use along with {totalSupply} to enumerate all tokens.
893      */
894     function tokenByIndex(uint256 index) external view returns (uint256);
895 }
896 
897 // File: @openzeppelin/contracts@4.4.2/token/ERC721/extensions/IERC721Metadata.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 /**
906  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
907  * @dev See https://eips.ethereum.org/EIPS/eip-721
908  */
909 interface IERC721Metadata is IERC721 {
910     /**
911      * @dev Returns the token collection name.
912      */
913     function name() external view returns (string memory);
914 
915     /**
916      * @dev Returns the token collection symbol.
917      */
918     function symbol() external view returns (string memory);
919 
920     /**
921      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
922      */
923     function tokenURI(uint256 tokenId) external view returns (string memory);
924 }
925 
926 // File: ERC721A.sol
927 
928 
929 // Creator: Chiru Labs
930 
931 pragma solidity ^0.8.4;
932 
933 
934 
935 
936 
937 
938 
939 
940 
941 error ApprovalCallerNotOwnerNorApproved();
942 error ApprovalQueryForNonexistentToken();
943 error ApproveToCaller();
944 error ApprovalToCurrentOwner();
945 error BalanceQueryForZeroAddress();
946 error MintedQueryForZeroAddress();
947 error BurnedQueryForZeroAddress();
948 error AuxQueryForZeroAddress();
949 error MintToZeroAddress();
950 error MintZeroQuantity();
951 error OwnerIndexOutOfBounds();
952 error OwnerQueryForNonexistentToken();
953 error TokenIndexOutOfBounds();
954 error TransferCallerNotOwnerNorApproved();
955 error TransferFromIncorrectOwner();
956 error TransferToNonERC721ReceiverImplementer();
957 error TransferToZeroAddress();
958 error URIQueryForNonexistentToken();
959 
960 /**
961  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
962  * the Metadata extension. Built to optimize for lower gas during batch mints.
963  *
964  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
965  *
966  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
967  *
968  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
969  */
970 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
971     using Address for address;
972     using Strings for uint256;
973 
974     // Compiler will pack this into a single 256bit word.
975     struct TokenOwnership {
976         // The address of the owner.
977         address addr;
978         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
979         uint64 startTimestamp;
980         // Whether the token has been burned.
981         bool burned;
982     }
983 
984     // Compiler will pack this into a single 256bit word.
985     struct AddressData {
986         // Realistically, 2**64-1 is more than enough.
987         uint64 balance;
988         // Keeps track of mint count with minimal overhead for tokenomics.
989         uint64 numberMinted;
990         // Keeps track of burn count with minimal overhead for tokenomics.
991         uint64 numberBurned;
992         // For miscellaneous variable(s) pertaining to the address
993         // (e.g. number of whitelist mint slots used).
994         // If there are multiple variables, please pack them into a uint64.
995         uint64 aux;
996     }
997 
998     // The tokenId of the next token to be minted.
999     uint256 internal _currentIndex;
1000 
1001     // The number of tokens burned.
1002     uint256 internal _burnCounter;
1003 
1004     // Token name
1005     string private _name;
1006 
1007     // Token symbol
1008     string private _symbol;
1009 
1010     // Mapping from token ID to ownership details
1011     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1012     mapping(uint256 => TokenOwnership) internal _ownerships;
1013 
1014     // Mapping owner address to address data
1015     mapping(address => AddressData) private _addressData;
1016 
1017     // Mapping from token ID to approved address
1018     mapping(uint256 => address) private _tokenApprovals;
1019 
1020     // Mapping from owner to operator approvals
1021     mapping(address => mapping(address => bool)) private _operatorApprovals;
1022 
1023     constructor(string memory name_, string memory symbol_) {
1024         _name = name_;
1025         _symbol = symbol_;
1026         _currentIndex = _startTokenId();
1027     }
1028 
1029     /**
1030      * To change the starting tokenId, please override this function.
1031      */
1032     function _startTokenId() internal view virtual returns (uint256) {
1033         return 0;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-totalSupply}.
1038      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1039      */
1040     function totalSupply() public view returns (uint256) {
1041         // Counter underflow is impossible as _burnCounter cannot be incremented
1042         // more than _currentIndex - _startTokenId() times
1043         unchecked {
1044             return _currentIndex - _burnCounter - _startTokenId();
1045         }
1046     }
1047 
1048     /**
1049      * Returns the total amount of tokens minted in the contract.
1050      */
1051     function _totalMinted() internal view returns (uint256) {
1052         // Counter underflow is impossible as _currentIndex does not decrement,
1053         // and it is initialized to _startTokenId()
1054         unchecked {
1055             return _currentIndex - _startTokenId();
1056         }
1057     }
1058 
1059     /**
1060      * @dev See {IERC165-supportsInterface}.
1061      */
1062     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1063         return
1064             interfaceId == type(IERC721).interfaceId ||
1065             interfaceId == type(IERC721Metadata).interfaceId ||
1066             super.supportsInterface(interfaceId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-balanceOf}.
1071      */
1072     function balanceOf(address owner) public view override returns (uint256) {
1073         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1074         return uint256(_addressData[owner].balance);
1075     }
1076 
1077     /**
1078      * Returns the number of tokens minted by `owner`.
1079      */
1080     function _numberMinted(address owner) internal view returns (uint256) {
1081         if (owner == address(0)) revert MintedQueryForZeroAddress();
1082         return uint256(_addressData[owner].numberMinted);
1083     }
1084 
1085     /**
1086      * Returns the number of tokens burned by or on behalf of `owner`.
1087      */
1088     function _numberBurned(address owner) internal view returns (uint256) {
1089         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1090         return uint256(_addressData[owner].numberBurned);
1091     }
1092 
1093     /**
1094      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1095      */
1096     function _getAux(address owner) internal view returns (uint64) {
1097         if (owner == address(0)) revert AuxQueryForZeroAddress();
1098         return _addressData[owner].aux;
1099     }
1100 
1101     /**
1102      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1103      * If there are multiple variables, please pack them into a uint64.
1104      */
1105     function _setAux(address owner, uint64 aux) internal {
1106         if (owner == address(0)) revert AuxQueryForZeroAddress();
1107         _addressData[owner].aux = aux;
1108     }
1109 
1110     /**
1111      * Gas spent here starts off proportional to the maximum mint batch size.
1112      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1113      */
1114     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1115         uint256 curr = tokenId;
1116 
1117         unchecked {
1118             if (_startTokenId() <= curr && curr < _currentIndex) {
1119                 TokenOwnership memory ownership = _ownerships[curr];
1120                 if (!ownership.burned) {
1121                     if (ownership.addr != address(0)) {
1122                         return ownership;
1123                     }
1124                     // Invariant:
1125                     // There will always be an ownership that has an address and is not burned
1126                     // before an ownership that does not have an address and is not burned.
1127                     // Hence, curr will not underflow.
1128                     while (true) {
1129                         curr--;
1130                         ownership = _ownerships[curr];
1131                         if (ownership.addr != address(0)) {
1132                             return ownership;
1133                         }
1134                     }
1135                 }
1136             }
1137         }
1138         revert OwnerQueryForNonexistentToken();
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-ownerOf}.
1143      */
1144     function ownerOf(uint256 tokenId) public view override returns (address) {
1145         return ownershipOf(tokenId).addr;
1146     }
1147 
1148     /**
1149      * @dev See {IERC721Metadata-name}.
1150      */
1151     function name() public view virtual override returns (string memory) {
1152         return _name;
1153     }
1154 
1155     /**
1156      * @dev See {IERC721Metadata-symbol}.
1157      */
1158     function symbol() public view virtual override returns (string memory) {
1159         return _symbol;
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Metadata-tokenURI}.
1164      */
1165     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1166         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1167 
1168         string memory baseURI = _baseURI();
1169         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1170     }
1171 
1172     /**
1173      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1174      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1175      * by default, can be overriden in child contracts.
1176      */
1177     function _baseURI() internal view virtual returns (string memory) {
1178         return '';
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-approve}.
1183      */
1184     function approve(address to, uint256 tokenId) public override {
1185         address owner = ERC721A.ownerOf(tokenId);
1186         if (to == owner) revert ApprovalToCurrentOwner();
1187 
1188         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1189             revert ApprovalCallerNotOwnerNorApproved();
1190         }
1191 
1192         _approve(to, tokenId, owner);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-getApproved}.
1197      */
1198     function getApproved(uint256 tokenId) public view override returns (address) {
1199         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1200 
1201         return _tokenApprovals[tokenId];
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-setApprovalForAll}.
1206      */
1207     function setApprovalForAll(address operator, bool approved) public override {
1208         if (operator == _msgSender()) revert ApproveToCaller();
1209 
1210         _operatorApprovals[_msgSender()][operator] = approved;
1211         emit ApprovalForAll(_msgSender(), operator, approved);
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-isApprovedForAll}.
1216      */
1217     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1218         return _operatorApprovals[owner][operator];
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-transferFrom}.
1223      */
1224     function transferFrom(
1225         address from,
1226         address to,
1227         uint256 tokenId
1228     ) public virtual override {
1229         _transfer(from, to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-safeTransferFrom}.
1234      */
1235     function safeTransferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) public virtual override {
1240         safeTransferFrom(from, to, tokenId, '');
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-safeTransferFrom}.
1245      */
1246     function safeTransferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId,
1250         bytes memory _data
1251     ) public virtual override {
1252         _transfer(from, to, tokenId);
1253         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1254             revert TransferToNonERC721ReceiverImplementer();
1255         }
1256     }
1257 
1258     /**
1259      * @dev Returns whether `tokenId` exists.
1260      *
1261      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1262      *
1263      * Tokens start existing when they are minted (`_mint`),
1264      */
1265     function _exists(uint256 tokenId) internal view returns (bool) {
1266         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1267             !_ownerships[tokenId].burned;
1268     }
1269 
1270     function _safeMint(address to, uint256 quantity) internal {
1271         _safeMint(to, quantity, '');
1272     }
1273 
1274     /**
1275      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1276      *
1277      * Requirements:
1278      *
1279      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1280      * - `quantity` must be greater than 0.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _safeMint(
1285         address to,
1286         uint256 quantity,
1287         bytes memory _data
1288     ) internal {
1289         _mint(to, quantity, _data, true);
1290     }
1291 
1292     /**
1293      * @dev Mints `quantity` tokens and transfers them to `to`.
1294      *
1295      * Requirements:
1296      *
1297      * - `to` cannot be the zero address.
1298      * - `quantity` must be greater than 0.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _mint(
1303         address to,
1304         uint256 quantity,
1305         bytes memory _data,
1306         bool safe
1307     ) internal {
1308         uint256 startTokenId = _currentIndex;
1309         if (to == address(0)) revert MintToZeroAddress();
1310         if (quantity == 0) revert MintZeroQuantity();
1311 
1312         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1313 
1314         // Overflows are incredibly unrealistic.
1315         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1316         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1317         unchecked {
1318             _addressData[to].balance += uint64(quantity);
1319             _addressData[to].numberMinted += uint64(quantity);
1320 
1321             _ownerships[startTokenId].addr = to;
1322             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1323 
1324             uint256 updatedIndex = startTokenId;
1325             uint256 end = updatedIndex + quantity;
1326 
1327             if (safe && to.isContract()) {
1328                 do {
1329                     emit Transfer(address(0), to, updatedIndex);
1330                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1331                         revert TransferToNonERC721ReceiverImplementer();
1332                     }
1333                 } while (updatedIndex != end);
1334                 // Reentrancy protection
1335                 if (_currentIndex != startTokenId) revert();
1336             } else {
1337                 do {
1338                     emit Transfer(address(0), to, updatedIndex++);
1339                 } while (updatedIndex != end);
1340             }
1341             _currentIndex = updatedIndex;
1342         }
1343         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1344     }
1345 
1346     /**
1347      * @dev Transfers `tokenId` from `from` to `to`.
1348      *
1349      * Requirements:
1350      *
1351      * - `to` cannot be the zero address.
1352      * - `tokenId` token must be owned by `from`.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function _transfer(
1357         address from,
1358         address to,
1359         uint256 tokenId
1360     ) private {
1361         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1362 
1363         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1364             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1365             getApproved(tokenId) == _msgSender());
1366 
1367         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1368         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1369         if (to == address(0)) revert TransferToZeroAddress();
1370 
1371         _beforeTokenTransfers(from, to, tokenId, 1);
1372 
1373         // Clear approvals from the previous owner
1374         _approve(address(0), tokenId, prevOwnership.addr);
1375 
1376         // Underflow of the sender's balance is impossible because we check for
1377         // ownership above and the recipient's balance can't realistically overflow.
1378         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1379         unchecked {
1380             _addressData[from].balance -= 1;
1381             _addressData[to].balance += 1;
1382 
1383             _ownerships[tokenId].addr = to;
1384             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1385 
1386             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1387             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1388             uint256 nextTokenId = tokenId + 1;
1389             if (_ownerships[nextTokenId].addr == address(0)) {
1390                 // This will suffice for checking _exists(nextTokenId),
1391                 // as a burned slot cannot contain the zero address.
1392                 if (nextTokenId < _currentIndex) {
1393                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1394                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1395                 }
1396             }
1397         }
1398 
1399         emit Transfer(from, to, tokenId);
1400         _afterTokenTransfers(from, to, tokenId, 1);
1401     }
1402 
1403     /**
1404      * @dev Destroys `tokenId`.
1405      * The approval is cleared when the token is burned.
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must exist.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function _burn(uint256 tokenId) internal virtual {
1414         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1415 
1416         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1417 
1418         // Clear approvals from the previous owner
1419         _approve(address(0), tokenId, prevOwnership.addr);
1420 
1421         // Underflow of the sender's balance is impossible because we check for
1422         // ownership above and the recipient's balance can't realistically overflow.
1423         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1424         unchecked {
1425             _addressData[prevOwnership.addr].balance -= 1;
1426             _addressData[prevOwnership.addr].numberBurned += 1;
1427 
1428             // Keep track of who burned the token, and the timestamp of burning.
1429             _ownerships[tokenId].addr = prevOwnership.addr;
1430             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1431             _ownerships[tokenId].burned = true;
1432 
1433             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1434             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1435             uint256 nextTokenId = tokenId + 1;
1436             if (_ownerships[nextTokenId].addr == address(0)) {
1437                 // This will suffice for checking _exists(nextTokenId),
1438                 // as a burned slot cannot contain the zero address.
1439                 if (nextTokenId < _currentIndex) {
1440                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1441                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1442                 }
1443             }
1444         }
1445 
1446         emit Transfer(prevOwnership.addr, address(0), tokenId);
1447         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1448 
1449         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1450         unchecked {
1451             _burnCounter++;
1452         }
1453     }
1454 
1455     /**
1456      * @dev Approve `to` to operate on `tokenId`
1457      *
1458      * Emits a {Approval} event.
1459      */
1460     function _approve(
1461         address to,
1462         uint256 tokenId,
1463         address owner
1464     ) private {
1465         _tokenApprovals[tokenId] = to;
1466         emit Approval(owner, to, tokenId);
1467     }
1468 
1469     /**
1470      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1471      *
1472      * @param from address representing the previous owner of the given token ID
1473      * @param to target address that will receive the tokens
1474      * @param tokenId uint256 ID of the token to be transferred
1475      * @param _data bytes optional data to send along with the call
1476      * @return bool whether the call correctly returned the expected magic value
1477      */
1478     function _checkContractOnERC721Received(
1479         address from,
1480         address to,
1481         uint256 tokenId,
1482         bytes memory _data
1483     ) private returns (bool) {
1484         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1485             return retval == IERC721Receiver(to).onERC721Received.selector;
1486         } catch (bytes memory reason) {
1487             if (reason.length == 0) {
1488                 revert TransferToNonERC721ReceiverImplementer();
1489             } else {
1490                 assembly {
1491                     revert(add(32, reason), mload(reason))
1492                 }
1493             }
1494         }
1495     }
1496 
1497     /**
1498      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1499      * And also called before burning one token.
1500      *
1501      * startTokenId - the first token id to be transferred
1502      * quantity - the amount to be transferred
1503      *
1504      * Calling conditions:
1505      *
1506      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1507      * transferred to `to`.
1508      * - When `from` is zero, `tokenId` will be minted for `to`.
1509      * - When `to` is zero, `tokenId` will be burned by `from`.
1510      * - `from` and `to` are never both zero.
1511      */
1512     function _beforeTokenTransfers(
1513         address from,
1514         address to,
1515         uint256 startTokenId,
1516         uint256 quantity
1517     ) internal virtual {}
1518 
1519     /**
1520      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1521      * minting.
1522      * And also called after one token has been burned.
1523      *
1524      * startTokenId - the first token id to be transferred
1525      * quantity - the amount to be transferred
1526      *
1527      * Calling conditions:
1528      *
1529      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1530      * transferred to `to`.
1531      * - When `from` is zero, `tokenId` has been minted for `to`.
1532      * - When `to` is zero, `tokenId` has been burned by `from`.
1533      * - `from` and `to` are never both zero.
1534      */
1535     function _afterTokenTransfers(
1536         address from,
1537         address to,
1538         uint256 startTokenId,
1539         uint256 quantity
1540     ) internal virtual {}
1541 }
1542 
1543 // File: cozybears.sol
1544 
1545 // ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
1546 // ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
1547 // ,,,,,,,,,,,,,,,%%,,,,,,,,,,,,,,,,,..,,,,,,...,,,,,,,,,,,,,,,,,,,,,,,,,*&,,,,,,,,
1548 // ,,,,,,,,,,,,,,&(&%,,,,.....,,,,,......,,......,,,,,...,,,,,,,,,,...,,,@,@,,,,,,,
1549 // ,,,,,,,,,,,,,%%./&,,,,(&@*...,,................,......,,,,,,...&(%.,,*@ (&,,,,,,
1550 // ,,,,,,,,,,,,#&.  %@*,,%%.@............................,,,.....(#*&,,*@, .##,,,,,
1551 // ,,,,,,,,.....@(...  #@,  &/../............................./..&. .@(   ..@.,,,,,
1552 // ,,,,,,,,,.....,&@*...... *&%&/&.......,,,,................%*@/@    ...(@*.,,,,,,
1553 // ,,,,,,,,,,,........(@@&, ... (@@@(  ..  .#@@ .#@@&........#/ ....%@@/....,,,,,,,
1554 // ,,,,,,,,,,,,,............/@@#. ,@@,                ,@@,%@/ .%@#,........,,,,,,,,
1555 // ,,,,,............#@(   ,&@.   (@/..@.                (#..@%   .@%.....,,,,,,,,,,
1556 // ,,,,,,.........,@    /#*         .*        ,,,,,,,,,. ,* (@@*%# (&........,,,,,,
1557 // ,,,,,,,,,......%%  .....,@               ,,,,     .,,,.    @/.. *&..........,,,,
1558 // ,,,,,,,,,,,....*@  .......                                  @( #@........,,,,,,,
1559 // ,,,,,,,,,,,,.....@#               .&@@#....     ...  .%@@&.  @*.......,,,,,,,,,,
1560 // ,,,,..............&(#&,     ..,,,@(,,,.....     ...  .,,,,/@ @/.........,,,,,,,,
1561 // ,,,,,,...........(&..      ,,,,,,,,,,,,.....    ...  .,,,,   @/............,,,,,
1562 // ,,,,,,,,,........@/..             ..(@&&@%..    ... .@@&@@, ,@.............,,,,,
1563 // ,,,,,,,,,,,......@/..             .&@@@@@@@.     ..(@&&&&&@*&@.........,,,,,,,,,
1564 // ,,,,,,,..........(%..      .....  .,@,   @#.   /#, (@#   #@..,@,..........,,,,,,
1565 // ,,,,..............@/.     .. .... .........    @@@@@@*   .... /@............,,,,
1566 // ,,,,,,,,,..........&&     ......   .......       ,@        ...*@.......,,,,,,,,,
1567 // ,,,,,,,,,,,,,....../@@#                       ,@@@@@&        .@*.......,,,,,,,,,
1568 // ,,,,,,,,,,,........,@&,%@*                       @,         @&...........,,,,,,,
1569 // ,,,,,,,,,,.......*@/*%&,,.(@#                             /@@,...........,,,,,,,
1570 // ,,,,,,,,........@#, ,,/@,,,  *@&                         &&,%&.....,,,,,,,,,,,,,
1571 // ,,,,,,,,,,,,,,(@,,,,,.,,@@,,.....&@,          (......  /@*..*@@/....,,,,,,,,,,,,
1572 // ,,,,,,,,,,,,,#&, ,,, ,/@(,@&,,... ..#@*  #@*          @#,...*@  &@,,,,,,,,,,,,,,
1573 // ,,,,,,,,,,,,%&..,,.... ..%@,@&,,... . .%@.          *@, ....(@*,..&%,,,,,,,,,,,,
1574 // ,,,,,,,,,,,(@,,,,.   ......@#,(@@@@@/,. .,@@%*,,*%@@@,. .@%#*.%&,..(@,,,,,,,,,,,
1575 // ,,,,,,,,,,,@/,,,..... ......@#,, ,,@/,......@%    @/, ...%&,...%@. .(@,,,,,,,,,,
1576 // ,,,,,,,,,,(@,,,..... ........@,...,,*%@@/,,. .@( @*. (@&*,,... .@/, .@(,,,,,,,,,
1577 
1578 pragma solidity ^0.8.4;
1579 
1580 
1581 
1582 
1583 contract CozyBears is ERC721A, Ownable {
1584     using ECDSA for bytes32;
1585 
1586     address public allowListSigningAddress = address(0x5c0A83276d1F4953d985243559683F68cA9b7790);
1587 
1588     string private base;
1589     string public PROVENANCE;
1590     uint256 public MAX_SUPPLY = 8888;
1591     uint256 public price = 60000000000000000;
1592     uint256 public maxPublicMints = 10;
1593     uint256 public maxAllowMints = 3;
1594     
1595     bool private reserved;
1596     bool public mintIsActive;
1597     
1598     constructor() ERC721A("Cozy Bears", "CBEARS") {}
1599 
1600     function setBaseURI(string memory baseURI) public onlyOwner {
1601         base = baseURI;
1602     }
1603 
1604     function setAllowListSigner(address _signingAddress) external onlyOwner {
1605         allowListSigningAddress = _signingAddress;
1606     }
1607 
1608     function togglePublicSale() external onlyOwner {
1609         mintIsActive = !mintIsActive;
1610     }
1611 
1612     function setMaxPublicMints(uint256 _maxPublicMints) external onlyOwner {
1613         maxPublicMints = _maxPublicMints;
1614     }
1615 
1616     modifier mintCompliance(uint256 amount) {
1617         unchecked {
1618             require(_totalMinted() + amount <= MAX_SUPPLY, "max supply");
1619         }
1620         require(msg.value >= price*amount, "wrong price");
1621         _;
1622     }
1623     
1624     function mint(uint256 amount) external payable mintCompliance(amount) {
1625         require(mintIsActive, "Minting is paused");
1626         require(amount <= maxPublicMints, "max amount");
1627         require(msg.sender == tx.origin, "no bots");
1628         _mint(msg.sender, amount, "", false);
1629     }
1630 
1631     function allowlistMint(uint64 amount, bytes calldata _signature) external payable mintCompliance(amount) {
1632         require(
1633                 allowListSigningAddress ==
1634                     keccak256(
1635                         abi.encodePacked(
1636                             "\x19Ethereum Signed Message:\n32",
1637                             bytes32(uint256(uint160(msg.sender)))
1638                         )
1639                     ).recover(_signature),
1640                 "not allowed"
1641         );
1642         unchecked {
1643             uint64 numWhitelistMinted = _getAux(msg.sender) + amount;
1644             // MAX AMOUNT PER WALLET: 3
1645             require(numWhitelistMinted < 4, "max allowlist amount");
1646             _setAux(msg.sender,numWhitelistMinted);
1647         }
1648         _mint(msg.sender, amount, "", false);
1649     }
1650 
1651     function getAllowlistMinted(address _address) external view returns (uint64) {
1652         return _getAux(_address);
1653     }
1654 
1655     function setProvenanceHash(string memory provenanceHash) external onlyOwner {
1656         PROVENANCE = provenanceHash;
1657     }
1658 
1659     // Set some Cozy Bears aside
1660     function reserveBears() external onlyOwner {
1661         require(!reserved, "reserve redeemed");
1662         require(_totalMinted()<8718, "not enough supply");
1663         reserved = true;
1664         for (uint256 i = 0; i < 17; i++) {
1665             _mint(msg.sender, 10, "", false);
1666         }
1667     }
1668 
1669     function setPrice(uint256 _price) external onlyOwner {
1670         price = _price;
1671     }
1672 
1673     function withdraw() public payable onlyOwner {
1674         require(payable(msg.sender).send(address(this).balance));
1675     }
1676 
1677     function burnSupply(uint256 newSupply) external onlyOwner {
1678         require(newSupply < MAX_SUPPLY, "newSupply too high");
1679         require(newSupply > _totalMinted(), "newSupply too low");
1680         MAX_SUPPLY = newSupply;
1681     }
1682 
1683     function _baseURI() internal view override returns (string memory) {
1684         return base;
1685     }
1686 }