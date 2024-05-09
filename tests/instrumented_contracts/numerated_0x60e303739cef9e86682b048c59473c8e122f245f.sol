1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 // File: ECDSA.sol
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 
74 /**
75  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
76  *
77  * These functions can be used to verify that a message was signed by the holder
78  * of the private keys of a given address.
79  */
80 library ECDSA {
81     enum RecoverError {
82         NoError,
83         InvalidSignature,
84         InvalidSignatureLength,
85         InvalidSignatureS,
86         InvalidSignatureV
87     }
88 
89     function _throwError(RecoverError error) private pure {
90         if (error == RecoverError.NoError) {
91             return; // no error: do nothing
92         } else if (error == RecoverError.InvalidSignature) {
93             revert("ECDSA: invalid signature");
94         } else if (error == RecoverError.InvalidSignatureLength) {
95             revert("ECDSA: invalid signature length");
96         } else if (error == RecoverError.InvalidSignatureS) {
97             revert("ECDSA: invalid signature 's' value");
98         } else if (error == RecoverError.InvalidSignatureV) {
99             revert("ECDSA: invalid signature 'v' value");
100         }
101     }
102 
103     /**
104      * @dev Returns the address that signed a hashed message (`hash`) with
105      * `signature` or error string. This address can then be used for verification purposes.
106      *
107      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
108      * this function rejects them by requiring the `s` value to be in the lower
109      * half order, and the `v` value to be either 27 or 28.
110      *
111      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
112      * verification to be secure: it is possible to craft signatures that
113      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
114      * this is by receiving a hash of the original message (which may otherwise
115      * be too long), and then calling {toEthSignedMessageHash} on it.
116      *
117      * Documentation for signature generation:
118      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
119      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
120      *
121      * _Available since v4.3._
122      */
123     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
124         // Check the signature length
125         // - case 65: r,s,v signature (standard)
126         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
127         if (signature.length == 65) {
128             bytes32 r;
129             bytes32 s;
130             uint8 v;
131             // ecrecover takes the signature parameters, and the only way to get them
132             // currently is to use assembly.
133             assembly {
134                 r := mload(add(signature, 0x20))
135                 s := mload(add(signature, 0x40))
136                 v := byte(0, mload(add(signature, 0x60)))
137             }
138             return tryRecover(hash, v, r, s);
139         } else if (signature.length == 64) {
140             bytes32 r;
141             bytes32 vs;
142             // ecrecover takes the signature parameters, and the only way to get them
143             // currently is to use assembly.
144             assembly {
145                 r := mload(add(signature, 0x20))
146                 vs := mload(add(signature, 0x40))
147             }
148             return tryRecover(hash, r, vs);
149         } else {
150             return (address(0), RecoverError.InvalidSignatureLength);
151         }
152     }
153 
154     /**
155      * @dev Returns the address that signed a hashed message (`hash`) with
156      * `signature`. This address can then be used for verification purposes.
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
167      */
168     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
169         (address recovered, RecoverError error) = tryRecover(hash, signature);
170         _throwError(error);
171         return recovered;
172     }
173 
174     /**
175      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
176      *
177      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
178      *
179      * _Available since v4.3._
180      */
181     function tryRecover(
182         bytes32 hash,
183         bytes32 r,
184         bytes32 vs
185     ) internal pure returns (address, RecoverError) {
186         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
187         uint8 v = uint8((uint256(vs) >> 255) + 27);
188         return tryRecover(hash, v, r, s);
189     }
190 
191     /**
192      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
193      *
194      * _Available since v4.2._
195      */
196     function recover(
197         bytes32 hash,
198         bytes32 r,
199         bytes32 vs
200     ) internal pure returns (address) {
201         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
202         _throwError(error);
203         return recovered;
204     }
205 
206     /**
207      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
208      * `r` and `s` signature fields separately.
209      *
210      * _Available since v4.3._
211      */
212     function tryRecover(
213         bytes32 hash,
214         uint8 v,
215         bytes32 r,
216         bytes32 s
217     ) internal pure returns (address, RecoverError) {
218         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
219         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
220         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
221         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
222         //
223         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
224         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
225         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
226         // these malleable signatures as well.
227         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
228             return (address(0), RecoverError.InvalidSignatureS);
229         }
230         if (v != 27 && v != 28) {
231             return (address(0), RecoverError.InvalidSignatureV);
232         }
233 
234         // If the signature is valid (and not malleable), return the signer address
235         address signer = ecrecover(hash, v, r, s);
236         if (signer == address(0)) {
237             return (address(0), RecoverError.InvalidSignature);
238         }
239 
240         return (signer, RecoverError.NoError);
241     }
242 
243     /**
244      * @dev Overload of {ECDSA-recover} that receives the `v`,
245      * `r` and `s` signature fields separately.
246      */
247     function recover(
248         bytes32 hash,
249         uint8 v,
250         bytes32 r,
251         bytes32 s
252     ) internal pure returns (address) {
253         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
254         _throwError(error);
255         return recovered;
256     }
257 
258     /**
259      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
260      * produces hash corresponding to the one signed with the
261      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
262      * JSON-RPC method as part of EIP-191.
263      *
264      * See {recover}.
265      */
266     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
267         // 32 is the length in bytes of hash,
268         // enforced by the type signature above
269         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
270     }
271 
272     /**
273      * @dev Returns an Ethereum Signed Message, created from `s`. This
274      * produces hash corresponding to the one signed with the
275      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
276      * JSON-RPC method as part of EIP-191.
277      *
278      * See {recover}.
279      */
280     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
281         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
282     }
283 
284     /**
285      * @dev Returns an Ethereum Signed Typed Data, created from a
286      * `domainSeparator` and a `structHash`. This produces hash corresponding
287      * to the one signed with the
288      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
289      * JSON-RPC method as part of EIP-712.
290      *
291      * See {recover}.
292      */
293     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
294         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
295     }
296 }
297 // File: Context.sol
298 
299 
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address) {
315         return msg.sender;
316     }
317 
318     function _msgData() internal view virtual returns (bytes calldata) {
319         return msg.data;
320     }
321 }
322 // File: Ownable.sol
323 
324 
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Contract module which provides a basic access control mechanism, where
331  * there is an account (an owner) that can be granted exclusive access to
332  * specific functions.
333  *
334  * By default, the owner account will be the one that deploys the contract. This
335  * can later be changed with {transferOwnership}.
336  *
337  * This module is used through inheritance. It will make available the modifier
338  * `onlyOwner`, which can be applied to your functions to restrict their use to
339  * the owner.
340  */
341 abstract contract Ownable is Context {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor() {
350         _setOwner(_msgSender());
351     }
352 
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363        modifier onlyOwner() {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367 
368     /**
369      * @dev Leaves the contract without owner. It will not be possible to call
370      * `onlyOwner` functions anymore. Can only be called by the current owner.
371      *
372      * NOTE: Renouncing ownership will leave the contract without an owner,
373      * thereby removing any functionality that is only available to the owner.
374      */
375     function renounceOwnership() public virtual onlyOwner {
376         _setOwner(address(0));
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      * Can only be called by the current owner.
382      */
383     function transferOwnership(address newOwner) public virtual onlyOwner {
384         require(newOwner != address(0), "Ownable: new owner is the zero address");
385         _setOwner(newOwner);
386     }
387 
388     function _setOwner(address newOwner) private {
389         address oldOwner = _owner;
390         _owner = newOwner;
391         emit OwnershipTransferred(oldOwner, newOwner);
392     }
393 }
394 // File: Address.sol
395 
396 
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Collection of functions related to the address type
402  */
403 library Address {
404     /**
405      * @dev Returns true if `account` is a contract.
406      *
407      * [IMPORTANT]
408      * ====
409      * It is unsafe to assume that an address for which this function returns
410      * false is an externally-owned account (EOA) and not a contract.
411      *
412      * Among others, `isContract` will return false for the following
413      * types of addresses:
414      *
415      *  - an externally-owned account
416      *  - a contract in construction
417      *  - an address where a contract will be created
418      *  - an address where a contract lived, but was destroyed
419      * ====
420      */
421     function isContract(address account) internal view returns (bool) {
422         // This method relies on extcodesize, which returns 0 for contracts in
423         // construction, since the code is only stored at the end of the
424         // constructor execution.
425 
426         uint256 size;
427         assembly {
428             size := extcodesize(account)
429         }
430         return size > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         (bool success, ) = recipient.call{value: amount}("");
453         require(success, "Address: unable to send value, recipient may have reverted");
454     }
455 
456     /**
457      * @dev Performs a Solidity function call using a low level `call`. A
458      * plain `call` is an unsafe replacement for a function call: use this
459      * function instead.
460      *
461      * If `target` reverts with a revert reason, it is bubbled up by this
462      * function (like regular Solidity function calls).
463      *
464      * Returns the raw returned data. To convert to the expected return value,
465      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
466      *
467      * Requirements:
468      *
469      * - `target` must be a contract.
470      * - calling `target` with `data` must not revert.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionCall(target, data, "Address: low-level call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
480      * `errorMessage` as a fallback revert reason when `target` reverts.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, 0, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but also transferring `value` wei to `target`.
495      *
496      * Requirements:
497      *
498      * - the calling contract must have an ETH balance of at least `value`.
499      * - the called Solidity function must be `payable`.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
513      * with `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(address(this).balance >= value, "Address: insufficient balance for call");
524         require(isContract(target), "Address: call to non-contract");
525 
526         (bool success, bytes memory returndata) = target.call{value: value}(data);
527         return _verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
537         return functionStaticCall(target, data, "Address: low-level static call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return _verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
564         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.4._
572      */
573     function functionDelegateCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal returns (bytes memory) {
578         require(isContract(target), "Address: delegate call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.delegatecall(data);
581         return _verifyCallResult(success, returndata, errorMessage);
582     }
583 
584     function _verifyCallResult(
585         bool success,
586         bytes memory returndata,
587         string memory errorMessage
588     ) private pure returns (bytes memory) {
589         if (success) {
590             return returndata;
591         } else {
592             // Look for revert reason and bubble it up if present
593             if (returndata.length > 0) {
594                 // The easiest way to bubble the revert reason is using memory via assembly
595 
596                 assembly {
597                     let returndata_size := mload(returndata)
598                     revert(add(32, returndata), returndata_size)
599                 }
600             } else {
601                 revert(errorMessage);
602             }
603         }
604     }
605 }
606 // File: IERC721Receiver.sol
607 
608 
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @title ERC721 token receiver interface
614  * @dev Interface for any contract that wants to support safeTransfers
615  * from ERC721 asset contracts.
616  */
617 interface IERC721Receiver {
618     /**
619      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
620      * by `operator` from `from`, this function is called.
621      *
622      * It must return its Solidity selector to confirm the token transfer.
623      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
624      *
625      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
626      */
627     function onERC721Received(
628         address operator,
629         address from,
630         uint256 tokenId,
631         bytes calldata data
632     ) external returns (bytes4);
633 }
634 // File: IERC165.sol
635 
636 
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev Interface of the ERC165 standard, as defined in the
642  * https://eips.ethereum.org/EIPS/eip-165[EIP].
643  *
644  * Implementers can declare support of contract interfaces, which can then be
645  * queried by others ({ERC165Checker}).
646  *
647  * For an implementation, see {ERC165}.
648  */
649 interface IERC165 {
650     /**
651      * @dev Returns true if this contract implements the interface defined by
652      * `interfaceId`. See the corresponding
653      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
654      * to learn more about how these ids are created.
655      *
656      * This function call must use less than 30 000 gas.
657      */
658     function supportsInterface(bytes4 interfaceId) external view returns (bool);
659 }
660 // File: ERC165.sol
661 
662 
663 
664 pragma solidity ^0.8.0;
665 
666 
667 /**
668  * @dev Implementation of the {IERC165} interface.
669  *
670  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
671  * for the additional interface id that will be supported. For example:
672  *
673  * ```solidity
674  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
676  * }
677  * ```
678  *
679  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
680  */
681 abstract contract ERC165 is IERC165 {
682     /**
683      * @dev See {IERC165-supportsInterface}.
684      */
685     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
686         return interfaceId == type(IERC165).interfaceId;
687     }
688 }
689 // File: IERC721.sol
690 
691 
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @dev Required interface of an ERC721 compliant contract.
698  */
699 interface IERC721 is IERC165 {
700     /**
701      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
702      */
703     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
704 
705     /**
706      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
707      */
708     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
709 
710     /**
711      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
712      */
713     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
714 
715     /**
716      * @dev Returns the number of tokens in ``owner``'s account.
717      */
718     function balanceOf(address owner) external view returns (uint256 balance);
719 
720     /**
721      * @dev Returns the owner of the `tokenId` token.
722      *
723      * Requirements:
724      *
725      * - `tokenId` must exist.
726      */
727     function ownerOf(uint256 tokenId) external view returns (address owner);
728 
729     /**
730      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
731      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
732      *
733      * Requirements:
734      *
735      * - `from` cannot be the zero address.
736      * - `to` cannot be the zero address.
737      * - `tokenId` token must exist and be owned by `from`.
738      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
740      *
741      * Emits a {Transfer} event.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) external;
748 
749     /**
750      * @dev Transfers `tokenId` token from `from` to `to`.
751      *
752      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
753      *
754      * Requirements:
755      *
756      * - `from` cannot be the zero address.
757      * - `to` cannot be the zero address.
758      * - `tokenId` token must be owned by `from`.
759      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
760      *
761      * Emits a {Transfer} event.
762      */
763     function transferFrom(
764         address from,
765         address to,
766         uint256 tokenId
767     ) external;
768 
769     /**
770      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
771      * The approval is cleared when the token is transferred.
772      *
773      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
774      *
775      * Requirements:
776      *
777      * - The caller must own the token or be an approved operator.
778      * - `tokenId` must exist.
779      *
780      * Emits an {Approval} event.
781      */
782     function approve(address to, uint256 tokenId) external;
783 
784     /**
785      * @dev Returns the account approved for `tokenId` token.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must exist.
790      */
791     function getApproved(uint256 tokenId) external view returns (address operator);
792 
793     /**
794      * @dev Approve or remove `operator` as an operator for the caller.
795      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
796      *
797      * Requirements:
798      *
799      * - The `operator` cannot be the caller.
800      *
801      * Emits an {ApprovalForAll} event.
802      */
803     function setApprovalForAll(address operator, bool _approved) external;
804 
805     /**
806      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
807      *
808      * See {setApprovalForAll}
809      */
810     function isApprovedForAll(address owner, address operator) external view returns (bool);
811 
812     /**
813      * @dev Safely transfers `tokenId` token from `from` to `to`.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must exist and be owned by `from`.
820      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 tokenId,
829         bytes calldata data
830     ) external;
831 }
832 // File: IERC721Enumerable.sol
833 
834 
835 
836 pragma solidity ^0.8.0;
837 
838 
839 /**
840  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
841  * @dev See https://eips.ethereum.org/EIPS/eip-721
842  */
843 interface IERC721Enumerable is IERC721 {
844     /**
845      * @dev Returns the total amount of tokens stored by the contract.
846      */
847     function totalSupply() external view returns (uint256);
848 
849     /**
850      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
851      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
852      */
853     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
854 
855     /**
856      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
857      * Use along with {totalSupply} to enumerate all tokens.
858      */
859     function tokenByIndex(uint256 index) external view returns (uint256);
860 }
861 // File: IERC721Metadata.sol
862 
863 
864 
865 pragma solidity ^0.8.0;
866 
867 
868 /**
869  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
870  * @dev See https://eips.ethereum.org/EIPS/eip-721
871  */
872 interface IERC721Metadata is IERC721 {
873     /**
874      * @dev Returns the token collection name.
875      */
876     function name() external view returns (string memory);
877 
878     /**
879      * @dev Returns the token collection symbol.
880      */
881     function symbol() external view returns (string memory);
882 
883     /**
884      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
885      */
886     function tokenURI(uint256 tokenId) external view returns (string memory);
887 }
888 // File: ERC721A.sol
889 
890 
891 pragma solidity ^0.8.0;
892 
893 
894 
895 
896 
897 
898 
899 
900 
901 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
902     using Address for address;
903     using Strings for uint256;
904 
905     struct TokenOwnership {
906         address addr;
907         uint64 startTimestamp;
908     }
909 
910     struct AddressData {
911         uint128 balance;
912         uint128 numberMinted;
913     }
914 
915     uint256 internal currentIndex;
916 
917     // Token name
918     string private _name;
919 
920     // Token symbol
921     string private _symbol;
922 
923     // Mapping from token ID to ownership details
924     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
925     mapping(uint256 => TokenOwnership) internal _ownerships;
926 
927     // Mapping owner address to address data
928     mapping(address => AddressData) private _addressData;
929 
930     // Mapping from token ID to approved address
931     mapping(uint256 => address) private _tokenApprovals;
932 
933     // Mapping from owner to operator approvals
934     mapping(address => mapping(address => bool)) private _operatorApprovals;
935 
936     constructor(string memory name_, string memory symbol_) {
937         _name = name_;
938         _symbol = symbol_;
939     }
940 
941     /**
942      * @dev See {IERC721Enumerable-totalSupply}.
943      */
944     function totalSupply() public view override returns (uint256) {
945         return currentIndex;
946     }
947 
948     /**
949      * @dev See {IERC721Enumerable-tokenByIndex}.
950      */
951     function tokenByIndex(uint256 index) public view override returns (uint256) {
952         require(index < totalSupply(), 'ERC721A: global index out of bounds');
953         return index;
954     }
955 
956     /**
957      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
958      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
959      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
960      */
961     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
962         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
963         uint256 numMintedSoFar = totalSupply();
964         uint256 tokenIdsIdx;
965         address currOwnershipAddr;
966 
967         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
968         unchecked {
969             for (uint256 i; i < numMintedSoFar; i++) {
970                 TokenOwnership memory ownership = _ownerships[i];
971                 if (ownership.addr != address(0)) {
972                     currOwnershipAddr = ownership.addr;
973                 }
974                 if (currOwnershipAddr == owner) {
975                     if (tokenIdsIdx == index) {
976                         return i;
977                     }
978                     tokenIdsIdx++;
979                 }
980             }
981         }
982 
983         revert('ERC721A: unable to get token of owner by index');
984     }
985 
986     /**
987      * @dev See {IERC165-supportsInterface}.
988      */
989     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
990         return
991             interfaceId == type(IERC721).interfaceId ||
992             interfaceId == type(IERC721Metadata).interfaceId ||
993             interfaceId == type(IERC721Enumerable).interfaceId ||
994             super.supportsInterface(interfaceId);
995     }
996 
997     /**
998      * @dev See {IERC721-balanceOf}.
999      */
1000     function balanceOf(address owner) public view override returns (uint256) {
1001         require(owner != address(0), 'ERC721A: balance query for the zero address');
1002         return uint256(_addressData[owner].balance);
1003     }
1004 
1005     function _numberMinted(address owner) internal view returns (uint256) {
1006         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1007         return uint256(_addressData[owner].numberMinted);
1008     }
1009 
1010     /**
1011      * Gas spent here starts off proportional to the maximum mint batch size.
1012      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1013      */
1014     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1015         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1016 
1017         unchecked {
1018             for (uint256 curr = tokenId; curr >= 0; curr--) {
1019                 TokenOwnership memory ownership = _ownerships[curr];
1020                 if (ownership.addr != address(0)) {
1021                     return ownership;
1022                 }
1023             }
1024         }
1025 
1026         revert('ERC721A: unable to determine the owner of token');
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-ownerOf}.
1031      */
1032     function ownerOf(uint256 tokenId) public view override returns (address) {
1033         return ownershipOf(tokenId).addr;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-name}.
1038      */
1039     function name() public view virtual override returns (string memory) {
1040         return _name;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Metadata-symbol}.
1045      */
1046     function symbol() public view virtual override returns (string memory) {
1047         return _symbol;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Metadata-tokenURI}.
1052      */
1053     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1054         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1055 
1056         string memory baseURI = _baseURI();
1057         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1058     }
1059 
1060     /**
1061      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1062      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1063      * by default, can be overriden in child contracts.
1064      */
1065     function _baseURI() internal view virtual returns (string memory) {
1066         return '';
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-approve}.
1071      */
1072     function approve(address to, uint256 tokenId) public override {
1073         address owner = ERC721A.ownerOf(tokenId);
1074         require(to != owner, 'ERC721A: approval to current owner');
1075 
1076         require(
1077             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1078             'ERC721A: approve caller is not owner nor approved for all'
1079         );
1080 
1081         _approve(to, tokenId, owner);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-getApproved}.
1086      */
1087     function getApproved(uint256 tokenId) public view override returns (address) {
1088         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1089 
1090         return _tokenApprovals[tokenId];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-setApprovalForAll}.
1095      */
1096     function setApprovalForAll(address operator, bool approved) public override {
1097         require(operator != _msgSender(), 'ERC721A: approve to caller');
1098 
1099         _operatorApprovals[_msgSender()][operator] = approved;
1100         emit ApprovalForAll(_msgSender(), operator, approved);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-isApprovedForAll}.
1105      */
1106     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1107         return _operatorApprovals[owner][operator];
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-transferFrom}.
1112      */
1113     function transferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) public override {
1118         _transfer(from, to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-safeTransferFrom}.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) public override {
1129         safeTransferFrom(from, to, tokenId, '');
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId,
1139         bytes memory _data
1140     ) public override {
1141         _transfer(from, to, tokenId);
1142         require(
1143             _checkOnERC721Received(from, to, tokenId, _data),
1144             'ERC721A: transfer to non ERC721Receiver implementer'
1145         );
1146     }
1147 
1148     /**
1149      * @dev Returns whether `tokenId` exists.
1150      *
1151      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1152      *
1153      * Tokens start existing when they are minted (`_mint`),
1154      */
1155     function _exists(uint256 tokenId) internal view returns (bool) {
1156         return tokenId < currentIndex;
1157     }
1158 
1159     function _safeMint(address to, uint256 quantity) internal {
1160         _safeMint(to, quantity, '');
1161     }
1162 
1163     /**
1164      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1169      * - `quantity` must be greater than 0.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(
1174         address to,
1175         uint256 quantity,
1176         bytes memory _data
1177     ) internal {
1178         _mint(to, quantity, _data, true);
1179     }
1180 
1181     /**
1182      * @dev Mints `quantity` tokens and transfers them to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - `quantity` must be greater than 0.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _mint(
1192         address to,
1193         uint256 quantity,
1194         bytes memory _data,
1195         bool safe
1196     ) internal {
1197         uint256 startTokenId = currentIndex;
1198         require(to != address(0), 'ERC721A: mint to the zero address');
1199         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1200 
1201         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1202 
1203         // Overflows are incredibly unrealistic.
1204         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1205         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1206         unchecked {
1207             _addressData[to].balance += uint128(quantity);
1208             _addressData[to].numberMinted += uint128(quantity);
1209 
1210             _ownerships[startTokenId].addr = to;
1211             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1212 
1213             uint256 updatedIndex = startTokenId;
1214 
1215             for (uint256 i; i < quantity; i++) {
1216                 emit Transfer(address(0), to, updatedIndex);
1217                 if (safe) {
1218                     require(
1219                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1220                         'ERC721A: transfer to non ERC721Receiver implementer'
1221                     );
1222                 }
1223 
1224                 updatedIndex++;
1225             }
1226 
1227             currentIndex = updatedIndex;
1228         }
1229 
1230         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1231     }
1232 
1233     /**
1234      * @dev Transfers `tokenId` from `from` to `to`.
1235      *
1236      * Requirements:
1237      *
1238      * - `to` cannot be the zero address.
1239      * - `tokenId` token must be owned by `from`.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _transfer(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) private {
1248         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1249 
1250         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1251             getApproved(tokenId) == _msgSender() ||
1252             isApprovedForAll(prevOwnership.addr, _msgSender()));
1253 
1254         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1255 
1256         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1257         require(to != address(0), 'ERC721A: transfer to the zero address');
1258 
1259         _beforeTokenTransfers(from, to, tokenId, 1);
1260 
1261         // Clear approvals from the previous owner
1262         _approve(address(0), tokenId, prevOwnership.addr);
1263 
1264         // Underflow of the sender's balance is impossible because we check for
1265         // ownership above and the recipient's balance can't realistically overflow.
1266         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1267         unchecked {
1268             _addressData[from].balance -= 1;
1269             _addressData[to].balance += 1;
1270 
1271             _ownerships[tokenId].addr = to;
1272             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1273 
1274             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1275             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1276             uint256 nextTokenId = tokenId + 1;
1277             if (_ownerships[nextTokenId].addr == address(0)) {
1278                 if (_exists(nextTokenId)) {
1279                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1280                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1281                 }
1282             }
1283         }
1284 
1285         emit Transfer(from, to, tokenId);
1286         _afterTokenTransfers(from, to, tokenId, 1);
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits a {Approval} event.
1293      */
1294     function _approve(
1295         address to,
1296         uint256 tokenId,
1297         address owner
1298     ) private {
1299         _tokenApprovals[tokenId] = to;
1300         emit Approval(owner, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1305      * The call is not executed if the target address is not a contract.
1306      *
1307      * @param from address representing the previous owner of the given token ID
1308      * @param to target address that will receive the tokens
1309      * @param tokenId uint256 ID of the token to be transferred
1310      * @param _data bytes optional data to send along with the call
1311      * @return bool whether the call correctly returned the expected magic value
1312      */
1313     function _checkOnERC721Received(
1314         address from,
1315         address to,
1316         uint256 tokenId,
1317         bytes memory _data
1318     ) private returns (bool) {
1319         if (to.isContract()) {
1320             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1321                 return retval == IERC721Receiver(to).onERC721Received.selector;
1322             } catch (bytes memory reason) {
1323                 if (reason.length == 0) {
1324                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1325                 } else {
1326                     assembly {
1327                         revert(add(32, reason), mload(reason))
1328                     }
1329                 }
1330             }
1331         } else {
1332             return true;
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      */
1348     function _beforeTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 
1355     /**
1356      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1357      * minting.
1358      *
1359      * startTokenId - the first token id to be transferred
1360      * quantity - the amount to be transferred
1361      *
1362      * Calling conditions:
1363      *
1364      * - when `from` and `to` are both non-zero.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _afterTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 }
1374 
1375 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 /**
1380  * @dev Contract module that helps prevent reentrant calls to a function.
1381  *
1382  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1383  * available, which can be applied to functions to make sure there are no nested
1384  * (reentrant) calls to them.
1385  *
1386  * Note that because there is a single `nonReentrant` guard, functions marked as
1387  * `nonReentrant` may not call one another. This can be worked around by making
1388  * those functions `private`, and then adding `external` `nonReentrant` entry
1389  * points to them.
1390  *
1391  * TIP: If you would like to learn more about reentrancy and alternative ways
1392  * to protect against it, check out our blog post
1393  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1394  */
1395 abstract contract ReentrancyGuard {
1396     // Booleans are more expensive than uint256 or any type that takes up a full
1397     // word because each write operation emits an extra SLOAD to first read the
1398     // slot's contents, replace the bits taken up by the boolean, and then write
1399     // back. This is the compiler's defense against contract upgrades and
1400     // pointer aliasing, and it cannot be disabled.
1401 
1402     // The values being non-zero value makes deployment a bit more expensive,
1403     // but in exchange the refund on every call to nonReentrant will be lower in
1404     // amount. Since refunds are capped to a percentage of the total
1405     // transaction's gas, it is best to keep them low in cases like this one, to
1406     // increase the likelihood of the full refund coming into effect.
1407     uint256 private constant _NOT_ENTERED = 1;
1408     uint256 private constant _ENTERED = 2;
1409 
1410     uint256 private _status;
1411 
1412     constructor() {
1413         _status = _NOT_ENTERED;
1414     }
1415 
1416     /**
1417      * @dev Prevents a contract from calling itself, directly or indirectly.
1418      * Calling a `nonReentrant` function from another `nonReentrant`
1419      * function is not supported. It is possible to prevent this from happening
1420      * by making the `nonReentrant` function external, and making it call a
1421      * `private` function that does the actual work.
1422      */
1423     modifier nonReentrant() {
1424         _nonReentrantBefore();
1425         _;
1426         _nonReentrantAfter();
1427     }
1428 
1429     function _nonReentrantBefore() private {
1430         // On the first call to nonReentrant, _notEntered will be true
1431         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1432 
1433         // Any calls to nonReentrant after this point will fail
1434         _status = _ENTERED;
1435     }
1436 
1437     function _nonReentrantAfter() private {
1438         // By storing the original value once again, a refund is triggered (see
1439         // https://eips.ethereum.org/EIPS/eip-2200)
1440         _status = _NOT_ENTERED;
1441     }
1442 }
1443 
1444 
1445 pragma solidity ^0.8.2;
1446 
1447 abstract contract ALLOWLISTCONTRACT {
1448   function balanceOf(address owner) public view virtual returns (uint256);
1449 }
1450  
1451 contract AmariArtistPass is ERC721A, Ownable, ReentrancyGuard {
1452     using Strings
1453     for uint256;
1454     string public _metadata;
1455 
1456     ALLOWLISTCONTRACT private allowlistcontract;
1457 
1458    //@notice admin wallet
1459     address private adminWallet = 0x2901BF554C4c90d2356204fa0E772328Ea8d9e20;
1460 
1461     //@notice contract for allowlist
1462     address public allowlistContract = 0x892848074ddeA461A15f337250Da3ce55580CA85;
1463 
1464     //@notice phases for sale
1465     bool public isAllowlistActive = false;
1466     bool public isPublicActive = false;
1467 
1468     //@notice settings for sale
1469     uint256 public MAX_SUPPLY = 2000;
1470     uint256 public MAX_SUPPLY_ALLOWLIST = 400; // 250 for allowlists with 150 reserved
1471     uint256 public PRICE_PER_TOKEN = 0.02 ether;
1472     uint256 private maxMintPerWalletAllowlist = 1;
1473     uint256 private maxMintPerWalletPublic = 5;
1474 
1475     //@notice mappings for sale
1476     mapping(address => uint256) public numMintedPerPersonAllowlist;
1477     mapping(address => uint256) public numMintedPerPersonPublic;
1478 
1479     constructor() ERC721A("AmariArtistPass ", "AMAP") {
1480         allowlistcontract = ALLOWLISTCONTRACT(allowlistContract);
1481     }
1482 
1483     //@notice mint allowlist, requires balance from allowlist contract
1484     function mintAllowlist() external nonReentrant {
1485         uint256 ts = totalSupply();
1486         uint256 checkBal = allowlistcontract.balanceOf(msg.sender);
1487         require(isAllowlistActive, "Allowlist is not Active");
1488         require(checkBal > 0, "Minter does not own allowlisted contract");
1489 
1490         require(ts + 1 <= MAX_SUPPLY_ALLOWLIST, "Purchase would exceed max tokens");
1491         require(numMintedPerPersonAllowlist[msg.sender] + 1 <= maxMintPerWalletAllowlist, "Purchase would exceed max tokens per Wallet");
1492         require(msg.sender == tx.origin);
1493         _safeMint(msg.sender, 1);
1494         numMintedPerPersonAllowlist[msg.sender] += 1;
1495     }
1496 
1497     //@notice public mint
1498    function mintPublic(uint256 _tokenAmount) external payable nonReentrant {
1499         uint256 ts = totalSupply();
1500         require(isPublicActive, "Public is not Active");
1501         require(_tokenAmount <= maxMintPerWalletPublic, "Purchase would exceed max tokens per tx in this phase");
1502         require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens");
1503         require(msg.value >= PRICE_PER_TOKEN * _tokenAmount, "Ether value sent is not correct");
1504         require(msg.sender == tx.origin);
1505         require(numMintedPerPersonPublic[msg.sender] + _tokenAmount <= maxMintPerWalletPublic, "Purchase would exceed max tokens per Wallet");
1506 
1507         _safeMint(msg.sender, _tokenAmount);
1508         numMintedPerPersonPublic[msg.sender] += _tokenAmount;
1509        }
1510 
1511     //@notice reserve tokens, only owner
1512     function reserve(address addr, uint256 _tokenAmount) public onlyOwner {
1513         uint256 ts = totalSupply();
1514         require(ts + _tokenAmount <= MAX_SUPPLY);
1515         _safeMint(addr, _tokenAmount);
1516     }
1517 
1518     //@notice set new allowlist contract
1519     function setAllowlistContract(address _contract) external onlyOwner {
1520         allowlistContract = _contract;
1521     }
1522 
1523     //@notice set new price for a token
1524     function setPrice(uint256 _newPrice) external onlyOwner {
1525         PRICE_PER_TOKEN = _newPrice;
1526     }
1527 
1528     //@notice set new max allowlist/presale spots
1529     function setMaxAllowlist(uint256 _newMaxAllowlist) external onlyOwner {
1530         require(_newMaxAllowlist <= MAX_SUPPLY,"Can not set greater than maxsupply");
1531         MAX_SUPPLY_ALLOWLIST = _newMaxAllowlist;
1532     }
1533 
1534     //@notice set allowlist active
1535     function setAllowlistLive(bool _status) external onlyOwner {
1536         isAllowlistActive = _status;
1537     }
1538 
1539     //@notice set public active
1540     function sePublicLive(bool _status) external onlyOwner {
1541         isPublicActive = _status;
1542     }
1543 
1544     //@notice set max mint per wallet allowlist
1545     function setMaxMintPerWalletAllowlis(uint256 _amount) external onlyOwner {
1546         maxMintPerWalletAllowlist = _amount;
1547     }
1548 
1549     //@notice set max mint per wallet public
1550     function setMaxMintPerWalletPublic(uint256 _amount) external onlyOwner {
1551         maxMintPerWalletPublic = _amount;
1552     }
1553 
1554     //@notice set metadata
1555     function setMetadata(string memory metadata_) external onlyOwner {
1556         _metadata = metadata_;
1557     }
1558 
1559     //@notice Set the admin wallet.
1560     function setAdminWallet(address _wallet) external onlyOwner {
1561         adminWallet = _wallet;
1562     }
1563 
1564     //@notice call metadata
1565     function _baseURI() internal view virtual override returns(string memory) {
1566         return _metadata;
1567     }
1568 
1569     //@notice withdraw to admin
1570     function withdraw() public payable onlyOwner {
1571         (bool success, ) = payable(adminWallet).call {
1572             value: address(this).balance
1573         }("");
1574         require(success);
1575     }
1576 }