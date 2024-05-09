1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-29
3 */
4 
5 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(address from, address to, uint256 tokenId) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address from, address to, uint256 tokenId) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145       * @dev Safely transfers `tokenId` token from `from` to `to`.
146       *
147       * Requirements:
148       *
149       * - `from` cannot be the zero address.
150       * - `to` cannot be the zero address.
151       * - `tokenId` token must exist and be owned by `from`.
152       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154       *
155       * Emits a {Transfer} event.
156       */
157     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
158 }
159 
160 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
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
182 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
183 
184 pragma solidity ^0.8.0;
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
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Collection of functions related to the address type
214  */
215 library Address {
216     /**
217      * @dev Returns true if `account` is a contract.
218      *
219      * [IMPORTANT]
220      * ====
221      * It is unsafe to assume that an address for which this function returns
222      * false is an externally-owned account (EOA) and not a contract.
223      *
224      * Among others, `isContract` will return false for the following
225      * types of addresses:
226      *
227      *  - an externally-owned account
228      *  - a contract in construction
229      *  - an address where a contract will be created
230      *  - an address where a contract lived, but was destroyed
231      * ====
232      */
233     function isContract(address account) internal view returns (bool) {
234         // This method relies on extcodesize, which returns 0 for contracts in
235         // construction, since the code is only stored at the end of the
236         // constructor execution.
237 
238         uint256 size;
239         // solhint-disable-next-line no-inline-assembly
240         assembly { size := extcodesize(account) }
241         return size > 0;
242     }
243 
244     /**
245      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
246      * `recipient`, forwarding all available gas and reverting on errors.
247      *
248      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
249      * of certain opcodes, possibly making contracts go over the 2300 gas limit
250      * imposed by `transfer`, making them unable to receive funds via
251      * `transfer`. {sendValue} removes this limitation.
252      *
253      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
254      *
255      * IMPORTANT: because control is transferred to `recipient`, care must be
256      * taken to not create reentrancy vulnerabilities. Consider using
257      * {ReentrancyGuard} or the
258      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
259      */
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
264         (bool success, ) = recipient.call{ value: amount }("");
265         require(success, "Address: unable to send value, recipient may have reverted");
266     }
267 
268     /**
269      * @dev Performs a Solidity function call using a low level `call`. A
270      * plain`call` is an unsafe replacement for a function call: use this
271      * function instead.
272      *
273      * If `target` reverts with a revert reason, it is bubbled up by this
274      * function (like regular Solidity function calls).
275      *
276      * Returns the raw returned data. To convert to the expected return value,
277      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
278      *
279      * Requirements:
280      *
281      * - `target` must be a contract.
282      * - calling `target` with `data` must not revert.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
287       return functionCall(target, data, "Address: low-level call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
292      * `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, 0, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but also transferring `value` wei to `target`.
303      *
304      * Requirements:
305      *
306      * - the calling contract must have an ETH balance of at least `value`.
307      * - the called Solidity function must be `payable`.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
322         require(address(this).balance >= value, "Address: insufficient balance for call");
323         require(isContract(target), "Address: call to non-contract");
324 
325         // solhint-disable-next-line avoid-low-level-calls
326         (bool success, bytes memory returndata) = target.call{ value: value }(data);
327         return _verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
337         return functionStaticCall(target, data, "Address: low-level static call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
347         require(isContract(target), "Address: static call to non-contract");
348 
349         // solhint-disable-next-line avoid-low-level-calls
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return _verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
371         require(isContract(target), "Address: delegate call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return _verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/utils/Context.sol
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
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @dev String operations.
429  */
430 library Strings {
431     bytes16 private constant alphabet = "0123456789abcdef";
432 
433     /**
434      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
435      */
436     function toString(uint256 value) internal pure returns (string memory) {
437         // Inspired by OraclizeAPI's implementation - MIT licence
438         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
439 
440         if (value == 0) {
441             return "0";
442         }
443         uint256 temp = value;
444         uint256 digits;
445         while (temp != 0) {
446             digits++;
447             temp /= 10;
448         }
449         bytes memory buffer = new bytes(digits);
450         while (value != 0) {
451             digits -= 1;
452             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
453             value /= 10;
454         }
455         return string(buffer);
456     }
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
460      */
461     function toHexString(uint256 value) internal pure returns (string memory) {
462         if (value == 0) {
463             return "0x00";
464         }
465         uint256 temp = value;
466         uint256 length = 0;
467         while (temp != 0) {
468             length++;
469             temp >>= 8;
470         }
471         return toHexString(value, length);
472     }
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
476      */
477     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
478         bytes memory buffer = new bytes(2 * length + 2);
479         buffer[0] = "0";
480         buffer[1] = "x";
481         for (uint256 i = 2 * length + 1; i > 1; --i) {
482             buffer[i] = alphabet[value & 0xf];
483             value >>= 4;
484         }
485         require(value == 0, "Strings: hex length insufficient");
486         return string(buffer);
487     }
488 
489 }
490 
491 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Implementation of the {IERC165} interface.
497  *
498  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
499  * for the additional interface id that will be supported. For example:
500  *
501  * ```solidity
502  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
503  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
504  * }
505  * ```
506  *
507  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
508  */
509 abstract contract ERC165 is IERC165 {
510     /**
511      * @dev See {IERC165-supportsInterface}.
512      */
513     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514         return interfaceId == type(IERC165).interfaceId;
515     }
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
524  * the Metadata extension, but not including the Enumerable extension, which is available separately as
525  * {ERC721Enumerable}.
526  */
527 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
528     using Address for address;
529     using Strings for uint256;
530 
531     // Token name
532     string private _name;
533 
534     // Token symbol
535     string private _symbol;
536 
537     // Mapping from token ID to owner address
538     mapping (uint256 => address) private _owners;
539 
540     // Mapping owner address to token count
541     mapping (address => uint256) private _balances;
542 
543     // Mapping from token ID to approved address
544     mapping (uint256 => address) private _tokenApprovals;
545 
546     // Mapping from owner to operator approvals
547     mapping (address => mapping (address => bool)) private _operatorApprovals;
548 
549     /**
550      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
551      */
552     constructor (string memory name_, string memory symbol_) {
553         _name = name_;
554         _symbol = symbol_;
555     }
556 
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
561         return interfaceId == type(IERC721).interfaceId
562             || interfaceId == type(IERC721Metadata).interfaceId
563             || super.supportsInterface(interfaceId);
564     }
565 
566     /**
567      * @dev See {IERC721-balanceOf}.
568      */
569     function balanceOf(address owner) public view virtual override returns (uint256) {
570         require(owner != address(0), "ERC721: balance query for the zero address");
571         return _balances[owner];
572     }
573 
574     /**
575      * @dev See {IERC721-ownerOf}.
576      */
577     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
578         address owner = _owners[tokenId];
579         require(owner != address(0), "ERC721: owner query for nonexistent token");
580         return owner;
581     }
582 
583     /**
584      * @dev See {IERC721Metadata-name}.
585      */
586     function name() public view virtual override returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev See {IERC721Metadata-symbol}.
592      */
593     function symbol() public view virtual override returns (string memory) {
594         return _symbol;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-tokenURI}.
599      */
600     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
601         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
602 
603         string memory baseURI = _baseURI();
604         return bytes(baseURI).length > 0
605             ? string(abi.encodePacked(baseURI, tokenId.toString()))
606             : '';
607     }
608 
609     /**
610      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
611      * in child contracts.
612      */
613     function _baseURI() internal view virtual returns (string memory) {
614         return "";
615     }
616 
617     /**
618      * @dev See {IERC721-approve}.
619      */
620     function approve(address to, uint256 tokenId) public virtual override {
621         address owner = ERC721.ownerOf(tokenId);
622         require(to != owner, "ERC721: approval to current owner");
623 
624         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
625             "ERC721: approve caller is not owner nor approved for all"
626         );
627 
628         _approve(to, tokenId);
629     }
630 
631     /**
632      * @dev See {IERC721-getApproved}.
633      */
634     function getApproved(uint256 tokenId) public view virtual override returns (address) {
635         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
636 
637         return _tokenApprovals[tokenId];
638     }
639 
640     /**
641      * @dev See {IERC721-setApprovalForAll}.
642      */
643     function setApprovalForAll(address operator, bool approved) public virtual override {
644         require(operator != _msgSender(), "ERC721: approve to caller");
645 
646         _operatorApprovals[_msgSender()][operator] = approved;
647         emit ApprovalForAll(_msgSender(), operator, approved);
648     }
649 
650     /**
651      * @dev See {IERC721-isApprovedForAll}.
652      */
653     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
654         return _operatorApprovals[owner][operator];
655     }
656 
657     /**
658      * @dev See {IERC721-transferFrom}.
659      */
660     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
661         //solhint-disable-next-line max-line-length
662         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
663 
664         _transfer(from, to, tokenId);
665     }
666 
667     /**
668      * @dev See {IERC721-safeTransferFrom}.
669      */
670     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
671         safeTransferFrom(from, to, tokenId, "");
672     }
673 
674     /**
675      * @dev See {IERC721-safeTransferFrom}.
676      */
677     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
678         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
679         _safeTransfer(from, to, tokenId, _data);
680     }
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
684      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
685      *
686      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
687      *
688      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
689      * implement alternative mechanisms to perform token transfer, such as signature-based.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
697      *
698      * Emits a {Transfer} event.
699      */
700     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
701         _transfer(from, to, tokenId);
702         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
703     }
704 
705     /**
706      * @dev Returns whether `tokenId` exists.
707      *
708      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
709      *
710      * Tokens start existing when they are minted (`_mint`),
711      * and stop existing when they are burned (`_burn`).
712      */
713     function _exists(uint256 tokenId) internal view virtual returns (bool) {
714         return _owners[tokenId] != address(0);
715     }
716 
717     /**
718      * @dev Returns whether `spender` is allowed to manage `tokenId`.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
725         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
726         address owner = ERC721.ownerOf(tokenId);
727         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
728     }
729 
730     /**
731      * @dev Safely mints `tokenId` and transfers it to `to`.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must not exist.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _safeMint(address to, uint256 tokenId) internal virtual {
741         _safeMint(to, tokenId, "");
742     }
743 
744     /**
745      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
746      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
747      */
748     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
749         _mint(to, tokenId);
750         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
751     }
752 
753     /**
754      * @dev Mints `tokenId` and transfers it to `to`.
755      *
756      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
757      *
758      * Requirements:
759      *
760      * - `tokenId` must not exist.
761      * - `to` cannot be the zero address.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _mint(address to, uint256 tokenId) internal virtual {
766         require(to != address(0), "ERC721: mint to the zero address");
767         require(!_exists(tokenId), "ERC721: token already minted");
768 
769         _beforeTokenTransfer(address(0), to, tokenId);
770 
771         _balances[to] += 1;
772         _owners[tokenId] = to;
773 
774         emit Transfer(address(0), to, tokenId);
775     }
776 
777     /**
778      * @dev Destroys `tokenId`.
779      * The approval is cleared when the token is burned.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _burn(uint256 tokenId) internal virtual {
788         address owner = ERC721.ownerOf(tokenId);
789 
790         _beforeTokenTransfer(owner, address(0), tokenId);
791 
792         // Clear approvals
793         _approve(address(0), tokenId);
794 
795         _balances[owner] -= 1;
796         delete _owners[tokenId];
797 
798         emit Transfer(owner, address(0), tokenId);
799     }
800 
801     /**
802      * @dev Transfers `tokenId` from `from` to `to`.
803      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
804      *
805      * Requirements:
806      *
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must be owned by `from`.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _transfer(address from, address to, uint256 tokenId) internal virtual {
813         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
814         require(to != address(0), "ERC721: transfer to the zero address");
815 
816         _beforeTokenTransfer(from, to, tokenId);
817 
818         // Clear approvals from the previous owner
819         _approve(address(0), tokenId);
820 
821         _balances[from] -= 1;
822         _balances[to] += 1;
823         _owners[tokenId] = to;
824 
825         emit Transfer(from, to, tokenId);
826     }
827 
828     /**
829      * @dev Approve `to` to operate on `tokenId`
830      *
831      * Emits a {Approval} event.
832      */
833     function _approve(address to, uint256 tokenId) internal virtual {
834         _tokenApprovals[tokenId] = to;
835         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
836     }
837 
838     /**
839      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
840      * The call is not executed if the target address is not a contract.
841      *
842      * @param from address representing the previous owner of the given token ID
843      * @param to target address that will receive the tokens
844      * @param tokenId uint256 ID of the token to be transferred
845      * @param _data bytes optional data to send along with the call
846      * @return bool whether the call correctly returned the expected magic value
847      */
848     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
849         private returns (bool)
850     {
851         if (to.isContract()) {
852             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
853                 return retval == IERC721Receiver(to).onERC721Received.selector;
854             } catch (bytes memory reason) {
855                 if (reason.length == 0) {
856                     revert("ERC721: transfer to non ERC721Receiver implementer");
857                 } else {
858                     // solhint-disable-next-line no-inline-assembly
859                     assembly {
860                         revert(add(32, reason), mload(reason))
861                     }
862                 }
863             }
864         } else {
865             return true;
866         }
867     }
868 
869     /**
870      * @dev Hook that is called before any token transfer. This includes minting
871      * and burning.
872      *
873      * Calling conditions:
874      *
875      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
876      * transferred to `to`.
877      * - When `from` is zero, `tokenId` will be minted for `to`.
878      * - When `to` is zero, ``from``'s `tokenId` will be burned.
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      *
882      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
883      */
884     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
885 }
886 
887 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
888 
889 pragma solidity ^0.8.0;
890 
891 /**
892  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
893  * @dev See https://eips.ethereum.org/EIPS/eip-721
894  */
895 interface IERC721Enumerable is IERC721 {
896 
897     /**
898      * @dev Returns the total amount of tokens stored by the contract.
899      */
900     function totalSupply() external view returns (uint256);
901 
902     /**
903      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
904      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
905      */
906     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
907 
908     /**
909      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
910      * Use along with {totalSupply} to enumerate all tokens.
911      */
912     function tokenByIndex(uint256 index) external view returns (uint256);
913 }
914 
915 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
916 
917 pragma solidity ^0.8.0;
918 
919 /**
920  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
921  * enumerability of all the token ids in the contract as well as all token ids owned by each
922  * account.
923  */
924 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
925     // Mapping from owner to list of owned token IDs
926     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
927 
928     // Mapping from token ID to index of the owner tokens list
929     mapping(uint256 => uint256) private _ownedTokensIndex;
930 
931     // Array with all token ids, used for enumeration
932     uint256[] private _allTokens;
933 
934     // Mapping from token id to position in the allTokens array
935     mapping(uint256 => uint256) private _allTokensIndex;
936 
937     /**
938      * @dev See {IERC165-supportsInterface}.
939      */
940     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
941         return interfaceId == type(IERC721Enumerable).interfaceId
942             || super.supportsInterface(interfaceId);
943     }
944 
945     /**
946      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
947      */
948     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
949         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
950         return _ownedTokens[owner][index];
951     }
952 
953     /**
954      * @dev See {IERC721Enumerable-totalSupply}.
955      */
956     function totalSupply() public view virtual override returns (uint256) {
957         return _allTokens.length;
958     }
959 
960     /**
961      * @dev See {IERC721Enumerable-tokenByIndex}.
962      */
963     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
964         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
965         return _allTokens[index];
966     }
967 
968     /**
969      * @dev Hook that is called before any token transfer. This includes minting
970      * and burning.
971      *
972      * Calling conditions:
973      *
974      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
975      * transferred to `to`.
976      * - When `from` is zero, `tokenId` will be minted for `to`.
977      * - When `to` is zero, ``from``'s `tokenId` will be burned.
978      * - `from` cannot be the zero address.
979      * - `to` cannot be the zero address.
980      *
981      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
982      */
983     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
984         super._beforeTokenTransfer(from, to, tokenId);
985 
986         if (from == address(0)) {
987             _addTokenToAllTokensEnumeration(tokenId);
988         } else if (from != to) {
989             _removeTokenFromOwnerEnumeration(from, tokenId);
990         }
991         if (to == address(0)) {
992             _removeTokenFromAllTokensEnumeration(tokenId);
993         } else if (to != from) {
994             _addTokenToOwnerEnumeration(to, tokenId);
995         }
996     }
997 
998     /**
999      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1000      * @param to address representing the new owner of the given token ID
1001      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1002      */
1003     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1004         uint256 length = ERC721.balanceOf(to);
1005         _ownedTokens[to][length] = tokenId;
1006         _ownedTokensIndex[tokenId] = length;
1007     }
1008 
1009     /**
1010      * @dev Private function to add a token to this extension's token tracking data structures.
1011      * @param tokenId uint256 ID of the token to be added to the tokens list
1012      */
1013     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1014         _allTokensIndex[tokenId] = _allTokens.length;
1015         _allTokens.push(tokenId);
1016     }
1017 
1018     /**
1019      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1020      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1021      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1022      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1023      * @param from address representing the previous owner of the given token ID
1024      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1025      */
1026     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1027         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1028         // then delete the last slot (swap and pop).
1029 
1030         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1031         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1032 
1033         // When the token to delete is the last token, the swap operation is unnecessary
1034         if (tokenIndex != lastTokenIndex) {
1035             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1036 
1037             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1038             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1039         }
1040 
1041         // This also deletes the contents at the last position of the array
1042         delete _ownedTokensIndex[tokenId];
1043         delete _ownedTokens[from][lastTokenIndex];
1044     }
1045 
1046     /**
1047      * @dev Private function to remove a token from this extension's token tracking data structures.
1048      * This has O(1) time complexity, but alters the order of the _allTokens array.
1049      * @param tokenId uint256 ID of the token to be removed from the tokens list
1050      */
1051     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1052         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1053         // then delete the last slot (swap and pop).
1054 
1055         uint256 lastTokenIndex = _allTokens.length - 1;
1056         uint256 tokenIndex = _allTokensIndex[tokenId];
1057 
1058         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1059         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1060         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1061         uint256 lastTokenId = _allTokens[lastTokenIndex];
1062 
1063         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1064         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1065 
1066         // This also deletes the contents at the last position of the array
1067         delete _allTokensIndex[tokenId];
1068         _allTokens.pop();
1069     }
1070 }
1071 
1072 // File: @openzeppelin/contracts/access/Ownable.sol
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 /**
1077  * @dev Contract module which provides a basic access control mechanism, where
1078  * there is an account (an owner) that can be granted exclusive access to
1079  * specific functions.
1080  *
1081  * By default, the owner account will be the one that deploys the contract. This
1082  * can later be changed with {transferOwnership}.
1083  *
1084  * This module is used through inheritance. It will make available the modifier
1085  * `onlyOwner`, which can be applied to your functions to restrict their use to
1086  * the owner.
1087  */
1088 abstract contract Ownable is Context {
1089     address private _owner;
1090 
1091     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1092 
1093     /**
1094      * @dev Initializes the contract setting the deployer as the initial owner.
1095      */
1096     constructor () {
1097         address msgSender = _msgSender();
1098         _owner = msgSender;
1099         emit OwnershipTransferred(address(0), msgSender);
1100     }
1101 
1102     /**
1103      * @dev Returns the address of the current owner.
1104      */
1105     function owner() public view virtual returns (address) {
1106         return _owner;
1107     }
1108 
1109     /**
1110      * @dev Throws if called by any account other than the owner.
1111      */
1112     modifier onlyOwner() {
1113         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1114         _;
1115     }
1116 
1117     /**
1118      * @dev Leaves the contract without owner. It will not be possible to call
1119      * `onlyOwner` functions anymore. Can only be called by the current owner.
1120      *
1121      * NOTE: Renouncing ownership will leave the contract without an owner,
1122      * thereby removing any functionality that is only available to the owner.
1123      */
1124     function renounceOwnership() public virtual onlyOwner {
1125         emit OwnershipTransferred(_owner, address(0));
1126         _owner = address(0);
1127     }
1128 
1129     /**
1130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1131      * Can only be called by the current owner.
1132      */
1133     function transferOwnership(address newOwner) public virtual onlyOwner {
1134         require(newOwner != address(0), "Ownable: new owner is the zero address");
1135         emit OwnershipTransferred(_owner, newOwner);
1136         _owner = newOwner;
1137     }
1138 }
1139 
1140 // File: contracts/WickedStallions.sol
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 abstract contract SRSC {
1145   function ownerOf(uint256 tokenId) public virtual view returns (address);
1146   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1147   function balanceOf(address owner) external virtual view returns (uint256 balance);
1148 }
1149 
1150 contract SRSCCheddaz is ERC721Enumerable, Ownable {  
1151   
1152   SRSC private srsc = SRSC(0xd21a23606D2746f086f6528Cd6873bAD3307b903); 
1153   bool public saleIsActive = false;
1154   uint256 public maxCheddaz = 8888;
1155   string private baseURI;
1156 
1157   constructor() ERC721("Cheddaz", "CHEDDAZ") {
1158   }
1159 
1160   function isMinted(uint256 tokenId) external view returns (bool) {
1161     require(tokenId < maxCheddaz, "tokenId outside collection bounds");
1162     return _exists(tokenId);
1163   }
1164 
1165   function _baseURI() internal view override returns (string memory) {
1166     return baseURI;
1167   }
1168   
1169   function setBaseURI(string memory uri) public onlyOwner {
1170     baseURI = uri;
1171   }
1172 
1173   function flipSaleState() public onlyOwner {
1174     saleIsActive = !saleIsActive;
1175   }
1176 
1177   function mintCheddaz(uint256 startingIndex, uint256 totalCheddazToMint) public {
1178     require(saleIsActive, "Sale must be active to mint a Chedda");
1179     require(totalCheddazToMint > 0, "Must mint at least one Chedda");
1180     uint balance = srsc.balanceOf(msg.sender);
1181     require(balance > 0, "Must hold at least one Rat to mint a Chedda");
1182     require(balance >= totalCheddazToMint, "Must hold at least as many Rats as the number of Cheddaz you intend to mint");
1183     require(balance >= startingIndex + totalCheddazToMint, "Must hold at least as many Rats as the number of Cheddaz you intend to mint");
1184 
1185     for(uint i = 0; i < balance && i < totalCheddazToMint; i++) {
1186       require(totalSupply() < maxCheddaz, "Cannot exceed max supply of Cheddaz");
1187       uint tokenId = srsc.tokenOfOwnerByIndex(msg.sender, i + startingIndex);
1188       if (!_exists(tokenId)) {
1189         _safeMint(msg.sender, tokenId);
1190       }
1191     }
1192   }
1193 }