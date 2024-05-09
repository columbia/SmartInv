1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 // File: IOperatorFilterRegistry.sol
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: OperatorFilterer721.sol
34 
35 abstract contract OperatorFilterer721 {
36     error OperatorNotAllowed(address operator);
37 
38     IOperatorFilterRegistry constant operatorFilterRegistry =
39         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
40 
41     mapping(address => bool) internal allowedContracts;
42 
43     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
44         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
45         // will not revert, but the contract will need to be registered with the registry once it is deployed in
46         // order for the modifier to filter addresses.
47         if (address(operatorFilterRegistry).code.length > 0) {
48             if (subscribe) {
49                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
50             } else {
51                 if (subscriptionOrRegistrantToCopy != address(0)) {
52                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
53                 } else {
54                     operatorFilterRegistry.register(address(this));
55                 }
56             }
57         }
58     }
59 
60     modifier onlyAllowedOperator(address from) virtual {
61         // Check registry code length to facilitate testing in environments without a deployed registry.
62         if (address(operatorFilterRegistry).code.length > 0) {
63             // Allow spending tokens from addresses with balance
64             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
65             // from an EOA.
66             if (from == msg.sender) {
67                 _;
68                 return;
69             }
70             if (allowedContracts[msg.sender]) {
71                 _;
72                 return;
73             }
74             if (
75                 !(
76                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
77                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
78                 )
79             ) {
80                 revert OperatorNotAllowed(msg.sender);
81             }
82         }
83         _;
84     }
85 }
86 
87 // File: DefaultOperatorFilterer721.sol
88 
89 abstract contract DefaultOperatorFilterer721 is OperatorFilterer721 {
90     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
91 
92     constructor() OperatorFilterer721(DEFAULT_SUBSCRIPTION, true) {}
93 }
94 
95 // File: contracts/Ownable.sol
96 
97 /**
98  * @dev Contract module which provides a basic access control mechanism, where
99  * there is an account (an owner) that can be granted exclusive access to
100  * specific functions.
101  *
102  * By default, the owner account will be the one that deploys the contract. This
103  * can later be changed with {transferOwnership}.
104  *
105  * This module is used through inheritance. It will make available the modifier
106  * `onlyOwner`, which can be applied to your functions to restrict their use to
107  * the owner.
108  *
109  * Source: openzeppelin
110  */
111 abstract contract Ownable {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     /**
117      * @dev Initializes the contract setting the deployer as the initial owner.
118      */
119     constructor() {
120         _setOwner(msg.sender);
121     }
122 
123     /**
124      * @dev Returns the address of the current owner.
125      */
126     function owner() public view virtual returns (address) {
127         return _owner;
128     }
129 
130     /**
131      * @dev Throws if called by any account other than the owner.
132      */
133     modifier onlyOwner() {
134         require(owner() == msg.sender, "Ownable: caller is not the owner");
135         _;
136     }
137 
138     /**
139      * @dev Leaves the contract without owner. It will not be possible to call
140      * `onlyOwner` functions anymore. Can only be called by the current owner.
141      *
142      * NOTE: Renouncing ownership will leave the contract without an owner,
143      * thereby removing any functionality that is only available to the owner.
144      */
145     function renounceOwnership() external virtual onlyOwner {
146         _setOwner(address(0));
147     }
148 
149     /**
150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
151      * Can only be called by the current owner.
152      */
153     function transferOwnership(address newOwner) external virtual onlyOwner {
154         require(newOwner != address(0), "Ownable: new owner is the zero address");
155         _setOwner(newOwner);
156     }
157 
158     function _setOwner(address newOwner) private {
159         address oldOwner = _owner;
160         _owner = newOwner;
161         emit OwnershipTransferred(oldOwner, newOwner);
162     }
163 }
164 
165 // File: Strings.sol
166 
167 /**
168  * Source: Openzeppelin
169  */
170 
171 /**
172  * @dev String operations.
173  */
174 library Strings {
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
178      */
179     function toString(uint256 value) internal pure returns (string memory) {
180         // Inspired by OraclizeAPI's implementation - MIT licence
181         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
182 
183         if (value == 0) {
184             return "0";
185         }
186         uint256 temp = value;
187         uint256 digits;
188         while (temp != 0) {
189             digits++;
190             temp /= 10;
191         }
192         bytes memory buffer = new bytes(digits);
193         while (value != 0) {
194             digits -= 1;
195             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
196             value /= 10;
197         }
198         return string(buffer);
199     }
200 }
201 
202 // File: ECDSA.sol
203 
204 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
205 
206 
207 /**
208  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
209  *
210  * These functions can be used to verify that a message was signed by the holder
211  * of the private keys of a given address.
212  */
213 library ECDSA {
214 
215     /**
216      * @dev Returns the address that signed a hashed message (`hash`) with
217      * `signature` or error string. This address can then be used for verification purposes.
218      *
219      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
220      * this function rejects them by requiring the `s` value to be in the lower
221      * half order, and the `v` value to be either 27 or 28.
222      *
223      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
224      * verification to be secure: it is possible to craft signatures that
225      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
226      * this is by receiving a hash of the original message (which may otherwise
227      * be too long), and then calling {toEthSignedMessageHash} on it.
228      *
229      * Documentation for signature generation:
230      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
231      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
232      *
233      * _Available since v4.3._
234      */
235     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address) {
236         // Check the signature length
237         // - case 65: r,s,v signature (standard)
238         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
239         if (signature.length == 65) {
240             bytes32 r;
241             bytes32 s;
242             uint8 v;
243             // ecrecover takes the signature parameters, and the only way to get them
244             // currently is to use assembly.
245             assembly {
246                 r := mload(add(signature, 0x20))
247                 s := mload(add(signature, 0x40))
248                 v := byte(0, mload(add(signature, 0x60)))
249             }
250             return tryRecover(hash, v, r, s);
251         } else if (signature.length == 64) {
252             bytes32 r;
253             bytes32 vs;
254             // ecrecover takes the signature parameters, and the only way to get them
255             // currently is to use assembly.
256             assembly {
257                 r := mload(add(signature, 0x20))
258                 vs := mload(add(signature, 0x40))
259             }
260             return tryRecover(hash, r, vs);
261         } else {
262             return (address(0));
263         }
264     }
265 
266     /**
267      * @dev Returns the address that signed a hashed message (`hash`) with
268      * `signature`. This address can then be used for verification purposes.
269      *
270      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
271      * this function rejects them by requiring the `s` value to be in the lower
272      * half order, and the `v` value to be either 27 or 28.
273      *
274      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
275      * verification to be secure: it is possible to craft signatures that
276      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
277      * this is by receiving a hash of the original message (which may otherwise
278      * be too long), and then calling {toEthSignedMessageHash} on it.
279      */
280     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
281         (address recovered) = tryRecover(hash, signature);
282         return recovered;
283     }
284 
285     /**
286      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
287      *
288      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
289      *
290      * _Available since v4.3._
291      */
292     function tryRecover(
293         bytes32 hash,
294         bytes32 r,
295         bytes32 vs
296     ) internal pure returns (address) {
297         bytes32 s;
298         uint8 v;
299         assembly {
300             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
301             v := add(shr(255, vs), 27)
302         }
303         return tryRecover(hash, v, r, s);
304     }
305 
306     /**
307      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
308      * `r` and `s` signature fields separately.
309      *
310      * _Available since v4.3._
311      */
312     function tryRecover(
313         bytes32 hash,
314         uint8 v,
315         bytes32 r,
316         bytes32 s
317     ) internal pure returns (address) {
318         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
319         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
320         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
321         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
322         //
323         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
324         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
325         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
326         // these malleable signatures as well.
327         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
328             return (address(0));
329         }
330         if (v != 27 && v != 28) {
331             return (address(0));
332         }
333 
334         // If the signature is valid (and not malleable), return the signer address
335         address signer = ecrecover(hash, v, r, s);
336         if (signer == address(0)) {
337             return (address(0));
338         }
339 
340         return (signer);
341     }
342 
343     /**
344      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
345      * produces hash corresponding to the one signed with the
346      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
347      * JSON-RPC method as part of EIP-191.
348      *
349      * See {recover}.
350      */
351     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
352         // 32 is the length in bytes of hash,
353         // enforced by the type signature above
354         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
355     }
356 
357 }
358 
359 // File: Address.sol
360 
361 /**
362  * Source: Openzeppelin
363  */
364 
365 /**
366  * @dev Collection of functions related to the address type
367  */
368 library Address {
369     /**
370      * @dev Returns true if `account` is a contract.
371      *
372      * [IMPORTANT]
373      * ====
374      * It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      *
377      * Among others, `isContract` will return false for the following
378      * types of addresses:
379      *
380      *  - an externally-owned account
381      *  - a contract in construction
382      *  - an address where a contract will be created
383      *  - an address where a contract lived, but was destroyed
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // This method relies on extcodesize, which returns 0 for contracts in
388         // construction, since the code is only stored at the end of the
389         // constructor execution.
390 
391         uint256 size;
392         assembly {
393             size := extcodesize(account)
394         }
395         return size > 0;
396     }
397 }
398 
399 // File: IERC721Receiver.sol
400 
401 /**
402  * @title ERC721 token receiver interface
403  * @dev Interface for any contract that wants to support safeTransfers
404  * from ERC721 asset contracts.
405  */
406 interface IERC721Receiver {
407     /**
408      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
409      * by `operator` from `from`, this function is called.
410      *
411      * It must return its Solidity selector to confirm the token transfer.
412      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
413      *
414      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
415      */
416     function onERC721Received(
417         address operator,
418         address from,
419         uint256 tokenId,
420         bytes calldata data
421     ) external returns (bytes4);
422 }
423 
424 // File: IERC165.sol
425 
426 // https://eips.ethereum.org/EIPS/eip-165
427 
428 
429 interface IERC165 {
430     /// @notice Query if a contract implements an interface
431     /// @param interfaceID The interface identifier, as specified in ERC-165
432     /// @dev Interface identification is specified in ERC-165. This function
433     ///  uses less than 30,000 gas.
434     /// @return `true` if the contract implements `interfaceID` and
435     ///  `interfaceID` is not 0xffffffff, `false` otherwise
436     function supportsInterface(bytes4 interfaceID) external view returns (bool);
437 }
438 
439 // File: IERC2981.sol
440 
441 
442 /**
443  * Source: Openzeppelin
444  */
445 
446 
447 /**
448  * @dev Interface for the NFT Royalty Standard
449  */
450 interface IERC2981 is IERC165 {
451     /**
452      * @dev Called with the sale price to determine how much royalty is owed and to whom.
453      * @param tokenId - the NFT asset queried for royalty information
454      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
455      * @return receiver - address of who should be sent the royalty payment
456      * @return royaltyAmount - the royalty payment amount for `salePrice`
457      */
458     function royaltyInfo(uint256 tokenId, uint256 salePrice)
459         external
460         view
461         returns (address receiver, uint256 royaltyAmount);
462 }
463 
464 // File: ERC165.sol
465 
466 
467 /**
468  * Source: Openzeppelin
469  */
470 
471 
472 /**
473  * @dev Implementation of the {IERC165} interface.
474  *
475  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
476  * for the additional interface id that will be supported. For example:
477  *
478  * ```solidity
479  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
481  * }
482  * ```
483  *
484  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
485  */
486 abstract contract ERC165 is IERC165 {
487     /**
488      * @dev See {IERC165-supportsInterface}.
489      */
490     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491         return interfaceId == type(IERC165).interfaceId;
492     }
493 }
494 
495 // File: IERC721.sol
496 
497 // https://eips.ethereum.org/EIPS/eip-721, http://erc721.org/
498 
499 
500 /// @title ERC-721 Non-Fungible Token Standard
501 /// @dev See https://eips.ethereum.org/EIPS/eip-721
502 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
503 interface IERC721 is IERC165 {
504     /// @dev This emits when ownership of any NFT changes by any mechanism.
505     ///  This event emits when NFTs are created (`from` == 0) and destroyed
506     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
507     ///  may be created and assigned without emitting Transfer. At the time of
508     ///  any transfer, the approved address for that NFT (if any) is reset to none.
509     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
510 
511     /// @dev This emits when the approved address for an NFT is changed or
512     ///  reaffirmed. The zero address indicates there is no approved address.
513     ///  When a Transfer event emits, this also indicates that the approved
514     ///  address for that NFT (if any) is reset to none.
515     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
516 
517     /// @dev This emits when an operator is enabled or disabled for an owner.
518     ///  The operator can manage all NFTs of the owner.
519     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
520 
521     /// @notice Count all NFTs assigned to an owner
522     /// @dev NFTs assigned to the zero address are considered invalid, and this
523     ///  function throws for queries about the zero address.
524     /// @param _owner An address for whom to query the balance
525     /// @return The number of NFTs owned by `_owner`, possibly zero
526     function balanceOf(address _owner) external view returns (uint256);
527 
528     /// @notice Find the owner of an NFT
529     /// @dev NFTs assigned to zero address are considered invalid, and queries
530     ///  about them do throw.
531     /// @param _tokenId The identifier for an NFT
532     /// @return The address of the owner of the NFT
533     function ownerOf(uint256 _tokenId) external view returns (address);
534 
535     /// @notice Transfers the ownership of an NFT from one address to another address
536     /// @dev Throws unless `msg.sender` is the current owner, an authorized
537     ///  operator, or the approved address for this NFT. Throws if `_from` is
538     ///  not the current owner. Throws if `_to` is the zero address. Throws if
539     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
540     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
541     ///  `onERC721Received` on `_to` and throws if the return value is not
542     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
543     /// @param _from The current owner of the NFT
544     /// @param _to The new owner
545     /// @param _tokenId The NFT to transfer
546     /// @param data Additional data with no specified format, sent in call to `_to`
547     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external;
548 
549     /// @notice Transfers the ownership of an NFT from one address to another address
550     /// @dev This works identically to the other function with an extra data parameter,
551     ///  except this function just sets data to "".
552     /// @param _from The current owner of the NFT
553     /// @param _to The new owner
554     /// @param _tokenId The NFT to transfer
555     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
556 
557     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
558     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
559     ///  THEY MAY BE PERMANENTLY LOST
560     /// @dev Throws unless `msg.sender` is the current owner, an authorized
561     ///  operator, or the approved address for this NFT. Throws if `_from` is
562     ///  not the current owner. Throws if `_to` is the zero address. Throws if
563     ///  `_tokenId` is not a valid NFT.
564     /// @param _from The current owner of the NFT
565     /// @param _to The new owner
566     /// @param _tokenId The NFT to transfer
567     function transferFrom(address _from, address _to, uint256 _tokenId) external;
568 
569     /// @notice Change or reaffirm the approved address for an NFT
570     /// @dev The zero address indicates there is no approved address.
571     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
572     ///  operator of the current owner.
573     /// @param _approved The new approved NFT controller
574     /// @param _tokenId The NFT to approve
575     function approve(address _approved, uint256 _tokenId) external;
576 
577     /// @notice Enable or disable approval for a third party ("operator") to manage
578     ///  all of `msg.sender`'s assets
579     /// @dev Emits the ApprovalForAll event. The contract MUST allow
580     ///  multiple operators per owner.
581     /// @param _operator Address to add to the set of authorized operators
582     /// @param _approved True if the operator is approved, false to revoke approval
583     function setApprovalForAll(address _operator, bool _approved) external;
584 
585     /// @notice Get the approved address for a single NFT
586     /// @dev Throws if `_tokenId` is not a valid NFT.
587     /// @param _tokenId The NFT to find the approved address for
588     /// @return The approved address for this NFT, or the zero address if there is none
589     function getApproved(uint256 _tokenId) external view returns (address);
590 
591     /// @notice Query if an address is an authorized operator for another address
592     /// @param _owner The address that owns the NFTs
593     /// @param _operator The address that acts on behalf of the owner
594     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
595     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
596 }
597 
598 // File: IERC721Metadata.sol
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
620 }
621 
622 // File: ERC721.sol
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension
627  * Made for efficiancy!
628  */
629 contract ERC721 is ERC165, IERC721, IERC721Metadata, Ownable {
630     using Address for address;
631     using Strings for uint256;
632 
633     uint16 public totalSupply;
634 
635     address public proxyRegistryAddress;
636 
637     string public baseURI;
638 
639     // Mapping from token ID to owner address
640     mapping(uint256 => address) internal _owners;
641 
642     // Mapping owner address to token count
643     mapping(address => uint256) internal _balances;
644 
645     // Mapping from token ID to approved address
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651 
652     constructor(address _openseaProxyRegistry, string memory _baseURI) {
653         proxyRegistryAddress = _openseaProxyRegistry;
654         baseURI = _baseURI;
655     }
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
661         return
662             interfaceId == type(IERC721).interfaceId ||
663             interfaceId == type(IERC721Metadata).interfaceId ||
664             super.supportsInterface(interfaceId);
665     }
666 
667     /**
668      * @dev See {IERC721-balanceOf}.
669      */
670     function balanceOf(address owner) external view override returns (uint256) {
671         require(owner != address(0), "ERC721: balance query for the zero address");
672         return _balances[owner];
673     }
674 
675     /**
676      * @dev See {IERC721-ownerOf}.
677      */
678     function ownerOf(uint256 tokenId) public view override returns (address) {
679         address owner = _owners[tokenId];
680         require(owner != address(0), "ERC721: owner query for nonexistent token");
681         return owner;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-name}.
686      */
687     function name() external pure override returns (string memory) {
688         return "Chill Bear Club Pixels";
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-symbol}.
693      */
694     function symbol() external pure override returns (string memory) {
695         return "CBCP";
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-tokenURI}.
700      */
701     function tokenURI(uint256 tokenId) external view override returns (string memory) {
702         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
703 
704         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
705     }
706 
707     /**
708      * @dev See {IERC721-approve}.
709      */
710     function approve(address to, uint256 tokenId) external override {
711         address owner = _owners[tokenId];
712         require(to != owner, "ERC721: approval to current owner");
713 
714         require(
715             msg.sender == owner || isApprovedForAll(owner, msg.sender),
716             "ERC721: approve caller is not owner nor approved for all"
717         );
718 
719         _approve(to, tokenId);
720     }
721 
722     /**
723      * @dev See {IERC721-getApproved}.
724      */
725     function getApproved(uint256 tokenId) public view override returns (address) {
726         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
727 
728         return _tokenApprovals[tokenId];
729     }
730 
731     /**
732      * @dev See {IERC721-setApprovalForAll}.
733      */
734     function setApprovalForAll(address operator, bool approved) external override {
735         _setApprovalForAll(msg.sender, operator, approved);
736     }
737 
738     /**
739      * @dev See {IERC721-isApprovedForAll}.
740      */
741     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
742         // Whitelist OpenSea proxy contract for easy trading.
743         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
744         if (address(proxyRegistry.proxies(owner)) == operator) {
745             return true;
746         }
747 
748         return _operatorApprovals[owner][operator];
749     }
750 
751     function setOpenseaProxyRegistry(address addr) external onlyOwner {
752         proxyRegistryAddress = addr;
753     }
754 
755     function setBaseURI(string calldata _baseURI) external onlyOwner {
756         baseURI = _baseURI;
757     }
758 
759     /**
760      * @dev See {IERC721-transferFrom}.
761      */
762     function transferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public override virtual {
767         //solhint-disable-next-line max-line-length
768         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
769 
770         _transfer(from, to, tokenId);
771     }
772 
773     /**
774      * @dev See {IERC721-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) public override virtual {
781         safeTransferFrom(from, to, tokenId, "");
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) public override virtual {
793         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
794         _safeTransfer(from, to, tokenId, _data);
795     }
796 
797     /**
798      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
799      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
800      *
801      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
802      *
803      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
804      * implement alternative mechanisms to perform token transfer, such as signature-based.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must exist and be owned by `from`.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _safeTransfer(
816         address from,
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) internal virtual {
821         _transfer(from, to, tokenId);
822         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
823     }
824 
825     /**
826      * @dev Returns whether `tokenId` exists.
827      *
828      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
829      *
830      * Tokens start existing when they are minted
831      */
832     function _exists(uint256 tokenId) internal view virtual returns (bool) {
833         return _owners[tokenId] != address(0);
834     }
835 
836     /**
837      * @dev Returns whether `spender` is allowed to manage `tokenId`.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
844         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
845         address owner = _owners[tokenId];
846         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
847     }
848 
849     function _mintQty(uint16 qty, address to) internal {
850         uint tokenId = totalSupply;
851 
852         _balances[to] += qty;
853 
854         for (uint i; i < qty; i++) {
855             tokenId++;
856             _owners[tokenId] = to;
857             emit Transfer(address(0), to, tokenId);
858 
859         }
860 
861         totalSupply += qty;
862 
863         require(
864             _checkOnERC721Received(address(0), to, tokenId, ""),
865             "ERC721: transfer to non ERC721Receiver implementer"
866         ); // checking it once will make sure that the address can recieve NFTs
867     }
868 
869     /**
870      * @dev Mints `tokenId` and transfers it to `to`.
871      *
872      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
873      *
874      * Requirements:
875      *
876      * - `tokenId` must not exist.
877      * - `to` cannot be the zero address.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _mint2(address to) internal {
882         uint tokenId = totalSupply;
883 
884         _balances[to] += 2;
885 
886         for (uint i; i < 2; i++) {
887             tokenId++;
888             _owners[tokenId] = to;
889             emit Transfer(address(0), to, tokenId);
890 
891         }
892 
893         totalSupply += 2;
894 
895         require(
896             _checkOnERC721Received(address(0), to, tokenId, ""),
897             "ERC721: transfer to non ERC721Receiver implementer"
898         ); // checking it once will make sure that the address can recieve NFTs
899     }
900 
901     function _mint1(address to) internal {
902         uint tokenId = totalSupply + 1;
903 
904         _balances[to]++;
905         _owners[tokenId] = to;
906         emit Transfer(address(0), to, tokenId);
907         totalSupply++;
908 
909         require(
910             _checkOnERC721Received(address(0), to, tokenId, ""),
911             "ERC721: transfer to non ERC721Receiver implementer"
912         );
913     }
914 
915     /**
916      * @dev Transfers `tokenId` from `from` to `to`.
917      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
918      *
919      * Requirements:
920      *
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must be owned by `from`.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _transfer(
927         address from,
928         address to,
929         uint256 tokenId
930     ) internal virtual {
931         require(_owners[tokenId] == from, "ERC721: transfer from incorrect owner");
932         require(to != address(0), "ERC721: transfer to the zero address");
933 
934         // Clear approvals from the previous owner
935         _approve(address(0), tokenId);
936 
937         _balances[from]--;
938         _balances[to]++;
939 
940         _owners[tokenId] = to;
941 
942         emit Transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev Approve `to` to operate on `tokenId`
947      *
948      * Emits a {Approval} event.
949      */
950     function _approve(address to, uint256 tokenId) internal virtual {
951         _tokenApprovals[tokenId] = to;
952         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
953     }
954 
955     /**
956      * @dev Approve `operator` to operate on all of `owner` tokens
957      *
958      * Emits a {ApprovalForAll} event.
959      */
960     function _setApprovalForAll(
961         address owner,
962         address operator,
963         bool approved
964     ) internal virtual {
965         require(owner != operator, "ERC721: approve to caller");
966         _operatorApprovals[owner][operator] = approved;
967         emit ApprovalForAll(owner, operator, approved);
968     }
969 
970     /**
971      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
972      * The call is not executed if the target address is not a contract.
973      *
974      * @param from address representing the previous owner of the given token ID
975      * @param to target address that will receive the tokens
976      * @param tokenId uint256 ID of the token to be transferred
977      * @param _data bytes optional data to send along with the call
978      * @return bool whether the call correctly returned the expected magic value
979      */
980     function _checkOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         if (to.isContract()) {
987             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
988                 return retval == IERC721Receiver.onERC721Received.selector;
989             } catch (bytes memory reason) {
990                 if (reason.length == 0) {
991                     revert("ERC721: transfer to non ERC721Receiver implementer");
992                 } else {
993                     assembly {
994                         revert(add(32, reason), mload(reason))
995                     }
996                 }
997             }
998         } else {
999             return true;
1000         }
1001     }
1002 
1003 }
1004 
1005 contract OwnableDelegateProxy {}
1006 
1007 contract ProxyRegistry {
1008     mapping(address => OwnableDelegateProxy) public proxies;
1009 }
1010 
1011 
1012 // File: PixelBears.sol
1013 
1014 
1015 contract PixelBears is IERC2981, ERC721, DefaultOperatorFilterer721 {
1016 
1017     bool private _whitelistEnabled;
1018     bool private _publicEnabled;
1019 
1020     uint private _supply;
1021 
1022     uint private _whitelistSalePrice;
1023     uint private _publicSalePrice;
1024 
1025     address private _whitelistSigner;
1026 
1027     uint private _EIP2981RoyaltyPercentage;
1028 
1029     uint public maxFreeMint = 20;
1030 
1031     mapping(address => uint) public whitelistMinted;
1032     mapping(address => uint) public freeAmountMinted;
1033 
1034     event WhitelistSalePriceChanged(uint indexed prevPrice, uint indexed newPrice);
1035     event PublicSalePriceChanged(uint indexed prevPrice, uint indexed newPrice);
1036     event EIP2981RoyaltyPercentageChanged(uint indexed prevRoyalty, uint indexed newRoyalty);
1037 
1038     constructor(
1039         address _openseaProxyRegistry,
1040         uint supply,
1041         uint whitelistSalePrice,
1042         uint publicSalePrice,
1043         uint EIP2981RoyaltyPercentage,
1044         address whitelistSigner,
1045         string memory _baseURI
1046     ) ERC721(_openseaProxyRegistry, _baseURI) {
1047         require(EIP2981RoyaltyPercentage <= 1000, "royalty cannot be more than 10 percent");
1048         _EIP2981RoyaltyPercentage = EIP2981RoyaltyPercentage;
1049 
1050         _supply = supply;
1051         _whitelistSigner = whitelistSigner;
1052 
1053         _whitelistSalePrice = whitelistSalePrice;
1054         _publicSalePrice = publicSalePrice;
1055     }
1056 
1057 
1058     function mintFromReserve(address to) external onlyOwner {
1059         require(totalSupply < 1);
1060         _mint1(to);
1061     }
1062 
1063 
1064     function getMintingInfo() external view returns(
1065         uint supply,
1066         uint publicSalePrice,
1067         uint whitelistSalePrice,
1068         uint EIP2981RoyaltyPercentage
1069     ) {
1070         supply = _supply;
1071         whitelistSalePrice = _whitelistSalePrice;
1072         publicSalePrice = _publicSalePrice;
1073         EIP2981RoyaltyPercentage = _EIP2981RoyaltyPercentage;
1074     }
1075 
1076     function setWhitelistPrice(uint priceInWei) external onlyOwner {
1077         uint prev = _whitelistSalePrice;
1078         _whitelistSalePrice = priceInWei;
1079         emit WhitelistSalePriceChanged(prev, priceInWei);
1080     }
1081 
1082     function setPublicSalePrice(uint priceInWei) external onlyOwner {
1083         uint prev = _publicSalePrice;
1084         _publicSalePrice = priceInWei;
1085         emit PublicSalePriceChanged(prev, priceInWei);
1086     }
1087 
1088     function setMaxFreeMint(uint _maxFreeMint) external onlyOwner {
1089         maxFreeMint = _maxFreeMint;
1090     }
1091 
1092 
1093     function setWhitelistSigner(address whitelistSigner) external onlyOwner {
1094         _whitelistSigner = whitelistSigner;
1095     }
1096 
1097     /**
1098      * @notice In basis points (parts per 10K). Eg. 500 = 5%
1099      */
1100     function setEIP2981RoyaltyPercentage(uint percentage) external onlyOwner {
1101         require(percentage <= 1000, "royalty cannot be more than 10 percent");
1102         uint prev = _EIP2981RoyaltyPercentage;
1103         _EIP2981RoyaltyPercentage = percentage;
1104         emit EIP2981RoyaltyPercentageChanged(prev, percentage);
1105     }
1106 
1107     modifier mintFunc(uint16 qty, uint supply, uint price) {
1108         require(supply >= qty, "Request exceeds max supply!");
1109         require(msg.value == price * qty, "ETH Amount is not correct!");
1110         _;
1111     }
1112 
1113     function mint(uint16 qty) external payable mintFunc(qty, _supply, _publicSalePrice) {
1114         require(_publicEnabled, "Public minting is not enabled!");
1115         if (_publicSalePrice == 0) {
1116             require(freeAmountMinted[msg.sender] + qty <= maxFreeMint, "Can't mint more than max free quantity tokens!");
1117             freeAmountMinted[msg.sender] += qty;
1118         }
1119 
1120         _supply -= qty;
1121         _mintQty(qty, msg.sender);
1122     }
1123 
1124     function whitelistMint(bytes calldata sig, uint16 qty, uint16 maxQty) external payable mintFunc(qty, _supply, _whitelistSalePrice) {
1125         require(_whitelistEnabled, "Whitelist sale is not enabled!");
1126         require(_isWhitelisted(msg.sender, maxQty, sig), "User not whitelisted!");
1127         require(whitelistMinted[msg.sender] + qty <= maxQty, "Can't mint more than whitelisted amount of tokens!");
1128 
1129         _supply -= qty;
1130         whitelistMinted[msg.sender] += qty;
1131         _mintQty(qty, msg.sender);
1132     }
1133 
1134     function _isWhitelisted(address _wallet, uint16 _maxQty, bytes memory _signature) private view returns(bool) {
1135         return ECDSA.recover(
1136             ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_wallet, _maxQty))),
1137             _signature
1138         ) == _whitelistSigner;
1139     }
1140 
1141     function isWhitelisted(address _wallet, uint16 _maxQty, bytes memory _signature) external view returns(bool) {
1142         return _isWhitelisted(_wallet, _maxQty, _signature);
1143     }
1144 
1145     function getSalesStatus() external view returns(bool whitelistEnabled, bool publicEnabled, uint whitelistSalePrice, uint publicSalePrice) {
1146         whitelistEnabled = _whitelistEnabled;
1147         publicEnabled = _publicEnabled;
1148         whitelistSalePrice = _whitelistSalePrice;
1149         publicSalePrice = _publicSalePrice;
1150     }
1151 
1152     /**
1153      * @notice returns royalty info for EIP2981 supporting marketplaces
1154      * @dev Called with the sale price to determine how much royalty is owed and to whom.
1155      * @param tokenId - the NFT asset queried for royalty information
1156      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
1157      * @return receiver - address of who should be sent the royalty payment
1158      * @return royaltyAmount - the royalty payment amount for `salePrice`
1159      */
1160     function royaltyInfo(uint tokenId, uint salePrice) external view override returns(address receiver, uint256 royaltyAmount) {
1161         require(_exists(tokenId), "Royality querry for non-existant token!");
1162         return(owner(), salePrice * _EIP2981RoyaltyPercentage / 10000);
1163     }
1164 
1165     /**
1166      * @dev See {IERC165-supportsInterface}.
1167      */
1168     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1169         return
1170             interfaceId == type(IERC2981).interfaceId ||
1171             super.supportsInterface(interfaceId);
1172     }
1173 
1174     function withdraw() onlyOwner external {
1175         (bool success, ) = payable(msg.sender).call{value: address(this).balance, gas: 2600}("");
1176         require(success, "Failed to withdraw payment!");
1177     }
1178 
1179     function toggleWhitelistSale() external onlyOwner {
1180         _whitelistEnabled = !_whitelistEnabled;
1181     }
1182 
1183     function togglePublicSale() external onlyOwner {
1184         _publicEnabled = !_publicEnabled;
1185     }
1186 
1187     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1188         super.transferFrom(from, to, tokenId);
1189     }
1190 
1191     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1192         super.safeTransferFrom(from, to, tokenId);
1193     }
1194 
1195     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1196         public
1197         override
1198         onlyAllowedOperator(from)
1199     {
1200         super.safeTransferFrom(from, to, tokenId, data);
1201     }
1202 
1203     function setOperaterFilterBypass(address sender, bool approved) external onlyOwner {
1204         allowedContracts[sender] = approved;
1205     }
1206 
1207     function tokensOfOwner(address owner) external view returns(uint[] memory) {
1208         uint owned = _balances[owner];
1209         uint[] memory tokens = new uint[](owned);
1210         uint x;
1211 
1212         if (owned == 0) return tokens;
1213 
1214         for (uint i = 1; i <= totalSupply; i++) {
1215             if (ownerOf(i) == owner) {
1216                 tokens[x] = i;
1217                 x++;
1218                 if (x >= owned) {
1219                     break;
1220                 }
1221             }
1222         }
1223         return tokens;
1224     }
1225 }