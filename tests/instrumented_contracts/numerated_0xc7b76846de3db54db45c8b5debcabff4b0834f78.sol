1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 
6 // File: contracts/Ownable.sol
7 
8 /**
9  * @dev Contract module which provides a basic access control mechanism, where
10  * there is an account (an owner) that can be granted exclusive access to
11  * specific functions.
12  *
13  * By default, the owner account will be the one that deploys the contract. This
14  * can later be changed with {transferOwnership}.
15  *
16  * This module is used through inheritance. It will make available the modifier
17  * `onlyOwner`, which can be applied to your functions to restrict their use to
18  * the owner.
19  *
20  * Source: openzeppelin
21  */
22 abstract contract Ownable {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() {
31         _setOwner(msg.sender);
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(owner() == msg.sender, "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() external virtual onlyOwner {
57         _setOwner(address(0));
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) external virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         _setOwner(newOwner);
67     }
68 
69     function _setOwner(address newOwner) private {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 // File: Strings.sol
77 
78 /**
79  * Source: Openzeppelin
80  */
81 
82 /**
83  * @dev String operations.
84  */
85 library Strings {
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
89      */
90     function toString(uint256 value) internal pure returns (string memory) {
91         // Inspired by OraclizeAPI's implementation - MIT licence
92         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
93 
94         if (value == 0) {
95             return "0";
96         }
97         uint256 temp = value;
98         uint256 digits;
99         while (temp != 0) {
100             digits++;
101             temp /= 10;
102         }
103         bytes memory buffer = new bytes(digits);
104         while (value != 0) {
105             digits -= 1;
106             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
107             value /= 10;
108         }
109         return string(buffer);
110     }
111 }
112 
113 // File: ECDSA.sol
114 
115 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
116 
117 
118 /**
119  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
120  *
121  * These functions can be used to verify that a message was signed by the holder
122  * of the private keys of a given address.
123  */
124 library ECDSA {
125 
126     /**
127      * @dev Returns the address that signed a hashed message (`hash`) with
128      * `signature` or error string. This address can then be used for verification purposes.
129      *
130      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
131      * this function rejects them by requiring the `s` value to be in the lower
132      * half order, and the `v` value to be either 27 or 28.
133      *
134      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
135      * verification to be secure: it is possible to craft signatures that
136      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
137      * this is by receiving a hash of the original message (which may otherwise
138      * be too long), and then calling {toEthSignedMessageHash} on it.
139      *
140      * Documentation for signature generation:
141      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
142      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
143      *
144      * _Available since v4.3._
145      */
146     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address) {
147         // Check the signature length
148         // - case 65: r,s,v signature (standard)
149         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
150         if (signature.length == 65) {
151             bytes32 r;
152             bytes32 s;
153             uint8 v;
154             // ecrecover takes the signature parameters, and the only way to get them
155             // currently is to use assembly.
156             assembly {
157                 r := mload(add(signature, 0x20))
158                 s := mload(add(signature, 0x40))
159                 v := byte(0, mload(add(signature, 0x60)))
160             }
161             return tryRecover(hash, v, r, s);
162         } else if (signature.length == 64) {
163             bytes32 r;
164             bytes32 vs;
165             // ecrecover takes the signature parameters, and the only way to get them
166             // currently is to use assembly.
167             assembly {
168                 r := mload(add(signature, 0x20))
169                 vs := mload(add(signature, 0x40))
170             }
171             return tryRecover(hash, r, vs);
172         } else {
173             return (address(0));
174         }
175     }
176 
177     /**
178      * @dev Returns the address that signed a hashed message (`hash`) with
179      * `signature`. This address can then be used for verification purposes.
180      *
181      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
182      * this function rejects them by requiring the `s` value to be in the lower
183      * half order, and the `v` value to be either 27 or 28.
184      *
185      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
186      * verification to be secure: it is possible to craft signatures that
187      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
188      * this is by receiving a hash of the original message (which may otherwise
189      * be too long), and then calling {toEthSignedMessageHash} on it.
190      */
191     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
192         (address recovered) = tryRecover(hash, signature);
193         return recovered;
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
198      *
199      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
200      *
201      * _Available since v4.3._
202      */
203     function tryRecover(
204         bytes32 hash,
205         bytes32 r,
206         bytes32 vs
207     ) internal pure returns (address) {
208         bytes32 s;
209         uint8 v;
210         assembly {
211             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
212             v := add(shr(255, vs), 27)
213         }
214         return tryRecover(hash, v, r, s);
215     }
216 
217     /**
218      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
219      * `r` and `s` signature fields separately.
220      *
221      * _Available since v4.3._
222      */
223     function tryRecover(
224         bytes32 hash,
225         uint8 v,
226         bytes32 r,
227         bytes32 s
228     ) internal pure returns (address) {
229         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
230         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
231         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
232         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
233         //
234         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
235         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
236         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
237         // these malleable signatures as well.
238         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
239             return (address(0));
240         }
241         if (v != 27 && v != 28) {
242             return (address(0));
243         }
244 
245         // If the signature is valid (and not malleable), return the signer address
246         address signer = ecrecover(hash, v, r, s);
247         if (signer == address(0)) {
248             return (address(0));
249         }
250 
251         return (signer);
252     }
253 
254     /**
255      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
256      * produces hash corresponding to the one signed with the
257      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
258      * JSON-RPC method as part of EIP-191.
259      *
260      * See {recover}.
261      */
262     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
263         // 32 is the length in bytes of hash,
264         // enforced by the type signature above
265         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
266     }
267 
268 }
269 
270 // File: Address.sol
271 
272 /**
273  * Source: Openzeppelin
274  */
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         assembly {
304             size := extcodesize(account)
305         }
306         return size > 0;
307     }
308 }
309 
310 // File: IERC721Receiver.sol
311 
312 /**
313  * @title ERC721 token receiver interface
314  * @dev Interface for any contract that wants to support safeTransfers
315  * from ERC721 asset contracts.
316  */
317 interface IERC721Receiver {
318     /**
319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
320      * by `operator` from `from`, this function is called.
321      *
322      * It must return its Solidity selector to confirm the token transfer.
323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
324      *
325      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
326      */
327     function onERC721Received(
328         address operator,
329         address from,
330         uint256 tokenId,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 // File: IERC165.sol
336 
337 // https://eips.ethereum.org/EIPS/eip-165
338 
339 
340 interface IERC165 {
341     /// @notice Query if a contract implements an interface
342     /// @param interfaceID The interface identifier, as specified in ERC-165
343     /// @dev Interface identification is specified in ERC-165. This function
344     ///  uses less than 30,000 gas.
345     /// @return `true` if the contract implements `interfaceID` and
346     ///  `interfaceID` is not 0xffffffff, `false` otherwise
347     function supportsInterface(bytes4 interfaceID) external view returns (bool);
348 }
349 
350 // File: IERC2981.sol
351 
352 
353 /**
354  * Source: Openzeppelin
355  */
356 
357 
358 /**
359  * @dev Interface for the NFT Royalty Standard
360  */
361 interface IERC2981 is IERC165 {
362     /**
363      * @dev Called with the sale price to determine how much royalty is owed and to whom.
364      * @param tokenId - the NFT asset queried for royalty information
365      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
366      * @return receiver - address of who should be sent the royalty payment
367      * @return royaltyAmount - the royalty payment amount for `salePrice`
368      */
369     function royaltyInfo(uint256 tokenId, uint256 salePrice)
370         external
371         view
372         returns (address receiver, uint256 royaltyAmount);
373 }
374 
375 // File: ERC165.sol
376 
377 
378 /**
379  * Source: Openzeppelin
380  */
381 
382 
383 /**
384  * @dev Implementation of the {IERC165} interface.
385  *
386  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
387  * for the additional interface id that will be supported. For example:
388  *
389  * ```solidity
390  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
391  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
392  * }
393  * ```
394  *
395  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
396  */
397 abstract contract ERC165 is IERC165 {
398     /**
399      * @dev See {IERC165-supportsInterface}.
400      */
401     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
402         return interfaceId == type(IERC165).interfaceId;
403     }
404 }
405 
406 // File: IERC721.sol
407 
408 // https://eips.ethereum.org/EIPS/eip-721, http://erc721.org/
409 
410 
411 /// @title ERC-721 Non-Fungible Token Standard
412 /// @dev See https://eips.ethereum.org/EIPS/eip-721
413 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
414 interface IERC721 is IERC165 {
415     /// @dev This emits when ownership of any NFT changes by any mechanism.
416     ///  This event emits when NFTs are created (`from` == 0) and destroyed
417     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
418     ///  may be created and assigned without emitting Transfer. At the time of
419     ///  any transfer, the approved address for that NFT (if any) is reset to none.
420     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
421 
422     /// @dev This emits when the approved address for an NFT is changed or
423     ///  reaffirmed. The zero address indicates there is no approved address.
424     ///  When a Transfer event emits, this also indicates that the approved
425     ///  address for that NFT (if any) is reset to none.
426     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
427 
428     /// @dev This emits when an operator is enabled or disabled for an owner.
429     ///  The operator can manage all NFTs of the owner.
430     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
431 
432     /// @notice Count all NFTs assigned to an owner
433     /// @dev NFTs assigned to the zero address are considered invalid, and this
434     ///  function throws for queries about the zero address.
435     /// @param _owner An address for whom to query the balance
436     /// @return The number of NFTs owned by `_owner`, possibly zero
437     function balanceOf(address _owner) external view returns (uint256);
438 
439     /// @notice Find the owner of an NFT
440     /// @dev NFTs assigned to zero address are considered invalid, and queries
441     ///  about them do throw.
442     /// @param _tokenId The identifier for an NFT
443     /// @return The address of the owner of the NFT
444     function ownerOf(uint256 _tokenId) external view returns (address);
445 
446     /// @notice Transfers the ownership of an NFT from one address to another address
447     /// @dev Throws unless `msg.sender` is the current owner, an authorized
448     ///  operator, or the approved address for this NFT. Throws if `_from` is
449     ///  not the current owner. Throws if `_to` is the zero address. Throws if
450     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
451     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
452     ///  `onERC721Received` on `_to` and throws if the return value is not
453     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
454     /// @param _from The current owner of the NFT
455     /// @param _to The new owner
456     /// @param _tokenId The NFT to transfer
457     /// @param data Additional data with no specified format, sent in call to `_to`
458     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external;
459 
460     /// @notice Transfers the ownership of an NFT from one address to another address
461     /// @dev This works identically to the other function with an extra data parameter,
462     ///  except this function just sets data to "".
463     /// @param _from The current owner of the NFT
464     /// @param _to The new owner
465     /// @param _tokenId The NFT to transfer
466     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
467 
468     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
469     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
470     ///  THEY MAY BE PERMANENTLY LOST
471     /// @dev Throws unless `msg.sender` is the current owner, an authorized
472     ///  operator, or the approved address for this NFT. Throws if `_from` is
473     ///  not the current owner. Throws if `_to` is the zero address. Throws if
474     ///  `_tokenId` is not a valid NFT.
475     /// @param _from The current owner of the NFT
476     /// @param _to The new owner
477     /// @param _tokenId The NFT to transfer
478     function transferFrom(address _from, address _to, uint256 _tokenId) external;
479 
480     /// @notice Change or reaffirm the approved address for an NFT
481     /// @dev The zero address indicates there is no approved address.
482     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
483     ///  operator of the current owner.
484     /// @param _approved The new approved NFT controller
485     /// @param _tokenId The NFT to approve
486     function approve(address _approved, uint256 _tokenId) external;
487 
488     /// @notice Enable or disable approval for a third party ("operator") to manage
489     ///  all of `msg.sender`'s assets
490     /// @dev Emits the ApprovalForAll event. The contract MUST allow
491     ///  multiple operators per owner.
492     /// @param _operator Address to add to the set of authorized operators
493     /// @param _approved True if the operator is approved, false to revoke approval
494     function setApprovalForAll(address _operator, bool _approved) external;
495 
496     /// @notice Get the approved address for a single NFT
497     /// @dev Throws if `_tokenId` is not a valid NFT.
498     /// @param _tokenId The NFT to find the approved address for
499     /// @return The approved address for this NFT, or the zero address if there is none
500     function getApproved(uint256 _tokenId) external view returns (address);
501 
502     /// @notice Query if an address is an authorized operator for another address
503     /// @param _owner The address that owns the NFTs
504     /// @param _operator The address that acts on behalf of the owner
505     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
506     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
507 }
508 
509 // File: IERC721Metadata.sol
510 
511 
512 /**
513  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
514  * @dev See https://eips.ethereum.org/EIPS/eip-721
515  */
516 interface IERC721Metadata is IERC721 {
517     /**
518      * @dev Returns the token collection name.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the token collection symbol.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
529      */
530     function tokenURI(uint256 tokenId) external view returns (string memory);
531 }
532 
533 // File: ERC721.sol
534 
535 /**
536  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
537  * the Metadata extension
538  * Made for efficiancy!
539  */
540 contract ERC721 is ERC165, IERC721, IERC721Metadata, Ownable {
541     using Address for address;
542     using Strings for uint256;
543 
544     uint16 public totalSupply;
545 
546     address public proxyRegistryAddress;
547 
548     string public baseURI;
549 
550     // Mapping from token ID to owner address
551     mapping(uint256 => address) internal _owners;
552 
553     // Mapping owner address to token count
554     mapping(address => uint256) internal _balances;
555 
556     // Mapping from token ID to approved address
557     mapping(uint256 => address) private _tokenApprovals;
558 
559     // Mapping from owner to operator approvals
560     mapping(address => mapping(address => bool)) private _operatorApprovals;
561 
562 
563     constructor(address _openseaProxyRegistry, string memory _baseURI) {
564         proxyRegistryAddress = _openseaProxyRegistry;
565         baseURI = _baseURI;
566     }
567 
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
572         return
573             interfaceId == type(IERC721).interfaceId ||
574             interfaceId == type(IERC721Metadata).interfaceId ||
575             super.supportsInterface(interfaceId);
576     }
577 
578     /**
579      * @dev See {IERC721-balanceOf}.
580      */
581     function balanceOf(address owner) external view override returns (uint256) {
582         require(owner != address(0), "ERC721: balance query for the zero address");
583         return _balances[owner];
584     }
585 
586     /**
587      * @dev See {IERC721-ownerOf}.
588      */
589     function ownerOf(uint256 tokenId) public view override returns (address) {
590         address owner = _owners[tokenId];
591         require(owner != address(0), "ERC721: owner query for nonexistent token");
592         return owner;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-name}.
597      */
598     function name() external pure override returns (string memory) {
599         return "Chill Bear Club";
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-symbol}.
604      */
605     function symbol() external pure override returns (string memory) {
606         return "CBC";
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-tokenURI}.
611      */
612     function tokenURI(uint256 tokenId) external view override returns (string memory) {
613         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
614 
615         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
616     }
617 
618     /**
619      * @dev See {IERC721-approve}.
620      */
621     function approve(address to, uint256 tokenId) external override {
622         address owner = _owners[tokenId];
623         require(to != owner, "ERC721: approval to current owner");
624 
625         require(
626             msg.sender == owner || isApprovedForAll(owner, msg.sender),
627             "ERC721: approve caller is not owner nor approved for all"
628         );
629 
630         _approve(to, tokenId);
631     }
632 
633     /**
634      * @dev See {IERC721-getApproved}.
635      */
636     function getApproved(uint256 tokenId) public view override returns (address) {
637         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
638 
639         return _tokenApprovals[tokenId];
640     }
641 
642     /**
643      * @dev See {IERC721-setApprovalForAll}.
644      */
645     function setApprovalForAll(address operator, bool approved) external override {
646         _setApprovalForAll(msg.sender, operator, approved);
647     }
648 
649     /**
650      * @dev See {IERC721-isApprovedForAll}.
651      */
652     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
653         // Whitelist OpenSea proxy contract for easy trading.
654         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
655         if (address(proxyRegistry.proxies(owner)) == operator) {
656             return true;
657         }
658 
659         return _operatorApprovals[owner][operator];
660     }
661 
662     function setOpenseaProxyRegistry(address addr) external onlyOwner {
663         proxyRegistryAddress = addr;
664     }
665 
666     function setBaseURI(string calldata _baseURI) external onlyOwner {
667         baseURI = _baseURI;
668     }
669 
670     /**
671      * @dev See {IERC721-transferFrom}.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external override {
678         //solhint-disable-next-line max-line-length
679         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
680 
681         _transfer(from, to, tokenId);
682     }
683 
684     /**
685      * @dev See {IERC721-safeTransferFrom}.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) external override {
692         safeTransferFrom(from, to, tokenId, "");
693     }
694 
695     /**
696      * @dev See {IERC721-safeTransferFrom}.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId,
702         bytes memory _data
703     ) public override {
704         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
705         _safeTransfer(from, to, tokenId, _data);
706     }
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
710      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
711      *
712      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
713      *
714      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
715      * implement alternative mechanisms to perform token transfer, such as signature-based.
716      *
717      * Requirements:
718      *
719      * - `from` cannot be the zero address.
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must exist and be owned by `from`.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function _safeTransfer(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) internal virtual {
732         _transfer(from, to, tokenId);
733         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
734     }
735 
736     /**
737      * @dev Returns whether `tokenId` exists.
738      *
739      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
740      *
741      * Tokens start existing when they are minted
742      */
743     function _exists(uint256 tokenId) internal view virtual returns (bool) {
744         return _owners[tokenId] != address(0);
745     }
746 
747     /**
748      * @dev Returns whether `spender` is allowed to manage `tokenId`.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must exist.
753      */
754     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
755         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
756         address owner = _owners[tokenId];
757         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
758     }
759 
760     /**
761      * @dev Mints `tokenId` and transfers it to `to`.
762      *
763      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
764      *
765      * Requirements:
766      *
767      * - `tokenId` must not exist.
768      * - `to` cannot be the zero address.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _mint2(address to) internal {
773         uint tokenId = totalSupply;
774 
775         _balances[to] += 2;
776 
777         for (uint i; i < 2; i++) {
778             tokenId++;
779             _owners[tokenId] = to;
780             emit Transfer(address(0), to, tokenId);
781 
782         }
783 
784         totalSupply += 2;
785 
786         require(
787             _checkOnERC721Received(address(0), to, tokenId, ""),
788             "ERC721: transfer to non ERC721Receiver implementer"
789         ); // checking it once will make sure that the address can recieve NFTs
790     }
791 
792     function _mint1(address to) internal {
793         uint tokenId = totalSupply + 1;
794 
795         _balances[to]++;
796         _owners[tokenId] = to;
797         emit Transfer(address(0), to, tokenId);
798         totalSupply++;
799 
800         require(
801             _checkOnERC721Received(address(0), to, tokenId, ""),
802             "ERC721: transfer to non ERC721Receiver implementer"
803         );
804     }
805 
806     /**
807      * @dev Transfers `tokenId` from `from` to `to`.
808      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
809      *
810      * Requirements:
811      *
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must be owned by `from`.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _transfer(
818         address from,
819         address to,
820         uint256 tokenId
821     ) internal virtual {
822         require(_owners[tokenId] == from, "ERC721: transfer from incorrect owner");
823         require(to != address(0), "ERC721: transfer to the zero address");
824 
825         // Clear approvals from the previous owner
826         _approve(address(0), tokenId);
827 
828         _balances[from]--;
829         _balances[to]++;
830 
831         _owners[tokenId] = to;
832 
833         emit Transfer(from, to, tokenId);
834     }
835 
836     /**
837      * @dev Approve `to` to operate on `tokenId`
838      *
839      * Emits a {Approval} event.
840      */
841     function _approve(address to, uint256 tokenId) internal virtual {
842         _tokenApprovals[tokenId] = to;
843         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
844     }
845 
846     /**
847      * @dev Approve `operator` to operate on all of `owner` tokens
848      *
849      * Emits a {ApprovalForAll} event.
850      */
851     function _setApprovalForAll(
852         address owner,
853         address operator,
854         bool approved
855     ) internal virtual {
856         require(owner != operator, "ERC721: approve to caller");
857         _operatorApprovals[owner][operator] = approved;
858         emit ApprovalForAll(owner, operator, approved);
859     }
860 
861     /**
862      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
863      * The call is not executed if the target address is not a contract.
864      *
865      * @param from address representing the previous owner of the given token ID
866      * @param to target address that will receive the tokens
867      * @param tokenId uint256 ID of the token to be transferred
868      * @param _data bytes optional data to send along with the call
869      * @return bool whether the call correctly returned the expected magic value
870      */
871     function _checkOnERC721Received(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) private returns (bool) {
877         if (to.isContract()) {
878             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
879                 return retval == IERC721Receiver.onERC721Received.selector;
880             } catch (bytes memory reason) {
881                 if (reason.length == 0) {
882                     revert("ERC721: transfer to non ERC721Receiver implementer");
883                 } else {
884                     assembly {
885                         revert(add(32, reason), mload(reason))
886                     }
887                 }
888             }
889         } else {
890             return true;
891         }
892     }
893 
894 }
895 
896 contract OwnableDelegateProxy {}
897 
898 contract ProxyRegistry {
899     mapping(address => OwnableDelegateProxy) public proxies;
900 }
901 
902 
903 // File: ChillBears.sol
904 
905 
906 contract ChillBears is IERC2981, ERC721 {
907 
908     bool private _onlyWhitelist;
909     bool private _onlyOg;
910     bool private _mintingEnabled;
911 
912     uint private _preMintSupply;
913     uint private _publicSaleSupply;
914 
915     uint private _ogPrice;
916     uint private _preSalePrice;
917     uint private _publicSalePrice;
918 
919     uint private _EIP2981RoyaltyPercentage;
920 
921     mapping(address => uint) amountMinted;
922 
923     event OgPriceChanged(uint indexed prevPrice, uint indexed newPrice);
924     event PreSalePriceChanged(uint indexed prevPrice, uint indexed newPrice);
925     event PublicSalePriceChanged(uint indexed prevPrice, uint indexed newPrice);
926     event PreSaleSupplyChanged(uint indexed prevSupply, uint indexed newSupply);
927     event PublicSaleSupplyChanged(uint indexed prevSupply, uint indexed newSupply);
928     event EIP2981RoyaltyPercentageChanged(uint indexed prevRoyalty, uint indexed newRoyalty);
929 
930     constructor(
931         address _openseaProxyRegistry,
932         uint preMintSupply,
933         uint publicSaleSupply,
934         uint publicSalePrice,
935         uint ogPrice,
936         uint preSalePrice,
937         uint EIP2981RoyaltyPercentage,
938         string memory _baseURI
939     ) ERC721(_openseaProxyRegistry, _baseURI) {
940         require(EIP2981RoyaltyPercentage <= 1000, "royalty cannot be more than 10 percent");
941         _EIP2981RoyaltyPercentage = EIP2981RoyaltyPercentage;
942 
943         require(preMintSupply + publicSaleSupply == 5555, "Supply has to be 5555");
944         _preMintSupply = preMintSupply;
945         _publicSaleSupply = publicSaleSupply;
946 
947         _preSalePrice = preSalePrice;
948         _ogPrice = ogPrice;
949         _publicSalePrice = publicSalePrice;
950     }
951 
952 
953     function mintFromReserve(address to) external onlyOwner {
954         require(totalSupply < 1);
955         _mint1(to);
956     }
957 
958 
959     function getMintingInfo() external view returns(
960         uint preMintSupply,
961         uint publicSaleSupply,
962         uint publicSalePrice,
963         uint ogPrice,
964         uint preSalePrice,
965         uint EIP2981RoyaltyPercentage
966     ) {
967         preMintSupply = _preMintSupply;
968         publicSaleSupply = _publicSaleSupply;
969         preSalePrice = _preSalePrice;
970         ogPrice = _ogPrice;
971         publicSalePrice = _publicSalePrice;
972         EIP2981RoyaltyPercentage = _EIP2981RoyaltyPercentage;
973     }
974 
975 
976     /**
977      * @notice make sure you get the numbers correctly
978      * NOTE: adding tokens to the pre mint supply enceases the max total supply, to keep the total supply the same, make sure to change the public sale supply
979      */
980     function setPreMintSupply(uint supply) external onlyOwner {
981         require(supply + _publicSaleSupply <= 5555, "Total supply can't be > 5555");
982         uint prev = _preMintSupply;
983         _preMintSupply = supply;
984         emit PreSaleSupplyChanged(prev, supply);
985     }
986 
987     /**
988      * @notice make sure you get the numbers correctly
989      */
990     function setPublicMintSupply(uint supply) external onlyOwner {
991         require(_preMintSupply + supply <= 5555, "Total supply can't be > 5555");
992         uint prev = _publicSaleSupply;
993         _publicSaleSupply = supply;
994         emit PublicSaleSupplyChanged(prev, supply);
995     }
996 
997     function setOgMintPrice(uint priceInWei) external onlyOwner {
998         uint prev = _ogPrice;
999         _ogPrice = priceInWei;
1000         emit OgPriceChanged(prev, priceInWei);
1001     }
1002 
1003     function setPreSalePrice(uint priceInWei) external onlyOwner {
1004         uint prev = _preSalePrice;
1005         _preSalePrice = priceInWei;
1006         emit PreSalePriceChanged(prev, priceInWei);
1007     }
1008 
1009     function setPublicSalePrice(uint priceInWei) external onlyOwner {
1010         uint prev = _publicSalePrice;
1011         _publicSalePrice = priceInWei;
1012         emit PublicSalePriceChanged(prev, priceInWei);
1013     }
1014 
1015     /**
1016      * @notice In basis points (parts per 10K). Eg. 500 = 5%
1017      */
1018     function setEIP2981RoyaltyPercentage(uint percentage) external onlyOwner {
1019         require(percentage <= 1000, "royalty cannot be more than 10 percent");
1020         uint prev = _EIP2981RoyaltyPercentage;
1021         _EIP2981RoyaltyPercentage = percentage;
1022         emit EIP2981RoyaltyPercentageChanged(prev, percentage);
1023     }
1024 
1025     modifier mintFunc(uint maxMintSupply, uint price) {
1026         require(maxMintSupply > 0, "Request exceeds max supply!");
1027         require(msg.value == price, "ETH Amount is not correct!");
1028         _;
1029     }
1030 
1031     function mint() external payable mintFunc(_publicSaleSupply, _publicSalePrice) {
1032         require(_mintingEnabled, "Minting is not enabled!");
1033         require(amountMinted[msg.sender] == 0, "Can't mint more than 1 token!");
1034 
1035         _publicSaleSupply--;
1036         amountMinted[msg.sender]++;
1037         _mint1(msg.sender);
1038     }
1039 
1040     function preMint(bytes calldata sig) external payable mintFunc(_preMintSupply, _preSalePrice) {
1041         require(_onlyWhitelist, "Pre sale is not enabled!");
1042         require(_isWhitelisted(msg.sender, sig), "User not whitelisted!");
1043         require(amountMinted[msg.sender] == 0, "Can't mint more than 1 token!");
1044 
1045         _preMintSupply--;
1046         amountMinted[msg.sender]++;
1047         _mint1(msg.sender);
1048     }
1049 
1050     function ogMint(bytes calldata sig, uint amount) external payable mintFunc(_preMintSupply - amount - 1, _ogPrice * amount) {
1051         _ogMint(sig);
1052         require(amountMinted[msg.sender] + amount < 3, "Can't mint more than 2 tokens!");
1053 
1054         _preMintSupply -= amount;
1055         amountMinted[msg.sender] += amount;
1056 
1057         for (uint i; i < amount; i++) {
1058             _mint1(msg.sender);
1059         }
1060     }
1061 
1062     function _ogMint(bytes calldata sig) private view {
1063         require(_onlyOg, "Og minting is not enabled!");
1064         require(_isOG(msg.sender, sig), "User not OG!");
1065     }
1066 
1067     function _isOG(address _wallet, bytes memory _signature) private view returns(bool) {
1068         return ECDSA.recover(
1069             ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_wallet, "OG"))),
1070             _signature
1071         ) == owner();
1072     }
1073 
1074     function _isWhitelisted(address _wallet, bytes memory _signature) private view returns(bool) {
1075         return ECDSA.recover(
1076             ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_wallet))),
1077             _signature
1078         ) == owner();
1079     }
1080 
1081     function isWhitelisted(address _wallet, bytes memory _signature) external view returns(bool) {
1082         return _isWhitelisted(_wallet, _signature);
1083     }
1084 
1085     function getSalesStatus() external view returns(bool onlyOg, bool onlyWhitelist, bool mintingEnabled) {
1086         onlyOg = _onlyOg;
1087         onlyWhitelist = _onlyWhitelist;
1088         mintingEnabled = _mintingEnabled;
1089     }
1090 
1091     /**
1092      * @notice returns royalty info for EIP2981 supporting marketplaces
1093      * @dev Called with the sale price to determine how much royalty is owed and to whom.
1094      * @param tokenId - the NFT asset queried for royalty information
1095      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
1096      * @return receiver - address of who should be sent the royalty payment
1097      * @return royaltyAmount - the royalty payment amount for `salePrice`
1098      */
1099     function royaltyInfo(uint tokenId, uint salePrice) external view override returns(address receiver, uint256 royaltyAmount) {
1100         require(_exists(tokenId), "Royality querry for non-existant token!");
1101         return(owner(), salePrice * _EIP2981RoyaltyPercentage / 10000);
1102     }
1103 
1104     /**
1105      * @dev See {IERC165-supportsInterface}.
1106      */
1107     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1108         return
1109             interfaceId == type(IERC2981).interfaceId ||
1110             super.supportsInterface(interfaceId);
1111     }
1112 
1113     function withdraw() onlyOwner external {
1114         (bool success, ) = payable(msg.sender).call{value: address(this).balance, gas: 2600}("");
1115         require(success, "Failed to withdraw payment!");
1116     }
1117 
1118     /**
1119      * @notice toggles pre sale
1120      * @dev enables the pre sale functions. NEVER USE THIS AFTER ENABLING THE PUBLIC SALE FUNCTIONS
1121      */
1122     function togglePresale() external onlyOwner {
1123         _onlyWhitelist = !_onlyWhitelist;
1124     }
1125 
1126     function toggleOgSale() external onlyOwner {
1127         _onlyOg = !_onlyOg;
1128     }
1129 
1130     /**
1131      * @notice toggles the public sale
1132      * @dev enables/disables public sale functions and disables pre sale functions
1133      */
1134     function togglePublicSale() external onlyOwner {
1135         _onlyOg = false;
1136         _onlyWhitelist = false;
1137         _mintingEnabled = !_mintingEnabled;
1138     }
1139 
1140     function tokensOfOwner(address owner) external view returns(uint[] memory) {
1141         uint[] memory tokens = new uint[](_balances[owner]);
1142         uint y = totalSupply + 1;
1143         uint x;
1144 
1145         for (uint i = 1; i < y; i++) {
1146             if (ownerOf(i) == owner) {
1147                 tokens[x] = i;
1148                 x++;
1149             }
1150         }
1151         return tokens;
1152     }
1153 }