1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
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
70 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
96 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
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
315 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
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
344 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
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
371 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
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
401 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
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
545 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
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
573 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
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
986 // File: WooshiNFT.sol
987 
988 
989 //RMTPSH
990 pragma solidity ^0.8.0;
991 
992 
993 
994 
995 contract WooshiNFT is ERC721{
996     address minter;
997     string public baseTokenURI;
998     mapping(address => bool) public whitelist;
999 
1000     constructor ()
1001         ERC721("WOOSHI WORLD", "WOOSH")
1002         public
1003     {
1004         _transferOwnership(_msgSender());
1005         minter=msg.sender;
1006         whitelist[msg.sender]=true;
1007     }
1008     //calls
1009     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1010         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1011 
1012         return string(abi.encodePacked(baseTokenURI, uint2str(tokenId)));
1013         
1014         //return urilist[tokenId];
1015     }
1016     //admin
1017     function editWhitelist(address payable user, bool whitelisted) external{
1018         require(msg.sender==minter, "User is not minter");
1019         whitelist[user]=whitelisted;
1020     }
1021     function editMinter(address payable user) external{
1022         require(msg.sender==minter, "User is not minter");
1023         minter=user;
1024     }
1025     function setTokenURI(string memory _tokenURI) public virtual {
1026         require(whitelist[msg.sender]==true, "User is not whitelisted");
1027         baseTokenURI=_tokenURI;
1028     }
1029     function mint(uint tokenID, address user) external{
1030         require(whitelist[msg.sender]==true, "User is not whitelisted");
1031         _mint(user, tokenID);
1032     }
1033     
1034     //utils
1035      function uint2str(
1036       uint256 _i
1037     )
1038       internal
1039       pure
1040       returns (string memory str)
1041     {
1042         if (_i == 0)
1043         {
1044         return "0";
1045         }
1046         uint256 j = _i;
1047         uint256 length;
1048         while (j != 0)
1049         {
1050         length++;
1051         j /= 10;
1052         }
1053         bytes memory bstr = new bytes(length);
1054         uint256 k = length;
1055         j = _i;
1056         while (j != 0)
1057         {
1058         bstr[--k] = bytes1(uint8(48 + j % 10));
1059         j /= 10;
1060         }
1061         str = string(bstr);
1062     }
1063     
1064     address private _owner;
1065     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1066 
1067     /**
1068      * @dev Returns the address of the current owner.
1069      */
1070     function owner() public view virtual returns (address) {
1071         return _owner;
1072     }
1073 
1074     /**
1075      * @dev Throws if called by any account other than the owner.
1076      */
1077     modifier onlyOwner() {
1078         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1079         _;
1080     }
1081 
1082     /**
1083      * @dev Leaves the contract without owner. It will not be possible to call
1084      * `onlyOwner` functions anymore. Can only be called by the current owner.
1085      *
1086      * NOTE: Renouncing ownership will leave the contract without an owner,
1087      * thereby removing any functionality that is only available to the owner.
1088      */
1089     function renounceOwnership() public virtual onlyOwner {
1090         _transferOwnership(address(0));
1091     }
1092 
1093     /**
1094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1095      * Can only be called by the current owner.
1096      */
1097     function transferOwnership(address newOwner) public virtual onlyOwner {
1098         require(newOwner != address(0), "Ownable: new owner is the zero address");
1099         _transferOwnership(newOwner);
1100     }
1101 
1102     /**
1103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1104      * Internal function without access restriction.
1105      */
1106     function _transferOwnership(address newOwner) internal virtual {
1107         address oldOwner = _owner;
1108         _owner = newOwner;
1109         emit OwnershipTransferred(oldOwner, newOwner);
1110     }
1111 }