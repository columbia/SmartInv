1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Context.sol
67 
68 
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Provides information about the current execution context, including the
74  * sender of the transaction and its data. While these are generally available
75  * via msg.sender and msg.data, they should not be accessed in such a direct
76  * manner, since when dealing with meta-transactions the account sending and
77  * paying for execution may not be the actual sender (as far as an application
78  * is concerned).
79  *
80  * This contract is only required for intermediate, library-like contracts.
81  */
82 abstract contract Context {
83     function _msgSender() internal view virtual returns (address) {
84         return msg.sender;
85     }
86 
87     function _msgData() internal view virtual returns (bytes calldata) {
88         return msg.data;
89     }
90 }
91 
92 
93 // File: @openzeppelin/contracts/access/Ownable.sol
94 
95 
96 
97 pragma solidity ^0.8.0;
98 
99 
100 /**
101  * @dev Contract module which provides a basic access control mechanism, where
102  * there is an account (an owner) that can be granted exclusive access to
103  * specific functions.
104  *
105  * By default, the owner account will be the one that deploys the contract. This
106  * can later be changed with {transferOwnership}.
107  *
108  * This module is used through inheritance. It will make available the modifier
109  * `onlyOwner`, which can be applied to your functions to restrict their use to
110  * the owner.
111  */
112 abstract contract Ownable is Context {
113     address private _owner;
114 
115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116 
117     /**
118      * @dev Initializes the contract setting the deployer as the initial owner.
119      */
120     constructor() {
121         _setOwner(_msgSender());
122     }
123 
124     /**
125      * @dev Returns the address of the current owner.
126      */
127     function owner() public view virtual returns (address) {
128         return _owner;
129     }
130 
131     /**
132      * @dev Throws if called by any account other than the owner.
133      */
134     modifier onlyOwner() {
135         require(owner() == _msgSender(), "Ownable: caller is not the owner");
136         _;
137     }
138 
139     /**
140      * @dev Leaves the contract without owner. It will not be possible to call
141      * `onlyOwner` functions anymore. Can only be called by the current owner.
142      *
143      * NOTE: Renouncing ownership will leave the contract without an owner,
144      * thereby removing any functionality that is only available to the owner.
145      */
146     function renounceOwnership() public virtual onlyOwner {
147         _setOwner(address(0));
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Can only be called by the current owner.
153      */
154     function transferOwnership(address newOwner) public virtual onlyOwner {
155         require(newOwner != address(0), "Ownable: new owner is the zero address");
156         _setOwner(newOwner);
157     }
158 
159     function _setOwner(address newOwner) private {
160         address oldOwner = _owner;
161         _owner = newOwner;
162         emit OwnershipTransferred(oldOwner, newOwner);
163     }
164 }
165 
166 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
167 
168 
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Interface of the ERC165 standard, as defined in the
174  * https://eips.ethereum.org/EIPS/eip-165[EIP].
175  *
176  * Implementers can declare support of contract interfaces, which can then be
177  * queried by others ({ERC165Checker}).
178  *
179  * For an implementation, see {ERC165}.
180  */
181 interface IERC165 {
182     /**
183      * @dev Returns true if this contract implements the interface defined by
184      * `interfaceId`. See the corresponding
185      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
186      * to learn more about how these ids are created.
187      *
188      * This function call must use less than 30 000 gas.
189      */
190     function supportsInterface(bytes4 interfaceId) external view returns (bool);
191 }
192 
193 
194 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
195 
196 
197 
198 pragma solidity ^0.8.0;
199 
200 
201 /**
202  * @dev Implementation of the {IERC165} interface.
203  *
204  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
205  * for the additional interface id that will be supported. For example:
206  *
207  * ```solidity
208  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
209  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
210  * }
211  * ```
212  *
213  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
214  */
215 abstract contract ERC165 is IERC165 {
216     /**
217      * @dev See {IERC165-supportsInterface}.
218      */
219     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
220         return interfaceId == type(IERC165).interfaceId;
221     }
222 }
223 
224 
225 
226 
227 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
228 
229 
230 
231 pragma solidity ^0.8.0;
232 
233 
234 /**
235  * @dev Required interface of an ERC721 compliant contract.
236  */
237 interface IERC721 is IERC165 {
238     /**
239      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
240      */
241     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
245      */
246     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
247 
248     /**
249      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
250      */
251     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
252 
253     /**
254      * @dev Returns the number of tokens in ``owner``'s account.
255      */
256     function balanceOf(address owner) external view returns (uint256 balance);
257 
258     /**
259      * @dev Returns the owner of the `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function ownerOf(uint256 tokenId) external view returns (address owner);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
269      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
278      *
279      * Emits a {Transfer} event.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Transfers `tokenId` token from `from` to `to`.
289      *
290      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must be owned by `from`.
297      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
309      * The approval is cleared when the token is transferred.
310      *
311      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
312      *
313      * Requirements:
314      *
315      * - The caller must own the token or be an approved operator.
316      * - `tokenId` must exist.
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address to, uint256 tokenId) external;
321 
322     /**
323      * @dev Returns the account approved for `tokenId` token.
324      *
325      * Requirements:
326      *
327      * - `tokenId` must exist.
328      */
329     function getApproved(uint256 tokenId) external view returns (address operator);
330 
331     /**
332      * @dev Approve or remove `operator` as an operator for the caller.
333      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
334      *
335      * Requirements:
336      *
337      * - The `operator` cannot be the caller.
338      *
339      * Emits an {ApprovalForAll} event.
340      */
341     function setApprovalForAll(address operator, bool _approved) external;
342 
343     /**
344      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
345      *
346      * See {setApprovalForAll}
347      */
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 
350     /**
351      * @dev Safely transfers `tokenId` token from `from` to `to`.
352      *
353      * Requirements:
354      *
355      * - `from` cannot be the zero address.
356      * - `to` cannot be the zero address.
357      * - `tokenId` token must exist and be owned by `from`.
358      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
359      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
360      *
361      * Emits a {Transfer} event.
362      */
363     function safeTransferFrom(
364         address from,
365         address to,
366         uint256 tokenId,
367         bytes calldata data
368     ) external;
369 }
370 
371 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
372 
373 
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
380  * @dev See https://eips.ethereum.org/EIPS/eip-721
381  */
382 interface IERC721Metadata is IERC721 {
383     /**
384      * @dev Returns the token collection name.
385      */
386     function name() external view returns (string memory);
387 
388     /**
389      * @dev Returns the token collection symbol.
390      */
391     function symbol() external view returns (string memory);
392 
393     /**
394      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
395      */
396     function tokenURI(uint256 tokenId) external view returns (string memory);
397 }
398 
399 
400 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
401 
402 
403 
404 pragma solidity ^0.8.0;
405 
406 
407 
408 
409 
410 
411 
412 
413 /**
414  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
415  * the Metadata extension, but not including the Enumerable extension, which is available separately as
416  * {ERC721Enumerable}.
417  */
418 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
419     using Address for address;
420     using Strings for uint256;
421 
422     // Token name
423     string private _name;
424 
425     // Token symbol
426     string private _symbol;
427 
428     // Mapping from token ID to owner address
429     mapping(uint256 => address) private _owners;
430 
431     // Mapping owner address to token count
432     mapping(address => uint256) private _balances;
433 
434     // Mapping from token ID to approved address
435     mapping(uint256 => address) private _tokenApprovals;
436 
437     // Mapping from owner to operator approvals
438     mapping(address => mapping(address => bool)) private _operatorApprovals;
439 
440     /**
441      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
442      */
443     constructor(string memory name_, string memory symbol_) {
444         _name = name_;
445         _symbol = symbol_;
446     }
447 
448     /**
449      * @dev See {IERC165-supportsInterface}.
450      */
451     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
452         return
453             interfaceId == type(IERC721).interfaceId ||
454             interfaceId == type(IERC721Metadata).interfaceId ||
455             super.supportsInterface(interfaceId);
456     }
457 
458     /**
459      * @dev See {IERC721-balanceOf}.
460      */
461     function balanceOf(address owner) public view virtual override returns (uint256) {
462         require(owner != address(0), "ERC721: balance query for the zero address");
463         return _balances[owner];
464     }
465 
466     /**
467      * @dev See {IERC721-ownerOf}.
468      */
469     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
470         address owner = _owners[tokenId];
471         require(owner != address(0), "ERC721: owner query for nonexistent token");
472         return owner;
473     }
474 
475     /**
476      * @dev See {IERC721Metadata-name}.
477      */
478     function name() public view virtual override returns (string memory) {
479         return _name;
480     }
481 
482     /**
483      * @dev See {IERC721Metadata-symbol}.
484      */
485     function symbol() public view virtual override returns (string memory) {
486         return _symbol;
487     }
488 
489     /**
490      * @dev See {IERC721Metadata-tokenURI}.
491      */
492     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
493         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
494 
495         string memory baseURI = _baseURI();
496         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
497     }
498 
499     /**
500      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
501      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
502      * by default, can be overriden in child contracts.
503      */
504     function _baseURI() internal view virtual returns (string memory) {
505         return "";
506     }
507 
508     /**
509      * @dev See {IERC721-approve}.
510      */
511     function approve(address to, uint256 tokenId) public virtual override {
512         address owner = ERC721.ownerOf(tokenId);
513         require(to != owner, "ERC721: approval to current owner");
514 
515         require(
516             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
517             "ERC721: approve caller is not owner nor approved for all"
518         );
519 
520         _approve(to, tokenId);
521     }
522 
523     /**
524      * @dev See {IERC721-getApproved}.
525      */
526     function getApproved(uint256 tokenId) public view virtual override returns (address) {
527         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
528 
529         return _tokenApprovals[tokenId];
530     }
531 
532     /**
533      * @dev See {IERC721-setApprovalForAll}.
534      */
535     function setApprovalForAll(address operator, bool approved) public virtual override {
536         require(operator != _msgSender(), "ERC721: approve to caller");
537 
538         _operatorApprovals[_msgSender()][operator] = approved;
539         emit ApprovalForAll(_msgSender(), operator, approved);
540     }
541 
542     /**
543      * @dev See {IERC721-isApprovedForAll}.
544      */
545     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
546         return _operatorApprovals[owner][operator];
547     }
548 
549     /**
550      * @dev See {IERC721-transferFrom}.
551      */
552     function transferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) public virtual override {
557         //solhint-disable-next-line max-line-length
558         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
559 
560         _transfer(from, to, tokenId);
561     }
562 
563     /**
564      * @dev See {IERC721-safeTransferFrom}.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) public virtual override {
571         safeTransferFrom(from, to, tokenId, "");
572     }
573 
574     /**
575      * @dev See {IERC721-safeTransferFrom}.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId,
581         bytes memory _data
582     ) public virtual override {
583         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
584         _safeTransfer(from, to, tokenId, _data);
585     }
586 
587     /**
588      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
589      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
590      *
591      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
592      *
593      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
594      * implement alternative mechanisms to perform token transfer, such as signature-based.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must exist and be owned by `from`.
601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
602      *
603      * Emits a {Transfer} event.
604      */
605     function _safeTransfer(
606         address from,
607         address to,
608         uint256 tokenId,
609         bytes memory _data
610     ) internal virtual {
611         _transfer(from, to, tokenId);
612         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
613     }
614 
615     /**
616      * @dev Returns whether `tokenId` exists.
617      *
618      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
619      *
620      * Tokens start existing when they are minted (`_mint`),
621      * and stop existing when they are burned (`_burn`).
622      */
623     function _exists(uint256 tokenId) internal view virtual returns (bool) {
624         return _owners[tokenId] != address(0);
625     }
626 
627     /**
628      * @dev Returns whether `spender` is allowed to manage `tokenId`.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
635         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
636         address owner = ERC721.ownerOf(tokenId);
637         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
638     }
639 
640     /**
641      * @dev Safely mints `tokenId` and transfers it to `to`.
642      *
643      * Requirements:
644      *
645      * - `tokenId` must not exist.
646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
647      *
648      * Emits a {Transfer} event.
649      */
650     function _safeMint(address to, uint256 tokenId) internal virtual {
651         _safeMint(to, tokenId, "");
652     }
653 
654     /**
655      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
656      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
657      */
658     function _safeMint(
659         address to,
660         uint256 tokenId,
661         bytes memory _data
662     ) internal virtual {
663         _mint(to, tokenId);
664         require(
665             _checkOnERC721Received(address(0), to, tokenId, _data),
666             "ERC721: transfer to non ERC721Receiver implementer"
667         );
668     }
669 
670     /**
671      * @dev Mints `tokenId` and transfers it to `to`.
672      *
673      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
674      *
675      * Requirements:
676      *
677      * - `tokenId` must not exist.
678      * - `to` cannot be the zero address.
679      *
680      * Emits a {Transfer} event.
681      */
682     function _mint(address to, uint256 tokenId) internal virtual {
683         require(to != address(0), "ERC721: mint to the zero address");
684         require(!_exists(tokenId), "ERC721: token already minted");
685 
686         _beforeTokenTransfer(address(0), to, tokenId);
687 
688         _balances[to] += 1;
689         _owners[tokenId] = to;
690 
691         emit Transfer(address(0), to, tokenId);
692     }
693 
694     /**
695      * @dev Destroys `tokenId`.
696      * The approval is cleared when the token is burned.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must exist.
701      *
702      * Emits a {Transfer} event.
703      */
704     function _burn(uint256 tokenId) internal virtual {
705         address owner = ERC721.ownerOf(tokenId);
706 
707         _beforeTokenTransfer(owner, address(0), tokenId);
708 
709         // Clear approvals
710         _approve(address(0), tokenId);
711 
712         _balances[owner] -= 1;
713         delete _owners[tokenId];
714 
715         emit Transfer(owner, address(0), tokenId);
716     }
717 
718     /**
719      * @dev Transfers `tokenId` from `from` to `to`.
720      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
721      *
722      * Requirements:
723      *
724      * - `to` cannot be the zero address.
725      * - `tokenId` token must be owned by `from`.
726      *
727      * Emits a {Transfer} event.
728      */
729     function _transfer(
730         address from,
731         address to,
732         uint256 tokenId
733     ) internal virtual {
734         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
735         require(to != address(0), "ERC721: transfer to the zero address");
736 
737         _beforeTokenTransfer(from, to, tokenId);
738 
739         // Clear approvals from the previous owner
740         _approve(address(0), tokenId);
741 
742         _balances[from] -= 1;
743         _balances[to] += 1;
744         _owners[tokenId] = to;
745 
746         emit Transfer(from, to, tokenId);
747     }
748 
749     /**
750      * @dev Approve `to` to operate on `tokenId`
751      *
752      * Emits a {Approval} event.
753      */
754     function _approve(address to, uint256 tokenId) internal virtual {
755         _tokenApprovals[tokenId] = to;
756         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
757     }
758 
759     /**
760      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
761      * The call is not executed if the target address is not a contract.
762      *
763      * @param from address representing the previous owner of the given token ID
764      * @param to target address that will receive the tokens
765      * @param tokenId uint256 ID of the token to be transferred
766      * @param _data bytes optional data to send along with the call
767      * @return bool whether the call correctly returned the expected magic value
768      */
769     function _checkOnERC721Received(
770         address from,
771         address to,
772         uint256 tokenId,
773         bytes memory _data
774     ) private returns (bool) {
775         if (to.isContract()) {
776             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
777                 return retval == IERC721Receiver.onERC721Received.selector;
778             } catch (bytes memory reason) {
779                 if (reason.length == 0) {
780                     revert("ERC721: transfer to non ERC721Receiver implementer");
781                 } else {
782                     assembly {
783                         revert(add(32, reason), mload(reason))
784                     }
785                 }
786             }
787         } else {
788             return true;
789         }
790     }
791 
792     /**
793      * @dev Hook that is called before any token transfer. This includes minting
794      * and burning.
795      *
796      * Calling conditions:
797      *
798      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
799      * transferred to `to`.
800      * - When `from` is zero, `tokenId` will be minted for `to`.
801      * - When `to` is zero, ``from``'s `tokenId` will be burned.
802      * - `from` and `to` are never both zero.
803      *
804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
805      */
806     function _beforeTokenTransfer(
807         address from,
808         address to,
809         uint256 tokenId
810     ) internal virtual {}
811 }
812 
813 
814 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
815 
816 
817 
818 pragma solidity ^0.8.0;
819 
820 
821 /**
822  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
823  * @dev See https://eips.ethereum.org/EIPS/eip-721
824  */
825 interface IERC721Enumerable is IERC721 {
826     /**
827      * @dev Returns the total amount of tokens stored by the contract.
828      */
829     function totalSupply() external view returns (uint256);
830 
831     /**
832      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
833      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
834      */
835     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
836 
837     /**
838      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
839      * Use along with {totalSupply} to enumerate all tokens.
840      */
841     function tokenByIndex(uint256 index) external view returns (uint256);
842 }
843 
844 
845 
846 
847 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
848 
849 
850 
851 pragma solidity ^0.8.0;
852 
853 
854 
855 /**
856  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
857  * enumerability of all the token ids in the contract as well as all token ids owned by each
858  * account.
859  */
860 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
861     // Mapping from owner to list of owned token IDs
862     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
863 
864     // Mapping from token ID to index of the owner tokens list
865     mapping(uint256 => uint256) private _ownedTokensIndex;
866 
867     // Array with all token ids, used for enumeration
868     uint256[] private _allTokens;
869 
870     // Mapping from token id to position in the allTokens array
871     mapping(uint256 => uint256) private _allTokensIndex;
872 
873     /**
874      * @dev See {IERC165-supportsInterface}.
875      */
876     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
877         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
878     }
879 
880     /**
881      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
882      */
883     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
884         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
885         return _ownedTokens[owner][index];
886     }
887 
888     /**
889      * @dev See {IERC721Enumerable-totalSupply}.
890      */
891     function totalSupply() public view virtual override returns (uint256) {
892         return _allTokens.length;
893     }
894 
895     /**
896      * @dev See {IERC721Enumerable-tokenByIndex}.
897      */
898     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
899         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
900         return _allTokens[index];
901     }
902 
903     /**
904      * @dev Hook that is called before any token transfer. This includes minting
905      * and burning.
906      *
907      * Calling conditions:
908      *
909      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
910      * transferred to `to`.
911      * - When `from` is zero, `tokenId` will be minted for `to`.
912      * - When `to` is zero, ``from``'s `tokenId` will be burned.
913      * - `from` cannot be the zero address.
914      * - `to` cannot be the zero address.
915      *
916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
917      */
918     function _beforeTokenTransfer(
919         address from,
920         address to,
921         uint256 tokenId
922     ) internal virtual override {
923         super._beforeTokenTransfer(from, to, tokenId);
924 
925         if (from == address(0)) {
926             _addTokenToAllTokensEnumeration(tokenId);
927         } else if (from != to) {
928             _removeTokenFromOwnerEnumeration(from, tokenId);
929         }
930         if (to == address(0)) {
931             _removeTokenFromAllTokensEnumeration(tokenId);
932         } else if (to != from) {
933             _addTokenToOwnerEnumeration(to, tokenId);
934         }
935     }
936 
937     /**
938      * @dev Private function to add a token to this extension's ownership-tracking data structures.
939      * @param to address representing the new owner of the given token ID
940      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
941      */
942     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
943         uint256 length = ERC721.balanceOf(to);
944         _ownedTokens[to][length] = tokenId;
945         _ownedTokensIndex[tokenId] = length;
946     }
947 
948     /**
949      * @dev Private function to add a token to this extension's token tracking data structures.
950      * @param tokenId uint256 ID of the token to be added to the tokens list
951      */
952     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
953         _allTokensIndex[tokenId] = _allTokens.length;
954         _allTokens.push(tokenId);
955     }
956 
957     /**
958      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
959      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
960      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
961      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
962      * @param from address representing the previous owner of the given token ID
963      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
964      */
965     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
966         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
967         // then delete the last slot (swap and pop).
968 
969         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
970         uint256 tokenIndex = _ownedTokensIndex[tokenId];
971 
972         // When the token to delete is the last token, the swap operation is unnecessary
973         if (tokenIndex != lastTokenIndex) {
974             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
975 
976             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
977             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
978         }
979 
980         // This also deletes the contents at the last position of the array
981         delete _ownedTokensIndex[tokenId];
982         delete _ownedTokens[from][lastTokenIndex];
983     }
984 
985     /**
986      * @dev Private function to remove a token from this extension's token tracking data structures.
987      * This has O(1) time complexity, but alters the order of the _allTokens array.
988      * @param tokenId uint256 ID of the token to be removed from the tokens list
989      */
990     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
991         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
992         // then delete the last slot (swap and pop).
993 
994         uint256 lastTokenIndex = _allTokens.length - 1;
995         uint256 tokenIndex = _allTokensIndex[tokenId];
996 
997         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
998         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
999         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1000         uint256 lastTokenId = _allTokens[lastTokenIndex];
1001 
1002         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1003         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1004 
1005         // This also deletes the contents at the last position of the array
1006         delete _allTokensIndex[tokenId];
1007         _allTokens.pop();
1008     }
1009 }
1010 
1011 // File: @openzeppelin/contracts/utils/Strings.sol
1012 
1013 
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 /**
1018  * @dev String operations.
1019  */
1020 library Strings {
1021     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1022 
1023     /**
1024      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1025      */
1026     function toString(uint256 value) internal pure returns (string memory) {
1027         // Inspired by OraclizeAPI's implementation - MIT licence
1028         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1029 
1030         if (value == 0) {
1031             return "0";
1032         }
1033         uint256 temp = value;
1034         uint256 digits;
1035         while (temp != 0) {
1036             digits++;
1037             temp /= 10;
1038         }
1039         bytes memory buffer = new bytes(digits);
1040         while (value != 0) {
1041             digits -= 1;
1042             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1043             value /= 10;
1044         }
1045         return string(buffer);
1046     }
1047 
1048     /**
1049      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1050      */
1051     function toHexString(uint256 value) internal pure returns (string memory) {
1052         if (value == 0) {
1053             return "0x00";
1054         }
1055         uint256 temp = value;
1056         uint256 length = 0;
1057         while (temp != 0) {
1058             length++;
1059             temp >>= 8;
1060         }
1061         return toHexString(value, length);
1062     }
1063 
1064     /**
1065      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1066      */
1067     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1068         bytes memory buffer = new bytes(2 * length + 2);
1069         buffer[0] = "0";
1070         buffer[1] = "x";
1071         for (uint256 i = 2 * length + 1; i > 1; --i) {
1072             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1073             value >>= 4;
1074         }
1075         require(value == 0, "Strings: hex length insufficient");
1076         return string(buffer);
1077     }
1078 }
1079 
1080 
1081 // File: @openzeppelin/contracts/utils/Address.sol
1082 
1083 
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 /**
1088  * @dev Collection of functions related to the address type
1089  */
1090 library Address {
1091     /**
1092      * @dev Returns true if `account` is a contract.
1093      *
1094      * [IMPORTANT]
1095      * ====
1096      * It is unsafe to assume that an address for which this function returns
1097      * false is an externally-owned account (EOA) and not a contract.
1098      *
1099      * Among others, `isContract` will return false for the following
1100      * types of addresses:
1101      *
1102      *  - an externally-owned account
1103      *  - a contract in construction
1104      *  - an address where a contract will be created
1105      *  - an address where a contract lived, but was destroyed
1106      * ====
1107      */
1108     function isContract(address account) internal view returns (bool) {
1109         // This method relies on extcodesize, which returns 0 for contracts in
1110         // construction, since the code is only stored at the end of the
1111         // constructor execution.
1112 
1113         uint256 size;
1114         assembly {
1115             size := extcodesize(account)
1116         }
1117         return size > 0;
1118     }
1119 
1120     /**
1121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1122      * `recipient`, forwarding all available gas and reverting on errors.
1123      *
1124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1126      * imposed by `transfer`, making them unable to receive funds via
1127      * `transfer`. {sendValue} removes this limitation.
1128      *
1129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1130      *
1131      * IMPORTANT: because control is transferred to `recipient`, care must be
1132      * taken to not create reentrancy vulnerabilities. Consider using
1133      * {ReentrancyGuard} or the
1134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1135      */
1136     function sendValue(address payable recipient, uint256 amount) internal {
1137         require(address(this).balance >= amount, "Address: insufficient balance");
1138 
1139         (bool success, ) = recipient.call{value: amount}("");
1140         require(success, "Address: unable to send value, recipient may have reverted");
1141     }
1142 
1143     /**
1144      * @dev Performs a Solidity function call using a low level `call`. A
1145      * plain `call` is an unsafe replacement for a function call: use this
1146      * function instead.
1147      *
1148      * If `target` reverts with a revert reason, it is bubbled up by this
1149      * function (like regular Solidity function calls).
1150      *
1151      * Returns the raw returned data. To convert to the expected return value,
1152      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1153      *
1154      * Requirements:
1155      *
1156      * - `target` must be a contract.
1157      * - calling `target` with `data` must not revert.
1158      *
1159      * _Available since v3.1._
1160      */
1161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1162         return functionCall(target, data, "Address: low-level call failed");
1163     }
1164 
1165     /**
1166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1167      * `errorMessage` as a fallback revert reason when `target` reverts.
1168      *
1169      * _Available since v3.1._
1170      */
1171     function functionCall(
1172         address target,
1173         bytes memory data,
1174         string memory errorMessage
1175     ) internal returns (bytes memory) {
1176         return functionCallWithValue(target, data, 0, errorMessage);
1177     }
1178 
1179     /**
1180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1181      * but also transferring `value` wei to `target`.
1182      *
1183      * Requirements:
1184      *
1185      * - the calling contract must have an ETH balance of at least `value`.
1186      * - the called Solidity function must be `payable`.
1187      *
1188      * _Available since v3.1._
1189      */
1190     function functionCallWithValue(
1191         address target,
1192         bytes memory data,
1193         uint256 value
1194     ) internal returns (bytes memory) {
1195         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1196     }
1197 
1198     /**
1199      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1200      * with `errorMessage` as a fallback revert reason when `target` reverts.
1201      *
1202      * _Available since v3.1._
1203      */
1204     function functionCallWithValue(
1205         address target,
1206         bytes memory data,
1207         uint256 value,
1208         string memory errorMessage
1209     ) internal returns (bytes memory) {
1210         require(address(this).balance >= value, "Address: insufficient balance for call");
1211         require(isContract(target), "Address: call to non-contract");
1212 
1213         (bool success, bytes memory returndata) = target.call{value: value}(data);
1214         return verifyCallResult(success, returndata, errorMessage);
1215     }
1216 
1217     /**
1218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1219      * but performing a static call.
1220      *
1221      * _Available since v3.3._
1222      */
1223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1224         return functionStaticCall(target, data, "Address: low-level static call failed");
1225     }
1226 
1227     /**
1228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1229      * but performing a static call.
1230      *
1231      * _Available since v3.3._
1232      */
1233     function functionStaticCall(
1234         address target,
1235         bytes memory data,
1236         string memory errorMessage
1237     ) internal view returns (bytes memory) {
1238         require(isContract(target), "Address: static call to non-contract");
1239 
1240         (bool success, bytes memory returndata) = target.staticcall(data);
1241         return verifyCallResult(success, returndata, errorMessage);
1242     }
1243 
1244     /**
1245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1246      * but performing a delegate call.
1247      *
1248      * _Available since v3.4._
1249      */
1250     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1251         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1252     }
1253 
1254     /**
1255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1256      * but performing a delegate call.
1257      *
1258      * _Available since v3.4._
1259      */
1260     function functionDelegateCall(
1261         address target,
1262         bytes memory data,
1263         string memory errorMessage
1264     ) internal returns (bytes memory) {
1265         require(isContract(target), "Address: delegate call to non-contract");
1266 
1267         (bool success, bytes memory returndata) = target.delegatecall(data);
1268         return verifyCallResult(success, returndata, errorMessage);
1269     }
1270 
1271     /**
1272      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1273      * revert reason using the provided one.
1274      *
1275      * _Available since v4.3._
1276      */
1277     function verifyCallResult(
1278         bool success,
1279         bytes memory returndata,
1280         string memory errorMessage
1281     ) internal pure returns (bytes memory) {
1282         if (success) {
1283             return returndata;
1284         } else {
1285             // Look for revert reason and bubble it up if present
1286             if (returndata.length > 0) {
1287                 // The easiest way to bubble the revert reason is using memory via assembly
1288 
1289                 assembly {
1290                     let returndata_size := mload(returndata)
1291                     revert(add(32, returndata), returndata_size)
1292                 }
1293             } else {
1294                 revert(errorMessage);
1295             }
1296         }
1297     }
1298 }
1299 
1300 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1301 
1302 
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 /**
1307  * @title ERC721 token receiver interface
1308  * @dev Interface for any contract that wants to support safeTransfers
1309  * from ERC721 asset contracts.
1310  */
1311 interface IERC721Receiver {
1312     /**
1313      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1314      * by `operator` from `from`, this function is called.
1315      *
1316      * It must return its Solidity selector to confirm the token transfer.
1317      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1318      *
1319      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1320      */
1321     function onERC721Received(
1322         address operator,
1323         address from,
1324         uint256 tokenId,
1325         bytes calldata data
1326     ) external returns (bytes4);
1327 }
1328 
1329 
1330 
1331 // File: contracts/skvllpvnkz.sol
1332 
1333 
1334 pragma solidity ^0.8.0;
1335 
1336 
1337 
1338 
1339 contract Skvllpvnkz is ERC721Enumerable, Ownable, ReentrancyGuard {
1340 
1341     using Strings for uint256;
1342     
1343     /* Events */
1344     
1345     event SkvllpvnkzFreeMintStarted();
1346     event SkvllpvnkzFreeMintPaused();
1347     
1348     event SkvllpvnkzPublicSaleStarted();
1349     event SkvllpvnkzPublicSalePaused();
1350     
1351     event SkvllpvnkzPresaleStarted();
1352     event SkvllpvnkzPresalePaused();
1353     
1354     /* Supply Pools
1355     ** These are the total supply amounts for each pool.
1356     ** We have 3 supply pools:
1357     **   1. Reserved giveaway pool for future giveaways
1358     **   2. Reserved early free mint pool for previous collection owners
1359     **   3. Public presale and open sale pool available to everyone */ 
1360     uint256 private _maxSupply = 10000;
1361     uint256 private _rsrvdGiveawaySupply = 100;
1362     uint256 private _rsrvdEarlySupply = 356;
1363     uint256 private _unrsrvdSupply = _maxSupply - _rsrvdGiveawaySupply - _rsrvdEarlySupply;
1364     
1365     /* Token IDs
1366     ** Token ID ranges are reserved for the 3 different pools.
1367     ** _rsrvdGiveawayTID -> _rsrvdEarlyTID -> _tokenId */
1368     uint256 private _rsrvdGiveawayTID = 0; // This is the starting ID
1369     uint256 private _rsrvdEarlyTID = _rsrvdGiveawaySupply;
1370     uint256 private _tokenId = _rsrvdGiveawaySupply + _rsrvdEarlySupply;
1371     
1372     // The base URI for the token
1373     string _baseTokenURI;
1374     // The maximum mint batch size per transaction for the public sale
1375     uint256 private _maxBatch = 10;
1376     // The maximum mint batch size per transaction for the presale
1377     uint256 private _maxBatchPresale = 2;
1378     // The price per mint
1379     uint256 private _price = 0.05 ether;
1380     
1381     // Flag to start / pause public sale
1382     bool public _publicSale = false;
1383     // Flag to start / pause presale
1384     bool public _presale = false;
1385     // Flag to start / pause presale
1386     bool public _ownerSale = false;
1387     
1388     bool private _provenanceSet = false;
1389     
1390     string private _contractURI = "http://api.skvllpvnkz.io/contract";
1391     
1392     uint256 private _walletLimit = 200;
1393     
1394     string public provenance = "";
1395     
1396     /* Whitelists
1397     ** We have 2 separte whitelists:
1398     **   2. Presale whitelist for Outcasts */
1399     mapping(address => uint256) private _presaleList;
1400     mapping(address => uint256) private _freeList;
1401 
1402     // Withdraw addresses
1403     address t1 = 0xAD5e57aCB70635671d6FEa67b08FB56f3eff596e;
1404     address t2 = 0xE3f33298381C7694cf5e999B36fD513a0Ddec8ba;
1405     address t3 = 0x58723Ef34C6F1197c30B35fC763365508d24b448;
1406     address t4 = 0x46F231aD0279dA2d249D690Ab1e92F1B1f1F0158;
1407     address t5 = 0xcdA2E4b965eCa883415107b624e971c4Cefc4D8C;
1408     
1409     modifier notContract {
1410       require( !_isContract( msg.sender ), "Cannot call this from a contract " );
1411       _;
1412     }
1413 
1414     constructor() ERC721("Skvllpvnkz Hideout", "SKVLLZ") {}
1415     
1416     /* Presale Mint
1417     ** Presale minting is available before the public sale to users
1418     ** on the presale whitelist. Wallets on the whitelist will be allowed 
1419     ** to mint a maximum of 2 avatars */
1420     function presaleRecruit(uint256 num) external payable nonReentrant notContract{
1421         require( _presale, "Presale paused" );
1422         require( _presaleList[msg.sender] > 0, "Not on the whitelist");
1423         require( num <= _maxBatchPresale, "Exceeds the maximum amount" );
1424         require( _presaleList[msg.sender] >= num, 'Purchase exceeds max allowed');
1425         require( num <= remainingSupply(), "Exceeds reserved supply" );
1426         require( msg.value >= _price * num, "Ether sent is not correct" );
1427         
1428         _presaleList[msg.sender] -= num;
1429         
1430         for(uint256 i; i < num; i++){
1431             _tokenId ++;
1432             _safeMint( msg.sender,  _tokenId );
1433         }
1434     }
1435 
1436     /* Standard Mint
1437     ** This is the standard mint function allowing a user to mint a 
1438     ** maximum of 10 avatars. It mints the tokens from a pool of IDs
1439     ** starting after the initial reserved token pools */
1440     function recruit(uint256 num) external payable nonReentrant notContract {
1441         require( !_isContract( msg.sender ), "Cannot call this from a contract " );
1442         require( _publicSale, "Sale paused" );
1443         require( num <= _maxBatch, "Max 10 per TX" );
1444         require( num <= remainingSupply(), "Exceeds maximum supply" );
1445         require( balanceOf(msg.sender) + num <= _walletLimit, "Exceeds wallet limit");
1446         require( msg.value >= _price * num, "Incorrect Ether sent" );
1447         for( uint256 i; i < num; i++ ){
1448             if (_tokenId <= _maxSupply) {
1449                 _tokenId ++;
1450                 _safeMint( msg.sender,  _tokenId );
1451             }
1452         }
1453     }
1454     
1455     /* Giveaway Mint
1456     ** This is the standard mint function allowing a user to mint a 
1457     ** maximum of 20 avatars. It mints the tokens from a pool of IDs
1458     ** starting after the initial reserved token pools */
1459     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1460         require( _amount <= remainingGiveaways(), "Exceeds reserved supply" );
1461         for(uint256 i; i < _amount; i++){
1462             _rsrvdGiveawayTID ++;
1463             _safeMint( _to, _rsrvdGiveawayTID);
1464         }
1465     }
1466     
1467     function freeRecruit() external payable nonReentrant notContract {
1468         require( _ownerSale, "Free mint is not on" );
1469         require( _freeList[msg.sender] > 0, "Not on the whitelist");
1470         require( _freeList[msg.sender] <= remainingEarlySupply(), "Exceeds reserved supply" );
1471         
1472         uint256 mintCnt = _freeList[msg.sender];
1473         _freeList[msg.sender] = 0;
1474         
1475         for( uint256 i; i < mintCnt; i++ ){
1476             _rsrvdEarlyTID ++;
1477             _safeMint( msg.sender, _rsrvdEarlyTID );
1478         }
1479     }
1480     
1481     function _isContract(address _addr) internal view returns (bool) {
1482 		uint32 _size;
1483 		assembly {
1484 			_size:= extcodesize(_addr)
1485 		}
1486 		return (_size > 0);
1487 	}
1488     
1489     /* Remove wallet from the free mint whitelist */
1490     function removeFromFreeList(address _address) external onlyOwner {
1491         _freeList[_address] = 0;
1492     }
1493     
1494     /* Add wallet to the presale whitelist */
1495     function addToFreeList(address[] calldata addresses, uint256[] calldata count) external onlyOwner{
1496         for (uint256 i = 0; i < addresses.length; i++) {
1497           _freeList[addresses[i]] = count[i];
1498         }
1499     }
1500     
1501     /* Add wallet to the presale whitelist */
1502     function addToPresaleList(address[] calldata addresses) external onlyOwner{
1503         for (uint256 i = 0; i < addresses.length; i++) {
1504           require(addresses[i] != address(0), "Can't add a null address");
1505           _presaleList[addresses[i]] = _maxBatchPresale;
1506         }
1507     }
1508     
1509     /* Remove wallet from the presale whitelist */
1510     function removeFromPresaleList(address[] calldata addresses) external onlyOwner {
1511         for (uint256 i = 0; i < addresses.length; i++) {
1512           require(addresses[i] != address(0), "Can't remove a null address");
1513           _presaleList[addresses[i]] = 0;
1514         }
1515     }
1516     
1517     function onPresaleList(address addr) external view returns (uint256) {
1518         return _presaleList[addr];
1519     }
1520     
1521     function onFreeList(address addr) external view returns (uint256) {
1522         return _freeList[addr];
1523     }
1524 
1525     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1526         uint256 tokenCount = balanceOf(_owner);
1527         uint256[] memory tokensId = new uint256[](tokenCount);
1528         for(uint256 i; i < tokenCount; i++){
1529             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1530         }
1531         return tokensId;
1532     }
1533     
1534     function publicSale(bool val) external onlyOwner {
1535         _publicSale = val;
1536         if (val) {
1537             _presale = false;
1538             emit SkvllpvnkzPublicSaleStarted();
1539             emit SkvllpvnkzPresalePaused();
1540         } else {
1541             emit SkvllpvnkzPublicSalePaused();
1542         }
1543     }
1544     
1545     function freeMint(bool val) external onlyOwner {
1546         _ownerSale = val;
1547         if (val) {
1548             emit SkvllpvnkzFreeMintStarted();
1549         } else {
1550             emit SkvllpvnkzFreeMintPaused();
1551         }
1552     }
1553     
1554     function presale(bool val) external onlyOwner {
1555         require(!_publicSale, "Can't have a presale during the public sale");
1556         _presale = val;
1557         if (val) {
1558             emit SkvllpvnkzPresaleStarted();
1559         } else {
1560             emit SkvllpvnkzPresalePaused();
1561         }
1562     }
1563 
1564     function setPrice(uint256 _newPrice) external onlyOwner() {
1565         _price = _newPrice;
1566     }
1567 
1568     function _baseURI() internal view virtual override returns (string memory) {
1569         return _baseTokenURI;
1570     }
1571 
1572     function setBaseURI(string memory baseURI) external onlyOwner {
1573         _baseTokenURI = baseURI;
1574     }
1575     
1576     function setMaxBatch(uint256 maxBatch) external onlyOwner {
1577         _maxBatch = maxBatch;
1578     }
1579     
1580     function getMaxBatch() external view returns (uint256) {
1581         return _maxBatch;
1582     }
1583     
1584     function getPrice() external view returns (uint256){
1585         return _price;
1586     }
1587     
1588     function remainingTotalSupply() external view returns (uint256){
1589         return _maxSupply - totalSupply();
1590     }
1591     
1592     function remainingSupply() public view returns (uint256) {
1593         return _unrsrvdSupply + _rsrvdEarlySupply + _rsrvdGiveawaySupply - _tokenId;
1594     }
1595     
1596     function remainingGiveaways() public view returns (uint256){
1597         return _rsrvdGiveawaySupply - _rsrvdGiveawayTID;
1598     }
1599     
1600     function remainingEarlySupply() public view returns (uint256){
1601         return _rsrvdEarlySupply + _rsrvdGiveawaySupply - _rsrvdEarlyTID;
1602     }
1603     
1604     function maxSupply() external view returns (uint256){
1605         return _maxSupply;
1606     }
1607 
1608     function withdraw(uint256 amount) external payable onlyOwner {
1609         require(payable(msg.sender).send(amount));
1610     }
1611 
1612     function withdrawAll() external payable onlyOwner {
1613         uint256 _each = address(this).balance / 100;
1614         require(payable(t1).send( _each * 31 )); // TM1
1615         require(payable(t2).send( _each * 21 )); // TM2
1616         require(payable(t3).send( _each * 21 )); // TM3
1617         require(payable(t4).send( _each * 21 )); // TM4
1618         require(payable(t5).send( _each * 6 )); // Comm
1619     }
1620     
1621     function setWalletLimit(uint256 limit) external onlyOwner {
1622         _walletLimit = limit;
1623     }
1624     
1625     function setContractURI(string memory uri) external onlyOwner {
1626         _contractURI = uri;
1627     }
1628     
1629     function contractURI() external view returns (string memory) {
1630         return _contractURI;
1631     }
1632     
1633     function setProvenance(string memory _provenance) external onlyOwner {
1634         require(!_provenanceSet, "Provenance has been set already");
1635         provenance = _provenance;
1636         _provenanceSet = true;
1637     }
1638 }