1 // SPDX-License-Identifier: MIT
2 // File: contracts/LedgersNFT.sol
3 
4 
5 
6 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
7 pragma solidity ^0.8.0;
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 pragma solidity ^0.8.0;
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
167 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
168 pragma solidity ^0.8.0;
169 /**
170  * @dev Implementation of the {IERC165} interface.
171  *
172  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
173  * for the additional interface id that will be supported. For example:
174  *
175  * ```solidity
176  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
177  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
178  * }
179  * ```
180  *
181  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
182  */
183 abstract contract ERC165 is IERC165 {
184     /**
185      * @dev See {IERC165-supportsInterface}.
186      */
187     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
188         return interfaceId == type(IERC165).interfaceId;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Strings.sol
193 
194 
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev String operations.
200  */
201 library Strings {
202     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
203 
204     /**
205      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
206      */
207     function toString(uint256 value) internal pure returns (string memory) {
208         // Inspired by OraclizeAPI's implementation - MIT licence
209         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
210 
211         if (value == 0) {
212             return "0";
213         }
214         uint256 temp = value;
215         uint256 digits;
216         while (temp != 0) {
217             digits++;
218             temp /= 10;
219         }
220         bytes memory buffer = new bytes(digits);
221         while (value != 0) {
222             digits -= 1;
223             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
224             value /= 10;
225         }
226         return string(buffer);
227     }
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
231      */
232     function toHexString(uint256 value) internal pure returns (string memory) {
233         if (value == 0) {
234             return "0x00";
235         }
236         uint256 temp = value;
237         uint256 length = 0;
238         while (temp != 0) {
239             length++;
240             temp >>= 8;
241         }
242         return toHexString(value, length);
243     }
244 
245     /**
246      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
247      */
248     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
249         bytes memory buffer = new bytes(2 * length + 2);
250         buffer[0] = "0";
251         buffer[1] = "x";
252         for (uint256 i = 2 * length + 1; i > 1; --i) {
253             buffer[i] = _HEX_SYMBOLS[value & 0xf];
254             value >>= 4;
255         }
256         require(value == 0, "Strings: hex length insufficient");
257         return string(buffer);
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // This method relies on extcodesize, which returns 0 for contracts in
290         // construction, since the code is only stored at the end of the
291         // constructor execution.
292 
293         uint256 size;
294         assembly {
295             size := extcodesize(account)
296         }
297         return size > 0;
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{value: amount}("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain `call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.call{value: value}(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
404         return functionStaticCall(target, data, "Address: low-level static call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
481 
482 
483 
484 pragma solidity ^0.8.0;
485 
486 
487 /**
488  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
489  * @dev See https://eips.ethereum.org/EIPS/eip-721
490  */
491 interface IERC721Metadata is IERC721 {
492     /**
493      * @dev Returns the token collection name.
494      */
495     function name() external view returns (string memory);
496 
497     /**
498      * @dev Returns the token collection symbol.
499      */
500     function symbol() external view returns (string memory);
501 
502     /**
503      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
504      */
505     function tokenURI(uint256 tokenId) external view returns (string memory);
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @title ERC721 token receiver interface
516  * @dev Interface for any contract that wants to support safeTransfers
517  * from ERC721 asset contracts.
518  */
519 interface IERC721Receiver {
520     /**
521      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
522      * by `operator` from `from`, this function is called.
523      *
524      * It must return its Solidity selector to confirm the token transfer.
525      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
526      *
527      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
528      */
529     function onERC721Received(
530         address operator,
531         address from,
532         uint256 tokenId,
533         bytes calldata data
534     ) external returns (bytes4);
535 }
536 
537 // File: @openzeppelin/contracts/utils/Context.sol
538 pragma solidity ^0.8.0;
539 /**
540  * @dev Provides information about the current execution context, including the
541  * sender of the transaction and its data. While these are generally available
542  * via msg.sender and msg.data, they should not be accessed in such a direct
543  * manner, since when dealing with meta-transactions the account sending and
544  * paying for execution may not be the actual sender (as far as an application
545  * is concerned).
546  *
547  * This contract is only required for intermediate, library-like contracts.
548  */
549 abstract contract Context {
550     function _msgSender() internal view virtual returns (address) {
551         return msg.sender;
552     }
553 
554     function _msgData() internal view virtual returns (bytes calldata) {
555         return msg.data;
556     }
557 }
558 
559 
560 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
561 pragma solidity ^0.8.0;
562 /**
563  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
564  * the Metadata extension, but not including the Enumerable extension, which is available separately as
565  * {ERC721Enumerable}.
566  */
567 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
568     using Address for address;
569     using Strings for uint256;
570 
571     // Token name
572     string private _name;
573 
574     // Token symbol
575     string private _symbol;
576 
577     // Mapping from token ID to owner address
578     mapping(uint256 => address) private _owners;
579 
580     // Mapping owner address to token count
581     mapping(address => uint256) private _balances;
582 
583     // Mapping from token ID to approved address
584     mapping(uint256 => address) private _tokenApprovals;
585 
586     // Mapping from owner to operator approvals
587     mapping(address => mapping(address => bool)) private _operatorApprovals;
588 
589     /**
590      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
591      */
592     constructor(string memory name_, string memory symbol_) {
593         _name = name_;
594         _symbol = symbol_;
595     }
596 
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      */
600     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
601         return
602             interfaceId == type(IERC721).interfaceId ||
603             interfaceId == type(IERC721Metadata).interfaceId ||
604             super.supportsInterface(interfaceId);
605     }
606 
607     /**
608      * @dev See {IERC721-balanceOf}.
609      */
610     function balanceOf(address owner) public view virtual override returns (uint256) {
611         require(owner != address(0), "ERC721: balance query for the zero address");
612         return _balances[owner];
613     }
614 
615     /**
616      * @dev See {IERC721-ownerOf}.
617      */
618     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
619         address owner = _owners[tokenId];
620         require(owner != address(0), "ERC721: owner query for nonexistent token");
621         return owner;
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-name}.
626      */
627     function name() public view virtual override returns (string memory) {
628         return _name;
629     }
630 
631     /**
632      * @dev See {IERC721Metadata-symbol}.
633      */
634     function symbol() public view virtual override returns (string memory) {
635         return _symbol;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-tokenURI}.
640      */
641     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
642         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
643 
644         string memory baseURI = _baseURI();
645         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
646     }
647 
648     /**
649      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
650      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
651      * by default, can be overriden in child contracts.
652      */
653     function _baseURI() internal view virtual returns (string memory) {
654         return "";
655     }
656 
657     /**
658      * @dev See {IERC721-approve}.
659      */
660     function approve(address to, uint256 tokenId) public virtual override {
661         address owner = ERC721.ownerOf(tokenId);
662         require(to != owner, "ERC721: approval to current owner");
663 
664         require(
665             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
666             "ERC721: approve caller is not owner nor approved for all"
667         );
668 
669         _approve(to, tokenId);
670     }
671 
672     /**
673      * @dev See {IERC721-getApproved}.
674      */
675     function getApproved(uint256 tokenId) public view virtual override returns (address) {
676         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
677 
678         return _tokenApprovals[tokenId];
679     }
680 
681     /**
682      * @dev See {IERC721-setApprovalForAll}.
683      */
684     function setApprovalForAll(address operator, bool approved) public virtual override {
685         require(operator != _msgSender(), "ERC721: approve to caller");
686 
687         _operatorApprovals[_msgSender()][operator] = approved;
688         emit ApprovalForAll(_msgSender(), operator, approved);
689     }
690 
691     /**
692      * @dev See {IERC721-isApprovedForAll}.
693      */
694     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
695         return _operatorApprovals[owner][operator];
696     }
697 
698     /**
699      * @dev See {IERC721-transferFrom}.
700      */
701     function transferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) public virtual override {
706         //solhint-disable-next-line max-line-length
707         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
708 
709         _transfer(from, to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-safeTransferFrom}.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) public virtual override {
720         safeTransferFrom(from, to, tokenId, "");
721     }
722 
723     /**
724      * @dev See {IERC721-safeTransferFrom}.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) public virtual override {
732         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
733         _safeTransfer(from, to, tokenId, _data);
734     }
735 
736     /**
737      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
738      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
739      *
740      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
741      *
742      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
743      * implement alternative mechanisms to perform token transfer, such as signature-based.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function _safeTransfer(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) internal virtual {
760         _transfer(from, to, tokenId);
761         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
762     }
763 
764     /**
765      * @dev Returns whether `tokenId` exists.
766      *
767      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
768      *
769      * Tokens start existing when they are minted (`_mint`),
770      * and stop existing when they are burned (`_burn`).
771      */
772     function _exists(uint256 tokenId) internal view virtual returns (bool) {
773         return _owners[tokenId] != address(0);
774     }
775 
776     /**
777      * @dev Returns whether `spender` is allowed to manage `tokenId`.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
784         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
785         address owner = ERC721.ownerOf(tokenId);
786         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
787     }
788 
789     /**
790      * @dev Safely mints `tokenId` and transfers it to `to`.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must not exist.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _safeMint(address to, uint256 tokenId) internal virtual {
800         _safeMint(to, tokenId, "");
801     }
802 
803     /**
804      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
805      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
806      */
807     function _safeMint(
808         address to,
809         uint256 tokenId,
810         bytes memory _data
811     ) internal virtual {
812         _mint(to, tokenId);
813         require(
814             _checkOnERC721Received(address(0), to, tokenId, _data),
815             "ERC721: transfer to non ERC721Receiver implementer"
816         );
817     }
818 
819     /**
820      * @dev Mints `tokenId` and transfers it to `to`.
821      *
822      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
823      *
824      * Requirements:
825      *
826      * - `tokenId` must not exist.
827      * - `to` cannot be the zero address.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _mint(address to, uint256 tokenId) internal virtual {
832         require(to != address(0), "ERC721: mint to the zero address");
833         require(!_exists(tokenId), "ERC721: token already minted");
834 
835         _beforeTokenTransfer(address(0), to, tokenId);
836 
837         _balances[to] += 1;
838         _owners[tokenId] = to;
839 
840         emit Transfer(address(0), to, tokenId);
841     }
842 
843     /**
844      * @dev Destroys `tokenId`.
845      * The approval is cleared when the token is burned.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _burn(uint256 tokenId) internal virtual {
854         address owner = ERC721.ownerOf(tokenId);
855 
856         _beforeTokenTransfer(owner, address(0), tokenId);
857 
858         // Clear approvals
859         _approve(address(0), tokenId);
860 
861         _balances[owner] -= 1;
862         delete _owners[tokenId];
863 
864         emit Transfer(owner, address(0), tokenId);
865     }
866 
867     /**
868      * @dev Transfers `tokenId` from `from` to `to`.
869      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
870      *
871      * Requirements:
872      *
873      * - `to` cannot be the zero address.
874      * - `tokenId` token must be owned by `from`.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _transfer(
879         address from,
880         address to,
881         uint256 tokenId
882     ) internal virtual {
883         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
884         require(to != address(0), "ERC721: transfer to the zero address");
885 
886         _beforeTokenTransfer(from, to, tokenId);
887 
888         // Clear approvals from the previous owner
889         _approve(address(0), tokenId);
890 
891         _balances[from] -= 1;
892         _balances[to] += 1;
893         _owners[tokenId] = to;
894 
895         emit Transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev Approve `to` to operate on `tokenId`
900      *
901      * Emits a {Approval} event.
902      */
903     function _approve(address to, uint256 tokenId) internal virtual {
904         _tokenApprovals[tokenId] = to;
905         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
906     }
907 
908     /**
909      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
910      * The call is not executed if the target address is not a contract.
911      *
912      * @param from address representing the previous owner of the given token ID
913      * @param to target address that will receive the tokens
914      * @param tokenId uint256 ID of the token to be transferred
915      * @param _data bytes optional data to send along with the call
916      * @return bool whether the call correctly returned the expected magic value
917      */
918     function _checkOnERC721Received(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) private returns (bool) {
924         if (to.isContract()) {
925             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
926                 return retval == IERC721Receiver.onERC721Received.selector;
927             } catch (bytes memory reason) {
928                 if (reason.length == 0) {
929                     revert("ERC721: transfer to non ERC721Receiver implementer");
930                 } else {
931                     assembly {
932                         revert(add(32, reason), mload(reason))
933                     }
934                 }
935             }
936         } else {
937             return true;
938         }
939     }
940 
941     /**
942      * @dev Hook that is called before any token transfer. This includes minting
943      * and burning.
944      *
945      * Calling conditions:
946      *
947      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
948      * transferred to `to`.
949      * - When `from` is zero, `tokenId` will be minted for `to`.
950      * - When `to` is zero, ``from``'s `tokenId` will be burned.
951      * - `from` and `to` are never both zero.
952      *
953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
954      */
955     function _beforeTokenTransfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) internal virtual {}
960 }
961 
962 // File: @openzeppelin/contracts/access/Ownable.sol
963 pragma solidity ^0.8.0;
964 /**
965  * @dev Contract module which provides a basic access control mechanism, where
966  * there is an account (an owner) that can be granted exclusive access to
967  * specific functions.
968  *
969  * By default, the owner account will be the one that deploys the contract. This
970  * can later be changed with {transferOwnership}.
971  *
972  * This module is used through inheritance. It will make available the modifier
973  * `onlyOwner`, which can be applied to your functions to restrict their use to
974  * the owner.
975  */
976 abstract contract Ownable is Context {
977     address private _owner;
978 
979     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
980 
981     /**
982      * @dev Initializes the contract setting the deployer as the initial owner.
983      */
984     constructor() {
985         _setOwner(_msgSender());
986     }
987 
988     /**
989      * @dev Returns the address of the current owner.
990      */
991     function owner() public view virtual returns (address) {
992         return _owner;
993     }
994 
995     /**
996      * @dev Throws if called by any account other than the owner.
997      */
998     modifier onlyOwner() {
999         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1000         _;
1001     }
1002 
1003     /**
1004      * @dev Leaves the contract without owner. It will not be possible to call
1005      * `onlyOwner` functions anymore. Can only be called by the current owner.
1006      *
1007      * NOTE: Renouncing ownership will leave the contract without an owner,
1008      * thereby removing any functionality that is only available to the owner.
1009      */
1010     function renounceOwnership() public virtual onlyOwner {
1011         _setOwner(address(0));
1012     }
1013 
1014     /**
1015      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1016      * Can only be called by the current owner.
1017      */
1018     function transferOwnership(address newOwner) public virtual onlyOwner {
1019         require(newOwner != address(0), "Ownable: new owner is the zero address");
1020         _setOwner(newOwner);
1021     }
1022 
1023     function _setOwner(address newOwner) private {
1024         address oldOwner = _owner;
1025         _owner = newOwner;
1026         emit OwnershipTransferred(oldOwner, newOwner);
1027     }
1028 }
1029 
1030 pragma solidity >=0.7.0 <0.9.0;
1031 
1032 contract LedgersNFT is ERC721, Ownable {
1033   using Strings for uint256;
1034 
1035   string baseURI;
1036   string public baseExtension = ".json";
1037   uint256 public cost = 0.03 ether;
1038   uint256 public supply = 0;
1039   uint256 public maxSupply = 6767;
1040   uint256 public maxMintAmount = 10;
1041   bool public paused = true;
1042   bool public revealed = false;
1043   string public notRevealedUri;
1044 
1045   mapping(address => uint256) public mintCounter; 
1046 
1047   constructor() ERC721("Ledgers NFT", "LDG") {
1048   }
1049 
1050   // internal
1051   function _baseURI() internal view virtual override returns (string memory) {
1052     return baseURI;
1053   }
1054 
1055   // public
1056   function mint(uint256 _mintAmount) public payable {
1057     require(!paused, "contract is paused");
1058     require(_mintAmount > 0, "mint amount needs to be greater than 0");
1059     require(supply + _mintAmount <= maxSupply, "supply needs to be less than the max supply");
1060     
1061     if (msg.sender != owner()) {
1062       require(_mintAmount <= maxMintAmount, "amount needs to be less than the max");
1063       require(supply + _mintAmount <= 6650, "supply needs to be less than the max supply");
1064       require(mintCounter[msg.sender] + _mintAmount <= 30, "over wallet mint limit");
1065       mintCounter[msg.sender] = mintCounter[msg.sender] + _mintAmount;
1066       require(msg.value >= cost * _mintAmount, "need to have enough ETH");
1067     }
1068 
1069     for (uint256 i = 1; i <= _mintAmount; i++) {
1070       _safeMint(msg.sender, supply + 1);
1071       supply++;
1072     }
1073   }
1074 
1075   function tokenURI(uint256 tokenId)
1076     public
1077     view
1078     virtual
1079     override
1080     returns (string memory)
1081   {
1082     require(
1083       _exists(tokenId),
1084       "ERC721Metadata: URI query for nonexistent token"
1085     );
1086     
1087     if(revealed == false) {
1088         return notRevealedUri;
1089     }
1090 
1091     string memory currentBaseURI = _baseURI();
1092     return bytes(currentBaseURI).length > 0
1093         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1094         : "";
1095   }
1096 
1097   //only owner
1098   function reveal() public onlyOwner {
1099       revealed = true;
1100   }
1101   
1102   function setCost(uint256 _newCost) public onlyOwner {
1103     cost = _newCost;
1104   }
1105 
1106   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1107     maxMintAmount = _newmaxMintAmount;
1108   }
1109   
1110   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1111     notRevealedUri = _notRevealedURI;
1112   }
1113 
1114   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1115     baseURI = _newBaseURI;
1116   }
1117 
1118   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1119     baseExtension = _newBaseExtension;
1120   }
1121 
1122   function pause(bool _state) public onlyOwner {
1123     paused = _state;
1124   }
1125 
1126   function withdraw() public payable onlyOwner {
1127     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1128     require(os);
1129   }
1130 }