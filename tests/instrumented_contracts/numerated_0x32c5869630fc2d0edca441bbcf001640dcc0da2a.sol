1 // SPDX-License-Identifier: MIT
2 
3 /*
4   _______ _____            _____ _    _ _____        _   _ _____          ______
5  |__   __|  __ \    /\    / ____| |  | |  __ \ /\   | \ | |  __ \   /\   |___  /
6     | |  | |__) |  /  \  | (___ | |__| | |__) /  \  |  \| | |  | | /  \     / / 
7     | |  |  _  /  / /\ \  \___ \|  __  |  ___/ /\ \ | . ` | |  | |/ /\ \   / /  
8     | |  | | \ \ / ____ \ ____) | |  | | |  / ____ \| |\  | |__| / ____ \ / /__ 
9     |_|  |_|  \_|_/    \_\_____/|_|  |_|_| /_/    \_\_| \_|_____/_/    \_|_____|
10 
11 */
12 
13 // File @openzeppelin/contracts/utils/introspection/IERC165.sol
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Interface of the ERC165 standard, as defined in the
19  * https://eips.ethereum.org/EIPS/eip-165[EIP].
20  *
21  * Implementers can declare support of contract interfaces, which can then be
22  * queried by others ({ERC165Checker}).
23  *
24  * For an implementation, see {ERC165}.
25  */
26 interface IERC165 {
27     /**
28      * @dev Returns true if this contract implements the interface defined by
29      * `interfaceId`. See the corresponding
30      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
31      * to learn more about how these ids are created.
32      *
33      * This function call must use less than 30 000 gas.
34      */
35     function supportsInterface(bytes4 interfaceId) external view returns (bool);
36 }
37 
38 // File @openzeppelin/contracts/token/ERC721/IERC721.sol
39 
40 pragma solidity ^0.8.0;
41 
42 
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59      */
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     /**
63      * @dev Returns the number of tokens in ``owner``'s account.
64      */
65     function balanceOf(address owner) external view returns (uint256 balance);
66 
67     /**
68      * @dev Returns the owner of the `tokenId` token.
69      *
70      * Requirements:
71      *
72      * - `tokenId` must exist.
73      */
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75 
76     /**
77      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
78      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must exist and be owned by `from`.
85      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
86      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
87      *
88      * Emits a {Transfer} event.
89      */
90     function safeTransferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId) external view returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator) external view returns (bool);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external;
178 }
179 
180 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
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
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
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
233 // File @openzeppelin/contracts/utils/Address.sol
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
450 // File @openzeppelin/contracts/utils/Context.sol
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Provides information about the current execution context, including the
456  * sender of the transaction and its data. While these are generally available
457  * via msg.sender and msg.data, they should not be accessed in such a direct
458  * manner, since when dealing with meta-transactions the account sending and
459  * paying for execution may not be the actual sender (as far as an application
460  * is concerned).
461  *
462  * This contract is only required for intermediate, library-like contracts.
463  */
464 abstract contract Context {
465     function _msgSender() internal view virtual returns (address) {
466         return msg.sender;
467     }
468 
469     function _msgData() internal view virtual returns (bytes calldata) {
470         return msg.data;
471     }
472 }
473 
474 // File @openzeppelin/contracts/utils/Strings.sol
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev String operations.
480  */
481 library Strings {
482     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
486      */
487     function toString(uint256 value) internal pure returns (string memory) {
488         // Inspired by OraclizeAPI's implementation - MIT licence
489         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
490 
491         if (value == 0) {
492             return "0";
493         }
494         uint256 temp = value;
495         uint256 digits;
496         while (temp != 0) {
497             digits++;
498             temp /= 10;
499         }
500         bytes memory buffer = new bytes(digits);
501         while (value != 0) {
502             digits -= 1;
503             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
504             value /= 10;
505         }
506         return string(buffer);
507     }
508 
509     /**
510      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
511      */
512     function toHexString(uint256 value) internal pure returns (string memory) {
513         if (value == 0) {
514             return "0x00";
515         }
516         uint256 temp = value;
517         uint256 length = 0;
518         while (temp != 0) {
519             length++;
520             temp >>= 8;
521         }
522         return toHexString(value, length);
523     }
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
527      */
528     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
529         bytes memory buffer = new bytes(2 * length + 2);
530         buffer[0] = "0";
531         buffer[1] = "x";
532         for (uint256 i = 2 * length + 1; i > 1; --i) {
533             buffer[i] = _HEX_SYMBOLS[value & 0xf];
534             value >>= 4;
535         }
536         require(value == 0, "Strings: hex length insufficient");
537         return string(buffer);
538     }
539 }
540 
541 // File @openzeppelin/contracts/utils/introspection/ERC165.sol
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @dev Implementation of the {IERC165} interface.
548  *
549  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
550  * for the additional interface id that will be supported. For example:
551  *
552  * ```solidity
553  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
555  * }
556  * ```
557  *
558  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
559  */
560 abstract contract ERC165 is IERC165 {
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565         return interfaceId == type(IERC165).interfaceId;
566     }
567 }
568 
569 // File @openzeppelin/contracts/token/ERC721/ERC721.sol
570 
571 pragma solidity ^0.8.0;
572 
573 
574 
575 
576 
577 
578 
579 
580 /**
581  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
582  * the Metadata extension, but not including the Enumerable extension, which is available separately as
583  * {ERC721Enumerable}.
584  */
585 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
586     using Address for address;
587     using Strings for uint256;
588 
589     // Token name
590     string private _name;
591 
592     // Token symbol
593     string private _symbol;
594 
595     // Mapping from token ID to owner address
596     mapping(uint256 => address) private _owners;
597 
598     // Mapping owner address to token count
599     mapping(address => uint256) private _balances;
600 
601     // Mapping from token ID to approved address
602     mapping(uint256 => address) private _tokenApprovals;
603 
604     // Mapping from owner to operator approvals
605     mapping(address => mapping(address => bool)) private _operatorApprovals;
606 
607     /**
608      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
609      */
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }
614 
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
619         return
620             interfaceId == type(IERC721).interfaceId ||
621             interfaceId == type(IERC721Metadata).interfaceId ||
622             super.supportsInterface(interfaceId);
623     }
624 
625     /**
626      * @dev See {IERC721-balanceOf}.
627      */
628     function balanceOf(address owner) public view virtual override returns (uint256) {
629         require(owner != address(0), "ERC721: balance query for the zero address");
630         return _balances[owner];
631     }
632 
633     /**
634      * @dev See {IERC721-ownerOf}.
635      */
636     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
637         address owner = _owners[tokenId];
638         require(owner != address(0), "ERC721: owner query for nonexistent token");
639         return owner;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-name}.
644      */
645     function name() public view virtual override returns (string memory) {
646         return _name;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-symbol}.
651      */
652     function symbol() public view virtual override returns (string memory) {
653         return _symbol;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-tokenURI}.
658      */
659     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
660         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
661 
662         string memory baseURI = _baseURI();
663         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
664     }
665 
666     /**
667      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
668      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
669      * by default, can be overriden in child contracts.
670      */
671     function _baseURI() internal view virtual returns (string memory) {
672         return "";
673     }
674 
675     /**
676      * @dev See {IERC721-approve}.
677      */
678     function approve(address to, uint256 tokenId) public virtual override {
679         address owner = ERC721.ownerOf(tokenId);
680         require(to != owner, "ERC721: approval to current owner");
681 
682         require(
683             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
684             "ERC721: approve caller is not owner nor approved for all"
685         );
686 
687         _approve(to, tokenId);
688     }
689 
690     /**
691      * @dev See {IERC721-getApproved}.
692      */
693     function getApproved(uint256 tokenId) public view virtual override returns (address) {
694         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
695 
696         return _tokenApprovals[tokenId];
697     }
698 
699     /**
700      * @dev See {IERC721-setApprovalForAll}.
701      */
702     function setApprovalForAll(address operator, bool approved) public virtual override {
703         require(operator != _msgSender(), "ERC721: approve to caller");
704 
705         _operatorApprovals[_msgSender()][operator] = approved;
706         emit ApprovalForAll(_msgSender(), operator, approved);
707     }
708 
709     /**
710      * @dev See {IERC721-isApprovedForAll}.
711      */
712     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
713         return _operatorApprovals[owner][operator];
714     }
715 
716     /**
717      * @dev See {IERC721-transferFrom}.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         //solhint-disable-next-line max-line-length
725         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
726 
727         _transfer(from, to, tokenId);
728     }
729 
730     /**
731      * @dev See {IERC721-safeTransferFrom}.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) public virtual override {
738         safeTransferFrom(from, to, tokenId, "");
739     }
740 
741     /**
742      * @dev See {IERC721-safeTransferFrom}.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId,
748         bytes memory _data
749     ) public virtual override {
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751         _safeTransfer(from, to, tokenId, _data);
752     }
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
756      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
757      *
758      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
759      *
760      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
761      * implement alternative mechanisms to perform token transfer, such as signature-based.
762      *
763      * Requirements:
764      *
765      * - `from` cannot be the zero address.
766      * - `to` cannot be the zero address.
767      * - `tokenId` token must exist and be owned by `from`.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeTransfer(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes memory _data
777     ) internal virtual {
778         _transfer(from, to, tokenId);
779         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
780     }
781 
782     /**
783      * @dev Returns whether `tokenId` exists.
784      *
785      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
786      *
787      * Tokens start existing when they are minted (`_mint`),
788      * and stop existing when they are burned (`_burn`).
789      */
790     function _exists(uint256 tokenId) internal view virtual returns (bool) {
791         return _owners[tokenId] != address(0);
792     }
793 
794     /**
795      * @dev Returns whether `spender` is allowed to manage `tokenId`.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must exist.
800      */
801     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
802         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
803         address owner = ERC721.ownerOf(tokenId);
804         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
805     }
806 
807     /**
808      * @dev Safely mints `tokenId` and transfers it to `to`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must not exist.
813      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _safeMint(address to, uint256 tokenId) internal virtual {
818         _safeMint(to, tokenId, "");
819     }
820 
821     /**
822      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
823      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
824      */
825     function _safeMint(
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) internal virtual {
830         _mint(to, tokenId);
831         require(
832             _checkOnERC721Received(address(0), to, tokenId, _data),
833             "ERC721: transfer to non ERC721Receiver implementer"
834         );
835     }
836 
837     /**
838      * @dev Mints `tokenId` and transfers it to `to`.
839      *
840      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
841      *
842      * Requirements:
843      *
844      * - `tokenId` must not exist.
845      * - `to` cannot be the zero address.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _mint(address to, uint256 tokenId) internal virtual {
850         require(to != address(0), "ERC721: mint to the zero address");
851         require(!_exists(tokenId), "ERC721: token already minted");
852 
853         _beforeTokenTransfer(address(0), to, tokenId);
854 
855         _balances[to] += 1;
856         _owners[tokenId] = to;
857 
858         emit Transfer(address(0), to, tokenId);
859     }
860 
861     /**
862      * @dev Destroys `tokenId`.
863      * The approval is cleared when the token is burned.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _burn(uint256 tokenId) internal virtual {
872         address owner = ERC721.ownerOf(tokenId);
873 
874         _beforeTokenTransfer(owner, address(0), tokenId);
875 
876         // Clear approvals
877         _approve(address(0), tokenId);
878 
879         _balances[owner] -= 1;
880         delete _owners[tokenId];
881 
882         emit Transfer(owner, address(0), tokenId);
883     }
884 
885     /**
886      * @dev Transfers `tokenId` from `from` to `to`.
887      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
888      *
889      * Requirements:
890      *
891      * - `to` cannot be the zero address.
892      * - `tokenId` token must be owned by `from`.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _transfer(
897         address from,
898         address to,
899         uint256 tokenId
900     ) internal virtual {
901         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
902         require(to != address(0), "ERC721: transfer to the zero address");
903 
904         _beforeTokenTransfer(from, to, tokenId);
905 
906         // Clear approvals from the previous owner
907         _approve(address(0), tokenId);
908 
909         _balances[from] -= 1;
910         _balances[to] += 1;
911         _owners[tokenId] = to;
912 
913         emit Transfer(from, to, tokenId);
914     }
915 
916     /**
917      * @dev Approve `to` to operate on `tokenId`
918      *
919      * Emits a {Approval} event.
920      */
921     function _approve(address to, uint256 tokenId) internal virtual {
922         _tokenApprovals[tokenId] = to;
923         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
924     }
925 
926     /**
927      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
928      * The call is not executed if the target address is not a contract.
929      *
930      * @param from address representing the previous owner of the given token ID
931      * @param to target address that will receive the tokens
932      * @param tokenId uint256 ID of the token to be transferred
933      * @param _data bytes optional data to send along with the call
934      * @return bool whether the call correctly returned the expected magic value
935      */
936     function _checkOnERC721Received(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) private returns (bool) {
942         if (to.isContract()) {
943             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
944                 return retval == IERC721Receiver.onERC721Received.selector;
945             } catch (bytes memory reason) {
946                 if (reason.length == 0) {
947                     revert("ERC721: transfer to non ERC721Receiver implementer");
948                 } else {
949                     assembly {
950                         revert(add(32, reason), mload(reason))
951                     }
952                 }
953             }
954         } else {
955             return true;
956         }
957     }
958 
959     /**
960      * @dev Hook that is called before any token transfer. This includes minting
961      * and burning.
962      *
963      * Calling conditions:
964      *
965      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
966      * transferred to `to`.
967      * - When `from` is zero, `tokenId` will be minted for `to`.
968      * - When `to` is zero, ``from``'s `tokenId` will be burned.
969      * - `from` and `to` are never both zero.
970      *
971      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
972      */
973     function _beforeTokenTransfer(
974         address from,
975         address to,
976         uint256 tokenId
977     ) internal virtual {}
978 }
979 
980 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
981 
982 pragma solidity ^0.8.0;
983 
984 
985 /**
986  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
987  * @dev See https://eips.ethereum.org/EIPS/eip-721
988  */
989 interface IERC721Enumerable is IERC721 {
990     /**
991      * @dev Returns the total amount of tokens stored by the contract.
992      */
993     function totalSupply() external view returns (uint256);
994 
995     /**
996      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
997      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
998      */
999     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1000 
1001     /**
1002      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1003      * Use along with {totalSupply} to enumerate all tokens.
1004      */
1005     function tokenByIndex(uint256 index) external view returns (uint256);
1006 }
1007 
1008 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 
1013 
1014 /**
1015  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1016  * enumerability of all the token ids in the contract as well as all token ids owned by each
1017  * account.
1018  */
1019 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1020     // Mapping from owner to list of owned token IDs
1021     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1022 
1023     // Mapping from token ID to index of the owner tokens list
1024     mapping(uint256 => uint256) private _ownedTokensIndex;
1025 
1026     // Array with all token ids, used for enumeration
1027     uint256[] private _allTokens;
1028 
1029     // Mapping from token id to position in the allTokens array
1030     mapping(uint256 => uint256) private _allTokensIndex;
1031 
1032     /**
1033      * @dev See {IERC165-supportsInterface}.
1034      */
1035     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1036         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1041      */
1042     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1043         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1044         return _ownedTokens[owner][index];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Enumerable-totalSupply}.
1049      */
1050     function totalSupply() public view virtual override returns (uint256) {
1051         return _allTokens.length;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-tokenByIndex}.
1056      */
1057     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1058         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1059         return _allTokens[index];
1060     }
1061 
1062     /**
1063      * @dev Hook that is called before any token transfer. This includes minting
1064      * and burning.
1065      *
1066      * Calling conditions:
1067      *
1068      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1069      * transferred to `to`.
1070      * - When `from` is zero, `tokenId` will be minted for `to`.
1071      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1072      * - `from` cannot be the zero address.
1073      * - `to` cannot be the zero address.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _beforeTokenTransfer(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) internal virtual override {
1082         super._beforeTokenTransfer(from, to, tokenId);
1083 
1084         if (from == address(0)) {
1085             _addTokenToAllTokensEnumeration(tokenId);
1086         } else if (from != to) {
1087             _removeTokenFromOwnerEnumeration(from, tokenId);
1088         }
1089         if (to == address(0)) {
1090             _removeTokenFromAllTokensEnumeration(tokenId);
1091         } else if (to != from) {
1092             _addTokenToOwnerEnumeration(to, tokenId);
1093         }
1094     }
1095 
1096     /**
1097      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1098      * @param to address representing the new owner of the given token ID
1099      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1100      */
1101     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1102         uint256 length = ERC721.balanceOf(to);
1103         _ownedTokens[to][length] = tokenId;
1104         _ownedTokensIndex[tokenId] = length;
1105     }
1106 
1107     /**
1108      * @dev Private function to add a token to this extension's token tracking data structures.
1109      * @param tokenId uint256 ID of the token to be added to the tokens list
1110      */
1111     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1112         _allTokensIndex[tokenId] = _allTokens.length;
1113         _allTokens.push(tokenId);
1114     }
1115 
1116     /**
1117      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1118      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1119      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1120      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1121      * @param from address representing the previous owner of the given token ID
1122      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1123      */
1124     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1125         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1126         // then delete the last slot (swap and pop).
1127 
1128         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1129         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1130 
1131         // When the token to delete is the last token, the swap operation is unnecessary
1132         if (tokenIndex != lastTokenIndex) {
1133             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1134 
1135             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1136             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1137         }
1138 
1139         // This also deletes the contents at the last position of the array
1140         delete _ownedTokensIndex[tokenId];
1141         delete _ownedTokens[from][lastTokenIndex];
1142     }
1143 
1144     /**
1145      * @dev Private function to remove a token from this extension's token tracking data structures.
1146      * This has O(1) time complexity, but alters the order of the _allTokens array.
1147      * @param tokenId uint256 ID of the token to be removed from the tokens list
1148      */
1149     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1150         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1151         // then delete the last slot (swap and pop).
1152 
1153         uint256 lastTokenIndex = _allTokens.length - 1;
1154         uint256 tokenIndex = _allTokensIndex[tokenId];
1155 
1156         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1157         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1158         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1159         uint256 lastTokenId = _allTokens[lastTokenIndex];
1160 
1161         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1162         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1163 
1164         // This also deletes the contents at the last position of the array
1165         delete _allTokensIndex[tokenId];
1166         _allTokens.pop();
1167     }
1168 }
1169 
1170 // File @openzeppelin/contracts/access/Ownable.sol
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 /**
1176  * @dev Contract module which provides a basic access control mechanism, where
1177  * there is an account (an owner) that can be granted exclusive access to
1178  * specific functions.
1179  *
1180  * By default, the owner account will be the one that deploys the contract. This
1181  * can later be changed with {transferOwnership}.
1182  *
1183  * This module is used through inheritance. It will make available the modifier
1184  * `onlyOwner`, which can be applied to your functions to restrict their use to
1185  * the owner.
1186  */
1187 abstract contract Ownable is Context {
1188     address private _owner;
1189 
1190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1191 
1192     /**
1193      * @dev Initializes the contract setting the deployer as the initial owner.
1194      */
1195     constructor() {
1196         _setOwner(_msgSender());
1197     }
1198 
1199     /**
1200      * @dev Returns the address of the current owner.
1201      */
1202     function owner() public view virtual returns (address) {
1203         return _owner;
1204     }
1205 
1206     /**
1207      * @dev Throws if called by any account other than the owner.
1208      */
1209     modifier onlyOwner() {
1210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1211         _;
1212     }
1213 
1214     /**
1215      * @dev Leaves the contract without owner. It will not be possible to call
1216      * `onlyOwner` functions anymore. Can only be called by the current owner.
1217      *
1218      * NOTE: Renouncing ownership will leave the contract without an owner,
1219      * thereby removing any functionality that is only available to the owner.
1220      */
1221     function renounceOwnership() public virtual onlyOwner {
1222         _setOwner(address(0));
1223     }
1224 
1225     /**
1226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1227      * Can only be called by the current owner.
1228      */
1229     function transferOwnership(address newOwner) public virtual onlyOwner {
1230         require(newOwner != address(0), "Ownable: new owner is the zero address");
1231         _setOwner(newOwner);
1232     }
1233 
1234     function _setOwner(address newOwner) private {
1235         address oldOwner = _owner;
1236         _owner = newOwner;
1237         emit OwnershipTransferred(oldOwner, newOwner);
1238     }
1239 }
1240 
1241 // File contracts/trashpandaz.sol
1242 
1243 pragma solidity ^0.8.4;
1244 
1245 
1246 contract TrashPandaz is ERC721Enumerable, Ownable {  
1247     using Address for address;
1248     
1249     // Trash Pandaz
1250     bool public saleLive = false;
1251     bool public presaleLive = false;
1252     uint256 constant MAX_PANDAS = 10000;
1253     uint256 constant PRIVATE_PANDAS = 2000;
1254 	uint256 public reserved = 300;
1255     uint256 public price = 0.03 ether;
1256     uint256 public presaleAmountMinted;
1257     uint256 public presaleLimit = 2;
1258     mapping(address => bool) public presaleList;
1259     mapping(address => uint256) public presaleListPurchases;
1260     string public baseTokenURI;
1261     string private _contractURI = "https://trashpandaz.s3.us-east-2.amazonaws.com/phmeta/os";
1262     constructor (string memory newBaseURI) ERC721 ("Trash Pandaz", "TRASHPANDAZ") {
1263         setBaseURI(newBaseURI);
1264     }
1265 
1266     // Public Functions
1267     
1268     // Override so the openzeppelin tokenURI() method will use this method to create the full tokenURI instead
1269     function _baseURI() internal view virtual override returns (string memory) {
1270 		return baseTokenURI;
1271     }
1272 
1273     // View contractURI
1274     function contractURI() external view returns (string memory){
1275 		return _contractURI;
1276     }
1277 
1278     // See which address owns which tokens
1279     function tokensOfOwner(address addr) public view returns(uint256[] memory) {
1280         uint256 tokenCount = balanceOf(addr);
1281         uint256[] memory tokenId = new uint256[](tokenCount);
1282         for(uint256 i; i < tokenCount; i++){
1283             tokenId[i] = tokenOfOwnerByIndex(addr, i);
1284         }
1285         return tokenId;
1286     }
1287 
1288     // Minting
1289     function mintToken(uint256 _amount) public payable {
1290 	    uint256 supply = totalSupply();
1291         require( saleLive,                     "Sale is not active" );
1292         require( _amount > 0 && _amount < 6,    "Can only mint up to 5 tokens at once" );
1293         require( supply + _amount <= MAX_PANDAS, "Cannot mint more than max supply" );
1294         require( msg.value == price * _amount,   "Wrong amount of ETH sent" );
1295         for(uint256 i; i < _amount; i++){
1296             _safeMint( msg.sender, supply + i );
1297         }
1298     }
1299     
1300     // Presale minting
1301     function presaleMint(uint256 _amount) external payable {
1302 	    uint256 supply = totalSupply();
1303         require( presaleLive, "Presale is not active");
1304         require( presaleList[msg.sender], "Not on presale list");
1305         require( supply + _amount < MAX_PANDAS, "Cannot mint more than max supply" );
1306         require( presaleAmountMinted + _amount <= PRIVATE_PANDAS, "Presale sold out" );
1307         require( presaleListPurchases[msg.sender] + _amount <= presaleLimit, "Presale limit reached" );
1308         require( price * _amount <= msg.value, "Wrong amount of ETH sent" );
1309         for (uint256 i; i < _amount; i++) {
1310             presaleAmountMinted++;
1311             presaleListPurchases[msg.sender]++;
1312             _safeMint(msg.sender, supply + i );
1313         }
1314     }
1315 
1316     // Owner Functions 
1317     
1318     // Reserve minting
1319     function mintReserved(uint256 _amount) public onlyOwner {
1320         require( _amount <= reserved, "Cannot reserve more than reserved" );
1321         reserved -= _amount;
1322         uint256 supply = totalSupply();
1323         for(uint256 i; i < _amount; i++){
1324             _safeMint( msg.sender, supply + i );
1325         }
1326     }
1327 
1328     // Start and stop sale
1329     function setSaleLive(bool val) public onlyOwner {
1330         saleLive = val;
1331     }
1332     
1333     // Start and stop presale
1334     function setPresaleLive(bool val) public onlyOwner {
1335         presaleLive = val;
1336     }
1337     
1338     // Add to presale
1339     function addToPresaleList(address[] calldata entries) external onlyOwner {
1340         for(uint256 i = 0; i < entries.length; i++) {
1341             address entry = entries[i];
1342             require(entry != address(0), "Not a valid address");
1343             require(!presaleList[entry], "Address already exists on presale list");
1344 
1345             presaleList[entry] = true;
1346         }   
1347     }
1348     
1349     // Remove from presale
1350         function removeFromPresaleList(address[] calldata entries) external onlyOwner {
1351         for(uint256 i = 0; i < entries.length; i++) {
1352             address entry = entries[i];
1353             require(entry != address(0), "Not an address");
1354             
1355             presaleList[entry] = false;
1356         }
1357     }
1358     
1359 
1360     // Set baseURI
1361     function setBaseURI(string memory baseURI) public onlyOwner {
1362         baseTokenURI = baseURI;
1363     }
1364     
1365     // Set contractURI
1366     function setContractURI(string memory newContractURI) external onlyOwner {
1367 		_contractURI = newContractURI;
1368     }
1369 
1370     // Change price
1371     function setPrice(uint256 newPrice) public onlyOwner {
1372         price = newPrice;
1373     }
1374 
1375     // Withdraw to owner
1376     function withdraw() public onlyOwner {
1377         (bool success, ) = owner().call{value: address(this).balance}("");
1378         require(success, "TrashPandaz: Withdraw Failed");
1379     }
1380 }