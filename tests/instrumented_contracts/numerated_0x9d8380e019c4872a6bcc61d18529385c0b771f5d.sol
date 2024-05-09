1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-18
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-03-18
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-03-14
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-03-11
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2022-03-07
23 */
24 
25 /**
26  *Submitted for verification at Etherscan.io on 2022-03-07
27 */
28 
29 /**
30  *Submitted for verification at Etherscan.io on 2022-03-04
31 */
32 
33 /**
34  *Submitted for verification at Etherscan.io on 2022-03-04
35 */
36 
37 // SPDX-License-Identifier: MIT
38 pragma solidity ^ 0.8.7;
39 pragma experimental ABIEncoderV2;
40 
41 
42 
43 
44 
45 /**
46  * @dev Provides information about the current execution context, including the
47  * sender of the transaction and its data. While these are generally available
48  * via msg.sender and msg.data, they should not be accessed in such a direct
49  * manner, since when dealing with meta-transactions the account sending and
50  * paying for execution may not be the actual sender (as far as an application
51  * is concerned).
52  *
53  * This contract is only required for intermediate, library-like contracts.
54  */
55 abstract contract Context {
56     function _msgSender() internal view virtual returns(address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns(bytes calldata) {
61         return msg.data;
62     }
63 }
64 
65 /**
66  * @dev Interface of the ERC165 standard, as defined in the
67  * https://eips.ethereum.org/EIPS/eip-165[EIP].
68  *
69  * Implementers can declare support of contract interfaces, which can then be
70  * queried by others ({ERC165Checker}).
71  *
72  * For an implementation, see {ERC165}.
73  */
74 interface IERC165 {
75     /**
76      * @dev Returns true if this contract implements the interface defined by
77      * `interfaceId`. See the corresponding
78      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
79      * to learn more about how these ids are created.
80      *
81      * This function call must use less than 30 000 gas.
82      */
83     function supportsInterface(bytes4 interfaceId) external view returns(bool);
84 }
85 
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
110     function balanceOf(address owner) external view returns(uint256 balance);
111 
112     /**
113      * @dev Returns the owner of the `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function ownerOf(uint256 tokenId) external view returns(address owner);
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
183     function getApproved(uint256 tokenId) external view returns(address operator);
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
202     function isApprovedForAll(address owner, address operator) external view returns(bool);
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
226 
227 /**
228  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
229  * @dev See https://eips.ethereum.org/EIPS/eip-721
230  */
231 interface IERC721Metadata is IERC721 {
232     /**
233      * @dev Returns the token collection name.
234      */
235     function name() external view returns(string memory);
236 
237     /**
238      * @dev Returns the token collection symbol.
239      */
240     function symbol() external view returns(string memory);
241 
242     /**
243      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
244      */
245     function tokenURI(uint256 tokenId) external view returns(string memory);
246 }
247 
248 
249 
250 
251 
252 abstract contract ERC165 is IERC165 {
253     /**
254      * @dev See {IERC165-supportsInterface}.
255      */
256     function supportsInterface(bytes4 interfaceId) public view virtual override returns(bool) {
257         return interfaceId == type(IERC165).interfaceId;
258     }
259 }
260 
261 
262 
263 
264 
265 
266 /**
267  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
268  * the Metadata extension, but not including the Enumerable extension, which is available separately as
269  * {ERC721Enumerable}.
270  */
271 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
272     using Address for address;
273         using Strings for uint256;
274 
275             // Token name
276             string private _name;
277 
278     // Token symbol
279     string private _symbol;
280 
281     // Mapping from token ID to owner address
282     mapping(uint256 => address) private _owners;
283 
284     // Mapping owner address to token count
285     mapping(address => uint256) private _balances;
286 
287     // Mapping from token ID to approved address
288     mapping(uint256 => address) private _tokenApprovals;
289 
290     // Mapping from owner to operator approvals
291     mapping(address => mapping(address => bool)) private _operatorApprovals;
292 
293     /**
294      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
295      */
296     constructor(string memory name_, string memory symbol_) {
297         _name = name_;
298         _symbol = symbol_;
299     }
300 
301     /**
302      * @dev See {IERC165-supportsInterface}.
303      */
304     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns(bool) {
305         return
306         interfaceId == type(IERC721).interfaceId ||
307             interfaceId == type(IERC721Metadata).interfaceId ||
308             super.supportsInterface(interfaceId);
309     }
310 
311     /**
312      * @dev See {IERC721-balanceOf}.
313      */
314     function balanceOf(address owner) public view virtual override returns(uint256) {
315         require(owner != address(0), "ERC721: balance query for the zero address");
316         return _balances[owner];
317     }
318 
319     /**
320      * @dev See {IERC721-ownerOf}.
321      */
322     function ownerOf(uint256 tokenId) public view virtual override returns(address) {
323         address owner = _owners[tokenId];
324         require(owner != address(0), "ERC721: owner query for nonexistent token");
325         return owner;
326     }
327 
328     /**
329      * @dev See {IERC721Metadata-name}.
330      */
331     function name() public view virtual override returns(string memory) {
332         return _name;
333     }
334 
335     /**
336      * @dev See {IERC721Metadata-symbol}.
337      */
338     function symbol() public view virtual override returns(string memory) {
339         return _symbol;
340     }
341 
342     /**
343      * @dev See {IERC721Metadata-tokenURI}.
344      */
345     function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
346         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
347 
348         string memory baseURI = _baseURI();
349         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
350     }
351 
352     /**
353      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
354      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
355      * by default, can be overriden in child contracts.
356      */
357     function _baseURI() internal view virtual returns(string memory) {
358         return "";
359     }
360 
361     /**
362      * @dev See {IERC721-approve}.
363      */
364     function approve(address to, uint256 tokenId) public virtual override {
365         address owner = ERC721.ownerOf(tokenId);
366         require(to != owner, "ERC721: approval to current owner");
367 
368         require(
369             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
370             "ERC721: approve caller is not owner nor approved for all"
371         );
372 
373         _approve(to, tokenId);
374     }
375 
376     /**
377      * @dev See {IERC721-getApproved}.
378      */
379     function getApproved(uint256 tokenId) public view virtual override returns(address) {
380         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
381 
382         return _tokenApprovals[tokenId];
383     }
384 
385     /**
386      * @dev See {IERC721-setApprovalForAll}.
387      */
388     function setApprovalForAll(address operator, bool approved) public virtual override {
389         require(operator != _msgSender(), "ERC721: approve to caller");
390 
391         _operatorApprovals[_msgSender()][operator] = approved;
392         emit ApprovalForAll(_msgSender(), operator, approved);
393     }
394 
395     /**
396      * @dev See {IERC721-isApprovedForAll}.
397      */
398     function isApprovedForAll(address owner, address operator) public view virtual override returns(bool) {
399         return _operatorApprovals[owner][operator];
400     }
401 
402     /**
403      * @dev See {IERC721-transferFrom}.
404      */
405     function transferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) public virtual override {
410         //solhint-disable-next-line max-line-length
411         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
412 
413         _transfer(from, to, tokenId);
414     }
415 
416     /**
417      * @dev See {IERC721-safeTransferFrom}.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) public virtual override {
424         safeTransferFrom(from, to, tokenId, "");
425     }
426 
427     /**
428      * @dev See {IERC721-safeTransferFrom}.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId,
434         bytes memory _data
435     ) public virtual override {
436         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
437         _safeTransfer(from, to, tokenId, _data);
438     }
439 
440     /**
441      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
442      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
443      *
444      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
445      *
446      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
447      * implement alternative mechanisms to perform token transfer, such as signature-based.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must exist and be owned by `from`.
454      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
455      *
456      * Emits a {Transfer} event.
457      */
458     function _safeTransfer(
459         address from,
460         address to,
461         uint256 tokenId,
462         bytes memory _data
463     ) internal virtual {
464         _transfer(from, to, tokenId);
465         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
466     }
467 
468     /**
469      * @dev Returns whether `tokenId` exists.
470      *
471      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
472      *
473      * Tokens start existing when they are minted (`_mint`),
474      * and stop existing when they are burned (`_burn`).
475      */
476     function _exists(uint256 tokenId) internal view virtual returns(bool) {
477         return _owners[tokenId] != address(0);
478     }
479 
480     /**
481      * @dev Returns whether `spender` is allowed to manage `tokenId`.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns(bool) {
488         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
489         address owner = ERC721.ownerOf(tokenId);
490         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
491     }
492 
493     /**
494      * @dev Safely mints `tokenId` and transfers it to `to`.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must not exist.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function _safeMint(address to, uint256 tokenId) internal virtual {
504         _safeMint(to, tokenId, "");
505     }
506 
507     /**
508      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
509      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
510      */
511     function _safeMint(
512         address to,
513         uint256 tokenId,
514         bytes memory _data
515     ) internal virtual {
516         _mint(to, tokenId);
517         require(
518             _checkOnERC721Received(address(0), to, tokenId, _data),
519             "ERC721: transfer to non ERC721Receiver implementer"
520         );
521     }
522 
523     /**
524      * @dev Mints `tokenId` and transfers it to `to`.
525      *
526      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
527      *
528      * Requirements:
529      *
530      * - `tokenId` must not exist.
531      * - `to` cannot be the zero address.
532      *
533      * Emits a {Transfer} event.
534      */
535     function _mint(address to, uint256 tokenId) internal virtual {
536         require(to != address(0), "ERC721: mint to the zero address");
537         require(!_exists(tokenId), "ERC721: token already minted");
538 
539         _beforeTokenTransfer(address(0), to, tokenId);
540 
541         _balances[to] += 1;
542         _owners[tokenId] = to;
543 
544         emit Transfer(address(0), to, tokenId);
545     }
546 
547     /**
548      * @dev Destroys `tokenId`.
549      * The approval is cleared when the token is burned.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      *
555      * Emits a {Transfer} event.
556      */
557     function _burn(uint256 tokenId) internal virtual {
558         address owner = ERC721.ownerOf(tokenId);
559 
560         _beforeTokenTransfer(owner, address(0), tokenId);
561 
562         // Clear approvals
563         _approve(address(0), tokenId);
564 
565         _balances[owner] -= 1;
566         delete _owners[tokenId];
567 
568         emit Transfer(owner, address(0), tokenId);
569     }
570 
571     /**
572      * @dev Transfers `tokenId` from `from` to `to`.
573      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
574      *
575      * Requirements:
576      *
577      * - `to` cannot be the zero address.
578      * - `tokenId` token must be owned by `from`.
579      *
580      * Emits a {Transfer} event.
581      */
582     function _transfer(
583         address from,
584         address to,
585         uint256 tokenId
586     ) internal virtual {
587         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
588         require(to != address(0), "ERC721: transfer to the zero address");
589 
590         _beforeTokenTransfer(from, to, tokenId);
591 
592         // Clear approvals from the previous owner
593         _approve(address(0), tokenId);
594 
595         _balances[from] -= 1;
596         _balances[to] += 1;
597         _owners[tokenId] = to;
598 
599         emit Transfer(from, to, tokenId);
600     }
601 
602     /**
603      * @dev Approve `to` to operate on `tokenId`
604      *
605      * Emits a {Approval} event.
606      */
607     function _approve(address to, uint256 tokenId) internal virtual {
608         _tokenApprovals[tokenId] = to;
609         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
610     }
611 
612     /**
613      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
614      * The call is not executed if the target address is not a contract.
615      *
616      * @param from address representing the previous owner of the given token ID
617      * @param to target address that will receive the tokens
618      * @param tokenId uint256 ID of the token to be transferred
619      * @param _data bytes optional data to send along with the call
620      * @return bool whether the call correctly returned the expected magic value
621      */
622     function _checkOnERC721Received(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes memory _data
627     ) private returns(bool) {
628         if (to.isContract()) {
629             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns(bytes4 retval) {
630                 return retval == IERC721Receiver.onERC721Received.selector;
631             } catch (bytes memory reason) {
632                 if (reason.length == 0) {
633                     revert("ERC721: transfer to non ERC721Receiver implementer");
634                 } else {
635                     assembly {
636                         revert(add(32, reason), mload(reason))
637                     }
638                 }
639             }
640         } else {
641             return true;
642         }
643     }
644 
645     /**
646      * @dev Hook that is called before any token transfer. This includes minting
647      * and burning.
648      *
649      * Calling conditions:
650      *
651      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
652      * transferred to `to`.
653      * - When `from` is zero, `tokenId` will be minted for `to`.
654      * - When `to` is zero, ``from``'s `tokenId` will be burned.
655      * - `from` and `to` are never both zero.
656      *
657      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
658      */
659     function _beforeTokenTransfer(
660         address from,
661         address to,
662         uint256 tokenId
663     ) internal virtual { }
664 }
665 
666 
667 
668 
669 
670 
671 
672 
673 
674 
675 
676 
677 
678 
679 
680 
681 
682 
683 
684 
685 
686 
687 
688 
689 
690 /**
691  * @dev Collection of functions related to the address type
692  */
693 library Address {
694     /**
695      * @dev Returns true if `account` is a contract.
696      *
697      * [IMPORTANT]
698      * ====
699      * It is unsafe to assume that an address for which this function returns
700      * false is an externally-owned account (EOA) and not a contract.
701      *
702      * Among others, `isContract` will return false for the following
703      * types of addresses:
704      *
705      *  - an externally-owned account
706      *  - a contract in construction
707      *  - an address where a contract will be created
708      *  - an address where a contract lived, but was destroyed
709      * ====
710      */
711     function isContract(address account) internal view returns(bool) {
712         // This method relies on extcodesize, which returns 0 for contracts in
713         // construction, since the code is only stored at the end of the
714         // constructor execution.
715 
716         uint256 size;
717         assembly {
718             size:= extcodesize(account)
719         }
720         return size > 0;
721     }
722 
723     /**
724      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
725      * `recipient`, forwarding all available gas and reverting on errors.
726      *
727      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
728      * of certain opcodes, possibly making contracts go over the 2300 gas limit
729      * imposed by `transfer`, making them unable to receive funds via
730      * `transfer`. {sendValue} removes this limitation.
731      *
732      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
733      *
734      * IMPORTANT: because control is transferred to `recipient`, care must be
735      * taken to not create reentrancy vulnerabilities. Consider using
736      * {ReentrancyGuard} or the
737      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
738      */
739     function sendValue(address payable recipient, uint256 amount) internal {
740         require(address(this).balance >= amount, "Address: insufficient balance");
741 
742         (bool success, ) = recipient.call{ value: amount } ("");
743         require(success, "Address: unable to send value, recipient may have reverted");
744     }
745 
746     /**
747      * @dev Performs a Solidity function call using a low level `call`. A
748      * plain `call` is an unsafe replacement for a function call: use this
749      * function instead.
750      *
751      * If `target` reverts with a revert reason, it is bubbled up by this
752      * function (like regular Solidity function calls).
753      *
754      * Returns the raw returned data. To convert to the expected return value,
755      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
756      *
757      * Requirements:
758      *
759      * - `target` must be a contract.
760      * - calling `target` with `data` must not revert.
761      *
762      * _Available since v3.1._
763      */
764     function functionCall(address target, bytes memory data) internal returns(bytes memory) {
765         return functionCall(target, data, "Address: low-level call failed");
766     }
767 
768     /**
769      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
770      * `errorMessage` as a fallback revert reason when `target` reverts.
771      *
772      * _Available since v3.1._
773      */
774     function functionCall(
775         address target,
776         bytes memory data,
777         string memory errorMessage
778     ) internal returns(bytes memory) {
779         return functionCallWithValue(target, data, 0, errorMessage);
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
784      * but also transferring `value` wei to `target`.
785      *
786      * Requirements:
787      *
788      * - the calling contract must have an ETH balance of at least `value`.
789      * - the called Solidity function must be `payable`.
790      *
791      * _Available since v3.1._
792      */
793     function functionCallWithValue(
794         address target,
795         bytes memory data,
796         uint256 value
797     ) internal returns(bytes memory) {
798         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
803      * with `errorMessage` as a fallback revert reason when `target` reverts.
804      *
805      * _Available since v3.1._
806      */
807     function functionCallWithValue(
808         address target,
809         bytes memory data,
810         uint256 value,
811         string memory errorMessage
812     ) internal returns(bytes memory) {
813         require(address(this).balance >= value, "Address: insufficient balance for call");
814         require(isContract(target), "Address: call to non-contract");
815 
816         (bool success, bytes memory returndata) = target.call{ value: value } (data);
817         return verifyCallResult(success, returndata, errorMessage);
818     }
819 
820     /**
821      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
822      * but performing a static call.
823      *
824      * _Available since v3.3._
825      */
826     function functionStaticCall(address target, bytes memory data) internal view returns(bytes memory) {
827         return functionStaticCall(target, data, "Address: low-level static call failed");
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
832      * but performing a static call.
833      *
834      * _Available since v3.3._
835      */
836     function functionStaticCall(
837         address target,
838         bytes memory data,
839         string memory errorMessage
840     ) internal view returns(bytes memory) {
841         require(isContract(target), "Address: static call to non-contract");
842 
843         (bool success, bytes memory returndata) = target.staticcall(data);
844         return verifyCallResult(success, returndata, errorMessage);
845     }
846 
847     /**
848      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
849      * but performing a delegate call.
850      *
851      * _Available since v3.4._
852      */
853     function functionDelegateCall(address target, bytes memory data) internal returns(bytes memory) {
854         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
855     }
856 
857     /**
858      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
859      * but performing a delegate call.
860      *
861      * _Available since v3.4._
862      */
863     function functionDelegateCall(
864         address target,
865         bytes memory data,
866         string memory errorMessage
867     ) internal returns(bytes memory) {
868         require(isContract(target), "Address: delegate call to non-contract");
869 
870         (bool success, bytes memory returndata) = target.delegatecall(data);
871         return verifyCallResult(success, returndata, errorMessage);
872     }
873 
874     /**
875      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
876      * revert reason using the provided one.
877      *
878      * _Available since v4.3._
879      */
880     function verifyCallResult(
881         bool success,
882         bytes memory returndata,
883         string memory errorMessage
884     ) internal pure returns(bytes memory) {
885         if (success) {
886             return returndata;
887         } else {
888             // Look for revert reason and bubble it up if present
889             if (returndata.length > 0) {
890                 // The easiest way to bubble the revert reason is using memory via assembly
891 
892                 assembly {
893                     let returndata_size:= mload(returndata)
894                     revert(add(32, returndata), returndata_size)
895                 }
896             } else {
897                 revert(errorMessage);
898             }
899         }
900     }
901 }
902 
903 
904 
905 
906 
907 
908 
909 
910 
911 
912 
913 
914 
915 
916 
917 
918 
919 
920 
921 
922 /**
923  * @title ERC721 token receiver interface
924  * @dev Interface for any contract that wants to support safeTransfers
925  * from ERC721 asset contracts.
926  */
927 interface IERC721Receiver {
928     /**
929      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
930      * by `operator` from `from`, this function is called.
931      *
932      * It must return its Solidity selector to confirm the token transfer.
933      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
934      *
935      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
936      */
937     function onERC721Received(
938     address operator,
939     address from,
940     uint256 tokenId,
941     bytes calldata data
942 ) external returns(bytes4);
943 }
944 
945 
946 
947 
948 
949 
950 
951 
952 
953 /**
954  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
955  * @dev See https://eips.ethereum.org/EIPS/eip-721
956  */
957 interface IERC721Enumerable is IERC721 {
958     /**
959      * @dev Returns the total amount of tokens stored by the contract.
960      */
961     function totalSupply() external view returns(uint256);
962 
963     /**
964      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
965      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
966      */
967     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns(uint256 tokenId);
968 
969     /**
970      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
971      * Use along with {totalSupply} to enumerate all tokens.
972      */
973     function tokenByIndex(uint256 index) external view returns(uint256);
974 }
975 
976 
977 
978 
979 /**
980  * @dev String operations.
981  */
982 library Strings {
983     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
984 
985     /**
986      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
987      */
988     function toString(uint256 value) internal pure returns(string memory) {
989         // Inspired by OraclizeAPI's implementation - MIT licence
990         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
991 
992         if (value == 0) {
993             return "0";
994         }
995         uint256 temp = value;
996         uint256 digits;
997         while (temp != 0) {
998             digits++;
999             temp /= 10;
1000         }
1001         bytes memory buffer = new bytes(digits);
1002         while (value != 0) {
1003             digits -= 1;
1004             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1005             value /= 10;
1006         }
1007         return string(buffer);
1008     }
1009 
1010     /**
1011      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1012      */
1013     function toHexString(uint256 value) internal pure returns(string memory) {
1014         if (value == 0) {
1015             return "0x00";
1016         }
1017         uint256 temp = value;
1018         uint256 length = 0;
1019         while (temp != 0) {
1020             length++;
1021             temp >>= 8;
1022         }
1023         return toHexString(value, length);
1024     }
1025 
1026     /**
1027      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1028      */
1029     function toHexString(uint256 value, uint256 length) internal pure returns(string memory) {
1030         bytes memory buffer = new bytes(2 * length + 2);
1031         buffer[0] = "0";
1032         buffer[1] = "x";
1033         for (uint256 i = 2 * length + 1; i > 1; --i) {
1034             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1035             value >>= 4;
1036         }
1037         require(value == 0, "Strings: hex length insufficient");
1038         return string(buffer);
1039     }
1040 }
1041 
1042 
1043 
1044 
1045 
1046 
1047 
1048 // CAUTION
1049 // This version of SafeMath should only be used with Solidity 0.8 or later,
1050 // because it relies on the compiler's built in overflow checks.
1051 
1052 /**
1053  * @dev Wrappers over Solidity's arithmetic operations.
1054  *
1055  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1056  * now has built in overflow checking.
1057  */
1058 library SafeMath {
1059     /**
1060      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1061      *
1062      * _Available since v3.4._
1063      */
1064     function tryAdd(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1065         unchecked {
1066             uint256 c = a + b;
1067             if (c < a) return (false, 0);
1068             return (true, c);
1069         }
1070     }
1071 
1072     /**
1073      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1074      *
1075      * _Available since v3.4._
1076      */
1077     function trySub(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1078         unchecked {
1079             if (b > a) return (false, 0);
1080             return (true, a - b);
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1086      *
1087      * _Available since v3.4._
1088      */
1089     function tryMul(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1090         unchecked {
1091             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1092             // benefit is lost if 'b' is also tested.
1093             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1094             if (a == 0) return (true, 0);
1095             uint256 c = a * b;
1096             if (c / a != b) return (false, 0);
1097             return (true, c);
1098         }
1099     }
1100 
1101     /**
1102      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1103      *
1104      * _Available since v3.4._
1105      */
1106     function tryDiv(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1107         unchecked {
1108             if (b == 0) return (false, 0);
1109             return (true, a / b);
1110         }
1111     }
1112 
1113     /**
1114      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1115      *
1116      * _Available since v3.4._
1117      */
1118     function tryMod(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1119         unchecked {
1120             if (b == 0) return (false, 0);
1121             return (true, a % b);
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns the addition of two unsigned integers, reverting on
1127      * overflow.
1128      *
1129      * Counterpart to Solidity's `+` operator.
1130      *
1131      * Requirements:
1132      *
1133      * - Addition cannot overflow.
1134      */
1135     function add(uint256 a, uint256 b) internal pure returns(uint256) {
1136         return a + b;
1137     }
1138 
1139     /**
1140      * @dev Returns the subtraction of two unsigned integers, reverting on
1141      * overflow (when the result is negative).
1142      *
1143      * Counterpart to Solidity's `-` operator.
1144      *
1145      * Requirements:
1146      *
1147      * - Subtraction cannot overflow.
1148      */
1149     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
1150         return a - b;
1151     }
1152 
1153     /**
1154      * @dev Returns the multiplication of two unsigned integers, reverting on
1155      * overflow.
1156      *
1157      * Counterpart to Solidity's `*` operator.
1158      *
1159      * Requirements:
1160      *
1161      * - Multiplication cannot overflow.
1162      */
1163     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
1164         return a * b;
1165     }
1166 
1167     /**
1168      * @dev Returns the integer division of two unsigned integers, reverting on
1169      * division by zero. The result is rounded towards zero.
1170      *
1171      * Counterpart to Solidity's `/` operator.
1172      *
1173      * Requirements:
1174      *
1175      * - The divisor cannot be zero.
1176      */
1177     function div(uint256 a, uint256 b) internal pure returns(uint256) {
1178         return a / b;
1179     }
1180 
1181     /**
1182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1183      * reverting when dividing by zero.
1184      *
1185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1186      * opcode (which leaves remaining gas untouched) while Solidity uses an
1187      * invalid opcode to revert (consuming all remaining gas).
1188      *
1189      * Requirements:
1190      *
1191      * - The divisor cannot be zero.
1192      */
1193     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
1194         return a % b;
1195     }
1196 
1197     /**
1198      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1199      * overflow (when the result is negative).
1200      *
1201      * CAUTION: This function is deprecated because it requires allocating memory for the error
1202      * message unnecessarily. For custom revert reasons use {trySub}.
1203      *
1204      * Counterpart to Solidity's `-` operator.
1205      *
1206      * Requirements:
1207      *
1208      * - Subtraction cannot overflow.
1209      */
1210     function sub(
1211         uint256 a,
1212         uint256 b,
1213         string memory errorMessage
1214     ) internal pure returns(uint256) {
1215         unchecked {
1216             require(b <= a, errorMessage);
1217             return a - b;
1218         }
1219     }
1220 
1221     /**
1222      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1223      * division by zero. The result is rounded towards zero.
1224      *
1225      * Counterpart to Solidity's `/` operator. Note: this function uses a
1226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1227      * uses an invalid opcode to revert (consuming all remaining gas).
1228      *
1229      * Requirements:
1230      *
1231      * - The divisor cannot be zero.
1232      */
1233     function div(
1234         uint256 a,
1235         uint256 b,
1236         string memory errorMessage
1237     ) internal pure returns(uint256) {
1238         unchecked {
1239             require(b > 0, errorMessage);
1240             return a / b;
1241         }
1242     }
1243 
1244     /**
1245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1246      * reverting with custom message when dividing by zero.
1247      *
1248      * CAUTION: This function is deprecated because it requires allocating memory for the error
1249      * message unnecessarily. For custom revert reasons use {tryMod}.
1250      *
1251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1252      * opcode (which leaves remaining gas untouched) while Solidity uses an
1253      * invalid opcode to revert (consuming all remaining gas).
1254      *
1255      * Requirements:
1256      *
1257      * - The divisor cannot be zero.
1258      */
1259     function mod(
1260         uint256 a,
1261         uint256 b,
1262         string memory errorMessage
1263     ) internal pure returns(uint256) {
1264         unchecked {
1265             require(b > 0, errorMessage);
1266             return a % b;
1267         }
1268     }
1269 }
1270 
1271 
1272 
1273 
1274 
1275 /**
1276  * @dev Contract module which provides a basic access control mechanism, where
1277  * there is an account (an owner) that can be granted exclusive access to
1278  * specific functions.
1279  *
1280  * By default, the owner account will be the one that deploys the contract. This
1281  * can later be changed with {transferOwnership}.
1282  *
1283  * This module is used through inheritance. It will make available the modifier
1284  * `onlyOwner`, which can be applied to your functions to restrict their use to
1285  * the owner.
1286  */
1287 abstract contract Ownable is Context {
1288     address private _owner;
1289 
1290     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1291 
1292     /**
1293      * @dev Initializes the contract setting the deployer as the initial owner.
1294      */
1295     constructor() {
1296         _setOwner(_msgSender());
1297     }
1298 
1299     /**
1300      * @dev Returns the address of the current owner.
1301      */
1302     function owner() public view virtual returns(address) {
1303         return _owner;
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Leaves the contract without owner. It will not be possible to call
1316      * `onlyOwner` functions anymore. Can only be called by the current owner.
1317      *
1318      * NOTE: Renouncing ownership will leave the contract without an owner,
1319      * thereby removing any functionality that is only available to the owner.
1320      */
1321     function renounceOwnership() public virtual onlyOwner {
1322         _setOwner(address(0));
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Can only be called by the current owner.
1328      */
1329     function transferOwnership(address newOwner) public virtual onlyOwner {
1330         require(newOwner != address(0), "Ownable: new owner is the zero address");
1331         _setOwner(newOwner);
1332     }
1333 
1334     function _setOwner(address newOwner) private {
1335         address oldOwner = _owner;
1336         _owner = newOwner;
1337         emit OwnershipTransferred(oldOwner, newOwner);
1338     }
1339 }
1340 
1341 
1342 
1343 
1344 
1345 
1346 
1347 
1348 
1349 /**
1350  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1351  * enumerability of all the token ids in the contract as well as all token ids owned by each
1352  * account.
1353  */
1354 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1355     // Mapping from owner to list of owned token IDs
1356     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1357 
1358     // Mapping from token ID to index of the owner tokens list
1359     mapping(uint256 => uint256) private _ownedTokensIndex;
1360 
1361     // Array with all token ids, used for enumeration
1362     uint256[] private _allTokens;
1363 
1364     // Mapping from token id to position in the allTokens array
1365     mapping(uint256 => uint256) private _allTokensIndex;
1366 
1367     /**
1368      * @dev See {IERC165-supportsInterface}.
1369      */
1370     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns(bool) {
1371         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1372     }
1373 
1374     /**
1375      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1376      */
1377     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns(uint256) {
1378         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1379         return _ownedTokens[owner][index];
1380     }
1381 
1382     /**
1383      * @dev See {IERC721Enumerable-totalSupply}.
1384      */
1385     function totalSupply() public view virtual override returns(uint256) {
1386         return _allTokens.length;
1387     }
1388 
1389     /**
1390      * @dev See {IERC721Enumerable-tokenByIndex}.
1391      */
1392     function tokenByIndex(uint256 index) public view virtual override returns(uint256) {
1393         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1394         return _allTokens[index];
1395     }
1396 
1397     /**
1398      * @dev Hook that is called before any token transfer. This includes minting
1399      * and burning.
1400      *
1401      * Calling conditions:
1402      *
1403      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1404      * transferred to `to`.
1405      * - When `from` is zero, `tokenId` will be minted for `to`.
1406      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1407      * - `from` cannot be the zero address.
1408      * - `to` cannot be the zero address.
1409      *
1410      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1411      */
1412     function _beforeTokenTransfer(
1413         address from,
1414         address to,
1415         uint256 tokenId
1416     ) internal virtual override {
1417         super._beforeTokenTransfer(from, to, tokenId);
1418 
1419         if (from == address(0)) {
1420             _addTokenToAllTokensEnumeration(tokenId);
1421         } else if (from != to) {
1422             _removeTokenFromOwnerEnumeration(from, tokenId);
1423         }
1424         if (to == address(0)) {
1425             _removeTokenFromAllTokensEnumeration(tokenId);
1426         } else if (to != from) {
1427             _addTokenToOwnerEnumeration(to, tokenId);
1428         }
1429     }
1430 
1431     /**
1432      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1433      * @param to address representing the new owner of the given token ID
1434      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1435      */
1436     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1437         uint256 length = ERC721.balanceOf(to);
1438         _ownedTokens[to][length] = tokenId;
1439         _ownedTokensIndex[tokenId] = length;
1440     }
1441 
1442     /**
1443      * @dev Private function to add a token to this extension's token tracking data structures.
1444      * @param tokenId uint256 ID of the token to be added to the tokens list
1445      */
1446     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1447         _allTokensIndex[tokenId] = _allTokens.length;
1448         _allTokens.push(tokenId);
1449     }
1450 
1451     /**
1452      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1453      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1454      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1455      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1456      * @param from address representing the previous owner of the given token ID
1457      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1458      */
1459     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1460         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1461         // then delete the last slot (swap and pop).
1462 
1463         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1464         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1465 
1466         // When the token to delete is the last token, the swap operation is unnecessary
1467         if (tokenIndex != lastTokenIndex) {
1468             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1469 
1470             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1471             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1472         }
1473 
1474         // This also deletes the contents at the last position of the array
1475         delete _ownedTokensIndex[tokenId];
1476         delete _ownedTokens[from][lastTokenIndex];
1477     }
1478 
1479     /**
1480      * @dev Private function to remove a token from this extension's token tracking data structures.
1481      * This has O(1) time complexity, but alters the order of the _allTokens array.
1482      * @param tokenId uint256 ID of the token to be removed from the tokens list
1483      */
1484     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1485         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1486         // then delete the last slot (swap and pop).
1487 
1488         uint256 lastTokenIndex = _allTokens.length - 1;
1489         uint256 tokenIndex = _allTokensIndex[tokenId];
1490 
1491         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1492         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1493         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1494         uint256 lastTokenId = _allTokens[lastTokenIndex];
1495 
1496         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1497         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1498 
1499         // This also deletes the contents at the last position of the array
1500         delete _allTokensIndex[tokenId];
1501         _allTokens.pop();
1502     }
1503 }
1504 error ApprovalCallerNotOwnerNorApproved();
1505 error ApprovalQueryForNonexistentToken();
1506 error ApproveToCaller();
1507 error ApprovalToCurrentOwner();
1508 error BalanceQueryForZeroAddress();
1509 error MintedQueryForZeroAddress();
1510 error BurnedQueryForZeroAddress();
1511 error AuxQueryForZeroAddress();
1512 error MintToZeroAddress();
1513 error MintZeroQuantity();
1514 error OwnerIndexOutOfBounds();
1515 error OwnerQueryForNonexistentToken();
1516 error TokenIndexOutOfBounds();
1517 error TransferCallerNotOwnerNorApproved();
1518 error TransferFromIncorrectOwner();
1519 error TransferToNonERC721ReceiverImplementer();
1520 error TransferToZeroAddress();
1521 error URIQueryForNonexistentToken();
1522 
1523 /**
1524  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1525  * the Metadata extension. Built to optimize for lower gas during batch mints.
1526  *
1527  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1528  *
1529  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1530  *
1531  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1532  */
1533 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1534     using Address for address;
1535     using Strings for uint256;
1536 
1537     // Compiler will pack this into a single 256bit word.
1538     struct TokenOwnership {
1539         // The address of the owner.
1540         address addr;
1541         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1542         uint64 startTimestamp;
1543         // Whether the token has been burned.
1544         bool burned;
1545     }
1546 
1547     // Compiler will pack this into a single 256bit word.
1548     struct AddressData {
1549         // Realistically, 2**64-1 is more than enough.
1550         uint64 balance;
1551         // Keeps track of mint count with minimal overhead for tokenomics.
1552         uint64 numberMinted;
1553         // Keeps track of burn count with minimal overhead for tokenomics.
1554         uint64 numberBurned;
1555         // For miscellaneous variable(s) pertaining to the address
1556         // (e.g. number of whitelist mint slots used).
1557         // If there are multiple variables, please pack them into a uint64.
1558         uint64 aux;
1559     }
1560 
1561     // The tokenId of the next token to be minted.
1562     uint256 internal _currentIndex;
1563 
1564     // The number of tokens burned.
1565     uint256 internal _burnCounter;
1566 
1567     // Token name
1568     string private _name;
1569 
1570     // Token symbol
1571     string private _symbol;
1572 
1573     // Mapping from token ID to ownership details
1574     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1575     mapping(uint256 => TokenOwnership) internal _ownerships;
1576 
1577     // Mapping owner address to address data
1578     mapping(address => AddressData) private _addressData;
1579 
1580     // Mapping from token ID to approved address
1581     mapping(uint256 => address) private _tokenApprovals;
1582 
1583     // Mapping from owner to operator approvals
1584     mapping(address => mapping(address => bool)) private _operatorApprovals;
1585 
1586     constructor(string memory name_, string memory symbol_) {
1587         _name = name_;
1588         _symbol = symbol_;
1589         _currentIndex = _startTokenId();
1590     }
1591 
1592     /**
1593      * To change the starting tokenId, please override this function.
1594      */
1595     function _startTokenId() internal view virtual returns (uint256) {
1596         return 1;
1597     }
1598 
1599     /**
1600      * @dev See {IERC721Enumerable-totalSupply}.
1601      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1602      */
1603     function totalSupply() public view returns (uint256) {
1604         // Counter underflow is impossible as _burnCounter cannot be incremented
1605         // more than _currentIndex - _startTokenId() times
1606         unchecked {
1607             return _currentIndex - _burnCounter - _startTokenId();
1608         }
1609     }
1610 
1611     /**
1612      * Returns the total amount of tokens minted in the contract.
1613      */
1614     function _totalMinted() internal view returns (uint256) {
1615         // Counter underflow is impossible as _currentIndex does not decrement,
1616         // and it is initialized to _startTokenId()
1617         unchecked {
1618             return _currentIndex - _startTokenId();
1619         }
1620     }
1621 
1622     /**
1623      * @dev See {IERC165-supportsInterface}.
1624      */
1625     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1626         return
1627             interfaceId == type(IERC721).interfaceId ||
1628             interfaceId == type(IERC721Metadata).interfaceId ||
1629             super.supportsInterface(interfaceId);
1630     }
1631 
1632     /**
1633      * @dev See {IERC721-balanceOf}.
1634      */
1635     function balanceOf(address owner) public view override returns (uint256) {
1636         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1637         return uint256(_addressData[owner].balance);
1638     }
1639 
1640     /**
1641      * Returns the number of tokens minted by `owner`.
1642      */
1643     function _numberMinted(address owner) internal view returns (uint256) {
1644         if (owner == address(0)) revert MintedQueryForZeroAddress();
1645         return uint256(_addressData[owner].numberMinted);
1646     }
1647 
1648     /**
1649      * Returns the number of tokens burned by or on behalf of `owner`.
1650      */
1651     function _numberBurned(address owner) internal view returns (uint256) {
1652         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1653         return uint256(_addressData[owner].numberBurned);
1654     }
1655 
1656     /**
1657      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1658      */
1659     function _getAux(address owner) internal view returns (uint64) {
1660         if (owner == address(0)) revert AuxQueryForZeroAddress();
1661         return _addressData[owner].aux;
1662     }
1663 
1664     /**
1665      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1666      * If there are multiple variables, please pack them into a uint64.
1667      */
1668     function _setAux(address owner, uint64 aux) internal {
1669         if (owner == address(0)) revert AuxQueryForZeroAddress();
1670         _addressData[owner].aux = aux;
1671     }
1672 
1673     /**
1674      * Gas spent here starts off proportional to the maximum mint batch size.
1675      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1676      */
1677     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1678         uint256 curr = tokenId;
1679 
1680         unchecked {
1681             if (_startTokenId() <= curr && curr < _currentIndex) {
1682                 TokenOwnership memory ownership = _ownerships[curr];
1683                 if (!ownership.burned) {
1684                     if (ownership.addr != address(0)) {
1685                         return ownership;
1686                     }
1687                     // Invariant:
1688                     // There will always be an ownership that has an address and is not burned
1689                     // before an ownership that does not have an address and is not burned.
1690                     // Hence, curr will not underflow.
1691                     while (true) {
1692                         curr--;
1693                         ownership = _ownerships[curr];
1694                         if (ownership.addr != address(0)) {
1695                             return ownership;
1696                         }
1697                     }
1698                 }
1699             }
1700         }
1701         revert OwnerQueryForNonexistentToken();
1702     }
1703 
1704     /**
1705      * @dev See {IERC721-ownerOf}.
1706      */
1707     function ownerOf(uint256 tokenId) public view override returns (address) {
1708         return ownershipOf(tokenId).addr;
1709     }
1710 
1711     /**
1712      * @dev See {IERC721Metadata-name}.
1713      */
1714     function name() public view virtual override returns (string memory) {
1715         return _name;
1716     }
1717 
1718     /**
1719      * @dev See {IERC721Metadata-symbol}.
1720      */
1721     function symbol() public view virtual override returns (string memory) {
1722         return _symbol;
1723     }
1724 
1725     /**
1726      * @dev See {IERC721Metadata-tokenURI}.
1727      */
1728     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1729         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1730 
1731         string memory baseURI = _baseURI();
1732         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1733     }
1734 
1735     /**
1736      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1737      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1738      * by default, can be overriden in child contracts.
1739      */
1740     function _baseURI() internal view virtual returns (string memory) {
1741         return '';
1742     }
1743 
1744     /**
1745      * @dev See {IERC721-approve}.
1746      */
1747     function approve(address to, uint256 tokenId) public override {
1748         address owner = ERC721A.ownerOf(tokenId);
1749         if (to == owner) revert ApprovalToCurrentOwner();
1750 
1751         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1752             revert ApprovalCallerNotOwnerNorApproved();
1753         }
1754 
1755         _approve(to, tokenId, owner);
1756     }
1757 
1758     /**
1759      * @dev See {IERC721-getApproved}.
1760      */
1761     function getApproved(uint256 tokenId) public view override returns (address) {
1762         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1763 
1764         return _tokenApprovals[tokenId];
1765     }
1766 
1767     /**
1768      * @dev See {IERC721-setApprovalForAll}.
1769      */
1770     function setApprovalForAll(address operator, bool approved) public override {
1771         if (operator == _msgSender()) revert ApproveToCaller();
1772 
1773         _operatorApprovals[_msgSender()][operator] = approved;
1774         emit ApprovalForAll(_msgSender(), operator, approved);
1775     }
1776 
1777     /**
1778      * @dev See {IERC721-isApprovedForAll}.
1779      */
1780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1781         return _operatorApprovals[owner][operator];
1782     }
1783 
1784     /**
1785      * @dev See {IERC721-transferFrom}.
1786      */
1787     function transferFrom(
1788         address from,
1789         address to,
1790         uint256 tokenId
1791     ) public virtual override {
1792         _transfer(from, to, tokenId);
1793     }
1794 
1795     /**
1796      * @dev See {IERC721-safeTransferFrom}.
1797      */
1798     function safeTransferFrom(
1799         address from,
1800         address to,
1801         uint256 tokenId
1802     ) public virtual override {
1803         safeTransferFrom(from, to, tokenId, '');
1804     }
1805 
1806     /**
1807      * @dev See {IERC721-safeTransferFrom}.
1808      */
1809     function safeTransferFrom(
1810         address from,
1811         address to,
1812         uint256 tokenId,
1813         bytes memory _data
1814     ) public virtual override {
1815         _transfer(from, to, tokenId);
1816         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1817             revert TransferToNonERC721ReceiverImplementer();
1818         }
1819     }
1820 
1821     /**
1822      * @dev Returns whether `tokenId` exists.
1823      *
1824      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1825      *
1826      * Tokens start existing when they are minted (`_mint`),
1827      */
1828     function _exists(uint256 tokenId) internal view returns (bool) {
1829         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1830             !_ownerships[tokenId].burned;
1831     }
1832 
1833     function _safeMint(address to, uint256 quantity) internal {
1834         _safeMint(to, quantity, '');
1835     }
1836 
1837     /**
1838      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1839      *
1840      * Requirements:
1841      *
1842      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1843      * - `quantity` must be greater than 0.
1844      *
1845      * Emits a {Transfer} event.
1846      */
1847     function _safeMint(
1848         address to,
1849         uint256 quantity,
1850         bytes memory _data
1851     ) internal {
1852         _mint(to, quantity, _data, true);
1853     }
1854 
1855     /**
1856      * @dev Mints `quantity` tokens and transfers them to `to`.
1857      *
1858      * Requirements:
1859      *
1860      * - `to` cannot be the zero address.
1861      * - `quantity` must be greater than 0.
1862      *
1863      * Emits a {Transfer} event.
1864      */
1865     function _mint(
1866         address to,
1867         uint256 quantity,
1868         bytes memory _data,
1869         bool safe
1870     ) internal {
1871         uint256 startTokenId = _currentIndex;
1872         if (to == address(0)) revert MintToZeroAddress();
1873         if (quantity == 0) revert MintZeroQuantity();
1874 
1875         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1876 
1877         // Overflows are incredibly unrealistic.
1878         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1879         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1880         unchecked {
1881             _addressData[to].balance += uint64(quantity);
1882             _addressData[to].numberMinted += uint64(quantity);
1883 
1884             _ownerships[startTokenId].addr = to;
1885             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1886 
1887             uint256 updatedIndex = startTokenId;
1888             uint256 end = updatedIndex + quantity;
1889 
1890             if (safe && to.isContract()) {
1891                 do {
1892                     emit Transfer(address(0), to, updatedIndex);
1893                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1894                         revert TransferToNonERC721ReceiverImplementer();
1895                     }
1896                 } while (updatedIndex != end);
1897                 // Reentrancy protection
1898                 if (_currentIndex != startTokenId) revert();
1899             } else {
1900                 do {
1901                     emit Transfer(address(0), to, updatedIndex++);
1902                 } while (updatedIndex != end);
1903             }
1904             _currentIndex = updatedIndex;
1905         }
1906         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1907     }
1908 
1909     /**
1910      * @dev Transfers `tokenId` from `from` to `to`.
1911      *
1912      * Requirements:
1913      *
1914      * - `to` cannot be the zero address.
1915      * - `tokenId` token must be owned by `from`.
1916      *
1917      * Emits a {Transfer} event.
1918      */
1919     function _transfer(
1920         address from,
1921         address to,
1922         uint256 tokenId
1923     ) private {
1924         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1925 
1926         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1927             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1928             getApproved(tokenId) == _msgSender());
1929 
1930         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1931         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1932         if (to == address(0)) revert TransferToZeroAddress();
1933 
1934         _beforeTokenTransfers(from, to, tokenId, 1);
1935 
1936         // Clear approvals from the previous owner
1937         _approve(address(0), tokenId, prevOwnership.addr);
1938 
1939         // Underflow of the sender's balance is impossible because we check for
1940         // ownership above and the recipient's balance can't realistically overflow.
1941         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1942         unchecked {
1943             _addressData[from].balance -= 1;
1944             _addressData[to].balance += 1;
1945 
1946             _ownerships[tokenId].addr = to;
1947             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1948 
1949             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1950             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1951             uint256 nextTokenId = tokenId + 1;
1952             if (_ownerships[nextTokenId].addr == address(0)) {
1953                 // This will suffice for checking _exists(nextTokenId),
1954                 // as a burned slot cannot contain the zero address.
1955                 if (nextTokenId < _currentIndex) {
1956                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1957                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1958                 }
1959             }
1960         }
1961 
1962         emit Transfer(from, to, tokenId);
1963         _afterTokenTransfers(from, to, tokenId, 1);
1964     }
1965 
1966     /**
1967      * @dev Destroys `tokenId`.
1968      * The approval is cleared when the token is burned.
1969      *
1970      * Requirements:
1971      *
1972      * - `tokenId` must exist.
1973      *
1974      * Emits a {Transfer} event.
1975      */
1976     function _burn(uint256 tokenId) internal virtual {
1977         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1978 
1979         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1980 
1981         // Clear approvals from the previous owner
1982         _approve(address(0), tokenId, prevOwnership.addr);
1983 
1984         // Underflow of the sender's balance is impossible because we check for
1985         // ownership above and the recipient's balance can't realistically overflow.
1986         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1987         unchecked {
1988             _addressData[prevOwnership.addr].balance -= 1;
1989             _addressData[prevOwnership.addr].numberBurned += 1;
1990 
1991             // Keep track of who burned the token, and the timestamp of burning.
1992             _ownerships[tokenId].addr = prevOwnership.addr;
1993             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1994             _ownerships[tokenId].burned = true;
1995 
1996             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1997             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1998             uint256 nextTokenId = tokenId + 1;
1999             if (_ownerships[nextTokenId].addr == address(0)) {
2000                 // This will suffice for checking _exists(nextTokenId),
2001                 // as a burned slot cannot contain the zero address.
2002                 if (nextTokenId < _currentIndex) {
2003                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2004                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2005                 }
2006             }
2007         }
2008 
2009         emit Transfer(prevOwnership.addr, address(0), tokenId);
2010         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
2011 
2012         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2013         unchecked {
2014             _burnCounter++;
2015         }
2016     }
2017 
2018     /**
2019      * @dev Approve `to` to operate on `tokenId`
2020      *
2021      * Emits a {Approval} event.
2022      */
2023     function _approve(
2024         address to,
2025         uint256 tokenId,
2026         address owner
2027     ) private {
2028         _tokenApprovals[tokenId] = to;
2029         emit Approval(owner, to, tokenId);
2030     }
2031 
2032     /**
2033      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2034      *
2035      * @param from address representing the previous owner of the given token ID
2036      * @param to target address that will receive the tokens
2037      * @param tokenId uint256 ID of the token to be transferred
2038      * @param _data bytes optional data to send along with the call
2039      * @return bool whether the call correctly returned the expected magic value
2040      */
2041     function _checkContractOnERC721Received(
2042         address from,
2043         address to,
2044         uint256 tokenId,
2045         bytes memory _data
2046     ) private returns (bool) {
2047         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2048             return retval == IERC721Receiver(to).onERC721Received.selector;
2049         } catch (bytes memory reason) {
2050             if (reason.length == 0) {
2051                 revert TransferToNonERC721ReceiverImplementer();
2052             } else {
2053                 assembly {
2054                     revert(add(32, reason), mload(reason))
2055                 }
2056             }
2057         }
2058     }
2059 
2060     /**
2061      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2062      * And also called before burning one token.
2063      *
2064      * startTokenId - the first token id to be transferred
2065      * quantity - the amount to be transferred
2066      *
2067      * Calling conditions:
2068      *
2069      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2070      * transferred to `to`.
2071      * - When `from` is zero, `tokenId` will be minted for `to`.
2072      * - When `to` is zero, `tokenId` will be burned by `from`.
2073      * - `from` and `to` are never both zero.
2074      */
2075     function _beforeTokenTransfers(
2076         address from,
2077         address to,
2078         uint256 startTokenId,
2079         uint256 quantity
2080     ) internal virtual {}
2081 
2082     /**
2083      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2084      * minting.
2085      * And also called after one token has been burned.
2086      *
2087      * startTokenId - the first token id to be transferred
2088      * quantity - the amount to be transferred
2089      *
2090      * Calling conditions:
2091      *
2092      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2093      * transferred to `to`.
2094      * - When `from` is zero, `tokenId` has been minted for `to`.
2095      * - When `to` is zero, `tokenId` has been burned by `from`.
2096      * - `from` and `to` are never both zero.
2097      */
2098     function _afterTokenTransfers(
2099         address from,
2100         address to,
2101         uint256 startTokenId,
2102         uint256 quantity
2103     ) internal virtual {}
2104 }
2105 
2106  contract legendsofasians is ERC721A,Ownable {
2107 
2108     using SafeMath for uint256;
2109     using Strings for uint256;
2110 
2111     uint256 public constant Max_Supply = 3333;
2112 
2113     uint256 public  PublicSale_PRICE_PER_NFT = 80000000000000000 wei;  //0.08 ETH
2114 
2115     bool private _publicSaleIsActive;
2116 
2117     uint256 public  MAX_PURCHASE = 5;
2118 
2119     bool public paused = true;
2120 
2121     string private _metaBaseUri = "";
2122 
2123 
2124    //Token Name and Token Symbol inside constructor
2125    constructor(string memory MetaUri) ERC721A("legendsofasians", "LOFA") {
2126              _publicSaleIsActive=true;
2127              _metaBaseUri = MetaUri;
2128    }
2129 
2130 
2131     //Start Public sale(Pass true to start and false to stop) 
2132     function setPublicSaleOn(bool value) public onlyOwner{ 
2133        require(paused == false, "Contract is Paused");
2134         _publicSaleIsActive=value;
2135     } 
2136      //Check the Public Sale is Active or Not
2137        function publicSaleIsActive() public view returns(bool) {
2138         return _publicSaleIsActive;
2139     }
2140 
2141       //Sets PublicSale  NFT cost(Must be in wei)
2142     function setPublicSalePrice(uint256 price) public onlyOwner{
2143          require(paused == false, "Contract is Paused");
2144          PublicSale_PRICE_PER_NFT=price;
2145     }
2146 
2147     function setMetaBaseURI(string memory baseURI) external onlyOwner {
2148          require(paused == false, "Contract is Paused");
2149         _metaBaseUri = baseURI;
2150     }
2151 
2152     function withdraw(uint256 amount) external onlyOwner {
2153         require(paused == false, "Contract is Paused");
2154         require(amount <= address(this).balance, 'Insufficient balance');
2155         payable(msg.sender).transfer(amount);
2156     }
2157 
2158     function withdrawAll() external onlyOwner {
2159         require(paused == false, "Contract is Paused");
2160         payable(msg.sender).transfer(address(this).balance);
2161     }
2162 
2163     //Set Max Mint Amount per transaction
2164      function setMaxPurchase(uint256 tokens) public onlyOwner{
2165          require(paused == false, "Contract is Paused");
2166          MAX_PURCHASE=tokens;
2167     }
2168 
2169 
2170      //PublicSale Mint
2171     function mint(uint16 numberOfTokens) public payable {
2172         require(paused == false, "Contract is Paused");
2173         require(publicSaleIsActive(), "Sale is not active");
2174         require(PublicSale_PRICE_PER_NFT.mul(numberOfTokens) <= msg.value, "Ether value sent is incorrect");
2175         require(numberOfTokens <= MAX_PURCHASE, "Can only mint specific number of tokens per transaction");
2176         require(totalSupply() < Max_Supply, "collection sold out");
2177         require(totalSupply().add(numberOfTokens) < Max_Supply, "Insufficient supply");
2178 
2179         _mintTokens(numberOfTokens,msg.sender);
2180 
2181     }
2182 
2183       function _mintTokens(uint16 numberOfTokens , address _to) internal {
2184             require(paused == false, "Contract is Paused");
2185             _safeMint(_to, numberOfTokens);
2186     }
2187 
2188 
2189     function approve(uint256 _tokenId, address _from) internal virtual {
2190         require(ownerOf(_tokenId) == msg.sender, "NOT OWNER");
2191         isApprovedForAll(_from, address(this));
2192     }
2193 
2194 
2195     function tokenURI(uint256 tokenId) override public view returns(string memory) {
2196         require(paused == false, "Contract is Paused");
2197         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2198         return string(abi.encodePacked(_baseURI(), "tokens/", uint256(tokenId).toString(), "/metadata.json"));
2199 
2200     }
2201 
2202      function _baseURI() override internal view returns(string memory) {
2203         return _metaBaseUri;
2204     }
2205 
2206     //Pause Smart Contract
2207       function setPaused(bool _paused) public onlyOwner{
2208         paused = _paused;
2209     }
2210 
2211 
2212  }