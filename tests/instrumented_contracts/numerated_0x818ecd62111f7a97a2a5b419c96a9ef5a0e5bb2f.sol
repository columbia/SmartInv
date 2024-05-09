1 // SPDX-License-Identifier: MIT
2 //Developer Info:
3 //Written by Ghazanfar Perdakh
4 //Email: uchihaghazanfar@gmail.com
5 //Whatsapp NO.: +923331578650
6 //fiverr: fiverr.com/ghazanfarperdakh
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 pragma solidity ^0.8.0;
66 /**
67  * @dev String operations.
68  */
69 library Strings {
70     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
74      */
75     function toString(uint256 value) internal pure returns (string memory) {
76         // Inspired by OraclizeAPI's implementation - MIT licence
77         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
78 
79         if (value == 0) {
80             return "0";
81         }
82         uint256 temp = value;
83         uint256 digits;
84         while (temp != 0) {
85             digits++;
86             temp /= 10;
87         }
88         bytes memory buffer = new bytes(digits);
89         while (value != 0) {
90             digits -= 1;
91             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
92             value /= 10;
93         }
94         return string(buffer);
95     }
96 
97 }
98 
99 // File: @openzeppelin/contracts/utils/Context.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 // File: @openzeppelin/contracts/access/Ownable.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 
134 /**
135  * @dev Contract module which provides a basic access control mechanism, where
136  * there is an account (an owner) that can be granted exclusive access to
137  * specific functions.
138  *
139  * By default, the owner account will be the one that deploys the contract. This
140  * can later be changed with {transferOwnership}.
141  *
142  * This module is used through inheritance. It will make available the modifier
143  * `onlyOwner`, which can be applied to your functions to restrict their use to
144  * the owner.
145  */
146 abstract contract Ownable is Context {
147     address private _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     /**
152      * @dev Initializes the contract setting the deployer as the initial owner.
153      */
154     constructor() {
155         _transferOwnership(_msgSender());
156     }
157 
158     /**
159      * @dev Returns the address of the current owner.
160      */
161     function owner() public view virtual returns (address) {
162         return _owner;
163     }
164 
165     /**
166      * @dev Throws if called by any account other than the owner.
167      */
168     modifier onlyOwner() {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     /**
174      * @dev Leaves the contract without owner. It will not be possible to call
175      * `onlyOwner` functions anymore. Can only be called by the current owner.
176      *
177      * NOTE: Renouncing ownership will leave the contract without an owner,
178      * thereby removing any functionality that is only available to the owner.
179      */
180     function renounceOwnership() public virtual onlyOwner {
181         _transferOwnership(address(0));
182     }
183 
184     /**
185      * @dev Transfers ownership of the contract to a new account (`newOwner`).
186      * Can only be called by the current owner.
187      */
188     function transferOwnership(address newOwner) public virtual onlyOwner {
189         require(newOwner != address(0), "Ownable: new owner is the zero address");
190         _transferOwnership(newOwner);
191     }
192 
193     /**
194      * @dev Transfers ownership of the contract to a new account (`newOwner`).
195      * Internal function without access restriction.
196      */
197     function _transferOwnership(address newOwner) internal virtual {
198         address oldOwner = _owner;
199         _owner = newOwner;
200         emit OwnershipTransferred(oldOwner, newOwner);
201     }
202 }
203 
204 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @title ERC721 token receiver interface
213  * @dev Interface for any contract that wants to support safeTransfers
214  * from ERC721 asset contracts.
215  */
216 interface IERC721Receiver {
217     /**
218      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
219      * by `operator` from `from`, this function is called.
220      *
221      * It must return its Solidity selector to confirm the token transfer.
222      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
223      *
224      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
225      */
226     function onERC721Received(
227         address operator,
228         address from,
229         uint256 tokenId,
230         bytes calldata data
231     ) external returns (bytes4);
232 }
233 
234 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Interface of the ERC165 standard, as defined in the
243  * https://eips.ethereum.org/EIPS/eip-165[EIP].
244  *
245  * Implementers can declare support of contract interfaces, which can then be
246  * queried by others ({ERC165Checker}).
247  *
248  * For an implementation, see {ERC165}.
249  */
250 interface IERC165 {
251     /**
252      * @dev Returns true if this contract implements the interface defined by
253      * `interfaceId`. See the corresponding
254      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
255      * to learn more about how these ids are created.
256      *
257      * This function call must use less than 30 000 gas.
258      */
259     function supportsInterface(bytes4 interfaceId) external view returns (bool);
260 }
261 
262 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
263 
264 
265 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 
270 /**
271  * @dev Implementation of the {IERC165} interface.
272  *
273  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
274  * for the additional interface id that will be supported. For example:
275  *
276  * ```solidity
277  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
278  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
279  * }
280  * ```
281  *
282  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
283  */
284 abstract contract ERC165 is IERC165 {
285     /**
286      * @dev See {IERC165-supportsInterface}.
287      */
288     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
289         return interfaceId == type(IERC165).interfaceId;
290     }
291 }
292 
293 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
294 
295 
296 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 
301 /**
302  * @dev Required interface of an ERC721 compliant contract.
303  */
304 interface IERC721 is IERC165 {
305     /**
306      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
307      */
308     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
309 
310     /**
311      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
312      */
313     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
314 
315     /**
316      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
317      */
318     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
319 
320     /**
321      * @dev Returns the number of tokens in ``owner``'s account.
322      */
323     function balanceOf(address owner) external view returns (uint256 balance);
324 
325     /**
326      * @dev Returns the owner of the `tokenId` token.
327      *
328      * Requirements:
329      *
330      * - `tokenId` must exist.
331      */
332     function ownerOf(uint256 tokenId) external view returns (address owner);
333 
334     /**
335      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
336      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
337      *
338      * Requirements:
339      *
340      * - `from` cannot be the zero address.
341      * - `to` cannot be the zero address.
342      * - `tokenId` token must exist and be owned by `from`.
343      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
344      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
345      *
346      * Emits a {Transfer} event.
347      */
348     function safeTransferFrom(
349         address from,
350         address to,
351         uint256 tokenId
352     ) external;
353 
354     /**
355      * @dev Transfers `tokenId` token from `from` to `to`.
356      *
357      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transferFrom(
369         address from,
370         address to,
371         uint256 tokenId
372     ) external;
373 
374     /**
375      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
376      * The approval is cleared when the token is transferred.
377      *
378      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
379      *
380      * Requirements:
381      *
382      * - The caller must own the token or be an approved operator.
383      * - `tokenId` must exist.
384      *
385      * Emits an {Approval} event.
386      */
387     function approve(address to, uint256 tokenId) external;
388 
389     /**
390      * @dev Returns the account approved for `tokenId` token.
391      *
392      * Requirements:
393      *
394      * - `tokenId` must exist.
395      */
396     function getApproved(uint256 tokenId) external view returns (address operator);
397 
398     /**
399      * @dev Approve or remove `operator` as an operator for the caller.
400      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
401      *
402      * Requirements:
403      *
404      * - The `operator` cannot be the caller.
405      *
406      * Emits an {ApprovalForAll} event.
407      */
408     function setApprovalForAll(address operator, bool _approved) external;
409 
410     /**
411      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
412      *
413      * See {setApprovalForAll}
414      */
415     function isApprovedForAll(address owner, address operator) external view returns (bool);
416 
417     /**
418      * @dev Safely transfers `tokenId` token from `from` to `to`.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId,
434         bytes calldata data
435     ) external;
436 }
437 
438 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 
446 /**
447  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
448  * @dev See https://eips.ethereum.org/EIPS/eip-721
449  */
450 interface IERC721Enumerable is IERC721 {
451     /**
452      * @dev Returns the total amount of tokens stored by the contract.
453      */
454     function totalSupply() external view returns (uint256);
455 
456     /**
457      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
458      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
459      */
460     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
461 
462     /**
463      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
464      * Use along with {totalSupply} to enumerate all tokens.
465      */
466     function tokenByIndex(uint256 index) external view returns (uint256);
467 }
468 
469 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
479  * @dev See https://eips.ethereum.org/EIPS/eip-721
480  */
481 interface IERC721Metadata is IERC721 {
482     /**
483      * @dev Returns the token collection name.
484      */
485     function name() external view returns (string memory);
486 
487     /**
488      * @dev Returns the token collection symbol.
489      */
490     function symbol() external view returns (string memory);
491 
492     /**
493      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
494      */
495     function tokenURI(uint256 tokenId) external view returns (string memory);
496 }
497 
498 // File: ERC2000000.sol
499 
500 
501 
502 pragma solidity ^0.8.7;
503 
504 
505 
506 
507 
508 
509 
510 
511 
512 
513 library Address {
514     function isContract(address account) internal view returns (bool) {
515         uint size;
516         assembly {
517             size := extcodesize(account)
518         }
519         return size > 0;
520     }
521 }
522 
523 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
524     using Address for address;
525     using Strings for uint256;
526     
527     string private _name;
528     string private _symbol;
529 
530     // Mapping from token ID to owner address
531     address[] internal _owners;
532 
533     mapping(uint256 => address) private _tokenApprovals;
534     mapping(address => mapping(address => bool)) private _operatorApprovals;
535 
536     /**
537      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
538      */
539     constructor(string memory name_, string memory symbol_) {
540         _name = name_;
541         _symbol = symbol_;
542     }
543 
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId)
548         public
549         view
550         virtual
551         override(ERC165, IERC165)
552         returns (bool)
553     {
554         return
555             interfaceId == type(IERC721).interfaceId ||
556             interfaceId == type(IERC721Metadata).interfaceId ||
557             super.supportsInterface(interfaceId);
558     }
559 
560     /**
561      * @dev See {IERC721-balanceOf}.
562      */
563     function balanceOf(address owner) 
564         public 
565         view 
566         virtual 
567         override 
568         returns (uint) 
569     {
570         require(owner != address(0), "ERC721: balance query for the zero address");
571 
572         uint count;
573         uint length= _owners.length;
574         for( uint i; i < length; ++i ){
575           if( owner == _owners[i] )
576             ++count;
577         }
578         delete length;
579         return count;
580     }
581 
582     /**
583      * @dev See {IERC721-ownerOf}.
584      */
585     function ownerOf(uint256 tokenId)
586         public
587         view
588         virtual
589         override
590         returns (address)
591     {
592         address owner = _owners[tokenId];
593         require(
594             owner != address(0),
595             "ERC721: owner query for nonexistent token"
596         );
597         return owner;
598     }
599 
600     /**
601      * @dev See {IERC721Metadata-name}.
602      */
603     function name() public view virtual override returns (string memory) {
604         return _name;
605     }
606 
607     /**
608      * @dev See {IERC721Metadata-symbol}.
609      */
610     function symbol() public view virtual override returns (string memory) {
611         return _symbol;
612     }
613 
614     /**
615      * @dev See {IERC721-approve}.
616      */
617     function approve(address to, uint256 tokenId) public virtual override {
618         address owner = ERC721.ownerOf(tokenId);
619         require(to != owner, "ERC721: approval to current owner");
620 
621         require(
622             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
623             "ERC721: approve caller is not owner nor approved for all"
624         );
625 
626         _approve(to, tokenId);
627     }
628 
629     /**
630      * @dev See {IERC721-getApproved}.
631      */
632     function getApproved(uint256 tokenId)
633         public
634         view
635         virtual
636         override
637         returns (address)
638     {
639         require(
640             _exists(tokenId),
641             "ERC721: approved query for nonexistent token"
642         );
643 
644         return _tokenApprovals[tokenId];
645     }
646 
647     /**
648      * @dev See {IERC721-setApprovalForAll}.
649      */
650     function setApprovalForAll(address operator, bool approved)
651         public
652         virtual
653         override
654     {
655         require(operator != _msgSender(), "ERC721: approve to caller");
656 
657         _operatorApprovals[_msgSender()][operator] = approved;
658         emit ApprovalForAll(_msgSender(), operator, approved);
659     }
660 
661     /**
662      * @dev See {IERC721-isApprovedForAll}.
663      */
664     function isApprovedForAll(address owner, address operator)
665         public
666         view
667         virtual
668         override
669         returns (bool)
670     {
671         return _operatorApprovals[owner][operator];
672     }
673 
674     /**
675      * @dev See {IERC721-transferFrom}.
676      */
677     function transferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) public virtual override {
682         //solhint-disable-next-line max-line-length
683         require(
684             _isApprovedOrOwner(_msgSender(), tokenId),
685             "ERC721: transfer caller is not owner nor approved"
686         );
687 
688         _transfer(from, to, tokenId);
689     }
690 
691     /**
692      * @dev See {IERC721-safeTransferFrom}.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) public virtual override {
699         safeTransferFrom(from, to, tokenId, "");
700     }
701 
702     /**
703      * @dev See {IERC721-safeTransferFrom}.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes memory _data
710     ) public virtual override {
711         require(
712             _isApprovedOrOwner(_msgSender(), tokenId),
713             "ERC721: transfer caller is not owner nor approved"
714         );
715         _safeTransfer(from, to, tokenId, _data);
716     }
717 
718     /**
719      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
720      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
721      *
722      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
723      *
724      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
725      * implement alternative mechanisms to perform token transfer, such as signature-based.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must exist and be owned by `from`.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _safeTransfer(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) internal virtual {
742         _transfer(from, to, tokenId);
743         require(
744             _checkOnERC721Received(from, to, tokenId, _data),
745             "ERC721: transfer to non ERC721Receiver implementer"
746         );
747     }
748 
749     /**
750      * @dev Returns whether `tokenId` exists.
751      *
752      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
753      *
754      * Tokens start existing when they are minted (`_mint`),
755      * and stop existing when they are burned (`_burn`).
756      */
757     function _exists(uint256 tokenId) internal view virtual returns (bool) {
758         return tokenId < _owners.length && _owners[tokenId] != address(0);
759     }
760 
761     /**
762      * @dev Returns whether `spender` is allowed to manage `tokenId`.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function _isApprovedOrOwner(address spender, uint256 tokenId)
769         internal
770         view
771         virtual
772         returns (bool)
773     {
774         require(
775             _exists(tokenId),
776             "ERC721: operator query for nonexistent token"
777         );
778         address owner = ERC721.ownerOf(tokenId);
779         return (spender == owner ||
780             getApproved(tokenId) == spender ||
781             isApprovedForAll(owner, spender));
782     }
783 
784     /**
785      * @dev Safely mints `tokenId` and transfers it to `to`.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must not exist.
790      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _safeMint(address to, uint256 tokenId) internal virtual {
795         _safeMint(to, tokenId, "");
796     }
797 
798     /**
799      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
800      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
801      */
802     function _safeMint(
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) internal virtual {
807         _mint(to, tokenId);
808         require(
809             _checkOnERC721Received(address(0), to, tokenId, _data),
810             "ERC721: transfer to non ERC721Receiver implementer"
811         );
812     }
813 
814     /**
815      * @dev Mints `tokenId` and transfers it to `to`.
816      *
817      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
818      *
819      * Requirements:
820      *
821      * - `tokenId` must not exist.
822      * - `to` cannot be the zero address.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _mint(address to, uint256 tokenId) internal virtual {
827         require(to != address(0), "ERC721: mint to the zero address");
828         require(!_exists(tokenId), "ERC721: token already minted");
829 
830         _beforeTokenTransfer(address(0), to, tokenId);
831         _owners.push(to);
832 
833         emit Transfer(address(0), to, tokenId);
834     }
835 
836     /**
837      * @dev Destroys `tokenId`.
838      * The approval is cleared when the token is burned.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _burn(uint256 tokenId) internal virtual {
847         address owner = ERC721.ownerOf(tokenId);
848 
849         _beforeTokenTransfer(owner, address(0), tokenId);
850 
851         // Clear approvals
852         _approve(address(0), tokenId);
853         _owners[tokenId] = address(0);
854 
855         emit Transfer(owner, address(0), tokenId);
856     }
857 
858     /**
859      * @dev Transfers `tokenId` from `from` to `to`.
860      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
861      *
862      * Requirements:
863      *
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must be owned by `from`.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _transfer(
870         address from,
871         address to,
872         uint256 tokenId
873     ) internal virtual {
874         require(
875             ERC721.ownerOf(tokenId) == from,
876             "ERC721: transfer of token that is not own"
877         );
878         require(to != address(0), "ERC721: transfer to the zero address");
879 
880         _beforeTokenTransfer(from, to, tokenId);
881 
882         // Clear approvals from the previous owner
883         _approve(address(0), tokenId);
884         _owners[tokenId] = to;
885 
886         emit Transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev Approve `to` to operate on `tokenId`
891      *
892      * Emits a {Approval} event.
893      */
894     function _approve(address to, uint256 tokenId) internal virtual {
895         _tokenApprovals[tokenId] = to;
896         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
897     }
898 
899     /**
900      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
901      * The call is not executed if the target address is not a contract.
902      *
903      * @param from address representing the previous owner of the given token ID
904      * @param to target address that will receive the tokens
905      * @param tokenId uint256 ID of the token to be transferred
906      * @param _data bytes optional data to send along with the call
907      * @return bool whether the call correctly returned the expected magic value
908      */
909     function _checkOnERC721Received(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) private returns (bool) {
915         if (to.isContract()) {
916             try
917                 IERC721Receiver(to).onERC721Received(
918                     _msgSender(),
919                     from,
920                     tokenId,
921                     _data
922                 )
923             returns (bytes4 retval) {
924                 return retval == IERC721Receiver.onERC721Received.selector;
925             } catch (bytes memory reason) {
926                 if (reason.length == 0) {
927                     revert(
928                         "ERC721: transfer to non ERC721Receiver implementer"
929                     );
930                 } else {
931                     assembly {
932                         revert(add(32, reason), mload(reason))
933                     }
934                 }
935             }
936         } else {
937             return true;
938         }
939     }
940 
941     /**
942      * @dev Hook that is called before any token transfer. This includes minting
943      * and burning.
944      *
945      * Calling conditions:
946      *
947      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
948      * transferred to `to`.
949      * - When `from` is zero, `tokenId` will be minted for `to`.
950      * - When `to` is zero, ``from``'s `tokenId` will be burned.
951      * - `from` and `to` are never both zero.
952      *
953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
954      */
955     function _beforeTokenTransfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) internal virtual {}
960 }
961 
962 
963 pragma solidity ^0.8.7;
964 
965 
966 /**
967  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
968  * enumerability of all the token ids in the contract as well as all token ids owned by each
969  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
970  */
971 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
972     /**
973      * @dev See {IERC165-supportsInterface}.
974      */
975     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
976         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
977     }
978 
979     /**
980      * @dev See {IERC721Enumerable-totalSupply}.
981      */
982     function totalSupply() public view virtual override returns (uint256) {
983         return _owners.length;
984     }
985 
986     /**
987      * @dev See {IERC721Enumerable-tokenByIndex}.
988      */
989     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
990         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
991         return index;
992     }
993 
994     /**
995      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
996      */
997     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
998         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
999 
1000         uint count;
1001         for(uint i; i < _owners.length; i++){
1002             if(owner == _owners[i]){
1003                 if(count == index) return i;
1004                 else count++;
1005             }
1006         }
1007 
1008         revert("ERC721Enumerable: owner index out of bounds");
1009     }
1010 }
1011     pragma solidity ^0.8.7;
1012 
1013     contract ONRYO888  is ERC721Enumerable,  Ownable {
1014     using Strings for uint256;
1015 
1016 
1017   string private uriPrefix = "";
1018   string private uriSuffix = ".json";
1019   string public hiddenURL = "ipfs://QmcxUHCpqQXCaoW7mHGdaYwD9XnHHn69LQxdUJXW45rXTJ/hidden.json";
1020 
1021   
1022   
1023 
1024   uint256 public cost = 0.0888 ether;
1025   uint256 public whiteListCost =0.0888 ether;
1026 
1027   uint8 public maxWLMintAmountPerWallet = 1;  
1028   mapping (address => uint8) public nftPerWLAddress;
1029    mapping (address => uint8) public nftPerAddress;
1030   uint16 public constant maxSupply = 888;
1031   uint8 public maxMintAmountPerWallet = 3;
1032 
1033 
1034   bool public WLpaused = false;
1035   bool public paused = true;
1036   bool public reveal = false;
1037 
1038   
1039   bytes32 public whitelistMerkleRoot = 0xcfea41ea735f36459157573e73601ffd579b02d350609e660b8d01b1dca3a857;
1040   
1041 
1042   constructor() ERC721("Onryo 888", "ONRYO") {
1043     
1044   }
1045  
1046   function mint(uint8 _mintAmount) external payable  {
1047     uint16 totalSupply = uint16(_owners.length);
1048     uint8 tokens =nftPerAddress[msg.sender];
1049     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1050     require(_mintAmount + tokens <= maxMintAmountPerWallet, "Exceeds max per transaction.");
1051 
1052     require(!paused, "The contract is paused!");
1053     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1054      for(uint8 i; i < _mintAmount; i++) {
1055     _mint(msg.sender, totalSupply + i);
1056      }
1057         nftPerAddress[msg.sender] = tokens + _mintAmount;
1058      delete totalSupply;
1059      delete _mintAmount;
1060   }
1061   
1062   function Reserve(uint8 _mintAmount, address _receiver) external onlyOwner {
1063     uint16 totalSupply = uint8(_owners.length);
1064     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1065     for(uint16 i; i < _mintAmount; i++) {
1066     _mint(_receiver , totalSupply + i);
1067      }
1068      delete _mintAmount;
1069      delete _receiver;
1070      delete totalSupply;
1071   }
1072 
1073 
1074    
1075   function tokenURI(uint256 _tokenId)
1076     public
1077     view
1078     virtual
1079     override
1080     returns (string memory)
1081   {
1082     require(
1083       _exists(_tokenId),
1084       "ERC721Metadata: URI query for nonexistent token"
1085     );
1086     
1087     if (reveal == false) {
1088       return hiddenURL;
1089     }
1090 
1091     
1092 
1093     string memory currentBaseURI = _baseURI();
1094     return bytes(currentBaseURI).length > 0
1095         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1096         : "";
1097   }
1098   function setRevealed() external onlyOwner {
1099     reveal = !reveal;
1100   }
1101    function setWLPaused() external onlyOwner {
1102     WLpaused = !WLpaused;
1103   }
1104   function setWLCost(uint256 _cost) external onlyOwner {
1105     whiteListCost = _cost;
1106     delete _cost;
1107   }
1108   function setMaxTxPerWlAddress(uint8 _limit) external onlyOwner{
1109     maxWLMintAmountPerWallet = _limit;
1110    delete _limit;
1111 
1112 }
1113 function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1114         whitelistMerkleRoot = _whitelistMerkleRoot;
1115     }
1116 
1117     
1118     function getLeafNode(address _leaf) internal pure returns (bytes32 temp)
1119     {
1120         return keccak256(abi.encodePacked(_leaf));
1121     }
1122     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1123         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1124     }
1125 
1126 function whitelistMint(uint8 _mintAmount, bytes32[] calldata merkleProof) external payable {
1127         
1128        bytes32  leafnode = getLeafNode(msg.sender);
1129         uint8 tokens =nftPerWLAddress[msg.sender] ;
1130        require(_verify(leafnode ,   merkleProof   ),  "Invalid merkle proof");
1131        require (tokens + _mintAmount <= maxWLMintAmountPerWallet, "Exceeds max tx per address");
1132       
1133 
1134 
1135     require(!WLpaused, "Whitelist minting is over!");
1136     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1137 
1138        uint16 totalSupply = uint16(_owners.length);
1139     for(uint8 i; i < _mintAmount; i++) {
1140     _mint(msg.sender , totalSupply + i);
1141      }
1142       nftPerWLAddress[msg.sender] = _mintAmount + tokens;
1143       delete totalSupply;
1144       delete _mintAmount;
1145       
1146     
1147     }
1148   function setHiddenMetadataUri(string memory _hiddenMetadataUri) external onlyOwner {
1149     hiddenURL = _hiddenMetadataUri;
1150   }
1151   
1152  
1153 
1154   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1155     uriPrefix = _uriPrefix;
1156   }
1157 
1158 
1159   function setPaused() external onlyOwner {
1160     paused = !paused;
1161     WLpaused = true;
1162   }
1163 
1164   function setCost(uint _cost) external onlyOwner{
1165       cost = _cost;
1166 
1167   }
1168 
1169 
1170   function setMaxMintAmountPerWallet(uint8 _maxtx) external onlyOwner{
1171       maxMintAmountPerWallet = _maxtx;
1172 
1173   }
1174 
1175  
1176 
1177   function withdraw() external onlyOwner {
1178   uint _balance = address(this).balance;
1179      payable(msg.sender).transfer(_balance ); 
1180        
1181   }
1182 
1183    function _mint(address to, uint256 tokenId) internal virtual override {
1184         _owners.push(to);
1185         emit Transfer(address(0), to, tokenId);
1186     }
1187 
1188   function _baseURI() internal view  returns (string memory) {
1189     return uriPrefix;
1190   }
1191 }