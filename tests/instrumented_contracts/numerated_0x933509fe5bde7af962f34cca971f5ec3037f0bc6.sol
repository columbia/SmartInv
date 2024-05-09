1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 
29 
30 // import "../../utils/introspection/IERC165.sol";
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 
171 
172 /**
173  * @title ERC721 token receiver interface
174  * @dev Interface for any contract that wants to support safeTransfers
175  * from ERC721 asset contracts.
176  */
177 interface IERC721Receiver {
178     /**
179      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
180      * by `operator` from `from`, this function is called.
181      *
182      * It must return its Solidity selector to confirm the token transfer.
183      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
184      *
185      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
186      */
187     function onERC721Received(
188         address operator,
189         address from,
190         uint256 tokenId,
191         bytes calldata data
192     ) external returns (bytes4);
193 }
194 
195 
196 
197 
198 // import "../IERC721.sol";
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
222 /**
223  * @dev Collection of functions related to the address type
224  */
225 library Address {
226     /**
227      * @dev Returns true if `account` is a contract.
228      *
229      * [IMPORTANT]
230      * ====
231      * It is unsafe to assume that an address for which this function returns
232      * false is an externally-owned account (EOA) and not a contract.
233      *
234      * Among others, `isContract` will return false for the following
235      * types of addresses:
236      *
237      *  - an externally-owned account
238      *  - a contract in construction
239      *  - an address where a contract will be created
240      *  - an address where a contract lived, but was destroyed
241      * ====
242      */
243     function isContract(address account) internal view returns (bool) {
244         // This method relies on extcodesize, which returns 0 for contracts in
245         // construction, since the code is only stored at the end of the
246         // constructor execution.
247 
248         uint256 size;
249         assembly {
250             size := extcodesize(account)
251         }
252         return size > 0;
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         (bool success, ) = recipient.call{value: amount}("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain `call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionCall(target, data, "Address: low-level call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
302      * `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335      * with `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         require(isContract(target), "Address: call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.call{value: value}(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
359         return functionStaticCall(target, data, "Address: low-level static call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(isContract(target), "Address: delegate call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             // Look for revert reason and bubble it up if present
421             if (returndata.length > 0) {
422                 // The easiest way to bubble the revert reason is using memory via assembly
423 
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 
436 
437 
438 /**
439  * @dev Provides information about the current execution context, including the
440  * sender of the transaction and its data. While these are generally available
441  * via msg.sender and msg.data, they should not be accessed in such a direct
442  * manner, since when dealing with meta-Limit the account sending and
443  * paying for execution may not be the actual sender (as far as an application
444  * is concerned).
445  *
446  * This contract is only required for intermediate, library-like contracts.
447  */
448 abstract contract Context {
449     function _msgSender() internal view virtual returns (address) {
450         return msg.sender;
451     }
452 
453     function _msgData() internal view virtual returns (bytes calldata) {
454         return msg.data;
455     }
456 }
457 
458 
459 /**
460  * @dev String operations.
461  */
462 library Strings {
463     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
467      */
468     function toString(uint256 value) internal pure returns (string memory) {
469         // Inspired by OraclizeAPI's implementation - MIT licence
470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
471 
472         if (value == 0) {
473             return "0";
474         }
475         uint256 temp = value;
476         uint256 digits;
477         while (temp != 0) {
478             digits++;
479             temp /= 10;
480         }
481         bytes memory buffer = new bytes(digits);
482         while (value != 0) {
483             digits -= 1;
484             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
485             value /= 10;
486         }
487         return string(buffer);
488     }
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
492      */
493     function toHexString(uint256 value) internal pure returns (string memory) {
494         if (value == 0) {
495             return "0x00";
496         }
497         uint256 temp = value;
498         uint256 length = 0;
499         while (temp != 0) {
500             length++;
501             temp >>= 8;
502         }
503         return toHexString(value, length);
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
508      */
509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
510         bytes memory buffer = new bytes(2 * length + 2);
511         buffer[0] = "0";
512         buffer[1] = "x";
513         for (uint256 i = 2 * length + 1; i > 1; --i) {
514             buffer[i] = _HEX_SYMBOLS[value & 0xf];
515             value >>= 4;
516         }
517         require(value == 0, "Strings: hex length insufficient");
518         return string(buffer);
519     }
520 }
521 
522 
523 // import "./IERC165.sol";
524 
525 /**
526  * @dev Implementation of the {IERC165} interface.
527  *
528  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
529  * for the additional interface id that will be supported. For example:
530  *
531  * ```solidity
532  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
534  * }
535  * ```
536  *
537  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
538  */
539 abstract contract ERC165 is IERC165 {
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         return interfaceId == type(IERC165).interfaceId;
545     }
546 }
547 
548 
549 
550 
551 
552 /*import "./IERC721.sol";
553 import "./IERC721Receiver.sol";
554 import "./extensions/IERC721Metadata.sol";
555 import "../../utils/Address.sol";
556 import "../../utils/Context.sol";
557 import "../../utils/Strings.sol";
558 import "../../utils/introspection/ERC165.sol";*/
559 
560 /**
561  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
562  * the Metadata extension, but not including the Enumerable extension, which is available separately as
563  * {ERC721Enumerable}.
564  */
565 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
566     using Address for address;
567     using Strings for uint256;
568 
569     // Token name
570     string private _name;
571 
572     // Token symbol
573     string private _symbol;
574 
575     // Mapping from token ID to owner address
576     mapping(uint256 => address) private _owners;
577 
578     // Mapping owner address to token count
579     mapping(address => uint256) private _balances;
580 
581     // Mapping from token ID to approved address
582     mapping(uint256 => address) private _tokenApprovals;
583 
584     // Mapping from owner to operator approvals
585     mapping(address => mapping(address => bool)) private _operatorApprovals;
586 
587     /**
588      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
589      */
590     constructor(string memory name_, string memory symbol_) {
591         _name = name_;
592         _symbol = symbol_;
593     }
594 
595     /**
596      * @dev See {IERC165-supportsInterface}.
597      */
598     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
599         return
600             interfaceId == type(IERC721).interfaceId ||
601             interfaceId == type(IERC721Metadata).interfaceId ||
602             super.supportsInterface(interfaceId);
603     }
604 
605     /**
606      * @dev See {IERC721-balanceOf}.
607      */
608     function balanceOf(address owner) public view virtual override returns (uint256) {
609         require(owner != address(0), "ERC721: balance query for the zero address");
610         return _balances[owner];
611     }
612 
613     /**
614      * @dev See {IERC721-ownerOf}.
615      */
616     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
617         address owner = _owners[tokenId];
618         require(owner != address(0), "ERC721: owner query for nonexistent token");
619         return owner;
620     }
621 
622     /**
623      * @dev See {IERC721Metadata-name}.
624      */
625     function name() public view virtual override returns (string memory) {
626         return _name;
627     }
628 
629     /**
630      * @dev See {IERC721Metadata-symbol}.
631      */
632     function symbol() public view virtual override returns (string memory) {
633         return _symbol;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-tokenURI}.
638      */
639     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
640         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
641 
642         string memory baseURI = _baseURI();
643         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
644     }
645 
646     /**
647      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
648      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
649      * by default, can be overriden in child contracts.
650      */
651     function _baseURI() internal view virtual returns (string memory) {
652         return "";
653     }
654 
655     /**
656      * @dev See {IERC721-approve}.
657      */
658     function approve(address to, uint256 tokenId) public virtual override {
659         address owner = ERC721.ownerOf(tokenId);
660         require(to != owner, "ERC721: approval to current owner");
661 
662         require(
663             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
664             "ERC721: approve caller is not owner nor approved for all"
665         );
666 
667         _approve(to, tokenId);
668     }
669 
670     /**
671      * @dev See {IERC721-getApproved}.
672      */
673     function getApproved(uint256 tokenId) public view virtual override returns (address) {
674         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
675 
676         return _tokenApprovals[tokenId];
677     }
678 
679     /**
680      * @dev See {IERC721-setApprovalForAll}.
681      */
682     function setApprovalForAll(address operator, bool approved) public virtual override {
683         require(operator != _msgSender(), "ERC721: approve to caller");
684 
685         _operatorApprovals[_msgSender()][operator] = approved;
686         emit ApprovalForAll(_msgSender(), operator, approved);
687     }
688 
689     /**
690      * @dev See {IERC721-isApprovedForAll}.
691      */
692     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
693         return _operatorApprovals[owner][operator];
694     }
695 
696     /**
697      * @dev See {IERC721-transferFrom}.
698      */
699     function transferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) public virtual override {
704         //solhint-disable-next-line max-line-length
705         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
706 
707         _transfer(from, to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-safeTransferFrom}.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) external virtual override {
718         safeTransferFrom(from, to, tokenId, "");
719     }
720 
721     /**
722      * @dev See {IERC721-safeTransferFrom}.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes memory _data
729     ) public virtual override {
730         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
731         _safeTransfer(from, to, tokenId, _data);
732     }
733 
734     /**
735      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
736      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
737      *
738      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
739      *
740      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
741      * implement alternative mechanisms to perform token transfer, such as signature-based.
742      *
743      * Requirements:
744      *
745      * - `from` cannot be the zero address.
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must exist and be owned by `from`.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _safeTransfer(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) internal virtual {
758         _transfer(from, to, tokenId);
759         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
760     }
761 
762     /**
763      * @dev Returns whether `tokenId` exists.
764      *
765      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
766      *
767      * Tokens start existing when they are minted (`_mint`),
768      * and stop existing when they are burned (`_burn`).
769      */
770     function _exists(uint256 tokenId) internal view virtual returns (bool) {
771         return _owners[tokenId] != address(0);
772     }
773 
774     /**
775      * @dev Returns whether `spender` is allowed to manage `tokenId`.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must exist.
780      */
781     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
782         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
783         address owner = ERC721.ownerOf(tokenId);
784         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
785     }
786 
787     /**
788      * @dev Safely mints `tokenId` and transfers it to `to`.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must not exist.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function _safeMint(address to, uint256 tokenId) internal virtual {
798         _safeMint(to, tokenId, "");
799     }
800 
801     /**
802      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
803      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
804      */
805     function _safeMint(
806         address to,
807         uint256 tokenId,
808         bytes memory _data
809     ) internal virtual {
810         _mint(to, tokenId);
811         require(
812             _checkOnERC721Received(address(0), to, tokenId, _data),
813             "ERC721: transfer to non ERC721Receiver implementer"
814         );
815     }
816 
817     /**
818      * @dev Mints `tokenId` and transfers it to `to`.
819      *
820      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
821      *
822      * Requirements:
823      *
824      * - `tokenId` must not exist.
825      * - `to` cannot be the zero address.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _mint(address to, uint256 tokenId) internal virtual {
830         require(to != address(0), "ERC721: mint to the zero address");
831         require(!_exists(tokenId), "ERC721: token already minted");
832 
833         _beforeTokenTransfer(address(0), to, tokenId);
834 
835         _balances[to] += 1;
836         _owners[tokenId] = to;
837 
838         emit Transfer(address(0), to, tokenId);
839     }
840 
841     /**
842      * @dev Destroys `tokenId`.
843      * The approval is cleared when the token is burned.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _burn(uint256 tokenId) internal virtual {
852         address owner = ERC721.ownerOf(tokenId);
853 
854         _beforeTokenTransfer(owner, address(0), tokenId);
855 
856         // Clear approvals
857         _approve(address(0), tokenId);
858 
859         _balances[owner] -= 1;
860         delete _owners[tokenId];
861 
862         emit Transfer(owner, address(0), tokenId);
863     }
864 
865     /**
866      * @dev Transfers `tokenId` from `from` to `to`.
867      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
868      *
869      * Requirements:
870      *
871      * - `to` cannot be the zero address.
872      * - `tokenId` token must be owned by `from`.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _transfer(
877         address from,
878         address to,
879         uint256 tokenId
880     ) internal virtual {
881         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
882         require(to != address(0), "ERC721: transfer to the zero address");
883 
884         _beforeTokenTransfer(from, to, tokenId);
885 
886         // Clear approvals from the previous owner
887         _approve(address(0), tokenId);
888 
889         _balances[from] -= 1;
890         _balances[to] += 1;
891         _owners[tokenId] = to;
892 
893         emit Transfer(from, to, tokenId);
894     }
895 
896     /**
897      * @dev Approve `to` to operate on `tokenId`
898      *
899      * Emits a {Approval} event.
900      */
901     function _approve(address to, uint256 tokenId) internal virtual {
902         _tokenApprovals[tokenId] = to;
903         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
904     }
905 
906     /**
907      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
908      * The call is not executed if the target address is not a contract.
909      *
910      * @param from address representing the previous owner of the given token ID
911      * @param to target address that will receive the tokens
912      * @param tokenId uint256 ID of the token to be transferred
913      * @param _data bytes optional data to send along with the call
914      * @return bool whether the call correctly returned the expected magic value
915      */
916     function _checkOnERC721Received(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) private returns (bool) {
922         if (to.isContract()) {
923             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
924                 return retval == IERC721Receiver.onERC721Received.selector;
925             } catch (bytes memory reason) {
926                 if (reason.length == 0) {
927                     revert("ERC721: transfer to non ERC721Receiver implementer");
928                 } else {
929                     assembly {
930                         revert(add(32, reason), mload(reason))
931                     }
932                 }
933             }
934         } else {
935             return true;
936         }
937     }
938 
939     /**
940      * @dev Hook that is called before any token transfer. This includes minting
941      * and burning.
942      *
943      * Calling conditions:
944      *
945      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
946      * transferred to `to`.
947      * - When `from` is zero, `tokenId` will be minted for `to`.
948      * - When `to` is zero, ``from``'s `tokenId` will be burned.
949      * - `from` and `to` are never both zero.
950      *
951      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
952      */
953     function _beforeTokenTransfer(
954         address from,
955         address to,
956         uint256 tokenId
957     ) internal virtual {}
958 }
959 
960 
961 
962 
963 /**
964  * @title Counters
965  * @author Matt Condon (@shrugs)
966  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
967  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
968  *
969  * Include with `using Counters for Counters.Counter;`
970  */
971 library Counters {
972     struct Counter {
973         // This variable should never be directly accessed by users of the library: interactions must be restricted to
974         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
975         // this feature: see https://github.com/ethereum/solidity/issues/4637
976         uint256 _value; // default: 0
977     }
978 
979     function current(Counter storage counter) internal view returns (uint256) {
980         return counter._value;
981     }
982 
983     function increment(Counter storage counter) internal {
984         unchecked {
985             counter._value += 1;
986         }
987     }
988 
989     function decrement(Counter storage counter) internal {
990         uint256 value = counter._value;
991         require(value > 0, "Counter: decrement overflow");
992         unchecked {
993             counter._value = value - 1;
994         }
995     }
996 
997     function reset(Counter storage counter) internal {
998         counter._value = 0;
999     }
1000 }
1001 
1002 // import "../utils/Context.sol";
1003 
1004 /**
1005  * @dev Contract module which provides a basic access control mechanism, where
1006  * there is an account (an owner) that can be granted exclusive access to
1007  * specific functions.
1008  *
1009  * By default, the owner account will be the one that deploys the contract. This
1010  * can later be changed with {transferOwnership}.
1011  *
1012  * This module is used through inheritance. It will make available the modifier
1013  * `onlyOwner`, which can be applied to your functions to restrict their use to
1014  * the owner.
1015  */
1016 abstract contract Ownable is Context {
1017     address private _owner;
1018 
1019     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1020 
1021     /**
1022      * @dev Initializes the contract setting the deployer as the initial owner.
1023      */
1024     constructor() {
1025         _setOwner(_msgSender());
1026     }
1027 
1028     /**
1029      * @dev Returns the address of the current owner.
1030      */
1031     function owner() public view virtual returns (address) {
1032         return _owner;
1033     }
1034 
1035     /**
1036      * @dev Throws if called by any account other than the owner.
1037      */
1038     modifier onlyOwner() {
1039         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1040         _;
1041     }
1042 
1043     /**
1044      * @dev Leaves the contract without owner. It will not be possible to call
1045      * `onlyOwner` functions anymore. Can only be called by the current owner.
1046      *
1047      * NOTE: Renouncing ownership will leave the contract without an owner,
1048      * thereby removing any functionality that is only available to the owner.
1049      */
1050     function renounceOwnership() external virtual onlyOwner {
1051         _setOwner(address(0));
1052     }
1053 
1054     /**
1055      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1056      * Can only be called by the current owner.
1057      */
1058     function transferOwnership(address newOwner) public virtual onlyOwner {
1059         require(newOwner != address(0), "Ownable: new owner is the zero address");
1060         _setOwner(newOwner);
1061     }
1062 
1063     function _setOwner(address newOwner) private {
1064         address oldOwner = _owner;
1065         _owner = newOwner;
1066         emit OwnershipTransferred(oldOwner, newOwner);
1067     }
1068 }
1069 
1070 abstract contract ReentrancyGuard {
1071     // Booleans are more expensive than uint256 or any type that takes up a full
1072     // word because each write operation emits an extra SLOAD to first read the
1073     // slot's contents, replace the bits taken up by the boolean, and then write
1074     // back. This is the compiler's defense against contract upgrades and
1075     // pointer aliasing, and it cannot be disabled.
1076 
1077     // The values being non-zero value makes deployment a bit more expensive,
1078     // but in exchange the refund on every call to nonReentrant will be lower in
1079     // amount. Since refunds are capped to a percentage of the total
1080     // transaction's gas, it is best to keep them low in cases like this one, to
1081     // increase the likelihood of the full refund coming into effect.
1082     uint256 private constant _NOT_ENTERED = 1;
1083     uint256 private constant _ENTERED = 2;
1084 
1085     uint256 private _status;
1086 
1087     constructor() {
1088         _status = _NOT_ENTERED;
1089     }
1090 
1091     /**
1092      * @dev Prevents a contract from calling itself, directly or indirectly.
1093      * Calling a `nonReentrant` function from another `nonReentrant`
1094      * function is not supported. It is possible to prevent this from happening
1095      * by making the `nonReentrant` function external, and making it call a
1096      * `private` function that does the actual work.
1097      */
1098     modifier nonReentrant() {
1099         // On the first call to nonReentrant, _notEntered will be true
1100         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1101 
1102         // Any calls to nonReentrant after this point will fail
1103         _status = _ENTERED;
1104 
1105         _;
1106 
1107         // By storing the original value once again, a refund is triggered (see
1108         // https://eips.ethereum.org/EIPS/eip-2200)
1109         _status = _NOT_ENTERED;
1110     }
1111 }
1112 
1113 
1114 contract LegendsOfShangu is ERC721, Ownable, ReentrancyGuard{
1115     using Counters for Counters.Counter;
1116     Counters.Counter _tokenIdTracker;
1117 
1118     mapping(uint256 => string) public _tokenURIs; //returns uris for particular token id
1119     mapping(uint256 => address) public minter;   //returs minter of a token id
1120     mapping(address => uint256[]) public mintedByUser;
1121     uint256 public constant awakeningLimit = 2623;
1122     uint256 public constant whitelistOneLimit = 2000;
1123     uint256 public constant whitelistTwoLimit = 1000;
1124     uint256 public constant publicSaleLimit = 7400;
1125     uint256 public constant awakeningUserLimit = 24;
1126     uint256 public constant whitelistOneUserLimit = 12;
1127     uint256 public constant whitelistTwoUserLimit = 12;
1128     uint256 public constant publicSaleUserLimit = 12;
1129     uint256 public constant awakeningPrice = 0.08 ether;
1130     uint256 public constant whitelistOnePrice = 0.1 ether;
1131     uint256 public constant whitelistTwoPrice = 0.12 ether;
1132     uint256 public publicSalePrice;
1133     bool public publicSalePriceSet;
1134     uint256 public constant awakeningStart = 1643851800;
1135     uint256 public constant whitelistOneStart = 1644017400;
1136     uint256 public constant whitelistTwoStart = 1644197400;
1137     uint256 public constant publicSaleStart = 1644283800;
1138     uint256 public constant awakeningEnd= 1643862600;
1139     uint256 public constant whitelistOneEnd = 1644028200;
1140     uint256 public constant whitelistTwoEnd = 1644211800;
1141     uint256 public constant teamLimit = 377;
1142     mapping(address => uint256) public userAwakeningLimit;
1143     mapping(address => uint256) public userWhitelistOneLimit;
1144     mapping(address => uint256) public userWhitelistTwoLimit;
1145     mapping(address => uint256) public userPublicSaleLimit;
1146     mapping(uint256 => bool) public revealed;
1147     mapping(address => bool) public awakeningWhitelisted;
1148     mapping(address => bool) public whitelistOneWhitelisted;
1149     mapping(address => bool) public whitelistTwoWhitelisted;
1150     string public baseUri = "https://legendsofshangu.mypinata.cloud/ipfs/QmXZEctx31jg9hQEx9ukeK13YG5SQrBZDjgs8GV83AoBPt";
1151     uint256 public awakeningSold;
1152     uint256 public whitelistOneSold;
1153     uint256 public whitelistTwoSold;
1154     uint256 public publicSaleSold;
1155     uint256 public TeamWalletMinted;
1156     uint256 public totalSale;
1157     address public TeamWallet1;
1158     address public TeamWallet2;
1159     address public TeamWallet3;
1160     address public TeamWallet4;
1161     address public TeamWallet5;
1162     address public TeamWallet6;
1163     address public TeamWallet7;
1164     address public TeamWallet8;
1165 
1166     
1167 
1168     constructor(string memory NAME, string memory SYMBOL, address _teamWallet1, address _teamWallet2, address _teamWallet3, address _teamWallet4 ,
1169     address _teamWallet5, address _teamWallet6, address _teamWallet7,  address _teamWallet8 ) ERC721(NAME,SYMBOL) {
1170     TeamWallet1 = _teamWallet1;
1171     TeamWallet2 = _teamWallet2;
1172     TeamWallet3 = _teamWallet3;
1173     TeamWallet4 = _teamWallet4;
1174     TeamWallet5 = _teamWallet5;
1175     TeamWallet6 = _teamWallet6;
1176     TeamWallet7 = _teamWallet7;
1177     TeamWallet8 = _teamWallet8;
1178     }
1179 
1180    event Minted (uint256 _NftId, string msg);
1181    
1182    event BatchMint(uint256 _totalNft, string msg);
1183 
1184    event Revealed();
1185 
1186    event PriceSet(uint256 price);
1187 
1188    event AwakeningWhitelist();
1189 
1190    event WhitelistOneWhitelist();
1191  
1192    event WhitelistTwoWhitelist();
1193 
1194     function _mintNft(address creator) 
1195     private 
1196     returns (uint256) 
1197     { 
1198         uint256 NftId = _tokenIdTracker.current(); 
1199         _safeMint(creator, NftId);
1200         mintedByUser[creator].push(NftId);
1201         minter[NftId] = creator;
1202         _setTokenURI(NftId, baseUri);
1203         _tokenIdTracker.increment();
1204         emit Minted (NftId,"successfully minted");
1205         
1206     
1207         return (NftId); 
1208     }
1209     // function to mint multiple nfts
1210     function awakeningMint( uint256 numberOfNfts) external payable nonReentrant returns(bool) {
1211     require(block.timestamp> awakeningStart && block.timestamp< awakeningEnd,"Sale Not Started");
1212         require(awakeningWhitelisted[msg.sender]==true,"User not whitelisted");
1213         awakeningSold = awakeningSold + numberOfNfts;
1214         require(awakeningSold<= awakeningLimit,"Awakening Sale Limit Exceeded");
1215         require(msg.value >= numberOfNfts*awakeningPrice, "Please Enter Correct Amount");
1216         payable(address(this)).transfer(msg.value);
1217         awakeningMint(msg.sender, numberOfNfts);
1218         totalSale = totalSale+numberOfNfts;
1219         emit BatchMint(numberOfNfts," Awakening Minted successfully");
1220         return(true);
1221     
1222     }
1223     function whitelistOneMint( uint256 numberOfNfts) external payable nonReentrant returns(bool) {
1224     require(block.timestamp> whitelistOneStart && block.timestamp< whitelistOneEnd,"Sale not started");
1225         require(whitelistOneWhitelisted[msg.sender]==true,"User not whitelisted");
1226         whitelistOneSold = whitelistOneSold + numberOfNfts;
1227         require(whitelistOneSold<= whitelistOneLimit,"Whitelist One Sale Limit Exceeded");
1228         require(msg.value >= numberOfNfts*whitelistOnePrice, "Please Enter Correct Amount");
1229         payable(address(this)).transfer(msg.value);
1230         whitelistOneMint(msg.sender, numberOfNfts);
1231         totalSale = totalSale+numberOfNfts;
1232           emit BatchMint(numberOfNfts," Whitelist One Minted successfully");
1233            return(true);
1234     
1235     }
1236     function whitelistTwoMint( uint256 numberOfNfts) external payable nonReentrant returns(bool) {
1237     require(block.timestamp> whitelistTwoStart && block.timestamp< whitelistTwoEnd,"Sale not started");
1238         require(whitelistTwoWhitelisted[msg.sender]==true,"User not whitelisted");
1239         whitelistTwoSold = whitelistTwoSold + numberOfNfts;
1240         require(whitelistTwoSold<= whitelistTwoLimit,"Whitelist Two Sale Limit Exceeded");
1241         require(msg.value >= numberOfNfts*whitelistTwoPrice, "Please Enter Correct Amount");
1242         payable(address(this)).transfer(msg.value);
1243         whitelistTwoMint(msg.sender, numberOfNfts);
1244         totalSale = totalSale+numberOfNfts;
1245         emit BatchMint(numberOfNfts,"Whitelist Two Minted successfully");
1246         return(true);
1247 
1248     }
1249     function publicSaleMint( uint256 numberOfNfts) external payable nonReentrant returns(bool) {
1250         require(block.timestamp> publicSaleStart,"Sale not started"); 
1251         require(publicSalePriceSet == true,"Price not set");
1252         totalSale = totalSale+numberOfNfts;
1253         require(totalSale<= publicSaleLimit,"Total Supply Reached");
1254         require(msg.value >= numberOfNfts*publicSalePrice, "Please Enter Correct Amount");
1255         payable(address(this)).transfer(msg.value);
1256         publicSaleMint(msg.sender, numberOfNfts);
1257          emit BatchMint(numberOfNfts,"Public Sale Minted successfully");
1258          return(true);
1259   
1260     }
1261 
1262     function withdrawAmount() external payable onlyOwner{
1263         uint256 amount = address(this).balance;
1264         payable(TeamWallet1).transfer((amount)*32/100);
1265         payable(TeamWallet2).transfer((amount)*25/100);
1266         payable(TeamWallet3).transfer((amount)*25/100);
1267         payable(TeamWallet4).transfer((amount)*5/100);
1268         payable(TeamWallet5).transfer((amount)*3/100);
1269         payable(TeamWallet6).transfer((amount)*1/100);
1270         payable(TeamWallet7).transfer((amount)*1/100);
1271         payable(TeamWallet8).transfer((amount)*8/100);
1272 
1273     }
1274  
1275     function awakeningMint(address creator, uint256 numberOfNfts) private{
1276         userAwakeningLimit[creator] = userAwakeningLimit[creator] + numberOfNfts;
1277         require(userAwakeningLimit[creator]<= awakeningUserLimit,"Minting Limit Exceeded");
1278         for(uint256 i = 0; i< numberOfNfts; i++){
1279         _mintNft(creator);
1280         }
1281         
1282     }
1283 
1284     function whitelistOneMint(address creator, uint256 numberOfNfts) private{
1285         userWhitelistOneLimit[creator] = userWhitelistOneLimit[creator] + numberOfNfts;
1286         require(userWhitelistOneLimit[creator]<= whitelistOneUserLimit,"Minting Limit Exceeded"); 
1287         for(uint256 i = 0; i< numberOfNfts; i++){
1288         _mintNft(creator);
1289         }
1290         
1291     }
1292 
1293     function whitelistTwoMint(address creator, uint256 numberOfNfts) private{
1294         userWhitelistTwoLimit[creator] = userWhitelistTwoLimit[creator] + numberOfNfts;
1295         require(userWhitelistTwoLimit[creator]<= whitelistTwoUserLimit,"Minting Limit Exceeded"); 
1296         for(uint256 i = 0; i< numberOfNfts; i++){
1297         _mintNft(creator);
1298         }
1299         
1300     }
1301 
1302     function publicSaleMint(address creator, uint256 numberOfNfts) private{
1303         userPublicSaleLimit[creator] = userPublicSaleLimit[creator] + numberOfNfts;
1304         require(userPublicSaleLimit[creator]<= publicSaleUserLimit,"Minting Limit Exceeded");  
1305         for(uint256 i = 0; i< numberOfNfts; i++){
1306         _mintNft(creator);
1307         }
1308 
1309         
1310     }
1311 
1312     function whitelistUsersForAwakening(address[] memory user) external onlyOwner{
1313         address[] memory _user = user;
1314         uint256 length = _user.length;
1315          for(uint256 i=0; i<length;i++){ 
1316              awakeningWhitelisted[_user[i]] = true;
1317          }
1318         emit AwakeningWhitelist();
1319     }
1320 
1321     function whitelistUsersForWhitelistOne(address[] memory user) external onlyOwner{
1322         address[] memory _user = user;
1323         uint256 length = _user.length;
1324          for(uint256 i=0; i<length;i++){
1325              whitelistOneWhitelisted[_user[i]] = true;
1326          }
1327         emit WhitelistOneWhitelist();
1328     } 
1329 
1330     function whitelistUsersForWhitelistTwo(address[] memory user) external onlyOwner{
1331         address[] memory _user = user;
1332         uint256 length = _user.length;
1333          for(uint256 i=0; i<length;i++){
1334              whitelistTwoWhitelisted[_user[i]] = true;
1335          }
1336         emit WhitelistTwoWhitelist();
1337     }
1338 
1339     function setPublicSalePrice(uint256 price) external onlyOwner{
1340      require(price >0,"Price should be greater than 0");
1341      publicSalePrice = price;
1342      publicSalePriceSet = true;
1343      emit PriceSet(price);
1344     } 
1345    
1346     // returns minter of a token
1347      function minterOfToken(uint256 tokenId) external view returns (address _minter){
1348         return(minter[tokenId]);
1349     }
1350     // sets uri for a token
1351     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1352         private 
1353     
1354     {
1355         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1356         _tokenURIs[tokenId] = _tokenURI;
1357     }
1358 
1359     // sets uri for a token
1360     function revealNFTs(uint256[] memory tokenId, string[] memory _tokenURI)
1361         external onlyOwner 
1362        
1363     {   require(tokenId.length == _tokenURI.length,"Invalid Input");
1364         uint256 entry = tokenId.length;
1365         for(uint256 i= 0; i<entry ; i++){
1366         require(revealed[tokenId[i]]==false,"Already revealed");
1367         revealed[tokenId[i]]= true;
1368         _setTokenURI(tokenId[i],_tokenURI[i]);
1369         }
1370 
1371         emit Revealed();
1372     }
1373    // returns the total amount of NFTs minted
1374     function getTokenCounter() external view returns (uint256 tracker){
1375         return(_tokenIdTracker.current());
1376     }
1377 
1378     function teamMint(uint256 numberOfNfts) external onlyOwner{
1379         TeamWalletMinted = TeamWalletMinted + numberOfNfts;
1380         require(TeamWalletMinted <= teamLimit, " Mint limit exceeded");
1381         for(uint256 i=0; i< numberOfNfts; i++){
1382         _mintNft(msg.sender);
1383         }
1384     }
1385 
1386  
1387     
1388 function getNFTMintedByUser(address user) external view returns (uint256[] memory ids){
1389     return(mintedByUser[user]);
1390 }
1391      // returns uri of a particular token
1392     function tokenURI(uint256 tokenId)
1393         public
1394         view
1395         override
1396         returns (string memory)
1397     {
1398         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1399         string memory _tokenURI = _tokenURIs[tokenId];
1400 
1401         return _tokenURI;
1402     }
1403 
1404 function ownerOfTokenId(address user) external view returns(uint256[] memory ids){
1405   uint256 count = 0;
1406   for(uint256 i=0; i<_tokenIdTracker.current();i++){
1407       if(ownerOf(i)== user){
1408           count++;
1409       }
1410 
1411   }
1412   uint256[] memory tokenIds = new uint256[](count);
1413   uint256 counter = 0;
1414    for(uint256 i=0; i<_tokenIdTracker.current();i++){
1415       if(ownerOf(i)== user){
1416           tokenIds[counter] = i;
1417           counter++;
1418       }
1419 
1420   }
1421    return(tokenIds);
1422 }    
1423 
1424    receive() external payable {}
1425     fallback() external payable {}
1426 
1427 }