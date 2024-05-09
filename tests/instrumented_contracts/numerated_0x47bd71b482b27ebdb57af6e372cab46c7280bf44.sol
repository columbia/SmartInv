1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies on extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         assembly {
33             size := extcodesize(account)
34         }
35         return size > 0;
36     }
37 
38     /**
39      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40      * `recipient`, forwarding all available gas and reverting on errors.
41      *
42      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43      * of certain opcodes, possibly making contracts go over the 2300 gas limit
44      * imposed by `transfer`, making them unable to receive funds via
45      * `transfer`. {sendValue} removes this limitation.
46      *
47      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48      *
49      * IMPORTANT: because control is transferred to `recipient`, care must be
50      * taken to not create reentrancy vulnerabilities. Consider using
51      * {ReentrancyGuard} or the
52      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53      */
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(address(this).balance >= amount, "Address: insufficient balance");
56 
57         (bool success, ) = recipient.call{value: amount}("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain `call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80         return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(
90         address target,
91         bytes memory data,
92         string memory errorMessage
93     ) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(
109         address target,
110         bytes memory data,
111         uint256 value
112     ) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
118      * with `errorMessage` as a fallback revert reason when `target` reverts.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value,
126         string memory errorMessage
127     ) internal returns (bytes memory) {
128         require(address(this).balance >= value, "Address: insufficient balance for call");
129         require(isContract(target), "Address: call to non-contract");
130 
131         (bool success, bytes memory returndata) = target.call{value: value}(data);
132         return verifyCallResult(success, returndata, errorMessage);
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
142         return functionStaticCall(target, data, "Address: low-level static call failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal view returns (bytes memory) {
156         require(isContract(target), "Address: static call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.staticcall(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but performing a delegate call.
165      *
166      * _Available since v3.4._
167      */
168     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(isContract(target), "Address: delegate call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.delegatecall(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
191      * revert reason using the provided one.
192      *
193      * _Available since v4.3._
194      */
195     function verifyCallResult(
196         bool success,
197         bytes memory returndata,
198         string memory errorMessage
199     ) internal pure returns (bytes memory) {
200         if (success) {
201             return returndata;
202         } else {
203             // Look for revert reason and bubble it up if present
204             if (returndata.length > 0) {
205                 // The easiest way to bubble the revert reason is using memory via assembly
206 
207                 assembly {
208                     let returndata_size := mload(returndata)
209                     revert(add(32, returndata), returndata_size)
210                 }
211             } else {
212                 revert(errorMessage);
213             }
214         }
215     }
216 }
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @dev Provides information about the current execution context, including the
222  * sender of the transaction and its data. While these are generally available
223  * via msg.sender and msg.data, they should not be accessed in such a direct
224  * manner, since when dealing with meta-transactions the account sending and
225  * paying for execution may not be the actual sender (as far as an application
226  * is concerned).
227  *
228  * This contract is only required for intermediate, library-like contracts.
229  */
230 abstract contract Context {
231     function _msgSender() internal view virtual returns (address) {
232         return msg.sender;
233     }
234 
235     function _msgData() internal view virtual returns (bytes calldata) {
236         return msg.data;
237     }
238 }
239 
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Interface of the ERC165 standard, as defined in the
245  * https://eips.ethereum.org/EIPS/eip-165[EIP].
246  *
247  * Implementers can declare support of contract interfaces, which can then be
248  * queried by others ({ERC165Checker}).
249  *
250  * For an implementation, see {ERC165}.
251  */
252 interface IERC165 {
253     /**
254      * @dev Returns true if this contract implements the interface defined by
255      * `interfaceId`. See the corresponding
256      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
257      * to learn more about how these ids are created.
258      *
259      * This function call must use less than 30 000 gas.
260      */
261     function supportsInterface(bytes4 interfaceId) external view returns (bool);
262 }
263 
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Implementation of the {IERC165} interface.
269  *
270  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
271  * for the additional interface id that will be supported. For example:
272  *
273  * ```solidity
274  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
275  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
276  * }
277  * ```
278  *
279  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
280  */
281 abstract contract ERC165 is IERC165 {
282     /**
283      * @dev See {IERC165-supportsInterface}.
284      */
285     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
286         return interfaceId == type(IERC165).interfaceId;
287     }
288 }
289 
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Required interface of an ERC721 compliant contract.
295  */
296 interface IERC721 is IERC165 {
297     /**
298      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
299      */
300     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
301 
302     /**
303      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
304      */
305     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
306 
307     /**
308      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
309      */
310     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
311 
312     /**
313      * @dev Returns the number of tokens in ``owner``'s account.
314      */
315     function balanceOf(address owner) external view returns (uint256 balance);
316 
317     /**
318      * @dev Returns the owner of the `tokenId` token.
319      *
320      * Requirements:
321      *
322      * - `tokenId` must exist.
323      */
324     function ownerOf(uint256 tokenId) external view returns (address owner);
325 
326     /**
327      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
328      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
329      *
330      * Requirements:
331      *
332      * - `from` cannot be the zero address.
333      * - `to` cannot be the zero address.
334      * - `tokenId` token must exist and be owned by `from`.
335      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
336      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
337      *
338      * Emits a {Transfer} event.
339      */
340     function safeTransferFrom(
341         address from,
342         address to,
343         uint256 tokenId
344     ) external;
345 
346     /**
347      * @dev Transfers `tokenId` token from `from` to `to`.
348      *
349      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
350      *
351      * Requirements:
352      *
353      * - `from` cannot be the zero address.
354      * - `to` cannot be the zero address.
355      * - `tokenId` token must be owned by `from`.
356      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
357      *
358      * Emits a {Transfer} event.
359      */
360     function transferFrom(
361         address from,
362         address to,
363         uint256 tokenId
364     ) external;
365 
366     /**
367      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
368      * The approval is cleared when the token is transferred.
369      *
370      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
371      *
372      * Requirements:
373      *
374      * - The caller must own the token or be an approved operator.
375      * - `tokenId` must exist.
376      *
377      * Emits an {Approval} event.
378      */
379     function approve(address to, uint256 tokenId) external;
380 
381     /**
382      * @dev Returns the account approved for `tokenId` token.
383      *
384      * Requirements:
385      *
386      * - `tokenId` must exist.
387      */
388     function getApproved(uint256 tokenId) external view returns (address operator);
389 
390     /**
391      * @dev Approve or remove `operator` as an operator for the caller.
392      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
393      *
394      * Requirements:
395      *
396      * - The `operator` cannot be the caller.
397      *
398      * Emits an {ApprovalForAll} event.
399      */
400     function setApprovalForAll(address operator, bool _approved) external;
401 
402     /**
403      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
404      *
405      * See {setApprovalForAll}
406      */
407     function isApprovedForAll(address owner, address operator) external view returns (bool);
408 
409     /**
410      * @dev Safely transfers `tokenId` token from `from` to `to`.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must exist and be owned by `from`.
417      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
419      *
420      * Emits a {Transfer} event.
421      */
422     function safeTransferFrom(
423         address from,
424         address to,
425         uint256 tokenId,
426         bytes calldata data
427     ) external;
428 }
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
434  * @dev See https://eips.ethereum.org/EIPS/eip-721
435  */
436 interface IERC721Metadata is IERC721 {
437     /**
438      * @dev Returns the token collection name.
439      */
440     function name() external view returns (string memory);
441 
442     /**
443      * @dev Returns the token collection symbol.
444      */
445     function symbol() external view returns (string memory);
446 
447     /**
448      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
449      */
450     function tokenURI(uint256 tokenId) external view returns (string memory);
451 }
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
457  * the Metadata extension, but not including the Enumerable extension, which is available separately as
458  * {ERC721Enumerable}.
459  */
460 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
461     using Address for address;
462     using Strings for uint256;
463 
464     // Token name
465     string private _name;
466 
467     // Token symbol
468     string private _symbol;
469 
470     // Mapping from token ID to owner address
471     mapping(uint256 => address) private _owners;
472 
473     // Mapping owner address to token count
474     mapping(address => uint256) private _balances;
475 
476     // Mapping from token ID to approved address
477     mapping(uint256 => address) private _tokenApprovals;
478 
479     // Mapping from owner to operator approvals
480     mapping(address => mapping(address => bool)) private _operatorApprovals;
481 
482     /**
483      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
484      */
485     constructor(string memory name_, string memory symbol_) {
486         _name = name_;
487         _symbol = symbol_;
488     }
489 
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
494         return
495             interfaceId == type(IERC721).interfaceId ||
496             interfaceId == type(IERC721Metadata).interfaceId ||
497             super.supportsInterface(interfaceId);
498     }
499 
500     /**
501      * @dev See {IERC721-balanceOf}.
502      */
503     function balanceOf(address owner) public view virtual override returns (uint256) {
504         require(owner != address(0), "ERC721: balance query for the zero address");
505         return _balances[owner];
506     }
507 
508     /**
509      * @dev See {IERC721-ownerOf}.
510      */
511     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
512         address owner = _owners[tokenId];
513         require(owner != address(0), "ERC721: owner query for nonexistent token");
514         return owner;
515     }
516 
517     /**
518      * @dev See {IERC721Metadata-name}.
519      */
520     function name() public view virtual override returns (string memory) {
521         return _name;
522     }
523 
524     /**
525      * @dev See {IERC721Metadata-symbol}.
526      */
527     function symbol() public view virtual override returns (string memory) {
528         return _symbol;
529     }
530 
531     /**
532      * @dev See {IERC721Metadata-tokenURI}.
533      */
534     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
535         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
536 
537         string memory baseURI = _baseURI();
538         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
539     }
540 
541     /**
542      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
543      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
544      * by default, can be overriden in child contracts.
545      */
546     function _baseURI() internal view virtual returns (string memory) {
547         return "";
548     }
549 
550     /**
551      * @dev See {IERC721-approve}.
552      */
553     function approve(address to, uint256 tokenId) public virtual override {
554         address owner = ERC721.ownerOf(tokenId);
555         require(to != owner, "ERC721: approval to current owner");
556 
557         require(
558             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
559             "ERC721: approve caller is not owner nor approved for all"
560         );
561 
562         _approve(to, tokenId);
563     }
564 
565     /**
566      * @dev See {IERC721-getApproved}.
567      */
568     function getApproved(uint256 tokenId) public view virtual override returns (address) {
569         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
570 
571         return _tokenApprovals[tokenId];
572     }
573 
574     /**
575      * @dev See {IERC721-setApprovalForAll}.
576      */
577     function setApprovalForAll(address operator, bool approved) public virtual override {
578         require(operator != _msgSender(), "ERC721: approve to caller");
579 
580         _operatorApprovals[_msgSender()][operator] = approved;
581         emit ApprovalForAll(_msgSender(), operator, approved);
582     }
583 
584     /**
585      * @dev See {IERC721-isApprovedForAll}.
586      */
587     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
588         return _operatorApprovals[owner][operator];
589     }
590 
591     /**
592      * @dev See {IERC721-transferFrom}.
593      */
594     function transferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) public virtual override {
599         //solhint-disable-next-line max-line-length
600         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
601 
602         _transfer(from, to, tokenId);
603     }
604 
605     /**
606      * @dev See {IERC721-safeTransferFrom}.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) public virtual override {
613         safeTransferFrom(from, to, tokenId, "");
614     }
615 
616     /**
617      * @dev See {IERC721-safeTransferFrom}.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId,
623         bytes memory _data
624     ) public virtual override {
625         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
626         _safeTransfer(from, to, tokenId, _data);
627     }
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
632      *
633      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
634      *
635      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
636      * implement alternative mechanisms to perform token transfer, such as signature-based.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
644      *
645      * Emits a {Transfer} event.
646      */
647     function _safeTransfer(
648         address from,
649         address to,
650         uint256 tokenId,
651         bytes memory _data
652     ) internal virtual {
653         _transfer(from, to, tokenId);
654         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
655     }
656 
657     /**
658      * @dev Returns whether `tokenId` exists.
659      *
660      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
661      *
662      * Tokens start existing when they are minted (`_mint`),
663      * and stop existing when they are burned (`_burn`).
664      */
665     function _exists(uint256 tokenId) internal view virtual returns (bool) {
666         return _owners[tokenId] != address(0);
667     }
668 
669     /**
670      * @dev Returns whether `spender` is allowed to manage `tokenId`.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must exist.
675      */
676     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
677         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
678         address owner = ERC721.ownerOf(tokenId);
679         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
680     }
681 
682     /**
683      * @dev Safely mints `tokenId` and transfers it to `to`.
684      *
685      * Requirements:
686      *
687      * - `tokenId` must not exist.
688      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function _safeMint(address to, uint256 tokenId) internal virtual {
693         _safeMint(to, tokenId, "");
694     }
695 
696     /**
697      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
698      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
699      */
700     function _safeMint(
701         address to,
702         uint256 tokenId,
703         bytes memory _data
704     ) internal virtual {
705         _mint(to, tokenId);
706         require(
707             _checkOnERC721Received(address(0), to, tokenId, _data),
708             "ERC721: transfer to non ERC721Receiver implementer"
709         );
710     }
711 
712     /**
713      * @dev Mints `tokenId` and transfers it to `to`.
714      *
715      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
716      *
717      * Requirements:
718      *
719      * - `tokenId` must not exist.
720      * - `to` cannot be the zero address.
721      *
722      * Emits a {Transfer} event.
723      */
724     function _mint(address to, uint256 tokenId) internal virtual {
725         require(to != address(0), "ERC721: mint to the zero address");
726         require(!_exists(tokenId), "ERC721: token already minted");
727 
728         _beforeTokenTransfer(address(0), to, tokenId);
729 
730         _balances[to] += 1;
731         _owners[tokenId] = to;
732 
733         emit Transfer(address(0), to, tokenId);
734     }
735 
736     /**
737      * @dev Destroys `tokenId`.
738      * The approval is cleared when the token is burned.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _burn(uint256 tokenId) internal virtual {
747         address owner = ERC721.ownerOf(tokenId);
748 
749         _beforeTokenTransfer(owner, address(0), tokenId);
750 
751         // Clear approvals
752         _approve(address(0), tokenId);
753 
754         _balances[owner] -= 1;
755         delete _owners[tokenId];
756 
757         emit Transfer(owner, address(0), tokenId);
758     }
759 
760     /**
761      * @dev Transfers `tokenId` from `from` to `to`.
762      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
763      *
764      * Requirements:
765      *
766      * - `to` cannot be the zero address.
767      * - `tokenId` token must be owned by `from`.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _transfer(
772         address from,
773         address to,
774         uint256 tokenId
775     ) internal virtual {
776         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
777         require(to != address(0), "ERC721: transfer to the zero address");
778 
779         _beforeTokenTransfer(from, to, tokenId);
780 
781         // Clear approvals from the previous owner
782         _approve(address(0), tokenId);
783 
784         _balances[from] -= 1;
785         _balances[to] += 1;
786         _owners[tokenId] = to;
787 
788         emit Transfer(from, to, tokenId);
789     }
790 
791     /**
792      * @dev Approve `to` to operate on `tokenId`
793      *
794      * Emits a {Approval} event.
795      */
796     function _approve(address to, uint256 tokenId) internal virtual {
797         _tokenApprovals[tokenId] = to;
798         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
799     }
800 
801     /**
802      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
803      * The call is not executed if the target address is not a contract.
804      *
805      * @param from address representing the previous owner of the given token ID
806      * @param to target address that will receive the tokens
807      * @param tokenId uint256 ID of the token to be transferred
808      * @param _data bytes optional data to send along with the call
809      * @return bool whether the call correctly returned the expected magic value
810      */
811     function _checkOnERC721Received(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) private returns (bool) {
817         if (to.isContract()) {
818             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
819                 return retval == IERC721Receiver.onERC721Received.selector;
820             } catch (bytes memory reason) {
821                 if (reason.length == 0) {
822                     revert("ERC721: transfer to non ERC721Receiver implementer");
823                 } else {
824                     assembly {
825                         revert(add(32, reason), mload(reason))
826                     }
827                 }
828             }
829         } else {
830             return true;
831         }
832     }
833 
834     /**
835      * @dev Hook that is called before any token transfer. This includes minting
836      * and burning.
837      *
838      * Calling conditions:
839      *
840      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
841      * transferred to `to`.
842      * - When `from` is zero, `tokenId` will be minted for `to`.
843      * - When `to` is zero, ``from``'s `tokenId` will be burned.
844      * - `from` and `to` are never both zero.
845      *
846      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
847      */
848     function _beforeTokenTransfer(
849         address from,
850         address to,
851         uint256 tokenId
852     ) internal virtual {}
853 }
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @title ERC721 Burnable Token
859  * @dev ERC721 Token that can be irreversibly burned (destroyed).
860  */
861 abstract contract ERC721Burnable is Context, ERC721 {
862     /**
863      * @dev Burns `tokenId`. See {ERC721-_burn}.
864      *
865      * Requirements:
866      *
867      * - The caller must own `tokenId` or be an approved operator.
868      */
869     function burn(uint256 tokenId) public virtual {
870         //solhint-disable-next-line max-line-length
871         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
872         _burn(tokenId);
873     }
874 }
875 
876 
877 
878 pragma solidity ^0.8.0;
879 
880 /**
881  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
882  * @dev See https://eips.ethereum.org/EIPS/eip-721
883  */
884 interface IERC721Enumerable is IERC721 {
885     /**
886      * @dev Returns the total amount of tokens stored by the contract.
887      */
888     function totalSupply() external view returns (uint256);
889 
890     /**
891      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
892      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
893      */
894     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
895 
896     /**
897      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
898      * Use along with {totalSupply} to enumerate all tokens.
899      */
900     function tokenByIndex(uint256 index) external view returns (uint256);
901 }
902 
903 
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
909  * enumerability of all the token ids in the contract as well as all token ids owned by each
910  * account.
911  */
912 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
913     // Mapping from owner to list of owned token IDs
914     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
915 
916     // Mapping from token ID to index of the owner tokens list
917     mapping(uint256 => uint256) private _ownedTokensIndex;
918 
919     // Array with all token ids, used for enumeration
920     uint256[] private _allTokens;
921 
922     // Mapping from token id to position in the allTokens array
923     mapping(uint256 => uint256) private _allTokensIndex;
924 
925     /**
926      * @dev See {IERC165-supportsInterface}.
927      */
928     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
929         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
930     }
931 
932     /**
933      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
934      */
935     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
936         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
937         return _ownedTokens[owner][index];
938     }
939 
940     /**
941      * @dev See {IERC721Enumerable-totalSupply}.
942      */
943     function totalSupply() public view virtual override returns (uint256) {
944         return _allTokens.length;
945     }
946 
947     /**
948      * @dev See {IERC721Enumerable-tokenByIndex}.
949      */
950     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
951         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
952         return _allTokens[index];
953     }
954 
955     /**
956      * @dev Hook that is called before any token transfer. This includes minting
957      * and burning.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` will be minted for `to`.
964      * - When `to` is zero, ``from``'s `tokenId` will be burned.
965      * - `from` cannot be the zero address.
966      * - `to` cannot be the zero address.
967      *
968      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
969      */
970     function _beforeTokenTransfer(
971         address from,
972         address to,
973         uint256 tokenId
974     ) internal virtual override {
975         super._beforeTokenTransfer(from, to, tokenId);
976 
977         if (from == address(0)) {
978             _addTokenToAllTokensEnumeration(tokenId);
979         } else if (from != to) {
980             _removeTokenFromOwnerEnumeration(from, tokenId);
981         }
982         if (to == address(0)) {
983             _removeTokenFromAllTokensEnumeration(tokenId);
984         } else if (to != from) {
985             _addTokenToOwnerEnumeration(to, tokenId);
986         }
987     }
988 
989     /**
990      * @dev Private function to add a token to this extension's ownership-tracking data structures.
991      * @param to address representing the new owner of the given token ID
992      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
993      */
994     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
995         uint256 length = ERC721.balanceOf(to);
996         _ownedTokens[to][length] = tokenId;
997         _ownedTokensIndex[tokenId] = length;
998     }
999 
1000     /**
1001      * @dev Private function to add a token to this extension's token tracking data structures.
1002      * @param tokenId uint256 ID of the token to be added to the tokens list
1003      */
1004     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1005         _allTokensIndex[tokenId] = _allTokens.length;
1006         _allTokens.push(tokenId);
1007     }
1008 
1009     /**
1010      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1011      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1012      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1013      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1014      * @param from address representing the previous owner of the given token ID
1015      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1016      */
1017     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1018         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1019         // then delete the last slot (swap and pop).
1020 
1021         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1022         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1023 
1024         // When the token to delete is the last token, the swap operation is unnecessary
1025         if (tokenIndex != lastTokenIndex) {
1026             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1027 
1028             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1029             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1030         }
1031 
1032         // This also deletes the contents at the last position of the array
1033         delete _ownedTokensIndex[tokenId];
1034         delete _ownedTokens[from][lastTokenIndex];
1035     }
1036 
1037     /**
1038      * @dev Private function to remove a token from this extension's token tracking data structures.
1039      * This has O(1) time complexity, but alters the order of the _allTokens array.
1040      * @param tokenId uint256 ID of the token to be removed from the tokens list
1041      */
1042     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1043         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1044         // then delete the last slot (swap and pop).
1045 
1046         uint256 lastTokenIndex = _allTokens.length - 1;
1047         uint256 tokenIndex = _allTokensIndex[tokenId];
1048 
1049         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1050         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1051         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1052         uint256 lastTokenId = _allTokens[lastTokenIndex];
1053 
1054         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1055         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1056 
1057         // This also deletes the contents at the last position of the array
1058         delete _allTokensIndex[tokenId];
1059         _allTokens.pop();
1060     }
1061 }
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 /**
1066  * @dev ERC721 token with storage based token URI management.
1067  */
1068 abstract contract ERC721URIStorage is ERC721 {
1069     using Strings for uint256;
1070 
1071     // Optional mapping for token URIs
1072     mapping(uint256 => string) private _tokenURIs;
1073 
1074     /**
1075      * @dev See {IERC721Metadata-tokenURI}.
1076      */
1077     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1078         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1079 
1080         string memory _tokenURI = _tokenURIs[tokenId];
1081         string memory base = _baseURI();
1082 
1083         // If there is no base URI, return the token URI.
1084         if (bytes(base).length == 0) {
1085             return _tokenURI;
1086         }
1087         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1088         if (bytes(_tokenURI).length > 0) {
1089             return string(abi.encodePacked(base, _tokenURI));
1090         }
1091 
1092         return super.tokenURI(tokenId);
1093     }
1094 
1095     /**
1096      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      */
1102     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1103         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1104         _tokenURIs[tokenId] = _tokenURI;
1105     }
1106 
1107     /**
1108      * @dev Destroys `tokenId`.
1109      * The approval is cleared when the token is burned.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _burn(uint256 tokenId) internal virtual override {
1118         super._burn(tokenId);
1119 
1120         if (bytes(_tokenURIs[tokenId]).length != 0) {
1121             delete _tokenURIs[tokenId];
1122         }
1123     }
1124 }
1125 
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 /**
1130  * @title ERC721 token receiver interface
1131  * @dev Interface for any contract that wants to support safeTransfers
1132  * from ERC721 asset contracts.
1133  */
1134 interface IERC721Receiver {
1135     /**
1136      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1137      * by `operator` from `from`, this function is called.
1138      *
1139      * It must return its Solidity selector to confirm the token transfer.
1140      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1141      *
1142      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1143      */
1144     function onERC721Received(
1145         address operator,
1146         address from,
1147         uint256 tokenId,
1148         bytes calldata data
1149     ) external returns (bytes4);
1150 }
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 /**
1155  * @dev Contract module which provides a basic access control mechanism, where
1156  * there is an account (an owner) that can be granted exclusive access to
1157  * specific functions.
1158  *
1159  * By default, the owner account will be the one that deploys the contract. This
1160  * can later be changed with {transferOwnership}.
1161  *
1162  * This module is used through inheritance. It will make available the modifier
1163  * `onlyOwner`, which can be applied to your functions to restrict their use to
1164  * the owner.
1165  */
1166 abstract contract Ownable is Context {
1167     address private _owner;
1168 
1169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1170 
1171     /**
1172      * @dev Initializes the contract setting the deployer as the initial owner.
1173      */
1174     constructor() {
1175         _setOwner(_msgSender());
1176     }
1177 
1178     /**
1179      * @dev Returns the address of the current owner.
1180      */
1181     function owner() public view virtual returns (address) {
1182         return _owner;
1183     }
1184 
1185     /**
1186      * @dev Throws if called by any account other than the owner.
1187      */
1188     modifier onlyOwner() {
1189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1190         _;
1191     }
1192 
1193     /**
1194      * @dev Leaves the contract without owner. It will not be possible to call
1195      * `onlyOwner` functions anymore. Can only be called by the current owner.
1196      *
1197      * NOTE: Renouncing ownership will leave the contract without an owner,
1198      * thereby removing any functionality that is only available to the owner.
1199      */
1200     function renounceOwnership() public virtual onlyOwner {
1201         _setOwner(address(0));
1202     }
1203 
1204     /**
1205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1206      * Can only be called by the current owner.
1207      */
1208     function transferOwnership(address newOwner) public virtual onlyOwner {
1209         require(newOwner != address(0), "Ownable: new owner is the zero address");
1210         _setOwner(newOwner);
1211     }
1212 
1213     function _setOwner(address newOwner) private {
1214         address oldOwner = _owner;
1215         _owner = newOwner;
1216         emit OwnershipTransferred(oldOwner, newOwner);
1217     }
1218 }
1219 
1220 pragma solidity ^0.8.0;
1221 
1222 /**
1223  * @dev String operations.
1224  */
1225 library Strings {
1226     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1227 
1228     /**
1229      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1230      */
1231     function toString(uint256 value) internal pure returns (string memory) {
1232         // Inspired by OraclizeAPI's implementation - MIT licence
1233         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1234 
1235         if (value == 0) {
1236             return "0";
1237         }
1238         uint256 temp = value;
1239         uint256 digits;
1240         while (temp != 0) {
1241             digits++;
1242             temp /= 10;
1243         }
1244         bytes memory buffer = new bytes(digits);
1245         while (value != 0) {
1246             digits -= 1;
1247             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1248             value /= 10;
1249         }
1250         return string(buffer);
1251     }
1252 
1253     /**
1254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1255      */
1256     function toHexString(uint256 value) internal pure returns (string memory) {
1257         if (value == 0) {
1258             return "0x00";
1259         }
1260         uint256 temp = value;
1261         uint256 length = 0;
1262         while (temp != 0) {
1263             length++;
1264             temp >>= 8;
1265         }
1266         return toHexString(value, length);
1267     }
1268 
1269     /**
1270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1271      */
1272     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1273         bytes memory buffer = new bytes(2 * length + 2);
1274         buffer[0] = "0";
1275         buffer[1] = "x";
1276         for (uint256 i = 2 * length + 1; i > 1; --i) {
1277             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1278             value >>= 4;
1279         }
1280         require(value == 0, "Strings: hex length insufficient");
1281         return string(buffer);
1282     }
1283 }
1284 
1285 
1286 /**
1287 ::::::ccclccccclloooollooodxxxxxxxxdddxxkkkkkkkkO00000000OOkkkkkkxxdddxxxxxxxdoolllooolccccccc::::::
1288 ccccllcccccllloooollooddxxxxxxxddxxxkkkkkkkOO000000000000000OOOkkkkkkxxxxxxxxxxxddoollloollccccccc::
1289 llcccclllooooollooddxxxxxxxxxxxxkkkkkkkOO000OOO0KKK0000KK000OOOOOOkkkkkOkkkxxxxxxxxxddoolllolllccccc
1290 cclllooooollloodxxxxxxxxxxxkkOkkkOOO00000OkkOkOOK00kxkkkkxxkkkkkkOO0OOkkkkOOkkkxxxxxxxxxddoooloollcc
1291 looooolllooddxxxxxxxxxkkkOOkOOO000000OkkOkkO0Oxoc,.. .';coddddxxdxkkkkOOOOkkkkOOkkxxxdxxxxxxddoollll
1292 oooolooddxxxxxxxxxkkkkOOOOO000000OOOOOkk0Oxoc,.          .';coddddxxxxkkkkkOOOkkkkOOkkxxxddxxxxxdool
1293 oooloxxxxxxxxxkkkkOOOO0000O000O00OkkOOxoc,.                  .';coxxdxxxxxkkkxkkOOkkkOOOkkxxddxxxxxx
1294 oolldxxdxxkkkkkOOO000OO000O000OOOOxo:,.                          .';coxxdxkkkxkkxxkkkOkkkOOOkxddxxxx
1295 oolldxxdxOkkkOO00OO00OOO0OOkOOxo:,.                                  .';coxxdk0K0OkxkOOOOkkkkOxdxxxx
1296 oolldxddkOxk00O00OOOOOxxkkxl:,.                                          .';:oxkO0K0000OO00xxOxdxxxx
1297 oolldxddkOkkO0OOOkxxkkdl:,.                                                  ..,ckKKK0KKOO0kxOxdxxxx
1298 oocldxddkOxxkkxxxkdc:,.                                                          lkkK0KKOO0kxOxdxxxx
1299 oollxxdxkkxxddxxkc.                                                              :dd00KKOO0kxOxdxxxx
1300 ooloxxdxOkxxdddxk,                                                               :ddOOKKOO0kxOxdxxxx
1301 ooloxxxxOkxxxxxxk,                                                               :ddOO00OO0kxOxdxxxx
1302 ooldxxxxOkxkOOxxk,            ..'''.                           .',;;,.           :ddOkk0OO0kkOxdxxxx
1303 ooldxxxxOkxkO0xxk,           'kOdodkxc.     'c.              cOOkkkko.           :ddOkk0OO0kkOkxxxxx
1304 ooodxxdxOxkk00dxk,           :Kl   .c0d.    cXo       ::    .dWx.                :ddOkk0OO0kkOkxxxxx
1305 olodxxdxOxkO00dxk,           :Kc    .dO.    lW0,     .OO'    lNx.                :doOkk0OO0kkOkdxxxx
1306 olodxxdxOxkO00kkk,           ;Kk::::o0o     oWWd.    :XNl    :Xk.                :doOkk0OO0kkOkdxxxx
1307 olldxxdxOxkO0K0KO,           ;KOcccldkkc.  .dX0O;   .xKKO'   ,KO.                :dokkk0OO0kkOxdxxxx
1308 olldxxdxOkkOOK00k,           ;0l      ;Ok. .k0:xx.  ;0lc0l   .O0'                :dokkk0OO0kkOxdxxxx
1309 ollxxxdxOkkOOK0Od,           ,0l       ,Oc .Ok.,k: .dO'.xO.  .xK,                :dokkx0OO0kxOxdxxxx
1310 oclxxxdkOkkkOK0kd,           ,0o       .kl '0x. lxclOo  :Kl   dX:                :dokkxOOO0xxOxddxxx
1311 ocoxxxdkkkOk000kd,           ,0o       :O; ,0d  .xXX0,  .kO.  lXc                :dokxxOOO0xkOxodxxx
1312 oloxxddkkkOO00Okd,           '0x.  ..,lkc  ;0l   :OXx.   cKc  ;Kd.               :dokkOKOO0kkOxodxxx
1313 oloxxddkkkOO0kkkd,           .lxlclool:.   ;O:   .'c;    'Ok. .d0kxdxxo.         :dokO0KOO0xkOxodxxx
1314 lldxxdokkkOO0kxkd,                         ...            ,:.   ';cloo:.         :dokk0XOOOxxOkddxxx
1315 lldxxddkkkO0Kxxkd,                                                               :dokO0X00OxxOkddxxx
1316 lldxxddkxkO0Kxxxd,                                                               :dokO0X0OOxkOkddxxx
1317 lldxxddkxkOO0kxxo,                                                               :od000XOOOxkOkddxxx
1318 lldxxdxkxkOO0kxdo,                                                               :od0O0X0OOxkOkddxxx
1319 loxxxdxkxkOOKkxdo,                                                              .lod00KXOOOxkOkddxxx
1320 loxxxdxkxkO0Kkxdo,                                                          .':cdkxkK0KKOOOxkOkddxxx
1321 loxxxdxkxOO0K00xol,..                                                   .':ldkkxxkO00000O0OxkOkddxxx
1322 loxxxdxkkOOO000Oxxxdl:,.                                            .,:ldkkxxkOOO00000000OkkOOkddxxx
1323 loxxxxkkkO00O0000Okkxxxxdoloc'.                                 .':ldkkxxkOOO000000000OOkkOOOkxddxxx
1324 loxxxdxOkkkkO0000000OOkkk000Okdc;'.                         .,:ldkkxxxkOO00000000OOOOOOOOkkxxddxxxxd
1325 llodxddxxkOkkkkkO00000000Okkkkxxxxoc;'.                 .,:ldkkxxkkkO00000000OkkkkOOOkkxxxdxxxxxdool
1326 oollodxxxxxxkOkkxkkO0000000KKK0Okkddddoc:,.         .,:ldkkxdkOOO00000000OkkkkkOOkkxxddxxxxxddoolloo
1327 lloooloodxxxxxxkkkkxkkO000000000000Okxddxxol:,..,:cldkkxdxkOO00000000OkkkkkOOkkxxddxxxxxdddoollooooo
1328 ccllloooooddxxxxxxkkOkkkkO0000000000000OOOOO0KOOOOkxdxkkO0000O000OkkkkkOOkkxxxdxxxxxxddoooloooooollc
1329 lccccllooolooddxxxxxxxkOkkkkkkkkOO00O000KKKKKKK00OOOO000000000OkkkkOOOkxxddxxxxxxddoooloooooollccccc
1330 ccclccccloooolloodxxxxdxxkOOOOOOkkkkO00OO0000KKKKKK0000000OkkkkkOOkxxxddxxxxxddoolloooooollcccccccll
1331 :::clllccclloooolloodxxxxxxxkkkkkOOkkkkOO00O0000000000OOkkkkOOkxxxxxxxxxxxdoollloooooollccccclclllll
1332 :::::ccllccccllooollloddxxxxxxxxxxkkOOkkkkOO00000OOOkkkkOOkxxxddxxxxxxdooolloooooollccccccllcllllcc:
1333 ;:::;::cccllcccllooooolloddxxxxxxxxxxxkkOOkkkOOOkkkkOOkxxxddxxxxxxddoolllooooolllcccclllcclllccc::::
1334 ',;;::::::ccllcccclloooooloooddxxxxxxxxxxkkOOOOOOkkkxxddxxxxxxxdoolllooooolllccccclccllllccc::::::::
1335 ''',;;::::::cclccccccllllooollloodxxxxxxxxxxxkxxxdddxxxxxxxdoollloooooollcccccllcllcclcc::::::::::;;
1336 ''''',;:::::::cccllcccccccooooolllodxxxxxxxxxdddxxxxxxxxxdolllooooooolccccccclllllllcc:;::::::::;,,'
1337 
1338    Blockchain Miners NFTs are hand drawn rare and unique artworks that come with
1339    a real utility. Our unique artworks are inspired by Bitcoin miners (AntminerS19j ASIC Pro)
1340    and will be limited to 11111 items that are generated from 250+ traits and attributes.
1341 */
1342 
1343 
1344 pragma solidity >=0.7.0 <0.9.0;
1345 
1346 contract Blockchain_Miners_Club is ERC721Enumerable, ERC721URIStorage, Ownable {
1347   using Strings for uint256;
1348 
1349   string public baseURI;
1350   uint256 public price = 0.07 ether;
1351   uint256 public maxSupply = 11111;
1352   uint256 public burnCount;
1353   uint256 public reservedRemaining = 241;
1354   uint256 public maxMintAmount = 8;
1355   uint256 public nftPerAddressLimit = 3;
1356   bool public saleStatus = false;
1357   bool public preSaleStatus = false;
1358   
1359   mapping (address => uint256) public presaleWhitelist;
1360 
1361   constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
1362     setBaseURI("ipfs://QmazLZ6FKkTyVcLDhW4ieiAQWrD5Ri4r1FF95n51CLAyFQ/");
1363   }
1364 
1365   function mint(uint256 _mintAmount) public payable {
1366     require(saleStatus, "Sale not active");
1367     uint256 supply = totalSupply() + burnCount;
1368     require(_mintAmount > 0, "Need to mint at least 1 NFT");
1369     require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1370     require(supply + _mintAmount <= maxSupply - reservedRemaining, "Max NFT limit exceeded");
1371     require(msg.value >= price * _mintAmount, "insufficient payment value");
1372 
1373     
1374     if(preSaleStatus == true) {
1375         uint256 reserved = presaleWhitelist[msg.sender];
1376         require(reserved > 0, "No tokens reserved for this address");
1377         require(_mintAmount <= reserved, "Can't mint more than reserved");
1378         presaleWhitelist[msg.sender] = reserved - _mintAmount;
1379     }
1380        
1381     for (uint256 i = 1; i <= _mintAmount; i++) {
1382         _safeMint(msg.sender, supply + i);
1383     }
1384   }
1385 
1386   function walletMiners(address _owner) external view returns (uint256[] memory) {
1387       uint256 tokenCount = balanceOf(_owner);
1388       uint256[] memory tokensId = new uint256[](tokenCount);
1389       for (uint256 i = 0; i < tokenCount; i++) {
1390         tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1391       }
1392         return tokensId;
1393     }
1394 
1395   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1396     nftPerAddressLimit = _limit;
1397   }
1398   
1399   function setCost(uint256 _newPrice) public onlyOwner {
1400     price = _newPrice;
1401   }
1402 
1403   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1404     maxMintAmount = _newmaxMintAmount;
1405   }
1406 
1407   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1408     baseURI = _newBaseURI;
1409   }
1410   
1411    /*
1412     * Mint 241 reserved NFTs for giveaways, devs, etc.
1413    */
1414   function reserveMint(uint256 reservedAmount) public onlyOwner {
1415        require(reservedAmount <= reservedRemaining, "Remaining reserve too small");
1416        require(reservedAmount > 0, "Need to mint at least 1 NFT");
1417        uint256 supply = totalSupply() + burnCount;
1418        reservedRemaining -= reservedAmount;
1419         for (uint256 i = 1; i <= reservedAmount; i++) {
1420          _safeMint(msg.sender, supply + i); 
1421          
1422         }
1423   }
1424 
1425   function saleState(bool _state) public onlyOwner {
1426         saleStatus = _state;
1427   }
1428   
1429   function presaleState(bool _prestate) public onlyOwner {
1430         preSaleStatus = _prestate;
1431   }
1432   
1433   function _baseURI() internal view virtual override returns (string memory) {
1434     return baseURI;
1435   }
1436 
1437   function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
1438         return super.tokenURI(_tokenId);
1439   }
1440   
1441   function getReserveRemaining() public view returns (uint256){
1442         return reservedRemaining;
1443   }
1444   
1445   function getSaleStatus() public view returns (bool){
1446         return saleStatus;
1447   }
1448   
1449   function getPresaleStatus() public view returns (bool){
1450         return preSaleStatus;
1451   }
1452   
1453   function whitelistUsers(address[] calldata presaleAddresses) external onlyOwner {
1454         for(uint256 i; i < presaleAddresses.length; i++){
1455             presaleWhitelist[presaleAddresses[i]] = nftPerAddressLimit;
1456         }
1457    }
1458  
1459   function isApprovedForAll(address _owner, address _operator) public override view returns (bool isOperator) {
1460         if (_operator == address(0xa5409ec958C83C3f309868babACA7c86DCB077c1)) {     // OpenSea approval
1461             return true;
1462         }
1463         
1464         return ERC721.isApprovedForAll(_owner, _operator);
1465     }
1466  
1467   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable){
1468         super._beforeTokenTransfer(from, to, tokenId);
1469     }
1470  
1471   function burn(uint256 tokenId) public {
1472         require(_isApprovedOrOwner(_msgSender(), tokenId));
1473         burnCount++;
1474         _burn(tokenId);
1475     }
1476     
1477   function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
1478         super._burn(_tokenId);
1479   }
1480  
1481   function withdraw() public payable onlyOwner {
1482         uint256 currentBalance = address(this).balance;
1483         (bool sent, ) = address(msg.sender).call{value: currentBalance}('');
1484         require(sent,"Error while transferring balance");    
1485   }
1486   
1487   function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool){
1488         return super.supportsInterface(interfaceId);
1489     }
1490   
1491 }