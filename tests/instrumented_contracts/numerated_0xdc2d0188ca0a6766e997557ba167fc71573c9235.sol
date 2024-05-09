1 // SPDX-License-Identifier: MIT AND BSD-3-Clause 
2 // Sources flattened with hardhat v2.8.4 https://hardhat.org
3 pragma solidity ^0.8.1;
4 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 
9 
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
37 
38 
39 
40 /**
41  * @dev Required interface of an ERC721 compliant contract.
42  */
43 interface IERC721 is IERC165 {
44     /**
45      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
51      */
52     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56      */
57     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
58 
59     /**
60      * @dev Returns the number of tokens in ``owner``'s account.
61      */
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the `tokenId` token.
66      *
67      * Requirements:
68      *
69      * - `tokenId` must exist.
70      */
71     function ownerOf(uint256 tokenId) external view returns (address owner);
72 
73     /**
74      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
75      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92 
93     /**
94      * @dev Transfers `tokenId` token from `from` to `to`.
95      *
96      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must be owned by `from`.
103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 tokenId
111     ) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId) external view returns (address operator);
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
151      *
152      * See {setApprovalForAll}
153      */
154     function isApprovedForAll(address owner, address operator) external view returns (bool);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166      *
167      * Emits a {Transfer} event.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 }
176 
177 
178 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
182 
183 
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 
209 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
210 
211 
212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
213 
214 
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 
238 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
239 
240 
241 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
242 
243 
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      *
266      * [IMPORTANT]
267      * ====
268      * You shouldn't rely on `isContract` to protect against flash loan attacks!
269      *
270      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
271      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
272      * constructor.
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize/address.code.length, which returns 0
277         // for contracts in construction, since the code is only stored at the end
278         // of the constructor execution.
279 
280         return account.code.length > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 
464 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
468 
469 
470 
471 /**
472  * @dev Provides information about the current execution context, including the
473  * sender of the transaction and its data. While these are generally available
474  * via msg.sender and msg.data, they should not be accessed in such a direct
475  * manner, since when dealing with meta-transactions the account sending and
476  * paying for execution may not be the actual sender (as far as an application
477  * is concerned).
478  *
479  * This contract is only required for intermediate, library-like contracts.
480  */
481 abstract contract Context {
482     function _msgSender() internal view virtual returns (address) {
483         return msg.sender;
484     }
485 
486     function _msgData() internal view virtual returns (bytes calldata) {
487         return msg.data;
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
496 
497 
498 
499 /**
500  * @dev Implementation of the {IERC165} interface.
501  *
502  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
503  * for the additional interface id that will be supported. For example:
504  *
505  * ```solidity
506  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
508  * }
509  * ```
510  *
511  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
512  */
513 abstract contract ERC165 is IERC165 {
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      */
517     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518         return interfaceId == type(IERC165).interfaceId;
519     }
520 }
521 
522 
523 // File contracts/ERC721B.sol
524 
525 
526 
527 
528 
529 /********************
530 * @author: Squeebo *
531 ********************/
532 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
533     using Address for address;
534 
535     // Token name
536     string private _name;
537 
538     // Token symbol
539     string private _symbol;
540 
541     // Mapping from token ID to owner address
542     address[] internal _owners;
543 
544     // Mapping from token ID to approved address
545     mapping(uint256 => address) private _tokenApprovals;
546 
547     // Mapping from owner to operator approvals
548     mapping(address => mapping(address => bool)) private _operatorApprovals;
549 
550     /**
551      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
552      */
553     constructor(string memory name_, string memory symbol_) {
554         _name = name_;
555         _symbol = symbol_;
556     }
557 
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
562         return
563             interfaceId == type(IERC721).interfaceId ||
564             interfaceId == type(IERC721Metadata).interfaceId ||
565             super.supportsInterface(interfaceId);
566     }
567 
568     /**
569      * @dev See {IERC721-balanceOf}.
570      */
571     function balanceOf(address owner) public view virtual override returns (uint256) {
572         require(owner != address(0), "ERC721: balance query for the zero address");
573 
574         uint count = 0;
575         uint length = _owners.length;
576         for( uint i = 0; i < length; ++i ){
577           if( owner == _owners[i] ){
578             ++count;
579           }
580         }
581 
582         delete length;
583         return count;
584     }
585 
586     /**
587      * @dev See {IERC721-ownerOf}.
588      */
589     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
590         address owner = _owners[tokenId];
591         require(owner != address(0), "ERC721: owner query for nonexistent token");
592         return owner;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-name}.
597      */
598     function name() public view virtual override returns (string memory) {
599         return _name;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-symbol}.
604      */
605     function symbol() public view virtual override returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev See {IERC721-approve}.
611      */
612     function approve(address to, uint256 tokenId) public virtual override {
613         address owner = ERC721B.ownerOf(tokenId);
614         require(to != owner, "ERC721: approval to current owner");
615 
616         require(
617             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
618             "ERC721: approve caller is not owner nor approved for all"
619         );
620 
621         _approve(to, tokenId);
622     }
623 
624     /**
625      * @dev See {IERC721-getApproved}.
626      */
627     function getApproved(uint256 tokenId) public view virtual override returns (address) {
628         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
629 
630         return _tokenApprovals[tokenId];
631     }
632 
633     /**
634      * @dev See {IERC721-setApprovalForAll}.
635      */
636     function setApprovalForAll(address operator, bool approved) public virtual override {
637         require(operator != _msgSender(), "ERC721: approve to caller");
638 
639         _operatorApprovals[_msgSender()][operator] = approved;
640         emit ApprovalForAll(_msgSender(), operator, approved);
641     }
642 
643     /**
644      * @dev See {IERC721-isApprovedForAll}.
645      */
646     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
647         return _operatorApprovals[owner][operator];
648     }
649 
650 
651     /**
652      * @dev See {IERC721-transferFrom}.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) public virtual override {
659         //solhint-disable-next-line max-line-length
660         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
661 
662         _transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public virtual override {
673         safeTransferFrom(from, to, tokenId, "");
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes memory _data
684     ) public virtual override {
685         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
686         _safeTransfer(from, to, tokenId, _data);
687     }
688 
689     /**
690      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
691      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
692      *
693      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
694      *
695      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
696      * implement alternative mechanisms to perform token transfer, such as signature-based.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must exist and be owned by `from`.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function _safeTransfer(
708         address from,
709         address to,
710         uint256 tokenId,
711         bytes memory _data
712     ) internal virtual {
713         _transfer(from, to, tokenId);
714         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
715     }
716 
717     /**
718      * @dev Returns whether `tokenId` exists.
719      *
720      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
721      *
722      * Tokens start existing when they are minted (`_mint`),
723      * and stop existing when they are burned (`_burn`).
724      */
725     function _exists(uint256 tokenId) internal view virtual returns (bool) {
726         return tokenId < _owners.length && _owners[tokenId] != address(0);
727     }
728 
729     /**
730      * @dev Returns whether `spender` is allowed to manage `tokenId`.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
737         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
738         address owner = ERC721B.ownerOf(tokenId);
739         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
740     }
741 
742     /**
743      * @dev Safely mints `tokenId` and transfers it to `to`.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must not exist.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _safeMint(address to, uint256 tokenId) internal virtual {
753         _safeMint(to, tokenId, "");
754     }
755 
756 
757     /**
758      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
759      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
760      */
761     function _safeMint(
762         address to,
763         uint256 tokenId,
764         bytes memory _data
765     ) internal virtual {
766         _mint(to, tokenId);
767         require(
768             _checkOnERC721Received(address(0), to, tokenId, _data),
769             "ERC721: transfer to non ERC721Receiver implementer"
770         );
771     }
772 
773     /**
774      * @dev Mints `tokenId` and transfers it to `to`.
775      *
776      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
777      *
778      * Requirements:
779      *
780      * - `tokenId` must not exist.
781      * - `to` cannot be the zero address.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _mint(address to, uint256 tokenId) internal virtual {
786         require(to != address(0), "ERC721: mint to the zero address");
787         require(!_exists(tokenId), "ERC721: token already minted");
788 
789         _beforeTokenTransfer(address(0), to, tokenId);
790         _owners.push(to);
791 
792         emit Transfer(address(0), to, tokenId);
793     }
794 
795     /**
796      * @dev Destroys `tokenId`.
797      * The approval is cleared when the token is burned.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _burn(uint256 tokenId) internal virtual {
806         address owner = ERC721B.ownerOf(tokenId);
807 
808         _beforeTokenTransfer(owner, address(0), tokenId);
809 
810         // Clear approvals
811         _approve(address(0), tokenId);
812         _owners[tokenId] = address(0);
813 
814         emit Transfer(owner, address(0), tokenId);
815     }
816 
817     /**
818      * @dev Transfers `tokenId` from `from` to `to`.
819      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
820      *
821      * Requirements:
822      *
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must be owned by `from`.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _transfer(
829         address from,
830         address to,
831         uint256 tokenId
832     ) internal virtual {
833         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
834         require(to != address(0), "ERC721: transfer to the zero address");
835 
836         _beforeTokenTransfer(from, to, tokenId);
837 
838         // Clear approvals from the previous owner
839         _approve(address(0), tokenId);
840         _owners[tokenId] = to;
841 
842         emit Transfer(from, to, tokenId);
843     }
844 
845     /**
846      * @dev Approve `to` to operate on `tokenId`
847      *
848      * Emits a {Approval} event.
849      */
850     function _approve(address to, uint256 tokenId) internal virtual {
851         _tokenApprovals[tokenId] = to;
852         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
853     }
854 
855 
856     /**
857      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
858      * The call is not executed if the target address is not a contract.
859      *
860      * @param from address representing the previous owner of the given token ID
861      * @param to target address that will receive the tokens
862      * @param tokenId uint256 ID of the token to be transferred
863      * @param _data bytes optional data to send along with the call
864      * @return bool whether the call correctly returned the expected magic value
865      */
866     function _checkOnERC721Received(
867         address from,
868         address to,
869         uint256 tokenId,
870         bytes memory _data
871     ) private returns (bool) {
872         if (to.isContract()) {
873             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
874                 return retval == IERC721Receiver.onERC721Received.selector;
875             } catch (bytes memory reason) {
876                 if (reason.length == 0) {
877                     revert("ERC721: transfer to non ERC721Receiver implementer");
878                 } else {
879                     assembly {
880                         revert(add(32, reason), mload(reason))
881                     }
882                 }
883             }
884         } else {
885             return true;
886         }
887     }
888 
889     /**
890      * @dev Hook that is called before any token transfer. This includes minting
891      * and burning.
892      *
893      * Calling conditions:
894      *
895      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
896      * transferred to `to`.
897      * - When `from` is zero, `tokenId` will be minted for `to`.
898      * - When `to` is zero, ``from``'s `tokenId` will be burned.
899      * - `from` and `to` are never both zero.
900      *
901      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
902      */
903     function _beforeTokenTransfer(
904         address from,
905         address to,
906         uint256 tokenId
907     ) internal virtual {}
908 }
909 
910 
911 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
912 
913 
914 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
915 
916 
917 
918 /**
919  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
920  * @dev See https://eips.ethereum.org/EIPS/eip-721
921  */
922 interface IERC721Enumerable is IERC721 {
923     /**
924      * @dev Returns the total amount of tokens stored by the contract.
925      */
926     function totalSupply() external view returns (uint256);
927 
928     /**
929      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
930      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
931      */
932     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
933 
934     /**
935      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
936      * Use along with {totalSupply} to enumerate all tokens.
937      */
938     function tokenByIndex(uint256 index) external view returns (uint256);
939 }
940 
941 
942 // File contracts/ERC721EnumerableLite.sol
943 
944 
945 
946 /**
947  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
948  * enumerability of all the token ids in the contract as well as all token ids owned by each
949  * account.
950  */
951 abstract contract ERC721EnumerableLite is ERC721B, IERC721Enumerable {
952     /**
953      * @dev See {IERC165-supportsInterface}.
954      */
955     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
956         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
961      */
962     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
963         require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
964 
965         uint count;
966         for( uint i; i < _owners.length; ++i ){
967             if( owner == _owners[i] ){
968                 if( count == index )
969                     return i;
970                 else
971                     ++count;
972             }
973         }
974 
975         require(false, "ERC721Enumerable: owner index out of bounds");
976     }
977 
978     /**
979      * @dev See {IERC721Enumerable-totalSupply}.
980      */
981     function totalSupply() public view virtual override returns (uint256) {
982         return _owners.length;
983     }
984 
985     /**
986      * @dev See {IERC721Enumerable-tokenByIndex}.
987      */
988     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
989         require(index < ERC721EnumerableLite.totalSupply(), "ERC721Enumerable: global index out of bounds");
990         return index;
991     }
992 }
993 
994 
995 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
996 
997 
998 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
999 
1000 
1001 
1002 /**
1003  * @dev Contract module which provides a basic access control mechanism, where
1004  * there is an account (an owner) that can be granted exclusive access to
1005  * specific functions.
1006  *
1007  * By default, the owner account will be the one that deploys the contract. This
1008  * can later be changed with {transferOwnership}.
1009  *
1010  * This module is used through inheritance. It will make available the modifier
1011  * `onlyOwner`, which can be applied to your functions to restrict their use to
1012  * the owner.
1013  */
1014 abstract contract Ownable is Context {
1015     address private _owner;
1016 
1017     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1018 
1019     /**
1020      * @dev Initializes the contract setting the deployer as the initial owner.
1021      */
1022     constructor() {
1023         _transferOwnership(_msgSender());
1024     }
1025 
1026     /**
1027      * @dev Returns the address of the current owner.
1028      */
1029     function owner() public view virtual returns (address) {
1030         return _owner;
1031     }
1032 
1033     /**
1034      * @dev Throws if called by any account other than the owner.
1035      */
1036     modifier onlyOwner() {
1037         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1038         _;
1039     }
1040 
1041     /**
1042      * @dev Leaves the contract without owner. It will not be possible to call
1043      * `onlyOwner` functions anymore. Can only be called by the current owner.
1044      *
1045      * NOTE: Renouncing ownership will leave the contract without an owner,
1046      * thereby removing any functionality that is only available to the owner.
1047      */
1048     function renounceOwnership() public virtual onlyOwner {
1049         _transferOwnership(address(0));
1050     }
1051 
1052     /**
1053      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1054      * Can only be called by the current owner.
1055      */
1056     function transferOwnership(address newOwner) public virtual onlyOwner {
1057         require(newOwner != address(0), "Ownable: new owner is the zero address");
1058         _transferOwnership(newOwner);
1059     }
1060 
1061     /**
1062      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1063      * Internal function without access restriction.
1064      */
1065     function _transferOwnership(address newOwner) internal virtual {
1066         address oldOwner = _owner;
1067         _owner = newOwner;
1068         emit OwnershipTransferred(oldOwner, newOwner);
1069     }
1070 }
1071 
1072 
1073 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
1074 
1075 
1076 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1077 
1078 
1079 
1080 /**
1081  * @dev String operations.
1082  */
1083 library Strings {
1084     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1085 
1086     /**
1087      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1088      */
1089     function toString(uint256 value) internal pure returns (string memory) {
1090         // Inspired by OraclizeAPI's implementation - MIT licence
1091         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1092 
1093         if (value == 0) {
1094             return "0";
1095         }
1096         uint256 temp = value;
1097         uint256 digits;
1098         while (temp != 0) {
1099             digits++;
1100             temp /= 10;
1101         }
1102         bytes memory buffer = new bytes(digits);
1103         while (value != 0) {
1104             digits -= 1;
1105             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1106             value /= 10;
1107         }
1108         return string(buffer);
1109     }
1110 
1111     /**
1112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1113      */
1114     function toHexString(uint256 value) internal pure returns (string memory) {
1115         if (value == 0) {
1116             return "0x00";
1117         }
1118         uint256 temp = value;
1119         uint256 length = 0;
1120         while (temp != 0) {
1121             length++;
1122             temp >>= 8;
1123         }
1124         return toHexString(value, length);
1125     }
1126 
1127     /**
1128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1129      */
1130     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1131         bytes memory buffer = new bytes(2 * length + 2);
1132         buffer[0] = "0";
1133         buffer[1] = "x";
1134         for (uint256 i = 2 * length + 1; i > 1; --i) {
1135             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1136             value >>= 4;
1137         }
1138         require(value == 0, "Strings: hex length insufficient");
1139         return string(buffer);
1140     }
1141 }
1142 
1143 
1144 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
1145 
1146 
1147 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1148 
1149 
1150 
1151 /**
1152  * @dev Interface of the ERC20 standard as defined in the EIP.
1153  */
1154 interface IERC20 {
1155     /**
1156      * @dev Returns the amount of tokens in existence.
1157      */
1158     function totalSupply() external view returns (uint256);
1159 
1160     /**
1161      * @dev Returns the amount of tokens owned by `account`.
1162      */
1163     function balanceOf(address account) external view returns (uint256);
1164 
1165     /**
1166      * @dev Moves `amount` tokens from the caller's account to `to`.
1167      *
1168      * Returns a boolean value indicating whether the operation succeeded.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function transfer(address to, uint256 amount) external returns (bool);
1173 
1174     /**
1175      * @dev Returns the remaining number of tokens that `spender` will be
1176      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1177      * zero by default.
1178      *
1179      * This value changes when {approve} or {transferFrom} are called.
1180      */
1181     function allowance(address owner, address spender) external view returns (uint256);
1182 
1183     /**
1184      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1185      *
1186      * Returns a boolean value indicating whether the operation succeeded.
1187      *
1188      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1189      * that someone may use both the old and the new allowance by unfortunate
1190      * transaction ordering. One possible solution to mitigate this race
1191      * condition is to first reduce the spender's allowance to 0 and set the
1192      * desired value afterwards:
1193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1194      *
1195      * Emits an {Approval} event.
1196      */
1197     function approve(address spender, uint256 amount) external returns (bool);
1198 
1199     /**
1200      * @dev Moves `amount` tokens from `from` to `to` using the
1201      * allowance mechanism. `amount` is then deducted from the caller's
1202      * allowance.
1203      *
1204      * Returns a boolean value indicating whether the operation succeeded.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function transferFrom(
1209         address from,
1210         address to,
1211         uint256 amount
1212     ) external returns (bool);
1213 
1214     /**
1215      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1216      * another (`to`).
1217      *
1218      * Note that `value` may be zero.
1219      */
1220     event Transfer(address indexed from, address indexed to, uint256 value);
1221 
1222     /**
1223      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1224      * a call to {approve}. `value` is the new allowance.
1225      */
1226     event Approval(address indexed owner, address indexed spender, uint256 value);
1227 }
1228 
1229 
1230 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
1231 
1232 
1233 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1234 
1235 
1236 
1237 
1238 /**
1239  * @title SafeERC20
1240  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1241  * contract returns false). Tokens that return no value (and instead revert or
1242  * throw on failure) are also supported, non-reverting calls are assumed to be
1243  * successful.
1244  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1245  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1246  */
1247 library SafeERC20 {
1248     using Address for address;
1249 
1250     function safeTransfer(
1251         IERC20 token,
1252         address to,
1253         uint256 value
1254     ) internal {
1255         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1256     }
1257 
1258     function safeTransferFrom(
1259         IERC20 token,
1260         address from,
1261         address to,
1262         uint256 value
1263     ) internal {
1264         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1265     }
1266 
1267     /**
1268      * @dev Deprecated. This function has issues similar to the ones found in
1269      * {IERC20-approve}, and its usage is discouraged.
1270      *
1271      * Whenever possible, use {safeIncreaseAllowance} and
1272      * {safeDecreaseAllowance} instead.
1273      */
1274     function safeApprove(
1275         IERC20 token,
1276         address spender,
1277         uint256 value
1278     ) internal {
1279         // safeApprove should only be called when setting an initial allowance,
1280         // or when resetting it to zero. To increase and decrease it, use
1281         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1282         require(
1283             (value == 0) || (token.allowance(address(this), spender) == 0),
1284             "SafeERC20: approve from non-zero to non-zero allowance"
1285         );
1286         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1287     }
1288 
1289     function safeIncreaseAllowance(
1290         IERC20 token,
1291         address spender,
1292         uint256 value
1293     ) internal {
1294         uint256 newAllowance = token.allowance(address(this), spender) + value;
1295         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1296     }
1297 
1298     function safeDecreaseAllowance(
1299         IERC20 token,
1300         address spender,
1301         uint256 value
1302     ) internal {
1303         unchecked {
1304             uint256 oldAllowance = token.allowance(address(this), spender);
1305             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1306             uint256 newAllowance = oldAllowance - value;
1307             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1308         }
1309     }
1310 
1311     /**
1312      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1313      * on the return value: the return value is optional (but if data is returned, it must not be false).
1314      * @param token The token targeted by the call.
1315      * @param data The call data (encoded using abi.encode or one of its variants).
1316      */
1317     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1318         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1319         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1320         // the target address contains contract code and also asserts for success in the low-level call.
1321 
1322         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1323         if (returndata.length > 0) {
1324             // Return data is optional
1325             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1326         }
1327     }
1328 }
1329 
1330 
1331 // File @openzeppelin/contracts/finance/PaymentSplitter.sol@v4.5.0
1332 
1333 
1334 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1335 
1336 
1337 
1338 
1339 
1340 /**
1341  * @title PaymentSplitter
1342  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1343  * that the Ether will be split in this way, since it is handled transparently by the contract.
1344  *
1345  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1346  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1347  * an amount proportional to the percentage of total shares they were assigned.
1348  *
1349  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1350  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1351  * function.
1352  *
1353  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1354  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1355  * to run tests before sending real value to this contract.
1356  */
1357 contract PaymentSplitter is Context {
1358     event PayeeAdded(address account, uint256 shares);
1359     event PaymentReleased(address to, uint256 amount);
1360     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1361     event PaymentReceived(address from, uint256 amount);
1362 
1363     uint256 private _totalShares;
1364     uint256 private _totalReleased;
1365 
1366     mapping(address => uint256) private _shares;
1367     mapping(address => uint256) private _released;
1368     address[] private _payees;
1369 
1370     mapping(IERC20 => uint256) private _erc20TotalReleased;
1371     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1372 
1373     /**
1374      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1375      * the matching position in the `shares` array.
1376      *
1377      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1378      * duplicates in `payees`.
1379      */
1380     constructor(address[] memory payees, uint256[] memory shares_) payable {
1381         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1382         require(payees.length > 0, "PaymentSplitter: no payees");
1383 
1384         for (uint256 i = 0; i < payees.length; i++) {
1385             _addPayee(payees[i], shares_[i]);
1386         }
1387     }
1388 
1389     /**
1390      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1391      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1392      * reliability of the events, and not the actual splitting of Ether.
1393      *
1394      * To learn more about this see the Solidity documentation for
1395      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1396      * functions].
1397      */
1398     receive() external payable virtual {
1399         emit PaymentReceived(_msgSender(), msg.value);
1400     }
1401 
1402     /**
1403      * @dev Getter for the total shares held by payees.
1404      */
1405     function totalShares() public view returns (uint256) {
1406         return _totalShares;
1407     }
1408 
1409     /**
1410      * @dev Getter for the total amount of Ether already released.
1411      */
1412     function totalReleased() public view returns (uint256) {
1413         return _totalReleased;
1414     }
1415 
1416     /**
1417      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1418      * contract.
1419      */
1420     function totalReleased(IERC20 token) public view returns (uint256) {
1421         return _erc20TotalReleased[token];
1422     }
1423 
1424     /**
1425      * @dev Getter for the amount of shares held by an account.
1426      */
1427     function shares(address account) public view returns (uint256) {
1428         return _shares[account];
1429     }
1430 
1431     /**
1432      * @dev Getter for the amount of Ether already released to a payee.
1433      */
1434     function released(address account) public view returns (uint256) {
1435         return _released[account];
1436     }
1437 
1438     /**
1439      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1440      * IERC20 contract.
1441      */
1442     function released(IERC20 token, address account) public view returns (uint256) {
1443         return _erc20Released[token][account];
1444     }
1445 
1446     /**
1447      * @dev Getter for the address of the payee number `index`.
1448      */
1449     function payee(uint256 index) public view returns (address) {
1450         return _payees[index];
1451     }
1452 
1453     /**
1454      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1455      * total shares and their previous withdrawals.
1456      */
1457     function release(address payable account) public virtual {
1458         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1459 
1460         uint256 totalReceived = address(this).balance + totalReleased();
1461         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1462 
1463         require(payment != 0, "PaymentSplitter: account is not due payment");
1464 
1465         _released[account] += payment;
1466         _totalReleased += payment;
1467 
1468         Address.sendValue(account, payment);
1469         emit PaymentReleased(account, payment);
1470     }
1471 
1472     /**
1473      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1474      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1475      * contract.
1476      */
1477     function release(IERC20 token, address account) public virtual {
1478         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1479 
1480         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1481         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1482 
1483         require(payment != 0, "PaymentSplitter: account is not due payment");
1484 
1485         _erc20Released[token][account] += payment;
1486         _erc20TotalReleased[token] += payment;
1487 
1488         SafeERC20.safeTransfer(token, account, payment);
1489         emit ERC20PaymentReleased(token, account, payment);
1490     }
1491 
1492     /**
1493      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1494      * already released amounts.
1495      */
1496     function _pendingPayment(
1497         address account,
1498         uint256 totalReceived,
1499         uint256 alreadyReleased
1500     ) private view returns (uint256) {
1501         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1502     }
1503 
1504     /**
1505      * @dev Add a new payee to the contract.
1506      * @param account The address of the payee to add.
1507      * @param shares_ The number of shares owned by the payee.
1508      */
1509     function _addPayee(address account, uint256 shares_) private {
1510         require(account != address(0), "PaymentSplitter: account is the zero address");
1511         require(shares_ > 0, "PaymentSplitter: shares are 0");
1512         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1513 
1514         _payees.push(account);
1515         _shares[account] = shares_;
1516         _totalShares = _totalShares + shares_;
1517         emit PayeeAdded(account, shares_);
1518     }
1519 }
1520 
1521 
1522 // File contracts/LarvaCrabsV3.sol
1523 
1524 
1525 
1526 
1527 contract LarvaCrabsV4 is ERC721EnumerableLite, Ownable, PaymentSplitter {
1528   using Strings for uint256;
1529 
1530   string public baseURI;
1531   string public baseExtension = ".json";
1532   bool public isPauseMode = true;
1533   uint256 public Price = 0.025 ether;
1534   uint256 public MaxCollection = 5001;
1535   uint256 public maxMintPerTrx = 10;
1536   bool public isProxied = true;
1537 
1538   address[] private addressList = [
1539     0x7Efa12Bb53D462e12FC136f1AfFA2510D3b4a580,
1540     0x273962695a1d24f8E3316B12Ca294800b5A88659
1541   ];
1542   uint[] private shareList = [
1543     95,
1544     5
1545   ];
1546 
1547   constructor(string memory _name,
1548               string memory _symbol,
1549               string memory _initBaseURI)
1550     ERC721B(_name, _symbol) 
1551     PaymentSplitter(addressList, shareList){
1552     setBaseURI(_initBaseURI);
1553   }
1554 
1555   function _baseURI() internal view virtual returns (string memory) {
1556     return baseURI;
1557   }
1558 
1559   /// #if_succeeds {:msg "totalSupply increase by mint amount"} old(totalSupply()) == totalSupply() - _mintAmount;
1560   function mint(uint256 _mintAmount) public payable {
1561     require(!isPauseMode, "Paused");
1562     uint256 supply = totalSupply();
1563     require(_mintAmount > 0, "Select at least 1 NFT");
1564     require(supply + _mintAmount <= MaxCollection, "Not Enough Left");  
1565       if (msg.sender != owner()) {
1566         require(_mintAmount <= maxMintPerTrx, "Max Mint Amount Reached");
1567         require(msg.value >= Price * _mintAmount, "Balance Insufficient"); 
1568         
1569     }
1570     for (uint256 i = 0; i < _mintAmount; ++i) {
1571       _safeMint(msg.sender, supply + i);
1572     }
1573   }
1574 
1575   function tokenURI(uint256 tokenId) 
1576   public view virtual override returns (string memory)
1577   {
1578     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1579     string memory base = _baseURI();
1580         string memory retURI = "";
1581         if (isProxied) {
1582             retURI = bytes(base).length > 0
1583                      ? string(abi.encodePacked(base, tokenId.toString()))
1584                      : "";
1585         } else {
1586             retURI = bytes(base).length > 0
1587                      ? string(abi.encodePacked(base, tokenId.toString(),
1588                        baseExtension))
1589                     : "";
1590         }
1591 
1592         return retURI;
1593   }
1594 
1595   function gift(uint[] calldata quantity,
1596                 address[] calldata recipient)
1597                 external onlyOwner{
1598     require(quantity.length == recipient.length,
1599             "Must provide equal quantities and recipients" );
1600 
1601     uint totalQuantity = 0;
1602     uint256 supply = totalSupply();
1603     for(uint i = 0; i < quantity.length; ++i){
1604       totalQuantity += quantity[i];
1605     }
1606     require( supply + totalQuantity <= MaxCollection,
1607              "Not Enough Left" );
1608     delete totalQuantity;
1609 
1610     for(uint i = 0; i < recipient.length; ++i){
1611       for(uint j = 0; j < quantity[i]; ++j){
1612         _safeMint( recipient[i], supply++, "" );
1613       }
1614     }
1615   }
1616 
1617   function reserve() public onlyOwner {
1618         uint256 i;
1619         uint256 supply = totalSupply();
1620         require( supply + 30 <= MaxCollection,
1621              "Not Enough Left" );
1622             
1623         for (i = 0; i < 30; i++) {
1624             _safeMint(msg.sender, supply++, "");
1625         }
1626     }
1627 
1628   function flipPauseMode() public onlyOwner{
1629     isPauseMode = !isPauseMode;
1630   }
1631   
1632   function setPrice(uint256 _newPrice) public onlyOwner {
1633     Price = _newPrice;
1634   }
1635 
1636   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1637     maxMintPerTrx = _newmaxMintAmount;
1638   }
1639 
1640   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1641     baseURI = _newBaseURI;
1642   }
1643 
1644   function withdraw() public payable onlyOwner {
1645     (bool cc, ) = payable(owner()).call{value: address(this).balance}("");
1646     require(cc);
1647   }
1648 
1649   function flipIsProxied() public onlyOwner {
1650         isProxied = !isProxied;
1651     }
1652 }