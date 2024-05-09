1 /**
2  *Submitted for verification at Etherscan.io on 2021-2-10
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // Shiba Doodles
8 
9 /*
10 Shiba Doodles is a passion project inspired by a prominent web3 project and one of the 
11 internet’s most iconic meme - Doodles and Shibas. Community-driven where owners are a 
12 part of something bigger. Become a part of the 8,888 shibas em-barking throughout the 
13 ethererum network.
14 **/
15 
16 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
17 pragma solidity ^0.8.0;
18 
19 interface IERC165 {
20     function supportsInterface(bytes4 interfaceId) external view returns (bool);
21 }
22 
23 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(
34         address indexed from,
35         address indexed to,
36         uint256 indexed tokenId
37     );
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(
43         address indexed owner,
44         address indexed approved,
45         uint256 indexed tokenId
46     );
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(
52         address indexed owner,
53         address indexed operator,
54         bool approved
55     );
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     function safeTransferFrom(
65         address from,
66         address to,
67         uint256 tokenId
68     ) external;
69 
70     function transferFrom(
71         address from,
72         address to,
73         uint256 tokenId
74     ) external;
75 
76     function approve(address to, uint256 tokenId) external;
77 
78     function getApproved(uint256 tokenId)
79         external
80         view
81         returns (address operator);
82 
83     function setApprovalForAll(address operator, bool _approved) external;
84 
85     function isApprovedForAll(address owner, address operator)
86         external
87         view
88         returns (bool);
89 
90     function safeTransferFrom(
91         address from,
92         address to,
93         uint256 tokenId,
94         bytes calldata data
95     ) external;
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
103  * @dev See https://eips.ethereum.org/EIPS/eip-721
104  */
105 interface IERC721Enumerable is IERC721 {
106     /**
107      * @dev Returns the total amount of tokens stored by the contract.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
113      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
114      */
115     function tokenOfOwnerByIndex(address owner, uint256 index)
116         external
117         view
118         returns (uint256 tokenId);
119 
120     /**
121      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
122      * Use along with {totalSupply} to enumerate all tokens.
123      */
124     function tokenByIndex(uint256 index) external view returns (uint256);
125 }
126 
127 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
128 pragma solidity ^0.8.0;
129 
130 abstract contract ERC165 is IERC165 {
131     /**
132      * @dev See {IERC165-supportsInterface}.
133      */
134     function supportsInterface(bytes4 interfaceId)
135         public
136         view
137         virtual
138         override
139         returns (bool)
140     {
141         return interfaceId == type(IERC165).interfaceId;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Strings.sol
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev String operations.
151  */
152 library Strings {
153     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
154 
155     /**
156      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
157      */
158     function toString(uint256 value) internal pure returns (string memory) {
159         // Inspired by OraclizeAPI's implementation - MIT licence
160         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
161 
162         if (value == 0) {
163             return "0";
164         }
165         uint256 temp = value;
166         uint256 digits;
167         while (temp != 0) {
168             digits++;
169             temp /= 10;
170         }
171         bytes memory buffer = new bytes(digits);
172         while (value != 0) {
173             digits -= 1;
174             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
175             value /= 10;
176         }
177         return string(buffer);
178     }
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
182      */
183     function toHexString(uint256 value) internal pure returns (string memory) {
184         if (value == 0) {
185             return "0x00";
186         }
187         uint256 temp = value;
188         uint256 length = 0;
189         while (temp != 0) {
190             length++;
191             temp >>= 8;
192         }
193         return toHexString(value, length);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
198      */
199     function toHexString(uint256 value, uint256 length)
200         internal
201         pure
202         returns (string memory)
203     {
204         bytes memory buffer = new bytes(2 * length + 2);
205         buffer[0] = "0";
206         buffer[1] = "x";
207         for (uint256 i = 2 * length + 1; i > 1; --i) {
208             buffer[i] = _HEX_SYMBOLS[value & 0xf];
209             value >>= 4;
210         }
211         require(value == 0, "Strings: hex length insufficient");
212         return string(buffer);
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Address.sol
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @dev Collection of functions related to the address type
222  */
223 library Address {
224     function isContract(address account) internal view returns (bool) {
225         uint256 size;
226         assembly {
227             size := extcodesize(account)
228         }
229         return size > 0;
230     }
231 
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(
234             address(this).balance >= amount,
235             "Address: insufficient balance"
236         );
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         require(
240             success,
241             "Address: unable to send value, recipient may have reverted"
242         );
243     }
244 
245     function functionCall(address target, bytes memory data)
246         internal
247         returns (bytes memory)
248     {
249         return functionCall(target, data, "Address: low-level call failed");
250     }
251 
252     function functionCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, 0, errorMessage);
258     }
259 
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return
266             functionCallWithValue(
267                 target,
268                 data,
269                 value,
270                 "Address: low-level call with value failed"
271             );
272     }
273 
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(
281             address(this).balance >= value,
282             "Address: insufficient balance for call"
283         );
284         require(isContract(target), "Address: call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.call{value: value}(
287             data
288         );
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     function functionStaticCall(address target, bytes memory data)
293         internal
294         view
295         returns (bytes memory)
296     {
297         return
298             functionStaticCall(
299                 target,
300                 data,
301                 "Address: low-level static call failed"
302             );
303     }
304 
305     function functionStaticCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal view returns (bytes memory) {
310         require(isContract(target), "Address: static call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.staticcall(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     function functionDelegateCall(address target, bytes memory data)
317         internal
318         returns (bytes memory)
319     {
320         return
321             functionDelegateCall(
322                 target,
323                 data,
324                 "Address: low-level delegate call failed"
325             );
326     }
327 
328     function functionDelegateCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(isContract(target), "Address: delegate call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.delegatecall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     function verifyCallResult(
340         bool success,
341         bytes memory returndata,
342         string memory errorMessage
343     ) internal pure returns (bytes memory) {
344         if (success) {
345             return returndata;
346         } else {
347             // Look for revert reason and bubble it up if present
348             if (returndata.length > 0) {
349                 // The easiest way to bubble the revert reason is using memory via assembly
350 
351                 assembly {
352                     let returndata_size := mload(returndata)
353                     revert(add(32, returndata), returndata_size)
354                 }
355             } else {
356                 revert(errorMessage);
357             }
358         }
359     }
360 }
361 
362 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
368  * @dev See https://eips.ethereum.org/EIPS/eip-721
369  */
370 interface IERC721Metadata is IERC721 {
371     /**
372      * @dev Returns the token collection name.
373      */
374     function name() external view returns (string memory);
375 
376     /**
377      * @dev Returns the token collection symbol.
378      */
379     function symbol() external view returns (string memory);
380 
381     /**
382      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
383      */
384     function tokenURI(uint256 tokenId) external view returns (string memory);
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
388 
389 pragma solidity ^0.8.0;
390 
391 interface IERC721Receiver {
392     function onERC721Received(
393         address operator,
394         address from,
395         uint256 tokenId,
396         bytes calldata data
397     ) external returns (bytes4);
398 }
399 
400 // File: @openzeppelin/contracts/utils/Context.sol
401 pragma solidity ^0.8.0;
402 
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         return msg.data;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
414 pragma solidity ^0.8.0;
415 
416 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
417     using Address for address;
418     using Strings for uint256;
419 
420     // Token name
421     string private _name;
422 
423     // Token symbol
424     string private _symbol;
425 
426     // Mapping from token ID to owner address
427     mapping(uint256 => address) private _owners;
428 
429     // Mapping owner address to token count
430     mapping(address => uint256) private _balances;
431 
432     // Mapping from token ID to approved address
433     mapping(uint256 => address) private _tokenApprovals;
434 
435     // Mapping from owner to operator approvals
436     mapping(address => mapping(address => bool)) private _operatorApprovals;
437 
438     /**
439      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
440      */
441     constructor(string memory name_, string memory symbol_) {
442         _name = name_;
443         _symbol = symbol_;
444     }
445 
446     /**
447      * @dev See {IERC165-supportsInterface}.
448      */
449     function supportsInterface(bytes4 interfaceId)
450         public
451         view
452         virtual
453         override(ERC165, IERC165)
454         returns (bool)
455     {
456         return
457             interfaceId == type(IERC721).interfaceId ||
458             interfaceId == type(IERC721Metadata).interfaceId ||
459             super.supportsInterface(interfaceId);
460     }
461 
462     /**
463      * @dev See {IERC721-balanceOf}.
464      */
465     function balanceOf(address owner)
466         public
467         view
468         virtual
469         override
470         returns (uint256)
471     {
472         require(
473             owner != address(0),
474             "ERC721: balance query for the zero address"
475         );
476         return _balances[owner];
477     }
478 
479     /**
480      * @dev See {IERC721-ownerOf}.
481      */
482     function ownerOf(uint256 tokenId)
483         public
484         view
485         virtual
486         override
487         returns (address)
488     {
489         address owner = _owners[tokenId];
490         require(
491             owner != address(0),
492             "ERC721: owner query for nonexistent token"
493         );
494         return owner;
495     }
496 
497     /**
498      * @dev See {IERC721Metadata-name}.
499      */
500     function name() public view virtual override returns (string memory) {
501         return _name;
502     }
503 
504     /**
505      * @dev See {IERC721Metadata-symbol}.
506      */
507     function symbol() public view virtual override returns (string memory) {
508         return _symbol;
509     }
510 
511     /**
512      * @dev See {IERC721Metadata-tokenURI}.
513      */
514     function tokenURI(uint256 tokenId)
515         public
516         view
517         virtual
518         override
519         returns (string memory)
520     {
521         require(
522             _exists(tokenId),
523             "ERC721Metadata: URI query for nonexistent token"
524         );
525 
526         string memory baseURI = _baseURI();
527         return
528             bytes(baseURI).length > 0
529                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
530                 : "";
531     }
532 
533     function _baseURI() internal view virtual returns (string memory) {
534         return "";
535     }
536 
537     /**
538      * @dev See {IERC721-approve}.
539      */
540     function approve(address to, uint256 tokenId) public virtual override {
541         address owner = ERC721.ownerOf(tokenId);
542         require(to != owner, "ERC721: approval to current owner");
543 
544         require(
545             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
546             "ERC721: approve caller is not owner nor approved for all"
547         );
548 
549         _approve(to, tokenId);
550     }
551 
552     /**
553      * @dev See {IERC721-getApproved}.
554      */
555     function getApproved(uint256 tokenId)
556         public
557         view
558         virtual
559         override
560         returns (address)
561     {
562         require(
563             _exists(tokenId),
564             "ERC721: approved query for nonexistent token"
565         );
566 
567         return _tokenApprovals[tokenId];
568     }
569 
570     /**
571      * @dev See {IERC721-setApprovalForAll}.
572      */
573     function setApprovalForAll(address operator, bool approved)
574         public
575         virtual
576         override
577     {
578         require(operator != _msgSender(), "ERC721: approve to caller");
579 
580         _operatorApprovals[_msgSender()][operator] = approved;
581         emit ApprovalForAll(_msgSender(), operator, approved);
582     }
583 
584     /**
585      * @dev See {IERC721-isApprovedForAll}.
586      */
587     function isApprovedForAll(address owner, address operator)
588         public
589         view
590         virtual
591         override
592         returns (bool)
593     {
594         return _operatorApprovals[owner][operator];
595     }
596 
597     /**
598      * @dev See {IERC721-transferFrom}.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) public virtual override {
605         //solhint-disable-next-line max-line-length
606         require(
607             _isApprovedOrOwner(_msgSender(), tokenId),
608             "ERC721: transfer caller is not owner nor approved"
609         );
610 
611         _transfer(from, to, tokenId);
612     }
613 
614     /**
615      * @dev See {IERC721-safeTransferFrom}.
616      */
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) public virtual override {
622         safeTransferFrom(from, to, tokenId, "");
623     }
624 
625     /**
626      * @dev See {IERC721-safeTransferFrom}.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes memory _data
633     ) public virtual override {
634         require(
635             _isApprovedOrOwner(_msgSender(), tokenId),
636             "ERC721: transfer caller is not owner nor approved"
637         );
638         _safeTransfer(from, to, tokenId, _data);
639     }
640 
641     function _safeTransfer(
642         address from,
643         address to,
644         uint256 tokenId,
645         bytes memory _data
646     ) internal virtual {
647         _transfer(from, to, tokenId);
648         require(
649             _checkOnERC721Received(from, to, tokenId, _data),
650             "ERC721: transfer to non ERC721Receiver implementer"
651         );
652     }
653 
654     function _exists(uint256 tokenId) internal view virtual returns (bool) {
655         return _owners[tokenId] != address(0);
656     }
657 
658     function _isApprovedOrOwner(address spender, uint256 tokenId)
659         internal
660         view
661         virtual
662         returns (bool)
663     {
664         require(
665             _exists(tokenId),
666             "ERC721: operator query for nonexistent token"
667         );
668         address owner = ERC721.ownerOf(tokenId);
669         return (spender == owner ||
670             getApproved(tokenId) == spender ||
671             isApprovedForAll(owner, spender));
672     }
673 
674     function _safeMint(address to, uint256 tokenId) internal virtual {
675         _safeMint(to, tokenId, "");
676     }
677 
678     function _safeMint(
679         address to,
680         uint256 tokenId,
681         bytes memory _data
682     ) internal virtual {
683         _mint(to, tokenId);
684         require(
685             _checkOnERC721Received(address(0), to, tokenId, _data),
686             "ERC721: transfer to non ERC721Receiver implementer"
687         );
688     }
689 
690     function _mint(address to, uint256 tokenId) internal virtual {
691         require(to != address(0), "ERC721: mint to the zero address");
692         require(!_exists(tokenId), "ERC721: token already minted");
693 
694         _beforeTokenTransfer(address(0), to, tokenId);
695 
696         _balances[to] += 1;
697         _owners[tokenId] = to;
698 
699         emit Transfer(address(0), to, tokenId);
700     }
701 
702     function _burn(uint256 tokenId) internal virtual {
703         address owner = ERC721.ownerOf(tokenId);
704 
705         _beforeTokenTransfer(owner, address(0), tokenId);
706 
707         // Clear approvals
708         _approve(address(0), tokenId);
709 
710         _balances[owner] -= 1;
711         delete _owners[tokenId];
712 
713         emit Transfer(owner, address(0), tokenId);
714     }
715 
716     /**
717      * @dev Transfers `tokenId` from `from` to `to`.
718      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
719      *
720      * Requirements:
721      *
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must be owned by `from`.
724      *
725      * Emits a {Transfer} event.
726      */
727     function _transfer(
728         address from,
729         address to,
730         uint256 tokenId
731     ) internal virtual {
732         require(
733             ERC721.ownerOf(tokenId) == from,
734             "ERC721: transfer of token that is not own"
735         );
736         require(to != address(0), "ERC721: transfer to the zero address");
737 
738         _beforeTokenTransfer(from, to, tokenId);
739 
740         // Clear approvals from the previous owner
741         _approve(address(0), tokenId);
742 
743         _balances[from] -= 1;
744         _balances[to] += 1;
745         _owners[tokenId] = to;
746 
747         emit Transfer(from, to, tokenId);
748     }
749 
750     function _approve(address to, uint256 tokenId) internal virtual {
751         _tokenApprovals[tokenId] = to;
752         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
753     }
754 
755     function _checkOnERC721Received(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes memory _data
760     ) private returns (bool) {
761         if (to.isContract()) {
762             try
763                 IERC721Receiver(to).onERC721Received(
764                     _msgSender(),
765                     from,
766                     tokenId,
767                     _data
768                 )
769             returns (bytes4 retval) {
770                 return retval == IERC721Receiver.onERC721Received.selector;
771             } catch (bytes memory reason) {
772                 if (reason.length == 0) {
773                     revert(
774                         "ERC721: transfer to non ERC721Receiver implementer"
775                     );
776                 } else {
777                     assembly {
778                         revert(add(32, reason), mload(reason))
779                     }
780                 }
781             }
782         } else {
783             return true;
784         }
785     }
786 
787     function _beforeTokenTransfer(
788         address from,
789         address to,
790         uint256 tokenId
791     ) internal virtual {}
792 }
793 
794 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
795 
796 pragma solidity ^0.8.0;
797 
798 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
799     // Mapping from owner to list of owned token IDs
800     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
801 
802     // Mapping from token ID to index of the owner tokens list
803     mapping(uint256 => uint256) private _ownedTokensIndex;
804 
805     // Array with all token ids, used for enumeration
806     uint256[] private _allTokens;
807 
808     // Mapping from token id to position in the allTokens array
809     mapping(uint256 => uint256) private _allTokensIndex;
810 
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId)
815         public
816         view
817         virtual
818         override(IERC165, ERC721)
819         returns (bool)
820     {
821         return
822             interfaceId == type(IERC721Enumerable).interfaceId ||
823             super.supportsInterface(interfaceId);
824     }
825 
826     /**
827      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
828      */
829     function tokenOfOwnerByIndex(address owner, uint256 index)
830         public
831         view
832         virtual
833         override
834         returns (uint256)
835     {
836         require(
837             index < ERC721.balanceOf(owner),
838             "ERC721Enumerable: owner index out of bounds"
839         );
840         return _ownedTokens[owner][index];
841     }
842 
843     /**
844      * @dev See {IERC721Enumerable-totalSupply}.
845      */
846     function totalSupply() public view virtual override returns (uint256) {
847         return _allTokens.length;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-tokenByIndex}.
852      */
853     function tokenByIndex(uint256 index)
854         public
855         view
856         virtual
857         override
858         returns (uint256)
859     {
860         require(
861             index < ERC721Enumerable.totalSupply(),
862             "ERC721Enumerable: global index out of bounds"
863         );
864         return _allTokens[index];
865     }
866 
867     function _beforeTokenTransfer(
868         address from,
869         address to,
870         uint256 tokenId
871     ) internal virtual override {
872         super._beforeTokenTransfer(from, to, tokenId);
873 
874         if (from == address(0)) {
875             _addTokenToAllTokensEnumeration(tokenId);
876         } else if (from != to) {
877             _removeTokenFromOwnerEnumeration(from, tokenId);
878         }
879         if (to == address(0)) {
880             _removeTokenFromAllTokensEnumeration(tokenId);
881         } else if (to != from) {
882             _addTokenToOwnerEnumeration(to, tokenId);
883         }
884     }
885 
886     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
887         uint256 length = ERC721.balanceOf(to);
888         _ownedTokens[to][length] = tokenId;
889         _ownedTokensIndex[tokenId] = length;
890     }
891 
892     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
893         _allTokensIndex[tokenId] = _allTokens.length;
894         _allTokens.push(tokenId);
895     }
896 
897     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
898         private
899     {
900         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
901         uint256 tokenIndex = _ownedTokensIndex[tokenId];
902 
903         // When the token to delete is the last token, the swap operation is unnecessary
904         if (tokenIndex != lastTokenIndex) {
905             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
906 
907             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
908             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
909         }
910 
911         // This also deletes the contents at the last position of the array
912         delete _ownedTokensIndex[tokenId];
913         delete _ownedTokens[from][lastTokenIndex];
914     }
915 
916     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
917         uint256 lastTokenIndex = _allTokens.length - 1;
918         uint256 tokenIndex = _allTokensIndex[tokenId];
919 
920         uint256 lastTokenId = _allTokens[lastTokenIndex];
921 
922         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
923         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
924 
925         delete _allTokensIndex[tokenId];
926         _allTokens.pop();
927     }
928 }
929 
930 // File: @openzeppelin/contracts/access/Ownable.sol
931 pragma solidity ^0.8.0;
932 
933 abstract contract Ownable is Context {
934     address private _owner;
935 
936     event OwnershipTransferred(
937         address indexed previousOwner,
938         address indexed newOwner
939     );
940 
941     /**
942      * @dev Initializes the contract setting the deployer as the initial owner.
943      */
944     constructor() {
945         _setOwner(_msgSender());
946     }
947 
948     /**
949      * @dev Returns the address of the current owner.
950      */
951     function owner() public view virtual returns (address) {
952         return _owner;
953     }
954 
955     /**
956      * @dev Throws if called by any account other than the owner.
957      */
958     modifier onlyOwner() {
959         require(owner() == _msgSender(), "Ownable: caller is not the owner");
960         _;
961     }
962 
963     function renounceOwnership() public virtual onlyOwner {
964         _setOwner(address(0));
965     }
966 
967     function transferOwnership(address newOwner) public virtual onlyOwner {
968         require(
969             newOwner != address(0),
970             "Ownable: new owner is the zero address"
971         );
972         _setOwner(newOwner);
973     }
974 
975     function _setOwner(address newOwner) private {
976         address oldOwner = _owner;
977         _owner = newOwner;
978         emit OwnershipTransferred(oldOwner, newOwner);
979     }
980 }
981 
982 pragma solidity >=0.7.0 <0.9.0;
983 
984 contract ShibaDoodles is ERC721Enumerable, Ownable {
985     using Strings for uint256;
986 
987     string baseURI;
988     string public baseExtension = ".json";
989     uint256 public cost = 0.0123 ether;
990     uint256 public maxSupply = 8888;
991     uint256 public maxMintAmount = 10;
992     bool public paused = true;
993     bool public dynamicCost = true;
994     bool public revealed = true;
995     string public notRevealedUri;
996 
997     constructor(
998         string memory _name,
999         string memory _symbol,
1000         string memory _initBaseURI,
1001         string memory _initNotRevealedUri
1002     ) ERC721(_name, _symbol) {
1003         setBaseURI(_initBaseURI);
1004         setNotRevealedURI(_initNotRevealedUri);
1005     }
1006 
1007     // internal
1008     function _baseURI() internal view virtual override returns (string memory) {
1009         return baseURI;
1010     }
1011 
1012     function updateMintPrice(uint256 _supply)
1013         internal
1014         view
1015         returns (uint256 _cost)
1016     {
1017         if (_supply < 1000) {
1018             return 0.00 ether;
1019         }
1020         if (_supply < maxSupply) {
1021             return 0.0123 ether;
1022         }
1023     }
1024 
1025     // public
1026     function mint(uint256 _mintAmount) public payable {
1027         uint256 supply = totalSupply();
1028         require(!paused);
1029         require(_mintAmount > 0);
1030         require(_mintAmount <= maxMintAmount);
1031         require(supply + _mintAmount <= maxSupply);
1032         require(
1033             msg.value >= updateMintPrice(supply) * _mintAmount,
1034             "Not enough funds"
1035         );
1036 
1037         for (uint256 i = 1; i <= _mintAmount; i++) {
1038             _safeMint(msg.sender, supply + i);
1039         }
1040     }
1041 
1042     function walletOfOwner(address _owner)
1043         public
1044         view
1045         returns (uint256[] memory)
1046     {
1047         uint256 ownerTokenCount = balanceOf(_owner);
1048         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1049         for (uint256 i; i < ownerTokenCount; i++) {
1050             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1051         }
1052         return tokenIds;
1053     }
1054 
1055     function tokenURI(uint256 tokenId)
1056         public
1057         view
1058         virtual
1059         override
1060         returns (string memory)
1061     {
1062         require(
1063             _exists(tokenId),
1064             "ERC721Metadata: URI query for nonexistent token"
1065         );
1066 
1067         if (revealed == false) {
1068             return notRevealedUri;
1069         }
1070 
1071         string memory currentBaseURI = _baseURI();
1072         return
1073             bytes(currentBaseURI).length > 0
1074                 ? string(
1075                     abi.encodePacked(
1076                         currentBaseURI,
1077                         tokenId.toString(),
1078                         baseExtension
1079                     )
1080                 )
1081                 : "";
1082     }
1083 
1084     //only owner
1085     function reveal() public onlyOwner {
1086         revealed = true;
1087     }
1088 
1089     function setCost(uint256 _newCost) public onlyOwner {
1090         cost = _newCost;
1091     }
1092 
1093     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1094         maxMintAmount = _newmaxMintAmount;
1095     }
1096 
1097     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1098         notRevealedUri = _notRevealedURI;
1099     }
1100 
1101     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1102         baseURI = _newBaseURI;
1103     }
1104 
1105     function setBaseExtension(string memory _newBaseExtension)
1106         public
1107         onlyOwner
1108     {
1109         baseExtension = _newBaseExtension;
1110     }
1111 
1112     function pause(bool _state) public onlyOwner {
1113         paused = _state;
1114     }
1115 
1116     function withdraw() public payable onlyOwner {
1117         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1118         require(os);
1119     }
1120 }