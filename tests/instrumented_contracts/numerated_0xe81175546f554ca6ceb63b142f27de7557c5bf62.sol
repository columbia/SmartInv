1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8;
3 
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 
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
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.     *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
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
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
165 
166 /**
167  * @title ERC721 token receiver interface
168  * @dev Interface for any contract that wants to support safeTransfers
169  * from ERC721 asset contracts.
170  */
171 interface IERC721Receiver {
172     /**
173      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
174      * by `operator` from `from`, this function is called.
175      *
176      * It must return its Solidity selector to confirm the token transfer.
177      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
178      *
179      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
180      */
181     function onERC721Received(
182         address operator,
183         address from,
184         uint256 tokenId,
185         bytes calldata data
186     ) external returns (bytes4);
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
190 
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
212 // File: @openzeppelin/contracts/utils/Address.sol
213 
214 /**
215  * @dev Collection of functions related to the address type
216  */
217 library Address {
218     /**
219      * @dev Returns true if `account` is a contract.
220      *
221      * [IMPORTANT]
222      * ====
223      * It is unsafe to assume that an address for which this function returns
224      * false is an externally-owned account (EOA) and not a contract.
225      *
226      * Among others, `isContract` will return false for the following
227      * types of addresses:
228      *
229      *  - an externally-owned account
230      *  - a contract in construction
231      *  - an address where a contract will be created
232      *  - an address where a contract lived, but was destroyed
233      * ====
234      */
235     function isContract(address account) internal view returns (bool) {
236         // This method relies on extcodesize, which returns 0 for contracts in
237         // construction, since the code is only stored at the end of the
238         // constructor execution.
239 
240         uint256 size;
241         assembly {
242             size := extcodesize(account)
243         }
244         return size > 0;
245     }
246 
247     /**
248      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
249      * `recipient`, forwarding all available gas and reverting on errors.
250      *
251      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
252      * of certain opcodes, possibly making contracts go over the 2300 gas limit
253      * imposed by `transfer`, making them unable to receive funds via
254      * `transfer`. {sendValue} removes this limitation.
255      *
256      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
257      *
258      * IMPORTANT: because control is transferred to `recipient`, care must be
259      * taken to not create reentrancy vulnerabilities. Consider using
260      * {ReentrancyGuard} or the
261      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
262      */
263     function sendValue(address payable recipient, uint256 amount) internal {
264         require(address(this).balance >= amount, "Address: insufficient balance");
265 
266         (bool success, ) = recipient.call{value: amount}("");
267         require(success, "Address: unable to send value, recipient may have reverted");
268     }
269 
270     /**
271      * @dev Performs a Solidity function call using a low level `call`. A
272      * plain `call` is an unsafe replacement for a function call: use this
273      * function instead.
274      *
275      * If `target` reverts with a revert reason, it is bubbled up by this
276      * function (like regular Solidity function calls).
277      *
278      * Returns the raw returned data. To convert to the expected return value,
279      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
280      *
281      * Requirements:
282      *
283      * - `target` must be a contract.
284      * - calling `target` with `data` must not revert.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionCall(target, data, "Address: low-level call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
294      * `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
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
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
327      * with `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         require(address(this).balance >= value, "Address: insufficient balance for call");
338         require(isContract(target), "Address: call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.call{value: value}(data);
341         return _verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
351         return functionStaticCall(target, data, "Address: low-level static call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal view returns (bytes memory) {
365         require(isContract(target), "Address: static call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.staticcall(data);
368         return _verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
378         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(isContract(target), "Address: delegate call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.delegatecall(data);
395         return _verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     function _verifyCallResult(
399         bool success,
400         bytes memory returndata,
401         string memory errorMessage
402     ) private pure returns (bytes memory) {
403         if (success) {
404             return returndata;
405         } else {
406             // Look for revert reason and bubble it up if present
407             if (returndata.length > 0) {
408                 // The easiest way to bubble the revert reason is using memory via assembly
409 
410                 assembly {
411                     let returndata_size := mload(returndata)
412                     revert(add(32, returndata), returndata_size)
413                 }
414             } else {
415                 revert(errorMessage);
416             }
417         }
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/Context.sol
422 
423 /*
424  * @dev Provides information about the current execution context, including the
425  * sender of the transaction and its data. While these are generally available
426  * via msg.sender and msg.data, they should not be accessed in such a direct
427  * manner, since when dealing with meta-transactions the account sending and
428  * paying for execution may not be the actual sender (as far as an application
429  * is concerned).
430  *
431  * This contract is only required for intermediate, library-like contracts.
432  */
433 abstract contract Context {
434     function _msgSender() internal view virtual returns (address) {
435         return msg.sender;
436     }
437 
438     function _msgData() internal view virtual returns (bytes calldata) {
439         return msg.data;
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/Strings.sol
444 
445 /**
446  * @dev String operations.
447  */
448 library Strings {
449     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
450 
451     /**
452      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
453      */
454     function toString(uint256 value) internal pure returns (string memory) {
455         // Inspired by OraclizeAPI's implementation - MIT licence
456         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
457         if (value == 0) {
458             return "0";
459         }
460         uint256 temp = value;
461         uint256 digits;
462         while (temp != 0) {
463             digits++;
464             temp /= 10;
465         }
466         bytes memory buffer = new bytes(digits);
467         while (value != 0) {
468             digits -= 1;
469             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
470             value /= 10;
471         }
472         return string(buffer);
473     }
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
477      */
478     function toHexString(uint256 value) internal pure returns (string memory) {
479         if (value == 0) {
480             return "0x00";
481         }
482         uint256 temp = value;
483         uint256 length = 0;
484         while (temp != 0) {
485             length++;
486             temp >>= 8;
487         }
488         return toHexString(value, length);
489     }
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
493      */
494     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
495         bytes memory buffer = new bytes(2 * length + 2);
496         buffer[0] = "0";
497         buffer[1] = "x";
498         for (uint256 i = 2 * length + 1; i > 1; --i) {
499             buffer[i] = _HEX_SYMBOLS[value & 0xf];
500             value >>= 4;
501         }
502         require(value == 0, "Strings: hex length insufficient");
503         return string(buffer);
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
533 
534 /**
535  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
536  * the Metadata extension, but not including the Enumerable extension, which is available separately as
537  * {ERC721Enumerable}.
538  */
539 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
540     using Address for address;
541     using Strings for uint256;
542 
543     // Token name
544     string private _name;
545 
546     // Token symbol
547     string private _symbol;
548 
549     // Mapping from token ID to owner address
550     mapping(uint256 => address) private _owners;
551 
552     // Mapping owner address to token count
553     mapping(address => uint256) private _balances;
554 
555     // Mapping from token ID to approved address
556     mapping(uint256 => address) private _tokenApprovals;
557 
558     // Mapping from owner to operator approvals
559     mapping(address => mapping(address => bool)) private _operatorApprovals;
560 
561     /**
562      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
563      */
564     constructor(string memory name_, string memory symbol_) {
565         _name = name_;
566         _symbol = symbol_;
567     }
568 
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
573         return
574             interfaceId == type(IERC721).interfaceId ||
575             interfaceId == type(IERC721Metadata).interfaceId ||
576             super.supportsInterface(interfaceId);
577     }
578 
579     /**
580      * @dev See {IERC721-balanceOf}.
581      */
582     function balanceOf(address owner) public view virtual override returns (uint256) {
583         require(owner != address(0), "ERC721: balance query for the zero address");
584         return _balances[owner];
585     }
586 
587     /**
588      * @dev See {IERC721-ownerOf}.
589      */
590     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
591         address owner = _owners[tokenId];
592         require(owner != address(0), "ERC721: owner query for nonexistent token");
593         return owner;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-name}.
598      */
599     function name() public view virtual override returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-symbol}.
605      */
606     function symbol() public view virtual override returns (string memory) {
607         return _symbol;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-tokenURI}.
612      */
613     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
614         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
615 
616         string memory baseURI = _baseURI();
617         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
618     }
619 
620     /**
621      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
622      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
623      * by default, can be overriden in child contracts.
624      */
625     function _baseURI() internal view virtual returns (string memory) {
626         return "";
627     }
628 
629     /**
630      * @dev See {IERC721-approve}.
631      */
632     function approve(address to, uint256 tokenId) public virtual override {
633         address owner = ERC721.ownerOf(tokenId);
634         require(to != owner, "ERC721: approval to current owner");
635 
636         require(
637             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
638             "ERC721: approve caller is not owner nor approved for all"
639         );
640 
641         _approve(to, tokenId);
642     }
643 
644     /**
645      * @dev See {IERC721-getApproved}.
646      */
647     function getApproved(uint256 tokenId) public view virtual override returns (address) {
648         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
649 
650         return _tokenApprovals[tokenId];
651     }
652 
653     /**
654      * @dev See {IERC721-setApprovalForAll}.
655      */
656     function setApprovalForAll(address operator, bool approved) public virtual override {
657         require(operator != _msgSender(), "ERC721: approve to caller");
658 
659         _operatorApprovals[_msgSender()][operator] = approved;
660         emit ApprovalForAll(_msgSender(), operator, approved);
661     }
662 
663     /**
664      * @dev See {IERC721-isApprovedForAll}.
665      */
666     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
667         return _operatorApprovals[owner][operator];
668     }
669 
670     /**
671      * @dev See {IERC721-transferFrom}.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) public virtual override {
678         //solhint-disable-next-line max-line-length
679         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
680 
681         _transfer(from, to, tokenId);
682     }
683 
684     /**
685      * @dev See {IERC721-safeTransferFrom}.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) public virtual override {
692         safeTransferFrom(from, to, tokenId, "");
693     }
694 
695     /**
696      * @dev See {IERC721-safeTransferFrom}.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId,
702         bytes memory _data
703     ) public virtual override {
704         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
705         _safeTransfer(from, to, tokenId, _data);
706     }
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
710      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
711      *
712      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
713      *
714      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
715      * implement alternative mechanisms to perform token transfer, such as signature-based.
716      *
717      * Requirements:
718      *
719      * - `from` cannot be the zero address.
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must exist and be owned by `from`.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function _safeTransfer(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) internal virtual {
732         _transfer(from, to, tokenId);
733         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");    }
734 
735     /**
736      * @dev Returns whether `tokenId` exists.
737      *
738      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
739      *
740      * Tokens start existing when they are minted (`_mint`),
741      * and stop existing when they are burned (`_burn`).
742      */
743     function _exists(uint256 tokenId) internal view virtual returns (bool) {
744         return _owners[tokenId] != address(0);
745     }
746 
747     /**
748      * @dev Returns whether `spender` is allowed to manage `tokenId`.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must exist.
753      */
754     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
755         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
756         address owner = ERC721.ownerOf(tokenId);
757         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
758     }
759 
760     /**
761      * @dev Safely mints `tokenId` and transfers it to `to`.
762      *
763      * Requirements:
764      *
765      * - `tokenId` must not exist.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeMint(address to, uint256 tokenId) internal virtual {
771         _safeMint(to, tokenId, "");
772     }
773 
774     /**
775      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
776      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
777      */
778     function _safeMint(
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) internal virtual {
783         _mint(to, tokenId);
784         require(
785             _checkOnERC721Received(address(0), to, tokenId, _data),
786             "ERC721: transfer to non ERC721Receiver implementer"
787         );
788     }
789 
790     /**
791      * @dev Mints `tokenId` and transfers it to `to`.
792      *
793      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
794      *
795      * Requirements:
796      *
797      * - `tokenId` must not exist.
798      * - `to` cannot be the zero address.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _mint(address to, uint256 tokenId) internal virtual {
803         require(to != address(0), "ERC721: mint to the zero address");
804         require(!_exists(tokenId), "ERC721: token already minted");
805 
806         _beforeTokenTransfer(address(0), to, tokenId);
807 
808         _balances[to] += 1;
809         _owners[tokenId] = to;
810 
811         emit Transfer(address(0), to, tokenId);
812     }
813 
814     /**
815      * @dev Destroys `tokenId`.
816      * The approval is cleared when the token is burned.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _burn(uint256 tokenId) internal virtual {
825         address owner = ERC721.ownerOf(tokenId);
826 
827         _beforeTokenTransfer(owner, address(0), tokenId);
828 
829         // Clear approvals
830         _approve(address(0), tokenId);
831 
832         _balances[owner] -= 1;
833         delete _owners[tokenId];
834 
835         emit Transfer(owner, address(0), tokenId);
836     }
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
841      *
842      * Requirements:
843      *
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must be owned by `from`.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _transfer(
850         address from,
851         address to,
852         uint256 tokenId
853     ) internal virtual {
854         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
855         require(to != address(0), "ERC721: transfer to the zero address");
856 
857         _beforeTokenTransfer(from, to, tokenId);
858 
859         // Clear approvals from the previous owner
860         _approve(address(0), tokenId);
861 
862         _balances[from] -= 1;
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(from, to, tokenId);
867     }
868 
869     /**
870      * @dev Approve `to` to operate on `tokenId`
871      *
872      * Emits a {Approval} event.
873      */
874     function _approve(address to, uint256 tokenId) internal virtual {
875         _tokenApprovals[tokenId] = to;
876         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
877     }
878 
879     /**
880      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
881      * The call is not executed if the target address is not a contract.
882      *
883      * @param from address representing the previous owner of the given token ID
884      * @param to target address that will receive the tokens
885      * @param tokenId uint256 ID of the token to be transferred
886      * @param _data bytes optional data to send along with the call
887      * @return bool whether the call correctly returned the expected magic value
888      */
889     function _checkOnERC721Received(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) private returns (bool) {
895         if (to.isContract()) {
896             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
897                 return retval == IERC721Receiver(to).onERC721Received.selector;
898             } catch (bytes memory reason) {
899                 if (reason.length == 0) {
900                     revert("ERC721: transfer to non ERC721Receiver implementer");
901                 } else {
902                     assembly {
903                         revert(add(32, reason), mload(reason))
904                     }
905                 }
906             }
907         } else {
908             return true;
909         }
910     }
911 
912     /**
913      * @dev Hook that is called before any token transfer. This includes minting
914      * and burning.
915      *
916      * Calling conditions:
917      *
918      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
919      * transferred to `to`.
920      * - When `from` is zero, `tokenId` will be minted for `to`.
921      * - When `to` is zero, ``from``'s `tokenId` will be burned.
922      * - `from` and `to` are never both zero.
923      *
924      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
925      */
926     function _beforeTokenTransfer(
927         address from,
928         address to,
929         uint256 tokenId
930     ) internal virtual {}
931 }
932 
933 // File: contracts/WrappedLunar.sol
934 
935 interface Lunar {
936   function ownerOf(uint id) external view returns(address);
937   function transfer(uint id, address newOwner, string memory newData) external returns(bool);
938   function setPrice(uint id, bool forSale, uint newPrice) external;
939 }
940 
941 
942 /**
943  * @dev ERC721 wrap contract for Lunar (`0x43fb95c7afA1Ac1E721F33C695b2A0A94C7ddAb2`).
944  * Uses a 3 step reservation process to allow wrapping without paying purchase fees.
945  * STEP 1: Call the `reserveNFT` function with the ID of the NFT you want to wrap
946  * STEP 2: Transfer the NFT to this contract
947  * STEP 3: Call the `mint` function with the ID of the NFT you sent in step 2
948  */
949 contract WrappedLunar is ERC721 {
950 
951     Lunar public lunar = Lunar(0x43fb95c7afA1Ac1E721F33C695b2A0A94C7ddAb2);
952     address public owner = 0x070DcB7ba170091F84783b224489aA8B280c1A30;
953     string internal baseURI;
954     mapping(uint256 => address) public reservations;
955 
956     constructor() ERC721("Wrapped Lunar", "WLUNA") {}
957 
958     function setBaseURI(string memory newBaseURI) public {
959         require(msg.sender == owner);
960         baseURI = newBaseURI;
961     }
962 
963     function renounceOwnership() public {
964         require(msg.sender == owner);
965         owner = address(0);
966     }
967 
968     /**
969      * @dev Reservation function, step 1 of the wrapping process.
970      * Users must call this function before transferring their nfts to this contract.
971     */
972     function reserveNFT(uint256 id) external {
973         require(lunar.ownerOf(id) == msg.sender, "Caller is not the owner");
974         reservations[id] = msg.sender;
975     }
976 
977     /**
978      * @dev Mint function, step 3 of the wrapping process.
979      * Users must call this function after reserving their NFT with the `reserveNFT` function and having it transferred to
980      * this contract by interacting with the original Lunar contract.
981      */
982     function mint(uint256 id) external {
983         require(lunar.ownerOf(id) == address(this), "Lunar not owned by this contract");
984         require(reservations[id] == msg.sender, "Caller doesn't have a reservation on this nft");
985 
986         lunar.setPrice(id, false, 0);
987         _mint(msg.sender, id);
988         delete reservations[id];
989     }
990 
991     function withdraw(uint256 id) external {
992         require(ownerOf(id) == msg.sender, "Caller is not the owner");
993 
994         lunar.transfer(id, msg.sender, "");
995         _burn(id);
996     }
997 
998     function _baseURI() internal view override returns (string memory) {
999         return baseURI;
1000     }
1001 
1002 }