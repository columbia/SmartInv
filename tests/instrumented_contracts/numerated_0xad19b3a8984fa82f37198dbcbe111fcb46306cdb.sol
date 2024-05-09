1 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
9  *
10  * These functions can be used to verify that a message was signed by the holder
11  * of the private keys of a given address.
12  */
13 library ECDSA {
14     enum RecoverError {
15         NoError,
16         InvalidSignature,
17         InvalidSignatureLength,
18         InvalidSignatureS,
19         InvalidSignatureV
20     }
21 
22     function _throwError(RecoverError error) private pure {
23         if (error == RecoverError.NoError) {
24             return; // no error: do nothing
25         } else if (error == RecoverError.InvalidSignature) {
26             revert("ECDSA: invalid signature");
27         } else if (error == RecoverError.InvalidSignatureLength) {
28             revert("ECDSA: invalid signature length");
29         } else if (error == RecoverError.InvalidSignatureS) {
30             revert("ECDSA: invalid signature 's' value");
31         } else if (error == RecoverError.InvalidSignatureV) {
32             revert("ECDSA: invalid signature 'v' value");
33         }
34     }
35 
36     /**
37      * @dev Returns the address that signed a hashed message (`hash`) with
38      * `signature` or error string. This address can then be used for verification purposes.
39      *
40      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
41      * this function rejects them by requiring the `s` value to be in the lower
42      * half order, and the `v` value to be either 27 or 28.
43      *
44      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
45      * verification to be secure: it is possible to craft signatures that
46      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
47      * this is by receiving a hash of the original message (which may otherwise
48      * be too long), and then calling {toEthSignedMessageHash} on it.
49      *
50      * Documentation for signature generation:
51      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
52      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
53      *
54      * _Available since v4.3._
55      */
56     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
57         // Check the signature length
58         // - case 65: r,s,v signature (standard)
59         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
60         if (signature.length == 65) {
61             bytes32 r;
62             bytes32 s;
63             uint8 v;
64             // ecrecover takes the signature parameters, and the only way to get them
65             // currently is to use assembly.
66             assembly {
67                 r := mload(add(signature, 0x20))
68                 s := mload(add(signature, 0x40))
69                 v := byte(0, mload(add(signature, 0x60)))
70             }
71             return tryRecover(hash, v, r, s);
72         } else if (signature.length == 64) {
73             bytes32 r;
74             bytes32 vs;
75             // ecrecover takes the signature parameters, and the only way to get them
76             // currently is to use assembly.
77             assembly {
78                 r := mload(add(signature, 0x20))
79                 vs := mload(add(signature, 0x40))
80             }
81             return tryRecover(hash, r, vs);
82         } else {
83             return (address(0), RecoverError.InvalidSignatureLength);
84         }
85     }
86 
87     /**
88      * @dev Returns the address that signed a hashed message (`hash`) with
89      * `signature`. This address can then be used for verification purposes.
90      *
91      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
92      * this function rejects them by requiring the `s` value to be in the lower
93      * half order, and the `v` value to be either 27 or 28.
94      *
95      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
96      * verification to be secure: it is possible to craft signatures that
97      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
98      * this is by receiving a hash of the original message (which may otherwise
99      * be too long), and then calling {toEthSignedMessageHash} on it.
100      */
101     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
102         (address recovered, RecoverError error) = tryRecover(hash, signature);
103         _throwError(error);
104         return recovered;
105     }
106 
107     /**
108      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
109      *
110      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
111      *
112      * _Available since v4.3._
113      */
114     function tryRecover(
115         bytes32 hash,
116         bytes32 r,
117         bytes32 vs
118     ) internal pure returns (address, RecoverError) {
119         bytes32 s;
120         uint8 v;
121         assembly {
122             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
123             v := add(shr(255, vs), 27)
124         }
125         return tryRecover(hash, v, r, s);
126     }
127 
128     /**
129      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
130      *
131      * _Available since v4.2._
132      */
133     function recover(
134         bytes32 hash,
135         bytes32 r,
136         bytes32 vs
137     ) internal pure returns (address) {
138         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
139         _throwError(error);
140         return recovered;
141     }
142 
143     /**
144      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
145      * `r` and `s` signature fields separately.
146      *
147      * _Available since v4.3._
148      */
149     function tryRecover(
150         bytes32 hash,
151         uint8 v,
152         bytes32 r,
153         bytes32 s
154     ) internal pure returns (address, RecoverError) {
155         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
156         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
157         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
158         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
159         //
160         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
161         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
162         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
163         // these malleable signatures as well.
164         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
165             return (address(0), RecoverError.InvalidSignatureS);
166         }
167         if (v != 27 && v != 28) {
168             return (address(0), RecoverError.InvalidSignatureV);
169         }
170 
171         // If the signature is valid (and not malleable), return the signer address
172         address signer = ecrecover(hash, v, r, s);
173         if (signer == address(0)) {
174             return (address(0), RecoverError.InvalidSignature);
175         }
176 
177         return (signer, RecoverError.NoError);
178     }
179 
180     /**
181      * @dev Overload of {ECDSA-recover} that receives the `v`,
182      * `r` and `s` signature fields separately.
183      */
184     function recover(
185         bytes32 hash,
186         uint8 v,
187         bytes32 r,
188         bytes32 s
189     ) internal pure returns (address) {
190         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
191         _throwError(error);
192         return recovered;
193     }
194 
195     /**
196      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
197      * produces hash corresponding to the one signed with the
198      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
199      * JSON-RPC method as part of EIP-191.
200      *
201      * See {recover}.
202      */
203     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
204         // 32 is the length in bytes of hash,
205         // enforced by the type signature above
206         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
207     }
208 
209     /**
210      * @dev Returns an Ethereum Signed Typed Data, created from a
211      * `domainSeparator` and a `structHash`. This produces hash corresponding
212      * to the one signed with the
213      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
214      * JSON-RPC method as part of EIP-712.
215      *
216      * See {recover}.
217      */
218     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
219         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Strings.sol
224 
225 
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev String operations.
231  */
232 library Strings {
233     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
237      */
238     function toString(uint256 value) internal pure returns (string memory) {
239         // Inspired by OraclizeAPI's implementation - MIT licence
240         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
241 
242         if (value == 0) {
243             return "0";
244         }
245         uint256 temp = value;
246         uint256 digits;
247         while (temp != 0) {
248             digits++;
249             temp /= 10;
250         }
251         bytes memory buffer = new bytes(digits);
252         while (value != 0) {
253             digits -= 1;
254             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
255             value /= 10;
256         }
257         return string(buffer);
258     }
259 
260     /**
261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
262      */
263     function toHexString(uint256 value) internal pure returns (string memory) {
264         if (value == 0) {
265             return "0x00";
266         }
267         uint256 temp = value;
268         uint256 length = 0;
269         while (temp != 0) {
270             length++;
271             temp >>= 8;
272         }
273         return toHexString(value, length);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
278      */
279     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
280         bytes memory buffer = new bytes(2 * length + 2);
281         buffer[0] = "0";
282         buffer[1] = "x";
283         for (uint256 i = 2 * length + 1; i > 1; --i) {
284             buffer[i] = _HEX_SYMBOLS[value & 0xf];
285             value >>= 4;
286         }
287         require(value == 0, "Strings: hex length insufficient");
288         return string(buffer);
289     }
290 }
291 
292 // File: @openzeppelin/contracts/utils/Context.sol
293 
294 
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Provides information about the current execution context, including the
300  * sender of the transaction and its data. While these are generally available
301  * via msg.sender and msg.data, they should not be accessed in such a direct
302  * manner, since when dealing with meta-transactions the account sending and
303  * paying for execution may not be the actual sender (as far as an application
304  * is concerned).
305  *
306  * This contract is only required for intermediate, library-like contracts.
307  */
308 abstract contract Context {
309     function _msgSender() internal view virtual returns (address) {
310         return msg.sender;
311     }
312 
313     function _msgData() internal view virtual returns (bytes calldata) {
314         return msg.data;
315     }
316 }
317 
318 // File: @openzeppelin/contracts/access/Ownable.sol
319 
320 
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Contract module which provides a basic access control mechanism, where
327  * there is an account (an owner) that can be granted exclusive access to
328  * specific functions.
329  *
330  * By default, the owner account will be the one that deploys the contract. This
331  * can later be changed with {transferOwnership}.
332  *
333  * This module is used through inheritance. It will make available the modifier
334  * `onlyOwner`, which can be applied to your functions to restrict their use to
335  * the owner.
336  */
337 abstract contract Ownable is Context {
338     address private _owner;
339 
340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
341 
342     /**
343      * @dev Initializes the contract setting the deployer as the initial owner.
344      */
345     constructor() {
346         _setOwner(_msgSender());
347     }
348 
349     /**
350      * @dev Returns the address of the current owner.
351      */
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355 
356     /**
357      * @dev Throws if called by any account other than the owner.
358      */
359     modifier onlyOwner() {
360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
361         _;
362     }
363 
364     /**
365      * @dev Leaves the contract without owner. It will not be possible to call
366      * `onlyOwner` functions anymore. Can only be called by the current owner.
367      *
368      * NOTE: Renouncing ownership will leave the contract without an owner,
369      * thereby removing any functionality that is only available to the owner.
370      */
371     function renounceOwnership() public virtual onlyOwner {
372         _setOwner(address(0));
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _setOwner(newOwner);
382     }
383 
384     function _setOwner(address newOwner) private {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 // File: @openzeppelin/contracts/utils/Address.sol
392 
393 
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      */
418     function isContract(address account) internal view returns (bool) {
419         // This method relies on extcodesize, which returns 0 for contracts in
420         // construction, since the code is only stored at the end of the
421         // constructor execution.
422 
423         uint256 size;
424         assembly {
425             size := extcodesize(account)
426         }
427         return size > 0;
428     }
429 
430     /**
431      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
432      * `recipient`, forwarding all available gas and reverting on errors.
433      *
434      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
435      * of certain opcodes, possibly making contracts go over the 2300 gas limit
436      * imposed by `transfer`, making them unable to receive funds via
437      * `transfer`. {sendValue} removes this limitation.
438      *
439      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
440      *
441      * IMPORTANT: because control is transferred to `recipient`, care must be
442      * taken to not create reentrancy vulnerabilities. Consider using
443      * {ReentrancyGuard} or the
444      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
445      */
446     function sendValue(address payable recipient, uint256 amount) internal {
447         require(address(this).balance >= amount, "Address: insufficient balance");
448 
449         (bool success, ) = recipient.call{value: amount}("");
450         require(success, "Address: unable to send value, recipient may have reverted");
451     }
452 
453     /**
454      * @dev Performs a Solidity function call using a low level `call`. A
455      * plain `call` is an unsafe replacement for a function call: use this
456      * function instead.
457      *
458      * If `target` reverts with a revert reason, it is bubbled up by this
459      * function (like regular Solidity function calls).
460      *
461      * Returns the raw returned data. To convert to the expected return value,
462      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
463      *
464      * Requirements:
465      *
466      * - `target` must be a contract.
467      * - calling `target` with `data` must not revert.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionCall(target, data, "Address: low-level call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
477      * `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, 0, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but also transferring `value` wei to `target`.
492      *
493      * Requirements:
494      *
495      * - the calling contract must have an ETH balance of at least `value`.
496      * - the called Solidity function must be `payable`.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value
504     ) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(address(this).balance >= value, "Address: insufficient balance for call");
521         require(isContract(target), "Address: call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.call{value: value}(data);
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
534         return functionStaticCall(target, data, "Address: low-level static call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
539      * but performing a static call.
540      *
541      * _Available since v3.3._
542      */
543     function functionStaticCall(
544         address target,
545         bytes memory data,
546         string memory errorMessage
547     ) internal view returns (bytes memory) {
548         require(isContract(target), "Address: static call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.staticcall(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         require(isContract(target), "Address: delegate call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.delegatecall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
583      * revert reason using the provided one.
584      *
585      * _Available since v4.3._
586      */
587     function verifyCallResult(
588         bool success,
589         bytes memory returndata,
590         string memory errorMessage
591     ) internal pure returns (bytes memory) {
592         if (success) {
593             return returndata;
594         } else {
595             // Look for revert reason and bubble it up if present
596             if (returndata.length > 0) {
597                 // The easiest way to bubble the revert reason is using memory via assembly
598 
599                 assembly {
600                     let returndata_size := mload(returndata)
601                     revert(add(32, returndata), returndata_size)
602                 }
603             } else {
604                 revert(errorMessage);
605             }
606         }
607     }
608 }
609 
610 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
611 
612 
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @title ERC721 token receiver interface
618  * @dev Interface for any contract that wants to support safeTransfers
619  * from ERC721 asset contracts.
620  */
621 interface IERC721Receiver {
622     /**
623      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
624      * by `operator` from `from`, this function is called.
625      *
626      * It must return its Solidity selector to confirm the token transfer.
627      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
628      *
629      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
630      */
631     function onERC721Received(
632         address operator,
633         address from,
634         uint256 tokenId,
635         bytes calldata data
636     ) external returns (bytes4);
637 }
638 
639 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
640 
641 
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Interface of the ERC165 standard, as defined in the
647  * https://eips.ethereum.org/EIPS/eip-165[EIP].
648  *
649  * Implementers can declare support of contract interfaces, which can then be
650  * queried by others ({ERC165Checker}).
651  *
652  * For an implementation, see {ERC165}.
653  */
654 interface IERC165 {
655     /**
656      * @dev Returns true if this contract implements the interface defined by
657      * `interfaceId`. See the corresponding
658      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
659      * to learn more about how these ids are created.
660      *
661      * This function call must use less than 30 000 gas.
662      */
663     function supportsInterface(bytes4 interfaceId) external view returns (bool);
664 }
665 
666 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
667 
668 
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @dev Implementation of the {IERC165} interface.
675  *
676  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
677  * for the additional interface id that will be supported. For example:
678  *
679  * ```solidity
680  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
682  * }
683  * ```
684  *
685  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
686  */
687 abstract contract ERC165 is IERC165 {
688     /**
689      * @dev See {IERC165-supportsInterface}.
690      */
691     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692         return interfaceId == type(IERC165).interfaceId;
693     }
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
697 
698 
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Required interface of an ERC721 compliant contract.
705  */
706 interface IERC721 is IERC165 {
707     /**
708      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
709      */
710     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
711 
712     /**
713      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
714      */
715     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
716 
717     /**
718      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
719      */
720     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
721 
722     /**
723      * @dev Returns the number of tokens in ``owner``'s account.
724      */
725     function balanceOf(address owner) external view returns (uint256 balance);
726 
727     /**
728      * @dev Returns the owner of the `tokenId` token.
729      *
730      * Requirements:
731      *
732      * - `tokenId` must exist.
733      */
734     function ownerOf(uint256 tokenId) external view returns (address owner);
735 
736     /**
737      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
738      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
739      *
740      * Requirements:
741      *
742      * - `from` cannot be the zero address.
743      * - `to` cannot be the zero address.
744      * - `tokenId` token must exist and be owned by `from`.
745      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) external;
755 
756     /**
757      * @dev Transfers `tokenId` token from `from` to `to`.
758      *
759      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must be owned by `from`.
766      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
767      *
768      * Emits a {Transfer} event.
769      */
770     function transferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) external;
775 
776     /**
777      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
778      * The approval is cleared when the token is transferred.
779      *
780      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
781      *
782      * Requirements:
783      *
784      * - The caller must own the token or be an approved operator.
785      * - `tokenId` must exist.
786      *
787      * Emits an {Approval} event.
788      */
789     function approve(address to, uint256 tokenId) external;
790 
791     /**
792      * @dev Returns the account approved for `tokenId` token.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must exist.
797      */
798     function getApproved(uint256 tokenId) external view returns (address operator);
799 
800     /**
801      * @dev Approve or remove `operator` as an operator for the caller.
802      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
803      *
804      * Requirements:
805      *
806      * - The `operator` cannot be the caller.
807      *
808      * Emits an {ApprovalForAll} event.
809      */
810     function setApprovalForAll(address operator, bool _approved) external;
811 
812     /**
813      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
814      *
815      * See {setApprovalForAll}
816      */
817     function isApprovedForAll(address owner, address operator) external view returns (bool);
818 
819     /**
820      * @dev Safely transfers `tokenId` token from `from` to `to`.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must exist and be owned by `from`.
827      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function safeTransferFrom(
833         address from,
834         address to,
835         uint256 tokenId,
836         bytes calldata data
837     ) external;
838 }
839 
840 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
841 
842 
843 
844 pragma solidity ^0.8.0;
845 
846 
847 /**
848  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
849  * @dev See https://eips.ethereum.org/EIPS/eip-721
850  */
851 interface IERC721Enumerable is IERC721 {
852     /**
853      * @dev Returns the total amount of tokens stored by the contract.
854      */
855     function totalSupply() external view returns (uint256);
856 
857     /**
858      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
859      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
860      */
861     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
862 
863     /**
864      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
865      * Use along with {totalSupply} to enumerate all tokens.
866      */
867     function tokenByIndex(uint256 index) external view returns (uint256);
868 }
869 
870 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
871 
872 
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**
878  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
879  * @dev See https://eips.ethereum.org/EIPS/eip-721
880  */
881 interface IERC721Metadata is IERC721 {
882     /**
883      * @dev Returns the token collection name.
884      */
885     function name() external view returns (string memory);
886 
887     /**
888      * @dev Returns the token collection symbol.
889      */
890     function symbol() external view returns (string memory);
891 
892     /**
893      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
894      */
895     function tokenURI(uint256 tokenId) external view returns (string memory);
896 }
897 
898 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
899 
900 
901 
902 pragma solidity ^0.8.0;
903 
904 
905 
906 
907 
908 
909 
910 
911 /**
912  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
913  * the Metadata extension, but not including the Enumerable extension, which is available separately as
914  * {ERC721Enumerable}.
915  */
916 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
917     using Address for address;
918     using Strings for uint256;
919 
920     // Token name
921     string private _name;
922 
923     // Token symbol
924     string private _symbol;
925 
926     // Mapping from token ID to owner address
927     mapping(uint256 => address) private _owners;
928 
929     // Mapping owner address to token count
930     mapping(address => uint256) private _balances;
931 
932     // Mapping from token ID to approved address
933     mapping(uint256 => address) private _tokenApprovals;
934 
935     // Mapping from owner to operator approvals
936     mapping(address => mapping(address => bool)) private _operatorApprovals;
937 
938     /**
939      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
940      */
941     constructor(string memory name_, string memory symbol_) {
942         _name = name_;
943         _symbol = symbol_;
944     }
945 
946     /**
947      * @dev See {IERC165-supportsInterface}.
948      */
949     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
950         return
951             interfaceId == type(IERC721).interfaceId ||
952             interfaceId == type(IERC721Metadata).interfaceId ||
953             super.supportsInterface(interfaceId);
954     }
955 
956     /**
957      * @dev See {IERC721-balanceOf}.
958      */
959     function balanceOf(address owner) public view virtual override returns (uint256) {
960         require(owner != address(0), "ERC721: balance query for the zero address");
961         return _balances[owner];
962     }
963 
964     /**
965      * @dev See {IERC721-ownerOf}.
966      */
967     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
968         address owner = _owners[tokenId];
969         require(owner != address(0), "ERC721: owner query for nonexistent token");
970         return owner;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-name}.
975      */
976     function name() public view virtual override returns (string memory) {
977         return _name;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-symbol}.
982      */
983     function symbol() public view virtual override returns (string memory) {
984         return _symbol;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-tokenURI}.
989      */
990     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
991         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
992 
993         string memory baseURI = _baseURI();
994         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
995     }
996 
997     /**
998      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
999      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1000      * by default, can be overriden in child contracts.
1001      */
1002     function _baseURI() internal view virtual returns (string memory) {
1003         return "";
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-approve}.
1008      */
1009     function approve(address to, uint256 tokenId) public virtual override {
1010         address owner = ERC721.ownerOf(tokenId);
1011         require(to != owner, "ERC721: approval to current owner");
1012 
1013         require(
1014             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1015             "ERC721: approve caller is not owner nor approved for all"
1016         );
1017 
1018         _approve(to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-getApproved}.
1023      */
1024     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1025         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1026 
1027         return _tokenApprovals[tokenId];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-setApprovalForAll}.
1032      */
1033     function setApprovalForAll(address operator, bool approved) public virtual override {
1034         require(operator != _msgSender(), "ERC721: approve to caller");
1035 
1036         _operatorApprovals[_msgSender()][operator] = approved;
1037         emit ApprovalForAll(_msgSender(), operator, approved);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-isApprovedForAll}.
1042      */
1043     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1044         return _operatorApprovals[owner][operator];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-transferFrom}.
1049      */
1050     function transferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         //solhint-disable-next-line max-line-length
1056         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1057 
1058         _transfer(from, to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-safeTransferFrom}.
1063      */
1064     function safeTransferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) public virtual override {
1069         safeTransferFrom(from, to, tokenId, "");
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-safeTransferFrom}.
1074      */
1075     function safeTransferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId,
1079         bytes memory _data
1080     ) public virtual override {
1081         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1082         _safeTransfer(from, to, tokenId, _data);
1083     }
1084 
1085     /**
1086      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1087      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1088      *
1089      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1090      *
1091      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1092      * implement alternative mechanisms to perform token transfer, such as signature-based.
1093      *
1094      * Requirements:
1095      *
1096      * - `from` cannot be the zero address.
1097      * - `to` cannot be the zero address.
1098      * - `tokenId` token must exist and be owned by `from`.
1099      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _safeTransfer(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) internal virtual {
1109         _transfer(from, to, tokenId);
1110         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1111     }
1112 
1113     /**
1114      * @dev Returns whether `tokenId` exists.
1115      *
1116      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1117      *
1118      * Tokens start existing when they are minted (`_mint`),
1119      * and stop existing when they are burned (`_burn`).
1120      */
1121     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1122         return _owners[tokenId] != address(0);
1123     }
1124 
1125     /**
1126      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must exist.
1131      */
1132     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1133         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1134         address owner = ERC721.ownerOf(tokenId);
1135         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1136     }
1137 
1138     /**
1139      * @dev Safely mints `tokenId` and transfers it to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `tokenId` must not exist.
1144      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _safeMint(address to, uint256 tokenId) internal virtual {
1149         _safeMint(to, tokenId, "");
1150     }
1151 
1152     /**
1153      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1154      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1155      */
1156     function _safeMint(
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) internal virtual {
1161         _mint(to, tokenId);
1162         require(
1163             _checkOnERC721Received(address(0), to, tokenId, _data),
1164             "ERC721: transfer to non ERC721Receiver implementer"
1165         );
1166     }
1167 
1168     /**
1169      * @dev Mints `tokenId` and transfers it to `to`.
1170      *
1171      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must not exist.
1176      * - `to` cannot be the zero address.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _mint(address to, uint256 tokenId) internal virtual {
1181         require(to != address(0), "ERC721: mint to the zero address");
1182         require(!_exists(tokenId), "ERC721: token already minted");
1183 
1184         _beforeTokenTransfer(address(0), to, tokenId);
1185 
1186         _balances[to] += 1;
1187         _owners[tokenId] = to;
1188 
1189         emit Transfer(address(0), to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId) internal virtual {
1203         address owner = ERC721.ownerOf(tokenId);
1204 
1205         _beforeTokenTransfer(owner, address(0), tokenId);
1206 
1207         // Clear approvals
1208         _approve(address(0), tokenId);
1209 
1210         _balances[owner] -= 1;
1211         delete _owners[tokenId];
1212 
1213         emit Transfer(owner, address(0), tokenId);
1214     }
1215 
1216     /**
1217      * @dev Transfers `tokenId` from `from` to `to`.
1218      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `tokenId` token must be owned by `from`.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _transfer(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) internal virtual {
1232         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1233         require(to != address(0), "ERC721: transfer to the zero address");
1234 
1235         _beforeTokenTransfer(from, to, tokenId);
1236 
1237         // Clear approvals from the previous owner
1238         _approve(address(0), tokenId);
1239 
1240         _balances[from] -= 1;
1241         _balances[to] += 1;
1242         _owners[tokenId] = to;
1243 
1244         emit Transfer(from, to, tokenId);
1245     }
1246 
1247     /**
1248      * @dev Approve `to` to operate on `tokenId`
1249      *
1250      * Emits a {Approval} event.
1251      */
1252     function _approve(address to, uint256 tokenId) internal virtual {
1253         _tokenApprovals[tokenId] = to;
1254         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1259      * The call is not executed if the target address is not a contract.
1260      *
1261      * @param from address representing the previous owner of the given token ID
1262      * @param to target address that will receive the tokens
1263      * @param tokenId uint256 ID of the token to be transferred
1264      * @param _data bytes optional data to send along with the call
1265      * @return bool whether the call correctly returned the expected magic value
1266      */
1267     function _checkOnERC721Received(
1268         address from,
1269         address to,
1270         uint256 tokenId,
1271         bytes memory _data
1272     ) private returns (bool) {
1273         if (to.isContract()) {
1274             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1275                 return retval == IERC721Receiver.onERC721Received.selector;
1276             } catch (bytes memory reason) {
1277                 if (reason.length == 0) {
1278                     revert("ERC721: transfer to non ERC721Receiver implementer");
1279                 } else {
1280                     assembly {
1281                         revert(add(32, reason), mload(reason))
1282                     }
1283                 }
1284             }
1285         } else {
1286             return true;
1287         }
1288     }
1289 
1290     /**
1291      * @dev Hook that is called before any token transfer. This includes minting
1292      * and burning.
1293      *
1294      * Calling conditions:
1295      *
1296      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1297      * transferred to `to`.
1298      * - When `from` is zero, `tokenId` will be minted for `to`.
1299      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1300      * - `from` and `to` are never both zero.
1301      *
1302      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1303      */
1304     function _beforeTokenTransfer(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) internal virtual {}
1309 }
1310 
1311 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1312 
1313 
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 
1318 
1319 /**
1320  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1321  * enumerability of all the token ids in the contract as well as all token ids owned by each
1322  * account.
1323  */
1324 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1325     // Mapping from owner to list of owned token IDs
1326     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1327 
1328     // Mapping from token ID to index of the owner tokens list
1329     mapping(uint256 => uint256) private _ownedTokensIndex;
1330 
1331     // Array with all token ids, used for enumeration
1332     uint256[] private _allTokens;
1333 
1334     // Mapping from token id to position in the allTokens array
1335     mapping(uint256 => uint256) private _allTokensIndex;
1336 
1337     /**
1338      * @dev See {IERC165-supportsInterface}.
1339      */
1340     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1341         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1342     }
1343 
1344     /**
1345      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1346      */
1347     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1348         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1349         return _ownedTokens[owner][index];
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Enumerable-totalSupply}.
1354      */
1355     function totalSupply() public view virtual override returns (uint256) {
1356         return _allTokens.length;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Enumerable-tokenByIndex}.
1361      */
1362     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1363         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1364         return _allTokens[index];
1365     }
1366 
1367     /**
1368      * @dev Hook that is called before any token transfer. This includes minting
1369      * and burning.
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` will be minted for `to`.
1376      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1377      * - `from` cannot be the zero address.
1378      * - `to` cannot be the zero address.
1379      *
1380      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1381      */
1382     function _beforeTokenTransfer(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) internal virtual override {
1387         super._beforeTokenTransfer(from, to, tokenId);
1388 
1389         if (from == address(0)) {
1390             _addTokenToAllTokensEnumeration(tokenId);
1391         } else if (from != to) {
1392             _removeTokenFromOwnerEnumeration(from, tokenId);
1393         }
1394         if (to == address(0)) {
1395             _removeTokenFromAllTokensEnumeration(tokenId);
1396         } else if (to != from) {
1397             _addTokenToOwnerEnumeration(to, tokenId);
1398         }
1399     }
1400 
1401     /**
1402      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1403      * @param to address representing the new owner of the given token ID
1404      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1405      */
1406     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1407         uint256 length = ERC721.balanceOf(to);
1408         _ownedTokens[to][length] = tokenId;
1409         _ownedTokensIndex[tokenId] = length;
1410     }
1411 
1412     /**
1413      * @dev Private function to add a token to this extension's token tracking data structures.
1414      * @param tokenId uint256 ID of the token to be added to the tokens list
1415      */
1416     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1417         _allTokensIndex[tokenId] = _allTokens.length;
1418         _allTokens.push(tokenId);
1419     }
1420 
1421     /**
1422      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1423      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1424      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1425      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1426      * @param from address representing the previous owner of the given token ID
1427      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1428      */
1429     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1430         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1431         // then delete the last slot (swap and pop).
1432 
1433         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1434         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1435 
1436         // When the token to delete is the last token, the swap operation is unnecessary
1437         if (tokenIndex != lastTokenIndex) {
1438             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1439 
1440             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1441             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1442         }
1443 
1444         // This also deletes the contents at the last position of the array
1445         delete _ownedTokensIndex[tokenId];
1446         delete _ownedTokens[from][lastTokenIndex];
1447     }
1448 
1449     /**
1450      * @dev Private function to remove a token from this extension's token tracking data structures.
1451      * This has O(1) time complexity, but alters the order of the _allTokens array.
1452      * @param tokenId uint256 ID of the token to be removed from the tokens list
1453      */
1454     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1455         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1456         // then delete the last slot (swap and pop).
1457 
1458         uint256 lastTokenIndex = _allTokens.length - 1;
1459         uint256 tokenIndex = _allTokensIndex[tokenId];
1460 
1461         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1462         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1463         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1464         uint256 lastTokenId = _allTokens[lastTokenIndex];
1465 
1466         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1467         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1468 
1469         // This also deletes the contents at the last position of the array
1470         delete _allTokensIndex[tokenId];
1471         _allTokens.pop();
1472     }
1473 }
1474 
1475 // File: contracts/MinterSuite.sol
1476 
1477 
1478 pragma solidity ^0.8.9;
1479 
1480 /*
1481      _  _ _ _  _ ___ ____ ____    ____ _  _ _ ___ ____
1482      |\/| | |\ |  |  |___ |__/    [__  |  | |  |  |___
1483     |  | | | \|  |  |___ |  \    ___] |__| |  |  |___
1484     Minter Suite / 2021 / V2.0
1485 */
1486 
1487 
1488 
1489 
1490 
1491 contract MinterSuite is ERC721Enumerable, Ownable {
1492     using Strings for uint256;
1493     
1494     uint256 public constant LIFETIME = 10;
1495     uint256 public constant RENEWAL = 512;
1496     uint256 public constant MAX = LIFETIME + RENEWAL;
1497     uint256 public constant RENEWAL_PRICE = 0.3 ether;
1498     uint256 public constant DISCOUNT_RENEWAL_PRICE = 0.24 ether;
1499     uint256 public constant RENEWAL_FEE = 0.1 ether;
1500     uint256 public constant LIFETIME_PRICE = 0.8 ether;
1501     uint256 public constant PER_MINT = 1;
1502     
1503     string private _tokenBaseURI = "https://minterbot.art/meta/";
1504     address private constant _owner2 = 0x32bA63cEBd73934a9139c67aa2B6cb7Ae1Aa3D49;
1505     
1506     mapping(address => bool) public discountList;
1507     mapping(uint256 => bool) public renewalList;
1508     mapping(address => uint256) public discountListPurchases;
1509     mapping(uint256 => uint256) public licenseExpiry;
1510     
1511     uint256 public lifetimeAmountMinted;
1512     uint256 public renewalAmountMinted;
1513     uint256 public discountPurchaseLimit = 1;
1514     bool public saleLive;
1515     
1516     constructor() ERC721("Minter Suite License", "MSL") { }
1517     
1518     modifier onlyEOA() {
1519         require(msg.sender == tx.origin, "CONTRACT_MINTING_NOT_PERMITTED");
1520         _;
1521     }
1522     
1523     function _isExpired(uint256 tokenId) internal view returns (bool) {
1524         return block.timestamp > licenseExpiry[tokenId];
1525     }
1526     
1527     function isExpired(uint256 tokenId) external view returns (bool) {
1528         require(_exists(tokenId), "INVALID_TOKEN");
1529         require(renewalList[tokenId], "NOT_RENEWAL");
1530         
1531         return _isExpired(tokenId);
1532     }
1533     
1534     function getExpiryTime(uint256 tokenId) external view returns (uint256) {
1535         require(_exists(tokenId), "INVALID_TOKEN");
1536         require(renewalList[tokenId], "NOT_RENEWAL");
1537         
1538         return licenseExpiry[tokenId];
1539     }
1540     
1541     function addToDiscounList(address[] calldata wallets) external onlyOwner {
1542         for (uint256 i = 0; i < wallets.length; i++) {
1543             address wallet = wallets[i];
1544             require(wallet != address(0), "NULL_ADDRESS");
1545             require(discountList[wallet] != true, "DUPLICATE_WALLET");
1546             
1547             discountList[wallet] = true;
1548         }
1549     }
1550     
1551     function removeFromDiscountList(address[] calldata wallets) external onlyOwner {
1552         for (uint256 i = 0; i < wallets.length; i++) {
1553             address wallet = wallets[i];
1554             require(wallet != address(0), "NULL_ADDRESS");
1555             
1556             discountList[wallet] = false;
1557         }
1558     }
1559 
1560     function renew(uint256 tokenId) external payable onlyEOA {
1561         require(_exists(tokenId), "INVALID_TOKEN");
1562         require(renewalList[tokenId], "NOT_RENEWAL");
1563         require(RENEWAL_FEE <= msg.value, "INSUFFICIENT_ETH");
1564         
1565         if (_isExpired(tokenId)) {
1566             licenseExpiry[tokenId] = block.timestamp + 30 days;
1567         }
1568         else {
1569             licenseExpiry[tokenId] += 30 days;
1570         }
1571     }
1572 
1573     function buyDiscountedRenewal() external payable onlyEOA {
1574         require(saleLive, "SALE_CLOSED");
1575         require(discountList[msg.sender], "NOT_PERMITTED");
1576         require(totalSupply() < MAX, "OUT_OF_STOCK");
1577         require(renewalAmountMinted + PER_MINT <= RENEWAL, "EXCEED_RENEWAL");
1578         require(discountListPurchases[msg.sender] + PER_MINT <= discountPurchaseLimit, "EXCEED_DISCOUNT_LIMIT");
1579         require(DISCOUNT_RENEWAL_PRICE * PER_MINT <= msg.value, "INSUFFICIENT_ETH");
1580         
1581         renewalAmountMinted++;
1582         discountListPurchases[msg.sender]++;
1583         
1584         uint256 tokenId = totalSupply() + 1;
1585         licenseExpiry[tokenId] = block.timestamp + 30 days;
1586         renewalList[tokenId] = true;
1587         _safeMint(msg.sender, tokenId);
1588     }
1589     
1590     function buyRenewal() external payable onlyEOA {
1591         require(saleLive, "SALE_CLOSED");
1592         require(totalSupply() < MAX, "OUT_OF_STOCK");
1593         require(renewalAmountMinted + PER_MINT <= RENEWAL, "EXCEED_RENEWAL");
1594         require(RENEWAL_PRICE * PER_MINT <= msg.value, "INSUFFICIENT_ETH");
1595         
1596         renewalAmountMinted++;
1597         
1598         uint256 tokenId = totalSupply() + 1;
1599         licenseExpiry[tokenId] = block.timestamp + 30 days;
1600         renewalList[tokenId] = true;
1601         _safeMint(msg.sender, tokenId);
1602     }
1603     
1604     function buyLifetime() external payable onlyEOA {
1605         require(saleLive, "SALE_CLOSED");
1606         require(totalSupply() < MAX, "OUT_OF_STOCK");
1607         require(lifetimeAmountMinted + PER_MINT <= LIFETIME, "EXCEED_LIFETIME");
1608         require(LIFETIME_PRICE * PER_MINT <= msg.value, "INSUFFICIENT_ETH");
1609         
1610         lifetimeAmountMinted++;
1611         _safeMint(msg.sender, totalSupply() + 1);
1612     }
1613     
1614     function withdraw() external onlyOwner {
1615         payable(_owner2).transfer(address(this).balance / 2);
1616         payable(msg.sender).transfer(address(this).balance);
1617     }
1618     
1619     function isDiscounted(address addr) external view returns (bool) {
1620         require(addr != address(0), "NULL_ADDRESS");
1621         return discountList[addr];
1622     }
1623     
1624     function hasDiscountUsed(address addr) external view returns (uint256) {
1625         require(addr != address(0), "NULL_ADDRESS");
1626         require(discountList[addr], "NOT_PERMITTED");
1627         return discountListPurchases[addr];
1628     }
1629     
1630     function toggleSaleLiveStatus() external onlyOwner {
1631         saleLive = !saleLive;
1632     }
1633 
1634     function setBaseURI(string calldata URI) external onlyOwner {
1635         _tokenBaseURI = URI;
1636     }
1637     
1638     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1639         require(_exists(tokenId), "Cannot query non-existent token");
1640         
1641         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1642     }
1643 }