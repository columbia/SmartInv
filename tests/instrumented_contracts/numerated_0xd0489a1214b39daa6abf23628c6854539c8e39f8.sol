1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-08
3  */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 // File: @openzeppelin/contracts/introspection/IERC165.sol
7 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
8 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
9 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
10 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
11 // File: @openzeppelin/contracts/introspection/ERC165.sol
12 // File: @openzeppelin/contracts/utils/Address.sol
13 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
14 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
15 // File: @openzeppelin/contracts/utils/Strings.sol
16 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
17 // File: @openzeppelin/contracts/access/Ownable.sol
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity ^0.8.0;
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Interface of the ERC165 standard, as defined in the
47  * https://eips.ethereum.org/EIPS/eip-165[EIP].
48  *
49  * Implementers can declare support of contract interfaces, which can then be
50  * queried by others ({ERC165Checker}).
51  *
52  * For an implementation, see {ERC165}.
53  */
54 interface IERC165 {
55     /**
56      * @dev Returns true if this contract implements the interface defined by
57      * `interfaceId`. See the corresponding
58      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
59      * to learn more about how these ids are created.
60      *
61      * This function call must use less than 30 000 gas.
62      */
63     function supportsInterface(bytes4 interfaceId) external view returns (bool);
64 }
65 
66 pragma solidity ^0.8.0;
67 
68 /**l
69  * @dev Implementation of the {IERC165} interface.
70  *
71  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
72  * for the additional interface id that will be supported. For example:
73  *
74  * ```solidity
75  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
76  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
77  * }
78  * ```
79  *
80  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
81  */
82 abstract contract ERC165 is IERC165 {
83     /**
84      * @dev See {IERC165-supportsInterface}.
85      */
86     function supportsInterface(bytes4 interfaceId)
87         public
88         view
89         virtual
90         override
91         returns (bool)
92     {
93         return interfaceId == type(IERC165).interfaceId;
94     }
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev String operations.
101  */
102 library Strings {
103     bytes16 private constant alphabet = "0123456789abcdef";
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
107      */
108     function toString(uint256 value) internal pure returns (string memory) {
109         // Inspired by OraclizeAPI's implementation - MIT licence
110         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
111 
112         if (value == 0) {
113             return "0";
114         }
115         uint256 temp = value;
116         uint256 digits;
117         while (temp != 0) {
118             digits++;
119             temp /= 10;
120         }
121         bytes memory buffer = new bytes(digits);
122         while (value != 0) {
123             digits -= 1;
124             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
125             value /= 10;
126         }
127         return string(buffer);
128     }
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
132      */
133     function toHexString(uint256 value) internal pure returns (string memory) {
134         if (value == 0) {
135             return "0x00";
136         }
137         uint256 temp = value;
138         uint256 length = 0;
139         while (temp != 0) {
140             length++;
141             temp >>= 8;
142         }
143         return toHexString(value, length);
144     }
145 
146     /**
147      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
148      */
149     function toHexString(uint256 value, uint256 length)
150         internal
151         pure
152         returns (string memory)
153     {
154         bytes memory buffer = new bytes(2 * length + 2);
155         buffer[0] = "0";
156         buffer[1] = "x";
157         for (uint256 i = 2 * length + 1; i > 1; --i) {
158             buffer[i] = alphabet[value & 0xf];
159             value >>= 4;
160         }
161         require(value == 0, "Strings: hex length insufficient");
162         return string(buffer);
163     }
164 }
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @dev Contract module which provides a basic access control mechanism, where
170  * there is an account (an owner) that can be granted exclusive access to
171  * specific functions.
172  *
173  * By default, the owner account will be the one that deploys the contract. This
174  * can later be changed with {transferOwnership}.
175  *`
176  * This module is used through inheritance. It will make available the modifier
177  * `onlyOwner`, which can be applied to your functions to restrict their use to
178  * the owner.
179  */
180 abstract contract Ownable is Context {
181     address private _owner;
182 
183     event OwnershipTransferred(
184         address indexed previousOwner,
185         address indexed newOwner
186     );
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor() {
192         address msgSender = _msgSender();
193         _owner = msgSender;
194         emit OwnershipTransferred(address(0), msgSender);
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         emit OwnershipTransferred(_owner, address(0));
221         _owner = address(0);
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(
230             newOwner != address(0),
231             "Ownable: new owner is the zero address"
232         );
233         emit OwnershipTransferred(_owner, newOwner);
234         _owner = newOwner;
235     }
236 }
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @title ERC721 token receiver interface
242  * @dev Interface for any contract that wants to support safeTransfers
243  * from ERC721 asset contracts.
244  */
245 interface IERC721Receiver {
246     /**
247      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
248      * by `operator` from `from`, this function is called.
249      *
250      * It must return its Solidity selector to confirm the token transfer.
251      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
252      *
253      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
254      */
255     function onERC721Received(
256         address operator,
257         address from,
258         uint256 tokenId,
259         bytes calldata data
260     ) external returns (bytes4);
261 }
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Required interface of an ERC721 compliant contract.
267  */
268 interface IERC721 is IERC165 {
269     /**
270      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
271      */
272     event Transfer(
273         address indexed from,
274         address indexed to,
275         uint256 indexed tokenId
276     );
277 
278     /**
279      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
280      */
281     event Approval(
282         address indexed owner,
283         address indexed approved,
284         uint256 indexed tokenId
285     );
286 
287     /**
288      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
289      */
290     event ApprovalForAll(
291         address indexed owner,
292         address indexed operator,
293         bool approved
294     );
295 
296     /**
297      * @dev Returns the number of tokens in ``owner``'s account.
298      */
299     function balanceOf(address owner) external view returns (uint256 balance);
300 
301     /**
302      * @dev Returns the owner of the `tokenId` token.
303      *
304      * Requirements:
305      *
306      * - `tokenId` must exist.
307      */
308     function ownerOf(uint256 tokenId) external view returns (address owner);
309 
310     /**
311      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
312      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
313      *
314      * Requirements:
315      *
316      * - `from` cannot be the zero address.
317      * - `to` cannot be the zero address.
318      * - `tokenId` token must exist and be owned by `from`.
319      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
320      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
321      *
322      * Emits a {Transfer} event.
323      */
324     function safeTransferFrom(
325         address from,
326         address to,
327         uint256 tokenId
328     ) external;
329 
330     /**
331      * @dev Transfers `tokenId` token from `from` to `to`.
332      *
333      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `tokenId` token must be owned by `from`.
340      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transferFrom(
345         address from,
346         address to,
347         uint256 tokenId
348     ) external;
349 
350     /**
351      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
352      * The approval is cleared when the token is transferred.
353      *
354      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
355      *
356      * Requirements:
357      *
358      * - The caller must own the token or be an approved operator.
359      * - `tokenId` must exist.
360      *
361      * Emits an {Approval} event.
362      */
363     function approve(address to, uint256 tokenId) external;
364 
365     /**
366      * @dev Returns the account approved for `tokenId` token.
367      *
368      * Requirements:
369      *
370      * - `tokenId` must exist.
371      */
372     function getApproved(uint256 tokenId)
373         external
374         view
375         returns (address operator);
376 
377     /**
378      * @dev Approve or remove `operator` as an operator for the caller.
379      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
380      *
381      * Requirements:
382      *
383      * - The `operator` cannot be the caller.
384      *
385      * Emits an {ApprovalForAll} event.
386      */
387     function setApprovalForAll(address operator, bool _approved) external;
388 
389     /**
390      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
391      *
392      * See {setApprovalForAll}
393      */
394     function isApprovedForAll(address owner, address operator)
395         external
396         view
397         returns (bool);
398 
399     /**
400      * @dev Safely transfers `tokenId` token from `from` to `to`.
401      *
402      * Requirements:
403      *
404      * - `from` cannot be the zero address.
405      * - `to` cannot be the zero address.
406      * - `tokenId` token must exist and be owned by `from`.
407      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
408      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
409      *
410      * Emits a {Transfer} event.
411      */
412     function safeTransferFrom(
413         address from,
414         address to,
415         uint256 tokenId,
416         bytes calldata data
417     ) external;
418 }
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
424  * @dev See https://eips.ethereum.org/EIPS/eip-721
425  */
426 interface IERC721Enumerable is IERC721 {
427     /**
428      * @dev Returns the total amount of tokens stored by the contract.
429      */
430     function totalSupply() external view returns (uint256);
431 
432     /**
433      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
434      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
435      */
436     function tokenOfOwnerByIndex(address owner, uint256 index)
437         external
438         view
439         returns (uint256 tokenId);
440 
441     /**
442      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
443      * Use along with {totalSupply} to enumerate all tokens.
444      */
445     function tokenByIndex(uint256 index) external view returns (uint256);
446 }
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
452  * @dev See https://eips.ethereum.org/EIPS/eip-721
453  */
454 interface IERC721Metadata is IERC721 {
455     /**
456      * @dev Returns the token collection name.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the token collection symbol.
462      */
463     function symbol() external view returns (string memory);
464 
465     /**
466      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
467      */
468     function tokenURI(uint256 tokenId) external view returns (string memory);
469 }
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
475  * the Metadata extension, but not including the Enumerable extension, which is available separately as
476  * {ERC721Enumerable}.
477  */
478 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
479     using Address for address;
480     using Strings for uint256;
481 
482     // Token name
483     string private _name;
484 
485     // Token symbol
486     string private _symbol;
487 
488     // Mapping from token ID to owner address
489     mapping(uint256 => address) private _owners;
490 
491     // Mapping owner address to token count
492     mapping(address => uint256) private _balances;
493 
494     // Mapping from token ID to approved address
495     mapping(uint256 => address) private _tokenApprovals;
496 
497     // Mapping from owner to operator approvals
498     mapping(address => mapping(address => bool)) private _operatorApprovals;
499 
500     /**
501      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
502      */
503     constructor(string memory name_, string memory symbol_) {
504         _name = name_;
505         _symbol = symbol_;
506     }
507 
508     /**
509      * @dev See {IERC165-supportsInterface}.
510      */
511     function supportsInterface(bytes4 interfaceId)
512         public
513         view
514         virtual
515         override(ERC165, IERC165)
516         returns (bool)
517     {
518         return
519             interfaceId == type(IERC721).interfaceId ||
520             interfaceId == type(IERC721Metadata).interfaceId ||
521             super.supportsInterface(interfaceId);
522     }
523 
524     /**
525      * @dev See {IERC721-balanceOf}.
526      */
527     function balanceOf(address owner)
528         public
529         view
530         virtual
531         override
532         returns (uint256)
533     {
534         require(
535             owner != address(0),
536             "ERC721: balance query for the zero address"
537         );
538         return _balances[owner];
539     }
540 
541     /**
542      * @dev See {IERC721-ownerOf}.
543      */
544     function ownerOf(uint256 tokenId)
545         public
546         view
547         virtual
548         override
549         returns (address)
550     {
551         address owner = _owners[tokenId];
552         require(
553             owner != address(0),
554             "ERC721: owner query for nonexistent token"
555         );
556         return owner;
557     }
558 
559     /**
560      * @dev See {IERC721Metadata-name}.
561      */
562     function name() public view virtual override returns (string memory) {
563         return _name;
564     }
565 
566     /**
567      * @dev See {IERC721Metadata-symbol}.
568      */
569     function symbol() public view virtual override returns (string memory) {
570         return _symbol;
571     }
572 
573     /**
574      * @dev See {IERC721Metadata-tokenURI}.
575      */
576     function tokenURI(uint256 tokenId)
577         public
578         view
579         virtual
580         override
581         returns (string memory)
582     {
583         require(
584             _exists(tokenId),
585             "ERC721Metadata: URI query for nonexistent token"
586         );
587 
588         string memory baseURI = _baseURI();
589         return
590             bytes(baseURI).length > 0
591                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
592                 : "";
593     }
594 
595     /**
596      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
597      * in child contracts.
598      */
599     function _baseURI() internal view virtual returns (string memory) {
600         return "";
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
747         return _owners[tokenId] != address(0);
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
820 
821         _balances[to] += 1;
822         _owners[tokenId] = to;
823 
824         emit Transfer(address(0), to, tokenId);
825     }
826 
827     /**
828      * @dev Destroys `tokenId`.
829      * The approval is cleared when the token is burned.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must exist.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _burn(uint256 tokenId) internal virtual {
838         address owner = ERC721.ownerOf(tokenId);
839 
840         _beforeTokenTransfer(owner, address(0), tokenId);
841 
842         // Clear approvals
843         _approve(address(0), tokenId);
844 
845         _balances[owner] -= 1;
846         delete _owners[tokenId];
847 
848         emit Transfer(owner, address(0), tokenId);
849     }
850 
851     /**
852      * @dev Transfers `tokenId` from `from` to `to`.
853      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must be owned by `from`.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _transfer(
863         address from,
864         address to,
865         uint256 tokenId
866     ) internal virtual {
867         require(
868             ERC721.ownerOf(tokenId) == from,
869             "ERC721: transfer of token that is not own"
870         );
871         require(to != address(0), "ERC721: transfer to the zero address");
872 
873         _beforeTokenTransfer(from, to, tokenId);
874 
875         // Clear approvals from the previous owner
876         _approve(address(0), tokenId);
877 
878         _balances[from] -= 1;
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev Approve `to` to operate on `tokenId`
887      *
888      * Emits a {Approval} event.
889      */
890     function _approve(address to, uint256 tokenId) internal virtual {
891         _tokenApprovals[tokenId] = to;
892         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
893     }
894 
895     /**
896      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
897      * The call is not executed if the target address is not a contract.
898      *
899      * @param from address representing the previous owner of the given token ID
900      * @param to target address that will receive the tokens
901      * @param tokenId uint256 ID of the token to be transferred
902      * @param _data bytes optional data to send along with the call
903      * @return bool whether the call correctly returned the expected magic value
904      */
905     function _checkOnERC721Received(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) private returns (bool) {
911         if (to.isContract()) {
912             try
913                 IERC721Receiver(to).onERC721Received(
914                     _msgSender(),
915                     from,
916                     tokenId,
917                     _data
918                 )
919             returns (bytes4 retval) {
920                 return retval == IERC721Receiver(to).onERC721Received.selector;
921             } catch (bytes memory reason) {
922                 if (reason.length == 0) {
923                     revert(
924                         "ERC721: transfer to non ERC721Receiver implementer"
925                     );
926                 } else {
927                     // solhint-disable-next-line no-inline-assembly
928                     assembly {
929                         revert(add(32, reason), mload(reason))
930                     }
931                 }
932             }
933         } else {
934             return true;
935         }
936     }
937 
938     /**
939      * @dev Hook that is called before any token transfer. This includes minting
940      * and burning.
941      *
942      * Calling conditions:
943      *
944      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
945      * transferred to `to`.
946      * - When `from` is zero, `tokenId` will be minted for `to`.
947      * - When `to` is zero, ``from``'s `tokenId` will be burned.
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      *
951      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
952      */
953     function _beforeTokenTransfer(
954         address from,
955         address to,
956         uint256 tokenId
957     ) internal virtual {}
958 }
959 
960 pragma solidity ^0.8.0;
961 
962 /**
963  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
964  * enumerability of all the token ids in the contract as well as all token ids owned by each
965  * account.
966  */
967 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
968     // Mapping from owner to list of owned token IDs
969     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
970 
971     // Mapping from token ID to index of the owner tokens list
972     mapping(uint256 => uint256) private _ownedTokensIndex;
973 
974     // Array with all token ids, used for enumeration
975     uint256[] private _allTokens;
976 
977     // Mapping from token id to position in the allTokens array
978     mapping(uint256 => uint256) private _allTokensIndex;
979 
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      */
983     function supportsInterface(bytes4 interfaceId)
984         public
985         view
986         virtual
987         override(IERC165, ERC721)
988         returns (bool)
989     {
990         return
991             interfaceId == type(IERC721Enumerable).interfaceId ||
992             super.supportsInterface(interfaceId);
993     }
994 
995     /**
996      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
997      */
998     function tokenOfOwnerByIndex(address owner, uint256 index)
999         public
1000         view
1001         virtual
1002         override
1003         returns (uint256)
1004     {
1005         require(
1006             index < ERC721.balanceOf(owner),
1007             "ERC721Enumerable: owner index out of bounds"
1008         );
1009         return _ownedTokens[owner][index];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Enumerable-totalSupply}.
1014      */
1015     function totalSupply() public view virtual override returns (uint256) {
1016         return _allTokens.length;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-tokenByIndex}.
1021      */
1022     function tokenByIndex(uint256 index)
1023         public
1024         view
1025         virtual
1026         override
1027         returns (uint256)
1028     {
1029         require(
1030             index < ERC721Enumerable.totalSupply(),
1031             "ERC721Enumerable: global index out of bounds"
1032         );
1033         return _allTokens[index];
1034     }
1035 
1036     /**
1037      * @dev Hook that is called before any token transfer. This includes minting
1038      * and burning.
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` will be minted for `to`.
1045      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      *
1049      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1050      */
1051     function _beforeTokenTransfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual override {
1056         super._beforeTokenTransfer(from, to, tokenId);
1057 
1058         if (from == address(0)) {
1059             _addTokenToAllTokensEnumeration(tokenId);
1060         } else if (from != to) {
1061             _removeTokenFromOwnerEnumeration(from, tokenId);
1062         }
1063         if (to == address(0)) {
1064             _removeTokenFromAllTokensEnumeration(tokenId);
1065         } else if (to != from) {
1066             _addTokenToOwnerEnumeration(to, tokenId);
1067         }
1068     }
1069 
1070     /**
1071      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1072      * @param to address representing the new owner of the given token ID
1073      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1074      */
1075     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1076         uint256 length = ERC721.balanceOf(to);
1077         _ownedTokens[to][length] = tokenId;
1078         _ownedTokensIndex[tokenId] = length;
1079     }
1080 
1081     /**
1082      * @dev Private function to add a token to this extension's token tracking data structures.
1083      * @param tokenId uint256 ID of the token to be added to the tokens list
1084      */
1085     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1086         _allTokensIndex[tokenId] = _allTokens.length;
1087         _allTokens.push(tokenId);
1088     }
1089 
1090     /**
1091      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1092      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1093      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1094      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1095      * @param from address representing the previous owner of the given token ID
1096      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1097      */
1098     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1099         private
1100     {
1101         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1102         // then delete the last slot (swap and pop).
1103 
1104         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1105         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1106 
1107         // When the token to delete is the last token, the swap operation is unnecessary
1108         if (tokenIndex != lastTokenIndex) {
1109             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1110 
1111             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1112             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1113         }
1114 
1115         // This also deletes the contents at the last position of the array
1116         delete _ownedTokensIndex[tokenId];
1117         delete _ownedTokens[from][lastTokenIndex];
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's token tracking data structures.
1122      * This has O(1) time complexity, but alters the order of the _allTokens array.
1123      * @param tokenId uint256 ID of the token to be removed from the tokens list
1124      */
1125     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1126         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1127         // then delete the last slot (swap and pop).
1128 
1129         uint256 lastTokenIndex = _allTokens.length - 1;
1130         uint256 tokenIndex = _allTokensIndex[tokenId];
1131 
1132         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1133         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1134         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1135         uint256 lastTokenId = _allTokens[lastTokenIndex];
1136 
1137         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139 
1140         // This also deletes the contents at the last position of the array
1141         delete _allTokensIndex[tokenId];
1142         _allTokens.pop();
1143     }
1144 }
1145 
1146 pragma solidity ^0.8.0;
1147 
1148 /**
1149  * @dev Collection of functions related to the address type
1150  */
1151 library Address {
1152     /**
1153      * @dev Returns true if `account` is a contract.
1154      *
1155      * [IMPORTANT]
1156      * ====
1157      * It is unsafe to assume that an address for which this function returns
1158      * false is an externally-owned account (EOA) and not a contract.
1159      *
1160      * Among others, `isContract` will return false for the following
1161      * types of addresses:
1162      *
1163      *  - an externally-owned account
1164      *  - a contract in construction
1165      *  - an address where a contract will be created
1166      *  - an address where a contract lived, but was destroyed
1167      * ====
1168      */
1169     function isContract(address account) internal view returns (bool) {
1170         // This method relies on extcodesize, which returns 0 for contracts in
1171         // construction, since the code is only stored at the end of the
1172         // constructor execution.
1173 
1174         uint256 size;
1175         // solhint-disable-next-line no-inline-assembly
1176         assembly {
1177             size := extcodesize(account)
1178         }
1179         return size > 0;
1180     }
1181 
1182     /**
1183      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1184      * `recipient`, forwarding all available gas and reverting on errors.
1185      *
1186      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1187      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1188      * imposed by `transfer`, making them unable to receive funds via
1189      * `transfer`. {sendValue} removes this limitation.
1190      *
1191      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1192      *
1193      * IMPORTANT: because control is transferred to `recipient`, care must be
1194      * taken to not create reentrancy vulnerabilities. Consider using
1195      * {ReentrancyGuard} or the
1196      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1197      */
1198     function sendValue(address payable recipient, uint256 amount) internal {
1199         require(
1200             address(this).balance >= amount,
1201             "Address: insufficient balance"
1202         );
1203 
1204         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1205         (bool success, ) = recipient.call{value: amount}("");
1206         require(
1207             success,
1208             "Address: unable to send value, recipient may have reverted"
1209         );
1210     }
1211 
1212     /**
1213      * @dev Performs a Solidity function call using a low level `call`. A
1214      * plain`call` is an unsafe replacement for a function call: use this
1215      * function instead.
1216      *
1217      * If `target` reverts with a revert reason, it is bubbled up by this
1218      * function (like regular Solidity function calls).
1219      *
1220      * Returns the raw returned data. To convert to the expected return value,
1221      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1222      *
1223      * Requirements:
1224      *
1225      * - `target` must be a contract.
1226      * - calling `target` with `data` must not revert.
1227      *
1228      * _Available since v3.1._
1229      */
1230     function functionCall(address target, bytes memory data)
1231         internal
1232         returns (bytes memory)
1233     {
1234         return functionCall(target, data, "Address: low-level call failed");
1235     }
1236 
1237     /**
1238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1239      * `errorMessage` as a fallback revert reason when `target` reverts.
1240      *
1241      * _Available since v3.1._
1242      */
1243     function functionCall(
1244         address target,
1245         bytes memory data,
1246         string memory errorMessage
1247     ) internal returns (bytes memory) {
1248         return functionCallWithValue(target, data, 0, errorMessage);
1249     }
1250 
1251     /**
1252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1253      * but also transferring `value` wei to `target`.
1254      *
1255      * Requirements:
1256      *
1257      * - the calling contract must have an ETH balance of at least `value`.
1258      * - the called Solidity function must be `payable`.
1259      *
1260      * _Available since v3.1._
1261      */
1262     function functionCallWithValue(
1263         address target,
1264         bytes memory data,
1265         uint256 value
1266     ) internal returns (bytes memory) {
1267         return
1268             functionCallWithValue(
1269                 target,
1270                 data,
1271                 value,
1272                 "Address: low-level call with value failed"
1273             );
1274     }
1275 
1276     /**
1277      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1278      * with `errorMessage` as a fallback revert reason when `target` reverts.
1279      *
1280      * _Available since v3.1._
1281      */
1282     function functionCallWithValue(
1283         address target,
1284         bytes memory data,
1285         uint256 value,
1286         string memory errorMessage
1287     ) internal returns (bytes memory) {
1288         require(
1289             address(this).balance >= value,
1290             "Address: insufficient balance for call"
1291         );
1292         require(isContract(target), "Address: call to non-contract");
1293 
1294         // solhint-disable-next-line avoid-low-level-calls
1295         (bool success, bytes memory returndata) = target.call{value: value}(
1296             data
1297         );
1298         return _verifyCallResult(success, returndata, errorMessage);
1299     }
1300 
1301     /**
1302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1303      * but performing a static call.
1304      *
1305      * _Available since v3.3._
1306      */
1307     function functionStaticCall(address target, bytes memory data)
1308         internal
1309         view
1310         returns (bytes memory)
1311     {
1312         return
1313             functionStaticCall(
1314                 target,
1315                 data,
1316                 "Address: low-level static call failed"
1317             );
1318     }
1319 
1320     /**
1321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1322      * but performing a static call.
1323      *
1324      * _Available since v3.3._
1325      */
1326     function functionStaticCall(
1327         address target,
1328         bytes memory data,
1329         string memory errorMessage
1330     ) internal view returns (bytes memory) {
1331         require(isContract(target), "Address: static call to non-contract");
1332 
1333         // solhint-disable-next-line avoid-low-level-calls
1334         (bool success, bytes memory returndata) = target.staticcall(data);
1335         return _verifyCallResult(success, returndata, errorMessage);
1336     }
1337 
1338     /**
1339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1340      * but performing a delegate call.
1341      *
1342      * _Available since v3.4._
1343      */
1344     function functionDelegateCall(address target, bytes memory data)
1345         internal
1346         returns (bytes memory)
1347     {
1348         return
1349             functionDelegateCall(
1350                 target,
1351                 data,
1352                 "Address: low-level delegate call failed"
1353             );
1354     }
1355 
1356     /**
1357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1358      * but performing a delegate call.
1359      *
1360      * _Available since v3.4._
1361      */
1362     function functionDelegateCall(
1363         address target,
1364         bytes memory data,
1365         string memory errorMessage
1366     ) internal returns (bytes memory) {
1367         require(isContract(target), "Address: delegate call to non-contract");
1368 
1369         // solhint-disable-next-line avoid-low-level-calls
1370         (bool success, bytes memory returndata) = target.delegatecall(data);
1371         return _verifyCallResult(success, returndata, errorMessage);
1372     }
1373 
1374     function _verifyCallResult(
1375         bool success,
1376         bytes memory returndata,
1377         string memory errorMessage
1378     ) private pure returns (bytes memory) {
1379         if (success) {
1380             return returndata;
1381         } else {
1382             // Look for revert reason and bubble it up if present
1383             if (returndata.length > 0) {
1384                 // The easiest way to bubble the revert reason is using memory via assembly
1385 
1386                 // solhint-disable-next-line no-inline-assembly
1387                 assembly {
1388                     let returndata_size := mload(returndata)
1389                     revert(add(32, returndata), returndata_size)
1390                 }
1391             } else {
1392                 revert(errorMessage);
1393             }
1394         }
1395     }
1396 }
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 contract echibi is ERC721Enumerable, Ownable {
1401     using Strings for uint256;
1402 
1403     string _baseTokenURI;
1404     uint256 private _price = 0.005 ether;
1405     bool public _paused = true;
1406 
1407     // withdraw addresses
1408     address t1 = 0x021F7a58649dB0b715401eb3a8b1353A667097Bc;
1409 
1410     constructor(string memory baseURI) ERC721("echibi", "chib") {
1411         setBaseURI(baseURI);
1412     }
1413 
1414     function mintChibi(uint256 num) public payable {
1415         uint256 supply = totalSupply();
1416         require(!_paused, "Sale paused");
1417         require(num < 6, "You can mint 5 chibis at a time");
1418         require(supply + num < 1000, "Exceeds chibi supply!");
1419         require(msg.value >= _price * num, "Ether sent is not correct");
1420 
1421         for (uint256 i; i < num; i++) {
1422             _safeMint(msg.sender, supply + i);
1423         }
1424     }
1425 
1426     // Mint value change if required.
1427     function setPrice(uint256 _newPrice) public onlyOwner {
1428         _price = _newPrice;
1429     }
1430 
1431     function _baseURI() internal view virtual override returns (string memory) {
1432         return _baseTokenURI;
1433     }
1434 
1435     function setBaseURI(string memory baseURI) public onlyOwner {
1436         _baseTokenURI = baseURI;
1437     }
1438 
1439     function getPrice() public view returns (uint256) {
1440         return _price;
1441     }
1442 
1443     function pause(bool val) public onlyOwner {
1444         _paused = val;
1445     }
1446 
1447     function withdrawAll() public payable onlyOwner {
1448         uint256 _balance = address(this).balance;
1449         require(payable(t1).send(_balance));
1450     }
1451 }