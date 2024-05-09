1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-14
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 
171 
172 
173 /**
174  * @title ERC721 token receiver interface
175  * @dev Interface for any contract that wants to support safeTransfers
176  * from ERC721 asset contracts.
177  */
178 interface IERC721Receiver {
179     /**
180      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
181      * by `operator` from `from`, this function is called.
182      *
183      * It must return its Solidity selector to confirm the token transfer.
184      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
185      *
186      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
187      */
188     function onERC721Received(
189         address operator,
190         address from,
191         uint256 tokenId,
192         bytes calldata data
193     ) external returns (bytes4);
194 }
195 
196 
197 
198 
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Metadata is IERC721 {
205     /**
206      * @dev Returns the token collection name.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the token collection symbol.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217      */
218     function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize, which returns 0 for contracts in
246         // construction, since the code is only stored at the end of the
247         // constructor execution.
248 
249         uint256 size;
250         assembly {
251             size := extcodesize(account)
252         }
253         return size > 0;
254     }
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         (bool success, ) = recipient.call{value: amount}("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain `call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         require(isContract(target), "Address: call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.call{value: value}(data);
350         return _verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
360         return functionStaticCall(target, data, "Address: low-level static call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal view returns (bytes memory) {
374         require(isContract(target), "Address: static call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return _verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(isContract(target), "Address: delegate call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.delegatecall(data);
404         return _verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     function _verifyCallResult(
408         bool success,
409         bytes memory returndata,
410         string memory errorMessage
411     ) private pure returns (bytes memory) {
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 
431 
432 
433 /*
434  * @dev Provides information about the current execution context, including the
435  * sender of the transaction and its data. While these are generally available
436  * via msg.sender and msg.data, they should not be accessed in such a direct
437  * manner, since when dealing with meta-transactions the account sending and
438  * paying for execution may not be the actual sender (as far as an application
439  * is concerned).
440  *
441  * This contract is only required for intermediate, library-like contracts.
442  */
443 abstract contract Context {
444     function _msgSender() internal view virtual returns (address) {
445         return msg.sender;
446     }
447 
448     function _msgData() internal view virtual returns (bytes calldata) {
449         return msg.data;
450     }
451 }
452 
453 
454 
455 /**
456  * @dev String operations.
457  */
458 library Strings {
459     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
460 
461     /**
462      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
463      */
464     function toString(uint256 value) internal pure returns (string memory) {
465         // Inspired by OraclizeAPI's implementation - MIT licence
466         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
467 
468         if (value == 0) {
469             return "0";
470         }
471         uint256 temp = value;
472         uint256 digits;
473         while (temp != 0) {
474             digits++;
475             temp /= 10;
476         }
477         bytes memory buffer = new bytes(digits);
478         while (value != 0) {
479             digits -= 1;
480             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
481             value /= 10;
482         }
483         return string(buffer);
484     }
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
488      */
489     function toHexString(uint256 value) internal pure returns (string memory) {
490         if (value == 0) {
491             return "0x00";
492         }
493         uint256 temp = value;
494         uint256 length = 0;
495         while (temp != 0) {
496             length++;
497             temp >>= 8;
498         }
499         return toHexString(value, length);
500     }
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
504      */
505     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
506         bytes memory buffer = new bytes(2 * length + 2);
507         buffer[0] = "0";
508         buffer[1] = "x";
509         for (uint256 i = 2 * length + 1; i > 1; --i) {
510             buffer[i] = _HEX_SYMBOLS[value & 0xf];
511             value >>= 4;
512         }
513         require(value == 0, "Strings: hex length insufficient");
514         return string(buffer);
515     }
516 }
517 
518 
519 
520 
521 
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * ```solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * ```
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544 
545 
546 
547 
548 /**
549  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
550  * the Metadata extension, but not including the Enumerable extension, which is available separately as
551  * {ERC721Enumerable}.
552  */
553 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
554     using Address for address;
555     using Strings for uint256;
556 
557     // Token name
558     string private _name;
559 
560     // Token symbol
561     string private _symbol;
562 
563     // Mapping from token ID to owner address
564     mapping(uint256 => address) private _owners;
565 
566     // Mapping owner address to token count
567     mapping(address => uint256) private _balances;
568 
569     // Mapping from token ID to approved address
570     mapping(uint256 => address) private _tokenApprovals;
571 
572     // Mapping from owner to operator approvals
573     mapping(address => mapping(address => bool)) private _operatorApprovals;
574 
575     /**
576      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
577      */
578     constructor(string memory name_, string memory symbol_) {
579         _name = name_;
580         _symbol = symbol_;
581     }
582 
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
587         return
588             interfaceId == type(IERC721).interfaceId ||
589             interfaceId == type(IERC721Metadata).interfaceId ||
590             super.supportsInterface(interfaceId);
591     }
592 
593     /**
594      * @dev See {IERC721-balanceOf}.
595      */
596     function balanceOf(address owner) public view virtual override returns (uint256) {
597         require(owner != address(0), "ERC721: balance query for the zero address");
598         return _balances[owner];
599     }
600 
601     /**
602      * @dev See {IERC721-ownerOf}.
603      */
604     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
605         address owner = _owners[tokenId];
606         require(owner != address(0), "ERC721: owner query for nonexistent token");
607         return owner;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-name}.
612      */
613     function name() public view virtual override returns (string memory) {
614         return _name;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-symbol}.
619      */
620     function symbol() public view virtual override returns (string memory) {
621         return _symbol;
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-tokenURI}.
626      */
627     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
628         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
629 
630         string memory baseURI = _baseURI();
631         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
632     }
633 
634     /**
635      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
636      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
637      * by default, can be overriden in child contracts.
638      */
639     function _baseURI() internal view virtual returns (string memory) {
640         return "";
641     }
642 
643     /**
644      * @dev See {IERC721-approve}.
645      */
646     function approve(address to, uint256 tokenId) public virtual override {
647         address owner = ERC721.ownerOf(tokenId);
648         require(to != owner, "ERC721: approval to current owner");
649 
650         require(
651             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
652             "ERC721: approve caller is not owner nor approved for all"
653         );
654 
655         _approve(to, tokenId);
656     }
657 
658     /**
659      * @dev See {IERC721-getApproved}.
660      */
661     function getApproved(uint256 tokenId) public view virtual override returns (address) {
662         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
663 
664         return _tokenApprovals[tokenId];
665     }
666 
667     /**
668      * @dev See {IERC721-setApprovalForAll}.
669      */
670     function setApprovalForAll(address operator, bool approved) public virtual override {
671         require(operator != _msgSender(), "ERC721: approve to caller");
672 
673         _operatorApprovals[_msgSender()][operator] = approved;
674         emit ApprovalForAll(_msgSender(), operator, approved);
675     }
676 
677     /**
678      * @dev See {IERC721-isApprovedForAll}.
679      */
680     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
681         return _operatorApprovals[owner][operator];
682     }
683 
684     /**
685      * @dev See {IERC721-transferFrom}.
686      */
687     function transferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) public virtual override {
692         //solhint-disable-next-line max-line-length
693         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
694 
695         _transfer(from, to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-safeTransferFrom}.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) public virtual override {
706         safeTransferFrom(from, to, tokenId, "");
707     }
708 
709     /**
710      * @dev See {IERC721-safeTransferFrom}.
711      */
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId,
716         bytes memory _data
717     ) public virtual override {
718         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
719         _safeTransfer(from, to, tokenId, _data);
720     }
721 
722     /**
723      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
724      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
725      *
726      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
727      *
728      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
729      * implement alternative mechanisms to perform token transfer, such as signature-based.
730      *
731      * Requirements:
732      *
733      * - `from` cannot be the zero address.
734      * - `to` cannot be the zero address.
735      * - `tokenId` token must exist and be owned by `from`.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _safeTransfer(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes memory _data
745     ) internal virtual {
746         _transfer(from, to, tokenId);
747         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
748     }
749 
750     /**
751      * @dev Returns whether `tokenId` exists.
752      *
753      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
754      *
755      * Tokens start existing when they are minted (`_mint`),
756      * and stop existing when they are burned (`_burn`).
757      */
758     function _exists(uint256 tokenId) internal view virtual returns (bool) {
759         return _owners[tokenId] != address(0);
760     }
761 
762     /**
763      * @dev Returns whether `spender` is allowed to manage `tokenId`.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
770         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
771         address owner = ERC721.ownerOf(tokenId);
772         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
773     }
774 
775     /**
776      * @dev Safely mints `tokenId` and transfers it to `to`.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must not exist.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeMint(address to, uint256 tokenId) internal virtual {
786         _safeMint(to, tokenId, "");
787     }
788 
789     /**
790      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
791      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
792      */
793     function _safeMint(
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) internal virtual {
798         _mint(to, tokenId);
799         require(
800             _checkOnERC721Received(address(0), to, tokenId, _data),
801             "ERC721: transfer to non ERC721Receiver implementer"
802         );
803     }
804 
805     /**
806      * @dev Mints `tokenId` and transfers it to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
809      *
810      * Requirements:
811      *
812      * - `tokenId` must not exist.
813      * - `to` cannot be the zero address.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _mint(address to, uint256 tokenId) internal virtual {
818         require(to != address(0), "ERC721: mint to the zero address");
819         require(!_exists(tokenId), "ERC721: token already minted");
820 
821         _beforeTokenTransfer(address(0), to, tokenId);
822 
823         _balances[to] += 1;
824         _owners[tokenId] = to;
825 
826         emit Transfer(address(0), to, tokenId);
827     }
828 
829     /**
830      * @dev Destroys `tokenId`.
831      * The approval is cleared when the token is burned.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _burn(uint256 tokenId) internal virtual {
840         address owner = ERC721.ownerOf(tokenId);
841 
842         _beforeTokenTransfer(owner, address(0), tokenId);
843 
844         // Clear approvals
845         _approve(address(0), tokenId);
846 
847         _balances[owner] -= 1;
848         delete _owners[tokenId];
849 
850         emit Transfer(owner, address(0), tokenId);
851     }
852 
853     /**
854      * @dev Transfers `tokenId` from `from` to `to`.
855      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _transfer(
865         address from,
866         address to,
867         uint256 tokenId
868     ) internal virtual {
869         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
870         require(to != address(0), "ERC721: transfer to the zero address");
871 
872         _beforeTokenTransfer(from, to, tokenId);
873 
874         // Clear approvals from the previous owner
875         _approve(address(0), tokenId);
876 
877         _balances[from] -= 1;
878         _balances[to] += 1;
879         _owners[tokenId] = to;
880 
881         emit Transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev Approve `to` to operate on `tokenId`
886      *
887      * Emits a {Approval} event.
888      */
889     function _approve(address to, uint256 tokenId) internal virtual {
890         _tokenApprovals[tokenId] = to;
891         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
892     }
893 
894     /**
895      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
896      * The call is not executed if the target address is not a contract.
897      *
898      * @param from address representing the previous owner of the given token ID
899      * @param to target address that will receive the tokens
900      * @param tokenId uint256 ID of the token to be transferred
901      * @param _data bytes optional data to send along with the call
902      * @return bool whether the call correctly returned the expected magic value
903      */
904     function _checkOnERC721Received(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) private returns (bool) {
910         if (to.isContract()) {
911             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
912                 return retval == IERC721Receiver(to).onERC721Received.selector;
913             } catch (bytes memory reason) {
914                 if (reason.length == 0) {
915                     revert("ERC721: transfer to non ERC721Receiver implementer");
916                 } else {
917                     assembly {
918                         revert(add(32, reason), mload(reason))
919                     }
920                 }
921             }
922         } else {
923             return true;
924         }
925     }
926 
927     /**
928      * @dev Hook that is called before any token transfer. This includes minting
929      * and burning.
930      *
931      * Calling conditions:
932      *
933      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
934      * transferred to `to`.
935      * - When `from` is zero, `tokenId` will be minted for `to`.
936      * - When `to` is zero, ``from``'s `tokenId` will be burned.
937      * - `from` and `to` are never both zero.
938      *
939      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
940      */
941     function _beforeTokenTransfer(
942         address from,
943         address to,
944         uint256 tokenId
945     ) internal virtual {}
946 }
947 
948 
949 
950 
951 /**
952  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
953  * @dev See https://eips.ethereum.org/EIPS/eip-721
954  */
955 interface IERC721Enumerable is IERC721 {
956     /**
957      * @dev Returns the total amount of tokens stored by the contract.
958      */
959     function totalSupply() external view returns (uint256);
960 
961     /**
962      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
963      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
964      */
965     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
966 
967     /**
968      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
969      * Use along with {totalSupply} to enumerate all tokens.
970      */
971     function tokenByIndex(uint256 index) external view returns (uint256);
972 }
973 
974 
975 
976 
977 
978 /**
979  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
980  * enumerability of all the token ids in the contract as well as all token ids owned by each
981  * account.
982  */
983 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
984     // Mapping from owner to list of owned token IDs
985     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
986 
987     // Mapping from token ID to index of the owner tokens list
988     mapping(uint256 => uint256) private _ownedTokensIndex;
989 
990     // Array with all token ids, used for enumeration
991     uint256[] private _allTokens;
992 
993     // Mapping from token id to position in the allTokens array
994     mapping(uint256 => uint256) private _allTokensIndex;
995 
996     /**
997      * @dev See {IERC165-supportsInterface}.
998      */
999     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1000         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1005      */
1006     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1007         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1008         return _ownedTokens[owner][index];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Enumerable-totalSupply}.
1013      */
1014     function totalSupply() public view virtual override returns (uint256) {
1015         return _allTokens.length;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-tokenByIndex}.
1020      */
1021     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1022         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1023         return _allTokens[index];
1024     }
1025 
1026     /**
1027      * @dev Hook that is called before any token transfer. This includes minting
1028      * and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1033      * transferred to `to`.
1034      * - When `from` is zero, `tokenId` will be minted for `to`.
1035      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1036      * - `from` cannot be the zero address.
1037      * - `to` cannot be the zero address.
1038      *
1039      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1040      */
1041     function _beforeTokenTransfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) internal virtual override {
1046         super._beforeTokenTransfer(from, to, tokenId);
1047 
1048         if (from == address(0)) {
1049             _addTokenToAllTokensEnumeration(tokenId);
1050         } else if (from != to) {
1051             _removeTokenFromOwnerEnumeration(from, tokenId);
1052         }
1053         if (to == address(0)) {
1054             _removeTokenFromAllTokensEnumeration(tokenId);
1055         } else if (to != from) {
1056             _addTokenToOwnerEnumeration(to, tokenId);
1057         }
1058     }
1059 
1060     /**
1061      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1062      * @param to address representing the new owner of the given token ID
1063      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1064      */
1065     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1066         uint256 length = ERC721.balanceOf(to);
1067         _ownedTokens[to][length] = tokenId;
1068         _ownedTokensIndex[tokenId] = length;
1069     }
1070 
1071     /**
1072      * @dev Private function to add a token to this extension's token tracking data structures.
1073      * @param tokenId uint256 ID of the token to be added to the tokens list
1074      */
1075     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1076         _allTokensIndex[tokenId] = _allTokens.length;
1077         _allTokens.push(tokenId);
1078     }
1079 
1080     /**
1081      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1082      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1083      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1084      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1085      * @param from address representing the previous owner of the given token ID
1086      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1087      */
1088     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1089         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1090         // then delete the last slot (swap and pop).
1091 
1092         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1093         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1094 
1095         // When the token to delete is the last token, the swap operation is unnecessary
1096         if (tokenIndex != lastTokenIndex) {
1097             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1098 
1099             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1100             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1101         }
1102 
1103         // This also deletes the contents at the last position of the array
1104         delete _ownedTokensIndex[tokenId];
1105         delete _ownedTokens[from][lastTokenIndex];
1106     }
1107 
1108     /**
1109      * @dev Private function to remove a token from this extension's token tracking data structures.
1110      * This has O(1) time complexity, but alters the order of the _allTokens array.
1111      * @param tokenId uint256 ID of the token to be removed from the tokens list
1112      */
1113     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1114         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1115         // then delete the last slot (swap and pop).
1116 
1117         uint256 lastTokenIndex = _allTokens.length - 1;
1118         uint256 tokenIndex = _allTokensIndex[tokenId];
1119 
1120         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1121         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1122         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1123         uint256 lastTokenId = _allTokens[lastTokenIndex];
1124 
1125         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1126         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1127 
1128         // This also deletes the contents at the last position of the array
1129         delete _allTokensIndex[tokenId];
1130         _allTokens.pop();
1131     }
1132 }
1133 
1134 
1135 /**
1136  * @dev Contract module which provides a basic access control mechanism, where
1137  * there is an account (an owner) that can be granted exclusive access to
1138  * specific functions.
1139  *
1140  * By default, the owner account will be the one that deploys the contract. This
1141  * can later be changed with {transferOwnership}.
1142  *
1143  * This module is used through inheritance. It will make available the modifier
1144  * `onlyOwner`, which can be applied to your functions to restrict their use to
1145  * the owner.
1146  */
1147 abstract contract Ownable is Context {
1148     address private _owner;
1149 
1150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1151 
1152     /**
1153      * @dev Initializes the contract setting the deployer as the initial owner.
1154      */
1155     constructor() {
1156         _setOwner(_msgSender());
1157     }
1158 
1159     /**
1160      * @dev Returns the address of the current owner.
1161      */
1162     function owner() public view virtual returns (address) {
1163         return _owner;
1164     }
1165 
1166     /**
1167      * @dev Throws if called by any account other than the owner.
1168      */
1169     modifier onlyOwner() {
1170         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1171         _;
1172     }
1173 
1174     /**
1175      * @dev Leaves the contract without owner. It will not be possible to call
1176      * `onlyOwner` functions anymore. Can only be called by the current owner.
1177      *
1178      * NOTE: Renouncing ownership will leave the contract without an owner,
1179      * thereby removing any functionality that is only available to the owner.
1180      */
1181     function renounceOwnership() public virtual onlyOwner {
1182         _setOwner(address(0));
1183     }
1184 
1185     /**
1186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1187      * Can only be called by the current owner.
1188      */
1189     function transferOwnership(address newOwner) public virtual onlyOwner {
1190         require(newOwner != address(0), "Ownable: new owner is the zero address");
1191         _setOwner(newOwner);
1192     }
1193 
1194     function _setOwner(address newOwner) private {
1195         address oldOwner = _owner;
1196         _owner = newOwner;
1197         emit OwnershipTransferred(oldOwner, newOwner);
1198     }
1199 }
1200 
1201 
1202 
1203 
1204 contract KARMA is ERC721Enumerable, Ownable {
1205 
1206     using Strings for uint256;
1207 
1208     string _baseTokenURI;
1209     uint256 public _reserved = 555;
1210     uint256 private _price = 0.0555 ether;
1211     bool public _paused = true;
1212 
1213     // withdraw addresses
1214     address t1 = 0xeed0f861c97a181Cb1f91e39C500652e08e87955;
1215 
1216 
1217     constructor(string memory baseURI) ERC721("Karma Collective", "KARMA")  {
1218         setBaseURI(baseURI);
1219 
1220     }
1221 
1222     function mint(uint256 num) public payable {
1223         uint256 supply = totalSupply();
1224         require( !_paused,                            "Sale paused" );
1225         require( num < 21,                            "You can mint a maximum of 20" );
1226         require(balanceOf(msg.sender) < 101, "Too many tokens owned to mint more");
1227         require( supply + num < 556 - _reserved,     "Exceeds maximum supply" );
1228         require( msg.value >= _price * num,           "Ether sent is not correct" );
1229 
1230         for(uint256 i; i < num; i++){
1231             _safeMint( msg.sender, supply + i );
1232         }
1233     }
1234 
1235     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1236         uint256 tokenCount = balanceOf(_owner);
1237 
1238         uint256[] memory tokensId = new uint256[](tokenCount);
1239         for(uint256 i; i < tokenCount; i++){
1240             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1241         }
1242         return tokensId;
1243     }
1244 
1245     // Just in case Eth does some crazy stuff
1246     function setPrice(uint256 _newPrice) public onlyOwner() {
1247         _price = _newPrice;
1248     }
1249 
1250     function _baseURI() internal view virtual override returns (string memory) {
1251         return _baseTokenURI;
1252     }
1253 
1254     function setBaseURI(string memory baseURI) public onlyOwner {
1255         _baseTokenURI = baseURI;
1256     }
1257 
1258     function getPrice() public view returns (uint256){
1259         return _price;
1260     }
1261 
1262     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1263         require( _amount <= _reserved, "Exceeds reserved supply" );
1264 
1265         uint256 supply = totalSupply();
1266         for(uint256 i; i < _amount; i++){
1267             _safeMint( _to, supply + i );
1268         }
1269 
1270         _reserved -= _amount;
1271     }
1272 
1273     function pause(bool val) public onlyOwner {
1274         _paused = val;
1275     }
1276     
1277    function setReserved(uint256 _newReserved) public onlyOwner {
1278         _reserved = _newReserved;
1279     }
1280     
1281 
1282     function withdrawAll() public payable onlyOwner {
1283         uint256 _each = address(this).balance;
1284         require(payable(t1).send(_each));
1285     }
1286 }