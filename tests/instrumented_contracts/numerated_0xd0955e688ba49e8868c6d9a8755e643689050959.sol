1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.0;
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
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 pragma solidity ^0.8.0;
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
78     function safeTransferFrom(address from, address to, uint256 tokenId) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address from, address to, uint256 tokenId) external;
95 
96     /**
97      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
98      * The approval is cleared when the token is transferred.
99      *
100      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
101      *
102      * Requirements:
103      *
104      * - The caller must own the token or be an approved operator.
105      * - `tokenId` must exist.
106      *
107      * Emits an {Approval} event.
108      */
109     function approve(address to, uint256 tokenId) external;
110 
111     /**
112      * @dev Returns the account approved for `tokenId` token.
113      *
114      * Requirements:
115      *
116      * - `tokenId` must exist.
117      */
118     function getApproved(uint256 tokenId) external view returns (address operator);
119 
120     /**
121      * @dev Approve or remove `operator` as an operator for the caller.
122      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
123      *
124      * Requirements:
125      *
126      * - The `operator` cannot be the caller.
127      *
128      * Emits an {ApprovalForAll} event.
129      */
130     function setApprovalForAll(address operator, bool _approved) external;
131 
132     /**
133      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
134      *
135      * See {setApprovalForAll}
136      */
137     function isApprovedForAll(address owner, address operator) external view returns (bool);
138 
139     /**
140       * @dev Safely transfers `tokenId` token from `from` to `to`.
141       *
142       * Requirements:
143       *
144       * - `from` cannot be the zero address.
145       * - `to` cannot be the zero address.
146       * - `tokenId` token must exist and be owned by `from`.
147       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
148       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
149       *
150       * Emits a {Transfer} event.
151       */
152     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
153 }
154 
155 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
156 
157 
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @title ERC721 token receiver interface
163  * @dev Interface for any contract that wants to support safeTransfers
164  * from ERC721 asset contracts.
165  */
166 interface IERC721Receiver {
167     /**
168      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
169      * by `operator` from `from`, this function is called.
170      *
171      * It must return its Solidity selector to confirm the token transfer.
172      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
173      *
174      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
175      */
176     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
177 }
178 
179 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
180 pragma solidity ^0.8.0;
181 
182 
183 /**
184  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
185  * @dev See https://eips.ethereum.org/EIPS/eip-721
186  */
187 interface IERC721Metadata is IERC721 {
188 
189     /**
190      * @dev Returns the token collection name.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the token collection symbol.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
201      */
202     function tokenURI(uint256 tokenId) external view returns (string memory);
203 }
204 
205 // File: @openzeppelin/contracts/utils/Address.sol
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         // solhint-disable-next-line no-inline-assembly
237         assembly { size := extcodesize(account) }
238         return size > 0;
239     }
240 
241     /**
242      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
243      * `recipient`, forwarding all available gas and reverting on errors.
244      *
245      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
246      * of certain opcodes, possibly making contracts go over the 2300 gas limit
247      * imposed by `transfer`, making them unable to receive funds via
248      * `transfer`. {sendValue} removes this limitation.
249      *
250      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
251      *
252      * IMPORTANT: because control is transferred to `recipient`, care must be
253      * taken to not create reentrancy vulnerabilities. Consider using
254      * {ReentrancyGuard} or the
255      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
256      */
257     function sendValue(address payable recipient, uint256 amount) internal {
258         require(address(this).balance >= amount, "Address: insufficient balance");
259 
260         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
261         (bool success, ) = recipient.call{ value: amount }("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain`call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284       return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, 0, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but also transferring `value` wei to `target`.
300      *
301      * Requirements:
302      *
303      * - the calling contract must have an ETH balance of at least `value`.
304      * - the called Solidity function must be `payable`.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
314      * with `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
319         require(address(this).balance >= value, "Address: insufficient balance for call");
320         require(isContract(target), "Address: call to non-contract");
321 
322         // solhint-disable-next-line avoid-low-level-calls
323         (bool success, bytes memory returndata) = target.call{ value: value }(data);
324         return _verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
334         return functionStaticCall(target, data, "Address: low-level static call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
344         require(isContract(target), "Address: static call to non-contract");
345 
346         // solhint-disable-next-line avoid-low-level-calls
347         (bool success, bytes memory returndata) = target.staticcall(data);
348         return _verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.delegatecall(data);
372         return _verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/utils/Context.sol
396 
397 
398 
399 pragma solidity ^0.8.0;
400 
401 /*
402  * @dev Provides information about the current execution context, including the
403  * sender of the transaction and its data. While these are generally available
404  * via msg.sender and msg.data, they should not be accessed in such a direct
405  * manner, since when dealing with meta-transactions the account sending and
406  * paying for execution may not be the actual sender (as far as an application
407  * is concerned).
408  *
409  * This contract is only required for intermediate, library-like contracts.
410  */
411 abstract contract Context {
412     function _msgSender() internal view virtual returns (address) {
413         return msg.sender;
414     }
415 
416     function _msgData() internal view virtual returns (bytes calldata) {
417         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
418         return msg.data;
419     }
420 }
421 
422 
423 // File: @openzeppelin/contracts/utils/Strings.sol
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev String operations.
428  */
429 library Strings {
430     bytes16 private constant alphabet = "0123456789abcdef";
431 
432     /**
433      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
434      */
435     function toString(uint256 value) internal pure returns (string memory) {
436         // Inspired by OraclizeAPI's implementation - MIT licence
437         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
438 
439         if (value == 0) {
440             return "0";
441         }
442         uint256 temp = value;
443         uint256 digits;
444         while (temp != 0) {
445             digits++;
446             temp /= 10;
447         }
448         bytes memory buffer = new bytes(digits);
449         while (value != 0) {
450             digits -= 1;
451             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
452             value /= 10;
453         }
454         return string(buffer);
455     }
456 
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
459      */
460     function toHexString(uint256 value) internal pure returns (string memory) {
461         if (value == 0) {
462             return "0x00";
463         }
464         uint256 temp = value;
465         uint256 length = 0;
466         while (temp != 0) {
467             length++;
468             temp >>= 8;
469         }
470         return toHexString(value, length);
471     }
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
475      */
476     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
477         bytes memory buffer = new bytes(2 * length + 2);
478         buffer[0] = "0";
479         buffer[1] = "x";
480         for (uint256 i = 2 * length + 1; i > 1; --i) {
481             buffer[i] = alphabet[value & 0xf];
482             value >>= 4;
483         }
484         require(value == 0, "Strings: hex length insufficient");
485         return string(buffer);
486     }
487 
488 }
489 
490 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Implementation of the {IERC165} interface.
496  *
497  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
498  * for the additional interface id that will be supported. For example:
499  *
500  * ```solidity
501  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
503  * }
504  * ```
505  *
506  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
507  */
508 abstract contract ERC165 is IERC165 {
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513         return interfaceId == type(IERC165).interfaceId;
514     }
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
518 pragma solidity ^0.8.0;
519 
520 
521 /**
522  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
523  * the Metadata extension, but not including the Enumerable extension, which is available separately as
524  * {ERC721Enumerable}.
525  */
526 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
527     using Address for address;
528     using Strings for uint256;
529 
530     // Token name
531     string private _name;
532 
533     // Token symbol
534     string private _symbol;
535 
536     // Mapping from token ID to owner address
537     mapping (uint256 => address) private _owners;
538 
539     // Mapping owner address to token count
540     mapping (address => uint256) private _balances;
541 
542     // Mapping from token ID to approved address
543     mapping (uint256 => address) private _tokenApprovals;
544 
545     // Mapping from owner to operator approvals
546     mapping (address => mapping (address => bool)) private _operatorApprovals;
547 
548     /**
549      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
550      */
551     constructor (string memory name_, string memory symbol_) {
552         _name = name_;
553         _symbol = symbol_;
554     }
555 
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
560         return interfaceId == type(IERC721).interfaceId
561             || interfaceId == type(IERC721Metadata).interfaceId
562             || super.supportsInterface(interfaceId);
563     }
564 
565     /**
566      * @dev See {IERC721-balanceOf}.
567      */
568     function balanceOf(address owner) public view virtual override returns (uint256) {
569         require(owner != address(0), "ERC721: balance query for the zero address");
570         return _balances[owner];
571     }
572 
573     /**
574      * @dev See {IERC721-ownerOf}.
575      */
576     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
577         address owner = _owners[tokenId];
578         require(owner != address(0), "ERC721: owner query for nonexistent token");
579         return owner;
580     }
581 
582     /**
583      * @dev See {IERC721Metadata-name}.
584      */
585     function name() public view virtual override returns (string memory) {
586         return _name;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-symbol}.
591      */
592     function symbol() public view virtual override returns (string memory) {
593         return _symbol;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-tokenURI}.
598      */
599     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
600         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
601 
602         string memory baseURI = _baseURI();
603         return bytes(baseURI).length > 0
604             ? string(abi.encodePacked(baseURI, tokenId.toString()))
605             : '';
606     }
607 
608     /**
609      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
610      * in child contracts.
611      */
612     function _baseURI() internal view virtual returns (string memory) {
613         return "";
614     }
615 
616     /**
617      * @dev See {IERC721-approve}.
618      */
619     function approve(address to, uint256 tokenId) public virtual override {
620         address owner = ERC721.ownerOf(tokenId);
621         require(to != owner, "ERC721: approval to current owner");
622 
623         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
624             "ERC721: approve caller is not owner nor approved for all"
625         );
626 
627         _approve(to, tokenId);
628     }
629 
630     /**
631      * @dev See {IERC721-getApproved}.
632      */
633     function getApproved(uint256 tokenId) public view virtual override returns (address) {
634         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
635 
636         return _tokenApprovals[tokenId];
637     }
638 
639     /**
640      * @dev See {IERC721-setApprovalForAll}.
641      */
642     function setApprovalForAll(address operator, bool approved) public virtual override {
643         require(operator != _msgSender(), "ERC721: approve to caller");
644 
645         _operatorApprovals[_msgSender()][operator] = approved;
646         emit ApprovalForAll(_msgSender(), operator, approved);
647     }
648 
649     /**
650      * @dev See {IERC721-isApprovedForAll}.
651      */
652     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
653         return _operatorApprovals[owner][operator];
654     }
655 
656     /**
657      * @dev See {IERC721-transferFrom}.
658      */
659     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
660         //solhint-disable-next-line max-line-length
661         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
662 
663         _transfer(from, to, tokenId);
664     }
665 
666     /**
667      * @dev See {IERC721-safeTransferFrom}.
668      */
669     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
670         safeTransferFrom(from, to, tokenId, "");
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
677         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
678         _safeTransfer(from, to, tokenId, _data);
679     }
680 
681     /**
682      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
683      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
684      *
685      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
686      *
687      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
688      * implement alternative mechanisms to perform token transfer, such as signature-based.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must exist and be owned by `from`.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
700         _transfer(from, to, tokenId);
701         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
702     }
703 
704     /**
705      * @dev Returns whether `tokenId` exists.
706      *
707      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
708      *
709      * Tokens start existing when they are minted (`_mint`),
710      * and stop existing when they are burned (`_burn`).
711      */
712     function _exists(uint256 tokenId) internal view virtual returns (bool) {
713         return _owners[tokenId] != address(0);
714     }
715 
716     /**
717      * @dev Returns whether `spender` is allowed to manage `tokenId`.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must exist.
722      */
723     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
724         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
725         address owner = ERC721.ownerOf(tokenId);
726         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
727     }
728 
729     /**
730      * @dev Safely mints `tokenId` and transfers it to `to`.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must not exist.
735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
736      *
737      * Emits a {Transfer} event.
738      */
739     function _safeMint(address to, uint256 tokenId) internal virtual {
740         _safeMint(to, tokenId, "");
741     }
742 
743     /**
744      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
745      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
746      */
747     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
748         _mint(to, tokenId);
749         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
750     }
751 
752     /**
753      * @dev Mints `tokenId` and transfers it to `to`.
754      *
755      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
756      *
757      * Requirements:
758      *
759      * - `tokenId` must not exist.
760      * - `to` cannot be the zero address.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _mint(address to, uint256 tokenId) internal virtual {
765         require(to != address(0), "ERC721: mint to the zero address");
766         require(!_exists(tokenId), "ERC721: token already minted");
767 
768         _beforeTokenTransfer(address(0), to, tokenId);
769 
770         _balances[to] += 1;
771         _owners[tokenId] = to;
772 
773         emit Transfer(address(0), to, tokenId);
774     }
775 
776     /**
777      * @dev Destroys `tokenId`.
778      * The approval is cleared when the token is burned.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _burn(uint256 tokenId) internal virtual {
787         address owner = ERC721.ownerOf(tokenId);
788 
789         _beforeTokenTransfer(owner, address(0), tokenId);
790 
791         // Clear approvals
792         _approve(address(0), tokenId);
793 
794         _balances[owner] -= 1;
795         delete _owners[tokenId];
796 
797         emit Transfer(owner, address(0), tokenId);
798     }
799 
800     /**
801      * @dev Transfers `tokenId` from `from` to `to`.
802      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
803      *
804      * Requirements:
805      *
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must be owned by `from`.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _transfer(address from, address to, uint256 tokenId) internal virtual {
812         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
813         require(to != address(0), "ERC721: transfer to the zero address");
814 
815         _beforeTokenTransfer(from, to, tokenId);
816 
817         // Clear approvals from the previous owner
818         _approve(address(0), tokenId);
819 
820         _balances[from] -= 1;
821         _balances[to] += 1;
822         _owners[tokenId] = to;
823 
824         emit Transfer(from, to, tokenId);
825     }
826 
827     /**
828      * @dev Approve `to` to operate on `tokenId`
829      *
830      * Emits a {Approval} event.
831      */
832     function _approve(address to, uint256 tokenId) internal virtual {
833         _tokenApprovals[tokenId] = to;
834         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
835     }
836 
837     /**
838      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
839      * The call is not executed if the target address is not a contract.
840      *
841      * @param from address representing the previous owner of the given token ID
842      * @param to target address that will receive the tokens
843      * @param tokenId uint256 ID of the token to be transferred
844      * @param _data bytes optional data to send along with the call
845      * @return bool whether the call correctly returned the expected magic value
846      */
847     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
848         private returns (bool)
849     {
850         if (to.isContract()) {
851             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
852                 return retval == IERC721Receiver(to).onERC721Received.selector;
853             } catch (bytes memory reason) {
854                 if (reason.length == 0) {
855                     revert("ERC721: transfer to non ERC721Receiver implementer");
856                 } else {
857                     // solhint-disable-next-line no-inline-assembly
858                     assembly {
859                         revert(add(32, reason), mload(reason))
860                     }
861                 }
862             }
863         } else {
864             return true;
865         }
866     }
867 
868     /**
869      * @dev Hook that is called before any token transfer. This includes minting
870      * and burning.
871      *
872      * Calling conditions:
873      *
874      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
875      * transferred to `to`.
876      * - When `from` is zero, `tokenId` will be minted for `to`.
877      * - When `to` is zero, ``from``'s `tokenId` will be burned.
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      *
881      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
882      */
883     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
884 }
885 
886 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
887 pragma solidity ^0.8.0;
888 
889 
890 /**
891  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
892  * @dev See https://eips.ethereum.org/EIPS/eip-721
893  */
894 interface IERC721Enumerable is IERC721 {
895 
896     /**
897      * @dev Returns the total amount of tokens stored by the contract.
898      */
899     function totalSupply() external view returns (uint256);
900 
901     /**
902      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
903      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
904      */
905     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
906 
907     /**
908      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
909      * Use along with {totalSupply} to enumerate all tokens.
910      */
911     function tokenByIndex(uint256 index) external view returns (uint256);
912 }
913 
914 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
915 pragma solidity ^0.8.0;
916 /**
917  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
918  * enumerability of all the token ids in the contract as well as all token ids owned by each
919  * account.
920  */
921 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
922     // Mapping from owner to list of owned token IDs
923     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
924 
925     // Mapping from token ID to index of the owner tokens list
926     mapping(uint256 => uint256) private _ownedTokensIndex;
927 
928     // Array with all token ids, used for enumeration
929     uint256[] private _allTokens;
930 
931     // Mapping from token id to position in the allTokens array
932     mapping(uint256 => uint256) private _allTokensIndex;
933 
934     /**
935      * @dev See {IERC165-supportsInterface}.
936      */
937     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
938         return interfaceId == type(IERC721Enumerable).interfaceId
939             || super.supportsInterface(interfaceId);
940     }
941 
942     /**
943      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
944      */
945     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
946         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
947         return _ownedTokens[owner][index];
948     }
949 
950     /**
951      * @dev See {IERC721Enumerable-totalSupply}.
952      */
953     function totalSupply() public view virtual override returns (uint256) {
954         return _allTokens.length;
955     }
956 
957     /**
958      * @dev See {IERC721Enumerable-tokenByIndex}.
959      */
960     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
961         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
962         return _allTokens[index];
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
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      *
978      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
979      */
980     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
981         super._beforeTokenTransfer(from, to, tokenId);
982 
983         if (from == address(0)) {
984             _addTokenToAllTokensEnumeration(tokenId);
985         } else if (from != to) {
986             _removeTokenFromOwnerEnumeration(from, tokenId);
987         }
988         if (to == address(0)) {
989             _removeTokenFromAllTokensEnumeration(tokenId);
990         } else if (to != from) {
991             _addTokenToOwnerEnumeration(to, tokenId);
992         }
993     }
994 
995     /**
996      * @dev Private function to add a token to this extension's ownership-tracking data structures.
997      * @param to address representing the new owner of the given token ID
998      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
999      */
1000     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1001         uint256 length = ERC721.balanceOf(to);
1002         _ownedTokens[to][length] = tokenId;
1003         _ownedTokensIndex[tokenId] = length;
1004     }
1005 
1006     /**
1007      * @dev Private function to add a token to this extension's token tracking data structures.
1008      * @param tokenId uint256 ID of the token to be added to the tokens list
1009      */
1010     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1011         _allTokensIndex[tokenId] = _allTokens.length;
1012         _allTokens.push(tokenId);
1013     }
1014 
1015     /**
1016      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1017      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1018      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1019      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1020      * @param from address representing the previous owner of the given token ID
1021      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1022      */
1023     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1024         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1025         // then delete the last slot (swap and pop).
1026 
1027         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1028         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1029 
1030         // When the token to delete is the last token, the swap operation is unnecessary
1031         if (tokenIndex != lastTokenIndex) {
1032             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1033 
1034             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1035             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1036         }
1037 
1038         // This also deletes the contents at the last position of the array
1039         delete _ownedTokensIndex[tokenId];
1040         delete _ownedTokens[from][lastTokenIndex];
1041     }
1042 
1043     /**
1044      * @dev Private function to remove a token from this extension's token tracking data structures.
1045      * This has O(1) time complexity, but alters the order of the _allTokens array.
1046      * @param tokenId uint256 ID of the token to be removed from the tokens list
1047      */
1048     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1049         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1050         // then delete the last slot (swap and pop).
1051 
1052         uint256 lastTokenIndex = _allTokens.length - 1;
1053         uint256 tokenIndex = _allTokensIndex[tokenId];
1054 
1055         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1056         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1057         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1058         uint256 lastTokenId = _allTokens[lastTokenIndex];
1059 
1060         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1061         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1062 
1063         // This also deletes the contents at the last position of the array
1064         delete _allTokensIndex[tokenId];
1065         _allTokens.pop();
1066     }
1067 }
1068 
1069 // File: @openzeppelin/contracts/access/Ownable.sol
1070 
1071 
1072 
1073 pragma solidity ^0.8.0;
1074 
1075 /**
1076  * @dev Contract module which provides a basic access control mechanism, where
1077  * there is an account (an owner) that can be granted exclusive access to
1078  * specific functions.
1079  *
1080  * By default, the owner account will be the one that deploys the contract. This
1081  * can later be changed with {transferOwnership}.
1082  *
1083  * This module is used through inheritance. It will make available the modifier
1084  * `onlyOwner`, which can be applied to your functions to restrict their use to
1085  * the owner.
1086  */
1087 abstract contract Ownable is Context {
1088     address private _owner;
1089 
1090     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1091 
1092     /**
1093      * @dev Initializes the contract setting the deployer as the initial owner.
1094      */
1095     constructor () {
1096         address msgSender = _msgSender();
1097         _owner = msgSender;
1098         emit OwnershipTransferred(address(0), msgSender);
1099     }
1100 
1101     /**
1102      * @dev Returns the address of the current owner.
1103      */
1104     function owner() public view virtual returns (address) {
1105         return _owner;
1106     }
1107 
1108     /**
1109      * @dev Throws if called by any account other than the owner.
1110      */
1111     modifier onlyOwner() {
1112         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1113         _;
1114     }
1115 
1116     /**
1117      * @dev Leaves the contract without owner. It will not be possible to call
1118      * `onlyOwner` functions anymore. Can only be called by the current owner.
1119      *
1120      * NOTE: Renouncing ownership will leave the contract without an owner,
1121      * thereby removing any functionality that is only available to the owner.
1122      */
1123     function renounceOwnership() public virtual onlyOwner {
1124         emit OwnershipTransferred(_owner, address(0));
1125         _owner = address(0);
1126     }
1127 
1128     /**
1129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1130      * Can only be called by the current owner.
1131      */
1132     function transferOwnership(address newOwner) public virtual onlyOwner {
1133         require(newOwner != address(0), "Ownable: new owner is the zero address");
1134         emit OwnershipTransferred(_owner, newOwner);
1135         _owner = newOwner;
1136     }
1137 }
1138 
1139 
1140 pragma solidity ^0.8.0;
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
1304     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1305         unchecked {
1306             require(b <= a, errorMessage);
1307             return a - b;
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1313      * division by zero. The result is rounded towards zero.
1314      *
1315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1316      * opcode (which leaves remaining gas untouched) while Solidity uses an
1317      * invalid opcode to revert (consuming all remaining gas).
1318      *
1319      * Counterpart to Solidity's `/` operator. Note: this function uses a
1320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1321      * uses an invalid opcode to revert (consuming all remaining gas).
1322      *
1323      * Requirements:
1324      *
1325      * - The divisor cannot be zero.
1326      */
1327     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1328         unchecked {
1329             require(b > 0, errorMessage);
1330             return a / b;
1331         }
1332     }
1333 
1334     /**
1335      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1336      * reverting with custom message when dividing by zero.
1337      *
1338      * CAUTION: This function is deprecated because it requires allocating memory for the error
1339      * message unnecessarily. For custom revert reasons use {tryMod}.
1340      *
1341      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1342      * opcode (which leaves remaining gas untouched) while Solidity uses an
1343      * invalid opcode to revert (consuming all remaining gas).
1344      *
1345      * Requirements:
1346      *
1347      * - The divisor cannot be zero.
1348      */
1349     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1350         unchecked {
1351             require(b > 0, errorMessage);
1352             return a % b;
1353         }
1354     }
1355 }
1356 
1357 
1358 // File: ComplexityAlpha.sol
1359 pragma solidity ^0.8.0;
1360 
1361 contract ComplexityAlpha is ERC721Enumerable, Ownable {
1362     using SafeMath for uint256;
1363     using Strings for uint256;
1364 
1365     // Sale
1366     uint256 public MAIN_NFT_SUPPLY = 511;
1367     uint256 public TOTAL_NFT_SUPPLY = 512;
1368     uint public constant MAX_PURCHASABLE = 20;
1369     uint256 public MINT_PRICE = 42069000000000000; // 0.042069 ETH
1370     bool public ANON = false;
1371 
1372     // Base URI
1373     string private _baseURIextended;
1374 
1375     constructor() ERC721("ComplexityAlpha", "ALPHA") {
1376     }
1377 
1378     function _baseURI() internal view virtual override returns (string memory) {
1379         return _baseURIextended;
1380     }
1381 
1382     function setBaseURI(string memory baseURI_) external onlyOwner() {
1383         _baseURIextended = baseURI_;
1384     }
1385 
1386     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1387         string memory baseURI = _baseURI();
1388         return string(abi.encodePacked(baseURI, tokenId.toString()));
1389     }
1390 
1391     function ratwell() public payable {
1392         require(totalSupply() < TOTAL_NFT_SUPPLY, "All NFTs have been minted.");
1393         require(MINT_PRICE == msg.value, "Incorrect Ether value.");
1394         require(ANON == false);
1395         ANON = true;
1396         _safeMint(msg.sender, 511);
1397     }
1398 
1399    function mint(uint256 amountToMint) public payable {
1400         uint256 sup;
1401         if (ANON == false) {
1402             sup = MAIN_NFT_SUPPLY;
1403         } else {
1404             sup = TOTAL_NFT_SUPPLY;
1405         }
1406         require(totalSupply() <= sup, "All NFTs have been minted.");
1407         require(amountToMint > 0, "Must mint at least one.");
1408         require(amountToMint <= MAX_PURCHASABLE, "Maximum amount to mint is 20.");
1409         require(totalSupply() + amountToMint <= sup, "The amount of NFTs you are trying to mint exceeds the max supply.");
1410         require(MINT_PRICE.mul(amountToMint) == msg.value, "Incorrect Ether value.");
1411 
1412         for (uint256 i = 0; i < amountToMint; i++) {
1413             uint256 mintIndex;
1414             if (ANON == false) {
1415                 mintIndex = totalSupply();
1416             } else {
1417                 mintIndex = totalSupply() - 1; 
1418             }
1419             _safeMint(msg.sender, mintIndex);
1420         }
1421    }
1422 
1423     function withdraw() public payable onlyOwner {
1424         require(payable(msg.sender).send(address(this).balance));
1425     }
1426 }