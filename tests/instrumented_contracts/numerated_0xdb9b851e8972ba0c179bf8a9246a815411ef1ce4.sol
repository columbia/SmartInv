1 // SPDX-License-Identifier: BSD-3-Clause
2 
3 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
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
71 
72 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 
99 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _transferOwnership(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Internal function without access restriction.
167      */
168     function _transferOwnership(address newOwner) internal virtual {
169         address oldOwner = _owner;
170         _owner = newOwner;
171         emit OwnershipTransferred(oldOwner, newOwner);
172     }
173 }
174 
175 
176 // File contracts/Blimpie/Delegated.sol
177 
178 pragma solidity ^0.8.0;
179 
180 /***********************
181 * @author: squeebo_nft *
182 ************************/
183 
184 contract Delegated is Ownable{
185   mapping(address => bool) internal _delegates;
186 
187   constructor(){
188     _delegates[owner()] = true;
189   }
190 
191   modifier onlyDelegates {
192     require(_delegates[msg.sender], "Invalid delegate" );
193     _;
194   }
195 
196   //onlyOwner
197   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
198     return _delegates[addr];
199   }
200 
201   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
202     _delegates[addr] = isDelegate_;
203   }
204 
205   function transferOwnership(address newOwner) public virtual override onlyOwner {
206     _delegates[newOwner] = true;
207     super.transferOwnership( newOwner );
208   }
209 }
210 
211 
212 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.4.1
213 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
219  *
220  * These functions can be used to verify that a message was signed by the holder
221  * of the private keys of a given address.
222  */
223 library ECDSA {
224     enum RecoverError {
225         NoError,
226         InvalidSignature,
227         InvalidSignatureLength,
228         InvalidSignatureS,
229         InvalidSignatureV
230     }
231 
232     function _throwError(RecoverError error) private pure {
233         if (error == RecoverError.NoError) {
234             return; // no error: do nothing
235         } else if (error == RecoverError.InvalidSignature) {
236             revert("ECDSA: invalid signature");
237         } else if (error == RecoverError.InvalidSignatureLength) {
238             revert("ECDSA: invalid signature length");
239         } else if (error == RecoverError.InvalidSignatureS) {
240             revert("ECDSA: invalid signature 's' value");
241         } else if (error == RecoverError.InvalidSignatureV) {
242             revert("ECDSA: invalid signature 'v' value");
243         }
244     }
245 
246     /**
247      * @dev Returns the address that signed a hashed message (`hash`) with
248      * `signature` or error string. This address can then be used for verification purposes.
249      *
250      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
251      * this function rejects them by requiring the `s` value to be in the lower
252      * half order, and the `v` value to be either 27 or 28.
253      *
254      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
255      * verification to be secure: it is possible to craft signatures that
256      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
257      * this is by receiving a hash of the original message (which may otherwise
258      * be too long), and then calling {toEthSignedMessageHash} on it.
259      *
260      * Documentation for signature generation:
261      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
262      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
263      *
264      * _Available since v4.3._
265      */
266     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
267         // Check the signature length
268         // - case 65: r,s,v signature (standard)
269         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
270         if (signature.length == 65) {
271             bytes32 r;
272             bytes32 s;
273             uint8 v;
274             // ecrecover takes the signature parameters, and the only way to get them
275             // currently is to use assembly.
276             assembly {
277                 r := mload(add(signature, 0x20))
278                 s := mload(add(signature, 0x40))
279                 v := byte(0, mload(add(signature, 0x60)))
280             }
281             return tryRecover(hash, v, r, s);
282         } else if (signature.length == 64) {
283             bytes32 r;
284             bytes32 vs;
285             // ecrecover takes the signature parameters, and the only way to get them
286             // currently is to use assembly.
287             assembly {
288                 r := mload(add(signature, 0x20))
289                 vs := mload(add(signature, 0x40))
290             }
291             return tryRecover(hash, r, vs);
292         } else {
293             return (address(0), RecoverError.InvalidSignatureLength);
294         }
295     }
296 
297     /**
298      * @dev Returns the address that signed a hashed message (`hash`) with
299      * `signature`. This address can then be used for verification purposes.
300      *
301      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
302      * this function rejects them by requiring the `s` value to be in the lower
303      * half order, and the `v` value to be either 27 or 28.
304      *
305      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
306      * verification to be secure: it is possible to craft signatures that
307      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
308      * this is by receiving a hash of the original message (which may otherwise
309      * be too long), and then calling {toEthSignedMessageHash} on it.
310      */
311     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
312         (address recovered, RecoverError error) = tryRecover(hash, signature);
313         _throwError(error);
314         return recovered;
315     }
316 
317     /**
318      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
319      *
320      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
321      *
322      * _Available since v4.3._
323      */
324     function tryRecover(
325         bytes32 hash,
326         bytes32 r,
327         bytes32 vs
328     ) internal pure returns (address, RecoverError) {
329         bytes32 s;
330         uint8 v;
331         assembly {
332             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
333             v := add(shr(255, vs), 27)
334         }
335         return tryRecover(hash, v, r, s);
336     }
337 
338     /**
339      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
340      *
341      * _Available since v4.2._
342      */
343     function recover(
344         bytes32 hash,
345         bytes32 r,
346         bytes32 vs
347     ) internal pure returns (address) {
348         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
349         _throwError(error);
350         return recovered;
351     }
352 
353     /**
354      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
355      * `r` and `s` signature fields separately.
356      *
357      * _Available since v4.3._
358      */
359     function tryRecover(
360         bytes32 hash,
361         uint8 v,
362         bytes32 r,
363         bytes32 s
364     ) internal pure returns (address, RecoverError) {
365         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
366         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
367         // the valid range for s in (301): 0 < s < secp256k1n ├╖ 2 + 1, and for v in (302): v Γêê {27, 28}. Most
368         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
369         //
370         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
371         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
372         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
373         // these malleable signatures as well.
374         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
375             return (address(0), RecoverError.InvalidSignatureS);
376         }
377         if (v != 27 && v != 28) {
378             return (address(0), RecoverError.InvalidSignatureV);
379         }
380 
381         // If the signature is valid (and not malleable), return the signer address
382         address signer = ecrecover(hash, v, r, s);
383         if (signer == address(0)) {
384             return (address(0), RecoverError.InvalidSignature);
385         }
386 
387         return (signer, RecoverError.NoError);
388     }
389 
390     /**
391      * @dev Overload of {ECDSA-recover} that receives the `v`,
392      * `r` and `s` signature fields separately.
393      */
394     function recover(
395         bytes32 hash,
396         uint8 v,
397         bytes32 r,
398         bytes32 s
399     ) internal pure returns (address) {
400         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
401         _throwError(error);
402         return recovered;
403     }
404 
405     /**
406      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
407      * produces hash corresponding to the one signed with the
408      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
409      * JSON-RPC method as part of EIP-191.
410      *
411      * See {recover}.
412      */
413     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
414         // 32 is the length in bytes of hash,
415         // enforced by the type signature above
416         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
417     }
418 
419     /**
420      * @dev Returns an Ethereum Signed Message, created from `s`. This
421      * produces hash corresponding to the one signed with the
422      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
423      * JSON-RPC method as part of EIP-191.
424      *
425      * See {recover}.
426      */
427     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
428         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
429     }
430 
431     /**
432      * @dev Returns an Ethereum Signed Typed Data, created from a
433      * `domainSeparator` and a `structHash`. This produces hash corresponding
434      * to the one signed with the
435      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
436      * JSON-RPC method as part of EIP-712.
437      *
438      * See {recover}.
439      */
440     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
441         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
442     }
443 }
444 
445 
446 // File contracts/Blimpie/Signed.sol
447 
448 pragma solidity ^0.8.0;
449 contract Signed is Delegated{
450   using Strings for uint256;
451   using ECDSA for bytes32;
452 
453   string private _secret;
454   address private _signer;
455 
456 
457   function setSecret( string calldata secret ) external onlyOwner{
458     _secret = secret;
459   }
460 
461   function setSigner( address signer ) external onlyOwner{
462     _signer = signer;
463   }
464 
465 
466   function createHash( string memory data ) internal view returns ( bytes32 ){
467     return keccak256( abi.encodePacked( address(this), msg.sender, data, _secret ) );
468   }
469 
470   function getSigner( bytes32 hash, bytes memory signature ) internal pure returns( address ){
471     return hash.toEthSignedMessageHash().recover( signature );
472   }
473 
474   function isAuthorizedSigner( address extracted ) internal view virtual returns( bool ){
475     return extracted == _signer;
476   }
477 
478   function verifySignature( string memory data, bytes calldata signature ) internal view {
479     address extracted = getSigner( createHash( data ), signature );
480     require( isAuthorizedSigner( extracted ), "Signature verification failed" );
481   }
482 
483 
484 }
485 
486 
487 // File contracts/Blimpie/IERC721Batch.sol
488 
489 pragma solidity ^0.8.0;
490 
491 interface IERC721Batch {
492   function isOwnerOf( address account, uint[] calldata tokenIds ) external view returns( bool );
493   function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external;
494   function walletOfOwner( address account ) external view returns( uint[] memory );
495 }
496 
497 
498 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
499 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Interface of the ERC165 standard, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-165[EIP].
506  *
507  * Implementers can declare support of contract interfaces, which can then be
508  * queried by others ({ERC165Checker}).
509  *
510  * For an implementation, see {ERC165}.
511  */
512 interface IERC165 {
513     /**
514      * @dev Returns true if this contract implements the interface defined by
515      * `interfaceId`. See the corresponding
516      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
517      * to learn more about how these ids are created.
518      *
519      * This function call must use less than 30 000 gas.
520      */
521     function supportsInterface(bytes4 interfaceId) external view returns (bool);
522 }
523 
524 
525 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
526 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Required interface of an ERC721 compliant contract.
532  */
533 interface IERC721 is IERC165 {
534     /**
535      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
536      */
537     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
541      */
542     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
543 
544     /**
545      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
546      */
547     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
548 
549     /**
550      * @dev Returns the number of tokens in ``owner``'s account.
551      */
552     function balanceOf(address owner) external view returns (uint256 balance);
553 
554     /**
555      * @dev Returns the owner of the `tokenId` token.
556      *
557      * Requirements:
558      *
559      * - `tokenId` must exist.
560      */
561     function ownerOf(uint256 tokenId) external view returns (address owner);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
565      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId
581     ) external;
582 
583     /**
584      * @dev Transfers `tokenId` token from `from` to `to`.
585      *
586      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      *
595      * Emits a {Transfer} event.
596      */
597     function transferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
605      * The approval is cleared when the token is transferred.
606      *
607      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
608      *
609      * Requirements:
610      *
611      * - The caller must own the token or be an approved operator.
612      * - `tokenId` must exist.
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address to, uint256 tokenId) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Approve or remove `operator` as an operator for the caller.
629      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
630      *
631      * Requirements:
632      *
633      * - The `operator` cannot be the caller.
634      *
635      * Emits an {ApprovalForAll} event.
636      */
637     function setApprovalForAll(address operator, bool _approved) external;
638 
639     /**
640      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
641      *
642      * See {setApprovalForAll}
643      */
644     function isApprovedForAll(address owner, address operator) external view returns (bool);
645 
646     /**
647      * @dev Safely transfers `tokenId` token from `from` to `to`.
648      *
649      * Requirements:
650      *
651      * - `from` cannot be the zero address.
652      * - `to` cannot be the zero address.
653      * - `tokenId` token must exist and be owned by `from`.
654      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656      *
657      * Emits a {Transfer} event.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId,
663         bytes calldata data
664     ) external;
665 }
666 
667 
668 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.1
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Enumerable is IERC721 {
678     /**
679      * @dev Returns the total amount of tokens stored by the contract.
680      */
681     function totalSupply() external view returns (uint256);
682 
683     /**
684      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
685      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
686      */
687     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
688 
689     /**
690      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
691      * Use along with {totalSupply} to enumerate all tokens.
692      */
693     function tokenByIndex(uint256 index) external view returns (uint256);
694 }
695 
696 
697 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
698 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 /**
703  * @title ERC721 token receiver interface
704  * @dev Interface for any contract that wants to support safeTransfers
705  * from ERC721 asset contracts.
706  */
707 interface IERC721Receiver {
708     /**
709      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
710      * by `operator` from `from`, this function is called.
711      *
712      * It must return its Solidity selector to confirm the token transfer.
713      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
714      *
715      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
716      */
717     function onERC721Received(
718         address operator,
719         address from,
720         uint256 tokenId,
721         bytes calldata data
722     ) external returns (bytes4);
723 }
724 
725 
726 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
727 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 
753 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
754 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 /**
759  * @dev Collection of functions related to the address type
760  */
761 library Address {
762     /**
763      * @dev Returns true if `account` is a contract.
764      *
765      * [IMPORTANT]
766      * ====
767      * It is unsafe to assume that an address for which this function returns
768      * false is an externally-owned account (EOA) and not a contract.
769      *
770      * Among others, `isContract` will return false for the following
771      * types of addresses:
772      *
773      *  - an externally-owned account
774      *  - a contract in construction
775      *  - an address where a contract will be created
776      *  - an address where a contract lived, but was destroyed
777      * ====
778      */
779     function isContract(address account) internal view returns (bool) {
780         // This method relies on extcodesize, which returns 0 for contracts in
781         // construction, since the code is only stored at the end of the
782         // constructor execution.
783 
784         uint256 size;
785         assembly {
786             size := extcodesize(account)
787         }
788         return size > 0;
789     }
790 
791     /**
792      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
793      * `recipient`, forwarding all available gas and reverting on errors.
794      *
795      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
796      * of certain opcodes, possibly making contracts go over the 2300 gas limit
797      * imposed by `transfer`, making them unable to receive funds via
798      * `transfer`. {sendValue} removes this limitation.
799      *
800      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
801      *
802      * IMPORTANT: because control is transferred to `recipient`, care must be
803      * taken to not create reentrancy vulnerabilities. Consider using
804      * {ReentrancyGuard} or the
805      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
806      */
807     function sendValue(address payable recipient, uint256 amount) internal {
808         require(address(this).balance >= amount, "Address: insufficient balance");
809 
810         (bool success, ) = recipient.call{value: amount}("");
811         require(success, "Address: unable to send value, recipient may have reverted");
812     }
813 
814     /**
815      * @dev Performs a Solidity function call using a low level `call`. A
816      * plain `call` is an unsafe replacement for a function call: use this
817      * function instead.
818      *
819      * If `target` reverts with a revert reason, it is bubbled up by this
820      * function (like regular Solidity function calls).
821      *
822      * Returns the raw returned data. To convert to the expected return value,
823      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
824      *
825      * Requirements:
826      *
827      * - `target` must be a contract.
828      * - calling `target` with `data` must not revert.
829      *
830      * _Available since v3.1._
831      */
832     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
833         return functionCall(target, data, "Address: low-level call failed");
834     }
835 
836     /**
837      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
838      * `errorMessage` as a fallback revert reason when `target` reverts.
839      *
840      * _Available since v3.1._
841      */
842     function functionCall(
843         address target,
844         bytes memory data,
845         string memory errorMessage
846     ) internal returns (bytes memory) {
847         return functionCallWithValue(target, data, 0, errorMessage);
848     }
849 
850     /**
851      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
852      * but also transferring `value` wei to `target`.
853      *
854      * Requirements:
855      *
856      * - the calling contract must have an ETH balance of at least `value`.
857      * - the called Solidity function must be `payable`.
858      *
859      * _Available since v3.1._
860      */
861     function functionCallWithValue(
862         address target,
863         bytes memory data,
864         uint256 value
865     ) internal returns (bytes memory) {
866         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
867     }
868 
869     /**
870      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
871      * with `errorMessage` as a fallback revert reason when `target` reverts.
872      *
873      * _Available since v3.1._
874      */
875     function functionCallWithValue(
876         address target,
877         bytes memory data,
878         uint256 value,
879         string memory errorMessage
880     ) internal returns (bytes memory) {
881         require(address(this).balance >= value, "Address: insufficient balance for call");
882         require(isContract(target), "Address: call to non-contract");
883 
884         (bool success, bytes memory returndata) = target.call{value: value}(data);
885         return verifyCallResult(success, returndata, errorMessage);
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
890      * but performing a static call.
891      *
892      * _Available since v3.3._
893      */
894     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
895         return functionStaticCall(target, data, "Address: low-level static call failed");
896     }
897 
898     /**
899      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
900      * but performing a static call.
901      *
902      * _Available since v3.3._
903      */
904     function functionStaticCall(
905         address target,
906         bytes memory data,
907         string memory errorMessage
908     ) internal view returns (bytes memory) {
909         require(isContract(target), "Address: static call to non-contract");
910 
911         (bool success, bytes memory returndata) = target.staticcall(data);
912         return verifyCallResult(success, returndata, errorMessage);
913     }
914 
915     /**
916      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
917      * but performing a delegate call.
918      *
919      * _Available since v3.4._
920      */
921     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
922         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
923     }
924 
925     /**
926      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
927      * but performing a delegate call.
928      *
929      * _Available since v3.4._
930      */
931     function functionDelegateCall(
932         address target,
933         bytes memory data,
934         string memory errorMessage
935     ) internal returns (bytes memory) {
936         require(isContract(target), "Address: delegate call to non-contract");
937 
938         (bool success, bytes memory returndata) = target.delegatecall(data);
939         return verifyCallResult(success, returndata, errorMessage);
940     }
941 
942     /**
943      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
944      * revert reason using the provided one.
945      *
946      * _Available since v4.3._
947      */
948     function verifyCallResult(
949         bool success,
950         bytes memory returndata,
951         string memory errorMessage
952     ) internal pure returns (bytes memory) {
953         if (success) {
954             return returndata;
955         } else {
956             // Look for revert reason and bubble it up if present
957             if (returndata.length > 0) {
958                 // The easiest way to bubble the revert reason is using memory via assembly
959 
960                 assembly {
961                     let returndata_size := mload(returndata)
962                     revert(add(32, returndata), returndata_size)
963                 }
964             } else {
965                 revert(errorMessage);
966             }
967         }
968     }
969 }
970 
971 
972 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
973 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @dev Implementation of the {IERC165} interface.
979  *
980  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
981  * for the additional interface id that will be supported. For example:
982  *
983  * ```solidity
984  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
985  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
986  * }
987  * ```
988  *
989  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
990  */
991 abstract contract ERC165 is IERC165 {
992     /**
993      * @dev See {IERC165-supportsInterface}.
994      */
995     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
996         return interfaceId == type(IERC165).interfaceId;
997     }
998 }
999 
1000 
1001 // File contracts/PoodleDunks/PD721.sol
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 /****************************************
1006  * @author: squeebo_nft                 *
1007  * @team:   GoldenX                     *
1008  ****************************************
1009  *   Blimpie-ERC721 provides low-gas    *
1010  *           mints + transfers          *
1011  ****************************************/
1012 
1013 abstract contract PD721 is Context, Delegated, ERC165, IERC721, IERC721Metadata {
1014     using Address for address;
1015 
1016     string private _name;
1017     string private _symbol;
1018     address[] internal _owners;
1019 
1020     mapping(uint => address) internal _tokenApprovals;
1021     mapping(address => mapping(address => bool)) private _operatorApprovals;
1022 
1023     constructor(string memory name_, string memory symbol_)
1024         Delegated(){
1025         _name = name_;
1026         _symbol = symbol_;
1027     }
1028 
1029     //public
1030     function name() external view override returns (string memory) {
1031         return _name;
1032     }
1033 
1034     function balanceOf(address owner) public view override returns (uint256) {
1035         require(owner != address(0), "ERC721: balance query for the zero address");
1036 
1037         uint count;
1038         for( uint i; i < _owners.length; ++i ){
1039             if( owner == _owners[i] )
1040                 ++count;
1041         }
1042         return count;
1043     }
1044 
1045     function ownerOf(uint tokenId) public view override returns (address) {
1046         require(_exists(tokenId), "ERC721: query for nonexistent token");
1047         return _owners[tokenId];
1048     }
1049 
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1051         return
1052             interfaceId == type(IERC721).interfaceId ||
1053             interfaceId == type(IERC721Metadata).interfaceId ||
1054             super.supportsInterface(interfaceId);
1055     }
1056 
1057     function symbol() external view override returns (string memory) {
1058         return _symbol;
1059     }
1060 
1061     function approve(address to, uint tokenId) external override {
1062         address owner = ownerOf(tokenId);
1063         require(to != owner, "ERC721: approval to current owner");
1064 
1065         require(
1066             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1067             "ERC721: approve caller is not owner nor approved for all"
1068         );
1069 
1070         _approve(to, tokenId);
1071     }
1072 
1073     function getApproved(uint tokenId) public view override returns (address) {
1074         require(_exists(tokenId), "ERC721: query for nonexistent token");
1075         return _tokenApprovals[tokenId];
1076     }
1077 
1078     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1079         return _operatorApprovals[owner][operator];
1080     }
1081 
1082     function setApprovalForAll(address operator, bool approved) external override {
1083         require(operator != _msgSender(), "ERC721: approve to caller");
1084         _operatorApprovals[_msgSender()][operator] = approved;
1085         emit ApprovalForAll(_msgSender(), operator, approved);
1086     }
1087 
1088     function transferFrom(
1089         address from,
1090         address to,
1091         uint tokenId
1092     ) external override {
1093         //solhint-disable-next-line max-line-length
1094         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1095         _transfer(from, to, tokenId);
1096     }
1097 
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint tokenId
1102     ) external override {
1103         safeTransferFrom(from, to, tokenId, "");
1104     }
1105 
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint tokenId,
1110         bytes memory _data
1111     ) public override {
1112         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1113         _safeTransfer(from, to, tokenId, _data);
1114     }
1115 
1116 
1117     //internal
1118     function _approve(address to, uint tokenId) internal {
1119         _tokenApprovals[tokenId] = to;
1120         emit Approval(ownerOf(tokenId), to, tokenId);
1121     }
1122 
1123     function _checkOnERC721Received(
1124         address from,
1125         address to,
1126         uint tokenId,
1127         bytes memory _data
1128     ) private returns (bool) {
1129         if (to.isContract()) {
1130             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1131                 return retval == IERC721Receiver.onERC721Received.selector;
1132             } catch (bytes memory reason) {
1133                 if (reason.length == 0) {
1134                     revert("ERC721: transfer to non ERC721Receiver implementer");
1135                 } else {
1136                     assembly {
1137                         revert(add(32, reason), mload(reason))
1138                     }
1139                 }
1140             }
1141         } else {
1142             return true;
1143         }
1144     }
1145 
1146     function _exists(uint tokenId) internal view returns (bool) {
1147         return tokenId < _owners.length && _owners[tokenId] != address(0);
1148     }
1149 
1150     function _isApprovedOrOwner(address spender, uint tokenId) internal view returns (bool) {
1151         require(_exists(tokenId), "ERC721: query for nonexistent token");
1152         address owner = ownerOf(tokenId);
1153         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1154     }
1155 
1156     function _mint(address to, uint tokenId) internal virtual;
1157 
1158     function _safeTransfer(
1159         address from,
1160         address to,
1161         uint tokenId,
1162         bytes memory _data
1163     ) internal {
1164         _transfer(from, to, tokenId);
1165         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1166     }
1167 
1168     function _transfer(
1169         address from,
1170         address to,
1171         uint tokenId
1172     ) internal {
1173         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1174         require(to != address(0), "ERC721: transfer to the zero address");
1175 
1176         // Clear approvals from the previous owner
1177         _approve(address(0), tokenId);
1178         _owners[tokenId] = to;
1179 
1180         emit Transfer(from, to, tokenId);
1181     }
1182 }
1183 
1184 
1185 // File contracts/PoodleDunks/PD721Enumerable.sol
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 /**
1191  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1192  * enumerability of all the token ids in the contract as well as all token ids owned by each
1193  * account.
1194  */
1195 abstract contract PD721Enumerable is PD721, IERC721Enumerable {
1196     /**
1197      * @dev See {IERC165-supportsInterface}.
1198      */
1199     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, PD721) returns (bool) {
1200         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1205      */
1206     function tokenOfOwnerByIndex(address owner, uint256 index) external view override returns (uint256 tokenId) {
1207         uint count;
1208         for( uint i; i < _owners.length; ++i ){
1209             if( owner == _owners[i] ){
1210                 if( count == index )
1211                     return i;
1212                 else
1213                     ++count;
1214             }
1215         }
1216 
1217         require(false, "ERC721Enumerable: owner index out of bounds");
1218     }
1219 
1220     /**
1221      * @dev See {IERC721Enumerable-totalSupply}.
1222      */
1223     function totalSupply() public view override returns (uint256) {
1224         return _owners.length;
1225     }
1226 
1227     /**
1228      * @dev See {IERC721Enumerable-tokenByIndex}.
1229      */
1230     function tokenByIndex(uint256 index) external view override returns (uint256) {
1231         require(index < _owners.length, "ERC721: query for nonexistent token");
1232         return index;
1233     }
1234 }
1235 
1236 
1237 // File contracts/PoodleDunks/PD721Batch.sol
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 /****************************************
1242  * @author: squeebo_nft                 *
1243  * @team:   GoldenX                     *
1244  ****************************************/
1245 
1246 
1247 abstract contract PD721Batch is PD721Enumerable, IERC721Batch {
1248   function isOwnerOf( address account, uint[] calldata tokenIds ) external view override returns( bool ){
1249     for(uint i; i < tokenIds.length; ++i ){
1250       if( _owners[ tokenIds[i] ] != account )
1251         return false;
1252     }
1253 
1254     return true;
1255   }
1256 
1257   function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external override{
1258     for(uint i; i < tokenIds.length; ++i ){
1259       safeTransferFrom( from, to, tokenIds[i], data );
1260     }
1261   }
1262 
1263   function walletOfOwner( address account ) public view override returns( uint[] memory ){
1264     uint quantity = balanceOf( account );
1265 
1266     uint count;
1267     uint[] memory wallet = new uint[]( quantity );
1268     for( uint i; i < _owners.length; ++i ){
1269       if( account == _owners[i] ){
1270         wallet[ count++ ] = i;
1271         if( count == quantity )
1272           break;
1273       }
1274     }
1275     return wallet;
1276   }
1277 }
1278 
1279 
1280 // File contracts/PoodleDunks/PoodleDunks.sol
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 /****************************************
1285  * @author: GoldenX                     *
1286  ****************************************
1287  *   Blimpie-ERC721 provides low-gas    *
1288  *           mints + transfers          *
1289  ****************************************/
1290 
1291 
1292 
1293 contract PoodleDunks is PD721Batch, Signed {
1294   using Strings for uint;
1295 
1296   uint public MAX_CLAIM  = 2000;
1297   uint public MAX_ORDER  = 20;
1298   uint public MAX_SUPPLY = 10000;
1299   uint public PRICE      = 0.04 ether;
1300 
1301   bool public isFreesaleActive = false;
1302   bool public isPresaleActive = false;
1303   bool public isVerified = true;
1304   bool public isMainsaleActive = false;
1305   uint public totalClaimed;
1306 
1307   string private _baseTokenURI = '';
1308   string private _tokenURISuffix = '';
1309   mapping(address => uint) private _claimed;
1310   address private a1 = 0xB7edf3Cbb58ecb74BdE6298294c7AAb339F3cE4a;
1311 
1312   constructor()
1313     PD721("PoodleDunks", "PDNK"){
1314   }
1315 
1316 
1317   //safety first
1318   fallback() external payable {}
1319 
1320   receive() external payable {}
1321 
1322   function withdraw() external onlyOwner{
1323     require( address(this).balance > 0 );
1324     require( payable(a1).send( address(this).balance ) );
1325   }
1326 
1327 
1328   //view
1329   function getTokensByOwner(address owner) external view returns(uint256[] memory) {
1330     return walletOfOwner(owner);
1331   }
1332 
1333   function tokenURI(uint tokenId) external view override returns (string memory) {
1334     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1335     return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _tokenURISuffix));
1336   }
1337 
1338 
1339   //nonpayable 
1340   function claim( uint quantity, bytes calldata signature ) external {
1341     require( isFreesaleActive, "Claim is not active" );
1342     require( _claimed[ msg.sender ] < quantity, "No claims available" );
1343     quantity -= _claimed[ msg.sender ];
1344 
1345     uint supply = totalSupply();
1346     require( quantity + supply <= MAX_SUPPLY );
1347 
1348     totalClaimed += quantity;
1349     require( totalClaimed <= MAX_CLAIM, "No claim supply available" );
1350 
1351     if( isVerified )
1352       verifySignature( quantity.toString(), signature );
1353 
1354     unchecked {
1355       _claimed[ msg.sender ] += quantity;
1356       for(uint i; i < quantity; i++){
1357         _mint( msg.sender, supply++ );
1358       }
1359     }
1360   }
1361 
1362 
1363   //payable
1364   function mint( uint quantity, bytes calldata signature ) external payable {
1365     require( quantity <= MAX_ORDER,         "Order too big"             );
1366     require( msg.value >= PRICE * quantity, "Ether sent is not correct" );
1367 
1368     uint256 supply = totalSupply();
1369     require( supply + quantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1370 
1371     if( isMainsaleActive ){
1372       //ok
1373     }
1374     else if( isPresaleActive ){
1375       if( isVerified )
1376         verifySignature( quantity.toString(), signature );
1377     }
1378     else{
1379       revert( "Sale is not active" );
1380     }
1381 
1382     unchecked {
1383       for(uint i; i < quantity; i++){
1384         _mint( msg.sender, supply++ );
1385       }
1386     }
1387   }
1388 
1389   function changeWithdrawalAddress(address newAddress) external onlyOwner {
1390     require(a1 != newAddress, "New value matches old value");
1391     a1 = newAddress;
1392   }
1393 
1394 
1395   //onlyDelegates
1396   function mintTo(uint[] calldata quantity, address[] calldata recipient) external payable onlyDelegates{
1397     require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1398 
1399     uint totalQuantity;
1400     uint supply = totalSupply();
1401     for(uint i; i < quantity.length; i++){
1402       totalQuantity += quantity[i];
1403     }
1404     require( supply + totalQuantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1405 
1406     unchecked {
1407       for(uint i = 0; i < recipient.length; i++){
1408         for(uint j = 0; j < quantity[i]; j++){
1409           _mint( recipient[i], supply++ );
1410         }
1411       }
1412     }
1413   }
1414 
1415   function setActive(bool isFreesaleActive_, bool isPresaleActive_, bool isMainsaleActive_, bool isVerified_) external onlyDelegates{
1416     if( isFreesaleActive != isFreesaleActive_ )
1417       isFreesaleActive = isFreesaleActive_;
1418     
1419     if( isPresaleActive != isPresaleActive_ )
1420       isPresaleActive = isPresaleActive_;
1421 
1422     if( isMainsaleActive != isMainsaleActive_ )
1423       isMainsaleActive = isMainsaleActive_;
1424 
1425     if( isVerified != isVerified_ )
1426       isVerified = isVerified_;
1427   }
1428 
1429   function setBaseURI(string calldata _newBaseURI, string calldata _newSuffix) external onlyDelegates{
1430     _baseTokenURI = _newBaseURI;
1431     _tokenURISuffix = _newSuffix;
1432   }
1433 
1434   function setMax(uint maxClaim, uint maxOrder, uint maxSupply) external onlyDelegates{
1435     require( maxSupply >= totalSupply(), "Specified supply is lower than current balance" );
1436     if( MAX_CLAIM != maxClaim )
1437       MAX_CLAIM = maxClaim;
1438     
1439     if( MAX_ORDER != maxOrder )
1440       MAX_ORDER = maxOrder;
1441 
1442     if( MAX_SUPPLY != maxSupply )
1443       MAX_SUPPLY = maxSupply;
1444   }
1445 
1446   function setPrice(uint price) external onlyDelegates{
1447     if( PRICE != price )
1448       PRICE = price;
1449   }
1450 
1451 
1452   //internal
1453   function _mint(address to, uint256 tokenId) internal override {
1454     _owners.push(to);
1455     emit Transfer(address(0), to, tokenId);
1456   }
1457 }