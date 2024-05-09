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
180 
181 
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
188  * @dev See https://eips.ethereum.org/EIPS/eip-721
189  */
190 interface IERC721Metadata is IERC721 {
191 
192     /**
193      * @dev Returns the token collection name.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the token collection symbol.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
204      */
205     function tokenURI(uint256 tokenId) external view returns (string memory);
206 }
207 
208 // File: @openzeppelin/contracts/utils/Address.sol
209 
210 
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev Collection of functions related to the address type
216  */
217 library Address {
218     /**
219      * @dev Returns true if `account` is a contract.
220      *
221      * [IMPORTANT]
222      * ====
223      * It is unsafe to assume that an address for which this function returns
224      * false is an externally-owned account (EOA) and not a contract.
225      *
226      * Among others, `isContract` will return false for the following
227      * types of addresses:
228      *
229      *  - an externally-owned account
230      *  - a contract in construction
231      *  - an address where a contract will be created
232      *  - an address where a contract lived, but was destroyed
233      * ====
234      */
235     function isContract(address account) internal view returns (bool) {
236         // This method relies on extcodesize, which returns 0 for contracts in
237         // construction, since the code is only stored at the end of the
238         // constructor execution.
239 
240         uint256 size;
241         // solhint-disable-next-line no-inline-assembly
242         assembly { size := extcodesize(account) }
243         return size > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
266         (bool success, ) = recipient.call{ value: amount }("");
267         require(success, "Address: unable to send value, recipient may have reverted");
268     }
269 
270     /**
271      * @dev Performs a Solidity function call using a low level `call`. A
272      * plain`call` is an unsafe replacement for a function call: use this
273      * function instead.
274      *
275      * If `target` reverts with a revert reason, it is bubbled up by this
276      * function (like regular Solidity function calls).
277      *
278      * Returns the raw returned data. To convert to the expected return value,
279      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
280      *
281      * Requirements:
282      *
283      * - `target` must be a contract.
284      * - calling `target` with `data` must not revert.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
289       return functionCall(target, data, "Address: low-level call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
294      * `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
324         require(address(this).balance >= value, "Address: insufficient balance for call");
325         require(isContract(target), "Address: call to non-contract");
326 
327         // solhint-disable-next-line avoid-low-level-calls
328         (bool success, bytes memory returndata) = target.call{ value: value }(data);
329         return _verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return _verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
373         require(isContract(target), "Address: delegate call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return _verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/utils/Context.sol
401 
402 
403 
404 pragma solidity ^0.8.0;
405 
406 /*
407  * @dev Provides information about the current execution context, including the
408  * sender of the transaction and its data. While these are generally available
409  * via msg.sender and msg.data, they should not be accessed in such a direct
410  * manner, since when dealing with meta-transactions the account sending and
411  * paying for execution may not be the actual sender (as far as an application
412  * is concerned).
413  *
414  * This contract is only required for intermediate, library-like contracts.
415  */
416 abstract contract Context {
417     function _msgSender() internal view virtual returns (address) {
418         return msg.sender;
419     }
420 
421     function _msgData() internal view virtual returns (bytes calldata) {
422         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
423         return msg.data;
424     }
425 }
426 
427 // File: @openzeppelin/contracts/utils/Strings.sol
428 
429 
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev String operations.
435  */
436 library Strings {
437     bytes16 private constant alphabet = "0123456789abcdef";
438 
439     /**
440      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
441      */
442     function toString(uint256 value) internal pure returns (string memory) {
443         // Inspired by OraclizeAPI's implementation - MIT licence
444         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
445 
446         if (value == 0) {
447             return "0";
448         }
449         uint256 temp = value;
450         uint256 digits;
451         while (temp != 0) {
452             digits++;
453             temp /= 10;
454         }
455         bytes memory buffer = new bytes(digits);
456         while (value != 0) {
457             digits -= 1;
458             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
459             value /= 10;
460         }
461         return string(buffer);
462     }
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
466      */
467     function toHexString(uint256 value) internal pure returns (string memory) {
468         if (value == 0) {
469             return "0x00";
470         }
471         uint256 temp = value;
472         uint256 length = 0;
473         while (temp != 0) {
474             length++;
475             temp >>= 8;
476         }
477         return toHexString(value, length);
478     }
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
482      */
483     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
484         bytes memory buffer = new bytes(2 * length + 2);
485         buffer[0] = "0";
486         buffer[1] = "x";
487         for (uint256 i = 2 * length + 1; i > 1; --i) {
488             buffer[i] = alphabet[value & 0xf];
489             value >>= 4;
490         }
491         require(value == 0, "Strings: hex length insufficient");
492         return string(buffer);
493     }
494 
495 }
496 
497 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
498 
499 
500 
501 pragma solidity ^0.8.0;
502 
503 
504 /**
505  * @dev Implementation of the {IERC165} interface.
506  *
507  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
508  * for the additional interface id that will be supported. For example:
509  *
510  * ```solidity
511  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
512  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
513  * }
514  * ```
515  *
516  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
517  */
518 abstract contract ERC165 is IERC165 {
519     /**
520      * @dev See {IERC165-supportsInterface}.
521      */
522     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
523         return interfaceId == type(IERC165).interfaceId;
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 
535 
536 
537 
538 
539 
540 /**
541  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
542  * the Metadata extension, but not including the Enumerable extension, which is available separately as
543  * {ERC721Enumerable}.
544  */
545 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
546     using Address for address;
547     using Strings for uint256;
548 
549     // Token name
550     string private _name;
551 
552     // Token symbol
553     string private _symbol;
554 
555     // Mapping from token ID to owner address
556     mapping (uint256 => address) private _owners;
557 
558     // Mapping owner address to token count
559     mapping (address => uint256) private _balances;
560 
561     // Mapping from token ID to approved address
562     mapping (uint256 => address) private _tokenApprovals;
563 
564     // Mapping from owner to operator approvals
565     mapping (address => mapping (address => bool)) private _operatorApprovals;
566 
567     /**
568      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
569      */
570     constructor (string memory name_, string memory symbol_) {
571         _name = name_;
572         _symbol = symbol_;
573     }
574 
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
579         return interfaceId == type(IERC721).interfaceId
580             || interfaceId == type(IERC721Metadata).interfaceId
581             || super.supportsInterface(interfaceId);
582     }
583 
584     /**
585      * @dev See {IERC721-balanceOf}.
586      */
587     function balanceOf(address owner) public view virtual override returns (uint256) {
588         require(owner != address(0), "ERC721: balance query for the zero address");
589         return _balances[owner];
590     }
591 
592     /**
593      * @dev See {IERC721-ownerOf}.
594      */
595     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
596         address owner = _owners[tokenId];
597         require(owner != address(0), "ERC721: owner query for nonexistent token");
598         return owner;
599     }
600 
601     /**
602      * @dev See {IERC721Metadata-name}.
603      */
604     function name() public view virtual override returns (string memory) {
605         return _name;
606     }
607 
608     /**
609      * @dev See {IERC721Metadata-symbol}.
610      */
611     function symbol() public view virtual override returns (string memory) {
612         return _symbol;
613     }
614 
615     /**
616      * @dev See {IERC721Metadata-tokenURI}.
617      */
618     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
619         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
620 
621         string memory baseURI = _baseURI();
622         return bytes(baseURI).length > 0
623             ? string(abi.encodePacked(baseURI, tokenId.toString()))
624             : '';
625     }
626 
627     /**
628      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
629      * in child contracts.
630      */
631     function _baseURI() internal view virtual returns (string memory) {
632         return "";
633     }
634 
635     /**
636      * @dev See {IERC721-approve}.
637      */
638     function approve(address to, uint256 tokenId) public virtual override {
639         address owner = ERC721.ownerOf(tokenId);
640         require(to != owner, "ERC721: approval to current owner");
641 
642         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
643             "ERC721: approve caller is not owner nor approved for all"
644         );
645 
646         _approve(to, tokenId);
647     }
648 
649     /**
650      * @dev See {IERC721-getApproved}.
651      */
652     function getApproved(uint256 tokenId) public view virtual override returns (address) {
653         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
654 
655         return _tokenApprovals[tokenId];
656     }
657 
658     /**
659      * @dev See {IERC721-setApprovalForAll}.
660      */
661     function setApprovalForAll(address operator, bool approved) public virtual override {
662         require(operator != _msgSender(), "ERC721: approve to caller");
663 
664         _operatorApprovals[_msgSender()][operator] = approved;
665         emit ApprovalForAll(_msgSender(), operator, approved);
666     }
667 
668     /**
669      * @dev See {IERC721-isApprovedForAll}.
670      */
671     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
672         return _operatorApprovals[owner][operator];
673     }
674 
675     /**
676      * @dev See {IERC721-transferFrom}.
677      */
678     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
679         //solhint-disable-next-line max-line-length
680         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
681 
682         _transfer(from, to, tokenId);
683     }
684 
685     /**
686      * @dev See {IERC721-safeTransferFrom}.
687      */
688     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
689         safeTransferFrom(from, to, tokenId, "");
690     }
691 
692     /**
693      * @dev See {IERC721-safeTransferFrom}.
694      */
695     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
696         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
697         _safeTransfer(from, to, tokenId, _data);
698     }
699 
700     /**
701      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
702      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
703      *
704      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
705      *
706      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
707      * implement alternative mechanisms to perform token transfer, such as signature-based.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `tokenId` token must exist and be owned by `from`.
714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
715      *
716      * Emits a {Transfer} event.
717      */
718     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
719         _transfer(from, to, tokenId);
720         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
721     }
722 
723     /**
724      * @dev Returns whether `tokenId` exists.
725      *
726      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
727      *
728      * Tokens start existing when they are minted (`_mint`),
729      * and stop existing when they are burned (`_burn`).
730      */
731     function _exists(uint256 tokenId) internal view virtual returns (bool) {
732         return _owners[tokenId] != address(0);
733     }
734 
735     /**
736      * @dev Returns whether `spender` is allowed to manage `tokenId`.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
743         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
744         address owner = ERC721.ownerOf(tokenId);
745         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
746     }
747 
748     /**
749      * @dev Safely mints `tokenId` and transfers it to `to`.
750      *
751      * Requirements:
752      *
753      * - `tokenId` must not exist.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _safeMint(address to, uint256 tokenId) internal virtual {
759         _safeMint(to, tokenId, "");
760     }
761 
762     /**
763      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
764      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
765      */
766     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
767         _mint(to, tokenId);
768         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
769     }
770 
771     /**
772      * @dev Mints `tokenId` and transfers it to `to`.
773      *
774      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
775      *
776      * Requirements:
777      *
778      * - `tokenId` must not exist.
779      * - `to` cannot be the zero address.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _mint(address to, uint256 tokenId) internal virtual {
784         require(to != address(0), "ERC721: mint to the zero address");
785         require(!_exists(tokenId), "ERC721: token already minted");
786 
787         _beforeTokenTransfer(address(0), to, tokenId);
788 
789         _balances[to] += 1;
790         _owners[tokenId] = to;
791 
792         emit Transfer(address(0), to, tokenId);
793     }
794 
795     /**
796      * @dev Destroys `tokenId`.
797      * The approval is cleared when the token is burned.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _burn(uint256 tokenId) internal virtual {
806         address owner = ERC721.ownerOf(tokenId);
807 
808         _beforeTokenTransfer(owner, address(0), tokenId);
809 
810         // Clear approvals
811         _approve(address(0), tokenId);
812 
813         _balances[owner] -= 1;
814         delete _owners[tokenId];
815 
816         emit Transfer(owner, address(0), tokenId);
817     }
818 
819     /**
820      * @dev Transfers `tokenId` from `from` to `to`.
821      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
822      *
823      * Requirements:
824      *
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _transfer(address from, address to, uint256 tokenId) internal virtual {
831         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
832         require(to != address(0), "ERC721: transfer to the zero address");
833 
834         _beforeTokenTransfer(from, to, tokenId);
835 
836         // Clear approvals from the previous owner
837         _approve(address(0), tokenId);
838 
839         _balances[from] -= 1;
840         _balances[to] += 1;
841         _owners[tokenId] = to;
842 
843         emit Transfer(from, to, tokenId);
844     }
845 
846     /**
847      * @dev Approve `to` to operate on `tokenId`
848      *
849      * Emits a {Approval} event.
850      */
851     function _approve(address to, uint256 tokenId) internal virtual {
852         _tokenApprovals[tokenId] = to;
853         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
854     }
855 
856     /**
857      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
858      * The call is not executed if the target address is not a contract.
859      *
860      * @param from address representing the previous owner of the given token ID
861      * @param to target address that will receive the tokens
862      * @param tokenId uint256 ID of the token to be transferred
863      * @param _data bytes optional data to send along with the call
864      * @return bool whether the call correctly returned the expected magic value
865      */
866     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
867         private returns (bool)
868     {
869         if (to.isContract()) {
870             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
871                 return retval == IERC721Receiver(to).onERC721Received.selector;
872             } catch (bytes memory reason) {
873                 if (reason.length == 0) {
874                     revert("ERC721: transfer to non ERC721Receiver implementer");
875                 } else {
876                     // solhint-disable-next-line no-inline-assembly
877                     assembly {
878                         revert(add(32, reason), mload(reason))
879                     }
880                 }
881             }
882         } else {
883             return true;
884         }
885     }
886 
887     /**
888      * @dev Hook that is called before any token transfer. This includes minting
889      * and burning.
890      *
891      * Calling conditions:
892      *
893      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
894      * transferred to `to`.
895      * - When `from` is zero, `tokenId` will be minted for `to`.
896      * - When `to` is zero, ``from``'s `tokenId` will be burned.
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      *
900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
901      */
902     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
903 }
904 
905 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
906 
907 
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
914  * @dev See https://eips.ethereum.org/EIPS/eip-721
915  */
916 interface IERC721Enumerable is IERC721 {
917 
918     /**
919      * @dev Returns the total amount of tokens stored by the contract.
920      */
921     function totalSupply() external view returns (uint256);
922 
923     /**
924      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
925      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
926      */
927     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
928 
929     /**
930      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
931      * Use along with {totalSupply} to enumerate all tokens.
932      */
933     function tokenByIndex(uint256 index) external view returns (uint256);
934 }
935 
936 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
937 
938 
939 
940 pragma solidity ^0.8.0;
941 
942 
943 
944 /**
945  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
946  * enumerability of all the token ids in the contract as well as all token ids owned by each
947  * account.
948  */
949 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
950     // Mapping from owner to list of owned token IDs
951     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
952 
953     // Mapping from token ID to index of the owner tokens list
954     mapping(uint256 => uint256) private _ownedTokensIndex;
955 
956     // Array with all token ids, used for enumeration
957     uint256[] private _allTokens;
958 
959     // Mapping from token id to position in the allTokens array
960     mapping(uint256 => uint256) private _allTokensIndex;
961 
962     /**
963      * @dev See {IERC165-supportsInterface}.
964      */
965     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
966         return interfaceId == type(IERC721Enumerable).interfaceId
967             || super.supportsInterface(interfaceId);
968     }
969 
970     /**
971      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
972      */
973     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
974         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
975         return _ownedTokens[owner][index];
976     }
977 
978     /**
979      * @dev See {IERC721Enumerable-totalSupply}.
980      */
981     function totalSupply() public view virtual override returns (uint256) {
982         return _allTokens.length;
983     }
984 
985     /**
986      * @dev See {IERC721Enumerable-tokenByIndex}.
987      */
988     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
989         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
990         return _allTokens[index];
991     }
992 
993     /**
994      * @dev Hook that is called before any token transfer. This includes minting
995      * and burning.
996      *
997      * Calling conditions:
998      *
999      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1000      * transferred to `to`.
1001      * - When `from` is zero, `tokenId` will be minted for `to`.
1002      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1009         super._beforeTokenTransfer(from, to, tokenId);
1010 
1011         if (from == address(0)) {
1012             _addTokenToAllTokensEnumeration(tokenId);
1013         } else if (from != to) {
1014             _removeTokenFromOwnerEnumeration(from, tokenId);
1015         }
1016         if (to == address(0)) {
1017             _removeTokenFromAllTokensEnumeration(tokenId);
1018         } else if (to != from) {
1019             _addTokenToOwnerEnumeration(to, tokenId);
1020         }
1021     }
1022 
1023     /**
1024      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1025      * @param to address representing the new owner of the given token ID
1026      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1027      */
1028     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1029         uint256 length = ERC721.balanceOf(to);
1030         _ownedTokens[to][length] = tokenId;
1031         _ownedTokensIndex[tokenId] = length;
1032     }
1033 
1034     /**
1035      * @dev Private function to add a token to this extension's token tracking data structures.
1036      * @param tokenId uint256 ID of the token to be added to the tokens list
1037      */
1038     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1039         _allTokensIndex[tokenId] = _allTokens.length;
1040         _allTokens.push(tokenId);
1041     }
1042 
1043     /**
1044      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1045      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1046      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1047      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1048      * @param from address representing the previous owner of the given token ID
1049      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1050      */
1051     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1052         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1053         // then delete the last slot (swap and pop).
1054 
1055         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1056         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1057 
1058         // When the token to delete is the last token, the swap operation is unnecessary
1059         if (tokenIndex != lastTokenIndex) {
1060             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1061 
1062             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1063             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1064         }
1065 
1066         // This also deletes the contents at the last position of the array
1067         delete _ownedTokensIndex[tokenId];
1068         delete _ownedTokens[from][lastTokenIndex];
1069     }
1070 
1071     /**
1072      * @dev Private function to remove a token from this extension's token tracking data structures.
1073      * This has O(1) time complexity, but alters the order of the _allTokens array.
1074      * @param tokenId uint256 ID of the token to be removed from the tokens list
1075      */
1076     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1077         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1078         // then delete the last slot (swap and pop).
1079 
1080         uint256 lastTokenIndex = _allTokens.length - 1;
1081         uint256 tokenIndex = _allTokensIndex[tokenId];
1082 
1083         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1084         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1085         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1086         uint256 lastTokenId = _allTokens[lastTokenIndex];
1087 
1088         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1089         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1090 
1091         // This also deletes the contents at the last position of the array
1092         delete _allTokensIndex[tokenId];
1093         _allTokens.pop();
1094     }
1095 }
1096 
1097 // File: @openzeppelin/contracts/access/Ownable.sol
1098 
1099 
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 /**
1104  * @dev Contract module which provides a basic access control mechanism, where
1105  * there is an account (an owner) that can be granted exclusive access to
1106  * specific functions.
1107  *
1108  * By default, the owner account will be the one that deploys the contract. This
1109  * can later be changed with {transferOwnership}.
1110  *
1111  * This module is used through inheritance. It will make available the modifier
1112  * `onlyOwner`, which can be applied to your functions to restrict their use to
1113  * the owner.
1114  */
1115 abstract contract Ownable is Context {
1116     address private _owner;
1117 
1118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1119 
1120     /**
1121      * @dev Initializes the contract setting the deployer as the initial owner.
1122      */
1123     constructor () {
1124         address msgSender = _msgSender();
1125         _owner = msgSender;
1126         emit OwnershipTransferred(address(0), msgSender);
1127     }
1128 
1129     /**
1130      * @dev Returns the address of the current owner.
1131      */
1132     function owner() public view virtual returns (address) {
1133         return _owner;
1134     }
1135 
1136     /**
1137      * @dev Throws if called by any account other than the owner.
1138      */
1139     modifier onlyOwner() {
1140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1141         _;
1142     }
1143 
1144     /**
1145      * @dev Leaves the contract without owner. It will not be possible to call
1146      * `onlyOwner` functions anymore. Can only be called by the current owner.
1147      *
1148      * NOTE: Renouncing ownership will leave the contract without an owner,
1149      * thereby removing any functionality that is only available to the owner.
1150      */
1151     function renounceOwnership() public virtual onlyOwner {
1152         emit OwnershipTransferred(_owner, address(0));
1153         _owner = address(0);
1154     }
1155 
1156     /**
1157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1158      * Can only be called by the current owner.
1159      */
1160     function transferOwnership(address newOwner) public virtual onlyOwner {
1161         require(newOwner != address(0), "Ownable: new owner is the zero address");
1162         emit OwnershipTransferred(_owner, newOwner);
1163         _owner = newOwner;
1164     }
1165 }
1166 
1167 // File: contracts/CypherCityPets.sol
1168 pragma solidity ^0.8.0;
1169 
1170 contract CypherCity {
1171     function ownerOf(uint256) public returns (address) {}
1172 }
1173 
1174 contract CypherCityPets is ERC721Enumerable, Ownable {
1175     uint256 public constant MAX_NFT_SUPPLY = 8888;
1176     bool public saleStarted = true;
1177 
1178     mapping(uint256 => bool) public cyphersRedeemed;
1179 
1180     CypherCity cypherCityContract;
1181 
1182     constructor(address cypherCityAddress) ERC721("Cypher City Pets", "PETS") {
1183         cypherCityContract = CypherCity(cypherCityAddress);
1184     }
1185 
1186     function _baseURI() internal view virtual override returns (string memory) {
1187         return "https://api.cyphercity.io/pets/";
1188     }
1189 
1190     function getTokenURI(uint256 tokenId) public view returns (string memory) {
1191         return tokenURI(tokenId);
1192     }
1193 
1194    function mint(uint256[] memory cyphers) public {
1195         require(saleStarted == true, "This sale has not started.");
1196         require(totalSupply() < MAX_NFT_SUPPLY, "All NFTs have been minted.");
1197         require(cyphers.length > 0, "You must mint at least one Cypher.");
1198         require(totalSupply() + cyphers.length <= MAX_NFT_SUPPLY, "The amount of Cyphers you are trying to mint exceeds the MAX_NFT_SUPPLY.");
1199 
1200         for (uint256 i = 0; i < cyphers.length; i++) {
1201             uint256 cypher = cyphers[i];
1202             require(cypherCityContract.ownerOf(cypher) == msg.sender, "You are not the owner of this Cypher.");
1203             require(cyphersRedeemed[cypher] == false, "Cypher has already been redeemed.");
1204             uint256 mintIndex = totalSupply();
1205             _safeMint(msg.sender, mintIndex);
1206             cyphersRedeemed[cypher] = true;
1207         }
1208    }
1209 
1210     function startSale() public onlyOwner {
1211         saleStarted = true;
1212     }
1213 
1214     function pauseSale() public onlyOwner {
1215         saleStarted = false;
1216     }
1217 
1218 
1219     function withdraw() public payable onlyOwner {
1220         require(payable(msg.sender).send(address(this).balance));
1221     }
1222 }