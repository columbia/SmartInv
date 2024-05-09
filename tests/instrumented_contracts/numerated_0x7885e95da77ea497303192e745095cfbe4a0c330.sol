1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 abstract contract ERC165 is IERC165 {
27     /**
28      * @dev See {IERC165-supportsInterface}.
29      */
30     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
31         return interfaceId == type(IERC165).interfaceId;
32     }
33 }
34 
35 pragma solidity ^0.8.0;
36 
37 /*
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         return msg.data;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
58 
59 pragma solidity ^0.8.0;
60 
61 
62 /**
63  * @dev Required interface of an ERC721 compliant contract.
64  */
65 interface IERC721 is IERC165 {
66     /**
67      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
73      */
74     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
78      */
79     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
80 
81     /**
82      * @dev Returns the number of tokens in ``owner``'s account.
83      */
84     function balanceOf(address owner) external view returns (uint256 balance);
85 
86     /**
87      * @dev Returns the owner of the `tokenId` token.
88      *
89      * Requirements:
90      *
91      * - `tokenId` must exist.
92      */
93     function ownerOf(uint256 tokenId) external view returns (address owner);
94 
95     /**
96      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
97      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must exist and be owned by `from`.
104      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
106      *
107      * Emits a {Transfer} event.
108      */
109     function safeTransferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Transfers `tokenId` token from `from` to `to`.
117      *
118      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
119      *
120      * Requirements:
121      *
122      * - `from` cannot be the zero address.
123      * - `to` cannot be the zero address.
124      * - `tokenId` token must be owned by `from`.
125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(
130         address from,
131         address to,
132         uint256 tokenId
133     ) external;
134 
135     /**
136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
137      * The approval is cleared when the token is transferred.
138      *
139      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
140      *
141      * Requirements:
142      *
143      * - The caller must own the token or be an approved operator.
144      * - `tokenId` must exist.
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address to, uint256 tokenId) external;
149 
150     /**
151      * @dev Returns the account approved for `tokenId` token.
152      *
153      * Requirements:
154      *
155      * - `tokenId` must exist.
156      */
157     function getApproved(uint256 tokenId) external view returns (address operator);
158 
159     /**
160      * @dev Approve or remove `operator` as an operator for the caller.
161      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
162      *
163      * Requirements:
164      *
165      * - The `operator` cannot be the caller.
166      *
167      * Emits an {ApprovalForAll} event.
168      */
169     function setApprovalForAll(address operator, bool _approved) external;
170 
171     /**
172      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
173      *
174      * See {setApprovalForAll}
175      */
176     function isApprovedForAll(address owner, address operator) external view returns (bool);
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188      *
189      * Emits a {Transfer} event.
190      */
191     function safeTransferFrom(
192         address from,
193         address to,
194         uint256 tokenId,
195         bytes calldata data
196     ) external;
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
200 
201 pragma solidity ^0.8.0;
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Enumerable is IERC721 {
209     /**
210      * @dev Returns the total amount of tokens stored by the contract.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
216      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
217      */
218     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
219 
220     /**
221      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
222      * Use along with {totalSupply} to enumerate all tokens.
223      */
224     function tokenByIndex(uint256 index) external view returns (uint256);
225 }
226 
227 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev String operations.
233  */
234 library Strings {
235     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
236 
237     /**
238      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
239      */
240     function toString(uint256 value) internal pure returns (string memory) {
241         // Inspired by OraclizeAPI's implementation - MIT licence
242         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
243 
244         if (value == 0) {
245             return "0";
246         }
247         uint256 temp = value;
248         uint256 digits;
249         while (temp != 0) {
250             digits++;
251             temp /= 10;
252         }
253         bytes memory buffer = new bytes(digits);
254         while (value != 0) {
255             digits -= 1;
256             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
257             value /= 10;
258         }
259         return string(buffer);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
264      */
265     function toHexString(uint256 value) internal pure returns (string memory) {
266         if (value == 0) {
267             return "0x00";
268         }
269         uint256 temp = value;
270         uint256 length = 0;
271         while (temp != 0) {
272             length++;
273             temp >>= 8;
274         }
275         return toHexString(value, length);
276     }
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
280      */
281     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
282         bytes memory buffer = new bytes(2 * length + 2);
283         buffer[0] = "0";
284         buffer[1] = "x";
285         for (uint256 i = 2 * length + 1; i > 1; --i) {
286             buffer[i] = _HEX_SYMBOLS[value & 0xf];
287             value >>= 4;
288         }
289         require(value == 0, "Strings: hex length insufficient");
290         return string(buffer);
291     }
292 }
293 
294 pragma solidity ^0.8.0;
295 
296 
297 /**
298  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
299  * @dev See https://eips.ethereum.org/EIPS/eip-721
300  */
301 interface IERC721Metadata is IERC721 {
302     /**
303      * @dev Returns the token collection name.
304      */
305     function name() external view returns (string memory);
306 
307     /**
308      * @dev Returns the token collection symbol.
309      */
310     function symbol() external view returns (string memory);
311 
312     /**
313      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
314      */
315     function tokenURI(uint256 tokenId) external view returns (string memory);
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
324  * the Metadata extension, but not including the Enumerable extension, which is available separately as
325  * {ERC721Enumerable}.
326  */
327 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
328     using Address for address;
329     using Strings for uint256;
330 
331     // Token name
332     string private _name;
333 
334     // Token symbol
335     string private _symbol;
336 
337     // Mapping from token ID to owner address
338     mapping(uint256 => address) private _owners;
339 
340     // Mapping owner address to token count
341     mapping(address => uint256) private _balances;
342 
343     // Mapping from token ID to approved address
344     mapping(uint256 => address) private _tokenApprovals;
345 
346     // Mapping from owner to operator approvals
347     mapping(address => mapping(address => bool)) private _operatorApprovals;
348 
349     /**
350      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
351      */
352     constructor(string memory name_, string memory symbol_) {
353         _name = name_;
354         _symbol = symbol_;
355     }
356 
357     /**
358      * @dev See {IERC165-supportsInterface}.
359      */
360     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
361         return
362             interfaceId == type(IERC721).interfaceId ||
363             interfaceId == type(IERC721Metadata).interfaceId ||
364             super.supportsInterface(interfaceId);
365     }
366 
367     /**
368      * @dev See {IERC721-balanceOf}.
369      */
370     function balanceOf(address owner) public view virtual override returns (uint256) {
371         require(owner != address(0), "ERC721: balance query for the zero address");
372         return _balances[owner];
373     }
374 
375     /**
376      * @dev See {IERC721-ownerOf}.
377      */
378     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
379         address owner = _owners[tokenId];
380         require(owner != address(0), "ERC721: owner query for nonexistent token");
381         return owner;
382     }
383 
384     /**
385      * @dev See {IERC721Metadata-name}.
386      */
387     function name() public view virtual override returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @dev See {IERC721Metadata-symbol}.
393      */
394     function symbol() public view virtual override returns (string memory) {
395         return _symbol;
396     }
397 
398     /**
399      * @dev See {IERC721Metadata-tokenURI}.
400      */
401     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
402         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
403 
404         string memory baseURI = _baseURI();
405         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
406     }
407 
408     /**
409      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
410      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
411      * by default, can be overriden in child contracts.
412      */
413     function _baseURI() internal view virtual returns (string memory) {
414         return "";
415     }
416 
417     /**
418      * @dev See {IERC721-approve}.
419      */
420     function approve(address to, uint256 tokenId) public virtual override {
421         address owner = ERC721.ownerOf(tokenId);
422         require(to != owner, "ERC721: approval to current owner");
423 
424         require(
425             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
426             "ERC721: approve caller is not owner nor approved for all"
427         );
428 
429         _approve(to, tokenId);
430     }
431 
432     /**
433      * @dev See {IERC721-getApproved}.
434      */
435     function getApproved(uint256 tokenId) public view virtual override returns (address) {
436         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
437 
438         return _tokenApprovals[tokenId];
439     }
440 
441     /**
442      * @dev See {IERC721-setApprovalForAll}.
443      */
444     function setApprovalForAll(address operator, bool approved) public virtual override {
445         require(operator != _msgSender(), "ERC721: approve to caller");
446 
447         _operatorApprovals[_msgSender()][operator] = approved;
448         emit ApprovalForAll(_msgSender(), operator, approved);
449     }
450 
451     /**
452      * @dev See {IERC721-isApprovedForAll}.
453      */
454     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
455         return _operatorApprovals[owner][operator];
456     }
457 
458     /**
459      * @dev See {IERC721-transferFrom}.
460      */
461     function transferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) public virtual override {
466         //solhint-disable-next-line max-line-length
467         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
468 
469         _transfer(from, to, tokenId);
470     }
471 
472     /**
473      * @dev See {IERC721-safeTransferFrom}.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) public virtual override {
480         safeTransferFrom(from, to, tokenId, "");
481     }
482 
483     /**
484      * @dev See {IERC721-safeTransferFrom}.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId,
490         bytes memory _data
491     ) public virtual override {
492         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
493         _safeTransfer(from, to, tokenId, _data);
494     }
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
498      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
499      *
500      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
501      *
502      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
503      * implement alternative mechanisms to perform token transfer, such as signature-based.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
511      *
512      * Emits a {Transfer} event.
513      */
514     function _safeTransfer(
515         address from,
516         address to,
517         uint256 tokenId,
518         bytes memory _data
519     ) internal virtual {
520         _transfer(from, to, tokenId);
521         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
522     }
523 
524     /**
525      * @dev Returns whether `tokenId` exists.
526      *
527      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
528      *
529      * Tokens start existing when they are minted (`_mint`),
530      * and stop existing when they are burned (`_burn`).
531      */
532     function _exists(uint256 tokenId) internal view virtual returns (bool) {
533         return _owners[tokenId] != address(0);
534     }
535 
536     /**
537      * @dev Returns whether `spender` is allowed to manage `tokenId`.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
544         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
545         address owner = ERC721.ownerOf(tokenId);
546         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
547     }
548 
549     /**
550      * @dev Safely mints `tokenId` and transfers it to `to`.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must not exist.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function _safeMint(address to, uint256 tokenId) internal virtual {
560         _safeMint(to, tokenId, "");
561     }
562 
563     /**
564      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
565      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
566      */
567     function _safeMint(
568         address to,
569         uint256 tokenId,
570         bytes memory _data
571     ) internal virtual {
572         _mint(to, tokenId);
573         require(
574             _checkOnERC721Received(address(0), to, tokenId, _data),
575             "ERC721: transfer to non ERC721Receiver implementer"
576         );
577     }
578 
579     /**
580      * @dev Mints `tokenId` and transfers it to `to`.
581      *
582      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
583      *
584      * Requirements:
585      *
586      * - `tokenId` must not exist.
587      * - `to` cannot be the zero address.
588      *
589      * Emits a {Transfer} event.
590      */
591     function _mint(address to, uint256 tokenId) internal virtual {
592         require(to != address(0), "ERC721: mint to the zero address");
593         require(!_exists(tokenId), "ERC721: token already minted");
594 
595         _beforeTokenTransfer(address(0), to, tokenId);
596 
597         _balances[to] += 1;
598         _owners[tokenId] = to;
599 
600         emit Transfer(address(0), to, tokenId);
601     }
602 
603     /**
604      * @dev Destroys `tokenId`.
605      * The approval is cleared when the token is burned.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      *
611      * Emits a {Transfer} event.
612      */
613     function _burn(uint256 tokenId) internal virtual {
614         address owner = ERC721.ownerOf(tokenId);
615 
616         _beforeTokenTransfer(owner, address(0), tokenId);
617 
618         // Clear approvals
619         _approve(address(0), tokenId);
620 
621         _balances[owner] -= 1;
622         delete _owners[tokenId];
623 
624         emit Transfer(owner, address(0), tokenId);
625     }
626 
627     /**
628      * @dev Transfers `tokenId` from `from` to `to`.
629      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
630      *
631      * Requirements:
632      *
633      * - `to` cannot be the zero address.
634      * - `tokenId` token must be owned by `from`.
635      *
636      * Emits a {Transfer} event.
637      */
638     function _transfer(
639         address from,
640         address to,
641         uint256 tokenId
642     ) internal virtual {
643         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
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
669      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
670      * The call is not executed if the target address is not a contract.
671      *
672      * @param from address representing the previous owner of the given token ID
673      * @param to target address that will receive the tokens
674      * @param tokenId uint256 ID of the token to be transferred
675      * @param _data bytes optional data to send along with the call
676      * @return bool whether the call correctly returned the expected magic value
677      */
678     function _checkOnERC721Received(
679         address from,
680         address to,
681         uint256 tokenId,
682         bytes memory _data
683     ) private returns (bool) {
684         if (to.isContract()) {
685             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
686                 return retval == IERC721Receiver(to).onERC721Received.selector;
687             } catch (bytes memory reason) {
688                 if (reason.length == 0) {
689                     revert("ERC721: transfer to non ERC721Receiver implementer");
690                 } else {
691                     assembly {
692                         revert(add(32, reason), mload(reason))
693                     }
694                 }
695             }
696         } else {
697             return true;
698         }
699     }
700 
701     /**
702      * @dev Hook that is called before any token transfer. This includes minting
703      * and burning.
704      *
705      * Calling conditions:
706      *
707      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
708      * transferred to `to`.
709      * - When `from` is zero, `tokenId` will be minted for `to`.
710      * - When `to` is zero, ``from``'s `tokenId` will be burned.
711      * - `from` and `to` are never both zero.
712      *
713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
714      */
715     function _beforeTokenTransfer(
716         address from,
717         address to,
718         uint256 tokenId
719     ) internal virtual {}
720 }
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
726  * enumerability of all the token ids in the contract as well as all token ids owned by each
727  * account.
728  */
729 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
730     // Mapping from owner to list of owned token IDs
731     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
732 
733     // Mapping from token ID to index of the owner tokens list
734     mapping(uint256 => uint256) private _ownedTokensIndex;
735 
736     // Array with all token ids, used for enumeration
737     uint256[] private _allTokens;
738 
739     // Mapping from token id to position in the allTokens array
740     mapping(uint256 => uint256) private _allTokensIndex;
741 
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
746         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
751      */
752     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
753         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
754         return _ownedTokens[owner][index];
755     }
756 
757     /**
758      * @dev See {IERC721Enumerable-totalSupply}.
759      */
760     function totalSupply() public view virtual override returns (uint256) {
761         return _allTokens.length;
762     }
763 
764     /**
765      * @dev See {IERC721Enumerable-tokenByIndex}.
766      */
767     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
768         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
769         return _allTokens[index];
770     }
771 
772     /**
773      * @dev Hook that is called before any token transfer. This includes minting
774      * and burning.
775      *
776      * Calling conditions:
777      *
778      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
779      * transferred to `to`.
780      * - When `from` is zero, `tokenId` will be minted for `to`.
781      * - When `to` is zero, ``from``'s `tokenId` will be burned.
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      *
785      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
786      */
787     function _beforeTokenTransfer(
788         address from,
789         address to,
790         uint256 tokenId
791     ) internal virtual override {
792         super._beforeTokenTransfer(from, to, tokenId);
793 
794         if (from == address(0)) {
795             _addTokenToAllTokensEnumeration(tokenId);
796         } else if (from != to) {
797             _removeTokenFromOwnerEnumeration(from, tokenId);
798         }
799         if (to == address(0)) {
800             _removeTokenFromAllTokensEnumeration(tokenId);
801         } else if (to != from) {
802             _addTokenToOwnerEnumeration(to, tokenId);
803         }
804     }
805 
806     /**
807      * @dev Private function to add a token to this extension's ownership-tracking data structures.
808      * @param to address representing the new owner of the given token ID
809      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
810      */
811     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
812         uint256 length = ERC721.balanceOf(to);
813         _ownedTokens[to][length] = tokenId;
814         _ownedTokensIndex[tokenId] = length;
815     }
816 
817     /**
818      * @dev Private function to add a token to this extension's token tracking data structures.
819      * @param tokenId uint256 ID of the token to be added to the tokens list
820      */
821     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
822         _allTokensIndex[tokenId] = _allTokens.length;
823         _allTokens.push(tokenId);
824     }
825 
826     /**
827      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
828      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
829      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
830      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
831      * @param from address representing the previous owner of the given token ID
832      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
833      */
834     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
835         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
836         // then delete the last slot (swap and pop).
837 
838         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
839         uint256 tokenIndex = _ownedTokensIndex[tokenId];
840 
841         // When the token to delete is the last token, the swap operation is unnecessary
842         if (tokenIndex != lastTokenIndex) {
843             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
844 
845             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
846             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
847         }
848 
849         // This also deletes the contents at the last position of the array
850         delete _ownedTokensIndex[tokenId];
851         delete _ownedTokens[from][lastTokenIndex];
852     }
853 
854     /**
855      * @dev Private function to remove a token from this extension's token tracking data structures.
856      * This has O(1) time complexity, but alters the order of the _allTokens array.
857      * @param tokenId uint256 ID of the token to be removed from the tokens list
858      */
859     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
860         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
861         // then delete the last slot (swap and pop).
862 
863         uint256 lastTokenIndex = _allTokens.length - 1;
864         uint256 tokenIndex = _allTokensIndex[tokenId];
865 
866         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
867         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
868         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
869         uint256 lastTokenId = _allTokens[lastTokenIndex];
870 
871         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
872         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
873 
874         // This also deletes the contents at the last position of the array
875         delete _allTokensIndex[tokenId];
876         _allTokens.pop();
877     }
878 }
879 
880 // File: @openzeppelin/contracts/utils/Context.sol
881 
882 pragma solidity ^0.8.0;
883 
884 /**
885  * @dev Collection of functions related to the address type
886  */
887 library Address {
888     /**
889      * @dev Returns true if `account` is a contract.
890      *
891      * [IMPORTANT]
892      * ====
893      * It is unsafe to assume that an address for which this function returns
894      * false is an externally-owned account (EOA) and not a contract.
895      *
896      * Among others, `isContract` will return false for the following
897      * types of addresses:
898      *
899      *  - an externally-owned account
900      *  - a contract in construction
901      *  - an address where a contract will be created
902      *  - an address where a contract lived, but was destroyed
903      * ====
904      */
905     function isContract(address account) internal view returns (bool) {
906         // This method relies on extcodesize, which returns 0 for contracts in
907         // construction, since the code is only stored at the end of the
908         // constructor execution.
909 
910         uint256 size;
911         assembly {
912             size := extcodesize(account)
913         }
914         return size > 0;
915     }
916 
917     /**
918      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
919      * `recipient`, forwarding all available gas and reverting on errors.
920      *
921      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
922      * of certain opcodes, possibly making contracts go over the 2300 gas limit
923      * imposed by `transfer`, making them unable to receive funds via
924      * `transfer`. {sendValue} removes this limitation.
925      *
926      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
927      *
928      * IMPORTANT: because control is transferred to `recipient`, care must be
929      * taken to not create reentrancy vulnerabilities. Consider using
930      * {ReentrancyGuard} or the
931      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
932      */
933     function sendValue(address payable recipient, uint256 amount) internal {
934         require(address(this).balance >= amount, "Address: insufficient balance");
935 
936         (bool success, ) = recipient.call{value: amount}("");
937         require(success, "Address: unable to send value, recipient may have reverted");
938     }
939 
940     /**
941      * @dev Performs a Solidity function call using a low level `call`. A
942      * plain `call` is an unsafe replacement for a function call: use this
943      * function instead.
944      *
945      * If `target` reverts with a revert reason, it is bubbled up by this
946      * function (like regular Solidity function calls).
947      *
948      * Returns the raw returned data. To convert to the expected return value,
949      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
950      *
951      * Requirements:
952      *
953      * - `target` must be a contract.
954      * - calling `target` with `data` must not revert.
955      *
956      * _Available since v3.1._
957      */
958     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
959         return functionCall(target, data, "Address: low-level call failed");
960     }
961 
962     /**
963      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
964      * `errorMessage` as a fallback revert reason when `target` reverts.
965      *
966      * _Available since v3.1._
967      */
968     function functionCall(
969         address target,
970         bytes memory data,
971         string memory errorMessage
972     ) internal returns (bytes memory) {
973         return functionCallWithValue(target, data, 0, errorMessage);
974     }
975 
976     /**
977      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
978      * but also transferring `value` wei to `target`.
979      *
980      * Requirements:
981      *
982      * - the calling contract must have an ETH balance of at least `value`.
983      * - the called Solidity function must be `payable`.
984      *
985      * _Available since v3.1._
986      */
987     function functionCallWithValue(
988         address target,
989         bytes memory data,
990         uint256 value
991     ) internal returns (bytes memory) {
992         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
993     }
994 
995     /**
996      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
997      * with `errorMessage` as a fallback revert reason when `target` reverts.
998      *
999      * _Available since v3.1._
1000      */
1001     function functionCallWithValue(
1002         address target,
1003         bytes memory data,
1004         uint256 value,
1005         string memory errorMessage
1006     ) internal returns (bytes memory) {
1007         require(address(this).balance >= value, "Address: insufficient balance for call");
1008         require(isContract(target), "Address: call to non-contract");
1009 
1010         (bool success, bytes memory returndata) = target.call{value: value}(data);
1011         return _verifyCallResult(success, returndata, errorMessage);
1012     }
1013 
1014     /**
1015      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1016      * but performing a static call.
1017      *
1018      * _Available since v3.3._
1019      */
1020     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1021         return functionStaticCall(target, data, "Address: low-level static call failed");
1022     }
1023 
1024     /**
1025      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1026      * but performing a static call.
1027      *
1028      * _Available since v3.3._
1029      */
1030     function functionStaticCall(
1031         address target,
1032         bytes memory data,
1033         string memory errorMessage
1034     ) internal view returns (bytes memory) {
1035         require(isContract(target), "Address: static call to non-contract");
1036 
1037         (bool success, bytes memory returndata) = target.staticcall(data);
1038         return _verifyCallResult(success, returndata, errorMessage);
1039     }
1040 
1041     /**
1042      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1043      * but performing a delegate call.
1044      *
1045      * _Available since v3.4._
1046      */
1047     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1048         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1053      * but performing a delegate call.
1054      *
1055      * _Available since v3.4._
1056      */
1057     function functionDelegateCall(
1058         address target,
1059         bytes memory data,
1060         string memory errorMessage
1061     ) internal returns (bytes memory) {
1062         require(isContract(target), "Address: delegate call to non-contract");
1063 
1064         (bool success, bytes memory returndata) = target.delegatecall(data);
1065         return _verifyCallResult(success, returndata, errorMessage);
1066     }
1067 
1068     function _verifyCallResult(
1069         bool success,
1070         bytes memory returndata,
1071         string memory errorMessage
1072     ) private pure returns (bytes memory) {
1073         if (success) {
1074             return returndata;
1075         } else {
1076             // Look for revert reason and bubble it up if present
1077             if (returndata.length > 0) {
1078                 // The easiest way to bubble the revert reason is using memory via assembly
1079 
1080                 assembly {
1081                     let returndata_size := mload(returndata)
1082                     revert(add(32, returndata), returndata_size)
1083                 }
1084             } else {
1085                 revert(errorMessage);
1086             }
1087         }
1088     }
1089 }
1090 
1091 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 /**
1096  * @title ERC721 token receiver interface
1097  * @dev Interface for any contract that wants to support safeTransfers
1098  * from ERC721 asset contracts.
1099  */
1100 interface IERC721Receiver {
1101     /**
1102      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1103      * by `operator` from `from`, this function is called.
1104      *
1105      * It must return its Solidity selector to confirm the token transfer.
1106      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1107      *
1108      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1109      */
1110     function onERC721Received(
1111         address operator,
1112         address from,
1113         uint256 tokenId,
1114         bytes calldata data
1115     ) external returns (bytes4);
1116 }
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @dev Contract module which provides a basic access control mechanism, where
1122  * there is an account (an owner) that can be granted exclusive access to
1123  * specific functions.
1124  *
1125  * By default, the owner account will be the one that deploys the contract. This
1126  * can later be changed with {transferOwnership}.
1127  *
1128  * This module is used through inheritance. It will make available the modifier
1129  * `onlyOwner`, which can be applied to your functions to restrict their use to
1130  * the owner.
1131  */
1132 abstract contract Ownable is Context {
1133     address private _owner;
1134 
1135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1136 
1137     /**
1138      * @dev Initializes the contract setting the deployer as the initial owner.
1139      */
1140     constructor() {
1141         _transferOwnership(_msgSender());
1142     }
1143 
1144     /**
1145      * @dev Returns the address of the current owner.
1146      */
1147     function owner() public view virtual returns (address) {
1148         return _owner;
1149     }
1150 
1151     /**
1152      * @dev Throws if called by any account other than the owner.
1153      */
1154     modifier onlyOwner() {
1155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1156         _;
1157     }
1158 
1159     /**
1160      * @dev Leaves the contract without owner. It will not be possible to call
1161      * `onlyOwner` functions anymore. Can only be called by the current owner.
1162      *
1163      * NOTE: Renouncing ownership will leave the contract without an owner,
1164      * thereby removing any functionality that is only available to the owner.
1165      */
1166     function renounceOwnership() public virtual onlyOwner {
1167         _transferOwnership(address(0));
1168     }
1169 
1170     /**
1171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1172      * Can only be called by the current owner.
1173      */
1174     function transferOwnership(address newOwner) public virtual onlyOwner {
1175         require(newOwner != address(0), "Ownable: new owner is the zero address");
1176         _transferOwnership(newOwner);
1177     }
1178 
1179     /**
1180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1181      * Internal function without access restriction.
1182      */
1183     function _transferOwnership(address newOwner) internal virtual {
1184         address oldOwner = _owner;
1185         _owner = newOwner;
1186         emit OwnershipTransferred(oldOwner, newOwner);
1187     }
1188 }
1189 
1190 pragma solidity ^0.8.2;
1191 /**
1192  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1193  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1194  *
1195  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1196  *
1197  * Does not support burning tokens to address(0).
1198  *
1199  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
1200  */
1201 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1202     using Address for address;
1203     using Strings for uint256;
1204 
1205     struct TokenOwnership {
1206         address addr;
1207         uint64 startTimestamp;
1208     }
1209 
1210     struct AddressData {
1211         uint128 balance;
1212         uint128 numberMinted;
1213     }
1214 
1215     uint256 internal currentIndex = 0;
1216 
1217     // Token name
1218     string private _name;
1219 
1220     // Token symbol
1221     string private _symbol;
1222 
1223     // Mapping from token ID to ownership details
1224     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1225     mapping(uint256 => TokenOwnership) internal _ownerships;
1226 
1227     // Mapping owner address to address data
1228     mapping(address => AddressData) private _addressData;
1229 
1230     // Mapping from token ID to approved address
1231     mapping(uint256 => address) private _tokenApprovals;
1232 
1233     // Mapping from owner to operator approvals
1234     mapping(address => mapping(address => bool)) private _operatorApprovals;
1235 
1236     constructor(string memory name_, string memory symbol_) {
1237         _name = name_;
1238         _symbol = symbol_;
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Enumerable-totalSupply}.
1243      */
1244     function totalSupply() public view override returns (uint256) {
1245         return currentIndex;
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Enumerable-tokenByIndex}.
1250      */
1251     function tokenByIndex(uint256 index) public view override returns (uint256) {
1252         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1253         return index;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1258      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1259      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1260      */
1261     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1262         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1263         uint256 numMintedSoFar = totalSupply();
1264         uint256 tokenIdsIdx = 0;
1265         address currOwnershipAddr = address(0);
1266         for (uint256 i = 0; i < numMintedSoFar; i++) {
1267             TokenOwnership memory ownership = _ownerships[i];
1268             if (ownership.addr != address(0)) {
1269                 currOwnershipAddr = ownership.addr;
1270             }
1271             if (currOwnershipAddr == owner) {
1272                 if (tokenIdsIdx == index) {
1273                     return i;
1274                 }
1275                 tokenIdsIdx++;
1276             }
1277         }
1278         revert('ERC721A: unable to get token of owner by index');
1279     }
1280 
1281     /**
1282      * @dev See {IERC165-supportsInterface}.
1283      */
1284     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1285         return
1286             interfaceId == type(IERC721).interfaceId ||
1287             interfaceId == type(IERC721Metadata).interfaceId ||
1288             interfaceId == type(IERC721Enumerable).interfaceId ||
1289             super.supportsInterface(interfaceId);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-balanceOf}.
1294      */
1295     function balanceOf(address owner) public view override returns (uint256) {
1296         require(owner != address(0), 'ERC721A: balance query for the zero address');
1297         return uint256(_addressData[owner].balance);
1298     }
1299 
1300     function _numberMinted(address owner) internal view returns (uint256) {
1301         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1302         return uint256(_addressData[owner].numberMinted);
1303     }
1304 
1305     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1306         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1307 
1308         for (uint256 curr = tokenId; ; curr--) {
1309             TokenOwnership memory ownership = _ownerships[curr];
1310             if (ownership.addr != address(0)) {
1311                 return ownership;
1312             }
1313         }
1314 
1315         revert('ERC721A: unable to determine the owner of token');
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-ownerOf}.
1320      */
1321     function ownerOf(uint256 tokenId) public view override returns (address) {
1322         return ownershipOf(tokenId).addr;
1323     }
1324 
1325     /**
1326      * @dev See {IERC721Metadata-name}.
1327      */
1328     function name() public view virtual override returns (string memory) {
1329         return _name;
1330     }
1331 
1332     /**
1333      * @dev See {IERC721Metadata-symbol}.
1334      */
1335     function symbol() public view virtual override returns (string memory) {
1336         return _symbol;
1337     }
1338 
1339     /**
1340      * @dev See {IERC721Metadata-tokenURI}.
1341      */
1342     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1343         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1344 
1345         string memory baseURI = _baseURI();
1346         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1347     }
1348 
1349     /**
1350      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1351      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1352      * by default, can be overriden in child contracts.
1353      */
1354     function _baseURI() internal view virtual returns (string memory) {
1355         return '';
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-approve}.
1360      */
1361     function approve(address to, uint256 tokenId) public override {
1362         address owner = ERC721A.ownerOf(tokenId);
1363         require(to != owner, 'ERC721A: approval to current owner');
1364 
1365         require(
1366             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1367             'ERC721A: approve caller is not owner nor approved for all'
1368         );
1369 
1370         _approve(to, tokenId, owner);
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-getApproved}.
1375      */
1376     function getApproved(uint256 tokenId) public view override returns (address) {
1377         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1378 
1379         return _tokenApprovals[tokenId];
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-setApprovalForAll}.
1384      */
1385     function setApprovalForAll(address operator, bool approved) public override {
1386         require(operator != _msgSender(), 'ERC721A: approve to caller');
1387 
1388         _operatorApprovals[_msgSender()][operator] = approved;
1389         emit ApprovalForAll(_msgSender(), operator, approved);
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-isApprovedForAll}.
1394      */
1395     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1396         return _operatorApprovals[owner][operator];
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-transferFrom}.
1401      */
1402     function transferFrom(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) public override {
1407         _transfer(from, to, tokenId);
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-safeTransferFrom}.
1412      */
1413     function safeTransferFrom(
1414         address from,
1415         address to,
1416         uint256 tokenId
1417     ) public override {
1418         safeTransferFrom(from, to, tokenId, '');
1419     }
1420 
1421     /**
1422      * @dev See {IERC721-safeTransferFrom}.
1423      */
1424     function safeTransferFrom(
1425         address from,
1426         address to,
1427         uint256 tokenId,
1428         bytes memory _data
1429     ) public override {
1430         _transfer(from, to, tokenId);
1431         require(
1432             _checkOnERC721Received(from, to, tokenId, _data),
1433             'ERC721A: transfer to non ERC721Receiver implementer'
1434         );
1435     }
1436 
1437     /**
1438      * @dev Returns whether `tokenId` exists.
1439      *
1440      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1441      *
1442      * Tokens start existing when they are minted (`_mint`),
1443      */
1444     function _exists(uint256 tokenId) internal view returns (bool) {
1445         return tokenId < currentIndex;
1446     }
1447 
1448     function _safeMint(address to, uint256 quantity) internal {
1449         _safeMint(to, quantity, '');
1450     }
1451 
1452     /**
1453      * @dev Mints `quantity` tokens and transfers them to `to`.
1454      *
1455      * Requirements:
1456      *
1457      * - `to` cannot be the zero address.
1458      * - `quantity` cannot be larger than the max batch size.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _safeMint(
1463         address to,
1464         uint256 quantity,
1465         bytes memory _data
1466     ) internal {
1467         uint256 startTokenId = currentIndex;
1468         require(to != address(0), 'ERC721A: mint to the zero address');
1469         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1470         require(!_exists(startTokenId), 'ERC721A: token already minted');
1471         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1472 
1473         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1474 
1475         AddressData memory addressData = _addressData[to];
1476         _addressData[to] = AddressData(
1477             addressData.balance + uint128(quantity),
1478             addressData.numberMinted + uint128(quantity)
1479         );
1480         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1481 
1482         uint256 updatedIndex = startTokenId;
1483 
1484         for (uint256 i = 0; i < quantity; i++) {
1485             emit Transfer(address(0), to, updatedIndex);
1486             require(
1487                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1488                 'ERC721A: transfer to non ERC721Receiver implementer'
1489             );
1490             updatedIndex++;
1491         }
1492 
1493         currentIndex = updatedIndex;
1494         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1495     }
1496 
1497     /**
1498      * @dev Transfers `tokenId` from `from` to `to`.
1499      *
1500      * Requirements:
1501      *
1502      * - `to` cannot be the zero address.
1503      * - `tokenId` token must be owned by `from`.
1504      *
1505      * Emits a {Transfer} event.
1506      */
1507     function _transfer(
1508         address from,
1509         address to,
1510         uint256 tokenId
1511     ) private {
1512         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1513 
1514         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1515             getApproved(tokenId) == _msgSender() ||
1516             isApprovedForAll(prevOwnership.addr, _msgSender()));
1517 
1518         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1519 
1520         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1521         require(to != address(0), 'ERC721A: transfer to the zero address');
1522 
1523         _beforeTokenTransfers(from, to, tokenId, 1);
1524 
1525         // Clear approvals from the previous owner
1526         _approve(address(0), tokenId, prevOwnership.addr);
1527 
1528         // Underflow of the sender's balance is impossible because we check for
1529         // ownership above and the recipient's balance can't realistically overflow.
1530         unchecked {
1531             _addressData[from].balance -= 1;
1532             _addressData[to].balance += 1;
1533         }
1534 
1535         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1536 
1537         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1538         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1539         uint256 nextTokenId = tokenId + 1;
1540         if (_ownerships[nextTokenId].addr == address(0)) {
1541             if (_exists(nextTokenId)) {
1542                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1543             }
1544         }
1545 
1546         emit Transfer(from, to, tokenId);
1547         _afterTokenTransfers(from, to, tokenId, 1);
1548     }
1549 
1550     /**
1551      * @dev Approve `to` to operate on `tokenId`
1552      *
1553      * Emits a {Approval} event.
1554      */
1555     function _approve(
1556         address to,
1557         uint256 tokenId,
1558         address owner
1559     ) private {
1560         _tokenApprovals[tokenId] = to;
1561         emit Approval(owner, to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1566      * The call is not executed if the target address is not a contract.
1567      *
1568      * @param from address representing the previous owner of the given token ID
1569      * @param to target address that will receive the tokens
1570      * @param tokenId uint256 ID of the token to be transferred
1571      * @param _data bytes optional data to send along with the call
1572      * @return bool whether the call correctly returned the expected magic value
1573      */
1574     function _checkOnERC721Received(
1575         address from,
1576         address to,
1577         uint256 tokenId,
1578         bytes memory _data
1579     ) private returns (bool) {
1580         if (to.isContract()) {
1581             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1582                 return retval == IERC721Receiver(to).onERC721Received.selector;
1583             } catch (bytes memory reason) {
1584                 if (reason.length == 0) {
1585                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1586                 } else {
1587                     assembly {
1588                         revert(add(32, reason), mload(reason))
1589                     }
1590                 }
1591             }
1592         } else {
1593             return true;
1594         }
1595     }
1596 
1597     /**
1598      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1599      *
1600      * startTokenId - the first token id to be transferred
1601      * quantity - the amount to be transferred
1602      *
1603      * Calling conditions:
1604      *
1605      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1606      * transferred to `to`.
1607      * - When `from` is zero, `tokenId` will be minted for `to`.
1608      */
1609     function _beforeTokenTransfers(
1610         address from,
1611         address to,
1612         uint256 startTokenId,
1613         uint256 quantity
1614     ) internal virtual {}
1615 
1616     /**
1617      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1618      * minting.
1619      *
1620      * startTokenId - the first token id to be transferred
1621      * quantity - the amount to be transferred
1622      *
1623      * Calling conditions:
1624      *
1625      * - when `from` and `to` are both non-zero.
1626      * - `from` and `to` are never both zero.
1627      */
1628     function _afterTokenTransfers(
1629         address from,
1630         address to,
1631         uint256 startTokenId,
1632         uint256 quantity
1633     ) internal virtual {}
1634 }
1635 
1636 pragma solidity ^0.8.0;
1637 
1638 /**
1639  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1640  *
1641  * These functions can be used to verify that a message was signed by the holder
1642  * of the private keys of a given address.
1643  */
1644 library ECDSA {
1645     enum RecoverError {
1646         NoError,
1647         InvalidSignature,
1648         InvalidSignatureLength,
1649         InvalidSignatureS,
1650         InvalidSignatureV
1651     }
1652 
1653     function _throwError(RecoverError error) private pure {
1654         if (error == RecoverError.NoError) {
1655             return; // no error: do nothing
1656         } else if (error == RecoverError.InvalidSignature) {
1657             revert("ECDSA: invalid signature");
1658         } else if (error == RecoverError.InvalidSignatureLength) {
1659             revert("ECDSA: invalid signature length");
1660         } else if (error == RecoverError.InvalidSignatureS) {
1661             revert("ECDSA: invalid signature 's' value");
1662         } else if (error == RecoverError.InvalidSignatureV) {
1663             revert("ECDSA: invalid signature 'v' value");
1664         }
1665     }
1666 
1667     /**
1668      * @dev Returns the address that signed a hashed message (`hash`) with
1669      * `signature` or error string. This address can then be used for verification purposes.
1670      *
1671      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1672      * this function rejects them by requiring the `s` value to be in the lower
1673      * half order, and the `v` value to be either 27 or 28.
1674      *
1675      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1676      * verification to be secure: it is possible to craft signatures that
1677      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1678      * this is by receiving a hash of the original message (which may otherwise
1679      * be too long), and then calling {toEthSignedMessageHash} on it.
1680      *
1681      * Documentation for signature generation:
1682      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1683      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1684      *
1685      * _Available since v4.3._
1686      */
1687     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1688         // Check the signature length
1689         // - case 65: r,s,v signature (standard)
1690         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1691         if (signature.length == 65) {
1692             bytes32 r;
1693             bytes32 s;
1694             uint8 v;
1695             // ecrecover takes the signature parameters, and the only way to get them
1696             // currently is to use assembly.
1697             assembly {
1698                 r := mload(add(signature, 0x20))
1699                 s := mload(add(signature, 0x40))
1700                 v := byte(0, mload(add(signature, 0x60)))
1701             }
1702             return tryRecover(hash, v, r, s);
1703         } else if (signature.length == 64) {
1704             bytes32 r;
1705             bytes32 vs;
1706             // ecrecover takes the signature parameters, and the only way to get them
1707             // currently is to use assembly.
1708             assembly {
1709                 r := mload(add(signature, 0x20))
1710                 vs := mload(add(signature, 0x40))
1711             }
1712             return tryRecover(hash, r, vs);
1713         } else {
1714             return (address(0), RecoverError.InvalidSignatureLength);
1715         }
1716     }
1717 
1718     /**
1719      * @dev Returns the address that signed a hashed message (`hash`) with
1720      * `signature`. This address can then be used for verification purposes.
1721      *
1722      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1723      * this function rejects them by requiring the `s` value to be in the lower
1724      * half order, and the `v` value to be either 27 or 28.
1725      *
1726      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1727      * verification to be secure: it is possible to craft signatures that
1728      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1729      * this is by receiving a hash of the original message (which may otherwise
1730      * be too long), and then calling {toEthSignedMessageHash} on it.
1731      */
1732     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1733         (address recovered, RecoverError error) = tryRecover(hash, signature);
1734         _throwError(error);
1735         return recovered;
1736     }
1737 
1738     /**
1739      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1740      *
1741      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1742      *
1743      * _Available since v4.3._
1744      */
1745     function tryRecover(
1746         bytes32 hash,
1747         bytes32 r,
1748         bytes32 vs
1749     ) internal pure returns (address, RecoverError) {
1750         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1751         uint8 v = uint8((uint256(vs) >> 255) + 27);
1752         return tryRecover(hash, v, r, s);
1753     }
1754 
1755     /**
1756      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1757      *
1758      * _Available since v4.2._
1759      */
1760     function recover(
1761         bytes32 hash,
1762         bytes32 r,
1763         bytes32 vs
1764     ) internal pure returns (address) {
1765         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1766         _throwError(error);
1767         return recovered;
1768     }
1769 
1770     /**
1771      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1772      * `r` and `s` signature fields separately.
1773      *
1774      * _Available since v4.3._
1775      */
1776     function tryRecover(
1777         bytes32 hash,
1778         uint8 v,
1779         bytes32 r,
1780         bytes32 s
1781     ) internal pure returns (address, RecoverError) {
1782         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1783         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1784         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1785         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1786         //
1787         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1788         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1789         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1790         // these malleable signatures as well.
1791         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1792             return (address(0), RecoverError.InvalidSignatureS);
1793         }
1794         if (v != 27 && v != 28) {
1795             return (address(0), RecoverError.InvalidSignatureV);
1796         }
1797 
1798         // If the signature is valid (and not malleable), return the signer address
1799         address signer = ecrecover(hash, v, r, s);
1800         if (signer == address(0)) {
1801             return (address(0), RecoverError.InvalidSignature);
1802         }
1803 
1804         return (signer, RecoverError.NoError);
1805     }
1806 
1807     /**
1808      * @dev Overload of {ECDSA-recover} that receives the `v`,
1809      * `r` and `s` signature fields separately.
1810      */
1811     function recover(
1812         bytes32 hash,
1813         uint8 v,
1814         bytes32 r,
1815         bytes32 s
1816     ) internal pure returns (address) {
1817         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1818         _throwError(error);
1819         return recovered;
1820     }
1821 
1822     /**
1823      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1824      * produces hash corresponding to the one signed with the
1825      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1826      * JSON-RPC method as part of EIP-191.
1827      *
1828      * See {recover}.
1829      */
1830     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1831         // 32 is the length in bytes of hash,
1832         // enforced by the type signature above
1833         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1834     }
1835 
1836     /**
1837      * @dev Returns an Ethereum Signed Message, created from `s`. This
1838      * produces hash corresponding to the one signed with the
1839      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1840      * JSON-RPC method as part of EIP-191.
1841      *
1842      * See {recover}.
1843      */
1844     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1845         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1846     }
1847 
1848     /**
1849      * @dev Returns an Ethereum Signed Typed Data, created from a
1850      * `domainSeparator` and a `structHash`. This produces hash corresponding
1851      * to the one signed with the
1852      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1853      * JSON-RPC method as part of EIP-712.
1854      *
1855      * See {recover}.
1856      */
1857     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1858         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1859     }
1860 }
1861 
1862 contract Creatures is ERC721A, Ownable {
1863     using Strings for uint;
1864     using ECDSA for bytes32;
1865 
1866     constructor() ERC721A("Creatures", "CRT") {}
1867     
1868     uint256 public constant maxSupply = 1500;
1869     uint256 maxMintPerCall = 2;
1870     uint256 presaleMaxMint = 1500;
1871 
1872     struct mintTracker {
1873         uint256 amount;
1874     }
1875 
1876     bool public blacklistedSaleStatus = false;
1877 
1878     string private _baseTokenURI;
1879 
1880     address private signer = 0x4557674Ea101C7594a68263D735BacD0Ae57E569;
1881 
1882     mapping(address => mintTracker) private _minttracker;
1883     mapping(address => bool) public _twomintsAddress;
1884     mapping(address => uint) devMintsTo;
1885 
1886     modifier mintChecks(uint numNFTs) {
1887         unchecked {
1888             require(tx.origin == msg.sender);
1889             require(numNFTs <= maxMintPerCall, "Number to mint exceeds maximum per tx");
1890             require(numNFTs + totalSupply() <= maxSupply, "Mint would exceed supply");
1891         }
1892         _;
1893     }
1894 
1895     // MINTING ------------------------------------------------------------------------
1896 
1897     function whitelistMint(uint256 numNFTs, bytes calldata signature) public payable mintChecks(numNFTs) {
1898         unchecked {
1899             require(blacklistedSaleStatus, "Sale has not started");
1900             require(verifySignature(abi.encodePacked(msg.sender), signature), "Invalid signature provided");
1901             require(totalSupply() + numNFTs - devMintsTo[msg.sender] <= presaleMaxMint, "Can't mint that many in pre-sale");
1902             if(_twomintsAddress[msg.sender] == true){
1903                 require(_minttracker[msg.sender].amount + numNFTs <= 2, "Can't mint more than 2 NFTs.");
1904             }else{
1905                 require(_minttracker[msg.sender].amount + numNFTs <= 1, "Can't mint more than 1 NFT.");
1906             }
1907         }
1908         _minttracker[msg.sender].amount = _minttracker[msg.sender].amount + numNFTs;
1909         _safeMint(msg.sender, numNFTs);
1910     }
1911 
1912     //GETS ---------------------------------------------------------------------------
1913 
1914     function tokenURI(uint tokenId) public view override returns(string memory) {
1915         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1916         return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), ".json"));
1917     }
1918 
1919     function getMintedAmountForAddress(address _address) public view returns(uint256){
1920         return _minttracker[_address].amount;
1921     }
1922 
1923     function getMintedAmountForMyself() public view returns(uint256){
1924         return _minttracker[msg.sender].amount;
1925     }
1926 
1927     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1928         return ownershipOf(tokenId);
1929     }
1930 
1931     function verifySignature(bytes memory data, bytes calldata signature) internal view returns(bool) {
1932         return (keccak256(data).toEthSignedMessageHash().recover(signature) == signer);
1933     }
1934 
1935     function getSigner() public view returns(address){
1936         return signer;
1937     }
1938 
1939     function getTwoMintsWhitelistForAddress(address _address) public view returns (bool){
1940         if(_twomintsAddress[_address] == true){
1941             return true;
1942         }else{
1943             return false;
1944         }
1945     }
1946 
1947     //SETS --------------------------------------------------------------------------
1948     function setBaseURI(string calldata new_baseURI) external onlyOwner {
1949         _baseTokenURI = new_baseURI;
1950     }
1951         
1952     function setSaleStates(bool new_blacklistedSaleStatus) external onlyOwner{
1953         blacklistedSaleStatus = new_blacklistedSaleStatus;
1954     }
1955 
1956     function setSigner(address new_signer) external onlyOwner {
1957         signer = new_signer;
1958     }
1959 
1960     function addTo2MintsWhitelist(address _address) external onlyOwner {
1961         require(!_twomintsAddress[_address], "Address is already whitelisted for 2 mints.");
1962         _twomintsAddress[_address] = true;
1963     }
1964 
1965     function addTo2MintsWhitelist2(address[] memory _addresses) external onlyOwner {
1966         for(uint i = 0; i < _addresses.length; i++){
1967             _twomintsAddress[_addresses[i]] = true;
1968         }
1969     }
1970 
1971 }