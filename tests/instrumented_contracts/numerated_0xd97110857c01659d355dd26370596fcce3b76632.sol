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
583     mapping (uint256 => address) private _ogminter;
584     
585     mapping (uint256 => address) private _ntminter;
586     // Mapping owner address to token count
587     mapping(address => uint256) private _balances;
588     
589     // Mapping from token ID to approved address
590     mapping(uint256 => address) private _tokenApprovals;
591 
592     // Mapping from owner to operator approvals
593     mapping(address => mapping(address => bool)) private _operatorApprovals;
594     
595     uint256 public UnlockCost = 100000000000000000;
596     
597     uint256 public TransferFee = 75000000000000000;
598    
599     /**
600      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
601      */
602     constructor(string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605     }
606 
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
611         return
612             interfaceId == type(IERC721).interfaceId ||
613             interfaceId == type(IERC721Metadata).interfaceId ||
614             super.supportsInterface(interfaceId);
615     }
616 
617     /**
618      * @dev See {IERC721-balanceOf}.
619      */
620     function balanceOf(address owner) public view virtual override returns (uint256) {
621         require(owner != address(0), "ERC721: balance query for the zero address");
622         return _balances[owner];
623     }
624 
625     /**
626      * @dev See {IERC721-ownerOf}.
627      */
628     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
629         address owner = _owners[tokenId];
630         require(owner != address(0), "ERC721: owner query for nonexistent token");
631         return owner;
632     }
633     
634     function original(uint256 tokenId) public view virtual returns (address) {
635         address _isOG = _ogminter[tokenId];
636         require(_isOG != address(0), "ERC721: owner query for nonexistent token");
637         return _isOG;
638     }
639     
640     function ntoriginal(uint256 tokenId) public view virtual returns (address) {
641         address _ntOG = _ntminter[tokenId];
642         require(_ntOG != address(0), "ERC721: owner query for nonexistent token");
643         return _ntOG;
644     }
645     
646     /**
647      * @dev See {IERC721Metadata-name}.
648      */
649     function name() public view virtual override returns (string memory) {
650         return _name;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-symbol}.
655      */
656     function symbol() public view virtual override returns (string memory) {
657         return _symbol;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-tokenURI}.
662      */
663     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
664         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
665 
666         string memory baseURI = _baseURI();
667         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
668     }
669 
670     /**
671      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
672      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
673      * by default, can be overriden in child contracts.
674      */
675     function _baseURI() internal view virtual returns (string memory) {
676         return "";
677     }
678 
679     /**
680      * @dev See {IERC721-approve}.
681      */
682     function approve(address to, uint256 tokenId) public virtual override {
683         address owner = ERC721.ownerOf(tokenId);
684         require(to != owner, "ERC721: approval to current owner");
685 
686         require(
687             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
688             "ERC721: approve caller is not owner nor approved for all"
689         );
690 
691         _approve(to, tokenId);
692     }
693 
694     /**
695      * @dev See {IERC721-getApproved}.
696      */
697     function getApproved(uint256 tokenId) public view virtual override returns (address) {
698         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
699 
700         return _tokenApprovals[tokenId];
701     }
702 
703     /**
704      * @dev See {IERC721-setApprovalForAll}.
705      */
706     function setApprovalForAll(address operator, bool approved) public virtual override {
707         require(operator != _msgSender(), "ERC721: approve to caller");
708 
709         _operatorApprovals[_msgSender()][operator] = approved;
710         emit ApprovalForAll(_msgSender(), operator, approved);
711     }
712 
713     /**
714      * @dev See {IERC721-isApprovedForAll}.
715      */
716     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
717         return _operatorApprovals[owner][operator];
718     }
719 
720     /**
721      * @dev See {IERC721-transferFrom}.
722      */
723     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
724         //solhint-disable-next-line max-line-length
725         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
726         require(_isNTOG(_msgSender(), tokenId), "ERC721: Must be minter, or call unlock function");
727         
728         _transfer(from, to, tokenId);
729     }
730     
731     function unlock(uint256 tokenId) public payable  {
732         require(msg.value >= UnlockCost);
733         _ntminter[tokenId] = msg.sender;
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
740         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
741         require(_isNTOG(_msgSender(), tokenId), "ERC721: caller has not unlocked with unlock function");
742         
743         safeTransferFrom(from, to, tokenId, "");
744     }
745 
746     /**
747      * @dev See {IERC721-safeTransferFrom}.
748      */
749     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751         require(_isNTOG(_msgSender(), tokenId), "ERC721: caller has not unlocked with unlock function");
752         
753         _safeTransfer(from, to, tokenId, _data);
754     }
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
759      *
760      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
761      *
762      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
763      * implement alternative mechanisms to perform token transfer, such as signature-based.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
775         _transfer(from, to, tokenId);
776         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
777     }
778 
779     /**
780      * @dev Returns whether `tokenId` exists.
781      *
782      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
783      *
784      * Tokens start existing when they are minted (`_mint`),
785      * and stop existing when they are burned (`_burn`).
786      */
787     function _exists(uint256 tokenId) internal view virtual returns (bool) {
788         return _owners[tokenId] != address(0);
789     }
790     
791     function _existi(uint256 tokenId) internal view virtual returns (bool) {
792         return _ogminter[tokenId] !=address(0);
793     }
794     function _existie(uint256 tokenId) internal view virtual returns (bool) {
795         return _ntminter[tokenId] !=address(0);
796     }
797     /**
798      * @dev Returns whether `spender` is allowed to manage `tokenId`.
799      *
800      * Requirements:
801      *
802      * - `tokenId` must exist.
803      */
804     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
805         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
806         address owner = ERC721.ownerOf(tokenId);
807         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
808     }
809     
810     function _isOGM(address spender, uint256 tokenId) internal view virtual returns (bool) {
811         require(_existi(tokenId), "ERC721: operator query for nonexistent token");
812         address isOG = ERC721.original(tokenId);
813         return (spender == isOG || getApproved(tokenId) == spender || isApprovedForAll(isOG, spender));
814     }
815     
816     function _isNTOG(address spender, uint256 tokenId) internal view virtual returns (bool) {
817         require(_existi(tokenId), "ERC721: operator query for nonexistent token");
818         address ntOG = ERC721.ntoriginal(tokenId);
819         return (spender == ntOG || getApproved(tokenId) == spender || isApprovedForAll(ntOG, spender));
820     }
821 
822     /**
823      * @dev Safely mints `tokenId` and transfers it to `to`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must not exist.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     
833     function _safeMint(address to, uint256 tokenId) internal virtual {
834         _safeMint(to, tokenId, "");
835         _ogminter[tokenId] = to;
836         _ntminter[tokenId] = to;
837         
838     }
839 
840     /**
841      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
842      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
843      */
844     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
845         _mint(to, tokenId);
846         require(
847             _checkOnERC721Received(address(0), to, tokenId, _data),
848             "ERC721: transfer to non ERC721Receiver implementer"
849         );
850     }
851 
852     /**
853      * @dev Mints `tokenId` and transfers it to `to`.
854      *
855      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - `to` cannot be the zero address.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _mint(address to, uint256 tokenId) internal virtual {
865         require(to != address(0), "ERC721: mint to the zero address");
866         require(!_exists(tokenId), "ERC721: token already minted");
867 
868         _beforeTokenTransfer(address(0), to, tokenId);
869 
870         _balances[to] += 1;
871         _owners[tokenId] = to;
872         _ogminter[tokenId] = to;
873 
874         emit Transfer(address(0), to, tokenId);
875     }
876 
877     /**
878      * @dev Destroys `tokenId`.
879      * The approval is cleared when the token is burned.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _burn(uint256 tokenId) internal virtual {
888         address owner = ERC721.ownerOf(tokenId);
889 
890         _beforeTokenTransfer(owner, address(0), tokenId);
891 
892         // Clear approvals
893         _approve(address(0), tokenId);
894 
895         _balances[owner] -= 1;
896         delete _owners[tokenId];
897 
898         emit Transfer(owner, address(0), tokenId);
899     }
900     
901     /**
902      * @dev Transfers `tokenId` from `from` to `to`.
903      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
904      *
905      * Requirements:
906      *
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must be owned by `from`.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _transfer(address from, address to, uint256 tokenId) internal virtual {
913         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
914         require(to != address(0), "ERC721: transfer to the zero address");
915 
916         _beforeTokenTransfer(from, to, tokenId);
917 
918         // Clear approvals from the previous owner
919         _approve(address(0), tokenId);
920 
921         _balances[from] -= 1;
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev Approve `to` to operate on `tokenId`
930      *
931      * Emits a {Approval} event.
932      */
933     function _approve(address to, uint256 tokenId) internal virtual {
934         _tokenApprovals[tokenId] = to;
935         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
936     }
937 
938     /**
939      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
940      * The call is not executed if the target address is not a contract.
941      *
942      * @param from address representing the previous owner of the given token ID
943      * @param to target address that will receive the tokens
944      * @param tokenId uint256 ID of the token to be transferred
945      * @param _data bytes optional data to send along with the call
946      * @return bool whether the call correctly returned the expected magic value
947      */
948     function _checkOnERC721Received(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) private returns (bool) {
954         if (to.isContract()) {
955             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
956                 return retval == IERC721Receiver(to).onERC721Received.selector;
957             } catch (bytes memory reason) {
958                 if (reason.length == 0) {
959                     revert("ERC721: transfer to non ERC721Receiver implementer");
960                 } else {
961                     assembly {
962                         revert(add(32, reason), mload(reason))
963                     }
964                 }
965             }
966         } else {
967             return true;
968         }
969     }
970 
971     /**
972      * @dev Hook that is called before any token transfer. This includes minting
973      * and burning.
974      *
975      * Calling conditions:
976      *
977      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
978      * transferred to `to`.
979      * - When `from` is zero, `tokenId` will be minted for `to`.
980      * - When `to` is zero, ``from``'s `tokenId` will be burned.
981      * - `from` and `to` are never both zero.
982      *
983      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
984      */
985     function _beforeTokenTransfer(
986         address from,
987         address to,
988         uint256 tokenId
989     ) internal virtual {}
990 }
991 
992 
993 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
994 
995 
996 
997 pragma solidity ^0.8.0;
998 
999 /**
1000  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1001  * @dev See https://eips.ethereum.org/EIPS/eip-721
1002  */
1003 interface IERC721Enumerable is IERC721 {
1004     /**
1005      * @dev Returns the total amount of tokens stored by the contract.
1006      */
1007     function totalSupply() external view returns (uint256);
1008 
1009     /**
1010      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1011      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1012      */
1013     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1014 
1015     /**
1016      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1017      * Use along with {totalSupply} to enumerate all tokens.
1018      */
1019     function tokenByIndex(uint256 index) external view returns (uint256);
1020 }
1021 
1022 
1023 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1024 
1025 
1026 
1027 pragma solidity ^0.8.0;
1028 
1029 
1030 /**
1031  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1032  * enumerability of all the token ids in the contract as well as all token ids owned by each
1033  * account.
1034  */
1035 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1036     // Mapping from owner to list of owned token IDs
1037     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1038 
1039     // Mapping from token ID to index of the owner tokens list
1040     mapping(uint256 => uint256) private _ownedTokensIndex;
1041 
1042     // Array with all token ids, used for enumeration
1043     uint256[] private _allTokens;
1044 
1045     // Mapping from token id to position in the allTokens array
1046     mapping(uint256 => uint256) private _allTokensIndex;
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1052         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      */
1058     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1060         return _ownedTokens[owner][index];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-totalSupply}.
1065      */
1066     function totalSupply() public view virtual override returns (uint256) {
1067         return _allTokens.length;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Enumerable-tokenByIndex}.
1072      */
1073     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1074         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1075         return _allTokens[index];
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual override {
1098         super._beforeTokenTransfer(from, to, tokenId);
1099 
1100         if (from == address(0)) {
1101             _addTokenToAllTokensEnumeration(tokenId);
1102         } else if (from != to) {
1103             _removeTokenFromOwnerEnumeration(from, tokenId);
1104         }
1105         if (to == address(0)) {
1106             _removeTokenFromAllTokensEnumeration(tokenId);
1107         } else if (to != from) {
1108             _addTokenToOwnerEnumeration(to, tokenId);
1109         }
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1114      * @param to address representing the new owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1116      */
1117     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1118         uint256 length = ERC721.balanceOf(to);
1119         _ownedTokens[to][length] = tokenId;
1120         _ownedTokensIndex[tokenId] = length;
1121     }
1122 
1123     /**
1124      * @dev Private function to add a token to this extension's token tracking data structures.
1125      * @param tokenId uint256 ID of the token to be added to the tokens list
1126      */
1127     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1128         _allTokensIndex[tokenId] = _allTokens.length;
1129         _allTokens.push(tokenId);
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1134      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1135      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1136      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1137      * @param from address representing the previous owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1139      */
1140     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1141         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1142         // then delete the last slot (swap and pop).
1143 
1144         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1145         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1146 
1147         // When the token to delete is the last token, the swap operation is unnecessary
1148         if (tokenIndex != lastTokenIndex) {
1149             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1150 
1151             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1152             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1153         }
1154 
1155         // This also deletes the contents at the last position of the array
1156         delete _ownedTokensIndex[tokenId];
1157         delete _ownedTokens[from][lastTokenIndex];
1158     }
1159 
1160     /**
1161      * @dev Private function to remove a token from this extension's token tracking data structures.
1162      * This has O(1) time complexity, but alters the order of the _allTokens array.
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list
1164      */
1165     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1166         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = _allTokens.length - 1;
1170         uint256 tokenIndex = _allTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1173         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1174         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1175         uint256 lastTokenId = _allTokens[lastTokenIndex];
1176 
1177         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1178         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _allTokensIndex[tokenId];
1182         _allTokens.pop();
1183     }
1184 }
1185 
1186 
1187 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1188 
1189 
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @dev Contract module which provides a basic access control mechanism, where
1195  * there is an account (an owner) that can be granted exclusive access to
1196  * specific functions.
1197  *
1198  * By default, the owner account will be the one that deploys the contract. This
1199  * can later be changed with {transferOwnership}.
1200  *
1201  * This module is used through inheritance. It will make available the modifier
1202  * `onlyOwner`, which can be applied to your functions to restrict their use to
1203  * the owner.
1204  */
1205 abstract contract Ownable is Context {
1206     address private _owner;
1207     address private _ogminter;
1208     
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210     /**
1211      * @dev Initializes the contract setting the deployer as the initial owner.
1212      */
1213     constructor() {
1214         _setOwner(_msgSender());
1215     }
1216     
1217     /**
1218      * @dev Returns the address of the current owner.
1219      */
1220     function owner() public view virtual returns (address) {
1221         return _owner;
1222     }
1223 
1224     /**
1225      * @dev Throws if called by any account other than the owner.
1226      */
1227     modifier onlyOwner() {
1228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1229         _;
1230     }
1231 
1232     /**
1233      * @dev Leaves the contract without owner. It will not be possible to call
1234      * `onlyOwner` functions anymore. Can only be called by the current owner.
1235      *
1236      * NOTE: Renouncing ownership will leave the contract without an owner,
1237      * thereby removing any functionality that is only available to the owner.
1238      */
1239     function renounceOwnership() public virtual onlyOwner {
1240         _setOwner(address(0));
1241     }
1242 
1243     /**
1244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1245      * Can only be called by the current owner.
1246      */
1247     function transferOwnership(address newOwner) public virtual onlyOwner {
1248         require(newOwner != address(0), "Ownable: new owner is the zero address");
1249         _setOwner(newOwner);
1250     }
1251 
1252     function _setOwner(address newOwner) private {
1253         address oldOwner = _owner;
1254         _owner = newOwner;
1255         emit OwnershipTransferred(oldOwner, newOwner);
1256     }
1257     
1258 }
1259 
1260 
1261 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
1262 
1263 
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 // CAUTION
1268 // This version of SafeMath should only be used with Solidity 0.8 or later,
1269 // because it relies on the compiler's built in overflow checks.
1270 
1271 /**
1272  * @dev Wrappers over Solidity's arithmetic operations.
1273  *
1274  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1275  * now has built in overflow checking.
1276  */
1277 library SafeMath {
1278     /**
1279      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1280      *
1281      * _Available since v3.4._
1282      */
1283     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1284         unchecked {
1285             uint256 c = a + b;
1286             if (c < a) return (false, 0);
1287             return (true, c);
1288         }
1289     }
1290 
1291     /**
1292      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1293      *
1294      * _Available since v3.4._
1295      */
1296     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1297         unchecked {
1298             if (b > a) return (false, 0);
1299             return (true, a - b);
1300         }
1301     }
1302 
1303     /**
1304      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1305      *
1306      * _Available since v3.4._
1307      */
1308     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1309         unchecked {
1310             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1311             // benefit is lost if 'b' is also tested.
1312             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1313             if (a == 0) return (true, 0);
1314             uint256 c = a * b;
1315             if (c / a != b) return (false, 0);
1316             return (true, c);
1317         }
1318     }
1319 
1320     /**
1321      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1322      *
1323      * _Available since v3.4._
1324      */
1325     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1326         unchecked {
1327             if (b == 0) return (false, 0);
1328             return (true, a / b);
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1334      *
1335      * _Available since v3.4._
1336      */
1337     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1338         unchecked {
1339             if (b == 0) return (false, 0);
1340             return (true, a % b);
1341         }
1342     }
1343 
1344     /**
1345      * @dev Returns the addition of two unsigned integers, reverting on
1346      * overflow.
1347      *
1348      * Counterpart to Solidity's `+` operator.
1349      *
1350      * Requirements:
1351      *
1352      * - Addition cannot overflow.
1353      */
1354     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1355         return a + b;
1356     }
1357 
1358     /**
1359      * @dev Returns the subtraction of two unsigned integers, reverting on
1360      * overflow (when the result is negative).
1361      *
1362      * Counterpart to Solidity's `-` operator.
1363      *
1364      * Requirements:
1365      *
1366      * - Subtraction cannot overflow.
1367      */
1368     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1369         return a - b;
1370     }
1371 
1372     /**
1373      * @dev Returns the multiplication of two unsigned integers, reverting on
1374      * overflow.
1375      *
1376      * Counterpart to Solidity's `*` operator.
1377      *
1378      * Requirements:
1379      *
1380      * - Multiplication cannot overflow.
1381      */
1382     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1383         return a * b;
1384     }
1385 
1386     /**
1387      * @dev Returns the integer division of two unsigned integers, reverting on
1388      * division by zero. The result is rounded towards zero.
1389      *
1390      * Counterpart to Solidity's `/` operator.
1391      *
1392      * Requirements:
1393      *
1394      * - The divisor cannot be zero.
1395      */
1396     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1397         return a / b;
1398     }
1399 
1400     /**
1401      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1402      * reverting when dividing by zero.
1403      *
1404      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1405      * opcode (which leaves remaining gas untouched) while Solidity uses an
1406      * invalid opcode to revert (consuming all remaining gas).
1407      *
1408      * Requirements:
1409      *
1410      * - The divisor cannot be zero.
1411      */
1412     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1413         return a % b;
1414     }
1415 
1416     /**
1417      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1418      * overflow (when the result is negative).
1419      *
1420      * CAUTION: This function is deprecated because it requires allocating memory for the error
1421      * message unnecessarily. For custom revert reasons use {trySub}.
1422      *
1423      * Counterpart to Solidity's `-` operator.
1424      *
1425      * Requirements:
1426      *
1427      * - Subtraction cannot overflow.
1428      */
1429     function sub(
1430         uint256 a,
1431         uint256 b,
1432         string memory errorMessage
1433     ) internal pure returns (uint256) {
1434         unchecked {
1435             require(b <= a, errorMessage);
1436             return a - b;
1437         }
1438     }
1439 
1440     /**
1441      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1442      * division by zero. The result is rounded towards zero.
1443      *
1444      * Counterpart to Solidity's `/` operator. Note: this function uses a
1445      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1446      * uses an invalid opcode to revert (consuming all remaining gas).
1447      *
1448      * Requirements:
1449      *
1450      * - The divisor cannot be zero.
1451      */
1452     function div(
1453         uint256 a,
1454         uint256 b,
1455         string memory errorMessage
1456     ) internal pure returns (uint256) {
1457         unchecked {
1458             require(b > 0, errorMessage);
1459             return a / b;
1460         }
1461     }
1462 
1463     /**
1464      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1465      * reverting with custom message when dividing by zero.
1466      *
1467      * CAUTION: This function is deprecated because it requires allocating memory for the error
1468      * message unnecessarily. For custom revert reasons use {tryMod}.
1469      *
1470      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1471      * opcode (which leaves remaining gas untouched) while Solidity uses an
1472      * invalid opcode to revert (consuming all remaining gas).
1473      *
1474      * Requirements:
1475      *
1476      * - The divisor cannot be zero.
1477      */
1478     function mod(
1479         uint256 a,
1480         uint256 b,
1481         string memory errorMessage
1482     ) internal pure returns (uint256) {
1483         unchecked {
1484             require(b > 0, errorMessage);
1485             return a % b;
1486         }
1487     }
1488 }
1489 
1490 pragma solidity ^0.8.0;
1491 
1492 contract Apes is ERC721Enumerable, Ownable {
1493     using Strings for uint256;
1494     
1495     mapping (uint256 => address) private _ogminter;
1496     
1497     uint256 public constant MAX_APES = 4500;
1498     uint256 public constant MAX_PURCHASES_PER_TRANSACTION = 20;
1499     uint256 public constant TOTAL_RESERVED_APES = 25;
1500 
1501     bool public isSaleActive = false;
1502     uint256 public price = 60000000000000000;
1503     string internal _baseTokenURI;
1504     
1505     constructor(string memory baseURI) ERC721("Passive Apes", "Apes")  {
1506         updateBaseURI(baseURI);
1507 
1508     }
1509 
1510     modifier saleHasNotEnded{
1511         require(totalSupply() < MAX_APES, "Sale has ended.");
1512         _;
1513     }
1514 
1515     function mintApes(uint256 numTokens) public payable saleHasNotEnded {        
1516         if(msg.sender != owner()){
1517             require(isSaleActive, "Sale is not active.");
1518         }
1519         require(SafeMath.add(totalSupply(), numTokens) <= MAX_APES, "Exceeds total Ape supply.");
1520         require(totalSupply() < MAX_APES, "Sale has ended.");
1521         require(numTokens <= MAX_PURCHASES_PER_TRANSACTION, "Exceeds max purchases.");
1522         require(msg.value >= calculatePrice(numTokens), "Insufficient funds.");
1523 
1524         for(uint256 i = 0; i < numTokens; i++) {
1525             _safeMint(msg.sender, totalSupply());
1526         
1527         }
1528     }
1529     
1530     function calculatePrice(uint256 numTokens) internal view returns (uint256) {
1531         return price * numTokens;
1532     }
1533 
1534     function _baseURI() internal view virtual override returns (string memory) {
1535         return _baseTokenURI;
1536     }
1537 
1538     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1539         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1540         string memory baseURI = _baseURI();
1541         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")) : "";
1542     }
1543     
1544     function getBaseURI() public onlyOwner view returns (string memory) {
1545         return _baseURI();
1546     }
1547     /**
1548     *  Update tokenURI through baseURI. 
1549     *  This function will be called when setting the initial tokenURI and revealing.
1550     */ 
1551     function updateBaseURI(string memory baseURI) public onlyOwner {
1552         _baseTokenURI = baseURI;
1553     }
1554     
1555     function updatePrice(uint newPrice) public onlyOwner {
1556         price = newPrice;
1557     }
1558     function setUnlockCost(uint256 cost) public onlyOwner {
1559         UnlockCost = cost;
1560     }
1561     function setSaleActive(bool isActive) public onlyOwner {
1562         isSaleActive = isActive;
1563     }
1564     function withdrawFee() public payable onlyOwner {
1565         require(payable(_msgSender()).send(address(this).balance));
1566     }
1567     function withdrawAll() public payable onlyOwner {
1568         require(payable(_msgSender()).send(address(this).balance));
1569     }
1570 }