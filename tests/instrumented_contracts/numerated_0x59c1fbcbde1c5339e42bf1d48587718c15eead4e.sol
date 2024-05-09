1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Collection of functions related to the address type
28  */
29 library Address {
30     /**
31      * @dev Returns true if `account` is a contract.
32      *
33      * [IMPORTANT]
34      * ====
35      * It is unsafe to assume that an address for which this function returns
36      * false is an externally-owned account (EOA) and not a contract.
37      *
38      * Among others, `isContract` will return false for the following
39      * types of addresses:
40      *
41      *  - an externally-owned account
42      *  - a contract in construction
43      *  - an address where a contract will be created
44      *  - an address where a contract lived, but was destroyed
45      * ====
46      */
47     function isContract(address account) internal view returns (bool) {
48         // This method relies on extcodesize, which returns 0 for contracts in
49         // construction, since the code is only stored at the end of the
50         // constructor execution.
51 
52         uint256 size;
53         assembly {
54             size := extcodesize(account)
55         }
56         return size > 0;
57     }
58 
59     /**
60      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
61      * `recipient`, forwarding all available gas and reverting on errors.
62      *
63      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
64      * of certain opcodes, possibly making contracts go over the 2300 gas limit
65      * imposed by `transfer`, making them unable to receive funds via
66      * `transfer`. {sendValue} removes this limitation.
67      *
68      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
69      *
70      * IMPORTANT: because control is transferred to `recipient`, care must be
71      * taken to not create reentrancy vulnerabilities. Consider using
72      * {ReentrancyGuard} or the
73      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
74      */
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         (bool success, ) = recipient.call{value: amount}("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81 
82     /**
83      * @dev Performs a Solidity function call using a low level `call`. A
84      * plain `call` is an unsafe replacement for a function call: use this
85      * function instead.
86      *
87      * If `target` reverts with a revert reason, it is bubbled up by this
88      * function (like regular Solidity function calls).
89      *
90      * Returns the raw returned data. To convert to the expected return value,
91      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
92      *
93      * Requirements:
94      *
95      * - `target` must be a contract.
96      * - calling `target` with `data` must not revert.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
106      * `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151 
152         (bool success, bytes memory returndata) = target.call{value: value}(data);
153         return verifyCallResult(success, returndata, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
163         return functionStaticCall(target, data, "Address: low-level static call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
168      * but performing a static call.
169      *
170      * _Available since v3.3._
171      */
172     function functionStaticCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal view returns (bytes memory) {
177         require(isContract(target), "Address: static call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.staticcall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
195      * but performing a delegate call.
196      *
197      * _Available since v3.4._
198      */
199     function functionDelegateCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(isContract(target), "Address: delegate call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
212      * revert reason using the provided one.
213      *
214      * _Available since v4.3._
215      */
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227 
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Interface of the ERC165 standard, as defined in the
243  * https://eips.ethereum.org/EIPS/eip-165[EIP].
244  *
245  * Implementers can declare support of contract interfaces, which can then be
246  * queried by others ({ERC165Checker}).
247  *
248  * For an implementation, see {ERC165}.
249  */
250 interface IERC165 {
251     /**
252      * @dev Returns true if this contract implements the interface defined by
253      * `interfaceId`. See the corresponding
254      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
255      * to learn more about how these ids are created.
256      *
257      * This function call must use less than 30 000 gas.
258      */
259     function supportsInterface(bytes4 interfaceId) external view returns (bool);
260 }
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Required interface of an ERC721 compliant contract.
266  */
267 interface IERC721 is IERC165 {
268     /**
269      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
270      */
271     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
272 
273     /**
274      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
275      */
276     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
277 
278     /**
279      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
280      */
281     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
282 
283     /**
284      * @dev Returns the number of tokens in ``owner``'s account.
285      */
286     function balanceOf(address owner) external view returns (uint256 balance);
287 
288     /**
289      * @dev Returns the owner of the `tokenId` token.
290      *
291      * Requirements:
292      *
293      * - `tokenId` must exist.
294      */
295     function ownerOf(uint256 tokenId) external view returns (address owner);
296 
297     /**
298      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
299      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `tokenId` token must exist and be owned by `from`.
306      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
308      *
309      * Emits a {Transfer} event.
310      */
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId
315     ) external;
316 
317     /**
318      * @dev Transfers `tokenId` token from `from` to `to`.
319      *
320      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must be owned by `from`.
327      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transferFrom(
332         address from,
333         address to,
334         uint256 tokenId
335     ) external;
336 
337     /**
338      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
339      * The approval is cleared when the token is transferred.
340      *
341      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
342      *
343      * Requirements:
344      *
345      * - The caller must own the token or be an approved operator.
346      * - `tokenId` must exist.
347      *
348      * Emits an {Approval} event.
349      */
350     function approve(address to, uint256 tokenId) external;
351 
352     /**
353      * @dev Returns the account approved for `tokenId` token.
354      *
355      * Requirements:
356      *
357      * - `tokenId` must exist.
358      */
359     function getApproved(uint256 tokenId) external view returns (address operator);
360 
361     /**
362      * @dev Approve or remove `operator` as an operator for the caller.
363      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
364      *
365      * Requirements:
366      *
367      * - The `operator` cannot be the caller.
368      *
369      * Emits an {ApprovalForAll} event.
370      */
371     function setApprovalForAll(address operator, bool _approved) external;
372 
373     /**
374      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
375      *
376      * See {setApprovalForAll}
377      */
378     function isApprovedForAll(address owner, address operator) external view returns (bool);
379 
380     /**
381      * @dev Safely transfers `tokenId` token from `from` to `to`.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must exist and be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
390      *
391      * Emits a {Transfer} event.
392      */
393     function safeTransferFrom(
394         address from,
395         address to,
396         uint256 tokenId,
397         bytes calldata data
398     ) external;
399 }
400 
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
406  * @dev See https://eips.ethereum.org/EIPS/eip-721
407  */
408 interface IERC721Metadata is IERC721 {
409     /**
410      * @dev Returns the token collection name.
411      */
412     function name() external view returns (string memory);
413 
414     /**
415      * @dev Returns the token collection symbol.
416      */
417     function symbol() external view returns (string memory);
418 
419     /**
420      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
421      */
422     function tokenURI(uint256 tokenId) external view returns (string memory);
423 }
424 
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @title ERC721 token receiver interface
429  * @dev Interface for any contract that wants to support safeTransfers
430  * from ERC721 asset contracts.
431  */
432 interface IERC721Receiver {
433     /**
434      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
435      * by `operator` from `from`, this function is called.
436      *
437      * It must return its Solidity selector to confirm the token transfer.
438      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
439      *
440      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
441      */
442     function onERC721Received(
443         address operator,
444         address from,
445         uint256 tokenId,
446         bytes calldata data
447     ) external returns (bytes4);
448 }
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev Implementation of the {IERC165} interface.
454  *
455  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
456  * for the additional interface id that will be supported. For example:
457  *
458  * ```solidity
459  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
461  * }
462  * ```
463  *
464  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
465  */
466 abstract contract ERC165 is IERC165 {
467     /**
468      * @dev See {IERC165-supportsInterface}.
469      */
470     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471         return interfaceId == type(IERC165).interfaceId;
472     }
473 }
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev String operations.
479  */
480 library Strings {
481     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
485      */
486     function toString(uint256 value) internal pure returns (string memory) {
487         // Inspired by OraclizeAPI's implementation - MIT licence
488         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
489 
490         if (value == 0) {
491             return "0";
492         }
493         uint256 temp = value;
494         uint256 digits;
495         while (temp != 0) {
496             digits++;
497             temp /= 10;
498         }
499         bytes memory buffer = new bytes(digits);
500         while (value != 0) {
501             digits -= 1;
502             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
503             value /= 10;
504         }
505         return string(buffer);
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
510      */
511     function toHexString(uint256 value) internal pure returns (string memory) {
512         if (value == 0) {
513             return "0x00";
514         }
515         uint256 temp = value;
516         uint256 length = 0;
517         while (temp != 0) {
518             length++;
519             temp >>= 8;
520         }
521         return toHexString(value, length);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
526      */
527     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
528         bytes memory buffer = new bytes(2 * length + 2);
529         buffer[0] = "0";
530         buffer[1] = "x";
531         for (uint256 i = 2 * length + 1; i > 1; --i) {
532             buffer[i] = _HEX_SYMBOLS[value & 0xf];
533             value >>= 4;
534         }
535         require(value == 0, "Strings: hex length insufficient");
536         return string(buffer);
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
582         interfaceId == type(IERC721).interfaceId ||
583         interfaceId == type(IERC721Metadata).interfaceId ||
584         super.supportsInterface(interfaceId);
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
757      * @dev Returns whether `spender` is allowed to manage `tokenId`.
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
945  * @dev Contract module which provides a basic access control mechanism, where
946  * there is an account (an owner) that can be granted exclusive access to
947  * specific functions.
948  *
949  * By default, the owner account will be the one that deploys the contract. This
950  * can later be changed with {transferOwnership}.
951  *
952  * This module is used through inheritance. It will make available the modifier
953  * `onlyOwner`, which can be applied to your functions to restrict their use to
954  * the owner.
955  */
956 abstract contract Ownable is Context {
957     address private _owner;
958 
959     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
960 
961     /**
962      * @dev Initializes the contract setting the deployer as the initial owner.
963      */
964     constructor() {
965         _setOwner(_msgSender());
966     }
967 
968     /**
969      * @dev Returns the address of the current owner.
970      */
971     function owner() public view virtual returns (address) {
972         return _owner;
973     }
974 
975     /**
976      * @dev Throws if called by any account other than the owner.
977      */
978     modifier onlyOwner() {
979         require(owner() == _msgSender(), "Ownable: caller is not the owner");
980         _;
981     }
982 
983     /**
984      * @dev Leaves the contract without owner. It will not be possible to call
985      * `onlyOwner` functions anymore. Can only be called by the current owner.
986      *
987      * NOTE: Renouncing ownership will leave the contract without an owner,
988      * thereby removing any functionality that is only available to the owner.
989      */
990     function renounceOwnership() public virtual onlyOwner {
991         _setOwner(address(0));
992     }
993 
994     /**
995      * @dev Transfers ownership of the contract to a new account (`newOwner`).
996      * Can only be called by the current owner.
997      */
998     function transferOwnership(address newOwner) public virtual onlyOwner {
999         require(newOwner != address(0), "Ownable: new owner is the zero address");
1000         _setOwner(newOwner);
1001     }
1002 
1003     function _setOwner(address newOwner) private {
1004         address oldOwner = _owner;
1005         _owner = newOwner;
1006         emit OwnershipTransferred(oldOwner, newOwner);
1007     }
1008 }
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 /**
1013  * @dev Contract module which allows children to implement an emergency stop
1014  * mechanism that can be triggered by an authorized account.
1015  *
1016  * This module is used through inheritance. It will make available the
1017  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1018  * the functions of your contract. Note that they will not be pausable by
1019  * simply including this module, only once the modifiers are put in place.
1020  */
1021 abstract contract Pausable is Context {
1022     /**
1023      * @dev Emitted when the pause is triggered by `account`.
1024      */
1025     event Paused(address account);
1026 
1027     /**
1028      * @dev Emitted when the pause is lifted by `account`.
1029      */
1030     event Unpaused(address account);
1031 
1032     bool private _paused;
1033 
1034     /**
1035      * @dev Initializes the contract in unpaused state.
1036      */
1037     constructor() {
1038         _paused = false;
1039     }
1040 
1041     /**
1042      * @dev Returns true if the contract is paused, and false otherwise.
1043      */
1044     function paused() public view virtual returns (bool) {
1045         return _paused;
1046     }
1047 
1048     /**
1049      * @dev Modifier to make a function callable only when the contract is not paused.
1050      *
1051      * Requirements:
1052      *
1053      * - The contract must not be paused.
1054      */
1055     modifier whenNotPaused() {
1056         require(!paused(), "Pausable: paused");
1057         _;
1058     }
1059 
1060     /**
1061      * @dev Modifier to make a function callable only when the contract is paused.
1062      *
1063      * Requirements:
1064      *
1065      * - The contract must be paused.
1066      */
1067     modifier whenPaused() {
1068         require(paused(), "Pausable: not paused");
1069         _;
1070     }
1071 
1072     /**
1073      * @dev Triggers stopped state.
1074      *
1075      * Requirements:
1076      *
1077      * - The contract must not be paused.
1078      */
1079     function _pause() internal virtual whenNotPaused {
1080         _paused = true;
1081         emit Paused(_msgSender());
1082     }
1083 
1084     /**
1085      * @dev Returns to normal state.
1086      *
1087      * Requirements:
1088      *
1089      * - The contract must be paused.
1090      */
1091     function _unpause() internal virtual whenPaused {
1092         _paused = false;
1093         emit Unpaused(_msgSender());
1094     }
1095 }
1096 
1097 
1098 pragma solidity >=0.4.22 <0.9.0;
1099 
1100 contract WealthyApeSocialClub is Ownable, ERC721, Pausable {
1101     using Strings for uint256;
1102 
1103     uint256 public constant TOTAL_QTY = 7777;
1104     uint256 public constant FREE_MINT_MAX_QTY = 500;
1105     uint256 public constant TEAM_RESERVE_QTY = 50;
1106     uint256 public price_ = 0.05 ether;
1107     uint256 public maxQtyPerWallet_ = 20;
1108     string public tokenBaseURI_;
1109     uint256 public mintedQty_;
1110 
1111     mapping(address => uint256) public minterToTokenQty;
1112     mapping(address => bool) public freeMint;
1113 
1114     constructor(string memory tokenBaseURI) ERC721("Wealthy Ape Social Club", "WASC") {
1115         tokenBaseURI_ = tokenBaseURI;
1116         pause();
1117     }
1118 
1119     function mint(uint256 mintQty) external payable whenNotPaused {
1120         if (mintedQty_ < FREE_MINT_MAX_QTY + TEAM_RESERVE_QTY) {
1121             require(mintQty == 1, "Only one free mint");
1122             require(!freeMint[msg.sender], "Already minted free");
1123             freeMint[msg.sender] = true;
1124         } else {
1125             require(mintedQty_ + mintQty <= TOTAL_QTY, "Request amount exceeds total max supply");
1126             require(minterToTokenQty[msg.sender] + mintQty <= maxQtyPerWallet_, "Max quantity per wallet is exceeded");
1127             require(msg.value >= price_ * mintQty, "Insufficient ether amount sent");
1128             minterToTokenQty[msg.sender] += mintQty;
1129         }
1130 
1131         for (uint256 i = 0; i < mintQty; i++) {
1132             _mint(msg.sender, mintedQty_ + i);
1133         }
1134 
1135         mintedQty_ += mintQty;
1136     }
1137 
1138     function reserve() external onlyOwner {
1139         for (uint256 i = 0; i < TEAM_RESERVE_QTY; ++i) {
1140             _mint(msg.sender, mintedQty_ + i);
1141         }
1142 
1143         mintedQty_ += TEAM_RESERVE_QTY;
1144     }
1145 
1146     function setMaxQtyWallet(uint256 maxQtyPerWallet) external onlyOwner {
1147         maxQtyPerWallet_ = maxQtyPerWallet;
1148     }
1149 
1150     function setBaseURI(string calldata URI) public onlyOwner {
1151         tokenBaseURI_ = URI;
1152     }
1153 
1154     function _baseURI() internal view override(ERC721) returns (string memory) {
1155         return tokenBaseURI_;
1156     }
1157 
1158     function tokenURI(uint256 _tokenId) public view virtual override(ERC721) returns (string memory) {
1159         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1160         string memory currentBaseURI = _baseURI();
1161         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1162     }
1163 
1164     function pause() public onlyOwner {
1165         _pause();
1166     }
1167 
1168     function unpause() public onlyOwner {
1169         _unpause();
1170     }
1171 
1172     function totalSupply() public view returns (uint256) {
1173         return mintedQty_;
1174     }
1175 
1176     function withdraw(uint256 amount) external onlyOwner {
1177         require(address(this).balance >= amount, "Contract balance too low");
1178 
1179         require(payable(msg.sender).send(amount));
1180     }
1181 }