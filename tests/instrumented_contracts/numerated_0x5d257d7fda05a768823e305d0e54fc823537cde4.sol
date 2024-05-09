1 pragma solidity ^0.8.0;
2 
3 
4 // 
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
26 // 
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
164 // 
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
188 // 
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
210 // 
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
424 // 
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
445 // 
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
509 // 
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
533 // 
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
934 // 
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
958 // 
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
1115 // 
1116 /**
1117  * @dev Interface of the ERC20 standard as defined in the EIP.
1118  */
1119 interface IERC20 {
1120     /**
1121      * @dev Returns the amount of tokens in existence.
1122      */
1123     function totalSupply() external view returns (uint256);
1124 
1125     /**
1126      * @dev Returns the amount of tokens owned by `account`.
1127      */
1128     function balanceOf(address account) external view returns (uint256);
1129 
1130     /**
1131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1132      *
1133      * Returns a boolean value indicating whether the operation succeeded.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function transfer(address recipient, uint256 amount) external returns (bool);
1138 
1139     /**
1140      * @dev Returns the remaining number of tokens that `spender` will be
1141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1142      * zero by default.
1143      *
1144      * This value changes when {approve} or {transferFrom} are called.
1145      */
1146     function allowance(address owner, address spender) external view returns (uint256);
1147 
1148     /**
1149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1150      *
1151      * Returns a boolean value indicating whether the operation succeeded.
1152      *
1153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1154      * that someone may use both the old and the new allowance by unfortunate
1155      * transaction ordering. One possible solution to mitigate this race
1156      * condition is to first reduce the spender's allowance to 0 and set the
1157      * desired value afterwards:
1158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1159      *
1160      * Emits an {Approval} event.
1161      */
1162     function approve(address spender, uint256 amount) external returns (bool);
1163 
1164     /**
1165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1166      * allowance mechanism. `amount` is then deducted from the caller's
1167      * allowance.
1168      *
1169      * Returns a boolean value indicating whether the operation succeeded.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function transferFrom(
1174         address sender,
1175         address recipient,
1176         uint256 amount
1177     ) external returns (bool);
1178 
1179     /**
1180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1181      * another (`to`).
1182      *
1183      * Note that `value` may be zero.
1184      */
1185     event Transfer(address indexed from, address indexed to, uint256 value);
1186 
1187     /**
1188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1189      * a call to {approve}. `value` is the new allowance.
1190      */
1191     event Approval(address indexed owner, address indexed spender, uint256 value);
1192 }
1193 
1194 // 
1195 interface IMiece is IERC20 {
1196     function burnFrom(address account, uint256 amount) external;
1197     function getTokensStaked(address staker) external returns (uint256[] memory);
1198 }
1199 
1200 //
1201 
1202 // 
1203 interface IZombie is IERC721 {
1204     // function burnFrom(address account, uint256 amount) external;
1205     function mintZombie(address account, string memory hash) external;
1206     function totalSupply() external view returns (uint256);
1207 }
1208 
1209 // 
1210 library GraveyardLibrary {
1211     string internal constant TABLE =
1212         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1213 
1214 
1215     struct Trait {
1216         string traitName;
1217         string traitType;
1218         string pixels;
1219         uint256 pixelCount;
1220     }
1221 
1222 
1223     /**
1224      * @dev Converts a digit from 0 - 10000 into its corresponding rarity based on the given rarity tier.
1225      * @param _randinput The input from 0 - 10000 to use for rarity gen.
1226      * @param _rarityTier The tier to use.
1227      */
1228     function rarityGen(uint256 _randinput, uint8 _rarityTier, uint16[][8] storage TIERS)
1229         external
1230         view
1231         returns (string memory)
1232     {
1233         uint16 currentLowerBound = 0;
1234         for (uint8 i = 0; i < TIERS[_rarityTier].length; i++) {
1235             uint16 thisPercentage = TIERS[_rarityTier][i];
1236             if (
1237                 _randinput >= currentLowerBound &&
1238                 _randinput < currentLowerBound + thisPercentage
1239             ) return toString(i);
1240             currentLowerBound = currentLowerBound + thisPercentage;
1241         }
1242 
1243         revert();
1244     }
1245 
1246 
1247     /**
1248      * @dev Returns the current miece cost of mint.
1249      */
1250     function currentMieceCost(uint256 _totalSupply) public pure returns (uint256) {
1251 
1252         if (_totalSupply <= 1000) 
1253             return 15 ether; // 15 miece
1254 
1255         if (_totalSupply > 1000 && _totalSupply <= 2111)
1256             return 25 ether; // 25 miece
1257 
1258         if (_totalSupply > 2111 && _totalSupply <= 3222)
1259             return 35 ether; // 35 miece
1260 
1261         if (_totalSupply > 3222 && _totalSupply <= 4333)
1262             return 45 ether; // 45 miece
1263 
1264         if (_totalSupply > 4333 && _totalSupply <= 5444)
1265             return 55 ether; // 55 miece
1266 
1267         revert();
1268     }
1269 
1270 
1271     /**
1272      * @dev Returns the current cost of fastening up a digging
1273      */
1274     function currentFastenCost() public pure returns (uint256) {
1275         return 10 ether;  // 10 miece
1276     }
1277 
1278     /**
1279      * @dev Helper function to reduce pixel size within contract
1280      */
1281     function letterToNumber(string memory _inputLetter, string[] memory LETTERS)
1282         public
1283         pure
1284         returns (uint8)
1285     {
1286         for (uint8 i = 0; i < LETTERS.length; i++) {
1287             if (
1288                 keccak256(abi.encodePacked((LETTERS[i]))) ==
1289                 keccak256(abi.encodePacked((_inputLetter)))
1290             ) return (i + 1);
1291         }
1292         revert();
1293     }
1294 
1295 
1296     /**
1297      * @dev Returns a hash for a given tokenId
1298      * @param tokenHash The tokenId to return the hash for.
1299      * @param yielded The tokenId to return the hash for.
1300      */
1301     function _tokenIdToHash(string memory tokenHash, bool yielded)
1302         external
1303         pure
1304         returns (string memory)
1305     {
1306         // string memory tokenHash = tokenIdToHash[_tokenId];
1307 
1308         // If this is grave has been dug override the previous hash
1309         // FIXME: we could just use the burn address instead and remove the yielded flag
1310         // if (ownerOf(_tokenId) == 0x000000000000000000000000000000000000dEaD) {
1311 
1312         if ( yielded ) {            
1313             tokenHash = string(
1314                 abi.encodePacked(
1315                     "1",
1316                     GraveyardLibrary.substring(tokenHash, 1, 9)
1317                 )
1318             );
1319 
1320         }
1321 
1322         return tokenHash;
1323     }
1324 
1325 
1326     /**
1327      * @dev Hash to metadata function
1328      */
1329     function hashToMetadata(string memory _hash, mapping(uint256 => Trait[]) storage traitTypes)
1330         public
1331         view
1332         returns (string memory)
1333     {
1334         string memory metadataString;
1335 
1336         for (uint8 i = 0; i < 9; i++) { //9
1337             uint8 thisTraitIndex = GraveyardLibrary.parseInt(
1338                 GraveyardLibrary.substring(_hash, i, i + 1)
1339             );
1340 
1341             metadataString = string(
1342                 abi.encodePacked(
1343                     metadataString,
1344                     '{"trait_type":"',
1345                     traitTypes[i][thisTraitIndex].traitType,
1346                     '","value":"',
1347                     traitTypes[i][thisTraitIndex].traitName,
1348                     '"}'
1349                 )
1350             );
1351 
1352             if (i != 8)
1353                 metadataString = string(abi.encodePacked(metadataString, ","));
1354         }
1355 
1356         return string(abi.encodePacked("[", metadataString, "]"));
1357     }
1358 
1359 
1360     /**
1361      * @dev Returns the SVG and metadata for a token Id
1362      * @param _tokenId The tokenId to return the SVG and metadata for.
1363      */
1364     function tokenURIData(uint256 _tokenId, string memory tokenHash, mapping(uint256 => Trait[]) storage traitTypes, string[] memory LETTERS, uint256 diggingStarted)
1365         external
1366         view        
1367         returns (string memory)
1368     {
1369         
1370         return
1371             string(
1372                 abi.encodePacked(
1373                     "data:application/json;base64,",
1374                     encode(
1375                         bytes(
1376                             string(
1377                                 abi.encodePacked(
1378                                     '{"name": "cMyGravez #',
1379                                     toString(_tokenId),
1380                                     // toString(diggingStarted),      // FIXME: !!!!                               
1381                                     '", "description": "cMyKatzGraves is a collection of 5,444 unique graves, where burned cats rests in peace. All the metadata and images stored 100% on-chain.", "image": "data:image/svg+xml;base64,',
1382                                     encode(
1383                                         bytes(hashToSVG(tokenHash,traitTypes,LETTERS,diggingStarted))
1384                                     ),
1385                                     '","attributes":',
1386                                     hashToMetadata(tokenHash,traitTypes),
1387                                     "}"
1388                                 )
1389                             )
1390                         )
1391                     )
1392                 )
1393             );
1394     }
1395 
1396 
1397     /**
1398      * @dev Hash to SVG function
1399      */
1400     function hashToSVG(string memory _hash, mapping(uint256 => Trait[]) storage traitTypes, string[] memory LETTERS, uint256 diggingStarted)
1401         public
1402         view
1403         returns (string memory)
1404     {
1405         string memory svgString;
1406         bool[24][24] memory placedPixels;
1407 
1408         for (uint8 i = 0; i < 9; i++) { 
1409             uint8 thisTraitIndex = GraveyardLibrary.parseInt(
1410                 GraveyardLibrary.substring(_hash, i, i + 1)
1411             );
1412             
1413             // Hide the zombie arm if the digging is not started
1414             if ( i == 1 && diggingStarted == 0 ) {
1415                 continue;
1416             }
1417             for (
1418                 uint16 j = 0;
1419                 j < traitTypes[i][thisTraitIndex].pixelCount; // <
1420                 j++
1421             ) {
1422                 string memory thisPixel = GraveyardLibrary.substring(
1423                     traitTypes[i][thisTraitIndex].pixels,
1424                     j * 4,
1425                     j * 4 + 4
1426                 );
1427 
1428                 uint8 x = letterToNumber(
1429                     GraveyardLibrary.substring(thisPixel, 0, 1), LETTERS
1430                 );
1431                 uint8 y = letterToNumber(
1432                     GraveyardLibrary.substring(thisPixel, 1, 2), LETTERS
1433                 );
1434 
1435                 if (placedPixels[x][y]) continue;
1436 
1437                 svgString = string(
1438                     abi.encodePacked(
1439                         svgString,
1440                         "<rect class='c",
1441                         GraveyardLibrary.substring(thisPixel, 2, 4),
1442                         "' x='",
1443                         toString(x),
1444                         "' y='",
1445                         toString(y),
1446                         "'/>"
1447                     )
1448                 );
1449 
1450                 placedPixels[x][y] = true;
1451             }
1452         }
1453 
1454         svgString = string(
1455             abi.encodePacked(
1456                 '<svg id="g" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 24 24" style="background-color:#2A2A2A"> ',
1457                 svgString,
1458                // "<style>rect{width:1px;height:1px;} #mouse-svg{shape-rendering: crispedges;} .c00{fill:#000000}.c01{fill:#B1ADAC}.c02{fill:#D7D7D7}.c03{fill:#FFA6A6}.c04{fill:#FFD4D5}.c05{fill:#B9AD95}.c06{fill:#E2D6BE}.c07{fill:#7F625A}.c08{fill:#A58F82}.c09{fill:#4B1E0B}.c10{fill:#6D2C10}.c11{fill:#D8D8D8}.c12{fill:#F5F5F5}.c13{fill:#433D4B}.c14{fill:#8D949C}.c15{fill:#05FF00}.c16{fill:#01C700}.c17{fill:#0B8F08}.c18{fill:#421C13}.c19{fill:#6B392A}.c20{fill:#A35E40}.c21{fill:#DCBD91}.c22{fill:#777777}.c23{fill:#848484}.c24{fill:#ABABAB}.c25{fill:#BABABA}.c26{fill:#C7C7C7}.c27{fill:#EAEAEA}.c28{fill:#0C76AA}.c29{fill:#0E97DB}.c30{fill:#10A4EC}.c31{fill:#13B0FF}.c32{fill:#2EB9FE}.c33{fill:#54CCFF}.c34{fill:#50C0F2}.c35{fill:#54CCFF}.c36{fill:#72DAFF}.c37{fill:#B6EAFF}.c38{fill:#FFFFFF}.c39{fill:#954546}.c40{fill:#0B87F7}.c41{fill:#FF2626}.c42{fill:#180F02}.c43{fill:#2B2319}.c44{fill:#FBDD4B}.c45{fill:#F5B923}.c46{fill:#CC8A18}.c47{fill:#3C2203}.c48{fill:#53320B}.c49{fill:#7B501D}.c50{fill:#FFE646}.c51{fill:#FFD627}.c52{fill:#F5B700}.c53{fill:#242424}.c54{fill:#4A4A4A}.c55{fill:#676767}.c56{fill:#F08306}.c57{fill:#FCA30E}.c58{fill:#FEBC0E}.c59{fill:#FBEC1C}.c60{fill:#14242F}.c61{fill:#B06837}.c62{fill:#8F4B0E}.c63{fill:#D88227}.c64{fill:#B06837}</style></svg>"
1459                 "<style>rect{width:1px;height:1px;}#g{shape-rendering: crispedges;}.c00{fill:#3b0346}.c01{fill:#9500b4}.c02{fill:#496707}.c03{fill:#a58d9c}.c04{fill:#859e4a}.c05{fill:#778d45}.c06{fill:#6f8342}.c07{fill:#ff0043}.c08{fill:#f6767b}.c09{fill:#c74249}.c10{fill:#aa343a}.c11{fill:#ffffff}.c12{fill:#000000}.c13{fill:#bfb23e}.c14{fill:#e9cf00}.c15{fill:#00b300}.c16{fill:#009a1a}.c17{fill:#00791a}.c18{fill:#ff2d00}.c19{fill:#e57600}.c20{fill:#f8d9d9}.c21{fill:#ddc600}.c22{fill:#4f4f4f}.c23{fill:#535353}.c24{fill:#565656}.c25{fill:#444444}.c26{fill:#46503f}.c27{fill:#363d30}.c28{fill:#72775c}.c29{fill:#474939}.c30{fill:#5c614a}.c31{fill:#833f41}.c32{fill:#a09300}.c33{fill:#938700}.c34{fill:#877c00}.c35{fill:#5b231d}.c36{fill:#733e39}.c37{fill:#97575a}.c38{fill:#c66703}.c39{fill:#a75c19}.c40{fill:#5a2e04}.c41{fill:#26331d}.c42{fill:#314522}.c43{fill:#3b2d08}.c44{fill:#47360c}.c45{fill:#002845}.c46{fill:#00538a}.c47{fill:#382e25}.c48{fill:#473c32}.c49{fill:#f6efe9}.c50{fill:#695841}.c51{fill:#705d43}.c52{fill:#786142}.c53{fill:#6a4945}.c54{fill:#724946}.c55{fill:#794a45}.c56{fill:#0f0f0f}.c57{fill:#181818}.c58{fill:#8a8a8a}.c59{fill:#445763}.c60{fill:#475c6a}.c61{fill:#465f70}.c62{fill:#ededed}</style></svg>"
1460             )
1461         );
1462 
1463         return svgString;
1464     }    
1465 
1466 
1467     function encode(bytes memory data) public pure returns (string memory) {
1468         if (data.length == 0) return "";
1469 
1470         // load the table into memory
1471         string memory table = TABLE;
1472 
1473         // multiply by 4/3 rounded up
1474         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1475 
1476         // add some extra buffer at the end required for the writing
1477         string memory result = new string(encodedLen + 32);
1478 
1479         assembly {
1480             // set the actual output length
1481             mstore(result, encodedLen)
1482 
1483             // prepare the lookup table
1484             let tablePtr := add(table, 1)
1485 
1486             // input ptr
1487             let dataPtr := data
1488             let endPtr := add(dataPtr, mload(data))
1489 
1490             // result ptr, jump over length
1491             let resultPtr := add(result, 32)
1492 
1493             // run over the input, 3 bytes at a time
1494             for {
1495 
1496             } lt(dataPtr, endPtr) {
1497 
1498             } {
1499                 dataPtr := add(dataPtr, 3)
1500 
1501                 // read 3 bytes
1502                 let input := mload(dataPtr)
1503 
1504                 // write 4 characters
1505                 mstore(
1506                     resultPtr,
1507                     shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1508                 )
1509                 resultPtr := add(resultPtr, 1)
1510                 mstore(
1511                     resultPtr,
1512                     shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1513                 )
1514                 resultPtr := add(resultPtr, 1)
1515                 mstore(
1516                     resultPtr,
1517                     shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1518                 )
1519                 resultPtr := add(resultPtr, 1)
1520                 mstore(
1521                     resultPtr,
1522                     shl(248, mload(add(tablePtr, and(input, 0x3F))))
1523                 )
1524                 resultPtr := add(resultPtr, 1)
1525             }
1526 
1527             // padding with '='
1528             switch mod(mload(data), 3)
1529             case 1 {
1530                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1531             }
1532             case 2 {
1533                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1534             }
1535         }
1536 
1537         return result;
1538     }
1539 
1540     /**
1541      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1542      */
1543     function toString(uint256 value) internal pure returns (string memory) {
1544         if (value == 0) {
1545             return "0";
1546         }
1547         uint256 temp = value;
1548         uint256 digits;
1549         while (temp != 0) {
1550             digits++;
1551             temp /= 10;
1552         }
1553         bytes memory buffer = new bytes(digits);
1554         while (value != 0) {
1555             digits -= 1;
1556             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1557             value /= 10;
1558         }
1559         return string(buffer);
1560     }
1561 
1562     function parseInt(string memory _a)
1563         internal
1564         pure
1565         returns (uint8 _parsedInt)
1566     {
1567         bytes memory bresult = bytes(_a);
1568         uint8 mint = 0;
1569         for (uint8 i = 0; i < bresult.length; i++) {
1570             if (
1571                 (uint8(uint8(bresult[i])) >= 48) &&
1572                 (uint8(uint8(bresult[i])) <= 57)
1573             ) {
1574                 mint *= 10;
1575                 mint += uint8(bresult[i]) - 48;
1576             }
1577         }
1578         return mint;
1579     }
1580 
1581     function substring(
1582         string memory str,
1583         uint256 startIndex,
1584         uint256 endIndex
1585     ) internal pure returns (string memory) {
1586         bytes memory strBytes = bytes(str);
1587         bytes memory result = new bytes(endIndex - startIndex);
1588         for (uint256 i = startIndex; i < endIndex; i++) {
1589             result[i - startIndex] = strBytes[i];
1590         }
1591         return string(result);
1592     }
1593 
1594     function isContract(address account) internal view returns (bool) {
1595         // This method relies on extcodesize, which returns 0 for contracts in
1596         // construction, since the code is only stored at the end of the
1597         // constructor execution.
1598 
1599         uint256 size;
1600         assembly {
1601             size := extcodesize(account)
1602         }
1603         return size > 0;
1604     }
1605 }
1606 
1607 // 
1608 /*
1609 
1610      ___  ___      _____                          
1611      |  \/  |     |  __ \                         
1612   ___| .  . |_   _| |  \/_ __ __ ___   _____  ___ 
1613  / __| |\/| | | | | | __| '__/ _` \ \ / / _ \/ __|
1614 | (__| |  | | |_| | |_\ \ | | (_| |\ V /  __/\__ \
1615  \___\_|  |_/\__, |\____/_|  \__,_| \_/ \___||___/
1616               __/ |                               
1617              |___/                                
1618 
1619 */
1620 contract Graveyard is ERC721Enumerable {
1621     using GraveyardLibrary for uint8;
1622     
1623     // While zombies are false, minting graveyards is not possible
1624     // bool public ZOMBIES = false;
1625 
1626     // uint256 public DEFAULT_DIGGING_TIME = 86400;
1627     uint256 public MAX_SUPPLY = 5444;
1628     uint256 SEED_NONCE = 0;
1629 
1630     // Mappings for the traits and their hashes
1631     mapping(uint256 => GraveyardLibrary.Trait[]) public traitTypes;
1632     mapping(string => bool) hashToMinted;
1633     mapping(uint256 => string) internal tokenIdToHash;
1634 
1635     // Mapping of graveyardId to store the time when the zombie can be claimed
1636     mapping(uint256 => uint256) internal tokenIdToTargetTime;
1637 
1638     // Mapping of graveyardId to staker
1639     mapping(uint256 => address) internal tokenIdToStaker;    
1640     mapping(address => uint256[]) internal stakerToTokenIds;
1641 
1642     // Mapping of graveyardId to staked zombie ids 
1643     mapping(uint256 => uint256[]) internal graveyardIdToCatIds;
1644 
1645     address nullAddress = 0x0000000000000000000000000000000000000000;
1646 
1647     // Mapping of graveyardId to store if a zombie has been claimed or not
1648     mapping(uint256 => bool) internal tokenIdToYield;
1649 
1650     mapping(uint256 => bool) internal katzIdUsedForMint;
1651 
1652     // The ZombieKat contract address
1653     address public zombiesAddress;
1654 
1655     // String arrays, we were not able to store this in the library. Sing the alphabet while you read this.
1656     string[] LETTERS = [
1657         "a",
1658         "b",
1659         "c",
1660         "d",
1661         "e",
1662         "f",
1663         "g",
1664         "h",
1665         "i",
1666         "j",
1667         "k",
1668         "l",
1669         "m",
1670         "n",
1671         "o",
1672         "p",
1673         "q",
1674         "r",
1675         "s",
1676         "t",
1677         "u",
1678         "v",
1679         "w",
1680         "x",
1681         "y",
1682         "z"
1683     ];
1684 
1685     // Array to store the rarity of the graves
1686     uint16[][8] internal TIERS;
1687 
1688     // The miece contract address and the contract owner. 
1689     address mieceAddress;
1690     address _owner;
1691 
1692     constructor() ERC721("cMyGraves", "Grave") {
1693         _owner = msg.sender;
1694 
1695         TIERS[0] = [100, 200, 800, 800, 1200, 2000, 4900]; // arm
1696         TIERS[1] = [400, 1000, 3200, 5400];
1697         TIERS[2] = [500, 1400, 1600, 6500];
1698         TIERS[3] = [100, 400, 500, 9000];
1699         TIERS[4] = [200, 400, 1100, 1100, 2400, 2400, 2400];
1700         TIERS[5] = [2500, 2500, 2500, 2500];
1701         TIERS[6] = [2500, 2500, 2500, 2500];
1702         TIERS[7] = [40, 140, 1420, 1800, 2000, 2200, 2400 ];
1703 
1704     }
1705 
1706     /**
1707      * @dev Returns the staked zombies ids 
1708      * @param staker  The address of the staker
1709      */   
1710     function getCatsStaked(address staker)
1711         public
1712         view
1713         returns (uint256[] memory)
1714     {
1715         return stakerToTokenIds[staker];
1716     }
1717     
1718     /**
1719      * @dev helper function to remove a token id from the array associated to the staker
1720      * @param staker  The address of the staker
1721      * @param index Index
1722      */   
1723     function remove(address staker, uint256 index) internal {
1724         if (index >= stakerToTokenIds[staker].length) return;
1725 
1726         for (uint256 i = index; i < stakerToTokenIds[staker].length - 1; i++) {
1727             stakerToTokenIds[staker][i] = stakerToTokenIds[staker][i + 1];
1728         }
1729         stakerToTokenIds[staker].pop();
1730     }
1731 
1732     /**
1733      * @dev helper function to maintain the list of staked ids of an address
1734      * @param staker  The address of the staker
1735      * @param tokenId  The Staked Zombie Ids
1736      */
1737     function removeTokenIdFromStaker(address staker, uint256 tokenId) internal {
1738         for (uint256 i = 0; i < stakerToTokenIds[staker].length; i++) {
1739             if (stakerToTokenIds[staker][i] == tokenId) {
1740                 //This is the tokenId to remove;
1741                 remove(staker, i);
1742             }
1743         }
1744     }
1745 
1746     /**
1747      * @dev Initialize the digging op and sets the target time when user can claim a zombie
1748      * @param graveId  Target Grave Id
1749      */
1750     
1751     function initDigTime(uint256 graveId, uint256 multipler) internal {
1752         tokenIdToTargetTime[graveId] =
1753             block.timestamp +
1754             (86400 * multipler);
1755     }
1756 
1757     /**
1758      * @dev Unstakes the zombies from the grave, but only if the zombie has been claimed first. 
1759      * @param graveId  Grave Id
1760      */
1761     function claimAndUnstake(uint256 graveId) public {
1762         claimZombie(graveId);
1763 
1764         require(
1765             tokenIdToYield[graveId] == true
1766             // "You need to claim the zombie first"
1767         );
1768 
1769         for (uint256 i = 0; i < graveyardIdToCatIds[graveId].length; i++) {
1770             require(
1771                 tokenIdToStaker[graveyardIdToCatIds[graveId][i]] == msg.sender
1772                 // "Message Sender was not original staker!"
1773             );
1774 
1775             IERC721(zombiesAddress).transferFrom(
1776                 address(this),
1777                 msg.sender,
1778                 graveyardIdToCatIds[graveId][i]
1779             );
1780 
1781             removeTokenIdFromStaker(
1782                 msg.sender,
1783                 graveyardIdToCatIds[graveId][i]
1784             );
1785 
1786             tokenIdToStaker[graveyardIdToCatIds[graveId][i]] = nullAddress;
1787         }
1788     }
1789 
1790     /**
1791      * @dev Moves staked zombies from one grave to an another
1792      * @param fromGraveId   Source Grave Id
1793      * @param toGraveId  Target Grave Id
1794      */
1795 
1796     function claimAndMove(uint256 fromGraveId, uint256 toGraveId) public {
1797         claimZombie(fromGraveId);
1798 
1799         require(
1800             tokenIdToYield[fromGraveId] == true
1801             // "You need to withdraw the zombie cat first."
1802         );
1803 
1804         require(
1805             ownerOf(toGraveId) == msg.sender
1806             // "You can only dig your own graves"
1807         );
1808 
1809         for (uint256 i = 0; i < graveyardIdToCatIds[fromGraveId].length; i++) {
1810             require(
1811                 tokenIdToStaker[graveyardIdToCatIds[fromGraveId][i]] ==
1812                     msg.sender
1813                 // "Message Sender was not original staker!"
1814             );
1815             graveyardIdToCatIds[toGraveId].push(
1816                 graveyardIdToCatIds[fromGraveId][i]
1817             );
1818         }
1819         delete graveyardIdToCatIds[fromGraveId]; // Maybe we don't need this
1820 
1821         initDigTime(toGraveId, 7);
1822     }
1823 
1824     /**
1825      * @dev Stake zombies in a grave
1826      * @param graveId   The grave id
1827      * @param tokenIds  Ids of the zombies
1828      */
1829 
1830     function stakeByIds(uint256 graveId, uint256[] memory tokenIds) public {
1831         require(
1832             tokenIds.length == 2
1833             // "You need two cats to dig!"
1834         );
1835 
1836         require(
1837             graveyardIdToCatIds[graveId].length == 0
1838             // "There are already cats digging this grave"
1839         );
1840 
1841         require(
1842             ownerOf(graveId) == msg.sender
1843             // "You can only dig your own graves"
1844         );
1845 
1846         for (uint256 i = 0; i < tokenIds.length; i++) {
1847             require(
1848                 IERC721(zombiesAddress).ownerOf(tokenIds[i]) == msg.sender &&
1849                     tokenIdToStaker[tokenIds[i]] == nullAddress
1850                 // "Token must be stakable by you!"
1851             );
1852 
1853             IERC721(zombiesAddress).transferFrom(
1854                 msg.sender,
1855                 address(this),
1856                 tokenIds[i]
1857             );
1858 
1859             stakerToTokenIds[msg.sender].push(tokenIds[i]);
1860 
1861             graveyardIdToCatIds[graveId].push(tokenIds[i]);
1862 
1863             tokenIdToStaker[tokenIds[i]] = msg.sender;
1864         }
1865 
1866         initDigTime(graveId, 7);
1867     }
1868 
1869     /**
1870      * @dev Returns the list of ids staked in a grave
1871      * @param graveId The grave id
1872      */
1873     function getCatsStakedByGraveId(uint256 graveId)
1874         public
1875         view
1876         returns (uint256[] memory)
1877     {
1878         return graveyardIdToCatIds[graveId];
1879     }
1880     
1881 
1882     /**
1883      * @dev Returns seconds lefts from a digging completion
1884      * @param graveId The tokenId to return the time lefts
1885      */ 
1886     function getDiggingCompletionTime(uint256 graveId)
1887         public
1888         view
1889         returns (uint256)
1890     {
1891         require(tokenIdToTargetTime[graveId] != 0
1892         // , "Digging not started"
1893         );
1894         require(tokenIdToYield[graveId] != true
1895         //, "Digging already finished"
1896         );
1897 
1898         return tokenIdToTargetTime[graveId];
1899     }
1900 
1901     /**
1902      * @dev Claims the zombie from a grave and burn the grave. 
1903      * @param tokenId The grave Id to claim the zombie from
1904      */
1905      function claimZombie(uint256 tokenId) internal {
1906          require(
1907             ownerOf(tokenId) == msg.sender
1908             // "You cannot withdraw from someone else grave"
1909         );
1910         require(
1911             tokenIdToTargetTime[tokenId] < block.timestamp
1912             //  "This grave digging is not finished yet"
1913         );
1914 
1915         // Zombie Contract will mint a Zombie with the same hash as the Current Grave
1916         IZombie(zombiesAddress).mintZombie(
1917             msg.sender,
1918             _tokenIdToHash(tokenId)
1919         );
1920 
1921         tokenIdToYield[tokenId] = true;
1922 
1923         // After the zombie claimed we burn the graveyard
1924         _transfer(
1925             msg.sender,
1926             0x000000000000000000000000000000000000dEaD,
1927             tokenId
1928         );
1929      }
1930 
1931     /**
1932      * @dev Claims the zombie from a grave and burn the grave. 
1933      * @param tokenIds The grave Ids to claim the zombie from
1934      */
1935     function claimZombies(uint256[] memory tokenIds) public {
1936         for (uint256 i = 0; i < tokenIds.length; i++) {
1937             require(
1938                 graveyardIdToCatIds[tokenIds[i]].length == 0
1939                 // "There are cats digging the grave, can't only claim yielded zombie"
1940             );
1941 
1942             claimZombie(tokenIds[i]);
1943         }
1944     }
1945 
1946     /**
1947      * @dev Fasten up the digging process by spending mice on the Grave. You can include the same GraveId multiple time, it decreases the digging time with a day.
1948      * @param tokenIds The graveyard Ids. 
1949      */
1950     function fastenDigging(uint256[] memory tokenIds) public {
1951         for (uint256 i = 0; i < tokenIds.length; i++) {
1952             IMiece(mieceAddress).burnFrom(
1953                 msg.sender,
1954                 GraveyardLibrary.currentFastenCost(
1955                     // IZombie(zombiesAddress).totalSupply()
1956                 )
1957             );
1958 
1959             tokenIdToTargetTime[tokenIds[i]] =
1960                 tokenIdToTargetTime[tokenIds[i]] -
1961                 86400;
1962         }
1963     }
1964 
1965     /*
1966   __  __ _     _   _             ___             _   _             
1967  |  \/  (_)_ _| |_(_)_ _  __ _  | __|  _ _ _  __| |_(_)___ _ _  ___
1968  | |\/| | | ' \  _| | ' \/ _` | | _| || | ' \/ _|  _| / _ \ ' \(_-<
1969  |_|  |_|_|_||_\__|_|_||_\__, | |_| \_,_|_||_\__|\__|_\___/_||_/__/
1970                          |___/                                     
1971    */
1972 
1973     /**
1974      * @dev Generates a 9 digit hash from a tokenId, address, and random number.
1975      * @param _t The token id to be used within the hash.
1976      * @param _a The address to be used within the hash.
1977      * @param _c The custom nonce to be used within the hash.
1978      */
1979     function hash(
1980         uint256 _t,
1981         address _a,
1982         uint256 _c
1983     ) internal returns (string memory) {
1984         require(_c < 10);
1985 
1986         // This will generate a 9 character string.
1987         //The last 8 digits are random, the first is 0, due to the mouse not being burned.
1988         string memory currentHash = "0";
1989 
1990         for (uint8 i = 0; i < 8; i++) {
1991             SEED_NONCE++;
1992             uint16 _randinput = uint16(
1993                 uint256(
1994                     keccak256(
1995                         abi.encodePacked(
1996                             block.timestamp,
1997                             block.difficulty,
1998                             _t,
1999                             _a,
2000                             _c,
2001                             SEED_NONCE
2002                         )
2003                     )
2004                 ) % 10000
2005             );
2006 
2007             currentHash = string(
2008                 abi.encodePacked(
2009                     currentHash,
2010                     GraveyardLibrary.rarityGen(_randinput, i, TIERS)
2011                 )
2012             );
2013         }
2014 
2015         if (hashToMinted[currentHash]) return hash(_t, _a, _c + 1);
2016 
2017         return currentHash;
2018     }
2019 
2020     /**
2021      * @dev Returns the current miece cost of mint.
2022      */
2023     function currentMieceCost() public view returns (uint256) {
2024         return GraveyardLibrary.currentMieceCost(totalSupply());
2025     }
2026 
2027 
2028     /**
2029      * @dev Checks if a Katz has been used for minting.
2030      */
2031     function checkKatzUsage(uint256 katzId) public view returns (bool) {
2032         return katzIdUsedForMint[ katzId ];
2033     }
2034 
2035     /**
2036      * @dev Mints a Grave, this is to avoid code duplication.
2037      */
2038     function mintGrave(uint256 katzId) public {
2039         uint256 _totalSupply = totalSupply();
2040         require(_totalSupply < MAX_SUPPLY);
2041 
2042         // FIXME: Add these before deployment
2043         // require(_totalSupply > 4);
2044         // require(!GraveyardLibrary.isContract(msg.sender));
2045         
2046         uint256 thisTokenId = _totalSupply;
2047 
2048         tokenIdToHash[thisTokenId] = hash(thisTokenId, msg.sender, 0);
2049 
2050         hashToMinted[tokenIdToHash[thisTokenId]] = true;
2051 
2052         IMiece(mieceAddress).burnFrom(msg.sender, currentMieceCost());
2053 
2054         // First 1000 graves yields automatically after 7 days. 
2055         if ( _totalSupply < 1000 ) {
2056 
2057             bool doesListContainElement = false;
2058 
2059             uint256[] memory stakedIds = IMiece(mieceAddress).getTokensStaked(msg.sender);
2060 
2061             for (uint i=0; i < stakedIds.length; i++) {
2062                 if (katzId == stakedIds[i]) {
2063                     doesListContainElement = true;
2064                 }
2065             }
2066             require(doesListContainElement == true);
2067 
2068             require(katzIdUsedForMint[ katzId ] == false);
2069 
2070             katzIdUsedForMint[ katzId ] = true;
2071                                                             // require(stakedIds.length > 0);    
2072            initDigTime(thisTokenId, 7);
2073         }
2074         
2075         _mint(msg.sender, thisTokenId);
2076     }
2077  
2078 
2079   
2080 
2081     function mintReserve(uint256 _times) public onlyOwner {
2082         // ZOMBIES = true;
2083         for(uint256 i=0; i< _times; i++){
2084             uint256 thisTokenId = totalSupply();
2085             require(thisTokenId < 50);
2086             tokenIdToHash[thisTokenId] = hash(thisTokenId, msg.sender, 0);
2087             hashToMinted[tokenIdToHash[thisTokenId]] = true;
2088             initDigTime(thisTokenId, 7);
2089             _mint(msg.sender, thisTokenId);
2090         }
2091     }
2092  
2093 
2094     /*
2095  ____     ___   ____  ___        _____  __ __  ____     __ ______  ____  ___   ____   _____
2096 |    \   /  _] /    ||   \      |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
2097 |  D  ) /  [_ |  o  ||    \     |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
2098 |    / |    _]|     ||  D  |    |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
2099 |    \ |   [_ |  _  ||     |    |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
2100 |  .  \|     ||  |  ||     |    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
2101 |__|\_||_____||__|__||_____|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
2102                                                                                            
2103 */
2104 
2105     /**
2106      * @dev Returns the SVG and metadata for a token Id
2107      * @param _tokenId The tokenId to return the SVG and metadata for.
2108      */
2109 
2110     function tokenURI(uint256 _tokenId)
2111         public
2112         view
2113         override
2114         returns (string memory)
2115     {
2116         require(_exists(_tokenId));
2117 
2118         string memory tokenHash = _tokenIdToHash(_tokenId);
2119         
2120         return
2121             GraveyardLibrary.tokenURIData(
2122                 _tokenId,
2123                 tokenHash,
2124                 traitTypes,
2125                 LETTERS,
2126                 tokenIdToTargetTime[_tokenId]
2127             );
2128     }
2129 
2130 
2131     /**
2132      * @dev Returns a hash for a given tokenId
2133      * @param _tokenId The tokenId to return the hash for.
2134      */
2135     function _tokenIdToHash(uint256 _tokenId)
2136         public
2137         view
2138         returns (string memory)
2139     {
2140         string memory tokenHash = tokenIdToHash[_tokenId];
2141         //If this is a burned token, override the previous hash
2142         if (tokenIdToYield[_tokenId]) {
2143             tokenHash = string(
2144                 abi.encodePacked(
2145                     "1",
2146                     GraveyardLibrary.substring(tokenHash, 1, 9)
2147                 )
2148             );
2149         }
2150 
2151         return tokenHash;
2152     }
2153 
2154     /**
2155      * @dev Returns the wallet of a given wallet. Mainly for ease for frontend devs.
2156      * @param _wallet The wallet to get the tokens of.
2157      */
2158     function walletOfOwner(address _wallet)
2159         public
2160         view
2161         returns (uint256[] memory)
2162     {
2163         uint256 tokenCount = balanceOf(_wallet);
2164 
2165         uint256[] memory tokensId = new uint256[](tokenCount);
2166         for (uint256 i; i < tokenCount; i++) {
2167             tokensId[i] = tokenOfOwnerByIndex(_wallet, i);
2168         }
2169         return tokensId;
2170     }
2171 
2172     /*
2173 
2174   ___   __    __  ____     ___  ____       _____  __ __  ____     __ ______  ____  ___   ____   _____
2175  /   \ |  |__|  ||    \   /  _]|    \     |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
2176 |     ||  |  |  ||  _  | /  [_ |  D  )    |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
2177 |  O  ||  |  |  ||  |  ||    _]|    /     |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
2178 |     ||  `  '  ||  |  ||   [_ |    \     |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
2179 |     | \      / |  |  ||     ||  .  \    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
2180  \___/   \_/\_/  |__|__||_____||__|\_|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
2181                                                                                                      
2182 
2183 
2184     */
2185 
2186     
2187     /**
2188      * @dev Add a trait type
2189      * @param _traitTypeIndex The trait type index
2190      * @param traits Array of traits to add
2191      */
2192 
2193     function addTraitType(
2194         uint256 _traitTypeIndex,
2195         GraveyardLibrary.Trait[] memory traits
2196     ) public onlyOwner {
2197         for (uint256 i = 0; i < traits.length; i++) {
2198             traitTypes[_traitTypeIndex].push(
2199                 GraveyardLibrary.Trait(
2200                     traits[i].traitName,
2201                     traits[i].traitType,
2202                     traits[i].pixels,
2203                     traits[i].pixelCount
2204                 )
2205             );
2206         }
2207 
2208         return;
2209     }
2210 
2211     /**
2212      * @dev Sets the miece, cats and zombie contract addresses
2213      * @param _mieceAddress The miece address
2214      * @param _zombiesAddress The cats address
2215      */
2216     function setContractAddresses(
2217         address _mieceAddress,
2218         address _zombiesAddress
2219     ) public onlyOwner {
2220         mieceAddress = _mieceAddress;
2221         zombiesAddress = _zombiesAddress;
2222         return;
2223     }
2224 
2225     /**
2226      * @dev Transfers ownership
2227      * @param _newOwner The new owner
2228      */
2229     // function transferOwnership(address _newOwner) public onlyOwner {
2230     //     _owner = _newOwner;
2231     // }
2232     
2233 
2234     /**
2235      * @dev Modifier to only allow owner to call functions
2236      */
2237     modifier onlyOwner() {
2238         require(_owner == msg.sender);
2239         _;
2240     }
2241 }