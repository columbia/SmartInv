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
1040  * @dev Interface of the ERC20 standard as defined in the EIP.
1041  */
1042 interface IERC20 {
1043     /**
1044      * @dev Returns the amount of tokens in existence.
1045      */
1046     function totalSupply() external view returns (uint256);
1047 
1048     /**
1049      * @dev Returns the amount of tokens owned by `account`.
1050      */
1051     function balanceOf(address account) external view returns (uint256);
1052 
1053     /**
1054      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1055      *
1056      * Returns a boolean value indicating whether the operation succeeded.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function transfer(address recipient, uint256 amount) external returns (bool);
1061 
1062     /**
1063      * @dev Returns the remaining number of tokens that `spender` will be
1064      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1065      * zero by default.
1066      *
1067      * This value changes when {approve} or {transferFrom} are called.
1068      */
1069     function allowance(address owner, address spender) external view returns (uint256);
1070 
1071     /**
1072      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1073      *
1074      * Returns a boolean value indicating whether the operation succeeded.
1075      *
1076      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1077      * that someone may use both the old and the new allowance by unfortunate
1078      * transaction ordering. One possible solution to mitigate this race
1079      * condition is to first reduce the spender's allowance to 0 and set the
1080      * desired value afterwards:
1081      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1082      *
1083      * Emits an {Approval} event.
1084      */
1085     function approve(address spender, uint256 amount) external returns (bool);
1086 
1087     /**
1088      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1089      * allowance mechanism. `amount` is then deducted from the caller's
1090      * allowance.
1091      *
1092      * Returns a boolean value indicating whether the operation succeeded.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1097 
1098     /**
1099      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1100      * another (`to`).
1101      *
1102      * Note that `value` may be zero.
1103      */
1104     event Transfer(address indexed from, address indexed to, uint256 value);
1105 
1106     /**
1107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1108      * a call to {approve}. `value` is the new allowance.
1109      */
1110     event Approval(address indexed owner, address indexed spender, uint256 value);
1111 }
1112 
1113 // 
1114 /**
1115  * @dev Interface for the optional metadata functions from the ERC20 standard.
1116  *
1117  * _Available since v4.1._
1118  */
1119 interface IERC20Metadata is IERC20 {
1120     /**
1121      * @dev Returns the name of the token.
1122      */
1123     function name() external view returns (string memory);
1124 
1125     /**
1126      * @dev Returns the symbol of the token.
1127      */
1128     function symbol() external view returns (string memory);
1129 
1130     /**
1131      * @dev Returns the decimals places of the token.
1132      */
1133     function decimals() external view returns (uint8);
1134 }
1135 
1136 // 
1137 /**
1138  * @dev Implementation of the {IERC20} interface.
1139  *
1140  * This implementation is agnostic to the way tokens are created. This means
1141  * that a supply mechanism has to be added in a derived contract using {_mint}.
1142  * For a generic mechanism see {ERC20PresetMinterPauser}.
1143  *
1144  * TIP: For a detailed writeup see our guide
1145  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1146  * to implement supply mechanisms].
1147  *
1148  * We have followed general OpenZeppelin guidelines: functions revert instead
1149  * of returning `false` on failure. This behavior is nonetheless conventional
1150  * and does not conflict with the expectations of ERC20 applications.
1151  *
1152  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1153  * This allows applications to reconstruct the allowance for all accounts just
1154  * by listening to said events. Other implementations of the EIP may not emit
1155  * these events, as it isn't required by the specification.
1156  *
1157  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1158  * functions have been added to mitigate the well-known issues around setting
1159  * allowances. See {IERC20-approve}.
1160  */
1161 contract ERC20 is Context, IERC20, IERC20Metadata {
1162     mapping (address => uint256) private _balances;
1163 
1164     mapping (address => mapping (address => uint256)) private _allowances;
1165 
1166     uint256 private _totalSupply;
1167 
1168     string private _name;
1169     string private _symbol;
1170 
1171     /**
1172      * @dev Sets the values for {name} and {symbol}.
1173      *
1174      * The defaut value of {decimals} is 18. To select a different value for
1175      * {decimals} you should overload it.
1176      *
1177      * All two of these values are immutable: they can only be set once during
1178      * construction.
1179      */
1180     constructor (string memory name_, string memory symbol_) {
1181         _name = name_;
1182         _symbol = symbol_;
1183     }
1184 
1185     /**
1186      * @dev Returns the name of the token.
1187      */
1188     function name() public view virtual override returns (string memory) {
1189         return _name;
1190     }
1191 
1192     /**
1193      * @dev Returns the symbol of the token, usually a shorter version of the
1194      * name.
1195      */
1196     function symbol() public view virtual override returns (string memory) {
1197         return _symbol;
1198     }
1199 
1200     /**
1201      * @dev Returns the number of decimals used to get its user representation.
1202      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1203      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1204      *
1205      * Tokens usually opt for a value of 18, imitating the relationship between
1206      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1207      * overridden;
1208      *
1209      * NOTE: This information is only used for _display_ purposes: it in
1210      * no way affects any of the arithmetic of the contract, including
1211      * {IERC20-balanceOf} and {IERC20-transfer}.
1212      */
1213     function decimals() public view virtual override returns (uint8) {
1214         return 18;
1215     }
1216 
1217     /**
1218      * @dev See {IERC20-totalSupply}.
1219      */
1220     function totalSupply() public view virtual override returns (uint256) {
1221         return _totalSupply;
1222     }
1223 
1224     /**
1225      * @dev See {IERC20-balanceOf}.
1226      */
1227     function balanceOf(address account) public view virtual override returns (uint256) {
1228         return _balances[account];
1229     }
1230 
1231     /**
1232      * @dev See {IERC20-transfer}.
1233      *
1234      * Requirements:
1235      *
1236      * - `recipient` cannot be the zero address.
1237      * - the caller must have a balance of at least `amount`.
1238      */
1239     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1240         _transfer(_msgSender(), recipient, amount);
1241         return true;
1242     }
1243 
1244     /**
1245      * @dev See {IERC20-allowance}.
1246      */
1247     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1248         return _allowances[owner][spender];
1249     }
1250 
1251     /**
1252      * @dev See {IERC20-approve}.
1253      *
1254      * Requirements:
1255      *
1256      * - `spender` cannot be the zero address.
1257      */
1258     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1259         _approve(_msgSender(), spender, amount);
1260         return true;
1261     }
1262 
1263     /**
1264      * @dev See {IERC20-transferFrom}.
1265      *
1266      * Emits an {Approval} event indicating the updated allowance. This is not
1267      * required by the EIP. See the note at the beginning of {ERC20}.
1268      *
1269      * Requirements:
1270      *
1271      * - `sender` and `recipient` cannot be the zero address.
1272      * - `sender` must have a balance of at least `amount`.
1273      * - the caller must have allowance for ``sender``'s tokens of at least
1274      * `amount`.
1275      */
1276     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1277         _transfer(sender, recipient, amount);
1278 
1279         uint256 currentAllowance = _allowances[sender][_msgSender()];
1280         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1281         _approve(sender, _msgSender(), currentAllowance - amount);
1282 
1283         return true;
1284     }
1285 
1286     /**
1287      * @dev Atomically increases the allowance granted to `spender` by the caller.
1288      *
1289      * This is an alternative to {approve} that can be used as a mitigation for
1290      * problems described in {IERC20-approve}.
1291      *
1292      * Emits an {Approval} event indicating the updated allowance.
1293      *
1294      * Requirements:
1295      *
1296      * - `spender` cannot be the zero address.
1297      */
1298     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1299         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1300         return true;
1301     }
1302 
1303     /**
1304      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1305      *
1306      * This is an alternative to {approve} that can be used as a mitigation for
1307      * problems described in {IERC20-approve}.
1308      *
1309      * Emits an {Approval} event indicating the updated allowance.
1310      *
1311      * Requirements:
1312      *
1313      * - `spender` cannot be the zero address.
1314      * - `spender` must have allowance for the caller of at least
1315      * `subtractedValue`.
1316      */
1317     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1318         uint256 currentAllowance = _allowances[_msgSender()][spender];
1319         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1320         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1321 
1322         return true;
1323     }
1324 
1325     /**
1326      * @dev Moves tokens `amount` from `sender` to `recipient`.
1327      *
1328      * This is internal function is equivalent to {transfer}, and can be used to
1329      * e.g. implement automatic token fees, slashing mechanisms, etc.
1330      *
1331      * Emits a {Transfer} event.
1332      *
1333      * Requirements:
1334      *
1335      * - `sender` cannot be the zero address.
1336      * - `recipient` cannot be the zero address.
1337      * - `sender` must have a balance of at least `amount`.
1338      */
1339     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1340         require(sender != address(0), "ERC20: transfer from the zero address");
1341         require(recipient != address(0), "ERC20: transfer to the zero address");
1342 
1343         _beforeTokenTransfer(sender, recipient, amount);
1344 
1345         uint256 senderBalance = _balances[sender];
1346         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1347         _balances[sender] = senderBalance - amount;
1348         _balances[recipient] += amount;
1349 
1350         emit Transfer(sender, recipient, amount);
1351     }
1352 
1353     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1354      * the total supply.
1355      *
1356      * Emits a {Transfer} event with `from` set to the zero address.
1357      *
1358      * Requirements:
1359      *
1360      * - `to` cannot be the zero address.
1361      */
1362     function _mint(address account, uint256 amount) internal virtual {
1363         require(account != address(0), "ERC20: mint to the zero address");
1364 
1365         _beforeTokenTransfer(address(0), account, amount);
1366 
1367         _totalSupply += amount;
1368         _balances[account] += amount;
1369         emit Transfer(address(0), account, amount);
1370     }
1371 
1372     /**
1373      * @dev Destroys `amount` tokens from `account`, reducing the
1374      * total supply.
1375      *
1376      * Emits a {Transfer} event with `to` set to the zero address.
1377      *
1378      * Requirements:
1379      *
1380      * - `account` cannot be the zero address.
1381      * - `account` must have at least `amount` tokens.
1382      */
1383     function _burn(address account, uint256 amount) internal virtual {
1384         require(account != address(0), "ERC20: burn from the zero address");
1385 
1386         _beforeTokenTransfer(account, address(0), amount);
1387 
1388         uint256 accountBalance = _balances[account];
1389         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1390         _balances[account] = accountBalance - amount;
1391         _totalSupply -= amount;
1392 
1393         emit Transfer(account, address(0), amount);
1394     }
1395 
1396     /**
1397      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1398      *
1399      * This internal function is equivalent to `approve`, and can be used to
1400      * e.g. set automatic allowances for certain subsystems, etc.
1401      *
1402      * Emits an {Approval} event.
1403      *
1404      * Requirements:
1405      *
1406      * - `owner` cannot be the zero address.
1407      * - `spender` cannot be the zero address.
1408      */
1409     function _approve(address owner, address spender, uint256 amount) internal virtual {
1410         require(owner != address(0), "ERC20: approve from the zero address");
1411         require(spender != address(0), "ERC20: approve to the zero address");
1412 
1413         _allowances[owner][spender] = amount;
1414         emit Approval(owner, spender, amount);
1415     }
1416 
1417     /**
1418      * @dev Hook that is called before any transfer of tokens. This includes
1419      * minting and burning.
1420      *
1421      * Calling conditions:
1422      *
1423      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1424      * will be to transferred to `to`.
1425      * - when `from` is zero, `amount` tokens will be minted for `to`.
1426      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1427      * - `from` and `to` are never both zero.
1428      *
1429      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1430      */
1431     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1432 }
1433 
1434 // 
1435 /**
1436  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1437  * tokens and those that they have an allowance for, in a way that can be
1438  * recognized off-chain (via event analysis).
1439  */
1440 abstract contract ERC20Burnable is Context, ERC20 {
1441     /**
1442      * @dev Destroys `amount` tokens from the caller.
1443      *
1444      * See {ERC20-_burn}.
1445      */
1446     function burn(uint256 amount) public virtual {
1447         _burn(_msgSender(), amount);
1448     }
1449 
1450     /**
1451      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1452      * allowance.
1453      *
1454      * See {ERC20-_burn} and {ERC20-allowance}.
1455      *
1456      * Requirements:
1457      *
1458      * - the caller must have allowance for ``accounts``'s tokens of at least
1459      * `amount`.
1460      */
1461     function burnFrom(address account, uint256 amount) public virtual {
1462         uint256 currentAllowance = allowance(account, _msgSender());
1463         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1464         _approve(account, _msgSender(), currentAllowance - amount);
1465         _burn(account, amount);
1466     }
1467 }
1468 
1469 // 
1470 /**
1471  * @dev Contract module which allows children to implement an emergency stop
1472  * mechanism that can be triggered by an authorized account.
1473  *
1474  * This module is used through inheritance. It will make available the
1475  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1476  * the functions of your contract. Note that they will not be pausable by
1477  * simply including this module, only once the modifiers are put in place.
1478  */
1479 abstract contract Pausable is Context {
1480     /**
1481      * @dev Emitted when the pause is triggered by `account`.
1482      */
1483     event Paused(address account);
1484 
1485     /**
1486      * @dev Emitted when the pause is lifted by `account`.
1487      */
1488     event Unpaused(address account);
1489 
1490     bool private _paused;
1491 
1492     /**
1493      * @dev Initializes the contract in unpaused state.
1494      */
1495     constructor () {
1496         _paused = false;
1497     }
1498 
1499     /**
1500      * @dev Returns true if the contract is paused, and false otherwise.
1501      */
1502     function paused() public view virtual returns (bool) {
1503         return _paused;
1504     }
1505 
1506     /**
1507      * @dev Modifier to make a function callable only when the contract is not paused.
1508      *
1509      * Requirements:
1510      *
1511      * - The contract must not be paused.
1512      */
1513     modifier whenNotPaused() {
1514         require(!paused(), "Pausable: paused");
1515         _;
1516     }
1517 
1518     /**
1519      * @dev Modifier to make a function callable only when the contract is paused.
1520      *
1521      * Requirements:
1522      *
1523      * - The contract must be paused.
1524      */
1525     modifier whenPaused() {
1526         require(paused(), "Pausable: not paused");
1527         _;
1528     }
1529 
1530     /**
1531      * @dev Triggers stopped state.
1532      *
1533      * Requirements:
1534      *
1535      * - The contract must not be paused.
1536      */
1537     function _pause() internal virtual whenNotPaused {
1538         _paused = true;
1539         emit Paused(_msgSender());
1540     }
1541 
1542     /**
1543      * @dev Returns to normal state.
1544      *
1545      * Requirements:
1546      *
1547      * - The contract must be paused.
1548      */
1549     function _unpause() internal virtual whenPaused {
1550         _paused = false;
1551         emit Unpaused(_msgSender());
1552     }
1553 }
1554 
1555 // 
1556 /**
1557  * @dev ERC20 token with pausable token transfers, minting and burning.
1558  *
1559  * Useful for scenarios such as preventing trades until the end of an evaluation
1560  * period, or having an emergency switch for freezing all token transfers in the
1561  * event of a large bug.
1562  */
1563 abstract contract ERC20Pausable is ERC20, Pausable {
1564     /**
1565      * @dev See {ERC20-_beforeTokenTransfer}.
1566      *
1567      * Requirements:
1568      *
1569      * - the contract must not be paused.
1570      */
1571     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1572         super._beforeTokenTransfer(from, to, amount);
1573 
1574         require(!paused(), "ERC20Pausable: token transfer while paused");
1575     }
1576 }
1577 
1578 // 
1579 /**
1580  * @dev Contract module which provides a basic access control mechanism, where
1581  * there is an account (an owner) that can be granted exclusive access to
1582  * specific functions.
1583  *
1584  * By default, the owner account will be the one that deploys the contract. This
1585  * can later be changed with {transferOwnership}.
1586  *
1587  * This module is used through inheritance. It will make available the modifier
1588  * `onlyOwner`, which can be applied to your functions to restrict their use to
1589  * the owner.
1590  */
1591 abstract contract Ownable is Context {
1592     address private _owner;
1593 
1594     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1595 
1596     /**
1597      * @dev Initializes the contract setting the deployer as the initial owner.
1598      */
1599     constructor () {
1600         address msgSender = _msgSender();
1601         _owner = msgSender;
1602         emit OwnershipTransferred(address(0), msgSender);
1603     }
1604 
1605     /**
1606      * @dev Returns the address of the current owner.
1607      */
1608     function owner() public view virtual returns (address) {
1609         return _owner;
1610     }
1611 
1612     /**
1613      * @dev Throws if called by any account other than the owner.
1614      */
1615     modifier onlyOwner() {
1616         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1617         _;
1618     }
1619 
1620     /**
1621      * @dev Leaves the contract without owner. It will not be possible to call
1622      * `onlyOwner` functions anymore. Can only be called by the current owner.
1623      *
1624      * NOTE: Renouncing ownership will leave the contract without an owner,
1625      * thereby removing any functionality that is only available to the owner.
1626      */
1627     function renounceOwnership() public virtual onlyOwner {
1628         emit OwnershipTransferred(_owner, address(0));
1629         _owner = address(0);
1630     }
1631 
1632     /**
1633      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1634      * Can only be called by the current owner.
1635      */
1636     function transferOwnership(address newOwner) public virtual onlyOwner {
1637         require(newOwner != address(0), "Ownable: new owner is the zero address");
1638         emit OwnershipTransferred(_owner, newOwner);
1639         _owner = newOwner;
1640     }
1641 }
1642 
1643 // 
1644 interface ITopDogBeachClub is IERC721Enumerable {
1645     function getBirthday(uint256 tokenId) external view returns (uint256);
1646 }
1647 
1648 /**
1649  * @title SNAX
1650  * @author @darkp0rt
1651  *     _____            ____             .-^-.
1652  *   |_   _|___ ___   |    \ ___ ___    '"'|`"`
1653  *     | | | . | . |  |  |  | . | . |      j
1654  *     |_| |___|  _|  |____/|___|_  |
1655  *             |_|              |___|
1656  *    _____             _      _____ _     _   
1657  *   | __  |___ ___ ___| |_   |     | |_ _| |_ 
1658  *   | __ -| -_| .'|  _|   |  |   --| | | | . |
1659  *   |_____|___|__,|___|_|_|  |_____|_|___|___|
1660  */
1661 contract SNAXToken is Context, Ownable, ERC20Burnable, ERC20Pausable {
1662     uint256 private constant SECONDS_IN_A_DAY = 86400;
1663     uint256 private constant INITIAL_ALLOTMENT = 420 * (10 ** 18);
1664     uint256 private constant EMISSIONS_PER_DAY = 10 * (10 ** 18);
1665 
1666     mapping(uint256 => uint256) private _lastClaim;
1667     address private _tdbcAddress;
1668 
1669     constructor(string memory name, string memory symbol, address tdbcAddress) ERC20(name, symbol) {
1670         _tdbcAddress = tdbcAddress;
1671     }
1672 
1673     function accumulated(uint256 tokenId) public view returns (uint256) {
1674         require(ITopDogBeachClub(_tdbcAddress).ownerOf(tokenId) != address(0), "Nobody owns this doggo");
1675         require(tokenId < ITopDogBeachClub(_tdbcAddress).totalSupply(), "Doggo does not exist");
1676 
1677         uint256 lastClaimed = uint256(_lastClaim[tokenId]);
1678         uint256 doggoBirthday = ITopDogBeachClub(_tdbcAddress).getBirthday(tokenId);
1679         uint256 claimPeriod = lastClaimed == 0 ? doggoBirthday : lastClaimed;
1680         uint256 totalAccum = ((block.timestamp - claimPeriod) * EMISSIONS_PER_DAY) / SECONDS_IN_A_DAY;
1681 
1682         // give initial allotment if this doggo hasn't claimed it's tokens yet
1683         if (lastClaimed == 0) totalAccum = totalAccum + INITIAL_ALLOTMENT;
1684 
1685         return totalAccum;
1686     }
1687 
1688     function totalAccumulated(uint256[] memory tokenIds) public view returns (uint256) {
1689         uint256 totalAccum = 0;
1690         for (uint i = 0; i < tokenIds.length; i++) {
1691             totalAccum = totalAccum + accumulated(tokenIds[i]);
1692         }
1693 
1694         return totalAccum;
1695     }
1696 
1697     function claim(uint256[] memory tokenIds) public returns (uint256) {
1698         uint256 totalClaimQty = 0;
1699         for (uint i = 0; i < tokenIds.length; i++) {
1700             require(tokenIds[i] < ITopDogBeachClub(_tdbcAddress).totalSupply(), "Doggo does not exist");
1701 
1702             for (uint j = i + 1; j < tokenIds.length; j++) {
1703                 require(tokenIds[i] != tokenIds[j], "Duplicate token IDs");
1704             }
1705 
1706             uint tokenId = tokenIds[i];
1707             require(ITopDogBeachClub(_tdbcAddress).ownerOf(tokenId) == msg.sender, "Claimant is not the owner");
1708 
1709             uint256 claimQty = accumulated(tokenId);
1710             if (claimQty != 0) {
1711                 totalClaimQty = totalClaimQty + claimQty;
1712                 _lastClaim[tokenId] = block.timestamp;
1713             }
1714         }
1715 
1716         require(totalClaimQty != 0, "No accumulated $SNAX");
1717         _mint(msg.sender, totalClaimQty);
1718 
1719         return totalClaimQty;
1720     }
1721 
1722     function mint(address to, uint256 amount) public virtual onlyOwner {
1723         _mint(to, amount);
1724     }
1725 
1726     function pause() public virtual onlyOwner {
1727         _pause();
1728     }
1729 
1730     function unpause() public virtual onlyOwner {
1731         _unpause();
1732     }
1733 
1734     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1735         super._beforeTokenTransfer(from, to, amount);
1736     }
1737 }