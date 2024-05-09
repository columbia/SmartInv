1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev These functions deal with verification of Merkle Trees proofs.
9  *
10  * The proofs can be generated using the JavaScript library
11  * https://github.com/miguelmota/merkletreejs[merkletreejs].
12  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
13  *
14  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
15  */
16 library MerkleProof {
17     /**
18      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
19      * defined by `root`. For this, a `proof` must be provided, containing
20      * sibling hashes on the branch from the leaf to the root of the tree. Each
21      * pair of leaves and each pair of pre-images are assumed to be sorted.
22      */
23     function verify(
24         bytes32[] memory proof,
25         bytes32 root,
26         bytes32 leaf
27     ) internal pure returns (bool) {
28         return processProof(proof, leaf) == root;
29     }
30 
31     /**
32      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
33      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
34      * hash matches the root of the tree. When processing the proof, the pairs
35      * of leafs & pre-images are assumed to be sorted.
36      *
37      * _Available since v4.4._
38      */
39     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
40         bytes32 computedHash = leaf;
41         for (uint256 i = 0; i < proof.length; i++) {
42             bytes32 proofElement = proof[i];
43             if (computedHash <= proofElement) {
44                 // Hash(current computed hash + current element of the proof)
45                 computedHash = _efficientHash(computedHash, proofElement);
46             } else {
47                 // Hash(current element of the proof + current computed hash)
48                 computedHash = _efficientHash(proofElement, computedHash);
49             }
50         }
51         return computedHash;
52     }
53 
54     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
55         assembly {
56             mstore(0x00, a)
57             mstore(0x20, b)
58             value := keccak256(0x00, 0x40)
59         }
60     }
61 }
62 
63 // File: @openzeppelin/contracts/utils/Context.sol
64 
65 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev Provides information about the current execution context, including the
71  * sender of the transaction and its data. While these are generally available
72  * via msg.sender and msg.data, they should not be accessed in such a direct
73  * manner, since when dealing with meta-transactions the account sending and
74  * paying for execution may not be the actual sender (as far as an application
75  * is concerned).
76  *
77  * This contract is only required for intermediate, library-like contracts.
78  */
79 abstract contract Context {
80     function _msgSender() internal view virtual returns (address) {
81         return msg.sender;
82     }
83 
84     function _msgData() internal view virtual returns (bytes calldata) {
85         return msg.data;
86     }
87 }
88 
89 // File: @openzeppelin/contracts/access/Ownable.sol
90 
91 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Contract module which provides a basic access control mechanism, where
97  * there is an account (an owner) that can be granted exclusive access to
98  * specific functions.
99  *
100  * By default, the owner account will be the one that deploys the contract. This
101  * can later be changed with {transferOwnership}.
102  *
103  * This module is used through inheritance. It will make available the modifier
104  * `onlyOwner`, which can be applied to your functions to restrict their use to
105  * the owner.
106  */
107 abstract contract Ownable is Context {
108     address private _owner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     /**
113      * @dev Initializes the contract setting the deployer as the initial owner.
114      */
115     constructor() {
116         _transferOwnership(_msgSender());
117     }
118 
119     /**
120      * @dev Returns the address of the current owner.
121      */
122     function owner() public view virtual returns (address) {
123         return _owner;
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         require(owner() == _msgSender(), "Ownable: caller is not the owner");
131         _;
132     }
133 
134     /**
135      * @dev Leaves the contract without owner. It will not be possible to call
136      * `onlyOwner` functions anymore. Can only be called by the current owner.
137      *
138      * NOTE: Renouncing ownership will leave the contract without an owner,
139      * thereby removing any functionality that is only available to the owner.
140      */
141     function renounceOwnership() public virtual onlyOwner {
142         _transferOwnership(address(0));
143     }
144 
145     /**
146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
147      * Can only be called by the current owner.
148      */
149     function transferOwnership(address newOwner) public virtual onlyOwner {
150         require(newOwner != address(0), "Ownable: new owner is the zero address");
151         _transferOwnership(newOwner);
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Internal function without access restriction.
157      */
158     function _transferOwnership(address newOwner) internal virtual {
159         address oldOwner = _owner;
160         _owner = newOwner;
161         emit OwnershipTransferred(oldOwner, newOwner);
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
166 
167 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Interface of the ERC165 standard, as defined in the
173  * https://eips.ethereum.org/EIPS/eip-165[EIP].
174  *
175  * Implementers can declare support of contract interfaces, which can then be
176  * queried by others ({ERC165Checker}).
177  *
178  * For an implementation, see {ERC165}.
179  */
180 interface IERC165 {
181     /**
182      * @dev Returns true if this contract implements the interface defined by
183      * `interfaceId`. See the corresponding
184      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
185      * to learn more about how these ids are created.
186      *
187      * This function call must use less than 30 000 gas.
188      */
189     function supportsInterface(bytes4 interfaceId) external view returns (bool);
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Required interface of an ERC721 compliant contract.
200  */
201 interface IERC721 is IERC165 {
202     /**
203      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
206 
207     /**
208      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
209      */
210     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
214      */
215     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
216 
217     /**
218      * @dev Returns the number of tokens in ``owner``'s account.
219      */
220     function balanceOf(address owner) external view returns (uint256 balance);
221 
222     /**
223      * @dev Returns the owner of the `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function ownerOf(uint256 tokenId) external view returns (address owner);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
233      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must exist and be owned by `from`.
240      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
242      *
243      * Emits a {Transfer} event.
244      */
245     function safeTransferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external;
250 
251     /**
252      * @dev Transfers `tokenId` token from `from` to `to`.
253      *
254      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
273      * The approval is cleared when the token is transferred.
274      *
275      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
276      *
277      * Requirements:
278      *
279      * - The caller must own the token or be an approved operator.
280      * - `tokenId` must exist.
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address to, uint256 tokenId) external;
285 
286     /**
287      * @dev Returns the account approved for `tokenId` token.
288      *
289      * Requirements:
290      *
291      * - `tokenId` must exist.
292      */
293     function getApproved(uint256 tokenId) external view returns (address operator);
294 
295     /**
296      * @dev Approve or remove `operator` as an operator for the caller.
297      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
298      *
299      * Requirements:
300      *
301      * - The `operator` cannot be the caller.
302      *
303      * Emits an {ApprovalForAll} event.
304      */
305     function setApprovalForAll(address operator, bool _approved) external;
306 
307     /**
308      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
309      *
310      * See {setApprovalForAll}
311      */
312     function isApprovedForAll(address owner, address operator) external view returns (bool);
313 
314     /**
315      * @dev Safely transfers `tokenId` token from `from` to `to`.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must exist and be owned by `from`.
322      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
323      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
324      *
325      * Emits a {Transfer} event.
326      */
327     function safeTransferFrom(
328         address from,
329         address to,
330         uint256 tokenId,
331         bytes calldata data
332     ) external;
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
336 
337 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @title ERC721 token receiver interface
343  * @dev Interface for any contract that wants to support safeTransfers
344  * from ERC721 asset contracts.
345  */
346 interface IERC721Receiver {
347     /**
348      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
349      * by `operator` from `from`, this function is called.
350      *
351      * It must return its Solidity selector to confirm the token transfer.
352      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
353      *
354      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
355      */
356     function onERC721Received(
357         address operator,
358         address from,
359         uint256 tokenId,
360         bytes calldata data
361     ) external returns (bytes4);
362 }
363 
364 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
365 
366 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
372  * @dev See https://eips.ethereum.org/EIPS/eip-721
373  */
374 interface IERC721Metadata is IERC721 {
375     /**
376      * @dev Returns the token collection name.
377      */
378     function name() external view returns (string memory);
379 
380     /**
381      * @dev Returns the token collection symbol.
382      */
383     function symbol() external view returns (string memory);
384 
385     /**
386      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
387      */
388     function tokenURI(uint256 tokenId) external view returns (string memory);
389 }
390 
391 // File: @openzeppelin/contracts/utils/Strings.sol
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev String operations.
399  */
400 library Strings {
401     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
402 
403     /**
404      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
405      */
406     function toString(uint256 value) internal pure returns (string memory) {
407         // Inspired by OraclizeAPI's implementation - MIT licence
408         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
409 
410         if (value == 0) {
411             return "0";
412         }
413         uint256 temp = value;
414         uint256 digits;
415         while (temp != 0) {
416             digits++;
417             temp /= 10;
418         }
419         bytes memory buffer = new bytes(digits);
420         while (value != 0) {
421             digits -= 1;
422             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
423             value /= 10;
424         }
425         return string(buffer);
426     }
427 
428     /**
429      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
430      */
431     function toHexString(uint256 value) internal pure returns (string memory) {
432         if (value == 0) {
433             return "0x00";
434         }
435         uint256 temp = value;
436         uint256 length = 0;
437         while (temp != 0) {
438             length++;
439             temp >>= 8;
440         }
441         return toHexString(value, length);
442     }
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
446      */
447     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
448         bytes memory buffer = new bytes(2 * length + 2);
449         buffer[0] = "0";
450         buffer[1] = "x";
451         for (uint256 i = 2 * length + 1; i > 1; --i) {
452             buffer[i] = _HEX_SYMBOLS[value & 0xf];
453             value >>= 4;
454         }
455         require(value == 0, "Strings: hex length insufficient");
456         return string(buffer);
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @dev Implementation of the {IERC165} interface.
468  *
469  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
470  * for the additional interface id that will be supported. For example:
471  *
472  * ```solidity
473  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
475  * }
476  * ```
477  *
478  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
479  */
480 abstract contract ERC165 is IERC165 {
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      */
484     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485         return interfaceId == type(IERC165).interfaceId;
486     }
487 }
488 
489 // File: contracts/Address.sol
490 
491 pragma solidity ^0.8.6;
492 
493 library Address {
494     function isContract(address account) internal view returns (bool) {
495         uint size;
496         assembly {
497             size := extcodesize(account)
498         }
499         return size > 0;
500     }
501 }
502 
503 // File: contracts/ERC721.sol
504 
505 
506 pragma solidity ^0.8.7;
507 
508 
509 
510 
511 
512 
513 
514 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
515     using Address for address;
516     using Strings for uint256;
517     
518     string private _name;
519     string private _symbol;
520 
521     // Mapping from token ID to owner address
522     address[] internal _owners;
523 
524     mapping(uint256 => address) private _tokenApprovals;
525     mapping(address => mapping(address => bool)) private _operatorApprovals;
526 
527     /**
528      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
529      */
530     constructor(string memory name_, string memory symbol_) {
531         _name = name_;
532         _symbol = symbol_;
533     }
534 
535     /**
536      * @dev See {IERC165-supportsInterface}.
537      */
538     function supportsInterface(bytes4 interfaceId)
539         public
540         view
541         virtual
542         override(ERC165, IERC165)
543         returns (bool)
544     {
545         return
546             interfaceId == type(IERC721).interfaceId ||
547             interfaceId == type(IERC721Metadata).interfaceId ||
548             super.supportsInterface(interfaceId);
549     }
550 
551     /**
552      * @dev See {IERC721-balanceOf}.
553      */
554     function balanceOf(address owner) 
555         public 
556         view 
557         virtual 
558         override 
559         returns (uint) 
560     {
561         require(owner != address(0), "ERC721: balance query for the zero address");
562 
563         uint count;
564         for( uint i; i < _owners.length; ++i ){
565           if( owner == _owners[i] )
566             ++count;
567         }
568         return count;
569     }
570 
571     /**
572      * @dev See {IERC721-ownerOf}.
573      */
574     function ownerOf(uint256 tokenId)
575         public
576         view
577         virtual
578         override
579         returns (address)
580     {
581         address owner = _owners[tokenId];
582         require(
583             owner != address(0),
584             "ERC721: owner query for nonexistent token"
585         );
586         return owner;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-name}.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-symbol}.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev See {IERC721-approve}.
605      */
606     function approve(address to, uint256 tokenId) public virtual override {
607         address owner = ERC721.ownerOf(tokenId);
608         require(to != owner, "ERC721: approval to current owner");
609 
610         require(
611             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
612             "ERC721: approve caller is not owner nor approved for all"
613         );
614 
615         _approve(to, tokenId);
616     }
617 
618     /**
619      * @dev See {IERC721-getApproved}.
620      */
621     function getApproved(uint256 tokenId)
622         public
623         view
624         virtual
625         override
626         returns (address)
627     {
628         require(
629             _exists(tokenId),
630             "ERC721: approved query for nonexistent token"
631         );
632 
633         return _tokenApprovals[tokenId];
634     }
635 
636     /**
637      * @dev See {IERC721-setApprovalForAll}.
638      */
639     function setApprovalForAll(address operator, bool approved)
640         public
641         virtual
642         override
643     {
644         require(operator != _msgSender(), "ERC721: approve to caller");
645 
646         _operatorApprovals[_msgSender()][operator] = approved;
647         emit ApprovalForAll(_msgSender(), operator, approved);
648     }
649 
650     /**
651      * @dev See {IERC721-isApprovedForAll}.
652      */
653     function isApprovedForAll(address owner, address operator)
654         public
655         view
656         virtual
657         override
658         returns (bool)
659     {
660         return _operatorApprovals[owner][operator];
661     }
662 
663     /**
664      * @dev See {IERC721-transferFrom}.
665      */
666     function transferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) public virtual override {
671         //solhint-disable-next-line max-line-length
672         require(
673             _isApprovedOrOwner(_msgSender(), tokenId),
674             "ERC721: transfer caller is not owner nor approved"
675         );
676 
677         _transfer(from, to, tokenId);
678     }
679 
680     /**
681      * @dev See {IERC721-safeTransferFrom}.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) public virtual override {
688         safeTransferFrom(from, to, tokenId, "");
689     }
690 
691     /**
692      * @dev See {IERC721-safeTransferFrom}.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes memory _data
699     ) public virtual override {
700         require(
701             _isApprovedOrOwner(_msgSender(), tokenId),
702             "ERC721: transfer caller is not owner nor approved"
703         );
704         _safeTransfer(from, to, tokenId, _data);
705     }
706 
707     /**
708      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
709      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
710      *
711      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
712      *
713      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
714      * implement alternative mechanisms to perform token transfer, such as signature-based.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `tokenId` token must exist and be owned by `from`.
721      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
722      *
723      * Emits a {Transfer} event.
724      */
725     function _safeTransfer(
726         address from,
727         address to,
728         uint256 tokenId,
729         bytes memory _data
730     ) internal virtual {
731         _transfer(from, to, tokenId);
732         require(
733             _checkOnERC721Received(from, to, tokenId, _data),
734             "ERC721: transfer to non ERC721Receiver implementer"
735         );
736     }
737 
738     /**
739      * @dev Returns whether `tokenId` exists.
740      *
741      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
742      *
743      * Tokens start existing when they are minted (`_mint`),
744      * and stop existing when they are burned (`_burn`).
745      */
746     function _exists(uint256 tokenId) internal view virtual returns (bool) {
747         return tokenId < _owners.length && _owners[tokenId] != address(0);
748     }
749 
750     /**
751      * @dev Returns whether `spender` is allowed to manage `tokenId`.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      */
757     function _isApprovedOrOwner(address spender, uint256 tokenId)
758         internal
759         view
760         virtual
761         returns (bool)
762     {
763         require(
764             _exists(tokenId),
765             "ERC721: operator query for nonexistent token"
766         );
767         address owner = ERC721.ownerOf(tokenId);
768         return (spender == owner ||
769             getApproved(tokenId) == spender ||
770             isApprovedForAll(owner, spender));
771     }
772 
773     /**
774      * @dev Safely mints `tokenId` and transfers it to `to`.
775      *
776      * Requirements:
777      *
778      * - `tokenId` must not exist.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _safeMint(address to, uint256 tokenId) internal virtual {
784         _safeMint(to, tokenId, "");
785     }
786 
787     /**
788      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
789      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
790      */
791     function _safeMint(
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) internal virtual {
796         _mint(to, tokenId);
797         require(
798             _checkOnERC721Received(address(0), to, tokenId, _data),
799             "ERC721: transfer to non ERC721Receiver implementer"
800         );
801     }
802 
803     /**
804      * @dev Mints `tokenId` and transfers it to `to`.
805      *
806      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
807      *
808      * Requirements:
809      *
810      * - `tokenId` must not exist.
811      * - `to` cannot be the zero address.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _mint(address to, uint256 tokenId) internal virtual {
816         require(to != address(0), "ERC721: mint to the zero address");
817         require(!_exists(tokenId), "ERC721: token already minted");
818 
819         _beforeTokenTransfer(address(0), to, tokenId);
820         _owners.push(to);
821 
822         emit Transfer(address(0), to, tokenId);
823     }
824 
825     /**
826      * @dev Destroys `tokenId`.
827      * The approval is cleared when the token is burned.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _burn(uint256 tokenId) internal virtual {
836         address owner = ERC721.ownerOf(tokenId);
837 
838         _beforeTokenTransfer(owner, address(0), tokenId);
839 
840         // Clear approvals
841         _approve(address(0), tokenId);
842         _owners[tokenId] = address(0);
843 
844         emit Transfer(owner, address(0), tokenId);
845     }
846 
847     /**
848      * @dev Transfers `tokenId` from `from` to `to`.
849      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
850      *
851      * Requirements:
852      *
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _transfer(
859         address from,
860         address to,
861         uint256 tokenId
862     ) internal virtual {
863         require(
864             ERC721.ownerOf(tokenId) == from,
865             "ERC721: transfer of token that is not own"
866         );
867         require(to != address(0), "ERC721: transfer to the zero address");
868 
869         _beforeTokenTransfer(from, to, tokenId);
870 
871         // Clear approvals from the previous owner
872         _approve(address(0), tokenId);
873         _owners[tokenId] = to;
874 
875         emit Transfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev Approve `to` to operate on `tokenId`
880      *
881      * Emits a {Approval} event.
882      */
883     function _approve(address to, uint256 tokenId) internal virtual {
884         _tokenApprovals[tokenId] = to;
885         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
903     ) private returns (bool) {
904         if (to.isContract()) {
905             try
906                 IERC721Receiver(to).onERC721Received(
907                     _msgSender(),
908                     from,
909                     tokenId,
910                     _data
911                 )
912             returns (bytes4 retval) {
913                 return retval == IERC721Receiver.onERC721Received.selector;
914             } catch (bytes memory reason) {
915                 if (reason.length == 0) {
916                     revert(
917                         "ERC721: transfer to non ERC721Receiver implementer"
918                     );
919                 } else {
920                     assembly {
921                         revert(add(32, reason), mload(reason))
922                     }
923                 }
924             }
925         } else {
926             return true;
927         }
928     }
929 
930     /**
931      * @dev Hook that is called before any token transfer. This includes minting
932      * and burning.
933      *
934      * Calling conditions:
935      *
936      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
937      * transferred to `to`.
938      * - When `from` is zero, `tokenId` will be minted for `to`.
939      * - When `to` is zero, ``from``'s `tokenId` will be burned.
940      * - `from` and `to` are never both zero.
941      *
942      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
943      */
944     function _beforeTokenTransfer(
945         address from,
946         address to,
947         uint256 tokenId
948     ) internal virtual {}
949 }
950 
951 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
952 
953 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 /**
958  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
959  * @dev See https://eips.ethereum.org/EIPS/eip-721
960  */
961 interface IERC721Enumerable is IERC721 {
962     /**
963      * @dev Returns the total amount of tokens stored by the contract.
964      */
965     function totalSupply() external view returns (uint256);
966 
967     /**
968      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
969      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
970      */
971     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
972 
973     /**
974      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
975      * Use along with {totalSupply} to enumerate all tokens.
976      */
977     function tokenByIndex(uint256 index) external view returns (uint256);
978 }
979 
980 // File: contracts/ERC721Enumerable.sol
981 
982 
983 pragma solidity ^0.8.7;
984 
985 
986 /**
987  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
988  * enumerability of all the token ids in the contract as well as all token ids owned by each
989  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
990  */
991 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
992     /**
993      * @dev See {IERC165-supportsInterface}.
994      */
995     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
996         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
997     }
998 
999     /**
1000      * @dev See {IERC721Enumerable-totalSupply}.
1001      */
1002     function totalSupply() public view virtual override returns (uint256) {
1003         return _owners.length;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Enumerable-tokenByIndex}.
1008      */
1009     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1010         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
1011         return index;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1016      */
1017     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1018         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1019 
1020         uint count;
1021         for(uint i; i < _owners.length; i++){
1022             if(owner == _owners[i]){
1023                 if(count == index) return i;
1024                 else count++;
1025             }
1026         }
1027 
1028         revert("ERC721Enumerable: owner index out of bounds");
1029     }
1030 }
1031 
1032 // File: contracts/CryptoVenus.sol
1033 
1034 /**
1035   SPDX-License-Identifier: GPL-3.0
1036   Artist & Creator: ericareiling.eth
1037   Developer: jabeo.eth
1038   CryptoVenus NFT 
1039 
1040 
1041 ////////////////////////////////////////////////-//-----------------------------
1042 //////////////////////////////////////////////////-/----------------------------
1043 ///////////////////////////////////////////////////-----------------------------
1044 -///////////////////////////////////////////////-//----------------/------------
1045         .,-////////////////////////@@@@@@@@@@@/-//-------------------------////
1046                             .,--/@@@@@@@@@@@@@@@@@////---/-/-//----/-/--////////
1047                             @@@@@@@@@@@@@@@@@@@@@@@-/-////////////////////////
1048                         ,@@@@@@@@@@@.....,-/((#@@@@  .--///-/////////////////
1049                         @@@@@@@@@@@@@,%##..,-///(##@@@         .---/////////////
1050                     @@@@@@@@@@@@@@/.,,-.-,,-///###@@@                 ,----/-//
1051                     @@@@@@@@@@@@@@-, .--(..-(#(###@@@                           
1052                     #@@@@@@@@@@-,,,,/-(,,(#((-#@@@                            
1053             .   . ..   (@@@@@@@%,,.,.%(/(((#((/@@@@ .                          
1054 .      ....  ...  ..   .@@@@@@(#,...&-%%&%%#/-@@@      .                      
1055     .     . ......          @@@-,.#..--%%%%@/--@@@@. . ..                      
1056 .    .........  ...           %%%....,((,#%%(-#-.           .                   
1057 .  .... .  .. .. .       /(%%%%#.,-, (.#%/#-(-                                
1058 . ..... . ...   ..-((/(////######((,   (((#%-(/////((((((((((((/(/#(###(((#(%%
1059 .   . . .....   .-((/////////%/(/((///- .--///-,-------/////(/(////////(((((((((
1060 . .  . .,,##((#(###-//--/////(/////#--,,---/(,/-/--------((/(/(((//////////////
1061 ###%%%##((((((((#(/(-/(--/--////////--,-,%/-(--,--------(/(-((/((/(((((((((///(/
1062 ((((((((((((-/(((/-/--#(//----/-(--/-,,--/%//--.-//----(((/-///((((((((/(//////(
1063 ###(#(((#((##((///#-/--(//-----------,-(--/---, -------(//-((//(&%%&%&%###%&&&&&
1064 #(##%&%%##%##(//(%//%-(#(-------------,#,//--/------/--(/---//##########&%&%%%%%
1065 @#&%%&@&%####((##((/%//(-----/--------#%,#----,(/-/(---/(/--/(((###%##&%&%&%%%&&
1066 #%%%%%#####%##(/(#(//(###/////--------#(//-//-/-/--/////(/-//###%%%#%#%%&%%%#%&%
1067 #//########%#((##/%/#///(%%%%####%%#-/(&/--%((%%%%,-----///-/###%%##%##%&%%%%%%%
1068 &((&&(#@%%#%((####/%(%%#####(//(((/--,%(#----%%-((-%%%%%(--//#####(#############
1069 (@#@&&%%%%%%/(##%///&#%%/#####/-,-----%-#--/(,----#(#%%#/---/(#####(#(%######(((
1070 -(&@#&&%%%%%%((/#(/(&%(%%(/%####---//--/-////-%/%#(##-/--/-/(#(#%%&&%#%(##%%%%%&
1071 %%##%##%#%%%%%#//(((%%%#%(#(#%#(///---((-//(/--,-##---//////(#//#%(&(&%%@%%&%@#%
1072 &%(%###%%%%%#%%%%#(/###%@@@@@@@@@@-&&&/-/@@@@#--@#/#%%&%%%//((((%%%&@/@-@/&@/@.%
1073 ##%##%%%%%#%%#%((#%%%/(%/((/%((////-//&,(/-&@%&/@#@@@@@&&%%###((#%##(((((#(#((##
1074 &@@#%%%((((%/((((//(%%/(-%%/(/(////-//--(((#/%,#&&#(&@@@/(##%%%###(#(#((((((((##
1075 /@#%@&%#(((%(((%%%%%(/((//%(((/((((/--(,%((#-(#%((%&((##(#/((#%#&######(#(((((((
1076 %%@@&%%#(((#%#((/(//(/(//##//(((((#(/-,-((/#(%(,/((#(((((((((((((((#@@##%%%&#%#%
1077 
1078  */
1079 
1080 pragma solidity ^0.8.7;
1081 
1082 
1083 
1084 contract CryptoVenus is ERC721Enumerable, Ownable {
1085 
1086   string  public              baseURI;
1087   
1088   address public              proxyRegistryAddress;
1089 
1090   bytes32 public              giftlistMerkleRoot;
1091   bytes32 public              allowlistMerkleRoot;
1092 
1093   bool    public              isPublicMintOpen      = false;
1094 
1095   uint256 public constant     MAX_SUPPLY            = 10000;
1096 
1097   uint256 public constant     MINT_ALLOWANCE        = 10;
1098   uint256 public constant     GIFT_ALLOWANCE        = 1;
1099   uint256 public constant     allowlistPrice        = 0.08 ether;
1100   uint256 public constant     mintPrice             = 0.1 ether;
1101 
1102   mapping(address => bool) public projectProxy;
1103   mapping(address => uint) public giftAddressToMinted;
1104   mapping(address => uint) public addressToMinted;
1105 
1106   constructor(
1107       string memory _baseURI, 
1108       address _proxyRegistryAddress
1109   )
1110       ERC721("CryptoVenus", "VENUS")
1111   {
1112       baseURI = _baseURI;
1113       proxyRegistryAddress = _proxyRegistryAddress;
1114   }
1115 
1116   // Token URI
1117 
1118   function setBaseURI(string memory _baseURI) public onlyOwner {
1119       baseURI = _baseURI;
1120   }
1121 
1122   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1123       require(_exists(_tokenId), "Token does not exist.");
1124       return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1125   }
1126 
1127   // Proxy Registry
1128 
1129   function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1130       proxyRegistryAddress = _proxyRegistryAddress;
1131   }
1132 
1133   function flipProxyState(address proxyAddress) public onlyOwner {
1134       projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1135   }
1136 
1137   // Merkle Trees
1138 
1139   function _leaf(string memory payload) internal pure returns (bytes32) {
1140       return keccak256(abi.encodePacked(payload));
1141   }
1142 
1143   // Gift List
1144 
1145   function setGiftListMerkleRoot(bytes32 _giftlistMerkleRoot) external onlyOwner {
1146       giftlistMerkleRoot = _giftlistMerkleRoot;
1147   }
1148 
1149   function giftlistMint(uint256 count, bytes32[] calldata proof) public {
1150       uint256 totalSupply = _owners.length;
1151       string memory payload = string(abi.encodePacked(_msgSender()));
1152       require(MerkleProof.verify(proof, giftlistMerkleRoot, _leaf(payload)), "Invalid Merkle Tree proof supplied.");
1153       require(giftAddressToMinted[_msgSender()] + count <= GIFT_ALLOWANCE, "Exceeds gift allowance"); 
1154       require(totalSupply + count <= MAX_SUPPLY, "Exceeds max supply.");
1155 
1156       giftAddressToMinted[_msgSender()] += count;
1157       for(uint i; i < count; i++) { 
1158           _mint(_msgSender(), totalSupply + i);
1159       }
1160   }
1161 
1162   // Allow List
1163 
1164   function setAllowlistMerkleRoot(bytes32 _allowlistMerkleRoot) external onlyOwner {
1165       allowlistMerkleRoot = _allowlistMerkleRoot;
1166   }
1167 
1168   function allowlistMint(uint256 count, bytes32[] calldata proof) public payable {
1169       uint256 totalSupply = _owners.length;
1170       string memory payload = string(abi.encodePacked(_msgSender()));
1171       require(MerkleProof.verify(proof, allowlistMerkleRoot, _leaf(payload)), "Invalid Merkle Tree proof supplied.");
1172       require(addressToMinted[_msgSender()] + count <= MINT_ALLOWANCE, "Exceeds minting allowance"); 
1173       require(totalSupply + count <= MAX_SUPPLY, "Exceeds max supply.");
1174       require(count * allowlistPrice == msg.value, "Insufficient funds provided.");
1175 
1176       addressToMinted[_msgSender()] += count;
1177       for(uint i; i < count; i++) { 
1178           _mint(_msgSender(), totalSupply + i);
1179       }
1180   }
1181 
1182   // Dev
1183 
1184   function devMint(uint256 count, address _to) external onlyOwner {
1185       uint256 totalSupply = _owners.length;
1186       require(totalSupply + count <= MAX_SUPPLY, "Exceeds max supply.");
1187       
1188       for(uint256 i; i < count; i++)
1189           _mint(_to, totalSupply + i);
1190   }
1191 
1192   // Public
1193 
1194   function publicMint(uint256 count) public payable {
1195       uint256 totalSupply = _owners.length;
1196       require(isPublicMintOpen, "Public mint is not open!");
1197       require(totalSupply + count <= MAX_SUPPLY, "Exceeds max supply.");
1198       require(addressToMinted[_msgSender()] + count <= MINT_ALLOWANCE, "Exceeds mint supply"); 
1199       require(count * mintPrice == msg.value, "Invalid funds provided.");
1200   
1201       for(uint i; i < count; i++) { 
1202           _mint(_msgSender(), totalSupply + i);
1203       }
1204   }
1205 
1206   function togglePublicSale() external onlyOwner {
1207       delete allowlistMerkleRoot;
1208       isPublicMintOpen = true;
1209   }
1210 
1211   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1212       uint256 tokenCount = balanceOf(_owner);
1213       if (tokenCount == 0) return new uint256[](0);
1214 
1215       uint256[] memory tokensId = new uint256[](tokenCount);
1216       for (uint256 i; i < tokenCount; i++) {
1217           tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1218       }
1219       return tokensId;
1220   }
1221 
1222   function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
1223       for (uint256 i = 0; i < _tokenIds.length; i++) {
1224           transferFrom(_from, _to, _tokenIds[i]);
1225       }
1226   }
1227 
1228   function batchSafeTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory data_) public {
1229       for (uint256 i = 0; i < _tokenIds.length; i++) {
1230           safeTransferFrom(_from, _to, _tokenIds[i], data_);
1231       }
1232   }
1233 
1234   function isOwnerOf(address account, uint256[] calldata _tokenIds) external view returns (bool){
1235       for(uint256 i; i < _tokenIds.length; ++i){
1236           if(_owners[_tokenIds[i]] != account)
1237               return false;
1238       }
1239 
1240       return true;
1241   }
1242 
1243   function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1244       OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1245       if (address(proxyRegistry.proxies(_owner)) == operator || projectProxy[operator]) return true;
1246       return super.isApprovedForAll(_owner, operator);
1247   }
1248 
1249   function _mint(address to, uint256 tokenId) internal virtual override {
1250       _owners.push(to);
1251       emit Transfer(address(0), to, tokenId);
1252   }
1253 
1254   function withdraw(address _wallet) public payable onlyOwner {
1255       require(payable(_wallet).send(address(this).balance));
1256   }
1257 
1258 }
1259 
1260 contract OwnableDelegateProxy { }
1261 contract OpenSeaProxyRegistry {
1262     mapping(address => OwnableDelegateProxy) public proxies;
1263 }