1 // SPDX-License-Identifier: MIT
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
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been whiteed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
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
138      * @dev Returns if the `operator` is whiteed to manage all of the assets of `owner`.
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
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 }
164 
165 pragma solidity ^0.8.0;
166 
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
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
194  * @dev See https://eips.ethereum.org/EIPS/eip-721
195  */
196 interface IERC721Metadata is IERC721 {
197     /**
198      * @dev Returns the token collection name.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the token collection symbol.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
209      */
210     function tokenURI(uint256 tokenId) external view returns (string memory);
211 }
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize, which returns 0 for contracts in
238         // construction, since the code is only stored at the end of the
239         // constructor execution.
240 
241         uint256 size;
242         assembly {
243             size := extcodesize(account)
244         }
245         return size > 0;
246     }
247 
248     /**
249      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
250      * `recipient`, forwarding all available gas and reverting on errors.
251      *
252      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
253      * of certain opcodes, possibly making contracts go over the 2300 gas limit
254      * imposed by `transfer`, making them unable to receive funds via
255      * `transfer`. {sendValue} removes this limitation.
256      *
257      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
258      *
259      * IMPORTANT: because control is transferred to `recipient`, care must be
260      * taken to not create reentrancy vulnerabilities. Consider using
261      * {ReentrancyGuard} or the
262      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         (bool success, ) = recipient.call{value: amount}("");
268         require(success, "Address: unable to send value, recipient may have reverted");
269     }
270 
271     /**
272      * @dev Performs a Solidity function call using a low level `call`. A
273      * plain `call` is an unsafe replacement for a function call: use this
274      * function instead.
275      *
276      * If `target` reverts with a revert reason, it is bubbled up by this
277      * function (like regular Solidity function calls).
278      *
279      * Returns the raw returned data. To convert to the expected return value,
280      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
281      *
282      * Requirements:
283      *
284      * - `target` must be a contract.
285      * - calling `target` with `data` must not revert.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290         return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
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
318     function functionCallWithValue(
319         address target,
320         bytes memory data,
321         uint256 value
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
328      * with `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         require(address(this).balance >= value, "Address: insufficient balance for call");
339         require(isContract(target), "Address: call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.call{value: value}(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
352         return functionStaticCall(target, data, "Address: low-level static call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal view returns (bytes memory) {
366         require(isContract(target), "Address: static call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.staticcall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.4._
387      */
388     function functionDelegateCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(isContract(target), "Address: delegate call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.delegatecall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
401      * revert reason using the provided one.
402      *
403      * _Available since v4.3._
404      */
405     function verifyCallResult(
406         bool success,
407         bytes memory returndata,
408         string memory errorMessage
409     ) internal pure returns (bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Provides information about the current execution context, including the
432  * sender of the transaction and its data. While these are generally available
433  * via msg.sender and msg.data, they should not be accessed in such a direct
434  * manner, since when dealing with meta-transactions the account sending and
435  * paying for execution may not be the actual sender (as far as an application
436  * is concerned).
437  *
438  * This contract is only required for intermediate, library-like contracts.
439  */
440 abstract contract Context {
441     function _msgSender() internal view virtual returns (address) {
442         return msg.sender;
443     }
444 
445     function _msgData() internal view virtual returns (bytes calldata) {
446         return msg.data;
447     }
448 }
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev String operations.
454  */
455 library Strings {
456     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
460      */
461     function toString(uint256 value) internal pure returns (string memory) {
462         // Inspired by OraclizeAPI's implementation - MIT licence
463         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
464 
465         if (value == 0) {
466             return "0";
467         }
468         uint256 temp = value;
469         uint256 digits;
470         while (temp != 0) {
471             digits++;
472             temp /= 10;
473         }
474         bytes memory buffer = new bytes(digits);
475         while (value != 0) {
476             digits -= 1;
477             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
478             value /= 10;
479         }
480         return string(buffer);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
485      */
486     function toHexString(uint256 value) internal pure returns (string memory) {
487         if (value == 0) {
488             return "0x00";
489         }
490         uint256 temp = value;
491         uint256 length = 0;
492         while (temp != 0) {
493             length++;
494             temp >>= 8;
495         }
496         return toHexString(value, length);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
501      */
502     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
503         bytes memory buffer = new bytes(2 * length + 2);
504         buffer[0] = "0";
505         buffer[1] = "x";
506         for (uint256 i = 2 * length + 1; i > 1; --i) {
507             buffer[i] = _HEX_SYMBOLS[value & 0xf];
508             value >>= 4;
509         }
510         require(value == 0, "Strings: hex length insufficient");
511         return string(buffer);
512     }
513 }
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
544  * the Metadata extension, but not including the Enumerable extension, which is available separately as
545  * {ERC721Enumerable}.
546  */
547 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
548     using Address for address;
549     using Strings for uint256;
550 
551     // Token name
552     string private _name;
553 
554     // Token symbol
555     string private _symbol;
556 
557     // Mapping from token ID to owner address
558     mapping(uint256 => address) private _owners;
559 
560     // Mapping owner address to token count
561     mapping(address => uint256) private _balances;
562 
563     // Mapping from token ID to approved address
564     mapping(uint256 => address) private _tokenApprovals;
565 
566     // Mapping from owner to operator approvals
567     mapping(address => mapping(address => bool)) private _operatorApprovals;
568 
569     /**
570      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
571      */
572     constructor(string memory name_, string memory symbol_) {
573         _name = name_;
574         _symbol = symbol_;
575     }
576 
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
581         return
582             interfaceId == type(IERC721).interfaceId ||
583             interfaceId == type(IERC721Metadata).interfaceId ||
584             super.supportsInterface(interfaceId);
585     }
586 
587     /**
588      * @dev See {IERC721-balanceOf}.
589      */
590     function balanceOf(address owner) public view virtual override returns (uint256) {
591         require(owner != address(0), "ERC721: balance query for the zero address");
592         return _balances[owner];
593     }
594 
595     /**
596      * @dev See {IERC721-ownerOf}.
597      */
598     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
599         address owner = _owners[tokenId];
600         require(owner != address(0), "ERC721: owner query for nonexistent token");
601         return owner;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-name}.
606      */
607     function name() public view virtual override returns (string memory) {
608         return _name;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-symbol}.
613      */
614     function symbol() public view virtual override returns (string memory) {
615         return _symbol;
616     }
617 
618     /**
619      * @dev See {IERC721Metadata-tokenURI}.
620      */
621     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
622         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
623 
624         string memory baseURI = _baseURI();
625         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
626     }
627 
628     /**
629      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
630      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
631      * by default, can be overriden in child contracts.
632      */
633     function _baseURI() internal view virtual returns (string memory) {
634         return "";
635     }
636 
637     /**
638      * @dev See {IERC721-approve}.
639      */
640     function approve(address to, uint256 tokenId) public virtual override {
641         address owner = ERC721.ownerOf(tokenId);
642         require(to != owner, "ERC721: approval to current owner");
643 
644         require(
645             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
646             "ERC721: approve caller is not owner nor approved for all"
647         );
648 
649         _approve(to, tokenId);
650     }
651 
652     /**
653      * @dev See {IERC721-getApproved}.
654      */
655     function getApproved(uint256 tokenId) public view virtual override returns (address) {
656         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
657 
658         return _tokenApprovals[tokenId];
659     }
660 
661     /**
662      * @dev See {IERC721-setApprovalForAll}.
663      */
664     function setApprovalForAll(address operator, bool approved) public virtual override {
665         require(operator != _msgSender(), "ERC721: approve to caller");
666 
667         _operatorApprovals[_msgSender()][operator] = approved;
668         emit ApprovalForAll(_msgSender(), operator, approved);
669     }
670 
671     /**
672      * @dev See {IERC721-isApprovedForAll}.
673      */
674     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
675         return _operatorApprovals[owner][operator];
676     }
677 
678     /**
679      * @dev See {IERC721-transferFrom}.
680      */
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) public virtual override {
686         //solhint-disable-next-line max-line-length
687         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
688 
689         _transfer(from, to, tokenId);
690     }
691 
692     /**
693      * @dev See {IERC721-safeTransferFrom}.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) public virtual override {
700         safeTransferFrom(from, to, tokenId, "");
701     }
702 
703     /**
704      * @dev See {IERC721-safeTransferFrom}.
705      */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes memory _data
711     ) public virtual override {
712         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
713         _safeTransfer(from, to, tokenId, _data);
714     }
715 
716     /**
717      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
718      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
719      *
720      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
721      *
722      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
723      * implement alternative mechanisms to perform token transfer, such as signature-based.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must exist and be owned by `from`.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function _safeTransfer(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes memory _data
739     ) internal virtual {
740         _transfer(from, to, tokenId);
741         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
742     }
743 
744     /**
745      * @dev Returns whether `tokenId` exists.
746      *
747      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
748      *
749      * Tokens start existing when they are minted (`_mint`),
750      * and stop existing when they are burned (`_burn`).
751      */
752     function _exists(uint256 tokenId) internal view virtual returns (bool) {
753         return _owners[tokenId] != address(0);
754     }
755 
756     /**
757      * @dev Returns whether `spender` is whiteed to manage `tokenId`.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
764         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
765         address owner = ERC721.ownerOf(tokenId);
766         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
767     }
768 
769     /**
770      * @dev Safely mints `tokenId` and transfers it to `to`.
771      *
772      * Requirements:
773      *
774      * - `tokenId` must not exist.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _safeMint(address to, uint256 tokenId) internal virtual {
780         _safeMint(to, tokenId, "");
781     }
782 
783     /**
784      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
785      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
786      */
787     function _safeMint(
788         address to,
789         uint256 tokenId,
790         bytes memory _data
791     ) internal virtual {
792         _mint(to, tokenId);
793         require(
794             _checkOnERC721Received(address(0), to, tokenId, _data),
795             "ERC721: transfer to non ERC721Receiver implementer"
796         );
797     }
798 
799     /**
800      * @dev Mints `tokenId` and transfers it to `to`.
801      *
802      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
803      *
804      * Requirements:
805      *
806      * - `tokenId` must not exist.
807      * - `to` cannot be the zero address.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _mint(address to, uint256 tokenId) internal virtual {
812         require(to != address(0), "ERC721: mint to the zero address");
813         require(!_exists(tokenId), "ERC721: token already minted");
814 
815         _beforeTokenTransfer(address(0), to, tokenId);
816 
817         _balances[to] += 1;
818         _owners[tokenId] = to;
819 
820         emit Transfer(address(0), to, tokenId);
821     }
822 
823     /**
824      * @dev Destroys `tokenId`.
825      * The approval is cleared when the token is burned.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must exist.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _burn(uint256 tokenId) internal virtual {
834         address owner = ERC721.ownerOf(tokenId);
835 
836         _beforeTokenTransfer(owner, address(0), tokenId);
837 
838         // Clear approvals
839         _approve(address(0), tokenId);
840 
841         _balances[owner] -= 1;
842         delete _owners[tokenId];
843 
844         emit Transfer(owner, address(0), tokenId);
845     }
846 
847     /**
848      * @dev Transfers `tokenId` from `from` to `to`.
849      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
850      *
851      * Requirements:
852      *
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _transfer(
859         address from,
860         address to,
861         uint256 tokenId
862     ) internal virtual {
863         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
864         require(to != address(0), "ERC721: transfer to the zero address");
865 
866         _beforeTokenTransfer(from, to, tokenId);
867 
868         // Clear approvals from the previous owner
869         _approve(address(0), tokenId);
870 
871         _balances[from] -= 1;
872         _balances[to] += 1;
873         _owners[tokenId] = to;
874 
875         emit Transfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev Approve `to` to operate on `tokenId`
880      *
881      * Emits a {Approval} event.
882      */
883     function _approve(address to, uint256 tokenId) internal virtual {
884         _tokenApprovals[tokenId] = to;
885         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
886     }
887 
888     /**
889      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
890      * The call is not executed if the target address is not a contract.
891      *
892      * @param from address representing the previous owner of the given token ID
893      * @param to target address that will receive the tokens
894      * @param tokenId uint256 ID of the token to be transferred
895      * @param _data bytes optional data to send along with the call
896      * @return bool whether the call correctly returned the expected magic value
897      */
898     function _checkOnERC721Received(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) private returns (bool) {
904         if (to.isContract()) {
905             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
906                 return retval == IERC721Receiver.onERC721Received.selector;
907             } catch (bytes memory reason) {
908                 if (reason.length == 0) {
909                     revert("ERC721: transfer to non ERC721Receiver implementer");
910                 } else {
911                     assembly {
912                         revert(add(32, reason), mload(reason))
913                     }
914                 }
915             }
916         } else {
917             return true;
918         }
919     }
920 
921     /**
922      * @dev Hook that is called before any token transfer. This includes minting
923      * and burning.
924      *
925      * Calling conditions:
926      *
927      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
928      * transferred to `to`.
929      * - When `from` is zero, `tokenId` will be minted for `to`.
930      * - When `to` is zero, ``from``'s `tokenId` will be burned.
931      * - `from` and `to` are never both zero.
932      *
933      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
934      */
935     function _beforeTokenTransfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {}
940 }
941 
942 pragma solidity ^0.8.0;
943 
944 /**
945  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
946  * @dev See https://eips.ethereum.org/EIPS/eip-721
947  */
948 interface IERC721Enumerable is IERC721 {
949     /**
950      * @dev Returns the total amount of tokens stored by the contract.
951      */
952     function totalSupply() external view returns (uint256);
953 
954     /**
955      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
956      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
957      */
958     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
959 
960     /**
961      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
962      * Use along with {totalSupply} to enumerate all tokens.
963      */
964     function tokenByIndex(uint256 index) external view returns (uint256);
965 }
966 
967 pragma solidity ^0.8.0;
968 
969 /**
970  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
971  * enumerability of all the token ids in the contract as well as all token ids owned by each
972  * account.
973  */
974 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
975     // Mapping from owner to list of owned token IDs
976     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
977 
978     // Mapping from token ID to index of the owner tokens list
979     mapping(uint256 => uint256) private _ownedTokensIndex;
980 
981     // Array with all token ids, used for enumeration
982     uint256[] private _allTokens;
983 
984     // Mapping from token id to position in the allTokens array
985     mapping(uint256 => uint256) private _allTokensIndex;
986 
987     /**
988      * @dev See {IERC165-supportsInterface}.
989      */
990     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
991         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
992     }
993 
994     /**
995      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
996      */
997     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
998         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
999         return _ownedTokens[owner][index];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Enumerable-totalSupply}.
1004      */
1005     function totalSupply() public view virtual override returns (uint256) {
1006         return _allTokens.length;
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Enumerable-tokenByIndex}.
1011      */
1012     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1013         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1014         return _allTokens[index];
1015     }
1016 
1017     /**
1018      * @dev Hook that is called before any token transfer. This includes minting
1019      * and burning.
1020      *
1021      * Calling conditions:
1022      *
1023      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1024      * transferred to `to`.
1025      * - When `from` is zero, `tokenId` will be minted for `to`.
1026      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1027      * - `from` cannot be the zero address.
1028      * - `to` cannot be the zero address.
1029      *
1030      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1031      */
1032     function _beforeTokenTransfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) internal virtual override {
1037         super._beforeTokenTransfer(from, to, tokenId);
1038 
1039         if (from == address(0)) {
1040             _addTokenToAllTokensEnumeration(tokenId);
1041         } else if (from != to) {
1042             _removeTokenFromOwnerEnumeration(from, tokenId);
1043         }
1044         if (to == address(0)) {
1045             _removeTokenFromAllTokensEnumeration(tokenId);
1046         } else if (to != from) {
1047             _addTokenToOwnerEnumeration(to, tokenId);
1048         }
1049     }
1050 
1051     /**
1052      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1053      * @param to address representing the new owner of the given token ID
1054      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1055      */
1056     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1057         uint256 length = ERC721.balanceOf(to);
1058         _ownedTokens[to][length] = tokenId;
1059         _ownedTokensIndex[tokenId] = length;
1060     }
1061 
1062     /**
1063      * @dev Private function to add a token to this extension's token tracking data structures.
1064      * @param tokenId uint256 ID of the token to be added to the tokens list
1065      */
1066     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1067         _allTokensIndex[tokenId] = _allTokens.length;
1068         _allTokens.push(tokenId);
1069     }
1070 
1071     /**
1072      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1073      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this whites for
1074      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1075      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1076      * @param from address representing the previous owner of the given token ID
1077      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1078      */
1079     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1080         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1081         // then delete the last slot (swap and pop).
1082 
1083         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1084         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1085 
1086         // When the token to delete is the last token, the swap operation is unnecessary
1087         if (tokenIndex != lastTokenIndex) {
1088             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1089 
1090             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1091             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1092         }
1093 
1094         // This also deletes the contents at the last position of the array
1095         delete _ownedTokensIndex[tokenId];
1096         delete _ownedTokens[from][lastTokenIndex];
1097     }
1098 
1099     /**
1100      * @dev Private function to remove a token from this extension's token tracking data structures.
1101      * This has O(1) time complexity, but alters the order of the _allTokens array.
1102      * @param tokenId uint256 ID of the token to be removed from the tokens list
1103      */
1104     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1105         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1106         // then delete the last slot (swap and pop).
1107 
1108         uint256 lastTokenIndex = _allTokens.length - 1;
1109         uint256 tokenIndex = _allTokensIndex[tokenId];
1110 
1111         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1112         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1113         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1114         uint256 lastTokenId = _allTokens[lastTokenIndex];
1115 
1116         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1117         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1118 
1119         // This also deletes the contents at the last position of the array
1120         delete _allTokensIndex[tokenId];
1121         _allTokens.pop();
1122     }
1123 }
1124 
1125 pragma solidity ^0.8.0;
1126 
1127 // CAUTION
1128 // This version of SafeMath should only be used with Solidity 0.8 or later,
1129 // because it relies on the compiler's built in overflow checks.
1130 
1131 /**
1132  * @dev Wrappers over Solidity's arithmetic operations.
1133  *
1134  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1135  * now has built in overflow checking.
1136  */
1137 library SafeMath {
1138     /**
1139      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1140      *
1141      * _Available since v3.4._
1142      */
1143     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1144         unchecked {
1145             uint256 c = a + b;
1146             if (c < a) return (false, 0);
1147             return (true, c);
1148         }
1149     }
1150 
1151     /**
1152      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1153      *
1154      * _Available since v3.4._
1155      */
1156     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1157         unchecked {
1158             if (b > a) return (false, 0);
1159             return (true, a - b);
1160         }
1161     }
1162 
1163     /**
1164      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1165      *
1166      * _Available since v3.4._
1167      */
1168     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1169         unchecked {
1170             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1171             // benefit is lost if 'b' is also tested.
1172             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1173             if (a == 0) return (true, 0);
1174             uint256 c = a * b;
1175             if (c / a != b) return (false, 0);
1176             return (true, c);
1177         }
1178     }
1179 
1180     /**
1181      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1182      *
1183      * _Available since v3.4._
1184      */
1185     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1186         unchecked {
1187             if (b == 0) return (false, 0);
1188             return (true, a / b);
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1194      *
1195      * _Available since v3.4._
1196      */
1197     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1198         unchecked {
1199             if (b == 0) return (false, 0);
1200             return (true, a % b);
1201         }
1202     }
1203 
1204     /**
1205      * @dev Returns the addition of two unsigned integers, reverting on
1206      * overflow.
1207      *
1208      * Counterpart to Solidity's `+` operator.
1209      *
1210      * Requirements:
1211      *
1212      * - Addition cannot overflow.
1213      */
1214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1215         return a + b;
1216     }
1217 
1218     /**
1219      * @dev Returns the subtraction of two unsigned integers, reverting on
1220      * overflow (when the result is negative).
1221      *
1222      * Counterpart to Solidity's `-` operator.
1223      *
1224      * Requirements:
1225      *
1226      * - Subtraction cannot overflow.
1227      */
1228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1229         return a - b;
1230     }
1231 
1232     /**
1233      * @dev Returns the multiplication of two unsigned integers, reverting on
1234      * overflow.
1235      *
1236      * Counterpart to Solidity's `*` operator.
1237      *
1238      * Requirements:
1239      *
1240      * - Multiplication cannot overflow.
1241      */
1242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1243         return a * b;
1244     }
1245 
1246     /**
1247      * @dev Returns the integer division of two unsigned integers, reverting on
1248      * division by zero. The result is rounded towards zero.
1249      *
1250      * Counterpart to Solidity's `/` operator.
1251      *
1252      * Requirements:
1253      *
1254      * - The divisor cannot be zero.
1255      */
1256     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1257         return a / b;
1258     }
1259 
1260     /**
1261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1262      * reverting when dividing by zero.
1263      *
1264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1265      * opcode (which leaves remaining gas untouched) while Solidity uses an
1266      * invalid opcode to revert (consuming all remaining gas).
1267      *
1268      * Requirements:
1269      *
1270      * - The divisor cannot be zero.
1271      */
1272     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1273         return a % b;
1274     }
1275 
1276     /**
1277      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1278      * overflow (when the result is negative).
1279      *
1280      * CAUTION: This function is deprecated because it requires allocating memory for the error
1281      * message unnecessarily. For custom revert reasons use {trySub}.
1282      *
1283      * Counterpart to Solidity's `-` operator.
1284      *
1285      * Requirements:
1286      *
1287      * - Subtraction cannot overflow.
1288      */
1289     function sub(
1290         uint256 a,
1291         uint256 b,
1292         string memory errorMessage
1293     ) internal pure returns (uint256) {
1294         unchecked {
1295             require(b <= a, errorMessage);
1296             return a - b;
1297         }
1298     }
1299 
1300     /**
1301      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1302      * division by zero. The result is rounded towards zero.
1303      *
1304      * Counterpart to Solidity's `/` operator. Note: this function uses a
1305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1306      * uses an invalid opcode to revert (consuming all remaining gas).
1307      *
1308      * Requirements:
1309      *
1310      * - The divisor cannot be zero.
1311      */
1312     function div(
1313         uint256 a,
1314         uint256 b,
1315         string memory errorMessage
1316     ) internal pure returns (uint256) {
1317         unchecked {
1318             require(b > 0, errorMessage);
1319             return a / b;
1320         }
1321     }
1322 
1323     /**
1324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1325      * reverting with custom message when dividing by zero.
1326      *
1327      * CAUTION: This function is deprecated because it requires allocating memory for the error
1328      * message unnecessarily. For custom revert reasons use {tryMod}.
1329      *
1330      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1331      * opcode (which leaves remaining gas untouched) while Solidity uses an
1332      * invalid opcode to revert (consuming all remaining gas).
1333      *
1334      * Requirements:
1335      *
1336      * - The divisor cannot be zero.
1337      */
1338     function mod(
1339         uint256 a,
1340         uint256 b,
1341         string memory errorMessage
1342     ) internal pure returns (uint256) {
1343         unchecked {
1344             require(b > 0, errorMessage);
1345             return a % b;
1346         }
1347     }
1348 }
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 /**
1353  * @dev Contract module which provides a basic access control mechanism, where
1354  * there is an account (an owner) that can be granted exclusive access to
1355  * specific functions.
1356  *
1357  * By default, the owner account will be the one that deploys the contract. This
1358  * can later be changed with {transferOwnership}.
1359  *
1360  * This module is used through inheritance. It will make available the modifier
1361  * `onlyOwner`, which can be applied to your functions to restrict their use to
1362  * the owner.
1363  */
1364 abstract contract Ownable is Context {
1365     address private _owner;
1366 
1367     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1368 
1369     /**
1370      * @dev Initializes the contract setting the deployer as the initial owner.
1371      */
1372     constructor() {
1373         _setOwner(_msgSender());
1374     }
1375 
1376     /**
1377      * @dev Returns the address of the current owner.
1378      */
1379     function owner() public view virtual returns (address) {
1380         return _owner;
1381     }
1382 
1383     /**
1384      * @dev Throws if called by any account other than the owner.
1385      */
1386     modifier onlyOwner() {
1387         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1388         _;
1389     }
1390 
1391     /**
1392      * @dev Leaves the contract without owner. It will not be possible to call
1393      * `onlyOwner` functions anymore. Can only be called by the current owner.
1394      *
1395      * NOTE: Renouncing ownership will leave the contract without an owner,
1396      * thereby removing any functionality that is only available to the owner.
1397      */
1398     function renounceOwnership() public virtual onlyOwner {
1399         _setOwner(address(0));
1400     }
1401 
1402     /**
1403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1404      * Can only be called by the current owner.
1405      */
1406     function transferOwnership(address newOwner) public virtual onlyOwner {
1407         require(newOwner != address(0), "Ownable: new owner is the zero address");
1408         _setOwner(newOwner);
1409     }
1410 
1411     function _setOwner(address newOwner) private {
1412         address oldOwner = _owner;
1413         _owner = newOwner;
1414         emit OwnershipTransferred(oldOwner, newOwner);
1415     }
1416 }
1417 
1418 pragma solidity ^0.8.7;
1419 
1420 contract PowerMusixClub is ERC721("Power Musix Club", "MUSIX"), ERC721Enumerable, Ownable {
1421     using SafeMath for uint256;
1422     using Strings for uint256;
1423 
1424     string private baseURI;
1425     bool public isPreReveal;
1426     mapping(address => bool) private whiteList;
1427     address mint1155Address;
1428 
1429     /*
1430      * Function to set Base URI
1431     */
1432     function setURI(string memory _URI) external onlyOwner {
1433         baseURI = _URI;
1434     }
1435 
1436     /*
1437      * Function togglePreReveal to activate/desactivate pre-reveal option
1438     */
1439     function togglePreReveal() external onlyOwner {
1440         isPreReveal = !isPreReveal;
1441     }
1442 
1443     /*
1444      * Function to set the ERC1155 address contract
1445     */
1446     function setMint1155Address(address _contractAddress) external onlyOwner {
1447         mint1155Address = _contractAddress;
1448     }
1449 
1450     /*
1451      * Function addToWhiteList to add whitelisted addresses to prereveal
1452     */
1453     function addToWhiteList(
1454         address[] memory _addresses
1455     )
1456         external
1457         onlyOwner
1458     {
1459         for (uint256 i = 0; i < _addresses.length; i++) {
1460             require(_addresses[i] != address(0), "Cannot add the null address");
1461             whiteList[_addresses[i]] = true;
1462         }
1463     }
1464 
1465     /*
1466      * Function to mint the ERC-721 NFT (reveal function)
1467     */
1468     function mintReveal(address _to) external returns(uint256) {
1469         require(msg.sender == mint1155Address, "Not authorized");
1470 
1471         if(isPreReveal) {
1472             require(whiteList[_to], 'You are not on the Pre Reveal List');
1473         }
1474 
1475         _safeMint(_to, totalSupply());
1476         return totalSupply();
1477     }
1478 
1479     /*
1480     * Mint for giveways.
1481     */
1482     function giveawayMint(address _to) public onlyOwner {
1483         _safeMint(_to, totalSupply());
1484     }
1485 
1486     /*
1487      * Function to get token URI of given token ID
1488     */
1489     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1490         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1491 
1492         return bytes(baseURI).length > 0
1493             ? string(abi.encodePacked(baseURI, _tokenId.toString()))
1494             : "";
1495     }
1496 
1497     function supportsInterface(bytes4 _interfaceId) public view override (ERC721, ERC721Enumerable) returns (bool) {
1498         return super.supportsInterface(_interfaceId);
1499     }
1500 
1501     /*
1502      * Standard functions to be overridden
1503     */
1504     function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal override(ERC721, ERC721Enumerable) {
1505         super._beforeTokenTransfer(_from, _to, _tokenId);
1506     }
1507 }