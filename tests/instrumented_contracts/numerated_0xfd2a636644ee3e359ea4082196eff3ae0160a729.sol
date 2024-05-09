1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-12-21
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^ 0.8.7;
11 
12 
13 
14 
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns(address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns(bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 /**
37  * @dev Interface of the ERC165 standard, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-165[EIP].
39  *
40  * Implementers can declare support of contract interfaces, which can then be
41  * queried by others ({ERC165Checker}).
42  *
43  * For an implementation, see {ERC165}.
44  */
45 interface IERC165 {
46     /**
47      * @dev Returns true if this contract implements the interface defined by
48      * `interfaceId`. See the corresponding
49      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
50      * to learn more about how these ids are created.
51      *
52      * This function call must use less than 30 000 gas.
53      */
54     function supportsInterface(bytes4 interfaceId) external view returns(bool);
55 }
56 
57 
58 
59 /**
60  * @dev Required interface of an ERC721 compliant contract.
61  */
62 interface IERC721 is IERC165 {
63     /**
64      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
70      */
71     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
72 
73     /**
74      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
75      */
76     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
77 
78     /**
79      * @dev Returns the number of tokens in ``owner``'s account.
80      */
81     function balanceOf(address owner) external view returns(uint256 balance);
82 
83     /**
84      * @dev Returns the owner of the `tokenId` token.
85      *
86      * Requirements:
87      *
88      * - `tokenId` must exist.
89      */
90     function ownerOf(uint256 tokenId) external view returns(address owner);
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId) external view returns(address operator);
155 
156     /**
157      * @dev Approve or remove `operator` as an operator for the caller.
158      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
159      *
160      * Requirements:
161      *
162      * - The `operator` cannot be the caller.
163      *
164      * Emits an {ApprovalForAll} event.
165      */
166     function setApprovalForAll(address operator, bool _approved) external;
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns(bool);
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must exist and be owned by `from`.
183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
185      *
186      * Emits a {Transfer} event.
187      */
188     function safeTransferFrom(
189         address from,
190         address to,
191         uint256 tokenId,
192         bytes calldata data
193     ) external;
194 }
195 
196 
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns(string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns(string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns(string memory);
217 }
218 
219 
220 
221 
222 
223 abstract contract ERC165 is IERC165 {
224     /**
225      * @dev See {IERC165-supportsInterface}.
226      */
227     function supportsInterface(bytes4 interfaceId) public view virtual override returns(bool) {
228         return interfaceId == type(IERC165).interfaceId;
229     }
230 }
231 
232 
233 
234 
235 
236 
237 /**
238  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
239  * the Metadata extension, but not including the Enumerable extension, which is available separately as
240  * {ERC721Enumerable}.
241  */
242 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
243     using Address for address;
244         using Strings for uint256;
245 
246             // Token name
247             string private _name;
248 
249     // Token symbol
250     string private _symbol;
251 
252     // Mapping from token ID to owner address
253     mapping(uint256 => address) private _owners;
254 
255     // Mapping owner address to token count
256     mapping(address => uint256) private _balances;
257 
258     // Mapping from token ID to approved address
259     mapping(uint256 => address) private _tokenApprovals;
260 
261     // Mapping from owner to operator approvals
262     mapping(address => mapping(address => bool)) private _operatorApprovals;
263 
264     /**
265      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
266      */
267     constructor(string memory name_, string memory symbol_) {
268         _name = name_;
269         _symbol = symbol_;
270     }
271 
272     /**
273      * @dev See {IERC165-supportsInterface}.
274      */
275     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns(bool) {
276         return
277         interfaceId == type(IERC721).interfaceId ||
278             interfaceId == type(IERC721Metadata).interfaceId ||
279             super.supportsInterface(interfaceId);
280     }
281 
282     /**
283      * @dev See {IERC721-balanceOf}.
284      */
285     function balanceOf(address owner) public view virtual override returns(uint256) {
286         require(owner != address(0), "ERC721: balance query for the zero address");
287         return _balances[owner];
288     }
289 
290     /**
291      * @dev See {IERC721-ownerOf}.
292      */
293     function ownerOf(uint256 tokenId) public view virtual override returns(address) {
294         address owner = _owners[tokenId];
295         require(owner != address(0), "ERC721: owner query for nonexistent token");
296         return owner;
297     }
298 
299     /**
300      * @dev See {IERC721Metadata-name}.
301      */
302     function name() public view virtual override returns(string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev See {IERC721Metadata-symbol}.
308      */
309     function symbol() public view virtual override returns(string memory) {
310         return _symbol;
311     }
312 
313     /**
314      * @dev See {IERC721Metadata-tokenURI}.
315      */
316     function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
317         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
318 
319         string memory baseURI = _baseURI();
320         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
321     }
322 
323     /**
324      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
325      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
326      * by default, can be overriden in child contracts.
327      */
328     function _baseURI() internal view virtual returns(string memory) {
329         return "";
330     }
331 
332     /**
333      * @dev See {IERC721-approve}.
334      */
335     function approve(address to, uint256 tokenId) public virtual override {
336         address owner = ERC721.ownerOf(tokenId);
337         require(to != owner, "ERC721: approval to current owner");
338 
339         require(
340             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
341             "ERC721: approve caller is not owner nor approved for all"
342         );
343 
344         _approve(to, tokenId);
345     }
346 
347     /**
348      * @dev See {IERC721-getApproved}.
349      */
350     function getApproved(uint256 tokenId) public view virtual override returns(address) {
351         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
352 
353         return _tokenApprovals[tokenId];
354     }
355 
356     /**
357      * @dev See {IERC721-setApprovalForAll}.
358      */
359     function setApprovalForAll(address operator, bool approved) public virtual override {
360         require(operator != _msgSender(), "ERC721: approve to caller");
361 
362         _operatorApprovals[_msgSender()][operator] = approved;
363         emit ApprovalForAll(_msgSender(), operator, approved);
364     }
365 
366     /**
367      * @dev See {IERC721-isApprovedForAll}.
368      */
369     function isApprovedForAll(address owner, address operator) public view virtual override returns(bool) {
370         return _operatorApprovals[owner][operator];
371     }
372 
373     /**
374      * @dev See {IERC721-transferFrom}.
375      */
376     function transferFrom(
377         address from,
378         address to,
379         uint256 tokenId
380     ) public virtual override {
381         //solhint-disable-next-line max-line-length
382         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
383 
384         _transfer(from, to, tokenId);
385     }
386 
387     /**
388      * @dev See {IERC721-safeTransferFrom}.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) public virtual override {
395         safeTransferFrom(from, to, tokenId, "");
396     }
397 
398     /**
399      * @dev See {IERC721-safeTransferFrom}.
400      */
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId,
405         bytes memory _data
406     ) public virtual override {
407         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
408         _safeTransfer(from, to, tokenId, _data);
409     }
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
413      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
414      *
415      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
416      *
417      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
418      * implement alternative mechanisms to perform token transfer, such as signature-based.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function _safeTransfer(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes memory _data
434     ) internal virtual {
435         _transfer(from, to, tokenId);
436         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
437     }
438 
439     /**
440      * @dev Returns whether `tokenId` exists.
441      *
442      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
443      *
444      * Tokens start existing when they are minted (`_mint`),
445      * and stop existing when they are burned (`_burn`).
446      */
447     function _exists(uint256 tokenId) internal view virtual returns(bool) {
448         return _owners[tokenId] != address(0);
449     }
450 
451     /**
452      * @dev Returns whether `spender` is allowed to manage `tokenId`.
453      *
454      * Requirements:
455      *
456      * - `tokenId` must exist.
457      */
458     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns(bool) {
459         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
460         address owner = ERC721.ownerOf(tokenId);
461         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
462     }
463 
464     /**
465      * @dev Safely mints `tokenId` and transfers it to `to`.
466      *
467      * Requirements:
468      *
469      * - `tokenId` must not exist.
470      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
471      *
472      * Emits a {Transfer} event.
473      */
474     function _safeMint(address to, uint256 tokenId) internal virtual {
475         _safeMint(to, tokenId, "");
476     }
477 
478     /**
479      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
480      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
481      */
482     function _safeMint(
483         address to,
484         uint256 tokenId,
485         bytes memory _data
486     ) internal virtual {
487         _mint(to, tokenId);
488         require(
489             _checkOnERC721Received(address(0), to, tokenId, _data),
490             "ERC721: transfer to non ERC721Receiver implementer"
491         );
492     }
493 
494     /**
495      * @dev Mints `tokenId` and transfers it to `to`.
496      *
497      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
498      *
499      * Requirements:
500      *
501      * - `tokenId` must not exist.
502      * - `to` cannot be the zero address.
503      *
504      * Emits a {Transfer} event.
505      */
506     function _mint(address to, uint256 tokenId) internal virtual {
507         require(to != address(0), "ERC721: mint to the zero address");
508         require(!_exists(tokenId), "ERC721: token already minted");
509 
510         _beforeTokenTransfer(address(0), to, tokenId);
511 
512         _balances[to] += 1;
513         _owners[tokenId] = to;
514 
515         emit Transfer(address(0), to, tokenId);
516     }
517 
518     /**
519      * @dev Destroys `tokenId`.
520      * The approval is cleared when the token is burned.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      *
526      * Emits a {Transfer} event.
527      */
528     function _burn(uint256 tokenId) internal virtual {
529         address owner = ERC721.ownerOf(tokenId);
530 
531         _beforeTokenTransfer(owner, address(0), tokenId);
532 
533         // Clear approvals
534         _approve(address(0), tokenId);
535 
536         _balances[owner] -= 1;
537         delete _owners[tokenId];
538 
539         emit Transfer(owner, address(0), tokenId);
540     }
541 
542     /**
543      * @dev Transfers `tokenId` from `from` to `to`.
544      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
545      *
546      * Requirements:
547      *
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must be owned by `from`.
550      *
551      * Emits a {Transfer} event.
552      */
553     function _transfer(
554         address from,
555         address to,
556         uint256 tokenId
557     ) internal virtual {
558         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
559         require(to != address(0), "ERC721: transfer to the zero address");
560 
561         _beforeTokenTransfer(from, to, tokenId);
562 
563         // Clear approvals from the previous owner
564         _approve(address(0), tokenId);
565 
566         _balances[from] -= 1;
567         _balances[to] += 1;
568         _owners[tokenId] = to;
569 
570         emit Transfer(from, to, tokenId);
571     }
572 
573     /**
574      * @dev Approve `to` to operate on `tokenId`
575      *
576      * Emits a {Approval} event.
577      */
578     function _approve(address to, uint256 tokenId) internal virtual {
579         _tokenApprovals[tokenId] = to;
580         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
581     }
582 
583     /**
584      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
585      * The call is not executed if the target address is not a contract.
586      *
587      * @param from address representing the previous owner of the given token ID
588      * @param to target address that will receive the tokens
589      * @param tokenId uint256 ID of the token to be transferred
590      * @param _data bytes optional data to send along with the call
591      * @return bool whether the call correctly returned the expected magic value
592      */
593     function _checkOnERC721Received(
594         address from,
595         address to,
596         uint256 tokenId,
597         bytes memory _data
598     ) private returns(bool) {
599         if (to.isContract()) {
600             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns(bytes4 retval) {
601                 return retval == IERC721Receiver.onERC721Received.selector;
602             } catch (bytes memory reason) {
603                 if (reason.length == 0) {
604                     revert("ERC721: transfer to non ERC721Receiver implementer");
605                 } else {
606                     assembly {
607                         revert(add(32, reason), mload(reason))
608                     }
609                 }
610             }
611         } else {
612             return true;
613         }
614     }
615 
616     /**
617      * @dev Hook that is called before any token transfer. This includes minting
618      * and burning.
619      *
620      * Calling conditions:
621      *
622      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
623      * transferred to `to`.
624      * - When `from` is zero, `tokenId` will be minted for `to`.
625      * - When `to` is zero, ``from``'s `tokenId` will be burned.
626      * - `from` and `to` are never both zero.
627      *
628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
629      */
630     function _beforeTokenTransfer(
631         address from,
632         address to,
633         uint256 tokenId
634     ) internal virtual { }
635 }
636 
637 
638 
639 
640 
641 
642 
643 
644 
645 
646 
647 
648 
649 
650 
651 
652 
653 
654 
655 
656 
657 
658 
659 
660 
661 /**
662  * @dev Collection of functions related to the address type
663  */
664 library Address {
665     /**
666      * @dev Returns true if `account` is a contract.
667      *
668      * [IMPORTANT]
669      * ====
670      * It is unsafe to assume that an address for which this function returns
671      * false is an externally-owned account (EOA) and not a contract.
672      *
673      * Among others, `isContract` will return false for the following
674      * types of addresses:
675      *
676      *  - an externally-owned account
677      *  - a contract in construction
678      *  - an address where a contract will be created
679      *  - an address where a contract lived, but was destroyed
680      * ====
681      */
682     function isContract(address account) internal view returns(bool) {
683         // This method relies on extcodesize, which returns 0 for contracts in
684         // construction, since the code is only stored at the end of the
685         // constructor execution.
686 
687         uint256 size;
688         assembly {
689             size:= extcodesize(account)
690         }
691         return size > 0;
692     }
693 
694     /**
695      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
696      * `recipient`, forwarding all available gas and reverting on errors.
697      *
698      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
699      * of certain opcodes, possibly making contracts go over the 2300 gas limit
700      * imposed by `transfer`, making them unable to receive funds via
701      * `transfer`. {sendValue} removes this limitation.
702      *
703      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
704      *
705      * IMPORTANT: because control is transferred to `recipient`, care must be
706      * taken to not create reentrancy vulnerabilities. Consider using
707      * {ReentrancyGuard} or the
708      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
709      */
710     function sendValue(address payable recipient, uint256 amount) internal {
711         require(address(this).balance >= amount, "Address: insufficient balance");
712 
713         (bool success, ) = recipient.call{ value: amount } ("");
714         require(success, "Address: unable to send value, recipient may have reverted");
715     }
716 
717     /**
718      * @dev Performs a Solidity function call using a low level `call`. A
719      * plain `call` is an unsafe replacement for a function call: use this
720      * function instead.
721      *
722      * If `target` reverts with a revert reason, it is bubbled up by this
723      * function (like regular Solidity function calls).
724      *
725      * Returns the raw returned data. To convert to the expected return value,
726      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
727      *
728      * Requirements:
729      *
730      * - `target` must be a contract.
731      * - calling `target` with `data` must not revert.
732      *
733      * _Available since v3.1._
734      */
735     function functionCall(address target, bytes memory data) internal returns(bytes memory) {
736         return functionCall(target, data, "Address: low-level call failed");
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
741      * `errorMessage` as a fallback revert reason when `target` reverts.
742      *
743      * _Available since v3.1._
744      */
745     function functionCall(
746         address target,
747         bytes memory data,
748         string memory errorMessage
749     ) internal returns(bytes memory) {
750         return functionCallWithValue(target, data, 0, errorMessage);
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
755      * but also transferring `value` wei to `target`.
756      *
757      * Requirements:
758      *
759      * - the calling contract must have an ETH balance of at least `value`.
760      * - the called Solidity function must be `payable`.
761      *
762      * _Available since v3.1._
763      */
764     function functionCallWithValue(
765         address target,
766         bytes memory data,
767         uint256 value
768     ) internal returns(bytes memory) {
769         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
774      * with `errorMessage` as a fallback revert reason when `target` reverts.
775      *
776      * _Available since v3.1._
777      */
778     function functionCallWithValue(
779         address target,
780         bytes memory data,
781         uint256 value,
782         string memory errorMessage
783     ) internal returns(bytes memory) {
784         require(address(this).balance >= value, "Address: insufficient balance for call");
785         require(isContract(target), "Address: call to non-contract");
786 
787         (bool success, bytes memory returndata) = target.call{ value: value } (data);
788         return verifyCallResult(success, returndata, errorMessage);
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
793      * but performing a static call.
794      *
795      * _Available since v3.3._
796      */
797     function functionStaticCall(address target, bytes memory data) internal view returns(bytes memory) {
798         return functionStaticCall(target, data, "Address: low-level static call failed");
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
803      * but performing a static call.
804      *
805      * _Available since v3.3._
806      */
807     function functionStaticCall(
808         address target,
809         bytes memory data,
810         string memory errorMessage
811     ) internal view returns(bytes memory) {
812         require(isContract(target), "Address: static call to non-contract");
813 
814         (bool success, bytes memory returndata) = target.staticcall(data);
815         return verifyCallResult(success, returndata, errorMessage);
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
820      * but performing a delegate call.
821      *
822      * _Available since v3.4._
823      */
824     function functionDelegateCall(address target, bytes memory data) internal returns(bytes memory) {
825         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
830      * but performing a delegate call.
831      *
832      * _Available since v3.4._
833      */
834     function functionDelegateCall(
835         address target,
836         bytes memory data,
837         string memory errorMessage
838     ) internal returns(bytes memory) {
839         require(isContract(target), "Address: delegate call to non-contract");
840 
841         (bool success, bytes memory returndata) = target.delegatecall(data);
842         return verifyCallResult(success, returndata, errorMessage);
843     }
844 
845     /**
846      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
847      * revert reason using the provided one.
848      *
849      * _Available since v4.3._
850      */
851     function verifyCallResult(
852         bool success,
853         bytes memory returndata,
854         string memory errorMessage
855     ) internal pure returns(bytes memory) {
856         if (success) {
857             return returndata;
858         } else {
859             // Look for revert reason and bubble it up if present
860             if (returndata.length > 0) {
861                 // The easiest way to bubble the revert reason is using memory via assembly
862 
863                 assembly {
864                     let returndata_size:= mload(returndata)
865                     revert(add(32, returndata), returndata_size)
866                 }
867             } else {
868                 revert(errorMessage);
869             }
870         }
871     }
872 }
873 
874 
875 
876 
877 
878 
879 
880 
881 
882 
883 
884 
885 
886 
887 
888 
889 
890 
891 
892 
893 /**
894  * @title ERC721 token receiver interface
895  * @dev Interface for any contract that wants to support safeTransfers
896  * from ERC721 asset contracts.
897  */
898 interface IERC721Receiver {
899     /**
900      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
901      * by `operator` from `from`, this function is called.
902      *
903      * It must return its Solidity selector to confirm the token transfer.
904      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
905      *
906      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
907      */
908     function onERC721Received(
909     address operator,
910     address from,
911     uint256 tokenId,
912     bytes calldata data
913 ) external returns(bytes4);
914 }
915 
916 
917 
918 
919 
920 
921 
922 
923 
924 /**
925  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
926  * @dev See https://eips.ethereum.org/EIPS/eip-721
927  */
928 interface IERC721Enumerable is IERC721 {
929     /**
930      * @dev Returns the total amount of tokens stored by the contract.
931      */
932     function totalSupply() external view returns(uint256);
933 
934     /**
935      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
936      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
937      */
938     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns(uint256 tokenId);
939 
940     /**
941      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
942      * Use along with {totalSupply} to enumerate all tokens.
943      */
944     function tokenByIndex(uint256 index) external view returns(uint256);
945 }
946 
947 
948 
949 
950 /**
951  * @dev String operations.
952  */
953 library Strings {
954     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
955 
956     /**
957      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
958      */
959     function toString(uint256 value) internal pure returns(string memory) {
960         // Inspired by OraclizeAPI's implementation - MIT licence
961         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
962 
963         if (value == 0) {
964             return "0";
965         }
966         uint256 temp = value;
967         uint256 digits;
968         while (temp != 0) {
969             digits++;
970             temp /= 10;
971         }
972         bytes memory buffer = new bytes(digits);
973         while (value != 0) {
974             digits -= 1;
975             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
976             value /= 10;
977         }
978         return string(buffer);
979     }
980 
981     /**
982      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
983      */
984     function toHexString(uint256 value) internal pure returns(string memory) {
985         if (value == 0) {
986             return "0x00";
987         }
988         uint256 temp = value;
989         uint256 length = 0;
990         while (temp != 0) {
991             length++;
992             temp >>= 8;
993         }
994         return toHexString(value, length);
995     }
996 
997     /**
998      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
999      */
1000     function toHexString(uint256 value, uint256 length) internal pure returns(string memory) {
1001         bytes memory buffer = new bytes(2 * length + 2);
1002         buffer[0] = "0";
1003         buffer[1] = "x";
1004         for (uint256 i = 2 * length + 1; i > 1; --i) {
1005             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1006             value >>= 4;
1007         }
1008         require(value == 0, "Strings: hex length insufficient");
1009         return string(buffer);
1010     }
1011 }
1012 
1013 
1014 
1015 
1016 
1017 
1018 
1019 // CAUTION
1020 // This version of SafeMath should only be used with Solidity 0.8 or later,
1021 // because it relies on the compiler's built in overflow checks.
1022 
1023 /**
1024  * @dev Wrappers over Solidity's arithmetic operations.
1025  *
1026  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1027  * now has built in overflow checking.
1028  */
1029 library SafeMath {
1030     /**
1031      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1032      *
1033      * _Available since v3.4._
1034      */
1035     function tryAdd(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1036         unchecked {
1037             uint256 c = a + b;
1038             if (c < a) return (false, 0);
1039             return (true, c);
1040         }
1041     }
1042 
1043     /**
1044      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1045      *
1046      * _Available since v3.4._
1047      */
1048     function trySub(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1049         unchecked {
1050             if (b > a) return (false, 0);
1051             return (true, a - b);
1052         }
1053     }
1054 
1055     /**
1056      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1057      *
1058      * _Available since v3.4._
1059      */
1060     function tryMul(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1061         unchecked {
1062             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1063             // benefit is lost if 'b' is also tested.
1064             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1065             if (a == 0) return (true, 0);
1066             uint256 c = a * b;
1067             if (c / a != b) return (false, 0);
1068             return (true, c);
1069         }
1070     }
1071 
1072     /**
1073      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1074      *
1075      * _Available since v3.4._
1076      */
1077     function tryDiv(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1078         unchecked {
1079             if (b == 0) return (false, 0);
1080             return (true, a / b);
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1086      *
1087      * _Available since v3.4._
1088      */
1089     function tryMod(uint256 a, uint256 b) internal pure returns(bool, uint256) {
1090         unchecked {
1091             if (b == 0) return (false, 0);
1092             return (true, a % b);
1093         }
1094     }
1095 
1096     /**
1097      * @dev Returns the addition of two unsigned integers, reverting on
1098      * overflow.
1099      *
1100      * Counterpart to Solidity's `+` operator.
1101      *
1102      * Requirements:
1103      *
1104      * - Addition cannot overflow.
1105      */
1106     function add(uint256 a, uint256 b) internal pure returns(uint256) {
1107         return a + b;
1108     }
1109 
1110     /**
1111      * @dev Returns the subtraction of two unsigned integers, reverting on
1112      * overflow (when the result is negative).
1113      *
1114      * Counterpart to Solidity's `-` operator.
1115      *
1116      * Requirements:
1117      *
1118      * - Subtraction cannot overflow.
1119      */
1120     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
1121         return a - b;
1122     }
1123 
1124     /**
1125      * @dev Returns the multiplication of two unsigned integers, reverting on
1126      * overflow.
1127      *
1128      * Counterpart to Solidity's `*` operator.
1129      *
1130      * Requirements:
1131      *
1132      * - Multiplication cannot overflow.
1133      */
1134     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
1135         return a * b;
1136     }
1137 
1138     /**
1139      * @dev Returns the integer division of two unsigned integers, reverting on
1140      * division by zero. The result is rounded towards zero.
1141      *
1142      * Counterpart to Solidity's `/` operator.
1143      *
1144      * Requirements:
1145      *
1146      * - The divisor cannot be zero.
1147      */
1148     function div(uint256 a, uint256 b) internal pure returns(uint256) {
1149         return a / b;
1150     }
1151 
1152     /**
1153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1154      * reverting when dividing by zero.
1155      *
1156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1157      * opcode (which leaves remaining gas untouched) while Solidity uses an
1158      * invalid opcode to revert (consuming all remaining gas).
1159      *
1160      * Requirements:
1161      *
1162      * - The divisor cannot be zero.
1163      */
1164     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
1165         return a % b;
1166     }
1167 
1168     /**
1169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1170      * overflow (when the result is negative).
1171      *
1172      * CAUTION: This function is deprecated because it requires allocating memory for the error
1173      * message unnecessarily. For custom revert reasons use {trySub}.
1174      *
1175      * Counterpart to Solidity's `-` operator.
1176      *
1177      * Requirements:
1178      *
1179      * - Subtraction cannot overflow.
1180      */
1181     function sub(
1182         uint256 a,
1183         uint256 b,
1184         string memory errorMessage
1185     ) internal pure returns(uint256) {
1186         unchecked {
1187             require(b <= a, errorMessage);
1188             return a - b;
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1194      * division by zero. The result is rounded towards zero.
1195      *
1196      * Counterpart to Solidity's `/` operator. Note: this function uses a
1197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1198      * uses an invalid opcode to revert (consuming all remaining gas).
1199      *
1200      * Requirements:
1201      *
1202      * - The divisor cannot be zero.
1203      */
1204     function div(
1205         uint256 a,
1206         uint256 b,
1207         string memory errorMessage
1208     ) internal pure returns(uint256) {
1209         unchecked {
1210             require(b > 0, errorMessage);
1211             return a / b;
1212         }
1213     }
1214 
1215     /**
1216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1217      * reverting with custom message when dividing by zero.
1218      *
1219      * CAUTION: This function is deprecated because it requires allocating memory for the error
1220      * message unnecessarily. For custom revert reasons use {tryMod}.
1221      *
1222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1223      * opcode (which leaves remaining gas untouched) while Solidity uses an
1224      * invalid opcode to revert (consuming all remaining gas).
1225      *
1226      * Requirements:
1227      *
1228      * - The divisor cannot be zero.
1229      */
1230     function mod(
1231         uint256 a,
1232         uint256 b,
1233         string memory errorMessage
1234     ) internal pure returns(uint256) {
1235         unchecked {
1236             require(b > 0, errorMessage);
1237             return a % b;
1238         }
1239     }
1240 }
1241 
1242 
1243 
1244 
1245 
1246 /**
1247  * @dev Contract module which provides a basic access control mechanism, where
1248  * there is an account (an owner) that can be granted exclusive access to
1249  * specific functions.
1250  *
1251  * By default, the owner account will be the one that deploys the contract. This
1252  * can later be changed with {transferOwnership}.
1253  *
1254  * This module is used through inheritance. It will make available the modifier
1255  * `onlyOwner`, which can be applied to your functions to restrict their use to
1256  * the owner.
1257  */
1258 abstract contract Ownable is Context {
1259     address private _owner;
1260 
1261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1262 
1263     /**
1264      * @dev Initializes the contract setting the deployer as the initial owner.
1265      */
1266     constructor() {
1267         _setOwner(_msgSender());
1268     }
1269 
1270     /**
1271      * @dev Returns the address of the current owner.
1272      */
1273     function owner() public view virtual returns(address) {
1274         return _owner;
1275     }
1276 
1277     /**
1278      * @dev Throws if called by any account other than the owner.
1279      */
1280     modifier onlyOwner() {
1281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Leaves the contract without owner. It will not be possible to call
1287      * `onlyOwner` functions anymore. Can only be called by the current owner.
1288      *
1289      * NOTE: Renouncing ownership will leave the contract without an owner,
1290      * thereby removing any functionality that is only available to the owner.
1291      */
1292     function renounceOwnership() public virtual onlyOwner {
1293         _setOwner(address(0));
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Can only be called by the current owner.
1299      */
1300     function transferOwnership(address newOwner) public virtual onlyOwner {
1301         require(newOwner != address(0), "Ownable: new owner is the zero address");
1302         _setOwner(newOwner);
1303     }
1304 
1305     function _setOwner(address newOwner) private {
1306         address oldOwner = _owner;
1307         _owner = newOwner;
1308         emit OwnershipTransferred(oldOwner, newOwner);
1309     }
1310 }
1311 
1312 
1313 
1314 
1315 
1316 
1317 
1318 
1319 
1320 /**
1321  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1322  * enumerability of all the token ids in the contract as well as all token ids owned by each
1323  * account.
1324  */
1325 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1326     // Mapping from owner to list of owned token IDs
1327     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1328 
1329     // Mapping from token ID to index of the owner tokens list
1330     mapping(uint256 => uint256) private _ownedTokensIndex;
1331 
1332     // Array with all token ids, used for enumeration
1333     uint256[] private _allTokens;
1334 
1335     // Mapping from token id to position in the allTokens array
1336     mapping(uint256 => uint256) private _allTokensIndex;
1337 
1338     /**
1339      * @dev See {IERC165-supportsInterface}.
1340      */
1341     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns(bool) {
1342         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1343     }
1344 
1345     /**
1346      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1347      */
1348     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns(uint256) {
1349         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1350         return _ownedTokens[owner][index];
1351     }
1352 
1353     /**
1354      * @dev See {IERC721Enumerable-totalSupply}.
1355      */
1356     function totalSupply() public view virtual override returns(uint256) {
1357         return _allTokens.length;
1358     }
1359 
1360     /**
1361      * @dev See {IERC721Enumerable-tokenByIndex}.
1362      */
1363     function tokenByIndex(uint256 index) public view virtual override returns(uint256) {
1364         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1365         return _allTokens[index];
1366     }
1367 
1368     /**
1369      * @dev Hook that is called before any token transfer. This includes minting
1370      * and burning.
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` will be minted for `to`.
1377      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1378      * - `from` cannot be the zero address.
1379      * - `to` cannot be the zero address.
1380      *
1381      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1382      */
1383     function _beforeTokenTransfer(
1384         address from,
1385         address to,
1386         uint256 tokenId
1387     ) internal virtual override {
1388         super._beforeTokenTransfer(from, to, tokenId);
1389 
1390         if (from == address(0)) {
1391             _addTokenToAllTokensEnumeration(tokenId);
1392         } else if (from != to) {
1393             _removeTokenFromOwnerEnumeration(from, tokenId);
1394         }
1395         if (to == address(0)) {
1396             _removeTokenFromAllTokensEnumeration(tokenId);
1397         } else if (to != from) {
1398             _addTokenToOwnerEnumeration(to, tokenId);
1399         }
1400     }
1401 
1402     /**
1403      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1404      * @param to address representing the new owner of the given token ID
1405      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1406      */
1407     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1408         uint256 length = ERC721.balanceOf(to);
1409         _ownedTokens[to][length] = tokenId;
1410         _ownedTokensIndex[tokenId] = length;
1411     }
1412 
1413     /**
1414      * @dev Private function to add a token to this extension's token tracking data structures.
1415      * @param tokenId uint256 ID of the token to be added to the tokens list
1416      */
1417     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1418         _allTokensIndex[tokenId] = _allTokens.length;
1419         _allTokens.push(tokenId);
1420     }
1421 
1422     /**
1423      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1424      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1425      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1426      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1427      * @param from address representing the previous owner of the given token ID
1428      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1429      */
1430     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1431         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1432         // then delete the last slot (swap and pop).
1433 
1434         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1435         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1436 
1437         // When the token to delete is the last token, the swap operation is unnecessary
1438         if (tokenIndex != lastTokenIndex) {
1439             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1440 
1441             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1442             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1443         }
1444 
1445         // This also deletes the contents at the last position of the array
1446         delete _ownedTokensIndex[tokenId];
1447         delete _ownedTokens[from][lastTokenIndex];
1448     }
1449 
1450     /**
1451      * @dev Private function to remove a token from this extension's token tracking data structures.
1452      * This has O(1) time complexity, but alters the order of the _allTokens array.
1453      * @param tokenId uint256 ID of the token to be removed from the tokens list
1454      */
1455     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1456         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1457         // then delete the last slot (swap and pop).
1458 
1459         uint256 lastTokenIndex = _allTokens.length - 1;
1460         uint256 tokenIndex = _allTokensIndex[tokenId];
1461 
1462         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1463         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1464         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1465         uint256 lastTokenId = _allTokens[lastTokenIndex];
1466 
1467         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1468         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1469 
1470         // This also deletes the contents at the last position of the array
1471         delete _allTokensIndex[tokenId];
1472         _allTokens.pop();
1473     }
1474 }
1475 
1476 
1477 
1478 
1479 //Global Goats Main Contract
1480 
1481 contract GlobalGoats is ERC721Enumerable, Ownable {
1482 
1483     using SafeMath for uint256;
1484     using Strings for uint256;
1485 
1486     uint256 public constant collection_Supply = 2323;
1487 
1488     uint256 public constant MAX_PURCHASE = 20;
1489 
1490     uint256 public constant MAX_MintedForPromotion = 25;
1491 
1492     uint256 public goatsMintedForPromotion;
1493 
1494     uint256 public preSaleGoatsMinted;
1495 
1496     uint256 public constant MAX_MintedGoldenGoats = 100;
1497 
1498     uint256 public constant MAX_PreSaleMintedGoats = 350;
1499 
1500     uint256 public constant PRICE_PER_GOAT = 150000000000000000 wei;  //0.15 ETH
1501 
1502     uint256 public constant PreSale_PRICE_PER_GOAT = 110000000000000000 wei;  //0.11 ETH
1503 
1504     bool private _saleIsActive;
1505 
1506     mapping(uint256 => uint256) private _tokenPriceWei;
1507 
1508     mapping (uint256 => address) private _tokenListOwner;
1509 
1510     bool private _preSaleIsActive;
1511 
1512     string private _metaBaseUri = "https://assets.globalgoats.io/";
1513 
1514 
1515 //Index of Golden Goats
1516     uint[] GoldenGoats = [283, 107, 44, 344, 9, 23, 40, 218, 349, 165, 74, 2, 19, 227, 215, 315, 4, 303, 237, 209, 27, 199, 336, 256, 280, 312, 7, 317, 89, 169, 37, 204, 144, 133, 342, 156, 201, 196, 101, 164, 265, 275, 173, 228, 79, 277, 41, 292, 230, 337, 1619, 480, 1551, 1400, 1678, 1658, 2222, 1461, 2323, 2125, 981, 1639, 712, 1230, 1645, 1083, 976, 2244, 939, 786, 1223, 2022, 585, 2261, 926, 1985, 893, 1571, 1098, 792, 1944, 1754, 1352, 821, 1771, 931, 2018, 432, 1901, 1919, 867, 1295, 1697, 667, 2175, 1926, 1100, 1166, 1978, 2085];
1517 
1518     uint[] getOnSale;
1519     //Alternative Option 
1520     struct GoldenGoat {
1521         address userAddress;
1522         uint tokenId;
1523     }
1524     
1525 
1526     constructor() ERC721("GlobalGoats", "GOAT") {
1527 
1528         _saleIsActive = true;
1529         _preSaleIsActive = true;
1530         goatsMintedForPromotion = 0;
1531     }
1532 
1533     //public mint
1534     function mint(uint16 numberOfTokens) public payable {
1535         require(saleIsActive(), "Sale is not active");
1536         require(numberOfTokens <= MAX_PURCHASE, "Can only mint max 20 tokens per transaction");
1537         require(PRICE_PER_GOAT.mul(numberOfTokens) == msg.value, "Ether value sent is incorrect.Need 0.15 ETH for each GOAT");
1538         require(totalSupply() < collection_Supply, "collection sold out");
1539         require(totalSupply().add(numberOfTokens) < collection_Supply, "Insufficient supply");
1540 
1541         _mintTokens(numberOfTokens,msg.sender);
1542 
1543     }
1544 
1545     //Pre-Sale Mint
1546     function preSalemint(uint16 numberOfTokens) public payable {
1547         require(saleIsActive(), "Sale is not active");
1548         require(numberOfTokens <= MAX_PURCHASE, "Can only mint max 20 tokens per transaction");
1549         require(preSaleGoatsMinted.add(numberOfTokens) <= MAX_PreSaleMintedGoats, "Cannot mint more Pre-sale mintgoats for promotion");
1550         require(PreSale_PRICE_PER_GOAT.mul(numberOfTokens) == msg.value, "Ether value sent is incorrect.Need 0.11 ETH For Presale for each GOAT");
1551         require(totalSupply().add(numberOfTokens) < collection_Supply, "Insufficient supply");
1552         preSaleGoatsMinted += numberOfTokens;
1553 
1554         _mintTokens(numberOfTokens,msg.sender);
1555 
1556     }
1557 
1558 
1559     /* Owner functions */
1560 
1561     /**
1562      * Reserve a few Goats e.g. for giveaways
1563      */
1564     function reserveMint(uint16 numberOfTokens , address _to) external onlyOwner {
1565         require(goatsMintedForPromotion.add(numberOfTokens) <= MAX_MintedForPromotion, "Cannot mint more goats for promotion");
1566         require(totalSupply().add(numberOfTokens) < collection_Supply, "Insufficient supply");
1567         goatsMintedForPromotion += numberOfTokens;
1568         _mintTokens(numberOfTokens,_to);
1569     }
1570 
1571     
1572     function setSaleIsActive(bool active) external onlyOwner {
1573         _saleIsActive = active;
1574     }
1575 
1576     function setPreSaleIsActive(bool active) external onlyOwner {
1577         _preSaleIsActive = active;
1578     }
1579 
1580 
1581     function setMetaBaseURI(string memory baseURI) external onlyOwner {
1582         _metaBaseUri = baseURI;
1583     }
1584 
1585     function withdraw(uint256 amount) external onlyOwner {
1586         require(amount <= address(this).balance, 'Insufficient balance');
1587         payable(msg.sender).transfer(amount);
1588     }
1589 
1590     function withdrawAll() external onlyOwner {
1591         payable(msg.sender).transfer(address(this).balance);
1592     }
1593 
1594     /* View functions */
1595     function saleIsActive() public view returns(bool) {
1596         return _saleIsActive;
1597     }
1598 
1599     function presaleIsActive() public view returns(bool) {
1600         return _preSaleIsActive;
1601     }
1602     //get array of golden goats TokenIds
1603     function _getGGTokens() external view returns(uint[] memory) {
1604 
1605         uint[] memory goats = new uint[](GoldenGoats.length);
1606         
1607         for (uint j = 0; j < GoldenGoats.length; j++) {
1608         
1609             goats[j] = GoldenGoats[j];
1610         }
1611 
1612         return goats;
1613     }
1614 
1615 
1616  function _getOnSalePlatformTokens() external view returns(uint[] memory) {
1617 
1618         uint[] memory goats = new uint[](getOnSale.length);
1619         uint256 tokenId;
1620 
1621         for (uint j = 0; j < getOnSale.length; j++) {
1622             tokenId = getOnSale[j];
1623         if (_exists(tokenId)) {
1624         address listowneraddress = _tokenListOwner[tokenId];
1625         address currentOnweraddress = ownerOf(tokenId);
1626 
1627          if( listowneraddress == currentOnweraddress) {   // if else statement
1628          goats[j] = getOnSale[j];
1629          } 
1630         }
1631         }
1632 
1633         return goats;
1634     }
1635 
1636 
1637     function IsGGToken(uint256 tokenId) public view returns(bool status) {
1638         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1639         status = false;
1640         for (uint l = 0; l < GoldenGoats.length; l++) {
1641             
1642             if (GoldenGoats[l] == tokenId) {
1643                 status = true;
1644                 break;
1645             }
1646         }
1647          return status;
1648 
1649     }
1650 
1651  function IsonSaleToken(uint256 tokenId) public view returns(bool status) {
1652         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1653         status = false;
1654         for (uint k = 0; k < getOnSale.length; k++) {
1655             if (getOnSale[k] == tokenId) {
1656                 status = true;
1657                 break;
1658             }
1659         }
1660         return status;
1661 
1662     }
1663 
1664 
1665     function getCurrentPriceOfToken(uint256 tokenId) public view virtual returns(uint256) {
1666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1667         require(_tokenListOwner[tokenId] == ownerOf(tokenId) , "Not For Sale Currently on GlobalGoats.io");
1668         uint256 Price = _tokenPriceWei[tokenId];
1669 
1670         return Price;
1671     }
1672 
1673     function tokenURI(uint256 tokenId) override public view returns(string memory) {
1674         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1675         return string(abi.encodePacked(_baseURI(), "tokens/", uint256(tokenId).toString(), "/metadata.json"));
1676     }
1677 
1678     /* Internal functions */
1679     function _mintTokens(uint16 numberOfTokens , address _to) internal {
1680         for (uint16 i = 0; i < numberOfTokens; i++) {
1681             uint256 tokenId = totalSupply() + 1;
1682             //uint256 tokenId = _tokenIdTracker.current();
1683             _safeMint(_to, tokenId);
1684         }
1685     }
1686 
1687 
1688     function approve(uint256 _tokenId, address _from) internal virtual {
1689         require(ownerOf(_tokenId) == msg.sender, "NOT OWNER");
1690         isApprovedForAll(_from, address(this));
1691     }
1692 
1693 
1694     //send Price in wei
1695     function _setTokenPrice(uint256 tokenId, uint256 tokenPrice) external  {
1696         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1697         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1698 
1699         _tokenPriceWei[tokenId] = tokenPrice;
1700         getOnSale.push(tokenId);
1701         _tokenListOwner[tokenId] = msg.sender;
1702         approve(tokenId, msg.sender);
1703 
1704     }
1705 
1706     /* Only for Global Goats Platform */
1707     function transfergg(uint256 tokenId) external payable{
1708         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1709         require(msg.value > 0, "Price must be greater than zero");
1710         require(_tokenListOwner[tokenId] == ownerOf(tokenId) , "Not For Sale Currently on GlobalGoats.io");
1711         uint256 amountReceived = (msg.value * 1000000000000000000);
1712 
1713         require(amountReceived >= _tokenPriceWei[tokenId], "Invalid amount sent up");
1714     
1715         uint256 Platformpercentage = 8;
1716 
1717         //Give royalties to original contract owner
1718         uint256 ownerCut = (msg.value * Platformpercentage) / 100;
1719         
1720         address owner = owner();
1721         payable(owner).transfer(ownerCut);
1722 
1723         //Give royalties to NPort (2%)
1724         uint256 nportCut = (msg.value * 2) / 100;
1725 
1726         //token Current Owner
1727         address tokencurrentOwner = ownerOf(tokenId);
1728 
1729         //send royalty to 100 GG 
1730         uint256 ggtokenId;
1731         //divide nportcut by GG Lengths
1732         uint pricepergoat = nportCut / GoldenGoats.length;
1733         if (GoldenGoats.length > 0) {
1734             for (uint j = 0; j < GoldenGoats.length; j++) {
1735                 ggtokenId = GoldenGoats[j];
1736                 if (_exists(ggtokenId)) {
1737                    address GGtokenowner = ownerOf(ggtokenId);
1738                     payable(GGtokenowner).transfer(pricepergoat);
1739                 }
1740             }
1741         }
1742 
1743         //Give current owner the rest
1744         payable(tokencurrentOwner).transfer(msg.value - ownerCut - nportCut);
1745         _transfer(tokencurrentOwner, msg.sender, tokenId);
1746         _tokenPriceWei[tokenId] = 0;
1747 
1748         if (getOnSale.length > 0) {
1749             for (uint j = 0; j < getOnSale.length; j++) {
1750                 ggtokenId = getOnSale[j];
1751                 if (ggtokenId == tokenId) {
1752                     delete getOnSale[j];
1753                 }
1754             }
1755         }
1756     }
1757 
1758 
1759     function _baseURI() override internal view returns(string memory) {
1760         return _metaBaseUri;
1761     }
1762 
1763 }