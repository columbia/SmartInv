1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
10  *
11  * These functions can be used to verify that a message was signed by the holder
12  * of the private keys of a given address.
13  */
14 library ECDSA {
15     enum RecoverError {
16         NoError,
17         InvalidSignature,
18         InvalidSignatureLength,
19         InvalidSignatureS,
20         InvalidSignatureV
21     }
22 
23     function _throwError(RecoverError error) private pure {
24         if (error == RecoverError.NoError) {
25             return; // no error: do nothing
26         } else if (error == RecoverError.InvalidSignature) {
27             revert("ECDSA: invalid signature");
28         } else if (error == RecoverError.InvalidSignatureLength) {
29             revert("ECDSA: invalid signature length");
30         } else if (error == RecoverError.InvalidSignatureS) {
31             revert("ECDSA: invalid signature 's' value");
32         } else if (error == RecoverError.InvalidSignatureV) {
33             revert("ECDSA: invalid signature 'v' value");
34         }
35     }
36 
37     /**
38      * @dev Returns the address that signed a hashed message (`hash`) with
39      * `signature` or error string. This address can then be used for verification purposes.
40      *
41      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
42      * this function rejects them by requiring the `s` value to be in the lower
43      * half order, and the `v` value to be either 27 or 28.
44      *
45      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
46      * verification to be secure: it is possible to craft signatures that
47      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
48      * this is by receiving a hash of the original message (which may otherwise
49      * be too long), and then calling {toEthSignedMessageHash} on it.
50      *
51      * Documentation for signature generation:
52      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
53      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
54      *
55      * _Available since v4.3._
56      */
57     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
58         // Check the signature length
59         // - case 65: r,s,v signature (standard)
60         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
61         if (signature.length == 65) {
62             bytes32 r;
63             bytes32 s;
64             uint8 v;
65             // ecrecover takes the signature parameters, and the only way to get them
66             // currently is to use assembly.
67             assembly {
68                 r := mload(add(signature, 0x20))
69                 s := mload(add(signature, 0x40))
70                 v := byte(0, mload(add(signature, 0x60)))
71             }
72             return tryRecover(hash, v, r, s);
73         } else if (signature.length == 64) {
74             bytes32 r;
75             bytes32 vs;
76             // ecrecover takes the signature parameters, and the only way to get them
77             // currently is to use assembly.
78             assembly {
79                 r := mload(add(signature, 0x20))
80                 vs := mload(add(signature, 0x40))
81             }
82             return tryRecover(hash, r, vs);
83         } else {
84             return (address(0), RecoverError.InvalidSignatureLength);
85         }
86     }
87 
88     /**
89      * @dev Returns the address that signed a hashed message (`hash`) with
90      * `signature`. This address can then be used for verification purposes.
91      *
92      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
93      * this function rejects them by requiring the `s` value to be in the lower
94      * half order, and the `v` value to be either 27 or 28.
95      *
96      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
97      * verification to be secure: it is possible to craft signatures that
98      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
99      * this is by receiving a hash of the original message (which may otherwise
100      * be too long), and then calling {toEthSignedMessageHash} on it.
101      */
102     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
103         (address recovered, RecoverError error) = tryRecover(hash, signature);
104         _throwError(error);
105         return recovered;
106     }
107 
108     /**
109      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
110      *
111      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
112      *
113      * _Available since v4.3._
114      */
115     function tryRecover(
116         bytes32 hash,
117         bytes32 r,
118         bytes32 vs
119     ) internal pure returns (address, RecoverError) {
120         bytes32 s;
121         uint8 v;
122         assembly {
123             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
124             v := add(shr(255, vs), 27)
125         }
126         return tryRecover(hash, v, r, s);
127     }
128 
129     /**
130      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
131      *
132      * _Available since v4.2._
133      */
134     function recover(
135         bytes32 hash,
136         bytes32 r,
137         bytes32 vs
138     ) internal pure returns (address) {
139         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
140         _throwError(error);
141         return recovered;
142     }
143 
144     /**
145      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
146      * `r` and `s` signature fields separately.
147      *
148      * _Available since v4.3._
149      */
150     function tryRecover(
151         bytes32 hash,
152         uint8 v,
153         bytes32 r,
154         bytes32 s
155     ) internal pure returns (address, RecoverError) {
156         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
157         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
158         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
159         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
160         //
161         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
162         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
163         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
164         // these malleable signatures as well.
165         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
166             return (address(0), RecoverError.InvalidSignatureS);
167         }
168         if (v != 27 && v != 28) {
169             return (address(0), RecoverError.InvalidSignatureV);
170         }
171 
172         // If the signature is valid (and not malleable), return the signer address
173         address signer = ecrecover(hash, v, r, s);
174         if (signer == address(0)) {
175             return (address(0), RecoverError.InvalidSignature);
176         }
177 
178         return (signer, RecoverError.NoError);
179     }
180 
181     /**
182      * @dev Overload of {ECDSA-recover} that receives the `v`,
183      * `r` and `s` signature fields separately.
184      */
185     function recover(
186         bytes32 hash,
187         uint8 v,
188         bytes32 r,
189         bytes32 s
190     ) internal pure returns (address) {
191         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
192         _throwError(error);
193         return recovered;
194     }
195 
196     /**
197      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
198      * produces hash corresponding to the one signed with the
199      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
200      * JSON-RPC method as part of EIP-191.
201      *
202      * See {recover}.
203      */
204     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
205         // 32 is the length in bytes of hash,
206         // enforced by the type signature above
207         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
208     }
209 
210     /**
211      * @dev Returns an Ethereum Signed Typed Data, created from a
212      * `domainSeparator` and a `structHash`. This produces hash corresponding
213      * to the one signed with the
214      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
215      * JSON-RPC method as part of EIP-712.
216      *
217      * See {recover}.
218      */
219     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
220         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Strings.sol
225 
226 
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev String operations.
232  */
233 library Strings {
234     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
238      */
239     function toString(uint256 value) internal pure returns (string memory) {
240         // Inspired by OraclizeAPI's implementation - MIT licence
241         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
242 
243         if (value == 0) {
244             return "0";
245         }
246         uint256 temp = value;
247         uint256 digits;
248         while (temp != 0) {
249             digits++;
250             temp /= 10;
251         }
252         bytes memory buffer = new bytes(digits);
253         while (value != 0) {
254             digits -= 1;
255             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
256             value /= 10;
257         }
258         return string(buffer);
259     }
260 
261     /**
262      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
263      */
264     function toHexString(uint256 value) internal pure returns (string memory) {
265         if (value == 0) {
266             return "0x00";
267         }
268         uint256 temp = value;
269         uint256 length = 0;
270         while (temp != 0) {
271             length++;
272             temp >>= 8;
273         }
274         return toHexString(value, length);
275     }
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
279      */
280     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
281         bytes memory buffer = new bytes(2 * length + 2);
282         buffer[0] = "0";
283         buffer[1] = "x";
284         for (uint256 i = 2 * length + 1; i > 1; --i) {
285             buffer[i] = _HEX_SYMBOLS[value & 0xf];
286             value >>= 4;
287         }
288         require(value == 0, "Strings: hex length insufficient");
289         return string(buffer);
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Context.sol
294 
295 
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @dev Provides information about the current execution context, including the
301  * sender of the transaction and its data. While these are generally available
302  * via msg.sender and msg.data, they should not be accessed in such a direct
303  * manner, since when dealing with meta-transactions the account sending and
304  * paying for execution may not be the actual sender (as far as an application
305  * is concerned).
306  *
307  * This contract is only required for intermediate, library-like contracts.
308  */
309 abstract contract Context {
310     function _msgSender() internal view virtual returns (address) {
311         return msg.sender;
312     }
313 
314     function _msgData() internal view virtual returns (bytes calldata) {
315         return msg.data;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/access/Ownable.sol
320 
321 
322 
323 pragma solidity ^0.8.0;
324 
325 
326 /**
327  * @dev Contract module which provides a basic access control mechanism, where
328  * there is an account (an owner) that can be granted exclusive access to
329  * specific functions.
330  *
331  * By default, the owner account will be the one that deploys the contract. This
332  * can later be changed with {transferOwnership}.
333  *
334  * This module is used through inheritance. It will make available the modifier
335  * `onlyOwner`, which can be applied to your functions to restrict their use to
336  * the owner.
337  */
338 abstract contract Ownable is Context {
339     address private _owner;
340 
341     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
342 
343     /**
344      * @dev Initializes the contract setting the deployer as the initial owner.
345      */
346     constructor() {
347         _setOwner(_msgSender());
348     }
349 
350     /**
351      * @dev Returns the address of the current owner.
352      */
353     function owner() public view virtual returns (address) {
354         return _owner;
355     }
356 
357     /**
358      * @dev Throws if called by any account other than the owner.
359      */
360     modifier onlyOwner() {
361         require(owner() == _msgSender(), "Ownable: caller is not the owner");
362         _;
363     }
364 
365     /**
366      * @dev Leaves the contract without owner. It will not be possible to call
367      * `onlyOwner` functions anymore. Can only be called by the current owner.
368      *
369      * NOTE: Renouncing ownership will leave the contract without an owner,
370      * thereby removing any functionality that is only available to the owner.
371      */
372     function renounceOwnership() public virtual onlyOwner {
373         _setOwner(address(0));
374     }
375 
376     /**
377      * @dev Transfers ownership of the contract to a new account (`newOwner`).
378      * Can only be called by the current owner.
379      */
380     function transferOwnership(address newOwner) public virtual onlyOwner {
381         require(newOwner != address(0), "Ownable: new owner is the zero address");
382         _setOwner(newOwner);
383     }
384 
385     function _setOwner(address newOwner) private {
386         address oldOwner = _owner;
387         _owner = newOwner;
388         emit OwnershipTransferred(oldOwner, newOwner);
389     }
390 }
391 
392 // File: @openzeppelin/contracts/utils/Address.sol
393 
394 
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @dev Collection of functions related to the address type
400  */
401 library Address {
402     /**
403      * @dev Returns true if `account` is a contract.
404      *
405      * [IMPORTANT]
406      * ====
407      * It is unsafe to assume that an address for which this function returns
408      * false is an externally-owned account (EOA) and not a contract.
409      *
410      * Among others, `isContract` will return false for the following
411      * types of addresses:
412      *
413      *  - an externally-owned account
414      *  - a contract in construction
415      *  - an address where a contract will be created
416      *  - an address where a contract lived, but was destroyed
417      * ====
418      */
419     function isContract(address account) internal view returns (bool) {
420         // This method relies on extcodesize, which returns 0 for contracts in
421         // construction, since the code is only stored at the end of the
422         // constructor execution.
423 
424         uint256 size;
425         assembly {
426             size := extcodesize(account)
427         }
428         return size > 0;
429     }
430 
431     /**
432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
433      * `recipient`, forwarding all available gas and reverting on errors.
434      *
435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
437      * imposed by `transfer`, making them unable to receive funds via
438      * `transfer`. {sendValue} removes this limitation.
439      *
440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
441      *
442      * IMPORTANT: because control is transferred to `recipient`, care must be
443      * taken to not create reentrancy vulnerabilities. Consider using
444      * {ReentrancyGuard} or the
445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
446      */
447     function sendValue(address payable recipient, uint256 amount) internal {
448         require(address(this).balance >= amount, "Address: insufficient balance");
449 
450         (bool success, ) = recipient.call{value: amount}("");
451         require(success, "Address: unable to send value, recipient may have reverted");
452     }
453 
454     /**
455      * @dev Performs a Solidity function call using a low level `call`. A
456      * plain `call` is an unsafe replacement for a function call: use this
457      * function instead.
458      *
459      * If `target` reverts with a revert reason, it is bubbled up by this
460      * function (like regular Solidity function calls).
461      *
462      * Returns the raw returned data. To convert to the expected return value,
463      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
464      *
465      * Requirements:
466      *
467      * - `target` must be a contract.
468      * - calling `target` with `data` must not revert.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionCall(target, data, "Address: low-level call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
478      * `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, 0, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but also transferring `value` wei to `target`.
493      *
494      * Requirements:
495      *
496      * - the calling contract must have an ETH balance of at least `value`.
497      * - the called Solidity function must be `payable`.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
511      * with `errorMessage` as a fallback revert reason when `target` reverts.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(address(this).balance >= value, "Address: insufficient balance for call");
522         require(isContract(target), "Address: call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.call{value: value}(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
535         return functionStaticCall(target, data, "Address: low-level static call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         require(isContract(target), "Address: static call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.staticcall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
562         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(isContract(target), "Address: delegate call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.delegatecall(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
584      * revert reason using the provided one.
585      *
586      * _Available since v4.3._
587      */
588     function verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) internal pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
612 
613 
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @title ERC721 token receiver interface
619  * @dev Interface for any contract that wants to support safeTransfers
620  * from ERC721 asset contracts.
621  */
622 interface IERC721Receiver {
623     /**
624      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
625      * by `operator` from `from`, this function is called.
626      *
627      * It must return its Solidity selector to confirm the token transfer.
628      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
629      *
630      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
631      */
632     function onERC721Received(
633         address operator,
634         address from,
635         uint256 tokenId,
636         bytes calldata data
637     ) external returns (bytes4);
638 }
639 
640 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
641 
642 
643 
644 pragma solidity ^0.8.0;
645 
646 /**
647  * @dev Interface of the ERC165 standard, as defined in the
648  * https://eips.ethereum.org/EIPS/eip-165[EIP].
649  *
650  * Implementers can declare support of contract interfaces, which can then be
651  * queried by others ({ERC165Checker}).
652  *
653  * For an implementation, see {ERC165}.
654  */
655 interface IERC165 {
656     /**
657      * @dev Returns true if this contract implements the interface defined by
658      * `interfaceId`. See the corresponding
659      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
660      * to learn more about how these ids are created.
661      *
662      * This function call must use less than 30 000 gas.
663      */
664     function supportsInterface(bytes4 interfaceId) external view returns (bool);
665 }
666 
667 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
668 
669 
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
698 
699 
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Required interface of an ERC721 compliant contract.
706  */
707 interface IERC721 is IERC165 {
708     /**
709      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
710      */
711     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
712 
713     /**
714      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
715      */
716     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
717 
718     /**
719      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
720      */
721     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
722 
723     /**
724      * @dev Returns the number of tokens in ``owner``'s account.
725      */
726     function balanceOf(address owner) external view returns (uint256 balance);
727 
728     /**
729      * @dev Returns the owner of the `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function ownerOf(uint256 tokenId) external view returns (address owner);
736 
737     /**
738      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
739      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) external;
756 
757     /**
758      * @dev Transfers `tokenId` token from `from` to `to`.
759      *
760      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must be owned by `from`.
767      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
768      *
769      * Emits a {Transfer} event.
770      */
771     function transferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) external;
776 
777     /**
778      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
779      * The approval is cleared when the token is transferred.
780      *
781      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
782      *
783      * Requirements:
784      *
785      * - The caller must own the token or be an approved operator.
786      * - `tokenId` must exist.
787      *
788      * Emits an {Approval} event.
789      */
790     function approve(address to, uint256 tokenId) external;
791 
792     /**
793      * @dev Returns the account approved for `tokenId` token.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function getApproved(uint256 tokenId) external view returns (address operator);
800 
801     /**
802      * @dev Approve or remove `operator` as an operator for the caller.
803      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
804      *
805      * Requirements:
806      *
807      * - The `operator` cannot be the caller.
808      *
809      * Emits an {ApprovalForAll} event.
810      */
811     function setApprovalForAll(address operator, bool _approved) external;
812 
813     /**
814      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
815      *
816      * See {setApprovalForAll}
817      */
818     function isApprovedForAll(address owner, address operator) external view returns (bool);
819 
820     /**
821      * @dev Safely transfers `tokenId` token from `from` to `to`.
822      *
823      * Requirements:
824      *
825      * - `from` cannot be the zero address.
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must exist and be owned by `from`.
828      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
829      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
830      *
831      * Emits a {Transfer} event.
832      */
833     function safeTransferFrom(
834         address from,
835         address to,
836         uint256 tokenId,
837         bytes calldata data
838     ) external;
839 }
840 
841 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
842 
843 
844 
845 pragma solidity ^0.8.0;
846 
847 
848 /**
849  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
850  * @dev See https://eips.ethereum.org/EIPS/eip-721
851  */
852 interface IERC721Enumerable is IERC721 {
853     /**
854      * @dev Returns the total amount of tokens stored by the contract.
855      */
856     function totalSupply() external view returns (uint256);
857 
858     /**
859      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
860      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
861      */
862     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
863 
864     /**
865      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
866      * Use along with {totalSupply} to enumerate all tokens.
867      */
868     function tokenByIndex(uint256 index) external view returns (uint256);
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
872 
873 
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
899 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
900 
901 
902 
903 pragma solidity ^0.8.0;
904 
905 
906 
907 
908 
909 
910 
911 
912 /**
913  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
914  * the Metadata extension, but not including the Enumerable extension, which is available separately as
915  * {ERC721Enumerable}.
916  */
917 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
918     using Address for address;
919     using Strings for uint256;
920 
921     // Token name
922     string private _name;
923 
924     // Token symbol
925     string private _symbol;
926 
927     // Mapping from token ID to owner address
928     mapping(uint256 => address) private _owners;
929 
930     // Mapping owner address to token count
931     mapping(address => uint256) private _balances;
932 
933     // Mapping from token ID to approved address
934     mapping(uint256 => address) private _tokenApprovals;
935 
936     // Mapping from owner to operator approvals
937     mapping(address => mapping(address => bool)) private _operatorApprovals;
938 
939     /**
940      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
941      */
942     constructor(string memory name_, string memory symbol_) {
943         _name = name_;
944         _symbol = symbol_;
945     }
946 
947     /**
948      * @dev See {IERC165-supportsInterface}.
949      */
950     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
951         return
952             interfaceId == type(IERC721).interfaceId ||
953             interfaceId == type(IERC721Metadata).interfaceId ||
954             super.supportsInterface(interfaceId);
955     }
956 
957     /**
958      * @dev See {IERC721-balanceOf}.
959      */
960     function balanceOf(address owner) public view virtual override returns (uint256) {
961         require(owner != address(0), "ERC721: balance query for the zero address");
962         return _balances[owner];
963     }
964 
965     /**
966      * @dev See {IERC721-ownerOf}.
967      */
968     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
969         address owner = _owners[tokenId];
970         require(owner != address(0), "ERC721: owner query for nonexistent token");
971         return owner;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-name}.
976      */
977     function name() public view virtual override returns (string memory) {
978         return _name;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-symbol}.
983      */
984     function symbol() public view virtual override returns (string memory) {
985         return _symbol;
986     }
987 
988     /**
989      * @dev See {IERC721Metadata-tokenURI}.
990      */
991     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
992         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
993 
994         string memory baseURI = _baseURI();
995         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
996     }
997 
998     /**
999      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1000      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1001      * by default, can be overriden in child contracts.
1002      */
1003     function _baseURI() internal view virtual returns (string memory) {
1004         return "";
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-approve}.
1009      */
1010     function approve(address to, uint256 tokenId) public virtual override {
1011         address owner = ERC721.ownerOf(tokenId);
1012         require(to != owner, "ERC721: approval to current owner");
1013 
1014         require(
1015             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1016             "ERC721: approve caller is not owner nor approved for all"
1017         );
1018 
1019         _approve(to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-getApproved}.
1024      */
1025     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1026         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1027 
1028         return _tokenApprovals[tokenId];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-setApprovalForAll}.
1033      */
1034     function setApprovalForAll(address operator, bool approved) public virtual override {
1035         require(operator != _msgSender(), "ERC721: approve to caller");
1036 
1037         _operatorApprovals[_msgSender()][operator] = approved;
1038         emit ApprovalForAll(_msgSender(), operator, approved);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-isApprovedForAll}.
1043      */
1044     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1045         return _operatorApprovals[owner][operator];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-transferFrom}.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         //solhint-disable-next-line max-line-length
1057         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1058 
1059         _transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) public virtual override {
1070         safeTransferFrom(from, to, tokenId, "");
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) public virtual override {
1082         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1083         _safeTransfer(from, to, tokenId, _data);
1084     }
1085 
1086     /**
1087      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1088      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1089      *
1090      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1091      *
1092      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1093      * implement alternative mechanisms to perform token transfer, such as signature-based.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must exist and be owned by `from`.
1100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _safeTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) internal virtual {
1110         _transfer(from, to, tokenId);
1111         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1112     }
1113 
1114     /**
1115      * @dev Returns whether `tokenId` exists.
1116      *
1117      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1118      *
1119      * Tokens start existing when they are minted (`_mint`),
1120      * and stop existing when they are burned (`_burn`).
1121      */
1122     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1123         return _owners[tokenId] != address(0);
1124     }
1125 
1126     /**
1127      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      */
1133     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1134         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1135         address owner = ERC721.ownerOf(tokenId);
1136         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1137     }
1138 
1139     /**
1140      * @dev Safely mints `tokenId` and transfers it to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must not exist.
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _safeMint(address to, uint256 tokenId) internal virtual {
1150         _safeMint(to, tokenId, "");
1151     }
1152 
1153     /**
1154      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1155      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) internal virtual {
1162         _mint(to, tokenId);
1163         require(
1164             _checkOnERC721Received(address(0), to, tokenId, _data),
1165             "ERC721: transfer to non ERC721Receiver implementer"
1166         );
1167     }
1168 
1169     /**
1170      * @dev Mints `tokenId` and transfers it to `to`.
1171      *
1172      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must not exist.
1177      * - `to` cannot be the zero address.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _mint(address to, uint256 tokenId) internal virtual {
1182         require(to != address(0), "ERC721: mint to the zero address");
1183         require(!_exists(tokenId), "ERC721: token already minted");
1184 
1185         _beforeTokenTransfer(address(0), to, tokenId);
1186 
1187         _balances[to] += 1;
1188         _owners[tokenId] = to;
1189 
1190         emit Transfer(address(0), to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Destroys `tokenId`.
1195      * The approval is cleared when the token is burned.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         address owner = ERC721.ownerOf(tokenId);
1205 
1206         _beforeTokenTransfer(owner, address(0), tokenId);
1207 
1208         // Clear approvals
1209         _approve(address(0), tokenId);
1210 
1211         _balances[owner] -= 1;
1212         delete _owners[tokenId];
1213 
1214         emit Transfer(owner, address(0), tokenId);
1215     }
1216 
1217     /**
1218      * @dev Transfers `tokenId` from `from` to `to`.
1219      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1220      *
1221      * Requirements:
1222      *
1223      * - `to` cannot be the zero address.
1224      * - `tokenId` token must be owned by `from`.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _transfer(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) internal virtual {
1233         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1234         require(to != address(0), "ERC721: transfer to the zero address");
1235 
1236         _beforeTokenTransfer(from, to, tokenId);
1237 
1238         // Clear approvals from the previous owner
1239         _approve(address(0), tokenId);
1240 
1241         _balances[from] -= 1;
1242         _balances[to] += 1;
1243         _owners[tokenId] = to;
1244 
1245         emit Transfer(from, to, tokenId);
1246     }
1247 
1248     /**
1249      * @dev Approve `to` to operate on `tokenId`
1250      *
1251      * Emits a {Approval} event.
1252      */
1253     function _approve(address to, uint256 tokenId) internal virtual {
1254         _tokenApprovals[tokenId] = to;
1255         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1256     }
1257 
1258     /**
1259      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1260      * The call is not executed if the target address is not a contract.
1261      *
1262      * @param from address representing the previous owner of the given token ID
1263      * @param to target address that will receive the tokens
1264      * @param tokenId uint256 ID of the token to be transferred
1265      * @param _data bytes optional data to send along with the call
1266      * @return bool whether the call correctly returned the expected magic value
1267      */
1268     function _checkOnERC721Received(
1269         address from,
1270         address to,
1271         uint256 tokenId,
1272         bytes memory _data
1273     ) private returns (bool) {
1274         if (to.isContract()) {
1275             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1276                 return retval == IERC721Receiver.onERC721Received.selector;
1277             } catch (bytes memory reason) {
1278                 if (reason.length == 0) {
1279                     revert("ERC721: transfer to non ERC721Receiver implementer");
1280                 } else {
1281                     assembly {
1282                         revert(add(32, reason), mload(reason))
1283                     }
1284                 }
1285             }
1286         } else {
1287             return true;
1288         }
1289     }
1290 
1291     /**
1292      * @dev Hook that is called before any token transfer. This includes minting
1293      * and burning.
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1301      * - `from` and `to` are never both zero.
1302      *
1303      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1304      */
1305     function _beforeTokenTransfer(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) internal virtual {}
1310 }
1311 
1312 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1313 
1314 
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 
1319 
1320 /**
1321  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1322  * enumerability of all the token ids in the contract as well as all token ids owned by each
1323  * account.
1324  */
1325 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1326     // Mapping from owner to list of owned token IDs
1327     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1328 
1329     // Mapping from token ID to index of the owner tokens list
1330     mapping(uint256 => uint256) private _ownedTokensIndex;
1331 
1332     // Array with all token ids, used for enumeration
1333     uint256[] private _allTokens;
1334 
1335     // Mapping from token id to position in the allTokens array
1336     mapping(uint256 => uint256) private _allTokensIndex;
1337 
1338     /**
1339      * @dev See {IERC165-supportsInterface}.
1340      */
1341     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1342         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1343     }
1344 
1345     /**
1346      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1347      */
1348     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1349         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1350         return _ownedTokens[owner][index];
1351     }
1352 
1353     /**
1354      * @dev See {IERC721Enumerable-totalSupply}.
1355      */
1356     function totalSupply() public view virtual override returns (uint256) {
1357         return _allTokens.length;
1358     }
1359 
1360     /**
1361      * @dev See {IERC721Enumerable-tokenByIndex}.
1362      */
1363     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1364         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1365         return _allTokens[index];
1366     }
1367 
1368     /**
1369      * @dev Hook that is called before any token transfer. This includes minting
1370      * and burning.
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` will be minted for `to`.
1377      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1378      * - `from` cannot be the zero address.
1379      * - `to` cannot be the zero address.
1380      *
1381      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1382      */
1383     function _beforeTokenTransfer(
1384         address from,
1385         address to,
1386         uint256 tokenId
1387     ) internal virtual override {
1388         super._beforeTokenTransfer(from, to, tokenId);
1389 
1390         if (from == address(0)) {
1391             _addTokenToAllTokensEnumeration(tokenId);
1392         } else if (from != to) {
1393             _removeTokenFromOwnerEnumeration(from, tokenId);
1394         }
1395         if (to == address(0)) {
1396             _removeTokenFromAllTokensEnumeration(tokenId);
1397         } else if (to != from) {
1398             _addTokenToOwnerEnumeration(to, tokenId);
1399         }
1400     }
1401 
1402     /**
1403      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1404      * @param to address representing the new owner of the given token ID
1405      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1406      */
1407     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1408         uint256 length = ERC721.balanceOf(to);
1409         _ownedTokens[to][length] = tokenId;
1410         _ownedTokensIndex[tokenId] = length;
1411     }
1412 
1413     /**
1414      * @dev Private function to add a token to this extension's token tracking data structures.
1415      * @param tokenId uint256 ID of the token to be added to the tokens list
1416      */
1417     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1418         _allTokensIndex[tokenId] = _allTokens.length;
1419         _allTokens.push(tokenId);
1420     }
1421 
1422     /**
1423      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1424      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1425      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1426      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1427      * @param from address representing the previous owner of the given token ID
1428      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1429      */
1430     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1431         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1432         // then delete the last slot (swap and pop).
1433 
1434         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1435         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1436 
1437         // When the token to delete is the last token, the swap operation is unnecessary
1438         if (tokenIndex != lastTokenIndex) {
1439             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1440 
1441             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1442             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1443         }
1444 
1445         // This also deletes the contents at the last position of the array
1446         delete _ownedTokensIndex[tokenId];
1447         delete _ownedTokens[from][lastTokenIndex];
1448     }
1449 
1450     /**
1451      * @dev Private function to remove a token from this extension's token tracking data structures.
1452      * This has O(1) time complexity, but alters the order of the _allTokens array.
1453      * @param tokenId uint256 ID of the token to be removed from the tokens list
1454      */
1455     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1456         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1457         // then delete the last slot (swap and pop).
1458 
1459         uint256 lastTokenIndex = _allTokens.length - 1;
1460         uint256 tokenIndex = _allTokensIndex[tokenId];
1461 
1462         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1463         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1464         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1465         uint256 lastTokenId = _allTokens[lastTokenIndex];
1466 
1467         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1468         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1469 
1470         // This also deletes the contents at the last position of the array
1471         delete _allTokensIndex[tokenId];
1472         _allTokens.pop();
1473     }
1474 }
1475 
1476 // File: AS.sol
1477 
1478 
1479 pragma solidity ^0.8.4;
1480 
1481 /*
1482     Animal Society
1483 */
1484 
1485 
1486 contract AnimalSociety is ERC721Enumerable, Ownable {
1487     using Strings for uint256;
1488     using ECDSA for bytes32;
1489 
1490     uint256 public constant AS_GIFT = 350;
1491     uint256 public constant AS_SALE = 9649;
1492     uint256 public constant AS_MAX = AS_GIFT + AS_SALE;
1493     uint256 public constant AS_PRICE = 0.05 ether;
1494     uint256 public constant AS_MINT = 3;
1495     uint256 public constant MAX_3 = 1000;
1496     uint256 public constant MAX_2 = 2400;
1497     
1498     mapping(address => uint256) public listPurchases;
1499     mapping(string => bool) private _usedNonces;
1500     uint256 public used3;
1501     uint256 public used2;
1502     
1503     string private _contractURI;
1504     string private _tokenBaseURI = "https://animalsocietynft.com/api/metadata/";
1505     address private _devAddress = 0xa65159C939FbED795164bb40F7507d9E5D54Ff22; 
1506     address private _signerAddress = 0xC3E4371297DEAF3eA9D78466d96b1D6098162247;
1507 
1508     string public proof;
1509     uint256 public giftedAmount;
1510     uint256 public publicAmountMinted;
1511     bool public saleLive;
1512     bool public locked;
1513     
1514     constructor() ERC721("Animal Society", "AS") { }
1515     
1516     modifier notLocked {
1517         require(!locked, "Contract metadata methods are locked");
1518         _;
1519     }
1520     
1521     function hashTransaction(address sender, uint256 qty, string memory nonce) private pure returns(bytes32) {
1522           bytes32 hash = keccak256(abi.encodePacked(
1523             "\x19Ethereum Signed Message:\n32",
1524             keccak256(abi.encodePacked(sender, qty, nonce)))
1525           );
1526           
1527           return hash;
1528     }
1529     
1530     function matchAddresSigner(bytes32 hash, bytes memory signature) private view returns(bool) {
1531         return _signerAddress == hash.recover(signature);
1532     }
1533     
1534     function checkMaxMints(uint256 qty) private view returns(bool) {
1535         bool available;
1536         if( qty > 2) {   // if else statement
1537             available = used3 < MAX_3;
1538         } else if( qty > 1 ){
1539             available = used2 < MAX_2;
1540         } else {
1541             available = true;
1542         }       
1543         return available;
1544     }
1545     
1546     function buy(bytes32 hash, bytes memory signature, string memory nonce, uint256 tokenQuantity) external payable {
1547         require(saleLive, "SALE_CLOSED");
1548         require(matchAddresSigner(hash, signature), "DIRECT_MINT_DISALLOWED");
1549         require(!_usedNonces[nonce], "HASH_USED");
1550         require(hashTransaction(msg.sender, tokenQuantity, nonce) == hash, "HASH_FAIL");
1551         require(totalSupply() < AS_MAX, "OUT_OF_STOCK");
1552         require(publicAmountMinted + tokenQuantity <= AS_MAX, "EXCEED_PUBLIC");
1553         require(listPurchases[msg.sender] + tokenQuantity <= AS_MINT, "EXCEED_ALLOC");
1554         require(tokenQuantity <= AS_MINT, "EXCEED_AS_MINT");
1555         require(checkMaxMints(listPurchases[msg.sender] + tokenQuantity), "EXCEED_MINT_LIMITS");
1556         require(AS_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1557        
1558         if(listPurchases[msg.sender] > 2){
1559             used3--;
1560         }else if(listPurchases[msg.sender] > 1){
1561             used2--;
1562         }
1563         
1564         for(uint256 i = 0; i < tokenQuantity; i++) {
1565             publicAmountMinted++;
1566              listPurchases[msg.sender]++;
1567             _safeMint(msg.sender, totalSupply() + 1);
1568         }
1569         
1570         if(listPurchases[msg.sender] > 2){
1571             used3++;
1572         }else if(listPurchases[msg.sender] > 1){
1573             used2++;
1574         }
1575         
1576         _usedNonces[nonce] = true;
1577     }
1578 
1579     
1580     function gift(address[] calldata receivers) external onlyOwner {
1581         require(totalSupply() + receivers.length <= AS_MAX, "MAX_MINT");
1582         require(giftedAmount + receivers.length <= AS_GIFT, "GIFTS_EMPTY");
1583         
1584         for (uint256 i = 0; i < receivers.length; i++) {
1585             giftedAmount++;
1586             _safeMint(receivers[i], totalSupply() + 1);
1587         }
1588     }
1589     
1590     
1591      function claimReserved(address recipient, uint256 amount) external onlyOwner {
1592         require(totalSupply() + amount <= AS_MAX, "MAX_MINT");
1593         require(giftedAmount + amount <= AS_GIFT, "GIFTS_EMPTY");
1594         
1595         for (uint256 i = 0; i < amount; i++) {
1596             giftedAmount++;
1597             _safeMint(recipient, totalSupply() + 1);
1598         }
1599     }
1600     
1601     
1602     function withdraw() external onlyOwner {
1603         payable(_devAddress).transfer(address(this).balance / 4);
1604         payable(msg.sender).transfer(address(this).balance);
1605     }
1606     
1607     function purchasedCount(address addr) external view returns (uint256) {
1608         return listPurchases[addr];
1609     }
1610     
1611     // Owner functions for enabling presale, sale, revealing and setting the provenance hash
1612     function lockMetadata() external onlyOwner {
1613         locked = true;
1614     }
1615     
1616     function toggleSaleStatus() external onlyOwner {
1617         saleLive = !saleLive;
1618     }
1619     
1620     function setSignerAddress(address addr) external onlyOwner {
1621         _signerAddress = addr;
1622     }
1623     
1624     function setProvenanceHash(string calldata hash) external onlyOwner notLocked {
1625         proof = hash;
1626     }
1627     
1628     function setContractURI(string calldata URI) external onlyOwner notLocked {
1629         _contractURI = URI;
1630     }
1631     
1632     function setBaseURI(string calldata URI) external onlyOwner notLocked {
1633         _tokenBaseURI = URI;
1634     }
1635     
1636     function contractURI() public view returns (string memory) {
1637         return _contractURI;
1638     }
1639     
1640     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1641         require(_exists(tokenId), "Cannot query non-existent token");
1642         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1643     }
1644 }