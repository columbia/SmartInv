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
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
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
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 // 
167 /**
168  * @title ERC721 token receiver interface
169  * @dev Interface for any contract that wants to support safeTransfers
170  * from ERC721 asset contracts.
171  */
172 interface IERC721Receiver {
173     /**
174      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
175      * by `operator` from `from`, this function is called.
176      *
177      * It must return its Solidity selector to confirm the token transfer.
178      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
179      *
180      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
181      */
182     function onERC721Received(
183         address operator,
184         address from,
185         uint256 tokenId,
186         bytes calldata data
187     ) external returns (bytes4);
188 }
189 
190 // 
191 /**
192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
193  * @dev See https://eips.ethereum.org/EIPS/eip-721
194  */
195 interface IERC721Metadata is IERC721 {
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // 
213 /**
214  * @dev Collection of functions related to the address type
215  */
216 library Address {
217     /**
218      * @dev Returns true if `account` is a contract.
219      *
220      * [IMPORTANT]
221      * ====
222      * It is unsafe to assume that an address for which this function returns
223      * false is an externally-owned account (EOA) and not a contract.
224      *
225      * Among others, `isContract` will return false for the following
226      * types of addresses:
227      *
228      *  - an externally-owned account
229      *  - a contract in construction
230      *  - an address where a contract will be created
231      *  - an address where a contract lived, but was destroyed
232      * ====
233      */
234     function isContract(address account) internal view returns (bool) {
235         // This method relies on extcodesize, which returns 0 for contracts in
236         // construction, since the code is only stored at the end of the
237         // constructor execution.
238 
239         uint256 size;
240         assembly {
241             size := extcodesize(account)
242         }
243         return size > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         (bool success, ) = recipient.call{value: amount}("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 
269     /**
270      * @dev Performs a Solidity function call using a low level `call`. A
271      * plain `call` is an unsafe replacement for a function call: use this
272      * function instead.
273      *
274      * If `target` reverts with a revert reason, it is bubbled up by this
275      * function (like regular Solidity function calls).
276      *
277      * Returns the raw returned data. To convert to the expected return value,
278      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
279      *
280      * Requirements:
281      *
282      * - `target` must be a contract.
283      * - calling `target` with `data` must not revert.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionCall(target, data, "Address: low-level call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
293      * `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(data);
340         return _verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
350         return functionStaticCall(target, data, "Address: low-level static call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return _verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return _verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     function _verifyCallResult(
398         bool success,
399         bytes memory returndata,
400         string memory errorMessage
401     ) private pure returns (bytes memory) {
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 // 
421 /*
422  * @dev Provides information about the current execution context, including the
423  * sender of the transaction and its data. While these are generally available
424  * via msg.sender and msg.data, they should not be accessed in such a direct
425  * manner, since when dealing with meta-transactions the account sending and
426  * paying for execution may not be the actual sender (as far as an application
427  * is concerned).
428  *
429  * This contract is only required for intermediate, library-like contracts.
430  */
431 abstract contract Context {
432     function _msgSender() internal view virtual returns (address) {
433         return msg.sender;
434     }
435 
436     function _msgData() internal view virtual returns (bytes calldata) {
437         return msg.data;
438     }
439 }
440 
441 // 
442 /**
443  * @dev String operations.
444  */
445 library Strings {
446     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
450      */
451     function toString(uint256 value) internal pure returns (string memory) {
452         // Inspired by OraclizeAPI's implementation - MIT licence
453         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
454 
455         if (value == 0) {
456             return "0";
457         }
458         uint256 temp = value;
459         uint256 digits;
460         while (temp != 0) {
461             digits++;
462             temp /= 10;
463         }
464         bytes memory buffer = new bytes(digits);
465         while (value != 0) {
466             digits -= 1;
467             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
468             value /= 10;
469         }
470         return string(buffer);
471     }
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
475      */
476     function toHexString(uint256 value) internal pure returns (string memory) {
477         if (value == 0) {
478             return "0x00";
479         }
480         uint256 temp = value;
481         uint256 length = 0;
482         while (temp != 0) {
483             length++;
484             temp >>= 8;
485         }
486         return toHexString(value, length);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
491      */
492     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
493         bytes memory buffer = new bytes(2 * length + 2);
494         buffer[0] = "0";
495         buffer[1] = "x";
496         for (uint256 i = 2 * length + 1; i > 1; --i) {
497             buffer[i] = _HEX_SYMBOLS[value & 0xf];
498             value >>= 4;
499         }
500         require(value == 0, "Strings: hex length insufficient");
501         return string(buffer);
502     }
503 }
504 
505 // 
506 /**
507  * @dev Implementation of the {IERC165} interface.
508  *
509  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
510  * for the additional interface id that will be supported. For example:
511  *
512  * ```solidity
513  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
515  * }
516  * ```
517  *
518  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
519  */
520 abstract contract ERC165 is IERC165 {
521     /**
522      * @dev See {IERC165-supportsInterface}.
523      */
524     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525         return interfaceId == type(IERC165).interfaceId;
526     }
527 }
528 
529 // 
530 /**
531  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
532  * the Metadata extension, but not including the Enumerable extension, which is available separately as
533  * {ERC721Enumerable}.
534  */
535 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
536     using Address for address;
537     using Strings for uint256;
538 
539     // Token name
540     string private _name;
541 
542     // Token symbol
543     string private _symbol;
544 
545     // Mapping from token ID to owner address
546     mapping(uint256 => address) private _owners;
547 
548     // Mapping owner address to token count
549     mapping(address => uint256) private _balances;
550 
551     // Mapping from token ID to approved address
552     mapping(uint256 => address) private _tokenApprovals;
553 
554     // Mapping from owner to operator approvals
555     mapping(address => mapping(address => bool)) private _operatorApprovals;
556 
557     /**
558      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
559      */
560     constructor(string memory name_, string memory symbol_) {
561         _name = name_;
562         _symbol = symbol_;
563     }
564 
565     /**
566      * @dev See {IERC165-supportsInterface}.
567      */
568     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
569         return
570             interfaceId == type(IERC721).interfaceId ||
571             interfaceId == type(IERC721Metadata).interfaceId ||
572             super.supportsInterface(interfaceId);
573     }
574 
575     /**
576      * @dev See {IERC721-balanceOf}.
577      */
578     function balanceOf(address owner) public view virtual override returns (uint256) {
579         require(owner != address(0), "ERC721: balance query for the zero address");
580         return _balances[owner];
581     }
582 
583     /**
584      * @dev See {IERC721-ownerOf}.
585      */
586     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
587         address owner = _owners[tokenId];
588         require(owner != address(0), "ERC721: owner query for nonexistent token");
589         return owner;
590     }
591 
592     /**
593      * @dev See {IERC721Metadata-name}.
594      */
595     function name() public view virtual override returns (string memory) {
596         return _name;
597     }
598 
599     /**
600      * @dev See {IERC721Metadata-symbol}.
601      */
602     function symbol() public view virtual override returns (string memory) {
603         return _symbol;
604     }
605 
606     /**
607      * @dev See {IERC721Metadata-tokenURI}.
608      */
609     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
610         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
611 
612         string memory baseURI = _baseURI();
613         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
614     }
615 
616     /**
617      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
618      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
619      * by default, can be overriden in child contracts.
620      */
621     function _baseURI() internal view virtual returns (string memory) {
622         return "";
623     }
624 
625     /**
626      * @dev See {IERC721-approve}.
627      */
628     function approve(address to, uint256 tokenId) public virtual override {
629         address owner = ERC721.ownerOf(tokenId);
630         require(to != owner, "ERC721: approval to current owner");
631 
632         require(
633             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
634             "ERC721: approve caller is not owner nor approved for all"
635         );
636 
637         _approve(to, tokenId);
638     }
639 
640     /**
641      * @dev See {IERC721-getApproved}.
642      */
643     function getApproved(uint256 tokenId) public view virtual override returns (address) {
644         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
645 
646         return _tokenApprovals[tokenId];
647     }
648 
649     /**
650      * @dev See {IERC721-setApprovalForAll}.
651      */
652     function setApprovalForAll(address operator, bool approved) public virtual override {
653         require(operator != _msgSender(), "ERC721: approve to caller");
654 
655         _operatorApprovals[_msgSender()][operator] = approved;
656         emit ApprovalForAll(_msgSender(), operator, approved);
657     }
658 
659     /**
660      * @dev See {IERC721-isApprovedForAll}.
661      */
662     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
663         return _operatorApprovals[owner][operator];
664     }
665 
666     /**
667      * @dev See {IERC721-transferFrom}.
668      */
669     function transferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) public virtual override {
674         //solhint-disable-next-line max-line-length
675         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
676 
677         _transfer(from, to, tokenId);
678     }
679 
680     /**
681      * @dev See {IERC721-safeTransferFrom}.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) public virtual override {
688         safeTransferFrom(from, to, tokenId, "");
689     }
690 
691     /**
692      * @dev See {IERC721-safeTransferFrom}.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes memory _data
699     ) public virtual override {
700         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
701         _safeTransfer(from, to, tokenId, _data);
702     }
703 
704     /**
705      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
706      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
707      *
708      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
709      *
710      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
711      * implement alternative mechanisms to perform token transfer, such as signature-based.
712      *
713      * Requirements:
714      *
715      * - `from` cannot be the zero address.
716      * - `to` cannot be the zero address.
717      * - `tokenId` token must exist and be owned by `from`.
718      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
719      *
720      * Emits a {Transfer} event.
721      */
722     function _safeTransfer(
723         address from,
724         address to,
725         uint256 tokenId,
726         bytes memory _data
727     ) internal virtual {
728         _transfer(from, to, tokenId);
729         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
730     }
731 
732     /**
733      * @dev Returns whether `tokenId` exists.
734      *
735      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
736      *
737      * Tokens start existing when they are minted (`_mint`),
738      * and stop existing when they are burned (`_burn`).
739      */
740     function _exists(uint256 tokenId) internal view virtual returns (bool) {
741         return _owners[tokenId] != address(0);
742     }
743 
744     /**
745      * @dev Returns whether `spender` is allowed to manage `tokenId`.
746      *
747      * Requirements:
748      *
749      * - `tokenId` must exist.
750      */
751     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
752         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
753         address owner = ERC721.ownerOf(tokenId);
754         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
755     }
756 
757     /**
758      * @dev Safely mints `tokenId` and transfers it to `to`.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must not exist.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function _safeMint(address to, uint256 tokenId) internal virtual {
768         _safeMint(to, tokenId, "");
769     }
770 
771     /**
772      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
773      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
774      */
775     function _safeMint(
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) internal virtual {
780         _mint(to, tokenId);
781         require(
782             _checkOnERC721Received(address(0), to, tokenId, _data),
783             "ERC721: transfer to non ERC721Receiver implementer"
784         );
785     }
786 
787     /**
788      * @dev Mints `tokenId` and transfers it to `to`.
789      *
790      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
791      *
792      * Requirements:
793      *
794      * - `tokenId` must not exist.
795      * - `to` cannot be the zero address.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _mint(address to, uint256 tokenId) internal virtual {
800         require(to != address(0), "ERC721: mint to the zero address");
801         require(!_exists(tokenId), "ERC721: token already minted");
802 
803         _beforeTokenTransfer(address(0), to, tokenId);
804 
805         _balances[to] += 1;
806         _owners[tokenId] = to;
807 
808         emit Transfer(address(0), to, tokenId);
809     }
810 
811     /**
812      * @dev Destroys `tokenId`.
813      * The approval is cleared when the token is burned.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _burn(uint256 tokenId) internal virtual {
822         address owner = ERC721.ownerOf(tokenId);
823 
824         _beforeTokenTransfer(owner, address(0), tokenId);
825 
826         // Clear approvals
827         _approve(address(0), tokenId);
828 
829         _balances[owner] -= 1;
830         delete _owners[tokenId];
831 
832         emit Transfer(owner, address(0), tokenId);
833     }
834 
835     /**
836      * @dev Transfers `tokenId` from `from` to `to`.
837      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
838      *
839      * Requirements:
840      *
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must be owned by `from`.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _transfer(
847         address from,
848         address to,
849         uint256 tokenId
850     ) internal virtual {
851         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
852         require(to != address(0), "ERC721: transfer to the zero address");
853 
854         _beforeTokenTransfer(from, to, tokenId);
855 
856         // Clear approvals from the previous owner
857         _approve(address(0), tokenId);
858 
859         _balances[from] -= 1;
860         _balances[to] += 1;
861         _owners[tokenId] = to;
862 
863         emit Transfer(from, to, tokenId);
864     }
865 
866     /**
867      * @dev Approve `to` to operate on `tokenId`
868      *
869      * Emits a {Approval} event.
870      */
871     function _approve(address to, uint256 tokenId) internal virtual {
872         _tokenApprovals[tokenId] = to;
873         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
874     }
875 
876     /**
877      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
878      * The call is not executed if the target address is not a contract.
879      *
880      * @param from address representing the previous owner of the given token ID
881      * @param to target address that will receive the tokens
882      * @param tokenId uint256 ID of the token to be transferred
883      * @param _data bytes optional data to send along with the call
884      * @return bool whether the call correctly returned the expected magic value
885      */
886     function _checkOnERC721Received(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) private returns (bool) {
892         if (to.isContract()) {
893             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
894                 return retval == IERC721Receiver(to).onERC721Received.selector;
895             } catch (bytes memory reason) {
896                 if (reason.length == 0) {
897                     revert("ERC721: transfer to non ERC721Receiver implementer");
898                 } else {
899                     assembly {
900                         revert(add(32, reason), mload(reason))
901                     }
902                 }
903             }
904         } else {
905             return true;
906         }
907     }
908 
909     /**
910      * @dev Hook that is called before any token transfer. This includes minting
911      * and burning.
912      *
913      * Calling conditions:
914      *
915      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
916      * transferred to `to`.
917      * - When `from` is zero, `tokenId` will be minted for `to`.
918      * - When `to` is zero, ``from``'s `tokenId` will be burned.
919      * - `from` and `to` are never both zero.
920      *
921      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
922      */
923     function _beforeTokenTransfer(
924         address from,
925         address to,
926         uint256 tokenId
927     ) internal virtual {}
928 }
929 
930 // 
931 /**
932  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
933  * @dev See https://eips.ethereum.org/EIPS/eip-721
934  */
935 interface IERC721Enumerable is IERC721 {
936     /**
937      * @dev Returns the total amount of tokens stored by the contract.
938      */
939     function totalSupply() external view returns (uint256);
940 
941     /**
942      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
943      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
944      */
945     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
946 
947     /**
948      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
949      * Use along with {totalSupply} to enumerate all tokens.
950      */
951     function tokenByIndex(uint256 index) external view returns (uint256);
952 }
953 
954 // 
955 /**
956  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
957  * enumerability of all the token ids in the contract as well as all token ids owned by each
958  * account.
959  */
960 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
961     // Mapping from owner to list of owned token IDs
962     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
963 
964     // Mapping from token ID to index of the owner tokens list
965     mapping(uint256 => uint256) private _ownedTokensIndex;
966 
967     // Array with all token ids, used for enumeration
968     uint256[] private _allTokens;
969 
970     // Mapping from token id to position in the allTokens array
971     mapping(uint256 => uint256) private _allTokensIndex;
972 
973     /**
974      * @dev See {IERC165-supportsInterface}.
975      */
976     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
977         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
978     }
979 
980     /**
981      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
982      */
983     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
984         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
985         return _ownedTokens[owner][index];
986     }
987 
988     /**
989      * @dev See {IERC721Enumerable-totalSupply}.
990      */
991     function totalSupply() public view virtual override returns (uint256) {
992         return _allTokens.length;
993     }
994 
995     /**
996      * @dev See {IERC721Enumerable-tokenByIndex}.
997      */
998     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
999         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1000         return _allTokens[index];
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before any token transfer. This includes minting
1005      * and burning.
1006      *
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` will be minted for `to`.
1012      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1013      * - `from` cannot be the zero address.
1014      * - `to` cannot be the zero address.
1015      *
1016      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1017      */
1018     function _beforeTokenTransfer(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) internal virtual override {
1023         super._beforeTokenTransfer(from, to, tokenId);
1024 
1025         if (from == address(0)) {
1026             _addTokenToAllTokensEnumeration(tokenId);
1027         } else if (from != to) {
1028             _removeTokenFromOwnerEnumeration(from, tokenId);
1029         }
1030         if (to == address(0)) {
1031             _removeTokenFromAllTokensEnumeration(tokenId);
1032         } else if (to != from) {
1033             _addTokenToOwnerEnumeration(to, tokenId);
1034         }
1035     }
1036 
1037     /**
1038      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1039      * @param to address representing the new owner of the given token ID
1040      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1041      */
1042     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1043         uint256 length = ERC721.balanceOf(to);
1044         _ownedTokens[to][length] = tokenId;
1045         _ownedTokensIndex[tokenId] = length;
1046     }
1047 
1048     /**
1049      * @dev Private function to add a token to this extension's token tracking data structures.
1050      * @param tokenId uint256 ID of the token to be added to the tokens list
1051      */
1052     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1053         _allTokensIndex[tokenId] = _allTokens.length;
1054         _allTokens.push(tokenId);
1055     }
1056 
1057     /**
1058      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1059      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1060      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1061      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1062      * @param from address representing the previous owner of the given token ID
1063      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1064      */
1065     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1066         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1067         // then delete the last slot (swap and pop).
1068 
1069         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1070         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1071 
1072         // When the token to delete is the last token, the swap operation is unnecessary
1073         if (tokenIndex != lastTokenIndex) {
1074             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1075 
1076             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1077             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1078         }
1079 
1080         // This also deletes the contents at the last position of the array
1081         delete _ownedTokensIndex[tokenId];
1082         delete _ownedTokens[from][lastTokenIndex];
1083     }
1084 
1085     /**
1086      * @dev Private function to remove a token from this extension's token tracking data structures.
1087      * This has O(1) time complexity, but alters the order of the _allTokens array.
1088      * @param tokenId uint256 ID of the token to be removed from the tokens list
1089      */
1090     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1091         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1092         // then delete the last slot (swap and pop).
1093 
1094         uint256 lastTokenIndex = _allTokens.length - 1;
1095         uint256 tokenIndex = _allTokensIndex[tokenId];
1096 
1097         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1098         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1099         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1100         uint256 lastTokenId = _allTokens[lastTokenIndex];
1101 
1102         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1103         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1104 
1105         // This also deletes the contents at the last position of the array
1106         delete _allTokensIndex[tokenId];
1107         _allTokens.pop();
1108     }
1109 }
1110 
1111 // 
1112 /**
1113  * @dev Contract module which provides a basic access control mechanism, where
1114  * there is an account (an owner) that can be granted exclusive access to
1115  * specific functions.
1116  *
1117  * By default, the owner account will be the one that deploys the contract. This
1118  * can later be changed with {transferOwnership}.
1119  *
1120  * This module is used through inheritance. It will make available the modifier
1121  * `onlyOwner`, which can be applied to your functions to restrict their use to
1122  * the owner.
1123  */
1124 abstract contract Ownable is Context {
1125     address private _owner;
1126 
1127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1128 
1129     /**
1130      * @dev Initializes the contract setting the deployer as the initial owner.
1131      */
1132     constructor() {
1133         _setOwner(_msgSender());
1134     }
1135 
1136     /**
1137      * @dev Returns the address of the current owner.
1138      */
1139     function owner() public view virtual returns (address) {
1140         return _owner;
1141     }
1142 
1143     /**
1144      * @dev Throws if called by any account other than the owner.
1145      */
1146     modifier onlyOwner() {
1147         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1148         _;
1149     }
1150 
1151     /**
1152      * @dev Leaves the contract without owner. It will not be possible to call
1153      * `onlyOwner` functions anymore. Can only be called by the current owner.
1154      *
1155      * NOTE: Renouncing ownership will leave the contract without an owner,
1156      * thereby removing any functionality that is only available to the owner.
1157      */
1158     function renounceOwnership() public virtual onlyOwner {
1159         _setOwner(address(0));
1160     }
1161 
1162     /**
1163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1164      * Can only be called by the current owner.
1165      */
1166     function transferOwnership(address newOwner) public virtual onlyOwner {
1167         require(newOwner != address(0), "Ownable: new owner is the zero address");
1168         _setOwner(newOwner);
1169     }
1170 
1171     function _setOwner(address newOwner) private {
1172         address oldOwner = _owner;
1173         _owner = newOwner;
1174         emit OwnershipTransferred(oldOwner, newOwner);
1175     }
1176 }
1177 
1178 // 
1179 interface CoolCats {
1180     function balanceOf(address owner) external view returns (uint256 balance);
1181     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1182 }
1183 
1184 interface FameLadySquad {
1185     function balanceOf(address owner) external view returns (uint256 balance);
1186     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1187 }
1188 
1189 interface WorldOfWomen {
1190     function balanceOf(address owner) external view returns (uint256 balance);
1191     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1192 }
1193 
1194 /**
1195 Miss Crypto Club Contract 
1196 */
1197 contract MissCryptoClub is ERC721Enumerable, Ownable {
1198 
1199     using Strings for uint256;
1200 
1201     // base URI
1202     string _baseTokenURI;
1203     // Price of each Miss
1204     uint256 private _price = 0.04 ether;
1205 
1206     // Maximum amount of Miss in existance 
1207     uint256 public constant _max_miss = 10000;
1208     // Reserved Miss for grant 
1209     uint256 public _max_grant_miss = 50;
1210     // Reserved Miss for give away 
1211     uint256 public _max_reserved_miss = 100;
1212     // Reserved Miss for discount 
1213     uint256 public _max_discount_miss = 500;
1214 
1215     // Pause sales
1216     bool public _paused = true;
1217     // Pause grant
1218     bool public _grant_paused = true;
1219 
1220     // Cool cat contract address
1221     address internal coolcat;
1222     // Fame Lady Squad contract address
1223     address internal famelady;
1224     // World of Women contract address
1225     address internal wow;
1226     // Save grant token in order to not re-grant for same coolcat/famelady/wow token
1227     mapping (uint256 => bool) public coolcatMints;
1228     mapping (uint256 => bool) public fameladyMints;
1229     mapping (uint256 => bool) public wowMints;
1230     // Save address of granter in order to allow one grant for coolcat/famelady/wow owner
1231     mapping (address => bool) public grantMints;
1232 
1233     // team addresses
1234     address mcc_crypto = 0x9EFf64424F2FeDb6B4D74771Ddb81C5742FE2c2c;
1235     address luke_crypto = 0x799CD72D86A6AA46876C2689A13637Cbe6ae89da;
1236     address kristen_crypto = 0x3E4FE6d222F63064b5f61486625594597a091B9a;
1237     
1238 
1239     constructor(string memory tokenURI, address _coolcatAddr, address _fameladyAddr, address _wowAddr) 
1240     ERC721("MissCryptoClub", "MCC") {
1241         setBaseURI(tokenURI);
1242         coolcat = _coolcatAddr;
1243         famelady = _fameladyAddr;
1244         wow = _wowAddr;
1245 
1246         // team mint first 3 Miss
1247         _safeMint( mcc_crypto, 0);
1248         _safeMint( luke_crypto, 1);
1249         _safeMint( kristen_crypto, 2);
1250     }
1251 
1252     /**
1253     * @dev Mint Miss
1254     */
1255     function mint(uint256 numberOfMiss) public payable {
1256         uint256 supply = totalSupply();
1257         require( !_paused,                              "Sale paused" );
1258         require( msg.value >= _price * numberOfMiss,             "Ether sent is not correct" );
1259         require( supply + numberOfMiss < _max_miss - _max_grant_miss - _max_discount_miss - _max_reserved_miss,      "Exceeds maximum Miss supply" );
1260         require(numberOfMiss > 0, "You cannot mint 0 Miss.");
1261         require(numberOfMiss <= 20, "You are not allowed to buy this many miss at once.");
1262 
1263         for(uint256 i; i < numberOfMiss; i++){
1264             _safeMint( msg.sender, supply + i );
1265         }
1266     }
1267 
1268     /**
1269     * @dev Grant Miss
1270     */
1271     function grantMiss() external {
1272         require(!_grant_paused, "Grant is not started.");
1273         require(grantMints[msg.sender] == false, "Already grant with this address");
1274         require(1 <= _max_grant_miss, "Exceeds grant Miss supply");
1275         
1276         uint256 supply = totalSupply();
1277 
1278         uint256 coolcatNums = CoolCats(coolcat).balanceOf(msg.sender);
1279         uint256 fameladyNums = FameLadySquad(famelady).balanceOf(msg.sender);
1280         uint256 wowNums = WorldOfWomen(wow).balanceOf(msg.sender);
1281         require(coolcatNums > 0 || fameladyNums > 0 || wowNums > 0, "Need to have one of them in order to have a grant token!");
1282         
1283         if(coolcatNums > 0) {
1284             for(uint i =0 ; i<coolcatNums; i++){
1285                 uint256 coolcatTokenId = CoolCats(coolcat).tokenOfOwnerByIndex(msg.sender, i);
1286                 require(coolcatMints[coolcatTokenId]==false, "This coolcatTokenId has minted before");
1287                 coolcatMints[coolcatTokenId] = true;
1288             }
1289         }
1290 
1291         if(fameladyNums > 0) {
1292             for(uint i =0 ; i<fameladyNums; i++){
1293                 uint256 fameladyTokenId = FameLadySquad(famelady).tokenOfOwnerByIndex(msg.sender, i);
1294                 require(fameladyMints[fameladyTokenId]==false, "This fameladyTokenId has minted before");
1295                 fameladyMints[fameladyTokenId] = true;
1296             }
1297         }
1298 
1299         if(wowNums > 0) {
1300             for(uint i =0 ; i<wowNums; i++){
1301                 uint256 wowTokenId = WorldOfWomen(wow).tokenOfOwnerByIndex(msg.sender, i);
1302                 require(wowMints[wowTokenId]==false, "This wowTokenId has minted before");
1303                 wowMints[wowTokenId] = true;
1304             }
1305         }
1306         grantMints[msg.sender] = true;
1307         _safeMint(msg.sender, supply);
1308         _max_grant_miss -= 1;
1309     }
1310 
1311 
1312     /**
1313     * @dev Give away reserved Miss for events and gaming (Callable by owner only)
1314     */
1315     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1316         require(  _amount <= _max_reserved_miss , "Exceeds reserved Miss supply" );
1317 
1318         uint256 supply = totalSupply();
1319         for(uint256 i; i < _amount; i++){
1320             _safeMint( _to, supply + i );
1321         }
1322 
1323         _max_reserved_miss -= _amount;
1324     }
1325 
1326     
1327     /**
1328     * @dev Discount Mint (Callable by owner only)
1329     */
1330     function discountMint(address _to, uint256 _amount) external onlyOwner() {
1331         require(  _amount <= _max_discount_miss , "Exceeds Discount Miss supply" );
1332 
1333         uint256 supply = totalSupply();
1334         for(uint256 i; i < _amount; i++){
1335             _safeMint( _to, supply + i );
1336         }
1337 
1338         _max_discount_miss -= _amount;
1339     }
1340     
1341     function _baseURI() internal view virtual override returns (string memory) {
1342         return _baseTokenURI;
1343     }
1344 
1345     /**
1346     * @dev Change the base URI when we move IPFS (Callable by owner only)
1347     */
1348     function setBaseURI(string memory baseURI) public onlyOwner {
1349         _baseTokenURI = baseURI;
1350     }
1351 
1352     /**
1353     * @dev Get all tokens of a owner provided
1354     */
1355     function getTokensOfOwner(address _owner) public view returns(uint256[] memory) {
1356         uint256 tokenCount = balanceOf(_owner);
1357 
1358         uint256[] memory tokensId = new uint256[](tokenCount);
1359         for(uint256 i; i < tokenCount; i++){
1360             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1361         }
1362         return tokensId;
1363     }
1364 
1365     /**
1366     * @dev Set Price if need to discount (Callable by owner only)
1367     */
1368     function setPrice(uint256 _newPrice) public onlyOwner {
1369         _price = _newPrice;
1370     }
1371 
1372     function getPrice() public view returns (uint256){
1373         return _price;
1374     }
1375 
1376     function pause(bool val) public onlyOwner {
1377         _paused = val;
1378     }
1379 
1380     function grantPause(bool val) public onlyOwner {
1381         _grant_paused = val;
1382     }
1383 
1384     /**
1385     * @dev Withdraw ether from this contract (Callable by owner only)
1386     */
1387     function withdraw() onlyOwner public {
1388         uint256 _balance = address(this).balance;
1389         require(payable(luke_crypto).send(_balance));
1390     }
1391 }