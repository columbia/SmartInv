1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42     
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66     
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(address from, address to, uint256 tokenId) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address from, address to, uint256 tokenId) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
156 }
157 
158 
159 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
160 
161 
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @title ERC721 token receiver interface
167  * @dev Interface for any contract that wants to support safeTransfers
168  * from ERC721 asset contracts.
169  */
170 interface IERC721Receiver {
171     /**
172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
173      * by `operator` from `from`, this function is called.
174      *
175      * It must return its Solidity selector to confirm the token transfer.
176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
177      *
178      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
179      */
180     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
181 }
182 
183 
184 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
185 
186 
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195     /**
196      * @dev Returns the token collection name.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the token collection symbol.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
207      */
208     function tokenURI(uint256 tokenId) external view returns (string memory);
209 }
210 
211 
212 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
213 
214 
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222     /**
223      * @dev Returns true if `account` is a contract.
224      *
225      * [IMPORTANT]
226      * ====
227      * It is unsafe to assume that an address for which this function returns
228      * false is an externally-owned account (EOA) and not a contract.
229      *
230      * Among others, `isContract` will return false for the following
231      * types of addresses:
232      *
233      *  - an externally-owned account
234      *  - a contract in construction
235      *  - an address where a contract will be created
236      *  - an address where a contract lived, but was destroyed
237      * ====
238      */
239     function isContract(address account) internal view returns (bool) {
240         // This method relies on extcodesize, which returns 0 for contracts in
241         // construction, since the code is only stored at the end of the
242         // constructor execution.
243 
244         uint256 size;
245         assembly {
246             size := extcodesize(account)
247         }
248         return size > 0;
249     }
250 
251     /**
252      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
253      * `recipient`, forwarding all available gas and reverting on errors.
254      *
255      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
256      * of certain opcodes, possibly making contracts go over the 2300 gas limit
257      * imposed by `transfer`, making them unable to receive funds via
258      * `transfer`. {sendValue} removes this limitation.
259      *
260      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
261      *
262      * IMPORTANT: because control is transferred to `recipient`, care must be
263      * taken to not create reentrancy vulnerabilities. Consider using
264      * {ReentrancyGuard} or the
265      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
266      */
267     function sendValue(address payable recipient, uint256 amount) internal {
268         require(address(this).balance >= amount, "Address: insufficient balance");
269 
270         (bool success, ) = recipient.call{value: amount}("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain `call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but also transferring `value` wei to `target`.
313      *
314      * Requirements:
315      *
316      * - the calling contract must have an ETH balance of at least `value`.
317      * - the called Solidity function must be `payable`.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         require(address(this).balance >= value, "Address: insufficient balance for call");
342         require(isContract(target), "Address: call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.call{value: value}(data);
345         return _verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
355         return functionStaticCall(target, data, "Address: low-level static call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal view returns (bytes memory) {
369         require(isContract(target), "Address: static call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.staticcall(data);
372         return _verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(isContract(target), "Address: delegate call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.delegatecall(data);
399         return _verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     function _verifyCallResult(
403         bool success,
404         bytes memory returndata,
405         string memory errorMessage
406     ) private pure returns (bytes memory) {
407         if (success) {
408             return returndata;
409         } else {
410             // Look for revert reason and bubble it up if present
411             if (returndata.length > 0) {
412                 // The easiest way to bubble the revert reason is using memory via assembly
413 
414                 assembly {
415                     let returndata_size := mload(returndata)
416                     revert(add(32, returndata), returndata_size)
417                 }
418             } else {
419                 revert(errorMessage);
420             }
421         }
422     }
423 }
424 
425 
426 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
427 
428 
429 
430 pragma solidity ^0.8.0;
431 
432 /*
433  * @dev Provides information about the current execution context, including the
434  * sender of the transaction and its data. While these are generally available
435  * via msg.sender and msg.data, they should not be accessed in such a direct
436  * manner, since when dealing with meta-transactions the account sending and
437  * paying for execution may not be the actual sender (as far as an application
438  * is concerned).
439  *
440  * This contract is only required for intermediate, library-like contracts.
441  */
442 abstract contract Context {
443     function _msgSender() internal view virtual returns (address) {
444         return msg.sender;
445     }
446 
447     function _msgData() internal view virtual returns (bytes calldata) {
448         return msg.data;
449     }
450 }
451 
452 
453 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
454 
455 
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev String operations.
461  */
462 library Strings {
463     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
467      */
468     function toString(uint256 value) internal pure returns (string memory) {
469         // Inspired by OraclizeAPI's implementation - MIT licence
470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
471 
472         if (value == 0) {
473             return "0";
474         }
475         uint256 temp = value;
476         uint256 digits;
477         while (temp != 0) {
478             digits++;
479             temp /= 10;
480         }
481         bytes memory buffer = new bytes(digits);
482         while (value != 0) {
483             digits -= 1;
484             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
485             value /= 10;
486         }
487         return string(buffer);
488     }
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
492      */
493     function toHexString(uint256 value) internal pure returns (string memory) {
494         if (value == 0) {
495             return "0x00";
496         }
497         uint256 temp = value;
498         uint256 length = 0;
499         while (temp != 0) {
500             length++;
501             temp >>= 8;
502         }
503         return toHexString(value, length);
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
508      */
509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
510         bytes memory buffer = new bytes(2 * length + 2);
511         buffer[0] = "0";
512         buffer[1] = "x";
513         for (uint256 i = 2 * length + 1; i > 1; --i) {
514             buffer[i] = _HEX_SYMBOLS[value & 0xf];
515             value >>= 4;
516         }
517         require(value == 0, "Strings: hex length insufficient");
518         return string(buffer);
519     }
520 }
521 
522 
523 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
524 
525 
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Implementation of the {IERC165} interface.
531  *
532  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
533  * for the additional interface id that will be supported. For example:
534  *
535  * ```solidity
536  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
538  * }
539  * ```
540  *
541  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
542  */
543 abstract contract ERC165 is IERC165 {
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         return interfaceId == type(IERC165).interfaceId;
549     }
550 }
551 
552 
553 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
554 
555 
556 
557 pragma solidity ^0.8.0;
558 
559 
560 
561 
562 
563 
564 
565 /**
566  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
567  * the Metadata extension, but not including the Enumerable extension, which is available separately as
568  * {ERC721Enumerable}.
569  */
570 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
571     using Address for address;
572     using Strings for uint256;
573     
574     // Token name
575     string private _name;
576 
577     // Token symbol
578     string private _symbol;
579 
580     // Mapping from token ID to owner address
581     mapping(uint256 => address) private _owners;
582     
583     // Mapping owner address to token count
584     mapping(address => uint256) private _balances;
585     
586     // Mapping from token ID to approved address
587     mapping(uint256 => address) private _tokenApprovals;
588 
589     // Mapping from owner to operator approvals
590     mapping(address => mapping(address => bool)) private _operatorApprovals;
591    
592     /**
593      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
594      */
595     constructor(string memory name_, string memory symbol_) {
596         _name = name_;
597         _symbol = symbol_;
598     }
599 
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
604         return
605             interfaceId == type(IERC721).interfaceId ||
606             interfaceId == type(IERC721Metadata).interfaceId ||
607             super.supportsInterface(interfaceId);
608     }
609 
610     /**
611      * @dev See {IERC721-balanceOf}.
612      */
613     function balanceOf(address owner) public view virtual override returns (uint256) {
614         require(owner != address(0), "ERC721: balance query for the zero address");
615         return _balances[owner];
616     }
617 
618     /**
619      * @dev See {IERC721-ownerOf}.
620      */
621     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
622         address owner = _owners[tokenId];
623         require(owner != address(0), "ERC721: owner query for nonexistent token");
624         return owner;
625     }
626     
627     /**
628      * @dev See {IERC721Metadata-name}.
629      */
630     function name() public view virtual override returns (string memory) {
631         return _name;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-symbol}.
636      */
637     function symbol() public view virtual override returns (string memory) {
638         return _symbol;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-tokenURI}.
643      */
644     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
645         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
646 
647         string memory baseURI = _baseURI();
648         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
649     }
650 
651     /**
652      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
653      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
654      * by default, can be overriden in child contracts.
655      */
656     function _baseURI() internal view virtual returns (string memory) {
657         return "";
658     }
659 
660     /**
661      * @dev See {IERC721-approve}.
662      */
663     function approve(address to, uint256 tokenId) public virtual override {
664         address owner = ERC721.ownerOf(tokenId);
665         require(to != owner, "ERC721: approval to current owner");
666 
667         require(
668             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
669             "ERC721: approve caller is not owner nor approved for all"
670         );
671 
672         _approve(to, tokenId);
673     }
674 
675     /**
676      * @dev See {IERC721-getApproved}.
677      */
678     function getApproved(uint256 tokenId) public view virtual override returns (address) {
679         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
680 
681         return _tokenApprovals[tokenId];
682     }
683 
684     /**
685      * @dev See {IERC721-setApprovalForAll}.
686      */
687     function setApprovalForAll(address operator, bool approved) public virtual override {
688         require(operator != _msgSender(), "ERC721: approve to caller");
689 
690         _operatorApprovals[_msgSender()][operator] = approved;
691         emit ApprovalForAll(_msgSender(), operator, approved);
692     }
693 
694     /**
695      * @dev See {IERC721-isApprovedForAll}.
696      */
697     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
698         return _operatorApprovals[owner][operator];
699     }
700 
701     /**
702      * @dev See {IERC721-transferFrom}.
703      */
704     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
705         //solhint-disable-next-line max-line-length
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707         
708         _transfer(from, to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-safeTransferFrom}.
713      */
714     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
715         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
716         
717         safeTransferFrom(from, to, tokenId, "");
718     }
719 
720     /**
721      * @dev See {IERC721-safeTransferFrom}.
722      */
723     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
724         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
725         
726         _safeTransfer(from, to, tokenId, _data);
727     }
728 
729     /**
730      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
731      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
732      *
733      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
734      *
735      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
736      * implement alternative mechanisms to perform token transfer, such as signature-based.
737      *
738      * Requirements:
739      *
740      * - `from` cannot be the zero address.
741      * - `to` cannot be the zero address.
742      * - `tokenId` token must exist and be owned by `from`.
743      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
744      *
745      * Emits a {Transfer} event.
746      */
747     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
748         _transfer(from, to, tokenId);
749         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
750     }
751 
752     /**
753      * @dev Returns whether `tokenId` exists.
754      *
755      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
756      *
757      * Tokens start existing when they are minted (`_mint`),
758      * and stop existing when they are burned (`_burn`).
759      */
760     function _exists(uint256 tokenId) internal view virtual returns (bool) {
761         return _owners[tokenId] != address(0);
762     }
763     
764     /**
765      * @dev Returns whether `spender` is allowed to manage `tokenId`.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      */
771     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
772         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
773         address owner = ERC721.ownerOf(tokenId);
774         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
775     }
776 
777     /**
778      * @dev Safely mints `tokenId` and transfers it to `to`.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must not exist.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     
788     function _safeMint(address to, uint256 tokenId) internal virtual {
789         _safeMint(to, tokenId, "");
790         
791     }
792 
793     /**
794      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
795      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
796      */
797     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
798         _mint(to, tokenId);
799         require(
800             _checkOnERC721Received(address(0), to, tokenId, _data),
801             "ERC721: transfer to non ERC721Receiver implementer"
802         );
803     }
804 
805     /**
806      * @dev Mints `tokenId` and transfers it to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
809      *
810      * Requirements:
811      *
812      * - `tokenId` must not exist.
813      * - `to` cannot be the zero address.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _mint(address to, uint256 tokenId) internal virtual {
818         require(to != address(0), "ERC721: mint to the zero address");
819         require(!_exists(tokenId), "ERC721: token already minted");
820 
821         _beforeTokenTransfer(address(0), to, tokenId);
822 
823         _balances[to] += 1;
824         _owners[tokenId] = to;
825 
826         emit Transfer(address(0), to, tokenId);
827     }
828 
829     /**
830      * @dev Destroys `tokenId`.
831      * The approval is cleared when the token is burned.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _burn(uint256 tokenId) internal virtual {
840         address owner = ERC721.ownerOf(tokenId);
841 
842         _beforeTokenTransfer(owner, address(0), tokenId);
843 
844         // Clear approvals
845         _approve(address(0), tokenId);
846 
847         _balances[owner] -= 1;
848         delete _owners[tokenId];
849 
850         emit Transfer(owner, address(0), tokenId);
851     }
852     
853     /**
854      * @dev Transfers `tokenId` from `from` to `to`.
855      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _transfer(address from, address to, uint256 tokenId) internal virtual {
865         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
866         require(to != address(0), "ERC721: transfer to the zero address");
867 
868         _beforeTokenTransfer(from, to, tokenId);
869 
870         // Clear approvals from the previous owner
871         _approve(address(0), tokenId);
872 
873         _balances[from] -= 1;
874         _balances[to] += 1;
875         _owners[tokenId] = to;
876 
877         emit Transfer(from, to, tokenId);
878     }
879 
880     /**
881      * @dev Approve `to` to operate on `tokenId`
882      *
883      * Emits a {Approval} event.
884      */
885     function _approve(address to, uint256 tokenId) internal virtual {
886         _tokenApprovals[tokenId] = to;
887         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
888     }
889 
890     /**
891      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
892      * The call is not executed if the target address is not a contract.
893      *
894      * @param from address representing the previous owner of the given token ID
895      * @param to target address that will receive the tokens
896      * @param tokenId uint256 ID of the token to be transferred
897      * @param _data bytes optional data to send along with the call
898      * @return bool whether the call correctly returned the expected magic value
899      */
900     function _checkOnERC721Received(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) private returns (bool) {
906         if (to.isContract()) {
907             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
908                 return retval == IERC721Receiver(to).onERC721Received.selector;
909             } catch (bytes memory reason) {
910                 if (reason.length == 0) {
911                     revert("ERC721: transfer to non ERC721Receiver implementer");
912                 } else {
913                     assembly {
914                         revert(add(32, reason), mload(reason))
915                     }
916                 }
917             }
918         } else {
919             return true;
920         }
921     }
922 
923     /**
924      * @dev Hook that is called before any token transfer. This includes minting
925      * and burning.
926      *
927      * Calling conditions:
928      *
929      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
930      * transferred to `to`.
931      * - When `from` is zero, `tokenId` will be minted for `to`.
932      * - When `to` is zero, ``from``'s `tokenId` will be burned.
933      * - `from` and `to` are never both zero.
934      *
935      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
936      */
937     function _beforeTokenTransfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {}
942 }
943 
944 
945 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
946 
947 
948 
949 pragma solidity ^0.8.0;
950 
951 /**
952  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
953  * @dev See https://eips.ethereum.org/EIPS/eip-721
954  */
955 interface IERC721Enumerable is IERC721 {
956     /**
957      * @dev Returns the total amount of tokens stored by the contract.
958      */
959     function totalSupply() external view returns (uint256);
960 
961     /**
962      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
963      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
964      */
965     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
966 
967     /**
968      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
969      * Use along with {totalSupply} to enumerate all tokens.
970      */
971     function tokenByIndex(uint256 index) external view returns (uint256);
972 }
973 
974 
975 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
976 
977 
978 
979 pragma solidity ^0.8.0;
980 
981 
982 /**
983  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
984  * enumerability of all the token ids in the contract as well as all token ids owned by each
985  * account.
986  */
987 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
988     // Mapping from owner to list of owned token IDs
989     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
990 
991     // Mapping from token ID to index of the owner tokens list
992     mapping(uint256 => uint256) private _ownedTokensIndex;
993 
994     // Array with all token ids, used for enumeration
995     uint256[] private _allTokens;
996 
997     // Mapping from token id to position in the allTokens array
998     mapping(uint256 => uint256) private _allTokensIndex;
999 
1000     /**
1001      * @dev See {IERC165-supportsInterface}.
1002      */
1003     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1004         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1009      */
1010     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1011         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1012         return _ownedTokens[owner][index];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Enumerable-totalSupply}.
1017      */
1018     function totalSupply() public view virtual override returns (uint256) {
1019         return _allTokens.length;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Enumerable-tokenByIndex}.
1024      */
1025     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1026         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1027         return _allTokens[index];
1028     }
1029 
1030     /**
1031      * @dev Hook that is called before any token transfer. This includes minting
1032      * and burning.
1033      *
1034      * Calling conditions:
1035      *
1036      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1037      * transferred to `to`.
1038      * - When `from` is zero, `tokenId` will be minted for `to`.
1039      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      *
1043      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1044      */
1045     function _beforeTokenTransfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) internal virtual override {
1050         super._beforeTokenTransfer(from, to, tokenId);
1051 
1052         if (from == address(0)) {
1053             _addTokenToAllTokensEnumeration(tokenId);
1054         } else if (from != to) {
1055             _removeTokenFromOwnerEnumeration(from, tokenId);
1056         }
1057         if (to == address(0)) {
1058             _removeTokenFromAllTokensEnumeration(tokenId);
1059         } else if (to != from) {
1060             _addTokenToOwnerEnumeration(to, tokenId);
1061         }
1062     }
1063 
1064     /**
1065      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1066      * @param to address representing the new owner of the given token ID
1067      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1068      */
1069     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1070         uint256 length = ERC721.balanceOf(to);
1071         _ownedTokens[to][length] = tokenId;
1072         _ownedTokensIndex[tokenId] = length;
1073     }
1074 
1075     /**
1076      * @dev Private function to add a token to this extension's token tracking data structures.
1077      * @param tokenId uint256 ID of the token to be added to the tokens list
1078      */
1079     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1080         _allTokensIndex[tokenId] = _allTokens.length;
1081         _allTokens.push(tokenId);
1082     }
1083 
1084     /**
1085      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1086      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1087      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1088      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1089      * @param from address representing the previous owner of the given token ID
1090      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1091      */
1092     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1093         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1094         // then delete the last slot (swap and pop).
1095 
1096         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1097         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1098 
1099         // When the token to delete is the last token, the swap operation is unnecessary
1100         if (tokenIndex != lastTokenIndex) {
1101             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1102 
1103             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1104             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1105         }
1106 
1107         // This also deletes the contents at the last position of the array
1108         delete _ownedTokensIndex[tokenId];
1109         delete _ownedTokens[from][lastTokenIndex];
1110     }
1111 
1112     /**
1113      * @dev Private function to remove a token from this extension's token tracking data structures.
1114      * This has O(1) time complexity, but alters the order of the _allTokens array.
1115      * @param tokenId uint256 ID of the token to be removed from the tokens list
1116      */
1117     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1118         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1119         // then delete the last slot (swap and pop).
1120 
1121         uint256 lastTokenIndex = _allTokens.length - 1;
1122         uint256 tokenIndex = _allTokensIndex[tokenId];
1123 
1124         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1125         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1126         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1127         uint256 lastTokenId = _allTokens[lastTokenIndex];
1128 
1129         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1130         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1131 
1132         // This also deletes the contents at the last position of the array
1133         delete _allTokensIndex[tokenId];
1134         _allTokens.pop();
1135     }
1136 }
1137 
1138 
1139 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1140 
1141 
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 /**
1146  * @dev Contract module which provides a basic access control mechanism, where
1147  * there is an account (an owner) that can be granted exclusive access to
1148  * specific functions.
1149  *
1150  * By default, the owner account will be the one that deploys the contract. This
1151  * can later be changed with {transferOwnership}.
1152  *
1153  * This module is used through inheritance. It will make available the modifier
1154  * `onlyOwner`, which can be applied to your functions to restrict their use to
1155  * the owner.
1156  */
1157 abstract contract Ownable is Context {
1158     address private _owner;
1159     
1160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1161     /**
1162      * @dev Initializes the contract setting the deployer as the initial owner.
1163      */
1164     constructor() {
1165         _setOwner(_msgSender());
1166     }
1167     
1168     /**
1169      * @dev Returns the address of the current owner.
1170      */
1171     function owner() public view virtual returns (address) {
1172         return _owner;
1173     }
1174 
1175     /**
1176      * @dev Throws if called by any account other than the owner.
1177      */
1178     modifier onlyOwner() {
1179         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1180         _;
1181     }
1182 
1183     /**
1184      * @dev Leaves the contract without owner. It will not be possible to call
1185      * `onlyOwner` functions anymore. Can only be called by the current owner.
1186      *
1187      * NOTE: Renouncing ownership will leave the contract without an owner,
1188      * thereby removing any functionality that is only available to the owner.
1189      */
1190     function renounceOwnership() public virtual onlyOwner {
1191         _setOwner(address(0));
1192     }
1193 
1194     /**
1195      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1196      * Can only be called by the current owner.
1197      */
1198     function transferOwnership(address newOwner) public virtual onlyOwner {
1199         require(newOwner != address(0), "Ownable: new owner is the zero address");
1200         _setOwner(newOwner);
1201     }
1202 
1203     function _setOwner(address newOwner) private {
1204         address oldOwner = _owner;
1205         _owner = newOwner;
1206         emit OwnershipTransferred(oldOwner, newOwner);
1207     }
1208     
1209 }
1210 
1211 
1212 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
1213 
1214 
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 // CAUTION
1219 // This version of SafeMath should only be used with Solidity 0.8 or later,
1220 // because it relies on the compiler's built in overflow checks.
1221 
1222 /**
1223  * @dev Wrappers over Solidity's arithmetic operations.
1224  *
1225  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1226  * now has built in overflow checking.
1227  */
1228 library SafeMath {
1229     /**
1230      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1231      *
1232      * _Available since v3.4._
1233      */
1234     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1235         unchecked {
1236             uint256 c = a + b;
1237             if (c < a) return (false, 0);
1238             return (true, c);
1239         }
1240     }
1241 
1242     /**
1243      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1244      *
1245      * _Available since v3.4._
1246      */
1247     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1248         unchecked {
1249             if (b > a) return (false, 0);
1250             return (true, a - b);
1251         }
1252     }
1253 
1254     /**
1255      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1256      *
1257      * _Available since v3.4._
1258      */
1259     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1260         unchecked {
1261             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1262             // benefit is lost if 'b' is also tested.
1263             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1264             if (a == 0) return (true, 0);
1265             uint256 c = a * b;
1266             if (c / a != b) return (false, 0);
1267             return (true, c);
1268         }
1269     }
1270 
1271     /**
1272      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1273      *
1274      * _Available since v3.4._
1275      */
1276     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1277         unchecked {
1278             if (b == 0) return (false, 0);
1279             return (true, a / b);
1280         }
1281     }
1282 
1283     /**
1284      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1285      *
1286      * _Available since v3.4._
1287      */
1288     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1289         unchecked {
1290             if (b == 0) return (false, 0);
1291             return (true, a % b);
1292         }
1293     }
1294 
1295     /**
1296      * @dev Returns the addition of two unsigned integers, reverting on
1297      * overflow.
1298      *
1299      * Counterpart to Solidity's `+` operator.
1300      *
1301      * Requirements:
1302      *
1303      * - Addition cannot overflow.
1304      */
1305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1306         return a + b;
1307     }
1308 
1309     /**
1310      * @dev Returns the subtraction of two unsigned integers, reverting on
1311      * overflow (when the result is negative).
1312      *
1313      * Counterpart to Solidity's `-` operator.
1314      *
1315      * Requirements:
1316      *
1317      * - Subtraction cannot overflow.
1318      */
1319     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1320         return a - b;
1321     }
1322 
1323     /**
1324      * @dev Returns the multiplication of two unsigned integers, reverting on
1325      * overflow.
1326      *
1327      * Counterpart to Solidity's `*` operator.
1328      *
1329      * Requirements:
1330      *
1331      * - Multiplication cannot overflow.
1332      */
1333     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1334         return a * b;
1335     }
1336 
1337     /**
1338      * @dev Returns the integer division of two unsigned integers, reverting on
1339      * division by zero. The result is rounded towards zero.
1340      *
1341      * Counterpart to Solidity's `/` operator.
1342      *
1343      * Requirements:
1344      *
1345      * - The divisor cannot be zero.
1346      */
1347     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1348         return a / b;
1349     }
1350 
1351     /**
1352      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1353      * reverting when dividing by zero.
1354      *
1355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1356      * opcode (which leaves remaining gas untouched) while Solidity uses an
1357      * invalid opcode to revert (consuming all remaining gas).
1358      *
1359      * Requirements:
1360      *
1361      * - The divisor cannot be zero.
1362      */
1363     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1364         return a % b;
1365     }
1366 
1367     /**
1368      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1369      * overflow (when the result is negative).
1370      *
1371      * CAUTION: This function is deprecated because it requires allocating memory for the error
1372      * message unnecessarily. For custom revert reasons use {trySub}.
1373      *
1374      * Counterpart to Solidity's `-` operator.
1375      *
1376      * Requirements:
1377      *
1378      * - Subtraction cannot overflow.
1379      */
1380     function sub(
1381         uint256 a,
1382         uint256 b,
1383         string memory errorMessage
1384     ) internal pure returns (uint256) {
1385         unchecked {
1386             require(b <= a, errorMessage);
1387             return a - b;
1388         }
1389     }
1390 
1391     /**
1392      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1393      * division by zero. The result is rounded towards zero.
1394      *
1395      * Counterpart to Solidity's `/` operator. Note: this function uses a
1396      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1397      * uses an invalid opcode to revert (consuming all remaining gas).
1398      *
1399      * Requirements:
1400      *
1401      * - The divisor cannot be zero.
1402      */
1403     function div(
1404         uint256 a,
1405         uint256 b,
1406         string memory errorMessage
1407     ) internal pure returns (uint256) {
1408         unchecked {
1409             require(b > 0, errorMessage);
1410             return a / b;
1411         }
1412     }
1413 
1414     /**
1415      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1416      * reverting with custom message when dividing by zero.
1417      *
1418      * CAUTION: This function is deprecated because it requires allocating memory for the error
1419      * message unnecessarily. For custom revert reasons use {tryMod}.
1420      *
1421      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1422      * opcode (which leaves remaining gas untouched) while Solidity uses an
1423      * invalid opcode to revert (consuming all remaining gas).
1424      *
1425      * Requirements:
1426      *
1427      * - The divisor cannot be zero.
1428      */
1429     function mod(
1430         uint256 a,
1431         uint256 b,
1432         string memory errorMessage
1433     ) internal pure returns (uint256) {
1434         unchecked {
1435             require(b > 0, errorMessage);
1436             return a % b;
1437         }
1438     }
1439 }
1440 
1441 pragma solidity ^0.8.0;
1442 
1443 contract Apes is ERC721Enumerable, Ownable {
1444     using Strings for uint256;
1445     
1446     struct Investor {
1447         uint256 amountLeft;
1448         bool locked;
1449     }
1450 
1451     uint256 public MAX_APES = 4313;
1452 
1453     string internal _baseTokenURI;
1454     
1455     mapping(address => bool) public whitelisted;
1456     mapping(address => Investor) public investorDetails;
1457 
1458     
1459     constructor(string memory baseURI) ERC721("Pixel Apes", "Apes")  {
1460         updateBaseURI(baseURI);
1461     }
1462     
1463     function whitelist(address[] memory _investorAddresses, uint256[] memory _tokenAmount) external onlyOwner {
1464         require(_investorAddresses.length == _tokenAmount.length,"Input array's length mismatch");
1465         for (uint i = 0; i < _investorAddresses.length; i++) {
1466             whitelisted[_investorAddresses[i]] = true;
1467             investorDetails[_investorAddresses[i]] = Investor(_tokenAmount[i],false);
1468         }
1469     }
1470     
1471     function reclaim() external {
1472         require(totalSupply() < MAX_APES, "All Apes have not been reclaimed.");
1473         require(whitelisted[msg.sender]);
1474         require(!investorDetails[msg.sender].locked);
1475         uint256 _amount = investorDetails[msg.sender].amountLeft;
1476         investorDetails[msg.sender] = Investor(0, true);
1477         for(uint256 i = 0; i < _amount; i++) {
1478             _safeMint(msg.sender, totalSupply());
1479         
1480         }
1481     }
1482     
1483     function _baseURI() internal view virtual override returns (string memory) {
1484         return _baseTokenURI;
1485     }
1486 
1487     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1488         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1489         string memory baseURI = _baseURI();
1490         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")) : "";
1491     }
1492     
1493     function getBaseURI() public onlyOwner view returns (string memory) {
1494         return _baseURI();
1495     }
1496     
1497     function updateMax(uint256 maxape) external onlyOwner {
1498         require(maxape < 4313, "Cannot increase max apes.");
1499         MAX_APES = maxape;
1500     }
1501     
1502     function updateBaseURI(string memory baseURI) public onlyOwner {
1503         _baseTokenURI = baseURI;
1504     }
1505     
1506     function withdrawAll() public payable onlyOwner {
1507         require(payable(_msgSender()).send(address(this).balance));
1508     }
1509 }