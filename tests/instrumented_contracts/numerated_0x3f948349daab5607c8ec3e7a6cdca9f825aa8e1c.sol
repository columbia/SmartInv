1 // Sources flattened with hardhat v2.9.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
33 
34 
35 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId,
89         bytes calldata data
90     ) external;
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
178 
179 
180 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
238 
239 
240 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450 
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 
463 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes calldata) {
486         return msg.data;
487     }
488 }
489 
490 
491 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev String operations.
500  */
501 library Strings {
502     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
506      */
507     function toString(uint256 value) internal pure returns (string memory) {
508         // Inspired by OraclizeAPI's implementation - MIT licence
509         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
510 
511         if (value == 0) {
512             return "0";
513         }
514         uint256 temp = value;
515         uint256 digits;
516         while (temp != 0) {
517             digits++;
518             temp /= 10;
519         }
520         bytes memory buffer = new bytes(digits);
521         while (value != 0) {
522             digits -= 1;
523             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
524             value /= 10;
525         }
526         return string(buffer);
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
531      */
532     function toHexString(uint256 value) internal pure returns (string memory) {
533         if (value == 0) {
534             return "0x00";
535         }
536         uint256 temp = value;
537         uint256 length = 0;
538         while (temp != 0) {
539             length++;
540             temp >>= 8;
541         }
542         return toHexString(value, length);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
547      */
548     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
549         bytes memory buffer = new bytes(2 * length + 2);
550         buffer[0] = "0";
551         buffer[1] = "x";
552         for (uint256 i = 2 * length + 1; i > 1; --i) {
553             buffer[i] = _HEX_SYMBOLS[value & 0xf];
554             value >>= 4;
555         }
556         require(value == 0, "Strings: hex length insufficient");
557         return string(buffer);
558     }
559 }
560 
561 
562 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Implementation of the {IERC165} interface.
571  *
572  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
573  * for the additional interface id that will be supported. For example:
574  *
575  * ```solidity
576  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
578  * }
579  * ```
580  *
581  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
582  */
583 abstract contract ERC165 is IERC165 {
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588         return interfaceId == type(IERC165).interfaceId;
589     }
590 }
591 
592 
593 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.6.0
594 
595 
596 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 
602 
603 
604 
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata extension, but not including the Enumerable extension, which is available separately as
609  * {ERC721Enumerable}.
610  */
611 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
612     using Address for address;
613     using Strings for uint256;
614 
615     // Token name
616     string private _name;
617 
618     // Token symbol
619     string private _symbol;
620 
621     // Mapping from token ID to owner address
622     mapping(uint256 => address) private _owners;
623 
624     // Mapping owner address to token count
625     mapping(address => uint256) private _balances;
626 
627     // Mapping from token ID to approved address
628     mapping(uint256 => address) private _tokenApprovals;
629 
630     // Mapping from owner to operator approvals
631     mapping(address => mapping(address => bool)) private _operatorApprovals;
632 
633     /**
634      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
635      */
636     constructor(string memory name_, string memory symbol_) {
637         _name = name_;
638         _symbol = symbol_;
639     }
640 
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
645         return
646             interfaceId == type(IERC721).interfaceId ||
647             interfaceId == type(IERC721Metadata).interfaceId ||
648             super.supportsInterface(interfaceId);
649     }
650 
651     /**
652      * @dev See {IERC721-balanceOf}.
653      */
654     function balanceOf(address owner) public view virtual override returns (uint256) {
655         require(owner != address(0), "ERC721: balance query for the zero address");
656         return _balances[owner];
657     }
658 
659     /**
660      * @dev See {IERC721-ownerOf}.
661      */
662     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
663         address owner = _owners[tokenId];
664         require(owner != address(0), "ERC721: owner query for nonexistent token");
665         return owner;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-name}.
670      */
671     function name() public view virtual override returns (string memory) {
672         return _name;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-symbol}.
677      */
678     function symbol() public view virtual override returns (string memory) {
679         return _symbol;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-tokenURI}.
684      */
685     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
686         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
687 
688         string memory baseURI = _baseURI();
689         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
690     }
691 
692     /**
693      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
694      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
695      * by default, can be overridden in child contracts.
696      */
697     function _baseURI() internal view virtual returns (string memory) {
698         return "";
699     }
700 
701     /**
702      * @dev See {IERC721-approve}.
703      */
704     function approve(address to, uint256 tokenId) public virtual override {
705         address owner = ERC721.ownerOf(tokenId);
706         require(to != owner, "ERC721: approval to current owner");
707 
708         require(
709             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
710             "ERC721: approve caller is not owner nor approved for all"
711         );
712 
713         _approve(to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-getApproved}.
718      */
719     function getApproved(uint256 tokenId) public view virtual override returns (address) {
720         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
721 
722         return _tokenApprovals[tokenId];
723     }
724 
725     /**
726      * @dev See {IERC721-setApprovalForAll}.
727      */
728     function setApprovalForAll(address operator, bool approved) public virtual override {
729         _setApprovalForAll(_msgSender(), operator, approved);
730     }
731 
732     /**
733      * @dev See {IERC721-isApprovedForAll}.
734      */
735     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
736         return _operatorApprovals[owner][operator];
737     }
738 
739     /**
740      * @dev See {IERC721-transferFrom}.
741      */
742     function transferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public virtual override {
747         //solhint-disable-next-line max-line-length
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749 
750         _transfer(from, to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         safeTransferFrom(from, to, tokenId, "");
762     }
763 
764     /**
765      * @dev See {IERC721-safeTransferFrom}.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) public virtual override {
773         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
774         _safeTransfer(from, to, tokenId, _data);
775     }
776 
777     /**
778      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
779      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
780      *
781      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
782      *
783      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
784      * implement alternative mechanisms to perform token transfer, such as signature-based.
785      *
786      * Requirements:
787      *
788      * - `from` cannot be the zero address.
789      * - `to` cannot be the zero address.
790      * - `tokenId` token must exist and be owned by `from`.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeTransfer(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) internal virtual {
801         _transfer(from, to, tokenId);
802         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
803     }
804 
805     /**
806      * @dev Returns whether `tokenId` exists.
807      *
808      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
809      *
810      * Tokens start existing when they are minted (`_mint`),
811      * and stop existing when they are burned (`_burn`).
812      */
813     function _exists(uint256 tokenId) internal view virtual returns (bool) {
814         return _owners[tokenId] != address(0);
815     }
816 
817     /**
818      * @dev Returns whether `spender` is allowed to manage `tokenId`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
825         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
826         address owner = ERC721.ownerOf(tokenId);
827         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
828     }
829 
830     /**
831      * @dev Safely mints `tokenId` and transfers it to `to`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeMint(address to, uint256 tokenId) internal virtual {
841         _safeMint(to, tokenId, "");
842     }
843 
844     /**
845      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
846      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
847      */
848     function _safeMint(
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) internal virtual {
853         _mint(to, tokenId);
854         require(
855             _checkOnERC721Received(address(0), to, tokenId, _data),
856             "ERC721: transfer to non ERC721Receiver implementer"
857         );
858     }
859 
860     /**
861      * @dev Mints `tokenId` and transfers it to `to`.
862      *
863      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
864      *
865      * Requirements:
866      *
867      * - `tokenId` must not exist.
868      * - `to` cannot be the zero address.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _mint(address to, uint256 tokenId) internal virtual {
873         require(to != address(0), "ERC721: mint to the zero address");
874         require(!_exists(tokenId), "ERC721: token already minted");
875 
876         _beforeTokenTransfer(address(0), to, tokenId);
877 
878         _balances[to] += 1;
879         _owners[tokenId] = to;
880 
881         emit Transfer(address(0), to, tokenId);
882 
883         _afterTokenTransfer(address(0), to, tokenId);
884     }
885 
886     /**
887      * @dev Destroys `tokenId`.
888      * The approval is cleared when the token is burned.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _burn(uint256 tokenId) internal virtual {
897         address owner = ERC721.ownerOf(tokenId);
898 
899         _beforeTokenTransfer(owner, address(0), tokenId);
900 
901         // Clear approvals
902         _approve(address(0), tokenId);
903 
904         _balances[owner] -= 1;
905         delete _owners[tokenId];
906 
907         emit Transfer(owner, address(0), tokenId);
908 
909         _afterTokenTransfer(owner, address(0), tokenId);
910     }
911 
912     /**
913      * @dev Transfers `tokenId` from `from` to `to`.
914      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
915      *
916      * Requirements:
917      *
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must be owned by `from`.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _transfer(
924         address from,
925         address to,
926         uint256 tokenId
927     ) internal virtual {
928         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
929         require(to != address(0), "ERC721: transfer to the zero address");
930 
931         _beforeTokenTransfer(from, to, tokenId);
932 
933         // Clear approvals from the previous owner
934         _approve(address(0), tokenId);
935 
936         _balances[from] -= 1;
937         _balances[to] += 1;
938         _owners[tokenId] = to;
939 
940         emit Transfer(from, to, tokenId);
941 
942         _afterTokenTransfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev Approve `to` to operate on `tokenId`
947      *
948      * Emits a {Approval} event.
949      */
950     function _approve(address to, uint256 tokenId) internal virtual {
951         _tokenApprovals[tokenId] = to;
952         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
953     }
954 
955     /**
956      * @dev Approve `operator` to operate on all of `owner` tokens
957      *
958      * Emits a {ApprovalForAll} event.
959      */
960     function _setApprovalForAll(
961         address owner,
962         address operator,
963         bool approved
964     ) internal virtual {
965         require(owner != operator, "ERC721: approve to caller");
966         _operatorApprovals[owner][operator] = approved;
967         emit ApprovalForAll(owner, operator, approved);
968     }
969 
970     /**
971      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
972      * The call is not executed if the target address is not a contract.
973      *
974      * @param from address representing the previous owner of the given token ID
975      * @param to target address that will receive the tokens
976      * @param tokenId uint256 ID of the token to be transferred
977      * @param _data bytes optional data to send along with the call
978      * @return bool whether the call correctly returned the expected magic value
979      */
980     function _checkOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         if (to.isContract()) {
987             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
988                 return retval == IERC721Receiver.onERC721Received.selector;
989             } catch (bytes memory reason) {
990                 if (reason.length == 0) {
991                     revert("ERC721: transfer to non ERC721Receiver implementer");
992                 } else {
993                     assembly {
994                         revert(add(32, reason), mload(reason))
995                     }
996                 }
997             }
998         } else {
999             return true;
1000         }
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before any token transfer. This includes minting
1005      * and burning.
1006      *
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` will be minted for `to`.
1012      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1013      * - `from` and `to` are never both zero.
1014      *
1015      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1016      */
1017     function _beforeTokenTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {}
1022 
1023     /**
1024      * @dev Hook that is called after any transfer of tokens. This includes
1025      * minting and burning.
1026      *
1027      * Calling conditions:
1028      *
1029      * - when `from` and `to` are both non-zero.
1030      * - `from` and `to` are never both zero.
1031      *
1032      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1033      */
1034     function _afterTokenTransfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) internal virtual {}
1039 }
1040 
1041 
1042 // File @openzeppelin/contracts/utils/Counters.sol@v4.6.0
1043 
1044 
1045 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 /**
1050  * @title Counters
1051  * @author Matt Condon (@shrugs)
1052  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1053  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1054  *
1055  * Include with `using Counters for Counters.Counter;`
1056  */
1057 library Counters {
1058     struct Counter {
1059         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1060         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1061         // this feature: see https://github.com/ethereum/solidity/issues/4637
1062         uint256 _value; // default: 0
1063     }
1064 
1065     function current(Counter storage counter) internal view returns (uint256) {
1066         return counter._value;
1067     }
1068 
1069     function increment(Counter storage counter) internal {
1070         unchecked {
1071             counter._value += 1;
1072         }
1073     }
1074 
1075     function decrement(Counter storage counter) internal {
1076         uint256 value = counter._value;
1077         require(value > 0, "Counter: decrement overflow");
1078         unchecked {
1079             counter._value = value - 1;
1080         }
1081     }
1082 
1083     function reset(Counter storage counter) internal {
1084         counter._value = 0;
1085     }
1086 }
1087 
1088 
1089 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1090 
1091 
1092 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 /**
1097  * @dev Contract module which provides a basic access control mechanism, where
1098  * there is an account (an owner) that can be granted exclusive access to
1099  * specific functions.
1100  *
1101  * By default, the owner account will be the one that deploys the contract. This
1102  * can later be changed with {transferOwnership}.
1103  *
1104  * This module is used through inheritance. It will make available the modifier
1105  * `onlyOwner`, which can be applied to your functions to restrict their use to
1106  * the owner.
1107  */
1108 abstract contract Ownable is Context {
1109     address private _owner;
1110 
1111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1112 
1113     /**
1114      * @dev Initializes the contract setting the deployer as the initial owner.
1115      */
1116     constructor() {
1117         _transferOwnership(_msgSender());
1118     }
1119 
1120     /**
1121      * @dev Returns the address of the current owner.
1122      */
1123     function owner() public view virtual returns (address) {
1124         return _owner;
1125     }
1126 
1127     /**
1128      * @dev Throws if called by any account other than the owner.
1129      */
1130     modifier onlyOwner() {
1131         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1132         _;
1133     }
1134 
1135     /**
1136      * @dev Leaves the contract without owner. It will not be possible to call
1137      * `onlyOwner` functions anymore. Can only be called by the current owner.
1138      *
1139      * NOTE: Renouncing ownership will leave the contract without an owner,
1140      * thereby removing any functionality that is only available to the owner.
1141      */
1142     function renounceOwnership() public virtual onlyOwner {
1143         _transferOwnership(address(0));
1144     }
1145 
1146     /**
1147      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1148      * Can only be called by the current owner.
1149      */
1150     function transferOwnership(address newOwner) public virtual onlyOwner {
1151         require(newOwner != address(0), "Ownable: new owner is the zero address");
1152         _transferOwnership(newOwner);
1153     }
1154 
1155     /**
1156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1157      * Internal function without access restriction.
1158      */
1159     function _transferOwnership(address newOwner) internal virtual {
1160         address oldOwner = _owner;
1161         _owner = newOwner;
1162         emit OwnershipTransferred(oldOwner, newOwner);
1163     }
1164 }
1165 
1166 
1167 // File @openzeppelin/contracts/utils/escrow/Escrow.sol@v4.6.0
1168 
1169 
1170 // OpenZeppelin Contracts v4.4.1 (utils/escrow/Escrow.sol)
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 /**
1176  * @title Escrow
1177  * @dev Base escrow contract, holds funds designated for a payee until they
1178  * withdraw them.
1179  *
1180  * Intended usage: This contract (and derived escrow contracts) should be a
1181  * standalone contract, that only interacts with the contract that instantiated
1182  * it. That way, it is guaranteed that all Ether will be handled according to
1183  * the `Escrow` rules, and there is no need to check for payable functions or
1184  * transfers in the inheritance tree. The contract that uses the escrow as its
1185  * payment method should be its owner, and provide public methods redirecting
1186  * to the escrow's deposit and withdraw.
1187  */
1188 contract Escrow is Ownable {
1189     using Address for address payable;
1190 
1191     event Deposited(address indexed payee, uint256 weiAmount);
1192     event Withdrawn(address indexed payee, uint256 weiAmount);
1193 
1194     mapping(address => uint256) private _deposits;
1195 
1196     function depositsOf(address payee) public view returns (uint256) {
1197         return _deposits[payee];
1198     }
1199 
1200     /**
1201      * @dev Stores the sent amount as credit to be withdrawn.
1202      * @param payee The destination address of the funds.
1203      */
1204     function deposit(address payee) public payable virtual onlyOwner {
1205         uint256 amount = msg.value;
1206         _deposits[payee] += amount;
1207         emit Deposited(payee, amount);
1208     }
1209 
1210     /**
1211      * @dev Withdraw accumulated balance for a payee, forwarding all gas to the
1212      * recipient.
1213      *
1214      * WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
1215      * Make sure you trust the recipient, or are either following the
1216      * checks-effects-interactions pattern or using {ReentrancyGuard}.
1217      *
1218      * @param payee The address whose funds will be withdrawn and transferred to.
1219      */
1220     function withdraw(address payable payee) public virtual onlyOwner {
1221         uint256 payment = _deposits[payee];
1222 
1223         _deposits[payee] = 0;
1224 
1225         payee.sendValue(payment);
1226 
1227         emit Withdrawn(payee, payment);
1228     }
1229 }
1230 
1231 
1232 // File @openzeppelin/contracts/security/PullPayment.sol@v4.6.0
1233 
1234 
1235 // OpenZeppelin Contracts v4.4.1 (security/PullPayment.sol)
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 /**
1240  * @dev Simple implementation of a
1241  * https://consensys.github.io/smart-contract-best-practices/recommendations/#favor-pull-over-push-for-external-calls[pull-payment]
1242  * strategy, where the paying contract doesn't interact directly with the
1243  * receiver account, which must withdraw its payments itself.
1244  *
1245  * Pull-payments are often considered the best practice when it comes to sending
1246  * Ether, security-wise. It prevents recipients from blocking execution, and
1247  * eliminates reentrancy concerns.
1248  *
1249  * TIP: If you would like to learn more about reentrancy and alternative ways
1250  * to protect against it, check out our blog post
1251  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1252  *
1253  * To use, derive from the `PullPayment` contract, and use {_asyncTransfer}
1254  * instead of Solidity's `transfer` function. Payees can query their due
1255  * payments with {payments}, and retrieve them with {withdrawPayments}.
1256  */
1257 abstract contract PullPayment {
1258     Escrow private immutable _escrow;
1259 
1260     constructor() {
1261         _escrow = new Escrow();
1262     }
1263 
1264     /**
1265      * @dev Withdraw accumulated payments, forwarding all gas to the recipient.
1266      *
1267      * Note that _any_ account can call this function, not just the `payee`.
1268      * This means that contracts unaware of the `PullPayment` protocol can still
1269      * receive funds this way, by having a separate account call
1270      * {withdrawPayments}.
1271      *
1272      * WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
1273      * Make sure you trust the recipient, or are either following the
1274      * checks-effects-interactions pattern or using {ReentrancyGuard}.
1275      *
1276      * @param payee Whose payments will be withdrawn.
1277      */
1278     function withdrawPayments(address payable payee) public virtual {
1279         _escrow.withdraw(payee);
1280     }
1281 
1282     /**
1283      * @dev Returns the payments owed to an address.
1284      * @param dest The creditor's address.
1285      */
1286     function payments(address dest) public view returns (uint256) {
1287         return _escrow.depositsOf(dest);
1288     }
1289 
1290     /**
1291      * @dev Called by the payer to store the sent amount as credit to be pulled.
1292      * Funds sent in this way are stored in an intermediate {Escrow} contract, so
1293      * there is no danger of them being spent before withdrawal.
1294      *
1295      * @param dest The destination address of the funds.
1296      * @param amount The amount to transfer.
1297      */
1298     function _asyncTransfer(address dest, uint256 amount) internal virtual {
1299         _escrow.deposit{value: amount}(dest);
1300     }
1301 }
1302 
1303 
1304 // File contracts/PREPROD.sol
1305 
1306 
1307 pragma solidity ^0.8.0;
1308 
1309 
1310 
1311 
1312 contract BOTXNFT is ERC721, PullPayment, Ownable {
1313   using Counters for Counters.Counter;
1314   uint256 public constant TOTAL_SUPPLY = 10_000;
1315   Counters.Counter private currentTokenId;
1316   string public baseTokenURI;
1317   string public placeholderURI;
1318   uint256 public milestoneTimestamp;
1319   constructor() ERC721("BOT-X CLUB", "BOT-X") {
1320     placeholderURI = "https://bafybeifl7euux2peynwo4tdopc7lf5xv7dlpgnhzfandx7ewsgs32qft6e.ipfs.nftstorage.link/metadata/";
1321     milestoneTimestamp = 1654048800;
1322     baseTokenURI = "https://botxclub.mypinata.cloud/ipfs/QmS8eoWrYhqEYnNvSTJTXBXzfPN1WGFHbbovLGzfG5Uebh/";
1323   }
1324   function mintTo(address recipient) public payable onlyOwner returns (uint256) {
1325     uint256 tokenId = currentTokenId.current();
1326     require(tokenId < TOTAL_SUPPLY, "Max supply reached");
1327 
1328     currentTokenId.increment();
1329     uint256 newItemId = currentTokenId.current();
1330     _safeMint(recipient, newItemId);
1331     return newItemId;
1332   }
1333   
1334   // @dev Returns an URI for a given token ID switch based on current blocktimestamp
1335   function _baseURI() internal view virtual override returns (string memory) {
1336     if (block.timestamp > milestoneTimestamp) {
1337         return baseTokenURI;
1338     } else {
1339         return placeholderURI;
1340         }
1341     }
1342 
1343 
1344   /// @dev Sets the base token URI prefix.
1345   function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
1346     baseTokenURI = _baseTokenURI;
1347   }
1348 
1349   /// @dev Overridden in order to make it an onlyOwner function
1350   function withdrawPayments(address payable payee) public override onlyOwner virtual {
1351       super.withdrawPayments(payee);
1352   }
1353 
1354   /// @dev Set the turn over timestamp
1355   function setMilestoneTimestamp(uint256 _timestamp) public onlyOwner {
1356         milestoneTimestamp = _timestamp;
1357   }
1358 }