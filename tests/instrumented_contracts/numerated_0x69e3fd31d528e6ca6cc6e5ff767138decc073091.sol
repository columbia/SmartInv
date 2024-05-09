1 // File contracts/@openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 // File contracts/@openzeppelin/contracts/token/ERC721/IERC721.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(address from, address to, uint256 tokenId) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142       * @dev Safely transfers `tokenId` token from `from` to `to`.
143       *
144       * Requirements:
145       *
146       * - `from` cannot be the zero address.
147       * - `to` cannot be the zero address.
148       * - `tokenId` token must exist and be owned by `from`.
149       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151       *
152       * Emits a {Transfer} event.
153       */
154     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
155 }
156 
157 
158 // File contracts/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
159 
160 
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  * from ERC721 asset contracts.
168  */
169 interface IERC721Receiver {
170     /**
171      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
172      * by `operator` from `from`, this function is called.
173      *
174      * It must return its Solidity selector to confirm the token transfer.
175      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
176      *
177      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
178      */
179     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
180 }
181 
182 
183 // File contracts/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Metadata is IERC721 {
194 
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
212 // File contracts/@openzeppelin/contracts/utils/Address.sol
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
245         // solhint-disable-next-line no-inline-assembly
246         assembly { size := extcodesize(account) }
247         return size > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
270         (bool success, ) = recipient.call{ value: amount }("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain`call` is an unsafe replacement for a function call: use this
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
293       return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but also transferring `value` wei to `target`.
309      *
310      * Requirements:
311      *
312      * - the calling contract must have an ETH balance of at least `value`.
313      * - the called Solidity function must be `payable`.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         // solhint-disable-next-line avoid-low-level-calls
332         (bool success, bytes memory returndata) = target.call{ value: value }(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         // solhint-disable-next-line avoid-low-level-calls
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return _verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.delegatecall(data);
381         return _verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 
405 // File contracts/@openzeppelin/contracts/utils/Context.sol
406 
407 
408 
409 pragma solidity ^0.8.0;
410 
411 /*
412  * @dev Provides information about the current execution context, including the
413  * sender of the transaction and its data. While these are generally available
414  * via msg.sender and msg.data, they should not be accessed in such a direct
415  * manner, since when dealing with meta-transactions the account sending and
416  * paying for execution may not be the actual sender (as far as an application
417  * is concerned).
418  *
419  * This contract is only required for intermediate, library-like contracts.
420  */
421 abstract contract Context {
422     function _msgSender() internal view virtual returns (address) {
423         return msg.sender;
424     }
425 
426     function _msgData() internal view virtual returns (bytes calldata) {
427         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
428         return msg.data;
429     }
430 }
431 
432 
433 // File contracts/@openzeppelin/contracts/utils/Strings.sol
434 
435 
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev String operations.
441  */
442 library Strings {
443     bytes16 private constant alphabet = "0123456789abcdef";
444 
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
447      */
448     function toString(uint256 value) internal pure returns (string memory) {
449         // Inspired by OraclizeAPI's implementation - MIT licence
450         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
451 
452         if (value == 0) {
453             return "0";
454         }
455         uint256 temp = value;
456         uint256 digits;
457         while (temp != 0) {
458             digits++;
459             temp /= 10;
460         }
461         bytes memory buffer = new bytes(digits);
462         while (value != 0) {
463             digits -= 1;
464             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
465             value /= 10;
466         }
467         return string(buffer);
468     }
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
472      */
473     function toHexString(uint256 value) internal pure returns (string memory) {
474         if (value == 0) {
475             return "0x00";
476         }
477         uint256 temp = value;
478         uint256 length = 0;
479         while (temp != 0) {
480             length++;
481             temp >>= 8;
482         }
483         return toHexString(value, length);
484     }
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
488      */
489     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
490         bytes memory buffer = new bytes(2 * length + 2);
491         buffer[0] = "0";
492         buffer[1] = "x";
493         for (uint256 i = 2 * length + 1; i > 1; --i) {
494             buffer[i] = alphabet[value & 0xf];
495             value >>= 4;
496         }
497         require(value == 0, "Strings: hex length insufficient");
498         return string(buffer);
499     }
500 
501 }
502 
503 
504 // File contracts/@openzeppelin/contracts/utils/introspection/ERC165.sol
505 
506 
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Implementation of the {IERC165} interface.
512  *
513  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
514  * for the additional interface id that will be supported. For example:
515  *
516  * ```solidity
517  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
519  * }
520  * ```
521  *
522  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
523  */
524 abstract contract ERC165 is IERC165 {
525     /**
526      * @dev See {IERC165-supportsInterface}.
527      */
528     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
529         return interfaceId == type(IERC165).interfaceId;
530     }
531 }
532 
533 
534 // File contracts/@openzeppelin/contracts/token/ERC721/ERC721.sol
535 
536 
537 
538 pragma solidity ^0.8.0;
539 
540 
541 
542 
543 
544 
545 
546 /**
547  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
548  * the Metadata extension, but not including the Enumerable extension, which is available separately as
549  * {ERC721Enumerable}.
550  */
551 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
552     using Address for address;
553     using Strings for uint256;
554 
555     // Token name
556     string private _name;
557 
558     // Token symbol
559     string private _symbol;
560 
561     // Mapping from token ID to owner address
562     mapping (uint256 => address) private _owners;
563 
564     // Mapping owner address to token count
565     mapping (address => uint256) private _balances;
566 
567     // Mapping from token ID to approved address
568     mapping (uint256 => address) private _tokenApprovals;
569 
570     // Mapping from owner to operator approvals
571     mapping (address => mapping (address => bool)) private _operatorApprovals;
572 
573     /**
574      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
575      */
576     constructor (string memory name_, string memory symbol_) {
577         _name = name_;
578         _symbol = symbol_;
579     }
580 
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
585         return interfaceId == type(IERC721).interfaceId
586             || interfaceId == type(IERC721Metadata).interfaceId
587             || super.supportsInterface(interfaceId);
588     }
589 
590     /**
591      * @dev See {IERC721-balanceOf}.
592      */
593     function balanceOf(address owner) public view virtual override returns (uint256) {
594         require(owner != address(0), "ERC721: balance query for the zero address");
595         return _balances[owner];
596     }
597 
598     /**
599      * @dev See {IERC721-ownerOf}.
600      */
601     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
602         address owner = _owners[tokenId];
603         require(owner != address(0), "ERC721: owner query for nonexistent token");
604         return owner;
605     }
606 
607     /**
608      * @dev See {IERC721Metadata-name}.
609      */
610     function name() public view virtual override returns (string memory) {
611         return _name;
612     }
613 
614     /**
615      * @dev See {IERC721Metadata-symbol}.
616      */
617     function symbol() public view virtual override returns (string memory) {
618         return _symbol;
619     }
620 
621     /**
622      * @dev See {IERC721Metadata-tokenURI}.
623      */
624     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
625         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
626 
627         string memory baseURI = _baseURI();
628         return bytes(baseURI).length > 0
629             ? string(abi.encodePacked(baseURI, tokenId.toString()))
630             : '';
631     }
632 
633     /**
634      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
635      * in child contracts.
636      */
637     function _baseURI() internal view virtual returns (string memory) {
638         return "";
639     }
640 
641     /**
642      * @dev See {IERC721-approve}.
643      */
644     function approve(address to, uint256 tokenId) public virtual override {
645         address owner = ERC721.ownerOf(tokenId);
646         require(to != owner, "ERC721: approval to current owner");
647 
648         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
649             "ERC721: approve caller is not owner nor approved for all"
650         );
651 
652         _approve(to, tokenId);
653     }
654 
655     /**
656      * @dev See {IERC721-getApproved}.
657      */
658     function getApproved(uint256 tokenId) public view virtual override returns (address) {
659         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
660 
661         return _tokenApprovals[tokenId];
662     }
663 
664     /**
665      * @dev See {IERC721-setApprovalForAll}.
666      */
667     function setApprovalForAll(address operator, bool approved) public virtual override {
668         require(operator != _msgSender(), "ERC721: approve to caller");
669 
670         _operatorApprovals[_msgSender()][operator] = approved;
671         emit ApprovalForAll(_msgSender(), operator, approved);
672     }
673 
674     /**
675      * @dev See {IERC721-isApprovedForAll}.
676      */
677     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
678         return _operatorApprovals[owner][operator];
679     }
680 
681     /**
682      * @dev See {IERC721-transferFrom}.
683      */
684     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
685         //solhint-disable-next-line max-line-length
686         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
687 
688         _transfer(from, to, tokenId);
689     }
690 
691     /**
692      * @dev See {IERC721-safeTransferFrom}.
693      */
694     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
695         safeTransferFrom(from, to, tokenId, "");
696     }
697 
698     /**
699      * @dev See {IERC721-safeTransferFrom}.
700      */
701     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
702         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
703         _safeTransfer(from, to, tokenId, _data);
704     }
705 
706     /**
707      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
708      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
709      *
710      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
711      *
712      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
713      * implement alternative mechanisms to perform token transfer, such as signature-based.
714      *
715      * Requirements:
716      *
717      * - `from` cannot be the zero address.
718      * - `to` cannot be the zero address.
719      * - `tokenId` token must exist and be owned by `from`.
720      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
721      *
722      * Emits a {Transfer} event.
723      */
724     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
725         _transfer(from, to, tokenId);
726         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
727     }
728 
729     /**
730      * @dev Returns whether `tokenId` exists.
731      *
732      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
733      *
734      * Tokens start existing when they are minted (`_mint`),
735      * and stop existing when they are burned (`_burn`).
736      */
737     function _exists(uint256 tokenId) internal view virtual returns (bool) {
738         return _owners[tokenId] != address(0);
739     }
740 
741     /**
742      * @dev Returns whether `spender` is allowed to manage `tokenId`.
743      *
744      * Requirements:
745      *
746      * - `tokenId` must exist.
747      */
748     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
749         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
750         address owner = ERC721.ownerOf(tokenId);
751         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
752     }
753 
754     /**
755      * @dev Safely mints `tokenId` and transfers it to `to`.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must not exist.
760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _safeMint(address to, uint256 tokenId) internal virtual {
765         _safeMint(to, tokenId, "");
766     }
767 
768     /**
769      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
770      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
771      */
772     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
773         _mint(to, tokenId);
774         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
775     }
776 
777     /**
778      * @dev Mints `tokenId` and transfers it to `to`.
779      *
780      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
781      *
782      * Requirements:
783      *
784      * - `tokenId` must not exist.
785      * - `to` cannot be the zero address.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _mint(address to, uint256 tokenId) internal virtual {
790         require(to != address(0), "ERC721: mint to the zero address");
791         require(!_exists(tokenId), "ERC721: token already minted");
792 
793         _beforeTokenTransfer(address(0), to, tokenId);
794 
795         _balances[to] += 1;
796         _owners[tokenId] = to;
797 
798         emit Transfer(address(0), to, tokenId);
799     }
800 
801     /**
802      * @dev Destroys `tokenId`.
803      * The approval is cleared when the token is burned.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _burn(uint256 tokenId) internal virtual {
812         address owner = ERC721.ownerOf(tokenId);
813 
814         _beforeTokenTransfer(owner, address(0), tokenId);
815 
816         // Clear approvals
817         _approve(address(0), tokenId);
818 
819         _balances[owner] -= 1;
820         delete _owners[tokenId];
821 
822         emit Transfer(owner, address(0), tokenId);
823     }
824 
825     /**
826      * @dev Transfers `tokenId` from `from` to `to`.
827      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
828      *
829      * Requirements:
830      *
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must be owned by `from`.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _transfer(address from, address to, uint256 tokenId) internal virtual {
837         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
838         require(to != address(0), "ERC721: transfer to the zero address");
839 
840         _beforeTokenTransfer(from, to, tokenId);
841 
842         // Clear approvals from the previous owner
843         _approve(address(0), tokenId);
844 
845         _balances[from] -= 1;
846         _balances[to] += 1;
847         _owners[tokenId] = to;
848 
849         emit Transfer(from, to, tokenId);
850     }
851 
852     /**
853      * @dev Approve `to` to operate on `tokenId`
854      *
855      * Emits a {Approval} event.
856      */
857     function _approve(address to, uint256 tokenId) internal virtual {
858         _tokenApprovals[tokenId] = to;
859         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
860     }
861 
862     /**
863      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
864      * The call is not executed if the target address is not a contract.
865      *
866      * @param from address representing the previous owner of the given token ID
867      * @param to target address that will receive the tokens
868      * @param tokenId uint256 ID of the token to be transferred
869      * @param _data bytes optional data to send along with the call
870      * @return bool whether the call correctly returned the expected magic value
871      */
872     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
873         private returns (bool)
874     {
875         if (to.isContract()) {
876             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
877                 return retval == IERC721Receiver(to).onERC721Received.selector;
878             } catch (bytes memory reason) {
879                 if (reason.length == 0) {
880                     revert("ERC721: transfer to non ERC721Receiver implementer");
881                 } else {
882                     // solhint-disable-next-line no-inline-assembly
883                     assembly {
884                         revert(add(32, reason), mload(reason))
885                     }
886                 }
887             }
888         } else {
889             return true;
890         }
891     }
892 
893     /**
894      * @dev Hook that is called before any token transfer. This includes minting
895      * and burning.
896      *
897      * Calling conditions:
898      *
899      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
900      * transferred to `to`.
901      * - When `from` is zero, `tokenId` will be minted for `to`.
902      * - When `to` is zero, ``from``'s `tokenId` will be burned.
903      * - `from` cannot be the zero address.
904      * - `to` cannot be the zero address.
905      *
906      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
907      */
908     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
909 }
910 
911 
912 // File contracts/@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
913 
914 
915 
916 pragma solidity ^0.8.0;
917 
918 /**
919  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
920  * @dev See https://eips.ethereum.org/EIPS/eip-721
921  */
922 interface IERC721Enumerable is IERC721 {
923 
924     /**
925      * @dev Returns the total amount of tokens stored by the contract.
926      */
927     function totalSupply() external view returns (uint256);
928 
929     /**
930      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
931      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
932      */
933     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
934 
935     /**
936      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
937      * Use along with {totalSupply} to enumerate all tokens.
938      */
939     function tokenByIndex(uint256 index) external view returns (uint256);
940 }
941 
942 
943 // File contracts/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
944 
945 
946 
947 pragma solidity ^0.8.0;
948 
949 
950 /**
951  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
952  * enumerability of all the token ids in the contract as well as all token ids owned by each
953  * account.
954  */
955 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
956     // Mapping from owner to list of owned token IDs
957     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
958 
959     // Mapping from token ID to index of the owner tokens list
960     mapping(uint256 => uint256) private _ownedTokensIndex;
961 
962     // Array with all token ids, used for enumeration
963     uint256[] private _allTokens;
964 
965     // Mapping from token id to position in the allTokens array
966     mapping(uint256 => uint256) private _allTokensIndex;
967 
968     /**
969      * @dev See {IERC165-supportsInterface}.
970      */
971     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
972         return interfaceId == type(IERC721Enumerable).interfaceId
973             || super.supportsInterface(interfaceId);
974     }
975 
976     /**
977      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
978      */
979     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
980         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
981         return _ownedTokens[owner][index];
982     }
983 
984     /**
985      * @dev See {IERC721Enumerable-totalSupply}.
986      */
987     function totalSupply() public view virtual override returns (uint256) {
988         return _allTokens.length;
989     }
990 
991     /**
992      * @dev See {IERC721Enumerable-tokenByIndex}.
993      */
994     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
995         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
996         return _allTokens[index];
997     }
998 
999     /**
1000      * @dev Hook that is called before any token transfer. This includes minting
1001      * and burning.
1002      *
1003      * Calling conditions:
1004      *
1005      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1006      * transferred to `to`.
1007      * - When `from` is zero, `tokenId` will be minted for `to`.
1008      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1009      * - `from` cannot be the zero address.
1010      * - `to` cannot be the zero address.
1011      *
1012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1013      */
1014     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1015         super._beforeTokenTransfer(from, to, tokenId);
1016 
1017         if (from == address(0)) {
1018             _addTokenToAllTokensEnumeration(tokenId);
1019         } else if (from != to) {
1020             _removeTokenFromOwnerEnumeration(from, tokenId);
1021         }
1022         if (to == address(0)) {
1023             _removeTokenFromAllTokensEnumeration(tokenId);
1024         } else if (to != from) {
1025             _addTokenToOwnerEnumeration(to, tokenId);
1026         }
1027     }
1028 
1029     /**
1030      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1031      * @param to address representing the new owner of the given token ID
1032      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1033      */
1034     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1035         uint256 length = ERC721.balanceOf(to);
1036         _ownedTokens[to][length] = tokenId;
1037         _ownedTokensIndex[tokenId] = length;
1038     }
1039 
1040     /**
1041      * @dev Private function to add a token to this extension's token tracking data structures.
1042      * @param tokenId uint256 ID of the token to be added to the tokens list
1043      */
1044     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1045         _allTokensIndex[tokenId] = _allTokens.length;
1046         _allTokens.push(tokenId);
1047     }
1048 
1049     /**
1050      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1051      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1052      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1053      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1054      * @param from address representing the previous owner of the given token ID
1055      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1056      */
1057     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1058         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1059         // then delete the last slot (swap and pop).
1060 
1061         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1062         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1063 
1064         // When the token to delete is the last token, the swap operation is unnecessary
1065         if (tokenIndex != lastTokenIndex) {
1066             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1067 
1068             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1069             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1070         }
1071 
1072         // This also deletes the contents at the last position of the array
1073         delete _ownedTokensIndex[tokenId];
1074         delete _ownedTokens[from][lastTokenIndex];
1075     }
1076 
1077     /**
1078      * @dev Private function to remove a token from this extension's token tracking data structures.
1079      * This has O(1) time complexity, but alters the order of the _allTokens array.
1080      * @param tokenId uint256 ID of the token to be removed from the tokens list
1081      */
1082     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1083         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1084         // then delete the last slot (swap and pop).
1085 
1086         uint256 lastTokenIndex = _allTokens.length - 1;
1087         uint256 tokenIndex = _allTokensIndex[tokenId];
1088 
1089         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1090         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1091         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1092         uint256 lastTokenId = _allTokens[lastTokenIndex];
1093 
1094         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1095         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1096 
1097         // This also deletes the contents at the last position of the array
1098         delete _allTokensIndex[tokenId];
1099         _allTokens.pop();
1100     }
1101 }
1102 
1103 
1104 // File contracts/@openzeppelin/contracts/utils/Counters.sol
1105 
1106 
1107 
1108 pragma solidity ^0.8.0;
1109 
1110 /**
1111  * @title Counters
1112  * @author Matt Condon (@shrugs)
1113  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1114  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1115  *
1116  * Include with `using Counters for Counters.Counter;`
1117  */
1118 library Counters {
1119     struct Counter {
1120         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1121         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1122         // this feature: see https://github.com/ethereum/solidity/issues/4637
1123         uint256 _value; // default: 0
1124     }
1125 
1126     function current(Counter storage counter) internal view returns (uint256) {
1127         return counter._value;
1128     }
1129 
1130     function increment(Counter storage counter) internal {
1131         unchecked {
1132             counter._value += 1;
1133         }
1134     }
1135 
1136     function decrement(Counter storage counter) internal {
1137         uint256 value = counter._value;
1138         require(value > 0, "Counter: decrement overflow");
1139         unchecked {
1140             counter._value = value - 1;
1141         }
1142     }
1143 }
1144 
1145 
1146 // File contracts/@openzeppelin/contracts/access/Ownable.sol
1147 
1148 
1149 
1150 pragma solidity ^0.8.0;
1151 
1152 /**
1153  * @dev Contract module which provides a basic access control mechanism, where
1154  * there is an account (an owner) that can be granted exclusive access to
1155  * specific functions.
1156  *
1157  * By default, the owner account will be the one that deploys the contract. This
1158  * can later be changed with {transferOwnership}.
1159  *
1160  * This module is used through inheritance. It will make available the modifier
1161  * `onlyOwner`, which can be applied to your functions to restrict their use to
1162  * the owner.
1163  */
1164 abstract contract Ownable is Context {
1165     address private _owner;
1166 
1167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1168 
1169     /**
1170      * @dev Initializes the contract setting the deployer as the initial owner.
1171      */
1172     constructor () {
1173         address msgSender = _msgSender();
1174         _owner = msgSender;
1175         emit OwnershipTransferred(address(0), msgSender);
1176     }
1177 
1178     /**
1179      * @dev Returns the address of the current owner.
1180      */
1181     function owner() public view virtual returns (address) {
1182         return _owner;
1183     }
1184 
1185     /**
1186      * @dev Throws if called by any account other than the owner.
1187      */
1188     modifier onlyOwner() {
1189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1190         _;
1191     }
1192 
1193     /**
1194      * @dev Leaves the contract without owner. It will not be possible to call
1195      * `onlyOwner` functions anymore. Can only be called by the current owner.
1196      *
1197      * NOTE: Renouncing ownership will leave the contract without an owner,
1198      * thereby removing any functionality that is only available to the owner.
1199      */
1200     function renounceOwnership() public virtual onlyOwner {
1201         emit OwnershipTransferred(_owner, address(0));
1202         _owner = address(0);
1203     }
1204 
1205     /**
1206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1207      * Can only be called by the current owner.
1208      */
1209     function transferOwnership(address newOwner) public virtual onlyOwner {
1210         require(newOwner != address(0), "Ownable: new owner is the zero address");
1211         emit OwnershipTransferred(_owner, newOwner);
1212         _owner = newOwner;
1213     }
1214 }
1215 
1216 
1217 // File contracts/final.sol
1218 
1219 //SPDX-License-Identifier: MIT
1220 pragma solidity ^0.8.0;
1221 
1222 interface IERC20 {
1223 
1224 
1225     /**
1226     * @dev Returns the decimals.
1227     */
1228     function decimals() external view returns (uint256);
1229 
1230     /**
1231     * @dev Returns the totalSupply
1232     */
1233     function totalSupply() external view returns (uint256);
1234 
1235     /**
1236     * @dev Returns the amount of tokens owned by `account`.
1237     */
1238     function balanceOf(address account) external view returns (uint256);
1239 
1240     /**
1241         * @dev Moves `amount` tokens from the caller's account to `recipient`.
1242         *
1243         * Returns a boolean value indicating whether the operation succeeded.
1244         *
1245         * Emits a {Transfer} event.
1246         */
1247     function transfer(address recipient, uint256 amount) external returns (bool);
1248 
1249     /**
1250         * @dev Returns the remaining number of tokens that `spender` will be
1251         * allowed to spend on behalf of `owner` through {transferFrom}. This is
1252         * zero by default.
1253         *
1254         * This value changes when {approve} or {transferFrom} are called.
1255         */
1256     function allowance(address owner, address spender) external view returns (uint256);
1257 
1258     /**
1259         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1260         *
1261         * Returns a boolean value indicating whether the operation succeeded.
1262         *
1263         * IMPORTANT: Beware that changing an allowance with this method brings the risk
1264         * that someone may use both the old and the new allowance by unfortunate
1265         * transaction ordering. One possible solution to mitigate this race
1266         * condition is to first reduce the spender's allowance to 0 and set the
1267         * desired value afterwards:
1268         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1269         *
1270         * Emits an {Approval} event.
1271         */
1272     function approve(address spender, uint256 amount) external returns (bool);
1273 
1274     /**
1275         * @dev Moves `amount` tokens from `sender` to `recipient` using the
1276         * allowance mechanism. `amount` is then deducted from the caller's
1277         * allowance.
1278         *
1279         * Returns a boolean value indicating whether the operation succeeded.
1280         *
1281         * Emits a {Transfer} event.
1282         */
1283     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1284 
1285     /**
1286         * @dev Emitted when `value` tokens are moved from one account (`from`) to
1287         * another (`to`).
1288         *
1289         * Note that `value` may be zero.
1290         */
1291     event Transfer(address indexed from, address indexed to, uint256 value);
1292 
1293     /**
1294         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1295         * a call to {approve}. `value` is the new allowance.
1296         */
1297     event Approval(address indexed owner, address indexed spender, uint256 value);
1298 }
1299 
1300 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1301 
1302 
1303 
1304 pragma solidity 0.8.6;
1305 
1306 
1307 
1308 
1309 /**
1310  * @title SafeERC20
1311  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1312  * contract returns false). Tokens that return no value (and instead revert or
1313  * throw on failure) are also supported, non-reverting calls are assumed to be
1314  * successful.
1315  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1316  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1317  */
1318 library SafeERC20 {
1319     using SafeMath for uint256;
1320     using Address for address;
1321 
1322     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1323         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1324     }
1325 
1326     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1327         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1328     }
1329 
1330     /**
1331      * @dev Deprecated. This function has issues similar to the ones found in
1332      * {IERC20-approve}, and its usage is discouraged.
1333      *
1334      * Whenever possible, use {safeIncreaseAllowance} and
1335      * {safeDecreaseAllowance} instead.
1336      */
1337     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1338         // safeApprove should only be called when setting an initial allowance,
1339         // or when resetting it to zero. To increase and decrease it, use
1340         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1341         // solhint-disable-next-line max-line-length
1342         require((value == 0) || (token.allowance(address(this), spender) == 0),
1343             "SafeERC20: approve from non-zero to non-zero allowance"
1344         );
1345         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1346     }
1347 
1348     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1349         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1350         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1351     }
1352 
1353 /*
1354     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1355         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1356         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1357     }*/
1358 
1359     /**
1360      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1361      * on the return value: the return value is optional (but if data is returned, it must not be false).
1362      * @param token The token targeted by the call.
1363      * @param data The call data (encoded using abi.encode or one of its variants).
1364      */
1365     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1366         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1367         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1368         // the target address contains contract code and also asserts for success in the low-level call.
1369 
1370         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1371         if (returndata.length > 0) { // Return data is optional
1372             // solhint-disable-next-line max-line-length
1373             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1374         }
1375     }
1376 }
1377 
1378 
1379 interface IUniswapV2Pair {
1380     function factory() external view returns (address);
1381     function token0() external view returns (address);
1382     function token1() external view returns (address);
1383     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1384 }
1385 
1386 contract ShiryoinuAvatarsNFT is ERC721Enumerable, Ownable{
1387     using SafeMath for uint256;
1388     using Counters for Counters.Counter;
1389     using SafeERC20 for IERC20;
1390 
1391     modifier onlyClevel() {
1392         require(msg.sender == walletA || msg.sender == walletB || msg.sender == owner());
1393     _;
1394     }
1395 
1396     Counters.Counter private _tokenIds;
1397 
1398     address walletA;
1399     address walletB;
1400     uint256 walletBPercentage = 15;
1401 
1402     uint256 public phaseEndsAt = 10000;
1403 
1404     uint256 public mintPriceEth = 0.015 ether;
1405 
1406     IERC20 public shiryoToken;
1407 
1408     string private _baseTokenURI;
1409 
1410     event minting(uint256 id, address indexed customer);
1411 
1412     constructor(IERC20 _shiryoToken, address _walletA, address _walletB) ERC721("ShiryoinuAvatar", "ShiryoinuAvatar") {
1413         _baseTokenURI = "https://api.avatars.shiryoinu.com/";
1414         walletA = _walletA;
1415         walletB = _walletB;
1416         shiryoToken = _shiryoToken;
1417     }
1418 
1419     function _baseURI() internal view virtual override returns (string memory) {
1420         return _baseTokenURI;
1421     }
1422 
1423     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1424         uint256 tokenCount = balanceOf(_owner);
1425         if (tokenCount == 0) {
1426             // Return an empty array
1427             return new uint256[](0);
1428         } else {
1429             uint256[] memory result = new uint256[](tokenCount);
1430             uint256 index;
1431             for (index = 0; index < tokenCount; index++) {
1432                 result[index] = tokenOfOwnerByIndex(_owner, index);
1433             }
1434             return result;
1435         }
1436     }
1437     
1438 
1439     function mint_avatars_for_eth(uint256 _amount) public payable returns (uint256[] memory minted)  {
1440         require(_tokenIds.current() < phaseEndsAt, "Minting Phase Ended");
1441         require(_amount>0, "NFT: Invalid amount to mint.");
1442         require(msg.value==_amount*mintPriceEth , "NFT: Invalid value.");
1443 
1444         uint256[] memory tokensMinted;
1445         for (uint256 i = 0; i < _amount; i++) {
1446             _tokenIds.increment();
1447             uint256 newPack = _tokenIds.current();
1448             _mint(msg.sender, newPack);
1449           
1450             emit minting(newPack, msg.sender);
1451         }
1452         return tokensMinted;
1453     }
1454     
1455     
1456     // calculate price based on pair reserves
1457     // shiryo is token 0
1458     function getTokensForEth(uint _amountETH) public view returns(uint256){
1459         
1460         IUniswapV2Pair pair = IUniswapV2Pair(0xe6e1F4F9b0303Ca3878A110061C0Ec9b84fddD03);
1461         IERC20 token0 = IERC20(pair.token0());
1462         (uint Res0, uint Res1,) = pair.getReserves();
1463         
1464         // decimals
1465         uint res1 = Res1*(10**token0.decimals());
1466         uint ethPrice = ((10e18*res1)/Res0); // return amount of token1 needed to buy token0
1467         uint amountTokens = (_amountETH*10e18)/ethPrice;
1468         return amountTokens; 
1469     }
1470 
1471 
1472     function mint_avatars_for_shiryo(uint256 _amount) public payable returns (uint256[] memory minted)  {
1473         require(_tokenIds.current() < phaseEndsAt, "Minting Phase Ended");
1474         require(_amount>0, "NFT: Invalid amount to mint.");
1475 
1476         uint256 numTokensNeeded= getTokensForEth(_amount*mintPriceEth);
1477         require(shiryoToken.balanceOf(msg.sender)>=numTokensNeeded, "Insufficient token balance.");
1478         shiryoToken.safeTransferFrom(msg.sender, address(this) , numTokensNeeded);
1479         
1480         uint256[] memory tokensMinted;
1481         for (uint256 i = 0; i < _amount; i++) {
1482             _tokenIds.increment();
1483             uint256 newPack = _tokenIds.current();
1484             _mint(msg.sender, newPack);
1485           
1486             emit minting(newPack, msg.sender);
1487         }
1488         return tokensMinted;
1489     }
1490 
1491 
1492     function setEthMintPrice(uint256 _priceEth) public onlyOwner {
1493          mintPriceEth =_priceEth;
1494     }
1495 
1496     function withdraw_all() public onlyClevel {
1497         
1498         if(address(this).balance>0){
1499             uint256 amountEthB = SafeMath.div(address(this).balance,100).mul(walletBPercentage);
1500             uint256 amountEthA = address(this).balance.sub(amountEthB);
1501             payable(walletA).transfer(amountEthA);
1502             payable(walletB).transfer(amountEthB);
1503         }
1504 
1505         // for buy back and burning
1506         uint256 tokenBalance = shiryoToken.balanceOf(address(this));
1507         if (tokenBalance>0){
1508             shiryoToken.safeTransfer(walletA, tokenBalance);
1509         }
1510         
1511     }
1512 
1513     function setWalletA(address _walletA) public {
1514         require (msg.sender == walletA, "Who are you?");
1515         require (_walletA != address(0x0), "Invalid wallet");
1516         walletA = _walletA;
1517     }
1518 
1519     function setWalletB(address _walletB) public {
1520         require (msg.sender == walletB, "Who are you?");
1521         require (_walletB != address(0x0), "Invalid wallet.");
1522         walletB = _walletB;
1523     }
1524 
1525     function setWalletBPercentage(uint256 _percentage) public onlyOwner{
1526         require (_percentage>walletBPercentage && _percentage<=100, "Invalid new slice.");
1527         walletBPercentage = _percentage;
1528     }
1529     
1530     function setPhaseEndsAt(uint256 _phaseEnds) public onlyOwner{
1531         phaseEndsAt = _phaseEnds;
1532     }
1533 
1534 }
1535 
1536 
1537 library SafeMath {
1538 
1539     /**
1540     * @dev Multiplies two numbers, throws on overflow.
1541     */
1542     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1543         if (a == 0) {
1544             return 0;
1545         }
1546         uint256 c = a * b;
1547         assert(c / a == b);
1548         return c;
1549     }
1550 
1551     /**
1552     * @dev Integer division of two numbers, truncating the quotient.
1553     */
1554     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1555         // assert(b > 0); // Solidity automatically throws when dividing by 0
1556         uint256 c = a / b;
1557         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1558         return c;
1559     }
1560 
1561     /**
1562     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1563     */
1564     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1565         assert(b <= a);
1566         return a - b;
1567     }
1568 
1569     /**
1570     * @dev Adds two numbers, throws on overflow.
1571     */
1572     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1573         uint256 c = a + b;
1574         assert(c >= a);
1575         return c;
1576     }
1577 
1578 }