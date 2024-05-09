1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.7;
8 
9 
10 /**
11  * @title ERC721 token receiver interface
12  * @dev Interface for any contract that wants to support safeTransfers
13  * from ERC721 asset contracts.
14  */
15 interface IERC721Receiver {
16     /**
17      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
18      * by `operator` from `from`, this function is called.
19      *
20      * It must return its Solidity selector to confirm the token transfer.
21      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
22      *
23      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
24      */
25     function onERC721Received(
26         address operator,
27         address from,
28         uint256 tokenId,
29         bytes calldata data
30     ) external returns (bytes4);
31 }
32 
33 
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 
57 /**
58  * @dev Implementation of the {IERC165} interface.
59  *
60  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
61  * for the additional interface id that will be supported. For example:
62  *
63  * ```solidity
64  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
65  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
66  * }
67  * ```
68  *
69  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
70  */
71 abstract contract ERC165 is IERC165 {
72     /**
73      * @dev See {IERC165-supportsInterface}.
74      */
75     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
76         return interfaceId == type(IERC165).interfaceId;
77     }
78 }
79 
80 
81 /**
82  * @dev Required interface of an ERC721 compliant contract.
83  */
84 interface IERC721 is IERC165 {
85     /**
86      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
89 
90     /**
91      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
92      */
93     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
94 
95     /**
96      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
97      */
98     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
99 
100     /**
101      * @dev Returns the number of tokens in ``owner``'s account.
102      */
103     function balanceOf(address owner) external view returns (uint256 balance);
104 
105     /**
106      * @dev Returns the owner of the `tokenId` token.
107      *
108      * Requirements:
109      *
110      * - `tokenId` must exist.
111      */
112     function ownerOf(uint256 tokenId) external view returns (address owner);
113 
114     /**
115      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
116      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
117      *
118      * Requirements:
119      *
120      * - `from` cannot be the zero address.
121      * - `to` cannot be the zero address.
122      * - `tokenId` token must exist and be owned by `from`.
123      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
125      *
126      * Emits a {Transfer} event.
127      */
128     function safeTransferFrom(
129         address from,
130         address to,
131         uint256 tokenId
132     ) external;
133 
134     /**
135      * @dev Transfers `tokenId` token from `from` to `to`.
136      *
137      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must be owned by `from`.
144      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(
149         address from,
150         address to,
151         uint256 tokenId
152     ) external;
153 
154     /**
155      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
156      * The approval is cleared when the token is transferred.
157      *
158      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
159      *
160      * Requirements:
161      *
162      * - The caller must own the token or be an approved operator.
163      * - `tokenId` must exist.
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address to, uint256 tokenId) external;
168 
169     /**
170      * @dev Returns the account approved for `tokenId` token.
171      *
172      * Requirements:
173      *
174      * - `tokenId` must exist.
175      */
176     function getApproved(uint256 tokenId) external view returns (address operator);
177 
178     /**
179      * @dev Approve or remove `operator` as an operator for the caller.
180      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
181      *
182      * Requirements:
183      *
184      * - The `operator` cannot be the caller.
185      *
186      * Emits an {ApprovalForAll} event.
187      */
188     function setApprovalForAll(address operator, bool _approved) external;
189 
190     /**
191      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
192      *
193      * See {setApprovalForAll}
194      */
195     function isApprovedForAll(address owner, address operator) external view returns (bool);
196 
197     /**
198      * @dev Safely transfers `tokenId` token from `from` to `to`.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must exist and be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
207      *
208      * Emits a {Transfer} event.
209      */
210     function safeTransferFrom(
211         address from,
212         address to,
213         uint256 tokenId,
214         bytes calldata data
215     ) external;
216 }
217 
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
221  * @dev See https://eips.ethereum.org/EIPS/eip-721
222  */
223 interface IERC721Metadata is IERC721 {
224     /**
225      * @dev Returns the token collection name.
226      */
227     function name() external view returns (string memory);
228 
229     /**
230      * @dev Returns the token collection symbol.
231      */
232     function symbol() external view returns (string memory);
233 
234     /**
235      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
236      */
237     function tokenURI(uint256 tokenId) external view returns (string memory);
238 }
239 
240 /**
241  * @dev Provides information about the current execution context, including the
242  * sender of the transaction and its data. While these are generally available
243  * via msg.sender and msg.data, they should not be accessed in such a direct
244  * manner, since when dealing with meta-transactions the account sending and
245  * paying for execution may not be the actual sender (as far as an application
246  * is concerned).
247  *
248  * This contract is only required for intermediate, library-like contracts.
249  */
250 abstract contract Context {
251     function _msgSender() internal view virtual returns (address) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes calldata) {
256         return msg.data;
257     }
258 }
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // This method relies on extcodesize, which returns 0 for contracts in
283         // construction, since the code is only stored at the end of the
284         // constructor execution.
285 
286         uint256 size;
287         assembly {
288             size := extcodesize(account)
289         }
290         return size > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         (bool success, ) = recipient.call{value: amount}("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain `call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.call{value: value}(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
397         return functionStaticCall(target, data, "Address: low-level static call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal view returns (bytes memory) {
411         require(isContract(target), "Address: static call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(isContract(target), "Address: delegate call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.delegatecall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
446      * revert reason using the provided one.
447      *
448      * _Available since v4.3._
449      */
450     function verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) internal pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
474     using Address for address;
475     using Strings for uint256;
476 
477     // Token name
478     string private _name;
479 
480     // Token symbol
481     string private _symbol;
482 
483     // Mapping from token ID to owner address
484     mapping(uint256 => address) private _owners;
485 
486     // Mapping owner address to token count
487     mapping(address => uint256) private _balances;
488 
489     // Mapping from token ID to approved address
490     mapping(uint256 => address) private _tokenApprovals;
491 
492     // Mapping from owner to operator approvals
493     mapping(address => mapping(address => bool)) private _operatorApprovals;
494 
495     /**
496      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
497      */
498     constructor(string memory name_, string memory symbol_) {
499         _name = name_;
500         _symbol = symbol_;
501     }
502 
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
507         return
508             interfaceId == type(IERC721).interfaceId ||
509             interfaceId == type(IERC721Metadata).interfaceId ||
510             super.supportsInterface(interfaceId);
511     }
512 
513     /**
514      * @dev See {IERC721-balanceOf}.
515      */
516     function balanceOf(address owner) public view virtual override returns (uint256) {
517         require(owner != address(0), "ERC721: balance query for the zero address");
518         return _balances[owner];
519     }
520 
521     /**
522      * @dev See {IERC721-ownerOf}.
523      */
524     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
525         address owner = _owners[tokenId];
526         require(owner != address(0), "ERC721: owner query for nonexistent token");
527         return owner;
528     }
529 
530     /**
531      * @dev See {IERC721Metadata-name}.
532      */
533     function name() public view virtual override returns (string memory) {
534         return _name;
535     }
536 
537     /**
538      * @dev See {IERC721Metadata-symbol}.
539      */
540     function symbol() public view virtual override returns (string memory) {
541         return _symbol;
542     }
543 
544     /**
545      * @dev See {IERC721Metadata-tokenURI}.
546      */
547     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
548         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
549 
550         string memory baseURI = _baseURI();
551         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
552     }
553 
554     /**
555      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
556      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
557      * by default, can be overriden in child contracts.
558      */
559     function _baseURI() internal view virtual returns (string memory) {
560         return "";
561     }
562 
563     /**
564      * @dev See {IERC721-approve}.
565      */
566     function approve(address to, uint256 tokenId) public virtual override {
567         address owner = ERC721.ownerOf(tokenId);
568         require(to != owner, "ERC721: approval to current owner");
569 
570         require(
571             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
572             "ERC721: approve caller is not owner nor approved for all"
573         );
574 
575         _approve(to, tokenId);
576     }
577 
578     /**
579      * @dev See {IERC721-getApproved}.
580      */
581     function getApproved(uint256 tokenId) public view virtual override returns (address) {
582         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
583 
584         return _tokenApprovals[tokenId];
585     }
586 
587     /**
588      * @dev See {IERC721-setApprovalForAll}.
589      */
590     function setApprovalForAll(address operator, bool approved) public virtual override {
591         require(operator != _msgSender(), "ERC721: approve to caller");
592 
593         _operatorApprovals[_msgSender()][operator] = approved;
594         emit ApprovalForAll(_msgSender(), operator, approved);
595     }
596 
597     /**
598      * @dev See {IERC721-isApprovedForAll}.
599      */
600     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
601         return _operatorApprovals[owner][operator];
602     }
603 
604     /**
605      * @dev See {IERC721-transferFrom}.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) public virtual override {
612         //solhint-disable-next-line max-line-length
613         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
614 
615         _transfer(from, to, tokenId);
616     }
617 
618     /**
619      * @dev See {IERC721-safeTransferFrom}.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) public virtual override {
626         safeTransferFrom(from, to, tokenId, "");
627     }
628 
629     /**
630      * @dev See {IERC721-safeTransferFrom}.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId,
636         bytes memory _data
637     ) public virtual override {
638         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
639         _safeTransfer(from, to, tokenId, _data);
640     }
641 
642     /**
643      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
644      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
645      *
646      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
647      *
648      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
649      * implement alternative mechanisms to perform token transfer, such as signature-based.
650      *
651      * Requirements:
652      *
653      * - `from` cannot be the zero address.
654      * - `to` cannot be the zero address.
655      * - `tokenId` token must exist and be owned by `from`.
656      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
657      *
658      * Emits a {Transfer} event.
659      */
660     function _safeTransfer(
661         address from,
662         address to,
663         uint256 tokenId,
664         bytes memory _data
665     ) internal virtual {
666         _transfer(from, to, tokenId);
667         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
668     }
669 
670     /**
671      * @dev Returns whether `tokenId` exists.
672      *
673      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
674      *
675      * Tokens start existing when they are minted (`_mint`),
676      * and stop existing when they are burned (`_burn`).
677      */
678     function _exists(uint256 tokenId) internal view virtual returns (bool) {
679         return _owners[tokenId] != address(0);
680     }
681 
682     /**
683      * @dev Returns whether `spender` is allowed to manage `tokenId`.
684      *
685      * Requirements:
686      *
687      * - `tokenId` must exist.
688      */
689     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
690         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
691         address owner = ERC721.ownerOf(tokenId);
692         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
693     }
694 
695     /**
696      * @dev Safely mints `tokenId` and transfers it to `to`.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must not exist.
701      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702      *
703      * Emits a {Transfer} event.
704      */
705     function _safeMint(address to, uint256 tokenId) internal virtual {
706         _safeMint(to, tokenId, "");
707     }
708 
709     /**
710      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
711      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
712      */
713     function _safeMint(
714         address to,
715         uint256 tokenId,
716         bytes memory _data
717     ) internal virtual {
718         _mint(to, tokenId);
719         require(
720             _checkOnERC721Received(address(0), to, tokenId, _data),
721             "ERC721: transfer to non ERC721Receiver implementer"
722         );
723     }
724 
725     /**
726      * @dev Mints `tokenId` and transfers it to `to`.
727      *
728      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
729      *
730      * Requirements:
731      *
732      * - `tokenId` must not exist.
733      * - `to` cannot be the zero address.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _mint(address to, uint256 tokenId) internal virtual {
738         require(to != address(0), "ERC721: mint to the zero address");
739         require(!_exists(tokenId), "ERC721: token already minted");
740 
741         _beforeTokenTransfer(address(0), to, tokenId);
742 
743         _balances[to] += 1;
744         _owners[tokenId] = to;
745 
746         emit Transfer(address(0), to, tokenId);
747     }
748 
749     /**
750      * @dev Destroys `tokenId`.
751      * The approval is cleared when the token is burned.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _burn(uint256 tokenId) internal virtual {
760         address owner = ERC721.ownerOf(tokenId);
761 
762         _beforeTokenTransfer(owner, address(0), tokenId);
763 
764         // Clear approvals
765         _approve(address(0), tokenId);
766 
767         _balances[owner] -= 1;
768         delete _owners[tokenId];
769 
770         emit Transfer(owner, address(0), tokenId);
771     }
772 
773     /**
774      * @dev Transfers `tokenId` from `from` to `to`.
775      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
776      *
777      * Requirements:
778      *
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must be owned by `from`.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _transfer(
785         address from,
786         address to,
787         uint256 tokenId
788     ) internal virtual {
789         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
790         require(to != address(0), "ERC721: transfer to the zero address");
791 
792         _beforeTokenTransfer(from, to, tokenId);
793 
794         // Clear approvals from the previous owner
795         _approve(address(0), tokenId);
796 
797         _balances[from] -= 1;
798         _balances[to] += 1;
799         _owners[tokenId] = to;
800 
801         emit Transfer(from, to, tokenId);
802     }
803 
804     /**
805      * @dev Approve `to` to operate on `tokenId`
806      *
807      * Emits a {Approval} event.
808      */
809     function _approve(address to, uint256 tokenId) internal virtual {
810         _tokenApprovals[tokenId] = to;
811         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
812     }
813 
814     /**
815      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
816      * The call is not executed if the target address is not a contract.
817      *
818      * @param from address representing the previous owner of the given token ID
819      * @param to target address that will receive the tokens
820      * @param tokenId uint256 ID of the token to be transferred
821      * @param _data bytes optional data to send along with the call
822      * @return bool whether the call correctly returned the expected magic value
823      */
824     function _checkOnERC721Received(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) private returns (bool) {
830         if (to.isContract()) {
831             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
832                 return retval == IERC721Receiver.onERC721Received.selector;
833             } catch (bytes memory reason) {
834                 if (reason.length == 0) {
835                     revert("ERC721: transfer to non ERC721Receiver implementer");
836                 } else {
837                     assembly {
838                         revert(add(32, reason), mload(reason))
839                     }
840                 }
841             }
842         } else {
843             return true;
844         }
845     }
846 
847     /**
848      * @dev Hook that is called before any token transfer. This includes minting
849      * and burning.
850      *
851      * Calling conditions:
852      *
853      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
854      * transferred to `to`.
855      * - When `from` is zero, `tokenId` will be minted for `to`.
856      * - When `to` is zero, ``from``'s `tokenId` will be burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _beforeTokenTransfer(
862         address from,
863         address to,
864         uint256 tokenId
865     ) internal virtual {}
866 }
867 
868 
869 /**
870  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
871  * @dev See https://eips.ethereum.org/EIPS/eip-721
872  */
873 interface IERC721Enumerable is IERC721 {
874     /**
875      * @dev Returns the total amount of tokens stored by the contract.
876      */
877     function totalSupply() external view returns (uint256);
878 
879     /**
880      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
881      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
882      */
883     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
884 
885     /**
886      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
887      * Use along with {totalSupply} to enumerate all tokens.
888      */
889     function tokenByIndex(uint256 index) external view returns (uint256);
890 }
891 
892 
893 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
894     // Mapping from owner to list of owned token IDs
895     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
896 
897     // Mapping from token ID to index of the owner tokens list
898     mapping(uint256 => uint256) private _ownedTokensIndex;
899 
900     // Array with all token ids, used for enumeration
901     uint256[] private _allTokens;
902 
903     // Mapping from token id to position in the allTokens array
904     mapping(uint256 => uint256) private _allTokensIndex;
905 
906     /**
907      * @dev See {IERC165-supportsInterface}.
908      */
909     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
910         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
911     }
912 
913     /**
914      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
915      */
916     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
917         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
918         return _ownedTokens[owner][index];
919     }
920 
921     /**
922      * @dev See {IERC721Enumerable-totalSupply}.
923      */
924     function totalSupply() public view virtual override returns (uint256) {
925         return _allTokens.length;
926     }
927 
928     /**
929      * @dev See {IERC721Enumerable-tokenByIndex}.
930      */
931     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
932         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
933         return _allTokens[index];
934     }
935 
936     /**
937      * @dev Hook that is called before any token transfer. This includes minting
938      * and burning.
939      *
940      * Calling conditions:
941      *
942      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
943      * transferred to `to`.
944      * - When `from` is zero, `tokenId` will be minted for `to`.
945      * - When `to` is zero, ``from``'s `tokenId` will be burned.
946      * - `from` cannot be the zero address.
947      * - `to` cannot be the zero address.
948      *
949      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
950      */
951     function _beforeTokenTransfer(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal virtual override {
956         super._beforeTokenTransfer(from, to, tokenId);
957 
958         if (from == address(0)) {
959             _addTokenToAllTokensEnumeration(tokenId);
960         } else if (from != to) {
961             _removeTokenFromOwnerEnumeration(from, tokenId);
962         }
963         if (to == address(0)) {
964             _removeTokenFromAllTokensEnumeration(tokenId);
965         } else if (to != from) {
966             _addTokenToOwnerEnumeration(to, tokenId);
967         }
968     }
969 
970     /**
971      * @dev Private function to add a token to this extension's ownership-tracking data structures.
972      * @param to address representing the new owner of the given token ID
973      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
974      */
975     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
976         uint256 length = ERC721.balanceOf(to);
977         _ownedTokens[to][length] = tokenId;
978         _ownedTokensIndex[tokenId] = length;
979     }
980 
981     /**
982      * @dev Private function to add a token to this extension's token tracking data structures.
983      * @param tokenId uint256 ID of the token to be added to the tokens list
984      */
985     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
986         _allTokensIndex[tokenId] = _allTokens.length;
987         _allTokens.push(tokenId);
988     }
989 
990     /**
991      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
992      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
993      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
994      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
995      * @param from address representing the previous owner of the given token ID
996      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
997      */
998     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
999         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1000         // then delete the last slot (swap and pop).
1001 
1002         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1003         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1004 
1005         // When the token to delete is the last token, the swap operation is unnecessary
1006         if (tokenIndex != lastTokenIndex) {
1007             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1008 
1009             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1010             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1011         }
1012 
1013         // This also deletes the contents at the last position of the array
1014         delete _ownedTokensIndex[tokenId];
1015         delete _ownedTokens[from][lastTokenIndex];
1016     }
1017 
1018     /**
1019      * @dev Private function to remove a token from this extension's token tracking data structures.
1020      * This has O(1) time complexity, but alters the order of the _allTokens array.
1021      * @param tokenId uint256 ID of the token to be removed from the tokens list
1022      */
1023     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1024         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1025         // then delete the last slot (swap and pop).
1026 
1027         uint256 lastTokenIndex = _allTokens.length - 1;
1028         uint256 tokenIndex = _allTokensIndex[tokenId];
1029 
1030         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1031         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1032         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1033         uint256 lastTokenId = _allTokens[lastTokenIndex];
1034 
1035         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1036         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1037 
1038         // This also deletes the contents at the last position of the array
1039         delete _allTokensIndex[tokenId];
1040         _allTokens.pop();
1041     }
1042 }
1043 
1044 
1045 
1046 
1047 
1048 
1049 abstract contract Ownable is Context {
1050     address private _owner;
1051 
1052     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1053 
1054     /**
1055      * @dev Initializes the contract setting the deployer as the initial owner.
1056      */
1057     constructor() {
1058         _setOwner(_msgSender());
1059     }
1060 
1061     /**
1062      * @dev Returns the address of the current owner.
1063      */
1064     function owner() public view virtual returns (address) {
1065         return _owner;
1066     }
1067 
1068     /**
1069      * @dev Throws if called by any account other than the owner.
1070      */
1071     modifier onlyOwner() {
1072         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1073         _;
1074     }
1075 
1076     /**
1077      * @dev Leaves the contract without owner. It will not be possible to call
1078      * `onlyOwner` functions anymore. Can only be called by the current owner.
1079      *
1080      * NOTE: Renouncing ownership will leave the contract without an owner,
1081      * thereby removing any functionality that is only available to the owner.
1082      */
1083     function renounceOwnership() public virtual onlyOwner {
1084         _setOwner(address(0));
1085     }
1086 
1087     /**
1088      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1089      * Can only be called by the current owner.
1090      */
1091     function transferOwnership(address newOwner) public virtual onlyOwner {
1092         require(newOwner != address(0), "Ownable: new owner is the zero address");
1093         _setOwner(newOwner);
1094     }
1095 
1096     function _setOwner(address newOwner) private {
1097         address oldOwner = _owner;
1098         _owner = newOwner;
1099         emit OwnershipTransferred(oldOwner, newOwner);
1100     }
1101 }
1102 
1103 
1104 
1105 /**
1106  * @dev String operations.
1107  */
1108 library Strings {
1109     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1110 
1111     /**
1112      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1113      */
1114     function toString(uint256 value) internal pure returns (string memory) {
1115         // Inspired by OraclizeAPI's implementation - MIT licence
1116         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1117 
1118         if (value == 0) {
1119             return "0";
1120         }
1121         uint256 temp = value;
1122         uint256 digits;
1123         while (temp != 0) {
1124             digits++;
1125             temp /= 10;
1126         }
1127         bytes memory buffer = new bytes(digits);
1128         while (value != 0) {
1129             digits -= 1;
1130             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1131             value /= 10;
1132         }
1133         return string(buffer);
1134     }
1135 
1136     /**
1137      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1138      */
1139     function toHexString(uint256 value) internal pure returns (string memory) {
1140         if (value == 0) {
1141             return "0x00";
1142         }
1143         uint256 temp = value;
1144         uint256 length = 0;
1145         while (temp != 0) {
1146             length++;
1147             temp >>= 8;
1148         }
1149         return toHexString(value, length);
1150     }
1151 
1152     /**
1153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1154      */
1155     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1156         bytes memory buffer = new bytes(2 * length + 2);
1157         buffer[0] = "0";
1158         buffer[1] = "x";
1159         for (uint256 i = 2 * length + 1; i > 1; --i) {
1160             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1161             value >>= 4;
1162         }
1163         require(value == 0, "Strings: hex length insufficient");
1164         return string(buffer);
1165     }
1166 }
1167 
1168 
1169 
1170 /// [MIT License]
1171 /// @title Base64
1172 /// @notice Provides a function for encoding some bytes in base64
1173 /// @author Brecht Devos <brecht@loopring.org>
1174 library Base64 {
1175     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1176 
1177     /// @notice Encodes some bytes to the base64 representation
1178     function encode(bytes memory data) internal pure returns (string memory) {
1179         uint256 len = data.length;
1180         if (len == 0) return "";
1181 
1182         // multiply by 4/3 rounded up
1183         uint256 encodedLen = 4 * ((len + 2) / 3);
1184 
1185         // Add some extra buffer at the end
1186         bytes memory result = new bytes(encodedLen + 32);
1187 
1188         bytes memory table = TABLE;
1189 
1190         assembly {
1191             let tablePtr := add(table, 1)
1192             let resultPtr := add(result, 32)
1193 
1194             for {
1195                 let i := 0
1196             } lt(i, len) {
1197 
1198             } {
1199                 i := add(i, 3)
1200                 let input := and(mload(add(data, i)), 0xffffff)
1201 
1202                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1203                 out := shl(8, out)
1204                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1205                 out := shl(8, out)
1206                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1207                 out := shl(8, out)
1208                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1209                 out := shl(224, out)
1210 
1211                 mstore(resultPtr, out)
1212 
1213                 resultPtr := add(resultPtr, 4)
1214             }
1215 
1216             switch mod(len, 3)
1217             case 1 {
1218                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1219             }
1220             case 2 {
1221                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1222             }
1223 
1224             mstore(result, encodedLen)
1225         }
1226 
1227         return string(result);
1228     }
1229 }
1230 
1231 
1232 
1233 contract GMContract is ERC721Enumerable, Ownable {
1234     using Strings for uint256;
1235 
1236     uint256 constant private LINE_LENGTH = 88;
1237     string[] private text_options = [
1238         "GM",
1239         "GN",
1240         "GMI",
1241         "LFG",
1242         "FUD",
1243         "NGMI"
1244     ];
1245     string[] private text_to_font_size = [
1246         "500",
1247         "500",
1248         "400",
1249         "400",
1250         "400",
1251         "300"
1252     ];
1253     string[] private color_options = [
1254         "949398",
1255         "FC766A",
1256         "5F4B8B",
1257         "42EADD",
1258         "000000",
1259         "00A4CC",
1260         "00203F",
1261         "606060",
1262         "ED2B33",
1263         "2C5F2D",
1264         "00539C",
1265         "0063B2",
1266         "D198C5",
1267         "101820",
1268         "CBCE91",
1269         "B1624E",
1270         "89ABE3",
1271         "E3CD81",
1272         "101820",
1273         "A07855",
1274         "195190",
1275         "603F83",
1276         "2BAE66",
1277         "FAD0C9",
1278         "2D2926",
1279         "DAA03D",
1280         "990011",
1281         "435E55",
1282         "CBCE91",
1283         "FAEBEF",
1284         "F93822",
1285         "F2EDD7",
1286         "006B38",
1287         "F95700",
1288         "FFD662",
1289         "D7C49E",
1290         "FFA177",
1291         "DF6589",
1292         "FFE77A",
1293         "DD4132",
1294         "F1F4FF",
1295         "FCF951",
1296         "4B878B",
1297         "1C1C1B",
1298         "00B1D2",
1299         "79C000",
1300         "BD7F37",
1301         "E3C9CE",
1302         "00239C",
1303         "FC766A",
1304         "FC766A",
1305         "184A45",
1306         "FFA351",
1307         "FFA351",
1308         "EED971",
1309         "567572",
1310         "567572",
1311         "696667",
1312         "DA291C",
1313         "DA291C",
1314         "53A567",
1315         "D7A9E3",
1316         "D7A9E3",
1317         "A8D5BA",
1318         "7DB46C",
1319         "7DB46C",
1320         "ABD6DF",
1321         "F9A12E",
1322         "F9A12E",
1323         "9B4A97",
1324         "A59C94",
1325         "A59C94",
1326         "D32E5E",
1327         "FCF6F5",
1328         "FCF6F5",
1329         "8ABAD3",
1330         "FC766A",
1331         "FC766A",
1332         "F1AC88",
1333         "F6EA7B",
1334         "F6EA7B",
1335         "E683A9",
1336         "F65058",
1337         "F65058",
1338         "28334A",
1339         "95DBE5",
1340         "95DBE5",
1341         "339E66",
1342         "643E46",
1343         "643E46",
1344         "EE2737",
1345         "FF3EA5",
1346         "FF3EA5",
1347         "00A4CC",
1348         "E95C20",
1349         "E95C20",
1350         "4F2C1D",
1351         "D9514E",
1352         "D9514E",
1353         "2DA8D8",
1354         "963CBD",
1355         "FEAE51",
1356         "FCF6F5",
1357         "A13941",
1358         "2460A7",
1359         "D9B48F",
1360         "FFD653",
1361         "6E4C1E",
1362         "669DB3",
1363         "FF4F58",
1364         "0A5E2A",
1365         "FE0000",
1366         "FFDDE2",
1367         "008C76",
1368         "93385F",
1369         "301728",
1370         "F1F3FF",
1371         "EF6079",
1372         "ABD1C9",
1373         "97B3D0",
1374         "DBBEA1",
1375         "D34F73",
1376         "E3170A",
1377         "F7B32B",
1378         "2E5266",
1379         "D3D0CB",
1380         "ED254E",
1381         "011936"
1382     ];
1383     string[] private bg_color_options = [
1384         "F4DF4E",
1385         "5B84B1",
1386         "E69A8D",
1387         "CDB599",
1388         "FFFFFF",
1389         "F95700",
1390         "ADEFD1",
1391         "D6ED17",
1392         "D85A7F",
1393         "97BC62",
1394         "EEA47F",
1395         "9CC3D5",
1396         "E0C568",
1397         "FEE715",
1398         "EA738D",
1399         "5CC8D7",
1400         "FCF6F5",
1401         "B1B3B3",
1402         "F2AA4C",
1403         "D4B996",
1404         "A2A2A1",
1405         "C7D3D4",
1406         "FCF6F5",
1407         "6E6E6D",
1408         "E94B3C",
1409         "616247",
1410         "FCF6F5",
1411         "D64161",
1412         "76528B",
1413         "333D79",
1414         "FDD20E",
1415         "755139",
1416         "101820",
1417         "FFFFFF",
1418         "00539C",
1419         "343148",
1420         "F5C7B8",
1421         "3C1053",
1422         "2C5F2D",
1423         "9E1030",
1424         "A2A2A1",
1425         "422057",
1426         "D01C1F",
1427         "CE4A7E",
1428         "FDDB27",
1429         "FF7F41",
1430         "A13941",
1431         "9FC131",
1432         "E10600",
1433         "B0B8B4",
1434         "184A45",
1435         "B0B8B4",
1436         "FFBE7B",
1437         "EED971",
1438         "FFBE7B",
1439         "964F4C",
1440         "696667",
1441         "964F4C",
1442         "56A8CB",
1443         "53A567",
1444         "56A8CB",
1445         "8BBEE8",
1446         "A8D5BA",
1447         "8BBEE8",
1448         "E7EBE0",
1449         "ABD6DF",
1450         "E7EBE0",
1451         "FC766A",
1452         "9B4A97",
1453         "FC766A",
1454         "AE0E36",
1455         "D32E5E",
1456         "AE0E36",
1457         "EDC2D8",
1458         "8ABAD3",
1459         "EDC2D8",
1460         "783937",
1461         "F1AC88",
1462         "783937",
1463         "FFBA52",
1464         "E683A9",
1465         "FFBA52",
1466         "FBDE44",
1467         "28334A",
1468         "FBDE44",
1469         "078282",
1470         "339E66",
1471         "078282",
1472         "BA0020",
1473         "EE2737",
1474         "BA0020",
1475         "EDFF00",
1476         "00A4CC",
1477         "EDFF00",
1478         "006747",
1479         "4F2C1D",
1480         "006747",
1481         "2A2B2D",
1482         "2DA8D8",
1483         "2A2B2D",
1484         "FF6F61",
1485         "C5299B",
1486         "F0E1B9",
1487         "F3DB74",
1488         "85B3D1",
1489         "B3C7D6",
1490         "DDB65D",
1491         "EEB238",
1492         "F0F6F7",
1493         "A89C94",
1494         "6DAC4F",
1495         "EFEFE8",
1496         "FAA094",
1497         "9ED9CC",
1498         "9F6B99",
1499         "4F3466",
1500         "F7CED7",
1501         "F99FC9",
1502         "DFDCE5",
1503         "DBB04A",
1504         "A37B73",
1505         "3E282B",
1506         "A9E5BB",
1507         "FCF6B1",
1508         "6E8898",
1509         "9FB1BC",
1510         "F9DC5C",
1511         "F4FFFD"
1512     ];
1513     string[] private rotate_options = [
1514         "0",
1515         "45",
1516         "90",
1517         "135",
1518         "180",
1519         "225",
1520         "270",
1521         "315"
1522     ];
1523 
1524     function seededRandom(string memory seed, string memory input) internal pure returns (uint256) {
1525         return uint256(keccak256(abi.encodePacked(seed, input)));
1526     }
1527 
1528     function generateLineOfText(string memory text) internal pure returns (string memory) {
1529         bytes memory result = new bytes(LINE_LENGTH);
1530         bytes memory input = bytes(text);
1531         for (uint256 i = 0; i < LINE_LENGTH; i++) {
1532             result[i] = input[i % input.length];
1533         }
1534         return string(result);
1535     }
1536 
1537     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1538         require(tokenId < 420, "Invalid token ID");
1539         string memory tokenIdStr = tokenId.toString();
1540         uint256 beTextIndex = seededRandom("BE-TEXT", tokenIdStr) % text_options.length;
1541         uint256 feTextIndex = seededRandom("FE-TEXT", tokenIdStr) % text_options.length;
1542         uint256 colorIndex = seededRandom("color", tokenIdStr) % color_options.length;
1543         uint256 rotateIndex = seededRandom("rotate", tokenIdStr) % rotate_options.length;
1544 
1545         string memory lineOfText = generateLineOfText(text_options[beTextIndex]);
1546         string memory output = string(abi.encodePacked(
1547                 '<svg preserveAspectRatio="xMinYMin meet" viewBox="0 0 800 800" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" ><style>.base{fill: #',
1548                 color_options[colorIndex],
1549                 '; font-family: courier new; font-weight: bold; font-size: 14px; white-space: pre;}.bigText{font-family: courier new; font-weight: bold; font-size: ',
1550                 text_to_font_size[feTextIndex],
1551                 'px; white-space: pre;}</style><rect fill="#',
1552                 bg_color_options[colorIndex],
1553                 '" height="100%" width="100%"/><clipPath id="clip"><text id="bigText" class="bigText" x="0" y="0" text-anchor="middle" dominant-baseline="middle">',
1554                 text_options[feTextIndex],
1555                 '</text></clipPath><g clip-path="url(#clip)" transform="rotate('
1556             ));
1557         output = string(abi.encodePacked(
1558                 output,
1559                 rotate_options[rotateIndex],
1560                 ',400,400) translate(400,400)"><text id="line" class="base" text-anchor="middle" x="0" y="-280">',
1561                 lineOfText,
1562                 '</text><use xlink:href="#line" transform="translate(0,20)"/><use xlink:href="#line" transform="translate(0,40)"/><use xlink:href="#line" transform="translate(0,60)"/><use xlink:href="#line" transform="translate(0,80)"/><use xlink:href="#line" transform="translate(0,100)"/><use xlink:href="#line" transform="translate(0,120)"/><use xlink:href="#line" transform="translate(0,140)"/><use xlink:href="#line" transform="translate(0,160)"/><use xlink:href="#line" transform="translate(0,180)"/><use xlink:href="#line" transform="translate(0,200)"/><use xlink:href="#line" transform="translate(0,220)"/><use xlink:href="#line" transform="translate(0,240)"/><use xlink:href="#line" transform="translate(0,260)"/><use xlink:href="#line" transform="translate(0,280)"/><use xlink:href="#line" transform="translate(0,300)"/><use xlink:href="#line" transform="translate(0,320)"/><use xlink:href="#line" transform="translate(0,340)"/><use xlink:href="#line" transform="translate(0,360)"/><use xlink:href="#line" transform="translate(0,380)"/><use xlink:href="#line" transform="translate(0,400)"/><use xlink:href="#line" transform="translate(0,420)"/><use xlink:href="#line" transform="translate(0,440)"/><use xlink:href="#line" transform="translate(0,460)"/><use xlink:href="#line" transform="translate(0,480)"/></g></svg>'
1563             ));
1564         string memory attributes = string(abi.encodePacked('[{"trait_type":"Main Term","value":"', text_options[feTextIndex],
1565             '"},{"trait_type":"Secondary Term","value":"', text_options[beTextIndex],
1566             '"},{"trait_type":"Rotation","value":"', rotate_options[rotateIndex],
1567             '"},{"trait_type":"Font Color","value":"', color_options[colorIndex],
1568             '"},{"trait_type":"BG Color","value":"', bg_color_options[colorIndex],
1569             '"}]'));
1570         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "GM420 #', tokenIdStr,
1571             '", "description": "GM420 is a fully on-chain set of NFTs representing the Lingo that leads the NFT movement. 420 unique pieces of the different terms we all use everyday. The NFTs are fully created on-chain, during minting, and are all unique with basic traits such as Main Term, Secondary Term, Rotation, Font Color and BG Color. Owners of these NFTs will be the first to receive PUGS tokens when they are released.", "image": "data:image/svg+xml;base64,',
1572             Base64.encode(bytes(output)),
1573             '","attributes": ', attributes,
1574             '}'))));
1575         output = string(abi.encodePacked('data:application/json;base64,', json));
1576 
1577         return output;
1578     }
1579 
1580     function claim(uint256 num) public {
1581         uint256 supply = totalSupply();
1582         require( num < 2,                              "You can mint a maximum of 1 piece per tx" );
1583         require( supply + num - 1 < 417,      "Exceeds maximum supply" );
1584         _safeMint(_msgSender(), supply + num - 1);
1585     }
1586 
1587     function claimOwner(uint256 num) public onlyOwner {
1588         uint256 supply = totalSupply();
1589         require( num < 2,                              "You can mint a maximum of 1 piece per tx" );
1590         require( supply + num - 1 < 420,      "Exceeds maximum supply" );
1591         _safeMint(_msgSender(), supply + num - 1);
1592     }
1593 
1594     constructor() ERC721("GM420", "GM420") Ownable() {}
1595 }