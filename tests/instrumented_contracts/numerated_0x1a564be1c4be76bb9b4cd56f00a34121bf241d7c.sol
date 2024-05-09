1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-19
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
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
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
169 pragma solidity ^0.8.0;
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
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Metadata is IERC721 {
201     /**
202      * @dev Returns the token collection name.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the token collection symbol.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
213      */
214     function tokenURI(uint256 tokenId) external view returns (string memory);
215 }
216 
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @dev Collection of functions related to the address type
222  */
223 library Address {
224     /**
225      * @dev Returns true if `account` is a contract.
226      *
227      * [IMPORTANT]
228      * ====
229      * It is unsafe to assume that an address for which this function returns
230      * false is an externally-owned account (EOA) and not a contract.
231      *
232      * Among others, `isContract` will return false for the following
233      * types of addresses:
234      *
235      *  - an externally-owned account
236      *  - a contract in construction
237      *  - an address where a contract will be created
238      *  - an address where a contract lived, but was destroyed
239      * ====
240      */
241     function isContract(address account) internal view returns (bool) {
242         // This method relies on extcodesize, which returns 0 for contracts in
243         // construction, since the code is only stored at the end of the
244         // constructor execution.
245 
246         uint256 size;
247         assembly {
248             size := extcodesize(account)
249         }
250         return size > 0;
251     }
252 
253     /**
254      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
255      * `recipient`, forwarding all available gas and reverting on errors.
256      *
257      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
258      * of certain opcodes, possibly making contracts go over the 2300 gas limit
259      * imposed by `transfer`, making them unable to receive funds via
260      * `transfer`. {sendValue} removes this limitation.
261      *
262      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
263      *
264      * IMPORTANT: because control is transferred to `recipient`, care must be
265      * taken to not create reentrancy vulnerabilities. Consider using
266      * {ReentrancyGuard} or the
267      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
268      */
269     function sendValue(address payable recipient, uint256 amount) internal {
270         require(address(this).balance >= amount, "Address: insufficient balance");
271 
272         (bool success, ) = recipient.call{value: amount}("");
273         require(success, "Address: unable to send value, recipient may have reverted");
274     }
275 
276     /**
277      * @dev Performs a Solidity function call using a low level `call`. A
278      * plain `call` is an unsafe replacement for a function call: use this
279      * function instead.
280      *
281      * If `target` reverts with a revert reason, it is bubbled up by this
282      * function (like regular Solidity function calls).
283      *
284      * Returns the raw returned data. To convert to the expected return value,
285      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
286      *
287      * Requirements:
288      *
289      * - `target` must be a contract.
290      * - calling `target` with `data` must not revert.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
295         return functionCall(target, data, "Address: low-level call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
300      * `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but also transferring `value` wei to `target`.
315      *
316      * Requirements:
317      *
318      * - the calling contract must have an ETH balance of at least `value`.
319      * - the called Solidity function must be `payable`.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333      * with `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         require(isContract(target), "Address: call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.call{value: value}(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
357         return functionStaticCall(target, data, "Address: low-level static call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal view returns (bytes memory) {
371         require(isContract(target), "Address: static call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.staticcall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(isContract(target), "Address: delegate call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.delegatecall(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
406      * revert reason using the provided one.
407      *
408      * _Available since v4.3._
409      */
410     function verifyCallResult(
411         bool success,
412         bytes memory returndata,
413         string memory errorMessage
414     ) internal pure returns (bytes memory) {
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421 
422                 assembly {
423                     let returndata_size := mload(returndata)
424                     revert(add(32, returndata), returndata_size)
425                 }
426             } else {
427                 revert(errorMessage);
428             }
429         }
430     }
431 }
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Provides information about the current execution context, including the
437  * sender of the transaction and its data. While these are generally available
438  * via msg.sender and msg.data, they should not be accessed in such a direct
439  * manner, since when dealing with meta-transactions the account sending and
440  * paying for execution may not be the actual sender (as far as an application
441  * is concerned).
442  *
443  * This contract is only required for intermediate, library-like contracts.
444  */
445 abstract contract Context {
446     function _msgSender() internal view virtual returns (address) {
447         return msg.sender;
448     }
449 
450     function _msgData() internal view virtual returns (bytes calldata) {
451         return msg.data;
452     }
453 }
454 
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev String operations.
460  */
461 library Strings {
462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
466      */
467     function toString(uint256 value) internal pure returns (string memory) {
468         // Inspired by OraclizeAPI's implementation - MIT licence
469         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
470 
471         if (value == 0) {
472             return "0";
473         }
474         uint256 temp = value;
475         uint256 digits;
476         while (temp != 0) {
477             digits++;
478             temp /= 10;
479         }
480         bytes memory buffer = new bytes(digits);
481         while (value != 0) {
482             digits -= 1;
483             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
484             value /= 10;
485         }
486         return string(buffer);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
491      */
492     function toHexString(uint256 value) internal pure returns (string memory) {
493         if (value == 0) {
494             return "0x00";
495         }
496         uint256 temp = value;
497         uint256 length = 0;
498         while (temp != 0) {
499             length++;
500             temp >>= 8;
501         }
502         return toHexString(value, length);
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
507      */
508     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
509         bytes memory buffer = new bytes(2 * length + 2);
510         buffer[0] = "0";
511         buffer[1] = "x";
512         for (uint256 i = 2 * length + 1; i > 1; --i) {
513             buffer[i] = _HEX_SYMBOLS[value & 0xf];
514             value >>= 4;
515         }
516         require(value == 0, "Strings: hex length insufficient");
517         return string(buffer);
518     }
519 }
520 
521 /**
522  * @dev Implementation of the {IERC165} interface.
523  *
524  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
525  * for the additional interface id that will be supported. For example:
526  *
527  * ```solidity
528  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
530  * }
531  * ```
532  *
533  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
534  */
535 abstract contract ERC165 is IERC165 {
536     /**
537      * @dev See {IERC165-supportsInterface}.
538      */
539     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540         return interfaceId == type(IERC165).interfaceId;
541     }
542 }
543 
544 
545 /**
546  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
547  * the Metadata extension, but not including the Enumerable extension, which is available separately as
548  * {ERC721Enumerable}.
549  */
550 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
551     using Address for address;
552     using Strings for uint256;
553 
554     // Token name
555     string private _name;
556 
557     // Token symbol
558     string private _symbol;
559 
560     // Mapping from token ID to owner address
561     mapping(uint256 => address) private _owners;
562 
563     // Mapping owner address to token count
564     mapping(address => uint256) private _balances;
565 
566     // Mapping from token ID to approved address
567     mapping(uint256 => address) private _tokenApprovals;
568 
569     // Mapping from owner to operator approvals
570     mapping(address => mapping(address => bool)) private _operatorApprovals;
571 
572     /**
573      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
574      */
575     constructor(string memory name_, string memory symbol_) {
576         _name = name_;
577         _symbol = symbol_;
578     }
579 
580     /**
581      * @dev See {IERC165-supportsInterface}.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
584         return
585             interfaceId == type(IERC721).interfaceId ||
586             interfaceId == type(IERC721Metadata).interfaceId ||
587             super.supportsInterface(interfaceId);
588     }
589 
590     /**
591      * @dev See {IERC721-balanceOf}.
592      */
593     function balanceOf(address owner) public view virtual override returns (uint256) {
594         require(owner != address(0), "ERC721: balance query for the zero address");
595         return _balances[owner];
596     }
597 
598     /**
599      * @dev See {IERC721-ownerOf}.
600      */
601     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
602         address owner = _owners[tokenId];
603         require(owner != address(0), "ERC721: owner query for nonexistent token");
604         return owner;
605     }
606 
607     /**
608      * @dev See {IERC721Metadata-name}.
609      */
610     function name() public view virtual override returns (string memory) {
611         return _name;
612     }
613 
614     /**
615      * @dev See {IERC721Metadata-symbol}.
616      */
617     function symbol() public view virtual override returns (string memory) {
618         return _symbol;
619     }
620 
621     /**
622      * @dev See {IERC721Metadata-tokenURI}.
623      */
624     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
625         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
626 
627         string memory baseURI = _baseURI();
628         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
629     }
630 
631     /**
632      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
633      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
634      * by default, can be overriden in child contracts.
635      */
636     function _baseURI() internal view virtual returns (string memory) {
637         return "";
638     }
639 
640     /**
641      * @dev See {IERC721-approve}.
642      */
643     function approve(address to, uint256 tokenId) public virtual override {
644         address owner = ERC721.ownerOf(tokenId);
645         require(to != owner, "ERC721: approval to current owner");
646 
647         require(
648             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
649             "ERC721: approve caller is not owner nor approved for all"
650         );
651 
652         _approve(to, tokenId);
653     }
654 
655     /**
656      * @dev See {IERC721-getApproved}.
657      */
658     function getApproved(uint256 tokenId) public view virtual override returns (address) {
659         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
660 
661         return _tokenApprovals[tokenId];
662     }
663 
664     /**
665      * @dev See {IERC721-setApprovalForAll}.
666      */
667     function setApprovalForAll(address operator, bool approved) public virtual override {
668         require(operator != _msgSender(), "ERC721: approve to caller");
669 
670         _operatorApprovals[_msgSender()][operator] = approved;
671         emit ApprovalForAll(_msgSender(), operator, approved);
672     }
673 
674     /**
675      * @dev See {IERC721-isApprovedForAll}.
676      */
677     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
678         return _operatorApprovals[owner][operator];
679     }
680 
681     /**
682      * @dev See {IERC721-transferFrom}.
683      */
684     function transferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) public virtual override {
689         //solhint-disable-next-line max-line-length
690         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
691 
692         _transfer(from, to, tokenId);
693     }
694 
695     /**
696      * @dev See {IERC721-safeTransferFrom}.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId
702     ) public virtual override {
703         safeTransferFrom(from, to, tokenId, "");
704     }
705 
706     /**
707      * @dev See {IERC721-safeTransferFrom}.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId,
713         bytes memory _data
714     ) public virtual override {
715         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
716         _safeTransfer(from, to, tokenId, _data);
717     }
718 
719     /**
720      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
721      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
722      *
723      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
724      *
725      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
726      * implement alternative mechanisms to perform token transfer, such as signature-based.
727      *
728      * Requirements:
729      *
730      * - `from` cannot be the zero address.
731      * - `to` cannot be the zero address.
732      * - `tokenId` token must exist and be owned by `from`.
733      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _safeTransfer(
738         address from,
739         address to,
740         uint256 tokenId,
741         bytes memory _data
742     ) internal virtual {
743         _transfer(from, to, tokenId);
744         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
745     }
746 
747     /**
748      * @dev Returns whether `tokenId` exists.
749      *
750      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
751      *
752      * Tokens start existing when they are minted (`_mint`),
753      * and stop existing when they are burned (`_burn`).
754      */
755     function _exists(uint256 tokenId) internal view virtual returns (bool) {
756         return _owners[tokenId] != address(0);
757     }
758 
759     /**
760      * @dev Returns whether `spender` is allowed to manage `tokenId`.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must exist.
765      */
766     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
767         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
768         address owner = ERC721.ownerOf(tokenId);
769         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
770     }
771 
772     /**
773      * @dev Safely mints `tokenId` and transfers it to `to`.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must not exist.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _safeMint(address to, uint256 tokenId) internal virtual {
783         _safeMint(to, tokenId, "");
784     }
785 
786     /**
787      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
788      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
789      */
790     function _safeMint(
791         address to,
792         uint256 tokenId,
793         bytes memory _data
794     ) internal virtual {
795         _mint(to, tokenId);
796         require(
797             _checkOnERC721Received(address(0), to, tokenId, _data),
798             "ERC721: transfer to non ERC721Receiver implementer"
799         );
800     }
801 
802     /**
803      * @dev Mints `tokenId` and transfers it to `to`.
804      *
805      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
806      *
807      * Requirements:
808      *
809      * - `tokenId` must not exist.
810      * - `to` cannot be the zero address.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _mint(address to, uint256 tokenId) internal virtual {
815         require(to != address(0), "ERC721: mint to the zero address");
816         require(!_exists(tokenId), "ERC721: token already minted");
817 
818         _beforeTokenTransfer(address(0), to, tokenId);
819 
820         _balances[to] += 1;
821         _owners[tokenId] = to;
822 
823         emit Transfer(address(0), to, tokenId);
824     }
825 
826     /**
827      * @dev Destroys `tokenId`.
828      * The approval is cleared when the token is burned.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must exist.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _burn(uint256 tokenId) internal virtual {
837         address owner = ERC721.ownerOf(tokenId);
838 
839         _beforeTokenTransfer(owner, address(0), tokenId);
840 
841         // Clear approvals
842         _approve(address(0), tokenId);
843 
844         _balances[owner] -= 1;
845         delete _owners[tokenId];
846 
847         emit Transfer(owner, address(0), tokenId);
848     }
849 
850     /**
851      * @dev Transfers `tokenId` from `from` to `to`.
852      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
853      *
854      * Requirements:
855      *
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must be owned by `from`.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _transfer(
862         address from,
863         address to,
864         uint256 tokenId
865     ) internal virtual {
866         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
867         require(to != address(0), "ERC721: transfer to the zero address");
868 
869         _beforeTokenTransfer(from, to, tokenId);
870 
871         // Clear approvals from the previous owner
872         _approve(address(0), tokenId);
873 
874         _balances[from] -= 1;
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(from, to, tokenId);
879     }
880 
881     /**
882      * @dev Approve `to` to operate on `tokenId`
883      *
884      * Emits a {Approval} event.
885      */
886     function _approve(address to, uint256 tokenId) internal virtual {
887         _tokenApprovals[tokenId] = to;
888         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
889     }
890 
891     /**
892      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
893      * The call is not executed if the target address is not a contract.
894      *
895      * @param from address representing the previous owner of the given token ID
896      * @param to target address that will receive the tokens
897      * @param tokenId uint256 ID of the token to be transferred
898      * @param _data bytes optional data to send along with the call
899      * @return bool whether the call correctly returned the expected magic value
900      */
901     function _checkOnERC721Received(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) private returns (bool) {
907         if (to.isContract()) {
908             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
909                 return retval == IERC721Receiver.onERC721Received.selector;
910             } catch (bytes memory reason) {
911                 if (reason.length == 0) {
912                     revert("ERC721: transfer to non ERC721Receiver implementer");
913                 } else {
914                     assembly {
915                         revert(add(32, reason), mload(reason))
916                     }
917                 }
918             }
919         } else {
920             return true;
921         }
922     }
923 
924     /**
925      * @dev Hook that is called before any token transfer. This includes minting
926      * and burning.
927      *
928      * Calling conditions:
929      *
930      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
931      * transferred to `to`.
932      * - When `from` is zero, `tokenId` will be minted for `to`.
933      * - When `to` is zero, ``from``'s `tokenId` will be burned.
934      * - `from` and `to` are never both zero.
935      *
936      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
937      */
938     function _beforeTokenTransfer(
939         address from,
940         address to,
941         uint256 tokenId
942     ) internal virtual {}
943 }
944 
945 /**
946  * @dev ERC721 token with storage based token URI management.
947  */
948 abstract contract ERC721URIStorage is ERC721 {
949     using Strings for uint256;
950 
951     // Optional mapping for token URIs
952     mapping(uint256 => string) private _tokenURIs;
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
958         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
959 
960         string memory _tokenURI = _tokenURIs[tokenId];
961         string memory base = _baseURI();
962 
963         // If there is no base URI, return the token URI.
964         if (bytes(base).length == 0) {
965             return _tokenURI;
966         }
967         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
968         if (bytes(_tokenURI).length > 0) {
969             return string(abi.encodePacked(base, _tokenURI));
970         }
971 
972         return super.tokenURI(tokenId);
973     }
974 
975     /**
976      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must exist.
981      */
982     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
983         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
984         _tokenURIs[tokenId] = _tokenURI;
985     }
986 
987     /**
988      * @dev Destroys `tokenId`.
989      * The approval is cleared when the token is burned.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _burn(uint256 tokenId) internal virtual override {
998         super._burn(tokenId);
999 
1000         if (bytes(_tokenURIs[tokenId]).length != 0) {
1001             delete _tokenURIs[tokenId];
1002         }
1003     }
1004 }
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 // CAUTION
1009 // This version of SafeMath should only be used with Solidity 0.8 or later,
1010 // because it relies on the compiler's built in overflow checks.
1011 
1012 /**
1013  * @dev Wrappers over Solidity's arithmetic operations.
1014  *
1015  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1016  * now has built in overflow checking.
1017  */
1018 library SafeMath {
1019     /**
1020      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1021      *
1022      * _Available since v3.4._
1023      */
1024     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1025         unchecked {
1026             uint256 c = a + b;
1027             if (c < a) return (false, 0);
1028             return (true, c);
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1034      *
1035      * _Available since v3.4._
1036      */
1037     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1038         unchecked {
1039             if (b > a) return (false, 0);
1040             return (true, a - b);
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1046      *
1047      * _Available since v3.4._
1048      */
1049     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1050         unchecked {
1051             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1052             // benefit is lost if 'b' is also tested.
1053             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1054             if (a == 0) return (true, 0);
1055             uint256 c = a * b;
1056             if (c / a != b) return (false, 0);
1057             return (true, c);
1058         }
1059     }
1060 
1061     /**
1062      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1063      *
1064      * _Available since v3.4._
1065      */
1066     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1067         unchecked {
1068             if (b == 0) return (false, 0);
1069             return (true, a / b);
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1075      *
1076      * _Available since v3.4._
1077      */
1078     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1079         unchecked {
1080             if (b == 0) return (false, 0);
1081             return (true, a % b);
1082         }
1083     }
1084 
1085     /**
1086      * @dev Returns the addition of two unsigned integers, reverting on
1087      * overflow.
1088      *
1089      * Counterpart to Solidity's `+` operator.
1090      *
1091      * Requirements:
1092      *
1093      * - Addition cannot overflow.
1094      */
1095     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1096         return a + b;
1097     }
1098 
1099     /**
1100      * @dev Returns the subtraction of two unsigned integers, reverting on
1101      * overflow (when the result is negative).
1102      *
1103      * Counterpart to Solidity's `-` operator.
1104      *
1105      * Requirements:
1106      *
1107      * - Subtraction cannot overflow.
1108      */
1109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1110         return a - b;
1111     }
1112 
1113     /**
1114      * @dev Returns the multiplication of two unsigned integers, reverting on
1115      * overflow.
1116      *
1117      * Counterpart to Solidity's `*` operator.
1118      *
1119      * Requirements:
1120      *
1121      * - Multiplication cannot overflow.
1122      */
1123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1124         return a * b;
1125     }
1126 
1127     /**
1128      * @dev Returns the integer division of two unsigned integers, reverting on
1129      * division by zero. The result is rounded towards zero.
1130      *
1131      * Counterpart to Solidity's `/` operator.
1132      *
1133      * Requirements:
1134      *
1135      * - The divisor cannot be zero.
1136      */
1137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1138         return a / b;
1139     }
1140 
1141     /**
1142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1143      * reverting when dividing by zero.
1144      *
1145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1146      * opcode (which leaves remaining gas untouched) while Solidity uses an
1147      * invalid opcode to revert (consuming all remaining gas).
1148      *
1149      * Requirements:
1150      *
1151      * - The divisor cannot be zero.
1152      */
1153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1154         return a % b;
1155     }
1156 
1157     /**
1158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1159      * overflow (when the result is negative).
1160      *
1161      * CAUTION: This function is deprecated because it requires allocating memory for the error
1162      * message unnecessarily. For custom revert reasons use {trySub}.
1163      *
1164      * Counterpart to Solidity's `-` operator.
1165      *
1166      * Requirements:
1167      *
1168      * - Subtraction cannot overflow.
1169      */
1170     function sub(
1171         uint256 a,
1172         uint256 b,
1173         string memory errorMessage
1174     ) internal pure returns (uint256) {
1175         unchecked {
1176             require(b <= a, errorMessage);
1177             return a - b;
1178         }
1179     }
1180 
1181     /**
1182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1183      * division by zero. The result is rounded towards zero.
1184      *
1185      * Counterpart to Solidity's `/` operator. Note: this function uses a
1186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1187      * uses an invalid opcode to revert (consuming all remaining gas).
1188      *
1189      * Requirements:
1190      *
1191      * - The divisor cannot be zero.
1192      */
1193     function div(
1194         uint256 a,
1195         uint256 b,
1196         string memory errorMessage
1197     ) internal pure returns (uint256) {
1198         unchecked {
1199             require(b > 0, errorMessage);
1200             return a / b;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1206      * reverting with custom message when dividing by zero.
1207      *
1208      * CAUTION: This function is deprecated because it requires allocating memory for the error
1209      * message unnecessarily. For custom revert reasons use {tryMod}.
1210      *
1211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1212      * opcode (which leaves remaining gas untouched) while Solidity uses an
1213      * invalid opcode to revert (consuming all remaining gas).
1214      *
1215      * Requirements:
1216      *
1217      * - The divisor cannot be zero.
1218      */
1219     function mod(
1220         uint256 a,
1221         uint256 b,
1222         string memory errorMessage
1223     ) internal pure returns (uint256) {
1224         unchecked {
1225             require(b > 0, errorMessage);
1226             return a % b;
1227         }
1228     }
1229 }
1230 
1231 
1232 pragma solidity ^0.8.0;
1233 
1234 /**
1235  * @title Counters
1236  * @author Matt Condon (@shrugs)
1237  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1238  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1239  *
1240  * Include with `using Counters for Counters.Counter;`
1241  */
1242 library Counters {
1243     struct Counter {
1244         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1245         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1246         // this feature: see https://github.com/ethereum/solidity/issues/4637
1247         uint256 _value; // default: 0
1248     }
1249 
1250     function current(Counter storage counter) internal view returns (uint256) {
1251         return counter._value;
1252     }
1253 
1254     function increment(Counter storage counter) internal {
1255         unchecked {
1256             counter._value += 1;
1257         }
1258     }
1259 
1260     function decrement(Counter storage counter) internal {
1261         uint256 value = counter._value;
1262         require(value > 0, "Counter: decrement overflow");
1263         unchecked {
1264             counter._value = value - 1;
1265         }
1266     }
1267 
1268     function reset(Counter storage counter) internal {
1269         counter._value = 0;
1270     }
1271 }
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 /**
1276  * @dev Contract module which provides a basic access control mechanism, where
1277  * there is an account (an owner) that can be granted exclusive access to
1278  * specific functions.
1279  *
1280  * By default, the owner account will be the one that deploys the contract. This
1281  * can later be changed with {transferOwnership}.
1282  *
1283  * This module is used through inheritance. It will make available the modifier
1284  * `onlyOwner`, which can be applied to your functions to restrict their use to
1285  * the owner.
1286  */
1287 abstract contract Ownable is Context {
1288     address private _owner;
1289 
1290     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1291 
1292     /**
1293      * @dev Initializes the contract setting the deployer as the initial owner.
1294      */
1295     constructor() {
1296         _setOwner(_msgSender());
1297     }
1298 
1299     /**
1300      * @dev Returns the address of the current owner.
1301      */
1302     function owner() public view virtual returns (address) {
1303         return _owner;
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Leaves the contract without owner. It will not be possible to call
1316      * `onlyOwner` functions anymore. Can only be called by the current owner.
1317      *
1318      * NOTE: Renouncing ownership will leave the contract without an owner,
1319      * thereby removing any functionality that is only available to the owner.
1320      */
1321     function renounceOwnership() public virtual onlyOwner {
1322         _setOwner(address(0));
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Can only be called by the current owner.
1328      */
1329     function transferOwnership(address newOwner) public virtual onlyOwner {
1330         require(newOwner != address(0), "Ownable: new owner is the zero address");
1331         _setOwner(newOwner);
1332     }
1333 
1334     function _setOwner(address newOwner) private {
1335         address oldOwner = _owner;
1336         _owner = newOwner;
1337         emit OwnershipTransferred(oldOwner, newOwner);
1338     }
1339 }
1340 
1341 
1342 pragma solidity >= 0.4.22 <0.9.0;
1343 
1344 library console {
1345 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1346 
1347 	function _sendLogPayload(bytes memory payload) private view {
1348 		uint256 payloadLength = payload.length;
1349 		address consoleAddress = CONSOLE_ADDRESS;
1350 		assembly {
1351 			let payloadStart := add(payload, 32)
1352 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1353 		}
1354 	}
1355 
1356 	function log() internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log()"));
1358 	}
1359 
1360 	function logInt(int p0) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1362 	}
1363 
1364 	function logUint(uint p0) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1366 	}
1367 
1368 	function logString(string memory p0) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1370 	}
1371 
1372 	function logBool(bool p0) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1374 	}
1375 
1376 	function logAddress(address p0) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1378 	}
1379 
1380 	function logBytes(bytes memory p0) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1382 	}
1383 
1384 	function logBytes1(bytes1 p0) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1386 	}
1387 
1388 	function logBytes2(bytes2 p0) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1390 	}
1391 
1392 	function logBytes3(bytes3 p0) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1394 	}
1395 
1396 	function logBytes4(bytes4 p0) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1398 	}
1399 
1400 	function logBytes5(bytes5 p0) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1402 	}
1403 
1404 	function logBytes6(bytes6 p0) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1406 	}
1407 
1408 	function logBytes7(bytes7 p0) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1410 	}
1411 
1412 	function logBytes8(bytes8 p0) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1414 	}
1415 
1416 	function logBytes9(bytes9 p0) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1418 	}
1419 
1420 	function logBytes10(bytes10 p0) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1422 	}
1423 
1424 	function logBytes11(bytes11 p0) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1426 	}
1427 
1428 	function logBytes12(bytes12 p0) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1430 	}
1431 
1432 	function logBytes13(bytes13 p0) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1434 	}
1435 
1436 	function logBytes14(bytes14 p0) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1438 	}
1439 
1440 	function logBytes15(bytes15 p0) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1442 	}
1443 
1444 	function logBytes16(bytes16 p0) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1446 	}
1447 
1448 	function logBytes17(bytes17 p0) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1450 	}
1451 
1452 	function logBytes18(bytes18 p0) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1454 	}
1455 
1456 	function logBytes19(bytes19 p0) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1458 	}
1459 
1460 	function logBytes20(bytes20 p0) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1462 	}
1463 
1464 	function logBytes21(bytes21 p0) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1466 	}
1467 
1468 	function logBytes22(bytes22 p0) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1470 	}
1471 
1472 	function logBytes23(bytes23 p0) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1474 	}
1475 
1476 	function logBytes24(bytes24 p0) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1478 	}
1479 
1480 	function logBytes25(bytes25 p0) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1482 	}
1483 
1484 	function logBytes26(bytes26 p0) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1486 	}
1487 
1488 	function logBytes27(bytes27 p0) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1490 	}
1491 
1492 	function logBytes28(bytes28 p0) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1494 	}
1495 
1496 	function logBytes29(bytes29 p0) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1498 	}
1499 
1500 	function logBytes30(bytes30 p0) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1502 	}
1503 
1504 	function logBytes31(bytes31 p0) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1506 	}
1507 
1508 	function logBytes32(bytes32 p0) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1510 	}
1511 
1512 	function log(uint p0) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1514 	}
1515 
1516 	function log(string memory p0) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1518 	}
1519 
1520 	function log(bool p0) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1522 	}
1523 
1524 	function log(address p0) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1526 	}
1527 
1528 	function log(uint p0, uint p1) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1530 	}
1531 
1532 	function log(uint p0, string memory p1) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1534 	}
1535 
1536 	function log(uint p0, bool p1) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1538 	}
1539 
1540 	function log(uint p0, address p1) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1542 	}
1543 
1544 	function log(string memory p0, uint p1) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1546 	}
1547 
1548 	function log(string memory p0, string memory p1) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1550 	}
1551 
1552 	function log(string memory p0, bool p1) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1554 	}
1555 
1556 	function log(string memory p0, address p1) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1558 	}
1559 
1560 	function log(bool p0, uint p1) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1562 	}
1563 
1564 	function log(bool p0, string memory p1) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1566 	}
1567 
1568 	function log(bool p0, bool p1) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1570 	}
1571 
1572 	function log(bool p0, address p1) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1574 	}
1575 
1576 	function log(address p0, uint p1) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1578 	}
1579 
1580 	function log(address p0, string memory p1) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1582 	}
1583 
1584 	function log(address p0, bool p1) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1586 	}
1587 
1588 	function log(address p0, address p1) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1590 	}
1591 
1592 	function log(uint p0, uint p1, uint p2) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1594 	}
1595 
1596 	function log(uint p0, uint p1, string memory p2) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1598 	}
1599 
1600 	function log(uint p0, uint p1, bool p2) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1602 	}
1603 
1604 	function log(uint p0, uint p1, address p2) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1606 	}
1607 
1608 	function log(uint p0, string memory p1, uint p2) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1610 	}
1611 
1612 	function log(uint p0, string memory p1, string memory p2) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1614 	}
1615 
1616 	function log(uint p0, string memory p1, bool p2) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1618 	}
1619 
1620 	function log(uint p0, string memory p1, address p2) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1622 	}
1623 
1624 	function log(uint p0, bool p1, uint p2) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1626 	}
1627 
1628 	function log(uint p0, bool p1, string memory p2) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1630 	}
1631 
1632 	function log(uint p0, bool p1, bool p2) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1634 	}
1635 
1636 	function log(uint p0, bool p1, address p2) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1638 	}
1639 
1640 	function log(uint p0, address p1, uint p2) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1642 	}
1643 
1644 	function log(uint p0, address p1, string memory p2) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1646 	}
1647 
1648 	function log(uint p0, address p1, bool p2) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1650 	}
1651 
1652 	function log(uint p0, address p1, address p2) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1654 	}
1655 
1656 	function log(string memory p0, uint p1, uint p2) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1658 	}
1659 
1660 	function log(string memory p0, uint p1, string memory p2) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1662 	}
1663 
1664 	function log(string memory p0, uint p1, bool p2) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1666 	}
1667 
1668 	function log(string memory p0, uint p1, address p2) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1670 	}
1671 
1672 	function log(string memory p0, string memory p1, uint p2) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1674 	}
1675 
1676 	function log(string memory p0, string memory p1, string memory p2) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1678 	}
1679 
1680 	function log(string memory p0, string memory p1, bool p2) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1682 	}
1683 
1684 	function log(string memory p0, string memory p1, address p2) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1686 	}
1687 
1688 	function log(string memory p0, bool p1, uint p2) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1690 	}
1691 
1692 	function log(string memory p0, bool p1, string memory p2) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1694 	}
1695 
1696 	function log(string memory p0, bool p1, bool p2) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1698 	}
1699 
1700 	function log(string memory p0, bool p1, address p2) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1702 	}
1703 
1704 	function log(string memory p0, address p1, uint p2) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1706 	}
1707 
1708 	function log(string memory p0, address p1, string memory p2) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1710 	}
1711 
1712 	function log(string memory p0, address p1, bool p2) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1714 	}
1715 
1716 	function log(string memory p0, address p1, address p2) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1718 	}
1719 
1720 	function log(bool p0, uint p1, uint p2) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1722 	}
1723 
1724 	function log(bool p0, uint p1, string memory p2) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1726 	}
1727 
1728 	function log(bool p0, uint p1, bool p2) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1730 	}
1731 
1732 	function log(bool p0, uint p1, address p2) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1734 	}
1735 
1736 	function log(bool p0, string memory p1, uint p2) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1738 	}
1739 
1740 	function log(bool p0, string memory p1, string memory p2) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1742 	}
1743 
1744 	function log(bool p0, string memory p1, bool p2) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1746 	}
1747 
1748 	function log(bool p0, string memory p1, address p2) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1750 	}
1751 
1752 	function log(bool p0, bool p1, uint p2) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1754 	}
1755 
1756 	function log(bool p0, bool p1, string memory p2) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1758 	}
1759 
1760 	function log(bool p0, bool p1, bool p2) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1762 	}
1763 
1764 	function log(bool p0, bool p1, address p2) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1766 	}
1767 
1768 	function log(bool p0, address p1, uint p2) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1770 	}
1771 
1772 	function log(bool p0, address p1, string memory p2) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1774 	}
1775 
1776 	function log(bool p0, address p1, bool p2) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1778 	}
1779 
1780 	function log(bool p0, address p1, address p2) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1782 	}
1783 
1784 	function log(address p0, uint p1, uint p2) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1786 	}
1787 
1788 	function log(address p0, uint p1, string memory p2) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1790 	}
1791 
1792 	function log(address p0, uint p1, bool p2) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1794 	}
1795 
1796 	function log(address p0, uint p1, address p2) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1798 	}
1799 
1800 	function log(address p0, string memory p1, uint p2) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1802 	}
1803 
1804 	function log(address p0, string memory p1, string memory p2) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1806 	}
1807 
1808 	function log(address p0, string memory p1, bool p2) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1810 	}
1811 
1812 	function log(address p0, string memory p1, address p2) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1814 	}
1815 
1816 	function log(address p0, bool p1, uint p2) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1818 	}
1819 
1820 	function log(address p0, bool p1, string memory p2) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1822 	}
1823 
1824 	function log(address p0, bool p1, bool p2) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1826 	}
1827 
1828 	function log(address p0, bool p1, address p2) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1830 	}
1831 
1832 	function log(address p0, address p1, uint p2) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1834 	}
1835 
1836 	function log(address p0, address p1, string memory p2) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1838 	}
1839 
1840 	function log(address p0, address p1, bool p2) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1842 	}
1843 
1844 	function log(address p0, address p1, address p2) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1846 	}
1847 
1848 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1850 	}
1851 
1852 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1854 	}
1855 
1856 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1858 	}
1859 
1860 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1862 	}
1863 
1864 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1866 	}
1867 
1868 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1870 	}
1871 
1872 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1874 	}
1875 
1876 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1878 	}
1879 
1880 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1882 	}
1883 
1884 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1886 	}
1887 
1888 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1890 	}
1891 
1892 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1894 	}
1895 
1896 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1898 	}
1899 
1900 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1902 	}
1903 
1904 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1906 	}
1907 
1908 	function log(uint p0, uint p1, address p2, address p3) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1910 	}
1911 
1912 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1914 	}
1915 
1916 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1918 	}
1919 
1920 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1922 	}
1923 
1924 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1926 	}
1927 
1928 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1930 	}
1931 
1932 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1934 	}
1935 
1936 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1938 	}
1939 
1940 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1942 	}
1943 
1944 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1946 	}
1947 
1948 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1950 	}
1951 
1952 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1954 	}
1955 
1956 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1958 	}
1959 
1960 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1962 	}
1963 
1964 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1966 	}
1967 
1968 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1970 	}
1971 
1972 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1974 	}
1975 
1976 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1978 	}
1979 
1980 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1982 	}
1983 
1984 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1986 	}
1987 
1988 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1990 	}
1991 
1992 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1994 	}
1995 
1996 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1998 	}
1999 
2000 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2002 	}
2003 
2004 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2006 	}
2007 
2008 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2010 	}
2011 
2012 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2014 	}
2015 
2016 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2018 	}
2019 
2020 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2022 	}
2023 
2024 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2026 	}
2027 
2028 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2030 	}
2031 
2032 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2034 	}
2035 
2036 	function log(uint p0, bool p1, address p2, address p3) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2038 	}
2039 
2040 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2042 	}
2043 
2044 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2046 	}
2047 
2048 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2050 	}
2051 
2052 	function log(uint p0, address p1, uint p2, address p3) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2054 	}
2055 
2056 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2058 	}
2059 
2060 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2062 	}
2063 
2064 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2066 	}
2067 
2068 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2070 	}
2071 
2072 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2074 	}
2075 
2076 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2078 	}
2079 
2080 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2082 	}
2083 
2084 	function log(uint p0, address p1, bool p2, address p3) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2086 	}
2087 
2088 	function log(uint p0, address p1, address p2, uint p3) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2090 	}
2091 
2092 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2094 	}
2095 
2096 	function log(uint p0, address p1, address p2, bool p3) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2098 	}
2099 
2100 	function log(uint p0, address p1, address p2, address p3) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2102 	}
2103 
2104 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2106 	}
2107 
2108 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2110 	}
2111 
2112 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2114 	}
2115 
2116 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2118 	}
2119 
2120 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2122 	}
2123 
2124 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2126 	}
2127 
2128 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2130 	}
2131 
2132 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2134 	}
2135 
2136 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2138 	}
2139 
2140 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2142 	}
2143 
2144 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2146 	}
2147 
2148 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2150 	}
2151 
2152 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(string memory p0, address p1, address p2, address p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2374 	}
2375 
2376 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2378 	}
2379 
2380 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2394 	}
2395 
2396 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2398 	}
2399 
2400 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2402 	}
2403 
2404 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2406 	}
2407 
2408 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2410 	}
2411 
2412 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2414 	}
2415 
2416 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2418 	}
2419 
2420 	function log(bool p0, uint p1, address p2, address p3) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2422 	}
2423 
2424 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2426 	}
2427 
2428 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2430 	}
2431 
2432 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2434 	}
2435 
2436 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2438 	}
2439 
2440 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2442 	}
2443 
2444 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2446 	}
2447 
2448 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2450 	}
2451 
2452 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2454 	}
2455 
2456 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2458 	}
2459 
2460 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2462 	}
2463 
2464 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2466 	}
2467 
2468 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2470 	}
2471 
2472 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2474 	}
2475 
2476 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2478 	}
2479 
2480 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2482 	}
2483 
2484 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2486 	}
2487 
2488 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2490 	}
2491 
2492 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2494 	}
2495 
2496 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2498 	}
2499 
2500 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2502 	}
2503 
2504 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2506 	}
2507 
2508 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2510 	}
2511 
2512 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2514 	}
2515 
2516 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2518 	}
2519 
2520 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2522 	}
2523 
2524 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2526 	}
2527 
2528 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2530 	}
2531 
2532 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2534 	}
2535 
2536 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2538 	}
2539 
2540 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2542 	}
2543 
2544 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2546 	}
2547 
2548 	function log(bool p0, bool p1, address p2, address p3) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2550 	}
2551 
2552 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2554 	}
2555 
2556 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2558 	}
2559 
2560 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2562 	}
2563 
2564 	function log(bool p0, address p1, uint p2, address p3) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2566 	}
2567 
2568 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2570 	}
2571 
2572 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2574 	}
2575 
2576 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2578 	}
2579 
2580 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2582 	}
2583 
2584 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(bool p0, address p1, bool p2, address p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(bool p0, address p1, address p2, uint p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(bool p0, address p1, address p2, bool p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(bool p0, address p1, address p2, address p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(address p0, uint p1, uint p2, address p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(address p0, uint p1, bool p2, address p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(address p0, uint p1, address p2, uint p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(address p0, uint p1, address p2, bool p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(address p0, uint p1, address p2, address p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2698 	}
2699 
2700 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2701 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2702 	}
2703 
2704 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2705 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2706 	}
2707 
2708 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2709 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2710 	}
2711 
2712 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2713 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2714 	}
2715 
2716 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2717 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2718 	}
2719 
2720 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2721 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2722 	}
2723 
2724 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2725 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2726 	}
2727 
2728 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2729 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2730 	}
2731 
2732 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2733 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2734 	}
2735 
2736 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2737 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2738 	}
2739 
2740 	function log(address p0, string memory p1, address p2, address p3) internal view {
2741 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2742 	}
2743 
2744 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2745 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2746 	}
2747 
2748 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2749 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2750 	}
2751 
2752 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2753 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2754 	}
2755 
2756 	function log(address p0, bool p1, uint p2, address p3) internal view {
2757 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2758 	}
2759 
2760 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2761 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2762 	}
2763 
2764 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2765 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2766 	}
2767 
2768 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2769 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2770 	}
2771 
2772 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2773 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2774 	}
2775 
2776 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2777 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2778 	}
2779 
2780 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2781 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2782 	}
2783 
2784 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2785 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2786 	}
2787 
2788 	function log(address p0, bool p1, bool p2, address p3) internal view {
2789 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2790 	}
2791 
2792 	function log(address p0, bool p1, address p2, uint p3) internal view {
2793 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2794 	}
2795 
2796 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2797 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2798 	}
2799 
2800 	function log(address p0, bool p1, address p2, bool p3) internal view {
2801 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2802 	}
2803 
2804 	function log(address p0, bool p1, address p2, address p3) internal view {
2805 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2806 	}
2807 
2808 	function log(address p0, address p1, uint p2, uint p3) internal view {
2809 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2810 	}
2811 
2812 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2813 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2814 	}
2815 
2816 	function log(address p0, address p1, uint p2, bool p3) internal view {
2817 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2818 	}
2819 
2820 	function log(address p0, address p1, uint p2, address p3) internal view {
2821 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2822 	}
2823 
2824 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2825 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2826 	}
2827 
2828 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2829 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2830 	}
2831 
2832 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2833 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2834 	}
2835 
2836 	function log(address p0, address p1, string memory p2, address p3) internal view {
2837 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2838 	}
2839 
2840 	function log(address p0, address p1, bool p2, uint p3) internal view {
2841 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2842 	}
2843 
2844 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2845 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2846 	}
2847 
2848 	function log(address p0, address p1, bool p2, bool p3) internal view {
2849 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2850 	}
2851 
2852 	function log(address p0, address p1, bool p2, address p3) internal view {
2853 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2854 	}
2855 
2856 	function log(address p0, address p1, address p2, uint p3) internal view {
2857 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2858 	}
2859 
2860 	function log(address p0, address p1, address p2, string memory p3) internal view {
2861 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2862 	}
2863 
2864 	function log(address p0, address p1, address p2, bool p3) internal view {
2865 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2866 	}
2867 
2868 	function log(address p0, address p1, address p2, address p3) internal view {
2869 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2870 	}
2871 
2872 }
2873 
2874 pragma solidity ^0.8.4;
2875 
2876 contract SweetyardDog is ERC721URIStorage, Ownable {
2877     using SafeMath for uint256;
2878 
2879     string private baseURI;
2880     uint256 private constant Supply = 10000;
2881     uint256 private constant TOKEN_LIMIT = 9750;
2882     
2883     uint256 private Once_Max_Mint = 10;
2884     uint256 public constant shareValue = 500;
2885     
2886     address private constant TECH_ADDRESS = 0x6Fd792cbfc83aCCDfadBc41dFA6e1C7783F2af98;
2887     uint256 private constant TECH_FEE_PERCENT = 5;
2888     
2889     address private constant CREATOR_ADDRESS = 0xc714c774a86f87721Bbe78b7Cd5F49a543abe975;
2890     uint256 private constant CREATOR_FEE_PERCENT = 50;
2891     
2892     address private constant SHARE_ADDRESS = 0x69b40b7Eb1FA0601b2E9A68fcDE1899d0Ef177E3;
2893     uint256 private constant SHARE_FEE_PERCENT = 40;
2894     
2895     uint256 public fee;
2896 
2897     uint256[] private first_generation_tokenIds;
2898     uint256[] private gift_generation_tokenIds;
2899 
2900     uint256[TOKEN_LIMIT] private indices;
2901     uint256 private nonce;
2902 
2903     mapping(address=>bool) public whiteList;
2904 
2905     bool private isStart;
2906      
2907     event MintMulti(address indexed user, uint256[] tokenIds);
2908     event MintOne(address indexed user, uint256 tokenId);
2909     event MintOneOfOwner(address indexed user, uint256 len);
2910 
2911     constructor(uint256 _fee) ERC721("Sweetyard Dogs", "SYD") {
2912         fee = _fee;
2913         isStart = false;
2914     }
2915 
2916     function mint(uint256 _quantity) external payable returns (uint256[] memory) {
2917         require(_quantity > 0,"error: min quantity 1");
2918         require(_quantity <= Once_Max_Mint,"error: max quantity");
2919 
2920         require(
2921             first_generation_tokenIds.length + _quantity <= TOKEN_LIMIT,
2922             "error: out of stock"
2923         );
2924 
2925         require(isStart == true || whiteList[msg.sender] == true,"error: not start");
2926 
2927         uint256[] memory ids = new uint256[](_quantity);
2928         if(isStart == true || whiteList[msg.sender] == true){
2929             uint total =  fee.mul(_quantity);
2930             require(msg.value == total, "error: fee value");
2931             uint256 creator ;
2932             uint newTotal;
2933             
2934             if(first_generation_tokenIds.length<shareValue && first_generation_tokenIds.length.add(_quantity)>shareValue){
2935                 // creator & share
2936                 uint shareQuantity = first_generation_tokenIds.length.add(_quantity).sub(shareValue);
2937                 newTotal = fee.mul(shareQuantity);
2938                 payShare(newTotal);
2939 
2940                 creator = total.sub(newTotal);
2941                 payInternal(creator);
2942 
2943             }else if(first_generation_tokenIds.length.add(_quantity)<=shareValue){
2944                 // creator
2945                 newTotal = 0;
2946                 creator = total;
2947                 payInternal(creator);
2948             }else {
2949                 // share
2950                 newTotal = total;
2951                 creator=0;
2952                  payShare(newTotal);
2953             }
2954            
2955             for (uint256 index = 0; index < _quantity; index++) {
2956                 uint256 tokenId = _random();
2957                 _safeMint(address(msg.sender), tokenId);
2958                 first_generation_tokenIds.push(tokenId);
2959                 ids[index] = tokenId;
2960             }
2961             
2962             emit MintMulti(msg.sender, ids);
2963           
2964         }
2965         return ids;
2966     }
2967 
2968     function payInternal(uint total) internal {
2969         uint256 tech = total.mul(TECH_FEE_PERCENT).div(100);
2970         uint256 creator = total.sub(tech);
2971 
2972         (bool techBo,) = payable(TECH_ADDRESS).call{
2973             value: tech
2974         }("");
2975         require(techBo, "Failed to send Eth");
2976 
2977         (bool creatorBo,) = payable(CREATOR_ADDRESS).call{
2978             value: creator
2979         }("");
2980         require(creatorBo, "Failed to send Eth");
2981     }
2982 
2983     function payShare(uint total) internal {
2984             uint256 tech = total.mul(TECH_FEE_PERCENT).div(100);
2985             uint256 creator = total.mul(CREATOR_FEE_PERCENT).div(100);
2986             uint256 share = total.mul(SHARE_FEE_PERCENT).div(100);
2987             uint256 proj = total.sub(tech).sub(creator).sub(share);
2988              require(proj>0, "error: payEnable");
2989 
2990             (bool techBo,) = payable(TECH_ADDRESS).call{
2991                 value: tech
2992             }("");
2993             require(techBo, "Failed to send Eth");
2994             
2995             (bool creatorBo,) = payable(CREATOR_ADDRESS).call{
2996                 value: creator
2997             }("");
2998             require(creatorBo, "Failed to send Eth");
2999 
3000              (bool shareBo,) = payable(SHARE_ADDRESS).call{
3001                 value: share
3002             }("");
3003             require(shareBo, "Failed to send Eth");
3004 
3005             (bool projBo,) = payable(address(this)).call{
3006                 value: proj
3007             }("");
3008             require(projBo, "Failed to send Eth");
3009     }
3010 
3011     function mintOfOwner(address _to, uint256 _tokenId) external onlyOwner {
3012         require(_tokenId > TOKEN_LIMIT, "error: tokenId or gift_min_id ");
3013         require(_tokenId <= Supply, "error: tokenId or gift_max_id");
3014         require(
3015             gift_generation_tokenIds.length < Supply - TOKEN_LIMIT,
3016             "out of stock"
3017         );
3018 
3019         uint256 tokenId = _tokenId;
3020         _safeMint(address(_to), tokenId);
3021         gift_generation_tokenIds.push(tokenId);
3022         emit MintOne(_to, tokenId);
3023     }
3024 
3025     function mintMulOfOwner(address _to, uint256[] memory _tokenIds) external onlyOwner {
3026         // require(_tokenIds.length <= Once_Max_Mint, "error: max quantity");
3027         for (uint256 index = 0; index < _tokenIds.length; index++) {
3028             uint256 _tokenId = _tokenIds[index];
3029             require(_tokenId > TOKEN_LIMIT, "error: tokenId or gift_min_id ");
3030             require(_tokenId <= Supply, "error: tokenId or gift_max_id");
3031             require(
3032                 gift_generation_tokenIds.length < Supply - TOKEN_LIMIT,
3033                 "out of stock"
3034             );
3035 
3036             uint256 tokenId = _tokenId;
3037             _safeMint(address(_to), tokenId);
3038             gift_generation_tokenIds.push(tokenId);
3039         }
3040         emit MintOneOfOwner(_to, _tokenIds.length);
3041     }
3042 
3043     function setStart(bool _start) external onlyOwner {
3044         isStart = _start;
3045     }
3046 
3047     function setFee(uint _fee) external onlyOwner {
3048         fee = _fee;
3049     }
3050     
3051     function setOnceMaxMint(uint _value) external onlyOwner {
3052         Once_Max_Mint = _value;
3053     }
3054 
3055     function addWhiteList(address[]memory _addr) external onlyOwner {
3056         for (uint256 index = 0; index < _addr.length; index++) {
3057             whiteList[_addr[index]] = true;
3058         }
3059     }
3060 
3061     function rmWhiteList(address[]memory _addr) external onlyOwner {
3062         for (uint256 index = 0; index < _addr.length; index++) {
3063             whiteList[_addr[index]] = false;
3064         }
3065     }
3066 
3067     function setBaseURI(string memory _uri) external onlyOwner {
3068         baseURI = _uri;
3069     }
3070 
3071     function _random() internal returns (uint256) {
3072         uint256 totalSize = TOKEN_LIMIT - nonce;
3073         uint256 index = uint256(
3074             keccak256(
3075                 abi.encodePacked(
3076                     nonce,
3077                     msg.sender,
3078                     block.difficulty,
3079                     block.timestamp
3080                 )
3081             )
3082         ) % totalSize;
3083         uint256 value = 0;
3084         if (indices[index] != 0) {
3085             value = indices[index];
3086         } else {
3087             value = index;
3088         }
3089 
3090         // Move last value to selected position
3091         if (indices[totalSize - 1] == 0) {
3092             // Array position not initialized, so use position
3093             indices[index] = totalSize - 1;
3094         } else {
3095             // Array position holds a value so use that
3096             indices[index] = indices[totalSize - 1];
3097         }
3098         nonce++;
3099         // Don't allow a zero index, start counting at 1
3100         return value + 1;
3101     }
3102 
3103     function getBalance() public view returns (uint256) {
3104         return address(this).balance;
3105     }
3106 
3107     function withdraw() external onlyOwner {
3108         require(address(this).balance > 0, "balance zero");
3109         payable(owner()).transfer(address(this).balance);
3110     }
3111 
3112     function tokenIdsLength() external view returns(uint256){
3113         return first_generation_tokenIds.length + gift_generation_tokenIds.length;
3114     }
3115 
3116     function firstIdsLength() external view returns(uint256){
3117         return first_generation_tokenIds.length;
3118     }
3119 
3120     function totalSupply() public pure returns(uint256){
3121         return Supply;
3122     }
3123 
3124     function _baseURI() internal view override returns (string memory) {
3125         return baseURI;
3126     }
3127 
3128     receive() external payable {}
3129 
3130     fallback() external payable {}
3131 }