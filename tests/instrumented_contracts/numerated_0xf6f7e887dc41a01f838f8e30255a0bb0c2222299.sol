1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /** import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; **/
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 
165 /**
166  * @title ERC721 token receiver interface
167  * @dev Interface for any contract that wants to support safeTransfers
168  * from ERC721 asset contracts.
169  */
170 interface IERC721Receiver {
171     /**
172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
173      * by `operator` from `from`, this function is called.
174      *
175      * It must return its Solidity selector to confirm the token transfer.
176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
177      *
178      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
179      */
180     function onERC721Received(
181         address operator,
182         address from,
183         uint256 tokenId,
184         bytes calldata data
185     ) external returns (bytes4);
186 }
187 
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Metadata is IERC721 {
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         assembly {
237             size := extcodesize(account)
238         }
239         return size > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 /**
423  * @dev Provides information about the current execution context, including the
424  * sender of the transaction and its data. While these are generally available
425  * via msg.sender and msg.data, they should not be accessed in such a direct
426  * manner, since when dealing with meta-transactions the account sending and
427  * paying for execution may not be the actual sender (as far as an application
428  * is concerned).
429  *
430  * This contract is only required for intermediate, library-like contracts.
431  */
432 abstract contract Context {
433     function _msgSender() internal view virtual returns (address) {
434         return msg.sender;
435     }
436 
437     function _msgData() internal view virtual returns (bytes calldata) {
438         return msg.data;
439     }
440 }
441 
442 /**
443  * @dev Implementation of the {IERC165} interface.
444  *
445  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
446  * for the additional interface id that will be supported. For example:
447  *
448  * ```solidity
449  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
450  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
451  * }
452  * ```
453  *
454  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
455  */
456 abstract contract ERC165 is IERC165 {
457     /**
458      * @dev See {IERC165-supportsInterface}.
459      */
460     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
461         return interfaceId == type(IERC165).interfaceId;
462     }
463 }
464 
465 /**
466  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
467  * the Metadata extension, but not including the Enumerable extension, which is available separately as
468  * {ERC721Enumerable}.
469  */
470 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
471     using Address for address;
472     using Strings for uint256;
473 
474     // Token name
475     string private _name;
476 
477     // Token symbol
478     string private _symbol;
479 
480     // Mapping from token ID to owner address
481     mapping(uint256 => address) private _owners;
482 
483     // Mapping owner address to token count
484     mapping(address => uint256) private _balances;
485 
486     // Mapping from token ID to approved address
487     mapping(uint256 => address) private _tokenApprovals;
488 
489     // Mapping from owner to operator approvals
490     mapping(address => mapping(address => bool)) private _operatorApprovals;
491 
492     /**
493      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
494      */
495     constructor(string memory name_, string memory symbol_) {
496         _name = name_;
497         _symbol = symbol_;
498     }
499 
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
504         return
505             interfaceId == type(IERC721).interfaceId ||
506             interfaceId == type(IERC721Metadata).interfaceId ||
507             super.supportsInterface(interfaceId);
508     }
509 
510     /**
511      * @dev See {IERC721-balanceOf}.
512      */
513     function balanceOf(address owner) public view virtual override returns (uint256) {
514         require(owner != address(0), "ERC721: balance query for the zero address");
515         return _balances[owner];
516     }
517 
518     /**
519      * @dev See {IERC721-ownerOf}.
520      */
521     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
522         address owner = _owners[tokenId];
523         require(owner != address(0), "ERC721: owner query for nonexistent token");
524         return owner;
525     }
526 
527     /**
528      * @dev See {IERC721Metadata-name}.
529      */
530     function name() public view virtual override returns (string memory) {
531         return _name;
532     }
533 
534     /**
535      * @dev See {IERC721Metadata-symbol}.
536      */
537     function symbol() public view virtual override returns (string memory) {
538         return _symbol;
539     }
540 
541     /**
542      * @dev See {IERC721Metadata-tokenURI}.
543      */
544     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
545         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
546 
547         string memory baseURI = _baseURI();
548         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
549     }
550 
551     /**
552      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
553      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
554      * by default, can be overriden in child contracts.
555      */
556     function _baseURI() internal view virtual returns (string memory) {
557         return "";
558     }
559 
560     /**
561      * @dev See {IERC721-approve}.
562      */
563     function approve(address to, uint256 tokenId) public virtual override {
564         address owner = ERC721.ownerOf(tokenId);
565         require(to != owner, "ERC721: approval to current owner");
566 
567         require(
568             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
569             "ERC721: approve caller is not owner nor approved for all"
570         );
571 
572         _approve(to, tokenId);
573     }
574 
575     /**
576      * @dev See {IERC721-getApproved}.
577      */
578     function getApproved(uint256 tokenId) public view virtual override returns (address) {
579         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
580 
581         return _tokenApprovals[tokenId];
582     }
583 
584     /**
585      * @dev See {IERC721-setApprovalForAll}.
586      */
587     function setApprovalForAll(address operator, bool approved) public virtual override {
588         _setApprovalForAll(_msgSender(), operator, approved);
589     }
590 
591     /**
592      * @dev See {IERC721-isApprovedForAll}.
593      */
594     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
595         return _operatorApprovals[owner][operator];
596     }
597 
598     /**
599      * @dev See {IERC721-transferFrom}.
600      */
601     function transferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) public virtual override {
606         //solhint-disable-next-line max-line-length
607         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
608 
609         _transfer(from, to, tokenId);
610     }
611 
612     /**
613      * @dev See {IERC721-safeTransferFrom}.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) public virtual override {
620         safeTransferFrom(from, to, tokenId, "");
621     }
622 
623     /**
624      * @dev See {IERC721-safeTransferFrom}.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes memory _data
631     ) public virtual override {
632         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
633         _safeTransfer(from, to, tokenId, _data);
634     }
635 
636     /**
637      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
638      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
639      *
640      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
641      *
642      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
643      * implement alternative mechanisms to perform token transfer, such as signature-based.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must exist and be owned by `from`.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function _safeTransfer(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes memory _data
659     ) internal virtual {
660         _transfer(from, to, tokenId);
661         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
662     }
663 
664     /**
665      * @dev Returns whether `tokenId` exists.
666      *
667      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
668      *
669      * Tokens start existing when they are minted (`_mint`),
670      * and stop existing when they are burned (`_burn`).
671      */
672     function _exists(uint256 tokenId) internal view virtual returns (bool) {
673         return _owners[tokenId] != address(0);
674     }
675 
676     /**
677      * @dev Returns whether `spender` is allowed to manage `tokenId`.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
684         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
685         address owner = ERC721.ownerOf(tokenId);
686         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
687     }
688 
689     /**
690      * @dev Safely mints `tokenId` and transfers it to `to`.
691      *
692      * Requirements:
693      *
694      * - `tokenId` must not exist.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function _safeMint(address to, uint256 tokenId) internal virtual {
700         _safeMint(to, tokenId, "");
701     }
702 
703     /**
704      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
705      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
706      */
707     function _safeMint(
708         address to,
709         uint256 tokenId,
710         bytes memory _data
711     ) internal virtual {
712         _mint(to, tokenId);
713         require(
714             _checkOnERC721Received(address(0), to, tokenId, _data),
715             "ERC721: transfer to non ERC721Receiver implementer"
716         );
717     }
718 
719     /**
720      * @dev Mints `tokenId` and transfers it to `to`.
721      *
722      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
723      *
724      * Requirements:
725      *
726      * - `tokenId` must not exist.
727      * - `to` cannot be the zero address.
728      *
729      * Emits a {Transfer} event.
730      */
731     function _mint(address to, uint256 tokenId) internal virtual {
732         require(to != address(0), "ERC721: mint to the zero address");
733         require(!_exists(tokenId), "ERC721: token already minted");
734 
735         _beforeTokenTransfer(address(0), to, tokenId);
736 
737         _balances[to] += 1;
738         _owners[tokenId] = to;
739 
740         emit Transfer(address(0), to, tokenId);
741     }
742 
743     /**
744      * @dev Destroys `tokenId`.
745      * The approval is cleared when the token is burned.
746      *
747      * Requirements:
748      *
749      * - `tokenId` must exist.
750      *
751      * Emits a {Transfer} event.
752      */
753     function _burn(uint256 tokenId) internal virtual {
754         address owner = ERC721.ownerOf(tokenId);
755 
756         _beforeTokenTransfer(owner, address(0), tokenId);
757 
758         // Clear approvals
759         _approve(address(0), tokenId);
760 
761         _balances[owner] -= 1;
762         delete _owners[tokenId];
763 
764         emit Transfer(owner, address(0), tokenId);
765     }
766 
767     /**
768      * @dev Transfers `tokenId` from `from` to `to`.
769      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
770      *
771      * Requirements:
772      *
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must be owned by `from`.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _transfer(
779         address from,
780         address to,
781         uint256 tokenId
782     ) internal virtual {
783         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
784         require(to != address(0), "ERC721: transfer to the zero address");
785 
786         _beforeTokenTransfer(from, to, tokenId);
787 
788         // Clear approvals from the previous owner
789         _approve(address(0), tokenId);
790 
791         _balances[from] -= 1;
792         _balances[to] += 1;
793         _owners[tokenId] = to;
794 
795         emit Transfer(from, to, tokenId);
796     }
797 
798     /**
799      * @dev Approve `to` to operate on `tokenId`
800      *
801      * Emits a {Approval} event.
802      */
803     function _approve(address to, uint256 tokenId) internal virtual {
804         _tokenApprovals[tokenId] = to;
805         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
806     }
807 
808     /**
809      * @dev Approve `operator` to operate on all of `owner` tokens
810      *
811      * Emits a {ApprovalForAll} event.
812      */
813     function _setApprovalForAll(
814         address owner,
815         address operator,
816         bool approved
817     ) internal virtual {
818         require(owner != operator, "ERC721: approve to caller");
819         _operatorApprovals[owner][operator] = approved;
820         emit ApprovalForAll(owner, operator, approved);
821     }
822 
823     /**
824      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
825      * The call is not executed if the target address is not a contract.
826      *
827      * @param from address representing the previous owner of the given token ID
828      * @param to target address that will receive the tokens
829      * @param tokenId uint256 ID of the token to be transferred
830      * @param _data bytes optional data to send along with the call
831      * @return bool whether the call correctly returned the expected magic value
832      */
833     function _checkOnERC721Received(
834         address from,
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) private returns (bool) {
839         if (to.isContract()) {
840             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
841                 return retval == IERC721Receiver.onERC721Received.selector;
842             } catch (bytes memory reason) {
843                 if (reason.length == 0) {
844                     revert("ERC721: transfer to non ERC721Receiver implementer");
845                 } else {
846                     assembly {
847                         revert(add(32, reason), mload(reason))
848                     }
849                 }
850             }
851         } else {
852             return true;
853         }
854     }
855 
856     /**
857      * @dev Hook that is called before any token transfer. This includes minting
858      * and burning.
859      *
860      * Calling conditions:
861      *
862      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
863      * transferred to `to`.
864      * - When `from` is zero, `tokenId` will be minted for `to`.
865      * - When `to` is zero, ``from``'s `tokenId` will be burned.
866      * - `from` and `to` are never both zero.
867      *
868      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
869      */
870     function _beforeTokenTransfer(
871         address from,
872         address to,
873         uint256 tokenId
874     ) internal virtual {}
875 }
876 
877 /** import "@openzeppelin/contracts/utils/math/SafeMath.sol"; **/
878 
879 /**
880  * @dev Wrappers over Solidity's arithmetic operations.
881  *
882  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
883  * now has built in overflow checking.
884  */
885 library SafeMath {
886     /**
887      * @dev Returns the addition of two unsigned integers, with an overflow flag.
888      *
889      * _Available since v3.4._
890      */
891     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
892         unchecked {
893             uint256 c = a + b;
894             if (c < a) return (false, 0);
895             return (true, c);
896         }
897     }
898 
899     /**
900      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
901      *
902      * _Available since v3.4._
903      */
904     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
905         unchecked {
906             if (b > a) return (false, 0);
907             return (true, a - b);
908         }
909     }
910 
911     /**
912      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
913      *
914      * _Available since v3.4._
915      */
916     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
917         unchecked {
918             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
919             // benefit is lost if 'b' is also tested.
920             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
921             if (a == 0) return (true, 0);
922             uint256 c = a * b;
923             if (c / a != b) return (false, 0);
924             return (true, c);
925         }
926     }
927 
928     /**
929      * @dev Returns the division of two unsigned integers, with a division by zero flag.
930      *
931      * _Available since v3.4._
932      */
933     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
934         unchecked {
935             if (b == 0) return (false, 0);
936             return (true, a / b);
937         }
938     }
939 
940     /**
941      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
942      *
943      * _Available since v3.4._
944      */
945     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
946         unchecked {
947             if (b == 0) return (false, 0);
948             return (true, a % b);
949         }
950     }
951 
952     /**
953      * @dev Returns the addition of two unsigned integers, reverting on
954      * overflow.
955      *
956      * Counterpart to Solidity's `+` operator.
957      *
958      * Requirements:
959      *
960      * - Addition cannot overflow.
961      */
962     function add(uint256 a, uint256 b) internal pure returns (uint256) {
963         return a + b;
964     }
965 
966     /**
967      * @dev Returns the subtraction of two unsigned integers, reverting on
968      * overflow (when the result is negative).
969      *
970      * Counterpart to Solidity's `-` operator.
971      *
972      * Requirements:
973      *
974      * - Subtraction cannot overflow.
975      */
976     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
977         return a - b;
978     }
979 
980     /**
981      * @dev Returns the multiplication of two unsigned integers, reverting on
982      * overflow.
983      *
984      * Counterpart to Solidity's `*` operator.
985      *
986      * Requirements:
987      *
988      * - Multiplication cannot overflow.
989      */
990     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
991         return a * b;
992     }
993 
994     /**
995      * @dev Returns the integer division of two unsigned integers, reverting on
996      * division by zero. The result is rounded towards zero.
997      *
998      * Counterpart to Solidity's `/` operator.
999      *
1000      * Requirements:
1001      *
1002      * - The divisor cannot be zero.
1003      */
1004     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1005         return a / b;
1006     }
1007 
1008     /**
1009      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1010      * reverting when dividing by zero.
1011      *
1012      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1013      * opcode (which leaves remaining gas untouched) while Solidity uses an
1014      * invalid opcode to revert (consuming all remaining gas).
1015      *
1016      * Requirements:
1017      *
1018      * - The divisor cannot be zero.
1019      */
1020     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1021         return a % b;
1022     }
1023 
1024     /**
1025      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1026      * overflow (when the result is negative).
1027      *
1028      * CAUTION: This function is deprecated because it requires allocating memory for the error
1029      * message unnecessarily. For custom revert reasons use {trySub}.
1030      *
1031      * Counterpart to Solidity's `-` operator.
1032      *
1033      * Requirements:
1034      *
1035      * - Subtraction cannot overflow.
1036      */
1037     function sub(
1038         uint256 a,
1039         uint256 b,
1040         string memory errorMessage
1041     ) internal pure returns (uint256) {
1042         unchecked {
1043             require(b <= a, errorMessage);
1044             return a - b;
1045         }
1046     }
1047 
1048     /**
1049      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1050      * division by zero. The result is rounded towards zero.
1051      *
1052      * Counterpart to Solidity's `/` operator. Note: this function uses a
1053      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1054      * uses an invalid opcode to revert (consuming all remaining gas).
1055      *
1056      * Requirements:
1057      *
1058      * - The divisor cannot be zero.
1059      */
1060     function div(
1061         uint256 a,
1062         uint256 b,
1063         string memory errorMessage
1064     ) internal pure returns (uint256) {
1065         unchecked {
1066             require(b > 0, errorMessage);
1067             return a / b;
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1073      * reverting with custom message when dividing by zero.
1074      *
1075      * CAUTION: This function is deprecated because it requires allocating memory for the error
1076      * message unnecessarily. For custom revert reasons use {tryMod}.
1077      *
1078      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1079      * opcode (which leaves remaining gas untouched) while Solidity uses an
1080      * invalid opcode to revert (consuming all remaining gas).
1081      *
1082      * Requirements:
1083      *
1084      * - The divisor cannot be zero.
1085      */
1086     function mod(
1087         uint256 a,
1088         uint256 b,
1089         string memory errorMessage
1090     ) internal pure returns (uint256) {
1091         unchecked {
1092             require(b > 0, errorMessage);
1093             return a % b;
1094         }
1095     }
1096 }
1097 
1098 /** import "@openzeppelin/contracts/utils/Counters.sol"; **/
1099 
1100 /**
1101  * @title Counters
1102  * @author Matt Condon (@shrugs)
1103  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1104  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1105  *
1106  * Include with `using Counters for Counters.Counter;`
1107  */
1108 library Counters {
1109     struct Counter {
1110         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1111         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1112         // this feature: see https://github.com/ethereum/solidity/issues/4637
1113         uint256 _value; // default: 0
1114     }
1115 
1116     function current(Counter storage counter) internal view returns (uint256) {
1117         return counter._value;
1118     }
1119 
1120     function increment(Counter storage counter) internal {
1121         unchecked {
1122             counter._value += 1;
1123         }
1124     }
1125 
1126     function decrement(Counter storage counter) internal {
1127         uint256 value = counter._value;
1128         require(value > 0, "Counter: decrement overflow");
1129         unchecked {
1130             counter._value = value - 1;
1131         }
1132     }
1133 
1134     function reset(Counter storage counter) internal {
1135         counter._value = 0;
1136     }
1137 }
1138 
1139 /** import "@openzeppelin/contracts/access/Ownable.sol"; **/
1140 
1141 /**
1142  * @dev Contract module which provides a basic access control mechanism, where
1143  * there is an account (an owner) that can be granted exclusive access to
1144  * specific functions.
1145  *
1146  * By default, the owner account will be the one that deploys the contract. This
1147  * can later be changed with {transferOwnership}.
1148  *
1149  * This module is used through inheritance. It will make available the modifier
1150  * `onlyOwner`, which can be applied to your functions to restrict their use to
1151  * the owner.
1152  */
1153 abstract contract Ownable is Context {
1154     address private _owner;
1155 
1156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1157 
1158     /**
1159      * @dev Initializes the contract setting the deployer as the initial owner.
1160      */
1161     constructor() {
1162         _transferOwnership(_msgSender());
1163     }
1164 
1165     /**
1166      * @dev Returns the address of the current owner.
1167      */
1168     function owner() public view virtual returns (address) {
1169         return _owner;
1170     }
1171 
1172     /**
1173      * @dev Throws if called by any account other than the owner.
1174      */
1175     modifier onlyOwner() {
1176         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1177         _;
1178     }
1179 
1180     /**
1181      * @dev Leaves the contract without owner. It will not be possible to call
1182      * `onlyOwner` functions anymore. Can only be called by the current owner.
1183      *
1184      * NOTE: Renouncing ownership will leave the contract without an owner,
1185      * thereby removing any functionality that is only available to the owner.
1186      */
1187     function renounceOwnership() public virtual onlyOwner {
1188         _transferOwnership(address(0));
1189     }
1190 
1191     /**
1192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1193      * Can only be called by the current owner.
1194      */
1195     function transferOwnership(address newOwner) public virtual onlyOwner {
1196         require(newOwner != address(0), "Ownable: new owner is the zero address");
1197         _transferOwnership(newOwner);
1198     }
1199 
1200     /**
1201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1202      * Internal function without access restriction.
1203      */
1204     function _transferOwnership(address newOwner) internal virtual {
1205         address oldOwner = _owner;
1206         _owner = newOwner;
1207         emit OwnershipTransferred(oldOwner, newOwner);
1208     }
1209 }
1210 
1211 /** import "@openzeppelin/contracts/utils/Strings.sol"; **/
1212 
1213 /**
1214  * @dev String operations.
1215  */
1216 library Strings {
1217     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1218 
1219     /**
1220      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1221      */
1222     function toString(uint256 value) internal pure returns (string memory) {
1223         // Inspired by OraclizeAPI's implementation - MIT licence
1224         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1225 
1226         if (value == 0) {
1227             return "0";
1228         }
1229         uint256 temp = value;
1230         uint256 digits;
1231         while (temp != 0) {
1232             digits++;
1233             temp /= 10;
1234         }
1235         bytes memory buffer = new bytes(digits);
1236         while (value != 0) {
1237             digits -= 1;
1238             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1239             value /= 10;
1240         }
1241         return string(buffer);
1242     }
1243 
1244     /**
1245      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1246      */
1247     function toHexString(uint256 value) internal pure returns (string memory) {
1248         if (value == 0) {
1249             return "0x00";
1250         }
1251         uint256 temp = value;
1252         uint256 length = 0;
1253         while (temp != 0) {
1254             length++;
1255             temp >>= 8;
1256         }
1257         return toHexString(value, length);
1258     }
1259 
1260     /**
1261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1262      */
1263     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1264         bytes memory buffer = new bytes(2 * length + 2);
1265         buffer[0] = "0";
1266         buffer[1] = "x";
1267         for (uint256 i = 2 * length + 1; i > 1; --i) {
1268             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1269             value >>= 4;
1270         }
1271         require(value == 0, "Strings: hex length insufficient");
1272         return string(buffer);
1273     }
1274 }
1275 
1276 /************************
1277  * The Butt Stuff Contract stuff
1278  **********/
1279 
1280 contract ButtStuff is ERC721, Ownable {
1281   using SafeMath for uint256;
1282   using Strings for uint256;
1283   using Counters for Counters.Counter;
1284   Counters.Counter private _tokenIds;
1285 
1286   /**
1287    * @dev Butt Stuff NFTs 🍑 (mostly taken from Gray Boys ✨👽✨)
1288    * */
1289 
1290   uint256 public constant MAX_BUTT_STUFF = 10000;
1291   uint256 public constant MIN_FREE_BUTT_STUFF = 2222;
1292   uint256 public constant MAX_BUTT_STUFF_PER_FREE = 5;
1293   uint256 public constant MAX_BUTT_STUFF_PER_PURCHASE = 10;
1294     
1295   /* by contract price can never be higher than this (0.005 ETH but in WEI) */
1296   uint256 public constant MAX_BUTT_STUFF_PRICE = 5000000000000000;
1297   uint256 public BUTT_STUFF_PRICE;
1298   uint256 public MAX_BUTT_STUFF_PER_MINT;
1299   uint256 public FREE_BUTT_STUFF_MAX_ID;
1300   
1301   /* initially the base URI will be centralized, for gas optimizations */
1302   /* after full mint, the IPFS hash will be replaced and locked */
1303   string public tokenBaseURI;
1304   string public constant INITIAL_BASE_URI = "https://api.buttstuff.art/nft/";
1305 
1306   bool public mintActive = false;
1307   bool public freeMinting = true;
1308   bool public tokenBaseLocked = false;
1309 
1310   Counters.Counter public tokenSupply;
1311 
1312   /**
1313    * @dev Contract Methods
1314    */
1315 
1316   constructor() ERC721("Stuff up Butts", "BUTTS") {
1317     tokenBaseURI = INITIAL_BASE_URI;
1318     BUTT_STUFF_PRICE = MAX_BUTT_STUFF_PRICE;
1319     MAX_BUTT_STUFF_PER_MINT = MAX_BUTT_STUFF_PER_FREE;
1320     FREE_BUTT_STUFF_MAX_ID = MIN_FREE_BUTT_STUFF;
1321   }
1322 
1323   /************
1324    * Metadata *
1325    ************/
1326 
1327   /*
1328    * the initial base URL will be centralized for optimized gas ...
1329    * while also keeping the metadata safe from being sniped ...
1330    * second method locks that value forever when ready ...
1331    */
1332 
1333   function setTokenBaseURI(string memory _baseURI) 
1334     external onlyOwner {
1335     require(!tokenBaseLocked, "Token Base URI is locked now & forever.");
1336     tokenBaseURI = _baseURI;
1337   }
1338 
1339   function lockTokenBaseURI(bool _lockIn) 
1340     external onlyOwner {
1341     require(!tokenBaseLocked, "Token Base URI is locked now & forever.");
1342     if (_lockIn) {
1343       tokenBaseLocked = true;
1344     }
1345   }
1346 
1347   function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1348     require(_exists(_tokenId), "ERC721Metadata: that token doesn't exist");
1349     return string(abi.encodePacked(tokenBaseURI, _tokenId.toString()));
1350   }
1351 
1352   /********
1353    * Minting *
1354    ********/
1355 
1356   function mint(uint256 _quantity) external payable {
1357     require(mintActive, "Minting is not active.");
1358     require(_quantity <= MAX_BUTT_STUFF_PER_MINT, "Quantity is more than allowed per transaction.");
1359     _safeMintButtStuff(_quantity);
1360   }
1361 
1362   function _safeMintButtStuff(uint256 _quantity) internal {
1363     require(_quantity > 0, "You must mint at least 1 Stuff up Butts");
1364     require(tokenSupply.current().add(_quantity) <= MAX_BUTT_STUFF, "This Tx would exceed max supply of Stuff up Butts NFTs");
1365     if (freeMinting) {
1366       require(tokenSupply.current().add(_quantity) <= FREE_BUTT_STUFF_MAX_ID, "This Tx would exceed max supply of FREE Stuff up Butts NFTs");
1367     }
1368     if (!freeMinting) {
1369       require(msg.value >= BUTT_STUFF_PRICE.mul(_quantity), "The ether value sent is not correct");
1370     }
1371 
1372     for (uint256 i = 0; i < _quantity; i++) {
1373       uint256 mintIndex = tokenSupply.current() + 1;
1374       if (mintIndex <= MAX_BUTT_STUFF) {
1375         tokenSupply.increment();
1376         /* once the FREE limit is hit the max per tx increases */
1377         if (tokenSupply.current() == FREE_BUTT_STUFF_MAX_ID) {
1378           freeMinting = false;
1379           MAX_BUTT_STUFF_PER_MINT = MAX_BUTT_STUFF_PER_PURCHASE;
1380         }
1381         /* once it hits the max, turn off minting */
1382         if (mintIndex == MAX_BUTT_STUFF) {
1383           mintActive = false;
1384         }
1385         _safeMint(msg.sender, mintIndex);
1386       }
1387     }
1388   }
1389 
1390   function setMintActive(bool _active)
1391     external onlyOwner 
1392   {
1393     mintActive = _active;
1394   }
1395 
1396   /* these mostly help with the web3 experience */
1397 
1398   function isMintActive() 
1399     public view 
1400     returns (bool) 
1401   {
1402     return mintActive;
1403   }
1404 
1405   function maxPerMint() 
1406     public view 
1407     returns (uint256) 
1408   {
1409     return MAX_BUTT_STUFF_PER_MINT;
1410   }
1411 
1412   function totalSupply() 
1413     public view 
1414     returns (uint256) 
1415   {
1416     return tokenSupply.current();
1417   }
1418 
1419   function maxFreeTokenId() 
1420     public view 
1421     returns (uint256) 
1422   {
1423     return FREE_BUTT_STUFF_MAX_ID;
1424   }
1425 
1426   /**********
1427   * Pricing *
1428   * enables change in pricing, but only ever downward ...
1429   * who knows maybe all the Butt Stuff will be free $$$ ...
1430   ***************/
1431 
1432   function increaseFreeSupply(uint256 _newMaxTokenId) 
1433     external onlyOwner
1434   {
1435     require(_newMaxTokenId <= MAX_BUTT_STUFF, "Can't give away more than exist, duh");
1436     require(_newMaxTokenId > FREE_BUTT_STUFF_MAX_ID, "Can't lower the number of free ones, duh");
1437     require(_newMaxTokenId > tokenSupply.current(), "New one must be higher than current token");
1438     FREE_BUTT_STUFF_MAX_ID = _newMaxTokenId;
1439     if (!freeMinting) {
1440       freeMinting = true;
1441       MAX_BUTT_STUFF_PER_MINT = MAX_BUTT_STUFF_PER_FREE;
1442     }
1443   }
1444 
1445   function lowerMintPrice(uint256 _newPriceWei) 
1446     external onlyOwner 
1447   {
1448     require(tokenSupply.current() < MAX_BUTT_STUFF, "Minting is done, can't update price anymore");
1449     require(_newPriceWei < BUTT_STUFF_PRICE, "Price can only be lowered, duh");
1450     BUTT_STUFF_PRICE = _newPriceWei;
1451   }
1452 
1453   function getMintPrice() 
1454     public view 
1455     returns (uint256)
1456   {
1457     return BUTT_STUFF_PRICE;
1458   }
1459 
1460   /**************
1461    * Withdrawal *
1462    * these funds will go towards more projects ...
1463    * who know, holding these might be utility for future STUFF & THINGS ...
1464    * butt otherwise, just for cheeky fun ✨🍑✨ ...
1465    **************/
1466 
1467   function withdraw() public onlyOwner {
1468     uint256 balance = address(this).balance;
1469     require(balance > 0, "Nothing to withdraw");
1470     payable(msg.sender).transfer(balance);
1471   }
1472 
1473 }