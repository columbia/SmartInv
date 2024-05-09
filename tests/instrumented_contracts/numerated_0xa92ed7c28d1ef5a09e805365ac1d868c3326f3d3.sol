1 // File: node_modules/@openzeppelin/contracts/utils/Strings.sol
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
70 // File: node_modules/@openzeppelin/contracts/utils/Context.sol
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
96 // File: node_modules/@openzeppelin/contracts/utils/Address.sol
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
315 // File: node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
316 
317 
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @title ERC721 token receiver interface
323  * @dev Interface for any contract that wants to support safeTransfers
324  * from ERC721 asset contracts.
325  */
326 interface IERC721Receiver {
327     /**
328      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
329      * by `operator` from `from`, this function is called.
330      *
331      * It must return its Solidity selector to confirm the token transfer.
332      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
333      *
334      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
335      */
336     function onERC721Received(
337         address operator,
338         address from,
339         uint256 tokenId,
340         bytes calldata data
341     ) external returns (bytes4);
342 }
343 
344 // File: node_modules/@openzeppelin/contracts/utils/introspection/IERC165.sol
345 
346 
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Interface of the ERC165 standard, as defined in the
352  * https://eips.ethereum.org/EIPS/eip-165[EIP].
353  *
354  * Implementers can declare support of contract interfaces, which can then be
355  * queried by others ({ERC165Checker}).
356  *
357  * For an implementation, see {ERC165}.
358  */
359 interface IERC165 {
360     /**
361      * @dev Returns true if this contract implements the interface defined by
362      * `interfaceId`. See the corresponding
363      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
364      * to learn more about how these ids are created.
365      *
366      * This function call must use less than 30 000 gas.
367      */
368     function supportsInterface(bytes4 interfaceId) external view returns (bool);
369 }
370 
371 // File: node_modules/@openzeppelin/contracts/utils/introspection/ERC165.sol
372 
373 
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Implementation of the {IERC165} interface.
380  *
381  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
382  * for the additional interface id that will be supported. For example:
383  *
384  * ```solidity
385  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
386  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
387  * }
388  * ```
389  *
390  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
391  */
392 abstract contract ERC165 is IERC165 {
393     /**
394      * @dev See {IERC165-supportsInterface}.
395      */
396     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
397         return interfaceId == type(IERC165).interfaceId;
398     }
399 }
400 
401 // File: node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol
402 
403 
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev Required interface of an ERC721 compliant contract.
410  */
411 interface IERC721 is IERC165 {
412     /**
413      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
414      */
415     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
416 
417     /**
418      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
419      */
420     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
421 
422     /**
423      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
424      */
425     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
426 
427     /**
428      * @dev Returns the number of tokens in ``owner``'s account.
429      */
430     function balanceOf(address owner) external view returns (uint256 balance);
431 
432     /**
433      * @dev Returns the owner of the `tokenId` token.
434      *
435      * Requirements:
436      *
437      * - `tokenId` must exist.
438      */
439     function ownerOf(uint256 tokenId) external view returns (address owner);
440 
441     /**
442      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
443      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must exist and be owned by `from`.
450      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
451      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
452      *
453      * Emits a {Transfer} event.
454      */
455     function safeTransferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Transfers `tokenId` token from `from` to `to`.
463      *
464      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must be owned by `from`.
471      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
472      *
473      * Emits a {Transfer} event.
474      */
475     function transferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) external;
480 
481     /**
482      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
483      * The approval is cleared when the token is transferred.
484      *
485      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
486      *
487      * Requirements:
488      *
489      * - The caller must own the token or be an approved operator.
490      * - `tokenId` must exist.
491      *
492      * Emits an {Approval} event.
493      */
494     function approve(address to, uint256 tokenId) external;
495 
496     /**
497      * @dev Returns the account approved for `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function getApproved(uint256 tokenId) external view returns (address operator);
504 
505     /**
506      * @dev Approve or remove `operator` as an operator for the caller.
507      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
508      *
509      * Requirements:
510      *
511      * - The `operator` cannot be the caller.
512      *
513      * Emits an {ApprovalForAll} event.
514      */
515     function setApprovalForAll(address operator, bool _approved) external;
516 
517     /**
518      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
519      *
520      * See {setApprovalForAll}
521      */
522     function isApprovedForAll(address owner, address operator) external view returns (bool);
523 
524     /**
525      * @dev Safely transfers `tokenId` token from `from` to `to`.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must exist and be owned by `from`.
532      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
533      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
534      *
535      * Emits a {Transfer} event.
536      */
537     function safeTransferFrom(
538         address from,
539         address to,
540         uint256 tokenId,
541         bytes calldata data
542     ) external;
543 }
544 
545 // File: node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
546 
547 
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
554  * @dev See https://eips.ethereum.org/EIPS/eip-721
555  */
556 interface IERC721Metadata is IERC721 {
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() external view returns (string memory);
561 
562     /**
563      * @dev Returns the token collection symbol.
564      */
565     function symbol() external view returns (string memory);
566 
567     /**
568      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
569      */
570     function tokenURI(uint256 tokenId) external view returns (string memory);
571 }
572 
573 // File: node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol
574 
575 
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 
582 
583 
584 
585 
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         require(operator != _msgSender(), "ERC721: approve to caller");
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         //solhint-disable-next-line max-line-length
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732 
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, "");
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _transfer(from, to, tokenId);
785         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      * and stop existing when they are burned (`_burn`).
795      */
796     function _exists(uint256 tokenId) internal view virtual returns (bool) {
797         return _owners[tokenId] != address(0);
798     }
799 
800     /**
801      * @dev Returns whether `spender` is allowed to manage `tokenId`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
808         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
809         address owner = ERC721.ownerOf(tokenId);
810         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
811     }
812 
813     /**
814      * @dev Safely mints `tokenId` and transfers it to `to`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(address to, uint256 tokenId) internal virtual {
824         _safeMint(to, tokenId, "");
825     }
826 
827     /**
828      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
829      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
830      */
831     function _safeMint(
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _mint(to, tokenId);
837         require(
838             _checkOnERC721Received(address(0), to, tokenId, _data),
839             "ERC721: transfer to non ERC721Receiver implementer"
840         );
841     }
842 
843     /**
844      * @dev Mints `tokenId` and transfers it to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - `to` cannot be the zero address.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 tokenId) internal virtual {
856         require(to != address(0), "ERC721: mint to the zero address");
857         require(!_exists(tokenId), "ERC721: token already minted");
858 
859         _beforeTokenTransfer(address(0), to, tokenId);
860 
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889     }
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _transfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {
907         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
908         require(to != address(0), "ERC721: transfer to the zero address");
909 
910         _beforeTokenTransfer(from, to, tokenId);
911 
912         // Clear approvals from the previous owner
913         _approve(address(0), tokenId);
914 
915         _balances[from] -= 1;
916         _balances[to] += 1;
917         _owners[tokenId] = to;
918 
919         emit Transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev Approve `to` to operate on `tokenId`
924      *
925      * Emits a {Approval} event.
926      */
927     function _approve(address to, uint256 tokenId) internal virtual {
928         _tokenApprovals[tokenId] = to;
929         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
930     }
931 
932     /**
933      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
934      * The call is not executed if the target address is not a contract.
935      *
936      * @param from address representing the previous owner of the given token ID
937      * @param to target address that will receive the tokens
938      * @param tokenId uint256 ID of the token to be transferred
939      * @param _data bytes optional data to send along with the call
940      * @return bool whether the call correctly returned the expected magic value
941      */
942     function _checkOnERC721Received(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) private returns (bool) {
948         if (to.isContract()) {
949             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
950                 return retval == IERC721Receiver.onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0) {
953                     revert("ERC721: transfer to non ERC721Receiver implementer");
954                 } else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before any token transfer. This includes minting
967      * and burning.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, ``from``'s `tokenId` will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {}
984 }
985 
986 // File: node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol
987 
988 
989 
990 pragma solidity ^0.8.0;
991 
992 // CAUTION
993 // This version of SafeMath should only be used with Solidity 0.8 or later,
994 // because it relies on the compiler's built in overflow checks.
995 
996 /**
997  * @dev Wrappers over Solidity's arithmetic operations.
998  *
999  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1000  * now has built in overflow checking.
1001  */
1002 library SafeMath {
1003     /**
1004      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1005      *
1006      * _Available since v3.4._
1007      */
1008     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1009         unchecked {
1010             uint256 c = a + b;
1011             if (c < a) return (false, 0);
1012             return (true, c);
1013         }
1014     }
1015 
1016     /**
1017      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1018      *
1019      * _Available since v3.4._
1020      */
1021     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1022         unchecked {
1023             if (b > a) return (false, 0);
1024             return (true, a - b);
1025         }
1026     }
1027 
1028     /**
1029      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1030      *
1031      * _Available since v3.4._
1032      */
1033     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1034         unchecked {
1035             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1036             // benefit is lost if 'b' is also tested.
1037             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1038             if (a == 0) return (true, 0);
1039             uint256 c = a * b;
1040             if (c / a != b) return (false, 0);
1041             return (true, c);
1042         }
1043     }
1044 
1045     /**
1046      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1047      *
1048      * _Available since v3.4._
1049      */
1050     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1051         unchecked {
1052             if (b == 0) return (false, 0);
1053             return (true, a / b);
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1059      *
1060      * _Available since v3.4._
1061      */
1062     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1063         unchecked {
1064             if (b == 0) return (false, 0);
1065             return (true, a % b);
1066         }
1067     }
1068 
1069     /**
1070      * @dev Returns the addition of two unsigned integers, reverting on
1071      * overflow.
1072      *
1073      * Counterpart to Solidity's `+` operator.
1074      *
1075      * Requirements:
1076      *
1077      * - Addition cannot overflow.
1078      */
1079     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1080         return a + b;
1081     }
1082 
1083     /**
1084      * @dev Returns the subtraction of two unsigned integers, reverting on
1085      * overflow (when the result is negative).
1086      *
1087      * Counterpart to Solidity's `-` operator.
1088      *
1089      * Requirements:
1090      *
1091      * - Subtraction cannot overflow.
1092      */
1093     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1094         return a - b;
1095     }
1096 
1097     /**
1098      * @dev Returns the multiplication of two unsigned integers, reverting on
1099      * overflow.
1100      *
1101      * Counterpart to Solidity's `*` operator.
1102      *
1103      * Requirements:
1104      *
1105      * - Multiplication cannot overflow.
1106      */
1107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1108         return a * b;
1109     }
1110 
1111     /**
1112      * @dev Returns the integer division of two unsigned integers, reverting on
1113      * division by zero. The result is rounded towards zero.
1114      *
1115      * Counterpart to Solidity's `/` operator.
1116      *
1117      * Requirements:
1118      *
1119      * - The divisor cannot be zero.
1120      */
1121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1122         return a / b;
1123     }
1124 
1125     /**
1126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1127      * reverting when dividing by zero.
1128      *
1129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1130      * opcode (which leaves remaining gas untouched) while Solidity uses an
1131      * invalid opcode to revert (consuming all remaining gas).
1132      *
1133      * Requirements:
1134      *
1135      * - The divisor cannot be zero.
1136      */
1137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1138         return a % b;
1139     }
1140 
1141     /**
1142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1143      * overflow (when the result is negative).
1144      *
1145      * CAUTION: This function is deprecated because it requires allocating memory for the error
1146      * message unnecessarily. For custom revert reasons use {trySub}.
1147      *
1148      * Counterpart to Solidity's `-` operator.
1149      *
1150      * Requirements:
1151      *
1152      * - Subtraction cannot overflow.
1153      */
1154     function sub(
1155         uint256 a,
1156         uint256 b,
1157         string memory errorMessage
1158     ) internal pure returns (uint256) {
1159         unchecked {
1160             require(b <= a, errorMessage);
1161             return a - b;
1162         }
1163     }
1164 
1165     /**
1166      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1167      * division by zero. The result is rounded towards zero.
1168      *
1169      * Counterpart to Solidity's `/` operator. Note: this function uses a
1170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1171      * uses an invalid opcode to revert (consuming all remaining gas).
1172      *
1173      * Requirements:
1174      *
1175      * - The divisor cannot be zero.
1176      */
1177     function div(
1178         uint256 a,
1179         uint256 b,
1180         string memory errorMessage
1181     ) internal pure returns (uint256) {
1182         unchecked {
1183             require(b > 0, errorMessage);
1184             return a / b;
1185         }
1186     }
1187 
1188     /**
1189      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1190      * reverting with custom message when dividing by zero.
1191      *
1192      * CAUTION: This function is deprecated because it requires allocating memory for the error
1193      * message unnecessarily. For custom revert reasons use {tryMod}.
1194      *
1195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1196      * opcode (which leaves remaining gas untouched) while Solidity uses an
1197      * invalid opcode to revert (consuming all remaining gas).
1198      *
1199      * Requirements:
1200      *
1201      * - The divisor cannot be zero.
1202      */
1203     function mod(
1204         uint256 a,
1205         uint256 b,
1206         string memory errorMessage
1207     ) internal pure returns (uint256) {
1208         unchecked {
1209             require(b > 0, errorMessage);
1210             return a % b;
1211         }
1212     }
1213 }
1214 
1215 // File: contracts/TokenContract.sol
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 
1220 
1221 contract ForeverRugs is ERC721 {
1222     using SafeMath for uint256;
1223 
1224     event Mint(
1225         address indexed _to,
1226         uint256 _tokenId,
1227         uint256 indexed _projectId,
1228         string params
1229     );
1230 
1231     struct Project {
1232         string name;
1233         string artist;
1234         string description;
1235         string website;
1236         string projectBaseURI;
1237         string projectBaseIpfsURI;
1238         uint256 invocations;
1239         uint256 maxInvocations;
1240         bool useIpfs;
1241         bool active;
1242         bool locked;
1243         mapping(string => bool) seenNonces;
1244     }
1245 
1246     mapping(uint256 => Project) projects;
1247     mapping(uint256 => uint256) public projectIdToPricePerTokenInWei;
1248     mapping(uint256 => uint256) public tokenIdToProjectId;
1249     mapping(uint256 => uint256[]) internal projectIdToTokenIds;
1250     mapping(address => bool) public isAdmin;
1251 
1252     uint256 constant ONE_MILLION = 1_000_000;
1253     uint256 public nextProjectId = 0;
1254     address public owner;
1255     address public verifier;
1256 
1257     modifier onlyValidTokenId(uint256 _tokenId) {
1258         require(_exists(_tokenId), "Token ID does not exist");
1259         _;
1260     }
1261 
1262     modifier onlyUnlocked(uint256 _projectId) {
1263         require(!projects[_projectId].locked, "Only if unlocked");
1264         _;
1265     }
1266 
1267     modifier onlyAdmin() {
1268         require(isAdmin[msg.sender], "Only admin");
1269         _;
1270     }
1271 
1272     modifier onlyOwner() {
1273         require(msg.sender == owner, "Only owner");
1274         _;
1275     }
1276 
1277     constructor(string memory _tokenName, string memory _tokenSymbol, address _verifier) ERC721(_tokenName, _tokenSymbol) payable {
1278         owner = msg.sender;
1279         isAdmin[msg.sender] = true;
1280         verifier = _verifier;
1281     }
1282 
1283     function contractURI() public view returns (string memory) {
1284         return "https://d3q9esgymjsewz.cloudfront.net/foreverrugs.json";
1285     }
1286 
1287     function mint(address _to, uint256 _projectId, bytes memory signedParams, string memory params, string memory nonce) external payable returns (uint256 _tokenId) {
1288         require(projects[_projectId].active || isAdmin[msg.sender], "Project not enabled.");
1289 
1290         require(projects[_projectId].invocations.add(1) <= projects[_projectId].maxInvocations, "Must not exceed max invocations");
1291         require(msg.value >= projectIdToPricePerTokenInWei[_projectId], "Not enough ether.");
1292 
1293         require(!projects[_projectId].seenNonces[nonce]);
1294         require(isSignedMint(signedParams, params, nonce), "Invalid signature.");
1295 
1296         projects[_projectId].seenNonces[nonce] = true;
1297 
1298         uint256 tokenId = _mintToken(_to, _projectId, params);
1299         return tokenId;
1300     }
1301 
1302     function _mintToken(address _to, uint256 _projectId, string memory params) internal returns (uint256 _tokenId) {
1303         uint256 tokenIdToBe;
1304         if (_projectId == 0) {
1305             tokenIdToBe = _projectId + projects[_projectId].invocations;
1306         } 
1307         else {
1308             tokenIdToBe = (_projectId * ONE_MILLION) + projects[_projectId].invocations;
1309         }
1310         
1311         projects[_projectId].invocations = projects[_projectId].invocations.add(1);
1312 
1313         _mint(_to, tokenIdToBe);
1314 
1315         tokenIdToProjectId[tokenIdToBe] = _projectId;
1316         projectIdToTokenIds[_projectId].push(tokenIdToBe);
1317     
1318         emit Mint(_to, tokenIdToBe, _projectId, params);
1319 
1320         return tokenIdToBe;
1321     }
1322 
1323     function isSignedMint(bytes memory signedParams, string memory params, string memory nonce) internal view returns (bool) {
1324         // recreate the message hash that was signed on the client
1325         bytes32 hash = keccak256(abi.encodePacked(params, nonce));
1326         bytes32 messageHash = toEthSignedMessageHash(hash);
1327 
1328         address signer = verify(messageHash, signedParams);
1329         return signer == verifier;
1330     }
1331 
1332     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1333         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1334     }
1335 
1336     function setVerifier(address _verifier) external onlyOwner {
1337         verifier = _verifier;
1338     }
1339 
1340     function addAdmin(address _address) public onlyOwner {
1341         isAdmin[_address] = true;
1342     }
1343 
1344     function toggleProjectIsLocked(uint256 _projectId) public onlyAdmin onlyUnlocked(_projectId) {
1345         projects[_projectId].locked = true;
1346     }
1347 
1348     function toggleProjectIsActive(uint256 _projectId) public onlyAdmin {
1349         projects[_projectId].active = !projects[_projectId].active;
1350     }
1351 
1352     function toggleProjectUseIpfs(uint256 _projectId) public onlyAdmin onlyUnlocked(_projectId) {
1353         projects[_projectId].useIpfs = !projects[_projectId].useIpfs;
1354     }
1355 
1356     function addProject(string memory _projectName, uint256 _pricePerTokenInWei, uint256 maxInvocations) public onlyAdmin {
1357         uint256 projectId = nextProjectId;
1358         projects[projectId].name = _projectName;
1359         projectIdToPricePerTokenInWei[projectId] = _pricePerTokenInWei;
1360         projects[projectId].maxInvocations = maxInvocations;
1361         projects[projectId].active = false;
1362         projects[projectId].useIpfs = false;
1363         nextProjectId = nextProjectId.add(1);
1364     }
1365 
1366     function updateProjectPricePerTokenInWei(uint256 _projectId, uint256 _pricePerTokenInWei) onlyAdmin public {
1367         projectIdToPricePerTokenInWei[_projectId] = _pricePerTokenInWei;
1368     }
1369 
1370     function updateProjectName(uint256 _projectId, string memory _projectName) onlyUnlocked(_projectId) onlyAdmin public {
1371         projects[_projectId].name = _projectName;
1372     }
1373 
1374     function updateProjectArtistName(uint256 _projectId, string memory _projectArtistName) onlyUnlocked(_projectId) onlyAdmin public {
1375         projects[_projectId].artist = _projectArtistName;
1376     }
1377 
1378     function updateProjectDescription(uint256 _projectId, string memory _projectDescription) onlyAdmin public {
1379         projects[_projectId].description = _projectDescription;
1380     }
1381 
1382     function updateProjectWebsite(uint256 _projectId, string memory _projectWebsite) onlyAdmin public {
1383         projects[_projectId].website = _projectWebsite;
1384     }
1385 
1386     function updateProjectMaxInvocations(uint256 _projectId, uint256 _maxInvocations) onlyUnlocked(_projectId) onlyAdmin public {
1387         require(_maxInvocations < projects[_projectId].maxInvocations, "Max invocations can not be increased, only decreased.");
1388         require(_maxInvocations > projects[_projectId].invocations, "You must set max invocations greater than current invocations");
1389         require(_maxInvocations <= ONE_MILLION, "Cannot exceed 1,000,000");
1390         projects[_projectId].maxInvocations = _maxInvocations;
1391     }
1392 
1393     function updateProjectBaseURI(uint256 _projectId, string memory _newBaseURI) onlyUnlocked(_projectId) onlyAdmin public {
1394         projects[_projectId].projectBaseURI = _newBaseURI;
1395     }
1396 
1397     function updateProjectBaseIpfsURI(uint256 _projectId, string memory _projectBaseIpfsURI) onlyUnlocked(_projectId) onlyAdmin public {
1398         projects[_projectId].projectBaseIpfsURI = _projectBaseIpfsURI;
1399     }
1400 
1401     function projectDetails(uint256 _projectId) view public returns (string memory projectName, string memory artist, string memory description, string memory website) {
1402         projectName = projects[_projectId].name;
1403         artist = projects[_projectId].artist;
1404         description = projects[_projectId].description;
1405         website = projects[_projectId].website;
1406     }
1407 
1408     function projectTokenInfo(uint256 _projectId) view public returns (uint256 pricePerTokenInWei, uint256 invocations, uint256 maxInvocations, bool active) {
1409         pricePerTokenInWei = projectIdToPricePerTokenInWei[_projectId];
1410         invocations = projects[_projectId].invocations;
1411         maxInvocations = projects[_projectId].maxInvocations;
1412         active = projects[_projectId].active;
1413     }
1414 
1415     function projectURIInfo(uint256 _projectId) view public returns (string memory projectBaseURI, string memory projectBaseIpfsURI, bool useIpfs) {
1416         projectBaseURI = projects[_projectId].projectBaseURI;
1417         projectBaseIpfsURI = projects[_projectId].projectBaseIpfsURI;
1418         useIpfs = projects[_projectId].useIpfs;
1419     }
1420 
1421     function projectShowAllTokens(uint _projectId) public view returns (uint256[] memory){
1422         return projectIdToTokenIds[_projectId];
1423     }
1424 
1425     function append(string memory a, string memory b) internal pure returns (string memory) {
1426         return string(abi.encodePacked(a, b));
1427     }
1428 
1429     function uintToString(uint v) internal pure returns (string memory str) {
1430         uint maxlength = 100;
1431         bytes memory reversed = new bytes(maxlength);
1432         uint i = 0;
1433 
1434         if (v == 0) {
1435             return '0';
1436         }
1437 
1438         while (v != 0) {
1439             uint remainder = v % 10;
1440             v = v / 10;
1441             reversed[i++] = bytes1(uint8(48 + remainder));
1442         }
1443         bytes memory s = new bytes(i + 1);
1444         for (uint j = 0; j <= i; j++) {
1445             s[j] = reversed[i - j];
1446         }
1447         str = string(s);
1448     }
1449 
1450     function tokenURI(uint256 _tokenId) public view override(ERC721) onlyValidTokenId(_tokenId) returns (string memory) {
1451         if (projects[tokenIdToProjectId[_tokenId]].useIpfs)
1452         {
1453             string memory st = append(projects[tokenIdToProjectId[_tokenId]].projectBaseIpfsURI, uintToString(_tokenId));
1454             return append(st, ".json");
1455         }
1456 
1457         string memory s = append(projects[tokenIdToProjectId[_tokenId]].projectBaseURI, uintToString(_tokenId));
1458 
1459         return append(s, ".json");
1460     }
1461 
1462     function withdraw(uint256 amount) public onlyOwner {
1463         uint256 balance = address(this).balance;
1464         require(amount <= balance);
1465         payable(owner).transfer(amount);
1466     }
1467 
1468     function splitSignature(bytes memory sig)
1469         public
1470         pure
1471         returns (
1472             bytes32 r,
1473             bytes32 s,
1474             uint8 v
1475         )
1476     {
1477         require(sig.length == 65, "invalid signature length");
1478 
1479         assembly {
1480             /*
1481             First 32 bytes stores the length of the signature
1482 
1483             add(sig, 32) = pointer of sig + 32
1484             effectively, skips first 32 bytes of signature
1485 
1486             mload(p) loads next 32 bytes starting at the memory address p into memory
1487             */
1488 
1489             // first 32 bytes, after the length prefix
1490             r := mload(add(sig, 32))
1491             // second 32 bytes
1492             s := mload(add(sig, 64))
1493             // final byte (first byte of the next 32 bytes)
1494             v := byte(0, mload(add(sig, 96)))
1495         }
1496 
1497         // implicitly return (r, s, v)
1498     }
1499 
1500     // verifies that the verifier is the signer of the message
1501     function verify(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
1502         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1503         return ecrecover(_ethSignedMessageHash, v, r, s);
1504     }
1505 }