1 // File: contracts/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
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
29 // File: contracts/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 // File: contracts/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
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
204 // File: contracts/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: contracts/openzeppelin-contracts/contracts/utils/Address.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      *
261      * [IMPORTANT]
262      * ====
263      * You shouldn't rely on `isContract` to protect against flash loan attacks!
264      *
265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
267      * constructor.
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         assembly {
277             size := extcodesize(account)
278         }
279         return size > 0;
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
462 // File: contracts/openzeppelin-contracts/contracts/utils/Context.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Provides information about the current execution context, including the
471  * sender of the transaction and its data. While these are generally available
472  * via msg.sender and msg.data, they should not be accessed in such a direct
473  * manner, since when dealing with meta-transactions the account sending and
474  * paying for execution may not be the actual sender (as far as an application
475  * is concerned).
476  *
477  * This contract is only required for intermediate, library-like contracts.
478  */
479 abstract contract Context {
480     function _msgSender() internal view virtual returns (address) {
481         return msg.sender;
482     }
483 
484     function _msgData() internal view virtual returns (bytes calldata) {
485         return msg.data;
486     }
487 }
488 
489 // File: contracts/openzeppelin-contracts/contracts/utils/Strings.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev String operations.
498  */
499 library Strings {
500     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
504      */
505     function toString(uint256 value) internal pure returns (string memory) {
506         // Inspired by OraclizeAPI's implementation - MIT licence
507         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
508 
509         if (value == 0) {
510             return "0";
511         }
512         uint256 temp = value;
513         uint256 digits;
514         while (temp != 0) {
515             digits++;
516             temp /= 10;
517         }
518         bytes memory buffer = new bytes(digits);
519         while (value != 0) {
520             digits -= 1;
521             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
522             value /= 10;
523         }
524         return string(buffer);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
529      */
530     function toHexString(uint256 value) internal pure returns (string memory) {
531         if (value == 0) {
532             return "0x00";
533         }
534         uint256 temp = value;
535         uint256 length = 0;
536         while (temp != 0) {
537             length++;
538             temp >>= 8;
539         }
540         return toHexString(value, length);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
545      */
546     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
547         bytes memory buffer = new bytes(2 * length + 2);
548         buffer[0] = "0";
549         buffer[1] = "x";
550         for (uint256 i = 2 * length + 1; i > 1; --i) {
551             buffer[i] = _HEX_SYMBOLS[value & 0xf];
552             value >>= 4;
553         }
554         require(value == 0, "Strings: hex length insufficient");
555         return string(buffer);
556     }
557 }
558 
559 // File: contracts/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @dev Implementation of the {IERC165} interface.
569  *
570  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
571  * for the additional interface id that will be supported. For example:
572  *
573  * ```solidity
574  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
576  * }
577  * ```
578  *
579  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
580  */
581 abstract contract ERC165 is IERC165 {
582     /**
583      * @dev See {IERC165-supportsInterface}.
584      */
585     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
586         return interfaceId == type(IERC165).interfaceId;
587     }
588 }
589 
590 // File: contracts/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 
599 
600 
601 
602 
603 
604 /**
605  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
606  * the Metadata extension, but not including the Enumerable extension, which is available separately as
607  * {ERC721Enumerable}.
608  */
609 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
610     using Address for address;
611     using Strings for uint256;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to owner address
620     mapping(uint256 => address) private _owners;
621 
622     // Mapping owner address to token count
623     mapping(address => uint256) private _balances;
624 
625     // Mapping from token ID to approved address
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     /**
632      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
633      */
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637     }
638 
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
643         return
644             interfaceId == type(IERC721).interfaceId ||
645             interfaceId == type(IERC721Metadata).interfaceId ||
646             super.supportsInterface(interfaceId);
647     }
648 
649     /**
650      * @dev See {IERC721-balanceOf}.
651      */
652     function balanceOf(address owner) public view virtual override returns (uint256) {
653         require(owner != address(0), "ERC721: balance query for the zero address");
654         return _balances[owner];
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
661         address owner = _owners[tokenId];
662         require(owner != address(0), "ERC721: owner query for nonexistent token");
663         return owner;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-name}.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-symbol}.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-tokenURI}.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, can be overriden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return "";
697     }
698 
699     /**
700      * @dev See {IERC721-approve}.
701      */
702     function approve(address to, uint256 tokenId) public virtual override {
703         address owner = ERC721.ownerOf(tokenId);
704         require(to != owner, "ERC721: approval to current owner");
705 
706         require(
707             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
708             "ERC721: approve caller is not owner nor approved for all"
709         );
710 
711         _approve(to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-getApproved}.
716      */
717     function getApproved(uint256 tokenId) public view virtual override returns (address) {
718         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
719 
720         return _tokenApprovals[tokenId];
721     }
722 
723     /**
724      * @dev See {IERC721-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         _setApprovalForAll(_msgSender(), operator, approved);
728     }
729 
730     /**
731      * @dev See {IERC721-isApprovedForAll}.
732      */
733     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         //solhint-disable-next-line max-line-length
746         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
747 
748         _transfer(from, to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         safeTransferFrom(from, to, tokenId, "");
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes memory _data
770     ) public virtual override {
771         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
772         _safeTransfer(from, to, tokenId, _data);
773     }
774 
775     /**
776      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
777      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
778      *
779      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
780      *
781      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
782      * implement alternative mechanisms to perform token transfer, such as signature-based.
783      *
784      * Requirements:
785      *
786      * - `from` cannot be the zero address.
787      * - `to` cannot be the zero address.
788      * - `tokenId` token must exist and be owned by `from`.
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _safeTransfer(
794         address from,
795         address to,
796         uint256 tokenId,
797         bytes memory _data
798     ) internal virtual {
799         _transfer(from, to, tokenId);
800         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
801     }
802 
803     /**
804      * @dev Returns whether `tokenId` exists.
805      *
806      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
807      *
808      * Tokens start existing when they are minted (`_mint`),
809      * and stop existing when they are burned (`_burn`).
810      */
811     function _exists(uint256 tokenId) internal view virtual returns (bool) {
812         return _owners[tokenId] != address(0);
813     }
814 
815     /**
816      * @dev Returns whether `spender` is allowed to manage `tokenId`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      */
822     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
823         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
824         address owner = ERC721.ownerOf(tokenId);
825         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
826     }
827 
828     /**
829      * @dev Safely mints `tokenId` and transfers it to `to`.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must not exist.
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _safeMint(address to, uint256 tokenId) internal virtual {
839         _safeMint(to, tokenId, "");
840     }
841 
842     /**
843      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
844      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
845      */
846     function _safeMint(
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) internal virtual {
851         _mint(to, tokenId);
852         require(
853             _checkOnERC721Received(address(0), to, tokenId, _data),
854             "ERC721: transfer to non ERC721Receiver implementer"
855         );
856     }
857 
858     /**
859      * @dev Mints `tokenId` and transfers it to `to`.
860      *
861      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
862      *
863      * Requirements:
864      *
865      * - `tokenId` must not exist.
866      * - `to` cannot be the zero address.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _mint(address to, uint256 tokenId) internal virtual {
871         require(to != address(0), "ERC721: mint to the zero address");
872         require(!_exists(tokenId), "ERC721: token already minted");
873 
874         _beforeTokenTransfer(address(0), to, tokenId);
875 
876         _balances[to] += 1;
877         _owners[tokenId] = to;
878 
879         emit Transfer(address(0), to, tokenId);
880 
881         _afterTokenTransfer(address(0), to, tokenId);
882     }
883 
884     /**
885      * @dev Destroys `tokenId`.
886      * The approval is cleared when the token is burned.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _burn(uint256 tokenId) internal virtual {
895         address owner = ERC721.ownerOf(tokenId);
896 
897         _beforeTokenTransfer(owner, address(0), tokenId);
898 
899         // Clear approvals
900         _approve(address(0), tokenId);
901 
902         _balances[owner] -= 1;
903         delete _owners[tokenId];
904 
905         emit Transfer(owner, address(0), tokenId);
906 
907         _afterTokenTransfer(owner, address(0), tokenId);
908     }
909 
910     /**
911      * @dev Transfers `tokenId` from `from` to `to`.
912      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
913      *
914      * Requirements:
915      *
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must be owned by `from`.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _transfer(
922         address from,
923         address to,
924         uint256 tokenId
925     ) internal virtual {
926         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
927         require(to != address(0), "ERC721: transfer to the zero address");
928 
929         _beforeTokenTransfer(from, to, tokenId);
930 
931         // Clear approvals from the previous owner
932         _approve(address(0), tokenId);
933 
934         _balances[from] -= 1;
935         _balances[to] += 1;
936         _owners[tokenId] = to;
937 
938         emit Transfer(from, to, tokenId);
939 
940         _afterTokenTransfer(from, to, tokenId);
941     }
942 
943     /**
944      * @dev Approve `to` to operate on `tokenId`
945      *
946      * Emits a {Approval} event.
947      */
948     function _approve(address to, uint256 tokenId) internal virtual {
949         _tokenApprovals[tokenId] = to;
950         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
951     }
952 
953     /**
954      * @dev Approve `operator` to operate on all of `owner` tokens
955      *
956      * Emits a {ApprovalForAll} event.
957      */
958     function _setApprovalForAll(
959         address owner,
960         address operator,
961         bool approved
962     ) internal virtual {
963         require(owner != operator, "ERC721: approve to caller");
964         _operatorApprovals[owner][operator] = approved;
965         emit ApprovalForAll(owner, operator, approved);
966     }
967 
968     /**
969      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
970      * The call is not executed if the target address is not a contract.
971      *
972      * @param from address representing the previous owner of the given token ID
973      * @param to target address that will receive the tokens
974      * @param tokenId uint256 ID of the token to be transferred
975      * @param _data bytes optional data to send along with the call
976      * @return bool whether the call correctly returned the expected magic value
977      */
978     function _checkOnERC721Received(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes memory _data
983     ) private returns (bool) {
984         if (to.isContract()) {
985             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
986                 return retval == IERC721Receiver.onERC721Received.selector;
987             } catch (bytes memory reason) {
988                 if (reason.length == 0) {
989                     revert("ERC721: transfer to non ERC721Receiver implementer");
990                 } else {
991                     assembly {
992                         revert(add(32, reason), mload(reason))
993                     }
994                 }
995             }
996         } else {
997             return true;
998         }
999     }
1000 
1001     /**
1002      * @dev Hook that is called before any token transfer. This includes minting
1003      * and burning.
1004      *
1005      * Calling conditions:
1006      *
1007      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1008      * transferred to `to`.
1009      * - When `from` is zero, `tokenId` will be minted for `to`.
1010      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1011      * - `from` and `to` are never both zero.
1012      *
1013      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1014      */
1015     function _beforeTokenTransfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {}
1020 
1021     /**
1022      * @dev Hook that is called after any transfer of tokens. This includes
1023      * minting and burning.
1024      *
1025      * Calling conditions:
1026      *
1027      * - when `from` and `to` are both non-zero.
1028      * - `from` and `to` are never both zero.
1029      *
1030      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1031      */
1032     function _afterTokenTransfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) internal virtual {}
1037 }
1038 
1039 // File: contracts/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1040 
1041 
1042 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 
1047 /**
1048  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1049  * @dev See https://eips.ethereum.org/EIPS/eip-721
1050  */
1051 interface IERC721Enumerable is IERC721 {
1052     /**
1053      * @dev Returns the total amount of tokens stored by the contract.
1054      */
1055     function totalSupply() external view returns (uint256);
1056 
1057     /**
1058      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1059      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1060      */
1061     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1062 
1063     /**
1064      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1065      * Use along with {totalSupply} to enumerate all tokens.
1066      */
1067     function tokenByIndex(uint256 index) external view returns (uint256);
1068 }
1069 
1070 // File: contracts/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1071 
1072 
1073 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1074 
1075 pragma solidity ^0.8.0;
1076 
1077 
1078 
1079 /**
1080  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1081  * enumerability of all the token ids in the contract as well as all token ids owned by each
1082  * account.
1083  */
1084 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1085     // Mapping from owner to list of owned token IDs
1086     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1087 
1088     // Mapping from token ID to index of the owner tokens list
1089     mapping(uint256 => uint256) private _ownedTokensIndex;
1090 
1091     // Array with all token ids, used for enumeration
1092     uint256[] private _allTokens;
1093 
1094     // Mapping from token id to position in the allTokens array
1095     mapping(uint256 => uint256) private _allTokensIndex;
1096 
1097     /**
1098      * @dev See {IERC165-supportsInterface}.
1099      */
1100     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1101         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1106      */
1107     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1108         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1109         return _ownedTokens[owner][index];
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Enumerable-totalSupply}.
1114      */
1115     function totalSupply() public view virtual override returns (uint256) {
1116         return _allTokens.length;
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Enumerable-tokenByIndex}.
1121      */
1122     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1123         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1124         return _allTokens[index];
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before any token transfer. This includes minting
1129      * and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1134      * transferred to `to`.
1135      * - When `from` is zero, `tokenId` will be minted for `to`.
1136      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1137      * - `from` cannot be the zero address.
1138      * - `to` cannot be the zero address.
1139      *
1140      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1141      */
1142     function _beforeTokenTransfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) internal virtual override {
1147         super._beforeTokenTransfer(from, to, tokenId);
1148 
1149         if (from == address(0)) {
1150             _addTokenToAllTokensEnumeration(tokenId);
1151         } else if (from != to) {
1152             _removeTokenFromOwnerEnumeration(from, tokenId);
1153         }
1154         if (to == address(0)) {
1155             _removeTokenFromAllTokensEnumeration(tokenId);
1156         } else if (to != from) {
1157             _addTokenToOwnerEnumeration(to, tokenId);
1158         }
1159     }
1160 
1161     /**
1162      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1163      * @param to address representing the new owner of the given token ID
1164      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1165      */
1166     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1167         uint256 length = ERC721.balanceOf(to);
1168         _ownedTokens[to][length] = tokenId;
1169         _ownedTokensIndex[tokenId] = length;
1170     }
1171 
1172     /**
1173      * @dev Private function to add a token to this extension's token tracking data structures.
1174      * @param tokenId uint256 ID of the token to be added to the tokens list
1175      */
1176     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1177         _allTokensIndex[tokenId] = _allTokens.length;
1178         _allTokens.push(tokenId);
1179     }
1180 
1181     /**
1182      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1183      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1184      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1185      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1186      * @param from address representing the previous owner of the given token ID
1187      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1188      */
1189     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1190         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1191         // then delete the last slot (swap and pop).
1192 
1193         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1194         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1195 
1196         // When the token to delete is the last token, the swap operation is unnecessary
1197         if (tokenIndex != lastTokenIndex) {
1198             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1199 
1200             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1201             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1202         }
1203 
1204         // This also deletes the contents at the last position of the array
1205         delete _ownedTokensIndex[tokenId];
1206         delete _ownedTokens[from][lastTokenIndex];
1207     }
1208 
1209     /**
1210      * @dev Private function to remove a token from this extension's token tracking data structures.
1211      * This has O(1) time complexity, but alters the order of the _allTokens array.
1212      * @param tokenId uint256 ID of the token to be removed from the tokens list
1213      */
1214     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1215         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1216         // then delete the last slot (swap and pop).
1217 
1218         uint256 lastTokenIndex = _allTokens.length - 1;
1219         uint256 tokenIndex = _allTokensIndex[tokenId];
1220 
1221         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1222         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1223         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1224         uint256 lastTokenId = _allTokens[lastTokenIndex];
1225 
1226         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1227         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1228 
1229         // This also deletes the contents at the last position of the array
1230         delete _allTokensIndex[tokenId];
1231         _allTokens.pop();
1232     }
1233 }
1234 
1235 // File: contracts/openzeppelin-contracts/contracts/access/Ownable.sol
1236 
1237 
1238 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 
1243 /**
1244  * @dev Contract module which provides a basic access control mechanism, where
1245  * there is an account (an owner) that can be granted exclusive access to
1246  * specific functions.
1247  *
1248  * By default, the owner account will be the one that deploys the contract. This
1249  * can later be changed with {transferOwnership}.
1250  *
1251  * This module is used through inheritance. It will make available the modifier
1252  * `onlyOwner`, which can be applied to your functions to restrict their use to
1253  * the owner.
1254  */
1255 abstract contract Ownable is Context {
1256     address private _owner;
1257 
1258     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1259 
1260     /**
1261      * @dev Initializes the contract setting the deployer as the initial owner.
1262      */
1263     constructor() {
1264         _transferOwnership(_msgSender());
1265     }
1266 
1267     /**
1268      * @dev Returns the address of the current owner.
1269      */
1270     function owner() public view virtual returns (address) {
1271         return _owner;
1272     }
1273 
1274     /**
1275      * @dev Throws if called by any account other than the owner.
1276      */
1277     modifier onlyOwner() {
1278         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1279         _;
1280     }
1281 
1282     /**
1283      * @dev Leaves the contract without owner. It will not be possible to call
1284      * `onlyOwner` functions anymore. Can only be called by the current owner.
1285      *
1286      * NOTE: Renouncing ownership will leave the contract without an owner,
1287      * thereby removing any functionality that is only available to the owner.
1288      */
1289     function renounceOwnership() public virtual onlyOwner {
1290         _transferOwnership(address(0));
1291     }
1292 
1293     /**
1294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1295      * Can only be called by the current owner.
1296      */
1297     function transferOwnership(address newOwner) public virtual onlyOwner {
1298         require(newOwner != address(0), "Ownable: new owner is the zero address");
1299         _transferOwnership(newOwner);
1300     }
1301 
1302     /**
1303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1304      * Internal function without access restriction.
1305      */
1306     function _transferOwnership(address newOwner) internal virtual {
1307         address oldOwner = _owner;
1308         _owner = newOwner;
1309         emit OwnershipTransferred(oldOwner, newOwner);
1310     }
1311 }
1312 
1313 // File: contracts/Wrapper.sol
1314 
1315 // contracts/Wrapper.sol
1316 
1317 pragma solidity ^0.8.10;
1318 
1319 
1320 interface Cities {
1321     function cityNames(uint id) external view returns (bytes8);
1322 }
1323 
1324 interface Ethz {
1325     function players(uint id) external view returns (address etherAddress, string memory name, uint treasury,
1326       uint capitol, uint numCities, uint numUnits, uint lastTimestamp);
1327     function numCities() external view returns (uint numCities);
1328     function getCity(uint cityID) external view returns (uint owner, string memory cityName, bool[5] memory buildings,
1329       uint[10] memory units, uint[2] memory rowcol, int previousID, int nextID);
1330     function map(uint row, uint col) external view returns (uint playerID);
1331     function setOwner(uint cityID, uint owner) external;
1332     function setName(uint cityID, string calldata name) external;
1333     function setUnit(uint cityID, uint i, uint unitType) external;
1334     function setPreviousID(uint cityID, int previousID) external;
1335     function setNextID(uint cityID, int nextID) external;
1336     function setRowcol(uint cityID, uint[2] calldata rowcol) external;
1337     function setMap(uint row, uint col, uint ind) external;
1338     function setBuilding(uint cityID, uint buildingType) external;
1339     function pushCity() external;
1340     function setNumCities(uint nc) external;
1341 }
1342 
1343 contract Wrapper is ERC721Enumerable, Ownable {
1344     
1345     //0.88 eth
1346     uint256 public mintAmount = 880000000000000000;
1347     
1348     address payable public vault1 = payable(0x32792cC3aeb2e796202Ad830C5184feD849d76dA);
1349     address payable public vault2 = payable(0x04329C5aE62fe7A4B1e5ee8fD5B99E861934f105);
1350     address payable public vault3 = payable(0xd73F16f12117a08492097C0C1cD0f10Cf0bBc1e4);
1351     address payable public vault4 = payable(0x364762CA0e5922Aa64c102EB8F0602ffA9123a0D);
1352 
1353     //list of frontend (ideally ipfs or other decentral storage) URIs
1354     string[] fe;
1355     Ethz public base;
1356     address public baseAddress = address(0xb40d0312BaC389AE0a05053020Aac80c9237358B);
1357     Cities public cities;
1358     address public citiesAddress = address(0xcbA79e9e16Ae2C5DFdBCE9ed169a06057B3BD2A1);
1359     //tokenIds on the map
1360     uint16[34][34] public nfts;
1361     //cityIds+1 from base contract on the map
1362     uint16[34][34] public map;
1363     //tokenId to row, col
1364     mapping(uint => uint[2]) public position;
1365     mapping(uint16 => uint16) public tokenIdToCityId;
1366     //tokenId to city buildings
1367     mapping(uint16 => bool[5]) public idToBuildings;
1368     //tokens per quadrant, for north-west quadrant less are available (289-49=240) as 49 (numCitiesOriginal) already exist
1369     uint16 tokensPerQuadrant = 289;
1370     //number of cities already existing in the base contract.
1371     //WARNING !!! IF CHANGED change initCounters method
1372     uint16 numCitiesOriginal = 49;
1373     //tokenId counters for civ types (1st dimension), building types (2nd dimension)
1374     uint16[4][4] public counters;
1375     //tokenId counter limits for civ types (1st dimension), building types (2nd dimension)
1376     uint16[4][4] counterLimits;
1377     //mapping of 0,1,2,3 (farm, stables, woodworks, metalworks) to original base contract codes
1378     uint16[] buildingTypes = [1, 4, 2, 3];
1379 
1380     /*uint16 public jG;
1381     uint16 public uG;
1382     uint16 public offsetG;*/
1383 
1384 
1385 
1386     constructor() ERC721("Wrapped Etherization", "WETHZ") {
1387         //fe.push("ipfs://somehash");
1388         base = Ethz(baseAddress);
1389         cities = Cities(citiesAddress);
1390         _initMap();
1391         _initIdToBuildings();
1392         _initCounters();
1393     }
1394 
1395     function sweep() public {
1396         require(msg.sender == owner() || msg.sender == vault1 ||
1397             msg.sender == vault2 || msg.sender == vault3 ||
1398             msg.sender == vault4);
1399         
1400         uint256 balance = address(this).balance;
1401 
1402         vault1.transfer(balance*650/1000);
1403         vault2.transfer(balance*100/1000);
1404         vault3.transfer(balance*125/1000);
1405         //vault4.transfer(balance*125/1000);
1406         vault4.transfer(address(this).balance);
1407     }
1408 
1409     //helper method for users to decode the city owner uint in base contract back to the address
1410     function uint160ToAddress(uint160 x) public pure returns (address) {
1411         return address(x);
1412     }
1413 
1414     function _baseURI() internal pure override returns (string memory) {
1415         return "ipfs://Qmank3UwrGWAoQbRxRCimKw7kdhgu2utUe1AGRr9zzz3bF/";
1416         //return "";
1417     }
1418 
1419     function contractURI() public pure returns (string memory) {
1420         return "ipfs://Qmdb7xp5YJWdLrVei6vnnhdV5EyrBx5Pdt4VXXoexA5QoW";
1421         //return "";
1422     }
1423 
1424     function getFrontend(uint version) public view returns (string memory) {
1425         return fe[version];
1426     }
1427 
1428     function getFrontendListLength() public view returns (uint) {
1429         return fe.length;
1430     }
1431 
1432     function addFrontend(string calldata uri) public onlyOwner {
1433         fe.push(uri);
1434     }
1435 
1436     function getMap() public view returns (uint16[34][34] memory) {
1437         return map;
1438     }
1439     
1440     function getNfts() public view returns (uint16[34][34] memory) {
1441         return nfts;
1442     }
1443 
1444     //if start method was used in the base contract, allow map update in the wrapper
1445     function setMap(uint16 cityId) public onlyOwner {
1446         uint[2] memory rowcol;
1447         (,,,,rowcol,,) = base.getCity(cityId);
1448         map[rowcol[0]][rowcol[1]] = cityId+1;
1449     }
1450 
1451     function wrap(uint16 cityId) public {
1452         uint owner;
1453         uint[2] memory rowcol;
1454         address ownerAddress;
1455 
1456         require(cityId < numCitiesOriginal);
1457 
1458         (owner,,,,rowcol,,) = base.getCity(cityId);
1459 
1460         //check if already wrapped
1461         require(nfts[rowcol[0]][rowcol[1]] == 0);
1462 
1463         (ownerAddress,,,,,,) = base.players(owner);
1464         //check that the city owner is msg.sender
1465         require(ownerAddress == msg.sender);
1466 
1467         base.setOwner(cityId, uint256(uint160(msg.sender)));
1468         (owner,,,,,,) = base.getCity(cityId);
1469         //check that writing to the base contract succeeded
1470         require(owner == uint256(uint160(msg.sender)));
1471 
1472         tokenIdToCityId[cityId+1] = cityId;
1473         position[cityId+1] = rowcol;
1474         nfts[rowcol[0]][rowcol[1]] = cityId+1;
1475         _mint(msg.sender, cityId+1);
1476     }
1477 
1478     
1479     //for cities built using base contract start method but not in the historic set
1480     function wrapNew(uint16 cityId) public {
1481         //token id
1482         uint16 id;
1483         //counter row (civ type)
1484         uint16 i;
1485         //offset that indexes token counter's 2nd dimension (building type)
1486         uint16 offset;
1487         uint owner;
1488         uint[2] memory rowcol;
1489         address ownerAddress;
1490 
1491         require(cityId >= numCitiesOriginal);
1492 
1493         (owner,,,,rowcol,,) = base.getCity(cityId);
1494 
1495         //check if already wrapped
1496         require(nfts[rowcol[0]][rowcol[1]] == 0);
1497 
1498         (ownerAddress,,,,,,) = base.players(owner);
1499         //check that the city owner is msg.sender
1500         require(ownerAddress == msg.sender);
1501 
1502         i = _quadrantFromRowCol(rowcol[0], rowcol[1]);
1503         offset = _randomOffset(i);
1504         
1505         id = counters[i][offset];
1506         counters[i][offset]++;
1507 
1508         base.setOwner(cityId, uint256(uint160(msg.sender)));
1509         base.setName(cityId, string(abi.encodePacked(cities.cityNames(id))));
1510         base.setBuilding(cityId, buildingTypes[offset]);
1511         (owner,,,,,,) = base.getCity(cityId);
1512         //check that writing to the base contract succeeded
1513         require(owner == uint256(uint160(msg.sender)));
1514 
1515         idToBuildings[id] = [false, false, false, false, false];
1516         idToBuildings[id][offset] = true;
1517 
1518         tokenIdToCityId[id] = cityId;
1519         position[id] = rowcol;
1520         nfts[rowcol[0]][rowcol[1]] = id;
1521         map[rowcol[0]][rowcol[1]] = cityId+1;
1522 
1523         _mint(msg.sender, id);
1524 
1525     }
1526     
1527     function mint(uint row, uint col)
1528         public payable returns (uint256)
1529     {
1530         //token id
1531         uint16 id;
1532         uint cityId;
1533         //counter row (civ type)
1534         uint16 i;
1535         //offset that indexes token counter's 2nd dimension (building type)
1536         uint16 offset;
1537 
1538         require(msg.value == mintAmount);
1539 
1540         //require that the tile is empty
1541         require(nfts[row][col] == 0 && map[row][col] == 0);
1542         require(base.map(row, col) == 0);
1543 
1544         i = _quadrantFromRowCol(row, col);
1545         offset = _randomOffset(i);
1546         
1547         id = counters[i][offset];
1548         counters[i][offset]++;
1549 
1550         cityId = base.numCities();
1551         base.pushCity();
1552         base.setOwner(cityId, uint256(uint160(msg.sender)));
1553         base.setName(cityId, string(abi.encodePacked(cities.cityNames(id))));
1554         base.setUnit(cityId, 0, 1);
1555         base.setRowcol(cityId, [row,col]);
1556         base.setPreviousID(cityId, -1);
1557         base.setNextID(cityId, -1);
1558         base.setMap(row, col, cityId+1);
1559         base.setBuilding(cityId, buildingTypes[offset]);
1560         base.setNumCities(cityId+1);
1561         //check that writing to the base contract was successful
1562         require(base.numCities() > cityId);
1563 
1564         idToBuildings[id] = [false, false, false, false, false];
1565         idToBuildings[id][offset] = true;
1566 
1567         tokenIdToCityId[id] = uint16(cityId);
1568         position[id] = [row, col];
1569         nfts[row][col] = id;
1570         map[row][col] = uint16(cityId+1);
1571 
1572         _mint(msg.sender, id);
1573 
1574         return id;
1575     }
1576 
1577     function _quadrantFromRowCol(uint row, uint col) internal pure returns (uint16) {
1578         uint16 i;
1579 
1580         if(row >= 0 && col >= 0 && row <= 16 && col <= 16) {
1581             i = 0;
1582         } else if(row >= 0 && col >= 17 && row <= 16 && col <= 34) {
1583             i = 1;
1584         } else if(row >= 17 && col >= 17 && row <= 34 && col <= 34) {
1585             i = 2;
1586         } else if(row >= 17 && col >= 0 && row <= 34 && col <= 16) {
1587             i = 3;
1588         } else {
1589             revert();
1590         }
1591         return i;
1592     }
1593 
1594     //i = counter row (quadrant, ie civ type)
1595     function _randomOffset(uint16 i) internal view returns (uint16) {
1596         uint ran;
1597         //counter column (building type)
1598         uint16 j;
1599         //if no more available cities with this building, offset with u to another city-building list
1600         uint16 u;
1601         //total offset is (j+u)%4
1602         uint16 offset;
1603 
1604         /* Randomly generate tokenId */
1605         //counter column -> random
1606         ran = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
1607         ran = ran % 100;
1608         if(ran < 10) {
1609             //metalworks
1610             j = 3;
1611         } else if(ran >= 10 && ran < 30) {
1612             //woodworks
1613             j = 2;
1614         } else if(ran >= 30 && ran < 58) {
1615             //stables
1616             j = 1;
1617         } else if(ran >= 58 && ran < 100) {
1618             //farm
1619             j = 0;
1620         } else {
1621             revert();
1622         }
1623         //if col filled (no more cities with this building type),
1624         //for loop +1 to +3, modulo 4, to get counter col
1625         for(u = 0; u <= 3; u++) {
1626             offset = (j + u) % 4;
1627             if(counters[i][offset] <= counterLimits[i][offset]) {
1628                 break;
1629             }
1630         }
1631         //all cities taken (no free cities in any building-type counter lists)
1632         if(u > 3) {
1633             revert();
1634         }
1635 
1636         /*jG = j;
1637         uG = u;
1638         offsetG = offset;*/
1639 
1640         return offset;
1641     }
1642 
1643     function _initMap() internal {
1644         map[10][10] = 1;
1645         map[10][9] = 2;
1646         map[11][9] = 3;
1647         map[9][8] = 4;
1648         map[10][8] = 5;
1649         map[11][7] = 6;
1650         map[9][7] = 7;
1651         map[8][6] = 8;
1652         map[8][7] = 9;
1653         map[7][8] = 10;
1654         map[6][8] = 11;
1655         map[5][7] = 12;
1656         map[7][9] = 13;
1657         map[11][10] = 14;
1658         map[8][9] = 15;
1659         map[6][7] = 16;
1660         map[7][5] = 17;
1661         map[8][8] = 18;
1662         map[8][10] = 19;
1663         map[7][4] = 20;
1664         map[11][8] = 21;
1665         map[11][11] = 22;
1666         map[6][6] = 23;
1667         map[6][9] = 24;
1668         map[7][6] = 25;
1669         map[12][7] = 26;
1670         map[13][6] = 27;
1671         map[10][7] = 28;
1672         map[13][5] = 29;
1673         map[12][6] = 30;
1674         map[12][5] = 31;
1675         map[13][7] = 32;
1676         map[5][9] = 33;
1677         map[5][8] = 34;
1678         map[8][11] = 35;
1679         map[7][3] = 36;
1680         map[9][11] = 37;
1681         map[5][6] = 38;
1682         map[4][6] = 39;
1683         map[8][4] = 40;
1684         map[13][4] = 41;
1685         map[14][6] = 42;
1686         map[7][12] = 43;
1687         map[6][2] = 44;
1688         map[5][2] = 45;
1689         map[6][3] = 46;
1690         map[7][7] = 47;
1691         map[4][8] = 48;
1692         map[6][5] = 49;
1693     }
1694 
1695     function _initIdToBuildings() internal {
1696         idToBuildings[1] = [true,true,false,false,true];
1697         idToBuildings[2] = [false,true,false,false,true];
1698         idToBuildings[3] = [true,false,false,false,true];
1699         idToBuildings[4] = [false,false,false,false,true];
1700         idToBuildings[5] = [false,false,false,false,true];
1701         idToBuildings[6] = [false,false,false,false,false];
1702         idToBuildings[7] = [false,false,false,false,false];
1703         idToBuildings[8] = [false,false,false,false,false];
1704         idToBuildings[9] = [false,false,false,false,false];
1705         idToBuildings[10] = [true,false,false,false,true];
1706         idToBuildings[11] = [false,true,false,true,false];
1707         idToBuildings[12] = [false,true,false,false,false];
1708         idToBuildings[13] = [false,false,false,false,false];
1709         idToBuildings[14] = [true,true,true,false,true];
1710         idToBuildings[15] = [false,false,false,true,false];
1711         idToBuildings[16] = [true,false,false,false,true];
1712         idToBuildings[17] = [false,false,false,false,true];
1713         idToBuildings[18] = [true,false,false,false,false];
1714         idToBuildings[19] = [true,true,true,true,true];
1715         idToBuildings[20] = [true,true,true,true,true];
1716         idToBuildings[21] = [false,false,false,false,true];
1717         idToBuildings[22] = [true,true,false,true,true];
1718         idToBuildings[23] = [true,false,false,false,false];
1719         idToBuildings[24] = [false,false,true,false,false];
1720         idToBuildings[25] = [false,false,false,false,false];
1721         idToBuildings[26] = [false,false,false,false,false];
1722         idToBuildings[27] = [false,false,false,false,false];
1723         idToBuildings[28] = [false,false,false,false,false];
1724         idToBuildings[29] = [false,false,false,false,false];
1725         idToBuildings[30] = [false,false,false,false,false];
1726         idToBuildings[31] = [false,false,false,false,false];
1727         idToBuildings[32] = [false,false,false,false,false];
1728         idToBuildings[33] = [false,false,true,true,false];
1729         idToBuildings[34] = [false,true,true,false,true];
1730         idToBuildings[35] = [true,true,true,true,true];
1731         idToBuildings[36] = [true,true,true,true,true];
1732         idToBuildings[37] = [true,true,true,true,true];
1733         idToBuildings[38] = [false,false,false,false,false];
1734         idToBuildings[39] = [false,false,true,false,false];
1735         idToBuildings[40] = [false,false,false,false,false];
1736         idToBuildings[41] = [false,false,false,false,false];
1737         idToBuildings[42] = [false,false,false,false,false];
1738         idToBuildings[43] = [true,false,false,false,false];
1739         idToBuildings[44] = [false,false,false,false,true];
1740         idToBuildings[45] = [false,false,false,false,false];
1741         idToBuildings[46] = [false,false,false,false,false];
1742         idToBuildings[47] = [false,false,false,false,false];
1743         idToBuildings[48] = [false,false,false,false,false];
1744         idToBuildings[49] = [false,false,false,false,false];
1745     }
1746 
1747     //initialize the tokenId counters based on building rarity % 
1748     function _initCounters() internal {
1749         //QUADRANT1
1750         //1-49 taken
1751         counters[0][0] = 50;
1752         counterLimits[0][0] = 147;
1753         counters[0][1] = 148;
1754         counterLimits[0][1] = 216;
1755         counters[0][2] = 217;
1756         counterLimits[0][2] = 264;
1757         counters[0][3] = 265;
1758         counterLimits[0][3] = 289;
1759         //QUADRANT2
1760         counters[1][0] = 290;
1761         counterLimits[1][0] = 410;
1762         counters[1][1] = 411;
1763         counterLimits[1][1] = 491;
1764         counters[1][2] = 492;
1765         counterLimits[1][2] = 549;
1766         counters[1][3] = 550;
1767         counterLimits[1][3] = 578;
1768         //QUADRANT3
1769         counters[2][0] = 579;
1770         counterLimits[2][0] = 699;
1771         counters[2][1] = 700;
1772         counterLimits[2][1] = 780;
1773         counters[2][2] = 781;
1774         counterLimits[2][2] = 838;
1775         counters[2][3] = 839;
1776         counterLimits[2][3] = 867;
1777         //QUADRANT4
1778         counters[3][0] = 868;
1779         counterLimits[3][0] = 988;
1780         counters[3][1] = 989;
1781         counterLimits[3][1] = 1069;
1782         counters[3][2] = 1070;
1783         counterLimits[3][2] = 1127;
1784         counters[3][3] = 1128;
1785         counterLimits[3][3] = 1156;
1786     }
1787 
1788     function _transfer(
1789         address from,
1790         address to,
1791         uint256 tokenId
1792     ) internal override {
1793         base.setOwner(tokenIdToCityId[uint16(tokenId)], uint256(uint160(to)));
1794         super._transfer(from, to, tokenId);
1795     }
1796 
1797 }