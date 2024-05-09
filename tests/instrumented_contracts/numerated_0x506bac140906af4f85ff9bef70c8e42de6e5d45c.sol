1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _setOwner(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _setOwner(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _setOwner(newOwner);
83     }
84 
85     function _setOwner(address newOwner) private {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 /**
93  * @dev Interface of the ERC165 standard, as defined in the
94  * https://eips.ethereum.org/EIPS/eip-165[EIP].
95  *
96  * Implementers can declare support of contract interfaces, which can then be
97  * queried by others ({ERC165Checker}).
98  *
99  * For an implementation, see {ERC165}.
100  */
101 interface IERC165 {
102     /**
103      * @dev Returns true if this contract implements the interface defined by
104      * `interfaceId`. See the corresponding
105      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
106      * to learn more about how these ids are created.
107      *
108      * This function call must use less than 30 000 gas.
109      */
110     function supportsInterface(bytes4 interfaceId) external view returns (bool);
111 }
112 
113 /**
114  * @dev Required interface of an ERC721 compliant contract.
115  */
116 interface IERC721 is IERC165 {
117     /**
118      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
124      */
125     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
129      */
130     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
131 
132     /**
133      * @dev Returns the number of tokens in ``owner``'s account.
134      */
135     function balanceOf(address owner) external view returns (uint256 balance);
136 
137     /**
138      * @dev Returns the owner of the `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function ownerOf(uint256 tokenId) external view returns (address owner);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
148      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId
164     ) external;
165 
166     /**
167      * @dev Transfers `tokenId` token from `from` to `to`.
168      *
169      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external;
185 
186     /**
187      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
188      * The approval is cleared when the token is transferred.
189      *
190      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
191      *
192      * Requirements:
193      *
194      * - The caller must own the token or be an approved operator.
195      * - `tokenId` must exist.
196      *
197      * Emits an {Approval} event.
198      */
199     function approve(address to, uint256 tokenId) external;
200 
201     /**
202      * @dev Returns the account approved for `tokenId` token.
203      *
204      * Requirements:
205      *
206      * - `tokenId` must exist.
207      */
208     function getApproved(uint256 tokenId) external view returns (address operator);
209 
210     /**
211      * @dev Approve or remove `operator` as an operator for the caller.
212      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
213      *
214      * Requirements:
215      *
216      * - The `operator` cannot be the caller.
217      *
218      * Emits an {ApprovalForAll} event.
219      */
220     function setApprovalForAll(address operator, bool _approved) external;
221 
222     /**
223      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
224      *
225      * See {setApprovalForAll}
226      */
227     function isApprovedForAll(address owner, address operator) external view returns (bool);
228 
229     /**
230      * @dev Safely transfers `tokenId` token from `from` to `to`.
231      *
232      * Requirements:
233      *
234      * - `from` cannot be the zero address.
235      * - `to` cannot be the zero address.
236      * - `tokenId` token must exist and be owned by `from`.
237      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
238      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
239      *
240      * Emits a {Transfer} event.
241      */
242     function safeTransferFrom(
243         address from,
244         address to,
245         uint256 tokenId,
246         bytes calldata data
247     ) external;
248 }
249 
250 /**
251  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
252  * @dev See https://eips.ethereum.org/EIPS/eip-721
253  */
254 interface IERC721Enumerable is IERC721 {
255     /**
256      * @dev Returns the total amount of tokens stored by the contract.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
262      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
263      */
264     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
265 
266     /**
267      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
268      * Use along with {totalSupply} to enumerate all tokens.
269      */
270     function tokenByIndex(uint256 index) external view returns (uint256);
271 }
272 
273 /**
274  * @dev Implementation of the {IERC165} interface.
275  *
276  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
277  * for the additional interface id that will be supported. For example:
278  *
279  * ```solidity
280  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
281  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
282  * }
283  * ```
284  *
285  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
286  */
287 abstract contract ERC165 is IERC165 {
288     /**
289      * @dev See {IERC165-supportsInterface}.
290      */
291     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
292         return interfaceId == type(IERC165).interfaceId;
293     }
294 }
295 
296 /**
297  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
298  * @dev See https://eips.ethereum.org/EIPS/eip-721
299  */
300 interface IERC721Metadata is IERC721 {
301     /**
302      * @dev Returns the token collection name.
303      */
304     function name() external view returns (string memory);
305 
306     /**
307      * @dev Returns the token collection symbol.
308      */
309     function symbol() external view returns (string memory);
310 
311     /**
312      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
313      */
314     function tokenURI(uint256 tokenId) external view returns (string memory);
315 }
316 
317 
318 
319 
320 
321 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
722 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
723 /**
724  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
725  * enumerability of all the token ids in the contract as well as all token ids owned by each
726  * account.
727  */
728 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
729     // Mapping from owner to list of owned token IDs
730     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
731 
732     // Mapping from token ID to index of the owner tokens list
733     mapping(uint256 => uint256) private _ownedTokensIndex;
734 
735     // Array with all token ids, used for enumeration
736     uint256[] private _allTokens;
737 
738     // Mapping from token id to position in the allTokens array
739     mapping(uint256 => uint256) private _allTokensIndex;
740 
741     /**
742      * @dev See {IERC165-supportsInterface}.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
745         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
746     }
747 
748     /**
749      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
750      */
751     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
752         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
753         return _ownedTokens[owner][index];
754     }
755 
756     /**
757      * @dev See {IERC721Enumerable-totalSupply}.
758      */
759     function totalSupply() public view virtual override returns (uint256) {
760         return _allTokens.length;
761     }
762 
763     /**
764      * @dev See {IERC721Enumerable-tokenByIndex}.
765      */
766     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
767         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
768         return _allTokens[index];
769     }
770 
771     /**
772      * @dev Hook that is called before any token transfer. This includes minting
773      * and burning.
774      *
775      * Calling conditions:
776      *
777      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
778      * transferred to `to`.
779      * - When `from` is zero, `tokenId` will be minted for `to`.
780      * - When `to` is zero, ``from``'s `tokenId` will be burned.
781      * - `from` cannot be the zero address.
782      * - `to` cannot be the zero address.
783      *
784      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
785      */
786     function _beforeTokenTransfer(
787         address from,
788         address to,
789         uint256 tokenId
790     ) internal virtual override {
791         super._beforeTokenTransfer(from, to, tokenId);
792 
793         if (from == address(0)) {
794             _addTokenToAllTokensEnumeration(tokenId);
795         } else if (from != to) {
796             _removeTokenFromOwnerEnumeration(from, tokenId);
797         }
798         if (to == address(0)) {
799             _removeTokenFromAllTokensEnumeration(tokenId);
800         } else if (to != from) {
801             _addTokenToOwnerEnumeration(to, tokenId);
802         }
803     }
804 
805     /**
806      * @dev Private function to add a token to this extension's ownership-tracking data structures.
807      * @param to address representing the new owner of the given token ID
808      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
809      */
810     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
811         uint256 length = ERC721.balanceOf(to);
812         _ownedTokens[to][length] = tokenId;
813         _ownedTokensIndex[tokenId] = length;
814     }
815 
816     /**
817      * @dev Private function to add a token to this extension's token tracking data structures.
818      * @param tokenId uint256 ID of the token to be added to the tokens list
819      */
820     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
821         _allTokensIndex[tokenId] = _allTokens.length;
822         _allTokens.push(tokenId);
823     }
824 
825     /**
826      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
827      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
828      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
829      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
830      * @param from address representing the previous owner of the given token ID
831      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
832      */
833     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
834         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
835         // then delete the last slot (swap and pop).
836 
837         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
838         uint256 tokenIndex = _ownedTokensIndex[tokenId];
839 
840         // When the token to delete is the last token, the swap operation is unnecessary
841         if (tokenIndex != lastTokenIndex) {
842             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
843 
844             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
845             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
846         }
847 
848         // This also deletes the contents at the last position of the array
849         delete _ownedTokensIndex[tokenId];
850         delete _ownedTokens[from][lastTokenIndex];
851     }
852 
853     /**
854      * @dev Private function to remove a token from this extension's token tracking data structures.
855      * This has O(1) time complexity, but alters the order of the _allTokens array.
856      * @param tokenId uint256 ID of the token to be removed from the tokens list
857      */
858     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
859         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
860         // then delete the last slot (swap and pop).
861 
862         uint256 lastTokenIndex = _allTokens.length - 1;
863         uint256 tokenIndex = _allTokensIndex[tokenId];
864 
865         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
866         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
867         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
868         uint256 lastTokenId = _allTokens[lastTokenIndex];
869 
870         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
871         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
872 
873         // This also deletes the contents at the last position of the array
874         delete _allTokensIndex[tokenId];
875         _allTokens.pop();
876     }
877 }
878 
879 // File: @openzeppelin/contracts/utils/Strings.sol
880 /**
881  * @dev String operations.
882  */
883 library Strings {
884     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
885 
886     /**
887      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
888      */
889     function toString(uint256 value) internal pure returns (string memory) {
890         // Inspired by OraclizeAPI's implementation - MIT licence
891         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
892 
893         if (value == 0) {
894             return "0";
895         }
896         uint256 temp = value;
897         uint256 digits;
898         while (temp != 0) {
899             digits++;
900             temp /= 10;
901         }
902         bytes memory buffer = new bytes(digits);
903         while (value != 0) {
904             digits -= 1;
905             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
906             value /= 10;
907         }
908         return string(buffer);
909     }
910 
911     /**
912      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
913      */
914     function toHexString(uint256 value) internal pure returns (string memory) {
915         if (value == 0) {
916             return "0x00";
917         }
918         uint256 temp = value;
919         uint256 length = 0;
920         while (temp != 0) {
921             length++;
922             temp >>= 8;
923         }
924         return toHexString(value, length);
925     }
926 
927     /**
928      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
929      */
930     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
931         bytes memory buffer = new bytes(2 * length + 2);
932         buffer[0] = "0";
933         buffer[1] = "x";
934         for (uint256 i = 2 * length + 1; i > 1; --i) {
935             buffer[i] = _HEX_SYMBOLS[value & 0xf];
936             value >>= 4;
937         }
938         require(value == 0, "Strings: hex length insufficient");
939         return string(buffer);
940     }
941 }
942 
943 // File: @openzeppelin/contracts/utils/Address.sol
944 /**
945  * @dev Collection of functions related to the address type
946  */
947 library Address {
948     /**
949      * @dev Returns true if `account` is a contract.
950      *
951      * [IMPORTANT]
952      * ====
953      * It is unsafe to assume that an address for which this function returns
954      * false is an externally-owned account (EOA) and not a contract.
955      *
956      * Among others, `isContract` will return false for the following
957      * types of addresses:
958      *
959      *  - an externally-owned account
960      *  - a contract in construction
961      *  - an address where a contract will be created
962      *  - an address where a contract lived, but was destroyed
963      * ====
964      */
965     function isContract(address account) internal view returns (bool) {
966         // This method relies on extcodesize, which returns 0 for contracts in
967         // construction, since the code is only stored at the end of the
968         // constructor execution.
969 
970         uint256 size;
971         assembly {
972             size := extcodesize(account)
973         }
974         return size > 0;
975     }
976 
977     /**
978      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
979      * `recipient`, forwarding all available gas and reverting on errors.
980      *
981      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
982      * of certain opcodes, possibly making contracts go over the 2300 gas limit
983      * imposed by `transfer`, making them unable to receive funds via
984      * `transfer`. {sendValue} removes this limitation.
985      *
986      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
987      *
988      * IMPORTANT: because control is transferred to `recipient`, care must be
989      * taken to not create reentrancy vulnerabilities. Consider using
990      * {ReentrancyGuard} or the
991      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
992      */
993     function sendValue(address payable recipient, uint256 amount) internal {
994         require(address(this).balance >= amount, "Address: insufficient balance");
995 
996         (bool success, ) = recipient.call{value: amount}("");
997         require(success, "Address: unable to send value, recipient may have reverted");
998     }
999 
1000     /**
1001      * @dev Performs a Solidity function call using a low level `call`. A
1002      * plain `call` is an unsafe replacement for a function call: use this
1003      * function instead.
1004      *
1005      * If `target` reverts with a revert reason, it is bubbled up by this
1006      * function (like regular Solidity function calls).
1007      *
1008      * Returns the raw returned data. To convert to the expected return value,
1009      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1010      *
1011      * Requirements:
1012      *
1013      * - `target` must be a contract.
1014      * - calling `target` with `data` must not revert.
1015      *
1016      * _Available since v3.1._
1017      */
1018     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1019         return functionCall(target, data, "Address: low-level call failed");
1020     }
1021 
1022     /**
1023      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1024      * `errorMessage` as a fallback revert reason when `target` reverts.
1025      *
1026      * _Available since v3.1._
1027      */
1028     function functionCall(
1029         address target,
1030         bytes memory data,
1031         string memory errorMessage
1032     ) internal returns (bytes memory) {
1033         return functionCallWithValue(target, data, 0, errorMessage);
1034     }
1035 
1036     /**
1037      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1038      * but also transferring `value` wei to `target`.
1039      *
1040      * Requirements:
1041      *
1042      * - the calling contract must have an ETH balance of at least `value`.
1043      * - the called Solidity function must be `payable`.
1044      *
1045      * _Available since v3.1._
1046      */
1047     function functionCallWithValue(
1048         address target,
1049         bytes memory data,
1050         uint256 value
1051     ) internal returns (bytes memory) {
1052         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1053     }
1054 
1055     /**
1056      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1057      * with `errorMessage` as a fallback revert reason when `target` reverts.
1058      *
1059      * _Available since v3.1._
1060      */
1061     function functionCallWithValue(
1062         address target,
1063         bytes memory data,
1064         uint256 value,
1065         string memory errorMessage
1066     ) internal returns (bytes memory) {
1067         require(address(this).balance >= value, "Address: insufficient balance for call");
1068         require(isContract(target), "Address: call to non-contract");
1069 
1070         (bool success, bytes memory returndata) = target.call{value: value}(data);
1071         return _verifyCallResult(success, returndata, errorMessage);
1072     }
1073 
1074     /**
1075      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1076      * but performing a static call.
1077      *
1078      * _Available since v3.3._
1079      */
1080     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1081         return functionStaticCall(target, data, "Address: low-level static call failed");
1082     }
1083 
1084     /**
1085      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1086      * but performing a static call.
1087      *
1088      * _Available since v3.3._
1089      */
1090     function functionStaticCall(
1091         address target,
1092         bytes memory data,
1093         string memory errorMessage
1094     ) internal view returns (bytes memory) {
1095         require(isContract(target), "Address: static call to non-contract");
1096 
1097         (bool success, bytes memory returndata) = target.staticcall(data);
1098         return _verifyCallResult(success, returndata, errorMessage);
1099     }
1100 
1101     /**
1102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1103      * but performing a delegate call.
1104      *
1105      * _Available since v3.4._
1106      */
1107     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1108         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1109     }
1110 
1111     /**
1112      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1113      * but performing a delegate call.
1114      *
1115      * _Available since v3.4._
1116      */
1117     function functionDelegateCall(
1118         address target,
1119         bytes memory data,
1120         string memory errorMessage
1121     ) internal returns (bytes memory) {
1122         require(isContract(target), "Address: delegate call to non-contract");
1123 
1124         (bool success, bytes memory returndata) = target.delegatecall(data);
1125         return _verifyCallResult(success, returndata, errorMessage);
1126     }
1127 
1128     function _verifyCallResult(
1129         bool success,
1130         bytes memory returndata,
1131         string memory errorMessage
1132     ) private pure returns (bytes memory) {
1133         if (success) {
1134             return returndata;
1135         } else {
1136             // Look for revert reason and bubble it up if present
1137             if (returndata.length > 0) {
1138                 // The easiest way to bubble the revert reason is using memory via assembly
1139 
1140                 assembly {
1141                     let returndata_size := mload(returndata)
1142                     revert(add(32, returndata), returndata_size)
1143                 }
1144             } else {
1145                 revert(errorMessage);
1146             }
1147         }
1148     }
1149 }
1150 
1151 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1152 /**
1153  * @title ERC721 token receiver interface
1154  * @dev Interface for any contract that wants to support safeTransfers
1155  * from ERC721 asset contracts.
1156  */
1157 interface IERC721Receiver {
1158     /**
1159      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1160      * by `operator` from `from`, this function is called.
1161      *
1162      * It must return its Solidity selector to confirm the token transfer.
1163      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1164      *
1165      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1166      */
1167     function onERC721Received(
1168         address operator,
1169         address from,
1170         uint256 tokenId,
1171         bytes calldata data
1172     ) external returns (bytes4);
1173 }
1174 
1175 
1176 
1177 
1178 contract TwoHundredKeys is ERC721, ERC721Enumerable, Ownable {
1179 
1180   uint public constant MAX_SUPPLY = 10000;
1181   uint private constant MAX_MINT_PER_CALL = 20;
1182 
1183   bool public saleActive = false;
1184 
1185   uint256 private _price = 100000000000000000; //0.10 ETH
1186   string private _baseTokenURI = "ipfs://QmTN7q7KrGxPs2jAAtBgvKME1WZtEacEQUTCVXcoFehjke/";
1187 
1188 
1189 
1190   constructor() ERC721("200 Keys", "KEYS") {
1191   }
1192 
1193 
1194 
1195   function _baseURI() internal view override(ERC721) returns (string memory) {
1196     return _baseTokenURI;
1197   }
1198 
1199   function setBaseURI(string memory baseURI) public onlyOwner {
1200     _baseTokenURI = baseURI;
1201   }
1202 
1203   function getBaseURI() external view returns(string memory) {
1204     return _baseTokenURI;
1205   }
1206 
1207 
1208 
1209   function setPrice(uint256 price) public onlyOwner {
1210     _price = price;
1211   }
1212 
1213   function getPrice() external view returns(uint256) {
1214     return _price;
1215   }
1216 
1217 
1218    function tokensOfHolder(address _holder) external view returns(uint256[] memory ) {
1219     uint256 tokenCount = balanceOf(_holder);
1220     if (tokenCount == 0) {
1221       // Return an empty array
1222       return new uint256[](0);
1223     } else {
1224       uint256[] memory result = new uint256[](tokenCount);
1225       uint256 index;
1226       for (index = 0; index < tokenCount; index++) {
1227         result[index] = tokenOfOwnerByIndex(_holder, index);
1228       }
1229       return result;
1230     }
1231   }
1232 
1233   function mint(uint256 numNFTs) public payable {
1234     require(saleActive, "Sale is not active");
1235     require(MAX_SUPPLY > totalSupply(), "Minting has already finished");
1236     require(numNFTs > 0 && numNFTs <= MAX_MINT_PER_CALL, "Mint exceeds MAX_MINT_PER_CALL");
1237     require(MAX_SUPPLY >= totalSupply() + numNFTs, "Mint would exceed MAX_SUPPLY");
1238     require(msg.value >= _price * numNFTs, "Too little ETH sent");
1239 
1240     for (uint i = 0; i < numNFTs; i++) {
1241       uint mintIndex = totalSupply() + 1; // +1 so it doesn't start on index 0.
1242       _safeMint(msg.sender, mintIndex);
1243     }
1244   }
1245 
1246   function toggleSaleState() public onlyOwner {
1247     saleActive = !saleActive;
1248   }
1249 
1250   function withdraw() public onlyOwner {
1251     require(payable(msg.sender).send(address(this).balance));
1252   }
1253 
1254   function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1255     internal
1256     override(ERC721, ERC721Enumerable)
1257   {
1258     super._beforeTokenTransfer(from, to, tokenId);
1259   }
1260 
1261   function _burn(uint256 tokenId) internal override(ERC721) {
1262     super._burn(tokenId);
1263   }
1264 
1265   function tokenURI(uint256 tokenId)
1266     public
1267     view
1268     override(ERC721)
1269     returns (string memory)
1270   {
1271     return super.tokenURI(tokenId);
1272   }
1273 
1274 
1275   function supportsInterface(bytes4 interfaceId)
1276     public
1277     view
1278     override(ERC721, ERC721Enumerable)
1279     returns (bool)
1280   {
1281     return super.supportsInterface(interfaceId);
1282   }
1283 
1284 }