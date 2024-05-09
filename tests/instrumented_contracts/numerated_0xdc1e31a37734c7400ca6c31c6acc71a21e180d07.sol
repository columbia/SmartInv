1 // SPDX-License-Identifier: MIT
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
26 
27 
28 
29 pragma solidity ^0.8.0;
30 
31 
32 /**
33  * @dev Implementation of the {IERC165} interface.
34  *
35  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
36  * for the additional interface id that will be supported. For example:
37  *
38  * ```solidity
39  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
40  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
41  * }
42  * ```
43  *
44  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
45  */
46 abstract contract ERC165 is IERC165 {
47     /**
48      * @dev See {IERC165-supportsInterface}.
49      */
50     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
51         return interfaceId == type(IERC165).interfaceId;
52     }
53 }
54 
55 
56 
57 pragma solidity ^0.8.0;
58 
59 /**
60  * @title ERC721 token receiver interface
61  * @dev Interface for any contract that wants to support safeTransfers
62  * from ERC721 asset contracts.
63  */
64 interface IERC721Receiver {
65     /**
66      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
67      * by `operator` from `from`, this function is called.
68      *
69      * It must return its Solidity selector to confirm the token transfer.
70      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
71      *
72      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
73      */
74     function onERC721Received(
75         address operator,
76         address from,
77         uint256 tokenId,
78         bytes calldata data
79     ) external returns (bytes4);
80 }
81 
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Required interface of an ERC721 compliant contract.
90  */
91 interface IERC721 is IERC165 {
92     /**
93      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
96 
97     /**
98      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
99      */
100     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
101 
102     /**
103      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
104      */
105     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
106 
107     /**
108      * @dev Returns the number of tokens in ``owner``'s account.
109      */
110     function balanceOf(address owner) external view returns (uint256 balance);
111 
112     /**
113      * @dev Returns the owner of the `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function ownerOf(uint256 tokenId) external view returns (address owner);
120 
121     /**
122      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
123      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must exist and be owned by `from`.
130      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
131      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
132      *
133      * Emits a {Transfer} event.
134      */
135     function safeTransferFrom(
136         address from,
137         address to,
138         uint256 tokenId
139     ) external;
140 
141     /**
142      * @dev Transfers `tokenId` token from `from` to `to`.
143      *
144      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address from,
157         address to,
158         uint256 tokenId
159     ) external;
160 
161     /**
162      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
163      * The approval is cleared when the token is transferred.
164      *
165      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
166      *
167      * Requirements:
168      *
169      * - The caller must own the token or be an approved operator.
170      * - `tokenId` must exist.
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address to, uint256 tokenId) external;
175 
176     /**
177      * @dev Returns the account approved for `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function getApproved(uint256 tokenId) external view returns (address operator);
184 
185     /**
186      * @dev Approve or remove `operator` as an operator for the caller.
187      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
188      *
189      * Requirements:
190      *
191      * - The `operator` cannot be the caller.
192      *
193      * Emits an {ApprovalForAll} event.
194      */
195     function setApprovalForAll(address operator, bool _approved) external;
196 
197     /**
198      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
199      *
200      * See {setApprovalForAll}
201      */
202     function isApprovedForAll(address owner, address operator) external view returns (bool);
203 
204     /**
205      * @dev Safely transfers `tokenId` token from `from` to `to`.
206      *
207      * Requirements:
208      *
209      * - `from` cannot be the zero address.
210      * - `to` cannot be the zero address.
211      * - `tokenId` token must exist and be owned by `from`.
212      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
214      *
215      * Emits a {Transfer} event.
216      */
217     function safeTransferFrom(
218         address from,
219         address to,
220         uint256 tokenId,
221         bytes calldata data
222     ) external;
223 }
224 
225 
226 pragma solidity ^0.8.0;
227 
228 
229 /**
230  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
231  * @dev See https://eips.ethereum.org/EIPS/eip-721
232  */
233 interface IERC721Metadata is IERC721 {
234     /**
235      * @dev Returns the token collection name.
236      */
237     function name() external view returns (string memory);
238 
239     /**
240      * @dev Returns the token collection symbol.
241      */
242     function symbol() external view returns (string memory);
243 
244     /**
245      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
246      */
247     function tokenURI(uint256 tokenId) external view returns (string memory);
248 }
249 
250 pragma solidity ^0.8.0;
251 
252 
253 /**
254  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
255  * @dev See https://eips.ethereum.org/EIPS/eip-721
256  */
257 interface IERC721Enumerable is IERC721 {
258     /**
259      * @dev Returns the total amount of tokens stored by the contract.
260      */
261     function totalSupply() external view returns (uint256);
262 
263     /**
264      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
265      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
266      */
267     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
268 
269     /**
270      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
271      * Use along with {totalSupply} to enumerate all tokens.
272      */
273     function tokenByIndex(uint256 index) external view returns (uint256);
274 }
275 
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Provides information about the current execution context, including the
281  * sender of the transaction and its data. While these are generally available
282  * via msg.sender and msg.data, they should not be accessed in such a direct
283  * manner, since when dealing with meta-transactions the account sending and
284  * paying for execution may not be the actual sender (as far as an application
285  * is concerned).
286  *
287  * This contract is only required for intermediate, library-like contracts.
288  */
289 abstract contract Context {
290     function _msgSender() internal view virtual returns (address) {
291         return msg.sender;
292     }
293 
294     function _msgData() internal view virtual returns (bytes calldata) {
295         return msg.data;
296     }
297 }
298 
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
304  * the Metadata extension, but not including the Enumerable extension, which is available separately as
305  * {ERC721Enumerable}.
306  */
307 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
308     using Address for address;
309     using Strings for uint256;
310 
311     // Token name
312     string private _name;
313 
314     // Token symbol
315     string private _symbol;
316 
317     // Mapping from token ID to owner address
318     mapping(uint256 => address) private _owners;
319 
320     // Mapping owner address to token count
321     mapping(address => uint256) private _balances;
322 
323     // Mapping from token ID to approved address
324     mapping(uint256 => address) private _tokenApprovals;
325 
326     // Mapping from owner to operator approvals
327     mapping(address => mapping(address => bool)) private _operatorApprovals;
328 
329     /**
330      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
331      */
332     constructor(string memory name_, string memory symbol_) {
333         _name = name_;
334         _symbol = symbol_;
335     }
336 
337     /**
338      * @dev See {IERC165-supportsInterface}.
339      */
340     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
341         return
342             interfaceId == type(IERC721).interfaceId ||
343             interfaceId == type(IERC721Metadata).interfaceId ||
344             super.supportsInterface(interfaceId);
345     }
346 
347     /**
348      * @dev See {IERC721-balanceOf}.
349      */
350     function balanceOf(address owner) public view virtual override returns (uint256) {
351         require(owner != address(0), "ERC721: balance query for the zero address");
352         return _balances[owner];
353     }
354 
355     /**
356      * @dev See {IERC721-ownerOf}.
357      */
358     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
359         address owner = _owners[tokenId];
360         require(owner != address(0), "ERC721: owner query for nonexistent token");
361         return owner;
362     }
363 
364     /**
365      * @dev See {IERC721Metadata-name}.
366      */
367     function name() public view virtual override returns (string memory) {
368         return _name;
369     }
370 
371     /**
372      * @dev See {IERC721Metadata-symbol}.
373      */
374     function symbol() public view virtual override returns (string memory) {
375         return _symbol;
376     }
377 
378     /**
379      * @dev See {IERC721Metadata-tokenURI}.
380      */
381     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
382         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
383 
384         string memory baseURI = _baseURI();
385         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
386     }
387 
388     /**
389      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
390      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
391      * by default, can be overriden in child contracts.
392      */
393     function _baseURI() internal view virtual returns (string memory) {
394         return "";
395     }
396 
397     /**
398      * @dev See {IERC721-approve}.
399      */
400     function approve(address to, uint256 tokenId) public virtual override {
401         address owner = ERC721.ownerOf(tokenId);
402         require(to != owner, "ERC721: approval to current owner");
403 
404         require(
405             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
406             "ERC721: approve caller is not owner nor approved for all"
407         );
408 
409         _approve(to, tokenId);
410     }
411 
412     /**
413      * @dev See {IERC721-getApproved}.
414      */
415     function getApproved(uint256 tokenId) public view virtual override returns (address) {
416         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
417 
418         return _tokenApprovals[tokenId];
419     }
420 
421     /**
422      * @dev See {IERC721-setApprovalForAll}.
423      */
424     function setApprovalForAll(address operator, bool approved) public virtual override {
425         require(operator != _msgSender(), "ERC721: approve to caller");
426 
427         _operatorApprovals[_msgSender()][operator] = approved;
428         emit ApprovalForAll(_msgSender(), operator, approved);
429     }
430 
431     /**
432      * @dev See {IERC721-isApprovedForAll}.
433      */
434     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
435         return _operatorApprovals[owner][operator];
436     }
437 
438     /**
439      * @dev See {IERC721-transferFrom}.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) public virtual override {
446         //solhint-disable-next-line max-line-length
447         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
448 
449         _transfer(from, to, tokenId);
450     }
451 
452     /**
453      * @dev See {IERC721-safeTransferFrom}.
454      */
455     function safeTransferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) public virtual override {
460         safeTransferFrom(from, to, tokenId, "");
461     }
462 
463     /**
464      * @dev See {IERC721-safeTransferFrom}.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes memory _data
471     ) public virtual override {
472         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
473         _safeTransfer(from, to, tokenId, _data);
474     }
475 
476     /**
477      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
478      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
479      *
480      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
481      *
482      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
483      * implement alternative mechanisms to perform token transfer, such as signature-based.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must exist and be owned by `from`.
490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491      *
492      * Emits a {Transfer} event.
493      */
494     function _safeTransfer(
495         address from,
496         address to,
497         uint256 tokenId,
498         bytes memory _data
499     ) internal virtual {
500         _transfer(from, to, tokenId);
501         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
502     }
503 
504     /**
505      * @dev Returns whether `tokenId` exists.
506      *
507      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
508      *
509      * Tokens start existing when they are minted (`_mint`),
510      * and stop existing when they are burned (`_burn`).
511      */
512     function _exists(uint256 tokenId) internal view virtual returns (bool) {
513         return _owners[tokenId] != address(0);
514     }
515 
516     /**
517      * @dev Returns whether `spender` is allowed to manage `tokenId`.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
524         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
525         address owner = ERC721.ownerOf(tokenId);
526         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
527     }
528 
529     /**
530      * @dev Safely mints `tokenId` and transfers it to `to`.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must not exist.
535      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
536      *
537      * Emits a {Transfer} event.
538      */
539     function _safeMint(address to, uint256 tokenId) internal virtual {
540         _safeMint(to, tokenId, "");
541     }
542 
543     /**
544      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
545      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
546      */
547     function _safeMint(
548         address to,
549         uint256 tokenId,
550         bytes memory _data
551     ) internal virtual {
552         _mint(to, tokenId);
553         require(
554             _checkOnERC721Received(address(0), to, tokenId, _data),
555             "ERC721: transfer to non ERC721Receiver implementer"
556         );
557     }
558 
559     /**
560      * @dev Mints `tokenId` and transfers it to `to`.
561      *
562      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
563      *
564      * Requirements:
565      *
566      * - `tokenId` must not exist.
567      * - `to` cannot be the zero address.
568      *
569      * Emits a {Transfer} event.
570      */
571     function _mint(address to, uint256 tokenId) internal virtual {
572         require(to != address(0), "ERC721: mint to the zero address");
573         require(!_exists(tokenId), "ERC721: token already minted");
574 
575         _beforeTokenTransfer(address(0), to, tokenId);
576 
577         _balances[to] += 1;
578         _owners[tokenId] = to;
579 
580         emit Transfer(address(0), to, tokenId);
581     }
582 
583     /**
584      * @dev Destroys `tokenId`.
585      * The approval is cleared when the token is burned.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      *
591      * Emits a {Transfer} event.
592      */
593     function _burn(uint256 tokenId) internal virtual {
594         address owner = ERC721.ownerOf(tokenId);
595 
596         _beforeTokenTransfer(owner, address(0), tokenId);
597 
598         // Clear approvals
599         _approve(address(0), tokenId);
600 
601         _balances[owner] -= 1;
602         delete _owners[tokenId];
603 
604         emit Transfer(owner, address(0), tokenId);
605     }
606 
607     /**
608      * @dev Transfers `tokenId` from `from` to `to`.
609      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
610      *
611      * Requirements:
612      *
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must be owned by `from`.
615      *
616      * Emits a {Transfer} event.
617      */
618     function _transfer(
619         address from,
620         address to,
621         uint256 tokenId
622     ) internal virtual {
623         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
624         require(to != address(0), "ERC721: transfer to the zero address");
625 
626         _beforeTokenTransfer(from, to, tokenId);
627 
628         // Clear approvals from the previous owner
629         _approve(address(0), tokenId);
630 
631         _balances[from] -= 1;
632         _balances[to] += 1;
633         _owners[tokenId] = to;
634 
635         emit Transfer(from, to, tokenId);
636     }
637 
638     /**
639      * @dev Approve `to` to operate on `tokenId`
640      *
641      * Emits a {Approval} event.
642      */
643     function _approve(address to, uint256 tokenId) internal virtual {
644         _tokenApprovals[tokenId] = to;
645         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
646     }
647 
648     /**
649      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
650      * The call is not executed if the target address is not a contract.
651      *
652      * @param from address representing the previous owner of the given token ID
653      * @param to target address that will receive the tokens
654      * @param tokenId uint256 ID of the token to be transferred
655      * @param _data bytes optional data to send along with the call
656      * @return bool whether the call correctly returned the expected magic value
657      */
658     function _checkOnERC721Received(
659         address from,
660         address to,
661         uint256 tokenId,
662         bytes memory _data
663     ) private returns (bool) {
664         if (to.isContract()) {
665             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
666                 return retval == IERC721Receiver.onERC721Received.selector;
667             } catch (bytes memory reason) {
668                 if (reason.length == 0) {
669                     revert("ERC721: transfer to non ERC721Receiver implementer");
670                 } else {
671                     assembly {
672                         revert(add(32, reason), mload(reason))
673                     }
674                 }
675             }
676         } else {
677             return true;
678         }
679     }
680 
681     /**
682      * @dev Hook that is called before any token transfer. This includes minting
683      * and burning.
684      *
685      * Calling conditions:
686      *
687      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
688      * transferred to `to`.
689      * - When `from` is zero, `tokenId` will be minted for `to`.
690      * - When `to` is zero, ``from``'s `tokenId` will be burned.
691      * - `from` and `to` are never both zero.
692      *
693      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
694      */
695     function _beforeTokenTransfer(
696         address from,
697         address to,
698         uint256 tokenId
699     ) internal virtual {}
700 }
701 
702 
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @dev Collection of functions related to the address type
708  */
709 library Address {
710     /**
711      * @dev Returns true if `account` is a contract.
712      *
713      * [IMPORTANT]
714      * ====
715      * It is unsafe to assume that an address for which this function returns
716      * false is an externally-owned account (EOA) and not a contract.
717      *
718      * Among others, `isContract` will return false for the following
719      * types of addresses:
720      *
721      *  - an externally-owned account
722      *  - a contract in construction
723      *  - an address where a contract will be created
724      *  - an address where a contract lived, but was destroyed
725      * ====
726      */
727     function isContract(address account) internal view returns (bool) {
728         // This method relies on extcodesize, which returns 0 for contracts in
729         // construction, since the code is only stored at the end of the
730         // constructor execution.
731 
732         uint256 size;
733         assembly {
734             size := extcodesize(account)
735         }
736         return size > 0;
737     }
738 
739     /**
740      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
741      * `recipient`, forwarding all available gas and reverting on errors.
742      *
743      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
744      * of certain opcodes, possibly making contracts go over the 2300 gas limit
745      * imposed by `transfer`, making them unable to receive funds via
746      * `transfer`. {sendValue} removes this limitation.
747      *
748      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
749      *
750      * IMPORTANT: because control is transferred to `recipient`, care must be
751      * taken to not create reentrancy vulnerabilities. Consider using
752      * {ReentrancyGuard} or the
753      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
754      */
755     function sendValue(address payable recipient, uint256 amount) internal {
756         require(address(this).balance >= amount, "Address: insufficient balance");
757 
758         (bool success, ) = recipient.call{value: amount}("");
759         require(success, "Address: unable to send value, recipient may have reverted");
760     }
761 
762     /**
763      * @dev Performs a Solidity function call using a low level `call`. A
764      * plain `call` is an unsafe replacement for a function call: use this
765      * function instead.
766      *
767      * If `target` reverts with a revert reason, it is bubbled up by this
768      * function (like regular Solidity function calls).
769      *
770      * Returns the raw returned data. To convert to the expected return value,
771      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
772      *
773      * Requirements:
774      *
775      * - `target` must be a contract.
776      * - calling `target` with `data` must not revert.
777      *
778      * _Available since v3.1._
779      */
780     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
781         return functionCall(target, data, "Address: low-level call failed");
782     }
783 
784     /**
785      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
786      * `errorMessage` as a fallback revert reason when `target` reverts.
787      *
788      * _Available since v3.1._
789      */
790     function functionCall(
791         address target,
792         bytes memory data,
793         string memory errorMessage
794     ) internal returns (bytes memory) {
795         return functionCallWithValue(target, data, 0, errorMessage);
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
800      * but also transferring `value` wei to `target`.
801      *
802      * Requirements:
803      *
804      * - the calling contract must have an ETH balance of at least `value`.
805      * - the called Solidity function must be `payable`.
806      *
807      * _Available since v3.1._
808      */
809     function functionCallWithValue(
810         address target,
811         bytes memory data,
812         uint256 value
813     ) internal returns (bytes memory) {
814         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
815     }
816 
817     /**
818      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
819      * with `errorMessage` as a fallback revert reason when `target` reverts.
820      *
821      * _Available since v3.1._
822      */
823     function functionCallWithValue(
824         address target,
825         bytes memory data,
826         uint256 value,
827         string memory errorMessage
828     ) internal returns (bytes memory) {
829         require(address(this).balance >= value, "Address: insufficient balance for call");
830         require(isContract(target), "Address: call to non-contract");
831 
832         (bool success, bytes memory returndata) = target.call{value: value}(data);
833         return verifyCallResult(success, returndata, errorMessage);
834     }
835 
836     /**
837      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
838      * but performing a static call.
839      *
840      * _Available since v3.3._
841      */
842     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
843         return functionStaticCall(target, data, "Address: low-level static call failed");
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
848      * but performing a static call.
849      *
850      * _Available since v3.3._
851      */
852     function functionStaticCall(
853         address target,
854         bytes memory data,
855         string memory errorMessage
856     ) internal view returns (bytes memory) {
857         require(isContract(target), "Address: static call to non-contract");
858 
859         (bool success, bytes memory returndata) = target.staticcall(data);
860         return verifyCallResult(success, returndata, errorMessage);
861     }
862 
863     /**
864      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
865      * but performing a delegate call.
866      *
867      * _Available since v3.4._
868      */
869     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
870         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
871     }
872 
873     /**
874      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
875      * but performing a delegate call.
876      *
877      * _Available since v3.4._
878      */
879     function functionDelegateCall(
880         address target,
881         bytes memory data,
882         string memory errorMessage
883     ) internal returns (bytes memory) {
884         require(isContract(target), "Address: delegate call to non-contract");
885 
886         (bool success, bytes memory returndata) = target.delegatecall(data);
887         return verifyCallResult(success, returndata, errorMessage);
888     }
889 
890     /**
891      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
892      * revert reason using the provided one.
893      *
894      * _Available since v4.3._
895      */
896     function verifyCallResult(
897         bool success,
898         bytes memory returndata,
899         string memory errorMessage
900     ) internal pure returns (bytes memory) {
901         if (success) {
902             return returndata;
903         } else {
904             // Look for revert reason and bubble it up if present
905             if (returndata.length > 0) {
906                 // The easiest way to bubble the revert reason is using memory via assembly
907 
908                 assembly {
909                     let returndata_size := mload(returndata)
910                     revert(add(32, returndata), returndata_size)
911                 }
912             } else {
913                 revert(errorMessage);
914             }
915         }
916     }
917 }
918 
919 
920 
921 pragma solidity ^0.8.0;
922 
923 /**
924  * @dev Contract module that helps prevent reentrant calls to a function.
925  *
926  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
927  * available, which can be applied to functions to make sure there are no nested
928  * (reentrant) calls to them.
929  *
930  * Note that because there is a single `nonReentrant` guard, functions marked as
931  * `nonReentrant` may not call one another. This can be worked around by making
932  * those functions `private`, and then adding `external` `nonReentrant` entry
933  * points to them.
934  *
935  * TIP: If you would like to learn more about reentrancy and alternative ways
936  * to protect against it, check out our blog post
937  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
938  */
939 abstract contract ReentrancyGuard {
940     // Booleans are more expensive than uint256 or any type that takes up a full
941     // word because each write operation emits an extra SLOAD to first read the
942     // slot's contents, replace the bits taken up by the boolean, and then write
943     // back. This is the compiler's defense against contract upgrades and
944     // pointer aliasing, and it cannot be disabled.
945 
946     // The values being non-zero value makes deployment a bit more expensive,
947     // but in exchange the refund on every call to nonReentrant will be lower in
948     // amount. Since refunds are capped to a percentage of the total
949     // transaction's gas, it is best to keep them low in cases like this one, to
950     // increase the likelihood of the full refund coming into effect.
951     uint256 private constant _NOT_ENTERED = 1;
952     uint256 private constant _ENTERED = 2;
953 
954     uint256 private _status;
955 
956     constructor() {
957         _status = _NOT_ENTERED;
958     }
959 
960     /**
961      * @dev Prevents a contract from calling itself, directly or indirectly.
962      * Calling a `nonReentrant` function from another `nonReentrant`
963      * function is not supported. It is possible to prevent this from happening
964      * by making the `nonReentrant` function external, and make it call a
965      * `private` function that does the actual work.
966      */
967     modifier nonReentrant() {
968         // On the first call to nonReentrant, _notEntered will be true
969         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
970 
971         // Any calls to nonReentrant after this point will fail
972         _status = _ENTERED;
973 
974         _;
975 
976         // By storing the original value once again, a refund is triggered (see
977         // https://eips.ethereum.org/EIPS/eip-2200)
978         _status = _NOT_ENTERED;
979     }
980 }
981 
982 
983 pragma solidity ^0.8.0;
984 
985 /**
986  * @dev String operations.
987  */
988 library Strings {
989     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
990 
991     /**
992      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
993      */
994     function toString(uint256 value) internal pure returns (string memory) {
995         // Inspired by OraclizeAPI's implementation - MIT licence
996         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
997 
998         if (value == 0) {
999             return "0";
1000         }
1001         uint256 temp = value;
1002         uint256 digits;
1003         while (temp != 0) {
1004             digits++;
1005             temp /= 10;
1006         }
1007         bytes memory buffer = new bytes(digits);
1008         while (value != 0) {
1009             digits -= 1;
1010             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1011             value /= 10;
1012         }
1013         return string(buffer);
1014     }
1015 
1016     /**
1017      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1018      */
1019     function toHexString(uint256 value) internal pure returns (string memory) {
1020         if (value == 0) {
1021             return "0x00";
1022         }
1023         uint256 temp = value;
1024         uint256 length = 0;
1025         while (temp != 0) {
1026             length++;
1027             temp >>= 8;
1028         }
1029         return toHexString(value, length);
1030     }
1031 
1032     /**
1033      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1034      */
1035     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1036         bytes memory buffer = new bytes(2 * length + 2);
1037         buffer[0] = "0";
1038         buffer[1] = "x";
1039         for (uint256 i = 2 * length + 1; i > 1; --i) {
1040             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1041             value >>= 4;
1042         }
1043         require(value == 0, "Strings: hex length insufficient");
1044         return string(buffer);
1045     }
1046 }
1047 
1048 
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 
1053 /**
1054  * @dev Contract module which provides a basic access control mechanism, where
1055  * there is an account (an owner) that can be granted exclusive access to
1056  * specific functions.
1057  *
1058  * By default, the owner account will be the one that deploys the contract. This
1059  * can later be changed with {transferOwnership}.
1060  *
1061  * This module is used through inheritance. It will make available the modifier
1062  * `onlyOwner`, which can be applied to your functions to restrict their use to
1063  * the owner.
1064  */
1065 abstract contract Ownable is Context {
1066     address private _owner;
1067 
1068     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1069 
1070     /**
1071      * @dev Initializes the contract setting the deployer as the initial owner.
1072      */
1073     constructor() {
1074         _setOwner(_msgSender());
1075     }
1076 
1077     /**
1078      * @dev Returns the address of the current owner.
1079      */
1080     function owner() public view virtual returns (address) {
1081         return _owner;
1082     }
1083 
1084     /**
1085      * @dev Throws if called by any account other than the owner.
1086      */
1087     modifier onlyOwner() {
1088         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1089         _;
1090     }
1091 
1092     /**
1093      * @dev Leaves the contract without owner. It will not be possible to call
1094      * `onlyOwner` functions anymore. Can only be called by the current owner.
1095      *
1096      * NOTE: Renouncing ownership will leave the contract without an owner,
1097      * thereby removing any functionality that is only available to the owner.
1098      */
1099     function renounceOwnership() public virtual onlyOwner {
1100         _setOwner(address(0));
1101     }
1102 
1103     /**
1104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1105      * Can only be called by the current owner.
1106      */
1107     function transferOwnership(address newOwner) public virtual onlyOwner {
1108         require(newOwner != address(0), "Ownable: new owner is the zero address");
1109         _setOwner(newOwner);
1110     }
1111 
1112     function _setOwner(address newOwner) private {
1113         address oldOwner = _owner;
1114         _owner = newOwner;
1115         emit OwnershipTransferred(oldOwner, newOwner);
1116     }
1117 }
1118 
1119 
1120 pragma solidity ^0.8.10;
1121 
1122 contract OctoLab is ERC721, Ownable, ReentrancyGuard {
1123 	using Strings for uint256;
1124 
1125 	string public baseURI;
1126 	uint256 public cost = 0.025 ether;
1127     uint256 public minted;
1128 	uint256 public maxSupply = 3000;
1129 	uint256 public maxMint = 7;
1130 	bool public status = false;
1131 	
1132     address batzAddr = 0xc8adFb4D437357D0A656D4e62fd9a6D22e401aa0;   //CryptoBatz
1133     address catsAddr = 0x1A92f7381B9F03921564a437210bB9396471050C;   //CoolCats
1134 
1135     mapping(address => bool) public mintlist;
1136 
1137 	constructor() ERC721("OctoLab", "OL") {}
1138 
1139 
1140     //checks if address owns at least one token from either of the qualifying collections
1141     function isHolder(address _wallet) public view returns (bool) {
1142         ERC721 batzToken = ERC721(batzAddr);
1143         uint256 _batzBalance = batzToken.balanceOf(_wallet);
1144     
1145         ERC721 catsToken = ERC721(catsAddr);
1146         uint256 _catsBalance = catsToken.balanceOf(_wallet);
1147 
1148         return (_batzBalance + _catsBalance > 0);
1149   }
1150 
1151 
1152     //public mint
1153 	function mint(uint256 _mintAmount) public payable nonReentrant{
1154 		require(status, "Sale inactive" );
1155         require(msg.sender == tx.origin, "No contracts!");
1156 		require(_mintAmount <= maxMint, "Too many" );
1157 		require(minted + _mintAmount <= maxSupply, "Would excced supply" );
1158 		require(msg.value >= cost * _mintAmount, "Not enough ETH");
1159    		for (uint256 i = 0; i < _mintAmount; i++) {
1160             minted++;
1161 			_safeMint(msg.sender, minted);
1162 		}
1163 	}
1164 
1165 
1166     //free claim for qualifying holders
1167     function claim(address _wallet) external nonReentrant {
1168         require(status, "Sale inactive" );
1169         require(msg.sender == tx.origin, "No contracts!");
1170 		require(minted + 1 <= maxSupply, "Would excced supply" );
1171         (bool _holder) = isHolder(_wallet);
1172         require(_holder, "Must own at least one qualifying NFT to claim!");
1173         require(mintlist[_wallet] != true, "Already claimed!");
1174         mintlist[_wallet] = true;
1175         minted++;
1176         _safeMint(msg.sender, minted);
1177      }
1178 
1179 
1180     //giveaways
1181 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1182 		require(quantity.length == recipient.length, "Provide quantities and recipients" );
1183 		uint totalQuantity = 0;
1184 		for(uint i = 0; i < quantity.length; i++){
1185 			totalQuantity += quantity[i];
1186 		}
1187 		require( minted + totalQuantity <= maxSupply, "Too many" );
1188 		delete totalQuantity;
1189 		for(uint i = 0; i < recipient.length; i++){
1190 			for(uint j = 0; j < quantity[i]; j++){
1191             minted++;
1192 			_safeMint(recipient[i], minted);
1193 			}
1194 		}
1195 	}
1196 	
1197 
1198     //metadata
1199 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1200 	    require(_exists(tokenId), "Nonexistent token");
1201 	    string memory currentBaseURI = _baseURI();
1202 	    return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, (tokenId).toString())) : "";
1203 	}
1204 
1205 
1206     //setters
1207     function setBatzAddress(address _batzAddr) external onlyOwner {
1208         batzAddr = _batzAddr;
1209     }
1210 
1211     function setCatsAddress(address _catsAddr) external onlyOwner {
1212         catsAddr = _catsAddr;
1213     }
1214 
1215 	function setCost(uint256 _newCost) public onlyOwner {
1216 	    cost = _newCost;
1217 	}
1218 	function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1219 	    maxMint = _newMaxMintAmount;
1220 	}
1221 	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1222 	    maxSupply = _newMaxSupply;
1223 	}
1224 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1225 	    baseURI = _newBaseURI;
1226     }
1227 
1228 
1229     //admin functions
1230     function _baseURI() internal view override returns (string memory) {
1231         return baseURI;
1232     }
1233 	
1234 	function flipSaleStatus() public onlyOwner {
1235 	    status = !status;
1236 	}
1237 
1238 	function withdraw() public payable onlyOwner {
1239 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1240 	require(success);
1241 	}
1242 
1243 }