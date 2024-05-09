1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
40  * @dev See https://eips.ethereum.org/EIPS/eip-721
41  */
42  
43  interface IERC721 is IERC165 {
44     /**
45      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
51      */
52     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56      */
57     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
58 
59     /**
60      * @dev Returns the number of tokens in ``owner``'s account.
61      */
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the `tokenId` token.
66      *
67      * Requirements:
68      *
69      * - `tokenId` must exist.
70      */
71     function ownerOf(uint256 tokenId) external view returns (address owner);
72 
73     /**
74      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
75      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92 
93     /**
94      * @dev Transfers `tokenId` token from `from` to `to`.
95      *
96      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must be owned by `from`.
103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 tokenId
111     ) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId) external view returns (address operator);
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
151      *
152      * See {setApprovalForAll}
153      */
154     function isApprovedForAll(address owner, address operator) external view returns (bool);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166      *
167      * Emits a {Transfer} event.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 }
176  
177 interface IERC721Enumerable is IERC721 {
178     /**
179      * @dev Returns the total amount of tokens stored by the contract.
180      */
181     function totalSupply() external view returns (uint256);
182 
183     /**
184      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
185      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
186      */
187     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
188 
189     /**
190      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
191      * Use along with {totalSupply} to enumerate all tokens.
192      */
193     function tokenByIndex(uint256 index) external view returns (uint256);
194 }
195 
196 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
197 
198 
199 
200 pragma solidity ^0.8.0;
201 
202 
203 /**
204  * @dev Implementation of the {IERC165} interface.
205  *
206  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
207  * for the additional interface id that will be supported. For example:
208  *
209  * ```solidity
210  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
211  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
212  * }
213  * ```
214  *
215  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
216  */
217 abstract contract ERC165 is IERC165 {
218     /**
219      * @dev See {IERC165-supportsInterface}.
220      */
221     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
222         return interfaceId == type(IERC165).interfaceId;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Strings.sol
227 
228 
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev String operations.
234  */
235 library Strings {
236     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
237 
238     /**
239      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
240      */
241     function toString(uint256 value) internal pure returns (string memory) {
242         // Inspired by OraclizeAPI's implementation - MIT licence
243         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
244 
245         if (value == 0) {
246             return "0";
247         }
248         uint256 temp = value;
249         uint256 digits;
250         while (temp != 0) {
251             digits++;
252             temp /= 10;
253         }
254         bytes memory buffer = new bytes(digits);
255         while (value != 0) {
256             digits -= 1;
257             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
258             value /= 10;
259         }
260         return string(buffer);
261     }
262 
263     /**
264      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
265      */
266     function toHexString(uint256 value) internal pure returns (string memory) {
267         if (value == 0) {
268             return "0x00";
269         }
270         uint256 temp = value;
271         uint256 length = 0;
272         while (temp != 0) {
273             length++;
274             temp >>= 8;
275         }
276         return toHexString(value, length);
277     }
278 
279     /**
280      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
281      */
282     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
283         bytes memory buffer = new bytes(2 * length + 2);
284         buffer[0] = "0";
285         buffer[1] = "x";
286         for (uint256 i = 2 * length + 1; i > 1; --i) {
287             buffer[i] = _HEX_SYMBOLS[value & 0xf];
288             value >>= 4;
289         }
290         require(value == 0, "Strings: hex length insufficient");
291         return string(buffer);
292     }
293 }
294 
295 // File: @openzeppelin/contracts/utils/Address.sol
296 
297 
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Collection of functions related to the address type
303  */
304 library Address {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * [IMPORTANT]
309      * ====
310      * It is unsafe to assume that an address for which this function returns
311      * false is an externally-owned account (EOA) and not a contract.
312      *
313      * Among others, `isContract` will return false for the following
314      * types of addresses:
315      *
316      *  - an externally-owned account
317      *  - a contract in construction
318      *  - an address where a contract will be created
319      *  - an address where a contract lived, but was destroyed
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // This method relies on extcodesize, which returns 0 for contracts in
324         // construction, since the code is only stored at the end of the
325         // constructor execution.
326 
327         uint256 size;
328         assembly {
329             size := extcodesize(account)
330         }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         (bool success, ) = recipient.call{value: amount}("");
354         require(success, "Address: unable to send value, recipient may have reverted");
355     }
356 
357     /**
358      * @dev Performs a Solidity function call using a low level `call`. A
359      * plain `call` is an unsafe replacement for a function call: use this
360      * function instead.
361      *
362      * If `target` reverts with a revert reason, it is bubbled up by this
363      * function (like regular Solidity function calls).
364      *
365      * Returns the raw returned data. To convert to the expected return value,
366      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
367      *
368      * Requirements:
369      *
370      * - `target` must be a contract.
371      * - calling `target` with `data` must not revert.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionCall(target, data, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(address(this).balance >= value, "Address: insufficient balance for call");
425         require(isContract(target), "Address: call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.call{value: value}(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
438         return functionStaticCall(target, data, "Address: low-level static call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal view returns (bytes memory) {
452         require(isContract(target), "Address: static call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.staticcall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(isContract(target), "Address: delegate call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.delegatecall(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
487      * revert reason using the provided one.
488      *
489      * _Available since v4.3._
490      */
491     function verifyCallResult(
492         bool success,
493         bytes memory returndata,
494         string memory errorMessage
495     ) internal pure returns (bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502 
503                 assembly {
504                     let returndata_size := mload(returndata)
505                     revert(add(32, returndata), returndata_size)
506                 }
507             } else {
508                 revert(errorMessage);
509             }
510         }
511     }
512 }
513 
514 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
515 
516 
517 
518 pragma solidity ^0.8.0;
519 
520 
521 /**
522  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
523  * @dev See https://eips.ethereum.org/EIPS/eip-721
524  */
525 interface IERC721Metadata is IERC721 {
526     /**
527      * @dev Returns the token collection name.
528      */
529     function name() external view returns (string memory);
530 
531     /**
532      * @dev Returns the token collection symbol.
533      */
534     function symbol() external view returns (string memory);
535 
536     /**
537      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
538      */
539     function tokenURI(uint256 tokenId) external view returns (string memory);
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
543 
544 
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @title ERC721 token receiver interface
550  * @dev Interface for any contract that wants to support safeTransfers
551  * from ERC721 asset contracts.
552  */
553 interface IERC721Receiver {
554     /**
555      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
556      * by `operator` from `from`, this function is called.
557      *
558      * It must return its Solidity selector to confirm the token transfer.
559      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
560      *
561      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
562      */
563     function onERC721Received(
564         address operator,
565         address from,
566         uint256 tokenId,
567         bytes calldata data
568     ) external returns (bytes4);
569 }
570 
571 
572 
573 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
574 
575 
576 
577 pragma solidity ^0.8.0;
578 
579 /**
580  * @dev Required interface of an ERC721 compliant contract.
581  */
582 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
583 
584 
585 
586 pragma solidity ^0.8.0;
587 
588 
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Provides information about the current execution context, including the
594  * sender of the transaction and its data. While these are generally available
595  * via msg.sender and msg.data, they should not be accessed in such a direct
596  * manner, since when dealing with meta-transactions the account sending and
597  * paying for execution may not be the actual sender (as far as an application
598  * is concerned).
599  *
600  * This contract is only required for intermediate, library-like contracts.
601  */
602 abstract contract Context {
603     function _msgSender() internal view virtual returns (address) {
604         return msg.sender;
605     }
606 
607     function _msgData() internal view virtual returns (bytes calldata) {
608         return msg.data;
609     }
610 }
611 
612 
613 
614 
615 /**
616  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
617  * the Metadata extension, but not including the Enumerable extension, which is available separately as
618  * {ERC721Enumerable}.
619  */
620 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
621     using Address for address;
622     using Strings for uint256;
623 
624     // Token name
625     string private _name;
626 
627     // Token symbol
628     string private _symbol;
629 
630     // Mapping from token ID to owner address
631     mapping(uint256 => address) private _owners;
632 
633     // Mapping owner address to token count
634     mapping(address => uint256) private _balances;
635 
636     // Mapping from token ID to approved address
637     mapping(uint256 => address) private _tokenApprovals;
638 
639     // Mapping from owner to operator approvals
640     mapping(address => mapping(address => bool)) private _operatorApprovals;
641 
642     /**
643      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
644      */
645     constructor(string memory name_, string memory symbol_) {
646         _name = name_;
647         _symbol = symbol_;
648     }
649 
650     /**
651      * @dev See {IERC165-supportsInterface}.
652      */
653     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
654         return
655             interfaceId == type(IERC721).interfaceId ||
656             interfaceId == type(IERC721Metadata).interfaceId ||
657             super.supportsInterface(interfaceId);
658     }
659 
660     /**
661      * @dev See {IERC721-balanceOf}.
662      */
663     function balanceOf(address owner) public view virtual override returns (uint256) {
664         require(owner != address(0), "ERC721: balance query for the zero address");
665         return _balances[owner];
666     }
667 
668     /**
669      * @dev See {IERC721-ownerOf}.
670      */
671     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
672         address owner = _owners[tokenId];
673         require(owner != address(0), "ERC721: owner query for nonexistent token");
674         return owner;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-name}.
679      */
680     function name() public view virtual override returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-symbol}.
686      */
687     function symbol() public view virtual override returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-tokenURI}.
693      */
694     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
695         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
696 
697         string memory baseURI = _baseURI();
698         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
699     }
700 
701     /**
702      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
703      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
704      * by default, can be overriden in child contracts.
705      */
706     function _baseURI() internal view virtual returns (string memory) {
707         return "";
708     }
709 
710     /**
711      * @dev See {IERC721-approve}.
712      */
713     function approve(address to, uint256 tokenId) public virtual override {
714         address owner = ERC721.ownerOf(tokenId);
715         require(to != owner, "ERC721: approval to current owner");
716 
717         require(
718             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
719             "ERC721: approve caller is not owner nor approved for all"
720         );
721 
722         _approve(to, tokenId);
723     }
724 
725     /**
726      * @dev See {IERC721-getApproved}.
727      */
728     function getApproved(uint256 tokenId) public view virtual override returns (address) {
729         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
730 
731         return _tokenApprovals[tokenId];
732     }
733 
734     /**
735      * @dev See {IERC721-setApprovalForAll}.
736      */
737     function setApprovalForAll(address operator, bool approved) public virtual override {
738         require(operator != _msgSender(), "ERC721: approve to caller");
739 
740         _operatorApprovals[_msgSender()][operator] = approved;
741         emit ApprovalForAll(_msgSender(), operator, approved);
742     }
743 
744     /**
745      * @dev See {IERC721-isApprovedForAll}.
746      */
747     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
748         return _operatorApprovals[owner][operator];
749     }
750 
751     /**
752      * @dev See {IERC721-transferFrom}.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         //solhint-disable-next-line max-line-length
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761 
762         _transfer(from, to, tokenId);
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) public virtual override {
773         safeTransferFrom(from, to, tokenId, "");
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) public virtual override {
785         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
786         _safeTransfer(from, to, tokenId, _data);
787     }
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
794      *
795      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
796      * implement alternative mechanisms to perform token transfer, such as signature-based.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must exist and be owned by `from`.
803      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
804      *
805      * Emits a {Transfer} event.
806      */
807     function _safeTransfer(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) internal virtual {
813         _transfer(from, to, tokenId);
814         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
815     }
816 
817     /**
818      * @dev Returns whether `tokenId` exists.
819      *
820      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
821      *
822      * Tokens start existing when they are minted (`_mint`),
823      * and stop existing when they are burned (`_burn`).
824      */
825     function _exists(uint256 tokenId) internal view virtual returns (bool) {
826         return _owners[tokenId] != address(0);
827     }
828 
829     /**
830      * @dev Returns whether `spender` is allowed to manage `tokenId`.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      */
836     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
837         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
838         address owner = ERC721.ownerOf(tokenId);
839         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
840     }
841 
842     /**
843      * @dev Safely mints `tokenId` and transfers it to `to`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must not exist.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _safeMint(address to, uint256 tokenId) internal virtual {
853         _safeMint(to, tokenId, "");
854     }
855 
856     /**
857      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
858      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
859      */
860     function _safeMint(
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _mint(to, tokenId);
866         require(
867             _checkOnERC721Received(address(0), to, tokenId, _data),
868             "ERC721: transfer to non ERC721Receiver implementer"
869         );
870     }
871 
872     /**
873      * @dev Mints `tokenId` and transfers it to `to`.
874      *
875      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
876      *
877      * Requirements:
878      *
879      * - `tokenId` must not exist.
880      * - `to` cannot be the zero address.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _mint(address to, uint256 tokenId) internal virtual {
885         require(to != address(0), "ERC721: mint to the zero address");
886         require(!_exists(tokenId), "ERC721: token already minted");
887 
888         _beforeTokenTransfer(address(0), to, tokenId);
889 
890         _balances[to] += 1;
891         _owners[tokenId] = to;
892 
893         emit Transfer(address(0), to, tokenId);
894     }
895 
896     /**
897      * @dev Destroys `tokenId`.
898      * The approval is cleared when the token is burned.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _burn(uint256 tokenId) internal virtual {
907         address owner = ERC721.ownerOf(tokenId);
908 
909         _beforeTokenTransfer(owner, address(0), tokenId);
910 
911         // Clear approvals
912         _approve(address(0), tokenId);
913 
914         _balances[owner] -= 1;
915         delete _owners[tokenId];
916 
917         emit Transfer(owner, address(0), tokenId);
918     }
919 
920     /**
921      * @dev Transfers `tokenId` from `from` to `to`.
922      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
923      *
924      * Requirements:
925      *
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must be owned by `from`.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _transfer(
932         address from,
933         address to,
934         uint256 tokenId
935     ) internal virtual {
936         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
937         require(to != address(0), "ERC721: transfer to the zero address");
938 
939         _beforeTokenTransfer(from, to, tokenId);
940 
941         // Clear approvals from the previous owner
942         _approve(address(0), tokenId);
943 
944         _balances[from] -= 1;
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev Approve `to` to operate on `tokenId`
953      *
954      * Emits a {Approval} event.
955      */
956     function _approve(address to, uint256 tokenId) internal virtual {
957         _tokenApprovals[tokenId] = to;
958         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
959     }
960 
961     /**
962      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
963      * The call is not executed if the target address is not a contract.
964      *
965      * @param from address representing the previous owner of the given token ID
966      * @param to target address that will receive the tokens
967      * @param tokenId uint256 ID of the token to be transferred
968      * @param _data bytes optional data to send along with the call
969      * @return bool whether the call correctly returned the expected magic value
970      */
971     function _checkOnERC721Received(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) private returns (bool) {
977         if (to.isContract()) {
978             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
979                 return retval == IERC721Receiver.onERC721Received.selector;
980             } catch (bytes memory reason) {
981                 if (reason.length == 0) {
982                     revert("ERC721: transfer to non ERC721Receiver implementer");
983                 } else {
984                     assembly {
985                         revert(add(32, reason), mload(reason))
986                     }
987                 }
988             }
989         } else {
990             return true;
991         }
992     }
993 
994     /**
995      * @dev Hook that is called before any token transfer. This includes minting
996      * and burning.
997      *
998      * Calling conditions:
999      *
1000      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1001      * transferred to `to`.
1002      * - When `from` is zero, `tokenId` will be minted for `to`.
1003      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1004      * - `from` and `to` are never both zero.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _beforeTokenTransfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) internal virtual {}
1013 }
1014 
1015 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1016 
1017 
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 
1023 /**
1024  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1025  * enumerability of all the token ids in the contract as well as all token ids owned by each
1026  * account.
1027  */
1028 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1029     // Mapping from owner to list of owned token IDs
1030     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1031 
1032     // Mapping from token ID to index of the owner tokens list
1033     mapping(uint256 => uint256) private _ownedTokensIndex;
1034 
1035     // Array with all token ids, used for enumeration
1036     uint256[] private _allTokens;
1037 
1038     // Mapping from token id to position in the allTokens array
1039     mapping(uint256 => uint256) private _allTokensIndex;
1040 
1041     /**
1042      * @dev See {IERC165-supportsInterface}.
1043      */
1044     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1045         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1050      */
1051     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1052         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1053         return _ownedTokens[owner][index];
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-totalSupply}.
1058      */
1059     function totalSupply() public view virtual override returns (uint256) {
1060         return _allTokens.length;
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-tokenByIndex}.
1065      */
1066     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1067         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1068         return _allTokens[index];
1069     }
1070 
1071     /**
1072      * @dev Hook that is called before any token transfer. This includes minting
1073      * and burning.
1074      *
1075      * Calling conditions:
1076      *
1077      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1078      * transferred to `to`.
1079      * - When `from` is zero, `tokenId` will be minted for `to`.
1080      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1081      * - `from` cannot be the zero address.
1082      * - `to` cannot be the zero address.
1083      *
1084      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1085      */
1086     function _beforeTokenTransfer(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) internal virtual override {
1091         super._beforeTokenTransfer(from, to, tokenId);
1092 
1093         if (from == address(0)) {
1094             _addTokenToAllTokensEnumeration(tokenId);
1095         } else if (from != to) {
1096             _removeTokenFromOwnerEnumeration(from, tokenId);
1097         }
1098         if (to == address(0)) {
1099             _removeTokenFromAllTokensEnumeration(tokenId);
1100         } else if (to != from) {
1101             _addTokenToOwnerEnumeration(to, tokenId);
1102         }
1103     }
1104 
1105     /**
1106      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1107      * @param to address representing the new owner of the given token ID
1108      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1109      */
1110     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1111         uint256 length = ERC721.balanceOf(to);
1112         _ownedTokens[to][length] = tokenId;
1113         _ownedTokensIndex[tokenId] = length;
1114     }
1115 
1116     /**
1117      * @dev Private function to add a token to this extension's token tracking data structures.
1118      * @param tokenId uint256 ID of the token to be added to the tokens list
1119      */
1120     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1121         _allTokensIndex[tokenId] = _allTokens.length;
1122         _allTokens.push(tokenId);
1123     }
1124 
1125     /**
1126      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1127      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1128      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1129      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1130      * @param from address representing the previous owner of the given token ID
1131      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1132      */
1133     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1134         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1135         // then delete the last slot (swap and pop).
1136 
1137         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1138         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1139 
1140         // When the token to delete is the last token, the swap operation is unnecessary
1141         if (tokenIndex != lastTokenIndex) {
1142             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1143 
1144             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1145             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1146         }
1147 
1148         // This also deletes the contents at the last position of the array
1149         delete _ownedTokensIndex[tokenId];
1150         delete _ownedTokens[from][lastTokenIndex];
1151     }
1152 
1153     /**
1154      * @dev Private function to remove a token from this extension's token tracking data structures.
1155      * This has O(1) time complexity, but alters the order of the _allTokens array.
1156      * @param tokenId uint256 ID of the token to be removed from the tokens list
1157      */
1158     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1159         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1160         // then delete the last slot (swap and pop).
1161 
1162         uint256 lastTokenIndex = _allTokens.length - 1;
1163         uint256 tokenIndex = _allTokensIndex[tokenId];
1164 
1165         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1166         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1167         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1168         uint256 lastTokenId = _allTokens[lastTokenIndex];
1169 
1170         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1171         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1172 
1173         // This also deletes the contents at the last position of the array
1174         delete _allTokensIndex[tokenId];
1175         _allTokens.pop();
1176     }
1177 }
1178 
1179 // File: @openzeppelin/contracts/utils/Context.sol
1180 
1181 
1182 // File: @openzeppelin/contracts/access/Ownable.sol
1183 
1184 
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 
1189 /**
1190  * @dev Contract module which provides a basic access control mechanism, where
1191  * there is an account (an owner) that can be granted exclusive access to
1192  * specific functions.
1193  *
1194  * By default, the owner account will be the one that deploys the contract. This
1195  * can later be changed with {transferOwnership}.
1196  *
1197  * This module is used through inheritance. It will make available the modifier
1198  * `onlyOwner`, which can be applied to your functions to restrict their use to
1199  * the owner.
1200  */
1201 abstract contract Ownable is Context {
1202     address private _owner;
1203 
1204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1205 
1206     /**
1207      * @dev Initializes the contract setting the deployer as the initial owner.
1208      */
1209     constructor() {
1210         _setOwner(_msgSender());
1211     }
1212 
1213     /**
1214      * @dev Returns the address of the current owner.
1215      */
1216     function owner() public view virtual returns (address) {
1217         return _owner;
1218     }
1219 
1220     /**
1221      * @dev Throws if called by any account other than the owner.
1222      */
1223     modifier onlyOwner() {
1224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1225         _;
1226     }
1227 
1228     /**
1229      * @dev Leaves the contract without owner. It will not be possible to call
1230      * `onlyOwner` functions anymore. Can only be called by the current owner.
1231      *
1232      * NOTE: Renouncing ownership will leave the contract without an owner,
1233      * thereby removing any functionality that is only available to the owner.
1234      */
1235     function renounceOwnership() public virtual onlyOwner {
1236         _setOwner(address(0));
1237     }
1238 
1239     /**
1240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1241      * Can only be called by the current owner.
1242      */
1243     function transferOwnership(address newOwner) public virtual onlyOwner {
1244         require(newOwner != address(0), "Ownable: new owner is the zero address");
1245         _setOwner(newOwner);
1246     }
1247 
1248     function _setOwner(address newOwner) private {
1249         address oldOwner = _owner;
1250         _owner = newOwner;
1251         emit OwnershipTransferred(oldOwner, newOwner);
1252     }
1253 }
1254 
1255 // File: contracts/TDB.sol
1256 
1257 
1258 
1259 pragma solidity >=0.7.0 <0.9.0;
1260 
1261 
1262 
1263 contract NFT is ERC721Enumerable, Ownable {
1264   using Strings for uint256;
1265 
1266   string public baseURI;
1267   string public baseExtension = ".json";
1268   string public notRevealedUri;
1269   uint256 public cost = 0.069 ether;
1270   uint256 public maxSupply = 10000;
1271   uint256 public maxMintAmount = 20;
1272   uint256 public nftPerAddressLimit = 3;
1273   bool public paused = false;
1274   bool public revealed = false;
1275   bool public onlyWhitelisted = true;
1276   address[] public whitelistedAddresses;
1277   mapping(address => uint256) public addressMintedBalance;
1278 
1279   constructor(
1280     string memory _name,
1281     string memory _symbol,
1282     string memory _initBaseURI,
1283     string memory _initNotRevealedUri
1284   ) ERC721(_name, _symbol) {
1285     setBaseURI(_initBaseURI);
1286     setNotRevealedURI(_initNotRevealedUri);
1287   }
1288 
1289   // internal
1290   function _baseURI() internal view virtual override returns (string memory) {
1291     return baseURI;
1292   }
1293 
1294   // public
1295   function mint(uint256 _mintAmount) public payable {
1296     require(!paused, "The contract is paused");
1297     uint256 supply = totalSupply();
1298     require(_mintAmount > 0, "Need to mint at least 1 NFT");
1299     require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1300     require(supply + _mintAmount <= maxSupply, "Max NFT limit exceeded");
1301 
1302     if (msg.sender != owner()) {
1303         if(onlyWhitelisted == true) {
1304             require(isWhitelisted(msg.sender), "User is not whitelisted");
1305             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1306             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1307         }
1308         require(msg.value >= cost * _mintAmount, "Insufficient funds");
1309     }
1310 
1311     for (uint256 i = 1; i <= _mintAmount; i++) {
1312       addressMintedBalance[msg.sender]++;
1313       _safeMint(msg.sender, supply + i);
1314     }
1315   }
1316   
1317   function isWhitelisted(address _user) public view returns (bool) {
1318     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1319       if (whitelistedAddresses[i] == _user) {
1320           return true;
1321       }
1322     }
1323     return false;
1324   }
1325 
1326   function walletOfOwner(address _owner)
1327     public
1328     view
1329     returns (uint256[] memory)
1330   {
1331     uint256 ownerTokenCount = balanceOf(_owner);
1332     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1333     for (uint256 i; i < ownerTokenCount; i++) {
1334       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1335     }
1336     return tokenIds;
1337   }
1338 
1339   function tokenURI(uint256 tokenId)
1340     public
1341     view
1342     virtual
1343     override
1344     returns (string memory)
1345   {
1346     require(
1347       _exists(tokenId),
1348       "ERC721Metadata: URI query for nonexistent token"
1349     );
1350     
1351     if(revealed == false) {
1352         return notRevealedUri;
1353     }
1354 
1355     string memory currentBaseURI = _baseURI();
1356     return bytes(currentBaseURI).length > 0
1357         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1358         : "";
1359   }
1360 
1361   //only owner
1362   function reveal() public onlyOwner() {
1363       revealed = true;
1364   }
1365   
1366   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1367     nftPerAddressLimit = _limit;
1368   }
1369   
1370   function setCost(uint256 _newCost) public onlyOwner() {
1371     cost = _newCost;
1372   }
1373 
1374   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1375     maxMintAmount = _newmaxMintAmount;
1376   }
1377 
1378   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1379     baseURI = _newBaseURI;
1380   }
1381 
1382   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1383     baseExtension = _newBaseExtension;
1384   }
1385   
1386   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1387     notRevealedUri = _notRevealedURI;
1388   }
1389 
1390   function pause(bool _state) public onlyOwner {
1391     paused = _state;
1392   }
1393   
1394   function setOnlyWhitelisted(bool _state) public onlyOwner {
1395     onlyWhitelisted = _state;
1396   }
1397   
1398   function whitelistUsers(address[] calldata _users) public onlyOwner {
1399     delete whitelistedAddresses;
1400     whitelistedAddresses = _users;
1401   }
1402  
1403   function withdraw() public payable onlyOwner {
1404     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1405     require(success);
1406   }
1407 }