1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity ^0.8.0;
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
26 pragma solidity ^0.8.0;
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(address from, address to, uint256 tokenId) external;
75 
76     /**
77      * @dev Transfers `tokenId` token from `from` to `to`.
78      *
79      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must be owned by `from`.
86      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address from, address to, uint256 tokenId) external;
91 
92     /**
93      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
94      * The approval is cleared when the token is transferred.
95      *
96      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
97      *
98      * Requirements:
99      *
100      * - The caller must own the token or be an approved operator.
101      * - `tokenId` must exist.
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address to, uint256 tokenId) external;
106 
107     /**
108      * @dev Returns the account approved for `tokenId` token.
109      *
110      * Requirements:
111      *
112      * - `tokenId` must exist.
113      */
114     function getApproved(uint256 tokenId) external view returns (address operator);
115 
116     /**
117      * @dev Approve or remove `operator` as an operator for the caller.
118      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
119      *
120      * Requirements:
121      *
122      * - The `operator` cannot be the caller.
123      *
124      * Emits an {ApprovalForAll} event.
125      */
126     function setApprovalForAll(address operator, bool _approved) external;
127 
128     /**
129      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
130      *
131      * See {setApprovalForAll}
132      */
133     function isApprovedForAll(address owner, address operator) external view returns (bool);
134 
135     /**
136       * @dev Safely transfers `tokenId` token from `from` to `to`.
137       *
138       * Requirements:
139       *
140       * - `from` cannot be the zero address.
141       * - `to` cannot be the zero address.
142       * - `tokenId` token must exist and be owned by `from`.
143       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
144       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
145       *
146       * Emits a {Transfer} event.
147       */
148     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
149 }
150 
151 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
152 
153 
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @title ERC721 token receiver interface
159  * @dev Interface for any contract that wants to support safeTransfers
160  * from ERC721 asset contracts.
161  */
162 interface IERC721Receiver {
163     /**
164      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
165      * by `operator` from `from`, this function is called.
166      *
167      * It must return its Solidity selector to confirm the token transfer.
168      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
169      *
170      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
171      */
172     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
176 
177 
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187 
188     /**
189      * @dev Returns the token collection name.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the token collection symbol.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
200      */
201     function tokenURI(uint256 tokenId) external view returns (string memory);
202 }
203 
204 // File: @openzeppelin/contracts/utils/Address.sol
205 
206 
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev Collection of functions related to the address type
212  */
213 library Address {
214     /**
215      * @dev Returns true if `account` is a contract.
216      *
217      * [IMPORTANT]
218      * ====
219      * It is unsafe to assume that an address for which this function returns
220      * false is an externally-owned account (EOA) and not a contract.
221      *
222      * Among others, `isContract` will return false for the following
223      * types of addresses:
224      *
225      *  - an externally-owned account
226      *  - a contract in construction
227      *  - an address where a contract will be created
228      *  - an address where a contract lived, but was destroyed
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // This method relies on extcodesize, which returns 0 for contracts in
233         // construction, since the code is only stored at the end of the
234         // constructor execution.
235 
236         uint256 size;
237         // solhint-disable-next-line no-inline-assembly
238         assembly { size := extcodesize(account) }
239         return size > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
262         (bool success, ) = recipient.call{ value: amount }("");
263         require(success, "Address: unable to send value, recipient may have reverted");
264     }
265 
266     /**
267      * @dev Performs a Solidity function call using a low level `call`. A
268      * plain`call` is an unsafe replacement for a function call: use this
269      * function instead.
270      *
271      * If `target` reverts with a revert reason, it is bubbled up by this
272      * function (like regular Solidity function calls).
273      *
274      * Returns the raw returned data. To convert to the expected return value,
275      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
276      *
277      * Requirements:
278      *
279      * - `target` must be a contract.
280      * - calling `target` with `data` must not revert.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
285       return functionCall(target, data, "Address: low-level call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
290      * `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, 0, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but also transferring `value` wei to `target`.
301      *
302      * Requirements:
303      *
304      * - the calling contract must have an ETH balance of at least `value`.
305      * - the called Solidity function must be `payable`.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
315      * with `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
320         require(address(this).balance >= value, "Address: insufficient balance for call");
321         require(isContract(target), "Address: call to non-contract");
322 
323         // solhint-disable-next-line avoid-low-level-calls
324         (bool success, bytes memory returndata) = target.call{ value: value }(data);
325         return _verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
335         return functionStaticCall(target, data, "Address: low-level static call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
345         require(isContract(target), "Address: static call to non-contract");
346 
347         // solhint-disable-next-line avoid-low-level-calls
348         (bool success, bytes memory returndata) = target.staticcall(data);
349         return _verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
369         require(isContract(target), "Address: delegate call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.delegatecall(data);
373         return _verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 // solhint-disable-next-line no-inline-assembly
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/utils/Context.sol
397 
398 
399 
400 pragma solidity ^0.8.0;
401 
402 /*
403  * @dev Provides information about the current execution context, including the
404  * sender of the transaction and its data. While these are generally available
405  * via msg.sender and msg.data, they should not be accessed in such a direct
406  * manner, since when dealing with meta-transactions the account sending and
407  * paying for execution may not be the actual sender (as far as an application
408  * is concerned).
409  *
410  * This contract is only required for intermediate, library-like contracts.
411  */
412 abstract contract Context {
413     function _msgSender() internal view virtual returns (address) {
414         return msg.sender;
415     }
416 
417     function _msgData() internal view virtual returns (bytes calldata) {
418         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
419         return msg.data;
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/Strings.sol
424 
425 
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev String operations.
431  */
432 library Strings {
433     bytes16 private constant alphabet = "0123456789abcdef";
434 
435     /**
436      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
437      */
438     function toString(uint256 value) internal pure returns (string memory) {
439         // Inspired by OraclizeAPI's implementation - MIT licence
440         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
441 
442         if (value == 0) {
443             return "0";
444         }
445         uint256 temp = value;
446         uint256 digits;
447         while (temp != 0) {
448             digits++;
449             temp /= 10;
450         }
451         bytes memory buffer = new bytes(digits);
452         while (value != 0) {
453             digits -= 1;
454             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
455             value /= 10;
456         }
457         return string(buffer);
458     }
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
462      */
463     function toHexString(uint256 value) internal pure returns (string memory) {
464         if (value == 0) {
465             return "0x00";
466         }
467         uint256 temp = value;
468         uint256 length = 0;
469         while (temp != 0) {
470             length++;
471             temp >>= 8;
472         }
473         return toHexString(value, length);
474     }
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
478      */
479     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
480         bytes memory buffer = new bytes(2 * length + 2);
481         buffer[0] = "0";
482         buffer[1] = "x";
483         for (uint256 i = 2 * length + 1; i > 1; --i) {
484             buffer[i] = alphabet[value & 0xf];
485             value >>= 4;
486         }
487         require(value == 0, "Strings: hex length insufficient");
488         return string(buffer);
489     }
490 
491 }
492 
493 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
494 
495 
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @dev Implementation of the {IERC165} interface.
502  *
503  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
504  * for the additional interface id that will be supported. For example:
505  *
506  * ```solidity
507  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
508  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
509  * }
510  * ```
511  *
512  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
513  */
514 abstract contract ERC165 is IERC165 {
515     /**
516      * @dev See {IERC165-supportsInterface}.
517      */
518     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519         return interfaceId == type(IERC165).interfaceId;
520     }
521 }
522 
523 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
524 
525 
526 
527 pragma solidity ^0.8.0;
528 
529 
530 
531 
532 
533 
534 
535 
536 /**
537  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
538  * the Metadata extension, but not including the Enumerable extension, which is available separately as
539  * {ERC721Enumerable}.
540  */
541 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
542     using Address for address;
543     using Strings for uint256;
544 
545     // Token name
546     string private _name;
547 
548     // Token symbol
549     string private _symbol;
550 
551     // Mapping from token ID to owner address
552     mapping (uint256 => address) private _owners;
553 
554     // Mapping owner address to token count
555     mapping (address => uint256) private _balances;
556 
557     // Mapping from token ID to approved address
558     mapping (uint256 => address) private _tokenApprovals;
559 
560     // Mapping from owner to operator approvals
561     mapping (address => mapping (address => bool)) private _operatorApprovals;
562 
563     /**
564      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
565      */
566     constructor (string memory name_, string memory symbol_) {
567         _name = name_;
568         _symbol = symbol_;
569     }
570 
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
575         return interfaceId == type(IERC721).interfaceId
576             || interfaceId == type(IERC721Metadata).interfaceId
577             || super.supportsInterface(interfaceId);
578     }
579 
580     /**
581      * @dev See {IERC721-balanceOf}.
582      */
583     function balanceOf(address owner) public view virtual override returns (uint256) {
584         require(owner != address(0), "ERC721: balance query for the zero address");
585         return _balances[owner];
586     }
587 
588     /**
589      * @dev See {IERC721-ownerOf}.
590      */
591     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
592         address owner = _owners[tokenId];
593         require(owner != address(0), "ERC721: owner query for nonexistent token");
594         return owner;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-name}.
599      */
600     function name() public view virtual override returns (string memory) {
601         return _name;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-symbol}.
606      */
607     function symbol() public view virtual override returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-tokenURI}.
613      */
614     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
615         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
616 
617         string memory baseURI = _baseURI();
618         return bytes(baseURI).length > 0
619             ? string(abi.encodePacked(baseURI, tokenId.toString()))
620             : '';
621     }
622 
623     /**
624      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
625      * in child contracts.
626      */
627     function _baseURI() internal view virtual returns (string memory) {
628         return "";
629     }
630 
631     /**
632      * @dev See {IERC721-approve}.
633      */
634     function approve(address to, uint256 tokenId) public virtual override {
635         address owner = ERC721.ownerOf(tokenId);
636         require(to != owner, "ERC721: approval to current owner");
637 
638         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
639             "ERC721: approve caller is not owner nor approved for all"
640         );
641 
642         _approve(to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-getApproved}.
647      */
648     function getApproved(uint256 tokenId) public view virtual override returns (address) {
649         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
650 
651         return _tokenApprovals[tokenId];
652     }
653 
654     /**
655      * @dev See {IERC721-setApprovalForAll}.
656      */
657     function setApprovalForAll(address operator, bool approved) public virtual override {
658         require(operator != _msgSender(), "ERC721: approve to caller");
659 
660         _operatorApprovals[_msgSender()][operator] = approved;
661         emit ApprovalForAll(_msgSender(), operator, approved);
662     }
663 
664     /**
665      * @dev See {IERC721-isApprovedForAll}.
666      */
667     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
668         return _operatorApprovals[owner][operator];
669     }
670 
671     /**
672      * @dev See {IERC721-transferFrom}.
673      */
674     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
675         //solhint-disable-next-line max-line-length
676         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
677 
678         _transfer(from, to, tokenId);
679     }
680 
681     /**
682      * @dev See {IERC721-safeTransferFrom}.
683      */
684     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
685         safeTransferFrom(from, to, tokenId, "");
686     }
687 
688     /**
689      * @dev See {IERC721-safeTransferFrom}.
690      */
691     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
693         _safeTransfer(from, to, tokenId, _data);
694     }
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
698      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
699      *
700      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
701      *
702      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
703      * implement alternative mechanisms to perform token transfer, such as signature-based.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
711      *
712      * Emits a {Transfer} event.
713      */
714     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
715         _transfer(from, to, tokenId);
716         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
717     }
718 
719     /**
720      * @dev Returns whether `tokenId` exists.
721      *
722      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
723      *
724      * Tokens start existing when they are minted (`_mint`),
725      * and stop existing when they are burned (`_burn`).
726      */
727     function _exists(uint256 tokenId) internal view virtual returns (bool) {
728         return _owners[tokenId] != address(0);
729     }
730 
731     /**
732      * @dev Returns whether `spender` is allowed to manage `tokenId`.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
739         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
740         address owner = ERC721.ownerOf(tokenId);
741         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
742     }
743 
744     /**
745      * @dev Safely mints `tokenId` and transfers it to `to`.
746      *
747      * Requirements:
748      *
749      * - `tokenId` must not exist.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function _safeMint(address to, uint256 tokenId) internal virtual {
755         _safeMint(to, tokenId, "");
756     }
757 
758     /**
759      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
760      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
761      */
762     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
763         _mint(to, tokenId);
764         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
765     }
766 
767     /**
768      * @dev Mints `tokenId` and transfers it to `to`.
769      *
770      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
771      *
772      * Requirements:
773      *
774      * - `tokenId` must not exist.
775      * - `to` cannot be the zero address.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _mint(address to, uint256 tokenId) internal virtual {
780         require(to != address(0), "ERC721: mint to the zero address");
781         require(!_exists(tokenId), "ERC721: token already minted");
782 
783         _beforeTokenTransfer(address(0), to, tokenId);
784 
785         _balances[to] += 1;
786         _owners[tokenId] = to;
787 
788         emit Transfer(address(0), to, tokenId);
789     }
790 
791     /**
792      * @dev Destroys `tokenId`.
793      * The approval is cleared when the token is burned.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _burn(uint256 tokenId) internal virtual {
802         address owner = ERC721.ownerOf(tokenId);
803 
804         _beforeTokenTransfer(owner, address(0), tokenId);
805 
806         // Clear approvals
807         _approve(address(0), tokenId);
808 
809         _balances[owner] -= 1;
810         delete _owners[tokenId];
811 
812         emit Transfer(owner, address(0), tokenId);
813     }
814 
815     /**
816      * @dev Transfers `tokenId` from `from` to `to`.
817      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
818      *
819      * Requirements:
820      *
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must be owned by `from`.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _transfer(address from, address to, uint256 tokenId) internal virtual {
827         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
828         require(to != address(0), "ERC721: transfer to the zero address");
829 
830         _beforeTokenTransfer(from, to, tokenId);
831 
832         // Clear approvals from the previous owner
833         _approve(address(0), tokenId);
834 
835         _balances[from] -= 1;
836         _balances[to] += 1;
837         _owners[tokenId] = to;
838 
839         emit Transfer(from, to, tokenId);
840     }
841 
842     /**
843      * @dev Approve `to` to operate on `tokenId`
844      *
845      * Emits a {Approval} event.
846      */
847     function _approve(address to, uint256 tokenId) internal virtual {
848         _tokenApprovals[tokenId] = to;
849         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
850     }
851 
852     /**
853      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
854      * The call is not executed if the target address is not a contract.
855      *
856      * @param from address representing the previous owner of the given token ID
857      * @param to target address that will receive the tokens
858      * @param tokenId uint256 ID of the token to be transferred
859      * @param _data bytes optional data to send along with the call
860      * @return bool whether the call correctly returned the expected magic value
861      */
862     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
863         private returns (bool)
864     {
865         if (to.isContract()) {
866             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
867                 return retval == IERC721Receiver(to).onERC721Received.selector;
868             } catch (bytes memory reason) {
869                 if (reason.length == 0) {
870                     revert("ERC721: transfer to non ERC721Receiver implementer");
871                 } else {
872                     // solhint-disable-next-line no-inline-assembly
873                     assembly {
874                         revert(add(32, reason), mload(reason))
875                     }
876                 }
877             }
878         } else {
879             return true;
880         }
881     }
882 
883     /**
884      * @dev Hook that is called before any token transfer. This includes minting
885      * and burning.
886      *
887      * Calling conditions:
888      *
889      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
890      * transferred to `to`.
891      * - When `from` is zero, `tokenId` will be minted for `to`.
892      * - When `to` is zero, ``from``'s `tokenId` will be burned.
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      *
896      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
897      */
898     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
899 }
900 
901 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
902 
903 
904 
905 pragma solidity ^0.8.0;
906 
907 
908 /**
909  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
910  * @dev See https://eips.ethereum.org/EIPS/eip-721
911  */
912 interface IERC721Enumerable is IERC721 {
913 
914     /**
915      * @dev Returns the total amount of tokens stored by the contract.
916      */
917     function totalSupply() external view returns (uint256);
918 
919     /**
920      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
921      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
922      */
923     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
924 
925     /**
926      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
927      * Use along with {totalSupply} to enumerate all tokens.
928      */
929     function tokenByIndex(uint256 index) external view returns (uint256);
930 }
931 
932 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
933 
934 
935 
936 pragma solidity ^0.8.0;
937 
938 
939 
940 /**
941  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
942  * enumerability of all the token ids in the contract as well as all token ids owned by each
943  * account.
944  */
945 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
946     // Mapping from owner to list of owned token IDs
947     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
948 
949     // Mapping from token ID to index of the owner tokens list
950     mapping(uint256 => uint256) private _ownedTokensIndex;
951 
952     // Array with all token ids, used for enumeration
953     uint256[] private _allTokens;
954 
955     // Mapping from token id to position in the allTokens array
956     mapping(uint256 => uint256) private _allTokensIndex;
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
962         return interfaceId == type(IERC721Enumerable).interfaceId
963             || super.supportsInterface(interfaceId);
964     }
965 
966     /**
967      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
968      */
969     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
970         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
971         return _ownedTokens[owner][index];
972     }
973 
974     /**
975      * @dev See {IERC721Enumerable-totalSupply}.
976      */
977     function totalSupply() public view virtual override returns (uint256) {
978         return _allTokens.length;
979     }
980 
981     /**
982      * @dev See {IERC721Enumerable-tokenByIndex}.
983      */
984     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
985         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
986         return _allTokens[index];
987     }
988 
989     /**
990      * @dev Hook that is called before any token transfer. This includes minting
991      * and burning.
992      *
993      * Calling conditions:
994      *
995      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
996      * transferred to `to`.
997      * - When `from` is zero, `tokenId` will be minted for `to`.
998      * - When `to` is zero, ``from``'s `tokenId` will be burned.
999      * - `from` cannot be the zero address.
1000      * - `to` cannot be the zero address.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1005         super._beforeTokenTransfer(from, to, tokenId);
1006 
1007         if (from == address(0)) {
1008             _addTokenToAllTokensEnumeration(tokenId);
1009         } else if (from != to) {
1010             _removeTokenFromOwnerEnumeration(from, tokenId);
1011         }
1012         if (to == address(0)) {
1013             _removeTokenFromAllTokensEnumeration(tokenId);
1014         } else if (to != from) {
1015             _addTokenToOwnerEnumeration(to, tokenId);
1016         }
1017     }
1018 
1019     /**
1020      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1021      * @param to address representing the new owner of the given token ID
1022      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1023      */
1024     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1025         uint256 length = ERC721.balanceOf(to);
1026         _ownedTokens[to][length] = tokenId;
1027         _ownedTokensIndex[tokenId] = length;
1028     }
1029 
1030     /**
1031      * @dev Private function to add a token to this extension's token tracking data structures.
1032      * @param tokenId uint256 ID of the token to be added to the tokens list
1033      */
1034     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1035         _allTokensIndex[tokenId] = _allTokens.length;
1036         _allTokens.push(tokenId);
1037     }
1038 
1039     /**
1040      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1041      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1042      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1043      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1044      * @param from address representing the previous owner of the given token ID
1045      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1046      */
1047     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1048         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1049         // then delete the last slot (swap and pop).
1050 
1051         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1052         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1053 
1054         // When the token to delete is the last token, the swap operation is unnecessary
1055         if (tokenIndex != lastTokenIndex) {
1056             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1057 
1058             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1059             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1060         }
1061 
1062         // This also deletes the contents at the last position of the array
1063         delete _ownedTokensIndex[tokenId];
1064         delete _ownedTokens[from][lastTokenIndex];
1065     }
1066 
1067     /**
1068      * @dev Private function to remove a token from this extension's token tracking data structures.
1069      * This has O(1) time complexity, but alters the order of the _allTokens array.
1070      * @param tokenId uint256 ID of the token to be removed from the tokens list
1071      */
1072     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1073         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1074         // then delete the last slot (swap and pop).
1075 
1076         uint256 lastTokenIndex = _allTokens.length - 1;
1077         uint256 tokenIndex = _allTokensIndex[tokenId];
1078 
1079         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1080         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1081         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1082         uint256 lastTokenId = _allTokens[lastTokenIndex];
1083 
1084         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1085         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1086 
1087         // This also deletes the contents at the last position of the array
1088         delete _allTokensIndex[tokenId];
1089         _allTokens.pop();
1090     }
1091 }
1092 
1093 // File: @openzeppelin/contracts/access/Ownable.sol
1094 
1095 
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 /**
1100  * @dev Contract module which provides a basic access control mechanism, where
1101  * there is an account (an owner) that can be granted exclusive access to
1102  * specific functions.
1103  *
1104  * By default, the owner account will be the one that deploys the contract. This
1105  * can later be changed with {transferOwnership}.
1106  *
1107  * This module is used through inheritance. It will make available the modifier
1108  * `onlyOwner`, which can be applied to your functions to restrict their use to
1109  * the owner.
1110  */
1111 abstract contract Ownable is Context {
1112     address private _owner;
1113 
1114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1115 
1116     /**
1117      * @dev Initializes the contract setting the deployer as the initial owner.
1118      */
1119     constructor () {
1120         address msgSender = _msgSender();
1121         _owner = msgSender;
1122         emit OwnershipTransferred(address(0), msgSender);
1123     }
1124 
1125     /**
1126      * @dev Returns the address of the current owner.
1127      */
1128     function owner() public view virtual returns (address) {
1129         return _owner;
1130     }
1131 
1132     /**
1133      * @dev Throws if called by any account other than the owner.
1134      */
1135     modifier onlyOwner() {
1136         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1137         _;
1138     }
1139 
1140     /**
1141      * @dev Leaves the contract without owner. It will not be possible to call
1142      * `onlyOwner` functions anymore. Can only be called by the current owner.
1143      *
1144      * NOTE: Renouncing ownership will leave the contract without an owner,
1145      * thereby removing any functionality that is only available to the owner.
1146      */
1147     function renounceOwnership() public virtual onlyOwner {
1148         emit OwnershipTransferred(_owner, address(0));
1149         _owner = address(0);
1150     }
1151 
1152     /**
1153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1154      * Can only be called by the current owner.
1155      */
1156     function transferOwnership(address newOwner) public virtual onlyOwner {
1157         require(newOwner != address(0), "Ownable: new owner is the zero address");
1158         emit OwnershipTransferred(_owner, newOwner);
1159         _owner = newOwner;
1160     }
1161 }
1162 
1163 // File: contracts/GradientSquares.sol
1164 pragma solidity ^0.8.0;
1165 contract GradientSquares is ERC721Enumerable, Ownable {
1166     uint256 public constant MAX_NFT_SUPPLY = 2500;
1167     uint public constant MAX_PURCHASABLE = 20;
1168     uint256 public NFT_PRICE = 50000000000000000; // 0.05 ETH
1169     bool public saleStarted = false;
1170     string public PROVENANCE_HASH = "";
1171 
1172     constructor() ERC721("GradientSquares", "SQUARES") {
1173     }
1174 
1175     function _baseURI() internal view virtual override returns (string memory) {
1176         return "https://api.gradientsquares.xyz/";
1177     }
1178 
1179     function getTokenURI(uint256 tokenId) public view returns (string memory) {
1180         return tokenURI(tokenId);
1181     }
1182 
1183    function mint(uint256 amountToMint) public payable {
1184         require(saleStarted == true, "This sale has not started.");
1185         require(totalSupply() < MAX_NFT_SUPPLY, "All NFTs have been minted.");
1186         require(amountToMint > 0, "You must mint at least one Gradient Square.");
1187         require(amountToMint <= MAX_PURCHASABLE, "You cannot mint more than 20 Gradient Squares.");
1188         require(totalSupply() + amountToMint <= MAX_NFT_SUPPLY, "The amount of Gradient Squares you are trying to mint exceeds the MAX_NFT_SUPPLY.");
1189         
1190         require(NFT_PRICE * amountToMint == msg.value, "Incorrect Ether value.");
1191 
1192         for (uint256 i = 0; i < amountToMint; i++) {
1193             uint256 mintIndex = totalSupply();
1194             _safeMint(msg.sender, mintIndex);
1195         }
1196    }
1197 
1198    function reserveTokens() public onlyOwner {        
1199         for (uint256 i = 0; i < 200; i++) {
1200            uint256 mintIndex = totalSupply();
1201            _safeMint(msg.sender, mintIndex);
1202         }
1203     }
1204     
1205 
1206     function startSale() public onlyOwner {
1207         saleStarted = true;
1208     }
1209 
1210     function pauseSale() public onlyOwner {
1211         saleStarted = false;
1212     }
1213     
1214     function setProvenanceHash(string memory _hash) public onlyOwner {
1215         PROVENANCE_HASH = _hash;
1216     }
1217 
1218     function withdraw() public payable onlyOwner {
1219         require(payable(msg.sender).send(address(this).balance));
1220     }
1221 }