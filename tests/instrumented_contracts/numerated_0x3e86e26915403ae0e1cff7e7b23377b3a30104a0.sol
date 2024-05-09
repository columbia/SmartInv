1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 /**
5 
6 Created with <3 by https://twitter.com/0xfoobar and mar3k
7 
8 #     # ######     ######  #     # #     # #    #  #####
9 #     # #     #    #     # #     # ##    # #   #  #     #
10 #     # #     #    #     # #     # # #   # #  #   #
11 ####### #     #    ######  #     # #  #  # ###     #####
12 #     # #     #    #       #     # #   # # #  #         #
13 #     # #     #    #       #     # #    ## #   #  #     #
14 #     # ######     #        #####  #     # #    #  #####
15 
16 https://hdpunks.com
17 
18 */
19 
20 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
21 
22 
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
48 
49 
50 
51 pragma solidity ^0.8.0;
52 
53 
54 /**
55  * @dev Required interface of an ERC721 compliant contract.
56  */
57 interface IERC721 is IERC165 {
58     /**
59      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
60      */
61     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
65      */
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
70      */
71     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
72 
73     /**
74      * @dev Returns the number of tokens in ``owner``'s account.
75      */
76     function balanceOf(address owner) external view returns (uint256 balance);
77 
78     /**
79      * @dev Returns the owner of the `tokenId` token.
80      *
81      * Requirements:
82      *
83      * - `tokenId` must exist.
84      */
85     function ownerOf(uint256 tokenId) external view returns (address owner);
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(address from, address to, uint256 tokenId) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(address from, address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Returns the account approved for `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function getApproved(uint256 tokenId) external view returns (address operator);
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
157      *
158      * See {setApprovalForAll}
159      */
160     function isApprovedForAll(address owner, address operator) external view returns (bool);
161 
162     /**
163       * @dev Safely transfers `tokenId` token from `from` to `to`.
164       *
165       * Requirements:
166       *
167       * - `from` cannot be the zero address.
168       * - `to` cannot be the zero address.
169       * - `tokenId` token must exist and be owned by `from`.
170       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172       *
173       * Emits a {Transfer} event.
174       */
175     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
176 }
177 
178 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
179 
180 
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
199     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
200 }
201 
202 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
203 
204 
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214 
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
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
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
264         // solhint-disable-next-line no-inline-assembly
265         assembly { size := extcodesize(account) }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
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
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         require(isContract(target), "Address: call to non-contract");
349 
350         // solhint-disable-next-line avoid-low-level-calls
351         (bool success, bytes memory returndata) = target.call{ value: value }(data);
352         return _verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
362         return functionStaticCall(target, data, "Address: low-level static call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return _verifyCallResult(success, returndata, errorMessage);
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
395     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
396         require(isContract(target), "Address: delegate call to non-contract");
397 
398         // solhint-disable-next-line avoid-low-level-calls
399         (bool success, bytes memory returndata) = target.delegatecall(data);
400         return _verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 // solhint-disable-next-line no-inline-assembly
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/Context.sol
424 
425 
426 
427 pragma solidity ^0.8.0;
428 
429 /*
430  * @dev Provides information about the current execution context, including the
431  * sender of the transaction and its data. While these are generally available
432  * via msg.sender and msg.data, they should not be accessed in such a direct
433  * manner, since when dealing with meta-transactions the account sending and
434  * paying for execution may not be the actual sender (as far as an application
435  * is concerned).
436  *
437  * This contract is only required for intermediate, library-like contracts.
438  */
439 abstract contract Context {
440     function _msgSender() internal view virtual returns (address) {
441         return msg.sender;
442     }
443 
444     function _msgData() internal view virtual returns (bytes calldata) {
445         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
446         return msg.data;
447     }
448 }
449 
450 // File: @openzeppelin/contracts/utils/Strings.sol
451 
452 
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev String operations.
458  */
459 library Strings {
460     bytes16 private constant alphabet = "0123456789abcdef";
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
464      */
465     function toString(uint256 value) internal pure returns (string memory) {
466         // Inspired by OraclizeAPI's implementation - MIT licence
467         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
468 
469         if (value == 0) {
470             return "0";
471         }
472         uint256 temp = value;
473         uint256 digits;
474         while (temp != 0) {
475             digits++;
476             temp /= 10;
477         }
478         bytes memory buffer = new bytes(digits);
479         while (value != 0) {
480             digits -= 1;
481             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
482             value /= 10;
483         }
484         return string(buffer);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
489      */
490     function toHexString(uint256 value) internal pure returns (string memory) {
491         if (value == 0) {
492             return "0x00";
493         }
494         uint256 temp = value;
495         uint256 length = 0;
496         while (temp != 0) {
497             length++;
498             temp >>= 8;
499         }
500         return toHexString(value, length);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
505      */
506     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
507         bytes memory buffer = new bytes(2 * length + 2);
508         buffer[0] = "0";
509         buffer[1] = "x";
510         for (uint256 i = 2 * length + 1; i > 1; --i) {
511             buffer[i] = alphabet[value & 0xf];
512             value >>= 4;
513         }
514         require(value == 0, "Strings: hex length insufficient");
515         return string(buffer);
516     }
517 
518 }
519 
520 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
521 
522 
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @dev Implementation of the {IERC165} interface.
529  *
530  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
531  * for the additional interface id that will be supported. For example:
532  *
533  * ```solidity
534  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
536  * }
537  * ```
538  *
539  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
540  */
541 abstract contract ERC165 is IERC165 {
542     /**
543      * @dev See {IERC165-supportsInterface}.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546         return interfaceId == type(IERC165).interfaceId;
547     }
548 }
549 
550 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
551 
552 
553 
554 pragma solidity ^0.8.0;
555 
556 
557 
558 
559 
560 
561 
562 
563 /**
564  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
565  * the Metadata extension, but not including the Enumerable extension, which is available separately as
566  * {ERC721Enumerable}.
567  */
568 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
569     using Address for address;
570     using Strings for uint256;
571 
572     // Token name
573     string private _name;
574 
575     // Token symbol
576     string private _symbol;
577 
578     // Mapping from token ID to owner address
579     mapping (uint256 => address) private _owners;
580 
581     // Mapping owner address to token count
582     mapping (address => uint256) private _balances;
583 
584     // Mapping from token ID to approved address
585     mapping (uint256 => address) private _tokenApprovals;
586 
587     // Mapping from owner to operator approvals
588     mapping (address => mapping (address => bool)) private _operatorApprovals;
589 
590     /**
591      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
592      */
593     constructor (string memory name_, string memory symbol_) {
594         _name = name_;
595         _symbol = symbol_;
596     }
597 
598     /**
599      * @dev See {IERC165-supportsInterface}.
600      */
601     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
602         return interfaceId == type(IERC721).interfaceId
603             || interfaceId == type(IERC721Metadata).interfaceId
604             || super.supportsInterface(interfaceId);
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
645         return bytes(baseURI).length > 0
646             ? string(abi.encodePacked(baseURI, tokenId.toString()))
647             : '';
648     }
649 
650     /**
651      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
652      * in child contracts.
653      */
654     function _baseURI() internal view virtual returns (string memory) {
655         return "";
656     }
657 
658     /**
659      * @dev See {IERC721-approve}.
660      */
661     function approve(address to, uint256 tokenId) public virtual override {
662         address owner = ERC721.ownerOf(tokenId);
663         require(to != owner, "ERC721: approval to current owner");
664 
665         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
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
701     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
702         //solhint-disable-next-line max-line-length
703         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
704 
705         _transfer(from, to, tokenId);
706     }
707 
708     /**
709      * @dev See {IERC721-safeTransferFrom}.
710      */
711     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
712         safeTransferFrom(from, to, tokenId, "");
713     }
714 
715     /**
716      * @dev See {IERC721-safeTransferFrom}.
717      */
718     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
719         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
720         _safeTransfer(from, to, tokenId, _data);
721     }
722 
723     /**
724      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
725      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
726      *
727      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
728      *
729      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
730      * implement alternative mechanisms to perform token transfer, such as signature-based.
731      *
732      * Requirements:
733      *
734      * - `from` cannot be the zero address.
735      * - `to` cannot be the zero address.
736      * - `tokenId` token must exist and be owned by `from`.
737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
738      *
739      * Emits a {Transfer} event.
740      */
741     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
742         _transfer(from, to, tokenId);
743         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
744     }
745 
746     /**
747      * @dev Returns whether `tokenId` exists.
748      *
749      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
750      *
751      * Tokens start existing when they are minted (`_mint`),
752      * and stop existing when they are burned (`_burn`).
753      */
754     function _exists(uint256 tokenId) internal view virtual returns (bool) {
755         return _owners[tokenId] != address(0);
756     }
757 
758     /**
759      * @dev Returns whether `spender` is allowed to manage `tokenId`.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      */
765     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
766         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
767         address owner = ERC721.ownerOf(tokenId);
768         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
769     }
770 
771     /**
772      * @dev Safely mints `tokenId` and transfers it to `to`.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must not exist.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _safeMint(address to, uint256 tokenId) internal virtual {
782         _safeMint(to, tokenId, "");
783     }
784 
785     /**
786      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
787      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
788      */
789     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
790         _mint(to, tokenId);
791         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
792     }
793 
794     /**
795      * @dev Mints `tokenId` and transfers it to `to`.
796      *
797      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
798      *
799      * Requirements:
800      *
801      * - `tokenId` must not exist.
802      * - `to` cannot be the zero address.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _mint(address to, uint256 tokenId) internal virtual {
807         require(to != address(0), "ERC721: mint to the zero address");
808         require(!_exists(tokenId), "ERC721: token already minted");
809 
810         _beforeTokenTransfer(address(0), to, tokenId);
811 
812         _balances[to] += 1;
813         _owners[tokenId] = to;
814 
815         emit Transfer(address(0), to, tokenId);
816     }
817 
818     /**
819      * @dev Destroys `tokenId`.
820      * The approval is cleared when the token is burned.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must exist.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _burn(uint256 tokenId) internal virtual {
829         address owner = ERC721.ownerOf(tokenId);
830 
831         _beforeTokenTransfer(owner, address(0), tokenId);
832 
833         // Clear approvals
834         _approve(address(0), tokenId);
835 
836         _balances[owner] -= 1;
837         delete _owners[tokenId];
838 
839         emit Transfer(owner, address(0), tokenId);
840     }
841 
842     /**
843      * @dev Transfers `tokenId` from `from` to `to`.
844      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
845      *
846      * Requirements:
847      *
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must be owned by `from`.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _transfer(address from, address to, uint256 tokenId) internal virtual {
854         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
855         require(to != address(0), "ERC721: transfer to the zero address");
856 
857         _beforeTokenTransfer(from, to, tokenId);
858 
859         // Clear approvals from the previous owner
860         _approve(address(0), tokenId);
861 
862         _balances[from] -= 1;
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(from, to, tokenId);
867     }
868 
869     /**
870      * @dev Approve `to` to operate on `tokenId`
871      *
872      * Emits a {Approval} event.
873      */
874     function _approve(address to, uint256 tokenId) internal virtual {
875         _tokenApprovals[tokenId] = to;
876         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
877     }
878 
879     /**
880      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
881      * The call is not executed if the target address is not a contract.
882      *
883      * @param from address representing the previous owner of the given token ID
884      * @param to target address that will receive the tokens
885      * @param tokenId uint256 ID of the token to be transferred
886      * @param _data bytes optional data to send along with the call
887      * @return bool whether the call correctly returned the expected magic value
888      */
889     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
890         private returns (bool)
891     {
892         if (to.isContract()) {
893             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
894                 return retval == IERC721Receiver(to).onERC721Received.selector;
895             } catch (bytes memory reason) {
896                 if (reason.length == 0) {
897                     revert("ERC721: transfer to non ERC721Receiver implementer");
898                 } else {
899                     // solhint-disable-next-line no-inline-assembly
900                     assembly {
901                         revert(add(32, reason), mload(reason))
902                     }
903                 }
904             }
905         } else {
906             return true;
907         }
908     }
909 
910     /**
911      * @dev Hook that is called before any token transfer. This includes minting
912      * and burning.
913      *
914      * Calling conditions:
915      *
916      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
917      * transferred to `to`.
918      * - When `from` is zero, `tokenId` will be minted for `to`.
919      * - When `to` is zero, ``from``'s `tokenId` will be burned.
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      *
923      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
924      */
925     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
926 }
927 
928 // File: @openzeppelin/contracts/access/Ownable.sol
929 
930 
931 
932 pragma solidity ^0.8.0;
933 
934 /**
935  * @dev Contract module which provides a basic access control mechanism, where
936  * there is an account (an owner) that can be granted exclusive access to
937  * specific functions.
938  *
939  * By default, the owner account will be the one that deploys the contract. This
940  * can later be changed with {transferOwnership}.
941  *
942  * This module is used through inheritance. It will make available the modifier
943  * `onlyOwner`, which can be applied to your functions to restrict their use to
944  * the owner.
945  */
946 abstract contract Ownable is Context {
947     address private _owner;
948 
949     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
950 
951     /**
952      * @dev Initializes the contract setting the deployer as the initial owner.
953      */
954     constructor () {
955         address msgSender = _msgSender();
956         _owner = msgSender;
957         emit OwnershipTransferred(address(0), msgSender);
958     }
959 
960     /**
961      * @dev Returns the address of the current owner.
962      */
963     function owner() public view virtual returns (address) {
964         return _owner;
965     }
966 
967     /**
968      * @dev Throws if called by any account other than the owner.
969      */
970     modifier onlyOwner() {
971         require(owner() == _msgSender(), "Ownable: caller is not the owner");
972         _;
973     }
974 
975     /**
976      * @dev Leaves the contract without owner. It will not be possible to call
977      * `onlyOwner` functions anymore. Can only be called by the current owner.
978      *
979      * NOTE: Renouncing ownership will leave the contract without an owner,
980      * thereby removing any functionality that is only available to the owner.
981      */
982     function renounceOwnership() public virtual onlyOwner {
983         emit OwnershipTransferred(_owner, address(0));
984         _owner = address(0);
985     }
986 
987     /**
988      * @dev Transfers ownership of the contract to a new account (`newOwner`).
989      * Can only be called by the current owner.
990      */
991     function transferOwnership(address newOwner) public virtual onlyOwner {
992         require(newOwner != address(0), "Ownable: new owner is the zero address");
993         emit OwnershipTransferred(_owner, newOwner);
994         _owner = newOwner;
995     }
996 }
997 
998 // File: contracts/HDPunks.sol
999 
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 
1004 
1005 
1006 interface PunksContract {
1007 
1008     function balanceOf(address) external view returns (uint256);
1009 
1010     function punkIndexToAddress(uint256) external view returns (address);
1011 
1012 }
1013 
1014 interface WrapperContract {
1015 
1016     function balanceOf(address) external view returns (uint256);
1017 
1018     function ownerOf(uint256) external view returns (address);
1019 
1020 }
1021 
1022 interface IERC20 {
1023     function balanceOf(address) external view returns (uint);
1024 
1025     function transfer(address, uint) external returns (bool);
1026 }
1027 
1028 
1029 
1030 
1031 contract HDPunks is Ownable, ERC721 {
1032 
1033     event Mint(address indexed to, uint indexed _punkId);
1034 
1035     PunksContract public PUNKS = PunksContract(0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB);
1036     WrapperContract public WRAPPER = WrapperContract(0xb7F7F6C52F2e2fdb1963Eab30438024864c313F6);
1037     uint public constant TOKEN_LIMIT = 10000;
1038 
1039     uint public numTokens = 0;
1040     uint public _mintFee = 0.08 ether;
1041     bool public _publicMinting = false;
1042     string public _baseTokenURI;
1043     string public imageHash; // MD5 hash of the megaimage (100k x 100k pixels) containing 10000 punks
1044 
1045     // Random index assignment
1046     uint internal nonce = 0;
1047     uint[TOKEN_LIMIT] internal indices;
1048 
1049     constructor() payable ERC721("HD Punks", "HDPUNKS") {}
1050 
1051     /**
1052      * @dev Mint several HD Punks in a single transaction. Used in presale minting.
1053      */
1054     function mintMany(uint[] calldata _punkIds, address to) external payable {
1055         // Take mint fee
1056         require(msg.value >= _punkIds.length * mintFee() || to == owner(), "Please include mint fee");
1057         for (uint i = 0; i < _punkIds.length; i++) {
1058             _mint(_punkIds[i], to, true);
1059         }
1060     }
1061 
1062     /**
1063      * @dev Mint one HD Punk, same functionality as mintMany. Used in presale minting.
1064      */
1065     function mint(uint _punkId, address to) external payable {
1066         // Take mint fee
1067         require(msg.value >= mintFee() || to == owner(), "Please include mint fee");
1068         _mint(_punkId, to, true);
1069     }
1070 
1071     /**
1072      * @dev Mint `quantity` HDPunks, but chosen randomly. Used in public minting.
1073      */
1074     function mintRandom(address to, uint quantity) external payable {
1075         require(_publicMinting || to == owner(), "Wait for public minting");
1076         require(msg.sender == tx.origin, "No funny business");
1077         require(msg.value >= quantity * mintFee() || to == owner(), "Please include mint fee");
1078         // TODO: Check that randomness works well
1079         for (uint i = 0; i < quantity; i++) {
1080             _mint(randomIndex(), msg.sender, false);
1081         }
1082     }
1083 
1084     /**
1085      * @dev Checks validity of the mint, but not the mint fee.
1086      */
1087     function _mint(uint _punkId, address to, bool requireIsOwner) internal {
1088         // Check if token already exists
1089         require(!_exists(_punkId), "HDPunk already minted");
1090         overwriteIndex(_punkId);
1091 
1092         if (requireIsOwner) {
1093             address punkOwner = PUNKS.punkIndexToAddress(_punkId);
1094             if (punkOwner == address(WRAPPER)) {
1095                 punkOwner = WRAPPER.ownerOf(_punkId);
1096             }
1097             require(to == punkOwner || to == owner(), "Only the owner can mint");
1098         } else {
1099             require(_publicMinting || to == owner(), "Public minting not open");
1100         }
1101 
1102         _mint(to, _punkId);
1103         numTokens += 1;
1104         emit Mint(to, _punkId);
1105     }
1106 
1107     function randomIndex() internal view returns (uint) {
1108         uint totalSize = TOKEN_LIMIT - numTokens;
1109         uint index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
1110         uint value = 0;
1111         if (indices[index] != 0) {
1112             value = indices[index]; // If index taken, see what it points to
1113         } else {
1114             value = index;
1115         }
1116 
1117         // Use zero-indexing
1118         return value;
1119     }
1120 
1121     function overwriteIndex(uint index) internal {
1122         uint totalSize = TOKEN_LIMIT - numTokens;
1123         // Move last value to selected position
1124         if (indices[totalSize - 1] == 0) {
1125             // Array position not initialized, so use position
1126             indices[index] = totalSize - 1;
1127         } else {
1128             // Array position holds a value so use that
1129             indices[index] = indices[totalSize - 1];
1130         }
1131         nonce += 1;
1132     }
1133 
1134     /**
1135      * @dev Returns the current minting fee
1136      */
1137     function mintFee() public view returns (uint) {
1138         return _mintFee;
1139     }
1140 
1141     function setMintFee(uint256 __mintFee) public onlyOwner {
1142         _mintFee = __mintFee;
1143     }
1144 
1145     /**
1146      * @dev Withdraw the contract balance to the dev address
1147      */
1148     function withdraw() public {
1149         uint amount = address(this).balance;
1150         (bool success,) = owner().call{value: amount}("");
1151         require(success, "Failed to send ether");
1152     }
1153 
1154     /**
1155      * @dev Withdraw ERC20 tokens from the contract
1156      */
1157     function withdrawFungible(address _tokenContract) public {
1158       IERC20 token = IERC20(_tokenContract);
1159       uint256 amount = token.balanceOf(address(this));
1160       token.transfer(owner(), amount);
1161     }
1162 
1163     /**
1164      * @dev Withdraw ERC721 tokens from the contract
1165      */
1166     function withdrawNonFungible(address _tokenContract, uint256 _tokenId) public {
1167         IERC721(_tokenContract).transferFrom(address(this), owner(), _tokenId);
1168     }
1169 
1170     /**
1171      * @dev Returns a URI for a given token ID's metadata
1172      */
1173     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1174         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1175     }
1176 
1177     /**
1178      * @dev Updates the base token URI for the metadata
1179      */
1180     function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
1181         _baseTokenURI = __baseTokenURI;
1182     }
1183 
1184     /**
1185      * @dev Turn public minting on or off
1186      */
1187     function setPublicMinting(bool _val) public onlyOwner {
1188         _publicMinting = _val;
1189     }
1190 
1191     /**
1192      * @dev Set image hash
1193      */
1194     function setImageHash(string memory _imageHash) public onlyOwner {
1195         imageHash = _imageHash;
1196     }
1197 
1198 }