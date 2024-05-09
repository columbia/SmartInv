1 // Sources flattened with hardhat v2.3.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
4 // SPDX-License-Identifier: MIT
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(address from, address to, uint256 tokenId) external;
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
98     function transferFrom(address from, address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144       * @dev Safely transfers `tokenId` token from `from` to `to`.
145       *
146       * Requirements:
147       *
148       * - `from` cannot be the zero address.
149       * - `to` cannot be the zero address.
150       * - `tokenId` token must exist and be owned by `from`.
151       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153       *
154       * Emits a {Transfer} event.
155       */
156     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
157 }
158 
159 
160 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @title ERC721 token receiver interface
165  * @dev Interface for any contract that wants to support safeTransfers
166  * from ERC721 asset contracts.
167  */
168 interface IERC721Receiver {
169     /**
170      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
171      * by `operator` from `from`, this function is called.
172      *
173      * It must return its Solidity selector to confirm the token transfer.
174      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
175      *
176      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
177      */
178     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
179 }
180 
181 
182 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
183 
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192 
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 
210 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
211 
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize, which returns 0 for contracts in
238         // construction, since the code is only stored at the end of the
239         // constructor execution.
240 
241         uint256 size;
242         // solhint-disable-next-line no-inline-assembly
243         assembly { size := extcodesize(account) }
244         return size > 0;
245     }
246 
247     /**
248      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
249      * `recipient`, forwarding all available gas and reverting on errors.
250      *
251      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
252      * of certain opcodes, possibly making contracts go over the 2300 gas limit
253      * imposed by `transfer`, making them unable to receive funds via
254      * `transfer`. {sendValue} removes this limitation.
255      *
256      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
257      *
258      * IMPORTANT: because control is transferred to `recipient`, care must be
259      * taken to not create reentrancy vulnerabilities. Consider using
260      * {ReentrancyGuard} or the
261      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
262      */
263     function sendValue(address payable recipient, uint256 amount) internal {
264         require(address(this).balance >= amount, "Address: insufficient balance");
265 
266         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
267         (bool success, ) = recipient.call{ value: amount }("");
268         require(success, "Address: unable to send value, recipient may have reverted");
269     }
270 
271     /**
272      * @dev Performs a Solidity function call using a low level `call`. A
273      * plain`call` is an unsafe replacement for a function call: use this
274      * function instead.
275      *
276      * If `target` reverts with a revert reason, it is bubbled up by this
277      * function (like regular Solidity function calls).
278      *
279      * Returns the raw returned data. To convert to the expected return value,
280      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
281      *
282      * Requirements:
283      *
284      * - `target` must be a contract.
285      * - calling `target` with `data` must not revert.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290       return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, 0, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but also transferring `value` wei to `target`.
306      *
307      * Requirements:
308      *
309      * - the calling contract must have an ETH balance of at least `value`.
310      * - the called Solidity function must be `payable`.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         require(isContract(target), "Address: call to non-contract");
327 
328         // solhint-disable-next-line avoid-low-level-calls
329         (bool success, bytes memory returndata) = target.call{ value: value }(data);
330         return _verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
350         require(isContract(target), "Address: static call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.staticcall(data);
354         return _verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
374         require(isContract(target), "Address: delegate call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return _verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 
402 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
403 
404 
405 pragma solidity ^0.8.0;
406 
407 /*
408  * @dev Provides information about the current execution context, including the
409  * sender of the transaction and its data. While these are generally available
410  * via msg.sender and msg.data, they should not be accessed in such a direct
411  * manner, since when dealing with meta-transactions the account sending and
412  * paying for execution may not be the actual sender (as far as an application
413  * is concerned).
414  *
415  * This contract is only required for intermediate, library-like contracts.
416  */
417 abstract contract Context {
418     function _msgSender() internal view virtual returns (address) {
419         return msg.sender;
420     }
421 
422     function _msgData() internal view virtual returns (bytes calldata) {
423         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
424         return msg.data;
425     }
426 }
427 
428 
429 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
430 
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @dev String operations.
436  */
437 library Strings {
438     bytes16 private constant alphabet = "0123456789abcdef";
439 
440     /**
441      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
442      */
443     function toString(uint256 value) internal pure returns (string memory) {
444         // Inspired by OraclizeAPI's implementation - MIT licence
445         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
446 
447         if (value == 0) {
448             return "0";
449         }
450         uint256 temp = value;
451         uint256 digits;
452         while (temp != 0) {
453             digits++;
454             temp /= 10;
455         }
456         bytes memory buffer = new bytes(digits);
457         while (value != 0) {
458             digits -= 1;
459             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
460             value /= 10;
461         }
462         return string(buffer);
463     }
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
467      */
468     function toHexString(uint256 value) internal pure returns (string memory) {
469         if (value == 0) {
470             return "0x00";
471         }
472         uint256 temp = value;
473         uint256 length = 0;
474         while (temp != 0) {
475             length++;
476             temp >>= 8;
477         }
478         return toHexString(value, length);
479     }
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
483      */
484     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
485         bytes memory buffer = new bytes(2 * length + 2);
486         buffer[0] = "0";
487         buffer[1] = "x";
488         for (uint256 i = 2 * length + 1; i > 1; --i) {
489             buffer[i] = alphabet[value & 0xf];
490             value >>= 4;
491         }
492         require(value == 0, "Strings: hex length insufficient");
493         return string(buffer);
494     }
495 
496 }
497 
498 
499 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
500 
501 
502 pragma solidity ^0.8.0;
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
527 
528 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
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
539 /**
540  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
541  * the Metadata extension, but not including the Enumerable extension, which is available separately as
542  * {ERC721Enumerable}.
543  */
544 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
545     using Address for address;
546     using Strings for uint256;
547 
548     // Token name
549     string private _name;
550 
551     // Token symbol
552     string private _symbol;
553 
554     // Mapping from token ID to owner address
555     mapping (uint256 => address) private _owners;
556 
557     // Mapping owner address to token count
558     mapping (address => uint256) private _balances;
559 
560     // Mapping from token ID to approved address
561     mapping (uint256 => address) private _tokenApprovals;
562 
563     // Mapping from owner to operator approvals
564     mapping (address => mapping (address => bool)) private _operatorApprovals;
565 
566     /**
567      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
568      */
569     constructor (string memory name_, string memory symbol_) {
570         _name = name_;
571         _symbol = symbol_;
572     }
573 
574     /**
575      * @dev See {IERC165-supportsInterface}.
576      */
577     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
578         return interfaceId == type(IERC721).interfaceId
579             || interfaceId == type(IERC721Metadata).interfaceId
580             || super.supportsInterface(interfaceId);
581     }
582 
583     /**
584      * @dev See {IERC721-balanceOf}.
585      */
586     function balanceOf(address owner) public view virtual override returns (uint256) {
587         require(owner != address(0), "ERC721: balance query for the zero address");
588         return _balances[owner];
589     }
590 
591     /**
592      * @dev See {IERC721-ownerOf}.
593      */
594     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
595         address owner = _owners[tokenId];
596         require(owner != address(0), "ERC721: owner query for nonexistent token");
597         return owner;
598     }
599 
600     /**
601      * @dev See {IERC721Metadata-name}.
602      */
603     function name() public view virtual override returns (string memory) {
604         return _name;
605     }
606 
607     /**
608      * @dev See {IERC721Metadata-symbol}.
609      */
610     function symbol() public view virtual override returns (string memory) {
611         return _symbol;
612     }
613 
614     /**
615      * @dev See {IERC721Metadata-tokenURI}.
616      */
617     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
618         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
619 
620         string memory baseURI = _baseURI();
621         return bytes(baseURI).length > 0
622             ? string(abi.encodePacked(baseURI, tokenId.toString()))
623             : '';
624     }
625 
626     /**
627      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
628      * in child contracts.
629      */
630     function _baseURI() internal view virtual returns (string memory) {
631         return "";
632     }
633 
634     /**
635      * @dev See {IERC721-approve}.
636      */
637     function approve(address to, uint256 tokenId) public virtual override {
638         address owner = ERC721.ownerOf(tokenId);
639         require(to != owner, "ERC721: approval to current owner");
640 
641         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
642             "ERC721: approve caller is not owner nor approved for all"
643         );
644 
645         _approve(to, tokenId);
646     }
647 
648     /**
649      * @dev See {IERC721-getApproved}.
650      */
651     function getApproved(uint256 tokenId) public view virtual override returns (address) {
652         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
653 
654         return _tokenApprovals[tokenId];
655     }
656 
657     /**
658      * @dev See {IERC721-setApprovalForAll}.
659      */
660     function setApprovalForAll(address operator, bool approved) public virtual override {
661         require(operator != _msgSender(), "ERC721: approve to caller");
662 
663         _operatorApprovals[_msgSender()][operator] = approved;
664         emit ApprovalForAll(_msgSender(), operator, approved);
665     }
666 
667     /**
668      * @dev See {IERC721-isApprovedForAll}.
669      */
670     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
671         return _operatorApprovals[owner][operator];
672     }
673 
674     /**
675      * @dev See {IERC721-transferFrom}.
676      */
677     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
678         //solhint-disable-next-line max-line-length
679         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
680 
681         _transfer(from, to, tokenId);
682     }
683 
684     /**
685      * @dev See {IERC721-safeTransferFrom}.
686      */
687     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
688         safeTransferFrom(from, to, tokenId, "");
689     }
690 
691     /**
692      * @dev See {IERC721-safeTransferFrom}.
693      */
694     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
695         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
696         _safeTransfer(from, to, tokenId, _data);
697     }
698 
699     /**
700      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
701      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
702      *
703      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
704      *
705      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
706      * implement alternative mechanisms to perform token transfer, such as signature-based.
707      *
708      * Requirements:
709      *
710      * - `from` cannot be the zero address.
711      * - `to` cannot be the zero address.
712      * - `tokenId` token must exist and be owned by `from`.
713      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
714      *
715      * Emits a {Transfer} event.
716      */
717     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
718         _transfer(from, to, tokenId);
719         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
720     }
721 
722     /**
723      * @dev Returns whether `tokenId` exists.
724      *
725      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
726      *
727      * Tokens start existing when they are minted (`_mint`),
728      * and stop existing when they are burned (`_burn`).
729      */
730     function _exists(uint256 tokenId) internal view virtual returns (bool) {
731         return _owners[tokenId] != address(0);
732     }
733 
734     /**
735      * @dev Returns whether `spender` is allowed to manage `tokenId`.
736      *
737      * Requirements:
738      *
739      * - `tokenId` must exist.
740      */
741     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
742         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
743         address owner = ERC721.ownerOf(tokenId);
744         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
745     }
746 
747     /**
748      * @dev Safely mints `tokenId` and transfers it to `to`.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must not exist.
753      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function _safeMint(address to, uint256 tokenId) internal virtual {
758         _safeMint(to, tokenId, "");
759     }
760 
761     /**
762      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
763      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
764      */
765     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
766         _mint(to, tokenId);
767         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
768     }
769 
770     /**
771      * @dev Mints `tokenId` and transfers it to `to`.
772      *
773      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
774      *
775      * Requirements:
776      *
777      * - `tokenId` must not exist.
778      * - `to` cannot be the zero address.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _mint(address to, uint256 tokenId) internal virtual {
783         require(to != address(0), "ERC721: mint to the zero address");
784         require(!_exists(tokenId), "ERC721: token already minted");
785 
786         _beforeTokenTransfer(address(0), to, tokenId);
787 
788         _balances[to] += 1;
789         _owners[tokenId] = to;
790 
791         emit Transfer(address(0), to, tokenId);
792     }
793 
794     /**
795      * @dev Destroys `tokenId`.
796      * The approval is cleared when the token is burned.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _burn(uint256 tokenId) internal virtual {
805         address owner = ERC721.ownerOf(tokenId);
806 
807         _beforeTokenTransfer(owner, address(0), tokenId);
808 
809         // Clear approvals
810         _approve(address(0), tokenId);
811 
812         _balances[owner] -= 1;
813         delete _owners[tokenId];
814 
815         emit Transfer(owner, address(0), tokenId);
816     }
817 
818     /**
819      * @dev Transfers `tokenId` from `from` to `to`.
820      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
821      *
822      * Requirements:
823      *
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _transfer(address from, address to, uint256 tokenId) internal virtual {
830         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
831         require(to != address(0), "ERC721: transfer to the zero address");
832 
833         _beforeTokenTransfer(from, to, tokenId);
834 
835         // Clear approvals from the previous owner
836         _approve(address(0), tokenId);
837 
838         _balances[from] -= 1;
839         _balances[to] += 1;
840         _owners[tokenId] = to;
841 
842         emit Transfer(from, to, tokenId);
843     }
844 
845     /**
846      * @dev Approve `to` to operate on `tokenId`
847      *
848      * Emits a {Approval} event.
849      */
850     function _approve(address to, uint256 tokenId) internal virtual {
851         _tokenApprovals[tokenId] = to;
852         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
853     }
854 
855     /**
856      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
857      * The call is not executed if the target address is not a contract.
858      *
859      * @param from address representing the previous owner of the given token ID
860      * @param to target address that will receive the tokens
861      * @param tokenId uint256 ID of the token to be transferred
862      * @param _data bytes optional data to send along with the call
863      * @return bool whether the call correctly returned the expected magic value
864      */
865     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
866         private returns (bool)
867     {
868         if (to.isContract()) {
869             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
870                 return retval == IERC721Receiver(to).onERC721Received.selector;
871             } catch (bytes memory reason) {
872                 if (reason.length == 0) {
873                     revert("ERC721: transfer to non ERC721Receiver implementer");
874                 } else {
875                     // solhint-disable-next-line no-inline-assembly
876                     assembly {
877                         revert(add(32, reason), mload(reason))
878                     }
879                 }
880             }
881         } else {
882             return true;
883         }
884     }
885 
886     /**
887      * @dev Hook that is called before any token transfer. This includes minting
888      * and burning.
889      *
890      * Calling conditions:
891      *
892      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
893      * transferred to `to`.
894      * - When `from` is zero, `tokenId` will be minted for `to`.
895      * - When `to` is zero, ``from``'s `tokenId` will be burned.
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      *
899      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
900      */
901     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
902 }
903 
904 
905 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.1.0
906 
907 
908 pragma solidity ^0.8.0;
909 
910 /**
911  * @dev ERC721 token with storage based token URI management.
912  */
913 abstract contract ERC721URIStorage is ERC721 {
914     using Strings for uint256;
915 
916     // Optional mapping for token URIs
917     mapping (uint256 => string) private _tokenURIs;
918 
919     /**
920      * @dev See {IERC721Metadata-tokenURI}.
921      */
922     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
923         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
924 
925         string memory _tokenURI = _tokenURIs[tokenId];
926         string memory base = _baseURI();
927 
928         // If there is no base URI, return the token URI.
929         if (bytes(base).length == 0) {
930             return _tokenURI;
931         }
932         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
933         if (bytes(_tokenURI).length > 0) {
934             return string(abi.encodePacked(base, _tokenURI));
935         }
936 
937         return super.tokenURI(tokenId);
938     }
939 
940     /**
941      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      */
947     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
948         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
949         _tokenURIs[tokenId] = _tokenURI;
950     }
951 
952     /**
953      * @dev Destroys `tokenId`.
954      * The approval is cleared when the token is burned.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _burn(uint256 tokenId) internal virtual override {
963         super._burn(tokenId);
964 
965         if (bytes(_tokenURIs[tokenId]).length != 0) {
966             delete _tokenURIs[tokenId];
967         }
968     }
969 }
970 
971 
972 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
973 
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @title Counters
979  * @author Matt Condon (@shrugs)
980  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
981  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
982  *
983  * Include with `using Counters for Counters.Counter;`
984  */
985 library Counters {
986     struct Counter {
987         // This variable should never be directly accessed by users of the library: interactions must be restricted to
988         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
989         // this feature: see https://github.com/ethereum/solidity/issues/4637
990         uint256 _value; // default: 0
991     }
992 
993     function current(Counter storage counter) internal view returns (uint256) {
994         return counter._value;
995     }
996 
997     function increment(Counter storage counter) internal {
998         unchecked {
999             counter._value += 1;
1000         }
1001     }
1002 
1003     function decrement(Counter storage counter) internal {
1004         uint256 value = counter._value;
1005         require(value > 0, "Counter: decrement overflow");
1006         unchecked {
1007             counter._value = value - 1;
1008         }
1009     }
1010 }
1011 
1012 
1013 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1014 
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 /**
1019  * @dev Contract module which provides a basic access control mechanism, where
1020  * there is an account (an owner) that can be granted exclusive access to
1021  * specific functions.
1022  *
1023  * By default, the owner account will be the one that deploys the contract. This
1024  * can later be changed with {transferOwnership}.
1025  *
1026  * This module is used through inheritance. It will make available the modifier
1027  * `onlyOwner`, which can be applied to your functions to restrict their use to
1028  * the owner.
1029  */
1030 abstract contract Ownable is Context {
1031     address private _owner;
1032 
1033     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1034 
1035     /**
1036      * @dev Initializes the contract setting the deployer as the initial owner.
1037      */
1038     constructor () {
1039         address msgSender = _msgSender();
1040         _owner = msgSender;
1041         emit OwnershipTransferred(address(0), msgSender);
1042     }
1043 
1044     /**
1045      * @dev Returns the address of the current owner.
1046      */
1047     function owner() public view virtual returns (address) {
1048         return _owner;
1049     }
1050 
1051     /**
1052      * @dev Throws if called by any account other than the owner.
1053      */
1054     modifier onlyOwner() {
1055         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1056         _;
1057     }
1058 
1059     /**
1060      * @dev Leaves the contract without owner. It will not be possible to call
1061      * `onlyOwner` functions anymore. Can only be called by the current owner.
1062      *
1063      * NOTE: Renouncing ownership will leave the contract without an owner,
1064      * thereby removing any functionality that is only available to the owner.
1065      */
1066     function renounceOwnership() public virtual onlyOwner {
1067         emit OwnershipTransferred(_owner, address(0));
1068         _owner = address(0);
1069     }
1070 
1071     /**
1072      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1073      * Can only be called by the current owner.
1074      */
1075     function transferOwnership(address newOwner) public virtual onlyOwner {
1076         require(newOwner != address(0), "Ownable: new owner is the zero address");
1077         emit OwnershipTransferred(_owner, newOwner);
1078         _owner = newOwner;
1079     }
1080 }
1081 
1082 
1083 // File contracts/Misfit_University_Official.sol
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 
1088 
1089 
1090 contract Misfit_University_Official is ERC721URIStorage, Ownable {
1091     using Counters for Counters.Counter;
1092     Counters.Counter private _tokenIds;
1093 
1094     uint public fee;
1095 
1096     uint public reserved;
1097 
1098     string public baseUri;
1099 
1100     event Minted(address to, uint id, string uri);
1101 
1102     event PriceUpdated(uint newPrice);
1103 
1104     constructor() ERC721("Misfit University Official", "MU") {
1105       fee = 80000000000000000 wei; //0.08 ETH
1106       baseUri = "ipfs://QmbumZq4f81hc2KsVWMMH2AmRpw7nSwX3KBsjABewabNnj/";
1107     }
1108 
1109     /**
1110      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1111      */
1112     function toString(uint256 value) internal pure returns (string memory) {
1113         // Inspired by OraclizeAPI's implementation - MIT licence
1114         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1115 
1116         if (value == 0) {
1117             return "0";
1118         }
1119         uint256 temp = value;
1120         uint256 digits;
1121         while (temp != 0) {
1122             digits++;
1123             temp /= 10;
1124         }
1125         bytes memory buffer = new bytes(digits);
1126         while (value != 0) {
1127             digits -= 1;
1128             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1129             value /= 10;
1130         }
1131         return string(buffer);
1132     }
1133 
1134     /*
1135     * Mint Misfits
1136     */
1137     function mint(address player, uint numberOfMints)
1138         public payable
1139         returns (uint256)
1140     {
1141         require(_tokenIds.current() + numberOfMints <= 9900, "Maximum amount of Misfits already minted."); //10000 item cap (9900 public + 100 team mints)
1142         require(msg.value >= fee * numberOfMints, "Fee is not correct.");  //User must pay set fee.`
1143         require(numberOfMints <= 20, "You cant mint more than 20 at a time.");
1144 
1145         for(uint i = 0; i < numberOfMints; i++) {
1146 
1147             _tokenIds.increment();
1148             uint256 newItemId = _tokenIds.current();
1149             string memory tokenURI = string(abi.encodePacked(baseUri, toString(newItemId),  ".json"));
1150             _mint(player, newItemId);
1151             _setTokenURI(newItemId, tokenURI);
1152 
1153             //removed Mint event here bc of gas intensity.
1154         }
1155 
1156         return _tokenIds.current();
1157     }
1158 
1159     function getOwnerMintedTotal() public view returns(uint){
1160         return reserved;
1161     }
1162 
1163     function mintOwner(address player, string memory tokenURI)
1164         public onlyOwner
1165         returns (uint256)
1166     {
1167         require(reserved < 100); //owner can mint up to 100 for free. this can be handed over to a DAO too.
1168 
1169         require(_tokenIds.current() < 10000); //10000 item cap no matter what
1170 
1171         _tokenIds.increment();
1172 
1173         uint256 newItemId = _tokenIds.current();
1174         _mint(player, newItemId);
1175         _setTokenURI(newItemId, tokenURI);
1176 
1177         emit Minted(player, newItemId, tokenURI);
1178 
1179         reserved = reserved + 1;
1180 
1181         return newItemId;
1182     }
1183 
1184     function updateFee(uint newFee) public onlyOwner{
1185       fee = newFee;
1186 
1187       emit PriceUpdated(newFee);
1188     }
1189 
1190     function getFee() public view returns (uint) {
1191       return fee;
1192     }
1193 
1194     function cashOut() public onlyOwner{
1195         payable(msg.sender).transfer(address(this).balance);
1196     }
1197 }