1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _transferOwnership(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Internal function without access restriction.
86      */
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC165 standard, as defined in the
96  * https://eips.ethereum.org/EIPS/eip-165[EIP].
97  *
98  * Implementers can declare support of contract interfaces, which can then be
99  * queried by others ({ERC165Checker}).
100  *
101  * For an implementation, see {ERC165}.
102  */
103 interface IERC165 {
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 /**
116  * @dev Implementation of the {IERC165} interface.
117  *
118  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
119  * for the additional interface id that will be supported. For example:
120  *
121  * ```solidity
122  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
123  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
124  * }
125  * ```
126  *
127  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
128  */
129 abstract contract ERC165 is IERC165 {
130     /**
131      * @dev See {IERC165-supportsInterface}.
132      */
133     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
134         return interfaceId == type(IERC165).interfaceId;
135     }
136 }
137 
138 /**
139  * @dev Required interface of an ERC721 compliant contract.
140  */
141 interface IERC721 is IERC165 {
142     /**
143      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
149      */
150     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
151 
152     /**
153      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
154      */
155     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
156 
157     /**
158      * @dev Returns the number of tokens in ``owner``'s account.
159      */
160     function balanceOf(address owner) external view returns (uint256 balance);
161 
162     /**
163      * @dev Returns the owner of the `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function ownerOf(uint256 tokenId) external view returns (address owner);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
173      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` token from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Returns the account approved for `tokenId` token.
228      *
229      * Requirements:
230      *
231      * - `tokenId` must exist.
232      */
233     function getApproved(uint256 tokenId) external view returns (address operator);
234 
235     /**
236      * @dev Approve or remove `operator` as an operator for the caller.
237      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
238      *
239      * Requirements:
240      *
241      * - The `operator` cannot be the caller.
242      *
243      * Emits an {ApprovalForAll} event.
244      */
245     function setApprovalForAll(address operator, bool _approved) external;
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     /**
255      * @dev Safely transfers `tokenId` token from `from` to `to`.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId,
271         bytes calldata data
272     ) external;
273 }
274 
275 /**
276  * @title ERC721 token receiver interface
277  * @dev Interface for any contract that wants to support safeTransfers
278  * from ERC721 asset contracts.
279  */
280 interface IERC721Receiver {
281     /**
282      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
283      * by `operator` from `from`, this function is called.
284      *
285      * It must return its Solidity selector to confirm the token transfer.
286      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
287      *
288      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
289      */
290     function onERC721Received(
291         address operator,
292         address from,
293         uint256 tokenId,
294         bytes calldata data
295     ) external returns (bytes4);
296 }
297 
298 /**
299  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
300  * @dev See https://eips.ethereum.org/EIPS/eip-721
301  */
302 interface IERC721Metadata is IERC721 {
303     /**
304      * @dev Returns the token collection name.
305      */
306     function name() external view returns (string memory);
307 
308     /**
309      * @dev Returns the token collection symbol.
310      */
311     function symbol() external view returns (string memory);
312 
313     /**
314      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
315      */
316     function tokenURI(uint256 tokenId) external view returns (string memory);
317 }
318 
319 /**
320  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
321  * the Metadata extension, but not including the Enumerable extension, which is available separately as
322  * {ERC721Enumerable}.
323  */
324 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
325     using Address for address;
326     using Strings for uint256;
327 
328     // Token name
329     string private _name;
330 
331     // Token symbol
332     string private _symbol;
333 
334     // Mapping from token ID to owner address
335     mapping(uint256 => address) private _owners;
336 
337     // Mapping owner address to token count
338     mapping(address => uint256) private _balances;
339 
340     // Mapping from token ID to approved address
341     mapping(uint256 => address) private _tokenApprovals;
342 
343     // Mapping from owner to operator approvals
344     mapping(address => mapping(address => bool)) private _operatorApprovals;
345 
346     /**
347      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
348      */
349     constructor(string memory name_, string memory symbol_) {
350         _name = name_;
351         _symbol = symbol_;
352     }
353 
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
358         return
359         interfaceId == type(IERC721).interfaceId ||
360         interfaceId == type(IERC721Metadata).interfaceId ||
361         super.supportsInterface(interfaceId);
362     }
363 
364     /**
365      * @dev See {IERC721-balanceOf}.
366      */
367     function balanceOf(address owner) public view virtual override returns (uint256) {
368         require(owner != address(0), "ERC721: balance query for the zero address");
369         return _balances[owner];
370     }
371 
372     /**
373      * @dev See {IERC721-ownerOf}.
374      */
375     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
376         address owner = _owners[tokenId];
377         require(owner != address(0), "ERC721: owner query for nonexistent token");
378         return owner;
379     }
380 
381     /**
382      * @dev See {IERC721Metadata-name}.
383      */
384     function name() public view virtual override returns (string memory) {
385         return _name;
386     }
387 
388     /**
389      * @dev See {IERC721Metadata-symbol}.
390      */
391     function symbol() public view virtual override returns (string memory) {
392         return _symbol;
393     }
394 
395     /**
396      * @dev See {IERC721Metadata-tokenURI}.
397      */
398     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
399         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
400 
401         string memory baseURI = _baseURI();
402         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
403     }
404 
405     /**
406      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
407      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
408      * by default, can be overriden in child contracts.
409      */
410     function _baseURI() internal view virtual returns (string memory) {
411         return "";
412     }
413 
414     /**
415      * @dev See {IERC721-approve}.
416      */
417     function approve(address to, uint256 tokenId) public virtual override {
418         address owner = ERC721.ownerOf(tokenId);
419         require(to != owner, "ERC721: approval to current owner");
420 
421         require(
422             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
423             "ERC721: approve caller is not owner nor approved for all"
424         );
425 
426         _approve(to, tokenId);
427     }
428 
429     /**
430      * @dev See {IERC721-getApproved}.
431      */
432     function getApproved(uint256 tokenId) public view virtual override returns (address) {
433         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
434 
435         return _tokenApprovals[tokenId];
436     }
437 
438     /**
439      * @dev See {IERC721-setApprovalForAll}.
440      */
441     function setApprovalForAll(address operator, bool approved) public virtual override {
442         _setApprovalForAll(_msgSender(), operator, approved);
443     }
444 
445     /**
446      * @dev See {IERC721-isApprovedForAll}.
447      */
448     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
449         return _operatorApprovals[owner][operator];
450     }
451 
452     /**
453      * @dev See {IERC721-transferFrom}.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) public virtual override {
460         //solhint-disable-next-line max-line-length
461         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
462 
463         _transfer(from, to, tokenId);
464     }
465 
466     /**
467      * @dev See {IERC721-safeTransferFrom}.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) public virtual override {
474         safeTransferFrom(from, to, tokenId, "");
475     }
476 
477     /**
478      * @dev See {IERC721-safeTransferFrom}.
479      */
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId,
484         bytes memory _data
485     ) public virtual override {
486         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
487         _safeTransfer(from, to, tokenId, _data);
488     }
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
492      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
493      *
494      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
495      *
496      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
497      * implement alternative mechanisms to perform token transfer, such as signature-based.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
505      *
506      * Emits a {Transfer} event.
507      */
508     function _safeTransfer(
509         address from,
510         address to,
511         uint256 tokenId,
512         bytes memory _data
513     ) internal virtual {
514         _transfer(from, to, tokenId);
515         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
516     }
517 
518     /**
519      * @dev Returns whether `tokenId` exists.
520      *
521      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
522      *
523      * Tokens start existing when they are minted (`_mint`),
524      * and stop existing when they are burned (`_burn`).
525      */
526     function _exists(uint256 tokenId) internal view virtual returns (bool) {
527         return _owners[tokenId] != address(0);
528     }
529 
530     /**
531      * @dev Returns whether `spender` is allowed to manage `tokenId`.
532      *
533      * Requirements:
534      *
535      * - `tokenId` must exist.
536      */
537     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
538         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
539         address owner = ERC721.ownerOf(tokenId);
540         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
541     }
542 
543     /**
544      * @dev Safely mints `tokenId` and transfers it to `to`.
545      *
546      * Requirements:
547      *
548      * - `tokenId` must not exist.
549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550      *
551      * Emits a {Transfer} event.
552      */
553     function _safeMint(address to, uint256 tokenId) internal virtual {
554         _safeMint(to, tokenId, "");
555     }
556 
557     /**
558      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
559      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
560      */
561     function _safeMint(
562         address to,
563         uint256 tokenId,
564         bytes memory _data
565     ) internal virtual {
566         _mint(to, tokenId);
567         require(
568             _checkOnERC721Received(address(0), to, tokenId, _data),
569             "ERC721: transfer to non ERC721Receiver implementer"
570         );
571     }
572 
573     /**
574      * @dev Mints `tokenId` and transfers it to `to`.
575      *
576      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
577      *
578      * Requirements:
579      *
580      * - `tokenId` must not exist.
581      * - `to` cannot be the zero address.
582      *
583      * Emits a {Transfer} event.
584      */
585     function _mint(address to, uint256 tokenId) internal virtual {
586         require(to != address(0), "ERC721: mint to the zero address");
587         require(!_exists(tokenId), "ERC721: token already minted");
588 
589         _beforeTokenTransfer(address(0), to, tokenId);
590 
591         _balances[to] += 1;
592         _owners[tokenId] = to;
593 
594         emit Transfer(address(0), to, tokenId);
595     }
596 
597     /**
598      * @dev Destroys `tokenId`.
599      * The approval is cleared when the token is burned.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      *
605      * Emits a {Transfer} event.
606      */
607     function _burn(uint256 tokenId) internal virtual {
608         address owner = ERC721.ownerOf(tokenId);
609 
610         _beforeTokenTransfer(owner, address(0), tokenId);
611 
612         // Clear approvals
613         _approve(address(0), tokenId);
614 
615         _balances[owner] -= 1;
616         delete _owners[tokenId];
617 
618         emit Transfer(owner, address(0), tokenId);
619     }
620 
621     /**
622      * @dev Transfers `tokenId` from `from` to `to`.
623      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
624      *
625      * Requirements:
626      *
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must be owned by `from`.
629      *
630      * Emits a {Transfer} event.
631      */
632     function _transfer(
633         address from,
634         address to,
635         uint256 tokenId
636     ) internal virtual {
637         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
638         require(to != address(0), "ERC721: transfer to the zero address");
639 
640         _beforeTokenTransfer(from, to, tokenId);
641 
642         // Clear approvals from the previous owner
643         _approve(address(0), tokenId);
644 
645         _balances[from] -= 1;
646         _balances[to] += 1;
647         _owners[tokenId] = to;
648 
649         emit Transfer(from, to, tokenId);
650     }
651 
652     /**
653      * @dev Approve `to` to operate on `tokenId`
654      *
655      * Emits a {Approval} event.
656      */
657     function _approve(address to, uint256 tokenId) internal virtual {
658         _tokenApprovals[tokenId] = to;
659         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
660     }
661 
662     /**
663      * @dev Approve `operator` to operate on all of `owner` tokens
664      *
665      * Emits a {ApprovalForAll} event.
666      */
667     function _setApprovalForAll(
668         address owner,
669         address operator,
670         bool approved
671     ) internal virtual {
672         require(owner != operator, "ERC721: approve to caller");
673         _operatorApprovals[owner][operator] = approved;
674         emit ApprovalForAll(owner, operator, approved);
675     }
676 
677     /**
678      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
679      * The call is not executed if the target address is not a contract.
680      *
681      * @param from address representing the previous owner of the given token ID
682      * @param to target address that will receive the tokens
683      * @param tokenId uint256 ID of the token to be transferred
684      * @param _data bytes optional data to send along with the call
685      * @return bool whether the call correctly returned the expected magic value
686      */
687     function _checkOnERC721Received(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes memory _data
692     ) private returns (bool) {
693         if (to.isContract()) {
694             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
695                 return retval == IERC721Receiver.onERC721Received.selector;
696             } catch (bytes memory reason) {
697                 if (reason.length == 0) {
698                     revert("ERC721: transfer to non ERC721Receiver implementer");
699                 } else {
700                     assembly {
701                         revert(add(32, reason), mload(reason))
702                     }
703                 }
704             }
705         } else {
706             return true;
707         }
708     }
709 
710     /**
711      * @dev Hook that is called before any token transfer. This includes minting
712      * and burning.
713      *
714      * Calling conditions:
715      *
716      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
717      * transferred to `to`.
718      * - When `from` is zero, `tokenId` will be minted for `to`.
719      * - When `to` is zero, ``from``'s `tokenId` will be burned.
720      * - `from` and `to` are never both zero.
721      *
722      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
723      */
724     function _beforeTokenTransfer(
725         address from,
726         address to,
727         uint256 tokenId
728     ) internal virtual {}
729 }
730 
731 /**
732  * @dev Collection of functions related to the address type
733  */
734 library Address {
735     /**
736      * @dev Returns true if `account` is a contract.
737      *
738      * [IMPORTANT]
739      * ====
740      * It is unsafe to assume that an address for which this function returns
741      * false is an externally-owned account (EOA) and not a contract.
742      *
743      * Among others, `isContract` will return false for the following
744      * types of addresses:
745      *
746      *  - an externally-owned account
747      *  - a contract in construction
748      *  - an address where a contract will be created
749      *  - an address where a contract lived, but was destroyed
750      * ====
751      */
752     function isContract(address account) internal view returns (bool) {
753         // This method relies on extcodesize, which returns 0 for contracts in
754         // construction, since the code is only stored at the end of the
755         // constructor execution.
756 
757         uint256 size;
758         assembly {
759             size := extcodesize(account)
760         }
761         return size > 0;
762     }
763 
764     /**
765      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
766      * `recipient`, forwarding all available gas and reverting on errors.
767      *
768      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
769      * of certain opcodes, possibly making contracts go over the 2300 gas limit
770      * imposed by `transfer`, making them unable to receive funds via
771      * `transfer`. {sendValue} removes this limitation.
772      *
773      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
774      *
775      * IMPORTANT: because control is transferred to `recipient`, care must be
776      * taken to not create reentrancy vulnerabilities. Consider using
777      * {ReentrancyGuard} or the
778      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
779      */
780     function sendValue(address payable recipient, uint256 amount) internal {
781         require(address(this).balance >= amount, "Address: insufficient balance");
782 
783         (bool success, ) = recipient.call{value: amount}("");
784         require(success, "Address: unable to send value, recipient may have reverted");
785     }
786 
787     /**
788      * @dev Performs a Solidity function call using a low level `call`. A
789      * plain `call` is an unsafe replacement for a function call: use this
790      * function instead.
791      *
792      * If `target` reverts with a revert reason, it is bubbled up by this
793      * function (like regular Solidity function calls).
794      *
795      * Returns the raw returned data. To convert to the expected return value,
796      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
797      *
798      * Requirements:
799      *
800      * - `target` must be a contract.
801      * - calling `target` with `data` must not revert.
802      *
803      * _Available since v3.1._
804      */
805     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
806         return functionCall(target, data, "Address: low-level call failed");
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
811      * `errorMessage` as a fallback revert reason when `target` reverts.
812      *
813      * _Available since v3.1._
814      */
815     function functionCall(
816         address target,
817         bytes memory data,
818         string memory errorMessage
819     ) internal returns (bytes memory) {
820         return functionCallWithValue(target, data, 0, errorMessage);
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
825      * but also transferring `value` wei to `target`.
826      *
827      * Requirements:
828      *
829      * - the calling contract must have an ETH balance of at least `value`.
830      * - the called Solidity function must be `payable`.
831      *
832      * _Available since v3.1._
833      */
834     function functionCallWithValue(
835         address target,
836         bytes memory data,
837         uint256 value
838     ) internal returns (bytes memory) {
839         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
844      * with `errorMessage` as a fallback revert reason when `target` reverts.
845      *
846      * _Available since v3.1._
847      */
848     function functionCallWithValue(
849         address target,
850         bytes memory data,
851         uint256 value,
852         string memory errorMessage
853     ) internal returns (bytes memory) {
854         require(address(this).balance >= value, "Address: insufficient balance for call");
855         require(isContract(target), "Address: call to non-contract");
856 
857         (bool success, bytes memory returndata) = target.call{value: value}(data);
858         return verifyCallResult(success, returndata, errorMessage);
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
863      * but performing a static call.
864      *
865      * _Available since v3.3._
866      */
867     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
868         return functionStaticCall(target, data, "Address: low-level static call failed");
869     }
870 
871     /**
872      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
873      * but performing a static call.
874      *
875      * _Available since v3.3._
876      */
877     function functionStaticCall(
878         address target,
879         bytes memory data,
880         string memory errorMessage
881     ) internal view returns (bytes memory) {
882         require(isContract(target), "Address: static call to non-contract");
883 
884         (bool success, bytes memory returndata) = target.staticcall(data);
885         return verifyCallResult(success, returndata, errorMessage);
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
890      * but performing a delegate call.
891      *
892      * _Available since v3.4._
893      */
894     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
895         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
896     }
897 
898     /**
899      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
900      * but performing a delegate call.
901      *
902      * _Available since v3.4._
903      */
904     function functionDelegateCall(
905         address target,
906         bytes memory data,
907         string memory errorMessage
908     ) internal returns (bytes memory) {
909         require(isContract(target), "Address: delegate call to non-contract");
910 
911         (bool success, bytes memory returndata) = target.delegatecall(data);
912         return verifyCallResult(success, returndata, errorMessage);
913     }
914 
915     /**
916      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
917      * revert reason using the provided one.
918      *
919      * _Available since v4.3._
920      */
921     function verifyCallResult(
922         bool success,
923         bytes memory returndata,
924         string memory errorMessage
925     ) internal pure returns (bytes memory) {
926         if (success) {
927             return returndata;
928         } else {
929             // Look for revert reason and bubble it up if present
930             if (returndata.length > 0) {
931                 // The easiest way to bubble the revert reason is using memory via assembly
932 
933                 assembly {
934                     let returndata_size := mload(returndata)
935                     revert(add(32, returndata), returndata_size)
936                 }
937             } else {
938                 revert(errorMessage);
939             }
940         }
941     }
942 }
943 
944 /**
945  * @dev String operations.
946  */
947 library Strings {
948     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
949 
950     /**
951      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
952      */
953     function toString(uint256 value) internal pure returns (string memory) {
954         // Inspired by OraclizeAPI's implementation - MIT licence
955         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
956 
957         if (value == 0) {
958             return "0";
959         }
960         uint256 temp = value;
961         uint256 digits;
962         while (temp != 0) {
963             digits++;
964             temp /= 10;
965         }
966         bytes memory buffer = new bytes(digits);
967         while (value != 0) {
968             digits -= 1;
969             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
970             value /= 10;
971         }
972         return string(buffer);
973     }
974 
975     /**
976      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
977      */
978     function toHexString(uint256 value) internal pure returns (string memory) {
979         if (value == 0) {
980             return "0x00";
981         }
982         uint256 temp = value;
983         uint256 length = 0;
984         while (temp != 0) {
985             length++;
986             temp >>= 8;
987         }
988         return toHexString(value, length);
989     }
990 
991     /**
992      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
993      */
994     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
995         bytes memory buffer = new bytes(2 * length + 2);
996         buffer[0] = "0";
997         buffer[1] = "x";
998         for (uint256 i = 2 * length + 1; i > 1; --i) {
999             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1000             value >>= 4;
1001         }
1002         require(value == 0, "Strings: hex length insufficient");
1003         return string(buffer);
1004     }
1005 }
1006 
1007 contract ValhallaVacationClub is ERC721, Ownable {
1008     using Address for address;
1009 
1010     // some call it 'provenance'
1011     string public PROOF_OF_ANCESTRY;
1012 
1013     // eth://valhallavacayclub.com/look-at-me
1014     string public baseURI;
1015 
1016     // 9s EVERYWHERE
1017     uint256 public constant MAX_VIKINGS = 9999;
1018     uint256 public constant MAX_PRESALE = 750;
1019     uint256 public constant MAX_LUCKY_VIKINGS = 69;
1020     uint256 public constant FOR_THE_VAULT = 149;
1021 
1022     uint256 public constant PRICE = 0.065 ether;
1023     uint256 public constant PRESALE_PRICE = 0.04 ether;
1024 
1025     uint256 public luckySupply;
1026     uint256 public presaleSupply;
1027     uint256 public totalSupply;
1028 
1029     // Stay on your toes.
1030     bool public luckyActive = false;
1031     bool public presaleActive = false;
1032     bool public saleActive = false;
1033 
1034     // We need
1035     bool public vikingsBroughtHome = false;
1036 
1037     // Vault address
1038     address vaultAddress = 0xc7C15A3DC9A053D852de73651913532B0Ab5FD0B;
1039 
1040     // Store all the lucky mints to prevent duplicates
1041     mapping (address => bool) public claimedLuckers;
1042 
1043     // there is a lot to unpack here
1044     constructor() ERC721("Valhalla Vacation Club", "VVC") {}
1045 
1046     // Reserve some Vikings for the Team!
1047     function reserveVikings() public onlyOwner {
1048         require(bytes(PROOF_OF_ANCESTRY).length > 0,                "No distributing Vikings until provenance is established.");
1049         require(!vikingsBroughtHome,                                "Only once, even for you Odin");
1050         require(totalSupply + FOR_THE_VAULT <= MAX_VIKINGS,         "You have missed your chance, Fishlord.");
1051 
1052         for (uint256 i = 0; i < FOR_THE_VAULT; i++) {
1053             _safeMint(vaultAddress, totalSupply + i);
1054         }
1055 
1056         totalSupply += FOR_THE_VAULT;
1057         presaleSupply += FOR_THE_VAULT;
1058 
1059         vikingsBroughtHome = true;
1060     }
1061 
1062     // A freebie for you - Lucky you!
1063     function luckyViking() public {
1064         require(luckyActive,                                            "A sale period must be active to claim");
1065         require(!claimedLuckers[msg.sender],                            "You have already claimed your Lucky Viking.");
1066         require(totalSupply + 1 <= MAX_VIKINGS,                         "Sorry, you're too late! All vikings have been claimed.");
1067         require(luckySupply + 1 <= MAX_LUCKY_VIKINGS,                   "Sorry, you're too late! All Lucky Vikings have been claimed.");
1068 
1069         _safeMint( msg.sender, totalSupply);
1070         totalSupply += 1;
1071         luckySupply += 1;
1072         presaleSupply += 1;
1073 
1074         claimedLuckers[msg.sender] = true;
1075     }
1076 
1077     // Lets raid together, earlier than the others!!!!!!!!! LFG
1078     function mintPresale(uint256 numberOfMints) public payable {
1079         require(presaleActive,                                      "Presale must be active to mint");
1080         require(totalSupply + numberOfMints <= MAX_VIKINGS,         "Purchase would exceed max supply of tokens");
1081         require(presaleSupply + numberOfMints <= MAX_PRESALE,       "We have to save some Vikings for the public sale - Presale: SOLD OUT!");
1082         require(PRESALE_PRICE * numberOfMints == msg.value,         "Ether value sent is not correct");
1083 
1084         for(uint256 i; i < numberOfMints; i++){
1085             _safeMint( msg.sender, totalSupply + i );
1086         }
1087 
1088         totalSupply += numberOfMints;
1089         presaleSupply += numberOfMints;
1090     }
1091 
1092     // ..and now for the rest of you
1093     function mint(uint256 numberOfMints) public payable {
1094         require(saleActive,                                         "Sale must be active to mint");
1095         require(numberOfMints > 0 && numberOfMints < 6,             "Invalid purchase amount");
1096         require(totalSupply + numberOfMints <= MAX_VIKINGS,         "Purchase would exceed max supply of tokens");
1097         require(PRICE * numberOfMints == msg.value,                 "Ether value sent is not correct");
1098 
1099         for(uint256 i; i < numberOfMints; i++) {
1100             _safeMint(msg.sender, totalSupply + i);
1101         }
1102 
1103         totalSupply += numberOfMints;
1104     }
1105 
1106     // The Lizards made us do it!
1107     function setAncestry(string memory provenance) public onlyOwner {
1108         require(bytes(PROOF_OF_ANCESTRY).length == 0, "Now now, Loki, do not go and try to play god...twice.");
1109 
1110         PROOF_OF_ANCESTRY = provenance;
1111     }
1112 
1113     function toggleLuckers() public onlyOwner {
1114         require(bytes(PROOF_OF_ANCESTRY).length > 0, "No distributing Vikings until provenance is established.");
1115 
1116         luckyActive = !luckyActive;
1117         presaleActive = false;
1118     }
1119 
1120     //and a flip of the (small) switch
1121     function togglePresale() public onlyOwner {
1122         require(bytes(PROOF_OF_ANCESTRY).length > 0, "No distributing Vikings until provenance is established.");
1123 
1124         luckyActive = false;
1125         presaleActive = !presaleActive;
1126     }
1127 
1128     // LETS GO RAIDING!!! #VVCGANG
1129     function toggleSale() public onlyOwner {
1130         require(bytes(PROOF_OF_ANCESTRY).length > 0, "No distributing Vikings until provenance is established.");
1131 
1132         luckyActive = false;
1133         presaleActive = false;
1134         saleActive = !saleActive;
1135     }
1136 
1137     // For the grand reveal and where things are now.. where things will forever be.. gods willing
1138     function setBaseURI(string memory uri) public onlyOwner {
1139         baseURI = uri;
1140     }
1141 
1142     // Look at those god damn :horny: Vikings
1143     function _baseURI() internal view override returns (string memory) {
1144         return baseURI;
1145     }
1146 
1147     // We don't want to have all the money stuck in the contract, right?
1148     function withdraw() public onlyOwner {
1149         uint balance = address(this).balance;
1150         payable(msg.sender).transfer(balance);
1151     }
1152 }