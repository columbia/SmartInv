1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 // 
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
28 // 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(address from, address to, uint256 tokenId) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address from, address to, uint256 tokenId) external;
93 
94     /**
95      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
96      * The approval is cleared when the token is transferred.
97      *
98      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
99      *
100      * Requirements:
101      *
102      * - The caller must own the token or be an approved operator.
103      * - `tokenId` must exist.
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Returns the account approved for `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function getApproved(uint256 tokenId) external view returns (address operator);
117 
118     /**
119      * @dev Approve or remove `operator` as an operator for the caller.
120      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
121      *
122      * Requirements:
123      *
124      * - The `operator` cannot be the caller.
125      *
126      * Emits an {ApprovalForAll} event.
127      */
128     function setApprovalForAll(address operator, bool _approved) external;
129 
130     /**
131      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
132      *
133      * See {setApprovalForAll}
134      */
135     function isApprovedForAll(address owner, address operator) external view returns (bool);
136 
137     /**
138       * @dev Safely transfers `tokenId` token from `from` to `to`.
139       *
140       * Requirements:
141       *
142       * - `from` cannot be the zero address.
143       * - `to` cannot be the zero address.
144       * - `tokenId` token must exist and be owned by `from`.
145       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
147       *
148       * Emits a {Transfer} event.
149       */
150     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
151 }
152 
153 // 
154 /**
155  * @title ERC721 token receiver interface
156  * @dev Interface for any contract that wants to support safeTransfers
157  * from ERC721 asset contracts.
158  */
159 interface IERC721Receiver {
160     /**
161      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
162      * by `operator` from `from`, this function is called.
163      *
164      * It must return its Solidity selector to confirm the token transfer.
165      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
166      *
167      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
168      */
169     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
170 }
171 
172 // 
173 /**
174  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
175  * @dev See https://eips.ethereum.org/EIPS/eip-721
176  */
177 interface IERC721Metadata is IERC721 {
178 
179     /**
180      * @dev Returns the token collection name.
181      */
182     function name() external view returns (string memory);
183 
184     /**
185      * @dev Returns the token collection symbol.
186      */
187     function symbol() external view returns (string memory);
188 
189     /**
190      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
191      */
192     function tokenURI(uint256 tokenId) external view returns (string memory);
193 }
194 
195 // 
196 /**
197  * @dev Collection of functions related to the address type
198  */
199 library Address {
200     /**
201      * @dev Returns true if `account` is a contract.
202      *
203      * [IMPORTANT]
204      * ====
205      * It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      *
208      * Among others, `isContract` will return false for the following
209      * types of addresses:
210      *
211      *  - an externally-owned account
212      *  - a contract in construction
213      *  - an address where a contract will be created
214      *  - an address where a contract lived, but was destroyed
215      * ====
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize, which returns 0 for contracts in
219         // construction, since the code is only stored at the end of the
220         // constructor execution.
221 
222         uint256 size;
223         // solhint-disable-next-line no-inline-assembly
224         assembly { size := extcodesize(account) }
225         return size > 0;
226     }
227 
228     /**
229      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
230      * `recipient`, forwarding all available gas and reverting on errors.
231      *
232      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
233      * of certain opcodes, possibly making contracts go over the 2300 gas limit
234      * imposed by `transfer`, making them unable to receive funds via
235      * `transfer`. {sendValue} removes this limitation.
236      *
237      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
238      *
239      * IMPORTANT: because control is transferred to `recipient`, care must be
240      * taken to not create reentrancy vulnerabilities. Consider using
241      * {ReentrancyGuard} or the
242      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
243      */
244     function sendValue(address payable recipient, uint256 amount) internal {
245         require(address(this).balance >= amount, "Address: insufficient balance");
246 
247         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
248         (bool success, ) = recipient.call{ value: amount }("");
249         require(success, "Address: unable to send value, recipient may have reverted");
250     }
251 
252     /**
253      * @dev Performs a Solidity function call using a low level `call`. A
254      * plain`call` is an unsafe replacement for a function call: use this
255      * function instead.
256      *
257      * If `target` reverts with a revert reason, it is bubbled up by this
258      * function (like regular Solidity function calls).
259      *
260      * Returns the raw returned data. To convert to the expected return value,
261      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
262      *
263      * Requirements:
264      *
265      * - `target` must be a contract.
266      * - calling `target` with `data` must not revert.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
271       return functionCall(target, data, "Address: low-level call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
276      * `errorMessage` as a fallback revert reason when `target` reverts.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, 0, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but also transferring `value` wei to `target`.
287      *
288      * Requirements:
289      *
290      * - the calling contract must have an ETH balance of at least `value`.
291      * - the called Solidity function must be `payable`.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         // solhint-disable-next-line avoid-low-level-calls
310         (bool success, bytes memory returndata) = target.call{ value: value }(data);
311         return _verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
321         return functionStaticCall(target, data, "Address: low-level static call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
331         require(isContract(target), "Address: static call to non-contract");
332 
333         // solhint-disable-next-line avoid-low-level-calls
334         (bool success, bytes memory returndata) = target.staticcall(data);
335         return _verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but performing a delegate call.
341      *
342      * _Available since v3.4._
343      */
344     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         require(isContract(target), "Address: delegate call to non-contract");
356 
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = target.delegatecall(data);
359         return _verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 // 
383 /*
384  * @dev Provides information about the current execution context, including the
385  * sender of the transaction and its data. While these are generally available
386  * via msg.sender and msg.data, they should not be accessed in such a direct
387  * manner, since when dealing with meta-transactions the account sending and
388  * paying for execution may not be the actual sender (as far as an application
389  * is concerned).
390  *
391  * This contract is only required for intermediate, library-like contracts.
392  */
393 abstract contract Context {
394     function _msgSender() internal view virtual returns (address) {
395         return msg.sender;
396     }
397 
398     function _msgData() internal view virtual returns (bytes calldata) {
399         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
400         return msg.data;
401     }
402 }
403 
404 // 
405 /**
406  * @dev String operations.
407  */
408 library Strings {
409     bytes16 private constant alphabet = "0123456789abcdef";
410 
411     /**
412      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
413      */
414     function toString(uint256 value) internal pure returns (string memory) {
415         // Inspired by OraclizeAPI's implementation - MIT licence
416         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
417 
418         if (value == 0) {
419             return "0";
420         }
421         uint256 temp = value;
422         uint256 digits;
423         while (temp != 0) {
424             digits++;
425             temp /= 10;
426         }
427         bytes memory buffer = new bytes(digits);
428         while (value != 0) {
429             digits -= 1;
430             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
431             value /= 10;
432         }
433         return string(buffer);
434     }
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
438      */
439     function toHexString(uint256 value) internal pure returns (string memory) {
440         if (value == 0) {
441             return "0x00";
442         }
443         uint256 temp = value;
444         uint256 length = 0;
445         while (temp != 0) {
446             length++;
447             temp >>= 8;
448         }
449         return toHexString(value, length);
450     }
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
454      */
455     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
456         bytes memory buffer = new bytes(2 * length + 2);
457         buffer[0] = "0";
458         buffer[1] = "x";
459         for (uint256 i = 2 * length + 1; i > 1; --i) {
460             buffer[i] = alphabet[value & 0xf];
461             value >>= 4;
462         }
463         require(value == 0, "Strings: hex length insufficient");
464         return string(buffer);
465     }
466 
467 }
468 
469 // 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // 
494 /**
495  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
496  * the Metadata extension, but not including the Enumerable extension, which is available separately as
497  * {ERC721Enumerable}.
498  */
499 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
500     using Address for address;
501     using Strings for uint256;
502 
503     // Token name
504     string private _name;
505 
506     // Token symbol
507     string private _symbol;
508 
509     // Mapping from token ID to owner address
510     mapping (uint256 => address) private _owners;
511 
512     // Mapping owner address to token count
513     mapping (address => uint256) private _balances;
514 
515     // Mapping from token ID to approved address
516     mapping (uint256 => address) private _tokenApprovals;
517 
518     // Mapping from owner to operator approvals
519     mapping (address => mapping (address => bool)) private _operatorApprovals;
520 
521     /**
522      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
523      */
524     constructor (string memory name_, string memory symbol_) {
525         _name = name_;
526         _symbol = symbol_;
527     }
528 
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
533         return interfaceId == type(IERC721).interfaceId
534             || interfaceId == type(IERC721Metadata).interfaceId
535             || super.supportsInterface(interfaceId);
536     }
537 
538     /**
539      * @dev See {IERC721-balanceOf}.
540      */
541     function balanceOf(address owner) public view virtual override returns (uint256) {
542         require(owner != address(0), "ERC721: balance query for the zero address");
543         return _balances[owner];
544     }
545 
546     /**
547      * @dev See {IERC721-ownerOf}.
548      */
549     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
550         address owner = _owners[tokenId];
551         require(owner != address(0), "ERC721: owner query for nonexistent token");
552         return owner;
553     }
554 
555     /**
556      * @dev See {IERC721Metadata-name}.
557      */
558     function name() public view virtual override returns (string memory) {
559         return _name;
560     }
561 
562     /**
563      * @dev See {IERC721Metadata-symbol}.
564      */
565     function symbol() public view virtual override returns (string memory) {
566         return _symbol;
567     }
568 
569     /**
570      * @dev See {IERC721Metadata-tokenURI}.
571      */
572     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
573         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
574 
575         string memory baseURI = _baseURI();
576         return bytes(baseURI).length > 0
577             ? string(abi.encodePacked(baseURI, tokenId.toString()))
578             : '';
579     }
580 
581     /**
582      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
583      * in child contracts.
584      */
585     function _baseURI() internal view virtual returns (string memory) {
586         return "";
587     }
588 
589     /**
590      * @dev See {IERC721-approve}.
591      */
592     function approve(address to, uint256 tokenId) public virtual override {
593         address owner = ERC721.ownerOf(tokenId);
594         require(to != owner, "ERC721: approval to current owner");
595 
596         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
597             "ERC721: approve caller is not owner nor approved for all"
598         );
599 
600         _approve(to, tokenId);
601     }
602 
603     /**
604      * @dev See {IERC721-getApproved}.
605      */
606     function getApproved(uint256 tokenId) public view virtual override returns (address) {
607         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
608 
609         return _tokenApprovals[tokenId];
610     }
611 
612     /**
613      * @dev See {IERC721-setApprovalForAll}.
614      */
615     function setApprovalForAll(address operator, bool approved) public virtual override {
616         require(operator != _msgSender(), "ERC721: approve to caller");
617 
618         _operatorApprovals[_msgSender()][operator] = approved;
619         emit ApprovalForAll(_msgSender(), operator, approved);
620     }
621 
622     /**
623      * @dev See {IERC721-isApprovedForAll}.
624      */
625     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
626         return _operatorApprovals[owner][operator];
627     }
628 
629     /**
630      * @dev See {IERC721-transferFrom}.
631      */
632     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
633         //solhint-disable-next-line max-line-length
634         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
635 
636         _transfer(from, to, tokenId);
637     }
638 
639     /**
640      * @dev See {IERC721-safeTransferFrom}.
641      */
642     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
643         safeTransferFrom(from, to, tokenId, "");
644     }
645 
646     /**
647      * @dev See {IERC721-safeTransferFrom}.
648      */
649     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
650         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
651         _safeTransfer(from, to, tokenId, _data);
652     }
653 
654     /**
655      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
656      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
657      *
658      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
659      *
660      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
661      * implement alternative mechanisms to perform token transfer, such as signature-based.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must exist and be owned by `from`.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
673         _transfer(from, to, tokenId);
674         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
675     }
676 
677     /**
678      * @dev Returns whether `tokenId` exists.
679      *
680      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
681      *
682      * Tokens start existing when they are minted (`_mint`),
683      * and stop existing when they are burned (`_burn`).
684      */
685     function _exists(uint256 tokenId) internal view virtual returns (bool) {
686         return _owners[tokenId] != address(0);
687     }
688 
689     /**
690      * @dev Returns whether `spender` is allowed to manage `tokenId`.
691      *
692      * Requirements:
693      *
694      * - `tokenId` must exist.
695      */
696     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
697         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
698         address owner = ERC721.ownerOf(tokenId);
699         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
700     }
701 
702     /**
703      * @dev Safely mints `tokenId` and transfers it to `to`.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must not exist.
708      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
709      *
710      * Emits a {Transfer} event.
711      */
712     function _safeMint(address to, uint256 tokenId) internal virtual {
713         _safeMint(to, tokenId, "");
714     }
715 
716     /**
717      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
718      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
719      */
720     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
721         _mint(to, tokenId);
722         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
723     }
724 
725     /**
726      * @dev Mints `tokenId` and transfers it to `to`.
727      *
728      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
729      *
730      * Requirements:
731      *
732      * - `tokenId` must not exist.
733      * - `to` cannot be the zero address.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _mint(address to, uint256 tokenId) internal virtual {
738         require(to != address(0), "ERC721: mint to the zero address");
739         require(!_exists(tokenId), "ERC721: token already minted");
740 
741         _beforeTokenTransfer(address(0), to, tokenId);
742 
743         _balances[to] += 1;
744         _owners[tokenId] = to;
745 
746         emit Transfer(address(0), to, tokenId);
747     }
748 
749     /**
750      * @dev Destroys `tokenId`.
751      * The approval is cleared when the token is burned.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _burn(uint256 tokenId) internal virtual {
760         address owner = ERC721.ownerOf(tokenId);
761 
762         _beforeTokenTransfer(owner, address(0), tokenId);
763 
764         // Clear approvals
765         _approve(address(0), tokenId);
766 
767         _balances[owner] -= 1;
768         delete _owners[tokenId];
769 
770         emit Transfer(owner, address(0), tokenId);
771     }
772 
773     /**
774      * @dev Transfers `tokenId` from `from` to `to`.
775      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
776      *
777      * Requirements:
778      *
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must be owned by `from`.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _transfer(address from, address to, uint256 tokenId) internal virtual {
785         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
786         require(to != address(0), "ERC721: transfer to the zero address");
787 
788         _beforeTokenTransfer(from, to, tokenId);
789 
790         // Clear approvals from the previous owner
791         _approve(address(0), tokenId);
792 
793         _balances[from] -= 1;
794         _balances[to] += 1;
795         _owners[tokenId] = to;
796 
797         emit Transfer(from, to, tokenId);
798     }
799 
800     /**
801      * @dev Approve `to` to operate on `tokenId`
802      *
803      * Emits a {Approval} event.
804      */
805     function _approve(address to, uint256 tokenId) internal virtual {
806         _tokenApprovals[tokenId] = to;
807         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
808     }
809 
810     /**
811      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
812      * The call is not executed if the target address is not a contract.
813      *
814      * @param from address representing the previous owner of the given token ID
815      * @param to target address that will receive the tokens
816      * @param tokenId uint256 ID of the token to be transferred
817      * @param _data bytes optional data to send along with the call
818      * @return bool whether the call correctly returned the expected magic value
819      */
820     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
821         private returns (bool)
822     {
823         if (to.isContract()) {
824             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
825                 return retval == IERC721Receiver(to).onERC721Received.selector;
826             } catch (bytes memory reason) {
827                 if (reason.length == 0) {
828                     revert("ERC721: transfer to non ERC721Receiver implementer");
829                 } else {
830                     // solhint-disable-next-line no-inline-assembly
831                     assembly {
832                         revert(add(32, reason), mload(reason))
833                     }
834                 }
835             }
836         } else {
837             return true;
838         }
839     }
840 
841     /**
842      * @dev Hook that is called before any token transfer. This includes minting
843      * and burning.
844      *
845      * Calling conditions:
846      *
847      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
848      * transferred to `to`.
849      * - When `from` is zero, `tokenId` will be minted for `to`.
850      * - When `to` is zero, ``from``'s `tokenId` will be burned.
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      *
854      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
855      */
856     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
857 }
858 
859 // 
860 /**
861  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
862  * @dev See https://eips.ethereum.org/EIPS/eip-721
863  */
864 interface IERC721Enumerable is IERC721 {
865 
866     /**
867      * @dev Returns the total amount of tokens stored by the contract.
868      */
869     function totalSupply() external view returns (uint256);
870 
871     /**
872      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
873      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
874      */
875     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
876 
877     /**
878      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
879      * Use along with {totalSupply} to enumerate all tokens.
880      */
881     function tokenByIndex(uint256 index) external view returns (uint256);
882 }
883 
884 // 
885 /**
886  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
887  * enumerability of all the token ids in the contract as well as all token ids owned by each
888  * account.
889  */
890 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
891     // Mapping from owner to list of owned token IDs
892     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
893 
894     // Mapping from token ID to index of the owner tokens list
895     mapping(uint256 => uint256) private _ownedTokensIndex;
896 
897     // Array with all token ids, used for enumeration
898     uint256[] private _allTokens;
899 
900     // Mapping from token id to position in the allTokens array
901     mapping(uint256 => uint256) private _allTokensIndex;
902 
903     /**
904      * @dev See {IERC165-supportsInterface}.
905      */
906     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
907         return interfaceId == type(IERC721Enumerable).interfaceId
908             || super.supportsInterface(interfaceId);
909     }
910 
911     /**
912      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
913      */
914     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
915         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
916         return _ownedTokens[owner][index];
917     }
918 
919     /**
920      * @dev See {IERC721Enumerable-totalSupply}.
921      */
922     function totalSupply() public view virtual override returns (uint256) {
923         return _allTokens.length;
924     }
925 
926     /**
927      * @dev See {IERC721Enumerable-tokenByIndex}.
928      */
929     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
930         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
931         return _allTokens[index];
932     }
933 
934     /**
935      * @dev Hook that is called before any token transfer. This includes minting
936      * and burning.
937      *
938      * Calling conditions:
939      *
940      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
941      * transferred to `to`.
942      * - When `from` is zero, `tokenId` will be minted for `to`.
943      * - When `to` is zero, ``from``'s `tokenId` will be burned.
944      * - `from` cannot be the zero address.
945      * - `to` cannot be the zero address.
946      *
947      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
948      */
949     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
950         super._beforeTokenTransfer(from, to, tokenId);
951 
952         if (from == address(0)) {
953             _addTokenToAllTokensEnumeration(tokenId);
954         } else if (from != to) {
955             _removeTokenFromOwnerEnumeration(from, tokenId);
956         }
957         if (to == address(0)) {
958             _removeTokenFromAllTokensEnumeration(tokenId);
959         } else if (to != from) {
960             _addTokenToOwnerEnumeration(to, tokenId);
961         }
962     }
963 
964     /**
965      * @dev Private function to add a token to this extension's ownership-tracking data structures.
966      * @param to address representing the new owner of the given token ID
967      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
968      */
969     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
970         uint256 length = ERC721.balanceOf(to);
971         _ownedTokens[to][length] = tokenId;
972         _ownedTokensIndex[tokenId] = length;
973     }
974 
975     /**
976      * @dev Private function to add a token to this extension's token tracking data structures.
977      * @param tokenId uint256 ID of the token to be added to the tokens list
978      */
979     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
980         _allTokensIndex[tokenId] = _allTokens.length;
981         _allTokens.push(tokenId);
982     }
983 
984     /**
985      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
986      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
987      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
988      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
989      * @param from address representing the previous owner of the given token ID
990      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
991      */
992     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
993         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
994         // then delete the last slot (swap and pop).
995 
996         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
997         uint256 tokenIndex = _ownedTokensIndex[tokenId];
998 
999         // When the token to delete is the last token, the swap operation is unnecessary
1000         if (tokenIndex != lastTokenIndex) {
1001             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1002 
1003             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1004             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1005         }
1006 
1007         // This also deletes the contents at the last position of the array
1008         delete _ownedTokensIndex[tokenId];
1009         delete _ownedTokens[from][lastTokenIndex];
1010     }
1011 
1012     /**
1013      * @dev Private function to remove a token from this extension's token tracking data structures.
1014      * This has O(1) time complexity, but alters the order of the _allTokens array.
1015      * @param tokenId uint256 ID of the token to be removed from the tokens list
1016      */
1017     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1018         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1019         // then delete the last slot (swap and pop).
1020 
1021         uint256 lastTokenIndex = _allTokens.length - 1;
1022         uint256 tokenIndex = _allTokensIndex[tokenId];
1023 
1024         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1025         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1026         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1027         uint256 lastTokenId = _allTokens[lastTokenIndex];
1028 
1029         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1030         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1031 
1032         // This also deletes the contents at the last position of the array
1033         delete _allTokensIndex[tokenId];
1034         _allTokens.pop();
1035     }
1036 }
1037 
1038 // 
1039 /**
1040  * @dev Contract module which provides a basic access control mechanism, where
1041  * there is an account (an owner) that can be granted exclusive access to
1042  * specific functions.
1043  *
1044  * By default, the owner account will be the one that deploys the contract. This
1045  * can later be changed with {transferOwnership}.
1046  *
1047  * This module is used through inheritance. It will make available the modifier
1048  * `onlyOwner`, which can be applied to your functions to restrict their use to
1049  * the owner.
1050  */
1051 abstract contract Ownable is Context {
1052     address private _owner;
1053 
1054     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1055 
1056     /**
1057      * @dev Initializes the contract setting the deployer as the initial owner.
1058      */
1059     constructor () {
1060         address msgSender = _msgSender();
1061         _owner = msgSender;
1062         emit OwnershipTransferred(address(0), msgSender);
1063     }
1064 
1065     /**
1066      * @dev Returns the address of the current owner.
1067      */
1068     function owner() public view virtual returns (address) {
1069         return _owner;
1070     }
1071 
1072     /**
1073      * @dev Throws if called by any account other than the owner.
1074      */
1075     modifier onlyOwner() {
1076         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1077         _;
1078     }
1079 
1080     /**
1081      * @dev Leaves the contract without owner. It will not be possible to call
1082      * `onlyOwner` functions anymore. Can only be called by the current owner.
1083      *
1084      * NOTE: Renouncing ownership will leave the contract without an owner,
1085      * thereby removing any functionality that is only available to the owner.
1086      */
1087     function renounceOwnership() public virtual onlyOwner {
1088         emit OwnershipTransferred(_owner, address(0));
1089         _owner = address(0);
1090     }
1091 
1092     /**
1093      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1094      * Can only be called by the current owner.
1095      */
1096     function transferOwnership(address newOwner) public virtual onlyOwner {
1097         require(newOwner != address(0), "Ownable: new owner is the zero address");
1098         emit OwnershipTransferred(_owner, newOwner);
1099         _owner = newOwner;
1100     }
1101 }
1102 
1103 // 
1104 /**
1105  * @dev Contract module that helps prevent reentrant calls to a function.
1106  *
1107  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1108  * available, which can be applied to functions to make sure there are no nested
1109  * (reentrant) calls to them.
1110  *
1111  * Note that because there is a single `nonReentrant` guard, functions marked as
1112  * `nonReentrant` may not call one another. This can be worked around by making
1113  * those functions `private`, and then adding `external` `nonReentrant` entry
1114  * points to them.
1115  *
1116  * TIP: If you would like to learn more about reentrancy and alternative ways
1117  * to protect against it, check out our blog post
1118  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1119  */
1120 abstract contract ReentrancyGuard {
1121     // Booleans are more expensive than uint256 or any type that takes up a full
1122     // word because each write operation emits an extra SLOAD to first read the
1123     // slot's contents, replace the bits taken up by the boolean, and then write
1124     // back. This is the compiler's defense against contract upgrades and
1125     // pointer aliasing, and it cannot be disabled.
1126 
1127     // The values being non-zero value makes deployment a bit more expensive,
1128     // but in exchange the refund on every call to nonReentrant will be lower in
1129     // amount. Since refunds are capped to a percentage of the total
1130     // transaction's gas, it is best to keep them low in cases like this one, to
1131     // increase the likelihood of the full refund coming into effect.
1132     uint256 private constant _NOT_ENTERED = 1;
1133     uint256 private constant _ENTERED = 2;
1134 
1135     uint256 private _status;
1136 
1137     constructor () {
1138         _status = _NOT_ENTERED;
1139     }
1140 
1141     /**
1142      * @dev Prevents a contract from calling itself, directly or indirectly.
1143      * Calling a `nonReentrant` function from another `nonReentrant`
1144      * function is not supported. It is possible to prevent this from happening
1145      * by making the `nonReentrant` function external, and make it call a
1146      * `private` function that does the actual work.
1147      */
1148     modifier nonReentrant() {
1149         // On the first call to nonReentrant, _notEntered will be true
1150         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1151 
1152         // Any calls to nonReentrant after this point will fail
1153         _status = _ENTERED;
1154 
1155         _;
1156 
1157         // By storing the original value once again, a refund is triggered (see
1158         // https://eips.ethereum.org/EIPS/eip-2200)
1159         _status = _NOT_ENTERED;
1160     }
1161 }
1162 
1163 // 
1164 /**
1165  * @title TDBC contract v1
1166  * @author @darkp0rt
1167  *     _____            ____             .-^-.
1168  *   |_   _|___ ___   |    \ ___ ___    '"'|`"`
1169  *     | | | . | . |  |  |  | . | . |      j
1170  *     |_| |___|  _|  |____/|___|_  |
1171  *             |_|              |___|
1172  *    _____             _      _____ _     _   
1173  *   | __  |___ ___ ___| |_   |     | |_ _| |_ 
1174  *   | __ -| -_| .'|  _|   |  |   --| | | | . |
1175  *   |_____|___|__,|___|_|_|  |_____|_|___|___|
1176  */
1177 contract TopDogBeachClub is ERC721Enumerable, Ownable, ReentrancyGuard {
1178     /// @dev Solidity 0.8.0+ gives us safe math ops by default so there is no need to use SafeMath == cheaper gas
1179 
1180     enum FounderMemberClaimStatus { Invalid, Unclaimed, Claimed }
1181 
1182     uint256 private constant MAX_DOGS = 8000;
1183     uint256 private constant DEV_DOGGOS = 50;
1184     uint256 private constant DOGS_PER_TX = 10;
1185     uint256 private constant PRESALE_MAX_DOGGOS = 500;
1186     uint256 private constant DOG_PRICE = 0.08 ether;
1187 
1188     string public TDBC_PROVENANCE;
1189     bool private _isPublicSaleActive = false;
1190     bool private _isPreSaleActive = false;
1191     mapping (uint256 => uint256) private _doggoBirthdays;
1192     mapping (address => FounderMemberClaimStatus) private _foundingMemberClaims;
1193     string private _baseTokenURI;
1194 
1195     constructor (string memory name, string memory symbol, string memory baseTokenURI) ERC721(name, symbol) {
1196         _baseTokenURI = baseTokenURI;
1197     }
1198 
1199     function withdraw() public onlyOwner {
1200         require(payable(msg.sender).send(address(this).balance), ":-(");
1201     }
1202 
1203     function togglePublicSale() external onlyOwner {
1204         _isPublicSaleActive = !_isPublicSaleActive;
1205     }
1206 
1207     function togglePreSale() external onlyOwner {
1208         _isPreSaleActive = !_isPreSaleActive;
1209     }
1210 
1211     function isPublicSaleActive() external view returns (bool status) {
1212         return _isPublicSaleActive;
1213     }
1214 
1215     function isPreSaleActive() external view returns (bool status) {
1216         return _isPreSaleActive;
1217     }
1218 
1219     /*
1220     * A SHA256 hash representing all 8000 dogs. Will be set once all 8k are born
1221     */
1222     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1223         TDBC_PROVENANCE = provenanceHash;
1224     }
1225 
1226     function setBaseTokenURI(string memory baseTokenURI) public onlyOwner {
1227         _baseTokenURI = baseTokenURI;
1228     }
1229 
1230     /*
1231     * Message Jakub "Belly rub pls" on Discord
1232     */
1233     function mintPublic(uint256 amount) external payable nonReentrant() {
1234         require(_isPublicSaleActive, "Public sale is not active");
1235         require(amount > 0 && amount <= DOGS_PER_TX, "You can't mint that many doggos");
1236         require(totalSupply() + amount <= MAX_DOGS, "Mint would exceed max supply of doggos");
1237         require(msg.value == amount * DOG_PRICE, "You didn't send the right amount of eth");
1238         
1239         _mintMultiple(msg.sender, amount);
1240     }
1241 
1242     function mintFoundingMember() external payable nonReentrant() {
1243         require(_isPreSaleActive, "Pre-sale is not active");
1244         require(_foundingMemberClaims[msg.sender] != FounderMemberClaimStatus.Claimed, "You've already claimed your doggo");
1245         require(_foundingMemberClaims[msg.sender] == FounderMemberClaimStatus.Unclaimed, "You are not a founding member");
1246         require(totalSupply() + 1 < PRESALE_MAX_DOGGOS, "Mint would exceed max pre-sale doggos"); // should never happen but a saftey net
1247         require(totalSupply() + 1 <= MAX_DOGS, "Mint would exceed max supply of doggos");
1248         require(msg.value == 1 * DOG_PRICE, "You didn't send the right amount of eth");
1249         
1250         _mintMultiple(msg.sender, 1);
1251         _foundingMemberClaims[msg.sender] = FounderMemberClaimStatus.Claimed;
1252     }
1253 
1254     function addFoundingMembers(address[] memory members) external onlyOwner {
1255         for (uint256 i = 0; i < members.length; i++) {
1256             _foundingMemberClaims[members[i]] = FounderMemberClaimStatus.Unclaimed;
1257         }
1258     }
1259 
1260     /*
1261     * Sets aside some doggos for the dev team, used for competitions, giveaways and mods memberships
1262     */
1263     function reserve() external onlyOwner {
1264         require(balanceOf(msg.sender) < DEV_DOGGOS, ":-(");
1265         _mintMultiple(msg.sender, DEV_DOGGOS);
1266     }
1267 
1268     /**
1269      * @notice Returns a list of all tokenIds assigned to an address - used by the TDBC website
1270      * Taken from https://ethereum.stackexchange.com/questions/54959/list-erc721-tokens-owned-by-a-user-on-a-web-page
1271      * @param user get tokens of a given user
1272      */
1273     function tokensOfOwner(address user) external view returns (uint256[] memory ownerTokens) {
1274         uint256 tokenCount = balanceOf(user);
1275 
1276         if (tokenCount == 0) {
1277             return new uint256[](0);
1278         } else {
1279             uint256[] memory output = new uint256[](tokenCount);
1280 
1281             for (uint256 index = 0; index < tokenCount; index++) {
1282                 output[index] = tokenOfOwnerByIndex(user, index);
1283             }
1284             
1285             return output;
1286         }
1287     }
1288 
1289     /*
1290      * I hope you bought cake?
1291     */
1292     function getBirthday(uint256 tokenId) external view returns (uint256) {
1293         require(tokenId < totalSupply(), "That doggo has not been born yet :-(");
1294 
1295         return _doggoBirthdays[tokenId];
1296     }
1297 
1298     function _mintMultiple(address owner, uint256 amount) private {
1299         for (uint256 i = 0; i < amount; i++) {
1300             uint256 tokenId = totalSupply();
1301             _doggoBirthdays[tokenId] = block.timestamp;
1302             _safeMint(owner, tokenId);
1303         }
1304     }
1305 
1306     function _baseURI() internal view virtual override returns (string memory) {
1307         return _baseTokenURI;
1308     }
1309 }