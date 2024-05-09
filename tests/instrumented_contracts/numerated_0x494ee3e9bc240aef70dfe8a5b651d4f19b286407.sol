1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
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
27 
28 pragma solidity ^0.8.0;
29 
30 
31 /**
32  * @dev Implementation of the {IERC165} interface.
33  *
34  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
35  * for the additional interface id that will be supported. For example:
36  *
37  * ```solidity
38  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
39  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
40  * }
41  * ```
42  *
43  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
44  */
45 abstract contract ERC165 is IERC165 {
46     /**
47      * @dev See {IERC165-supportsInterface}.
48      */
49     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
50         return interfaceId == type(IERC165).interfaceId;
51     }
52 }
53 
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev String operations.
59  */
60 library Strings {
61     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
65      */
66     function toString(uint256 value) internal pure returns (string memory) {
67         // Inspired by OraclizeAPI's implementation - MIT licence
68         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
69 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
90      */
91     function toHexString(uint256 value) internal pure returns (string memory) {
92         if (value == 0) {
93             return "0x00";
94         }
95         uint256 temp = value;
96         uint256 length = 0;
97         while (temp != 0) {
98             length++;
99             temp >>= 8;
100         }
101         return toHexString(value, length);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
106      */
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 }
119 
120 
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Collection of functions related to the address type
150  */
151 library Address {
152     /**
153      * @dev Returns true if `account` is a contract.
154      *
155      * [IMPORTANT]
156      * ====
157      * It is unsafe to assume that an address for which this function returns
158      * false is an externally-owned account (EOA) and not a contract.
159      *
160      * Among others, `isContract` will return false for the following
161      * types of addresses:
162      *
163      *  - an externally-owned account
164      *  - a contract in construction
165      *  - an address where a contract will be created
166      *  - an address where a contract lived, but was destroyed
167      * ====
168      */
169     function isContract(address account) internal view returns (bool) {
170         // This method relies on extcodesize, which returns 0 for contracts in
171         // construction, since the code is only stored at the end of the
172         // constructor execution.
173 
174         uint256 size;
175         assembly {
176             size := extcodesize(account)
177         }
178         return size > 0;
179     }
180 
181     /**
182      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
183      * `recipient`, forwarding all available gas and reverting on errors.
184      *
185      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
186      * of certain opcodes, possibly making contracts go over the 2300 gas limit
187      * imposed by `transfer`, making them unable to receive funds via
188      * `transfer`. {sendValue} removes this limitation.
189      *
190      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
191      *
192      * IMPORTANT: because control is transferred to `recipient`, care must be
193      * taken to not create reentrancy vulnerabilities. Consider using
194      * {ReentrancyGuard} or the
195      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
196      */
197     function sendValue(address payable recipient, uint256 amount) internal {
198         require(address(this).balance >= amount, "Address: insufficient balance");
199 
200         (bool success, ) = recipient.call{value: amount}("");
201         require(success, "Address: unable to send value, recipient may have reverted");
202     }
203 
204     /**
205      * @dev Performs a Solidity function call using a low level `call`. A
206      * plain `call` is an unsafe replacement for a function call: use this
207      * function instead.
208      *
209      * If `target` reverts with a revert reason, it is bubbled up by this
210      * function (like regular Solidity function calls).
211      *
212      * Returns the raw returned data. To convert to the expected return value,
213      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
214      *
215      * Requirements:
216      *
217      * - `target` must be a contract.
218      * - calling `target` with `data` must not revert.
219      *
220      * _Available since v3.1._
221      */
222     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionCall(target, data, "Address: low-level call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
228      * `errorMessage` as a fallback revert reason when `target` reverts.
229      *
230      * _Available since v3.1._
231      */
232     function functionCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, 0, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but also transferring `value` wei to `target`.
243      *
244      * Requirements:
245      *
246      * - the calling contract must have an ETH balance of at least `value`.
247      * - the called Solidity function must be `payable`.
248      *
249      * _Available since v3.1._
250      */
251     function functionCallWithValue(
252         address target,
253         bytes memory data,
254         uint256 value
255     ) internal returns (bytes memory) {
256         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
261      * with `errorMessage` as a fallback revert reason when `target` reverts.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(
266         address target,
267         bytes memory data,
268         uint256 value,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(address(this).balance >= value, "Address: insufficient balance for call");
272         require(isContract(target), "Address: call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.call{value: value}(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a static call.
281      *
282      * _Available since v3.3._
283      */
284     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
285         return functionStaticCall(target, data, "Address: low-level static call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal view returns (bytes memory) {
299         require(isContract(target), "Address: static call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.staticcall(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a delegate call.
308      *
309      * _Available since v3.4._
310      */
311     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a delegate call.
318      *
319      * _Available since v3.4._
320      */
321     function functionDelegateCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(isContract(target), "Address: delegate call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.delegatecall(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
334      * revert reason using the provided one.
335      *
336      * _Available since v4.3._
337      */
338     function verifyCallResult(
339         bool success,
340         bytes memory returndata,
341         string memory errorMessage
342     ) internal pure returns (bytes memory) {
343         if (success) {
344             return returndata;
345         } else {
346             // Look for revert reason and bubble it up if present
347             if (returndata.length > 0) {
348                 // The easiest way to bubble the revert reason is using memory via assembly
349 
350                 assembly {
351                     let returndata_size := mload(returndata)
352                     revert(add(32, returndata), returndata_size)
353                 }
354             } else {
355                 revert(errorMessage);
356             }
357         }
358     }
359 }
360 
361 
362 
363 
364 
365 
366 
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @title ERC721 token receiver interface
372  * @dev Interface for any contract that wants to support safeTransfers
373  * from ERC721 asset contracts.
374  */
375 interface IERC721Receiver {
376     /**
377      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
378      * by `operator` from `from`, this function is called.
379      *
380      * It must return its Solidity selector to confirm the token transfer.
381      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
382      *
383      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
384      */
385     function onERC721Received(
386         address operator,
387         address from,
388         uint256 tokenId,
389         bytes calldata data
390     ) external returns (bytes4);
391 }
392 
393 pragma solidity ^0.8.0;
394 
395 
396 
397 
398 pragma solidity ^0.8.0;
399 
400 
401 
402 /**
403  * @dev Required interface of an ERC721 compliant contract.
404  */
405 interface IERC721 is IERC165 {
406     /**
407      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
413      */
414     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
418      */
419     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
420 
421     /**
422      * @dev Returns the number of tokens in ``owner``'s account.
423      */
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     /**
427      * @dev Returns the owner of the `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function ownerOf(uint256 tokenId) external view returns (address owner);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
437      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Transfers `tokenId` token from `from` to `to`.
457      *
458      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must be owned by `from`.
465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      *
467      * Emits a {Transfer} event.
468      */
469     function transferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
477      * The approval is cleared when the token is transferred.
478      *
479      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
480      *
481      * Requirements:
482      *
483      * - The caller must own the token or be an approved operator.
484      * - `tokenId` must exist.
485      *
486      * Emits an {Approval} event.
487      */
488     function approve(address to, uint256 tokenId) external;
489 
490     /**
491      * @dev Returns the account approved for `tokenId` token.
492      *
493      * Requirements:
494      *
495      * - `tokenId` must exist.
496      */
497     function getApproved(uint256 tokenId) external view returns (address operator);
498 
499     /**
500      * @dev Approve or remove `operator` as an operator for the caller.
501      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
502      *
503      * Requirements:
504      *
505      * - The `operator` cannot be the caller.
506      *
507      * Emits an {ApprovalForAll} event.
508      */
509     function setApprovalForAll(address operator, bool _approved) external;
510 
511     /**
512      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
513      *
514      * See {setApprovalForAll}
515      */
516     function isApprovedForAll(address owner, address operator) external view returns (bool);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must exist and be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId,
535         bytes calldata data
536     ) external;
537     
538 }
539 
540 
541 
542 /**
543  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
544  * @dev See https://eips.ethereum.org/EIPS/eip-721
545  */
546 interface IERC721Enumerable is IERC721 {
547     /**
548      * @dev Returns the total amount of tokens stored by the contract.
549      */
550     function totalSupply() external view returns (uint256);
551 
552     /**
553      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
554      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
555      */
556     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
557 
558     /**
559      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
560      * Use along with {totalSupply} to enumerate all tokens.
561      */
562     function tokenByIndex(uint256 index) external view returns (uint256);
563 
564 }
565 
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Metadata is IERC721 {
575     /**
576      * @dev Returns the token collection name.
577      */
578     function name() external view returns (string memory);
579 
580     /**
581      * @dev Returns the token collection symbol.
582      */
583     function symbol() external view returns (string memory);
584 
585     /**
586      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
587      */
588     function tokenURI(uint256 tokenId) external view returns (string memory);
589 }
590 
591 
592 
593 pragma solidity ^0.8.0;
594 
595 
596 
597 /**
598  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
599  * the Metadata extension, but not including the Enumerable extension, which is available separately as
600  * {ERC721Enumerable}.
601  */
602 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
603     using Address for address;
604     using Strings for uint256;
605 
606     // Token name
607     string private _name;
608 
609     // Token symbol
610     string private _symbol;
611 
612     // Mapping from token ID to owner address
613     mapping(uint256 => address) private _owners;
614 
615     // Mapping owner address to token count
616     mapping(address => uint256) private _balances;
617 
618     // Mapping from token ID to approved address
619     mapping(uint256 => address) private _tokenApprovals;
620 
621     // Mapping from owner to operator approvals
622     mapping(address => mapping(address => bool)) private _operatorApprovals;
623 
624     /**
625      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
626      */
627     constructor(string memory name_, string memory symbol_) {
628         _name = name_;
629         _symbol = symbol_;
630     }
631 
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
636         return
637             interfaceId == type(IERC721).interfaceId ||
638             interfaceId == type(IERC721Metadata).interfaceId ||
639             super.supportsInterface(interfaceId);
640     }
641 
642     /**
643      * @dev See {IERC721-balanceOf}.
644      */
645     function balanceOf(address owner) public view virtual override returns (uint256) {
646         require(owner != address(0), "ERC721: balance query for the zero address");
647         return _balances[owner];
648     }
649 
650     /**
651      * @dev See {IERC721-ownerOf}.
652      */
653     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
654         address owner = _owners[tokenId];
655         require(owner != address(0), "ERC721: owner query for nonexistent token");
656         return owner;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-name}.
661      */
662     function name() public view virtual override returns (string memory) {
663         return _name;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-symbol}.
668      */
669     function symbol() public view virtual override returns (string memory) {
670         return _symbol;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-tokenURI}.
675      */
676     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
677         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
678 
679         string memory baseURI = _baseURI();
680         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
681     }
682 
683     /**
684      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
685      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
686      * by default, can be overriden in child contracts.
687      */
688     function _baseURI() internal view virtual returns (string memory) {
689         return "";
690     }
691 
692     /**
693      * @dev See {IERC721-approve}.
694      */
695     function approve(address to, uint256 tokenId) public virtual override {
696         address owner = ERC721.ownerOf(tokenId);
697         require(to != owner, "ERC721: approval to current owner");
698 
699         require(
700             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
701             "ERC721: approve caller is not owner nor approved for all"
702         );
703 
704         _approve(to, tokenId);
705     }
706 
707     /**
708      * @dev See {IERC721-getApproved}.
709      */
710     function getApproved(uint256 tokenId) public view virtual override returns (address) {
711         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
712 
713         return _tokenApprovals[tokenId];
714     }
715 
716     /**
717      * @dev See {IERC721-setApprovalForAll}.
718      */
719     function setApprovalForAll(address operator, bool approved) public virtual override {
720         _setApprovalForAll(_msgSender(), operator, approved);
721     }
722 
723     /**
724      * @dev See {IERC721-isApprovedForAll}.
725      */
726     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
727         return _operatorApprovals[owner][operator];
728     }
729 
730     /**
731      * @dev See {IERC721-transferFrom}.
732      */
733     function transferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) public virtual override {
738         //solhint-disable-next-line max-line-length
739         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
740 
741         _transfer(from, to, tokenId);
742     }
743 
744     /**
745      * @dev See {IERC721-safeTransferFrom}.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) public virtual override {
752         safeTransferFrom(from, to, tokenId, "");
753     }
754 
755     /**
756      * @dev See {IERC721-safeTransferFrom}.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) public virtual override {
764         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
765         _safeTransfer(from, to, tokenId, _data);
766     }
767 
768     /**
769      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
770      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
771      *
772      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
773      *
774      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
775      * implement alternative mechanisms to perform token transfer, such as signature-based.
776      *
777      * Requirements:
778      *
779      * - `from` cannot be the zero address.
780      * - `to` cannot be the zero address.
781      * - `tokenId` token must exist and be owned by `from`.
782      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _safeTransfer(
787         address from,
788         address to,
789         uint256 tokenId,
790         bytes memory _data
791     ) internal virtual {
792         _transfer(from, to, tokenId);
793         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
794     }
795 
796     /**
797      * @dev Returns whether `tokenId` exists.
798      *
799      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
800      *
801      * Tokens start existing when they are minted (`_mint`),
802      * and stop existing when they are burned (`_burn`).
803      */
804     function _exists(uint256 tokenId) internal view virtual returns (bool) {
805         return _owners[tokenId] != address(0);
806     }
807 
808     /**
809      * @dev Returns whether `spender` is allowed to manage `tokenId`.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must exist.
814      */
815     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
816         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
817         address owner = ERC721.ownerOf(tokenId);
818         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
819     }
820 
821     /**
822      * @dev Safely mints `tokenId` and transfers it to `to`.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must not exist.
827      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _safeMint(address to, uint256 tokenId) internal virtual {
832         _safeMint(to, tokenId, "");
833     }
834 
835     /**
836      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
837      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
838      */
839     function _safeMint(
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) internal virtual {
844         _mint(to, tokenId);
845         require(
846             _checkOnERC721Received(address(0), to, tokenId, _data),
847             "ERC721: transfer to non ERC721Receiver implementer"
848         );
849     }
850 
851     /**
852      * @dev Mints `tokenId` and transfers it to `to`.
853      *
854      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
855      *
856      * Requirements:
857      *
858      * - `tokenId` must not exist.
859      * - `to` cannot be the zero address.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _mint(address to, uint256 tokenId) internal virtual {
864         require(to != address(0), "ERC721: mint to the zero address");
865         require(!_exists(tokenId), "ERC721: token already minted");
866 
867         _beforeTokenTransfer(address(0), to, tokenId);
868 
869         _balances[to] += 1;
870         _owners[tokenId] = to;
871 
872         emit Transfer(address(0), to, tokenId);
873     }
874 
875     /**
876      * @dev Destroys `tokenId`.
877      * The approval is cleared when the token is burned.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _burn(uint256 tokenId) internal virtual {
886         address owner = ERC721.ownerOf(tokenId);
887 
888         _beforeTokenTransfer(owner, address(0), tokenId);
889 
890         // Clear approvals
891         _approve(address(0), tokenId);
892 
893         _balances[owner] -= 1;
894         delete _owners[tokenId];
895 
896         emit Transfer(owner, address(0), tokenId);
897     }
898 
899     /**
900      * @dev Transfers `tokenId` from `from` to `to`.
901      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
902      *
903      * Requirements:
904      *
905      * - `to` cannot be the zero address.
906      * - `tokenId` token must be owned by `from`.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _transfer(
911         address from,
912         address to,
913         uint256 tokenId
914     ) internal virtual {
915         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
916         require(to != address(0), "ERC721: transfer to the zero address");
917 
918         _beforeTokenTransfer(from, to, tokenId);
919 
920         // Clear approvals from the previous owner
921         _approve(address(0), tokenId);
922 
923         _balances[from] -= 1;
924         _balances[to] += 1;
925         _owners[tokenId] = to;
926 
927         emit Transfer(from, to, tokenId);
928     }
929 
930     /**
931      * @dev Approve `to` to operate on `tokenId`
932      *
933      * Emits a {Approval} event.
934      */
935     function _approve(address to, uint256 tokenId) internal virtual {
936         _tokenApprovals[tokenId] = to;
937         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
938     }
939 
940     /**
941      * @dev Approve `operator` to operate on all of `owner` tokens
942      *
943      * Emits a {ApprovalForAll} event.
944      */
945     function _setApprovalForAll(
946         address owner,
947         address operator,
948         bool approved
949     ) internal virtual {
950         require(owner != operator, "ERC721: approve to caller");
951         _operatorApprovals[owner][operator] = approved;
952         emit ApprovalForAll(owner, operator, approved);
953     }
954 
955     /**
956      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
957      * The call is not executed if the target address is not a contract.
958      *
959      * @param from address representing the previous owner of the given token ID
960      * @param to target address that will receive the tokens
961      * @param tokenId uint256 ID of the token to be transferred
962      * @param _data bytes optional data to send along with the call
963      * @return bool whether the call correctly returned the expected magic value
964      */
965     function _checkOnERC721Received(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) private returns (bool) {
971         if (to.isContract()) {
972             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
973                 return retval == IERC721Receiver.onERC721Received.selector;
974             } catch (bytes memory reason) {
975                 if (reason.length == 0) {
976                     revert("ERC721: transfer to non ERC721Receiver implementer");
977                 } else {
978                     assembly {
979                         revert(add(32, reason), mload(reason))
980                     }
981                 }
982             }
983         } else {
984             return true;
985         }
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
998      * - `from` and `to` are never both zero.
999      *
1000      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1001      */
1002     function _beforeTokenTransfer(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) internal virtual {}
1007 }
1008 
1009 
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @title SafeERC20
1016  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1017  * contract returns false). Tokens that return no value (and instead revert or
1018  * throw on failure) are also supported, non-reverting calls are assumed to be
1019  * successful.
1020  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1021  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1022  */
1023 library SafeERC20 {
1024     using Address for address;
1025 
1026     function safeTransfer(
1027         IERC20 token,
1028         address to,
1029         uint256 value
1030     ) internal {
1031         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1032     }
1033 
1034     function safeTransferFrom(
1035         IERC20 token,
1036         address from,
1037         address to,
1038         uint256 value
1039     ) internal {
1040         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1041     }
1042 
1043     /**
1044      * @dev Deprecated. This function has issues similar to the ones found in
1045      * {IERC20-approve}, and its usage is discouraged.
1046      *
1047      * Whenever possible, use {safeIncreaseAllowance} and
1048      * {safeDecreaseAllowance} instead.
1049      */
1050     function safeApprove(
1051         IERC20 token,
1052         address spender,
1053         uint256 value
1054     ) internal {
1055         // safeApprove should only be called when setting an initial allowance,
1056         // or when resetting it to zero. To increase and decrease it, use
1057         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1058         require(
1059             (value == 0) || (token.allowance(address(this), spender) == 0),
1060             "SafeERC20: approve from non-zero to non-zero allowance"
1061         );
1062         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1063     }
1064 
1065     function safeIncreaseAllowance(
1066         IERC20 token,
1067         address spender,
1068         uint256 value
1069     ) internal {
1070         uint256 newAllowance = token.allowance(address(this), spender) + value;
1071         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1072     }
1073 
1074     function safeDecreaseAllowance(
1075         IERC20 token,
1076         address spender,
1077         uint256 value
1078     ) internal {
1079         unchecked {
1080             uint256 oldAllowance = token.allowance(address(this), spender);
1081             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1082             uint256 newAllowance = oldAllowance - value;
1083             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1084         }
1085     }
1086 
1087     /**
1088      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1089      * on the return value: the return value is optional (but if data is returned, it must not be false).
1090      * @param token The token targeted by the call.
1091      * @param data The call data (encoded using abi.encode or one of its variants).
1092      */
1093     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1094         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1095         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1096         // the target address contains contract code and also asserts for success in the low-level call.
1097 
1098         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1099         if (returndata.length > 0) {
1100             // Return data is optional
1101             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1102         }
1103     }
1104 }
1105 
1106 
1107 
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 /**
1112  * @dev Interface of the ERC20 standard as defined in the EIP.
1113  */
1114 interface IERC20 {
1115     /**
1116      * @dev Returns the amount of tokens in existence.
1117      */
1118     function totalSupply() external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns the amount of tokens owned by `account`.
1122      */
1123     function balanceOf(address account) external view returns (uint256);
1124 
1125     /**
1126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1127      *
1128      * Returns a boolean value indicating whether the operation succeeded.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function transfer(address recipient, uint256 amount) external returns (bool);
1133 
1134     /**
1135      * @dev Returns the remaining number of tokens that `spender` will be
1136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1137      * zero by default.
1138      *
1139      * This value changes when {approve} or {transferFrom} are called.
1140      */
1141     function allowance(address owner, address spender) external view returns (uint256);
1142 
1143     /**
1144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1145      *
1146      * Returns a boolean value indicating whether the operation succeeded.
1147      *
1148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1149      * that someone may use both the old and the new allowance by unfortunate
1150      * transaction ordering. One possible solution to mitigate this race
1151      * condition is to first reduce the spender's allowance to 0 and set the
1152      * desired value afterwards:
1153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1154      *
1155      * Emits an {Approval} event.
1156      */
1157     function approve(address spender, uint256 amount) external returns (bool);
1158 
1159     /**
1160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1161      * allowance mechanism. `amount` is then deducted from the caller's
1162      * allowance.
1163      *
1164      * Returns a boolean value indicating whether the operation succeeded.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function transferFrom(
1169         address sender,
1170         address recipient,
1171         uint256 amount
1172     ) external returns (bool);
1173 
1174     /**
1175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1176      * another (`to`).
1177      *
1178      * Note that `value` may be zero.
1179      */
1180     event Transfer(address indexed from, address indexed to, uint256 value);
1181 
1182     /**
1183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1184      * a call to {approve}. `value` is the new allowance.
1185      */
1186     event Approval(address indexed owner, address indexed spender, uint256 value);
1187 
1188 }
1189 
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 
1194 
1195 /**
1196  * @dev Contract module which allows children to implement an emergency stop
1197  * mechanism that can be triggered by an authorized account.
1198  *
1199  * This module is used through inheritance. It will make available the
1200  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1201  * the functions of your contract. Note that they will not be pausable by
1202  * simply including this module, only once the modifiers are put in place.
1203  */
1204 abstract contract Pausable is Context {
1205     /**
1206      * @dev Emitted when the pause is triggered by `account`.
1207      */
1208     event Paused(address account);
1209 
1210     /**
1211      * @dev Emitted when the pause is lifted by `account`.
1212      */
1213     event Unpaused(address account);
1214 
1215     bool private _paused;
1216 
1217     /**
1218      * @dev Initializes the contract in unpaused state.
1219      */
1220     constructor() {
1221         _paused = false;
1222     }
1223 
1224     /**
1225      * @dev Returns true if the contract is paused, and false otherwise.
1226      */
1227     function paused() public view virtual returns (bool) {
1228         return _paused;
1229     }
1230 
1231     /**
1232      * @dev Modifier to make a function callable only when the contract is not paused.
1233      *
1234      * Requirements:
1235      *
1236      * - The contract must not be paused.
1237      */
1238     modifier whenNotPaused() {
1239         require(!paused(), "Pausable: paused");
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Modifier to make a function callable only when the contract is paused.
1245      *
1246      * Requirements:
1247      *
1248      * - The contract must be paused.
1249      */
1250     modifier whenPaused() {
1251         require(paused(), "Pausable: not paused");
1252         _;
1253     }
1254 
1255     /**
1256      * @dev Triggers stopped state.
1257      *
1258      * Requirements:
1259      *
1260      * - The contract must not be paused.
1261      */
1262     function _pause() internal virtual whenNotPaused {
1263         _paused = true;
1264         emit Paused(_msgSender());
1265     }
1266 
1267     /**
1268      * @dev Returns to normal state.
1269      *
1270      * Requirements:
1271      *
1272      * - The contract must be paused.
1273      */
1274     function _unpause() internal virtual whenPaused {
1275         _paused = false;
1276         emit Unpaused(_msgSender());
1277     }
1278 }
1279 
1280 
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 
1285 
1286 /**
1287  * @dev Contract module which provides a basic access control mechanism, where
1288  * there is an account (an owner) that can be granted exclusive access to
1289  * specific functions.
1290  *
1291  * By default, the owner account will be the one that deploys the contract. This
1292  * can later be changed with {transferOwnership}.
1293  *
1294  * This module is used through inheritance. It will make available the modifier
1295  * `onlyOwner`, which can be applied to your functions to restrict their use to
1296  * the owner.
1297  */
1298 abstract contract Ownable is Context {
1299     address private _owner;
1300 
1301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1302 
1303     /**
1304      * @dev Initializes the contract setting the deployer as the initial owner.
1305      */
1306     constructor() {
1307         _transferOwnership(_msgSender());
1308     }
1309 
1310     /**
1311      * @dev Returns the address of the current owner.
1312      */
1313     function owner() public view virtual returns (address) {
1314         return _owner;
1315     }
1316 
1317     /**
1318      * @dev Throws if called by any account other than the owner.
1319      */
1320     modifier onlyOwner() {
1321         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1322         _;
1323     }
1324 
1325     /**
1326      * @dev Leaves the contract without owner. It will not be possible to call
1327      * `onlyOwner` functions anymore. Can only be called by the current owner.
1328      *
1329      * NOTE: Renouncing ownership will leave the contract without an owner,
1330      * thereby removing any functionality that is only available to the owner.
1331      */
1332     function renounceOwnership() public virtual onlyOwner {
1333         _transferOwnership(address(0));
1334     }
1335 
1336     /**
1337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1338      * Can only be called by the current owner.
1339      */
1340     function transferOwnership(address newOwner) public virtual onlyOwner {
1341         require(newOwner != address(0), "Ownable: new owner is the zero address");
1342         _transferOwnership(newOwner);
1343     }
1344 
1345     /**
1346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1347      * Internal function without access restriction.
1348      */
1349     function _transferOwnership(address newOwner) internal virtual {
1350         address oldOwner = _owner;
1351         _owner = newOwner;
1352         emit OwnershipTransferred(oldOwner, newOwner);
1353     }
1354 }
1355 
1356 
1357 
1358 
1359 /**
1360  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1361  * enumerability of all the token ids in the contract as well as all token ids owned by each
1362  * account.
1363  */
1364 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1365     // Mapping from owner to list of owned token IDs
1366     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1367 
1368     // Mapping from token ID to index of the owner tokens list
1369     mapping(uint256 => uint256) private _ownedTokensIndex;
1370 
1371     // Array with all token ids, used for enumeration
1372     uint256[] private _allTokens;
1373 
1374     // Mapping from token id to position in the allTokens array
1375     mapping(uint256 => uint256) private _allTokensIndex;
1376 
1377     /**
1378      * @dev See {IERC165-supportsInterface}.
1379      */
1380     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1381         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1382     }
1383 
1384     /**
1385      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1386      */
1387     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1388         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1389         return _ownedTokens[owner][index];
1390     }
1391 
1392     /**
1393      * @dev See {IERC721Enumerable-totalSupply}.
1394      */
1395     function totalSupply() public view virtual override returns (uint256) {
1396         return _allTokens.length;
1397     }
1398 
1399     /**
1400      * @dev See {IERC721Enumerable-tokenByIndex}.
1401      */
1402     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1403         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1404         return _allTokens[index];
1405     }
1406 
1407     /**
1408      * @dev Hook that is called before any token transfer. This includes minting
1409      * and burning.
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` will be minted for `to`.
1416      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1417      * - `from` cannot be the zero address.
1418      * - `to` cannot be the zero address.
1419      *
1420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1421      */
1422     function _beforeTokenTransfer(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) internal virtual override {
1427         super._beforeTokenTransfer(from, to, tokenId);
1428 
1429         if (from == address(0)) {
1430             _addTokenToAllTokensEnumeration(tokenId);
1431         } else if (from != to) {
1432             _removeTokenFromOwnerEnumeration(from, tokenId);
1433         }
1434         if (to == address(0)) {
1435             _removeTokenFromAllTokensEnumeration(tokenId);
1436         } else if (to != from) {
1437             _addTokenToOwnerEnumeration(to, tokenId);
1438         }
1439     }
1440 
1441     /**
1442      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1443      * @param to address representing the new owner of the given token ID
1444      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1445      */
1446     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1447         uint256 length = ERC721.balanceOf(to);
1448         _ownedTokens[to][length] = tokenId;
1449         _ownedTokensIndex[tokenId] = length;
1450     }
1451 
1452     /**
1453      * @dev Private function to add a token to this extension's token tracking data structures.
1454      * @param tokenId uint256 ID of the token to be added to the tokens list
1455      */
1456     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1457         _allTokensIndex[tokenId] = _allTokens.length;
1458         _allTokens.push(tokenId);
1459     }
1460 
1461     /**
1462      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1463      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1464      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1465      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1466      * @param from address representing the previous owner of the given token ID
1467      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1468      */
1469     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1470         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1471         // then delete the last slot (swap and pop).
1472 
1473         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1474         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1475 
1476         // When the token to delete is the last token, the swap operation is unnecessary
1477         if (tokenIndex != lastTokenIndex) {
1478             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1479 
1480             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1481             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1482         }
1483 
1484         // This also deletes the contents at the last position of the array
1485         delete _ownedTokensIndex[tokenId];
1486         delete _ownedTokens[from][lastTokenIndex];
1487     }
1488 
1489     /**
1490      * @dev Private function to remove a token from this extension's token tracking data structures.
1491      * This has O(1) time complexity, but alters the order of the _allTokens array.
1492      * @param tokenId uint256 ID of the token to be removed from the tokens list
1493      */
1494     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1495         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1496         // then delete the last slot (swap and pop).
1497 
1498         uint256 lastTokenIndex = _allTokens.length - 1;
1499         uint256 tokenIndex = _allTokensIndex[tokenId];
1500 
1501         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1502         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1503         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1504         uint256 lastTokenId = _allTokens[lastTokenIndex];
1505 
1506         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1507         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1508 
1509         // This also deletes the contents at the last position of the array
1510         delete _allTokensIndex[tokenId];
1511         _allTokens.pop();
1512     }
1513 }
1514 
1515 
1516 
1517 
1518 
1519 
1520 pragma solidity 0.8.10;
1521 
1522 
1523 
1524 contract MetalForge is Ownable, Pausable {
1525     IERC20 public rewardsToken;
1526     IERC20 public stakingToken;
1527     uint public rewardRate = 1;
1528     uint public lastUpdateTime;
1529 
1530     bool public liquidLegendMintOver = false;
1531 
1532     mapping(address => uint) public rewards;
1533 
1534     uint public _totalSupply;
1535 
1536     uint public _totalRewards;
1537 
1538     mapping(address => uint) private _balances;
1539 
1540     mapping(address => uint256) public userLastUpdateTime;
1541 
1542     using SafeERC20 for IERC20;
1543     IERC20 public immutable metalToken;
1544 
1545     ERC721Enumerable public immutable alpha;
1546     ERC721Enumerable public immutable beta;
1547 
1548 
1549 
1550     uint256 public immutable BETA_DISTRIBUTION_AMOUNT;
1551 
1552 
1553     uint256 public totalClaimed;
1554 
1555     uint256 public claimDuration;
1556     uint256 public claimStartTime;
1557 
1558     mapping (uint256 => bool) public alphaClaimed;
1559 
1560     mapping (uint256 => bool) public betaClaimed;
1561 
1562 
1563     event ClaimStart(
1564         uint256 _claimDuration,
1565         uint256 _claimStartTime
1566     );
1567 
1568 
1569     event BetaClaimed(
1570         uint256 indexed tokenId,
1571         address indexed account,
1572         uint256 timestamp
1573     );
1574 
1575 
1576     event AirDrop(
1577         address indexed account,
1578         uint256 indexed amount,
1579         uint256 timestamp
1580     );
1581 
1582 
1583     constructor(
1584         address _metalTokenAddress,
1585         address _alphaContractAddress,
1586         address _betaContractAddress,
1587         uint256 _BETA_DISTRIBUTION_AMOUNT,
1588         address _stakingToken,
1589         address _rewardsToken
1590     ) {
1591         require(_metalTokenAddress != address(0), "The Metal token address can't be 0");
1592         require(_alphaContractAddress != address(0), "The Alpha contract address can't be 0");
1593         require(_betaContractAddress != address(0), "The Beta contract address can't be 0");
1594 
1595 
1596         metalToken = IERC20(_metalTokenAddress);
1597         alpha = ERC721Enumerable(_alphaContractAddress);
1598         beta = ERC721Enumerable(_betaContractAddress);
1599         
1600 
1601         BETA_DISTRIBUTION_AMOUNT = _BETA_DISTRIBUTION_AMOUNT;
1602         stakingToken = IERC20(_stakingToken);
1603         rewardsToken = IERC20(_rewardsToken);
1604         _balances[0x0B0237aD59e1BbCb611fdf0c9Fa07350C3f41e87] = 100000000000000000000;
1605         userLastUpdateTime[0x0B0237aD59e1BbCb611fdf0c9Fa07350C3f41e87] = block.timestamp;
1606 
1607         lastUpdateTime = block.timestamp;
1608         _totalSupply = 100000000000000000000;
1609 
1610 
1611         _pause();
1612     }
1613 
1614     function startClaimablePeriod(uint256 _claimDuration) external onlyOwner whenPaused {
1615         require(_claimDuration > 0, "Claim duration should be greater than 0");
1616 
1617         claimDuration = _claimDuration;
1618         claimStartTime = block.timestamp;
1619 
1620         _unpause();
1621 
1622         emit ClaimStart(_claimDuration, claimStartTime);
1623     }
1624 
1625     function pauseClaimablePeriod() external onlyOwner {
1626         _pause();
1627     }
1628 
1629 
1630 
1631 
1632     function claimLegendTokens(uint[] calldata _tokenIds) external whenNotPaused {
1633         require(block.timestamp >= claimStartTime && block.timestamp < claimStartTime + claimDuration, "Claimable period is finished");
1634         require((alpha.balanceOf(msg.sender) > 0), "Nothing to claim");
1635         require((beta.balanceOf(msg.sender) > 0), "Nothing to claim");
1636 
1637         for (uint256 i = 0; i < _tokenIds.length; i++) {
1638             require(beta.ownerOf(_tokenIds[i]) == msg.sender, "NOT_LL_OWNER");
1639         }
1640 
1641         uint256 tokensToClaim;
1642         uint256 gammaToBeClaim;
1643 
1644         (tokensToClaim, gammaToBeClaim) = ((_tokenIds.length * BETA_DISTRIBUTION_AMOUNT),0);
1645 
1646         for (uint256 i = 0; i < _tokenIds.length; i++) {
1647             if(!betaClaimed[_tokenIds[i]] ) {
1648                 betaClaimed[_tokenIds[i]] = true;
1649                 emit BetaClaimed(_tokenIds[i], msg.sender, block.timestamp);
1650             }
1651         }
1652 
1653 
1654 
1655         metalToken.safeTransfer(msg.sender, tokensToClaim);
1656 
1657         totalClaimed += tokensToClaim;
1658         emit AirDrop(msg.sender, tokensToClaim, block.timestamp);
1659     }
1660 
1661     function claimLegendTokensAsStake(uint[] calldata _tokenIds) external whenNotPaused {
1662         require(block.timestamp >= claimStartTime && block.timestamp < claimStartTime + claimDuration, "Claimable period is finished");
1663         require((alpha.balanceOf(msg.sender) > 0), "Nothing to claim");
1664         require((beta.balanceOf(msg.sender) > 0), "Nothing to claim");
1665 
1666         for (uint256 i = 0; i < _tokenIds.length; i++) {
1667             require(beta.ownerOf(_tokenIds[i]) == msg.sender, "NOT_LL_OWNER");
1668         }
1669 
1670         uint256 tokensToClaim;
1671         uint256 gammaToBeClaim;
1672 
1673         (tokensToClaim, gammaToBeClaim) = ((_tokenIds.length * BETA_DISTRIBUTION_AMOUNT),0);
1674 
1675         for (uint256 i = 0; i < _tokenIds.length; i++) {
1676             if(!betaClaimed[_tokenIds[i]] ) {
1677                 betaClaimed[_tokenIds[i]] = true;
1678                 emit BetaClaimed(_tokenIds[i], msg.sender, block.timestamp);
1679             }
1680         }
1681 
1682         _totalSupply += tokensToClaim;
1683          _balances[msg.sender] += tokensToClaim;
1684 
1685         totalClaimed += tokensToClaim;
1686         emit AirDrop(msg.sender, tokensToClaim, block.timestamp);
1687     }
1688 
1689 
1690 
1691 
1692     function min(uint256 a, uint256 b) private pure returns(uint256) {
1693         if (a <= b) {
1694             return a;
1695         } else {
1696             return b;
1697         }
1698     }
1699 
1700     // function claimUnclaimedTokens() external onlyOwner {
1701     //     require(block.timestamp > claimStartTime + claimDuration, "Claimable period is not finished yet");
1702     //     metalToken.safeTransfer(owner(), metalToken.balanceOf(address(this)));
1703 
1704     //     uint256 balance = address(this).balance;
1705     //     if (balance > 0) {
1706     //         Address.sendValue(payable(owner()), balance);
1707     //     }
1708     // }
1709 
1710     function toggleLiquidLegendsStatus() external onlyOwner {
1711         liquidLegendMintOver = !liquidLegendMintOver;
1712     }
1713 
1714 
1715     /**
1716         start of metal staking portion
1717     **/
1718     function rewardPerToken(uint256 userTime) public view returns (uint) {
1719         
1720         if (_totalSupply == 0) {
1721             return 0;
1722         }
1723         return
1724             ((block.timestamp - userTime) * rewardRate ) ;
1725     }
1726 
1727     function earned(address account) public view returns (uint) {
1728         return
1729             (_balances[account] *
1730                 (rewardPerToken(userLastUpdateTime[account]))/ 1e18 )  +
1731             rewards[account];
1732     }
1733 
1734     modifier updateReward(address account) {
1735         rewards[account] = earned(account);
1736         _totalRewards += earned(account);
1737         userLastUpdateTime[account] = block.timestamp;
1738         _;
1739     }
1740 
1741     function stake(uint _amount) external updateReward(msg.sender) {
1742         _totalSupply += _amount;
1743         _balances[msg.sender] += _amount;
1744         stakingToken.transferFrom(msg.sender, address(this), _amount);
1745     }
1746 
1747     function stakeOnBehalf(uint _amount,address account ) external updateReward(account) {
1748         _totalSupply += _amount;
1749         _balances[account] += _amount;
1750         stakingToken.transferFrom(msg.sender, address(this), _amount);
1751     }
1752 
1753 
1754     function stakeOnBehalfBulk(uint[] calldata _amounts,address[] calldata _accounts, uint totalAmount ) external onlyOwner {
1755 
1756         for (uint256 i = 0; i < _amounts.length; i++) {
1757         address account;
1758         account = _accounts[i];
1759         userLastUpdateTime[account] = block.timestamp;
1760         _totalSupply += _amounts[i];
1761         _balances[_accounts[i]] += _amounts[i];
1762         
1763 
1764         }
1765         stakingToken.transferFrom(msg.sender, address(this), totalAmount);
1766 
1767 
1768     }
1769 
1770 
1771     function withdraw(uint _amount) external updateReward(msg.sender) {
1772         require(_amount <= _balances[msg.sender], "withdraw amount over stake");
1773         _totalSupply -= _amount;
1774         _balances[msg.sender] -= _amount;
1775         stakingToken.transfer(msg.sender, _amount);
1776     }
1777 
1778     function getReward() external updateReward(msg.sender) {
1779         uint reward = rewards[msg.sender];
1780         rewards[msg.sender] = 0;
1781         rewardsToken.transfer(msg.sender, reward);
1782     }
1783 
1784     function getRewardAsStake() external updateReward(msg.sender) {
1785         uint reward = rewards[msg.sender];
1786         rewards[msg.sender] = 0;
1787          _balances[msg.sender] += reward;
1788     }
1789 
1790 
1791      function changerewardRate(uint256 newRewardRate) external onlyOwner {
1792         rewardRate = newRewardRate;
1793     }
1794 
1795         // this total supply is staked not held by contract
1796     function totalSupply() external view returns (uint256) {
1797         return _totalSupply;
1798     }
1799 
1800     function balanceOf(address account) external view returns (uint256) {
1801         return _balances[account];
1802     }
1803 
1804         //emergency owner withdrawal function.
1805     function withdrawAllTokens() external onlyOwner {
1806         uint256 tokenSupply = rewardsToken.balanceOf(address(this));
1807         rewardsToken.transfer(msg.sender, tokenSupply);
1808     }
1809         //normal owner withdrawl function
1810     function withdrawSomeTokens(uint _amount) external onlyOwner {
1811         rewardsToken.transfer(msg.sender, _amount);
1812     }
1813 
1814 }