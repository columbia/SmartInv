1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-01-25
7 */
8 
9 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
10 
11 // SPDX-License-Identifier: MIT
12 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Interface of the ERC165 standard, as defined in the
18  * https://eips.ethereum.org/EIPS/eip-165[EIP].
19  *
20  * Implementers can declare support of contract interfaces, which can then be
21  * queried by others ({ERC165Checker}).
22  *
23  * For an implementation, see {ERC165}.
24  */
25 interface IERC165 {
26     /**
27      * @dev Returns true if this contract implements the interface defined by
28      * `interfaceId`. See the corresponding
29      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
30      * to learn more about how these ids are created.
31      *
32      * This function call must use less than 30 000 gas.
33      */
34     function supportsInterface(bytes4 interfaceId) external view returns (bool);
35 }
36 
37 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
38 
39 
40 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 
45 /**
46  * @dev Required interface of an ERC721 compliant contract.
47  */
48 interface IERC721 is IERC165 {
49     /**
50      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
56      */
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 }
181 
182 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @title ERC721 token receiver interface
191  * @dev Interface for any contract that wants to support safeTransfers
192  * from ERC721 asset contracts.
193  */
194 interface IERC721Receiver {
195     /**
196      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
197      * by `operator` from `from`, this function is called.
198      *
199      * It must return its Solidity selector to confirm the token transfer.
200      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
201      *
202      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
203      */
204     function onERC721Received(
205         address operator,
206         address from,
207         uint256 tokenId,
208         bytes calldata data
209     ) external returns (bytes4);
210 }
211 
212 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
216 
217 pragma solidity ^0.8.0;
218 
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
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
461 // File: @openzeppelin/contracts/utils/Context.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
488 // File: @openzeppelin/contracts/utils/Strings.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev String operations.
497  */
498 library Strings {
499     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
500 
501     /**
502      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
503      */
504     function toString(uint256 value) internal pure returns (string memory) {
505         // Inspired by OraclizeAPI's implementation - MIT licence
506         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
507 
508         if (value == 0) {
509             return "0";
510         }
511         uint256 temp = value;
512         uint256 digits;
513         while (temp != 0) {
514             digits++;
515             temp /= 10;
516         }
517         bytes memory buffer = new bytes(digits);
518         while (value != 0) {
519             digits -= 1;
520             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
521             value /= 10;
522         }
523         return string(buffer);
524     }
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
528      */
529     function toHexString(uint256 value) internal pure returns (string memory) {
530         if (value == 0) {
531             return "0x00";
532         }
533         uint256 temp = value;
534         uint256 length = 0;
535         while (temp != 0) {
536             length++;
537             temp >>= 8;
538         }
539         return toHexString(value, length);
540     }
541 
542     /**
543      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
544      */
545     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
546         bytes memory buffer = new bytes(2 * length + 2);
547         buffer[0] = "0";
548         buffer[1] = "x";
549         for (uint256 i = 2 * length + 1; i > 1; --i) {
550             buffer[i] = _HEX_SYMBOLS[value & 0xf];
551             value >>= 4;
552         }
553         require(value == 0, "Strings: hex length insufficient");
554         return string(buffer);
555     }
556 }
557 
558 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Implementation of the {IERC165} interface.
568  *
569  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
570  * for the additional interface id that will be supported. For example:
571  *
572  * ```solidity
573  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
575  * }
576  * ```
577  *
578  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
579  */
580 abstract contract ERC165 is IERC165 {
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         return interfaceId == type(IERC165).interfaceId;
586     }
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 
597 
598 
599 
600 
601 
602 
603 /**
604  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
605  * the Metadata extension, but not including the Enumerable extension, which is available separately as
606  * {ERC721Enumerable}.
607  */
608 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
609     using Address for address;
610     using Strings for uint256;
611 
612     // Token name
613     string private _name;
614 
615     // Token symbol
616     string private _symbol;
617 
618     // Mapping from token ID to owner address
619     mapping(uint256 => address) private _owners;
620 
621     // Mapping owner address to token count
622     mapping(address => uint256) private _balances;
623 
624     // Mapping from token ID to approved address
625     mapping(uint256 => address) private _tokenApprovals;
626 
627     // Mapping from owner to operator approvals
628     mapping(address => mapping(address => bool)) private _operatorApprovals;
629 
630     /**
631      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
632      */
633     constructor(string memory name_, string memory symbol_) {
634         _name = name_;
635         _symbol = symbol_;
636     }
637 
638     /**
639      * @dev See {IERC165-supportsInterface}.
640      */
641     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
642         return
643             interfaceId == type(IERC721).interfaceId ||
644             interfaceId == type(IERC721Metadata).interfaceId ||
645             super.supportsInterface(interfaceId);
646     }
647 
648     /**
649      * @dev See {IERC721-balanceOf}.
650      */
651     function balanceOf(address owner) public view virtual override returns (uint256) {
652         require(owner != address(0), "ERC721: balance query for the zero address");
653         return _balances[owner];
654     }
655 
656     /**
657      * @dev See {IERC721-ownerOf}.
658      */
659     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
660         address owner = _owners[tokenId];
661         require(owner != address(0), "ERC721: owner query for nonexistent token");
662         return owner;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-name}.
667      */
668     function name() public view virtual override returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-symbol}.
674      */
675     function symbol() public view virtual override returns (string memory) {
676         return _symbol;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-tokenURI}.
681      */
682     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
683         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
684 
685         string memory baseURI = _baseURI();
686         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
687     }
688 
689     /**
690      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
691      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
692      * by default, can be overriden in child contracts.
693      */
694     function _baseURI() internal view virtual returns (string memory) {
695         return "";
696     }
697 
698     /**
699      * @dev See {IERC721-approve}.
700      */
701     function approve(address to, uint256 tokenId) public virtual override {
702         address owner = ERC721.ownerOf(tokenId);
703         require(to != owner, "ERC721: approval to current owner");
704 
705         require(
706             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
707             "ERC721: approve caller is not owner nor approved for all"
708         );
709 
710         _approve(to, tokenId);
711     }
712 
713     /**
714      * @dev See {IERC721-getApproved}.
715      */
716     function getApproved(uint256 tokenId) public view virtual override returns (address) {
717         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
718 
719         return _tokenApprovals[tokenId];
720     }
721 
722     /**
723      * @dev See {IERC721-setApprovalForAll}.
724      */
725     function setApprovalForAll(address operator, bool approved) public virtual override {
726         _setApprovalForAll(_msgSender(), operator, approved);
727     }
728 
729     /**
730      * @dev See {IERC721-isApprovedForAll}.
731      */
732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         //solhint-disable-next-line max-line-length
745         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
746 
747         _transfer(from, to, tokenId);
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) public virtual override {
758         safeTransferFrom(from, to, tokenId, "");
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) public virtual override {
770         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
771         _safeTransfer(from, to, tokenId, _data);
772     }
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
776      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
777      *
778      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
779      *
780      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
781      * implement alternative mechanisms to perform token transfer, such as signature-based.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must exist and be owned by `from`.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeTransfer(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) internal virtual {
798         _transfer(from, to, tokenId);
799         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
800     }
801 
802     /**
803      * @dev Returns whether `tokenId` exists.
804      *
805      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
806      *
807      * Tokens start existing when they are minted (`_mint`),
808      * and stop existing when they are burned (`_burn`).
809      */
810     function _exists(uint256 tokenId) internal view virtual returns (bool) {
811         return _owners[tokenId] != address(0);
812     }
813 
814     /**
815      * @dev Returns whether `spender` is allowed to manage `tokenId`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must exist.
820      */
821     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
822         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
823         address owner = ERC721.ownerOf(tokenId);
824         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
825     }
826 
827     /**
828      * @dev Safely mints `tokenId` and transfers it to `to`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeMint(address to, uint256 tokenId) internal virtual {
838         _safeMint(to, tokenId, "");
839     }
840 
841     /**
842      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
843      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
844      */
845     function _safeMint(
846         address to,
847         uint256 tokenId,
848         bytes memory _data
849     ) internal virtual {
850         _mint(to, tokenId);
851         require(
852             _checkOnERC721Received(address(0), to, tokenId, _data),
853             "ERC721: transfer to non ERC721Receiver implementer"
854         );
855     }
856 
857     /**
858      * @dev Mints `tokenId` and transfers it to `to`.
859      *
860      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - `to` cannot be the zero address.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _mint(address to, uint256 tokenId) internal virtual {
870         require(to != address(0), "ERC721: mint to the zero address");
871         require(!_exists(tokenId), "ERC721: token already minted");
872 
873         _beforeTokenTransfer(address(0), to, tokenId);
874 
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(address(0), to, tokenId);
879     }
880 
881     /**
882      * @dev Destroys `tokenId`.
883      * The approval is cleared when the token is burned.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _burn(uint256 tokenId) internal virtual {
892         address owner = ERC721.ownerOf(tokenId);
893 
894         _beforeTokenTransfer(owner, address(0), tokenId);
895 
896         // Clear approvals
897         _approve(address(0), tokenId);
898 
899         _balances[owner] -= 1;
900         delete _owners[tokenId];
901 
902         emit Transfer(owner, address(0), tokenId);
903     }
904 
905     /**
906      * @dev Transfers `tokenId` from `from` to `to`.
907      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must be owned by `from`.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _transfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) internal virtual {
921         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
922         require(to != address(0), "ERC721: transfer to the zero address");
923 
924         _beforeTokenTransfer(from, to, tokenId);
925 
926         // Clear approvals from the previous owner
927         _approve(address(0), tokenId);
928 
929         _balances[from] -= 1;
930         _balances[to] += 1;
931         _owners[tokenId] = to;
932 
933         emit Transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev Approve `to` to operate on `tokenId`
938      *
939      * Emits a {Approval} event.
940      */
941     function _approve(address to, uint256 tokenId) internal virtual {
942         _tokenApprovals[tokenId] = to;
943         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
944     }
945 
946     /**
947      * @dev Approve `operator` to operate on all of `owner` tokens
948      *
949      * Emits a {ApprovalForAll} event.
950      */
951     function _setApprovalForAll(
952         address owner,
953         address operator,
954         bool approved
955     ) internal virtual {
956         require(owner != operator, "ERC721: approve to caller");
957         _operatorApprovals[owner][operator] = approved;
958         emit ApprovalForAll(owner, operator, approved);
959     }
960 
961     /**
962      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
963      * The call is not executed if the target address is not a contract.
964      *
965      * @param from address representing the previous owner of the given token ID
966      * @param to target address that will receive the tokens
967      * @param tokenId uint256 ID of the token to be transferred
968      * @param _data bytes optional data to send along with the call
969      * @return bool whether the call correctly returned the expected magic value
970      */
971     function _checkOnERC721Received(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) private returns (bool) {
977         if (to.isContract()) {
978             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
979                 return retval == IERC721Receiver.onERC721Received.selector;
980             } catch (bytes memory reason) {
981                 if (reason.length == 0) {
982                     revert("ERC721: transfer to non ERC721Receiver implementer");
983                 } else {
984                     assembly {
985                         revert(add(32, reason), mload(reason))
986                     }
987                 }
988             }
989         } else {
990             return true;
991         }
992     }
993 
994     /**
995      * @dev Hook that is called before any token transfer. This includes minting
996      * and burning.
997      *
998      * Calling conditions:
999      *
1000      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1001      * transferred to `to`.
1002      * - When `from` is zero, `tokenId` will be minted for `to`.
1003      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1004      * - `from` and `to` are never both zero.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _beforeTokenTransfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) internal virtual {}
1013 }
1014 
1015 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1016 
1017 
1018 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 /**
1024  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1025  * @dev See https://eips.ethereum.org/EIPS/eip-721
1026  */
1027 interface IERC721Enumerable is IERC721 {
1028     /**
1029      * @dev Returns the total amount of tokens stored by the contract.
1030      */
1031     function totalSupply() external view returns (uint256);
1032 
1033     /**
1034      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1035      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1036      */
1037     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1038 
1039     /**
1040      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1041      * Use along with {totalSupply} to enumerate all tokens.
1042      */
1043     function tokenByIndex(uint256 index) external view returns (uint256);
1044 }
1045 
1046 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1047 
1048 
1049 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 
1054 
1055 /**
1056  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1057  * enumerability of all the token ids in the contract as well as all token ids owned by each
1058  * account.
1059  */
1060 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1061     // Mapping from owner to list of owned token IDs
1062     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1063 
1064     // Mapping from token ID to index of the owner tokens list
1065     mapping(uint256 => uint256) private _ownedTokensIndex;
1066 
1067     // Array with all token ids, used for enumeration
1068     uint256[] private _allTokens;
1069 
1070     // Mapping from token id to position in the allTokens array
1071     mapping(uint256 => uint256) private _allTokensIndex;
1072 
1073     /**
1074      * @dev See {IERC165-supportsInterface}.
1075      */
1076     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1077         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1082      */
1083     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1084         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1085         return _ownedTokens[owner][index];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Enumerable-totalSupply}.
1090      */
1091     function totalSupply() public view virtual override returns (uint256) {
1092         return _allTokens.length;
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Enumerable-tokenByIndex}.
1097      */
1098     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1099         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1100         return _allTokens[index];
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before any token transfer. This includes minting
1105      * and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1110      * transferred to `to`.
1111      * - When `from` is zero, `tokenId` will be minted for `to`.
1112      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1113      * - `from` cannot be the zero address.
1114      * - `to` cannot be the zero address.
1115      *
1116      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1117      */
1118     function _beforeTokenTransfer(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) internal virtual override {
1123         super._beforeTokenTransfer(from, to, tokenId);
1124 
1125         if (from == address(0)) {
1126             _addTokenToAllTokensEnumeration(tokenId);
1127         } else if (from != to) {
1128             _removeTokenFromOwnerEnumeration(from, tokenId);
1129         }
1130         if (to == address(0)) {
1131             _removeTokenFromAllTokensEnumeration(tokenId);
1132         } else if (to != from) {
1133             _addTokenToOwnerEnumeration(to, tokenId);
1134         }
1135     }
1136 
1137     /**
1138      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1139      * @param to address representing the new owner of the given token ID
1140      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1141      */
1142     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1143         uint256 length = ERC721.balanceOf(to);
1144         _ownedTokens[to][length] = tokenId;
1145         _ownedTokensIndex[tokenId] = length;
1146     }
1147 
1148     /**
1149      * @dev Private function to add a token to this extension's token tracking data structures.
1150      * @param tokenId uint256 ID of the token to be added to the tokens list
1151      */
1152     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1153         _allTokensIndex[tokenId] = _allTokens.length;
1154         _allTokens.push(tokenId);
1155     }
1156 
1157     /**
1158      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1159      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1160      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1161      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1162      * @param from address representing the previous owner of the given token ID
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1164      */
1165     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1166         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1170         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary
1173         if (tokenIndex != lastTokenIndex) {
1174             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1175 
1176             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1177             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1178         }
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _ownedTokensIndex[tokenId];
1182         delete _ownedTokens[from][lastTokenIndex];
1183     }
1184 
1185     /**
1186      * @dev Private function to remove a token from this extension's token tracking data structures.
1187      * This has O(1) time complexity, but alters the order of the _allTokens array.
1188      * @param tokenId uint256 ID of the token to be removed from the tokens list
1189      */
1190     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1191         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1192         // then delete the last slot (swap and pop).
1193 
1194         uint256 lastTokenIndex = _allTokens.length - 1;
1195         uint256 tokenIndex = _allTokensIndex[tokenId];
1196 
1197         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1198         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1199         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1200         uint256 lastTokenId = _allTokens[lastTokenIndex];
1201 
1202         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1203         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1204 
1205         // This also deletes the contents at the last position of the array
1206         delete _allTokensIndex[tokenId];
1207         _allTokens.pop();
1208     }
1209 }
1210 
1211 // File: @openzeppelin/contracts/access/Ownable.sol
1212 
1213 
1214 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 
1219 /**
1220  * @dev Contract module which provides a basic access control mechanism, where
1221  * there is an account (an owner) that can be granted exclusive access to
1222  * specific functions.
1223  *
1224  * By default, the owner account will be the one that deploys the contract. This
1225  * can later be changed with {transferOwnership}.
1226  *
1227  * This module is used through inheritance. It will make available the modifier
1228  * `onlyOwner`, which can be applied to your functions to restrict their use to
1229  * the owner.
1230  */
1231 abstract contract Ownable is Context {
1232     address private _owner;
1233 
1234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1235 
1236     /**
1237      * @dev Initializes the contract setting the deployer as the initial owner.
1238      */
1239     constructor() {
1240         _transferOwnership(_msgSender());
1241     }
1242 
1243     /**
1244      * @dev Returns the address of the current owner.
1245      */
1246     function owner() public view virtual returns (address) {
1247         return _owner;
1248     }
1249 
1250     /**
1251      * @dev Throws if called by any account other than the owner.
1252      */
1253     modifier onlyOwner() {
1254         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1255         _;
1256     }
1257 
1258     /**
1259      * @dev Leaves the contract without owner. It will not be possible to call
1260      * `onlyOwner` functions anymore. Can only be called by the current owner.
1261      *
1262      * NOTE: Renouncing ownership will leave the contract without an owner,
1263      * thereby removing any functionality that is only available to the owner.
1264      */
1265     function renounceOwnership() public virtual onlyOwner {
1266         _transferOwnership(address(0));
1267     }
1268 
1269     /**
1270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1271      * Can only be called by the current owner.
1272      */
1273     function transferOwnership(address newOwner) public virtual onlyOwner {
1274         require(newOwner != address(0), "Ownable: new owner is the zero address");
1275         _transferOwnership(newOwner);
1276     }
1277 
1278     /**
1279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1280      * Internal function without access restriction.
1281      */
1282     function _transferOwnership(address newOwner) internal virtual {
1283         address oldOwner = _owner;
1284         _owner = newOwner;
1285         emit OwnershipTransferred(oldOwner, newOwner);
1286     }
1287 }
1288 
1289 pragma solidity ^0.8.0;
1290 
1291 /**
1292  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1293  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1294  *
1295  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1296  *
1297  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1298  *
1299  * Does not support burning tokens to address(0).
1300  */
1301 contract ERC721A is
1302   Context,
1303   ERC165,
1304   IERC721,
1305   IERC721Metadata,
1306   IERC721Enumerable
1307 {
1308   using Address for address;
1309   using Strings for uint256;
1310 
1311   struct TokenOwnership {
1312     address addr;
1313     uint64 startTimestamp;
1314   }
1315 
1316   struct AddressData {
1317     uint128 balance;
1318     uint128 numberMinted;
1319   }
1320 
1321   uint256 private currentIndex = 1;
1322 
1323   uint256 internal immutable collectionSize;
1324   uint256 internal immutable maxBatchSize;
1325 
1326   // Token name
1327   string private _name;
1328 
1329   // Token symbol
1330   string private _symbol;
1331 
1332   // Mapping from token ID to ownership details
1333   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1334   mapping(uint256 => TokenOwnership) private _ownerships;
1335 
1336   // Mapping owner address to address data
1337   mapping(address => AddressData) private _addressData;
1338 
1339   // Mapping from token ID to approved address
1340   mapping(uint256 => address) private _tokenApprovals;
1341 
1342   // Mapping from owner to operator approvals
1343   mapping(address => mapping(address => bool)) private _operatorApprovals;
1344 
1345   /**
1346    * @dev
1347    * `maxBatchSize` refers to how much a minter can mint at a time.
1348    * `collectionSize_` refers to how many tokens are in the collection.
1349    */
1350   constructor(
1351     string memory name_,
1352     string memory symbol_,
1353     uint256 maxBatchSize_,
1354     uint256 collectionSize_
1355   ) {
1356     require(
1357       collectionSize_ > 0,
1358       "ERC721A: collection must have a nonzero supply"
1359     );
1360     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1361     _name = name_;
1362     _symbol = symbol_;
1363     maxBatchSize = maxBatchSize_;
1364     collectionSize = collectionSize_;
1365   }
1366 
1367   /**
1368    * @dev See {IERC721Enumerable-totalSupply}.
1369    */
1370   function totalSupply() public view override returns (uint256) {
1371     return currentIndex;
1372   }
1373 
1374   /**
1375    * @dev See {IERC721Enumerable-tokenByIndex}.
1376    */
1377   function tokenByIndex(uint256 index) public view override returns (uint256) {
1378     require(index < totalSupply(), "ERC721A: global index out of bounds");
1379     return index;
1380   }
1381 
1382   /**
1383    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1384    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1385    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1386    */
1387   function tokenOfOwnerByIndex(address owner, uint256 index)
1388     public
1389     view
1390     override
1391     returns (uint256)
1392   {
1393     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1394     uint256 numMintedSoFar = totalSupply();
1395     uint256 tokenIdsIdx = 0;
1396     address currOwnershipAddr = address(0);
1397     for (uint256 i = 0; i < numMintedSoFar; i++) {
1398       TokenOwnership memory ownership = _ownerships[i];
1399       if (ownership.addr != address(0)) {
1400         currOwnershipAddr = ownership.addr;
1401       }
1402       if (currOwnershipAddr == owner) {
1403         if (tokenIdsIdx == index) {
1404           return i;
1405         }
1406         tokenIdsIdx++;
1407       }
1408     }
1409     revert("ERC721A: unable to get token of owner by index");
1410   }
1411 
1412   /**
1413    * @dev See {IERC165-supportsInterface}.
1414    */
1415   function supportsInterface(bytes4 interfaceId)
1416     public
1417     view
1418     virtual
1419     override(ERC165, IERC165)
1420     returns (bool)
1421   {
1422     return
1423       interfaceId == type(IERC721).interfaceId ||
1424       interfaceId == type(IERC721Metadata).interfaceId ||
1425       interfaceId == type(IERC721Enumerable).interfaceId ||
1426       super.supportsInterface(interfaceId);
1427   }
1428 
1429   /**
1430    * @dev See {IERC721-balanceOf}.
1431    */
1432   function balanceOf(address owner) public view override returns (uint256) {
1433     require(owner != address(0), "ERC721A: balance query for the zero address");
1434     return uint256(_addressData[owner].balance);
1435   }
1436 
1437   function _numberMinted(address owner) internal view returns (uint256) {
1438     require(
1439       owner != address(0),
1440       "ERC721A: number minted query for the zero address"
1441     );
1442     return uint256(_addressData[owner].numberMinted);
1443   }
1444 
1445   function ownershipOf(uint256 tokenId)
1446     internal
1447     view
1448     returns (TokenOwnership memory)
1449   {
1450     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1451 
1452     uint256 lowestTokenToCheck;
1453     if (tokenId >= maxBatchSize) {
1454       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1455     }
1456 
1457     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1458       TokenOwnership memory ownership = _ownerships[curr];
1459       if (ownership.addr != address(0)) {
1460         return ownership;
1461       }
1462     }
1463 
1464     revert("ERC721A: unable to determine the owner of token");
1465   }
1466 
1467   /**
1468    * @dev See {IERC721-ownerOf}.
1469    */
1470   function ownerOf(uint256 tokenId) public view override returns (address) {
1471     return ownershipOf(tokenId).addr;
1472   }
1473 
1474   /**
1475    * @dev See {IERC721Metadata-name}.
1476    */
1477   function name() public view virtual override returns (string memory) {
1478     return _name;
1479   }
1480 
1481   /**
1482    * @dev See {IERC721Metadata-symbol}.
1483    */
1484   function symbol() public view virtual override returns (string memory) {
1485     return _symbol;
1486   }
1487 
1488   /**
1489    * @dev See {IERC721Metadata-tokenURI}.
1490    */
1491   function tokenURI(uint256 tokenId)
1492     public
1493     view
1494     virtual
1495     override
1496     returns (string memory)
1497   {
1498     require(
1499       _exists(tokenId),
1500       "ERC721Metadata: URI query for nonexistent token"
1501     );
1502 
1503     string memory baseURI = _baseURI();
1504     return
1505       bytes(baseURI).length > 0
1506         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1507         : "";
1508   }
1509 
1510   /**
1511    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1512    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1513    * by default, can be overriden in child contracts.
1514    */
1515   function _baseURI() internal view virtual returns (string memory) {
1516     return "";
1517   }
1518 
1519   /**
1520    * @dev See {IERC721-approve}.
1521    */
1522   function approve(address to, uint256 tokenId) public override {
1523     address owner = ERC721A.ownerOf(tokenId);
1524     require(to != owner, "ERC721A: approval to current owner");
1525 
1526     require(
1527       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1528       "ERC721A: approve caller is not owner nor approved for all"
1529     );
1530 
1531     _approve(to, tokenId, owner);
1532   }
1533 
1534   /**
1535    * @dev See {IERC721-getApproved}.
1536    */
1537   function getApproved(uint256 tokenId) public view override returns (address) {
1538     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1539 
1540     return _tokenApprovals[tokenId];
1541   }
1542 
1543   /**
1544    * @dev See {IERC721-setApprovalForAll}.
1545    */
1546   function setApprovalForAll(address operator, bool approved) public override {
1547     require(operator != _msgSender(), "ERC721A: approve to caller");
1548 
1549     _operatorApprovals[_msgSender()][operator] = approved;
1550     emit ApprovalForAll(_msgSender(), operator, approved);
1551   }
1552 
1553   /**
1554    * @dev See {IERC721-isApprovedForAll}.
1555    */
1556   function isApprovedForAll(address owner, address operator)
1557     public
1558     view
1559     virtual
1560     override
1561     returns (bool)
1562   {
1563     return _operatorApprovals[owner][operator];
1564   }
1565 
1566   /**
1567    * @dev See {IERC721-transferFrom}.
1568    */
1569   function transferFrom(
1570     address from,
1571     address to,
1572     uint256 tokenId
1573   ) public override {
1574     _transfer(from, to, tokenId);
1575   }
1576 
1577   /**
1578    * @dev See {IERC721-safeTransferFrom}.
1579    */
1580   function safeTransferFrom(
1581     address from,
1582     address to,
1583     uint256 tokenId
1584   ) public override {
1585     safeTransferFrom(from, to, tokenId, "");
1586   }
1587 
1588   /**
1589    * @dev See {IERC721-safeTransferFrom}.
1590    */
1591   function safeTransferFrom(
1592     address from,
1593     address to,
1594     uint256 tokenId,
1595     bytes memory _data
1596   ) public override {
1597     _transfer(from, to, tokenId);
1598     require(
1599       _checkOnERC721Received(from, to, tokenId, _data),
1600       "ERC721A: transfer to non ERC721Receiver implementer"
1601     );
1602   }
1603 
1604   /**
1605    * @dev Returns whether `tokenId` exists.
1606    *
1607    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1608    *
1609    * Tokens start existing when they are minted (`_mint`),
1610    */
1611   function _exists(uint256 tokenId) internal view returns (bool) {
1612     return tokenId < currentIndex;
1613   }
1614 
1615   function _safeMint(address to, uint256 quantity) internal {
1616     _safeMint(to, quantity, "");
1617   }
1618 
1619   /**
1620    * @dev Mints `quantity` tokens and transfers them to `to`.
1621    *
1622    * Requirements:
1623    *
1624    * - there must be `quantity` tokens remaining unminted in the total collection.
1625    * - `to` cannot be the zero address.
1626    * - `quantity` cannot be larger than the max batch size.
1627    *
1628    * Emits a {Transfer} event.
1629    */
1630   function _safeMint(
1631     address to,
1632     uint256 quantity,
1633     bytes memory _data
1634   ) internal {
1635     uint256 startTokenId = currentIndex;
1636     require(to != address(0), "ERC721A: mint to the zero address");
1637     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1638     require(!_exists(startTokenId), "ERC721A: token already minted");
1639     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1640 
1641     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1642 
1643     AddressData memory addressData = _addressData[to];
1644     _addressData[to] = AddressData(
1645       addressData.balance + uint128(quantity),
1646       addressData.numberMinted + uint128(quantity)
1647     );
1648     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1649 
1650     uint256 updatedIndex = startTokenId;
1651 
1652     for (uint256 i = 0; i < quantity; i++) {
1653       emit Transfer(address(0), to, updatedIndex);
1654       require(
1655         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1656         "ERC721A: transfer to non ERC721Receiver implementer"
1657       );
1658       updatedIndex++;
1659     }
1660 
1661     currentIndex = updatedIndex;
1662     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1663   }
1664 
1665   /**
1666    * @dev Transfers `tokenId` from `from` to `to`.
1667    *
1668    * Requirements:
1669    *
1670    * - `to` cannot be the zero address.
1671    * - `tokenId` token must be owned by `from`.
1672    *
1673    * Emits a {Transfer} event.
1674    */
1675   function _transfer(
1676     address from,
1677     address to,
1678     uint256 tokenId
1679   ) private {
1680     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1681 
1682     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1683       getApproved(tokenId) == _msgSender() ||
1684       isApprovedForAll(prevOwnership.addr, _msgSender()));
1685 
1686     require(
1687       isApprovedOrOwner,
1688       "ERC721A: transfer caller is not owner nor approved"
1689     );
1690 
1691     require(
1692       prevOwnership.addr == from,
1693       "ERC721A: transfer from incorrect owner"
1694     );
1695     require(to != address(0), "ERC721A: transfer to the zero address");
1696 
1697     _beforeTokenTransfers(from, to, tokenId, 1);
1698 
1699     // Clear approvals from the previous owner
1700     _approve(address(0), tokenId, prevOwnership.addr);
1701 
1702     _addressData[from].balance -= 1;
1703     _addressData[to].balance += 1;
1704     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1705 
1706     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1707     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1708     uint256 nextTokenId = tokenId + 1;
1709     if (_ownerships[nextTokenId].addr == address(0)) {
1710       if (_exists(nextTokenId)) {
1711         _ownerships[nextTokenId] = TokenOwnership(
1712           prevOwnership.addr,
1713           prevOwnership.startTimestamp
1714         );
1715       }
1716     }
1717 
1718     emit Transfer(from, to, tokenId);
1719     _afterTokenTransfers(from, to, tokenId, 1);
1720   }
1721 
1722   /**
1723    * @dev Approve `to` to operate on `tokenId`
1724    *
1725    * Emits a {Approval} event.
1726    */
1727   function _approve(
1728     address to,
1729     uint256 tokenId,
1730     address owner
1731   ) private {
1732     _tokenApprovals[tokenId] = to;
1733     emit Approval(owner, to, tokenId);
1734   }
1735 
1736   uint256 public nextOwnerToExplicitlySet = 0;
1737 
1738   /**
1739    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1740    */
1741   function _setOwnersExplicit(uint256 quantity) internal {
1742     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1743     require(quantity > 0, "quantity must be nonzero");
1744     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1745     if (endIndex > collectionSize - 1) {
1746       endIndex = collectionSize - 1;
1747     }
1748     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1749     require(_exists(endIndex), "not enough minted yet for this cleanup");
1750     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1751       if (_ownerships[i].addr == address(0)) {
1752         TokenOwnership memory ownership = ownershipOf(i);
1753         _ownerships[i] = TokenOwnership(
1754           ownership.addr,
1755           ownership.startTimestamp
1756         );
1757       }
1758     }
1759     nextOwnerToExplicitlySet = endIndex + 1;
1760   }
1761 
1762   /**
1763    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1764    * The call is not executed if the target address is not a contract.
1765    *
1766    * @param from address representing the previous owner of the given token ID
1767    * @param to target address that will receive the tokens
1768    * @param tokenId uint256 ID of the token to be transferred
1769    * @param _data bytes optional data to send along with the call
1770    * @return bool whether the call correctly returned the expected magic value
1771    */
1772   function _checkOnERC721Received(
1773     address from,
1774     address to,
1775     uint256 tokenId,
1776     bytes memory _data
1777   ) private returns (bool) {
1778     if (to.isContract()) {
1779       try
1780         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1781       returns (bytes4 retval) {
1782         return retval == IERC721Receiver(to).onERC721Received.selector;
1783       } catch (bytes memory reason) {
1784         if (reason.length == 0) {
1785           revert("ERC721A: transfer to non ERC721Receiver implementer");
1786         } else {
1787           assembly {
1788             revert(add(32, reason), mload(reason))
1789           }
1790         }
1791       }
1792     } else {
1793       return true;
1794     }
1795   }
1796 
1797   /**
1798    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1799    *
1800    * startTokenId - the first token id to be transferred
1801    * quantity - the amount to be transferred
1802    *
1803    * Calling conditions:
1804    *
1805    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1806    * transferred to `to`.
1807    * - When `from` is zero, `tokenId` will be minted for `to`.
1808    */
1809   function _beforeTokenTransfers(
1810     address from,
1811     address to,
1812     uint256 startTokenId,
1813     uint256 quantity
1814   ) internal virtual {}
1815 
1816   /**
1817    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1818    * minting.
1819    *
1820    * startTokenId - the first token id to be transferred
1821    * quantity - the amount to be transferred
1822    *
1823    * Calling conditions:
1824    *
1825    * - when `from` and `to` are both non-zero.
1826    * - `from` and `to` are never both zero.
1827    */
1828   function _afterTokenTransfers(
1829     address from,
1830     address to,
1831     uint256 startTokenId,
1832     uint256 quantity
1833   ) internal virtual {}
1834 }
1835 
1836 /*
1837  *  Claim reserved NFTs 
1838  *  Created by entertainm.io
1839  */
1840 
1841 pragma solidity ^0.8.0;
1842 
1843 abstract contract CocktailClaimer {
1844     
1845     mapping( address => uint256 ) public stakerReserveLog;
1846     
1847     constructor() {
1848         setStakerAccess();
1849     }
1850     
1851     function setStakerAccess() internal {
1852       stakerReserveLog[ address(0x05a7a6234699399f0151D151D541E2c78B539683)  ] = 303;
1853       stakerReserveLog[ address(0x61481241bfB332757F02AF23FdC4655B555Bf9B2)  ] = 276;
1854       stakerReserveLog[ address(0xee6443d4eaeC0F72C721F7a714576DcF957fd67F)  ] = 210;
1855       stakerReserveLog[ address(0x642b339dff1B16efc62cC6c4EEC570307630E7ff)  ] = 145;
1856       stakerReserveLog[ address(0xc67452f4a50667f752cF41F5477488f8f5aA6B67)  ] = 100;
1857       stakerReserveLog[ address(0xa651b9E7d79d98cB07910Edd3e7952ebbD961f63)  ] = 92;
1858       stakerReserveLog[ address(0x4cBD07e1b723eC2334c5c33dFC92DA94cbF8994C)  ] = 88;
1859       stakerReserveLog[ address(0x8537BeFc73f2a8e3f8dB3a2314105A9F78528897)  ] = 85;
1860       stakerReserveLog[ address(0xfC6FcCD05A4e82C787888D9597C29527bf7310EF)  ] = 84;
1861       stakerReserveLog[ address(0x962Fb10CBE3E16757bFDef1863e277255a42D633)  ] = 80;
1862       stakerReserveLog[ address(0x3A6e48a9715AaDe7BC6b69aF435114721F9f6FE4)  ] = 78;
1863       stakerReserveLog[ address(0x61E1c9393CF4315638357BeCc8c75e5104EC2f01)  ] = 76;
1864       stakerReserveLog[ address(0x962Fb10CBE3E16757bFDef1863e277255a42D633)  ] = 73;
1865       stakerReserveLog[ address(0x8a305afD6521624dbd733FE41BD8Dd0Bb1eccB78)  ] = 73;
1866       stakerReserveLog[ address(0xF17f3Aa92518bAAA22C6cEC81744Dbb52321A4dD)  ] = 71;
1867       stakerReserveLog[ address(0xa8cAe97E267C10Ec56acfd9b808A284df3C4b00C)  ] = 70;
1868       stakerReserveLog[ address(0xd14543Be408f93559dc3017747797A5Ed251f825)  ] = 70;
1869       stakerReserveLog[ address(0x60314c86B99a2a108E5097fc2688AA1E3c30Be30)  ] = 68;
1870       stakerReserveLog[ address(0xBC54d698C48f8Da2531cC68F9Ca38aD27a1BDA4E)  ] = 68;
1871       stakerReserveLog[ address(0xAD4F5c944c49675cf275d8C674d9696b68B5D66D)  ] = 67;
1872       stakerReserveLog[ address(0x5874D43f23CafDebe7c9D913607dED8208Ed0AfA)  ] = 65;
1873       stakerReserveLog[ address(0xFCBE0C7c07fff72a3DCBfE69fe177515D6b5d926)  ] = 65;
1874       stakerReserveLog[ address(0x67eb29ED8C67C98575dD9cd49FdcE25B1218a5EE)  ] = 61;
1875       stakerReserveLog[ address(0x71F494b08dF932C87252B1129C24B45A5E77A9c6)  ] = 61;
1876       stakerReserveLog[ address(0xCA779fb29e1168321312a22CC0099BF910081F8f)  ] = 60;
1877       stakerReserveLog[ address(0x91F9068A506AcD5fD93399484f7D505733e65ba5)  ] = 60;
1878       stakerReserveLog[ address(0xc4795879b02091EDC192642A463d76A49D8CB4a6)  ] = 59;
1879       stakerReserveLog[ address(0xCcC596132a67c67915493BCCC9edE57fBcf64944)  ] = 56;
1880       stakerReserveLog[ address(0x1cf6f1A13084c8FBb750049Ed85C1FB2026792CE)  ] = 55;
1881       stakerReserveLog[ address(0x4505D32D3A6E42C3c9634FFa6E9a1925eD006b6d)  ] = 54;
1882       stakerReserveLog[ address(0x5791Aa30053389A755eB4D3D2b6Fbf4B3eBa927B)  ] = 54;
1883       stakerReserveLog[ address(0xA5f8756147A4ebFB40Bd32f4c789534B9Fc1E017)  ] = 53;
1884       stakerReserveLog[ address(0x1AC0475be8cBd5c6E547Eb5e71cDB223223a4b70)  ] = 52;
1885       stakerReserveLog[ address(0x0e279033eA931f98908cc52E1ABFCa60118CAeBA)  ] = 51;
1886       stakerReserveLog[ address(0x0c187Bc2DCcc26eD234a05e42801FA4E864Cf225)  ] = 50;
1887       stakerReserveLog[ address(0x86059d01E0C19e4fFb60b640D70C8bDF70082517)  ] = 49;
1888       stakerReserveLog[ address(0x67360FbbF936d0a16A718D136cA23e3F4910C15A)  ] = 48;
1889       stakerReserveLog[ address(0x1325c1F1310b8B44E450d22aa2cc72f9C6A02884)  ] = 48;
1890       stakerReserveLog[ address(0x02943c31E8ec7F64135D5635C54f60b377fe9c27)  ] = 47;
1891       stakerReserveLog[ address(0xB222147D7b97552FF3D3E8B2136f2Ccff98414A2)  ] = 46;
1892       stakerReserveLog[ address(0xBCCf45dE0226D4f7f102aF139E392392785a2243)  ] = 45;
1893       stakerReserveLog[ address(0x6744AC367Ba5F3bf3e9Fc32FB6fa0d721A1EA98a)  ] = 44;
1894       stakerReserveLog[ address(0x9D06117F640737B55140FF6Fa7d157748F70c946)  ] = 44;
1895       stakerReserveLog[ address(0x057eCa916B7207320b1916514dA3316f36546C85)  ] = 44;
1896       stakerReserveLog[ address(0xf71eA5dB26888f1f38E7DE3375030f32861c0803)  ] = 43;
1897       stakerReserveLog[ address(0x144757a24B61Cee2e593ADe64DA776759D786d73)  ] = 40;
1898       stakerReserveLog[ address(0xD5E35b78258118035E9A1767Fc3b0E07D2CE1234)  ] = 40;
1899       stakerReserveLog[ address(0x75b7328C016b840Af82Bf3fF01Daf0CDAFCec2fD)  ] = 39;
1900       stakerReserveLog[ address(0x4b31e16736B7c856224bffFBD0470d15F349779e)  ] = 38;
1901       stakerReserveLog[ address(0x05EF5F4e81Ec078F685f8e033580D3F93fF1609C)  ] = 38;
1902       stakerReserveLog[ address(0x8f85BDCbAD363bD67Bed3C1704B22f72e6679Eac)  ] = 38;
1903       stakerReserveLog[ address(0x72fa4Dba92817737FEA04430a5c5fB2D01467583)  ] = 37;
1904       stakerReserveLog[ address(0x618c74F416EcbC2215FC77bA4A70Da792FB5EDAF)  ] = 36;
1905       stakerReserveLog[ address(0x69D739E7BB3a52Fa381A9b1378a89C6A2959DfDb)  ] = 35;
1906       stakerReserveLog[ address(0x083578AcDA99E03B2E716676366577269943C980)  ] = 34;
1907       stakerReserveLog[ address(0x00aC4FBcABea927b5A56D1ef7Aa943d7e16Cd02C)  ] = 34;
1908       stakerReserveLog[ address(0xB6d69aa58B9eBAF211De055a3E4482c2a7074551)  ] = 34;
1909       stakerReserveLog[ address(0xAe3046078cd009072E131cC15564dAD94cBe985D)  ] = 34;
1910       stakerReserveLog[ address(0x8085840f492D93AA262059a99182952386cd5E91)  ] = 34;
1911       stakerReserveLog[ address(0xA678aAbf920B8B115d50b4FA72b6c6Fe692a5719)  ] = 33;
1912       stakerReserveLog[ address(0x1eAbb754B4a537DE37290435DAB29a2b36B2e55a)  ] = 33;
1913       stakerReserveLog[ address(0xC7086014ABeB5C730CC75D92F7439544039ad424)  ] = 32;
1914       stakerReserveLog[ address(0x9AF4b2Af4075dAb09b70A5195252EE356B2D31C0)  ] = 32;
1915       stakerReserveLog[ address(0x8e2a0c5A5CefBF95a04072ff5953b7F45810C2A9)  ] = 32;
1916       stakerReserveLog[ address(0x9683778152EddEE1636BAf20794d511461baeEd8)  ] = 31;
1917       stakerReserveLog[ address(0x2393930f99940f03994fEAc50704FF6F7eE521de)  ] = 31;
1918       stakerReserveLog[ address(0xb501F77A64Ebc732860c8f064665800C318b4847)  ] = 31;
1919       stakerReserveLog[ address(0xb5C00d898D3B2E776487c7E88F5b78592343309e)  ] = 31;
1920       stakerReserveLog[ address(0x2cEa922beDd4796265DDA912DEb2B5f61032F55F)  ] = 30;
1921       stakerReserveLog[ address(0xAB674D86bF1943C060cF0C3D8103A09F5299599C)  ] = 30;
1922       stakerReserveLog[ address(0x97EDF63009f01C259943595E65275C0A74eC9Efa)  ] = 30;
1923       stakerReserveLog[ address(0x860b661966De597b4154743DB5A09186fC81b565)  ] = 30;
1924       stakerReserveLog[ address(0x2309a6CCC10694F9811BB97e290Bb5B6675333Ce)  ] = 30;
1925       stakerReserveLog[ address(0x956978542459c88Da3B6573E9C6c159f67c0F955)  ] = 30;
1926       stakerReserveLog[ address(0x651741aD4945bE1B8fEC753168DA613FC2060c01)  ] = 29;
1927       stakerReserveLog[ address(0xDdA1C76e1805ACa2ed609Aec485FB43C54737075)  ] = 29;
1928       stakerReserveLog[ address(0x5528680C692adbfe993E4587567e69F7Ac65B12C)  ] = 29;
1929       stakerReserveLog[ address(0x84F1F7Ec4a5503d2A113C026d02Fc5F1EB9c899D)  ] = 29;
1930       stakerReserveLog[ address(0x41317e7cA1b415e3BEDA6e98346fa23e01d8D0B1)  ] = 29;
1931       stakerReserveLog[ address(0x27805aB336a56433397bABAFc3253d52Be8a7762)  ] = 28;
1932       stakerReserveLog[ address(0x6A329d74b030d0c4DD1669EAFeAeeCC534803E40)  ] = 28;
1933       stakerReserveLog[ address(0x01c7bc82925521e971C75eb50fE5E2b97f11F872)  ] = 28;
1934       stakerReserveLog[ address(0xB8cC38a0CDD8297dA6186E589aDf4D3EB41deA12)  ] = 28;
1935       stakerReserveLog[ address(0x62A090cb090379B6a8620BFa42577ECa1de5Aa13)  ] = 28;
1936       stakerReserveLog[ address(0xCf96368b5Bcf8656cE22C4df496102D9E71d279f)  ] = 28;
1937       stakerReserveLog[ address(0x2CE55667462e85B5D7A7a28BFaF5772199DcB666)  ] = 28;
1938       stakerReserveLog[ address(0xbc8944cA268E51cDB7726Ed3baB7d87C78796aAf)  ] = 27;
1939       stakerReserveLog[ address(0xDd8463c7e803d6A5E8711010cFfAfd977B54f744)  ] = 27;
1940       stakerReserveLog[ address(0xDAe527C4b4B466404055ae5BAA783454F7c5b59A)  ] = 27;
1941       stakerReserveLog[ address(0x892e1b672A437a89b1fDc6e310d96E8BFB16cdEf)  ] = 27;
1942       stakerReserveLog[ address(0x3ED9300270419eB20035fd3A18F9B3aba4A0ae23)  ] = 26;
1943       stakerReserveLog[ address(0x8D322ff8Dc31A44C682855979165f20b972112DB)  ] = 26;
1944       stakerReserveLog[ address(0x18C55b22FA947A9663438032048f9bcEc3c92e9A)  ] = 25;
1945       stakerReserveLog[ address(0x2cB66B548E687442E0ae603AEB1f7bCACc2A6F1f)  ] = 25;
1946       stakerReserveLog[ address(0xEd76E6b7E643A4476033c75Cb1f1fAeAe4cA12D9)  ] = 25;
1947       stakerReserveLog[ address(0xea4680339ad21382cd28ABbB274CfAC3df3E54a6)  ] = 25;
1948       stakerReserveLog[ address(0x4f7Cca651a6452941f617C5A461C5A55700330D7)  ] = 25;
1949       stakerReserveLog[ address(0xB1A30ecA11563e0F484E65cc4BbefC7715F1CE25)  ] = 25;
1950       stakerReserveLog[ address(0x91a693B30F5C1f04713a7228FC0676Db212dBc3F)  ] = 25;
1951       stakerReserveLog[ address(0x68AfA499A37878C73c2C51456a315C098B74Bd83)  ] = 24;
1952       stakerReserveLog[ address(0xd1c2c1eB4e3469F35769d7fb354fBD531b6e9c91)  ] = 24;
1953       stakerReserveLog[ address(0x4F83724a0Ec3F66e6cAc92b43916442Cf54f586d)  ] = 24;
1954       stakerReserveLog[ address(0x7E7c1A3541d2ff134f755ca58512B703906f2785)  ] = 24;
1955       stakerReserveLog[ address(0xa965dF87B467f25D7BbFA66f222bcBA299BDa3a8)  ] = 24;
1956       stakerReserveLog[ address(0xb2767629602Cf390168d4FFa52d283E894B01222)  ] = 24;
1957       stakerReserveLog[ address(0xD0BB6e64e1C6dEbADD41298E0fF39676630F03a8)  ] = 24;
1958       stakerReserveLog[ address(0x9C980F6069C241a5EbBE0A232F285Cce34131eF9)  ] = 24;
1959       stakerReserveLog[ address(0x850AF43e6728f225867aF041bc2a1E13437eC3d3)  ] = 24;
1960       stakerReserveLog[ address(0x207e2d5eA39cB9E38d1DD9Ba251707f1084694D8)  ] = 24;
1961       stakerReserveLog[ address(0xEa6f0dFd94b87Ba819310e7A430167474D0C7c6b)  ] = 24;
1962       stakerReserveLog[ address(0xaAA397b4Dce9AE40Aea19fD8695aC104f3bcA614)  ] = 23;
1963       stakerReserveLog[ address(0x64744bdF0312BAfaF82B1Fa142A1Bd72606F9Ea0)  ] = 23;
1964       stakerReserveLog[ address(0xf83A6d15eC451225A6B5a683BC2f85bf4dc35d13)  ] = 22;
1965       stakerReserveLog[ address(0x92b449114420c1b3F10324491727De57809f9Cc8)  ] = 22;
1966       stakerReserveLog[ address(0x104DEa01de4A993797444CC2c4619D48E76E0446)  ] = 22;
1967       stakerReserveLog[ address(0xcd00A56D065982ff5339A98C9f1f34f0A515A329)  ] = 22;
1968       stakerReserveLog[ address(0x816F81C3fA8368CDB1EaaD755ca50c62fdA9b60D)  ] = 22;
1969       stakerReserveLog[ address(0xb531320805C5BED1D46AEaDcF4F008FDF172DBDa)  ] = 22;
1970       stakerReserveLog[ address(0x00D4da27deDce60F859471D8f595fDB4aE861557)  ] = 22;
1971       stakerReserveLog[ address(0xb4dDF0235C74f7AF2E48f659607f6EA2F8616A5b)  ] = 21;
1972       stakerReserveLog[ address(0x12D7A3Fe8378E5aFce12581FfFa87d75855EB656)  ] = 21;
1973       stakerReserveLog[ address(0x4494d7FB34930cC147131d405bB21027Aded12f4)  ] = 21;
1974       stakerReserveLog[ address(0x3625645f0ceE90204F7c373aA55c1Ae262891693)  ] = 21;
1975       stakerReserveLog[ address(0x7754fCeA38769a9f3c3F99540d070240CA43351a)  ] = 21;
1976       stakerReserveLog[ address(0xE210Fa629e53721f46c9B28fE13dA66bf8a1fEFf)  ] = 21;
1977       stakerReserveLog[ address(0x1762DB6963c5F02EEDe0c3234d1d65B08595D032)  ] = 21;
1978       stakerReserveLog[ address(0x73f2Ab5dc5F47F9231149fCC24b3cBbC487D1AFb)  ] = 21;
1979       stakerReserveLog[ address(0x2445d9b342b8AD807d49334a0aaA928B07ba4aD4)  ] = 21;
1980       stakerReserveLog[ address(0x4476ab2c11b74576aa3abfAb19dde0aaDcFCA238)  ] = 21;
1981       stakerReserveLog[ address(0x459EE9ef16151a2946187c3139BE084D1dBA8d08)  ] = 21;
1982       stakerReserveLog[ address(0xf0EFedb980345dF4FC1175432B6C968efB221F80)  ] = 21;
1983       stakerReserveLog[ address(0x525baf5Fe2B580f8E867e45F3BC3556d6E9842E4)  ] = 21;
1984       stakerReserveLog[ address(0xACe9620B9Af1C0bb3ABC45E630CDEEbF2de4E023)  ] = 21;
1985       stakerReserveLog[ address(0xE421E19c69FFaEbE5f1548fDBa81D4b4Ad98688e)  ] = 21;
1986       stakerReserveLog[ address(0xa02E16777707446d626fDF1Fb17d9a9318F3EccA)  ] = 20;
1987       stakerReserveLog[ address(0xbB4aDec274c273818bA9473712F231a966A7F74A)  ] = 20;
1988       stakerReserveLog[ address(0xa73557ea8892d52E445A8c973B8a097a21189B96)  ] = 20;
1989       stakerReserveLog[ address(0x819fF8A68dc7440c63C5aDb810034380F3635E18)  ] = 20;
1990       stakerReserveLog[ address(0x4a9b4cea73531Ebbe64922639683574104e72E4E)  ] = 20;
1991       stakerReserveLog[ address(0x087CBAdf474d6248Ade1B06e3cC938cB34510F94)  ] = 20;
1992       stakerReserveLog[ address(0x00e68122d283cc3837E221cE7B2e08C1231BC269)  ] = 20;
1993       stakerReserveLog[ address(0xDA8D38d78589EDcf3F306ca122e1646aF913660D)  ] = 20;
1994       stakerReserveLog[ address(0x8fCF586D3B6fC5Bff8D2c612D56f18c2A0B992D4)  ] = 20;
1995       stakerReserveLog[ address(0x84F4EF52aC791aE14eE5935e4aa0427E271B347E)  ] = 20;
1996       stakerReserveLog[ address(0x9E6f98de1Bc2e28663492057552C5323C93A0996)  ] = 20;
1997       stakerReserveLog[ address(0x2455ca300C8EdfC9c96fb1FaB620621E19145233)  ] = 20;
1998       stakerReserveLog[ address(0xE6D860d6B04A00D55AEda46fB402a3d9A2Bce20c)  ] = 20;
1999       stakerReserveLog[ address(0x0c187Bc2DCcc26eD234a05e42801FA4E864Cf225)  ] = 19;
2000       stakerReserveLog[ address(0x086D87e70CEe08b5D33134c4445933AC9c13AC8a)  ] = 18;
2001       stakerReserveLog[ address(0x8EeC49C06322ad8181ca3bbAb3899507977Bb9D8)  ] = 18;
2002       stakerReserveLog[ address(0xD4BCE9c082e315b8E3D0A79bFB5c6daA36e9531B)  ] = 18;
2003       stakerReserveLog[ address(0x8D10af78548099A5b2Cf4f2ddE02CF14f6f8c2CE)  ] = 18;
2004       stakerReserveLog[ address(0x1Ee6FCa6b9BD318f13927a50c160C9B1ec6D7933)  ] = 18;
2005       stakerReserveLog[ address(0x623C04dd784cd3a937AB8511BbB165C872223A32)  ] = 18;
2006       stakerReserveLog[ address(0x885ADC65E090D56716fc897f4e2c505e0E620caB)  ] = 18;
2007       stakerReserveLog[ address(0x1a25D2e22289d4d49a98b9e5b4ed7383B106F746)  ] = 17;
2008       stakerReserveLog[ address(0x870Bf9b18227aa0d28C0f21689A21931aA4FE3DE)  ] = 17;
2009       stakerReserveLog[ address(0x9EC02aAE4653bd59aC2cE64A135c22Ade5c1856A)  ] = 17;
2010       stakerReserveLog[ address(0xE5E456AB0361e6Aba3325f84101F704adD175216)  ] = 17;
2011       stakerReserveLog[ address(0x3329dD0622d5ecA89a69e9C9D4854461136ef15b)  ] = 17;
2012       stakerReserveLog[ address(0xe62622CEC75cf038ff1246fB54fA88e5fA7a8D1e)  ] = 17;
2013       stakerReserveLog[ address(0x0783FD17d11589b59Ef7837803Bfb046c025C5Af)  ] = 16;
2014       stakerReserveLog[ address(0xA6f18cd918AE7b37e34aA59efC42849c1C973B9F)  ] = 16;
2015       stakerReserveLog[ address(0x9A55930661d1D8c594193f1CB3556c790c064781)  ] = 16;
2016       stakerReserveLog[ address(0x64fC6C7CAd57482844f239D9910336a03E6Ce831)  ] = 16;
2017       stakerReserveLog[ address(0xdbd690D439f47DFb5e76aCaDE43bAe4b9872cc70)  ] = 16;
2018       stakerReserveLog[ address(0x06A687b25900E4Fecb97b0212aD5590eD0467722)  ] = 16;
2019       stakerReserveLog[ address(0x36bD90e9785C8cffc576e70F946dEdb063Ffb418)  ] = 16;
2020       stakerReserveLog[ address(0xe269b26E1162B459410dC258945707720BB2b961)  ] = 16;
2021       stakerReserveLog[ address(0xb8E19Ee65163783CC335d158563fE867948e8005)  ] = 15;
2022       stakerReserveLog[ address(0xB3D5441c756dB13E3999551bd8191aB8C528e5fF)  ] = 15;
2023       stakerReserveLog[ address(0xf66ff43d0CF416F97eF2EACb190bC99Dc4436391)  ] = 15;
2024       stakerReserveLog[ address(0x0a1AA3d5C4dcae7F9b3E9F3b59EA36E4F8Fcf4f4)  ] = 15;
2025       stakerReserveLog[ address(0x706F652335bBE76Aae4f94bB68Fc2D8A53eF41E4)  ] = 15;
2026       stakerReserveLog[ address(0x6f04cc236BBdAbD0fd7A6DE77F47dc6843581151)  ] = 15;
2027       stakerReserveLog[ address(0x5e44357be9c3b4CeAbb30bD0E0A336608eCa0a3b)  ] = 14;
2028       stakerReserveLog[ address(0x59b8130B9b1Aa6313776649B17326AA668f7b7a6)  ] = 14;
2029       stakerReserveLog[ address(0x1180a73095e514Ac230538220828FD3C8b7a9909)  ] = 14;
2030       stakerReserveLog[ address(0x03F21d18402F65cEe60c9604f1C55ad6A2bf064e)  ] = 14;
2031       stakerReserveLog[ address(0xF86B48F340c88Af60eE0248E2e6Fd47358b62ED3)  ] = 14;
2032       stakerReserveLog[ address(0x91Bc36DB6925fD051A02e4dcB6804A736741e456)  ] = 13;
2033       stakerReserveLog[ address(0xeEcB0bA3Fb18C1Dd05228942E4b53E64E05C032B)  ] = 13;
2034       stakerReserveLog[ address(0x0F64B91bbb3cb3F32090a1aEC6C1B7de6381ff5a)  ] = 13;
2035       stakerReserveLog[ address(0xaF8B39955b7fa6497990A438b42BE5BD69D51816)  ] = 13;
2036       stakerReserveLog[ address(0xB18150275285BeCfcBb717f65B10Df2d211D5a02)  ] = 13;
2037       stakerReserveLog[ address(0x8E4544c1f65B02c8193fD6E24c127907BCfDfB8a)  ] = 13;
2038       stakerReserveLog[ address(0xC3EDF9a3aDB11B96Ded85E4B322D65dB127759dD)  ] = 13;
2039       stakerReserveLog[ address(0xcD1d1CCA481b0518639C8C6d3705A46d7a44d8FC)  ] = 13;
2040       stakerReserveLog[ address(0xBC058EcC77D40dB30a5AF8E1Ddc6bFA64bda195E)  ] = 12;
2041       stakerReserveLog[ address(0xc0234756810Da1FcE0551140C662586196f1869D)  ] = 12;
2042       stakerReserveLog[ address(0x18cF068bCf46fCcf4e3A3C96DC38291E03806908)  ] = 12;
2043       stakerReserveLog[ address(0xf43e716984D54C3D33Ee96fBB1b8F101d6c22C1C)  ] = 12;
2044       stakerReserveLog[ address(0xBeEA0c453B6400E56bE8394a3cAA7834b5881bb2)  ] = 12;
2045       stakerReserveLog[ address(0x4Fb7d58c887A7196b41B131bB1b5b50ebAc574cE)  ] = 12;
2046       stakerReserveLog[ address(0xb466716FE072B5D893dA56307B9063440CEd633A)  ] = 12;
2047       stakerReserveLog[ address(0xbA3E7a9E411feEd3CDa09aB4a8eDD3314E6b83Dd)  ] = 12;
2048       stakerReserveLog[ address(0xDA42629D5D0BdD2255560304043c78E7D736bc76)  ] = 12;
2049       stakerReserveLog[ address(0xcC6acBA2dF17134D18C94eaDa2B3399FDbfFC490)  ] = 12;
2050       stakerReserveLog[ address(0x5B8B6f909Eb67bCae679593E91d5bE3f14E9c5f3)  ] = 12;
2051       stakerReserveLog[ address(0x63C1f24400F053ff148c1476EE7d087AB108Dac3)  ] = 12;
2052       stakerReserveLog[ address(0xAE5559b20e871Dce1521bc2d3586E4E313BeDF34)  ] = 12;
2053       stakerReserveLog[ address(0x2B355cfaCd1F6453FeCe399f6399140Bc71ca437)  ] = 12;
2054       stakerReserveLog[ address(0x070fB67FBb8d73050C83088851e3862FfaBc15Cb)  ] = 12;
2055       stakerReserveLog[ address(0xbF1a53e1f37A886C68557ED827889D3AA7ED2589)  ] = 12;
2056       stakerReserveLog[ address(0x9f0046f1408268F302410c58bb399cd7a6865E2F)  ] = 12;
2057       stakerReserveLog[ address(0x7399e85324B71818D246d22fa090537Bff84e896)  ] = 11;
2058       stakerReserveLog[ address(0x00AfF2d72e92db35e3dB58fFCA62B3FC72B97422)  ] = 11;
2059       stakerReserveLog[ address(0x748C189a2321f9EeC6aa4f42e989c3Fae769bAb3)  ] = 11;
2060       stakerReserveLog[ address(0xAECDf6A9b599C7159803379e5F69FdCE5Fc49c2c)  ] = 11;
2061       stakerReserveLog[ address(0x90Ad1c591e114977cdBF2A718BC7C3D322981020)  ] = 11;
2062       stakerReserveLog[ address(0x4B0aeFb0cC74D521E4487084d1C9B88e35f9C80c)  ] = 11;
2063       stakerReserveLog[ address(0xa52d3dE9c8b0b21462F2C3A7a730C278ceC9eafC)  ] = 10;
2064       stakerReserveLog[ address(0xdBee763Cd99A5c443Af1971973f63f393B0bAc54)  ] = 10;
2065       stakerReserveLog[ address(0x1f8125672be2255C8541DeE989dbC16D3EA9304e)  ] = 10;
2066       stakerReserveLog[ address(0x918b84c61d5Fe6C0E57fbf6499216649Ed5C4AC1)  ] = 10;
2067       stakerReserveLog[ address(0x05265c4695e895177365d9AdCc291eD8ee6cfFbE)  ] = 10;
2068       stakerReserveLog[ address(0xc849a2a35145D609C46145F3a50e02913eD8990B)  ] = 10;
2069       stakerReserveLog[ address(0x86Aa372b6Dc962563D3c5eAB9c5457AE9bC56AC1)  ] = 10;
2070       stakerReserveLog[ address(0x69e69571d0d07EdBEde6c43849e8d877573eE6bf)  ] = 10;
2071       stakerReserveLog[ address(0xBD4222550deC41F66aF8B311D748dBF7c1e95768)  ] = 9;
2072       stakerReserveLog[ address(0x374D6392fCa56f3A96Fe6f9464d1A06B71379805)  ] = 9;
2073       stakerReserveLog[ address(0x3d3b44e1b9372Ff786aF1f160793AC580B2b22ae)  ] = 9;
2074       stakerReserveLog[ address(0x92fb6b5BC7f49b02E1d44c78FC5e671893F0E531)  ] = 9;
2075       stakerReserveLog[ address(0xc07fC1EA22B212AC109F951CebAAc119ccBC8413)  ] = 9;
2076       stakerReserveLog[ address(0xBbd5454fbA0D4269a70890A29D8A4816f439d737)  ] = 9;
2077       stakerReserveLog[ address(0xca31F049c9Cd8c0bc2B47FAc67aF658D6DA52a73)  ] = 9;
2078       stakerReserveLog[ address(0x5B4190c4376208BbCa4a27bB391425249469904E)  ] = 9;
2079       stakerReserveLog[ address(0xf10B2795F94dD6fE1EE70EC7c01cF071c4aDB524)  ] = 9;
2080       stakerReserveLog[ address(0x03bD7E336698a490EA51A4ECf2D4c06cC6ea3856)  ] = 9;
2081       stakerReserveLog[ address(0x483921291bBF0b5a32ECc20f698419AE55fB2eBc)  ] = 9;
2082       stakerReserveLog[ address(0x3d1a11dAAC4922F136d045aD85F2cAcC604A31C9)  ] = 9;
2083       stakerReserveLog[ address(0xeE4B71C36d17b1c70E438F8204907C5e068229cc)  ] = 8;
2084       stakerReserveLog[ address(0x9D47C98EB709603Aa82514F96b6EfA7939F2eDc1)  ] = 8;
2085       stakerReserveLog[ address(0x9886B7321D711754F9301300d4834ED839485462)  ] = 8;
2086       stakerReserveLog[ address(0xB7dB6634fFbF3af457d88c72f609433297cB1487)  ] = 8;
2087       stakerReserveLog[ address(0x1982d5A43bDcDf9C8F04a04Cf3665Fb03596Da80)  ] = 8;
2088       stakerReserveLog[ address(0xc52DDB928cEd386F3Fe8924CccCD71745ba11Ac9)  ] = 8;
2089       stakerReserveLog[ address(0xCb942dC11C304AB8F623417e26F4458c2a727fA7)  ] = 8;
2090       stakerReserveLog[ address(0xBd1A1fb692242676D7814dbB31a5Ee8c75EA656b)  ] = 8;
2091       stakerReserveLog[ address(0xfB1B0097517A29f9fDb7De750735cBC554E7791D)  ] = 8;
2092       stakerReserveLog[ address(0xDF8465e364C5Ba32bDB44D83B302Bd163622A263)  ] = 8;
2093       stakerReserveLog[ address(0xb00eC779b29C368953781B54cB231D202f388fbB)  ] = 8;
2094       stakerReserveLog[ address(0xc8467e8e6CF6380d99c644D3C9e183a537E90DC1)  ] = 8;
2095       stakerReserveLog[ address(0x140f7985c6BcC3A4c526394bd310cbc008BE4b1b)  ] = 8;
2096       stakerReserveLog[ address(0x5B5938604F7Ca00809f253cF6a2CFCB6Ab3F5992)  ] = 8;
2097       stakerReserveLog[ address(0xa7e9154dcE8c8aa1F395E17DD1F8b146aB799E4E)  ] = 8;
2098       stakerReserveLog[ address(0xB51E9b77d4973c4Dc3659A8d4E2fAD97F3723c73)  ] = 8;
2099       stakerReserveLog[ address(0x158f76b84E75B32ff3f80E026d47B3411c126250)  ] = 8;
2100       stakerReserveLog[ address(0x74C07Af588761e355Cc5319af150903B8333D1A4)  ] = 8;
2101       stakerReserveLog[ address(0x3a9C13AC4fB665cAB94A9555FF6Cc3ab4bbEDF5B)  ] = 8;
2102       stakerReserveLog[ address(0x1F61d37984288d815992b078B86f0f4610F79d0B)  ] = 8;
2103       stakerReserveLog[ address(0xcA059495aEB6a2ca3ab5Da0c6aeBa3F5944861F5)  ] = 8;
2104       stakerReserveLog[ address(0x49699e3eecdd72208B8B1D78CE3407F994d9f699)  ] = 7;
2105       stakerReserveLog[ address(0x303D80F0A4D997Fb48906772bfc6C5c0919a9319)  ] = 7;
2106       stakerReserveLog[ address(0x3a32affF419bC3a41c68Ddf793917CEdc6FF9Ad4)  ] = 7;
2107       stakerReserveLog[ address(0xF3998fd8f25Fe2Dcb53817746d3f51f78C7E35C1)  ] = 7;
2108       stakerReserveLog[ address(0x8925F18736637FcEac3Ed0e6D5871DF6809C5E94)  ] = 7;
2109       stakerReserveLog[ address(0x1499C87F66F369d5691Fe3ce807577c6f10DF992)  ] = 7;
2110       stakerReserveLog[ address(0xfa8ddaf49B3CB17B34F4Ab25299262fcbff5b6F5)  ] = 7;
2111       stakerReserveLog[ address(0xbE8050F2317417b9F9023D39776cC9dF74696131)  ] = 7;
2112       stakerReserveLog[ address(0xEE4925E025638cCF539c0292401d80071f7Efa24)  ] = 7;
2113       stakerReserveLog[ address(0x70353c3d40eA238423feBa3b7CB4be3F7406B6aE)  ] = 7;
2114       stakerReserveLog[ address(0xdaf749ba6328404285c7D86ccf8B01D5c1A24876)  ] = 7;
2115       stakerReserveLog[ address(0x838df7E0AC4EfCF27cB1C1Dd0EA18CB6cE366468)  ] = 7;
2116       stakerReserveLog[ address(0xC375AF9666078099A4CA193B3252Cc19F2af464B)  ] = 7;
2117       stakerReserveLog[ address(0xf8a6D7D51DFa46737D9010CED261155490c40Ed0)  ] = 6;
2118       stakerReserveLog[ address(0x8a285fa9529656864630095927335120208d3756)  ] = 6;
2119       stakerReserveLog[ address(0x7D55C7Dd860B2fBDa37ecAC08d7A2238CB6C03D3)  ] = 6;
2120       stakerReserveLog[ address(0xdDd1918AC0D873eb02feD2ac24251da75d983Fed)  ] = 6;
2121       stakerReserveLog[ address(0xBFF1e5D812C83C9392F45038270632CffC1Bc565)  ] = 6;
2122       stakerReserveLog[ address(0xb8255a69C09988D6d79083EebF538508743E7e80)  ] = 6;
2123       stakerReserveLog[ address(0x46d1A8BbF5bfFD0b804a83c13a719208fE2EE30c)  ] = 6;
2124       stakerReserveLog[ address(0x71D01033f8ffb379935C0d0e8474f45E6f92A972)  ] = 6;
2125       stakerReserveLog[ address(0x614F7863b421BDcDd62b5F504033957E80410555)  ] = 6;
2126       stakerReserveLog[ address(0x5a05cf16532d44732d11570C62c7983002795112)  ] = 6;
2127       stakerReserveLog[ address(0x8Cb88124230179014Ca7631b2dA5cA3bda5AbA00)  ] = 6;
2128       stakerReserveLog[ address(0x9DBE0cB89Fc07be11829475cEefBa667210b5797)  ] = 6;
2129       stakerReserveLog[ address(0x076462f6ac9cDC6995583b02f3AfE656E175580B)  ] = 6;
2130       stakerReserveLog[ address(0x6868B90BA68E48b3571928A7727201B9efE1D374)  ] = 6;
2131       stakerReserveLog[ address(0xe0B37eB3b7999642DeaD977CAD65A8b7C7e62073)  ] = 6;
2132       stakerReserveLog[ address(0x1D4C48320d293da6f416bb7ea444f3f638eBF464)  ] = 6;
2133       stakerReserveLog[ address(0xdDf6A1c1136C2B42481ad085d818F5BAbfD84849)  ] = 6;
2134       stakerReserveLog[ address(0x160b4A6Df57598C7e4e1B24371fA8E7EDa9244cd)  ] = 6;
2135       stakerReserveLog[ address(0x033b53EF4Ba5225160B78cF6CD7Ab08C8d5DBDa6)  ] = 6;
2136       stakerReserveLog[ address(0x53D93958403620EF1B9798f80369577aE809E1F3)  ] = 5;
2137       stakerReserveLog[ address(0x3cF9b27Fb14E83bf6b837C9981C961D377bB5d56)  ] = 5;
2138       stakerReserveLog[ address(0xC7622c949295BcBF40C4e6Ebd6F20db7Deb6746f)  ] = 5;
2139       stakerReserveLog[ address(0x33f065E9112D661f24C582F72688b02710795c6c)  ] = 5;
2140       stakerReserveLog[ address(0x43AEf37A726B41195BBe53428eF0E672aBAbba6B)  ] = 5;
2141       stakerReserveLog[ address(0x82c4D6Ab092A226d2e4f7c917990E0389390A3e8)  ] = 5;
2142       stakerReserveLog[ address(0x24855A2B42456BAdb4a628955c89388578Afb4A3)  ] = 5;
2143       stakerReserveLog[ address(0xAE3FA8178136D753Aae723a4dB62c9505e6477eb)  ] = 5;
2144       stakerReserveLog[ address(0x8b413FA207fcB8716d3E5F3b0a8880884a9fa1a7)  ] = 5;
2145       stakerReserveLog[ address(0xf60E43108D347Fe3B2191d76915741eacA6871B1)  ] = 5;
2146       stakerReserveLog[ address(0xf6fb5914115523ee81098047876F223E00Fc4Cdc)  ] = 5;
2147       stakerReserveLog[ address(0x2deE87d48f2ff96c284bF48f825D3f0333d89421)  ] = 5;
2148       stakerReserveLog[ address(0x32B461A21A88a65C29d5F88E27F986a14720E31c)  ] = 5;
2149       stakerReserveLog[ address(0xbB9Cba66efdb4831CA8139d76E8EB73c32C61848)  ] = 5;
2150       stakerReserveLog[ address(0xd4Cf55516c6b0A8e345195cdf58Acd6b83a2371F)  ] = 5;
2151       stakerReserveLog[ address(0x7d31bcFC94dc75823B2d08406D6a0f5aCa443989)  ] = 5;
2152       stakerReserveLog[ address(0x7444615a969c485A665Cd230A3d2083F38000781)  ] = 5;
2153       stakerReserveLog[ address(0x5ECbFfF5d7105C4bE407718BA3beEe78208b5581)  ] = 5;
2154       stakerReserveLog[ address(0x353c3ED77276D7c51c2AE0dE974557FdB7645CB2)  ] = 5;
2155       stakerReserveLog[ address(0x3722A8bBA8AeEcAcb5ef45208822bf935FBADb75)  ] = 5;
2156       stakerReserveLog[ address(0x0BFE9d38AE7ebB9213C4799bB82d70358F190aB6)  ] = 5;
2157       stakerReserveLog[ address(0x1A8EB494c2CEB2241C1572e663ff23211dEDf8Fc)  ] = 5;
2158       stakerReserveLog[ address(0x4C886776E556AAF3b59d3dcb4D0C8ade80C2Cb99)  ] = 5;
2159       stakerReserveLog[ address(0xa6aE8542F21108a84Eb065352d721e12D513F649)  ] = 5;
2160       stakerReserveLog[ address(0x7Fc7BfC4b36EbA867B60b62b9BB8aEacF3822062)  ] = 5;
2161       stakerReserveLog[ address(0xD781B34cbcE3c73f815D4a3b887c045E97BC2537)  ] = 5;
2162       stakerReserveLog[ address(0x32F0D391d7a2dA65E3995aF2D95192A0D07EC5ee)  ] = 5;
2163       stakerReserveLog[ address(0x174D444dc751433d238AD20975f01957a2C48741)  ] = 4;
2164       stakerReserveLog[ address(0xba75a436Eb388D6066E7859bd306669228d286F2)  ] = 4;
2165       stakerReserveLog[ address(0x621Ef8816661e837113b9975Fc82eA0086E8c8a4)  ] = 4;
2166       stakerReserveLog[ address(0x26E939aA71aea569a5df4FFCD89D618e47CaAe9F)  ] = 4;
2167       stakerReserveLog[ address(0x6891818d6D2fd16BAd34b49b10898EEdeefdE815)  ] = 4;
2168       stakerReserveLog[ address(0xd075D6339a075BdB4C5c9387abB2309e995851A6)  ] = 4;
2169       stakerReserveLog[ address(0x49945c2505D1330E071d49EF0c1bC724fddB650D)  ] = 4;
2170       stakerReserveLog[ address(0x38c86E5482BAC05Ff58A6F8EC6762E2a0DDb6Ef5)  ] = 4;
2171       stakerReserveLog[ address(0xD75a9fEb0dE749d2fb4C50EAc1Dc9ab561c6baa5)  ] = 4;
2172       stakerReserveLog[ address(0xCC1cE6B57a8DEbb3aB7cE6C1174A4EfFddf06b82)  ] = 4;
2173       stakerReserveLog[ address(0x048f8800D392fB97d34F813A6AC0E0F0F1ACf4FB)  ] = 4;
2174       stakerReserveLog[ address(0x645c829E92159CF1783744060cf86d26D9C38f5a)  ] = 4;
2175       stakerReserveLog[ address(0x5D6891b4451812dc670df87A63417e3d8273AE0E)  ] = 4;
2176       stakerReserveLog[ address(0xeAFf5514f3afaA6C398974E42F636f261ea9F617)  ] = 4;
2177       stakerReserveLog[ address(0xcDD38E23C7c59b5e5Ab9778c1552bE8bB3A00eab)  ] = 4;
2178       stakerReserveLog[ address(0xdad836760e9eeBD3d71E2Be2B5293cc360086346)  ] = 4;
2179       stakerReserveLog[ address(0x9Fc3c8BefB44DAAA07A66f05d3E0236B921b640A)  ] = 4;
2180       stakerReserveLog[ address(0xbAF45f436ae220747e449278A752017cC4708A6b)  ] = 4;
2181       stakerReserveLog[ address(0xC58BD7961088bC22Bb26232b7973973322E272f5)  ] = 4;
2182       stakerReserveLog[ address(0x7c7ec2Ef96e05582a0Bc999ba1613b2C235EfC20)  ] = 4;
2183       stakerReserveLog[ address(0xB040a24428A4BaB1F7DE05F017da8260d66625E2)  ] = 4;
2184       stakerReserveLog[ address(0x234Eb49594Be19ECc691F1E934fa27CD452ba8f1)  ] = 4;
2185       stakerReserveLog[ address(0x6e1eDe3BC2b7e16a48EB32b52D8De2925D907751)  ] = 4;
2186       stakerReserveLog[ address(0xA6D9107E7C6394141806217Dc207EbF3813b7443)  ] = 4;
2187       stakerReserveLog[ address(0x9Ae78e799b17F0ED3Af4C5aFCBA2cCbF5af4e905)  ] = 4;
2188       stakerReserveLog[ address(0xB9ACD89942Fbb70BEf9a8047858dFd3A8293c1eF)  ] = 4;
2189       stakerReserveLog[ address(0x81CE0B8dc0627355D75B9768304F1e7A09E125de)  ] = 4;
2190       stakerReserveLog[ address(0xa60b72668418Fb0d9928aE46cB79dbeb43e7C11E)  ] = 4;
2191       stakerReserveLog[ address(0x6E5a09e4C23A289e267aDD0207AC2F7f055147C0)  ] = 4;
2192       stakerReserveLog[ address(0x14861fc9b5C09A8E4c0551d122B1b6e0a662Ba30)  ] = 4;
2193       stakerReserveLog[ address(0x6b442eBAD72f3f400EC3C9b4Bb860E0913590456)  ] = 4;
2194       stakerReserveLog[ address(0xFfb8C9ec9951B1d22AE0676A8965de43412CeB7d)  ] = 4;
2195       stakerReserveLog[ address(0xf1db31022Ce06524E4fD36693dA2D485840b1543)  ] = 4;
2196       stakerReserveLog[ address(0xCf32E148528E51A62C8AA7959704D34075b2CC53)  ] = 4;
2197       stakerReserveLog[ address(0x55D2Fdaaa9c7358b0dE7f5c029577adF7d73702f)  ] = 4;
2198       stakerReserveLog[ address(0x118815Ec2Ef909dff5b9432B1f5C0f109c66176D)  ] = 4;
2199       stakerReserveLog[ address(0x190B11439a55Fc772E566EBa1A6D07D5b85a63D0)  ] = 4;
2200       stakerReserveLog[ address(0xF8DdE82f0875fCAe2F71b9c2B8e94f8f68a765C1)  ] = 4;
2201       stakerReserveLog[ address(0xB6354dC70143f869A1Ed0Bc7ad4B65d83d67284F)  ] = 4;
2202       stakerReserveLog[ address(0xC77320D1B3B4237fE0DD934Ec969483FEAeA45eD)  ] = 4;
2203       stakerReserveLog[ address(0x6A9af06aCC9fea0d75382FdaD8DbBaa41BbFa62d)  ] = 4;
2204       stakerReserveLog[ address(0x23a8F8fBA69cAad4De27feBfa883EfEa7c564bc6)  ] = 4;
2205       stakerReserveLog[ address(0xF69bC34B73DA823e18A6960975fB865a29B218A1)  ] = 4;
2206       stakerReserveLog[ address(0x064d875e4F384b5B1204F8Af98737C6f90da34e8)  ] = 4;
2207       stakerReserveLog[ address(0xFBd7bf4bf3EE2032848d21d6c6140C2400EC8553)  ] = 3;
2208       stakerReserveLog[ address(0xacc40f85dB13B527C7319e2913733C17631B39b7)  ] = 3;
2209       stakerReserveLog[ address(0xE1e09b606c35c61026aDF7FA7Bb33Fe6E6194064)  ] = 3;
2210       stakerReserveLog[ address(0x4F5B280f83B6e0453eE725cD45252110f3EaA762)  ] = 3;
2211       stakerReserveLog[ address(0x0Db9355ECAe0c997B45955697b4D591E2953e0b1)  ] = 3;
2212       stakerReserveLog[ address(0x0f8c9b0Bb3fa32f89B18E89C0B75548A81832b79)  ] = 3;
2213       stakerReserveLog[ address(0xeF214340E0EefD7D9ccC0FD6449fF03b04c4f305)  ] = 3;
2214       stakerReserveLog[ address(0xaBd5E7f0551F389b052c70d3efcbD7027E774996)  ] = 3;
2215       stakerReserveLog[ address(0x84a31330851D7450114F9De4673F8dCA7486d4E3)  ] = 3;
2216       stakerReserveLog[ address(0x448ceDfE28Ad81DC803034D98203097B4EE61E3c)  ] = 3;
2217       stakerReserveLog[ address(0x5b6c57D0C7959f20E900f1e71a1D691a6EC0E978)  ] = 3;
2218       stakerReserveLog[ address(0xd4c4dd385b97CD1d4823458BC69B579fC89a59F9)  ] = 3;
2219       stakerReserveLog[ address(0xC0AF213DDBB9Eb3D35912024FFE972B6640A4263)  ] = 3;
2220       stakerReserveLog[ address(0xc9bd8D37302bFa4CDDB8afad3a03cd187f3F2318)  ] = 3;
2221       stakerReserveLog[ address(0xc744Cf8f58DB2D7dEC3e9251008dE7f449E87b8c)  ] = 3;
2222       stakerReserveLog[ address(0xEac7705Fd1a2c1F401c129e18AfF65E4f6b4e073)  ] = 3;
2223       stakerReserveLog[ address(0x9fdD1691133603aC39f01654C1f5A17b8D9F7D40)  ] = 3;
2224       stakerReserveLog[ address(0xb5475DB885A6d3714edFf8d5ea3bE13bAd3a7319)  ] = 3;
2225       stakerReserveLog[ address(0x3A877A566fb0cE052e07C1B2A6bC7158FA1C23b4)  ] = 2;
2226       stakerReserveLog[ address(0x16Ada50F49aa18258AAB2243f0ED88676b8FAf0a)  ] = 2;
2227       stakerReserveLog[ address(0x07544F73A6f2c195D879d41d6237d163239aDc98)  ] = 2;
2228       stakerReserveLog[ address(0x45A50017FbC8D22160B36aF631aC214D580BAC59)  ] = 2;
2229       stakerReserveLog[ address(0x34AEbd219E365fd86497cd47290B72e702D30A82)  ] = 2;
2230       stakerReserveLog[ address(0xbb49FFc7344f2aBa266Abc329985014F1e3d6d1C)  ] = 2;
2231       stakerReserveLog[ address(0x7D86bE945E7f2524d59158f04c1B536855429068)  ] = 2;
2232       stakerReserveLog[ address(0x0bCb948037C91a3E98E830d91d18C682f380cc50)  ] = 2;
2233       stakerReserveLog[ address(0x26f3052A3Efd44754BB3061C675943CBB2B690f0)  ] = 2;
2234       stakerReserveLog[ address(0x12d676Db9C781ADFD1CB440ae328a538c32Da373)  ] = 2;
2235       stakerReserveLog[ address(0x2ECbEc5e4c300F88A957A1193bdFE6173baa39db)  ] = 2;
2236       stakerReserveLog[ address(0x6D45f8B052b77fF5Ba1461552a932C39E82330BA)  ] = 2;
2237       stakerReserveLog[ address(0x2AE0368b9c636955C93896091BF876D69665dCE4)  ] = 2;
2238       stakerReserveLog[ address(0xEe2982F69756867448b5A03558BE786388bf97ED)  ] = 2;
2239       stakerReserveLog[ address(0x3fc6C08e329954CE19384c6a70fB578791bCcC7E)  ] = 2;
2240       stakerReserveLog[ address(0x71626C8187912DE8376E86BB92bD572172b49eEe)  ] = 2;
2241       stakerReserveLog[ address(0x730CdB1402De8b7cc79067D80C375aaFd2c27591)  ] = 2;
2242       stakerReserveLog[ address(0x05740Bc573E9c6Bd423ac65D85D53FCb51A60DA2)  ] = 2;
2243       stakerReserveLog[ address(0xCe4A367116CceC25B50347387C9003305F660a61)  ] = 1;
2244       stakerReserveLog[ address(0x4CDe3b62417E91eED9D3f4B0eC4356Be0D734ba3)  ] = 1;
2245       stakerReserveLog[ address(0x5eF25c9e0E0c17257f437087A1fc629c1151c5e9)  ] = 1;
2246       stakerReserveLog[ address(0xa9BFef8ccfd99Eb9eC0581727843562cCD6dea04)  ] = 1;
2247       stakerReserveLog[ address(0xB4D9B517bdEE3D55d49aBac0D751B651954d402F)  ] = 1;
2248       stakerReserveLog[ address(0xcBDc0Fe85E092EEFcD292f2aeC41892CBB323EDE)  ] = 1;
2249       stakerReserveLog[ address(0x1AB74Bd73E80FC3368300d7EBD0f6E88ed02EfFC)  ] = 1;
2250       stakerReserveLog[ address(0xaF446267b0aa14258Ae8789D2dC5aEf9E9088A4b)  ] = 1;
2251       stakerReserveLog[ address(0xa4b6b09F63827b1823E381244e6C92E7aB41DDc5)  ] = 1;
2252       stakerReserveLog[ address(0x487B8E5A6b162367C9E46E9040248360C0ea6166)  ] = 1;
2253       stakerReserveLog[ address(0x5fdD6566c2a603925E0e077C9c342DDE7c06BF00)  ] = 1;
2254       stakerReserveLog[ address(0x6E47a768206673169eC07544544e37749DFA8B0D)  ] = 1;
2255       stakerReserveLog[ address(0x3A97B4a3F3960beDcCf3bae177612e36caBafDBa)  ] = 1;
2256       stakerReserveLog[ address(0xAb717EBa54aFdd7AC48BBAbE7C8223a48E9D4284)  ] = 1;
2257       stakerReserveLog[ address(0xDc0BD0523Ba5dE706A259EceAa597e03C7B28371)  ] = 1;
2258       stakerReserveLog[ address(0x2F754C908A3031348189b10a4C05C59A6F7e9077)  ] = 1;
2259       stakerReserveLog[ address(0x404F583833d0a05156FF6003da652B6031eBCB55)  ] = 1;
2260       stakerReserveLog[ address(0x63AAC522d1a29d1a4F58268b823Cad36BA764102)  ] = 1;
2261       stakerReserveLog[ address(0xFB5091128491B61C3298Fd18B4Cd9Be6212D78Dd)  ] = 1;
2262       stakerReserveLog[ address(0x4A06e76EeE09820df9ED94EA76C4c8DE06fc2818)  ] = 1;
2263       stakerReserveLog[ address(0x895980246D1854fE1340741a5CA0d823aFA9A98e)  ] = 1;
2264     }
2265 }
2266 
2267 
2268 pragma solidity ^0.8.0;
2269 
2270 contract Cocktails is ERC721A, Ownable, CocktailClaimer {
2271 
2272     uint public MAX_TOKENS = 6969;
2273     string private _baseURIextended;
2274     bool public publicSaleIsActive = false;
2275     bool public stakerSaleIsActive = false;
2276     uint256 public basePrice;
2277     bool public barIsOpen;
2278 
2279     uint256 public cooldown = 86400;
2280 
2281     mapping ( uint256 => uint256 ) public mBarCooldown;
2282     mapping ( address => bool ) public claims;
2283     
2284     event LogCocktailDrink(address clubber, uint256 cocktailId, uint256 pricePaid);
2285     
2286     constructor() ERC721A("Cocktails", "COCKTAIL", 350, 6969) {
2287     }
2288 
2289     function cocktailClaim() public {
2290         require(claims[msg.sender] == false, "Address already claimed.");
2291         if (publicSaleIsActive) {
2292             if (stakerReserveLog[msg.sender] == 0) {
2293               require(totalSupply() + 1 <= MAX_TOKENS, "Mint exceeds the max supply of the collection.");
2294               claims[msg.sender] = true;
2295               _safeMint(msg.sender, 1);
2296             } else {
2297               require(totalSupply() + stakerReserveLog[msg.sender] <= MAX_TOKENS, "Mint exceeds the max supply of the collection.");
2298               claims[msg.sender] = true;
2299               _safeMint(msg.sender, stakerReserveLog[msg.sender]);
2300             }
2301         } else {
2302             require(stakerSaleIsActive, "Staker claim must be active to mint NFTs");
2303             require(totalSupply() + stakerReserveLog[msg.sender] <= MAX_TOKENS, "Mint exceeds the max supply of the collection.");
2304             require(stakerReserveLog[msg.sender] > 0, "Address has not enough cocktail tickets");
2305             claims[msg.sender] = true;
2306             _safeMint(msg.sender, stakerReserveLog[msg.sender]);
2307         }
2308     }
2309 
2310     function drinkCocktail(uint256 cocktailId) public payable {
2311         require(barIsOpen == true, "Bar is closed.");
2312         require(mBarCooldown[cocktailId] <= block.timestamp - cooldown, "Cooldown on cocktail active");
2313         require(ownerOf(cocktailId) != msg.sender, "Drinker can't use his own cocktail.");
2314         require(basePrice <= msg.value, "Eth value is wrong.");
2315         mBarCooldown[cocktailId] = block.timestamp;
2316         payable(ownerOf(cocktailId)).transfer(msg.value / 2);
2317         emit LogCocktailDrink(msg.sender, cocktailId, msg.value);
2318     }
2319 
2320     function airdropNft(address userAddress, uint numberOfTokens) public onlyOwner {
2321         require(totalSupply() + numberOfTokens <= MAX_TOKENS);
2322          _safeMint(userAddress, numberOfTokens);
2323     }
2324 
2325     function setBaseURI(string memory baseURI_) public onlyOwner() {
2326         _baseURIextended = baseURI_;
2327     }
2328 
2329     function _baseURI() internal view virtual override returns (string memory) {
2330         return _baseURIextended;
2331     }
2332 
2333     function flipPublicMintState() public onlyOwner {
2334         publicSaleIsActive = !publicSaleIsActive;
2335     }
2336 
2337     function flipStakerSaleState() public onlyOwner {
2338         stakerSaleIsActive = !stakerSaleIsActive;
2339     }
2340 
2341     function changeCooldown(uint256 newCooldown) public onlyOwner {
2342         cooldown = newCooldown;
2343     }
2344 
2345     function getHolderTokens(address _owner) public view virtual returns (uint256[] memory) {
2346         uint256 tokenCount = balanceOf(_owner);
2347         uint256[] memory tokensId = new uint256[](tokenCount);
2348         for(uint256 i; i < tokenCount; i++){
2349             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2350         }
2351         return tokensId;
2352     }
2353 
2354     function changeBasePrice(uint256 newRarityPrice) public onlyOwner {
2355         basePrice = newRarityPrice;
2356     }
2357 
2358     function flipBarIsOpen() public onlyOwner {
2359         barIsOpen = !barIsOpen;
2360     }
2361 
2362     function withdraw() public onlyOwner {
2363         payable(msg.sender).transfer(address(this).balance);
2364     }
2365 }