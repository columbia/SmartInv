1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-28
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 pragma solidity 0.8.10;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 
30 /**
31  * @dev Implementation of the {IERC165} interface.
32  *
33  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
34  * for the additional interface id that will be supported. For example:
35  *
36  * ```solidity
37  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
38  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
39  * ```
40  *
41  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
42  */
43 abstract contract ERC165 is IERC165 {
44     /**
45      * @dev See {IERC165-supportsInterface}.
46      */
47     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
48         return interfaceId == type(IERC165).interfaceId;
49     }
50 }
51 
52 
53 /**
54  * @dev Required interface of an ERC721 compliant contract.
55  */
56 interface IERC721 is IERC165 {
57     /**
58      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
59      */
60     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
64      */
65     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
69      */
70     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
71 
72     /**
73      * @dev Returns the number of tokens in ``owner``'s account.
74      */
75     function balanceOf(address owner) external view returns (uint256 balance);
76 
77     /**
78      * @dev Returns the owner of the `tokenId` token.
79      *
80      * Requirements:
81      *
82      * - `tokenId` must exist.
83      */
84     function ownerOf(uint256 tokenId) external view returns (address owner);
85 
86     /**
87      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
88      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must exist and be owned by `from`.
95      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
96      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
97      *
98      * Emits a {Transfer} event.
99      */
100     function safeTransferFrom(address from, address to, uint256 tokenId) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(address from, address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162       * @dev Safely transfers `tokenId` token from `from` to `to`.
163       *
164       * Requirements:
165       *
166       * - `from` cannot be the zero address.
167       * - `to` cannot be the zero address.
168       * - `tokenId` token must exist and be owned by `from`.
169       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171       *
172       * Emits a {Transfer} event.
173       */
174     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
175 }
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 interface IERC721Receiver {
183     /**
184      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
185      * by `operator` from `from`, this function is called.
186      *
187      * It must return its Solidity selector to confirm the token transfer.
188      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
189      *
190      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
191      */
192     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
193 }
194 
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Metadata is IERC721 {
201 
202     /**
203      * @dev Returns the token collection name.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the token collection symbol.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
214      */
215     function tokenURI(uint256 tokenId) external view returns (string memory);
216 }
217 
218 
219 /**
220  * @dev Collection of functions related to the address type
221  */
222 library Address {
223     /**
224      * @dev Returns true if `account` is a contract.
225      *
226      * [IMPORTANT]
227      * ====
228      * It is unsafe to assume that an address for which this function returns
229      * false is an externally-owned account (EOA) and not a contract.
230      *
231      * Among others, `isContract` will return false for the following
232      * types of addresses:
233      *
234      *  - an externally-owned account
235      *  - a contract in construction
236      *  - an address where a contract will be created
237      *  - an address where a contract lived, but was destroyed
238      * ====
239      */
240     function isContract(address account) internal view returns (bool) {
241         // This method relies on extcodesize, which returns 0 for contracts in
242         // construction, since the code is only stored at the end of the
243         // constructor execution.
244 
245         uint256 size;
246         // solhint-disable-next-line no-inline-assembly
247         assembly { size := extcodesize(account) }
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
270         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
271         (bool success, ) = recipient.call{ value: amount }("");
272         require(success, "Address: unable to send value, recipient may have reverted");
273     }
274 
275     /**
276      * @dev Performs a Solidity function call using a low level `call`. A
277      * plain`call` is an unsafe replacement for a function call: use this
278      * function instead.
279      *
280      * If `target` reverts with a revert reason, it is bubbled up by this
281      * function (like regular Solidity function calls).
282      *
283      * Returns the raw returned data. To convert to the expected return value,
284      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
285      *
286      * Requirements:
287      *
288      * - `target` must be a contract.
289      * - calling `target` with `data` must not revert.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
294       return functionCall(target, data, "Address: low-level call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
299      * `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, 0, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but also transferring `value` wei to `target`.
310      *
311      * Requirements:
312      *
313      * - the calling contract must have an ETH balance of at least `value`.
314      * - the called Solidity function must be `payable`.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
324      * with `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         // solhint-disable-next-line avoid-low-level-calls
333         (bool success, bytes memory returndata) = target.call{ value: value }(data);
334         return _verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
344         return functionStaticCall(target, data, "Address: low-level static call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
378         require(isContract(target), "Address: delegate call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.delegatecall(data);
382         return _verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 // solhint-disable-next-line no-inline-assembly
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
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
427 
428 /**
429  * @dev String operations.
430  */
431 library Strings {
432     bytes16 private constant alphabet = "0123456789abcdef";
433 
434     /**
435      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
436      */
437     function toString(uint256 value) internal pure returns (string memory) {
438         // Inspired by OraclizeAPI's implementation - MIT licence
439         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
440 
441         if (value == 0) {
442             return "0";
443         }
444         uint256 temp = value;
445         uint256 digits;
446         while (temp != 0) {
447             digits++;
448             temp /= 10;
449         }
450         bytes memory buffer = new bytes(digits);
451         while (value != 0) {
452             digits -= 1;
453             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
454             value /= 10;
455         }
456         return string(buffer);
457     }
458 
459     /**
460      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
461      */
462     function toHexString(uint256 value) internal pure returns (string memory) {
463         if (value == 0) {
464             return "0x00";
465         }
466         uint256 temp = value;
467         uint256 length = 0;
468         while (temp != 0) {
469             length++;
470             temp >>= 8;
471         }
472         return toHexString(value, length);
473     }
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
477      */
478     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
479         bytes memory buffer = new bytes(2 * length + 2);
480         buffer[0] = "0";
481         buffer[1] = "x";
482         for (uint256 i = 2 * length + 1; i > 1; --i) {
483             buffer[i] = alphabet[value & 0xf];
484             value >>= 4;
485         }
486         require(value == 0, "Strings: hex length insufficient");
487         return string(buffer);
488     }
489 
490 }
491 
492 
493 /**
494  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
495  * the Metadata extension, but not including the Enumerable extension, which is available separately as
496  * {ERC721Enumerable}.
497  */
498 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
499     using Address for address;
500     using Strings for uint256;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     string internal _tokenURI;
509 
510 
511     // Mapping from token ID to owner address
512     mapping (uint256 => address) private _owners;
513 
514     // Mapping owner address to token count
515     mapping (address => uint256) private _balances;
516 
517     // Mapping from token ID to approved address
518     mapping (uint256 => address) private _tokenApprovals;
519 
520     // Mapping from owner to operator approvals
521     mapping (address => mapping (address => bool)) private _operatorApprovals;
522     
523 
524     /**
525      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
526      */
527     constructor (string memory name_, string memory symbol_) {
528         _name = name_;
529         _symbol = symbol_;
530     }
531 
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
536         return interfaceId == type(IERC721).interfaceId
537             || interfaceId == type(IERC721Metadata).interfaceId
538             || super.supportsInterface(interfaceId);
539     }
540 
541     /**
542      * @dev See {IERC721-balanceOf}.
543      */
544     function balanceOf(address owner) public view virtual override returns (uint256) {
545         require(owner != address(0), "ERC721: balance query for the zero address");
546         return _balances[owner];
547     }
548 
549     /**
550      * @dev See {IERC721-ownerOf}.
551      */
552     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
553         address owner = _owners[tokenId];
554         require(owner != address(0), "ERC721: owner query for nonexistent token");
555         return owner;
556     }
557 
558     /**
559      * @dev See {IERC721Metadata-name}.
560      */
561     function name() public view virtual override returns (string memory) {
562         return _name;
563     }
564 
565     /**
566      * @dev See {IERC721Metadata-symbol}.
567      */
568     function symbol() public view virtual override returns (string memory) {
569         return _symbol;
570     }
571     
572     /// @notice It all points to base reality being a higher order of consciousness, take a deep dive into the work of Jacobo Grinberg.
573 
574     function _baseURI() internal view  returns (string memory) {
575         return _tokenURI;
576     }
577 
578     /**
579      * @dev See {IERC721Metadata-tokenURI}.
580      */
581     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
582         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
583 
584         string memory uri = _baseURI();
585         return
586             bytes(uri).length > 0
587                 ? string(abi.encodePacked(uri, _tokenId.toString(),".json"))
588                 : "";
589     }
590 
591    
592     /**
593      * @dev See {IERC721-approve}.
594      */
595     function approve(address to, uint256 tokenId) public virtual override {
596         address owner = ERC721.ownerOf(tokenId);
597         require(to != owner, "ERC721: approval to current owner");
598 
599         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
600             "ERC721: approve caller is not owner nor approved for all"
601         );
602 
603         _approve(to, tokenId);
604     }
605 
606     /**
607      * @dev See {IERC721-getApproved}.
608      */
609     function getApproved(uint256 tokenId) public view virtual override returns (address) {
610         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
611 
612         return _tokenApprovals[tokenId];
613     }
614 
615     /**
616      * @dev See {IERC721-setApprovalForAll}.
617      */
618     function setApprovalForAll(address operator, bool approved) public virtual override {
619         require(operator != _msgSender(), "ERC721: approve to caller");
620 
621         _operatorApprovals[_msgSender()][operator] = approved;
622         emit ApprovalForAll(_msgSender(), operator, approved);
623     }
624 
625     /**
626      * @dev See {IERC721-isApprovedForAll}.
627      */
628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     /**
633      * @dev See {IERC721-transferFrom}.
634      */
635     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
636         //solhint-disable-next-line max-line-length
637         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
638 
639         _transfer(from, to, tokenId);
640     }
641 
642     /**
643      * @dev See {IERC721-safeTransferFrom}.
644      */
645     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
646         safeTransferFrom(from, to, tokenId, "");
647     }
648 
649     /**
650      * @dev See {IERC721-safeTransferFrom}.
651      */
652     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
653         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
654         _safeTransfer(from, to, tokenId, _data);
655     }
656 
657     /**
658      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
659      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
660      *
661      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
662      *
663      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
664      * implement alternative mechanisms to perform token transfer, such as signature-based.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
672      *
673      * Emits a {Transfer} event.
674      */
675     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
676         _transfer(from, to, tokenId);
677         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
678     }
679 
680     /**
681      * @dev Returns whether `tokenId` exists.
682      *
683      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
684      *
685      * Tokens start existing when they are minted (`_mint`),
686      * and stop existing when they are burned (`_burn`).
687      */
688     function _exists(uint256 tokenId) internal view virtual returns (bool) {
689         return _owners[tokenId] != address(0);
690     }
691 
692     /**
693      * @dev Returns whether `spender` is allowed to manage `tokenId`.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
700         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
701         address owner = ERC721.ownerOf(tokenId);
702         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
703     }
704 
705     /**
706      * @dev Safely mints `tokenId` and transfers it to `to`.
707      *
708      * Requirements:
709      *
710      * - `tokenId` must not exist.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function _safeMint(address to, uint256 tokenId) internal virtual {
716         _safeMint(to, tokenId, "");
717     }
718 
719     /**
720      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
721      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
722      */
723     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
724         _mint(to, tokenId);
725         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
726     }
727 
728     /**
729      * @dev Mints `tokenId` and transfers it to `to`.
730      *
731      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
732      *
733      * Requirements:
734      *
735      * - `tokenId` must not exist.
736      * - `to` cannot be the zero address.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _mint(address to, uint256 tokenId) internal virtual {
741         require(to != address(0), "ERC721: mint to the zero address");
742         require(!_exists(tokenId), "ERC721: token already minted");
743 
744         _beforeTokenTransfer(address(0), to, tokenId);
745 
746         _balances[to] += 1;
747         _owners[tokenId] = to;
748 
749         emit Transfer(address(0), to, tokenId);
750     }
751 
752     /**
753      * @dev Destroys `tokenId`.
754      * The approval is cleared when the token is burned.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _burn(uint256 tokenId) internal virtual {
763         address owner = ERC721.ownerOf(tokenId);
764 
765         _beforeTokenTransfer(owner, address(0), tokenId);
766 
767         // Clear approvals
768         _approve(address(0), tokenId);
769 
770         _balances[owner] -= 1;
771         delete _owners[tokenId];
772 
773         emit Transfer(owner, address(0), tokenId);
774     }
775 
776     /**
777      * @dev Transfers `tokenId` from `from` to `to`.
778      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
779      *
780      * Requirements:
781      *
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must be owned by `from`.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _transfer(address from, address to, uint256 tokenId) internal virtual {
788         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
789         require(to != address(0), "ERC721: transfer to the zero address");
790 
791         _beforeTokenTransfer(from, to, tokenId);
792 
793         // Clear approvals from the previous owner
794         _approve(address(0), tokenId);
795 
796         _balances[from] -= 1;
797         _balances[to] += 1;
798         _owners[tokenId] = to;
799 
800         emit Transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev Approve `to` to operate on `tokenId`
805      *
806      * Emits a {Approval} event.
807      */
808     function _approve(address to, uint256 tokenId) internal virtual {
809         _tokenApprovals[tokenId] = to;
810         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
811     }
812 
813     /**
814      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
815      * The call is not executed if the target address is not a contract.
816      *
817      * @param from address representing the previous owner of the given token ID
818      * @param to target address that will receive the tokens
819      * @param tokenId uint256 ID of the token to be transferred
820      * @param _data bytes optional data to send along with the call
821      * @return bool whether the call correctly returned the expected magic value
822      */
823     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
824         private returns (bool)
825     {
826         if (to.isContract()) {
827             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
828                 return retval == IERC721Receiver(to).onERC721Received.selector;
829             } catch (bytes memory reason) {
830                 if (reason.length == 0) {
831                     revert("ERC721: transfer to non ERC721Receiver implementer");
832                 } else {
833                     // solhint-disable-next-line no-inline-assembly
834                     assembly {
835                         revert(add(32, reason), mload(reason))
836                     }
837                 }
838             }
839         } else {
840             return true;
841         }
842     }
843 
844     /**
845      * @dev Hook that is called before any token transfer. This includes minting
846      * and burning.
847      *
848      * Calling conditions:
849      *
850      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
851      * transferred to `to`.
852      * - When `from` is zero, `tokenId` will be minted for `to`.
853      * - When `to` is zero, ``from``'s `tokenId` will be burned.
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      *
857      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
858      */
859     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
860 }
861 
862 
863 contract Ownable is Context {
864     address private _owner;
865 
866     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
867 
868     /**
869      * @dev Initializes the contract setting the deployer as the initial owner.
870      */
871     constructor ()  {
872         address msgSender = _msgSender();
873         _owner = msgSender;
874         emit OwnershipTransferred(address(0), msgSender);
875     }
876 
877     /**
878      * @dev Returns the address of the current owner.
879      */
880     function owner() public view returns (address) {
881         return _owner;
882     }
883 
884     /**
885      * @dev Throws if called by any account other than the owner.
886      */
887     modifier onlyOwner() {
888         require(_owner == _msgSender(), "Ownable: caller is not the owner");
889         _;
890     }
891 
892     /**
893      * @dev Leaves the contract without owner. It will not be possible to call
894      * `onlyOwner` functions anymore. Can only be called by the current owner.
895      *
896      * NOTE: Renouncing ownership will leave the contract without an owner,
897      * thereby removing any functionality that is only available to the owner.
898      */
899     function renounceOwnership() public virtual onlyOwner {
900         emit OwnershipTransferred(_owner, address(0));
901         _owner = address(0);
902     }
903 
904     /**
905      * @dev Transfers ownership of the contract to a new account (`newOwner`).
906      * Can only be called by the current owner.
907      */
908     function transferOwnership(address newOwner) public virtual onlyOwner {
909         require(newOwner != address(0), "Ownable: new owner is the zero address");
910         emit OwnershipTransferred(_owner, newOwner);
911         _owner = newOwner;
912     }
913 }
914 
915 
916 
917 /**
918  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
919  * @dev See https://eips.ethereum.org/EIPS/eip-721
920  */
921 interface IERC721Enumerable is IERC721 {
922     /**
923      * @dev Returns the total amount of tokens stored by the contract.
924      */
925     function totalSupply() external view returns (uint256);
926 
927     /**
928      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
929      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
930      */
931     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
932 
933     /**
934      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
935      * Use along with {totalSupply} to enumerate all tokens.
936      */
937     function tokenByIndex(uint256 index) external view returns (uint256);
938 }
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
962         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
963     }
964 
965     /**
966      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
967      */
968     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
969         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
970         return _ownedTokens[owner][index];
971     }
972 
973     /**
974      * @dev See {IERC721Enumerable-totalSupply}.
975      */
976     function totalSupply() public view virtual override returns (uint256) {
977         return _allTokens.length;
978     }
979 
980     /**
981      * @dev See {IERC721Enumerable-tokenByIndex}.
982      */
983     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
984         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
985         return _allTokens[index];
986     }
987 
988     /**
989      * @dev Hook that is called before any token transfer. This includes minting
990      * and burning.
991      *
992      * Calling conditions:
993      *
994      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
995      * transferred to `to`.
996      * - When `from` is zero, `tokenId` will be minted for `to`.
997      * - When `to` is zero, ``from``'s `tokenId` will be burned.
998      * - `from` cannot be the zero address.
999      * - `to` cannot be the zero address.
1000      *
1001      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1002      */
1003     function _beforeTokenTransfer(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) internal virtual override {
1008         super._beforeTokenTransfer(from, to, tokenId);
1009 
1010         if (from == address(0)) {
1011             _addTokenToAllTokensEnumeration(tokenId);
1012         } else if (from != to) {
1013             _removeTokenFromOwnerEnumeration(from, tokenId);
1014         }
1015         if (to == address(0)) {
1016             _removeTokenFromAllTokensEnumeration(tokenId);
1017         } else if (to != from) {
1018             _addTokenToOwnerEnumeration(to, tokenId);
1019         }
1020     }
1021 
1022     /**
1023      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1024      * @param to address representing the new owner of the given token ID
1025      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1026      */
1027     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1028         uint256 length = ERC721.balanceOf(to);
1029         _ownedTokens[to][length] = tokenId;
1030         _ownedTokensIndex[tokenId] = length;
1031     }
1032 
1033     /**
1034      * @dev Private function to add a token to this extension's token tracking data structures.
1035      * @param tokenId uint256 ID of the token to be added to the tokens list
1036      */
1037     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1038         _allTokensIndex[tokenId] = _allTokens.length;
1039         _allTokens.push(tokenId);
1040     }
1041 
1042     /**
1043      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1044      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1045      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1046      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1047      * @param from address representing the previous owner of the given token ID
1048      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1049      */
1050     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1051         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1052         // then delete the last slot (swap and pop).
1053 
1054         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1055         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1056 
1057         // When the token to delete is the last token, the swap operation is unnecessary
1058         if (tokenIndex != lastTokenIndex) {
1059             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1060 
1061             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1062             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1063         }
1064 
1065         // This also deletes the contents at the last position of the array
1066         delete _ownedTokensIndex[tokenId];
1067         delete _ownedTokens[from][lastTokenIndex];
1068     }
1069 
1070     /**
1071      * @dev Private function to remove a token from this extension's token tracking data structures.
1072      * This has O(1) time complexity, but alters the order of the _allTokens array.
1073      * @param tokenId uint256 ID of the token to be removed from the tokens list
1074      */
1075     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1076         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1077         // then delete the last slot (swap and pop).
1078 
1079         uint256 lastTokenIndex = _allTokens.length - 1;
1080         uint256 tokenIndex = _allTokensIndex[tokenId];
1081 
1082         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1083         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1084         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1085         uint256 lastTokenId = _allTokens[lastTokenIndex];
1086 
1087         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1088         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1089 
1090         // This also deletes the contents at the last position of the array
1091         delete _allTokensIndex[tokenId];
1092         _allTokens.pop();
1093     }
1094 }
1095 
1096 
1097 /**
1098  * @title Counters
1099  * @author Matt Condon (@shrugs)
1100  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1101  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1102  *
1103  * Include with `using Counters for Counters.Counter;`
1104  */
1105 library Counters {
1106     struct Counter {
1107         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1108         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1109         // this feature: see https://github.com/ethereum/solidity/issues/4637
1110         uint256 _value; // default: 0
1111     }
1112 
1113     function current(Counter storage counter) internal view returns (uint256) {
1114         return counter._value;
1115     }
1116 
1117     function increment(Counter storage counter) internal {
1118         unchecked {
1119             counter._value += 1;
1120         }
1121     }
1122 
1123     function decrement(Counter storage counter) internal {
1124         uint256 value = counter._value;
1125         require(value > 0, "Counter: decrement overflow");
1126         unchecked {
1127             counter._value = value - 1;
1128         }
1129     }
1130 
1131     function reset(Counter storage counter) internal {
1132         counter._value = 0;
1133     }
1134 }
1135 
1136 
1137 
1138 contract MidnightMunchies is ERC721Enumerable,Ownable() {
1139     
1140     IERC721Enumerable MembershipToken;
1141     
1142     using Counters for Counters.Counter;
1143     Counters.Counter private _tokenIds;
1144     
1145     uint256 public maxSupply;
1146     uint256 public lockedTime;
1147     bool public sale; 
1148     
1149     mapping(uint256 => uint256) public usedMembershipToken;
1150     
1151     event NftBought(address indexed, uint256 tokenId, uint256 memberShipTokenId);
1152     
1153     constructor(address _tokenAddress) ERC721("Midnight Munchies", "MND"){
1154         MembershipToken = IERC721Enumerable(_tokenAddress);
1155         maxSupply = 5555;
1156         _tokenURI = 'https://ipfs.io/ipfs/QmR8qos4anNBL6qEEXMUX6tMnz7mrVu7qE6wEKdTTc76Ys/';
1157         lockedTime = 1639872000; // Dec 19 2021 
1158         sale = false;
1159         
1160     } 
1161     
1162     function buyNft(uint256 _count,uint256[] memory tokenId) public {
1163         require(totalSupply() + _count <= maxSupply,"ERROR: max limit reached");
1164         require(_count <= 10 && tokenId.length <= 10,"ERROR: max 10 mint per transaction");
1165         require(_count == tokenId.length,"ERROR: wrong token ID or count");
1166         require(sale,"ERROR: not on sale");
1167 
1168         if(block.timestamp < lockedTime){
1169             require(_count <= MembershipToken.balanceOf(msg.sender),"ERROR: not enough MembershipToken");
1170             for(uint256 i=0; i<tokenId.length; i++){
1171                 require(msg.sender == MembershipToken.ownerOf(tokenId[i]),"ERROR: u don't have this token ID");
1172                 if(usedMembershipToken[tokenId[i]] != 0) require(usedMembershipToken[tokenId[i]] <= block.timestamp ,"ERROR: this Membership Token is already used");
1173             }
1174         }
1175         
1176         for(uint256 j=0; j< _count; j++){
1177             _tokenIds.increment();
1178             uint256 newItemId = _tokenIds.current();
1179             
1180             mintNft(newItemId);
1181             
1182             usedMembershipToken[tokenId[j]] = lockedTime;
1183             
1184             emit NftBought(msg.sender,newItemId,tokenId[j]);
1185         }
1186 
1187     }
1188 
1189     function changeTokenUri(string memory _newUri) public onlyOwner {
1190         _tokenURI = _newUri;
1191     } 
1192 
1193     function unLockSale() public onlyOwner {
1194         sale = true;
1195     }
1196 
1197     function lockSale() public onlyOwner {
1198         sale = false;
1199     }
1200 
1201     function changeLockTime(uint256 newTime) public onlyOwner {
1202         lockedTime = newTime;
1203     }
1204 
1205     function mintNft(uint256 _id) internal {
1206         _safeMint(msg.sender,_id);
1207     }
1208     
1209 }