1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
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
188 
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Metadata is IERC721 {
194     /**
195      * @dev Returns the token collection name.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the token collection symbol.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
206      */
207     function tokenURI(uint256 tokenId) external view returns (string memory);
208 }
209 
210 
211 /**
212  * @dev Collection of functions related to the address type
213  */
214 library Address {
215     /**
216      * @dev Returns true if `account` is a contract.
217      *
218      * [IMPORTANT]
219      * ====
220      * It is unsafe to assume that an address for which this function returns
221      * false is an externally-owned account (EOA) and not a contract.
222      *
223      * Among others, `isContract` will return false for the following
224      * types of addresses:
225      *
226      *  - an externally-owned account
227      *  - a contract in construction
228      *  - an address where a contract will be created
229      *  - an address where a contract lived, but was destroyed
230      * ====
231      */
232     function isContract(address account) internal view returns (bool) {
233         // This method relies on extcodesize, which returns 0 for contracts in
234         // construction, since the code is only stored at the end of the
235         // constructor execution.
236 
237         uint256 size;
238         assembly {
239             size := extcodesize(account)
240         }
241         return size > 0;
242     }
243 
244     /**
245      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
246      * `recipient`, forwarding all available gas and reverting on errors.
247      *
248      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
249      * of certain opcodes, possibly making contracts go over the 2300 gas limit
250      * imposed by `transfer`, making them unable to receive funds via
251      * `transfer`. {sendValue} removes this limitation.
252      *
253      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
254      *
255      * IMPORTANT: because control is transferred to `recipient`, care must be
256      * taken to not create reentrancy vulnerabilities. Consider using
257      * {ReentrancyGuard} or the
258      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
259      */
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         (bool success, ) = recipient.call{value: amount}("");
264         require(success, "Address: unable to send value, recipient may have reverted");
265     }
266 
267     /**
268      * @dev Performs a Solidity function call using a low level `call`. A
269      * plain `call` is an unsafe replacement for a function call: use this
270      * function instead.
271      *
272      * If `target` reverts with a revert reason, it is bubbled up by this
273      * function (like regular Solidity function calls).
274      *
275      * Returns the raw returned data. To convert to the expected return value,
276      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
277      *
278      * Requirements:
279      *
280      * - `target` must be a contract.
281      * - calling `target` with `data` must not revert.
282      *
283      * _Available since v3.1._
284      */
285     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
286         return functionCall(target, data, "Address: low-level call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
291      * `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, 0, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but also transferring `value` wei to `target`.
306      *
307      * Requirements:
308      *
309      * - the calling contract must have an ETH balance of at least `value`.
310      * - the called Solidity function must be `payable`.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
324      * with `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(
329         address target,
330         bytes memory data,
331         uint256 value,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         require(address(this).balance >= value, "Address: insufficient balance for call");
335         require(isContract(target), "Address: call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.call{value: value}(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
348         return functionStaticCall(target, data, "Address: low-level static call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal view returns (bytes memory) {
362         require(isContract(target), "Address: static call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.staticcall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a delegate call.
371      *
372      * _Available since v3.4._
373      */
374     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(isContract(target), "Address: delegate call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.delegatecall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
397      * revert reason using the provided one.
398      *
399      * _Available since v4.3._
400      */
401     function verifyCallResult(
402         bool success,
403         bytes memory returndata,
404         string memory errorMessage
405     ) internal pure returns (bytes memory) {
406         if (success) {
407             return returndata;
408         } else {
409             // Look for revert reason and bubble it up if present
410             if (returndata.length > 0) {
411                 // The easiest way to bubble the revert reason is using memory via assembly
412 
413                 assembly {
414                     let returndata_size := mload(returndata)
415                     revert(add(32, returndata), returndata_size)
416                 }
417             } else {
418                 revert(errorMessage);
419             }
420         }
421     }
422 }
423 
424 
425 /**
426  * @dev Provides information about the current execution context, including the
427  * sender of the transaction and its data. While these are generally available
428  * via msg.sender and msg.data, they should not be accessed in such a direct
429  * manner, since when dealing with meta-transactions the account sending and
430  * paying for execution may not be the actual sender (as far as an application
431  * is concerned).
432  *
433  * This contract is only required for intermediate, library-like contracts.
434  */
435 abstract contract Context {
436     function _msgSender() internal view virtual returns (address) {
437         return msg.sender;
438     }
439 
440     function _msgData() internal view virtual returns (bytes calldata) {
441         return msg.data;
442     }
443 }
444 
445 
446 /**
447  * @dev String operations.
448  */
449 library Strings {
450     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
454      */
455     function toString(uint256 value) internal pure returns (string memory) {
456         // Inspired by OraclizeAPI's implementation - MIT licence
457         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
458 
459         if (value == 0) {
460             return "0";
461         }
462         uint256 temp = value;
463         uint256 digits;
464         while (temp != 0) {
465             digits++;
466             temp /= 10;
467         }
468         bytes memory buffer = new bytes(digits);
469         while (value != 0) {
470             digits -= 1;
471             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
472             value /= 10;
473         }
474         return string(buffer);
475     }
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
479      */
480     function toHexString(uint256 value) internal pure returns (string memory) {
481         if (value == 0) {
482             return "0x00";
483         }
484         uint256 temp = value;
485         uint256 length = 0;
486         while (temp != 0) {
487             length++;
488             temp >>= 8;
489         }
490         return toHexString(value, length);
491     }
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
495      */
496     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
497         bytes memory buffer = new bytes(2 * length + 2);
498         buffer[0] = "0";
499         buffer[1] = "x";
500         for (uint256 i = 2 * length + 1; i > 1; --i) {
501             buffer[i] = _HEX_SYMBOLS[value & 0xf];
502             value >>= 4;
503         }
504         require(value == 0, "Strings: hex length insufficient");
505         return string(buffer);
506     }
507 }
508 
509 
510 /**
511  * @dev Implementation of the {IERC165} interface.
512  *
513  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
514  * for the additional interface id that will be supported. For example:
515  *
516  * ```solidity
517  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
519  * }
520  * ```
521  *
522  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
523  */
524 abstract contract ERC165 is IERC165 {
525     /**
526      * @dev See {IERC165-supportsInterface}.
527      */
528     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529         return interfaceId == type(IERC165).interfaceId;
530     }
531 }
532 
533 
534 /**
535  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
536  * the Metadata extension, but not including the Enumerable extension, which is available separately as
537  * {ERC721Enumerable}.
538  */
539 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
540     using Address for address;
541     using Strings for uint256;
542 
543     // Token name
544     string private _name;
545 
546     // Token symbol
547     string private _symbol;
548 
549     // Mapping from token ID to owner address
550     mapping(uint256 => address) private _owners;
551 
552     // Mapping owner address to token count
553     mapping(address => uint256) private _balances;
554 
555     // Mapping from token ID to approved address
556     mapping(uint256 => address) private _tokenApprovals;
557 
558     // Mapping from owner to operator approvals
559     mapping(address => mapping(address => bool)) private _operatorApprovals;
560 
561     /**
562      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
563      */
564     constructor(string memory name_, string memory symbol_) {
565         _name = name_;
566         _symbol = symbol_;
567     }
568 
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
573         return
574             interfaceId == type(IERC721).interfaceId ||
575             interfaceId == type(IERC721Metadata).interfaceId ||
576             super.supportsInterface(interfaceId);
577     }
578 
579     /**
580      * @dev See {IERC721-balanceOf}.
581      */
582     function balanceOf(address owner) public view virtual override returns (uint256) {
583         require(owner != address(0), "ERC721: balance query for the zero address");
584         return _balances[owner];
585     }
586 
587     /**
588      * @dev See {IERC721-ownerOf}.
589      */
590     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
591         address owner = _owners[tokenId];
592         require(owner != address(0), "ERC721: owner query for nonexistent token");
593         return owner;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-name}.
598      */
599     function name() public view virtual override returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-symbol}.
605      */
606     function symbol() public view virtual override returns (string memory) {
607         return _symbol;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-tokenURI}.
612      */
613     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
614         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
615 
616         string memory baseURI = _baseURI();
617         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
618     }
619 
620     /**
621      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
622      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
623      * by default, can be overriden in child contracts.
624      */
625     function _baseURI() internal view virtual returns (string memory) {
626         return "";
627     }
628 
629     /**
630      * @dev See {IERC721-approve}.
631      */
632     function approve(address to, uint256 tokenId) public virtual override {
633         address owner = ERC721.ownerOf(tokenId);
634         require(to != owner, "ERC721: approval to current owner");
635 
636         require(
637             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
638             "ERC721: approve caller is not owner nor approved for all"
639         );
640 
641         _approve(to, tokenId);
642     }
643 
644     /**
645      * @dev See {IERC721-getApproved}.
646      */
647     function getApproved(uint256 tokenId) public view virtual override returns (address) {
648         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
649 
650         return _tokenApprovals[tokenId];
651     }
652 
653     /**
654      * @dev See {IERC721-setApprovalForAll}.
655      */
656     function setApprovalForAll(address operator, bool approved) public virtual override {
657         require(operator != _msgSender(), "ERC721: approve to caller");
658 
659         _operatorApprovals[_msgSender()][operator] = approved;
660         emit ApprovalForAll(_msgSender(), operator, approved);
661     }
662 
663     /**
664      * @dev See {IERC721-isApprovedForAll}.
665      */
666     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
667         return _operatorApprovals[owner][operator];
668     }
669 
670     /**
671      * @dev See {IERC721-transferFrom}.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) public virtual override {
678         //solhint-disable-next-line max-line-length
679         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
680 
681         _transfer(from, to, tokenId);
682     }
683 
684     /**
685      * @dev See {IERC721-safeTransferFrom}.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) public virtual override {
692         safeTransferFrom(from, to, tokenId, "");
693     }
694 
695     /**
696      * @dev See {IERC721-safeTransferFrom}.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId,
702         bytes memory _data
703     ) public virtual override {
704         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
705         _safeTransfer(from, to, tokenId, _data);
706     }
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
710      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
711      *
712      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
713      *
714      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
715      * implement alternative mechanisms to perform token transfer, such as signature-based.
716      *
717      * Requirements:
718      *
719      * - `from` cannot be the zero address.
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must exist and be owned by `from`.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function _safeTransfer(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) internal virtual {
732         _transfer(from, to, tokenId);
733         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
734     }
735 
736     /**
737      * @dev Returns whether `tokenId` exists.
738      *
739      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
740      *
741      * Tokens start existing when they are minted (`_mint`),
742      * and stop existing when they are burned (`_burn`).
743      */
744     function _exists(uint256 tokenId) internal view virtual returns (bool) {
745         return _owners[tokenId] != address(0);
746     }
747 
748     /**
749      * @dev Returns whether `spender` is allowed to manage `tokenId`.
750      *
751      * Requirements:
752      *
753      * - `tokenId` must exist.
754      */
755     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
756         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
757         address owner = ERC721.ownerOf(tokenId);
758         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
759     }
760 
761     /**
762      * @dev Safely mints `tokenId` and transfers it to `to`.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must not exist.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _safeMint(address to, uint256 tokenId) internal virtual {
772         _safeMint(to, tokenId, "");
773     }
774 
775     /**
776      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
777      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
778      */
779     function _safeMint(
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _mint(to, tokenId);
785         require(
786             _checkOnERC721Received(address(0), to, tokenId, _data),
787             "ERC721: transfer to non ERC721Receiver implementer"
788         );
789     }
790 
791     /**
792      * @dev Mints `tokenId` and transfers it to `to`.
793      *
794      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
795      *
796      * Requirements:
797      *
798      * - `tokenId` must not exist.
799      * - `to` cannot be the zero address.
800      *
801      * Emits a {Transfer} event.
802      */
803     function _mint(address to, uint256 tokenId) internal virtual {
804         require(to != address(0), "ERC721: mint to the zero address");
805         require(!_exists(tokenId), "ERC721: token already minted");
806 
807         _beforeTokenTransfer(address(0), to, tokenId);
808 
809         _balances[to] += 1;
810         _owners[tokenId] = to;
811 
812         emit Transfer(address(0), to, tokenId);
813     }
814 
815     /**
816      * @dev Destroys `tokenId`.
817      * The approval is cleared when the token is burned.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _burn(uint256 tokenId) internal virtual {
826         address owner = ERC721.ownerOf(tokenId);
827 
828         _beforeTokenTransfer(owner, address(0), tokenId);
829 
830         // Clear approvals
831         _approve(address(0), tokenId);
832 
833         _balances[owner] -= 1;
834         delete _owners[tokenId];
835 
836         emit Transfer(owner, address(0), tokenId);
837     }
838 
839     /**
840      * @dev Transfers `tokenId` from `from` to `to`.
841      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
842      *
843      * Requirements:
844      *
845      * - `to` cannot be the zero address.
846      * - `tokenId` token must be owned by `from`.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _transfer(
851         address from,
852         address to,
853         uint256 tokenId
854     ) internal virtual {
855         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
856         require(to != address(0), "ERC721: transfer to the zero address");
857 
858         _beforeTokenTransfer(from, to, tokenId);
859 
860         // Clear approvals from the previous owner
861         _approve(address(0), tokenId);
862 
863         _balances[from] -= 1;
864         _balances[to] += 1;
865         _owners[tokenId] = to;
866 
867         emit Transfer(from, to, tokenId);
868     }
869 
870     /**
871      * @dev Approve `to` to operate on `tokenId`
872      *
873      * Emits a {Approval} event.
874      */
875     function _approve(address to, uint256 tokenId) internal virtual {
876         _tokenApprovals[tokenId] = to;
877         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
878     }
879 
880     /**
881      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
882      * The call is not executed if the target address is not a contract.
883      *
884      * @param from address representing the previous owner of the given token ID
885      * @param to target address that will receive the tokens
886      * @param tokenId uint256 ID of the token to be transferred
887      * @param _data bytes optional data to send along with the call
888      * @return bool whether the call correctly returned the expected magic value
889      */
890     function _checkOnERC721Received(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) private returns (bool) {
896         if (to.isContract()) {
897             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
898                 return retval == IERC721Receiver.onERC721Received.selector;
899             } catch (bytes memory reason) {
900                 if (reason.length == 0) {
901                     revert("ERC721: transfer to non ERC721Receiver implementer");
902                 } else {
903                     assembly {
904                         revert(add(32, reason), mload(reason))
905                     }
906                 }
907             }
908         } else {
909             return true;
910         }
911     }
912 
913     /**
914      * @dev Hook that is called before any token transfer. This includes minting
915      * and burning.
916      *
917      * Calling conditions:
918      *
919      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
920      * transferred to `to`.
921      * - When `from` is zero, `tokenId` will be minted for `to`.
922      * - When `to` is zero, ``from``'s `tokenId` will be burned.
923      * - `from` and `to` are never both zero.
924      *
925      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
926      */
927     function _beforeTokenTransfer(
928         address from,
929         address to,
930         uint256 tokenId
931     ) internal virtual {}
932 }
933 
934 
935 /**
936  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
937  * @dev See https://eips.ethereum.org/EIPS/eip-721
938  */
939 interface IERC721Enumerable is IERC721 {
940     /**
941      * @dev Returns the total amount of tokens stored by the contract.
942      */
943     function totalSupply() external view returns (uint256);
944 
945     /**
946      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
947      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
948      */
949     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
950 
951     /**
952      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
953      * Use along with {totalSupply} to enumerate all tokens.
954      */
955     function tokenByIndex(uint256 index) external view returns (uint256);
956 }
957 
958 
959 /**
960  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
961  * enumerability of all the token ids in the contract as well as all token ids owned by each
962  * account.
963  */
964 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
965     // Mapping from owner to list of owned token IDs
966     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
967 
968     // Mapping from token ID to index of the owner tokens list
969     mapping(uint256 => uint256) private _ownedTokensIndex;
970 
971     // Array with all token ids, used for enumeration
972     uint256[] private _allTokens;
973 
974     // Mapping from token id to position in the allTokens array
975     mapping(uint256 => uint256) private _allTokensIndex;
976 
977     /**
978      * @dev See {IERC165-supportsInterface}.
979      */
980     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
981         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
982     }
983 
984     /**
985      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
986      */
987     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
988         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
989         return _ownedTokens[owner][index];
990     }
991 
992     /**
993      * @dev See {IERC721Enumerable-totalSupply}.
994      */
995     function totalSupply() public view virtual override returns (uint256) {
996         return _allTokens.length;
997     }
998 
999     /**
1000      * @dev See {IERC721Enumerable-tokenByIndex}.
1001      */
1002     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1003         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1004         return _allTokens[index];
1005     }
1006 
1007     /**
1008      * @dev Hook that is called before any token transfer. This includes minting
1009      * and burning.
1010      *
1011      * Calling conditions:
1012      *
1013      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1014      * transferred to `to`.
1015      * - When `from` is zero, `tokenId` will be minted for `to`.
1016      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1017      * - `from` cannot be the zero address.
1018      * - `to` cannot be the zero address.
1019      *
1020      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1021      */
1022     function _beforeTokenTransfer(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) internal virtual override {
1027         super._beforeTokenTransfer(from, to, tokenId);
1028 
1029         if (from == address(0)) {
1030             _addTokenToAllTokensEnumeration(tokenId);
1031         } else if (from != to) {
1032             _removeTokenFromOwnerEnumeration(from, tokenId);
1033         }
1034         if (to == address(0)) {
1035             _removeTokenFromAllTokensEnumeration(tokenId);
1036         } else if (to != from) {
1037             _addTokenToOwnerEnumeration(to, tokenId);
1038         }
1039     }
1040 
1041     /**
1042      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1043      * @param to address representing the new owner of the given token ID
1044      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1045      */
1046     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1047         uint256 length = ERC721.balanceOf(to);
1048         _ownedTokens[to][length] = tokenId;
1049         _ownedTokensIndex[tokenId] = length;
1050     }
1051 
1052     /**
1053      * @dev Private function to add a token to this extension's token tracking data structures.
1054      * @param tokenId uint256 ID of the token to be added to the tokens list
1055      */
1056     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1057         _allTokensIndex[tokenId] = _allTokens.length;
1058         _allTokens.push(tokenId);
1059     }
1060 
1061     /**
1062      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1063      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1064      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1065      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1066      * @param from address representing the previous owner of the given token ID
1067      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1068      */
1069     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1070         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1071         // then delete the last slot (swap and pop).
1072 
1073         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1074         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1075 
1076         // When the token to delete is the last token, the swap operation is unnecessary
1077         if (tokenIndex != lastTokenIndex) {
1078             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1079 
1080             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1081             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1082         }
1083 
1084         // This also deletes the contents at the last position of the array
1085         delete _ownedTokensIndex[tokenId];
1086         delete _ownedTokens[from][lastTokenIndex];
1087     }
1088 
1089     /**
1090      * @dev Private function to remove a token from this extension's token tracking data structures.
1091      * This has O(1) time complexity, but alters the order of the _allTokens array.
1092      * @param tokenId uint256 ID of the token to be removed from the tokens list
1093      */
1094     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1095         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1096         // then delete the last slot (swap and pop).
1097 
1098         uint256 lastTokenIndex = _allTokens.length - 1;
1099         uint256 tokenIndex = _allTokensIndex[tokenId];
1100 
1101         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1102         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1103         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1104         uint256 lastTokenId = _allTokens[lastTokenIndex];
1105 
1106         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1107         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1108 
1109         // This also deletes the contents at the last position of the array
1110         delete _allTokensIndex[tokenId];
1111         _allTokens.pop();
1112     }
1113 }
1114 
1115 
1116 /**
1117  * @dev Contract module which provides a basic access control mechanism, where
1118  * there is an account (an owner) that can be granted exclusive access to
1119  * specific functions.
1120  *
1121  * By default, the owner account will be the one that deploys the contract. This
1122  * can later be changed with {transferOwnership}.
1123  *
1124  * This module is used through inheritance. It will make available the modifier
1125  * `onlyOwner`, which can be applied to your functions to restrict their use to
1126  * the owner.
1127  */
1128 abstract contract Ownable is Context {
1129     address private _owner;
1130 
1131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1132 
1133     /**
1134      * @dev Initializes the contract setting the deployer as the initial owner.
1135      */
1136     constructor() {
1137         _setOwner(_msgSender());
1138     }
1139 
1140     /**
1141      * @dev Returns the address of the current owner.
1142      */
1143     function owner() public view virtual returns (address) {
1144         return _owner;
1145     }
1146 
1147     /**
1148      * @dev Throws if called by any account other than the owner.
1149      */
1150     modifier onlyOwner() {
1151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1152         _;
1153     }
1154 
1155     /**
1156      * @dev Leaves the contract without owner. It will not be possible to call
1157      * `onlyOwner` functions anymore. Can only be called by the current owner.
1158      *
1159      * NOTE: Renouncing ownership will leave the contract without an owner,
1160      * thereby removing any functionality that is only available to the owner.
1161      */
1162     function renounceOwnership() public virtual onlyOwner {
1163         _setOwner(address(0));
1164     }
1165 
1166     /**
1167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1168      * Can only be called by the current owner.
1169      */
1170     function transferOwnership(address newOwner) public virtual onlyOwner {
1171         require(newOwner != address(0), "Ownable: new owner is the zero address");
1172         _setOwner(newOwner);
1173     }
1174 
1175     function _setOwner(address newOwner) private {
1176         address oldOwner = _owner;
1177         _owner = newOwner;
1178         emit OwnershipTransferred(oldOwner, newOwner);
1179     }
1180 }
1181 
1182 
1183 // CAUTION
1184 // This version of SafeMath should only be used with Solidity 0.8 or later,
1185 // because it relies on the compiler's built in overflow checks.
1186 /**
1187  * @dev Wrappers over Solidity's arithmetic operations.
1188  *
1189  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1190  * now has built in overflow checking.
1191  */
1192 library SafeMath {
1193     /**
1194      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1195      *
1196      * _Available since v3.4._
1197      */
1198     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1199         unchecked {
1200             uint256 c = a + b;
1201             if (c < a) return (false, 0);
1202             return (true, c);
1203         }
1204     }
1205 
1206     /**
1207      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1208      *
1209      * _Available since v3.4._
1210      */
1211     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1212         unchecked {
1213             if (b > a) return (false, 0);
1214             return (true, a - b);
1215         }
1216     }
1217 
1218     /**
1219      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1220      *
1221      * _Available since v3.4._
1222      */
1223     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1224         unchecked {
1225             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1226             // benefit is lost if 'b' is also tested.
1227             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1228             if (a == 0) return (true, 0);
1229             uint256 c = a * b;
1230             if (c / a != b) return (false, 0);
1231             return (true, c);
1232         }
1233     }
1234 
1235     /**
1236      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1237      *
1238      * _Available since v3.4._
1239      */
1240     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1241         unchecked {
1242             if (b == 0) return (false, 0);
1243             return (true, a / b);
1244         }
1245     }
1246 
1247     /**
1248      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1249      *
1250      * _Available since v3.4._
1251      */
1252     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1253         unchecked {
1254             if (b == 0) return (false, 0);
1255             return (true, a % b);
1256         }
1257     }
1258 
1259     /**
1260      * @dev Returns the addition of two unsigned integers, reverting on
1261      * overflow.
1262      *
1263      * Counterpart to Solidity's `+` operator.
1264      *
1265      * Requirements:
1266      *
1267      * - Addition cannot overflow.
1268      */
1269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1270         return a + b;
1271     }
1272 
1273     /**
1274      * @dev Returns the subtraction of two unsigned integers, reverting on
1275      * overflow (when the result is negative).
1276      *
1277      * Counterpart to Solidity's `-` operator.
1278      *
1279      * Requirements:
1280      *
1281      * - Subtraction cannot overflow.
1282      */
1283     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1284         return a - b;
1285     }
1286 
1287     /**
1288      * @dev Returns the multiplication of two unsigned integers, reverting on
1289      * overflow.
1290      *
1291      * Counterpart to Solidity's `*` operator.
1292      *
1293      * Requirements:
1294      *
1295      * - Multiplication cannot overflow.
1296      */
1297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1298         return a * b;
1299     }
1300 
1301     /**
1302      * @dev Returns the integer division of two unsigned integers, reverting on
1303      * division by zero. The result is rounded towards zero.
1304      *
1305      * Counterpart to Solidity's `/` operator.
1306      *
1307      * Requirements:
1308      *
1309      * - The divisor cannot be zero.
1310      */
1311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1312         return a / b;
1313     }
1314 
1315     /**
1316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1317      * reverting when dividing by zero.
1318      *
1319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1320      * opcode (which leaves remaining gas untouched) while Solidity uses an
1321      * invalid opcode to revert (consuming all remaining gas).
1322      *
1323      * Requirements:
1324      *
1325      * - The divisor cannot be zero.
1326      */
1327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1328         return a % b;
1329     }
1330 
1331     /**
1332      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1333      * overflow (when the result is negative).
1334      *
1335      * CAUTION: This function is deprecated because it requires allocating memory for the error
1336      * message unnecessarily. For custom revert reasons use {trySub}.
1337      *
1338      * Counterpart to Solidity's `-` operator.
1339      *
1340      * Requirements:
1341      *
1342      * - Subtraction cannot overflow.
1343      */
1344     function sub(
1345         uint256 a,
1346         uint256 b,
1347         string memory errorMessage
1348     ) internal pure returns (uint256) {
1349         unchecked {
1350             require(b <= a, errorMessage);
1351             return a - b;
1352         }
1353     }
1354 
1355     /**
1356      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1357      * division by zero. The result is rounded towards zero.
1358      *
1359      * Counterpart to Solidity's `/` operator. Note: this function uses a
1360      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1361      * uses an invalid opcode to revert (consuming all remaining gas).
1362      *
1363      * Requirements:
1364      *
1365      * - The divisor cannot be zero.
1366      */
1367     function div(
1368         uint256 a,
1369         uint256 b,
1370         string memory errorMessage
1371     ) internal pure returns (uint256) {
1372         unchecked {
1373             require(b > 0, errorMessage);
1374             return a / b;
1375         }
1376     }
1377 
1378     /**
1379      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1380      * reverting with custom message when dividing by zero.
1381      *
1382      * CAUTION: This function is deprecated because it requires allocating memory for the error
1383      * message unnecessarily. For custom revert reasons use {tryMod}.
1384      *
1385      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1386      * opcode (which leaves remaining gas untouched) while Solidity uses an
1387      * invalid opcode to revert (consuming all remaining gas).
1388      *
1389      * Requirements:
1390      *
1391      * - The divisor cannot be zero.
1392      */
1393     function mod(
1394         uint256 a,
1395         uint256 b,
1396         string memory errorMessage
1397     ) internal pure returns (uint256) {
1398         unchecked {
1399             require(b > 0, errorMessage);
1400             return a % b;
1401         }
1402     }
1403 }
1404 
1405 
1406 abstract contract ContextMixin {
1407     function msgSender()
1408         internal
1409         view
1410         returns (address payable sender)
1411     {
1412         if (msg.sender == address(this)) {
1413             bytes memory array = msg.data;
1414             uint256 index = msg.data.length;
1415             assembly {
1416                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1417                 sender := and(
1418                     mload(add(array, index)),
1419                     0xffffffffffffffffffffffffffffffffffffffff
1420                 )
1421             }
1422         } else {
1423             sender = payable(msg.sender);
1424         }
1425         return sender;
1426     }
1427 }
1428 
1429 contract Initializable {
1430     bool inited = false;
1431 
1432     modifier initializer() {
1433         require(!inited, "already inited");
1434         _;
1435         inited = true;
1436     }
1437 }
1438 
1439 contract EIP712Base is Initializable {
1440     struct EIP712Domain {
1441         string name;
1442         string version;
1443         address verifyingContract;
1444         bytes32 salt;
1445     }
1446 
1447     string constant public ERC712_VERSION = "1";
1448 
1449     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1450         bytes(
1451             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1452         )
1453     );
1454     bytes32 internal domainSeperator;
1455 
1456     // supposed to be called once while initializing.
1457     // one of the contracts that inherits this contract follows proxy pattern
1458     // so it is not possible to do this in a constructor
1459     function _initializeEIP712(
1460         string memory name
1461     )
1462         internal
1463         initializer
1464     {
1465         _setDomainSeperator(name);
1466     }
1467 
1468     function _setDomainSeperator(string memory name) internal {
1469         domainSeperator = keccak256(
1470             abi.encode(
1471                 EIP712_DOMAIN_TYPEHASH,
1472                 keccak256(bytes(name)),
1473                 keccak256(bytes(ERC712_VERSION)),
1474                 address(this),
1475                 bytes32(getChainId())
1476             )
1477         );
1478     }
1479 
1480     function getDomainSeperator() public view returns (bytes32) {
1481         return domainSeperator;
1482     }
1483 
1484     function getChainId() public view returns (uint256) {
1485         uint256 id;
1486         assembly {
1487             id := chainid()
1488         }
1489         return id;
1490     }
1491 
1492     /**
1493      * Accept message hash and returns hash message in EIP712 compatible form
1494      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1495      * https://eips.ethereum.org/EIPS/eip-712
1496      * "\\x19" makes the encoding deterministic
1497      * "\\x01" is the version byte to make it compatible to EIP-191
1498      */
1499     function toTypedMessageHash(bytes32 messageHash)
1500         internal
1501         view
1502         returns (bytes32)
1503     {
1504         return
1505             keccak256(
1506                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1507             );
1508     }
1509 }
1510 
1511 
1512 contract NativeMetaTransaction is EIP712Base {
1513     using SafeMath for uint256;
1514     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1515         bytes(
1516             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1517         )
1518     );
1519     event MetaTransactionExecuted(
1520         address userAddress,
1521         address payable relayerAddress,
1522         bytes functionSignature
1523     );
1524     mapping(address => uint256) nonces;
1525 
1526     /*
1527      * Meta transaction structure.
1528      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1529      * He should call the desired function directly in that case.
1530      */
1531     struct MetaTransaction {
1532         uint256 nonce;
1533         address from;
1534         bytes functionSignature;
1535     }
1536 
1537     function executeMetaTransaction(
1538         address userAddress,
1539         bytes memory functionSignature,
1540         bytes32 sigR,
1541         bytes32 sigS,
1542         uint8 sigV
1543     ) public payable returns (bytes memory) {
1544         MetaTransaction memory metaTx = MetaTransaction({
1545             nonce: nonces[userAddress],
1546             from: userAddress,
1547             functionSignature: functionSignature
1548         });
1549 
1550         require(
1551             verify(userAddress, metaTx, sigR, sigS, sigV),
1552             "Signer and signature do not match"
1553         );
1554 
1555         // increase nonce for user (to avoid re-use)
1556         nonces[userAddress] = nonces[userAddress].add(1);
1557 
1558         emit MetaTransactionExecuted(
1559             userAddress,
1560             payable(msg.sender),
1561             functionSignature
1562         );
1563 
1564         // Append userAddress and relayer address at the end to extract it from calling context
1565         (bool success, bytes memory returnData) = address(this).call(
1566             abi.encodePacked(functionSignature, userAddress)
1567         );
1568         require(success, "Function call not successful");
1569 
1570         return returnData;
1571     }
1572 
1573     function hashMetaTransaction(MetaTransaction memory metaTx)
1574         internal
1575         pure
1576         returns (bytes32)
1577     {
1578         return
1579             keccak256(
1580                 abi.encode(
1581                     META_TRANSACTION_TYPEHASH,
1582                     metaTx.nonce,
1583                     metaTx.from,
1584                     keccak256(metaTx.functionSignature)
1585                 )
1586             );
1587     }
1588 
1589     function getNonce(address user) public view returns (uint256 nonce) {
1590         nonce = nonces[user];
1591     }
1592 
1593     function verify(
1594         address signer,
1595         MetaTransaction memory metaTx,
1596         bytes32 sigR,
1597         bytes32 sigS,
1598         uint8 sigV
1599     ) internal view returns (bool) {
1600         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1601         return
1602             signer ==
1603             ecrecover(
1604                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1605                 sigV,
1606                 sigR,
1607                 sigS
1608             );
1609     }
1610 }
1611 
1612 
1613 contract OwnableDelegateProxy {}
1614 
1615 contract ProxyRegistry {
1616     mapping(address => OwnableDelegateProxy) public proxies;
1617 }
1618 
1619 interface AAA is IERC721Enumerable { }
1620 
1621 /**
1622  * @title MnemosNFT
1623  * Based on ERC721Tradable - ERC721 contract that whitelists a trading address,
1624  * and has mint, and limited claim, functionality.
1625  */
1626 contract MnemosNFT is
1627     ContextMixin,
1628     ERC721,
1629     ERC721Enumerable,
1630     NativeMetaTransaction,
1631     Ownable
1632 {
1633     using SafeMath for uint256;
1634 
1635     address immutable proxyRegistryAddress;
1636     uint256 public immutable NFTLimit = 999;
1637     uint256 public immutable redemptionBuyLimit = 261;
1638     uint256 public immutable PRICE = 0.08 ether;
1639     uint256 public boughtCount = 0;
1640     uint256 private _currentTokenId = 0;
1641     address payable private payee;
1642 
1643     uint256 immutable public redemptionStartTimestamp = 1638831600; //Mon 6th Dec 2021, 18:00 GMT-5
1644     uint256 immutable public redemptionEndTimestamp = 1639436400; //Mon 13th Dec 2021, 18:00 GMT-5
1645 
1646     AAA[] aaa721s; //recognised
1647     AAA[] aaa721sNonEnumerable; //non-enumerable
1648 
1649     //recognised AAA contract, to id, to true/false if redeemed
1650     mapping(AAA => mapping(uint256 => bool)) public isRedeemed;
1651 
1652 
1653     struct TokenSet {
1654         address aaaAddress;
1655         uint256[] tokenIds;
1656         bool[] redeemed;
1657     }
1658 
1659     constructor(
1660         AAA[] memory aaaAddresses,
1661         AAA[] memory aaaAddressesNonEnumerable,
1662         string memory _name,
1663         string memory _symbol,
1664         address _proxyRegistryAddress
1665     ) ERC721(_name, _symbol) {
1666         proxyRegistryAddress = _proxyRegistryAddress;
1667         _initializeEIP712(_name);
1668         aaa721s = aaaAddresses;
1669         aaa721sNonEnumerable = aaaAddressesNonEnumerable;
1670         payee = payable(_msgSender());
1671     }
1672 
1673     function isDuringRedemption() public view returns (bool) {
1674         return (
1675             (block.timestamp >= redemptionStartTimestamp) &&
1676             (block.timestamp < redemptionEndTimestamp)
1677         );
1678     }
1679 
1680     /**
1681      * Convenience function to return all AAA tokens+ids of an address,
1682      * including if already redeemed.
1683      * NB: cannot check non-enumerable NFTs
1684      */
1685     function tokensForAddress(
1686         address holder
1687     ) public view returns (
1688         TokenSet[] memory
1689     ) {
1690         TokenSet[] memory tokensOwned = new TokenSet[](aaa721s.length);
1691         for (uint256 i=0; i < aaa721s.length; i++) {
1692             AAA aaa = aaa721s[i];
1693             uint256 aaaBalance = aaa.balanceOf(holder);
1694             TokenSet memory tokenSet;
1695             tokenSet.aaaAddress = address(aaa);
1696             tokenSet.tokenIds = new uint256[](aaaBalance);
1697             tokenSet.redeemed = new bool[](aaaBalance);
1698             for (uint256 j=0; j<aaaBalance; j++) {
1699                 uint256 tokenId = aaa.tokenOfOwnerByIndex(
1700                     holder,
1701                     j
1702                 );
1703                 tokenSet.tokenIds[j] = tokenId;
1704                 tokenSet.redeemed[j] = isRedeemed[aaa][tokenId];
1705             }
1706             tokensOwned[i] = tokenSet;
1707         }
1708         return tokensOwned;
1709     }
1710 
1711     /**
1712      * @return redeemer the address of who can successfully redeem this token.
1713      * @dev fails if given contract is not a recognised AAA NFT, or
1714      * token doesn't exist.
1715      * otherwise returns 0 if already redeemed
1716      */
1717     function tokenRedeemer(
1718         AAA tokenContract,
1719         uint256 tokenId
1720     ) public view returns (address redeemer) {
1721         bool isAAA = false;
1722         for (uint256 i=0; i<aaa721s.length; i++) {
1723             if (aaa721s[i] == tokenContract) {
1724                 isAAA = true;
1725                 break;
1726             }
1727         }
1728         for (uint256 i=0; i<aaa721sNonEnumerable.length; i++) {
1729             if (aaa721sNonEnumerable[i] == tokenContract) {
1730                 isAAA = true;
1731                 break;
1732             }
1733         }
1734         require(isAAA, "MnemosNFT: given token not recognised");
1735         redeemer = address(0);
1736         if (isRedeemed[tokenContract][tokenId] == false) {
1737             redeemer = tokenContract.ownerOf(tokenId);
1738         }
1739     }
1740 
1741     /**
1742      * 
1743      */
1744     function redeem(
1745         AAA[] calldata tokenContracts,
1746         uint256[] calldata tokenIds
1747     ) public {
1748         require(isDuringRedemption(), "MnemosNFT: not during redemption period");
1749 
1750         uint256 length = tokenContracts.length;
1751         require(tokenIds.length == length, "MnemosNFT: array length mismatch");
1752 
1753         uint256 redeemed = 0;
1754 
1755         for (uint256 i=0; i<length; i++) {
1756             AAA tokenContract = tokenContracts[i];
1757             uint256 tokenId = tokenIds[i];
1758             if (tokenRedeemer(tokenContract, tokenId) == _msgSender()) {
1759                 redeemed++;
1760                 isRedeemed[tokenContract][tokenId] = true;
1761             }
1762         }
1763 
1764         // mint tokens to redeemer
1765         mintAmount(_msgSender(), redeemed);
1766     }
1767 
1768     /**
1769      * 
1770      */
1771     function buy(uint256 amountToBuy) public payable {
1772         require(block.timestamp >= redemptionStartTimestamp, "MnemosNFT: Sale not started");
1773         require(amountToBuy < NFTLimit, "MnemosNFT: can only try buy up to supply");
1774         if (isDuringRedemption()) {
1775             require(
1776                 boughtCount < redemptionBuyLimit,
1777                 "MnemosNFT: redemption allocation exhausted"
1778             );
1779             require(
1780                 boughtCount + amountToBuy <= redemptionBuyLimit,
1781                 "MnemosNFT: supply limited during redemption"
1782             );
1783         }
1784         uint256 cost = amountToBuy * PRICE;
1785         require(msg.value == cost, "MnemosNFT: incorrect ethers for purchase");
1786         require(payee.send(cost), "MnemosNFT: payee must take payment");
1787 
1788         // mint tokens to buyer
1789         mintAmount(_msgSender(), amountToBuy);
1790         // update bought count
1791         boughtCount += amountToBuy;
1792     }
1793 
1794     function setPayeeAddress(
1795         address payable newPayee
1796     ) public onlyOwner {
1797         payee = newPayee;
1798     }
1799 
1800     function mintAmount(
1801         address _to,
1802         uint256 _amount
1803     ) private {
1804         require(
1805             _currentTokenId < NFTLimit,
1806             "MnemosNFT: all tokens minted"
1807         );
1808         require (
1809             _currentTokenId + _amount <= NFTLimit,
1810             "MnemosNFT: can only mint to limit"
1811         );
1812 
1813         for (uint256 i = 0; i < _amount; i++) {
1814             uint256 newTokenId = _getNextTokenId();
1815             _mint(_to, newTokenId);
1816             _incrementTokenId();
1817         }
1818     }
1819 
1820 
1821     /**
1822      * @dev Mints a token to an address with a tokenURI.
1823      * @param _to address of the future owner of the token
1824      */
1825     function mintTo(address _to) private {
1826         uint256 newTokenId = _getNextTokenId();
1827         _mint(_to, newTokenId);
1828         _incrementTokenId();
1829     }
1830 
1831     /**
1832      * @dev calculates the next token ID based on value of _currentTokenId
1833      * @return uint256 for the next token ID
1834      */
1835     function _getNextTokenId() private view returns (uint256) {
1836         return _currentTokenId.add(1);
1837     }
1838 
1839     /**
1840      * @dev increments the value of _currentTokenId
1841      */
1842     function _incrementTokenId() private {
1843         _currentTokenId++;
1844     }
1845 
1846     function baseTokenURI() public pure returns (string memory) {
1847         return "https://futureart.mypinata.cloud/ipfs/QmcpYo3QUYrwopLW1V71xRDfAVV7BXXgx6GruQN4VfeEaj/";
1848     }
1849 
1850     function tokenURI(uint256 _tokenId) override public pure returns (string memory) {
1851         return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
1852     }
1853 
1854     /**
1855      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1856      */
1857     function isApprovedForAll(address tokenOwner, address operator)
1858         override
1859         public
1860         view
1861         returns (bool)
1862     {
1863         // Whitelist OpenSea proxy contract for easy trading.
1864         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1865         if (address(proxyRegistry.proxies(tokenOwner)) == operator) {
1866             return true;
1867         }
1868 
1869         return super.isApprovedForAll(tokenOwner, operator);
1870     }
1871 
1872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1873         return super.supportsInterface(interfaceId);
1874     }
1875 
1876 
1877     function _beforeTokenTransfer(
1878         address from,
1879         address to,
1880         uint256 tokenId
1881     ) internal virtual override(ERC721Enumerable, ERC721) {
1882         super._beforeTokenTransfer(from, to, tokenId);
1883     }
1884 
1885     /**
1886      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1887      */
1888     function _msgSender()
1889         internal
1890         override
1891         view
1892         returns (address sender)
1893     {
1894         return ContextMixin.msgSender();
1895     }
1896 
1897 }