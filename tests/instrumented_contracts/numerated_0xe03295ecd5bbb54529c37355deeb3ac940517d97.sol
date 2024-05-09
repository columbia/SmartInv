1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-30
3 */
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
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 pragma solidity ^0.8.0;
31 
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
157 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
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
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Metadata is IERC721 {
189 
190     /**
191      * @dev Returns the token collection name.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the token collection symbol.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
202      */
203     function tokenURI(uint256 tokenId) external view returns (string memory);
204 }
205 
206 // File: @openzeppelin/contracts/utils/Address.sol
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
398 pragma solidity ^0.8.0;
399 
400 /*
401  * @dev Provides information about the current execution context, including the
402  * sender of the transaction and its data. While these are generally available
403  * via msg.sender and msg.data, they should not be accessed in such a direct
404  * manner, since when dealing with meta-transactions the account sending and
405  * paying for execution may not be the actual sender (as far as an application
406  * is concerned).
407  *
408  * This contract is only required for intermediate, library-like contracts.
409  */
410 abstract contract Context {
411     function _msgSender() internal view virtual returns (address) {
412         return msg.sender;
413     }
414 
415     function _msgData() internal view virtual returns (bytes calldata) {
416         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
417         return msg.data;
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/Strings.sol
422 
423 
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
495 
496 /**
497  * @dev Implementation of the {IERC165} interface.
498  *
499  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
500  * for the additional interface id that will be supported. For example:
501  *
502  * ```solidity
503  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
505  * }
506  * ```
507  *
508  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
509  */
510 abstract contract ERC165 is IERC165 {
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         return interfaceId == type(IERC165).interfaceId;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
525  * the Metadata extension, but not including the Enumerable extension, which is available separately as
526  * {ERC721Enumerable}.
527  */
528 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
529     using Address for address;
530     using Strings for uint256;
531 
532     // Token name
533     string private _name;
534 
535     // Token symbol
536     string private _symbol;
537 
538     // Mapping from token ID to owner address
539     mapping (uint256 => address) private _owners;
540 
541     // Mapping owner address to token count
542     mapping (address => uint256) private _balances;
543 
544     // Mapping from token ID to approved address
545     mapping (uint256 => address) private _tokenApprovals;
546 
547     // Mapping from owner to operator approvals
548     mapping (address => mapping (address => bool)) private _operatorApprovals;
549 
550     /**
551      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
552      */
553     constructor (string memory name_, string memory symbol_) {
554         _name = name_;
555         _symbol = symbol_;
556     }
557 
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
562         return interfaceId == type(IERC721).interfaceId
563             || interfaceId == type(IERC721Metadata).interfaceId
564             || super.supportsInterface(interfaceId);
565     }
566 
567     /**
568      * @dev See {IERC721-balanceOf}.
569      */
570     function balanceOf(address owner) public view virtual override returns (uint256) {
571         require(owner != address(0), "ERC721: balance query for the zero address");
572         return _balances[owner];
573     }
574 
575     /**
576      * @dev See {IERC721-ownerOf}.
577      */
578     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
579         address owner = _owners[tokenId];
580         require(owner != address(0), "ERC721: owner query for nonexistent token");
581         return owner;
582     }
583 
584     /**
585      * @dev See {IERC721Metadata-name}.
586      */
587     function name() public view virtual override returns (string memory) {
588         return _name;
589     }
590 
591     /**
592      * @dev See {IERC721Metadata-symbol}.
593      */
594     function symbol() public view virtual override returns (string memory) {
595         return _symbol;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-tokenURI}.
600      */
601     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
602         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
603 
604         string memory baseURI = _baseURI();
605         return bytes(baseURI).length > 0
606             ? string(abi.encodePacked(baseURI, tokenId.toString()))
607             : '';
608     }
609 
610     /**
611      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
612      * in child contracts.
613      */
614     function _baseURI() internal view virtual returns (string memory) {
615         return "";
616     }
617 
618     /**
619      * @dev See {IERC721-approve}.
620      */
621     function approve(address to, uint256 tokenId) public virtual override {
622         address owner = ERC721.ownerOf(tokenId);
623         require(to != owner, "ERC721: approval to current owner");
624 
625         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
626             "ERC721: approve caller is not owner nor approved for all"
627         );
628 
629         _approve(to, tokenId);
630     }
631 
632     /**
633      * @dev See {IERC721-getApproved}.
634      */
635     function getApproved(uint256 tokenId) public view virtual override returns (address) {
636         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
637 
638         return _tokenApprovals[tokenId];
639     }
640 
641     /**
642      * @dev See {IERC721-setApprovalForAll}.
643      */
644     function setApprovalForAll(address operator, bool approved) public virtual override {
645         require(operator != _msgSender(), "ERC721: approve to caller");
646 
647         _operatorApprovals[_msgSender()][operator] = approved;
648         emit ApprovalForAll(_msgSender(), operator, approved);
649     }
650 
651     /**
652      * @dev See {IERC721-isApprovedForAll}.
653      */
654     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
655         return _operatorApprovals[owner][operator];
656     }
657 
658     /**
659      * @dev See {IERC721-transferFrom}.
660      */
661     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
662         //solhint-disable-next-line max-line-length
663         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
664 
665         _transfer(from, to, tokenId);
666     }
667 
668     /**
669      * @dev See {IERC721-safeTransferFrom}.
670      */
671     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
672         safeTransferFrom(from, to, tokenId, "");
673     }
674 
675     /**
676      * @dev See {IERC721-safeTransferFrom}.
677      */
678     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
679         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
680         _safeTransfer(from, to, tokenId, _data);
681     }
682 
683     /**
684      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
685      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
686      *
687      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
688      *
689      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
690      * implement alternative mechanisms to perform token transfer, such as signature-based.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must exist and be owned by `from`.
697      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
702         _transfer(from, to, tokenId);
703         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
704     }
705 
706     /**
707      * @dev Returns whether `tokenId` exists.
708      *
709      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
710      *
711      * Tokens start existing when they are minted (`_mint`),
712      * and stop existing when they are burned (`_burn`).
713      */
714     function _exists(uint256 tokenId) internal view virtual returns (bool) {
715         return _owners[tokenId] != address(0);
716     }
717 
718     /**
719      * @dev Returns whether `spender` is allowed to manage `tokenId`.
720      *
721      * Requirements:
722      *
723      * - `tokenId` must exist.
724      */
725     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
726         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
727         address owner = ERC721.ownerOf(tokenId);
728         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
729     }
730 
731     /**
732      * @dev Safely mints `tokenId` and transfers it to `to`.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must not exist.
737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
738      *
739      * Emits a {Transfer} event.
740      */
741     function _safeMint(address to, uint256 tokenId) internal virtual {
742         _safeMint(to, tokenId, "");
743     }
744 
745     /**
746      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
747      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
748      */
749     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
750         _mint(to, tokenId);
751         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
752     }
753 
754     /**
755      * @dev Mints `tokenId` and transfers it to `to`.
756      *
757      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
758      *
759      * Requirements:
760      *
761      * - `tokenId` must not exist.
762      * - `to` cannot be the zero address.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _mint(address to, uint256 tokenId) internal virtual {
767         require(to != address(0), "ERC721: mint to the zero address");
768         require(!_exists(tokenId), "ERC721: token already minted");
769 
770         _beforeTokenTransfer(address(0), to, tokenId);
771 
772         _balances[to] += 1;
773         _owners[tokenId] = to;
774 
775         emit Transfer(address(0), to, tokenId);
776     }
777 
778     /**
779      * @dev Destroys `tokenId`.
780      * The approval is cleared when the token is burned.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _burn(uint256 tokenId) internal virtual {
789         address owner = ERC721.ownerOf(tokenId);
790 
791         _beforeTokenTransfer(owner, address(0), tokenId);
792 
793         // Clear approvals
794         _approve(address(0), tokenId);
795 
796         _balances[owner] -= 1;
797         delete _owners[tokenId];
798 
799         emit Transfer(owner, address(0), tokenId);
800     }
801 
802     /**
803      * @dev Transfers `tokenId` from `from` to `to`.
804      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
805      *
806      * Requirements:
807      *
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must be owned by `from`.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _transfer(address from, address to, uint256 tokenId) internal virtual {
814         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
815         require(to != address(0), "ERC721: transfer to the zero address");
816 
817         _beforeTokenTransfer(from, to, tokenId);
818 
819         // Clear approvals from the previous owner
820         _approve(address(0), tokenId);
821 
822         _balances[from] -= 1;
823         _balances[to] += 1;
824         _owners[tokenId] = to;
825 
826         emit Transfer(from, to, tokenId);
827     }
828 
829     /**
830      * @dev Approve `to` to operate on `tokenId`
831      *
832      * Emits a {Approval} event.
833      */
834     function _approve(address to, uint256 tokenId) internal virtual {
835         _tokenApprovals[tokenId] = to;
836         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
837     }
838 
839     /**
840      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
841      * The call is not executed if the target address is not a contract.
842      *
843      * @param from address representing the previous owner of the given token ID
844      * @param to target address that will receive the tokens
845      * @param tokenId uint256 ID of the token to be transferred
846      * @param _data bytes optional data to send along with the call
847      * @return bool whether the call correctly returned the expected magic value
848      */
849     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
850         private returns (bool)
851     {
852         if (to.isContract()) {
853             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
854                 return retval == IERC721Receiver(to).onERC721Received.selector;
855             } catch (bytes memory reason) {
856                 if (reason.length == 0) {
857                     revert("ERC721: transfer to non ERC721Receiver implementer");
858                 } else {
859                     // solhint-disable-next-line no-inline-assembly
860                     assembly {
861                         revert(add(32, reason), mload(reason))
862                     }
863                 }
864             }
865         } else {
866             return true;
867         }
868     }
869 
870     /**
871      * @dev Hook that is called before any token transfer. This includes minting
872      * and burning.
873      *
874      * Calling conditions:
875      *
876      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
877      * transferred to `to`.
878      * - When `from` is zero, `tokenId` will be minted for `to`.
879      * - When `to` is zero, ``from``'s `tokenId` will be burned.
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      *
883      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
884      */
885     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
889 
890 pragma solidity ^0.8.0;
891 
892 
893 /**
894  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
895  * @dev See https://eips.ethereum.org/EIPS/eip-721
896  */
897 interface IERC721Enumerable is IERC721 {
898 
899     /**
900      * @dev Returns the total amount of tokens stored by the contract.
901      */
902     function totalSupply() external view returns (uint256);
903 
904     /**
905      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
906      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
907      */
908     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
909 
910     /**
911      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
912      * Use along with {totalSupply} to enumerate all tokens.
913      */
914     function tokenByIndex(uint256 index) external view returns (uint256);
915 }
916 
917 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
918 
919 pragma solidity ^0.8.0;
920 
921 
922 
923 /**
924  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
925  * enumerability of all the token ids in the contract as well as all token ids owned by each
926  * account.
927  */
928 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
929     // Mapping from owner to list of owned token IDs
930     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
931 
932     // Mapping from token ID to index of the owner tokens list
933     mapping(uint256 => uint256) private _ownedTokensIndex;
934 
935     // Array with all token ids, used for enumeration
936     uint256[] private _allTokens;
937 
938     // Mapping from token id to position in the allTokens array
939     mapping(uint256 => uint256) private _allTokensIndex;
940 
941     /**
942      * @dev See {IERC165-supportsInterface}.
943      */
944     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
945         return interfaceId == type(IERC721Enumerable).interfaceId
946             || super.supportsInterface(interfaceId);
947     }
948 
949     /**
950      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
951      */
952     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
953         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
954         return _ownedTokens[owner][index];
955     }
956 
957     /**
958      * @dev See {IERC721Enumerable-totalSupply}.
959      */
960     function totalSupply() public view virtual override returns (uint256) {
961         return _allTokens.length;
962     }
963 
964     /**
965      * @dev See {IERC721Enumerable-tokenByIndex}.
966      */
967     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
968         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
969         return _allTokens[index];
970     }
971 
972     /**
973      * @dev Hook that is called before any token transfer. This includes minting
974      * and burning.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` will be minted for `to`.
981      * - When `to` is zero, ``from``'s `tokenId` will be burned.
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      *
985      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
986      */
987     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
988         super._beforeTokenTransfer(from, to, tokenId);
989 
990         if (from == address(0)) {
991             _addTokenToAllTokensEnumeration(tokenId);
992         } else if (from != to) {
993             _removeTokenFromOwnerEnumeration(from, tokenId);
994         }
995         if (to == address(0)) {
996             _removeTokenFromAllTokensEnumeration(tokenId);
997         } else if (to != from) {
998             _addTokenToOwnerEnumeration(to, tokenId);
999         }
1000     }
1001 
1002     /**
1003      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1004      * @param to address representing the new owner of the given token ID
1005      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1006      */
1007     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1008         uint256 length = ERC721.balanceOf(to);
1009         _ownedTokens[to][length] = tokenId;
1010         _ownedTokensIndex[tokenId] = length;
1011     }
1012 
1013     /**
1014      * @dev Private function to add a token to this extension's token tracking data structures.
1015      * @param tokenId uint256 ID of the token to be added to the tokens list
1016      */
1017     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1018         _allTokensIndex[tokenId] = _allTokens.length;
1019         _allTokens.push(tokenId);
1020     }
1021 
1022     /**
1023      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1024      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1025      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1026      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1027      * @param from address representing the previous owner of the given token ID
1028      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1029      */
1030     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1031         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1032         // then delete the last slot (swap and pop).
1033 
1034         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1035         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1036 
1037         // When the token to delete is the last token, the swap operation is unnecessary
1038         if (tokenIndex != lastTokenIndex) {
1039             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1040 
1041             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1042             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1043         }
1044 
1045         // This also deletes the contents at the last position of the array
1046         delete _ownedTokensIndex[tokenId];
1047         delete _ownedTokens[from][lastTokenIndex];
1048     }
1049 
1050     /**
1051      * @dev Private function to remove a token from this extension's token tracking data structures.
1052      * This has O(1) time complexity, but alters the order of the _allTokens array.
1053      * @param tokenId uint256 ID of the token to be removed from the tokens list
1054      */
1055     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1056         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1057         // then delete the last slot (swap and pop).
1058 
1059         uint256 lastTokenIndex = _allTokens.length - 1;
1060         uint256 tokenIndex = _allTokensIndex[tokenId];
1061 
1062         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1063         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1064         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1065         uint256 lastTokenId = _allTokens[lastTokenIndex];
1066 
1067         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1068         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1069 
1070         // This also deletes the contents at the last position of the array
1071         delete _allTokensIndex[tokenId];
1072         _allTokens.pop();
1073     }
1074 }
1075 
1076 // File: @openzeppelin/contracts/access/Ownable.sol
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 /**
1081  * @dev Contract module which provides a basic access control mechanism, where
1082  * there is an account (an owner) that can be granted exclusive access to
1083  * specific functions.
1084  *
1085  * By default, the owner account will be the one that deploys the contract. This
1086  * can later be changed with {transferOwnership}.
1087  *
1088  * This module is used through inheritance. It will make available the modifier
1089  * `onlyOwner`, which can be applied to your functions to restrict their use to
1090  * the owner.
1091  */
1092 abstract contract Ownable is Context {
1093     address private _owner;
1094 
1095     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1096 
1097     /**
1098      * @dev Initializes the contract setting the deployer as the initial owner.
1099      */
1100     constructor () {
1101         address msgSender = _msgSender();
1102         _owner = msgSender;
1103         emit OwnershipTransferred(address(0), msgSender);
1104     }
1105 
1106     /**
1107      * @dev Returns the address of the current owner.
1108      */
1109     function owner() public view virtual returns (address) {
1110         return _owner;
1111     }
1112 
1113     /**
1114      * @dev Throws if called by any account other than the owner.
1115      */
1116     modifier onlyOwner() {
1117         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1118         _;
1119     }
1120 
1121     /**
1122      * @dev Leaves the contract without owner. It will not be possible to call
1123      * `onlyOwner` functions anymore. Can only be called by the current owner.
1124      *
1125      * NOTE: Renouncing ownership will leave the contract without an owner,
1126      * thereby removing any functionality that is only available to the owner.
1127      */
1128     function renounceOwnership() public virtual onlyOwner {
1129         emit OwnershipTransferred(_owner, address(0));
1130         _owner = address(0);
1131     }
1132 
1133     /**
1134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1135      * Can only be called by the current owner.
1136      */
1137     function transferOwnership(address newOwner) public virtual onlyOwner {
1138         require(newOwner != address(0), "Ownable: new owner is the zero address");
1139         emit OwnershipTransferred(_owner, newOwner);
1140         _owner = newOwner;
1141     }
1142 }
1143 
1144 
1145 // SPDX-License-Identifier: MIT
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 contract FatPunks is ERC721Enumerable, Ownable {
1150     
1151     using Strings for uint256;
1152     
1153     string _baseTokenURI;
1154     uint256 private _maxMint = 3;
1155     uint256 private _price = 3 * 10**16; //0.03 ETH;
1156     bool public _paused = true;
1157     uint public constant MAX_ENTRIES = 1000;
1158     
1159     constructor(string memory baseURI) ERC721("Fat Punks", "FATTY")  {
1160         setBaseURI(baseURI);
1161         
1162         // Mint first 15 fat punks to owner
1163          mint(msg.sender, 15);
1164     }
1165     
1166     function mint(address _to, uint256 num) public payable {
1167         uint256 supply = totalSupply();
1168         
1169         if(msg.sender != owner()) {
1170           require(!_paused, "Sale Paused");
1171           require(balanceOf(msg.sender) + num < 4, "Exceeds maximum fatties minted per wallet.");
1172           require( num < (4),"You can mint a max of 3 fatties." );
1173           require( msg.value >= _price,"Ether sent is not correct" );
1174         }
1175         
1176         require( supply + num < MAX_ENTRIES,"Exceeds maximum supply" );
1177         for(uint256 i; i < num; i++){
1178           _safeMint( _to, supply + i );
1179         }
1180     }
1181     
1182     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1183         uint256 tokenCount = balanceOf(_owner);
1184 
1185         uint256[] memory tokensId = new uint256[](tokenCount);
1186         for(uint256 i; i < tokenCount; i++){
1187             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1188         }
1189         return tokensId;
1190     }
1191     
1192     function getPrice() public view returns (uint256){
1193         if(msg.sender == owner()) {
1194             return 0;
1195         }
1196         return _price;
1197     }
1198     
1199     function setPrice(uint256 _newPrice) public onlyOwner() {
1200         _price = _newPrice;
1201     }
1202     
1203     function getMaxMint() public view returns (uint256){
1204         return _maxMint;
1205     }
1206     
1207     function setMaxMint(uint256 _newMaxMint) public onlyOwner() {
1208         _maxMint = _newMaxMint;
1209     }
1210     
1211     function _baseURI() internal view virtual override returns (string memory) {
1212         return _baseTokenURI;
1213     }
1214     
1215     function setBaseURI(string memory baseURI) public onlyOwner {
1216         _baseTokenURI = baseURI;
1217     }
1218     
1219     function pause(bool val) public onlyOwner {
1220         _paused = val;
1221     }
1222     
1223     function withdrawAll() public payable onlyOwner {
1224         require(payable(msg.sender).send(address(this).balance));
1225     }
1226 }