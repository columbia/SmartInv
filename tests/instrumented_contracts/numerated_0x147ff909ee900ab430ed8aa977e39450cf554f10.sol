1 // SPDX-License-Identifier: MIT
2 /**
3  * @title Killzuki
4  * @author Shahid Ahmed
5  * @dev Used for Ethereum projects compatible with OpenSea
6  */
7 pragma solidity >=0.8.4;
8 
9 pragma solidity ^0.8.0;
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
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
34 
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
177 
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 
205 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
206 
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 
232 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
233 
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         uint256 size;
264         assembly {
265             size := extcodesize(account)
266         }
267         return size > 0;
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         (bool success, ) = recipient.call{value: amount}("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain `call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         require(isContract(target), "Address: call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.call{value: value}(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal view returns (bytes memory) {
388         require(isContract(target), "Address: static call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(isContract(target), "Address: delegate call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.delegatecall(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
423      * revert reason using the provided one.
424      *
425      * _Available since v4.3._
426      */
427     function verifyCallResult(
428         bool success,
429         bytes memory returndata,
430         string memory errorMessage
431     ) internal pure returns (bytes memory) {
432         if (success) {
433             return returndata;
434         } else {
435             // Look for revert reason and bubble it up if present
436             if (returndata.length > 0) {
437                 // The easiest way to bubble the revert reason is using memory via assembly
438 
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 
451 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
452 
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Provides information about the current execution context, including the
458  * sender of the transaction and its data. While these are generally available
459  * via msg.sender and msg.data, they should not be accessed in such a direct
460  * manner, since when dealing with meta-transactions the account sending and
461  * paying for execution may not be the actual sender (as far as an application
462  * is concerned).
463  *
464  * This contract is only required for intermediate, library-like contracts.
465  */
466 abstract contract Context {
467     function _msgSender() internal view virtual returns (address) {
468         return msg.sender;
469     }
470 
471     function _msgData() internal view virtual returns (bytes calldata) {
472         return msg.data;
473     }
474 }
475 
476 
477 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
478 
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev String operations.
484  */
485 library Strings {
486     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
487 
488     /**
489      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
490      */
491     function toString(uint256 value) internal pure returns (string memory) {
492         // Inspired by OraclizeAPI's implementation - MIT licence
493         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
494 
495         if (value == 0) {
496             return "0";
497         }
498         uint256 temp = value;
499         uint256 digits;
500         while (temp != 0) {
501             digits++;
502             temp /= 10;
503         }
504         bytes memory buffer = new bytes(digits);
505         while (value != 0) {
506             digits -= 1;
507             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
508             value /= 10;
509         }
510         return string(buffer);
511     }
512 
513     /**
514      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
515      */
516     function toHexString(uint256 value) internal pure returns (string memory) {
517         if (value == 0) {
518             return "0x00";
519         }
520         uint256 temp = value;
521         uint256 length = 0;
522         while (temp != 0) {
523             length++;
524             temp >>= 8;
525         }
526         return toHexString(value, length);
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
531      */
532     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
533         bytes memory buffer = new bytes(2 * length + 2);
534         buffer[0] = "0";
535         buffer[1] = "x";
536         for (uint256 i = 2 * length + 1; i > 1; --i) {
537             buffer[i] = _HEX_SYMBOLS[value & 0xf];
538             value >>= 4;
539         }
540         require(value == 0, "Strings: hex length insufficient");
541         return string(buffer);
542     }
543 }
544 
545 
546 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
547 
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * ```solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * ```
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570         return interfaceId == type(IERC165).interfaceId;
571     }
572 }
573 
574 
575 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
576 
577 
578 pragma solidity ^0.8.0;
579 
580 
581 
582 
583 
584 
585 
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         require(operator != _msgSender(), "ERC721: approve to caller");
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         //solhint-disable-next-line max-line-length
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732 
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, "");
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _transfer(from, to, tokenId);
785         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      * and stop existing when they are burned (`_burn`).
795      */
796     function _exists(uint256 tokenId) internal view virtual returns (bool) {
797         return _owners[tokenId] != address(0);
798     }
799 
800     /**
801      * @dev Returns whether `spender` is allowed to manage `tokenId`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
808         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
809         address owner = ERC721.ownerOf(tokenId);
810         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
811     }
812 
813     /**
814      * @dev Safely mints `tokenId` and transfers it to `to`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(address to, uint256 tokenId) internal virtual {
824         _safeMint(to, tokenId, "");
825     }
826 
827     /**
828      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
829      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
830      */
831     function _safeMint(
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _mint(to, tokenId);
837         require(
838             _checkOnERC721Received(address(0), to, tokenId, _data),
839             "ERC721: transfer to non ERC721Receiver implementer"
840         );
841     }
842 
843     /**
844      * @dev Mints `tokenId` and transfers it to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - `to` cannot be the zero address.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 tokenId) internal virtual {
856         require(to != address(0), "ERC721: mint to the zero address");
857         require(!_exists(tokenId), "ERC721: token already minted");
858 
859         _beforeTokenTransfer(address(0), to, tokenId);
860 
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889     }
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _transfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {
907         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
908         require(to != address(0), "ERC721: transfer to the zero address");
909 
910         _beforeTokenTransfer(from, to, tokenId);
911 
912         // Clear approvals from the previous owner
913         _approve(address(0), tokenId);
914 
915         _balances[from] -= 1;
916         _balances[to] += 1;
917         _owners[tokenId] = to;
918 
919         emit Transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev Approve `to` to operate on `tokenId`
924      *
925      * Emits a {Approval} event.
926      */
927     function _approve(address to, uint256 tokenId) internal virtual {
928         _tokenApprovals[tokenId] = to;
929         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
930     }
931 
932     /**
933      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
934      * The call is not executed if the target address is not a contract.
935      *
936      * @param from address representing the previous owner of the given token ID
937      * @param to target address that will receive the tokens
938      * @param tokenId uint256 ID of the token to be transferred
939      * @param _data bytes optional data to send along with the call
940      * @return bool whether the call correctly returned the expected magic value
941      */
942     function _checkOnERC721Received(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) private returns (bool) {
948         if (to.isContract()) {
949             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
950                 return retval == IERC721Receiver.onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0) {
953                     revert("ERC721: transfer to non ERC721Receiver implementer");
954                 } else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before any token transfer. This includes minting
967      * and burning.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, ``from``'s `tokenId` will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {}
984 }
985 
986 
987 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
988 
989 
990 pragma solidity ^0.8.0;
991 
992 /**
993  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
994  * @dev See https://eips.ethereum.org/EIPS/eip-721
995  */
996 interface IERC721Enumerable is IERC721 {
997     /**
998      * @dev Returns the total amount of tokens stored by the contract.
999      */
1000     function totalSupply() external view returns (uint256);
1001 
1002     /**
1003      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1004      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1005      */
1006     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1007 
1008     /**
1009      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1010      * Use along with {totalSupply} to enumerate all tokens.
1011      */
1012     function tokenByIndex(uint256 index) external view returns (uint256);
1013 }
1014 
1015 
1016 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1017 
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 /**
1023  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1024  * enumerability of all the token ids in the contract as well as all token ids owned by each
1025  * account.
1026  */
1027 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1028     // Mapping from owner to list of owned token IDs
1029     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1030 
1031     // Mapping from token ID to index of the owner tokens list
1032     mapping(uint256 => uint256) private _ownedTokensIndex;
1033 
1034     // Array with all token ids, used for enumeration
1035     uint256[] private _allTokens;
1036 
1037     // Mapping from token id to position in the allTokens array
1038     mapping(uint256 => uint256) private _allTokensIndex;
1039 
1040     /**
1041      * @dev See {IERC165-supportsInterface}.
1042      */
1043     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1044         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1049      */
1050     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1051         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1052         return _ownedTokens[owner][index];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-totalSupply}.
1057      */
1058     function totalSupply() public view virtual override returns (uint256) {
1059         return _allTokens.length;
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Enumerable-tokenByIndex}.
1064      */
1065     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1066         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1067         return _allTokens[index];
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting
1072      * and burning.
1073      *
1074      * Calling conditions:
1075      *
1076      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1077      * transferred to `to`.
1078      * - When `from` is zero, `tokenId` will be minted for `to`.
1079      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      *
1083      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1084      */
1085     function _beforeTokenTransfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) internal virtual override {
1090         super._beforeTokenTransfer(from, to, tokenId);
1091 
1092         if (from == address(0)) {
1093             _addTokenToAllTokensEnumeration(tokenId);
1094         } else if (from != to) {
1095             _removeTokenFromOwnerEnumeration(from, tokenId);
1096         }
1097         if (to == address(0)) {
1098             _removeTokenFromAllTokensEnumeration(tokenId);
1099         } else if (to != from) {
1100             _addTokenToOwnerEnumeration(to, tokenId);
1101         }
1102     }
1103 
1104     /**
1105      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1106      * @param to address representing the new owner of the given token ID
1107      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1108      */
1109     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1110         uint256 length = ERC721.balanceOf(to);
1111         _ownedTokens[to][length] = tokenId;
1112         _ownedTokensIndex[tokenId] = length;
1113     }
1114 
1115     /**
1116      * @dev Private function to add a token to this extension's token tracking data structures.
1117      * @param tokenId uint256 ID of the token to be added to the tokens list
1118      */
1119     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1120         _allTokensIndex[tokenId] = _allTokens.length;
1121         _allTokens.push(tokenId);
1122     }
1123 
1124     /**
1125      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1126      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1127      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1128      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1129      * @param from address representing the previous owner of the given token ID
1130      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1131      */
1132     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1133         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1134         // then delete the last slot (swap and pop).
1135 
1136         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1137         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1138 
1139         // When the token to delete is the last token, the swap operation is unnecessary
1140         if (tokenIndex != lastTokenIndex) {
1141             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1142 
1143             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1144             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1145         }
1146 
1147         // This also deletes the contents at the last position of the array
1148         delete _ownedTokensIndex[tokenId];
1149         delete _ownedTokens[from][lastTokenIndex];
1150     }
1151 
1152     /**
1153      * @dev Private function to remove a token from this extension's token tracking data structures.
1154      * This has O(1) time complexity, but alters the order of the _allTokens array.
1155      * @param tokenId uint256 ID of the token to be removed from the tokens list
1156      */
1157     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1158         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1159         // then delete the last slot (swap and pop).
1160 
1161         uint256 lastTokenIndex = _allTokens.length - 1;
1162         uint256 tokenIndex = _allTokensIndex[tokenId];
1163 
1164         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1165         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1166         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1167         uint256 lastTokenId = _allTokens[lastTokenIndex];
1168 
1169         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1170         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1171 
1172         // This also deletes the contents at the last position of the array
1173         delete _allTokensIndex[tokenId];
1174         _allTokens.pop();
1175     }
1176 }
1177 
1178 
1179 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1180 
1181 
1182 pragma solidity ^0.8.0;
1183 
1184 /**
1185  * @title Counters
1186  * @author Matt Condon (@shrugs)
1187  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1188  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1189  *
1190  * Include with `using Counters for Counters.Counter;`
1191  */
1192 library Counters {
1193     struct Counter {
1194         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1195         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1196         // this feature: see https://github.com/ethereum/solidity/issues/4637
1197         uint256 _value; // default: 0
1198     }
1199 
1200     function current(Counter storage counter) internal view returns (uint256) {
1201         return counter._value;
1202     }
1203 
1204     function increment(Counter storage counter) internal {
1205         unchecked {
1206             counter._value += 1;
1207         }
1208     }
1209 
1210     function decrement(Counter storage counter) internal {
1211         uint256 value = counter._value;
1212         require(value > 0, "Counter: decrement overflow");
1213         unchecked {
1214             counter._value = value - 1;
1215         }
1216     }
1217 
1218     function reset(Counter storage counter) internal {
1219         counter._value = 0;
1220     }
1221 }
1222 
1223 
1224 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1225 
1226 
1227 pragma solidity ^0.8.0;
1228 
1229 /**
1230  * @dev Contract module which provides a basic access control mechanism, where
1231  * there is an account (an owner) that can be granted exclusive access to
1232  * specific functions.
1233  *
1234  * By default, the owner account will be the one that deploys the contract. This
1235  * can later be changed with {transferOwnership}.
1236  *
1237  * This module is used through inheritance. It will make available the modifier
1238  * `onlyOwner`, which can be applied to your functions to restrict their use to
1239  * the owner.
1240  */
1241 abstract contract Ownable is Context {
1242     address private _owner;
1243 
1244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1245 
1246     /**
1247      * @dev Initializes the contract setting the deployer as the initial owner.
1248      */
1249     constructor() {
1250         _setOwner(_msgSender());
1251     }
1252 
1253     /**
1254      * @dev Returns the address of the current owner.
1255      */
1256     function owner() public view virtual returns (address) {
1257         return _owner;
1258     }
1259 
1260     /**
1261      * @dev Throws if called by any account other than the owner.
1262      */
1263     modifier onlyOwner() {
1264         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1265         _;
1266     }
1267 
1268     /**
1269      * @dev Leaves the contract without owner. It will not be possible to call
1270      * `onlyOwner` functions anymore. Can only be called by the current owner.
1271      *
1272      * NOTE: Renouncing ownership will leave the contract without an owner,
1273      * thereby removing any functionality that is only available to the owner.
1274      */
1275     function renounceOwnership() public virtual onlyOwner {
1276         _setOwner(address(0));
1277     }
1278 
1279     /**
1280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1281      * Can only be called by the current owner.
1282      */
1283     function transferOwnership(address newOwner) public virtual onlyOwner {
1284         require(newOwner != address(0), "Ownable: new owner is the zero address");
1285         _setOwner(newOwner);
1286     }
1287 
1288     function _setOwner(address newOwner) private {
1289         address oldOwner = _owner;
1290         _owner = newOwner;
1291         emit OwnershipTransferred(oldOwner, newOwner);
1292     }
1293 }
1294 
1295 
1296 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.2
1297 
1298 
1299 pragma solidity ^0.8.0;
1300 
1301 // CAUTION
1302 // This version of SafeMath should only be used with Solidity 0.8 or later,
1303 // because it relies on the compiler's built in overflow checks.
1304 
1305 /**
1306  * @dev Wrappers over Solidity's arithmetic operations.
1307  *
1308  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1309  * now has built in overflow checking.
1310  */
1311 library SafeMath {
1312     /**
1313      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1314      *
1315      * _Available since v3.4._
1316      */
1317     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1318         unchecked {
1319             uint256 c = a + b;
1320             if (c < a) return (false, 0);
1321             return (true, c);
1322         }
1323     }
1324 
1325     /**
1326      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1327      *
1328      * _Available since v3.4._
1329      */
1330     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1331         unchecked {
1332             if (b > a) return (false, 0);
1333             return (true, a - b);
1334         }
1335     }
1336 
1337     /**
1338      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1339      *
1340      * _Available since v3.4._
1341      */
1342     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1343         unchecked {
1344             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1345             // benefit is lost if 'b' is also tested.
1346             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1347             if (a == 0) return (true, 0);
1348             uint256 c = a * b;
1349             if (c / a != b) return (false, 0);
1350             return (true, c);
1351         }
1352     }
1353 
1354     /**
1355      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1356      *
1357      * _Available since v3.4._
1358      */
1359     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1360         unchecked {
1361             if (b == 0) return (false, 0);
1362             return (true, a / b);
1363         }
1364     }
1365 
1366     /**
1367      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1368      *
1369      * _Available since v3.4._
1370      */
1371     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1372         unchecked {
1373             if (b == 0) return (false, 0);
1374             return (true, a % b);
1375         }
1376     }
1377 
1378     /**
1379      * @dev Returns the addition of two unsigned integers, reverting on
1380      * overflow.
1381      *
1382      * Counterpart to Solidity's `+` operator.
1383      *
1384      * Requirements:
1385      *
1386      * - Addition cannot overflow.
1387      */
1388     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1389         return a + b;
1390     }
1391 
1392     /**
1393      * @dev Returns the subtraction of two unsigned integers, reverting on
1394      * overflow (when the result is negative).
1395      *
1396      * Counterpart to Solidity's `-` operator.
1397      *
1398      * Requirements:
1399      *
1400      * - Subtraction cannot overflow.
1401      */
1402     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1403         return a - b;
1404     }
1405 
1406     /**
1407      * @dev Returns the multiplication of two unsigned integers, reverting on
1408      * overflow.
1409      *
1410      * Counterpart to Solidity's `*` operator.
1411      *
1412      * Requirements:
1413      *
1414      * - Multiplication cannot overflow.
1415      */
1416     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1417         return a * b;
1418     }
1419 
1420     /**
1421      * @dev Returns the integer division of two unsigned integers, reverting on
1422      * division by zero. The result is rounded towards zero.
1423      *
1424      * Counterpart to Solidity's `/` operator.
1425      *
1426      * Requirements:
1427      *
1428      * - The divisor cannot be zero.
1429      */
1430     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1431         return a / b;
1432     }
1433 
1434     /**
1435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1436      * reverting when dividing by zero.
1437      *
1438      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1439      * opcode (which leaves remaining gas untouched) while Solidity uses an
1440      * invalid opcode to revert (consuming all remaining gas).
1441      *
1442      * Requirements:
1443      *
1444      * - The divisor cannot be zero.
1445      */
1446     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1447         return a % b;
1448     }
1449 
1450     /**
1451      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1452      * overflow (when the result is negative).
1453      *
1454      * CAUTION: This function is deprecated because it requires allocating memory for the error
1455      * message unnecessarily. For custom revert reasons use {trySub}.
1456      *
1457      * Counterpart to Solidity's `-` operator.
1458      *
1459      * Requirements:
1460      *
1461      * - Subtraction cannot overflow.
1462      */
1463     function sub(
1464         uint256 a,
1465         uint256 b,
1466         string memory errorMessage
1467     ) internal pure returns (uint256) {
1468         unchecked {
1469             require(b <= a, errorMessage);
1470             return a - b;
1471         }
1472     }
1473 
1474     /**
1475      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1476      * division by zero. The result is rounded towards zero.
1477      *
1478      * Counterpart to Solidity's `/` operator. Note: this function uses a
1479      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1480      * uses an invalid opcode to revert (consuming all remaining gas).
1481      *
1482      * Requirements:
1483      *
1484      * - The divisor cannot be zero.
1485      */
1486     function div(
1487         uint256 a,
1488         uint256 b,
1489         string memory errorMessage
1490     ) internal pure returns (uint256) {
1491         unchecked {
1492             require(b > 0, errorMessage);
1493             return a / b;
1494         }
1495     }
1496 
1497     /**
1498      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1499      * reverting with custom message when dividing by zero.
1500      *
1501      * CAUTION: This function is deprecated because it requires allocating memory for the error
1502      * message unnecessarily. For custom revert reasons use {tryMod}.
1503      *
1504      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1505      * opcode (which leaves remaining gas untouched) while Solidity uses an
1506      * invalid opcode to revert (consuming all remaining gas).
1507      *
1508      * Requirements:
1509      *
1510      * - The divisor cannot be zero.
1511      */
1512     function mod(
1513         uint256 a,
1514         uint256 b,
1515         string memory errorMessage
1516     ) internal pure returns (uint256) {
1517         unchecked {
1518             require(b > 0, errorMessage);
1519             return a % b;
1520         }
1521     }
1522 }
1523 
1524 contract Killzuki is ERC721, Ownable { 
1525 
1526     using Strings for uint256;
1527 
1528     bool    public  revealed            = true;
1529     bool    public  sale                = true;
1530     bool    public  salefree            = false;
1531     uint16  public  nonce               = 0;
1532     uint    public  price               = 100000000000000000;
1533     uint16  public  earlySupply         = 7777;
1534     uint16  public  totalSupply         = 7777;
1535     uint8   public  maxTx               = 20;
1536     uint8   public  maxTxFree           = 20;
1537     uint16  public  maxFree             = 777;
1538     string  private baseURI             = "revealed/";
1539     string  public  notRevealedUri      = "notrevealed";
1540     uint256 public  tokensBurned        = 0;
1541     address private canBurn             = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
1542 
1543 
1544     constructor(
1545         string memory _name,
1546         string memory _ticker
1547     ) ERC721(_name, _ticker) {
1548     }
1549 
1550     function reveal() public onlyOwner {
1551         revealed                = !revealed;
1552     }
1553 
1554     function setBaseURI(string memory baseURI_) public onlyOwner {
1555         baseURI = baseURI_;
1556     }
1557 
1558     function setUnrevealedURI(string memory baseURI_) public onlyOwner {
1559         notRevealedUri = baseURI_;
1560     }
1561 
1562     function _baseURI() internal view virtual override returns (string memory) {
1563         if(revealed == false) {
1564             return notRevealedUri;
1565         }else{
1566             return baseURI;
1567         }
1568     }
1569 
1570     function setPrice(uint _newPrice) external onlyOwner {
1571         price = _newPrice;
1572     }
1573 
1574     function setEarlySupply(uint16 _newSupply) external onlyOwner {
1575         earlySupply = _newSupply;
1576     }
1577 
1578     function setTotalSupply(uint16 _newSupply) external onlyOwner {
1579         totalSupply = _newSupply;
1580         earlySupply = _newSupply;
1581     }
1582 
1583     function setSale(bool _value) public onlyOwner {
1584         sale = _value;
1585     }
1586 
1587     function setSaleFree() public onlyOwner {
1588         salefree = !salefree;
1589     }
1590 
1591     function setMaxTx(uint8 _newMax) external onlyOwner {
1592         maxTx = _newMax;
1593     }
1594 
1595     function setMaxTxFree(uint8 _newMax) external onlyOwner {
1596         maxTxFree = _newMax;
1597     }
1598 
1599     function setMaxFree(uint16 _newMax) external onlyOwner {
1600         maxFree = _newMax;
1601     }
1602 
1603     function setCanBurn(address _newWallet) external onlyOwner {
1604         canBurn = _newWallet;
1605     }
1606 
1607     function isCanBurn(address _user) public view returns (bool) {
1608         if (canBurn == _user) {
1609             return true;
1610         }else{
1611             return false;
1612         }
1613     }
1614 
1615     function burnMany(uint256[] calldata tokenIds) external {
1616         require(isCanBurn(msg.sender), "You Cannot Burn");
1617         for (uint256 i; i < tokenIds.length; i++) {
1618             _burn(tokenIds[i]);
1619         }
1620         tokensBurned += tokenIds.length;
1621     }
1622 
1623     function buy(uint8 _qty) external payable {
1624         require(sale, 'Sale is not active');
1625         require(uint16(_qty) + nonce - 1 <= totalSupply, 'No more supply');
1626         if (nonce < maxFree) {
1627             require(_qty <= maxTxFree || _qty < 1, 'You can not buy more than allowed');
1628         }else{
1629             require(_qty <= maxTx || _qty < 1, 'You can not buy more than allowed');
1630             require(msg.value >= price * _qty, 'Invalid price');
1631         }
1632 
1633         mintNFTs(msg.sender, _qty);
1634     }
1635 
1636     function buyfree(uint8 _qty) external payable {
1637         require(salefree, 'Free Sale is not active');
1638         require(_qty <= maxTxFree || _qty < 1, 'You can not buy more than allowed');
1639         require(uint16(_qty) + nonce - 1 <= totalSupply, 'No more supply');
1640 
1641         mintNFTs(msg.sender, _qty);
1642     }
1643 
1644     function giveaway(address _to, uint8 _qty) external onlyOwner {
1645         require(uint16(_qty) + nonce - 1 <= totalSupply, 'No more supply');
1646 
1647         mintNFTs(_to, _qty);
1648     }
1649 
1650     function mintNFTs(address _to, uint8 _qty) private {
1651         for (uint8 i = 0; i < _qty; i++) {
1652             uint16 _tokenId = nonce;
1653             _safeMint(_to, _tokenId);
1654             nonce++;
1655         }
1656     }
1657 
1658     function withdraw() external onlyOwner {
1659         payable(msg.sender).transfer(address(this).balance);
1660     }
1661 
1662     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1663         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1664         if(revealed == false) {
1665             return notRevealedUri;
1666         }else{
1667             return bytes(baseURI).length > 0 ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json")) : "";
1668         }
1669     }
1670 
1671 }