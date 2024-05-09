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
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
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
191         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
192         uint8 v = uint8((uint256(vs) >> 255) + 27);
193         return tryRecover(hash, v, r, s);
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
198      *
199      * _Available since v4.2._
200      */
201     function recover(
202         bytes32 hash,
203         bytes32 r,
204         bytes32 vs
205     ) internal pure returns (address) {
206         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
207         _throwError(error);
208         return recovered;
209     }
210 
211     /**
212      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
213      * `r` and `s` signature fields separately.
214      *
215      * _Available since v4.3._
216      */
217     function tryRecover(
218         bytes32 hash,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) internal pure returns (address, RecoverError) {
223         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
224         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
225         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
226         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
227         //
228         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
229         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
230         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
231         // these malleable signatures as well.
232         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
233             return (address(0), RecoverError.InvalidSignatureS);
234         }
235         if (v != 27 && v != 28) {
236             return (address(0), RecoverError.InvalidSignatureV);
237         }
238 
239         // If the signature is valid (and not malleable), return the signer address
240         address signer = ecrecover(hash, v, r, s);
241         if (signer == address(0)) {
242             return (address(0), RecoverError.InvalidSignature);
243         }
244 
245         return (signer, RecoverError.NoError);
246     }
247 
248     /**
249      * @dev Overload of {ECDSA-recover} that receives the `v`,
250      * `r` and `s` signature fields separately.
251      */
252     function recover(
253         bytes32 hash,
254         uint8 v,
255         bytes32 r,
256         bytes32 s
257     ) internal pure returns (address) {
258         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
259         _throwError(error);
260         return recovered;
261     }
262 
263     /**
264      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
265      * produces hash corresponding to the one signed with the
266      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
267      * JSON-RPC method as part of EIP-191.
268      *
269      * See {recover}.
270      */
271     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
272         // 32 is the length in bytes of hash,
273         // enforced by the type signature above
274         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
275     }
276 
277     /**
278      * @dev Returns an Ethereum Signed Message, created from `s`. This
279      * produces hash corresponding to the one signed with the
280      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
281      * JSON-RPC method as part of EIP-191.
282      *
283      * See {recover}.
284      */
285     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
286         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
287     }
288 
289     /**
290      * @dev Returns an Ethereum Signed Typed Data, created from a
291      * `domainSeparator` and a `structHash`. This produces hash corresponding
292      * to the one signed with the
293      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
294      * JSON-RPC method as part of EIP-712.
295      *
296      * See {recover}.
297      */
298     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
299         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
313  *
314  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
315  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
316  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
317  *
318  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
319  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
320  * ({_hashTypedDataV4}).
321  *
322  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
323  * the chain id to protect against replay attacks on an eventual fork of the chain.
324  *
325  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
326  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
327  *
328  * _Available since v3.4._
329  */
330 abstract contract EIP712 {
331     /* solhint-disable var-name-mixedcase */
332     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
333     // invalidate the cached domain separator if the chain id changes.
334     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
335     uint256 private immutable _CACHED_CHAIN_ID;
336     address private immutable _CACHED_THIS;
337 
338     bytes32 private immutable _HASHED_NAME;
339     bytes32 private immutable _HASHED_VERSION;
340     bytes32 private immutable _TYPE_HASH;
341 
342     /* solhint-enable var-name-mixedcase */
343 
344     /**
345      * @dev Initializes the domain separator and parameter caches.
346      *
347      * The meaning of `name` and `version` is specified in
348      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
349      *
350      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
351      * - `version`: the current major version of the signing domain.
352      *
353      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
354      * contract upgrade].
355      */
356     constructor(string memory name, string memory version) {
357         bytes32 hashedName = keccak256(bytes(name));
358         bytes32 hashedVersion = keccak256(bytes(version));
359         bytes32 typeHash = keccak256(
360             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
361         );
362         _HASHED_NAME = hashedName;
363         _HASHED_VERSION = hashedVersion;
364         _CACHED_CHAIN_ID = block.chainid;
365         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
366         _CACHED_THIS = address(this);
367         _TYPE_HASH = typeHash;
368     }
369 
370     /**
371      * @dev Returns the domain separator for the current chain.
372      */
373     function _domainSeparatorV4() internal view returns (bytes32) {
374         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
375             return _CACHED_DOMAIN_SEPARATOR;
376         } else {
377             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
378         }
379     }
380 
381     function _buildDomainSeparator(
382         bytes32 typeHash,
383         bytes32 nameHash,
384         bytes32 versionHash
385     ) private view returns (bytes32) {
386         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
387     }
388 
389     /**
390      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
391      * function returns the hash of the fully encoded EIP712 message for this domain.
392      *
393      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
394      *
395      * ```solidity
396      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
397      *     keccak256("Mail(address to,string contents)"),
398      *     mailTo,
399      *     keccak256(bytes(mailContents))
400      * )));
401      * address signer = ECDSA.recover(digest, signature);
402      * ```
403      */
404     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
405         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
406     }
407 }
408 
409 // File: whitelist.sol
410 
411 pragma solidity ^0.8.0;
412 
413 
414 contract whitelistChecker is EIP712{
415 
416     string private constant SIGNING_DOMAIN = "Godjira";
417     string private constant SIGNATURE_VERSION = "1";
418 
419     struct whitelisted{
420         address whiteListAddress;
421         bool isPrivateListed;
422         bytes signature;
423     }
424 
425     constructor() EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION){}
426   
427   
428     function getSigner(whitelisted memory list) internal view returns(address){
429         return _verify(list);
430     }
431 
432     
433     /// @notice Returns a hash of the given rarity, prepared using EIP712 typed data hashing rules.
434   
435     function _hash(whitelisted memory list) internal view returns (bytes32) {
436         return _hashTypedDataV4(
437             keccak256(
438                 abi.encode(
439                     keccak256("whitelisted(address whiteListAddress,bool isPrivateListed)"),
440                     list.whiteListAddress,
441                     list.isPrivateListed
442                 )
443             )
444         );
445     }
446 
447     function _verify(whitelisted memory list) internal view returns (address) {
448         bytes32 digest = _hash(list);
449         return ECDSA.recover(digest, list.signature);
450     }
451 
452     function getChainID() external view returns (uint256) {
453         uint256 id;
454         assembly {
455             id := chainid()
456         }
457         return id;
458     }
459 }
460 // File: @openzeppelin/contracts/utils/Context.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Provides information about the current execution context, including the
469  * sender of the transaction and its data. While these are generally available
470  * via msg.sender and msg.data, they should not be accessed in such a direct
471  * manner, since when dealing with meta-transactions the account sending and
472  * paying for execution may not be the actual sender (as far as an application
473  * is concerned).
474  *
475  * This contract is only required for intermediate, library-like contracts.
476  */
477 abstract contract Context {
478     function _msgSender() internal view virtual returns (address) {
479         return msg.sender;
480     }
481 
482     function _msgData() internal view virtual returns (bytes calldata) {
483         return msg.data;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/access/Ownable.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Contract module which provides a basic access control mechanism, where
497  * there is an account (an owner) that can be granted exclusive access to
498  * specific functions.
499  *
500  * By default, the owner account will be the one that deploys the contract. This
501  * can later be changed with {transferOwnership}.
502  *
503  * This module is used through inheritance. It will make available the modifier
504  * `onlyOwner`, which can be applied to your functions to restrict their use to
505  * the owner.
506  */
507 abstract contract Ownable is Context {
508     address private _owner;
509 
510     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
511 
512     /**
513      * @dev Initializes the contract setting the deployer as the initial owner.
514      */
515     constructor() {
516         _transferOwnership(_msgSender());
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view virtual returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         require(owner() == _msgSender(), "Ownable: caller is not the owner");
531         _;
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         _transferOwnership(address(0));
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         _transferOwnership(newOwner);
552     }
553 
554     /**
555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
556      * Internal function without access restriction.
557      */
558     function _transferOwnership(address newOwner) internal virtual {
559         address oldOwner = _owner;
560         _owner = newOwner;
561         emit OwnershipTransferred(oldOwner, newOwner);
562     }
563 }
564 
565 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Interface of the ERC165 standard, as defined in the
574  * https://eips.ethereum.org/EIPS/eip-165[EIP].
575  *
576  * Implementers can declare support of contract interfaces, which can then be
577  * queried by others ({ERC165Checker}).
578  *
579  * For an implementation, see {ERC165}.
580  */
581 interface IERC165 {
582     /**
583      * @dev Returns true if this contract implements the interface defined by
584      * `interfaceId`. See the corresponding
585      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
586      * to learn more about how these ids are created.
587      *
588      * This function call must use less than 30 000 gas.
589      */
590     function supportsInterface(bytes4 interfaceId) external view returns (bool);
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Required interface of an ERC721 compliant contract.
603  */
604 interface IERC721 is IERC165 {
605     /**
606      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
607      */
608     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
609 
610     /**
611      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
612      */
613     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
614 
615     /**
616      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
617      */
618     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
619 
620     /**
621      * @dev Returns the number of tokens in ``owner``'s account.
622      */
623     function balanceOf(address owner) external view returns (uint256 balance);
624 
625     /**
626      * @dev Returns the owner of the `tokenId` token.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      */
632     function ownerOf(uint256 tokenId) external view returns (address owner);
633 
634     /**
635      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
636      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Transfers `tokenId` token from `from` to `to`.
656      *
657      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
676      * The approval is cleared when the token is transferred.
677      *
678      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
679      *
680      * Requirements:
681      *
682      * - The caller must own the token or be an approved operator.
683      * - `tokenId` must exist.
684      *
685      * Emits an {Approval} event.
686      */
687     function approve(address to, uint256 tokenId) external;
688 
689     /**
690      * @dev Returns the account approved for `tokenId` token.
691      *
692      * Requirements:
693      *
694      * - `tokenId` must exist.
695      */
696     function getApproved(uint256 tokenId) external view returns (address operator);
697 
698     /**
699      * @dev Approve or remove `operator` as an operator for the caller.
700      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
701      *
702      * Requirements:
703      *
704      * - The `operator` cannot be the caller.
705      *
706      * Emits an {ApprovalForAll} event.
707      */
708     function setApprovalForAll(address operator, bool _approved) external;
709 
710     /**
711      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
712      *
713      * See {setApprovalForAll}
714      */
715     function isApprovedForAll(address owner, address operator) external view returns (bool);
716 
717     /**
718      * @dev Safely transfers `tokenId` token from `from` to `to`.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
726      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
727      *
728      * Emits a {Transfer} event.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes calldata data
735     ) external;
736 }
737 
738 // File: Gen2Sales.sol
739 
740 //SPDX-License-Identifier: UNLICENSED
741 
742 pragma solidity ^0.8.0;
743 
744 
745 
746 
747 contract Gen2Sales is Ownable, whitelistChecker {
748 
749     IERC721 Godjira2;
750     IERC721 Godjira1;
751     address CORE_TEAM_ADDRESS = 0xC79b099E83f6ECc8242f93d35782562b42c459F3; 
752     address designatedSigner = 0x2141fc90F4d8114e8778447d7c19b5992F6A0611; 
753 
754     uint PRICE = 0.099 ether;
755 
756     //TIMES 
757     uint public PRIVATE_TIME = 1646787600;
758     uint public HOLDERS_TIME = 1646794800;
759     uint public WHITELIST_TIME = 1646881200;
760     uint public CLAIM_TIME = 1646967600;
761 
762     //TOKEN TRACKERS
763     uint16 public privateSaleTracker = 340; //340-439
764     uint16 public genesisSaleTracker = 440; //440-1105
765     uint16 public whitelistSaleTracker = 1106; //1106-2852
766     uint16 public claimTracker = 2853; //2853-3332
767 
768     //SALE MAPPINGS
769     mapping(address=>bool) public privateBought; //privatelisted > has bought
770     mapping(uint=>bool) public genesisBought; //genesis token > has bought
771     mapping(address=>bool) public whitelistBought; //whitelisted > has bought
772 
773     //CLAIM MAPPINGS
774     mapping(uint=>bool) public genesisClaimed; //genesis token > has claimed
775     mapping(uint=>bool) public gen2Claimed; //gen 2 token > has claimed
776 
777     bool public isPaused;
778 
779     constructor(address _godjira2, address _godjira1) {
780         Godjira2 = IERC721(_godjira2);
781         Godjira1 = IERC721(_godjira1);
782     }
783 
784     modifier isNotPaused{
785         require(!isPaused,"Execution paused");
786         _;
787     }
788     //Region 1 - Sales
789 
790     function privateSale(whitelisted memory whitelist) external payable isNotPaused {
791         require(getSigner(whitelist) == designatedSigner, "Invalid signature");
792         require(msg.sender == whitelist.whiteListAddress, "not same user");
793         require(whitelist.isPrivateListed, "is not private listed");
794         require(!privateBought[msg.sender], "Already bought");
795         require(block.timestamp > PRIVATE_TIME, "Sale not started");
796         require(msg.value >= PRICE, "Paying too low");
797 
798         privateBought[msg.sender] = true;
799         Godjira2.safeTransferFrom(CORE_TEAM_ADDRESS, msg.sender, privateSaleTracker);
800         privateSaleTracker++;
801     }
802 
803     function whitelistSale(whitelisted memory whitelist) external payable isNotPaused{
804         require(getSigner(whitelist) == designatedSigner,"Invalid signature");
805         require(msg.sender == whitelist.whiteListAddress,"not same user");
806         require(!whitelist.isPrivateListed,"is private listed");
807         require(!whitelistBought[msg.sender],"Already bought");
808         require(block.timestamp > WHITELIST_TIME && block.timestamp < WHITELIST_TIME + 1 days,"Sale not started or has ended");
809         require(msg.value >= PRICE,"Paying too low");
810 
811         whitelistBought[msg.sender] = true;
812         Godjira2.safeTransferFrom(CORE_TEAM_ADDRESS,msg.sender,whitelistSaleTracker);
813         whitelistSaleTracker++;
814     }
815 
816 
817     function genesisSale(uint[] memory tokenId) external payable isNotPaused{
818         require(block.timestamp > HOLDERS_TIME,"Sale not started");
819         require(msg.value >= 2*PRICE*tokenId.length,"Paying too low");
820         for(uint i=0;i<tokenId.length;i++){
821             require(Godjira1.ownerOf(tokenId[i]) == msg.sender,"Sender not owner");
822             require(!genesisBought[tokenId[i]],"Already bought");
823 
824             genesisBought[tokenId[i]] = true;
825             Godjira2.safeTransferFrom(CORE_TEAM_ADDRESS,msg.sender,genesisSaleTracker);
826             Godjira2.safeTransferFrom(CORE_TEAM_ADDRESS,msg.sender,genesisSaleTracker+1);
827             genesisSaleTracker += 2;
828         }
829     }
830 
831     // Region 2 - Claims
832 
833     function genesisClaim(uint[] memory tokenId) external isNotPaused{
834         require(block.timestamp > CLAIM_TIME,"Claims not started");
835         for(uint i=0;i<tokenId.length;i++){
836             require(Godjira1.ownerOf(tokenId[i])==msg.sender,"Sender not owner");
837             require(!genesisClaimed[tokenId[i]],"Already claimed");
838 
839             genesisClaimed[tokenId[i]] = true;
840             Godjira2.safeTransferFrom(CORE_TEAM_ADDRESS,msg.sender,claimTracker);
841             claimTracker++;
842         }
843     }
844 
845     function privateSalesClaim(uint[] memory tokenId) external isNotPaused{
846         require(block.timestamp > CLAIM_TIME,"Claims not started");
847         for(uint i=0;i<tokenId.length;i++){
848             require(tokenId[i] >= 340 && tokenId[i] <= 439,"not valid token");
849             require(Godjira2.ownerOf(tokenId[i])==msg.sender,"Sender not owner");
850             require(!gen2Claimed[tokenId[i]],"Already claimed");
851             gen2Claimed[tokenId[i]] = true;
852             Godjira2.safeTransferFrom(CORE_TEAM_ADDRESS,msg.sender,claimTracker);
853             claimTracker++;
854         }
855     }
856 
857     function withdraw() external onlyOwner{
858         payable(msg.sender).transfer(address(this).balance);
859     }
860 
861     function pauseContract(bool _paused) external onlyOwner{
862         isPaused = _paused;
863     }
864 
865     function modifyGodjira2(address _godjira) external onlyOwner{
866         Godjira2 = IERC721(_godjira);
867     }
868 
869     function modifyGodjira1(address _godjira) external onlyOwner {
870         Godjira1 = IERC721(_godjira);
871     }
872 
873     function modifySigner(address _signer) external onlyOwner {
874         designatedSigner = _signer;
875     }
876 
877     function modifyCoreTeamAddress(address _core) external onlyOwner {
878         CORE_TEAM_ADDRESS = _core;
879     }
880 
881     function modifyPrice(uint _price) external onlyOwner {
882         PRICE = _price;
883     }
884 
885     function modifyPrivateTime(uint _time) external onlyOwner {
886         PRIVATE_TIME = _time;
887     }
888 
889     function modifyWhitelistTime(uint _time) external onlyOwner {
890         WHITELIST_TIME = _time;
891     }
892 
893     function modifyHolderTime(uint _time) external onlyOwner {
894         HOLDERS_TIME = _time;
895     }
896 
897     function modifyClaimTime(uint _time) external onlyOwner {
898         CLAIM_TIME = _time;
899     }
900 
901 }