1 //Wojakians Trade Contract V0.1 Beta Version
2 
3 
4 // SPDX-License-Identifier: MIT
5 
6 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File: @openzeppelin/contracts//token/ERC721/IERC721.sol
33 
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
159 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
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
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
183  * @dev See https://eips.ethereum.org/EIPS/eip-721
184  */
185 interface IERC721Metadata is IERC721 {
186 
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 // File: @openzeppelin/contracts//utils/Address.sol
204 
205 /**
206  * @dev Collection of functions related to the address type
207  */
208 library Address {
209     /**
210      * @dev Returns true if `account` is a contract.
211      *
212      * [IMPORTANT]
213      * ====
214      * It is unsafe to assume that an address for which this function returns
215      * false is an externally-owned account (EOA) and not a contract.
216      *
217      * Among others, `isContract` will return false for the following
218      * types of addresses:
219      *
220      *  - an externally-owned account
221      *  - a contract in construction
222      *  - an address where a contract will be created
223      *  - an address where a contract lived, but was destroyed
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize, which returns 0 for contracts in
228         // construction, since the code is only stored at the end of the
229         // constructor execution.
230 
231         uint256 size;
232         // solhint-disable-next-line no-inline-assembly
233         assembly { size := extcodesize(account) }
234         return size > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
257         (bool success, ) = recipient.call{ value: amount }("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260 
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain`call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
280       return functionCall(target, data, "Address: low-level call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
285      * `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, 0, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but also transferring `value` wei to `target`.
296      *
297      * Requirements:
298      *
299      * - the calling contract must have an ETH balance of at least `value`.
300      * - the called Solidity function must be `payable`.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
310      * with `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
315         require(address(this).balance >= value, "Address: insufficient balance for call");
316         require(isContract(target), "Address: call to non-contract");
317 
318         // solhint-disable-next-line avoid-low-level-calls
319         (bool success, bytes memory returndata) = target.call{ value: value }(data);
320         return _verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
330         return functionStaticCall(target, data, "Address: low-level static call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341 
342         // solhint-disable-next-line avoid-low-level-calls
343         (bool success, bytes memory returndata) = target.staticcall(data);
344         return _verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         require(isContract(target), "Address: delegate call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.delegatecall(data);
368         return _verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 // File: @openzeppelin/contracts//utils/Context.sol
392 
393 /*
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
410         return msg.data;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/utils/Strings.sol
415 
416 /**
417  * @dev String operations.
418  */
419 library Strings {
420     bytes16 private constant alphabet = "0123456789abcdef";
421 
422     /**
423      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
424      */
425     function toString(uint256 value) internal pure returns (string memory) {
426         // Inspired by OraclizeAPI's implementation - MIT licence
427         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
428 
429         if (value == 0) {
430             return "0";
431         }
432         uint256 temp = value;
433         uint256 digits;
434         while (temp != 0) {
435             digits++;
436             temp /= 10;
437         }
438         bytes memory buffer = new bytes(digits);
439         while (value != 0) {
440             digits -= 1;
441             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
442             value /= 10;
443         }
444         return string(buffer);
445     }
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
449      */
450     function toHexString(uint256 value) internal pure returns (string memory) {
451         if (value == 0) {
452             return "0x00";
453         }
454         uint256 temp = value;
455         uint256 length = 0;
456         while (temp != 0) {
457             length++;
458             temp >>= 8;
459         }
460         return toHexString(value, length);
461     }
462 
463     /**
464      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
465      */
466     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
467         bytes memory buffer = new bytes(2 * length + 2);
468         buffer[0] = "0";
469         buffer[1] = "x";
470         for (uint256 i = 2 * length + 1; i > 1; --i) {
471             buffer[i] = alphabet[value & 0xf];
472             value >>= 4;
473         }
474         require(value == 0, "Strings: hex length insufficient");
475         return string(buffer);
476     }
477 
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
481 
482 /**
483  * @dev Implementation of the {IERC165} interface.
484  *
485  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
486  * for the additional interface id that will be supported. For example:
487  *
488  * ```solidity
489  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
491  * }
492  * ```
493  *
494  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
495  */
496 abstract contract ERC165 is IERC165 {
497     /**
498      * @dev See {IERC165-supportsInterface}.
499      */
500     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol"
506 
507 /**
508  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
509  * the Metadata extension, but not including the Enumerable extension, which is available separately as
510  * {ERC721Enumerable}.
511  */
512 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
513     using Address for address;
514     using Strings for uint256;
515 
516     // Token name
517     string private _name;
518 
519     // Token symbol
520     string private _symbol;
521 
522     // Mapping from token ID to owner address
523     mapping (uint256 => address) private _owners;
524 
525     // Mapping owner address to token count
526     mapping (address => uint256) private _balances;
527 
528     // Mapping from token ID to approved address
529     mapping (uint256 => address) private _tokenApprovals;
530 
531     // Mapping from owner to operator approvals
532     mapping (address => mapping (address => bool)) private _operatorApprovals;
533 
534     /**
535      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
536      */
537     constructor (string memory name_, string memory symbol_) {
538         _name = name_;
539         _symbol = symbol_;
540     }
541 
542     /**
543      * @dev See {IERC165-supportsInterface}.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
546         return interfaceId == type(IERC721).interfaceId
547             || interfaceId == type(IERC721Metadata).interfaceId
548             || super.supportsInterface(interfaceId);
549     }
550 
551     /**
552      * @dev See {IERC721-balanceOf}.
553      */
554     function balanceOf(address owner) public view virtual override returns (uint256) {
555         require(owner != address(0), "ERC721: balance query for the zero address");
556         return _balances[owner];
557     }
558 
559     /**
560      * @dev See {IERC721-ownerOf}.
561      */
562     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
563         address owner = _owners[tokenId];
564         require(owner != address(0), "ERC721: owner query for nonexistent token");
565         return owner;
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-name}.
570      */
571     function name() public view virtual override returns (string memory) {
572         return _name;
573     }
574 
575     /**
576      * @dev See {IERC721Metadata-symbol}.
577      */
578     function symbol() public view virtual override returns (string memory) {
579         return _symbol;
580     }
581 
582     /**
583      * @dev See {IERC721Metadata-tokenURI}.
584      */
585     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
586         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
587 
588         string memory baseURI = _baseURI();
589         return bytes(baseURI).length > 0
590             ? string(abi.encodePacked(baseURI, tokenId.toString()))
591             : '';
592     }
593 
594     /**
595      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
596      * in child contracts.
597      */
598     function _baseURI() internal view virtual returns (string memory) {
599         return "";
600     }
601 
602     /**
603      * @dev See {IERC721-approve}.
604      */
605     function approve(address to, uint256 tokenId) public virtual override {
606         address owner = ERC721.ownerOf(tokenId);
607         require(to != owner, "ERC721: approval to current owner");
608 
609         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
610             "ERC721: approve caller is not owner nor approved for all"
611         );
612 
613         _approve(to, tokenId);
614     }
615 
616     /**
617      * @dev See {IERC721-getApproved}.
618      */
619     function getApproved(uint256 tokenId) public view virtual override returns (address) {
620         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
621 
622         return _tokenApprovals[tokenId];
623     }
624 
625     /**
626      * @dev See {IERC721-setApprovalForAll}.
627      */
628     function setApprovalForAll(address operator, bool approved) public virtual override {
629         require(operator != _msgSender(), "ERC721: approve to caller");
630 
631         _operatorApprovals[_msgSender()][operator] = approved;
632         emit ApprovalForAll(_msgSender(), operator, approved);
633     }
634 
635     /**
636      * @dev See {IERC721-isApprovedForAll}.
637      */
638     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
639         return _operatorApprovals[owner][operator];
640     }
641 
642     /**
643      * @dev See {IERC721-transferFrom}.
644      */
645     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
646         //solhint-disable-next-line max-line-length
647         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
648 
649         _transfer(from, to, tokenId);
650     }
651 
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
656         safeTransferFrom(from, to, tokenId, "");
657     }
658 
659     /**
660      * @dev See {IERC721-safeTransferFrom}.
661      */
662     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
663         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
664         _safeTransfer(from, to, tokenId, _data);
665     }
666 
667     /**
668      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
669      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
670      *
671      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
672      *
673      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
674      * implement alternative mechanisms to perform token transfer, such as signature-based.
675      *
676      * Requirements:
677      *
678      * - `from` cannot be the zero address.
679      * - `to` cannot be the zero address.
680      * - `tokenId` token must exist and be owned by `from`.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
686         _transfer(from, to, tokenId);
687         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
688     }
689 
690     /**
691      * @dev Returns whether `tokenId` exists.
692      *
693      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
694      *
695      * Tokens start existing when they are minted (`_mint`),
696      * and stop existing when they are burned (`_burn`).
697      */
698     function _exists(uint256 tokenId) internal view virtual returns (bool) {
699         return _owners[tokenId] != address(0);
700     }
701 
702     /**
703      * @dev Returns whether `spender` is allowed to manage `tokenId`.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
710         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
711         address owner = ERC721.ownerOf(tokenId);
712         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
713     }
714 
715     /**
716      * @dev Safely mints `tokenId` and transfers it to `to`.
717      *
718      * Requirements:
719      *
720      * - `tokenId` must not exist.
721      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
722      *
723      * Emits a {Transfer} event.
724      */
725     function _safeMint(address to, uint256 tokenId) internal virtual {
726         _safeMint(to, tokenId, "");
727     }
728 
729     /**
730      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
731      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
732      */
733     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
734         _mint(to, tokenId);
735         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
736     }
737 
738     /**
739      * @dev Mints `tokenId` and transfers it to `to`.
740      *
741      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
742      *
743      * Requirements:
744      *
745      * - `tokenId` must not exist.
746      * - `to` cannot be the zero address.
747      *
748      * Emits a {Transfer} event.
749      */
750     function _mint(address to, uint256 tokenId) internal virtual {
751         require(to != address(0), "ERC721: mint to the zero address");
752         require(!_exists(tokenId), "ERC721: token already minted");
753 
754         _beforeTokenTransfer(address(0), to, tokenId);
755 
756         _balances[to] += 1;
757         _owners[tokenId] = to;
758 
759         emit Transfer(address(0), to, tokenId);
760     }
761 
762     /**
763      * @dev Destroys `tokenId`.
764      * The approval is cleared when the token is burned.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must exist.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _burn(uint256 tokenId) internal virtual {
773         address owner = ERC721.ownerOf(tokenId);
774 
775         _beforeTokenTransfer(owner, address(0), tokenId);
776 
777         // Clear approvals
778         _approve(address(0), tokenId);
779 
780         _balances[owner] -= 1;
781         delete _owners[tokenId];
782 
783         emit Transfer(owner, address(0), tokenId);
784     }
785 
786     /**
787      * @dev Transfers `tokenId` from `from` to `to`.
788      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
789      *
790      * Requirements:
791      *
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must be owned by `from`.
794      *
795      * Emits a {Transfer} event.
796      */
797     function _transfer(address from, address to, uint256 tokenId) internal virtual {
798         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
799         require(to != address(0), "ERC721: transfer to the zero address");
800 
801         _beforeTokenTransfer(from, to, tokenId);
802 
803         // Clear approvals from the previous owner
804         _approve(address(0), tokenId);
805 
806         _balances[from] -= 1;
807         _balances[to] += 1;
808         _owners[tokenId] = to;
809 
810         emit Transfer(from, to, tokenId);
811     }
812 
813     /**
814      * @dev Approve `to` to operate on `tokenId`
815      *
816      * Emits a {Approval} event.
817      */
818     function _approve(address to, uint256 tokenId) internal virtual {
819         _tokenApprovals[tokenId] = to;
820         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
821     }
822 
823     /**
824      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
825      * The call is not executed if the target address is not a contract.
826      *
827      * @param from address representing the previous owner of the given token ID
828      * @param to target address that will receive the tokens
829      * @param tokenId uint256 ID of the token to be transferred
830      * @param _data bytes optional data to send along with the call
831      * @return bool whether the call correctly returned the expected magic value
832      */
833     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
834         private returns (bool)
835     {
836         if (to.isContract()) {
837             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
838                 return retval == IERC721Receiver(to).onERC721Received.selector;
839             } catch (bytes memory reason) {
840                 if (reason.length == 0) {
841                     revert("ERC721: transfer to non ERC721Receiver implementer");
842                 } else {
843                     // solhint-disable-next-line no-inline-assembly
844                     assembly {
845                         revert(add(32, reason), mload(reason))
846                     }
847                 }
848             }
849         } else {
850             return true;
851         }
852     }
853 
854     /**
855      * @dev Hook that is called before any token transfer. This includes minting
856      * and burning.
857      *
858      * Calling conditions:
859      *
860      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
861      * transferred to `to`.
862      * - When `from` is zero, `tokenId` will be minted for `to`.
863      * - When `to` is zero, ``from``'s `tokenId` will be burned.
864      * - `from` cannot be the zero address.
865      * - `to` cannot be the zero address.
866      *
867      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
868      */
869     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
870 }
871 
872 
873 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
874 
875 /**
876  * @dev ERC721 token with storage based token URI management.
877  */
878 abstract contract ERC721URIStorage is ERC721 {
879     using Strings for uint256;
880 
881     // Optional mapping for token URIs
882     mapping (uint256 => string) private _tokenURIs;
883 
884     /**
885      * @dev See {IERC721Metadata-tokenURI}.
886      */
887     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
888         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
889 
890         string memory _tokenURI = _tokenURIs[tokenId];
891         string memory base = _baseURI();
892 
893         // If there is no base URI, return the token URI.
894         if (bytes(base).length == 0) {
895             return _tokenURI;
896         }
897         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
898         if (bytes(_tokenURI).length > 0) {
899             return string(abi.encodePacked(base, _tokenURI));
900         }
901 
902         return super.tokenURI(tokenId);
903     }
904 
905     /**
906      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
913         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
914         _tokenURIs[tokenId] = _tokenURI;
915     }
916 
917     /**
918      * @dev Destroys `tokenId`.
919      * The approval is cleared when the token is burned.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _burn(uint256 tokenId) internal virtual override {
928         super._burn(tokenId);
929 
930         if (bytes(_tokenURIs[tokenId]).length != 0) {
931             delete _tokenURIs[tokenId];
932         }
933     }
934 }
935 
936 // File: @openzeppelin/contracts//access/Ownable.sol
937 
938 /**
939  * @dev Contract module which provides a basic access control mechanism, where
940  * there is an account (an owner) that can be granted exclusive access to
941  * specific functions.
942  *
943  * By default, the owner account will be the one that deploys the contract. This
944  * can later be changed with {transferOwnership}.
945  *
946  * This module is used through inheritance. It will make available the modifier
947  * `onlyOwner`, which can be applied to your functions to restrict their use to
948  * the owner.
949  */
950 abstract contract Ownable is Context {
951     address private _owner;
952 
953     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
954 
955     /**
956      * @dev Initializes the contract setting the deployer as the initial owner.
957      */
958     constructor () {
959         address msgSender = _msgSender();
960         _owner = msgSender;
961         emit OwnershipTransferred(address(0), msgSender);
962     }
963 
964     /**
965      * @dev Returns the address of the current owner.
966      */
967     function owner() public view virtual returns (address) {
968         return _owner;
969     }
970 
971     /**
972      * @dev Throws if called by any account other than the owner.
973      */
974     modifier onlyOwner() {
975         require(owner() == _msgSender(), "Ownable: caller is not the owner");
976         _;
977     }
978 
979     /**
980      * @dev Leaves the contract without owner. It will not be possible to call
981      * `onlyOwner` functions anymore. Can only be called by the current owner.
982      *
983      * NOTE: Renouncing ownership will leave the contract without an owner,
984      * thereby removing any functionality that is only available to the owner.
985      */
986     function renounceOwnership() public virtual onlyOwner {
987         emit OwnershipTransferred(_owner, address(0));
988         _owner = address(0);
989     }
990 
991     /**
992      * @dev Transfers ownership of the contract to a new account (`newOwner`).
993      * Can only be called by the current owner.
994      */
995     function transferOwnership(address newOwner) public virtual onlyOwner {
996         require(newOwner != address(0), "Ownable: new owner is the zero address");
997         emit OwnershipTransferred(_owner, newOwner);
998         _owner = newOwner;
999     }
1000 }
1001 
1002 // File: @openzeppelin/contracts/utils/Counters.sol
1003 
1004 /**
1005  * @title Counters
1006  * @author Matt Condon (@shrugs)
1007  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1008  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1009  *
1010  * Include with `using Counters for Counters.Counter;`
1011  */
1012 library Counters {
1013     struct Counter {
1014         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1015         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1016         // this feature: see https://github.com/ethereum/solidity/issues/4637
1017         uint256 _value; // default: 0
1018     }
1019 
1020     function current(Counter storage counter) internal view returns (uint256) {
1021         return counter._value;
1022     }
1023 
1024     function increment(Counter storage counter) internal {
1025         unchecked {
1026             counter._value += 1;
1027         }
1028     }
1029 
1030     function decrement(Counter storage counter) internal {
1031         uint256 value = counter._value;
1032         require(value > 0, "Counter: decrement overflow");
1033         unchecked {
1034             counter._value = value - 1;
1035         }
1036     }
1037 }
1038 
1039 // File: contracts/contract.sol
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 /**
1044  * @dev Interface of the ERC20 standard as defined in the EIP.
1045  */
1046 interface IERC20 {
1047     /**
1048      * @dev Returns the amount of tokens in existence.
1049      */
1050     function totalSupply() external view returns (uint256);
1051 
1052     /**
1053      * @dev Returns the amount of tokens owned by `account`.
1054      */
1055     function balanceOf(address account) external view returns (uint256);
1056 
1057     /**
1058      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1059      *
1060      * Returns a boolean value indicating whether the operation succeeded.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function transfer(
1065         address recipient,
1066         uint256 amount
1067     ) external returns (bool);
1068 
1069     /**
1070      * @dev Returns the remaining number of tokens that `spender` will be
1071      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1072      * zero by default.
1073      *
1074      * This value changes when {approve} or {transferFrom} are called.
1075      */
1076     function allowance(
1077         address owner,
1078         address spender
1079     ) external view returns (uint256);
1080 
1081     /**
1082      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1083      *
1084      * Returns a boolean value indicating whether the operation succeeded.
1085      *
1086      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1087      * that someone may use both the old and the new allowance by unfortunate
1088      * transaction ordering. One possible solution to mitigate this race
1089      * condition is to first reduce the spender's allowance to 0 and set the
1090      * desired value afterwards:
1091      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1092      *
1093      * Emits an {Approval} event.
1094      */
1095     function approve(address spender, uint256 amount) external returns (bool);
1096 
1097     /**
1098      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1099      * allowance mechanism. `amount` is then deducted from the caller's
1100      * allowance.
1101      *
1102      * Returns a boolean value indicating whether the operation succeeded.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function transferFrom(
1107         address sender,
1108         address recipient,
1109         uint256 amount
1110     ) external returns (bool);
1111 
1112     /**
1113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1114      * another (`to`).
1115      *
1116      * Note that `value` may be zero.
1117      */
1118     event Transfer(address indexed from, address indexed to, uint256 value);
1119 
1120     /**
1121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1122      * a call to {approve}. `value` is the new allowance.
1123      */
1124     event Approval(
1125         address indexed owner,
1126         address indexed spender,
1127         uint256 value
1128     );
1129 }
1130 
1131 
1132 contract WojakiansTrade is Ownable {
1133 
1134   event BuyEvent(  address indexed from ,uint256 indexed tokenId, uint256 indexed _type );
1135 
1136 
1137      struct Wojakians {
1138         uint token_id;
1139         uint gender;
1140         
1141     }
1142   uint256 public publicSaleCost = 0.01 ether;
1143 
1144     uint256 public publicSaleCostDAI = 5 ether;
1145 
1146  bool public publicSaleActive = true;
1147   bool public publicSaleDAIActive = true;
1148 
1149        mapping(uint256 => Wojakians) public wojakiansGender;
1150         IERC20 public daiInstance;
1151 
1152        uint256 public femaleIndex=0;
1153        uint256 public maleIndex=0;
1154        uint256 public publicIndex=0;
1155 
1156         uint256 public allMale=0;
1157         uint256 public allFemale=0;
1158 
1159 
1160   address public op;
1161 
1162 
1163         address public  wojakiansContract;
1164     constructor() { 
1165      
1166     }
1167 
1168    
1169     
1170    
1171   // Payable for buy
1172 function BuyWithETH(uint countMale, uint countFemale) public payable  {   
1173     require(publicSaleActive, "Public sale is not active");
1174 
1175     // Calculate the total price for the card basket
1176     uint sumAll = countMale + countFemale;
1177     uint256 totalPrice = getPriceEth(sumAll);
1178 
1179     require(countMale > 0 || countFemale > 0, "Please select male or female");
1180 
1181     // Require sufficient funds for the purchase
1182     require(msg.value == totalPrice, "Insufficient funds");
1183 
1184     require(allMale >= countMale, "Not enough male tokens");
1185     require(allFemale >= countFemale, "Not enough female tokens");
1186 
1187     if (countMale > 0){
1188         uint checkMale=1;
1189         while (checkMale <= countMale){
1190 
1191             if (wojakiansGender[maleIndex].gender == 0){
1192                 checkMale++;        
1193                 ERC721(wojakiansContract).approve(msg.sender, wojakiansGender[maleIndex].token_id);
1194                 ERC721(wojakiansContract).safeTransferFrom(address(this), msg.sender, wojakiansGender[maleIndex].token_id);
1195                               emit BuyEvent(msg.sender, wojakiansGender[maleIndex].token_id, 0);
1196 
1197                 allMale--;
1198             }
1199               maleIndex++;
1200         }
1201       
1202     }
1203 
1204      if (countFemale > 0){
1205         uint checkFemale=1;
1206         while (checkFemale <= countFemale){
1207 
1208             if (wojakiansGender[femaleIndex].gender == 1){
1209                 checkFemale++;        
1210                 ERC721(wojakiansContract).approve(msg.sender, wojakiansGender[femaleIndex].token_id);
1211                 ERC721(wojakiansContract).safeTransferFrom(address(this), msg.sender, wojakiansGender[femaleIndex].token_id);
1212                               emit BuyEvent(msg.sender, wojakiansGender[femaleIndex].token_id, 0);
1213 
1214                 allFemale--;
1215             }
1216               femaleIndex++;
1217         }
1218       
1219     }
1220 }
1221 
1222 
1223 
1224 function BuywithDai(uint256 daiAmount , uint countMale ,uint countFemale) external {
1225    
1226 
1227        require(publicSaleDAIActive, "Public sale DAI is not active");
1228 
1229     // Calculate the total price for the card basket
1230     uint sumAll = countMale + countFemale;
1231     uint256 totalPriceDAI = getPriceDAI(sumAll);
1232 
1233     require(countMale > 0 || countFemale > 0, "Please select male or female");
1234 
1235     // Require sufficient funds for the purchase
1236     require(daiAmount == totalPriceDAI, "Insufficient funds");
1237 
1238     require(allMale >= countMale, "Not enough male tokens");
1239     require(allFemale >= countFemale, "Not enough female tokens");
1240 
1241     require(daiInstance.balanceOf(msg.sender) >= daiAmount,"Not Enough Balance");
1242 
1243     bool success = daiInstance.transferFrom(msg.sender, address(this), daiAmount);
1244     require(success, "buy failed");
1245     //
1246 
1247 
1248   
1249     if (countMale > 0){
1250         uint checkMale=1;
1251         while (checkMale <= countMale){
1252  // Male
1253             if (wojakiansGender[maleIndex].gender == 0){
1254                 checkMale++;        
1255                 ERC721(wojakiansContract).approve(msg.sender, wojakiansGender[maleIndex].token_id);
1256                 ERC721(wojakiansContract).safeTransferFrom(address(this), msg.sender, wojakiansGender[maleIndex].token_id);
1257                 emit BuyEvent(msg.sender, wojakiansGender[maleIndex].token_id, 1);
1258 
1259                 allMale--;
1260             }
1261               maleIndex++;
1262         }
1263       
1264     }
1265 
1266      if (countFemale > 0){
1267         uint checkFemale=1;
1268         while (checkFemale <= countFemale){
1269  // FEMale
1270             if (wojakiansGender[femaleIndex].gender == 1){
1271                 checkFemale++;        
1272                 ERC721(wojakiansContract).approve(msg.sender, wojakiansGender[femaleIndex].token_id);
1273                 ERC721(wojakiansContract).safeTransferFrom(address(this), msg.sender, wojakiansGender[femaleIndex].token_id);
1274                               emit BuyEvent(msg.sender, wojakiansGender[femaleIndex].token_id, 1);
1275 
1276                 allFemale--;
1277             }
1278               femaleIndex++;
1279         }
1280       
1281     }
1282     
1283 }
1284 
1285 
1286     //set contract
1287       function setContractAddress(address _contract ) public onlyOwner  {
1288           wojakiansContract=_contract;
1289     }
1290 
1291       function SetDAI(IERC20 _Dai) public onlyOwner {
1292           daiInstance=_Dai;
1293     }
1294 
1295 
1296 function setGender(Wojakians[] memory _data) public  onlyOwner{
1297     for (uint i = 0; i < _data.length; i++) {
1298         wojakiansGender[publicIndex] = Wojakians(_data[i].token_id, _data[i].gender);
1299         publicIndex++;
1300 
1301         if (_data[i].gender == 0) {
1302             allMale++;
1303         } else {
1304             allFemale++;
1305         }
1306     }
1307 }
1308 
1309 
1310   
1311     /**
1312  * @dev transfer the token from the address of this contract  
1313  * to address of the owner 
1314  */
1315   
1316 
1317 function withdrawTokenID(uint256 _token_id) external onlyOwner {
1318   
1319         ERC721(wojakiansContract).approve(msg.sender, _token_id);
1320         ERC721(wojakiansContract).safeTransferFrom(address(this),msg.sender,_token_id);
1321 }
1322 function withdrawTokenIDs(uint256[] memory _token_id) external onlyOwner {
1323      for (uint i = 0; i < _token_id.length; i++) {
1324         ERC721(wojakiansContract).approve(msg.sender, _token_id[i]);
1325         ERC721(wojakiansContract).safeTransferFrom(address(this),msg.sender,_token_id[i]);
1326      }
1327 }
1328 
1329 
1330    function withdraw() public onlyOwner  {
1331         (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
1332         require(os);
1333     }
1334 
1335     function withdrawTokens(IERC20 token) public  onlyOwner {
1336         uint256 balance = token.balanceOf(address(this));
1337         token.transfer(msg.sender, balance);
1338     }
1339 
1340  function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner  {
1341         publicSaleCost = _publicSaleCost;
1342     }
1343 
1344      function setPublicSaleCostDAI(uint256 _dai) public onlyOwner  {
1345         publicSaleCostDAI = _dai;
1346     }
1347 
1348 
1349 //OP - NO OWNER
1350      function setPublicSaleCostOP(uint256 _publicSaleCost) public  {
1351         require(msg.sender == op , "Wrong Op"); 
1352         publicSaleCost = _publicSaleCost;
1353     }
1354     function setPublicSaleCostDAIOP(uint256 _dai) public  {
1355         require(msg.sender == op , "Wrong Op"); 
1356         publicSaleCostDAI = _dai;
1357     }
1358     function setGenderOP(Wojakians[] memory _data) public {
1359           require(msg.sender == op , "Wrong Op"); 
1360     for (uint i = 0; i < _data.length; i++) {
1361         wojakiansGender[publicIndex] = Wojakians(_data[i].token_id, _data[i].gender);
1362         publicIndex++;
1363 
1364         if (_data[i].gender == 0) {
1365             allMale++;
1366         } else {
1367             allFemale++;
1368         }
1369     }
1370 }
1371 
1372 //
1373 
1374     function setFemaleIndex(uint256 _femaleIndex) public onlyOwner  {
1375         femaleIndex = _femaleIndex;
1376     }
1377 
1378       function setMaleIndex(uint256 _maleIndex) public onlyOwner  {
1379         maleIndex = _maleIndex;
1380     }
1381 
1382  function setOpWallet(address _address) public onlyOwner  {
1383         op = _address;
1384     }
1385 
1386 
1387 
1388     //Get Gender
1389  function getGender(uint _index ) public view  returns( uint) {
1390       return wojakiansGender[_index].gender;
1391     }
1392   
1393 function getPriceEth(
1394     uint256 _count
1395    
1396 ) public view returns (uint256) {
1397    
1398 
1399     // Calculate the ETH price using the ratios and the public sale cost
1400     uint256 ethPrice = publicSaleCost * _count;
1401     
1402     // Convert the price to ETH by dividing by 10^18 twice
1403     return ethPrice;
1404 }
1405 
1406 
1407 //Get Price Dai
1408 
1409 function getPriceDAI(
1410     uint256 _count
1411    
1412 ) public view returns (uint256) {
1413    
1414 
1415     // Calculate the ETH price using the ratios and the public sale cost
1416     uint256 daiPrice = publicSaleCostDAI * _count;
1417     
1418     // Convert the price to ETH by dividing by 10^18 twice
1419     return daiPrice;
1420 }
1421 
1422 }