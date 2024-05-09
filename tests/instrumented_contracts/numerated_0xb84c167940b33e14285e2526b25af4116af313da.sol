1 /*
2   _   _ ______ _______ ______          __  __   ______ _    _ 
3  | \ | |  ____|__   __|  ____|   /\   |  \/  | |  ____| |  | |
4  |  \| | |__     | |  | |__     /  \  | \  / | | |__  | |  | |
5  | . ` |  __|    | |  |  __|   / /\ \ | |\/| | |  __| | |  | |
6  | |\  | |       | |  | |____ / ____ \| |  | |_| |____| |__| |
7  |_| \_|_|       |_|  |______/_/    \_\_|  |_(_)______|\____/ 
8  
9 */
10 
11 
12 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
13 
14 // SPDX-License-Identifier: BSD-3-Clause
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 
40 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
41 
42 
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Required interface of an ERC721 compliant contract.
48  */
49 interface IERC721 is IERC165 {
50     /**
51      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
52      */
53     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
54 
55     /**
56      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
57      */
58     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
59 
60     /**
61      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
62      */
63     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
64 
65     /**
66      * @dev Returns the number of tokens in ``owner``'s account.
67      */
68     function balanceOf(address owner) external view returns (uint256 balance);
69 
70     /**
71      * @dev Returns the owner of the `tokenId` token.
72      *
73      * Requirements:
74      *
75      * - `tokenId` must exist.
76      */
77     function ownerOf(uint256 tokenId) external view returns (address owner);
78 
79     /**
80      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
81      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must exist and be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
89      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
90      *
91      * Emits a {Transfer} event.
92      */
93     function safeTransferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Transfers `tokenId` token from `from` to `to`.
101      *
102      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must be owned by `from`.
109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Returns the account approved for `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function getApproved(uint256 tokenId) external view returns (address operator);
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
157      *
158      * See {setApprovalForAll}
159      */
160     function isApprovedForAll(address owner, address operator) external view returns (bool);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 }
182 
183 
184 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
185 
186 
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @title ERC721 token receiver interface
192  * @dev Interface for any contract that wants to support safeTransfers
193  * from ERC721 asset contracts.
194  */
195 interface IERC721Receiver {
196     /**
197      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
198      * by `operator` from `from`, this function is called.
199      *
200      * It must return its Solidity selector to confirm the token transfer.
201      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
202      *
203      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
204      */
205     function onERC721Received(
206         address operator,
207         address from,
208         uint256 tokenId,
209         bytes calldata data
210     ) external returns (bytes4);
211 }
212 
213 
214 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
215 
216 
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
222  * @dev See https://eips.ethereum.org/EIPS/eip-721
223  */
224 interface IERC721Metadata is IERC721 {
225     /**
226      * @dev Returns the token collection name.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the token collection symbol.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
237      */
238     function tokenURI(uint256 tokenId) external view returns (string memory);
239 }
240 
241 
242 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
243 
244 
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize, which returns 0 for contracts in
271         // construction, since the code is only stored at the end of the
272         // constructor execution.
273 
274         uint256 size;
275         assembly {
276             size := extcodesize(account)
277         }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         (bool success, ) = recipient.call{value: amount}("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain `call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         require(isContract(target), "Address: call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.call{value: value}(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
385         return functionStaticCall(target, data, "Address: low-level static call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal view returns (bytes memory) {
399         require(isContract(target), "Address: static call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.staticcall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
412         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(isContract(target), "Address: delegate call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.delegatecall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
434      * revert reason using the provided one.
435      *
436      * _Available since v4.3._
437      */
438     function verifyCallResult(
439         bool success,
440         bytes memory returndata,
441         string memory errorMessage
442     ) internal pure returns (bytes memory) {
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 
462 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
463 
464 
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Provides information about the current execution context, including the
470  * sender of the transaction and its data. While these are generally available
471  * via msg.sender and msg.data, they should not be accessed in such a direct
472  * manner, since when dealing with meta-transactions the account sending and
473  * paying for execution may not be the actual sender (as far as an application
474  * is concerned).
475  *
476  * This contract is only required for intermediate, library-like contracts.
477  */
478 abstract contract Context {
479     function _msgSender() internal view virtual returns (address) {
480         return msg.sender;
481     }
482 
483     function _msgData() internal view virtual returns (bytes calldata) {
484         return msg.data;
485     }
486 }
487 
488 
489 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
490 
491 
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Implementation of the {IERC165} interface.
497  *
498  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
499  * for the additional interface id that will be supported. For example:
500  *
501  * ```solidity
502  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
503  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
504  * }
505  * ```
506  *
507  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
508  */
509 abstract contract ERC165 is IERC165 {
510     /**
511      * @dev See {IERC165-supportsInterface}.
512      */
513     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514         return interfaceId == type(IERC165).interfaceId;
515     }
516 }
517 
518 
519 // File contracts/Blimpie/ERC721B.sol
520 
521 
522 pragma solidity ^0.8.0;
523 
524 /********************
525 * @author: Squeebo *
526 ********************/
527 
528 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
529     using Address for address;
530 
531     // Token name
532     string private _name;
533 
534     // Token symbol
535     string private _symbol;
536 
537     // Mapping from token ID to owner address
538     address[] internal _owners;
539 
540     // Mapping from token ID to approved address
541     mapping(uint256 => address) private _tokenApprovals;
542 
543     // Mapping from owner to operator approvals
544     mapping(address => mapping(address => bool)) private _operatorApprovals;
545 
546     /**
547      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
548      */
549     constructor(string memory name_, string memory symbol_) {
550         _name = name_;
551         _symbol = symbol_;
552     }
553 
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
558         return
559             interfaceId == type(IERC721).interfaceId ||
560             interfaceId == type(IERC721Metadata).interfaceId ||
561             super.supportsInterface(interfaceId);
562     }
563 
564     /**
565      * @dev See {IERC721-balanceOf}.
566      */
567     function balanceOf(address owner) public view virtual override returns (uint256) {
568         require(owner != address(0), "ERC721: balance query for the zero address");
569 
570         uint count = 0;
571         uint length = _owners.length;
572         for( uint i = 0; i < length; ++i ){
573           if( owner == _owners[i] ){
574             ++count;
575           }
576         }
577 
578         delete length;
579         return count;
580     }
581 
582     /**
583      * @dev See {IERC721-ownerOf}.
584      */
585     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
586         address owner = _owners[tokenId];
587         require(owner != address(0), "ERC721: owner query for nonexistent token");
588         return owner;
589     }
590 
591     /**
592      * @dev See {IERC721Metadata-name}.
593      */
594     function name() public view virtual override returns (string memory) {
595         return _name;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-symbol}.
600      */
601     function symbol() public view virtual override returns (string memory) {
602         return _symbol;
603     }
604 
605     /**
606      * @dev See {IERC721-approve}.
607      */
608     function approve(address to, uint256 tokenId) public virtual override {
609         address owner = ERC721B.ownerOf(tokenId);
610         require(to != owner, "ERC721: approval to current owner");
611 
612         require(
613             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
614             "ERC721: approve caller is not owner nor approved for all"
615         );
616 
617         _approve(to, tokenId);
618     }
619 
620     /**
621      * @dev See {IERC721-getApproved}.
622      */
623     function getApproved(uint256 tokenId) public view virtual override returns (address) {
624         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
625 
626         return _tokenApprovals[tokenId];
627     }
628 
629     /**
630      * @dev See {IERC721-setApprovalForAll}.
631      */
632     function setApprovalForAll(address operator, bool approved) public virtual override {
633         require(operator != _msgSender(), "ERC721: approve to caller");
634 
635         _operatorApprovals[_msgSender()][operator] = approved;
636         emit ApprovalForAll(_msgSender(), operator, approved);
637     }
638 
639     /**
640      * @dev See {IERC721-isApprovedForAll}.
641      */
642     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
643         return _operatorApprovals[owner][operator];
644     }
645 
646 
647     /**
648      * @dev See {IERC721-transferFrom}.
649      */
650     function transferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) public virtual override {
655         //solhint-disable-next-line max-line-length
656         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
657 
658         _transfer(from, to, tokenId);
659     }
660 
661     /**
662      * @dev See {IERC721-safeTransferFrom}.
663      */
664     function safeTransferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) public virtual override {
669         safeTransferFrom(from, to, tokenId, "");
670     }
671 
672     /**
673      * @dev See {IERC721-safeTransferFrom}.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId,
679         bytes memory _data
680     ) public virtual override {
681         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
682         _safeTransfer(from, to, tokenId, _data);
683     }
684 
685     /**
686      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
687      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
688      *
689      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
690      *
691      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
692      * implement alternative mechanisms to perform token transfer, such as signature-based.
693      *
694      * Requirements:
695      *
696      * - `from` cannot be the zero address.
697      * - `to` cannot be the zero address.
698      * - `tokenId` token must exist and be owned by `from`.
699      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
700      *
701      * Emits a {Transfer} event.
702      */
703     function _safeTransfer(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes memory _data
708     ) internal virtual {
709         _transfer(from, to, tokenId);
710         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
711     }
712 
713     /**
714      * @dev Returns whether `tokenId` exists.
715      *
716      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
717      *
718      * Tokens start existing when they are minted (`_mint`),
719      * and stop existing when they are burned (`_burn`).
720      */
721     function _exists(uint256 tokenId) internal view virtual returns (bool) {
722         return tokenId < _owners.length && _owners[tokenId] != address(0);
723     }
724 
725     /**
726      * @dev Returns whether `spender` is allowed to manage `tokenId`.
727      *
728      * Requirements:
729      *
730      * - `tokenId` must exist.
731      */
732     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
733         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
734         address owner = ERC721B.ownerOf(tokenId);
735         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
736     }
737 
738     /**
739      * @dev Safely mints `tokenId` and transfers it to `to`.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must not exist.
744      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
745      *
746      * Emits a {Transfer} event.
747      */
748     function _safeMint(address to, uint256 tokenId) internal virtual {
749         _safeMint(to, tokenId, "");
750     }
751 
752 
753     /**
754      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
755      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
756      */
757     function _safeMint(
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) internal virtual {
762         _mint(to, tokenId);
763         require(
764             _checkOnERC721Received(address(0), to, tokenId, _data),
765             "ERC721: transfer to non ERC721Receiver implementer"
766         );
767     }
768 
769     /**
770      * @dev Mints `tokenId` and transfers it to `to`.
771      *
772      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
773      *
774      * Requirements:
775      *
776      * - `tokenId` must not exist.
777      * - `to` cannot be the zero address.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _mint(address to, uint256 tokenId) internal virtual {
782         require(to != address(0), "ERC721: mint to the zero address");
783         require(!_exists(tokenId), "ERC721: token already minted");
784 
785         _beforeTokenTransfer(address(0), to, tokenId);
786         _owners.push(to);
787 
788         emit Transfer(address(0), to, tokenId);
789     }
790 
791     /**
792      * @dev Destroys `tokenId`.
793      * The approval is cleared when the token is burned.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _burn(uint256 tokenId) internal virtual {
802         address owner = ERC721B.ownerOf(tokenId);
803 
804         _beforeTokenTransfer(owner, address(0), tokenId);
805 
806         // Clear approvals
807         _approve(address(0), tokenId);
808         _owners[tokenId] = address(0);
809 
810         emit Transfer(owner, address(0), tokenId);
811     }
812 
813     /**
814      * @dev Transfers `tokenId` from `from` to `to`.
815      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
816      *
817      * Requirements:
818      *
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _transfer(
825         address from,
826         address to,
827         uint256 tokenId
828     ) internal virtual {
829         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
830         require(to != address(0), "ERC721: transfer to the zero address");
831 
832         _beforeTokenTransfer(from, to, tokenId);
833 
834         // Clear approvals from the previous owner
835         _approve(address(0), tokenId);
836         _owners[tokenId] = to;
837 
838         emit Transfer(from, to, tokenId);
839     }
840 
841     /**
842      * @dev Approve `to` to operate on `tokenId`
843      *
844      * Emits a {Approval} event.
845      */
846     function _approve(address to, uint256 tokenId) internal virtual {
847         _tokenApprovals[tokenId] = to;
848         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
849     }
850 
851 
852     /**
853      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
854      * The call is not executed if the target address is not a contract.
855      *
856      * @param from address representing the previous owner of the given token ID
857      * @param to target address that will receive the tokens
858      * @param tokenId uint256 ID of the token to be transferred
859      * @param _data bytes optional data to send along with the call
860      * @return bool whether the call correctly returned the expected magic value
861      */
862     function _checkOnERC721Received(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) private returns (bool) {
868         if (to.isContract()) {
869             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
870                 return retval == IERC721Receiver.onERC721Received.selector;
871             } catch (bytes memory reason) {
872                 if (reason.length == 0) {
873                     revert("ERC721: transfer to non ERC721Receiver implementer");
874                 } else {
875                     assembly {
876                         revert(add(32, reason), mload(reason))
877                     }
878                 }
879             }
880         } else {
881             return true;
882         }
883     }
884 
885     /**
886      * @dev Hook that is called before any token transfer. This includes minting
887      * and burning.
888      *
889      * Calling conditions:
890      *
891      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
892      * transferred to `to`.
893      * - When `from` is zero, `tokenId` will be minted for `to`.
894      * - When `to` is zero, ``from``'s `tokenId` will be burned.
895      * - `from` and `to` are never both zero.
896      *
897      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
898      */
899     function _beforeTokenTransfer(
900         address from,
901         address to,
902         uint256 tokenId
903     ) internal virtual {}
904 }
905 
906 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
907 
908 
909 
910 pragma solidity ^0.8.0;
911 
912 /**
913  * @dev String operations.
914  */
915 library Strings {
916     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
917 
918     /**
919      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
920      */
921     function toString(uint256 value) internal pure returns (string memory) {
922         // Inspired by OraclizeAPI's implementation - MIT licence
923         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
924 
925         if (value == 0) {
926             return "0";
927         }
928         uint256 temp = value;
929         uint256 digits;
930         while (temp != 0) {
931             digits++;
932             temp /= 10;
933         }
934         bytes memory buffer = new bytes(digits);
935         while (value != 0) {
936             digits -= 1;
937             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
938             value /= 10;
939         }
940         return string(buffer);
941     }
942 
943     /**
944      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
945      */
946     function toHexString(uint256 value) internal pure returns (string memory) {
947         if (value == 0) {
948             return "0x00";
949         }
950         uint256 temp = value;
951         uint256 length = 0;
952         while (temp != 0) {
953             length++;
954             temp >>= 8;
955         }
956         return toHexString(value, length);
957     }
958 
959     /**
960      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
961      */
962     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
963         bytes memory buffer = new bytes(2 * length + 2);
964         buffer[0] = "0";
965         buffer[1] = "x";
966         for (uint256 i = 2 * length + 1; i > 1; --i) {
967             buffer[i] = _HEX_SYMBOLS[value & 0xf];
968             value >>= 4;
969         }
970         require(value == 0, "Strings: hex length insufficient");
971         return string(buffer);
972     }
973 }
974 
975 
976 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
977 
978 
979 
980 pragma solidity ^0.8.0;
981 
982 /**
983  * @dev Contract module which provides a basic access control mechanism, where
984  * there is an account (an owner) that can be granted exclusive access to
985  * specific functions.
986  *
987  * By default, the owner account will be the one that deploys the contract. This
988  * can later be changed with {transferOwnership}.
989  *
990  * This module is used through inheritance. It will make available the modifier
991  * `onlyOwner`, which can be applied to your functions to restrict their use to
992  * the owner.
993  */
994 abstract contract Ownable is Context {
995     address private _owner;
996 
997     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
998 
999     /**
1000      * @dev Initializes the contract setting the deployer as the initial owner.
1001      */
1002     constructor() {
1003         _setOwner(_msgSender());
1004     }
1005 
1006     /**
1007      * @dev Returns the address of the current owner.
1008      */
1009     function owner() public view virtual returns (address) {
1010         return _owner;
1011     }
1012 
1013     /**
1014      * @dev Throws if called by any account other than the owner.
1015      */
1016     modifier onlyOwner() {
1017         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1018         _;
1019     }
1020 
1021     /**
1022      * @dev Leaves the contract without owner. It will not be possible to call
1023      * `onlyOwner` functions anymore. Can only be called by the current owner.
1024      *
1025      * NOTE: Renouncing ownership will leave the contract without an owner,
1026      * thereby removing any functionality that is only available to the owner.
1027      */
1028     function renounceOwnership() public virtual onlyOwner {
1029         _setOwner(address(0));
1030     }
1031 
1032     /**
1033      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1034      * Can only be called by the current owner.
1035      */
1036     function transferOwnership(address newOwner) public virtual onlyOwner {
1037         require(newOwner != address(0), "Ownable: new owner is the zero address");
1038         _setOwner(newOwner);
1039     }
1040 
1041     function _setOwner(address newOwner) private {
1042         address oldOwner = _owner;
1043         _owner = newOwner;
1044         emit OwnershipTransferred(oldOwner, newOwner);
1045     }
1046 }
1047 
1048 pragma solidity ^0.8.7;
1049 
1050 library ECDSA {
1051     enum RecoverError {
1052         NoError,
1053         InvalidSignature,
1054         InvalidSignatureLength,
1055         InvalidSignatureS,
1056         InvalidSignatureV
1057     }
1058 
1059     function _throwError(RecoverError error) private pure {
1060         if (error == RecoverError.NoError) {
1061             return; // no error: do nothing
1062         } else if (error == RecoverError.InvalidSignature) {
1063             revert("ECDSA: invalid signature");
1064         } else if (error == RecoverError.InvalidSignatureLength) {
1065             revert("ECDSA: invalid signature length");
1066         } else if (error == RecoverError.InvalidSignatureS) {
1067             revert("ECDSA: invalid signature 's' value");
1068         } else if (error == RecoverError.InvalidSignatureV) {
1069             revert("ECDSA: invalid signature 'v' value");
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns the address that signed a hashed message (`hash`) with
1075      * `signature` or error string. This address can then be used for verification purposes.
1076      *
1077      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1078      * this function rejects them by requiring the `s` value to be in the lower
1079      * half order, and the `v` value to be either 27 or 28.
1080      *
1081      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1082      * verification to be secure: it is possible to craft signatures that
1083      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1084      * this is by receiving a hash of the original message (which may otherwise
1085      * be too long), and then calling {toEthSignedMessageHash} on it.
1086      *
1087      * Documentation for signature generation:
1088      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1089      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1090      *
1091      * _Available since v4.3._
1092      */
1093     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1094         // Check the signature length
1095         // - case 65: r,s,v signature (standard)
1096         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1097         if (signature.length == 65) {
1098             bytes32 r;
1099             bytes32 s;
1100             uint8 v;
1101             // ecrecover takes the signature parameters, and the only way to get them
1102             // currently is to use assembly.
1103             assembly {
1104                 r := mload(add(signature, 0x20))
1105                 s := mload(add(signature, 0x40))
1106                 v := byte(0, mload(add(signature, 0x60)))
1107             }
1108             return tryRecover(hash, v, r, s);
1109         } else if (signature.length == 64) {
1110             bytes32 r;
1111             bytes32 vs;
1112             // ecrecover takes the signature parameters, and the only way to get them
1113             // currently is to use assembly.
1114             assembly {
1115                 r := mload(add(signature, 0x20))
1116                 vs := mload(add(signature, 0x40))
1117             }
1118             return tryRecover(hash, r, vs);
1119         } else {
1120             return (address(0), RecoverError.InvalidSignatureLength);
1121         }
1122     }
1123 
1124     /**
1125      * @dev Returns the address that signed a hashed message (`hash`) with
1126      * `signature`. This address can then be used for verification purposes.
1127      *
1128      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1129      * this function rejects them by requiring the `s` value to be in the lower
1130      * half order, and the `v` value to be either 27 or 28.
1131      *
1132      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1133      * verification to be secure: it is possible to craft signatures that
1134      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1135      * this is by receiving a hash of the original message (which may otherwise
1136      * be too long), and then calling {toEthSignedMessageHash} on it.
1137      */
1138     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1139         (address recovered, RecoverError error) = tryRecover(hash, signature);
1140         _throwError(error);
1141         return recovered;
1142     }
1143 
1144     /**
1145      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1146      *
1147      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1148      *
1149      * _Available since v4.3._
1150      */
1151     function tryRecover(
1152         bytes32 hash,
1153         bytes32 r,
1154         bytes32 vs
1155     ) internal pure returns (address, RecoverError) {
1156         bytes32 s;
1157         uint8 v;
1158         assembly {
1159             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1160             v := add(shr(255, vs), 27)
1161         }
1162         return tryRecover(hash, v, r, s);
1163     }
1164 
1165     /**
1166      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1167      * `r` and `s` signature fields separately.
1168      *
1169      * _Available since v4.3._
1170      */
1171     function tryRecover(
1172         bytes32 hash,
1173         uint8 v,
1174         bytes32 r,
1175         bytes32 s
1176     ) internal pure returns (address, RecoverError) {
1177         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1178         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1179         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1180         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1181         //
1182         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1183         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1184         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1185         // these malleable signatures as well.
1186         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1187             return (address(0), RecoverError.InvalidSignatureS);
1188         }
1189         if (v != 27 && v != 28) {
1190             return (address(0), RecoverError.InvalidSignatureV);
1191         }
1192 
1193         // If the signature is valid (and not malleable), return the signer address
1194         address signer = ecrecover(hash, v, r, s);
1195         if (signer == address(0)) {
1196             return (address(0), RecoverError.InvalidSignature);
1197         }
1198 
1199         return (signer, RecoverError.NoError);
1200     }
1201 }
1202 
1203 pragma solidity ^0.8.9;
1204 
1205 contract FaeNFT is  Ownable, ERC721B {
1206 
1207     using ECDSA for bytes32;
1208     using Strings for uint256;
1209 
1210     uint256 public constant COLLECTIBLE_MAX = 5556;
1211     uint256 public constant COLLECTIBLE_GIFT = 100;
1212     uint256 public constant COLLECTIBLE_PRICE = 0.1 ether;
1213     uint256 public constant COLLECTIBLE_PRESALE_PRICE = 0.06 ether;
1214     uint256 public constant COLLECTIBLE_PER_MINT = 10;
1215     uint256 public constant COLLECTIBLE_PRESALE_PURCHASE_LIMIT = 5;
1216     uint256 public giftedAmount;
1217 
1218     string public provenance;
1219     string private _tokenBaseURI;
1220 
1221     address private signerAddress = 0xDD01b77662E97AD121E3D1676fE618a2fe28A6E1;
1222 
1223     bool public presaleLive;
1224     bool public saleLive;
1225 
1226     mapping(address => uint256) public presalerListPurchases;
1227     mapping(address => uint256) public purchases;
1228 
1229     mapping(address => bool) public freeList;
1230     mapping(address => uint256) public freePurchases;
1231     
1232     constructor(
1233         string memory baseUri
1234     ) ERC721B("Fae NFT", "FAE") { 
1235         _tokenBaseURI = baseUri;
1236         _mint( msg.sender, 0 );
1237     }
1238 
1239     function addToFreeList(address[] calldata entries) external onlyOwner {
1240         for(uint256 i = 0; i < entries.length; i++) {
1241             address entry = entries[i];
1242             require(entry != address(0), "NULL_ADDRESS");
1243             require(!freeList[entry], "DUPLICATED_ENTRY");
1244             freeList[entry] = true;
1245         }   
1246     }
1247 
1248     function removeFromFreeList(address[] calldata entries) external onlyOwner {
1249         for(uint256 i = 0; i < entries.length; i++) {
1250             address entry = entries[i];
1251             require(entry != address(0), "NULL_ADDRESS");
1252             freeList[entry] = false;
1253         }
1254     }
1255 
1256     function freeMint() external {
1257         require(freeList[msg.sender], "NOT_QUALIFIED");
1258         require(freePurchases[msg.sender] < 2, "MAX_REACHED");
1259         require(totalSupply() <= COLLECTIBLE_MAX, "EXCEED_MAX_SALE_SUPPLY");
1260 
1261         freePurchases[msg.sender]++;
1262 
1263         uint mintIndex = totalSupply();
1264         _mint( msg.sender, mintIndex );
1265     }
1266 
1267     function totalSupply() public view virtual returns (uint256) {
1268         return _owners.length;
1269     }
1270 
1271     function buy(bytes32 hash, bytes memory signature, uint256 tokenQuantity) external payable {
1272         require(saleLive, "SALE_CLOSED");
1273         require(!presaleLive, "ONLY_PRESALE");
1274         require(tokenQuantity <= COLLECTIBLE_PER_MINT, "EXCEED_COLLECTIBLE_PER_MINT");
1275         require(COLLECTIBLE_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1276         require(totalSupply() + tokenQuantity <= COLLECTIBLE_MAX, "EXCEED_MAX_SALE_SUPPLY");
1277         require(matchAddressSigner(hash, signature), "NO_DIRECT_MINT");
1278 
1279         for(uint256 i = 0; i < tokenQuantity; i++) {
1280             uint mintIndex = totalSupply();
1281            _mint( msg.sender, mintIndex );
1282         }
1283     } 
1284 
1285     function presaleBuy(bytes32 hash, bytes memory signature, uint256 tokenQuantity) external payable {
1286         require(!saleLive && presaleLive, "PRESALE_CLOSED");
1287         require(presalerListPurchases[msg.sender] + tokenQuantity <= COLLECTIBLE_PRESALE_PURCHASE_LIMIT, "EXCEED_ALLOC");
1288         require(tokenQuantity <= COLLECTIBLE_PER_MINT, "EXCEED_COLLECTIBLE_PER_MINT");
1289         require(COLLECTIBLE_PRESALE_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1290         require(totalSupply() + tokenQuantity <= COLLECTIBLE_MAX, "EXCEED_MAX_SALE_SUPPLY");
1291         require(matchAddressSigner(hash, signature), "NO_DIRECT_MINT");
1292 
1293         presalerListPurchases[msg.sender] += tokenQuantity;
1294 
1295         for (uint256 i = 0; i < tokenQuantity; i++) {
1296             uint mintIndex = totalSupply();
1297             _mint( msg.sender, mintIndex );
1298         }
1299     } 
1300 
1301     function withdraw() external onlyOwner {
1302         _withdraw(msg.sender, address(this).balance);
1303     }
1304 
1305     function _withdraw(address _address, uint256 _amount) private {
1306         (bool success, ) = _address.call{value: _amount}("");
1307         require(success, "Transfer failed.");
1308     }
1309 
1310     function gift(address _to, uint256 _reserveAmount) external onlyOwner {
1311         require(totalSupply() + _reserveAmount <= COLLECTIBLE_MAX, "MAX_MINT");
1312         require(giftedAmount + _reserveAmount <= COLLECTIBLE_GIFT, "NO_GIFTS");
1313         
1314         for (uint256 i = 0; i < _reserveAmount; i++) {
1315             uint mintIndex = totalSupply();
1316             giftedAmount++;
1317             _safeMint(_to, mintIndex );
1318         }
1319     }
1320 
1321     function togglePresaleStatus() external onlyOwner {
1322         presaleLive = !presaleLive;
1323     } 
1324 
1325     function toggleSaleStatus() external onlyOwner {
1326         saleLive = !saleLive;
1327     }
1328 
1329     function setBaseURI(string calldata URI) external onlyOwner {
1330         _tokenBaseURI = URI;
1331     }
1332     
1333     function setProvenanceHash(string calldata hash) external onlyOwner {
1334         provenance = hash;
1335     } 
1336 
1337     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1338         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1339         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1340     } 
1341 
1342     function presalePurchasedCount(address addr) external view returns (uint256) {
1343         return presalerListPurchases[addr];
1344     } 
1345 
1346     function matchAddressSigner(bytes32 hash, bytes memory signature) private view returns(bool) {
1347         return signerAddress == hash.recover(signature);
1348     }
1349 }