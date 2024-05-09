1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/Address.sol
97 
98 
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Collection of functions related to the address type
104  */
105 library Address {
106     /**
107      * @dev Returns true if `account` is a contract.
108      *
109      * [IMPORTANT]
110      * ====
111      * It is unsafe to assume that an address for which this function returns
112      * false is an externally-owned account (EOA) and not a contract.
113      *
114      * Among others, `isContract` will return false for the following
115      * types of addresses:
116      *
117      *  - an externally-owned account
118      *  - a contract in construction
119      *  - an address where a contract will be created
120      *  - an address where a contract lived, but was destroyed
121      * ====
122      */
123     function isContract(address account) internal view returns (bool) {
124         // This method relies on extcodesize, which returns 0 for contracts in
125         // construction, since the code is only stored at the end of the
126         // constructor execution.
127 
128         uint256 size;
129         assembly {
130             size := extcodesize(account)
131         }
132         return size > 0;
133     }
134 
135     /**
136      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
137      * `recipient`, forwarding all available gas and reverting on errors.
138      *
139      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
140      * of certain opcodes, possibly making contracts go over the 2300 gas limit
141      * imposed by `transfer`, making them unable to receive funds via
142      * `transfer`. {sendValue} removes this limitation.
143      *
144      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
145      *
146      * IMPORTANT: because control is transferred to `recipient`, care must be
147      * taken to not create reentrancy vulnerabilities. Consider using
148      * {ReentrancyGuard} or the
149      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
150      */
151     function sendValue(address payable recipient, uint256 amount) internal {
152         require(address(this).balance >= amount, "Address: insufficient balance");
153 
154         (bool success, ) = recipient.call{value: amount}("");
155         require(success, "Address: unable to send value, recipient may have reverted");
156     }
157 
158     /**
159      * @dev Performs a Solidity function call using a low level `call`. A
160      * plain `call` is an unsafe replacement for a function call: use this
161      * function instead.
162      *
163      * If `target` reverts with a revert reason, it is bubbled up by this
164      * function (like regular Solidity function calls).
165      *
166      * Returns the raw returned data. To convert to the expected return value,
167      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
168      *
169      * Requirements:
170      *
171      * - `target` must be a contract.
172      * - calling `target` with `data` must not revert.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionCall(target, data, "Address: low-level call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
182      * `errorMessage` as a fallback revert reason when `target` reverts.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, 0, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but also transferring `value` wei to `target`.
197      *
198      * Requirements:
199      *
200      * - the calling contract must have an ETH balance of at least `value`.
201      * - the called Solidity function must be `payable`.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value
209     ) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
215      * with `errorMessage` as a fallback revert reason when `target` reverts.
216      *
217      * _Available since v3.1._
218      */
219     function functionCallWithValue(
220         address target,
221         bytes memory data,
222         uint256 value,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         require(address(this).balance >= value, "Address: insufficient balance for call");
226         require(isContract(target), "Address: call to non-contract");
227 
228         (bool success, bytes memory returndata) = target.call{value: value}(data);
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
239         return functionStaticCall(target, data, "Address: low-level static call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal view returns (bytes memory) {
253         require(isContract(target), "Address: static call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.staticcall(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a delegate call.
272      *
273      * _Available since v3.4._
274      */
275     function functionDelegateCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(isContract(target), "Address: delegate call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.delegatecall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
288      * revert reason using the provided one.
289      *
290      * _Available since v4.3._
291      */
292     function verifyCallResult(
293         bool success,
294         bytes memory returndata,
295         string memory errorMessage
296     ) internal pure returns (bytes memory) {
297         if (success) {
298             return returndata;
299         } else {
300             // Look for revert reason and bubble it up if present
301             if (returndata.length > 0) {
302                 // The easiest way to bubble the revert reason is using memory via assembly
303 
304                 assembly {
305                     let returndata_size := mload(returndata)
306                     revert(add(32, returndata), returndata_size)
307                 }
308             } else {
309                 revert(errorMessage);
310             }
311         }
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
316 
317 
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Interface of the ERC165 standard, as defined in the
323  * https://eips.ethereum.org/EIPS/eip-165[EIP].
324  *
325  * Implementers can declare support of contract interfaces, which can then be
326  * queried by others ({ERC165Checker}).
327  *
328  * For an implementation, see {ERC165}.
329  */
330 interface IERC165 {
331     /**
332      * @dev Returns true if this contract implements the interface defined by
333      * `interfaceId`. See the corresponding
334      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
335      * to learn more about how these ids are created.
336      *
337      * This function call must use less than 30 000 gas.
338      */
339     function supportsInterface(bytes4 interfaceId) external view returns (bool);
340 }
341 
342 
343 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
344 
345 
346 
347 pragma solidity ^0.8.0;
348 
349 
350 /**
351  * @dev Implementation of the {IERC165} interface.
352  *
353  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
354  * for the additional interface id that will be supported. For example:
355  *
356  * ```solidity
357  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
358  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
359  * }
360  * ```
361  *
362  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
363  */
364 abstract contract ERC165 is IERC165 {
365     /**
366      * @dev See {IERC165-supportsInterface}.
367      */
368     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
369         return interfaceId == type(IERC165).interfaceId;
370     }
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
374 
375 
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Required interface of an ERC721 compliant contract.
382  */
383 interface IERC721 is IERC165 {
384     /**
385      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in ``owner``'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must exist and be owned by `from`.
422      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
424      *
425      * Emits a {Transfer} event.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Transfers `tokenId` token from `from` to `to`.
435      *
436      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
455      * The approval is cleared when the token is transferred.
456      *
457      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
458      *
459      * Requirements:
460      *
461      * - The caller must own the token or be an approved operator.
462      * - `tokenId` must exist.
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address to, uint256 tokenId) external;
467 
468     /**
469      * @dev Returns the account approved for `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function getApproved(uint256 tokenId) external view returns (address operator);
476 
477     /**
478      * @dev Approve or remove `operator` as an operator for the caller.
479      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
480      *
481      * Requirements:
482      *
483      * - The `operator` cannot be the caller.
484      *
485      * Emits an {ApprovalForAll} event.
486      */
487     function setApprovalForAll(address operator, bool _approved) external;
488 
489     /**
490      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
491      *
492      * See {setApprovalForAll}
493      */
494     function isApprovedForAll(address owner, address operator) external view returns (bool);
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId,
513         bytes calldata data
514     ) external;
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
518 
519 
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 interface IERC721Metadata is IERC721 {
529     /**
530      * @dev Returns the token collection name.
531      */
532     function name() external view returns (string memory);
533 
534     /**
535      * @dev Returns the token collection symbol.
536      */
537     function symbol() external view returns (string memory);
538 
539     /**
540      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
541      */
542     function tokenURI(uint256 tokenId) external view returns (string memory);
543 }
544 
545 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
546 
547 
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @title ERC721 token receiver interface
553  * @dev Interface for any contract that wants to support safeTransfers
554  * from ERC721 asset contracts.
555  */
556 interface IERC721Receiver {
557     /**
558      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
559      * by `operator` from `from`, this function is called.
560      *
561      * It must return its Solidity selector to confirm the token transfer.
562      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
563      *
564      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
565      */
566     function onERC721Received(
567         address operator,
568         address from,
569         uint256 tokenId,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 
575 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 
582 
583 
584 
585 
586 
587 
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension, but not including the Enumerable extension, which is available separately as
591  * {ERC721Enumerable}.
592  */
593 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
594     using Address for address;
595     using Strings for uint256;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to owner address
604     mapping(uint256 => address) private _owners;
605 
606     // Mapping owner address to token count
607     mapping(address => uint256) private _balances;
608 
609     // Mapping from token ID to approved address
610     mapping(uint256 => address) private _tokenApprovals;
611 
612     // Mapping from owner to operator approvals
613     mapping(address => mapping(address => bool)) private _operatorApprovals;
614 
615     /**
616      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
617      */
618     constructor(string memory name_, string memory symbol_) {
619         _name = name_;
620         _symbol = symbol_;
621     }
622 
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
627         return
628             interfaceId == type(IERC721).interfaceId ||
629             interfaceId == type(IERC721Metadata).interfaceId ||
630             super.supportsInterface(interfaceId);
631     }
632 
633     /**
634      * @dev See {IERC721-balanceOf}.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         require(owner != address(0), "ERC721: balance query for the zero address");
638         return _balances[owner];
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         address owner = _owners[tokenId];
646         require(owner != address(0), "ERC721: owner query for nonexistent token");
647         return owner;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-name}.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-symbol}.
659      */
660     function symbol() public view virtual override returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-tokenURI}.
666      */
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
669 
670         string memory baseURI = _baseURI();
671         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
672     }
673 
674     /**
675      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
676      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
677      * by default, can be overriden in child contracts.
678      */
679     function _baseURI() internal view virtual returns (string memory) {
680         return "";
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = ERC721.ownerOf(tokenId);
688         require(to != owner, "ERC721: approval to current owner");
689 
690         require(
691             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-getApproved}.
700      */
701     function getApproved(uint256 tokenId) public view virtual override returns (address) {
702         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved) public virtual override {
711         require(operator != _msgSender(), "ERC721: approve to caller");
712 
713         _operatorApprovals[_msgSender()][operator] = approved;
714         emit ApprovalForAll(_msgSender(), operator, approved);
715     }
716 
717     /**
718      * @dev See {IERC721-isApprovedForAll}.
719      */
720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
721         return _operatorApprovals[owner][operator];
722     }
723 
724     /**
725      * @dev See {IERC721-transferFrom}.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         //solhint-disable-next-line max-line-length
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734 
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759         _safeTransfer(from, to, tokenId, _data);
760     }
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
767      *
768      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
769      * implement alternative mechanisms to perform token transfer, such as signature-based.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeTransfer(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      * and stop existing when they are burned (`_burn`).
797      */
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return _owners[tokenId] != address(0);
800     }
801 
802     /**
803      * @dev Returns whether `spender` is allowed to manage `tokenId`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
810         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
811         address owner = ERC721.ownerOf(tokenId);
812         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
813     }
814 
815     /**
816      * @dev Safely mints `tokenId` and transfers it to `to`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(address to, uint256 tokenId) internal virtual {
826         _safeMint(to, tokenId, "");
827     }
828 
829     /**
830      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
831      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
832      */
833     function _safeMint(
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _mint(to, tokenId);
839         require(
840             _checkOnERC721Received(address(0), to, tokenId, _data),
841             "ERC721: transfer to non ERC721Receiver implementer"
842         );
843     }
844 
845     /**
846      * @dev Mints `tokenId` and transfers it to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - `to` cannot be the zero address.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(address to, uint256 tokenId) internal virtual {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _beforeTokenTransfer(address(0), to, tokenId);
862 
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(address(0), to, tokenId);
867     }
868 
869     /**
870      * @dev Destroys `tokenId`.
871      * The approval is cleared when the token is burned.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         address owner = ERC721.ownerOf(tokenId);
881 
882         _beforeTokenTransfer(owner, address(0), tokenId);
883 
884         // Clear approvals
885         _approve(address(0), tokenId);
886 
887         _balances[owner] -= 1;
888         delete _owners[tokenId];
889 
890         emit Transfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev Approve `to` to operate on `tokenId`
926      *
927      * Emits a {Approval} event.
928      */
929     function _approve(address to, uint256 tokenId) internal virtual {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
932     }
933 
934     /**
935      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
936      * The call is not executed if the target address is not a contract.
937      *
938      * @param from address representing the previous owner of the given token ID
939      * @param to target address that will receive the tokens
940      * @param tokenId uint256 ID of the token to be transferred
941      * @param _data bytes optional data to send along with the call
942      * @return bool whether the call correctly returned the expected magic value
943      */
944     function _checkOnERC721Received(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) private returns (bool) {
950         if (to.isContract()) {
951             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
952                 return retval == IERC721Receiver.onERC721Received.selector;
953             } catch (bytes memory reason) {
954                 if (reason.length == 0) {
955                     revert("ERC721: transfer to non ERC721Receiver implementer");
956                 } else {
957                     assembly {
958                         revert(add(32, reason), mload(reason))
959                     }
960                 }
961             }
962         } else {
963             return true;
964         }
965     }
966 
967     /**
968      * @dev Hook that is called before any token transfer. This includes minting
969      * and burning.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      * - When `to` is zero, ``from``'s `tokenId` will be burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _beforeTokenTransfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {}
986 }
987 
988 // File: TerraNullius.sol
989 
990 
991 
992 pragma solidity 0.8.1;
993 
994 
995 contract Terra {
996   struct Claim { address claimant; string message; uint block_number; }
997   Claim[] public claims;
998 
999   function claim(string memory message) public {
1000     claims.push(Claim(msg.sender, message, block.number));
1001   }
1002 
1003   function number_of_claims() public view returns(uint result) {
1004     return claims.length;
1005   }
1006 }
1007 
1008 contract TerraNullius is ERC721 {
1009   Terra terra = Terra(0x6e38A457C722C6011B2dfa06d49240e797844d66);
1010   uint256 _totalSupply;
1011   uint256 max = 4000;
1012     
1013   constructor() ERC721("Terra Nullius", "TerraNullius") {}
1014   
1015   function totalSupply() public view virtual returns (uint256) {
1016     return _totalSupply;
1017   }
1018   
1019   function _baseURI() internal view virtual override returns (string memory) {
1020     return "https://terranullius.vercel.app/";
1021   }
1022     
1023   function mint(string memory message) public {
1024     require(_totalSupply < max);
1025     terra.claim(message);
1026     uint256 tokenId = terra.number_of_claims() - 1;
1027     _mint(msg.sender, tokenId);
1028     _totalSupply += 1;
1029   }
1030   
1031   function wrap(uint256 tokenId) public {
1032     require(_totalSupply < max);
1033     (address claimant,,) = terra.claims(tokenId);
1034     require(claimant != address(0));
1035     _mint(claimant, tokenId);
1036     _totalSupply += 1;
1037   }
1038   
1039   function mintMany(string[] memory messages) public {
1040     for (uint256 i = 0; i < messages.length; i++) {
1041       mint(messages[i]);   
1042     }  
1043   }
1044 }