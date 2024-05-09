1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 
5 /**
6  * @dev Interface for discreet.eth in addition to the standard ERC721 interface.
7  */
8 interface discreetNFTInterface {
9     /**
10      * @dev Mint token with the supplied tokenId if it is currently available.
11      */
12     function mint(uint256 tokenId) external;
13 
14     /**
15      * @dev Mint token with the supplied tokenId if it is currently available to
16      * another address.
17      */
18     function mint(address to, uint256 tokenId) external;
19 
20     /**
21      * @dev Burn token with the supplied tokenId if it is owned, approved or
22      * reclaimable. Tokens become reclaimable after ~4 million blocks without a
23      * mint or transfer.
24      */
25     function burn(uint256 tokenId) external;
26 
27     /**
28      * @dev Check the current block number at which a given token will become
29      * reclaimable.
30      */
31     function reclaimableThreshold(uint256 tokenId) external view returns (uint256);
32 
33     /**
34      * @dev Check whether a given token is currently reclaimable.
35      */
36     function isReclaimable(uint256 tokenId) external view returns (bool);
37 
38     /**
39      * @dev Retrieve just the image URI for a given token.
40      */
41     function tokenImageURI(uint256 tokenId) external view returns (string memory);
42 }
43 
44 
45 /**
46  * @dev Interface of the ERC165 standard, as defined in the
47  * https://eips.ethereum.org/EIPS/eip-165[EIP].
48  */
49 interface IERC165 {
50     /**
51      * @dev Returns true if this contract implements the interface defined by
52      * `interfaceId`. See the corresponding
53      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
54      * to learn more about how these ids are created.
55      *
56      * This function call must use less than 30 000 gas.
57      */
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
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
199 
200 /**
201  * @title ERC721 token receiver interface
202  * @dev Interface for any contract that wants to support safeTransfers
203  * from ERC721 asset contracts.
204  */
205 interface IERC721Receiver {
206     /**
207      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
208      * by `operator` from `from`, this function is called.
209      *
210      * It must return its Solidity selector to confirm the token transfer.
211      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
212      *
213      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
214      */
215     function onERC721Received(
216         address operator,
217         address from,
218         uint256 tokenId,
219         bytes calldata data
220     ) external returns (bytes4);
221 }
222 
223 
224 /**
225  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
226  * @dev See https://eips.ethereum.org/EIPS/eip-721
227  */
228 interface IERC721Metadata is IERC721 {
229     /**
230      * @dev Returns the token collection name.
231      */
232     function name() external view returns (string memory);
233 
234     /**
235      * @dev Returns the token collection symbol.
236      */
237     function symbol() external view returns (string memory);
238 
239     /**
240      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
241      */
242     function tokenURI(uint256 tokenId) external view returns (string memory);
243 }
244 
245 
246 /**
247  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
248  * @dev See https://eips.ethereum.org/EIPS/eip-721
249  */
250 interface IERC721Enumerable is IERC721 {
251     /**
252      * @dev Returns the total amount of tokens stored by the contract.
253      */
254     function totalSupply() external view returns (uint256);
255 
256     /**
257      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
258      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
259      */
260     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
261 
262     /**
263      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
264      * Use along with {totalSupply} to enumerate all tokens.
265      */
266     function tokenByIndex(uint256 index) external view returns (uint256);
267 }
268 
269 
270 interface IENSReverseRegistrar {
271     function claim(address owner) external returns (bytes32 node);
272     function setName(string calldata name) external returns (bytes32 node);
273 }
274 
275 
276 /**
277  * @dev Implementation of the {IERC165} interface.
278  */
279 abstract contract ERC165 is IERC165 {
280     /**
281      * @dev See {IERC165-supportsInterface}.
282      */
283     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284         return interfaceId == type(IERC165).interfaceId;
285     }
286 }
287 
288 
289 /// [MIT License]
290 /// @title Base64
291 /// @notice Provides a function for encoding some bytes in base64
292 /// @author Brecht Devos <brecht@loopring.org>
293 library Base64 {
294     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
295 
296     /// @notice Encodes some bytes to the base64 representation
297     function encode(bytes memory data) internal pure returns (string memory) {
298         uint256 len = data.length;
299         if (len == 0) return "";
300 
301         // multiply by 4/3 rounded up
302         uint256 encodedLen = 4 * ((len + 2) / 3);
303 
304         // Add some extra buffer at the end
305         bytes memory result = new bytes(encodedLen + 32);
306 
307         bytes memory table = TABLE;
308 
309         assembly {
310             let tablePtr := add(table, 1)
311             let resultPtr := add(result, 32)
312 
313             for {
314                 let i := 0
315             } lt(i, len) {
316 
317             } {
318                 i := add(i, 3)
319                 let input := and(mload(add(data, i)), 0xffffff)
320 
321                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
322                 out := shl(8, out)
323                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
324                 out := shl(8, out)
325                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
326                 out := shl(8, out)
327                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
328                 out := shl(224, out)
329 
330                 mstore(resultPtr, out)
331 
332                 resultPtr := add(resultPtr, 4)
333             }
334 
335             switch mod(len, 3)
336             case 1 {
337                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
338             }
339             case 2 {
340                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
341             }
342 
343             mstore(result, encodedLen)
344         }
345 
346         return string(result);
347     }
348 }
349 
350 
351 /**
352  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
353  * the Metadata extension, but not including the Enumerable extension, which is available separately as
354  * {ERC721Enumerable}.
355  */
356 contract ERC721 is ERC165, IERC721, IERC721Metadata {
357     // Token name
358     bytes8 private immutable _name;
359 
360     // Token symbol
361     bytes8 private immutable _symbol;
362 
363     // Mapping from token ID to owner address
364     mapping(uint256 => address) private _owners;
365 
366     // Mapping owner address to token count
367     mapping(address => uint256) private _balances;
368 
369     // Mapping from token ID to approved address
370     mapping(uint256 => address) private _tokenApprovals;
371 
372     // Mapping from owner to operator approvals
373     mapping(address => mapping(address => bool)) private _operatorApprovals;
374 
375     /**
376      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
377      */
378     constructor(bytes8 name_, bytes8 symbol_) {
379         _name = name_;
380         _symbol = symbol_;
381     }
382 
383     /**
384      * @dev See {IERC165-supportsInterface}.
385      */
386     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
387         return
388             interfaceId == type(IERC721).interfaceId ||
389             interfaceId == type(IERC721Metadata).interfaceId ||
390             super.supportsInterface(interfaceId);
391     }
392 
393     /**
394      * @dev See {IERC721-balanceOf}.
395      */
396     function balanceOf(address owner) public view virtual override returns (uint256) {
397         require(owner != address(0), "ERC721: balance query for the zero address");
398         return _balances[owner];
399     }
400 
401     /**
402      * @dev See {IERC721-ownerOf}.
403      */
404     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
405         address owner = _owners[tokenId];
406         require(owner != address(0), "ERC721: owner query for nonexistent token");
407         return owner;
408     }
409 
410     /**
411      * @dev See {IERC721Metadata-name}.
412      */
413     function name() external view virtual override returns (string memory) {
414         return string(abi.encodePacked(_name));
415     }
416 
417     /**
418      * @dev See {IERC721Metadata-symbol}.
419      */
420     function symbol() external view virtual override returns (string memory) {
421         return string(abi.encodePacked(_symbol));
422     }
423 
424     /**
425      * @dev NOTE: standard functionality overridden.
426      */
427     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {}
428 
429     /**
430      * @dev See {IERC721-approve}.
431      */
432     function approve(address to, uint256 tokenId) external virtual override {
433         address owner = ERC721.ownerOf(tokenId);
434         require(to != owner, "ERC721: approval to current owner");
435 
436         require(
437             msg.sender == owner || isApprovedForAll(owner, msg.sender),
438             "ERC721: approve caller is not owner nor approved for all"
439         );
440 
441         _approve(to, tokenId);
442     }
443 
444     /**
445      * @dev See {IERC721-getApproved}.
446      */
447     function getApproved(uint256 tokenId) public view virtual override returns (address) {
448         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
449 
450         return _tokenApprovals[tokenId];
451     }
452 
453     /**
454      * @dev See {IERC721-setApprovalForAll}.
455      */
456     function setApprovalForAll(address operator, bool approved) external virtual override {
457         require(operator != msg.sender, "ERC721: approve to caller");
458 
459         _operatorApprovals[msg.sender][operator] = approved;
460         emit ApprovalForAll(msg.sender, operator, approved);
461     }
462 
463     /**
464      * @dev See {IERC721-isApprovedForAll}.
465      */
466     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
467         return _operatorApprovals[owner][operator];
468     }
469 
470     /**
471      * @dev See {IERC721-transferFrom}.
472      */
473     function transferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external virtual override {
478         //solhint-disable-next-line max-line-length
479         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
480 
481         _transfer(from, to, tokenId);
482     }
483 
484     /**
485      * @dev See {IERC721-safeTransferFrom}.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external virtual override {
492         safeTransferFrom(from, to, tokenId, "");
493     }
494 
495     /**
496      * @dev See {IERC721-safeTransferFrom}.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId,
502         bytes memory _data
503     ) public virtual override {
504         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
505         _safeTransfer(from, to, tokenId, _data);
506     }
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
510      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
511      *
512      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
513      *
514      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
515      * implement alternative mechanisms to perform token transfer, such as signature-based.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must exist and be owned by `from`.
522      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
523      *
524      * Emits a {Transfer} event.
525      */
526     function _safeTransfer(
527         address from,
528         address to,
529         uint256 tokenId,
530         bytes memory _data
531     ) internal virtual {
532         _transfer(from, to, tokenId);
533         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
534     }
535 
536     /**
537      * @dev Returns whether `tokenId` exists.
538      *
539      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
540      *
541      * Tokens start existing when they are minted (`_mint`),
542      * and stop existing when they are burned (`_burn`).
543      */
544     function _exists(uint256 tokenId) internal view virtual returns (bool) {
545         return _owners[tokenId] != address(0);
546     }
547 
548     /**
549      * @dev Returns whether `spender` is allowed to manage `tokenId`.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
556         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
557         address owner = ERC721.ownerOf(tokenId);
558         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
559     }
560 
561     /**
562      * @dev Safely mints `tokenId` and transfers it to `to`.
563      *
564      * Requirements:
565      *
566      * - `tokenId` must not exist.
567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
568      *
569      * Emits a {Transfer} event.
570      */
571     function _safeMint(address to, uint256 tokenId) internal virtual {
572         _mint(to, tokenId);
573         require(
574             _checkOnERC721Received(address(0), to, tokenId, ""),
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
684         uint256 size;
685         assembly { size := extcodesize(to) }
686         if (size > 0) {
687             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
688                 return retval == IERC721Receiver(to).onERC721Received.selector;
689             } catch (bytes memory reason) {
690                 if (reason.length == 0) {
691                     revert("ERC721: transfer to non ERC721Receiver implementer");
692                 } else {
693                     assembly {
694                         revert(add(32, reason), mload(reason))
695                     }
696                 }
697             }
698         } else {
699             return true;
700         }
701     }
702 
703     /**
704      * @dev Hook that is called before any token transfer. This includes minting
705      * and burning.
706      *
707      * Calling conditions:
708      *
709      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
710      * transferred to `to`.
711      * - When `from` is zero, `tokenId` will be minted for `to`.
712      * - When `to` is zero, ``from``'s `tokenId` will be burned.
713      * - `from` and `to` are never both zero.
714      *
715      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
716      */
717     function _beforeTokenTransfer(
718         address from,
719         address to,
720         uint256 tokenId
721     ) internal virtual {}
722 }
723 
724 
725 /**
726  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
727  * enumerability of all the token ids in the contract as well as all token ids owned by each
728  * account.
729  */
730 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
731     // Mapping from owner to list of owned token IDs
732     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
733 
734     // Mapping from token ID to index of the owner tokens list
735     mapping(uint256 => uint256) private _ownedTokensIndex;
736 
737     // Array with all token ids, used for enumeration
738     uint256[] private _allTokens;
739 
740     // Mapping from token id to position in the allTokens array
741     mapping(uint256 => uint256) private _allTokensIndex;
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
747         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
748     }
749 
750     /**
751      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
752      */
753     function tokenOfOwnerByIndex(address owner, uint256 index) external view virtual override returns (uint256) {
754         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
755         return _ownedTokens[owner][index];
756     }
757 
758     /**
759      * @dev See {IERC721Enumerable-totalSupply}.
760      */
761     function totalSupply() public view virtual override returns (uint256) {
762         return _allTokens.length;
763     }
764 
765     /**
766      * @dev See {IERC721Enumerable-tokenByIndex}.
767      */
768     function tokenByIndex(uint256 index) external view virtual override returns (uint256) {
769         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
770         return _allTokens[index];
771     }
772 
773     /**
774      * @dev Hook that is called before any token transfer. This includes minting
775      * and burning.
776      *
777      * Calling conditions:
778      *
779      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
780      * transferred to `to`.
781      * - When `from` is zero, `tokenId` will be minted for `to`.
782      * - When `to` is zero, ``from``'s `tokenId` will be burned.
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      *
786      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
787      */
788     function _beforeTokenTransfer(
789         address from,
790         address to,
791         uint256 tokenId
792     ) internal virtual override {
793         super._beforeTokenTransfer(from, to, tokenId);
794 
795         if (from == address(0)) {
796             _addTokenToAllTokensEnumeration(tokenId);
797         } else if (from != to) {
798             _removeTokenFromOwnerEnumeration(from, tokenId);
799         }
800         if (to == address(0)) {
801             _removeTokenFromAllTokensEnumeration(tokenId);
802         } else if (to != from) {
803             _addTokenToOwnerEnumeration(to, tokenId);
804         }
805     }
806 
807     /**
808      * @dev Private function to add a token to this extension's ownership-tracking data structures.
809      * @param to address representing the new owner of the given token ID
810      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
811      */
812     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
813         uint256 length = ERC721.balanceOf(to);
814         _ownedTokens[to][length] = tokenId;
815         _ownedTokensIndex[tokenId] = length;
816     }
817 
818     /**
819      * @dev Private function to add a token to this extension's token tracking data structures.
820      * @param tokenId uint256 ID of the token to be added to the tokens list
821      */
822     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
823         _allTokensIndex[tokenId] = _allTokens.length;
824         _allTokens.push(tokenId);
825     }
826 
827     /**
828      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
829      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
830      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
831      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
832      * @param from address representing the previous owner of the given token ID
833      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
834      */
835     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
836         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
837         // then delete the last slot (swap and pop).
838 
839         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
840         uint256 tokenIndex = _ownedTokensIndex[tokenId];
841 
842         // When the token to delete is the last token, the swap operation is unnecessary
843         if (tokenIndex != lastTokenIndex) {
844             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
845 
846             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
847             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
848         }
849 
850         // This also deletes the contents at the last position of the array
851         delete _ownedTokensIndex[tokenId];
852         delete _ownedTokens[from][lastTokenIndex];
853     }
854 
855     /**
856      * @dev Private function to remove a token from this extension's token tracking data structures.
857      * This has O(1) time complexity, but alters the order of the _allTokens array.
858      * @param tokenId uint256 ID of the token to be removed from the tokens list
859      */
860     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
861         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
862         // then delete the last slot (swap and pop).
863 
864         uint256 lastTokenIndex = _allTokens.length - 1;
865         uint256 tokenIndex = _allTokensIndex[tokenId];
866 
867         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
868         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
869         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
870         uint256 lastTokenId = _allTokens[lastTokenIndex];
871 
872         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
873         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
874 
875         // This also deletes the contents at the last position of the array
876         delete _allTokensIndex[tokenId];
877         _allTokens.pop();
878     }
879 }
880 
881 
882 /**
883  * @dev discreet (full set — replaces the 576 orignal and 288 extra NFTs and
884  * adds an additional 432 for 1296 in total)
885  * @author 0age
886  */
887 contract discreetNFT is discreetNFTInterface, ERC721, ERC721Enumerable, IERC721Receiver {
888     // Map tokenIds to block numbers past which they are burnable by any caller.
889     mapping(uint256 => uint256) private _reclaimableThreshold;
890 
891     // Map transaction submitters to the block number of their last token mint.
892     mapping(address => uint256) private _lastTokenMinted;
893 
894     discreetNFTInterface public constant originalSet = discreetNFTInterface(
895         0x3c77065B584D4Af705B3E38CC35D336b081E4948
896     );
897 
898     discreetNFTInterface public constant extraSet = discreetNFTInterface(
899         0x04C0567cdBB51c3a9B1C907a56A5edA0EdeeBf71
900     );
901 
902     uint256 public immutable migrationEnds;
903 
904     // Fixed base64-encoded SVG fragments used across all images.
905     bytes32 private constant h0 = 'data:image/svg+xml;base64,PD94bW';
906     bytes32 private constant h1 = 'wgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz';
907     bytes32 private constant h2 = '0iVVRGLTgiPz48c3ZnIHZpZXdCb3g9Ij';
908     bytes32 private constant h3 = 'AgMCA1MDAgNTAwIiB4bWxucz0iaHR0cD';
909     bytes32 private constant h4 = 'ovL3d3dy53My5vcmcvMjAwMC9zdmciIH';
910     bytes32 private constant h5 = 'N0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOi';
911     bytes4 private constant m0 = 'iPjx';
912     bytes10 private constant m1 = 'BmaWxsPSIj';
913     bytes16 private constant f0 = 'IiAvPjwvc3ZnPg==';
914 
915     /**
916      * @dev Deploy discreet as an ERC721 NFT.
917      */
918     constructor() ERC721("discreet", "DISCREET") {
919         // Set up ENS reverse registrar.
920         IENSReverseRegistrar _ensReverseRegistrar = IENSReverseRegistrar(
921             0x084b1c3C81545d370f3634392De611CaaBFf8148
922         );
923 
924         _ensReverseRegistrar.claim(msg.sender);
925         _ensReverseRegistrar.setName("discreet.eth");
926 
927         migrationEnds = block.number + 21600; // ~3 days
928     }
929 
930     /**
931      * @dev Throttle minting to once a block and reset the reclamation threshold
932      * whenever a new token is minted or transferred.
933      */
934     function _beforeTokenTransfer(
935         address from,
936         address to,
937         uint256 tokenId
938     ) internal override(ERC721, ERC721Enumerable) {
939         super._beforeTokenTransfer(from, to, tokenId);
940 
941         // If minting: ensure it's the only one from this tx origin in the block.
942         if (from == address(0)) {
943             require(
944                 block.number > _lastTokenMinted[tx.origin],
945                 "discreet: cannot mint multiple tokens per block from a single origin"
946             );
947 
948             _lastTokenMinted[tx.origin] = block.number;
949         }
950 
951         // If not burning: reset tokenId's reclaimable threshold block number.
952         if (to != address(0)) {
953             _reclaimableThreshold[tokenId] = block.number + 0x400000;
954         }
955     }
956 
957     /**
958      * @dev Wrap an original or extra discreet NFT when transferred to this
959      * contract via `safeTransferFrom` during the migration period.
960      */
961     function onERC721Received(
962         address operator,
963         address from,
964         uint256 tokenId,
965         bytes calldata data
966     ) external override returns (bytes4) {
967         require(
968             block.number < migrationEnds,
969             "discreet: token migration is complete."
970         );
971 
972         require(
973             msg.sender == address(originalSet) || msg.sender == address(extraSet),
974             "discreet: only accepts original or extra set discreet tokens."
975         );
976 
977         if (msg.sender == address(originalSet)) {
978             require(
979                 tokenId < 0x240,
980                 "discreet: only accepts original set discreet tokens with metadata"
981             );
982             _safeMint(from, tokenId);
983         } else {
984             require(
985                 tokenId < 0x120,
986                 "discreet: only accepts extra set discreet tokens with metadata"
987             );
988             _safeMint(from, tokenId + 0x240);
989         }
990 
991         return this.onERC721Received.selector;
992     }
993 
994     /**
995      * @dev Mint a given discreet NFT if it is currently available.
996      */
997     function mint(uint256 tokenId) external override {
998         require(
999             tokenId < 0x510,
1000             "discreet: cannot mint out-of-range token"
1001         );
1002 
1003         if (tokenId < 0x360) {
1004             require(
1005                 block.number >= migrationEnds,
1006                 "discreet: cannot mint tokens from original or extra set until migration is complete."
1007             );
1008         }
1009 
1010         _safeMint(msg.sender, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Mint a given NFT if it is currently available to a given address.
1015      */
1016     function mint(address to, uint256 tokenId) external override {
1017         require(
1018             tokenId < 0x510,
1019             "discreet: cannot mint out-of-range token"
1020         );
1021 
1022         if (tokenId < 0x360) {
1023             require(
1024                 block.number >= migrationEnds,
1025                 "discreet: cannot mint tokens from original or extra set until migration is complete."
1026             );
1027         }
1028 
1029         _safeMint(to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Burn a given discreet NFT if it is owned, approved or reclaimable.
1034      * Tokens become reclaimable after ~4 million blocks without a transfer.
1035      */
1036     function burn(uint256 tokenId) external override {
1037         require(
1038             tokenId < 0x510,
1039             "discreet: cannot burn out-of-range token"
1040         );
1041 
1042         // Only enforce check if tokenId has not reached reclaimable threshold.
1043         if (!isReclaimable(tokenId)) {
1044             require(
1045                 _isApprovedOrOwner(msg.sender, tokenId),
1046                 "discreet: caller is not owner nor approved"
1047             );
1048         }
1049 
1050         _burn(tokenId);
1051     }
1052 
1053     /**
1054      * @dev Check the current block number at which the given token will become
1055      * reclaimable.
1056      */
1057     function reclaimableThreshold(uint256 tokenId) public view override returns (uint256) {
1058         require(tokenId < 0x510, "discreet: out-of-range token");
1059 
1060         return _reclaimableThreshold[tokenId];
1061     }
1062 
1063     /**
1064      * @dev Check whether a given token is currently reclaimable.
1065      */
1066     function isReclaimable(uint256 tokenId) public view override returns (bool) {
1067         return reclaimableThreshold(tokenId) < block.number;
1068     }
1069 
1070     /**
1071      * @dev Derive and return a discreet tokenURI image formatted as a data URI.
1072      */
1073     function tokenImageURI(uint256 tokenId) public view virtual override returns (string memory) {
1074         require(tokenId < 0x510, "discreet: URI image query for out-of-range token");
1075 
1076         // Nine base64-encoded SVG fragments for background colors.
1077         bytes9[9] memory c0 = [
1078             bytes9('MwMDAwMDA'),
1079             'M2OWZmMzc',
1080             'NmZjM3Njk',
1081             'MzNzY5ZmY',
1082             'NmZmZmOTA',
1083             'M5MGZmZmY',
1084             'NmZjkwZmY',
1085             'NmZmZmZmY',
1086             'M4MDgwODA'
1087         ];
1088 
1089         // Eighteen base64-encoded SVG fragments for primary shapes.
1090         string[18] memory s0 = [
1091             'yZWN0IHg9IjE1NSIgeT0iNTUiIHdpZHRoPSIxOTAiIGhlaWdodD0iMzkwIi',
1092             'yZWN0IHg9IjU1IiB5PSIxNTUiIHdpZHRoPSIzOTAiIGhlaWdodD0iMTkwIi',
1093             'yZWN0IHg9IjExNSIgeT0iMTE1IiB3aWR0aD0iMjcwIiBoZWlnaHQ9IjI3MCIgIC',
1094             'jaXJjbGUgY3g9IjI1MCIgY3k9IjI1MCIgcj0iMTY1Ii',
1095             'lbGxpcHNlIGN4PSIyNTAiIGN5PSIyNTAiIHJ4PSIxMjUiIHJ5PSIxOTUiIC',
1096             'lbGxpcHNlIGN4PSIyNTAiIGN5PSIyNTAiIHJ4PSIxOTUiIHJ5PSIxMjUiIC',
1097             'wb2x5Z29uIHBvaW50cz0iMTAwLDEzNSAyNTAsNDAwIDQwMCwxMzUiIC',
1098             'wb2x5Z29uIHBvaW50cz0iNDAwLDM2NSAyNTAsMTAwIDEwMCwzNjUiIC',
1099             'wb2x5Z29uIHBvaW50cz0iNDAwLDEwMCA0MDAsNDAwIDEwMCw0MDAiIC',
1100             'wb2x5Z29uIHBvaW50cz0iMTAwLDQwMCA0MDAsNDAwIDEwMCwxMDAiIC',
1101             'wb2x5Z29uIHBvaW50cz0iMTAwLDQwMCA0MDAsMTAwIDEwMCwxMDAiIC',
1102             'wb2x5Z29uIHBvaW50cz0iNDAwLDQwMCA0MDAsMTAwIDEwMCwxMDAiIC',
1103             'wb2x5Z29uIHBvaW50cz0iMjMwLDQwMCAyNzAsNDAwIDI3MCwyNzAgNDAwLDI3MCA0MDAsMjMwIDI3MCwyMzAgMjcwLDEwMCAyMzAsMTAwIDIzMCwyMzAgMTAwLDIzMCAxMDAsMjcwIDIzMCwyNzAiIC',
1104             'wb2x5Z29uIHBvaW50cz0iMjMwLDQwMCAyNzAsNDAwIDI3MCwyNzAgNDAwLDI3MCA0MDAsMjMwIDI3MCwyMzAgMjcwLDEwMCAyMzAsMTAwIDIzMCwyMzAgMTAwLDIzMCAxMDAsMjcwIDIzMCwyNzAiIHRyYW5zZm9ybT0icm90YXRlKDQ1LDI1MCwyNTApIi',
1105             'wb2x5Z29uIHBvaW50cz0iMjUwLDQwMCAzNTAsMjUwIDI1MCwxMDAgMTUwLDI1MCIgIC',
1106             'wb2x5Z29uIHBvaW50cz0iMjUwLDEwMCAzMzgsMzcxIDEwNywyMDQgMzkzLDIwNCAxNjIsMzcxIi',
1107             'wb2x5Z29uIHBvaW50cz0iMzgwLDE3NSAzODAsMzI1IDI1MCw0MDAgMTIwLDMyNSAxMjAsMTc1IDI1MCwxMDAiIC',
1108             'wYXRoIGQ9Ik0wIDIwMCB2LTIwMCBoMjAwIGExMywxMSAwIDAsMSAwLDIwMCBhMTEsMTMgMCAwLDEgLTIwMCwwIiB0cmFuc2Zvcm09InJvdGF0ZSgyMjUsMjA4LDE0OCkgc2NhbGUoMC45MikiIC'
1109         ];
1110 
1111         // Nine base64-encoded SVG fragments for primary colors.
1112         bytes8[9] memory c1 = [
1113             bytes8('NjlmZjM3'),
1114             'ZmYzNzY5',
1115             'Mzc2OWZm',
1116             'ZmZmZjkw',
1117             'OTBmZmZm',
1118             'ZmY5MGZm',
1119             'ZmZmZmZm',
1120             'ODA4MDgw',
1121             'MDAwMDAw'
1122         ];
1123 
1124         // Construct a discrete tokenURI from a unique combination of the above.
1125         uint256 c0i = (tokenId % 72) / 8;
1126         uint256 s0i = tokenId / 72;
1127         uint256 c1i = (tokenId % 8 + (tokenId / 8)) % 9;
1128         return string(
1129             abi.encodePacked(
1130                 h0, h1, h2, h3, h4, h5, c0[c0i], m0, s0[s0i], m1, c1[c1i], f0
1131            )
1132        );
1133     }
1134 
1135     /**
1136      * @dev Derive and return a tokenURI json payload formatted as a
1137      * data URI.
1138      */
1139     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1140         string memory json = Base64.encode(
1141             bytes(
1142                 string(
1143                     abi.encodePacked(
1144                         '{"name": "discreet #',
1145                         _toString(tokenId),
1146                         '", "description": "One of 1296 distinct images, stored and derived ',
1147                         'entirely on-chain, that comprise the discreet.eth collection. It ',
1148                         'will become reclaimable if 4,194,304 blocks elapse without this ',
1149                         'token being minted or transferred.", "image": "',
1150                         tokenImageURI(tokenId),
1151                         '"}'
1152                     )
1153                 )
1154             )
1155         );
1156 
1157         return string(abi.encodePacked('data:application/json;base64,', json));
1158     }
1159 
1160     /**
1161      * @dev Derive and return a contract-level json payload formatted as a
1162      * data URI.
1163      */
1164     function contractURI() public view returns (string memory) {
1165         return string(
1166             abi.encodePacked(
1167                 'data:application/json;base64,',
1168                 Base64.encode(
1169                     bytes(
1170                         string(
1171                             abi.encodePacked(
1172                                 '{"name": "discreet.eth", ',
1173                                 '"description": "A set of 1296 distinct images, stored and derived entirely ',
1174                                 'on-chain, that comprise the discreet.eth collection. Each token will ',
1175                                 'become reclaimable if 4,194,304 blocks elapse without a mint or transfer of ',
1176                                 'the token in question. Created with #1283 by 0age."}'
1177                             )
1178                         )
1179                     )
1180                 )
1181             )
1182         );
1183     }
1184 
1185     /**
1186      * @dev Coalesce supportsInterface from inherited contracts.
1187      */
1188     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1189         return super.supportsInterface(interfaceId);
1190     }
1191 
1192     function _toString(uint256 value) internal pure returns (string memory) {
1193         // Inspired by OraclizeAPI's implementation - MIT licence
1194         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1195         if (value == 0) {
1196             return "0";
1197         }
1198         uint256 temp = value;
1199         uint256 digits;
1200         while (temp != 0) {
1201             digits++;
1202             temp /= 10;
1203         }
1204         bytes memory buffer = new bytes(digits);
1205         while (value != 0) {
1206             digits -= 1;
1207             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1208             value /= 10;
1209         }
1210         return string(buffer);
1211     }
1212 }