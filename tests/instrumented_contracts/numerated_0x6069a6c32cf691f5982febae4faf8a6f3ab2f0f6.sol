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
679                 require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
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
1183 abstract contract OGB {
1184     function ownerOf(uint256 tokenId) public virtual view returns (address);
1185     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual;
1186     function isApprovedForAll(address owner, address operator) external virtual view returns (bool);
1187 }
1188 
1189 contract BullsOnTheBlockEvo is ERC721Enumerable, Ownable {
1190     OGB private ogb;
1191     address public OG_VAULT;
1192     string private baseURI;
1193     mapping(uint256 => uint256) tokenToTimeVaulted;
1194     bool public godsAreReleased = false;
1195     bool public evolveIsActive = false;
1196 
1197     event Evolve(address _from, uint256 _tokenId);
1198     event EvolveMultiple(address _from, uint256[] _tokenIds);
1199 
1200     constructor() ERC721("BullsOnTheBlock Evo","EVOBOTB"){
1201         ogb = OGB(0x3a8778A58993bA4B941f85684D74750043A4bB5f);
1202     }
1203 
1204     function flipSaleState() public onlyOwner {
1205         evolveIsActive = !evolveIsActive;
1206     }
1207 
1208     function evolveBull(uint256 _tokenId) public {
1209         require(evolveIsActive, "Evolving is not active");
1210         require(ogb.ownerOf(_tokenId) == msg.sender, "You must own the requested ID.");
1211         require(ogb.isApprovedForAll(msg.sender, address(this)), "Contract is not approved to transfer your OG Bull.");
1212 
1213         // Transfer OG Bull to the OG OG_VAULT
1214         // Store timestamp in mapping to token ID
1215         ogb.safeTransferFrom(msg.sender, OG_VAULT, _tokenId);
1216         tokenToTimeVaulted[_tokenId] = block.timestamp;
1217         // Mint Evolved Bull
1218         _safeMint(msg.sender, _tokenId);
1219         emit Evolve(msg.sender, _tokenId);
1220     }
1221 
1222     function evolveNBulls(uint256[] memory _tokenIds) public {
1223         require(evolveIsActive, "Evolving is not active");
1224         require(ogb.isApprovedForAll(msg.sender, address(this)), "Contract is not approved to transfer your OG Bull.");
1225         require(_tokenIds.length < 21, "Can't evolve more than 20 Bulls at once.");
1226         for (uint i = 0; i < _tokenIds.length; i++) {
1227             require(ogb.ownerOf(_tokenIds[i]) == msg.sender, "You must own the requested ID");
1228 
1229             // Transfer OG Bull to the OG OG_VAULT
1230             // Store timestamp in mapping to token ID
1231             ogb.safeTransferFrom(msg.sender, OG_VAULT, _tokenIds[i]);
1232             tokenToTimeVaulted[_tokenIds[i]] = block.timestamp;
1233             // Mint Evolved Bull
1234             _safeMint(msg.sender, _tokenIds[i]);
1235         }
1236         emit EvolveMultiple(msg.sender, _tokenIds);
1237     }
1238 
1239     function isEvolved(uint256 _tokenId) external view returns (bool) {
1240         require(_tokenId < 10000, "Token id outside collection bounds!");
1241         return _exists(_tokenId);
1242     }
1243 
1244     function mintPhoenix() external onlyOwner {
1245         require(!_exists(10000), "Phoenix already minted.");
1246         _safeMint(msg.sender, 10000);
1247     }
1248 
1249     // Hi there, you like to read code and be a nerd just like me?
1250     // You're probably wondering what this function is used for...
1251     // Only GOD knows!
1252     function releaseTheGods() external onlyOwner {
1253         require(!godsAreReleased, "Gods have already been released");
1254         for (uint i = 10001; i < 10005; i++) {
1255             _safeMint(msg.sender, i);
1256         }
1257         godsAreReleased = true;
1258     }
1259 
1260     function getTimeVaulted(uint256 tokenId) external view returns (uint256){
1261         require(tokenToTimeVaulted[tokenId] > 0, "Not vaulted yet");
1262         return tokenToTimeVaulted[tokenId];
1263     }
1264 
1265     function setOGVault(address _address) external onlyOwner {
1266         OG_VAULT = _address;
1267     }
1268 
1269     function _baseURI() internal view override returns (string memory) {
1270         return baseURI;
1271     }
1272 
1273     function setBaseURI(string memory uri) public onlyOwner {
1274         baseURI = uri;
1275     }
1276 }