1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.9.3 https://hardhat.org
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /**
7 ___███████▀◢▆▅▃ 　　　   　　 　　　 ▀▀████
8 ___██████▌◢▀█▓▓█◣   　　　　　　▂▃▃　 ████
9 __▐▐█████▍▌▐▓▓▉　　　　　　　◢▓▓█ ▼ ████
10 __ ▌██████▎　 ▀▀▀　　　　　　 　█▓▓▌ ▌ █████▌
11 _▐ ██████▊　 ℳ 　　　　　　　　▀◥◤▀    ▲████▉
12 _▊ ███████◣ 　　　　　　  ′　　　ℳ　 ▃◢██████▐
13 _ ▉ ████████◣ 　　　　 ▃、　　　　　◢███▊███ 
14 _▉　 █████████▆▃　　　　　　　 ◢████▌ ███ 
15 _ ▉　 ████▋████▉▀◥▅▃▃▅▇███▐██▋　▐██
16  */
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 
41 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
42 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
118 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Contract module that helps prevent reentrant calls to a function.
124  *
125  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
126  * available, which can be applied to functions to make sure there are no nested
127  * (reentrant) calls to them.
128  *
129  * Note that because there is a single `nonReentrant` guard, functions marked as
130  * `nonReentrant` may not call one another. This can be worked around by making
131  * those functions `private`, and then adding `external` `nonReentrant` entry
132  * points to them.
133  *
134  * TIP: If you would like to learn more about reentrancy and alternative ways
135  * to protect against it, check out our blog post
136  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
137  */
138 abstract contract ReentrancyGuard {
139     // Booleans are more expensive than uint256 or any type that takes up a full
140     // word because each write operation emits an extra SLOAD to first read the
141     // slot's contents, replace the bits taken up by the boolean, and then write
142     // back. This is the compiler's defense against contract upgrades and
143     // pointer aliasing, and it cannot be disabled.
144 
145     // The values being non-zero value makes deployment a bit more expensive,
146     // but in exchange the refund on every call to nonReentrant will be lower in
147     // amount. Since refunds are capped to a percentage of the total
148     // transaction's gas, it is best to keep them low in cases like this one, to
149     // increase the likelihood of the full refund coming into effect.
150     uint256 private constant _NOT_ENTERED = 1;
151     uint256 private constant _ENTERED = 2;
152 
153     uint256 private _status;
154 
155     constructor() {
156         _status = _NOT_ENTERED;
157     }
158 
159     /**
160      * @dev Prevents a contract from calling itself, directly or indirectly.
161      * Calling a `nonReentrant` function from another `nonReentrant`
162      * function is not supported. It is possible to prevent this from happening
163      * by making the `nonReentrant` function external, and making it call a
164      * `private` function that does the actual work.
165      */
166     modifier nonReentrant() {
167         // On the first call to nonReentrant, _notEntered will be true
168         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
169 
170         // Any calls to nonReentrant after this point will fail
171         _status = _ENTERED;
172 
173         _;
174 
175         // By storing the original value once again, a refund is triggered (see
176         // https://eips.ethereum.org/EIPS/eip-2200)
177         _status = _NOT_ENTERED;
178     }
179 }
180 
181 
182 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev String operations.
190  */
191 library Strings {
192     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
193 
194     /**
195      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
196      */
197     function toString(uint256 value) internal pure returns (string memory) {
198         // Inspired by OraclizeAPI's implementation - MIT licence
199         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
200 
201         if (value == 0) {
202             return "0";
203         }
204         uint256 temp = value;
205         uint256 digits;
206         while (temp != 0) {
207             digits++;
208             temp /= 10;
209         }
210         bytes memory buffer = new bytes(digits);
211         while (value != 0) {
212             digits -= 1;
213             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
214             value /= 10;
215         }
216         return string(buffer);
217     }
218 
219     /**
220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
221      */
222     function toHexString(uint256 value) internal pure returns (string memory) {
223         if (value == 0) {
224             return "0x00";
225         }
226         uint256 temp = value;
227         uint256 length = 0;
228         while (temp != 0) {
229             length++;
230             temp >>= 8;
231         }
232         return toHexString(value, length);
233     }
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
237      */
238     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
239         bytes memory buffer = new bytes(2 * length + 2);
240         buffer[0] = "0";
241         buffer[1] = "x";
242         for (uint256 i = 2 * length + 1; i > 1; --i) {
243             buffer[i] = _HEX_SYMBOLS[value & 0xf];
244             value >>= 4;
245         }
246         require(value == 0, "Strings: hex length insufficient");
247         return string(buffer);
248     }
249 }
250 
251 
252 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.5.0
253 
254 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
260  *
261  * These functions can be used to verify that a message was signed by the holder
262  * of the private keys of a given address.
263  */
264 library ECDSA {
265     enum RecoverError {
266         NoError,
267         InvalidSignature,
268         InvalidSignatureLength,
269         InvalidSignatureS,
270         InvalidSignatureV
271     }
272 
273     function _throwError(RecoverError error) private pure {
274         if (error == RecoverError.NoError) {
275             return; // no error: do nothing
276         } else if (error == RecoverError.InvalidSignature) {
277             revert("ECDSA: invalid signature");
278         } else if (error == RecoverError.InvalidSignatureLength) {
279             revert("ECDSA: invalid signature length");
280         } else if (error == RecoverError.InvalidSignatureS) {
281             revert("ECDSA: invalid signature 's' value");
282         } else if (error == RecoverError.InvalidSignatureV) {
283             revert("ECDSA: invalid signature 'v' value");
284         }
285     }
286 
287     /**
288      * @dev Returns the address that signed a hashed message (`hash`) with
289      * `signature` or error string. This address can then be used for verification purposes.
290      *
291      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
292      * this function rejects them by requiring the `s` value to be in the lower
293      * half order, and the `v` value to be either 27 or 28.
294      *
295      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
296      * verification to be secure: it is possible to craft signatures that
297      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
298      * this is by receiving a hash of the original message (which may otherwise
299      * be too long), and then calling {toEthSignedMessageHash} on it.
300      *
301      * Documentation for signature generation:
302      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
303      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
304      *
305      * _Available since v4.3._
306      */
307     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
308         // Check the signature length
309         // - case 65: r,s,v signature (standard)
310         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
311         if (signature.length == 65) {
312             bytes32 r;
313             bytes32 s;
314             uint8 v;
315             // ecrecover takes the signature parameters, and the only way to get them
316             // currently is to use assembly.
317             assembly {
318                 r := mload(add(signature, 0x20))
319                 s := mload(add(signature, 0x40))
320                 v := byte(0, mload(add(signature, 0x60)))
321             }
322             return tryRecover(hash, v, r, s);
323         } else if (signature.length == 64) {
324             bytes32 r;
325             bytes32 vs;
326             // ecrecover takes the signature parameters, and the only way to get them
327             // currently is to use assembly.
328             assembly {
329                 r := mload(add(signature, 0x20))
330                 vs := mload(add(signature, 0x40))
331             }
332             return tryRecover(hash, r, vs);
333         } else {
334             return (address(0), RecoverError.InvalidSignatureLength);
335         }
336     }
337 
338     /**
339      * @dev Returns the address that signed a hashed message (`hash`) with
340      * `signature`. This address can then be used for verification purposes.
341      *
342      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
343      * this function rejects them by requiring the `s` value to be in the lower
344      * half order, and the `v` value to be either 27 or 28.
345      *
346      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
347      * verification to be secure: it is possible to craft signatures that
348      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
349      * this is by receiving a hash of the original message (which may otherwise
350      * be too long), and then calling {toEthSignedMessageHash} on it.
351      */
352     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
353         (address recovered, RecoverError error) = tryRecover(hash, signature);
354         _throwError(error);
355         return recovered;
356     }
357 
358     /**
359      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
360      *
361      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
362      *
363      * _Available since v4.3._
364      */
365     function tryRecover(
366         bytes32 hash,
367         bytes32 r,
368         bytes32 vs
369     ) internal pure returns (address, RecoverError) {
370         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
371         uint8 v = uint8((uint256(vs) >> 255) + 27);
372         return tryRecover(hash, v, r, s);
373     }
374 
375     /**
376      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
377      *
378      * _Available since v4.2._
379      */
380     function recover(
381         bytes32 hash,
382         bytes32 r,
383         bytes32 vs
384     ) internal pure returns (address) {
385         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
386         _throwError(error);
387         return recovered;
388     }
389 
390     /**
391      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
392      * `r` and `s` signature fields separately.
393      *
394      * _Available since v4.3._
395      */
396     function tryRecover(
397         bytes32 hash,
398         uint8 v,
399         bytes32 r,
400         bytes32 s
401     ) internal pure returns (address, RecoverError) {
402         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
403         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
404         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
405         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
406         //
407         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
408         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
409         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
410         // these malleable signatures as well.
411         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
412             return (address(0), RecoverError.InvalidSignatureS);
413         }
414         if (v != 27 && v != 28) {
415             return (address(0), RecoverError.InvalidSignatureV);
416         }
417 
418         // If the signature is valid (and not malleable), return the signer address
419         address signer = ecrecover(hash, v, r, s);
420         if (signer == address(0)) {
421             return (address(0), RecoverError.InvalidSignature);
422         }
423 
424         return (signer, RecoverError.NoError);
425     }
426 
427     /**
428      * @dev Overload of {ECDSA-recover} that receives the `v`,
429      * `r` and `s` signature fields separately.
430      */
431     function recover(
432         bytes32 hash,
433         uint8 v,
434         bytes32 r,
435         bytes32 s
436     ) internal pure returns (address) {
437         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
438         _throwError(error);
439         return recovered;
440     }
441 
442     /**
443      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
444      * produces hash corresponding to the one signed with the
445      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
446      * JSON-RPC method as part of EIP-191.
447      *
448      * See {recover}.
449      */
450     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
451         // 32 is the length in bytes of hash,
452         // enforced by the type signature above
453         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
454     }
455 
456     /**
457      * @dev Returns an Ethereum Signed Message, created from `s`. This
458      * produces hash corresponding to the one signed with the
459      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
460      * JSON-RPC method as part of EIP-191.
461      *
462      * See {recover}.
463      */
464     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
465         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
466     }
467 
468     /**
469      * @dev Returns an Ethereum Signed Typed Data, created from a
470      * `domainSeparator` and a `structHash`. This produces hash corresponding
471      * to the one signed with the
472      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
473      * JSON-RPC method as part of EIP-712.
474      *
475      * See {recover}.
476      */
477     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
478         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
479     }
480 }
481 
482 
483 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 
511 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
512 
513 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Required interface of an ERC721 compliant contract.
519  */
520 interface IERC721 is IERC165 {
521     /**
522      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
523      */
524     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
528      */
529     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
533      */
534     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
535 
536     /**
537      * @dev Returns the number of tokens in ``owner``'s account.
538      */
539     function balanceOf(address owner) external view returns (uint256 balance);
540 
541     /**
542      * @dev Returns the owner of the `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function ownerOf(uint256 tokenId) external view returns (address owner);
549 
550     /**
551      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
552      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Transfers `tokenId` token from `from` to `to`.
572      *
573      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      *
582      * Emits a {Transfer} event.
583      */
584     function transferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
592      * The approval is cleared when the token is transferred.
593      *
594      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
595      *
596      * Requirements:
597      *
598      * - The caller must own the token or be an approved operator.
599      * - `tokenId` must exist.
600      *
601      * Emits an {Approval} event.
602      */
603     function approve(address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Returns the account approved for `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function getApproved(uint256 tokenId) external view returns (address operator);
613 
614     /**
615      * @dev Approve or remove `operator` as an operator for the caller.
616      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
617      *
618      * Requirements:
619      *
620      * - The `operator` cannot be the caller.
621      *
622      * Emits an {ApprovalForAll} event.
623      */
624     function setApprovalForAll(address operator, bool _approved) external;
625 
626     /**
627      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
628      *
629      * See {setApprovalForAll}
630      */
631     function isApprovedForAll(address owner, address operator) external view returns (bool);
632 
633     /**
634      * @dev Safely transfers `tokenId` token from `from` to `to`.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must exist and be owned by `from`.
641      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId,
650         bytes calldata data
651     ) external;
652 }
653 
654 
655 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
656 
657 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 /**
662  * @title ERC721 token receiver interface
663  * @dev Interface for any contract that wants to support safeTransfers
664  * from ERC721 asset contracts.
665  */
666 interface IERC721Receiver {
667     /**
668      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
669      * by `operator` from `from`, this function is called.
670      *
671      * It must return its Solidity selector to confirm the token transfer.
672      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
673      *
674      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
675      */
676     function onERC721Received(
677         address operator,
678         address from,
679         uint256 tokenId,
680         bytes calldata data
681     ) external returns (bytes4);
682 }
683 
684 
685 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Metadata is IERC721 {
696     /**
697      * @dev Returns the token collection name.
698      */
699     function name() external view returns (string memory);
700 
701     /**
702      * @dev Returns the token collection symbol.
703      */
704     function symbol() external view returns (string memory);
705 
706     /**
707      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708      */
709     function tokenURI(uint256 tokenId) external view returns (string memory);
710 }
711 
712 
713 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
714 
715 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
716 
717 pragma solidity ^0.8.1;
718 
719 /**
720  * @dev Collection of functions related to the address type
721  */
722 library Address {
723     /**
724      * @dev Returns true if `account` is a contract.
725      *
726      * [IMPORTANT]
727      * ====
728      * It is unsafe to assume that an address for which this function returns
729      * false is an externally-owned account (EOA) and not a contract.
730      *
731      * Among others, `isContract` will return false for the following
732      * types of addresses:
733      *
734      *  - an externally-owned account
735      *  - a contract in construction
736      *  - an address where a contract will be created
737      *  - an address where a contract lived, but was destroyed
738      * ====
739      *
740      * [IMPORTANT]
741      * ====
742      * You shouldn't rely on `isContract` to protect against flash loan attacks!
743      *
744      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
745      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
746      * constructor.
747      * ====
748      */
749     function isContract(address account) internal view returns (bool) {
750         // This method relies on extcodesize/address.code.length, which returns 0
751         // for contracts in construction, since the code is only stored at the end
752         // of the constructor execution.
753 
754         return account.code.length > 0;
755     }
756 
757     /**
758      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
759      * `recipient`, forwarding all available gas and reverting on errors.
760      *
761      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
762      * of certain opcodes, possibly making contracts go over the 2300 gas limit
763      * imposed by `transfer`, making them unable to receive funds via
764      * `transfer`. {sendValue} removes this limitation.
765      *
766      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
767      *
768      * IMPORTANT: because control is transferred to `recipient`, care must be
769      * taken to not create reentrancy vulnerabilities. Consider using
770      * {ReentrancyGuard} or the
771      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
772      */
773     function sendValue(address payable recipient, uint256 amount) internal {
774         require(address(this).balance >= amount, "Address: insufficient balance");
775 
776         (bool success, ) = recipient.call{value: amount}("");
777         require(success, "Address: unable to send value, recipient may have reverted");
778     }
779 
780     /**
781      * @dev Performs a Solidity function call using a low level `call`. A
782      * plain `call` is an unsafe replacement for a function call: use this
783      * function instead.
784      *
785      * If `target` reverts with a revert reason, it is bubbled up by this
786      * function (like regular Solidity function calls).
787      *
788      * Returns the raw returned data. To convert to the expected return value,
789      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
790      *
791      * Requirements:
792      *
793      * - `target` must be a contract.
794      * - calling `target` with `data` must not revert.
795      *
796      * _Available since v3.1._
797      */
798     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
799         return functionCall(target, data, "Address: low-level call failed");
800     }
801 
802     /**
803      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
804      * `errorMessage` as a fallback revert reason when `target` reverts.
805      *
806      * _Available since v3.1._
807      */
808     function functionCall(
809         address target,
810         bytes memory data,
811         string memory errorMessage
812     ) internal returns (bytes memory) {
813         return functionCallWithValue(target, data, 0, errorMessage);
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
818      * but also transferring `value` wei to `target`.
819      *
820      * Requirements:
821      *
822      * - the calling contract must have an ETH balance of at least `value`.
823      * - the called Solidity function must be `payable`.
824      *
825      * _Available since v3.1._
826      */
827     function functionCallWithValue(
828         address target,
829         bytes memory data,
830         uint256 value
831     ) internal returns (bytes memory) {
832         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
837      * with `errorMessage` as a fallback revert reason when `target` reverts.
838      *
839      * _Available since v3.1._
840      */
841     function functionCallWithValue(
842         address target,
843         bytes memory data,
844         uint256 value,
845         string memory errorMessage
846     ) internal returns (bytes memory) {
847         require(address(this).balance >= value, "Address: insufficient balance for call");
848         require(isContract(target), "Address: call to non-contract");
849 
850         (bool success, bytes memory returndata) = target.call{value: value}(data);
851         return verifyCallResult(success, returndata, errorMessage);
852     }
853 
854     /**
855      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
856      * but performing a static call.
857      *
858      * _Available since v3.3._
859      */
860     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
861         return functionStaticCall(target, data, "Address: low-level static call failed");
862     }
863 
864     /**
865      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
866      * but performing a static call.
867      *
868      * _Available since v3.3._
869      */
870     function functionStaticCall(
871         address target,
872         bytes memory data,
873         string memory errorMessage
874     ) internal view returns (bytes memory) {
875         require(isContract(target), "Address: static call to non-contract");
876 
877         (bool success, bytes memory returndata) = target.staticcall(data);
878         return verifyCallResult(success, returndata, errorMessage);
879     }
880 
881     /**
882      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
883      * but performing a delegate call.
884      *
885      * _Available since v3.4._
886      */
887     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
888         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
889     }
890 
891     /**
892      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
893      * but performing a delegate call.
894      *
895      * _Available since v3.4._
896      */
897     function functionDelegateCall(
898         address target,
899         bytes memory data,
900         string memory errorMessage
901     ) internal returns (bytes memory) {
902         require(isContract(target), "Address: delegate call to non-contract");
903 
904         (bool success, bytes memory returndata) = target.delegatecall(data);
905         return verifyCallResult(success, returndata, errorMessage);
906     }
907 
908     /**
909      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
910      * revert reason using the provided one.
911      *
912      * _Available since v4.3._
913      */
914     function verifyCallResult(
915         bool success,
916         bytes memory returndata,
917         string memory errorMessage
918     ) internal pure returns (bytes memory) {
919         if (success) {
920             return returndata;
921         } else {
922             // Look for revert reason and bubble it up if present
923             if (returndata.length > 0) {
924                 // The easiest way to bubble the revert reason is using memory via assembly
925 
926                 assembly {
927                     let returndata_size := mload(returndata)
928                     revert(add(32, returndata), returndata_size)
929                 }
930             } else {
931                 revert(errorMessage);
932             }
933         }
934     }
935 }
936 
937 
938 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
939 
940 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
941 
942 pragma solidity ^0.8.0;
943 
944 /**
945  * @dev Implementation of the {IERC165} interface.
946  *
947  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
948  * for the additional interface id that will be supported. For example:
949  *
950  * ```solidity
951  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
952  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
953  * }
954  * ```
955  *
956  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
957  */
958 abstract contract ERC165 is IERC165 {
959     /**
960      * @dev See {IERC165-supportsInterface}.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
963         return interfaceId == type(IERC165).interfaceId;
964     }
965 }
966 
967 
968 // File erc721a/contracts/ERC721A.sol@v3.1.0
969 
970 // Creator: Chiru Labs
971 
972 pragma solidity ^0.8.4;
973 
974 
975 
976 
977 
978 
979 
980 error ApprovalCallerNotOwnerNorApproved();
981 error ApprovalQueryForNonexistentToken();
982 error ApproveToCaller();
983 error ApprovalToCurrentOwner();
984 error BalanceQueryForZeroAddress();
985 error MintToZeroAddress();
986 error MintZeroQuantity();
987 error OwnerQueryForNonexistentToken();
988 error TransferCallerNotOwnerNorApproved();
989 error TransferFromIncorrectOwner();
990 error TransferToNonERC721ReceiverImplementer();
991 error TransferToZeroAddress();
992 error URIQueryForNonexistentToken();
993 
994 /**
995  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
996  * the Metadata extension. Built to optimize for lower gas during batch mints.
997  *
998  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
999  *
1000  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1001  *
1002  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1003  */
1004 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1005     using Address for address;
1006     using Strings for uint256;
1007 
1008     // Compiler will pack this into a single 256bit word.
1009     struct TokenOwnership {
1010         // The address of the owner.
1011         address addr;
1012         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1013         uint64 startTimestamp;
1014         // Whether the token has been burned.
1015         bool burned;
1016     }
1017 
1018     // Compiler will pack this into a single 256bit word.
1019     struct AddressData {
1020         // Realistically, 2**64-1 is more than enough.
1021         uint64 balance;
1022         // Keeps track of mint count with minimal overhead for tokenomics.
1023         uint64 numberMinted;
1024         // Keeps track of burn count with minimal overhead for tokenomics.
1025         uint64 numberBurned;
1026         // For miscellaneous variable(s) pertaining to the address
1027         // (e.g. number of whitelist mint slots used).
1028         // If there are multiple variables, please pack them into a uint64.
1029         uint64 aux;
1030     }
1031 
1032     // The tokenId of the next token to be minted.
1033     uint256 internal _currentIndex;
1034 
1035     // The number of tokens burned.
1036     uint256 internal _burnCounter;
1037 
1038     // Token name
1039     string private _name;
1040 
1041     // Token symbol
1042     string private _symbol;
1043 
1044     // Mapping from token ID to ownership details
1045     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1046     mapping(uint256 => TokenOwnership) internal _ownerships;
1047 
1048     // Mapping owner address to address data
1049     mapping(address => AddressData) private _addressData;
1050 
1051     // Mapping from token ID to approved address
1052     mapping(uint256 => address) private _tokenApprovals;
1053 
1054     // Mapping from owner to operator approvals
1055     mapping(address => mapping(address => bool)) private _operatorApprovals;
1056 
1057     constructor(string memory name_, string memory symbol_) {
1058         _name = name_;
1059         _symbol = symbol_;
1060         _currentIndex = _startTokenId();
1061     }
1062 
1063     /**
1064      * To change the starting tokenId, please override this function.
1065      */
1066     function _startTokenId() internal view virtual returns (uint256) {
1067         return 0;
1068     }
1069 
1070     /**
1071      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1072      */
1073     function totalSupply() public view returns (uint256) {
1074         // Counter underflow is impossible as _burnCounter cannot be incremented
1075         // more than _currentIndex - _startTokenId() times
1076         unchecked {
1077             return _currentIndex - _burnCounter - _startTokenId();
1078         }
1079     }
1080 
1081     /**
1082      * Returns the total amount of tokens minted in the contract.
1083      */
1084     function _totalMinted() internal view returns (uint256) {
1085         // Counter underflow is impossible as _currentIndex does not decrement,
1086         // and it is initialized to _startTokenId()
1087         unchecked {
1088             return _currentIndex - _startTokenId();
1089         }
1090     }
1091 
1092     /**
1093      * @dev See {IERC165-supportsInterface}.
1094      */
1095     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1096         return
1097             interfaceId == type(IERC721).interfaceId ||
1098             interfaceId == type(IERC721Metadata).interfaceId ||
1099             super.supportsInterface(interfaceId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-balanceOf}.
1104      */
1105     function balanceOf(address owner) public view override returns (uint256) {
1106         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1107         return uint256(_addressData[owner].balance);
1108     }
1109 
1110     /**
1111      * Returns the number of tokens minted by `owner`.
1112      */
1113     function _numberMinted(address owner) internal view returns (uint256) {
1114         return uint256(_addressData[owner].numberMinted);
1115     }
1116 
1117     /**
1118      * Returns the number of tokens burned by or on behalf of `owner`.
1119      */
1120     function _numberBurned(address owner) internal view returns (uint256) {
1121         return uint256(_addressData[owner].numberBurned);
1122     }
1123 
1124     /**
1125      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1126      */
1127     function _getAux(address owner) internal view returns (uint64) {
1128         return _addressData[owner].aux;
1129     }
1130 
1131     /**
1132      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1133      * If there are multiple variables, please pack them into a uint64.
1134      */
1135     function _setAux(address owner, uint64 aux) internal {
1136         _addressData[owner].aux = aux;
1137     }
1138 
1139     /**
1140      * Gas spent here starts off proportional to the maximum mint batch size.
1141      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1142      */
1143     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1144         uint256 curr = tokenId;
1145 
1146         unchecked {
1147             if (_startTokenId() <= curr && curr < _currentIndex) {
1148                 TokenOwnership memory ownership = _ownerships[curr];
1149                 if (!ownership.burned) {
1150                     if (ownership.addr != address(0)) {
1151                         return ownership;
1152                     }
1153                     // Invariant:
1154                     // There will always be an ownership that has an address and is not burned
1155                     // before an ownership that does not have an address and is not burned.
1156                     // Hence, curr will not underflow.
1157                     while (true) {
1158                         curr--;
1159                         ownership = _ownerships[curr];
1160                         if (ownership.addr != address(0)) {
1161                             return ownership;
1162                         }
1163                     }
1164                 }
1165             }
1166         }
1167         revert OwnerQueryForNonexistentToken();
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-ownerOf}.
1172      */
1173     function ownerOf(uint256 tokenId) public view override returns (address) {
1174         return _ownershipOf(tokenId).addr;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Metadata-name}.
1179      */
1180     function name() public view virtual override returns (string memory) {
1181         return _name;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Metadata-symbol}.
1186      */
1187     function symbol() public view virtual override returns (string memory) {
1188         return _symbol;
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Metadata-tokenURI}.
1193      */
1194     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1195         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1196 
1197         string memory baseURI = _baseURI();
1198         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1199     }
1200 
1201     /**
1202      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1203      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1204      * by default, can be overriden in child contracts.
1205      */
1206     function _baseURI() internal view virtual returns (string memory) {
1207         return '';
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-approve}.
1212      */
1213     function approve(address to, uint256 tokenId) public override {
1214         address owner = ERC721A.ownerOf(tokenId);
1215         if (to == owner) revert ApprovalToCurrentOwner();
1216 
1217         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1218             revert ApprovalCallerNotOwnerNorApproved();
1219         }
1220 
1221         _approve(to, tokenId, owner);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-getApproved}.
1226      */
1227     function getApproved(uint256 tokenId) public view override returns (address) {
1228         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1229 
1230         return _tokenApprovals[tokenId];
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-setApprovalForAll}.
1235      */
1236     function setApprovalForAll(address operator, bool approved) public virtual override {
1237         if (operator == _msgSender()) revert ApproveToCaller();
1238 
1239         _operatorApprovals[_msgSender()][operator] = approved;
1240         emit ApprovalForAll(_msgSender(), operator, approved);
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-isApprovedForAll}.
1245      */
1246     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1247         return _operatorApprovals[owner][operator];
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-transferFrom}.
1252      */
1253     function transferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) public virtual override {
1258         _transfer(from, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) public virtual override {
1269         safeTransferFrom(from, to, tokenId, '');
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-safeTransferFrom}.
1274      */
1275     function safeTransferFrom(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) public virtual override {
1281         _transfer(from, to, tokenId);
1282         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1283             revert TransferToNonERC721ReceiverImplementer();
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns whether `tokenId` exists.
1289      *
1290      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1291      *
1292      * Tokens start existing when they are minted (`_mint`),
1293      */
1294     function _exists(uint256 tokenId) internal view returns (bool) {
1295         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1296             !_ownerships[tokenId].burned;
1297     }
1298 
1299     function _safeMint(address to, uint256 quantity) internal {
1300         _safeMint(to, quantity, '');
1301     }
1302 
1303     /**
1304      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1305      *
1306      * Requirements:
1307      *
1308      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1309      * - `quantity` must be greater than 0.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _safeMint(
1314         address to,
1315         uint256 quantity,
1316         bytes memory _data
1317     ) internal {
1318         _mint(to, quantity, _data, true);
1319     }
1320 
1321     /**
1322      * @dev Mints `quantity` tokens and transfers them to `to`.
1323      *
1324      * Requirements:
1325      *
1326      * - `to` cannot be the zero address.
1327      * - `quantity` must be greater than 0.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _mint(
1332         address to,
1333         uint256 quantity,
1334         bytes memory _data,
1335         bool safe
1336     ) internal {
1337         uint256 startTokenId = _currentIndex;
1338         if (to == address(0)) revert MintToZeroAddress();
1339         if (quantity == 0) revert MintZeroQuantity();
1340 
1341         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1342 
1343         // Overflows are incredibly unrealistic.
1344         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1345         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1346         unchecked {
1347             _addressData[to].balance += uint64(quantity);
1348             _addressData[to].numberMinted += uint64(quantity);
1349 
1350             _ownerships[startTokenId].addr = to;
1351             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1352 
1353             uint256 updatedIndex = startTokenId;
1354             uint256 end = updatedIndex + quantity;
1355 
1356             if (safe && to.isContract()) {
1357                 do {
1358                     emit Transfer(address(0), to, updatedIndex);
1359                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1360                         revert TransferToNonERC721ReceiverImplementer();
1361                     }
1362                 } while (updatedIndex != end);
1363                 // Reentrancy protection
1364                 if (_currentIndex != startTokenId) revert();
1365             } else {
1366                 do {
1367                     emit Transfer(address(0), to, updatedIndex++);
1368                 } while (updatedIndex != end);
1369             }
1370             _currentIndex = updatedIndex;
1371         }
1372         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1373     }
1374 
1375     /**
1376      * @dev Transfers `tokenId` from `from` to `to`.
1377      *
1378      * Requirements:
1379      *
1380      * - `to` cannot be the zero address.
1381      * - `tokenId` token must be owned by `from`.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function _transfer(
1386         address from,
1387         address to,
1388         uint256 tokenId
1389     ) private {
1390         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1391 
1392         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1393 
1394         bool isApprovedOrOwner = (_msgSender() == from ||
1395             isApprovedForAll(from, _msgSender()) ||
1396             getApproved(tokenId) == _msgSender());
1397 
1398         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1399         if (to == address(0)) revert TransferToZeroAddress();
1400 
1401         _beforeTokenTransfers(from, to, tokenId, 1);
1402 
1403         // Clear approvals from the previous owner
1404         _approve(address(0), tokenId, from);
1405 
1406         // Underflow of the sender's balance is impossible because we check for
1407         // ownership above and the recipient's balance can't realistically overflow.
1408         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1409         unchecked {
1410             _addressData[from].balance -= 1;
1411             _addressData[to].balance += 1;
1412 
1413             TokenOwnership storage currSlot = _ownerships[tokenId];
1414             currSlot.addr = to;
1415             currSlot.startTimestamp = uint64(block.timestamp);
1416 
1417             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1418             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1419             uint256 nextTokenId = tokenId + 1;
1420             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1421             if (nextSlot.addr == address(0)) {
1422                 // This will suffice for checking _exists(nextTokenId),
1423                 // as a burned slot cannot contain the zero address.
1424                 if (nextTokenId != _currentIndex) {
1425                     nextSlot.addr = from;
1426                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1427                 }
1428             }
1429         }
1430 
1431         emit Transfer(from, to, tokenId);
1432         _afterTokenTransfers(from, to, tokenId, 1);
1433     }
1434 
1435     /**
1436      * @dev This is equivalent to _burn(tokenId, false)
1437      */
1438     function _burn(uint256 tokenId) internal virtual {
1439         _burn(tokenId, false);
1440     }
1441 
1442     /**
1443      * @dev Destroys `tokenId`.
1444      * The approval is cleared when the token is burned.
1445      *
1446      * Requirements:
1447      *
1448      * - `tokenId` must exist.
1449      *
1450      * Emits a {Transfer} event.
1451      */
1452     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1453         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1454 
1455         address from = prevOwnership.addr;
1456 
1457         if (approvalCheck) {
1458             bool isApprovedOrOwner = (_msgSender() == from ||
1459                 isApprovedForAll(from, _msgSender()) ||
1460                 getApproved(tokenId) == _msgSender());
1461 
1462             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1463         }
1464 
1465         _beforeTokenTransfers(from, address(0), tokenId, 1);
1466 
1467         // Clear approvals from the previous owner
1468         _approve(address(0), tokenId, from);
1469 
1470         // Underflow of the sender's balance is impossible because we check for
1471         // ownership above and the recipient's balance can't realistically overflow.
1472         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1473         unchecked {
1474             AddressData storage addressData = _addressData[from];
1475             addressData.balance -= 1;
1476             addressData.numberBurned += 1;
1477 
1478             // Keep track of who burned the token, and the timestamp of burning.
1479             TokenOwnership storage currSlot = _ownerships[tokenId];
1480             currSlot.addr = from;
1481             currSlot.startTimestamp = uint64(block.timestamp);
1482             currSlot.burned = true;
1483 
1484             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1485             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1486             uint256 nextTokenId = tokenId + 1;
1487             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1488             if (nextSlot.addr == address(0)) {
1489                 // This will suffice for checking _exists(nextTokenId),
1490                 // as a burned slot cannot contain the zero address.
1491                 if (nextTokenId != _currentIndex) {
1492                     nextSlot.addr = from;
1493                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1494                 }
1495             }
1496         }
1497 
1498         emit Transfer(from, address(0), tokenId);
1499         _afterTokenTransfers(from, address(0), tokenId, 1);
1500 
1501         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1502         unchecked {
1503             _burnCounter++;
1504         }
1505     }
1506 
1507     /**
1508      * @dev Approve `to` to operate on `tokenId`
1509      *
1510      * Emits a {Approval} event.
1511      */
1512     function _approve(
1513         address to,
1514         uint256 tokenId,
1515         address owner
1516     ) private {
1517         _tokenApprovals[tokenId] = to;
1518         emit Approval(owner, to, tokenId);
1519     }
1520 
1521     /**
1522      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1523      *
1524      * @param from address representing the previous owner of the given token ID
1525      * @param to target address that will receive the tokens
1526      * @param tokenId uint256 ID of the token to be transferred
1527      * @param _data bytes optional data to send along with the call
1528      * @return bool whether the call correctly returned the expected magic value
1529      */
1530     function _checkContractOnERC721Received(
1531         address from,
1532         address to,
1533         uint256 tokenId,
1534         bytes memory _data
1535     ) private returns (bool) {
1536         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1537             return retval == IERC721Receiver(to).onERC721Received.selector;
1538         } catch (bytes memory reason) {
1539             if (reason.length == 0) {
1540                 revert TransferToNonERC721ReceiverImplementer();
1541             } else {
1542                 assembly {
1543                     revert(add(32, reason), mload(reason))
1544                 }
1545             }
1546         }
1547     }
1548 
1549     /**
1550      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1551      * And also called before burning one token.
1552      *
1553      * startTokenId - the first token id to be transferred
1554      * quantity - the amount to be transferred
1555      *
1556      * Calling conditions:
1557      *
1558      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1559      * transferred to `to`.
1560      * - When `from` is zero, `tokenId` will be minted for `to`.
1561      * - When `to` is zero, `tokenId` will be burned by `from`.
1562      * - `from` and `to` are never both zero.
1563      */
1564     function _beforeTokenTransfers(
1565         address from,
1566         address to,
1567         uint256 startTokenId,
1568         uint256 quantity
1569     ) internal virtual {}
1570 
1571     /**
1572      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1573      * minting.
1574      * And also called after one token has been burned.
1575      *
1576      * startTokenId - the first token id to be transferred
1577      * quantity - the amount to be transferred
1578      *
1579      * Calling conditions:
1580      *
1581      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1582      * transferred to `to`.
1583      * - When `from` is zero, `tokenId` has been minted for `to`.
1584      * - When `to` is zero, `tokenId` has been burned by `from`.
1585      * - `from` and `to` are never both zero.
1586      */
1587     function _afterTokenTransfers(
1588         address from,
1589         address to,
1590         uint256 startTokenId,
1591         uint256 quantity
1592     ) internal virtual {}
1593 }
1594 
1595 
1596 // File contracts/library/AddressString.sol
1597 
1598 
1599 pragma solidity >=0.5.0;
1600 
1601 library AddressString {
1602     // converts an address to the uppercase hex string, extracting only len bytes (up to 20, multiple of 2)
1603     function toAsciiString(address addr) internal pure returns (string memory) {
1604         bytes memory s = new bytes(42);
1605         uint160 addrNum = uint160(addr);
1606         s[0] = '0';
1607         s[1] = 'X';
1608         for (uint256 i = 0; i < 40 / 2; i++) {
1609             // shift right and truncate all but the least significant byte to extract the byte at position 19-i
1610             uint8 b = uint8(addrNum >> (8 * (19 - i)));
1611             // first hex character is the most significant 4 bits
1612             uint8 hi = b >> 4;
1613             // second hex character is the least significant 4 bits
1614             uint8 lo = b - (hi << 4);
1615             s[2 * i + 2] = char(hi);
1616             s[2 * i + 3] = char(lo);
1617         }
1618         return string(s);
1619     }
1620 
1621     // hi and lo are only 4 bits and between 0 and 16
1622     // this method converts those values to the unicode/ascii code point for the hex representation
1623     // uses upper case for the characters
1624     function char(uint8 b) private pure returns (bytes1 c) {
1625         if (b < 10) {
1626             return bytes1(b + 0x30);
1627         } else {
1628             return bytes1(b + 0x37);
1629         }
1630     }
1631 }
1632 
1633 
1634 
1635 // File contracts/legendary.nft.sol
1636 //
1637 pragma solidity ^0.8.4;
1638 
1639 contract Okimi is Ownable, ERC721A, ReentrancyGuard {
1640   uint256 public immutable maxPerAddressDuringMint;
1641   uint256 public immutable amountForDevs;
1642   uint256 public immutable amountForSaleAndDev;
1643   uint256 internal immutable collectionSize;
1644   uint256 internal immutable maxBatchSize;
1645 
1646   struct SaleConfig {
1647     uint32 publicSaleStartTime;
1648     uint64 publicPriceWei;
1649   }
1650 
1651   SaleConfig public saleConfig;
1652 
1653   constructor()
1654   ERC721A("Okimi", "OKM")
1655   {
1656     maxPerAddressDuringMint = 5;
1657     maxBatchSize = 5;
1658     collectionSize = amountForDevs = amountForSaleAndDev = 1500;
1659     saleConfig.publicPriceWei = 5 ether / 1000;  // 0.005 ETH
1660     saleConfig.publicSaleStartTime = uint32(block.timestamp);
1661   }
1662 
1663   modifier callerIsUser() {
1664     require(tx.origin == msg.sender, "The caller is another contract");
1665     _;
1666   }
1667 
1668   function mint(uint256 quantity)
1669     external
1670     payable
1671     callerIsUser
1672   {
1673     SaleConfig memory config = saleConfig;
1674     uint256 publicPrice = uint256(config.publicPriceWei);
1675     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1676 
1677     require(
1678       isSaleOn(publicPrice, publicSaleStartTime),
1679       "sale has not begun yet"
1680     );
1681     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1682     require(
1683       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1684       "can not mint this many"
1685     );
1686     _safeMint(msg.sender, quantity);
1687     refundIfOver(publicPrice * quantity);
1688   }
1689 
1690   function refundIfOver(uint256 price)
1691     private
1692   {
1693     require(msg.value >= price, "Need to send more ETH.");
1694     if (msg.value > price) {
1695       payable(msg.sender).transfer(msg.value - price);
1696     }
1697   }
1698 
1699   function isSaleOn(uint256 _price, uint256 _startTime)
1700     public
1701     view
1702     returns (bool) 
1703   {
1704     return _price != 0 && _startTime != 0 && block.timestamp >= _startTime;
1705   }
1706 
1707   function getPrice()
1708     public
1709     view
1710     returns (uint256)
1711   {
1712     return uint256(saleConfig.publicPriceWei);
1713   }
1714 
1715   function setPublicSaleConfig(uint32 timestamp, uint64 price)
1716     external
1717     onlyOwner 
1718   {
1719     saleConfig.publicSaleStartTime = timestamp;
1720     saleConfig.publicPriceWei = price;
1721   }
1722 
1723   // For marketing etc.
1724   function reserve(uint256 quantity)
1725     external
1726     onlyOwner
1727   {
1728     require(
1729       totalSupply() + quantity <= amountForDevs,
1730       "too many already minted before dev mint"
1731     );
1732     require(
1733       quantity % maxBatchSize == 0,
1734       "can only mint a multiple of the maxBatchSize"
1735     );
1736     uint256 numChunks = quantity / maxBatchSize;
1737     for (uint256 i = 0; i < numChunks; i++) {
1738       _safeMint(msg.sender, maxBatchSize);
1739     }
1740   }
1741 
1742   // metadata URI
1743   string private _baseTokenURI;
1744 
1745   function _baseURI() internal view virtual override returns (string memory) {
1746     return _baseTokenURI;
1747   }
1748 
1749   function setBaseURI(string calldata baseURI)
1750     external
1751     onlyOwner 
1752   {
1753     _baseTokenURI = baseURI;
1754   }
1755 
1756   function withdraw()
1757     external
1758     onlyOwner
1759     nonReentrant 
1760   {
1761     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1762     require(success, "Transfer failed.");
1763   }
1764 
1765   function numberMinted(address owner)
1766     public
1767     view
1768     returns (uint256) 
1769   {
1770     return _numberMinted(owner);
1771   }
1772 
1773   function getOwnershipData(uint256 tokenId) 
1774     external
1775     view
1776     returns (TokenOwnership memory)
1777   {
1778     return _ownershipOf(tokenId);
1779   }
1780 
1781   function totalMinted()
1782     public
1783     view
1784     returns (uint256) 
1785   {
1786       // Counter underflow is impossible as _currentIndex does not decrement,
1787       // and it is initialized to _startTokenId()
1788       unchecked {
1789           return _currentIndex - _startTokenId();
1790       }
1791   }
1792 }