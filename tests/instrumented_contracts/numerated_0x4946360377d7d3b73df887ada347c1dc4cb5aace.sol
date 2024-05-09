1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 pragma solidity ^0.8.0;
4 
5 // File contracts/libraries/SafeTransfer.sol
6 
7 // SPDX-License-Identifier: GPL-3.0-or-later
8 
9 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
10 library TransferHelper {
11     function safeApprove(
12         address token,
13         address to,
14         uint256 value
15     ) internal {
16         // bytes4(keccak256(bytes('approve(address,uint256)')));
17         (bool success, bytes memory data) = token.call(
18             abi.encodeWithSelector(0x095ea7b3, to, value)
19         );
20         require(
21             success && (data.length == 0 || abi.decode(data, (bool))),
22             "safe approve failed"
23         );
24     }
25 
26     function safeTransfer(
27         address token,
28         address to,
29         uint256 value
30     ) internal {
31         // bytes4(keccak256(bytes('transfer(address,uint256)')));
32         (bool success, bytes memory data) = token.call(
33             abi.encodeWithSelector(0xa9059cbb, to, value)
34         );
35         require(
36             success && (data.length == 0 || abi.decode(data, (bool))),
37             "safe transfer failed"
38         );
39     }
40 
41     function safeTransferFrom(
42         address token,
43         address from,
44         address to,
45         uint256 value
46     ) internal {
47         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
48         (bool success, bytes memory data) = token.call(
49             abi.encodeWithSelector(0x23b872dd, from, to, value)
50         );
51         require(
52             success && (data.length == 0 || abi.decode(data, (bool))),
53             "safe transferFrom failed"
54         );
55     }
56 
57     function safeTransferETH(address to, uint256 value) internal {
58         (bool success, ) = to.call{ value: value }(new bytes(0));
59         require(success, "safe transferETH failed");
60     }
61 }
62 
63 
64 // File contracts/libraries/Ownable.sol
65 
66 /**
67  * @dev Contract module which provides a basic access control mechanism, where
68  * there is an account (an owner) that can be granted exclusive access to
69  * specific functions.
70  *
71  * By default, the owner account will be the one that deploys the contract. This
72  * can later be changed with {transferOwnership}.
73  *
74  * This module is used through inheritance. It will make available the modifier
75  * `onlyOwner`, which can be applied to your functions to restrict their use to
76  * the owner.
77  */
78 abstract contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(
82         address indexed previousOwner,
83         address indexed newOwner
84     );
85 
86     /**
87      * @dev Initializes the contract setting the deployer as the initial owner.
88      */
89     constructor() {
90         _transferOwnership(msg.sender);
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(owner() == msg.sender, "Ownable: caller is not the owner");
105         _;
106     }
107 
108     /**
109      * @dev Leaves the contract without owner. It will not be possible to call
110      * `onlyOwner` functions anymore. Can only be called by the current owner.
111      *
112      * NOTE: Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public virtual onlyOwner {
116         _transferOwnership(address(0));
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Can only be called by the current owner.
122      */
123     function transferOwnership(address newOwner) public virtual onlyOwner {
124         require(
125             newOwner != address(0),
126             "Ownable: new owner is the zero address"
127         );
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Internal function without access restriction.
134      */
135     function _transferOwnership(address newOwner) internal virtual {
136         address oldOwner = _owner;
137         _owner = newOwner;
138         emit OwnershipTransferred(oldOwner, newOwner);
139     }
140 }
141 
142 
143 // File contracts/interfaces/IERC721.sol
144 
145 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
146 
147 /**
148  * @dev Required interface of an ERC721 compliant contract.
149  */
150 interface IERC721 {
151     /**
152      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
153      */
154     event Transfer(
155         address indexed from,
156         address indexed to,
157         uint256 indexed tokenId
158     );
159 
160     /**
161      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
162      */
163     event Approval(
164         address indexed owner,
165         address indexed approved,
166         uint256 indexed tokenId
167     );
168 
169     /**
170      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
171      */
172     event ApprovalForAll(
173         address indexed owner,
174         address indexed operator,
175         bool approved
176     );
177 
178     /**
179      * @dev Returns the token collection name.
180      */
181     function name() external view returns (string memory);
182 
183     /**
184      * @dev Returns the token collection symbol.
185      */
186     function symbol() external view returns (string memory);
187 
188     /**
189      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
190      */
191     function tokenURI(uint256 tokenId) external view returns (string memory);
192 
193     /**
194      * @dev Returns the number of tokens in ``owner``'s account.
195      */
196     function balanceOf(address owner) external view returns (uint256 balance);
197 
198     /**
199      * @dev Returns the owner of the `tokenId` token.
200      *
201      * Requirements:
202      *
203      * - `tokenId` must exist.
204      */
205     function ownerOf(uint256 tokenId) external view returns (address owner);
206 
207     /**
208      * @dev Transfers `tokenId` token from `from` to `to`.
209      *
210      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must be owned by `from`.
217      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external;
226 
227     /**
228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
229      * The approval is cleared when the token is transferred.
230      *
231      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
232      *
233      * Requirements:
234      *
235      * - The caller must own the token or be an approved operator.
236      * - `tokenId` must exist.
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address to, uint256 tokenId) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId)
250         external
251         view
252         returns (address operator);
253 
254     /**
255      * @dev Approve or remove `operator` as an operator for the caller.
256      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
257      *
258      * Requirements:
259      *
260      * - The `operator` cannot be the caller.
261      *
262      * Emits an {ApprovalForAll} event.
263      */
264     function setApprovalForAll(address operator, bool _approved) external;
265 
266     /**
267      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
268      *
269      * See {setApprovalForAll}
270      */
271     function isApprovedForAll(address owner, address operator)
272         external
273         view
274         returns (bool);
275 }
276 
277 
278 // File contracts/libraries/Strings.sol
279 
280 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
281 
282 /**
283  * @dev String operations.
284  */
285 library Strings {
286     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
287 
288     /**
289      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
290      */
291     function toString(uint256 value) internal pure returns (string memory) {
292         // Inspired by OraclizeAPI's implementation - MIT licence
293         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
294 
295         if (value == 0) {
296             return "0";
297         }
298         uint256 temp = value;
299         uint256 digits;
300         while (temp != 0) {
301             digits++;
302             temp /= 10;
303         }
304         bytes memory buffer = new bytes(digits);
305         while (value != 0) {
306             digits -= 1;
307             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
308             value /= 10;
309         }
310         return string(buffer);
311     }
312 
313     /**
314      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
315      */
316     function toHexString(uint256 value) internal pure returns (string memory) {
317         if (value == 0) {
318             return "0x00";
319         }
320         uint256 temp = value;
321         uint256 length = 0;
322         while (temp != 0) {
323             length++;
324             temp >>= 8;
325         }
326         return toHexString(value, length);
327     }
328 
329     /**
330      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
331      */
332     function toHexString(uint256 value, uint256 length)
333         internal
334         pure
335         returns (string memory)
336     {
337         bytes memory buffer = new bytes(2 * length + 2);
338         buffer[0] = "0";
339         buffer[1] = "x";
340         for (uint256 i = 2 * length + 1; i > 1; --i) {
341             buffer[i] = _HEX_SYMBOLS[value & 0xf];
342             value >>= 4;
343         }
344         require(value == 0, "Strings: hex length insufficient");
345         return string(buffer);
346     }
347 }
348 
349 
350 // File contracts/libraries/ERC721.sol
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
353 
354 /**
355  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
356  * the Metadata extension, but not including the Enumerable extension, which is available separately as
357  * {ERC721Enumerable}.
358  */
359 contract ERC721 is IERC721 {
360     using Strings for uint256;
361 
362     // Token name
363     string private _name;
364 
365     // Token symbol
366     string private _symbol;
367 
368     // Base URI
369     string private _baseURI;
370 
371     // Mapping from token ID to owner address
372     mapping(uint256 => address) private _owners;
373 
374     // Mapping owner address to token count
375     mapping(address => uint256) private _balances;
376 
377     // Mapping from token ID to approved address
378     mapping(uint256 => address) private _tokenApprovals;
379 
380     // Mapping from owner to operator approvals
381     mapping(address => mapping(address => bool)) private _operatorApprovals;
382 
383     /**
384      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
385      */
386     constructor(
387         string memory name_,
388         string memory symbol_,
389         string memory baseURI_
390     ) {
391         _name = name_;
392         _symbol = symbol_;
393         _baseURI = baseURI_;
394     }
395 
396     /**
397      * @dev See {IERC721-balanceOf}.
398      */
399     function balanceOf(address owner)
400         public
401         view
402         virtual
403         override
404         returns (uint256)
405     {
406         require(
407             owner != address(0),
408             "ERC721: balance query for the zero address"
409         );
410         return _balances[owner];
411     }
412 
413     /**
414      * @dev See {IERC721-ownerOf}.
415      */
416     function ownerOf(uint256 tokenId)
417         public
418         view
419         virtual
420         override
421         returns (address)
422     {
423         address owner = _owners[tokenId];
424         require(
425             owner != address(0),
426             "ERC721: owner query for nonexistent token"
427         );
428         return owner;
429     }
430 
431     /**
432      * @dev See {IERC721Metadata-name}.
433      */
434     function name() public view virtual override returns (string memory) {
435         return _name;
436     }
437 
438     /**
439      * @dev See {IERC721Metadata-symbol}.
440      */
441     function symbol() public view virtual override returns (string memory) {
442         return _symbol;
443     }
444 
445     /**
446      * @dev See {IERC721Metadata-tokenURI}.
447      */
448     function tokenURI(uint256 tokenId)
449         public
450         view
451         virtual
452         override
453         returns (string memory)
454     {
455         require(
456             _exists(tokenId),
457             "ERC721Metadata: URI query for nonexistent token"
458         );
459 
460         string memory baseURI = _baseURI;
461         return
462             bytes(baseURI).length > 0
463                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
464                 : "";
465     }
466 
467     /**
468      * @dev See {IERC721-approve}.
469      */
470     function approve(address to, uint256 tokenId) public virtual override {
471         address owner = ERC721.ownerOf(tokenId);
472         require(to != owner, "ERC721: approval to current owner");
473 
474         require(
475             msg.sender == owner || isApprovedForAll(owner, msg.sender),
476             "ERC721: approve caller is not owner nor approved for all"
477         );
478 
479         _approve(to, tokenId);
480     }
481 
482     /**
483      * @dev See {IERC721-getApproved}.
484      */
485     function getApproved(uint256 tokenId)
486         public
487         view
488         virtual
489         override
490         returns (address)
491     {
492         require(
493             _exists(tokenId),
494             "ERC721: approved query for nonexistent token"
495         );
496 
497         return _tokenApprovals[tokenId];
498     }
499 
500     /**
501      * @dev See {IERC721-setApprovalForAll}.
502      */
503     function setApprovalForAll(address operator, bool approved)
504         public
505         virtual
506         override
507     {
508         _setApprovalForAll(msg.sender, operator, approved);
509     }
510 
511     /**
512      * @dev See {IERC721-isApprovedForAll}.
513      */
514     function isApprovedForAll(address owner, address operator)
515         public
516         view
517         virtual
518         override
519         returns (bool)
520     {
521         return _operatorApprovals[owner][operator];
522     }
523 
524     /**
525      * @dev See {IERC721-transferFrom}.
526      */
527     function transferFrom(
528         address from,
529         address to,
530         uint256 tokenId
531     ) public virtual override {
532         //solhint-disable-next-line max-line-length
533         require(
534             _isApprovedOrOwner(msg.sender, tokenId),
535             "ERC721: transfer caller is not owner nor approved"
536         );
537 
538         _transfer(from, to, tokenId);
539     }
540 
541     /**
542      * @dev Returns whether `tokenId` exists.
543      *
544      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
545      *
546      * Tokens start existing when they are minted (`_mint`),
547      * and stop existing when they are burned (`_burn`).
548      */
549     function _exists(uint256 tokenId) internal view virtual returns (bool) {
550         return _owners[tokenId] != address(0);
551     }
552 
553     /**
554      * @dev Returns whether `spender` is allowed to manage `tokenId`.
555      *
556      * Requirements:
557      *
558      * - `tokenId` must exist.
559      */
560     function _isApprovedOrOwner(address spender, uint256 tokenId)
561         internal
562         view
563         virtual
564         returns (bool)
565     {
566         require(
567             _exists(tokenId),
568             "ERC721: operator query for nonexistent token"
569         );
570         address owner = ERC721.ownerOf(tokenId);
571         return (spender == owner ||
572             getApproved(tokenId) == spender ||
573             isApprovedForAll(owner, spender));
574     }
575 
576     /**
577      * @dev Mints `tokenId` and transfers it to `to`.
578      *
579      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
580      *
581      * Requirements:
582      *
583      * - `tokenId` must not exist.
584      * - `to` cannot be the zero address.
585      *
586      * Emits a {Transfer} event.
587      */
588     function _mint(address to, uint256 tokenId) internal virtual {
589         require(to != address(0), "ERC721: mint to the zero address");
590         require(!_exists(tokenId), "ERC721: token already minted");
591 
592         _beforeTokenTransfer(address(0), to, tokenId);
593 
594         _balances[to] += 1;
595         _owners[tokenId] = to;
596 
597         emit Transfer(address(0), to, tokenId);
598     }
599 
600     /**
601      * @dev Destroys `tokenId`.
602      * The approval is cleared when the token is burned.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      *
608      * Emits a {Transfer} event.
609      */
610     function _burn(uint256 tokenId) internal virtual {
611         address owner = ERC721.ownerOf(tokenId);
612 
613         _beforeTokenTransfer(owner, address(0), tokenId);
614 
615         // Clear approvals
616         _approve(address(0), tokenId);
617 
618         _balances[owner] -= 1;
619         delete _owners[tokenId];
620 
621         emit Transfer(owner, address(0), tokenId);
622     }
623 
624     /**
625      * @dev Transfers `tokenId` from `from` to `to`.
626      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
627      *
628      * Requirements:
629      *
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must be owned by `from`.
632      *
633      * Emits a {Transfer} event.
634      */
635     function _transfer(
636         address from,
637         address to,
638         uint256 tokenId
639     ) internal virtual {
640         require(
641             ERC721.ownerOf(tokenId) == from,
642             "ERC721: transfer from incorrect owner"
643         );
644         require(to != address(0), "ERC721: transfer to the zero address");
645 
646         _beforeTokenTransfer(from, to, tokenId);
647 
648         // Clear approvals from the previous owner
649         _approve(address(0), tokenId);
650 
651         _balances[from] -= 1;
652         _balances[to] += 1;
653         _owners[tokenId] = to;
654 
655         emit Transfer(from, to, tokenId);
656     }
657 
658     /**
659      * @dev Approve `to` to operate on `tokenId`
660      *
661      * Emits a {Approval} event.
662      */
663     function _approve(address to, uint256 tokenId) internal virtual {
664         _tokenApprovals[tokenId] = to;
665         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
666     }
667 
668     /**
669      * @dev Approve `operator` to operate on all of `owner` tokens
670      *
671      * Emits a {ApprovalForAll} event.
672      */
673     function _setApprovalForAll(
674         address owner,
675         address operator,
676         bool approved
677     ) internal virtual {
678         require(owner != operator, "ERC721: approve to caller");
679         _operatorApprovals[owner][operator] = approved;
680         emit ApprovalForAll(owner, operator, approved);
681     }
682 
683     /**
684      * @dev Hook that is called before any token transfer. This includes minting
685      * and burning.
686      *
687      * Calling conditions:
688      *
689      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
690      * transferred to `to`.
691      * - When `from` is zero, `tokenId` will be minted for `to`.
692      * - When `to` is zero, ``from``'s `tokenId` will be burned.
693      * - `from` and `to` are never both zero.
694      *
695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
696      */
697     function _beforeTokenTransfer(
698         address from,
699         address to,
700         uint256 tokenId
701     ) internal virtual {}
702 }
703 
704 
705 // File contracts/interfaces/IERC721Enumerable.sol
706 
707 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Enumerable is IERC721 {
714     /**
715      * @dev Returns the total amount of tokens stored by the contract.
716      */
717     function totalSupply() external view returns (uint256);
718 
719     /**
720      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
721      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
722      */
723     function tokenOfOwnerByIndex(address owner, uint256 index)
724         external
725         view
726         returns (uint256 tokenId);
727 
728     /**
729      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
730      * Use along with {totalSupply} to enumerate all tokens.
731      */
732     function tokenByIndex(uint256 index) external view returns (uint256);
733 }
734 
735 
736 // File contracts/libraries/ERC721Enumerable.sol
737 
738 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
739 
740 /**
741  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
742  * enumerability of all the token ids in the contract as well as all token ids owned by each
743  * account.
744  */
745 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
746     // Mapping from owner to list of owned token IDs
747     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
748 
749     // Mapping from token ID to index of the owner tokens list
750     mapping(uint256 => uint256) private _ownedTokensIndex;
751 
752     // Array with all token ids, used for enumeration
753     uint256[] private _allTokens;
754 
755     // Mapping from token id to position in the allTokens array
756     mapping(uint256 => uint256) private _allTokensIndex;
757 
758     /**
759      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
760      */
761     function tokenOfOwnerByIndex(address owner, uint256 index)
762         public
763         view
764         virtual
765         override
766         returns (uint256)
767     {
768         require(
769             index < ERC721.balanceOf(owner),
770             "ERC721Enumerable: owner index out of bounds"
771         );
772         return _ownedTokens[owner][index];
773     }
774 
775     /**
776      * @dev See {IERC721Enumerable-totalSupply}.
777      */
778     function totalSupply() public view virtual override returns (uint256) {
779         return _allTokens.length;
780     }
781 
782     /**
783      * @dev See {IERC721Enumerable-tokenByIndex}.
784      */
785     function tokenByIndex(uint256 index)
786         public
787         view
788         virtual
789         override
790         returns (uint256)
791     {
792         require(
793             index < ERC721Enumerable.totalSupply(),
794             "ERC721Enumerable: global index out of bounds"
795         );
796         return _allTokens[index];
797     }
798 
799     /**
800      * @dev Hook that is called before any token transfer. This includes minting
801      * and burning.
802      *
803      * Calling conditions:
804      *
805      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
806      * transferred to `to`.
807      * - When `from` is zero, `tokenId` will be minted for `to`.
808      * - When `to` is zero, ``from``'s `tokenId` will be burned.
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      *
812      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
813      */
814     function _beforeTokenTransfer(
815         address from,
816         address to,
817         uint256 tokenId
818     ) internal virtual override {
819         super._beforeTokenTransfer(from, to, tokenId);
820 
821         if (from == address(0)) {
822             _addTokenToAllTokensEnumeration(tokenId);
823         } else if (from != to) {
824             _removeTokenFromOwnerEnumeration(from, tokenId);
825         }
826         if (to == address(0)) {
827             _removeTokenFromAllTokensEnumeration(tokenId);
828         } else if (to != from) {
829             _addTokenToOwnerEnumeration(to, tokenId);
830         }
831     }
832 
833     /**
834      * @dev Private function to add a token to this extension's ownership-tracking data structures.
835      * @param to address representing the new owner of the given token ID
836      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
837      */
838     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
839         uint256 length = ERC721.balanceOf(to);
840         _ownedTokens[to][length] = tokenId;
841         _ownedTokensIndex[tokenId] = length;
842     }
843 
844     /**
845      * @dev Private function to add a token to this extension's token tracking data structures.
846      * @param tokenId uint256 ID of the token to be added to the tokens list
847      */
848     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
849         _allTokensIndex[tokenId] = _allTokens.length;
850         _allTokens.push(tokenId);
851     }
852 
853     /**
854      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
855      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
856      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
857      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
858      * @param from address representing the previous owner of the given token ID
859      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
860      */
861     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
862         private
863     {
864         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
865         // then delete the last slot (swap and pop).
866 
867         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
868         uint256 tokenIndex = _ownedTokensIndex[tokenId];
869 
870         // When the token to delete is the last token, the swap operation is unnecessary
871         if (tokenIndex != lastTokenIndex) {
872             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
873 
874             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
875             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
876         }
877 
878         // This also deletes the contents at the last position of the array
879         delete _ownedTokensIndex[tokenId];
880         delete _ownedTokens[from][lastTokenIndex];
881     }
882 
883     /**
884      * @dev Private function to remove a token from this extension's token tracking data structures.
885      * This has O(1) time complexity, but alters the order of the _allTokens array.
886      * @param tokenId uint256 ID of the token to be removed from the tokens list
887      */
888     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
889         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
890         // then delete the last slot (swap and pop).
891 
892         uint256 lastTokenIndex = _allTokens.length - 1;
893         uint256 tokenIndex = _allTokensIndex[tokenId];
894 
895         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
896         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
897         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
898         uint256 lastTokenId = _allTokens[lastTokenIndex];
899 
900         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
901         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
902 
903         // This also deletes the contents at the last position of the array
904         delete _allTokensIndex[tokenId];
905         _allTokens.pop();
906     }
907 }
908 
909 
910 // File contracts/libraries/Math.sol
911 
912 library Math {
913     function compound(uint256 rewardRateX96, uint256 nCompounds)
914         internal
915         pure
916         returns (uint256 compoundedX96)
917     {
918         if (nCompounds == 0) {
919             compoundedX96 = 2**96;
920         } else if (nCompounds == 1) {
921             compoundedX96 = rewardRateX96;
922         } else {
923             compoundedX96 = compound(rewardRateX96, nCompounds / 2);
924             compoundedX96 = mulX96(compoundedX96, compoundedX96);
925 
926             if (nCompounds % 2 == 1) {
927                 compoundedX96 = mulX96(compoundedX96, rewardRateX96);
928             }
929         }
930     }
931 
932     // ref: https://blogs.sas.com/content/iml/2016/05/16/babylonian-square-roots.html
933     function sqrt(uint256 x) internal pure returns (uint256 y) {
934         uint256 z = (x + 1) / 2;
935         y = x;
936         while (z < y) {
937             y = z;
938             z = (x / z + z) / 2;
939         }
940     }
941 
942     function mulX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
943         z = (x * y) >> 96;
944     }
945 
946     function divX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
947         z = (x << 96) / y;
948     }
949 
950     function max(uint256 a, uint256 b) internal pure returns (uint256) {
951         return a >= b ? a : b;
952     }
953 
954     function min(uint256 a, uint256 b) internal pure returns (uint256) {
955         return a < b ? a : b;
956     }
957 }
958 
959 
960 // File contracts/libraries/Time.sol
961 
962 library Time {
963     function current_hour_timestamp() internal view returns (uint64) {
964         return uint64((block.timestamp / 1 hours) * 1 hours);
965     }
966 
967     function block_timestamp() internal view returns (uint64) {
968         return uint64(block.timestamp);
969     }
970 }
971 
972 
973 // File contracts/interfaces/IUniswapV3Factory.sol
974 
975 /// @title The interface for the Uniswap V3 Factory
976 /// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
977 interface IUniswapV3Factory {
978     /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
979     /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
980     /// @param tokenA The contract address of either token0 or token1
981     /// @param tokenB The contract address of the other token
982     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
983     /// @return pool The pool address
984     function getPool(
985         address tokenA,
986         address tokenB,
987         uint24 fee
988     ) external view returns (address pool);
989 
990     /// @notice Creates a pool for the given two tokens and fee
991     /// @param tokenA One of the two tokens in the desired pool
992     /// @param tokenB The other of the two tokens in the desired pool
993     /// @param fee The desired fee for the pool
994     /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
995     /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
996     /// are invalid.
997     /// @return pool The address of the newly created pool
998     function createPool(
999         address tokenA,
1000         address tokenB,
1001         uint24 fee
1002     ) external returns (address pool);
1003 }
1004 
1005 
1006 // File contracts/interfaces/IUniswapV3Pool.sol
1007 
1008 interface IUniswapV3Pool {
1009     /// @notice Sets the initial price for the pool
1010     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
1011     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
1012     function initialize(uint160 sqrtPriceX96) external;
1013 
1014     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
1015     /// when accessed externally.
1016     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
1017     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
1018     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
1019     /// boundary.
1020     /// observationIndex The index of the last oracle observation that was written,
1021     /// observationCardinality The current maximum number of observations stored in the pool,
1022     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
1023     /// feeProtocol The protocol fee for both tokens of the pool.
1024     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
1025     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
1026     /// unlocked Whether the pool is currently locked to reentrancy
1027     function slot0()
1028         external
1029         view
1030         returns (
1031             uint160 sqrtPriceX96,
1032             int24 tick,
1033             uint16 observationIndex,
1034             uint16 observationCardinality,
1035             uint16 observationCardinalityNext,
1036             uint8 feeProtocol,
1037             bool unlocked
1038         );
1039 
1040     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
1041     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
1042     /// the input observationCardinalityNext.
1043     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
1044     function increaseObservationCardinalityNext(
1045         uint16 observationCardinalityNext
1046     ) external;
1047 
1048     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
1049     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
1050     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
1051     /// you must call it with secondsAgos = [3600, 0].
1052     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
1053     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
1054     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
1055     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
1056     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
1057     /// timestamp
1058     function observe(uint32[] calldata secondsAgos)
1059         external
1060         view
1061         returns (
1062             int56[] memory tickCumulatives,
1063             uint160[] memory secondsPerLiquidityCumulativeX128s
1064         );
1065 }
1066 
1067 
1068 // File contracts/interfaces/IERC20.sol
1069 
1070 interface IERC20 {
1071     function totalSupply() external view returns (uint256);
1072 
1073     function balanceOf(address account) external view returns (uint256);
1074 
1075     function transfer(address recipient, uint256 amount)
1076         external
1077         returns (bool);
1078 
1079     function allowance(address owner, address spender)
1080         external
1081         view
1082         returns (uint256);
1083 
1084     function approve(address spender, uint256 amount) external returns (bool);
1085 
1086     function transferFrom(
1087         address sender,
1088         address recipient,
1089         uint256 amount
1090     ) external returns (bool);
1091 
1092     event Transfer(address indexed from, address indexed to, uint256 value);
1093     event Approval(
1094         address indexed owner,
1095         address indexed spender,
1096         uint256 value
1097     );
1098 }
1099 
1100 
1101 // File contracts/libraries/ERC20.sol
1102 
1103 /**
1104  * @dev Implementation of the {IERC20} interface.
1105  *
1106  * This implementation is agnostic to the way tokens are created. This means
1107  * that a supply mechanism has to be added in a derived contract using {_mint}.
1108  * For a generic mechanism see {ERC20PresetMinterPauser}.
1109  *
1110  * TIP: For a detailed writeup see our guide
1111  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1112  * to implement supply mechanisms].
1113  *
1114  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1115  * instead returning `false` on failure. This behavior is nonetheless
1116  * conventional and does not conflict with the expectations of ERC20
1117  * applications.
1118  *
1119  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1120  * This allows applications to reconstruct the allowance for all accounts just
1121  * by listening to said events. Other implementations of the EIP may not emit
1122  * these events, as it isn't required by the specification.
1123  *
1124  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1125  * functions have been added to mitigate the well-known issues around setting
1126  * allowances. See {IERC20-approve}.
1127  */
1128 contract ERC20 is IERC20 {
1129     mapping(address => uint256) private _balances;
1130 
1131     mapping(address => mapping(address => uint256)) private _allowances;
1132 
1133     uint256 private _totalSupply;
1134 
1135     string private _name;
1136     string private _symbol;
1137     uint8 private _decimals;
1138 
1139     /**
1140      * @dev Sets the values for {name} and {symbol}.
1141      *
1142      * The default value of {decimals} is 18. To select a different value for
1143      * {decimals} you should overload it.
1144      *
1145      * All two of these values are immutable: they can only be set once during
1146      * construction.
1147      */
1148     constructor(
1149         string memory name_,
1150         string memory symbol_,
1151         uint8 decimals_
1152     ) {
1153         _name = name_;
1154         _symbol = symbol_;
1155         _decimals = decimals_;
1156     }
1157 
1158     /**
1159      * @dev Returns the name of the token.
1160      */
1161     function name() public view virtual returns (string memory) {
1162         return _name;
1163     }
1164 
1165     /**
1166      * @dev Returns the symbol of the token, usually a shorter version of the
1167      * name.
1168      */
1169     function symbol() public view virtual returns (string memory) {
1170         return _symbol;
1171     }
1172 
1173     /**
1174      * @dev Returns the number of decimals used to get its user representation.
1175      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1176      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1177      *
1178      * Tokens usually opt for a value of 18, imitating the relationship between
1179      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1180      * overridden;
1181      *
1182      * NOTE: This information is only used for _display_ purposes: it in
1183      * no way affects any of the arithmetic of the contract, including
1184      * {IERC20-balanceOf} and {IERC20-transfer}.
1185      */
1186     function decimals() public view virtual returns (uint8) {
1187         return _decimals;
1188     }
1189 
1190     /**
1191      * @dev See {IERC20-totalSupply}.
1192      */
1193     function totalSupply() public view virtual override returns (uint256) {
1194         return _totalSupply;
1195     }
1196 
1197     /**
1198      * @dev See {IERC20-balanceOf}.
1199      */
1200     function balanceOf(address account)
1201         public
1202         view
1203         virtual
1204         override
1205         returns (uint256)
1206     {
1207         return _balances[account];
1208     }
1209 
1210     /**
1211      * @dev See {IERC20-transfer}.
1212      *
1213      * Requirements:
1214      *
1215      * - `recipient` cannot be the zero address.
1216      * - the caller must have a balance of at least `amount`.
1217      */
1218     function transfer(address recipient, uint256 amount)
1219         public
1220         virtual
1221         override
1222         returns (bool)
1223     {
1224         _transfer(msg.sender, recipient, amount);
1225         return true;
1226     }
1227 
1228     /**
1229      * @dev See {IERC20-allowance}.
1230      */
1231     function allowance(address owner, address spender)
1232         public
1233         view
1234         virtual
1235         override
1236         returns (uint256)
1237     {
1238         return _allowances[owner][spender];
1239     }
1240 
1241     /**
1242      * @dev See {IERC20-approve}.
1243      *
1244      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1245      * `transferFrom`. This is semantically equivalent to an infinite approval.
1246      *
1247      * Requirements:
1248      *
1249      * - `spender` cannot be the zero address.
1250      */
1251     function approve(address spender, uint256 amount)
1252         public
1253         virtual
1254         override
1255         returns (bool)
1256     {
1257         _approve(msg.sender, spender, amount);
1258         return true;
1259     }
1260 
1261     /**
1262      * @dev See {IERC20-transferFrom}.
1263      *
1264      * Emits an {Approval} event indicating the updated allowance. This is not
1265      * required by the EIP. See the note at the beginning of {ERC20}.
1266      *
1267      * NOTE: Does not update the allowance if the current allowance
1268      * is the maximum `uint256`.
1269      *
1270      * Requirements:
1271      *
1272      * - `sender` and `recipient` cannot be the zero address.
1273      * - `sender` must have a balance of at least `amount`.
1274      * - the caller must have allowance for ``sender``'s tokens of at least
1275      * `amount`.
1276      */
1277     function transferFrom(
1278         address sender,
1279         address recipient,
1280         uint256 amount
1281     ) public virtual override returns (bool) {
1282         uint256 currentAllowance = _allowances[sender][msg.sender];
1283         if (currentAllowance != type(uint256).max) {
1284             require(
1285                 currentAllowance >= amount,
1286                 "ERC20: transfer amount exceeds allowance"
1287             );
1288             unchecked {
1289                 _approve(sender, msg.sender, currentAllowance - amount);
1290             }
1291         }
1292 
1293         _transfer(sender, recipient, amount);
1294 
1295         return true;
1296     }
1297 
1298     /**
1299      * @dev Atomically increases the allowance granted to `spender` by the caller.
1300      *
1301      * This is an alternative to {approve} that can be used as a mitigation for
1302      * problems described in {IERC20-approve}.
1303      *
1304      * Emits an {Approval} event indicating the updated allowance.
1305      *
1306      * Requirements:
1307      *
1308      * - `spender` cannot be the zero address.
1309      */
1310     function increaseAllowance(address spender, uint256 addedValue)
1311         public
1312         virtual
1313         returns (bool)
1314     {
1315         _approve(
1316             msg.sender,
1317             spender,
1318             _allowances[msg.sender][spender] + addedValue
1319         );
1320         return true;
1321     }
1322 
1323     /**
1324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1325      *
1326      * This is an alternative to {approve} that can be used as a mitigation for
1327      * problems described in {IERC20-approve}.
1328      *
1329      * Emits an {Approval} event indicating the updated allowance.
1330      *
1331      * Requirements:
1332      *
1333      * - `spender` cannot be the zero address.
1334      * - `spender` must have allowance for the caller of at least
1335      * `subtractedValue`.
1336      */
1337     function decreaseAllowance(address spender, uint256 subtractedValue)
1338         public
1339         virtual
1340         returns (bool)
1341     {
1342         uint256 currentAllowance = _allowances[msg.sender][spender];
1343         require(
1344             currentAllowance >= subtractedValue,
1345             "ERC20: decreased allowance below zero"
1346         );
1347         unchecked {
1348             _approve(msg.sender, spender, currentAllowance - subtractedValue);
1349         }
1350 
1351         return true;
1352     }
1353 
1354     /**
1355      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1356      *
1357      * This internal function is equivalent to {transfer}, and can be used to
1358      * e.g. implement automatic token fees, slashing mechanisms, etc.
1359      *
1360      * Emits a {Transfer} event.
1361      *
1362      * Requirements:
1363      *
1364      * - `sender` cannot be the zero address.
1365      * - `recipient` cannot be the zero address.
1366      * - `sender` must have a balance of at least `amount`.
1367      */
1368     function _transfer(
1369         address sender,
1370         address recipient,
1371         uint256 amount
1372     ) internal virtual {
1373         require(sender != address(0), "ERC20: transfer from the zero address");
1374         require(recipient != address(0), "ERC20: transfer to the zero address");
1375 
1376         _beforeTokenTransfer(sender, recipient, amount);
1377 
1378         uint256 senderBalance = _balances[sender];
1379         require(
1380             senderBalance >= amount,
1381             "ERC20: transfer amount exceeds balance"
1382         );
1383         unchecked {
1384             _balances[sender] = senderBalance - amount;
1385         }
1386         _balances[recipient] += amount;
1387 
1388         emit Transfer(sender, recipient, amount);
1389 
1390         _afterTokenTransfer(sender, recipient, amount);
1391     }
1392 
1393     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1394      * the total supply.
1395      *
1396      * Emits a {Transfer} event with `from` set to the zero address.
1397      *
1398      * Requirements:
1399      *
1400      * - `account` cannot be the zero address.
1401      */
1402     function _mint(address account, uint256 amount) internal virtual {
1403         require(account != address(0), "ERC20: mint to the zero address");
1404 
1405         _beforeTokenTransfer(address(0), account, amount);
1406 
1407         _totalSupply += amount;
1408         _balances[account] += amount;
1409         emit Transfer(address(0), account, amount);
1410 
1411         _afterTokenTransfer(address(0), account, amount);
1412     }
1413 
1414     /**
1415      * @dev Destroys `amount` tokens from `account`, reducing the
1416      * total supply.
1417      *
1418      * Emits a {Transfer} event with `to` set to the zero address.
1419      *
1420      * Requirements:
1421      *
1422      * - `account` cannot be the zero address.
1423      * - `account` must have at least `amount` tokens.
1424      */
1425     function _burn(address account, uint256 amount) internal virtual {
1426         require(account != address(0), "ERC20: burn from the zero address");
1427 
1428         _beforeTokenTransfer(account, address(0), amount);
1429 
1430         uint256 accountBalance = _balances[account];
1431         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1432         unchecked {
1433             _balances[account] = accountBalance - amount;
1434         }
1435         _totalSupply -= amount;
1436 
1437         emit Transfer(account, address(0), amount);
1438 
1439         _afterTokenTransfer(account, address(0), amount);
1440     }
1441 
1442     /**
1443      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1444      *
1445      * This internal function is equivalent to `approve`, and can be used to
1446      * e.g. set automatic allowances for certain subsystems, etc.
1447      *
1448      * Emits an {Approval} event.
1449      *
1450      * Requirements:
1451      *
1452      * - `owner` cannot be the zero address.
1453      * - `spender` cannot be the zero address.
1454      */
1455     function _approve(
1456         address owner,
1457         address spender,
1458         uint256 amount
1459     ) internal virtual {
1460         require(owner != address(0), "ERC20: approve from the zero address");
1461         require(spender != address(0), "ERC20: approve to the zero address");
1462 
1463         _allowances[owner][spender] = amount;
1464         emit Approval(owner, spender, amount);
1465     }
1466 
1467     /**
1468      * @dev Hook that is called before any transfer of tokens. This includes
1469      * minting and burning.
1470      *
1471      * Calling conditions:
1472      *
1473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1474      * will be transferred to `to`.
1475      * - when `from` is zero, `amount` tokens will be minted for `to`.
1476      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1477      * - `from` and `to` are never both zero.
1478      *
1479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1480      */
1481     function _beforeTokenTransfer(
1482         address from,
1483         address to,
1484         uint256 amount
1485     ) internal virtual {}
1486 
1487     /**
1488      * @dev Hook that is called after any transfer of tokens. This includes
1489      * minting and burning.
1490      *
1491      * Calling conditions:
1492      *
1493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1494      * has been transferred to `to`.
1495      * - when `from` is zero, `amount` tokens have been minted for `to`.
1496      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1497      * - `from` and `to` are never both zero.
1498      *
1499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1500      */
1501     function _afterTokenTransfer(
1502         address from,
1503         address to,
1504         uint256 amount
1505     ) internal virtual {}
1506 }
1507 
1508 
1509 // File contracts/libraries/TickMath.sol
1510 
1511 /// @title Math library for computing sqrt prices from ticks and vice versa
1512 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
1513 /// prices between 2**-128 and 2**128
1514 library TickMath {
1515     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
1516     int24 internal constant MIN_TICK = -887272;
1517     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
1518     int24 internal constant MAX_TICK = -MIN_TICK;
1519 
1520     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
1521     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
1522     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
1523     uint160 internal constant MAX_SQRT_RATIO =
1524         1461446703485210103287273052203988822378723970342;
1525 
1526     /// @notice Calculates sqrt(1.0001^tick) * 2^96
1527     /// @dev Throws if |tick| > max tick
1528     /// @param tick The input tick for the above formula
1529     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
1530     /// at the given tick
1531     function getSqrtRatioAtTick(int24 tick)
1532         internal
1533         pure
1534         returns (uint160 sqrtPriceX96)
1535     {
1536         uint256 absTick = tick < 0
1537             ? uint256(-int256(tick))
1538             : uint256(int256(tick));
1539         require(absTick <= uint256(int256(MAX_TICK)), "T");
1540 
1541         uint256 ratio = absTick & 0x1 != 0
1542             ? 0xfffcb933bd6fad37aa2d162d1a594001
1543             : 0x100000000000000000000000000000000;
1544         if (absTick & 0x2 != 0)
1545             ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
1546         if (absTick & 0x4 != 0)
1547             ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
1548         if (absTick & 0x8 != 0)
1549             ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
1550         if (absTick & 0x10 != 0)
1551             ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
1552         if (absTick & 0x20 != 0)
1553             ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
1554         if (absTick & 0x40 != 0)
1555             ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
1556         if (absTick & 0x80 != 0)
1557             ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
1558         if (absTick & 0x100 != 0)
1559             ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
1560         if (absTick & 0x200 != 0)
1561             ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
1562         if (absTick & 0x400 != 0)
1563             ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
1564         if (absTick & 0x800 != 0)
1565             ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
1566         if (absTick & 0x1000 != 0)
1567             ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
1568         if (absTick & 0x2000 != 0)
1569             ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
1570         if (absTick & 0x4000 != 0)
1571             ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
1572         if (absTick & 0x8000 != 0)
1573             ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
1574         if (absTick & 0x10000 != 0)
1575             ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
1576         if (absTick & 0x20000 != 0)
1577             ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
1578         if (absTick & 0x40000 != 0)
1579             ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
1580         if (absTick & 0x80000 != 0)
1581             ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
1582 
1583         if (tick > 0) ratio = type(uint256).max / ratio;
1584 
1585         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
1586         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
1587         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
1588         sqrtPriceX96 = uint160(
1589             (ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1)
1590         );
1591     }
1592 
1593     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
1594     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
1595     /// ever return.
1596     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
1597     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
1598     function getTickAtSqrtRatio(uint160 sqrtPriceX96)
1599         internal
1600         pure
1601         returns (int24 tick)
1602     {
1603         // second inequality must be < because the price can never reach the price at the max tick
1604         require(
1605             sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO,
1606             "R"
1607         );
1608         uint256 ratio = uint256(sqrtPriceX96) << 32;
1609 
1610         uint256 r = ratio;
1611         uint256 msb = 0;
1612 
1613         assembly {
1614             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
1615             msb := or(msb, f)
1616             r := shr(f, r)
1617         }
1618         assembly {
1619             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
1620             msb := or(msb, f)
1621             r := shr(f, r)
1622         }
1623         assembly {
1624             let f := shl(5, gt(r, 0xFFFFFFFF))
1625             msb := or(msb, f)
1626             r := shr(f, r)
1627         }
1628         assembly {
1629             let f := shl(4, gt(r, 0xFFFF))
1630             msb := or(msb, f)
1631             r := shr(f, r)
1632         }
1633         assembly {
1634             let f := shl(3, gt(r, 0xFF))
1635             msb := or(msb, f)
1636             r := shr(f, r)
1637         }
1638         assembly {
1639             let f := shl(2, gt(r, 0xF))
1640             msb := or(msb, f)
1641             r := shr(f, r)
1642         }
1643         assembly {
1644             let f := shl(1, gt(r, 0x3))
1645             msb := or(msb, f)
1646             r := shr(f, r)
1647         }
1648         assembly {
1649             let f := gt(r, 0x1)
1650             msb := or(msb, f)
1651         }
1652 
1653         if (msb >= 128) r = ratio >> (msb - 127);
1654         else r = ratio << (127 - msb);
1655 
1656         int256 log_2 = (int256(msb) - 128) << 64;
1657 
1658         assembly {
1659             r := shr(127, mul(r, r))
1660             let f := shr(128, r)
1661             log_2 := or(log_2, shl(63, f))
1662             r := shr(f, r)
1663         }
1664         assembly {
1665             r := shr(127, mul(r, r))
1666             let f := shr(128, r)
1667             log_2 := or(log_2, shl(62, f))
1668             r := shr(f, r)
1669         }
1670         assembly {
1671             r := shr(127, mul(r, r))
1672             let f := shr(128, r)
1673             log_2 := or(log_2, shl(61, f))
1674             r := shr(f, r)
1675         }
1676         assembly {
1677             r := shr(127, mul(r, r))
1678             let f := shr(128, r)
1679             log_2 := or(log_2, shl(60, f))
1680             r := shr(f, r)
1681         }
1682         assembly {
1683             r := shr(127, mul(r, r))
1684             let f := shr(128, r)
1685             log_2 := or(log_2, shl(59, f))
1686             r := shr(f, r)
1687         }
1688         assembly {
1689             r := shr(127, mul(r, r))
1690             let f := shr(128, r)
1691             log_2 := or(log_2, shl(58, f))
1692             r := shr(f, r)
1693         }
1694         assembly {
1695             r := shr(127, mul(r, r))
1696             let f := shr(128, r)
1697             log_2 := or(log_2, shl(57, f))
1698             r := shr(f, r)
1699         }
1700         assembly {
1701             r := shr(127, mul(r, r))
1702             let f := shr(128, r)
1703             log_2 := or(log_2, shl(56, f))
1704             r := shr(f, r)
1705         }
1706         assembly {
1707             r := shr(127, mul(r, r))
1708             let f := shr(128, r)
1709             log_2 := or(log_2, shl(55, f))
1710             r := shr(f, r)
1711         }
1712         assembly {
1713             r := shr(127, mul(r, r))
1714             let f := shr(128, r)
1715             log_2 := or(log_2, shl(54, f))
1716             r := shr(f, r)
1717         }
1718         assembly {
1719             r := shr(127, mul(r, r))
1720             let f := shr(128, r)
1721             log_2 := or(log_2, shl(53, f))
1722             r := shr(f, r)
1723         }
1724         assembly {
1725             r := shr(127, mul(r, r))
1726             let f := shr(128, r)
1727             log_2 := or(log_2, shl(52, f))
1728             r := shr(f, r)
1729         }
1730         assembly {
1731             r := shr(127, mul(r, r))
1732             let f := shr(128, r)
1733             log_2 := or(log_2, shl(51, f))
1734             r := shr(f, r)
1735         }
1736         assembly {
1737             r := shr(127, mul(r, r))
1738             let f := shr(128, r)
1739             log_2 := or(log_2, shl(50, f))
1740         }
1741 
1742         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
1743 
1744         int24 tickLow = int24(
1745             (log_sqrt10001 - 3402992956809132418596140100660247210) >> 128
1746         );
1747         int24 tickHi = int24(
1748             (log_sqrt10001 + 291339464771989622907027621153398088495) >> 128
1749         );
1750 
1751         tick = tickLow == tickHi
1752             ? tickLow
1753             : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96
1754             ? tickHi
1755             : tickLow;
1756     }
1757 }
1758 
1759 
1760 // File contracts/Const.sol
1761 
1762 int24 constant INITIAL_QLT_PRICE_TICK = -23000; // QLT_USDC price ~ 100.0
1763 
1764 // initial values
1765 uint24 constant UNISWAP_POOL_FEE = 10000;
1766 int24 constant UNISWAP_POOL_TICK_SPACING = 200;
1767 uint16 constant UNISWAP_POOL_OBSERVATION_CADINALITY = 64;
1768 
1769 // default values
1770 uint256 constant DEFAULT_MIN_MINT_PRICE_X96 = 100 * Q96;
1771 uint32 constant DEFAULT_TWAP_DURATION = 1 hours;
1772 uint32 constant DEFAULT_UNSTAKE_LOCKUP_PERIOD = 3 days;
1773 
1774 // floating point math
1775 uint256 constant Q96 = 2**96;
1776 uint256 constant MX96 = Q96 / 10**6;
1777 uint256 constant TX96 = Q96 / 10**12;
1778 
1779 // ERC-20 contract addresses
1780 address constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
1781 address constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1782 address constant USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
1783 address constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
1784 address constant BUSD = address(0x4Fabb145d64652a948d72533023f6E7A623C7C53);
1785 address constant FRAX = address(0x853d955aCEf822Db058eb8505911ED77F175b99e);
1786 address constant WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
1787 
1788 // Uniswap, see `https://docs.uniswap.org/protocol/reference/deployments`
1789 address constant UNISWAP_FACTORY = address(
1790     0x1F98431c8aD98523631AE4a59f267346ea31F984
1791 );
1792 address constant UNISWAP_ROUTER = address(
1793     0xE592427A0AEce92De3Edee1F18E0157C05861564
1794 );
1795 address constant UNISWAP_NFP_MGR = address(
1796     0xC36442b4a4522E871399CD717aBDD847Ab11FE88
1797 );
1798 
1799 
1800 // File contracts/QLT.sol
1801 
1802 contract QLT is ERC20, Ownable {
1803     event Mint(address indexed account, uint256 amount);
1804     event Burn(uint256 amount);
1805 
1806     mapping(address => bool) public authorizedMinters;
1807 
1808     constructor() ERC20("Quantland", "QLT", 9) {
1809         require(
1810             address(this) < USDC,
1811             "QLT contract address must be smaller than USDC token contract address"
1812         );
1813         authorizedMinters[msg.sender] = true;
1814 
1815         // deploy uniswap pool
1816         IUniswapV3Pool pool = IUniswapV3Pool(
1817             IUniswapV3Factory(UNISWAP_FACTORY).createPool(
1818                 address(this),
1819                 USDC,
1820                 UNISWAP_POOL_FEE
1821             )
1822         );
1823         pool.initialize(TickMath.getSqrtRatioAtTick(INITIAL_QLT_PRICE_TICK));
1824         pool.increaseObservationCardinalityNext(
1825             UNISWAP_POOL_OBSERVATION_CADINALITY
1826         );
1827     }
1828 
1829     function mint(address account, uint256 amount)
1830         external
1831         onlyAuthorizedMinter
1832     {
1833         _mint(account, amount);
1834 
1835         emit Mint(account, amount);
1836     }
1837 
1838     function burn(uint256 amount) external onlyOwner {
1839         _burn(msg.sender, amount);
1840 
1841         emit Burn(amount);
1842     }
1843 
1844     /* Access Control */
1845     modifier onlyAuthorizedMinter() {
1846         require(authorizedMinters[msg.sender], "not authorized minter");
1847         _;
1848     }
1849 
1850     function addAuthorizedMinter(address account) external onlyOwner {
1851         authorizedMinters[account] = true;
1852     }
1853 
1854     function removeAuthorizedMinter(address account) external onlyOwner {
1855         authorizedMinters[account] = false;
1856     }
1857 }
1858 
1859 
1860 // File contracts/StakedQLT.sol
1861 
1862 struct StakingInfo {
1863     bytes32 stakingPlan;
1864     uint256 stakedAmount;
1865     uint64 stakeTime;
1866     uint64 unstakeTime;
1867     uint64 redeemTime;
1868     uint64 lastHarvestTime;
1869     uint256 accumulatedStakingReward;
1870 }
1871 
1872 struct StakingRewardRate {
1873     uint256 rewardRateX96;
1874     uint64 startTime;
1875 }
1876 
1877 struct StakingPowerMultiplier {
1878     uint64 multiplier;
1879     uint64 startTime;
1880 }
1881 
1882 struct StakingPlan {
1883     bytes32 name;
1884     uint256 stakingAmount;
1885     uint256 accumulatedStakingReward;
1886     StakingRewardRate[] rewardRates;
1887     StakingPowerMultiplier[] multipliers;
1888     uint64 lockupPeriod;
1889     uint64 createdAt;
1890     uint64 deactivatedAt;
1891 }
1892 
1893 contract StakedQLT is ERC721Enumerable, Ownable {
1894     using Math for uint256;
1895 
1896     event Stake(
1897         uint256 indexed tokenId,
1898         address staker,
1899         bytes32 stakingPlan,
1900         uint256 amount
1901     );
1902     event Unstake(uint256 indexed tokenId);
1903     event Redeem(uint256 indexed tokenId, uint256 amount);
1904     event Harvest(uint256 indexed tokenId, uint256 rewardAmount);
1905     event HarvestAll(uint256[] tokenIds, uint256 rewardAmount);
1906     event StakingPlanCreated(bytes32 name);
1907     event StakingPlanDeactivated(bytes32 name);
1908     event StakingRewardRateUpdated(bytes32 name, uint256 rewardRateX96);
1909     event StakingPowerMultiplierUpdated(bytes32 name, uint256 multiplier);
1910 
1911     QLT private immutable QLTContract;
1912 
1913     uint256 public tokenIdCounter;
1914     uint64 public harvestStartTime;
1915     uint64 public unstakeLockupPeriod;
1916 
1917     uint256 public totalStakingAmount;
1918     address public treasuryAddress;
1919     mapping(uint256 => StakingInfo) public stakingInfos;
1920     mapping(bytes32 => StakingPlan) public stakingPlans;
1921 
1922     mapping(address => bool) public authorizedOperators;
1923 
1924     constructor(address _QLTContract)
1925         ERC721("Staked QLT", "sQLT", "https://staked.quantland.finance/")
1926     {
1927         addAuthorizedOperator(msg.sender);
1928         harvestStartTime = type(uint64).max;
1929         unstakeLockupPeriod = DEFAULT_UNSTAKE_LOCKUP_PERIOD;
1930 
1931         addStakingPlan("gold", 7 days, (100040 * Q96) / 100000, 1); // APY 3,222 %
1932         addStakingPlan("platinum", 30 days, (100060 * Q96) / 100000, 3); // APY 19,041 %
1933         addStakingPlan("diamond", 90 days, (100080 * Q96) / 100000, 5); // APY 110,200 %
1934 
1935         QLTContract = QLT(_QLTContract);
1936     }
1937 
1938     /* Staking Plan Governance Functions */
1939     function addStakingPlan(
1940         bytes32 name,
1941         uint64 lockupPeriod,
1942         uint256 rewardRateX96,
1943         uint64 multiplier
1944     ) public onlyOwner {
1945         require(stakingPlans[name].createdAt == 0, "already created");
1946         StakingPlan storage stakingPlan = stakingPlans[name];
1947         stakingPlan.name = name;
1948         stakingPlan.rewardRates.push(
1949             StakingRewardRate({
1950                 rewardRateX96: rewardRateX96,
1951                 startTime: Time.current_hour_timestamp()
1952             })
1953         );
1954         stakingPlan.multipliers.push(
1955             StakingPowerMultiplier({
1956                 multiplier: multiplier,
1957                 startTime: Time.block_timestamp()
1958             })
1959         );
1960         stakingPlan.lockupPeriod = lockupPeriod;
1961         stakingPlan.createdAt = Time.block_timestamp();
1962 
1963         emit StakingPlanCreated(name);
1964     }
1965 
1966     function deactivateStakingPlan(bytes32 name) public onlyOwner {
1967         _checkStakingPlanActive(name);
1968 
1969         StakingPlan storage stakingPlan = stakingPlans[name];
1970         stakingPlan.deactivatedAt = Time.block_timestamp();
1971 
1972         emit StakingPlanDeactivated(name);
1973     }
1974 
1975     function updateStakingRewardRate(bytes32 name, uint256 rewardRateX96)
1976         public
1977         onlyOperator
1978     {
1979         _checkStakingPlanActive(name);
1980 
1981         StakingPlan storage stakingPlan = stakingPlans[name];
1982         stakingPlan.rewardRates.push(
1983             StakingRewardRate({
1984                 rewardRateX96: rewardRateX96,
1985                 startTime: Time.current_hour_timestamp()
1986             })
1987         );
1988 
1989         emit StakingRewardRateUpdated(name, rewardRateX96);
1990     }
1991 
1992     function updateStakingPowerMultiplier(bytes32 name, uint64 multiplier)
1993         public
1994         onlyOperator
1995     {
1996         _checkStakingPlanActive(name);
1997 
1998         StakingPlan storage stakingPlan = stakingPlans[name];
1999         stakingPlan.multipliers.push(
2000             StakingPowerMultiplier({
2001                 multiplier: multiplier,
2002                 startTime: Time.block_timestamp()
2003             })
2004         );
2005 
2006         emit StakingPowerMultiplierUpdated(name, multiplier);
2007     }
2008 
2009     /* Staking-Related Functions */
2010     function stake(
2011         address recipient,
2012         bytes32 stakingPlan,
2013         uint256 amount
2014     ) external returns (uint256 tokenId) {
2015         require(amount > 0, "amount is 0");
2016         _checkStakingPlanActive(stakingPlan);
2017 
2018         // transfer QLT
2019         QLTContract.transferFrom(msg.sender, address(this), amount);
2020 
2021         // mint
2022         tokenIdCounter += 1;
2023         tokenId = tokenIdCounter;
2024         _mint(recipient, tokenId);
2025         _approve(address(this), tokenId);
2026 
2027         // update staking info
2028         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2029         stakingInfo.stakingPlan = stakingPlan;
2030         stakingInfo.stakedAmount = amount;
2031         stakingInfo.stakeTime = Time.block_timestamp();
2032         stakingInfo.lastHarvestTime = Time.current_hour_timestamp();
2033 
2034         // update staking plan info
2035         stakingPlans[stakingPlan].stakingAmount += amount;
2036         totalStakingAmount += amount;
2037 
2038         emit Stake(tokenId, recipient, stakingPlan, amount);
2039     }
2040 
2041     function unstake(uint256 tokenId) external returns (uint256 rewardAmount) {
2042         _checkOwnershipOfStakingToken(tokenId);
2043 
2044         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2045         uint64 lockupPeriod = stakingPlans[stakingInfo.stakingPlan]
2046             .lockupPeriod;
2047         uint64 stakeTime = stakingInfo.stakeTime;
2048         uint64 unstakeTime = stakingInfo.unstakeTime;
2049 
2050         if (msg.sender == treasuryAddress) {
2051             lockupPeriod = 0;
2052         }
2053 
2054         require(unstakeTime == 0, "already unstaked");
2055         require(
2056             Time.block_timestamp() >= (stakeTime + lockupPeriod),
2057             "still in lockup"
2058         );
2059 
2060         // harvest first
2061         rewardAmount = harvestInternal(tokenId);
2062 
2063         // update staking info
2064         uint256 unstakedAmount = stakingInfo.stakedAmount;
2065         stakingInfo.unstakeTime = Time.block_timestamp();
2066 
2067         // update staking plan info
2068         stakingPlans[stakingInfo.stakingPlan].stakingAmount -= unstakedAmount;
2069         totalStakingAmount -= unstakedAmount;
2070 
2071         emit Unstake(tokenId);
2072     }
2073 
2074     function redeem(uint256 tokenId) external returns (uint256 redeemedAmount) {
2075         _checkOwnershipOfStakingToken(tokenId);
2076 
2077         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2078         uint64 unstakeTime = stakingInfo.unstakeTime;
2079         uint64 redeemTime = stakingInfo.redeemTime;
2080         uint64 _unstakeLockupPeriod = unstakeLockupPeriod;
2081 
2082         if (msg.sender == treasuryAddress) {
2083             _unstakeLockupPeriod = 0;
2084         }
2085 
2086         // check if can unstake
2087         require(unstakeTime > 0, "not unstaked");
2088         require(
2089             Time.block_timestamp() >= (unstakeTime + _unstakeLockupPeriod),
2090             "still in lockup"
2091         );
2092         require(redeemTime == 0, "already redeemed");
2093 
2094         // recycle and burn staking NFT
2095         address staker = ownerOf(tokenId);
2096         transferFrom(msg.sender, address(this), tokenId);
2097         _burn(tokenId);
2098 
2099         // transfer QLT back to staker
2100         redeemedAmount = stakingInfo.stakedAmount;
2101         QLTContract.transfer(staker, redeemedAmount);
2102 
2103         // update staking info
2104         stakingInfo.redeemTime = Time.block_timestamp();
2105 
2106         emit Redeem(tokenId, redeemedAmount);
2107     }
2108 
2109     function harvest(uint256 tokenId) external returns (uint256 rewardAmount) {
2110         return harvestInternal(tokenId);
2111     }
2112 
2113     function harvestAll(uint256[] calldata tokenIds)
2114         external
2115         returns (uint256 rewardAmount)
2116     {
2117         for (uint256 i = 0; i < tokenIds.length; i++) {
2118             rewardAmount += harvestInternal(tokenIds[i]);
2119         }
2120 
2121         emit HarvestAll(tokenIds, rewardAmount);
2122     }
2123 
2124     function harvestInternal(uint256 tokenId)
2125         internal
2126         returns (uint256 rewardAmount)
2127     {
2128         require(Time.block_timestamp() >= harvestStartTime, "come back later");
2129         _checkOwnershipOfStakingToken(tokenId);
2130 
2131         rewardAmount = getRewardsToHarvest(tokenId);
2132 
2133         if (rewardAmount > 0) {
2134             // mint QLT to recipient
2135             QLTContract.mint(ownerOf(tokenId), rewardAmount);
2136 
2137             // update staking info
2138             StakingInfo storage stakingInfo = stakingInfos[tokenId];
2139             stakingInfo.lastHarvestTime = Time.current_hour_timestamp();
2140             stakingInfo.accumulatedStakingReward += rewardAmount;
2141 
2142             // update staking plan info
2143             StakingPlan storage stakingPlan = stakingPlans[
2144                 stakingInfo.stakingPlan
2145             ];
2146             stakingPlan.accumulatedStakingReward += rewardAmount;
2147 
2148             emit Harvest(tokenId, rewardAmount);
2149         }
2150     }
2151 
2152     /* Staking State View Functions */
2153     function getRewardsToHarvest(uint256 tokenId)
2154         public
2155         view
2156         returns (uint256 rewardAmount)
2157     {
2158         require(tokenId <= tokenIdCounter, "not existent");
2159 
2160         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2161 
2162         if (stakingInfo.unstakeTime > 0) {
2163             return 0;
2164         }
2165 
2166         StakingPlan storage stakingPlan = stakingPlans[stakingInfo.stakingPlan];
2167 
2168         // calculate compounded rewards of QLT
2169         uint256 stakedAmountX96 = stakingInfo.stakedAmount * Q96;
2170         uint256 compoundedAmountX96 = stakedAmountX96;
2171         uint64 rewardEndTime = Time.current_hour_timestamp();
2172         uint64 lastHarvestTime = stakingInfo.lastHarvestTime;
2173 
2174         StakingRewardRate[] storage rewardRates = stakingPlan.rewardRates;
2175         uint256 i = rewardRates.length;
2176         while (i > 0) {
2177             i--;
2178 
2179             uint64 rewardStartTime = rewardRates[i].startTime;
2180             uint256 rewardRateX96 = rewardRates[i].rewardRateX96;
2181             uint256 nCompounds;
2182 
2183             if (rewardEndTime < rewardStartTime) {
2184                 continue;
2185             }
2186 
2187             if (rewardStartTime >= lastHarvestTime) {
2188                 nCompounds = (rewardEndTime - rewardStartTime) / 1 hours;
2189                 compoundedAmountX96 = compoundedAmountX96.mulX96(
2190                     Math.compound(rewardRateX96, nCompounds)
2191                 );
2192                 rewardEndTime = rewardStartTime;
2193             } else {
2194                 nCompounds = (rewardEndTime - lastHarvestTime) / 1 hours;
2195                 compoundedAmountX96 = compoundedAmountX96.mulX96(
2196                     Math.compound(rewardRateX96, nCompounds)
2197                 );
2198                 break;
2199             }
2200         }
2201 
2202         rewardAmount = (compoundedAmountX96 - stakedAmountX96) / Q96;
2203     }
2204 
2205     function getAllRewardsToHarvest(uint256[] calldata tokenIds)
2206         public
2207         view
2208         returns (uint256 rewardAmount)
2209     {
2210         for (uint256 i = 0; i < tokenIds.length; i++) {
2211             rewardAmount += getRewardsToHarvest(tokenIds[i]);
2212         }
2213     }
2214 
2215     function getStakingPower(
2216         uint256 tokenId,
2217         uint64 startTime,
2218         uint64 endTime
2219     ) public view returns (uint256 stakingPower) {
2220         require(tokenId <= tokenIdCounter, "not existent");
2221 
2222         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2223         if (stakingInfo.stakeTime >= endTime || stakingInfo.unstakeTime > 0) {
2224             return 0;
2225         }
2226         if (stakingInfo.stakeTime > startTime) {
2227             startTime = stakingInfo.stakeTime;
2228         }
2229 
2230         StakingPlan storage stakingPlan = stakingPlans[stakingInfo.stakingPlan];
2231         uint256 stakedAmount = stakingInfo.stakedAmount;
2232         StakingPowerMultiplier[] storage multipliers = stakingPlan.multipliers;
2233         uint256 i = multipliers.length;
2234         while (i > 0) {
2235             i--;
2236 
2237             uint64 rewardStartTime = multipliers[i].startTime;
2238             uint256 multiplier = multipliers[i].multiplier;
2239 
2240             if (rewardStartTime >= endTime) {
2241                 continue;
2242             }
2243 
2244             if (rewardStartTime >= startTime) {
2245                 stakingPower +=
2246                     stakedAmount *
2247                     (endTime - rewardStartTime) *
2248                     multiplier;
2249                 endTime = rewardStartTime;
2250             } else {
2251                 stakingPower +=
2252                     stakedAmount *
2253                     (endTime - startTime) *
2254                     multiplier;
2255                 break;
2256             }
2257         }
2258     }
2259 
2260     function getAllStakingPower(
2261         uint256[] calldata tokenIds,
2262         uint64 startTime,
2263         uint64 endTime
2264     ) public view returns (uint256 stakingPower) {
2265         for (uint256 i = 0; i < tokenIds.length; i++) {
2266             stakingPower += getStakingPower(tokenIds[i], startTime, endTime);
2267         }
2268     }
2269 
2270     /* Config Setters */
2271     function setHarvestStartTime(uint64 _harvestStartTime) external onlyOwner {
2272         harvestStartTime = _harvestStartTime;
2273     }
2274 
2275     function setUnstakeLockupPeriod(uint64 _unstakeLockupPeriod)
2276         external
2277         onlyOwner
2278     {
2279         unstakeLockupPeriod = _unstakeLockupPeriod;
2280     }
2281 
2282     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
2283         treasuryAddress = _treasuryAddress;
2284     }
2285 
2286     /* Helper Functions */
2287     function _checkOwnershipOfStakingToken(uint256 tokenId) internal view {
2288         require(ownerOf(tokenId) == msg.sender, "not owner");
2289     }
2290 
2291     function _checkStakingPlanActive(bytes32 stakingPlan) internal view {
2292         require(
2293             stakingPlans[stakingPlan].deactivatedAt == 0,
2294             "staking plan not active"
2295         );
2296     }
2297 
2298     /* Access Control */
2299     function addAuthorizedOperator(address account) public onlyOwner {
2300         authorizedOperators[account] = true;
2301     }
2302 
2303     function removeAuthorizedOperator(address account) external onlyOwner {
2304         authorizedOperators[account] = false;
2305     }
2306 
2307     modifier onlyOperator() {
2308         require(authorizedOperators[msg.sender], "not authorized");
2309         _;
2310     }
2311 }
2312 
2313 
2314 // File contracts/RewardDistributor.sol
2315 
2316 address constant USDC_ADDR = address(
2317     0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
2318 );
2319 StakedQLT constant STAKED_QLT_CONTRACT = StakedQLT(
2320     0x9D7977891e0d4D3Bc84456DD2838beE6ad484D87
2321 );
2322 uint256 constant MASK = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
2323 
2324 struct Campaign {
2325     bytes32 name;
2326     uint256 totalReward;
2327     uint256 totalStakingPower;
2328     uint128 rewardRate;
2329     uint64 startTime;
2330     uint64 endTime;
2331 }
2332 
2333 contract RewardDistributor is Ownable {
2334     event NewCampaign(
2335         uint256 indexed campaignId,
2336         uint256 indexed createdAt,
2337         uint256 totalReward,
2338         uint256 totalStakingPower,
2339         uint64 startTime,
2340         uint64 endTime
2341     );
2342     event ClaimReward(
2343         uint256 indexed campaignId,
2344         uint256 indexed tokenId,
2345         uint256 indexed timestamp,
2346         address receiver,
2347         uint256 rewardAmount
2348     );
2349 
2350     uint256 public campaignCount;
2351     uint256 public accumulatedRewards;
2352     mapping(uint256 => Campaign) public campaigns;
2353     mapping(uint256 => mapping(uint256 => uint256)) public claimed;
2354     bool public rewardClaimEnabled;
2355 
2356     constructor() {}
2357 
2358     function addCampaign(
2359         bytes32 name,
2360         uint256 totalReward,
2361         uint256 totalStakingPower,
2362         uint64 startTime,
2363         uint64 endTime
2364     ) external onlyOwner {
2365         campaignCount++;
2366         accumulatedRewards += totalReward;
2367 
2368         campaigns[campaignCount] = Campaign({
2369             name: name,
2370             totalReward: totalReward,
2371             totalStakingPower: totalStakingPower,
2372             rewardRate: uint128(totalStakingPower / totalReward),
2373             startTime: startTime,
2374             endTime: endTime
2375         });
2376 
2377         emit NewCampaign(
2378             campaignCount,
2379             block.timestamp,
2380             totalReward,
2381             totalStakingPower,
2382             startTime,
2383             endTime
2384         );
2385     }
2386 
2387     function setRewardClaimEnabled(bool _rewardClaimEnabled) external onlyOwner {
2388         rewardClaimEnabled = _rewardClaimEnabled;
2389     }
2390 
2391     function claimAllRewards(
2392         uint256[] calldata campaignIds,
2393         uint256[] calldata tokenIds
2394     ) external {
2395         require(rewardClaimEnabled, "come back later");
2396 
2397         uint256 totalRewardAmount = 0;
2398 
2399         for (uint256 j = 0; j < tokenIds.length; j++) {
2400             require(
2401                 STAKED_QLT_CONTRACT.ownerOf(tokenIds[j]) == msg.sender,
2402                 "not owner"
2403             );
2404         }
2405 
2406         for (uint256 i = 0; i < campaignIds.length; i++) {
2407             uint256 campaignId = campaignIds[i];
2408             Campaign storage campaign = campaigns[campaignId];
2409             uint128 rewardRate = campaign.rewardRate;
2410             uint64 startTime = campaign.startTime;
2411             uint64 endTime = campaign.endTime;
2412             for (uint256 j = 0; j < tokenIds.length; j++) {
2413                 uint256 tokenId = tokenIds[j];
2414                 uint256 flag = (1 << (tokenId & 0xff));
2415 
2416                 if (claimed[campaignId][tokenId & MASK] & flag > 0) {
2417                     continue;
2418                 }
2419 
2420                 uint256 stakingPower = STAKED_QLT_CONTRACT.getStakingPower(
2421                     tokenId,
2422                     startTime,
2423                     endTime
2424                 );
2425                 uint256 rewardAmount = stakingPower / rewardRate;
2426 
2427                 if (rewardAmount > 0) {
2428                     claimed[campaignId][tokenId & MASK] |= flag;
2429 
2430                     totalRewardAmount += rewardAmount;
2431 
2432                     emit ClaimReward(
2433                         campaignId,
2434                         tokenId,
2435                         block.timestamp,
2436                         msg.sender,
2437                         rewardAmount
2438                     );
2439                 }
2440             }
2441         }
2442 
2443         require((totalRewardAmount > 0), "no claimable reward");
2444 
2445         TransferHelper.safeTransfer(USDC_ADDR, msg.sender, totalRewardAmount);
2446     }
2447 
2448     function getClaimableCampaigns(uint256[] calldata tokenIds)
2449         public
2450         view
2451         returns (bool[] memory campaignIds)
2452     {
2453         bool[] memory ids = new bool[](campaignCount);
2454         for (
2455             uint256 campaignId = 1;
2456             campaignId <= campaignCount;
2457             campaignId++
2458         ) {
2459             for (uint256 i = 0; i < tokenIds.length; i++) {
2460                 if (getClaimableRewards(campaignId, tokenIds[i]) > 0) {
2461                     ids[campaignId - 1] = true;
2462                     break;
2463                 }
2464             }
2465         }
2466         return ids;
2467     }
2468 
2469     function getAllClaimableRewards(
2470         uint256[] calldata campaignIds,
2471         uint256[] calldata tokenIds
2472     ) public view returns (uint256 rewardAmount) {
2473         rewardAmount = 0;
2474 
2475         for (uint256 i = 0; i < campaignIds.length; i++) {
2476             for (uint256 j = 0; j < tokenIds.length; j++) {
2477                 rewardAmount += getClaimableRewards(
2478                     campaignIds[i],
2479                     tokenIds[j]
2480                 );
2481             }
2482         }
2483     }
2484 
2485     function getClaimableRewards(uint256 campaignId, uint256 tokenId)
2486         public
2487         view
2488         returns (uint256 rewardAmount)
2489     {
2490         if (claimed[campaignId][tokenId & MASK] & (1 << (tokenId & 0xff)) > 0) {
2491             return 0;
2492         }
2493 
2494         Campaign storage campaign = campaigns[campaignId];
2495         uint256 stakingPower = STAKED_QLT_CONTRACT.getStakingPower(
2496             tokenId,
2497             campaign.startTime,
2498             campaign.endTime
2499         );
2500         rewardAmount = stakingPower / campaign.rewardRate;
2501     }
2502 
2503     function transferToken(
2504         address token,
2505         address to,
2506         uint256 value
2507     ) external onlyOwner {
2508         TransferHelper.safeTransfer(token, to, value);
2509     }
2510 
2511     function call(address target, bytes calldata payload) external onlyOwner {
2512         (bool success, ) = target.call(payload);
2513         require(success);
2514     }
2515 }