1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 
6 /**
7  * @title LoFi Originals
8  * @author The Core Devs (@TheCoreDevs)
9  */
10 
11 
12 // File: contracts/Ownable.sol
13 
14 /**
15  * @dev Contract module which provides a basic access control mechanism, where
16  * there is an account (an owner) that can be granted exclusive access to
17  * specific functions.
18  *
19  * By default, the owner account will be the one that deploys the contract. This
20  * can later be changed with {transferOwnership}.
21  *
22  * This module is used through inheritance. It will make available the modifier
23  * `onlyOwner`, which can be applied to your functions to restrict their use to
24  * the owner.
25  *
26  * Source: openzeppelin
27  */
28 abstract contract Ownable {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Initializes the contract setting the deployer as the initial owner.
35      */
36     constructor() {
37         _setOwner(msg.sender);
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(owner() == msg.sender, "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() external virtual onlyOwner {
63         _setOwner(address(0));
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Can only be called by the current owner.
69      */
70     function transferOwnership(address newOwner) external virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         _setOwner(newOwner);
73     }
74 
75     function _setOwner(address newOwner) private {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
80 }
81 
82 // File: Strings.sol
83 
84 /**
85  * Source: Openzeppelin
86  */
87 
88 /**
89  * @dev String operations.
90  */
91 library Strings {
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
95      */
96     function toString(uint256 value) internal pure returns (string memory) {
97         // Inspired by OraclizeAPI's implementation - MIT licence
98         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
99 
100         if (value == 0) {
101             return "0";
102         }
103         uint256 temp = value;
104         uint256 digits;
105         while (temp != 0) {
106             digits++;
107             temp /= 10;
108         }
109         bytes memory buffer = new bytes(digits);
110         while (value != 0) {
111             digits -= 1;
112             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
113             value /= 10;
114         }
115         return string(buffer);
116     }
117 }
118 
119 // File: ECDSA.sol
120 
121 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
122 
123 
124 /**
125  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
126  *
127  * These functions can be used to verify that a message was signed by the holder
128  * of the private keys of a given address.
129  */
130 library ECDSA {
131     enum RecoverError {
132         NoError,
133         InvalidSignature,
134         InvalidSignatureLength,
135         InvalidSignatureS,
136         InvalidSignatureV
137     }
138 
139     function _throwError(RecoverError error) private pure {
140         if (error == RecoverError.NoError) {
141             return; // no error: do nothing
142         } else if (error == RecoverError.InvalidSignature) {
143             revert("ECDSA: invalid signature");
144         } else if (error == RecoverError.InvalidSignatureLength) {
145             revert("ECDSA: invalid signature length");
146         } else if (error == RecoverError.InvalidSignatureS) {
147             revert("ECDSA: invalid signature 's' value");
148         } else if (error == RecoverError.InvalidSignatureV) {
149             revert("ECDSA: invalid signature 'v' value");
150         }
151     }
152 
153     /**
154      * @dev Returns the address that signed a hashed message (`hash`) with
155      * `signature` or error string. This address can then be used for verification purposes.
156      *
157      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
158      * this function rejects them by requiring the `s` value to be in the lower
159      * half order, and the `v` value to be either 27 or 28.
160      *
161      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
162      * verification to be secure: it is possible to craft signatures that
163      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
164      * this is by receiving a hash of the original message (which may otherwise
165      * be too long), and then calling {toEthSignedMessageHash} on it.
166      *
167      * Documentation for signature generation:
168      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
169      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
170      *
171      * _Available since v4.3._
172      */
173     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
174         // Check the signature length
175         // - case 65: r,s,v signature (standard)
176         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
177         if (signature.length == 65) {
178             bytes32 r;
179             bytes32 s;
180             uint8 v;
181             // ecrecover takes the signature parameters, and the only way to get them
182             // currently is to use assembly.
183             assembly {
184                 r := mload(add(signature, 0x20))
185                 s := mload(add(signature, 0x40))
186                 v := byte(0, mload(add(signature, 0x60)))
187             }
188             return tryRecover(hash, v, r, s);
189         } else if (signature.length == 64) {
190             bytes32 r;
191             bytes32 vs;
192             // ecrecover takes the signature parameters, and the only way to get them
193             // currently is to use assembly.
194             assembly {
195                 r := mload(add(signature, 0x20))
196                 vs := mload(add(signature, 0x40))
197             }
198             return tryRecover(hash, r, vs);
199         } else {
200             return (address(0), RecoverError.InvalidSignatureLength);
201         }
202     }
203 
204     /**
205      * @dev Returns the address that signed a hashed message (`hash`) with
206      * `signature`. This address can then be used for verification purposes.
207      *
208      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
209      * this function rejects them by requiring the `s` value to be in the lower
210      * half order, and the `v` value to be either 27 or 28.
211      *
212      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
213      * verification to be secure: it is possible to craft signatures that
214      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
215      * this is by receiving a hash of the original message (which may otherwise
216      * be too long), and then calling {toEthSignedMessageHash} on it.
217      */
218     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
219         (address recovered, RecoverError error) = tryRecover(hash, signature);
220         _throwError(error);
221         return recovered;
222     }
223 
224     /**
225      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
226      *
227      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
228      *
229      * _Available since v4.3._
230      */
231     function tryRecover(
232         bytes32 hash,
233         bytes32 r,
234         bytes32 vs
235     ) internal pure returns (address, RecoverError) {
236         bytes32 s;
237         uint8 v;
238         assembly {
239             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
240             v := add(shr(255, vs), 27)
241         }
242         return tryRecover(hash, v, r, s);
243     }
244 
245     /**
246      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
247      * `r` and `s` signature fields separately.
248      *
249      * _Available since v4.3._
250      */
251     function tryRecover(
252         bytes32 hash,
253         uint8 v,
254         bytes32 r,
255         bytes32 s
256     ) internal pure returns (address, RecoverError) {
257         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
258         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
259         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
260         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
261         //
262         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
263         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
264         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
265         // these malleable signatures as well.
266         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
267             return (address(0), RecoverError.InvalidSignatureS);
268         }
269         if (v != 27 && v != 28) {
270             return (address(0), RecoverError.InvalidSignatureV);
271         }
272 
273         // If the signature is valid (and not malleable), return the signer address
274         address signer = ecrecover(hash, v, r, s);
275         if (signer == address(0)) {
276             return (address(0), RecoverError.InvalidSignature);
277         }
278 
279         return (signer, RecoverError.NoError);
280     }
281 
282     /**
283      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
284      * produces hash corresponding to the one signed with the
285      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
286      * JSON-RPC method as part of EIP-191.
287      *
288      * See {recover}.
289      */
290     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
291         // 32 is the length in bytes of hash,
292         // enforced by the type signature above
293         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
294     }
295 
296 }
297 
298 // File: Address.sol0
299 
300 /**
301  * Source: Openzeppelin
302  */
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         assembly {
332             size := extcodesize(account)
333         }
334         return size > 0;
335     }
336 }
337 
338 // File: IERC721Receiver.sol
339 
340 /**
341  * @title ERC721 token receiver interface
342  * @dev Interface for any contract that wants to support safeTransfers
343  * from ERC721 asset contracts.
344  */
345 interface IERC721Receiver {
346     /**
347      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
348      * by `operator` from `from`, this function is called.
349      *
350      * It must return its Solidity selector to confirm the token transfer.
351      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
352      *
353      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
354      */
355     function onERC721Received(
356         address operator,
357         address from,
358         uint256 tokenId,
359         bytes calldata data
360     ) external returns (bytes4);
361 }
362 
363 // File: IERC165.sol
364 
365 // https://eips.ethereum.org/EIPS/eip-165
366 
367 
368 interface IERC165 {
369     /// @notice Query if a contract implements an interface
370     /// @param interfaceID The interface identifier, as specified in ERC-165
371     /// @dev Interface identification is specified in ERC-165. This function
372     ///  uses less than 30,000 gas.
373     /// @return `true` if the contract implements `interfaceID` and
374     ///  `interfaceID` is not 0xffffffff, `false` otherwise
375     function supportsInterface(bytes4 interfaceID) external view returns (bool);
376 }
377 
378 // File: IERC2981.sol
379 
380 
381 /**
382  * Source: Openzeppelin
383  */
384 
385 
386 /**
387  * @dev Interface for the NFT Royalty Standard
388  */
389 interface IERC2981 is IERC165 {
390     /**
391      * @dev Called with the sale price to determine how much royalty is owed and to whom.
392      * @param tokenId - the NFT asset queried for royalty information
393      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
394      * @return receiver - address of who should be sent the royalty payment
395      * @return royaltyAmount - the royalty payment amount for `salePrice`
396      */
397     function royaltyInfo(uint256 tokenId, uint256 salePrice)
398         external
399         view
400         returns (address receiver, uint256 royaltyAmount);
401 }
402 
403 // File: ERC165.sol
404 
405 
406 /**
407  * Source: Openzeppelin
408  */
409 
410 
411 /**
412  * @dev Implementation of the {IERC165} interface.
413  *
414  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
415  * for the additional interface id that will be supported. For example:
416  *
417  * ```solidity
418  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
420  * }
421  * ```
422  *
423  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
424  */
425 abstract contract ERC165 is IERC165 {
426     /**
427      * @dev See {IERC165-supportsInterface}.
428      */
429     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430         return interfaceId == type(IERC165).interfaceId;
431     }
432 }
433 
434 // File: IERC721.sol
435 
436 // https://eips.ethereum.org/EIPS/eip-721, http://erc721.org/
437 
438 
439 /// @title ERC-721 Non-Fungible Token Standard
440 /// @dev See https://eips.ethereum.org/EIPS/eip-721
441 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
442 interface IERC721 is IERC165 {
443     /// @dev This emits when ownership of any NFT changes by any mechanism.
444     ///  This event emits when NFTs are created (`from` == 0) and destroyed
445     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
446     ///  may be created and assigned without emitting Transfer. At the time of
447     ///  any transfer, the approved address for that NFT (if any) is reset to none.
448     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
449 
450     /// @dev This emits when the approved address for an NFT is changed or
451     ///  reaffirmed. The zero address indicates there is no approved address.
452     ///  When a Transfer event emits, this also indicates that the approved
453     ///  address for that NFT (if any) is reset to none.
454     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
455 
456     /// @dev This emits when an operator is enabled or disabled for an owner.
457     ///  The operator can manage all NFTs of the owner.
458     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
459 
460     /// @notice Count all NFTs assigned to an owner
461     /// @dev NFTs assigned to the zero address are considered invalid, and this
462     ///  function throws for queries about the zero address.
463     /// @param _owner An address for whom to query the balance
464     /// @return The number of NFTs owned by `_owner`, possibly zero
465     function balanceOf(address _owner) external view returns (uint256);
466 
467     /// @notice Find the owner of an NFT
468     /// @dev NFTs assigned to zero address are considered invalid, and queries
469     ///  about them do throw.
470     /// @param _tokenId The identifier for an NFT
471     /// @return The address of the owner of the NFT
472     function ownerOf(uint256 _tokenId) external view returns (address);
473 
474     /// @notice Transfers the ownership of an NFT from one address to another address
475     /// @dev Throws unless `msg.sender` is the current owner, an authorized
476     ///  operator, or the approved address for this NFT. Throws if `_from` is
477     ///  not the current owner. Throws if `_to` is the zero address. Throws if
478     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
479     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
480     ///  `onERC721Received` on `_to` and throws if the return value is not
481     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
482     /// @param _from The current owner of the NFT
483     /// @param _to The new owner
484     /// @param _tokenId The NFT to transfer
485     /// @param data Additional data with no specified format, sent in call to `_to`
486     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external;
487 
488     /// @notice Transfers the ownership of an NFT from one address to another address
489     /// @dev This works identically to the other function with an extra data parameter,
490     ///  except this function just sets data to "".
491     /// @param _from The current owner of the NFT
492     /// @param _to The new owner
493     /// @param _tokenId The NFT to transfer
494     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
495 
496     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
497     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
498     ///  THEY MAY BE PERMANENTLY LOST
499     /// @dev Throws unless `msg.sender` is the current owner, an authorized
500     ///  operator, or the approved address for this NFT. Throws if `_from` is
501     ///  not the current owner. Throws if `_to` is the zero address. Throws if
502     ///  `_tokenId` is not a valid NFT.
503     /// @param _from The current owner of the NFT
504     /// @param _to The new owner
505     /// @param _tokenId The NFT to transfer
506     function transferFrom(address _from, address _to, uint256 _tokenId) external;
507 
508     /// @notice Change or reaffirm the approved address for an NFT
509     /// @dev The zero address indicates there is no approved address.
510     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
511     ///  operator of the current owner.
512     /// @param _approved The new approved NFT controller
513     /// @param _tokenId The NFT to approve
514     function approve(address _approved, uint256 _tokenId) external;
515 
516     /// @notice Enable or disable approval for a third party ("operator") to manage
517     ///  all of `msg.sender`'s assets
518     /// @dev Emits the ApprovalForAll event. The contract MUST allow
519     ///  multiple operators per owner.
520     /// @param _operator Address to add to the set of authorized operators
521     /// @param _approved True if the operator is approved, false to revoke approval
522     function setApprovalForAll(address _operator, bool _approved) external;
523 
524     /// @notice Get the approved address for a single NFT
525     /// @dev Throws if `_tokenId` is not a valid NFT.
526     /// @param _tokenId The NFT to find the approved address for
527     /// @return The approved address for this NFT, or the zero address if there is none
528     function getApproved(uint256 _tokenId) external view returns (address);
529 
530     /// @notice Query if an address is an authorized operator for another address
531     /// @param _owner The address that owns the NFTs
532     /// @param _operator The address that acts on behalf of the owner
533     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
534     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
535 }
536 
537 // File: IERC721Metadata.sol
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Metadata is IERC721 {
545     /**
546      * @dev Returns the token collection name.
547      */
548     function name() external view returns (string memory);
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() external view returns (string memory);
554 
555     /**
556      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
557      */
558     function tokenURI(uint256 tokenId) external view returns (string memory);
559 }
560 
561 // File: ERC721.sol
562 
563 /**
564  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
565  * the Metadata extension
566  * Made for efficiancy!
567  */
568 contract ERC721 is ERC165, IERC721, IERC721Metadata, Ownable {
569     using Address for address;
570     using Strings for uint256;
571 
572     uint16 public totalSupply;
573 
574     address public proxyRegistryAddress;
575 
576     string public baseURI;
577 
578     // Mapping from token ID to owner address
579     mapping(uint256 => address) internal _owners;
580 
581     // Mapping owner address to token count
582     mapping(address => uint256) internal _balances;
583 
584     // Mapping from token ID to approved address
585     mapping(uint256 => address) private _tokenApprovals;
586 
587     // Mapping from owner to operator approvals
588     mapping(address => mapping(address => bool)) private _operatorApprovals;
589 
590 
591     constructor(address _openseaProxyRegistry, string memory _baseURI) {
592         proxyRegistryAddress = _openseaProxyRegistry;
593         baseURI = _baseURI;
594     }
595 
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
600         return
601             interfaceId == type(IERC721).interfaceId ||
602             interfaceId == type(IERC721Metadata).interfaceId ||
603             super.supportsInterface(interfaceId);
604     }
605 
606     /**
607      * @dev See {IERC721-balanceOf}.
608      */
609     function balanceOf(address owner) external view override returns (uint256) {
610         require(owner != address(0), "ERC721: balance query for the zero address");
611         return _balances[owner];
612     }
613 
614     /**
615      * @dev See {IERC721-ownerOf}.
616      */
617     function ownerOf(uint256 tokenId) public view override returns (address) {
618         address owner = _owners[tokenId];
619         require(owner != address(0), "ERC721: owner query for nonexistent token");
620         return owner;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-name}.
625      */
626     function name() external pure override returns (string memory) {
627         return "Lofi Originals";
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-symbol}.
632      */
633     function symbol() external pure override returns (string memory) {
634         return "LO";
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-tokenURI}.
639      */
640     function tokenURI(uint256 tokenId) external view override returns (string memory) {
641         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
642 
643         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
644     }
645 
646     function setBaseURI(string memory uri) external onlyOwner {
647         baseURI = uri;
648     }
649 
650     /**
651      * @dev See {IERC721-approve}.
652      */
653     function approve(address to, uint256 tokenId) external override {
654         address owner = _owners[tokenId];
655         require(to != owner, "ERC721: approval to current owner");
656 
657         require(
658             msg.sender == owner || isApprovedForAll(owner, msg.sender),
659             "ERC721: approve caller is not owner nor approved for all"
660         );
661 
662         _approve(to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-getApproved}.
667      */
668     function getApproved(uint256 tokenId) public view override returns (address) {
669         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
670 
671         return _tokenApprovals[tokenId];
672     }
673 
674     /**
675      * @dev See {IERC721-setApprovalForAll}.
676      */
677     function setApprovalForAll(address operator, bool approved) external override {
678         _setApprovalForAll(msg.sender, operator, approved);
679     }
680 
681     /**
682      * @dev See {IERC721-isApprovedForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
685         // Whitelist OpenSea proxy contract for easy trading.
686         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
687         if (address(proxyRegistry.proxies(owner)) == operator) {
688             return true;
689         }
690 
691         return _operatorApprovals[owner][operator];
692     }
693 
694     function setOpenseaProxyRegistry(address addr) external onlyOwner {
695         proxyRegistryAddress = addr;
696     }
697 
698     /**
699      * @dev See {IERC721-transferFrom}.
700      */
701     function transferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) external override {
706         //solhint-disable-next-line max-line-length
707         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
708 
709         _transfer(from, to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-safeTransferFrom}.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) external override {
720         safeTransferFrom(from, to, tokenId, "");
721     }
722 
723     /**
724      * @dev See {IERC721-safeTransferFrom}.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) public override {
732         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
733         _safeTransfer(from, to, tokenId, _data);
734     }
735 
736     /**
737      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
738      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
739      *
740      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
741      *
742      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
743      * implement alternative mechanisms to perform token transfer, such as signature-based.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function _safeTransfer(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) internal virtual {
760         _transfer(from, to, tokenId);
761         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
762     }
763 
764     /**
765      * @dev Returns whether `tokenId` exists.
766      *
767      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
768      *
769      * Tokens start existing when they are minted
770      */
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return _owners[tokenId] != address(0);
773     }
774 
775     /**
776      * @dev Returns whether `spender` is allowed to manage `tokenId`.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
783         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
784         address owner = _owners[tokenId];
785         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
786     }
787 
788     /**
789      * @dev Mints `tokenId` and transfers it to `to`.
790      *
791      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
792      *
793      * Requirements:
794      *
795      * - `tokenId` must not exist.
796      * - `to` cannot be the zero address.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _mint(uint256 amount, address to, uint tokenId) internal {
801 
802         _balances[to] += amount;
803 
804         for (uint i; i < amount; i++) {
805             tokenId++;
806 
807             _owners[tokenId] = to;
808             emit Transfer(address(0), to, tokenId);
809         }
810 
811         totalSupply += uint16(amount);
812 
813         require(
814             _checkOnERC721Received(address(0), to, tokenId, ""),
815             "ERC721: transfer to non ERC721Receiver implementer"
816         ); // checking it once will make sure that the address can recieve NFTs
817     }
818 
819     function _mint(address to, uint tokenId) internal {
820 
821         _balances[to]++;
822         _owners[tokenId] = to;
823         emit Transfer(address(0), to, tokenId);
824 
825         totalSupply++;
826         
827         require(
828             _checkOnERC721Received(address(0), to, tokenId, ""),
829             "ERC721: transfer to non ERC721Receiver implementer"
830         );
831     }
832 
833     /**
834      * @dev Transfers `tokenId` from `from` to `to`.
835      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
836      *
837      * Requirements:
838      *
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must be owned by `from`.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _transfer(
845         address from,
846         address to,
847         uint256 tokenId
848     ) internal virtual {
849         require(_owners[tokenId] == from, "ERC721: transfer from incorrect owner");
850         require(to != address(0), "ERC721: transfer to the zero address");
851 
852         // Clear approvals from the previous owner
853         _approve(address(0), tokenId);
854 
855         _balances[from]--;
856         _balances[to]++;
857 
858         _owners[tokenId] = to;
859 
860         emit Transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev Approve `to` to operate on `tokenId`
865      *
866      * Emits a {Approval} event.
867      */
868     function _approve(address to, uint256 tokenId) internal virtual {
869         _tokenApprovals[tokenId] = to;
870         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
871     }
872 
873     /**
874      * @dev Approve `operator` to operate on all of `owner` tokens
875      *
876      * Emits a {ApprovalForAll} event.
877      */
878     function _setApprovalForAll(
879         address owner,
880         address operator,
881         bool approved
882     ) internal virtual {
883         require(owner != operator, "ERC721: approve to caller");
884         _operatorApprovals[owner][operator] = approved;
885         emit ApprovalForAll(owner, operator, approved);
886     }
887 
888     /**
889      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
890      * The call is not executed if the target address is not a contract.
891      *
892      * @param from address representing the previous owner of the given token ID
893      * @param to target address that will receive the tokens
894      * @param tokenId uint256 ID of the token to be transferred
895      * @param _data bytes optional data to send along with the call
896      * @return bool whether the call correctly returned the expected magic value
897      */
898     function _checkOnERC721Received(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) internal returns (bool) {
904         if (to.isContract()) {
905             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
906                 return retval == IERC721Receiver.onERC721Received.selector;
907             } catch (bytes memory reason) {
908                 if (reason.length == 0) {
909                     revert("ERC721: transfer to non ERC721Receiver implementer");
910                 } else {
911                     assembly {
912                         revert(add(32, reason), mload(reason))
913                     }
914                 }
915             }
916         } else {
917             return true;
918         }
919     }
920 
921 }
922 
923 contract OwnableDelegateProxy {}
924 
925 contract ProxyRegistry {
926     mapping(address => OwnableDelegateProxy) public proxies;
927 }
928 
929 
930 // File: LO.sol
931 
932 
933 contract LO is Ownable, IERC2981, ERC721 {
934 
935     bool private _onlyWhiteList;
936     bool private _mintingEnabled;
937 
938     uint private EIP2981RoyaltyPercent;
939 
940     mapping (address => uint8) public amountPreMinted;
941     mapping (address => uint8) public amountMinted;
942 
943     constructor(
944         uint _royalty,
945         address _openseaProxyRegistry,
946         string memory _tempBaseURI
947     ) ERC721(_openseaProxyRegistry, _tempBaseURI) {
948         EIP2981RoyaltyPercent = _royalty;
949     }
950 
951     function mintFromReserve(uint amount, address to) external onlyOwner {
952         uint tokenId = totalSupply;
953         require(amount + tokenId < 5556);
954         _mint(amount, to, tokenId);
955     }
956 
957     function batchMintFromReserve(uint[] memory amount, address[] memory to) external onlyOwner {
958         uint length = amount.length;
959         require(length == to.length, "array length missmatch");
960 
961         uint tokenId = totalSupply;
962         uint total;
963 
964         uint cAmount;
965         address cTo;
966 
967         for (uint i; i < length; i++) {
968 
969             assembly {
970                 cAmount := mload(add(add(amount, 0x20), mul(i, 0x20)))
971                 cTo := mload(add(add(to, 0x20), mul(i, 0x20)))
972             }
973 
974             require(!Address.isContract(cTo), "Cannot mint to contracts!");
975 
976             _balances[cTo] += cAmount;
977 
978             for (uint f; f < cAmount; f++) {
979                 tokenId++;
980 
981                 _owners[tokenId] = cTo;
982                 emit Transfer(address(0), cTo, tokenId);
983             }
984 
985             total += cAmount;
986         }
987 
988         require(tokenId < 5556, "Exceeds reserve!");
989 
990         totalSupply += uint16(total);
991     }
992 
993     function mint(uint256 amount) external payable {
994         require(_mintingEnabled, "Minting is not enabled!");
995         uint tokenId = totalSupply;
996         require(amount + tokenId < 5556, "Request exceeds max supply!");
997         require(amount + amountMinted[msg.sender] < 3 && amount != 0, "Request exceeds max per wallet!");
998         require(msg.value == amount * 9e16, "ETH Amount is not correct!");
999 
1000         amountMinted[msg.sender] += uint8(amount);
1001         _mint(amount, msg.sender, tokenId);
1002     }
1003 
1004     function famMint(bytes calldata sig) external payable {
1005         require(_onlyWhiteList, "Minting is not enabled!");
1006         require(_checkFamSig(msg.sender, sig), "User not whitelisted!");
1007         uint tokenId = totalSupply + 1;
1008         require(tokenId < 5556, "Request exceeds max supply!");
1009         require(amountPreMinted[msg.sender] == 0, "Request exceeds max per wallet!");
1010         require(msg.value == 9e16, "ETH Amount is not correct!");
1011 
1012         amountPreMinted[msg.sender]++;
1013         _mint(msg.sender, tokenId);
1014     }
1015 
1016     function ogMint(bytes calldata sig, uint256 amount) external payable {
1017         require(_onlyWhiteList, "Minting is not enabled!");
1018         require(_checkOgSig(msg.sender, sig), "User not whitelisted!");
1019         uint tokenId = totalSupply;
1020         require(amount + tokenId < 5556, "Request exceeds max supply!");
1021         require(amount + amountPreMinted[msg.sender] < 3 && amount != 0, "Request exceeds max per wallet!");
1022         require(msg.value == amount * 9e16, "ETH Amount is not correct!");
1023 
1024         amountPreMinted[msg.sender] += uint8(amount);
1025         _mint(amount, msg.sender, tokenId);
1026     }
1027 
1028     function _checkOgSig(address _wallet, bytes memory _signature) private view returns(bool) {
1029         return ECDSA.recover(
1030             ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_wallet, "OG"))),
1031             _signature
1032         ) == owner();
1033     }
1034 
1035     function _checkFamSig(address _wallet, bytes memory _signature) private view returns(bool) {
1036         return ECDSA.recover(
1037             ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_wallet, "FAM"))),
1038             _signature
1039         ) == owner();
1040     }
1041 
1042     function getOgMsg(address _wallet) external pure returns(bytes32) {
1043         return keccak256(abi.encodePacked(_wallet, "OG"));
1044     }
1045 
1046     function getFamMsg(address _wallet) external pure returns(bytes32) {
1047         return keccak256(abi.encodePacked(_wallet, "FAM"));
1048     }
1049 
1050     function getSalesStatus() external view returns(bool onlyWhitelist, bool mintingEnabled) {
1051         onlyWhitelist = _onlyWhiteList;
1052         mintingEnabled = _mintingEnabled;
1053     }
1054 
1055     /**
1056      * @notice returns royalty info for EIP2981 supporting marketplaces
1057      * @dev Called with the sale price to determine how much royalty is owed and to whom.
1058      * @param tokenId - the NFT asset queried for royalty information
1059      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
1060      * @return receiver - address of who should be sent the royalty payment
1061      * @return royaltyAmount - the royalty payment amount for `salePrice`
1062      */
1063     function royaltyInfo(uint tokenId, uint salePrice) external view override returns(address receiver, uint256 royaltyAmount) {
1064         require(_exists(tokenId), "Royality querry for non-existant token!");
1065         return(owner(), salePrice * EIP2981RoyaltyPercent / 10000);
1066     }
1067 
1068     /**
1069      * @notice sets the royalty percentage for EIP2981 supporting marketplaces
1070      * @dev percentage is in bassis points (parts per 10,000).
1071             Example: 5% = 500, 0.5% = 50
1072      * @param amount - percent amount
1073      */
1074     function setRoyaltyPercent(uint256 amount) external onlyOwner {
1075         EIP2981RoyaltyPercent = amount;
1076     }
1077 
1078     /**
1079      * @dev See {IERC165-supportsInterface}.
1080      */
1081     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1082         return
1083             interfaceId == type(IERC2981).interfaceId ||
1084             super.supportsInterface(interfaceId);
1085     }
1086 
1087     function withdraw() onlyOwner external {
1088         uint bal = address(this).balance;
1089         bool success;
1090         (success, ) = payable(msg.sender).call{value: (bal * 92) / 100, gas: 3000}("");
1091         require(success, "Transfer to contract owner failed!");
1092         (success, ) = payable(0xFab795b3e736C4323103a3ADAa901cc5a43646fE).call{value: ((bal * 8) / 100), gas: 3000}("");
1093         require(success, "Transfer to core devs failed!");
1094         
1095     }
1096 
1097     /**
1098      * @notice toggles pre sale
1099      * @dev enables the pre sale functions. NEVER USE THIS AFTER ENABLING THE PUBLIC SALE FUNCTIONS UNLESS ITS NECESSARY
1100      */
1101     function togglePresale() external onlyOwner {
1102         _onlyWhiteList = !_onlyWhiteList;
1103     }
1104 
1105     /**
1106      * @notice toggles the public sale
1107      * @dev enables/disables public sale functions and disables pre sale functions
1108      */
1109     function togglePublicSale() external onlyOwner {
1110         _onlyWhiteList = false;
1111         _mintingEnabled = !_mintingEnabled;
1112     }
1113 
1114     function tokensOfOwner(address owner) external view returns(uint[] memory) {
1115         uint[] memory tokens = new uint[](_balances[owner]);
1116         uint y = totalSupply + 1;
1117         uint x;
1118 
1119         for (uint i = 1; i < y; i++) {
1120             if (ownerOf(i) == owner) {
1121                 tokens[x] = i;
1122                 x++;
1123             }
1124         }
1125 
1126         return tokens;
1127     }
1128 }