1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 // File: ECDSA.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 
75 /**
76  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
77  *
78  * These functions can be used to verify that a message was signed by the holder
79  * of the private keys of a given address.
80  */
81 library ECDSA {
82     enum RecoverError {
83         NoError,
84         InvalidSignature,
85         InvalidSignatureLength,
86         InvalidSignatureS,
87         InvalidSignatureV
88     }
89 
90     function _throwError(RecoverError error) private pure {
91         if (error == RecoverError.NoError) {
92             return; // no error: do nothing
93         } else if (error == RecoverError.InvalidSignature) {
94             revert("ECDSA: invalid signature");
95         } else if (error == RecoverError.InvalidSignatureLength) {
96             revert("ECDSA: invalid signature length");
97         } else if (error == RecoverError.InvalidSignatureS) {
98             revert("ECDSA: invalid signature 's' value");
99         } else if (error == RecoverError.InvalidSignatureV) {
100             revert("ECDSA: invalid signature 'v' value");
101         }
102     }
103 
104     /**
105      * @dev Returns the address that signed a hashed message (`hash`) with
106      * `signature` or error string. This address can then be used for verification purposes.
107      *
108      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
109      * this function rejects them by requiring the `s` value to be in the lower
110      * half order, and the `v` value to be either 27 or 28.
111      *
112      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
113      * verification to be secure: it is possible to craft signatures that
114      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
115      * this is by receiving a hash of the original message (which may otherwise
116      * be too long), and then calling {toEthSignedMessageHash} on it.
117      *
118      * Documentation for signature generation:
119      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
120      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
121      *
122      * _Available since v4.3._
123      */
124     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
125         // Check the signature length
126         // - case 65: r,s,v signature (standard)
127         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
128         if (signature.length == 65) {
129             bytes32 r;
130             bytes32 s;
131             uint8 v;
132             // ecrecover takes the signature parameters, and the only way to get them
133             // currently is to use assembly.
134             assembly {
135                 r := mload(add(signature, 0x20))
136                 s := mload(add(signature, 0x40))
137                 v := byte(0, mload(add(signature, 0x60)))
138             }
139             return tryRecover(hash, v, r, s);
140         } else if (signature.length == 64) {
141             bytes32 r;
142             bytes32 vs;
143             // ecrecover takes the signature parameters, and the only way to get them
144             // currently is to use assembly.
145             assembly {
146                 r := mload(add(signature, 0x20))
147                 vs := mload(add(signature, 0x40))
148             }
149             return tryRecover(hash, r, vs);
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
298 // File: Context.sol
299 
300 
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Provides information about the current execution context, including the
306  * sender of the transaction and its data. While these are generally available
307  * via msg.sender and msg.data, they should not be accessed in such a direct
308  * manner, since when dealing with meta-transactions the account sending and
309  * paying for execution may not be the actual sender (as far as an application
310  * is concerned).
311  *
312  * This contract is only required for intermediate, library-like contracts.
313  */
314 abstract contract Context {
315     function _msgSender() internal view virtual returns (address) {
316         return msg.sender;
317     }
318 
319     function _msgData() internal view virtual returns (bytes calldata) {
320         return msg.data;
321     }
322 }
323 // File: Ownable.sol
324 
325 
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Contract module which provides a basic access control mechanism, where
332  * there is an account (an owner) that can be granted exclusive access to
333  * specific functions.
334  *
335  * By default, the owner account will be the one that deploys the contract. This
336  * can later be changed with {transferOwnership}.
337  *
338  * This module is used through inheritance. It will make available the modifier
339  * `onlyOwner`, which can be applied to your functions to restrict their use to
340  * the owner.
341  */
342 abstract contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351         _setOwner(_msgSender());
352     }
353 
354     /**
355      * @dev Returns the address of the current owner.
356      */
357     function owner() public view virtual returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     /**
370      * @dev Leaves the contract without owner. It will not be possible to call
371      * `onlyOwner` functions anymore. Can only be called by the current owner.
372      *
373      * NOTE: Renouncing ownership will leave the contract without an owner,
374      * thereby removing any functionality that is only available to the owner.
375      */
376     function renounceOwnership() public virtual onlyOwner {
377         _setOwner(address(0));
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Can only be called by the current owner.
383      */
384     function transferOwnership(address newOwner) public virtual onlyOwner {
385         require(newOwner != address(0), "Ownable: new owner is the zero address");
386         _setOwner(newOwner);
387     }
388 
389     function _setOwner(address newOwner) private {
390         address oldOwner = _owner;
391         _owner = newOwner;
392         emit OwnershipTransferred(oldOwner, newOwner);
393     }
394 }
395 // File: Address.sol
396 
397 
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * [IMPORTANT]
409      * ====
410      * It is unsafe to assume that an address for which this function returns
411      * false is an externally-owned account (EOA) and not a contract.
412      *
413      * Among others, `isContract` will return false for the following
414      * types of addresses:
415      *
416      *  - an externally-owned account
417      *  - a contract in construction
418      *  - an address where a contract will be created
419      *  - an address where a contract lived, but was destroyed
420      * ====
421      */
422     function isContract(address account) internal view returns (bool) {
423         // This method relies on extcodesize, which returns 0 for contracts in
424         // construction, since the code is only stored at the end of the
425         // constructor execution.
426 
427         uint256 size;
428         assembly {
429             size := extcodesize(account)
430         }
431         return size > 0;
432     }
433 
434     /**
435      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
436      * `recipient`, forwarding all available gas and reverting on errors.
437      *
438      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
439      * of certain opcodes, possibly making contracts go over the 2300 gas limit
440      * imposed by `transfer`, making them unable to receive funds via
441      * `transfer`. {sendValue} removes this limitation.
442      *
443      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
444      *
445      * IMPORTANT: because control is transferred to `recipient`, care must be
446      * taken to not create reentrancy vulnerabilities. Consider using
447      * {ReentrancyGuard} or the
448      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
449      */
450     function sendValue(address payable recipient, uint256 amount) internal {
451         require(address(this).balance >= amount, "Address: insufficient balance");
452 
453         (bool success, ) = recipient.call{value: amount}("");
454         require(success, "Address: unable to send value, recipient may have reverted");
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain `call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionCall(target, data, "Address: low-level call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
481      * `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
514      * with `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         require(address(this).balance >= value, "Address: insufficient balance for call");
525         require(isContract(target), "Address: call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.call{value: value}(data);
528         return _verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
538         return functionStaticCall(target, data, "Address: low-level static call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
543      * but performing a static call.
544      *
545      * _Available since v3.3._
546      */
547     function functionStaticCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal view returns (bytes memory) {
552         require(isContract(target), "Address: static call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.staticcall(data);
555         return _verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
565         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(isContract(target), "Address: delegate call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.delegatecall(data);
582         return _verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     function _verifyCallResult(
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) private pure returns (bytes memory) {
590         if (success) {
591             return returndata;
592         } else {
593             // Look for revert reason and bubble it up if present
594             if (returndata.length > 0) {
595                 // The easiest way to bubble the revert reason is using memory via assembly
596 
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @title ERC721 token receiver interface
613  * @dev Interface for any contract that wants to support safeTransfers
614  * from ERC721 asset contracts.
615  */
616 interface IERC721Receiver {
617     /**
618      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
619      * by `operator` from `from`, this function is called.
620      *
621      * It must return its Solidity selector to confirm the token transfer.
622      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
623      *
624      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
625      */
626     function onERC721Received(
627         address operator,
628         address from,
629         uint256 tokenId,
630         bytes calldata data
631     ) external returns (bytes4);
632 }
633 // File: IERC165.sol
634 
635 
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev Interface of the ERC165 standard, as defined in the
641  * https://eips.ethereum.org/EIPS/eip-165[EIP].
642  *
643  * Implementers can declare support of contract interfaces, which can then be
644  * queried by others ({ERC165Checker}).
645  *
646  * For an implementation, see {ERC165}.
647  */
648 interface IERC165 {
649     /**
650      * @dev Returns true if this contract implements the interface defined by
651      * `interfaceId`. See the corresponding
652      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
653      * to learn more about how these ids are created.
654      *
655      * This function call must use less than 30 000 gas.
656      */
657     function supportsInterface(bytes4 interfaceId) external view returns (bool);
658 }
659 // File: ERC165.sol
660 
661 
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @dev Implementation of the {IERC165} interface.
668  *
669  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
670  * for the additional interface id that will be supported. For example:
671  *
672  * ```solidity
673  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
675  * }
676  * ```
677  *
678  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
679  */
680 abstract contract ERC165 is IERC165 {
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685         return interfaceId == type(IERC165).interfaceId;
686     }
687 }
688 // File: IERC721.sol
689 
690 
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @dev Required interface of an ERC721 compliant contract.
697  */
698 interface IERC721 is IERC165 {
699     /**
700      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
701      */
702     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
703 
704     /**
705      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
706      */
707     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
708 
709     /**
710      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
711      */
712     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
713 
714     /**
715      * @dev Returns the number of tokens in ``owner``'s account.
716      */
717     function balanceOf(address owner) external view returns (uint256 balance);
718 
719     /**
720      * @dev Returns the owner of the `tokenId` token.
721      *
722      * Requirements:
723      *
724      * - `tokenId` must exist.
725      */
726     function ownerOf(uint256 tokenId) external view returns (address owner);
727 
728     /**
729      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
730      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
731      *
732      * Requirements:
733      *
734      * - `from` cannot be the zero address.
735      * - `to` cannot be the zero address.
736      * - `tokenId` token must exist and be owned by `from`.
737      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
738      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
739      *
740      * Emits a {Transfer} event.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) external;
747 
748     /**
749      * @dev Transfers `tokenId` token from `from` to `to`.
750      *
751      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must be owned by `from`.
758      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
759      *
760      * Emits a {Transfer} event.
761      */
762     function transferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) external;
767 
768     /**
769      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
770      * The approval is cleared when the token is transferred.
771      *
772      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
773      *
774      * Requirements:
775      *
776      * - The caller must own the token or be an approved operator.
777      * - `tokenId` must exist.
778      *
779      * Emits an {Approval} event.
780      */
781     function approve(address to, uint256 tokenId) external;
782 
783     /**
784      * @dev Returns the account approved for `tokenId` token.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must exist.
789      */
790     function getApproved(uint256 tokenId) external view returns (address operator);
791 
792     /**
793      * @dev Approve or remove `operator` as an operator for the caller.
794      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
795      *
796      * Requirements:
797      *
798      * - The `operator` cannot be the caller.
799      *
800      * Emits an {ApprovalForAll} event.
801      */
802     function setApprovalForAll(address operator, bool _approved) external;
803 
804     /**
805      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
806      *
807      * See {setApprovalForAll}
808      */
809     function isApprovedForAll(address owner, address operator) external view returns (bool);
810 
811     /**
812      * @dev Safely transfers `tokenId` token from `from` to `to`.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must exist and be owned by `from`.
819      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes calldata data
829     ) external;
830 }
831 // File: IERC721Enumerable.sol
832 
833 
834 
835 pragma solidity ^0.8.0;
836 
837 
838 /**
839  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
840  * @dev See https://eips.ethereum.org/EIPS/eip-721
841  */
842 interface IERC721Enumerable is IERC721 {
843     /**
844      * @dev Returns the total amount of tokens stored by the contract.
845      */
846     function totalSupply() external view returns (uint256);
847 
848     /**
849      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
850      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
851      */
852     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
853 
854     /**
855      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
856      * Use along with {totalSupply} to enumerate all tokens.
857      */
858     function tokenByIndex(uint256 index) external view returns (uint256);
859 }
860 // File: IERC721Metadata.sol
861 
862 
863 
864 pragma solidity ^0.8.0;
865 
866 
867 /**
868  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
869  * @dev See https://eips.ethereum.org/EIPS/eip-721
870  */
871 interface IERC721Metadata is IERC721 {
872     /**
873      * @dev Returns the token collection name.
874      */
875     function name() external view returns (string memory);
876 
877     /**
878      * @dev Returns the token collection symbol.
879      */
880     function symbol() external view returns (string memory);
881 
882     /**
883      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
884      */
885     function tokenURI(uint256 tokenId) external view returns (string memory);
886 }
887 // File: ERC721A.sol
888 
889 
890 pragma solidity ^0.8.0;
891 
892 
893 
894 
895 
896 
897 
898 
899 
900 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
901     using Address for address;
902     using Strings for uint256;
903 
904     struct TokenOwnership {
905         address addr;
906         uint64 startTimestamp;
907     }
908 
909     struct AddressData {
910         uint128 balance;
911         uint128 numberMinted;
912     }
913 
914     uint256 internal currentIndex;
915 
916     // Token name
917     string private _name;
918 
919     // Token symbol
920     string private _symbol;
921 
922     // Mapping from token ID to ownership details
923     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
924     mapping(uint256 => TokenOwnership) internal _ownerships;
925 
926     // Mapping owner address to address data
927     mapping(address => AddressData) private _addressData;
928 
929     // Mapping from token ID to approved address
930     mapping(uint256 => address) private _tokenApprovals;
931 
932     // Mapping from owner to operator approvals
933     mapping(address => mapping(address => bool)) private _operatorApprovals;
934 
935     constructor(string memory name_, string memory symbol_) {
936         _name = name_;
937         _symbol = symbol_;
938     }
939 
940     /**
941      * @dev See {IERC721Enumerable-totalSupply}.
942      */
943     function totalSupply() public view override returns (uint256) {
944         return currentIndex;
945     }
946 
947     /**
948      * @dev See {IERC721Enumerable-tokenByIndex}.
949      */
950     function tokenByIndex(uint256 index) public view override returns (uint256) {
951         require(index < totalSupply(), 'ERC721A: global index out of bounds');
952         return index;
953     }
954 
955     /**
956      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
957      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
958      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
959      */
960     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
961         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
962         uint256 numMintedSoFar = totalSupply();
963         uint256 tokenIdsIdx;
964         address currOwnershipAddr;
965 
966         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
967         unchecked {
968             for (uint256 i; i < numMintedSoFar; i++) {
969                 TokenOwnership memory ownership = _ownerships[i];
970                 if (ownership.addr != address(0)) {
971                     currOwnershipAddr = ownership.addr;
972                 }
973                 if (currOwnershipAddr == owner) {
974                     if (tokenIdsIdx == index) {
975                         return i;
976                     }
977                     tokenIdsIdx++;
978                 }
979             }
980         }
981 
982         revert('ERC721A: unable to get token of owner by index');
983     }
984 
985     /**
986      * @dev See {IERC165-supportsInterface}.
987      */
988     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
989         return
990             interfaceId == type(IERC721).interfaceId ||
991             interfaceId == type(IERC721Metadata).interfaceId ||
992             interfaceId == type(IERC721Enumerable).interfaceId ||
993             super.supportsInterface(interfaceId);
994     }
995 
996     /**
997      * @dev See {IERC721-balanceOf}.
998      */
999     function balanceOf(address owner) public view override returns (uint256) {
1000         require(owner != address(0), 'ERC721A: balance query for the zero address');
1001         return uint256(_addressData[owner].balance);
1002     }
1003 
1004     function _numberMinted(address owner) internal view returns (uint256) {
1005         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1006         return uint256(_addressData[owner].numberMinted);
1007     }
1008 
1009     /**
1010      * Gas spent here starts off proportional to the maximum mint batch size.
1011      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1012      */
1013     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1014         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1015 
1016         unchecked {
1017             for (uint256 curr = tokenId; curr >= 0; curr--) {
1018                 TokenOwnership memory ownership = _ownerships[curr];
1019                 if (ownership.addr != address(0)) {
1020                     return ownership;
1021                 }
1022             }
1023         }
1024 
1025         revert('ERC721A: unable to determine the owner of token');
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-ownerOf}.
1030      */
1031     function ownerOf(uint256 tokenId) public view override returns (address) {
1032         return ownershipOf(tokenId).addr;
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Metadata-name}.
1037      */
1038     function name() public view virtual override returns (string memory) {
1039         return _name;
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Metadata-symbol}.
1044      */
1045     function symbol() public view virtual override returns (string memory) {
1046         return _symbol;
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Metadata-tokenURI}.
1051      */
1052     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1053         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1054 
1055         string memory baseURI = _baseURI();
1056         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1057     }
1058 
1059     /**
1060      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1061      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1062      * by default, can be overriden in child contracts.
1063      */
1064     function _baseURI() internal view virtual returns (string memory) {
1065         return '';
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-approve}.
1070      */
1071     function approve(address to, uint256 tokenId) public override {
1072         address owner = ERC721A.ownerOf(tokenId);
1073         require(to != owner, 'ERC721A: approval to current owner');
1074 
1075         require(
1076             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1077             'ERC721A: approve caller is not owner nor approved for all'
1078         );
1079 
1080         _approve(to, tokenId, owner);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-getApproved}.
1085      */
1086     function getApproved(uint256 tokenId) public view override returns (address) {
1087         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1088 
1089         return _tokenApprovals[tokenId];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-setApprovalForAll}.
1094      */
1095     function setApprovalForAll(address operator, bool approved) public override {
1096         require(operator != _msgSender(), 'ERC721A: approve to caller');
1097 
1098         _operatorApprovals[_msgSender()][operator] = approved;
1099         emit ApprovalForAll(_msgSender(), operator, approved);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-isApprovedForAll}.
1104      */
1105     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1106         return _operatorApprovals[owner][operator];
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-transferFrom}.
1111      */
1112     function transferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId
1116     ) public override {
1117         _transfer(from, to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-safeTransferFrom}.
1122      */
1123     function safeTransferFrom(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) public override {
1128         safeTransferFrom(from, to, tokenId, '');
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-safeTransferFrom}.
1133      */
1134     function safeTransferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) public override {
1140         _transfer(from, to, tokenId);
1141         require(
1142             _checkOnERC721Received(from, to, tokenId, _data),
1143             'ERC721A: transfer to non ERC721Receiver implementer'
1144         );
1145     }
1146 
1147     /**
1148      * @dev Returns whether `tokenId` exists.
1149      *
1150      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1151      *
1152      * Tokens start existing when they are minted (`_mint`),
1153      */
1154     function _exists(uint256 tokenId) internal view returns (bool) {
1155         return tokenId < currentIndex;
1156     }
1157 
1158     function _safeMint(address to, uint256 quantity) internal {
1159         _safeMint(to, quantity, '');
1160     }
1161 
1162     /**
1163      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1168      * - `quantity` must be greater than 0.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _safeMint(
1173         address to,
1174         uint256 quantity,
1175         bytes memory _data
1176     ) internal {
1177         _mint(to, quantity, _data, true);
1178     }
1179 
1180     /**
1181      * @dev Mints `quantity` tokens and transfers them to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `quantity` must be greater than 0.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _mint(
1191         address to,
1192         uint256 quantity,
1193         bytes memory _data,
1194         bool safe
1195     ) internal {
1196         uint256 startTokenId = currentIndex;
1197         require(to != address(0), 'ERC721A: mint to the zero address');
1198         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1199 
1200         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1201 
1202         // Overflows are incredibly unrealistic.
1203         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1204         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1205         unchecked {
1206             _addressData[to].balance += uint128(quantity);
1207             _addressData[to].numberMinted += uint128(quantity);
1208 
1209             _ownerships[startTokenId].addr = to;
1210             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1211 
1212             uint256 updatedIndex = startTokenId;
1213 
1214             for (uint256 i; i < quantity; i++) {
1215                 emit Transfer(address(0), to, updatedIndex);
1216                 if (safe) {
1217                     require(
1218                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1219                         'ERC721A: transfer to non ERC721Receiver implementer'
1220                     );
1221                 }
1222 
1223                 updatedIndex++;
1224             }
1225 
1226             currentIndex = updatedIndex;
1227         }
1228 
1229         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1230     }
1231 
1232     /**
1233      * @dev Transfers `tokenId` from `from` to `to`.
1234      *
1235      * Requirements:
1236      *
1237      * - `to` cannot be the zero address.
1238      * - `tokenId` token must be owned by `from`.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _transfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) private {
1247         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1248 
1249         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1250             getApproved(tokenId) == _msgSender() ||
1251             isApprovedForAll(prevOwnership.addr, _msgSender()));
1252 
1253         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1254 
1255         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1256         require(to != address(0), 'ERC721A: transfer to the zero address');
1257 
1258         _beforeTokenTransfers(from, to, tokenId, 1);
1259 
1260         // Clear approvals from the previous owner
1261         _approve(address(0), tokenId, prevOwnership.addr);
1262 
1263         // Underflow of the sender's balance is impossible because we check for
1264         // ownership above and the recipient's balance can't realistically overflow.
1265         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1266         unchecked {
1267             _addressData[from].balance -= 1;
1268             _addressData[to].balance += 1;
1269 
1270             _ownerships[tokenId].addr = to;
1271             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1272 
1273             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1274             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1275             uint256 nextTokenId = tokenId + 1;
1276             if (_ownerships[nextTokenId].addr == address(0)) {
1277                 if (_exists(nextTokenId)) {
1278                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1279                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(from, to, tokenId);
1285         _afterTokenTransfers(from, to, tokenId, 1);
1286     }
1287 
1288     /**
1289      * @dev Approve `to` to operate on `tokenId`
1290      *
1291      * Emits a {Approval} event.
1292      */
1293     function _approve(
1294         address to,
1295         uint256 tokenId,
1296         address owner
1297     ) private {
1298         _tokenApprovals[tokenId] = to;
1299         emit Approval(owner, to, tokenId);
1300     }
1301 
1302     /**
1303      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1304      * The call is not executed if the target address is not a contract.
1305      *
1306      * @param from address representing the previous owner of the given token ID
1307      * @param to target address that will receive the tokens
1308      * @param tokenId uint256 ID of the token to be transferred
1309      * @param _data bytes optional data to send along with the call
1310      * @return bool whether the call correctly returned the expected magic value
1311      */
1312     function _checkOnERC721Received(
1313         address from,
1314         address to,
1315         uint256 tokenId,
1316         bytes memory _data
1317     ) private returns (bool) {
1318         if (to.isContract()) {
1319             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1320                 return retval == IERC721Receiver(to).onERC721Received.selector;
1321             } catch (bytes memory reason) {
1322                 if (reason.length == 0) {
1323                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1324                 } else {
1325                     assembly {
1326                         revert(add(32, reason), mload(reason))
1327                     }
1328                 }
1329             }
1330         } else {
1331             return true;
1332         }
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1337      *
1338      * startTokenId - the first token id to be transferred
1339      * quantity - the amount to be transferred
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` will be minted for `to`.
1346      */
1347     function _beforeTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 
1354     /**
1355      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1356      * minting.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - when `from` and `to` are both non-zero.
1364      * - `from` and `to` are never both zero.
1365      */
1366     function _afterTokenTransfers(
1367         address from,
1368         address to,
1369         uint256 startTokenId,
1370         uint256 quantity
1371     ) internal virtual {}
1372 }
1373 
1374 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1375 
1376 pragma solidity ^0.8.0;
1377 
1378 /**
1379  * @dev Contract module that helps prevent reentrant calls to a function.
1380  *
1381  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1382  * available, which can be applied to functions to make sure there are no nested
1383  * (reentrant) calls to them.
1384  *
1385  * Note that because there is a single `nonReentrant` guard, functions marked as
1386  * `nonReentrant` may not call one another. This can be worked around by making
1387  * those functions `private`, and then adding `external` `nonReentrant` entry
1388  * points to them.
1389  *
1390  * TIP: If you would like to learn more about reentrancy and alternative ways
1391  * to protect against it, check out our blog post
1392  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1393  */
1394 abstract contract ReentrancyGuard {
1395     // Booleans are more expensive than uint256 or any type that takes up a full
1396     // word because each write operation emits an extra SLOAD to first read the
1397     // slot's contents, replace the bits taken up by the boolean, and then write
1398     // back. This is the compiler's defense against contract upgrades and
1399     // pointer aliasing, and it cannot be disabled.
1400 
1401     // The values being non-zero value makes deployment a bit more expensive,
1402     // but in exchange the refund on every call to nonReentrant will be lower in
1403     // amount. Since refunds are capped to a percentage of the total
1404     // transaction's gas, it is best to keep them low in cases like this one, to
1405     // increase the likelihood of the full refund coming into effect.
1406     uint256 private constant _NOT_ENTERED = 1;
1407     uint256 private constant _ENTERED = 2;
1408 
1409     uint256 private _status;
1410 
1411     constructor() {
1412         _status = _NOT_ENTERED;
1413     }
1414 
1415     /**
1416      * @dev Prevents a contract from calling itself, directly or indirectly.
1417      * Calling a `nonReentrant` function from another `nonReentrant`
1418      * function is not supported. It is possible to prevent this from happening
1419      * by making the `nonReentrant` function external, and making it call a
1420      * `private` function that does the actual work.
1421      */
1422     modifier nonReentrant() {
1423         // On the first call to nonReentrant, _notEntered will be true
1424         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1425 
1426         // Any calls to nonReentrant after this point will fail
1427         _status = _ENTERED;
1428 
1429         _;
1430 
1431         // By storing the original value once again, a refund is triggered (see
1432         // https://eips.ethereum.org/EIPS/eip-2200)
1433         _status = _NOT_ENTERED;
1434     }
1435 }
1436 
1437 pragma solidity ^0.8.2;
1438 
1439 contract GOBLINDADDY is ERC721A, Ownable, ReentrancyGuard {  
1440     using Strings for uint256;
1441     string public _partslink;
1442     bool public byebye = false;
1443     uint256 public daddys = 9999;
1444     uint256 public daddybyebye = 2;
1445     uint256 public price = 0.009 ether;
1446     mapping(address => uint256) public howmanydaddys;
1447    
1448 	constructor() ERC721A("GOBLINDADDY", "GOBLINDADDY") {}
1449 
1450     function _baseURI() internal view virtual override returns (string memory) {
1451         return _partslink;
1452     }
1453 
1454  	function mint() external payable nonReentrant {
1455          uint256 cost = price * daddybyebye;
1456         require(msg.value >= cost);
1457         if(msg.value > price) {
1458             Address.sendValue(payable(msg.sender), msg.value - cost);
1459         }
1460   	    uint256 total = totalSupply();
1461         require(byebye);
1462         require(total + daddybyebye <= daddys);
1463         require(msg.sender == tx.origin);
1464     	require(howmanydaddys[msg.sender] < daddybyebye);
1465         _safeMint(msg.sender, daddybyebye);
1466         howmanydaddys[msg.sender] += daddybyebye;
1467     }
1468 
1469  	function makefly(address addr, uint256 _daddys) public onlyOwner {
1470   	    uint256 total = totalSupply();
1471 	    require(total + _daddys <= daddys);
1472         _safeMint(addr, _daddys);
1473     }
1474 
1475     function makebyebye(bool _bye) external onlyOwner {
1476         byebye = _bye;
1477     }
1478 
1479     function makeprice(uint256 _price) external onlyOwner {
1480         price = _price;
1481     }
1482 
1483     function spred(uint256 _byebye) external onlyOwner {
1484         daddybyebye = _byebye;
1485     }
1486 
1487     function makehaveparts(string memory parts) external onlyOwner {
1488         _partslink = parts;
1489     }
1490 
1491     function sumthinboutfunds() public payable onlyOwner {
1492 	    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1493 		require(success);
1494 	}
1495 
1496    fallback () external payable{}
1497    receive () external payable{}
1498 }