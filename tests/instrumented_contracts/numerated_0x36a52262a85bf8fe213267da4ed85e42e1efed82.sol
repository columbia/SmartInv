1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.4;
4 
5 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 
29 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been whiteed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is whiteed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 
169 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
170 
171 /**
172  * @title ERC721 token receiver interface
173  * @dev Interface for any contract that wants to support safeTransfers
174  * from ERC721 asset contracts.
175  */
176 interface IERC721Receiver {
177     /**
178      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
179      * by `operator` from `from`, this function is called.
180      *
181      * It must return its Solidity selector to confirm the token transfer.
182      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
183      *
184      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
185      */
186     function onERC721Received(
187         address operator,
188         address from,
189         uint256 tokenId,
190         bytes calldata data
191     ) external returns (bytes4);
192 }
193 
194 
195 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Metadata is IERC721 {
202     /**
203      * @dev Returns the token collection name.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the token collection symbol.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
214      */
215     function tokenURI(uint256 tokenId) external view returns (string memory);
216 }
217 
218 
219 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
220 
221 /**
222  * @dev Collection of functions related to the address type
223  */
224 library Address {
225     /**
226      * @dev Returns true if `account` is a contract.
227      *
228      * [IMPORTANT]
229      * ====
230      * It is unsafe to assume that an address for which this function returns
231      * false is an externally-owned account (EOA) and not a contract.
232      *
233      * Among others, `isContract` will return false for the following
234      * types of addresses:
235      *
236      *  - an externally-owned account
237      *  - a contract in construction
238      *  - an address where a contract will be created
239      *  - an address where a contract lived, but was destroyed
240      * ====
241      */
242     function isContract(address account) internal view returns (bool) {
243         // This method relies on extcodesize, which returns 0 for contracts in
244         // construction, since the code is only stored at the end of the
245         // constructor execution.
246 
247         uint256 size;
248         assembly {
249             size := extcodesize(account)
250         }
251         return size > 0;
252     }
253 
254     /**
255      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
256      * `recipient`, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by `transfer`, making them unable to receive funds via
261      * `transfer`. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to `recipient`, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         (bool success, ) = recipient.call{value: amount}("");
274         require(success, "Address: unable to send value, recipient may have reverted");
275     }
276 
277     /**
278      * @dev Performs a Solidity function call using a low level `call`. A
279      * plain `call` is an unsafe replacement for a function call: use this
280      * function instead.
281      *
282      * If `target` reverts with a revert reason, it is bubbled up by this
283      * function (like regular Solidity function calls).
284      *
285      * Returns the raw returned data. To convert to the expected return value,
286      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
287      *
288      * Requirements:
289      *
290      * - `target` must be a contract.
291      * - calling `target` with `data` must not revert.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
301      * `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but also transferring `value` wei to `target`.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least `value`.
320      * - the called Solidity function must be `payable`.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
334      * with `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         require(isContract(target), "Address: call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.call{value: value}(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.staticcall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.delegatecall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
407      * revert reason using the provided one.
408      *
409      * _Available since v4.3._
410      */
411     function verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) internal pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 
435 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
436 
437 /**
438  * @dev Provides information about the current execution context, including the
439  * sender of the transaction and its data. While these are generally available
440  * via msg.sender and msg.data, they should not be accessed in such a direct
441  * manner, since when dealing with meta-transactions the account sending and
442  * paying for execution may not be the actual sender (as far as an application
443  * is concerned).
444  *
445  * This contract is only required for intermediate, library-like contracts.
446  */
447 abstract contract Context {
448     function _msgSender() internal view virtual returns (address) {
449         return msg.sender;
450     }
451 
452     function _msgData() internal view virtual returns (bytes calldata) {
453         return msg.data;
454     }
455 }
456 
457 
458 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
459 
460 /**
461  * @dev String operations.
462  */
463 library Strings {
464     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
465 
466     /**
467      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
468      */
469     function toString(uint256 value) internal pure returns (string memory) {
470         // Inspired by OraclizeAPI's implementation - MIT licence
471         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
472 
473         if (value == 0) {
474             return "0";
475         }
476         uint256 temp = value;
477         uint256 digits;
478         while (temp != 0) {
479             digits++;
480             temp /= 10;
481         }
482         bytes memory buffer = new bytes(digits);
483         while (value != 0) {
484             digits -= 1;
485             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
486             value /= 10;
487         }
488         return string(buffer);
489     }
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
493      */
494     function toHexString(uint256 value) internal pure returns (string memory) {
495         if (value == 0) {
496             return "0x00";
497         }
498         uint256 temp = value;
499         uint256 length = 0;
500         while (temp != 0) {
501             length++;
502             temp >>= 8;
503         }
504         return toHexString(value, length);
505     }
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
509      */
510     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
511         bytes memory buffer = new bytes(2 * length + 2);
512         buffer[0] = "0";
513         buffer[1] = "x";
514         for (uint256 i = 2 * length + 1; i > 1; --i) {
515             buffer[i] = _HEX_SYMBOLS[value & 0xf];
516             value >>= 4;
517         }
518         require(value == 0, "Strings: hex length insufficient");
519         return string(buffer);
520     }
521 }
522 
523 
524 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
525 
526 /**
527  * @dev Implementation of the {IERC165} interface.
528  *
529  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
530  * for the additional interface id that will be supported. For example:
531  *
532  * ```solidity
533  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
535  * }
536  * ```
537  *
538  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
539  */
540 abstract contract ERC165 is IERC165 {
541     /**
542      * @dev See {IERC165-supportsInterface}.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545         return interfaceId == type(IERC165).interfaceId;
546     }
547 }
548 
549 
550 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
551 
552 /**
553  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
554  * the Metadata extension, but not including the Enumerable extension, which is available separately as
555  * {ERC721Enumerable}.
556  */
557 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
558     using Address for address;
559     using Strings for uint256;
560 
561     // Token name
562     string private _name;
563 
564     // Token symbol
565     string private _symbol;
566 
567     // Mapping from token ID to owner address
568     mapping(uint256 => address) private _owners;
569 
570     // Mapping owner address to token count
571     mapping(address => uint256) private _balances;
572 
573     // Mapping from token ID to approved address
574     mapping(uint256 => address) private _tokenApprovals;
575 
576     // Mapping from owner to operator approvals
577     mapping(address => mapping(address => bool)) private _operatorApprovals;
578 
579     /**
580      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
581      */
582     constructor(string memory name_, string memory symbol_) {
583         _name = name_;
584         _symbol = symbol_;
585     }
586 
587     /**
588      * @dev See {IERC165-supportsInterface}.
589      */
590     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
591         return
592             interfaceId == type(IERC721).interfaceId ||
593             interfaceId == type(IERC721Metadata).interfaceId ||
594             super.supportsInterface(interfaceId);
595     }
596 
597     /**
598      * @dev See {IERC721-balanceOf}.
599      */
600     function balanceOf(address owner) public view virtual override returns (uint256) {
601         require(owner != address(0), "ERC721: balance query for the zero address");
602         return _balances[owner];
603     }
604 
605     /**
606      * @dev See {IERC721-ownerOf}.
607      */
608     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
609         address owner = _owners[tokenId];
610         require(owner != address(0), "ERC721: owner query for nonexistent token");
611         return owner;
612     }
613 
614     /**
615      * @dev See {IERC721Metadata-name}.
616      */
617     function name() public view virtual override returns (string memory) {
618         return _name;
619     }
620 
621     /**
622      * @dev See {IERC721Metadata-symbol}.
623      */
624     function symbol() public view virtual override returns (string memory) {
625         return _symbol;
626     }
627 
628     /**
629      * @dev See {IERC721Metadata-tokenURI}.
630      */
631     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
632         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
633 
634         string memory baseURI = _baseURI();
635         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
636     }
637 
638     /**
639      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
640      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
641      * by default, can be overriden in child contracts.
642      */
643     function _baseURI() internal view virtual returns (string memory) {
644         return "";
645     }
646 
647     /**
648      * @dev See {IERC721-approve}.
649      */
650     function approve(address to, uint256 tokenId) public virtual override {
651         address owner = ERC721.ownerOf(tokenId);
652         require(to != owner, "ERC721: approval to current owner");
653 
654         require(
655             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
656             "ERC721: approve caller is not owner nor approved for all"
657         );
658 
659         _approve(to, tokenId);
660     }
661 
662     /**
663      * @dev See {IERC721-getApproved}.
664      */
665     function getApproved(uint256 tokenId) public view virtual override returns (address) {
666         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
667 
668         return _tokenApprovals[tokenId];
669     }
670 
671     /**
672      * @dev See {IERC721-setApprovalForAll}.
673      */
674     function setApprovalForAll(address operator, bool approved) public virtual override {
675         require(operator != _msgSender(), "ERC721: approve to caller");
676 
677         _operatorApprovals[_msgSender()][operator] = approved;
678         emit ApprovalForAll(_msgSender(), operator, approved);
679     }
680 
681     /**
682      * @dev See {IERC721-isApprovedForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
685         return _operatorApprovals[owner][operator];
686     }
687 
688     /**
689      * @dev See {IERC721-transferFrom}.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) public virtual override {
696         //solhint-disable-next-line max-line-length
697         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
698 
699         _transfer(from, to, tokenId);
700     }
701 
702     /**
703      * @dev See {IERC721-safeTransferFrom}.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) public virtual override {
710         safeTransferFrom(from, to, tokenId, "");
711     }
712 
713     /**
714      * @dev See {IERC721-safeTransferFrom}.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId,
720         bytes memory _data
721     ) public virtual override {
722         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
723         _safeTransfer(from, to, tokenId, _data);
724     }
725 
726     /**
727      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
728      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
729      *
730      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
731      *
732      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
733      * implement alternative mechanisms to perform token transfer, such as signature-based.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must exist and be owned by `from`.
740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741      *
742      * Emits a {Transfer} event.
743      */
744     function _safeTransfer(
745         address from,
746         address to,
747         uint256 tokenId,
748         bytes memory _data
749     ) internal virtual {
750         _transfer(from, to, tokenId);
751         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
752     }
753 
754     /**
755      * @dev Returns whether `tokenId` exists.
756      *
757      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
758      *
759      * Tokens start existing when they are minted (`_mint`),
760      * and stop existing when they are burned (`_burn`).
761      */
762     function _exists(uint256 tokenId) internal view virtual returns (bool) {
763         return _owners[tokenId] != address(0);
764     }
765 
766     /**
767      * @dev Returns whether `spender` is whiteed to manage `tokenId`.
768      *
769      * Requirements:
770      *
771      * - `tokenId` must exist.
772      */
773     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
774         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
775         address owner = ERC721.ownerOf(tokenId);
776         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
777     }
778 
779     /**
780      * @dev Safely mints `tokenId` and transfers it to `to`.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must not exist.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _safeMint(address to, uint256 tokenId) internal virtual {
790         _safeMint(to, tokenId, "");
791     }
792 
793     /**
794      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
795      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
796      */
797     function _safeMint(
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _mint(to, tokenId);
803         require(
804             _checkOnERC721Received(address(0), to, tokenId, _data),
805             "ERC721: transfer to non ERC721Receiver implementer"
806         );
807     }
808 
809     /**
810      * @dev Mints `tokenId` and transfers it to `to`.
811      *
812      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
813      *
814      * Requirements:
815      *
816      * - `tokenId` must not exist.
817      * - `to` cannot be the zero address.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _mint(address to, uint256 tokenId) internal virtual {
822         require(to != address(0), "ERC721: mint to the zero address");
823         require(!_exists(tokenId), "ERC721: token already minted");
824 
825         _beforeTokenTransfer(address(0), to, tokenId);
826 
827         _balances[to] += 1;
828         _owners[tokenId] = to;
829 
830         emit Transfer(address(0), to, tokenId);
831     }
832 
833     /**
834      * @dev Destroys `tokenId`.
835      * The approval is cleared when the token is burned.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must exist.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _burn(uint256 tokenId) internal virtual {
844         address owner = ERC721.ownerOf(tokenId);
845 
846         _beforeTokenTransfer(owner, address(0), tokenId);
847 
848         // Clear approvals
849         _approve(address(0), tokenId);
850 
851         _balances[owner] -= 1;
852         delete _owners[tokenId];
853 
854         emit Transfer(owner, address(0), tokenId);
855     }
856 
857     /**
858      * @dev Transfers `tokenId` from `from` to `to`.
859      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _transfer(
869         address from,
870         address to,
871         uint256 tokenId
872     ) internal virtual {
873         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
874         require(to != address(0), "ERC721: transfer to the zero address");
875 
876         _beforeTokenTransfer(from, to, tokenId);
877 
878         // Clear approvals from the previous owner
879         _approve(address(0), tokenId);
880 
881         _balances[from] -= 1;
882         _balances[to] += 1;
883         _owners[tokenId] = to;
884 
885         emit Transfer(from, to, tokenId);
886     }
887 
888     /**
889      * @dev Approve `to` to operate on `tokenId`
890      *
891      * Emits a {Approval} event.
892      */
893     function _approve(address to, uint256 tokenId) internal virtual {
894         _tokenApprovals[tokenId] = to;
895         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
896     }
897 
898     /**
899      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
900      * The call is not executed if the target address is not a contract.
901      *
902      * @param from address representing the previous owner of the given token ID
903      * @param to target address that will receive the tokens
904      * @param tokenId uint256 ID of the token to be transferred
905      * @param _data bytes optional data to send along with the call
906      * @return bool whether the call correctly returned the expected magic value
907      */
908     function _checkOnERC721Received(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) private returns (bool) {
914         if (to.isContract()) {
915             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
916                 return retval == IERC721Receiver.onERC721Received.selector;
917             } catch (bytes memory reason) {
918                 if (reason.length == 0) {
919                     revert("ERC721: transfer to non ERC721Receiver implementer");
920                 } else {
921                     assembly {
922                         revert(add(32, reason), mload(reason))
923                     }
924                 }
925             }
926         } else {
927             return true;
928         }
929     }
930 
931     /**
932      * @dev Hook that is called before any token transfer. This includes minting
933      * and burning.
934      *
935      * Calling conditions:
936      *
937      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
938      * transferred to `to`.
939      * - When `from` is zero, `tokenId` will be minted for `to`.
940      * - When `to` is zero, ``from``'s `tokenId` will be burned.
941      * - `from` and `to` are never both zero.
942      *
943      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
944      */
945     function _beforeTokenTransfer(
946         address from,
947         address to,
948         uint256 tokenId
949     ) internal virtual {}
950 }
951 
952 
953 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
954 
955 /**
956  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
957  * @dev See https://eips.ethereum.org/EIPS/eip-721
958  */
959 interface IERC721Enumerable is IERC721 {
960     /**
961      * @dev Returns the total amount of tokens stored by the contract.
962      */
963     function totalSupply() external view returns (uint256);
964 
965     /**
966      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
967      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
968      */
969     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
970 
971     /**
972      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
973      * Use along with {totalSupply} to enumerate all tokens.
974      */
975     function tokenByIndex(uint256 index) external view returns (uint256);
976 }
977 
978 
979 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.0
980 
981 
982 /**
983  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
984  * enumerability of all the token ids in the contract as well as all token ids owned by each
985  * account.
986  */
987 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
988     // Mapping from owner to list of owned token IDs
989     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
990 
991     // Mapping from token ID to index of the owner tokens list
992     mapping(uint256 => uint256) private _ownedTokensIndex;
993 
994     // Array with all token ids, used for enumeration
995     uint256[] private _allTokens;
996 
997     // Mapping from token id to position in the allTokens array
998     mapping(uint256 => uint256) private _allTokensIndex;
999 
1000     /**
1001      * @dev See {IERC165-supportsInterface}.
1002      */
1003     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1004         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1009      */
1010     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1011         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1012         return _ownedTokens[owner][index];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Enumerable-totalSupply}.
1017      */
1018     function totalSupply() public view virtual override returns (uint256) {
1019         return _allTokens.length;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Enumerable-tokenByIndex}.
1024      */
1025     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1026         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1027         return _allTokens[index];
1028     }
1029 
1030     /**
1031      * @dev Hook that is called before any token transfer. This includes minting
1032      * and burning.
1033      *
1034      * Calling conditions:
1035      *
1036      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1037      * transferred to `to`.
1038      * - When `from` is zero, `tokenId` will be minted for `to`.
1039      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      *
1043      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1044      */
1045     function _beforeTokenTransfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) internal virtual override {
1050         super._beforeTokenTransfer(from, to, tokenId);
1051 
1052         if (from == address(0)) {
1053             _addTokenToAllTokensEnumeration(tokenId);
1054         } else if (from != to) {
1055             _removeTokenFromOwnerEnumeration(from, tokenId);
1056         }
1057         if (to == address(0)) {
1058             _removeTokenFromAllTokensEnumeration(tokenId);
1059         } else if (to != from) {
1060             _addTokenToOwnerEnumeration(to, tokenId);
1061         }
1062     }
1063 
1064     /**
1065      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1066      * @param to address representing the new owner of the given token ID
1067      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1068      */
1069     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1070         uint256 length = ERC721.balanceOf(to);
1071         _ownedTokens[to][length] = tokenId;
1072         _ownedTokensIndex[tokenId] = length;
1073     }
1074 
1075     /**
1076      * @dev Private function to add a token to this extension's token tracking data structures.
1077      * @param tokenId uint256 ID of the token to be added to the tokens list
1078      */
1079     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1080         _allTokensIndex[tokenId] = _allTokens.length;
1081         _allTokens.push(tokenId);
1082     }
1083 
1084     /**
1085      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1086      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this whites for
1087      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1088      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1089      * @param from address representing the previous owner of the given token ID
1090      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1091      */
1092     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1093         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1094         // then delete the last slot (swap and pop).
1095 
1096         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1097         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1098 
1099         // When the token to delete is the last token, the swap operation is unnecessary
1100         if (tokenIndex != lastTokenIndex) {
1101             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1102 
1103             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1104             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1105         }
1106 
1107         // This also deletes the contents at the last position of the array
1108         delete _ownedTokensIndex[tokenId];
1109         delete _ownedTokens[from][lastTokenIndex];
1110     }
1111 
1112     /**
1113      * @dev Private function to remove a token from this extension's token tracking data structures.
1114      * This has O(1) time complexity, but alters the order of the _allTokens array.
1115      * @param tokenId uint256 ID of the token to be removed from the tokens list
1116      */
1117     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1118         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1119         // then delete the last slot (swap and pop).
1120 
1121         uint256 lastTokenIndex = _allTokens.length - 1;
1122         uint256 tokenIndex = _allTokensIndex[tokenId];
1123 
1124         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1125         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1126         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1127         uint256 lastTokenId = _allTokens[lastTokenIndex];
1128 
1129         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1130         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1131 
1132         // This also deletes the contents at the last position of the array
1133         delete _allTokensIndex[tokenId];
1134         _allTokens.pop();
1135     }
1136 }
1137 
1138 
1139 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
1140 
1141 
1142 // CAUTION
1143 // This version of SafeMath should only be used with Solidity 0.8 or later,
1144 // because it relies on the compiler's built in overflow checks.
1145 
1146 /**
1147  * @dev Wrappers over Solidity's arithmetic operations.
1148  *
1149  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1150  * now has built in overflow checking.
1151  */
1152 library SafeMath {
1153     /**
1154      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1155      *
1156      * _Available since v3.4._
1157      */
1158     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1159         unchecked {
1160             uint256 c = a + b;
1161             if (c < a) return (false, 0);
1162             return (true, c);
1163         }
1164     }
1165 
1166     /**
1167      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1168      *
1169      * _Available since v3.4._
1170      */
1171     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1172         unchecked {
1173             if (b > a) return (false, 0);
1174             return (true, a - b);
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1180      *
1181      * _Available since v3.4._
1182      */
1183     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1184         unchecked {
1185             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1186             // benefit is lost if 'b' is also tested.
1187             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1188             if (a == 0) return (true, 0);
1189             uint256 c = a * b;
1190             if (c / a != b) return (false, 0);
1191             return (true, c);
1192         }
1193     }
1194 
1195     /**
1196      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1197      *
1198      * _Available since v3.4._
1199      */
1200     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1201         unchecked {
1202             if (b == 0) return (false, 0);
1203             return (true, a / b);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1213         unchecked {
1214             if (b == 0) return (false, 0);
1215             return (true, a % b);
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns the addition of two unsigned integers, reverting on
1221      * overflow.
1222      *
1223      * Counterpart to Solidity's `+` operator.
1224      *
1225      * Requirements:
1226      *
1227      * - Addition cannot overflow.
1228      */
1229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1230         return a + b;
1231     }
1232 
1233     /**
1234      * @dev Returns the subtraction of two unsigned integers, reverting on
1235      * overflow (when the result is negative).
1236      *
1237      * Counterpart to Solidity's `-` operator.
1238      *
1239      * Requirements:
1240      *
1241      * - Subtraction cannot overflow.
1242      */
1243     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1244         return a - b;
1245     }
1246 
1247     /**
1248      * @dev Returns the multiplication of two unsigned integers, reverting on
1249      * overflow.
1250      *
1251      * Counterpart to Solidity's `*` operator.
1252      *
1253      * Requirements:
1254      *
1255      * - Multiplication cannot overflow.
1256      */
1257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1258         return a * b;
1259     }
1260 
1261     /**
1262      * @dev Returns the integer division of two unsigned integers, reverting on
1263      * division by zero. The result is rounded towards zero.
1264      *
1265      * Counterpart to Solidity's `/` operator.
1266      *
1267      * Requirements:
1268      *
1269      * - The divisor cannot be zero.
1270      */
1271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1272         return a / b;
1273     }
1274 
1275     /**
1276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1277      * reverting when dividing by zero.
1278      *
1279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1280      * opcode (which leaves remaining gas untouched) while Solidity uses an
1281      * invalid opcode to revert (consuming all remaining gas).
1282      *
1283      * Requirements:
1284      *
1285      * - The divisor cannot be zero.
1286      */
1287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1288         return a % b;
1289     }
1290 
1291     /**
1292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1293      * overflow (when the result is negative).
1294      *
1295      * CAUTION: This function is deprecated because it requires allocating memory for the error
1296      * message unnecessarily. For custom revert reasons use {trySub}.
1297      *
1298      * Counterpart to Solidity's `-` operator.
1299      *
1300      * Requirements:
1301      *
1302      * - Subtraction cannot overflow.
1303      */
1304     function sub(
1305         uint256 a,
1306         uint256 b,
1307         string memory errorMessage
1308     ) internal pure returns (uint256) {
1309         unchecked {
1310             require(b <= a, errorMessage);
1311             return a - b;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1317      * division by zero. The result is rounded towards zero.
1318      *
1319      * Counterpart to Solidity's `/` operator. Note: this function uses a
1320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1321      * uses an invalid opcode to revert (consuming all remaining gas).
1322      *
1323      * Requirements:
1324      *
1325      * - The divisor cannot be zero.
1326      */
1327     function div(
1328         uint256 a,
1329         uint256 b,
1330         string memory errorMessage
1331     ) internal pure returns (uint256) {
1332         unchecked {
1333             require(b > 0, errorMessage);
1334             return a / b;
1335         }
1336     }
1337 
1338     /**
1339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1340      * reverting with custom message when dividing by zero.
1341      *
1342      * CAUTION: This function is deprecated because it requires allocating memory for the error
1343      * message unnecessarily. For custom revert reasons use {tryMod}.
1344      *
1345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1346      * opcode (which leaves remaining gas untouched) while Solidity uses an
1347      * invalid opcode to revert (consuming all remaining gas).
1348      *
1349      * Requirements:
1350      *
1351      * - The divisor cannot be zero.
1352      */
1353     function mod(
1354         uint256 a,
1355         uint256 b,
1356         string memory errorMessage
1357     ) internal pure returns (uint256) {
1358         unchecked {
1359             require(b > 0, errorMessage);
1360             return a % b;
1361         }
1362     }
1363 }
1364 
1365 
1366 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
1367 
1368 /**
1369  * @dev Contract module which provides a basic access control mechanism, where
1370  * there is an account (an owner) that can be granted exclusive access to
1371  * specific functions.
1372  *
1373  * By default, the owner account will be the one that deploys the contract. This
1374  * can later be changed with {transferOwnership}.
1375  *
1376  * This module is used through inheritance. It will make available the modifier
1377  * `onlyOwner`, which can be applied to your functions to restrict their use to
1378  * the owner.
1379  */
1380 abstract contract Ownable is Context {
1381     address private _owner;
1382 
1383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1384 
1385     /**
1386      * @dev Initializes the contract setting the deployer as the initial owner.
1387      */
1388     constructor() {
1389         _setOwner(_msgSender());
1390     }
1391 
1392     /**
1393      * @dev Returns the address of the current owner.
1394      */
1395     function owner() public view virtual returns (address) {
1396         return _owner;
1397     }
1398 
1399     /**
1400      * @dev Throws if called by any account other than the owner.
1401      */
1402     modifier onlyOwner() {
1403         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1404         _;
1405     }
1406 
1407     /**
1408      * @dev Leaves the contract without owner. It will not be possible to call
1409      * `onlyOwner` functions anymore. Can only be called by the current owner.
1410      *
1411      * NOTE: Renouncing ownership will leave the contract without an owner,
1412      * thereby removing any functionality that is only available to the owner.
1413      */
1414     function renounceOwnership() public virtual onlyOwner {
1415         _setOwner(address(0));
1416     }
1417 
1418     /**
1419      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1420      * Can only be called by the current owner.
1421      */
1422     function transferOwnership(address newOwner) public virtual onlyOwner {
1423         require(newOwner != address(0), "Ownable: new owner is the zero address");
1424         _setOwner(newOwner);
1425     }
1426 
1427     function _setOwner(address newOwner) private {
1428         address oldOwner = _owner;
1429         _owner = newOwner;
1430         emit OwnershipTransferred(oldOwner, newOwner);
1431     }
1432 }
1433 
1434 
1435 contract Horizon is ERC721("Hor1zon", "H1Z"), ERC721Enumerable, Ownable {
1436     using SafeMath for uint256;
1437     using Strings for uint256;
1438     /*
1439      * Currently Assuming there will be one baseURI.
1440      * If it fails to upload all NFTs data under one baseURI,
1441      * we will divide baseURI and tokenURI function will be changed accordingly.
1442     */
1443     string private baseURI;
1444     string private blindURI;
1445     uint256 public constant BUY_LIMIT_PER_TX = 5;
1446     uint256 public constant MAX_NFT_PUBLIC = 6899;
1447     uint256 private constant MAX_NFT = 6999;
1448     uint256 public NFTPrice = 120000000000000000;  // 0.12 ETH
1449     bool public reveal;
1450     bool public isActive;
1451     bool public isPresaleActive;
1452     uint256 public constant WHITELIST_MAX_MINT = 2;
1453     mapping(address => bool) private whiteList;
1454     mapping(address => uint256) private whiteListClaimed;
1455     uint256 public giveawayCount;
1456     /*
1457      * Function to reveal all NFTs
1458     */
1459     function revealNow() 
1460         external 
1461         onlyOwner 
1462     {
1463         reveal = true;
1464     }
1465     
1466     /*
1467      * Function addToWhiteList to add whitelisted addresses to presale
1468     */
1469     function addToWhiteList(
1470         address[] memory _addresses
1471     ) 
1472         external
1473         onlyOwner
1474     {
1475         for (uint256 i = 0; i < _addresses.length; i++) {
1476             require(_addresses[i] != address(0), "Cannot add the null address");
1477             whiteList[_addresses[i]] = true;
1478             /**
1479             * @dev We don't want to reset _whiteListClaimed count
1480             * if we try to add someone more than once.
1481             */
1482             whiteListClaimed[_addresses[i]] > 0 ? whiteListClaimed[_addresses[i]] : 0;
1483         }
1484     }
1485     
1486     /*
1487      * Function onWhiteList returns if address is whitelisted or not 
1488     */
1489     function onWhiteList(
1490         address _addr
1491     ) 
1492         external 
1493         view
1494         returns (bool) 
1495     {
1496         return whiteList[_addr];
1497     }
1498     
1499     /*
1500      * Function setIsActive to activate/desactivate the smart contract
1501     */
1502     function setIsActive(
1503         bool _isActive
1504     ) 
1505         external 
1506         onlyOwner 
1507     {
1508         isActive = _isActive;
1509     }
1510     
1511     /*
1512      * Function setPresaleActive to activate/desactivate the presale  
1513     */
1514     function setPresaleActive(
1515         bool _isActive
1516     ) 
1517         external 
1518         onlyOwner 
1519     {
1520         isPresaleActive = _isActive;
1521     }
1522     
1523     /*
1524      * Function to set Base and Blind URI 
1525     */
1526     function setURIs(
1527         string memory _blindURI, 
1528         string memory _URI
1529     ) 
1530         external 
1531         onlyOwner 
1532     {
1533         blindURI = _blindURI;
1534         baseURI = _URI;
1535     }
1536     
1537     /*
1538      * Function to withdraw collected amount during minting by the owner
1539     */
1540     function withdraw(
1541         address _to
1542     ) 
1543         public 
1544         onlyOwner 
1545     {
1546         uint balance = address(this).balance;
1547         require(balance > 0, "Balance should be more then zero");
1548         payable(_to).transfer(balance);
1549     }
1550     
1551     /*
1552      * Function to mint new NFTs during the public sale
1553      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1554     */
1555     function mintNFT(
1556         uint256 _numOfTokens
1557     ) 
1558         public 
1559         payable 
1560     {
1561     
1562         require(isActive, 'Contract is not active');
1563         require(!isPresaleActive, 'Only whiteing from White List');
1564         require(_numOfTokens <= BUY_LIMIT_PER_TX, "Cannot mint above limit");
1565         require(totalSupply().add(_numOfTokens).sub(giveawayCount) <= MAX_NFT_PUBLIC, "Purchase would exceed max public supply of NFTs");
1566         require(NFTPrice.mul(_numOfTokens) == msg.value, "Ether value sent is not correct");
1567         
1568         for(uint i = 0; i < _numOfTokens; i++) {
1569             _safeMint(msg.sender, totalSupply().sub(giveawayCount));
1570         }
1571     }
1572     
1573     /*
1574      * Function to mint new NFTs during the presale
1575      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1576     */ 
1577     function mintNFTDuringPresale(
1578         uint256 _numOfTokens
1579     ) 
1580         public 
1581         payable
1582     {
1583         require(isActive, 'Contract is not active');
1584         require(isPresaleActive, 'Only whiteing from White List');
1585         require(whiteList[msg.sender], 'You are not on the White List');
1586         require(totalSupply() < MAX_NFT_PUBLIC, 'All public tokens have been minted');
1587         require(_numOfTokens <= WHITELIST_MAX_MINT, 'Cannot purchase this many tokens');
1588         require(totalSupply().add(_numOfTokens).sub(giveawayCount) <= MAX_NFT_PUBLIC, 'Purchase would exceed max public supply of NFTs');
1589         require(whiteListClaimed[msg.sender].add(_numOfTokens) <= WHITELIST_MAX_MINT, 'Purchase exceeds max whiteed');
1590         require(NFTPrice.mul(_numOfTokens) == msg.value, "Ether value sent is not correct");
1591         for (uint256 i = 0; i < _numOfTokens; i++) {
1592             
1593             whiteListClaimed[msg.sender] += 1;
1594             _safeMint(msg.sender, totalSupply().sub(giveawayCount));
1595         }
1596     }
1597     
1598     /*
1599      * Function to mint all NFTs for giveaway and partnerships
1600     */
1601     function mintByOwner(
1602         address _to, 
1603         uint256 _tokenId
1604     ) 
1605         public 
1606         onlyOwner
1607     {
1608         require(_tokenId >= MAX_NFT_PUBLIC, "Tokens number to mint must exceed number of public tokens");
1609         require(_tokenId < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1610         _safeMint(_to, _tokenId);
1611         giveawayCount=giveawayCount.add(1);
1612     }
1613     
1614     /*
1615      * Function to mint all NFTs for giveaway and partnerships
1616     */
1617     function mintMultipleByOwner(
1618         address[] memory _to, 
1619         uint256[] memory _tokenId
1620     ) 
1621         public 
1622         onlyOwner
1623     {
1624         require(_to.length == _tokenId.length, "Should have same length");
1625         for(uint256 i = 0; i < _to.length; i++){
1626             require(_tokenId[i] >= MAX_NFT_PUBLIC, "Tokens number to mint must exceed number of public tokens");
1627             require(_tokenId[i] < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1628             _safeMint(_to[i], _tokenId[i]);
1629             giveawayCount = giveawayCount.add(1);
1630         }
1631     }
1632     
1633     /*
1634      * Function to get token URI of given token ID
1635      * URI will be blank untill totalSupply reaches MAX_NFT_PUBLIC
1636     */
1637     function tokenURI(
1638         uint256 _tokenId
1639     ) 
1640         public 
1641         view 
1642         virtual 
1643         override 
1644         returns (string memory) 
1645     {
1646         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1647         if (!reveal) {
1648             return string(abi.encodePacked(blindURI));
1649         } else {
1650             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1651         }
1652     }
1653     
1654     function supportsInterface(
1655         bytes4 _interfaceId
1656     ) 
1657         public
1658         view 
1659         override (ERC721, ERC721Enumerable) 
1660         returns (bool) 
1661     {
1662         return super.supportsInterface(_interfaceId);
1663     }
1664 
1665     // Standard functions to be overridden 
1666     function _beforeTokenTransfer(
1667         address _from, 
1668         address _to, 
1669         uint256 _tokenId
1670     ) 
1671         internal 
1672         override(ERC721, ERC721Enumerable) 
1673     {
1674         super._beforeTokenTransfer(_from, _to, _tokenId);
1675     }
1676 }