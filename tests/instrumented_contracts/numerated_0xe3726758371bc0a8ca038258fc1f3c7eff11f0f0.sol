1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
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
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 
198 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
199 
200 
201 pragma solidity ^0.8.0;
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209     /**
210      * @dev Returns the token collection name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token collection symbol.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
221      */
222     function tokenURI(uint256 tokenId) external view returns (string memory);
223 }
224 
225 // File: @openzeppelin/contracts/utils/Address.sol
226 
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/Context.sol
444 
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Provides information about the current execution context, including the
450  * sender of the transaction and its data. While these are generally available
451  * via msg.sender and msg.data, they should not be accessed in such a direct
452  * manner, since when dealing with meta-transactions the account sending and
453  * paying for execution may not be the actual sender (as far as an application
454  * is concerned).
455  *
456  * This contract is only required for intermediate, library-like contracts.
457  */
458 abstract contract Context {
459     function _msgSender() internal view virtual returns (address) {
460         return msg.sender;
461     }
462 
463     function _msgData() internal view virtual returns (bytes calldata) {
464         return msg.data;
465     }
466 }
467 
468 // File: @openzeppelin/contracts/utils/Strings.sol
469 
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev String operations.
475  */
476 library Strings {
477     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
478 
479     /**
480      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
481      */
482     function toString(uint256 value) internal pure returns (string memory) {
483         // Inspired by OraclizeAPI's implementation - MIT licence
484         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
485 
486         if (value == 0) {
487             return "0";
488         }
489         uint256 temp = value;
490         uint256 digits;
491         while (temp != 0) {
492             digits++;
493             temp /= 10;
494         }
495         bytes memory buffer = new bytes(digits);
496         while (value != 0) {
497             digits -= 1;
498             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
499             value /= 10;
500         }
501         return string(buffer);
502     }
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
506      */
507     function toHexString(uint256 value) internal pure returns (string memory) {
508         if (value == 0) {
509             return "0x00";
510         }
511         uint256 temp = value;
512         uint256 length = 0;
513         while (temp != 0) {
514             length++;
515             temp >>= 8;
516         }
517         return toHexString(value, length);
518     }
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
522      */
523     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
524         bytes memory buffer = new bytes(2 * length + 2);
525         buffer[0] = "0";
526         buffer[1] = "x";
527         for (uint256 i = 2 * length + 1; i > 1; --i) {
528             buffer[i] = _HEX_SYMBOLS[value & 0xf];
529             value >>= 4;
530         }
531         require(value == 0, "Strings: hex length insufficient");
532         return string(buffer);
533     }
534 }
535 
536 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Implementation of the {IERC165} interface.
544  *
545  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
546  * for the additional interface id that will be supported. For example:
547  *
548  * ```solidity
549  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
551  * }
552  * ```
553  *
554  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
555  */
556 abstract contract ERC165 is IERC165 {
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561         return interfaceId == type(IERC165).interfaceId;
562     }
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
566 
567 
568 pragma solidity ^0.8.0;
569 
570 
571 
572 
573 
574 
575 
576 
577 /**
578  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
579  * the Metadata extension, but not including the Enumerable extension, which is available separately as
580  * {ERC721Enumerable}.
581  */
582 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
583     using Address for address;
584     using Strings for uint256;
585 
586     // Token name
587     string private _name;
588 
589     // Token symbol
590     string private _symbol;
591 
592     // Mapping from token ID to owner address
593     mapping(uint256 => address) private _owners;
594 
595     // Mapping owner address to token count
596     mapping(address => uint256) private _balances;
597 
598     // Mapping from token ID to approved address
599     mapping(uint256 => address) private _tokenApprovals;
600 
601     // Mapping from owner to operator approvals
602     mapping(address => mapping(address => bool)) private _operatorApprovals;
603 
604     /**
605      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
606      */
607     constructor(string memory name_, string memory symbol_) {
608         _name = name_;
609         _symbol = symbol_;
610     }
611 
612     /**
613      * @dev See {IERC165-supportsInterface}.
614      */
615     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
616         return
617             interfaceId == type(IERC721).interfaceId ||
618             interfaceId == type(IERC721Metadata).interfaceId ||
619             super.supportsInterface(interfaceId);
620     }
621 
622     /**
623      * @dev See {IERC721-balanceOf}.
624      */
625     function balanceOf(address owner) public view virtual override returns (uint256) {
626         require(owner != address(0), "ERC721: balance query for the zero address");
627         return _balances[owner];
628     }
629 
630     /**
631      * @dev See {IERC721-ownerOf}.
632      */
633     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
634         address owner = _owners[tokenId];
635         require(owner != address(0), "ERC721: owner query for nonexistent token");
636         return owner;
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-name}.
641      */
642     function name() public view virtual override returns (string memory) {
643         return _name;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-symbol}.
648      */
649     function symbol() public view virtual override returns (string memory) {
650         return _symbol;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-tokenURI}.
655      */
656     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
657         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
658 
659         string memory baseURI = _baseURI();
660         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
661     }
662 
663     /**
664      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
665      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
666      * by default, can be overriden in child contracts.
667      */
668     function _baseURI() internal view virtual returns (string memory) {
669         return "";
670     }
671 
672     /**
673      * @dev See {IERC721-approve}.
674      */
675     function approve(address to, uint256 tokenId) public virtual override {
676         address owner = ERC721.ownerOf(tokenId);
677         require(to != owner, "ERC721: approval to current owner");
678 
679         require(
680             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
681             "ERC721: approve caller is not owner nor approved for all"
682         );
683 
684         _approve(to, tokenId);
685     }
686 
687     /**
688      * @dev See {IERC721-getApproved}.
689      */
690     function getApproved(uint256 tokenId) public view virtual override returns (address) {
691         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
692 
693         return _tokenApprovals[tokenId];
694     }
695 
696     /**
697      * @dev See {IERC721-setApprovalForAll}.
698      */
699     function setApprovalForAll(address operator, bool approved) public virtual override {
700         require(operator != _msgSender(), "ERC721: approve to caller");
701 
702         _operatorApprovals[_msgSender()][operator] = approved;
703         emit ApprovalForAll(_msgSender(), operator, approved);
704     }
705 
706     /**
707      * @dev See {IERC721-isApprovedForAll}.
708      */
709     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
710         return _operatorApprovals[owner][operator];
711     }
712 
713     /**
714      * @dev See {IERC721-transferFrom}.
715      */
716     function transferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) public virtual override {
721         //solhint-disable-next-line max-line-length
722         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
723 
724         _transfer(from, to, tokenId);
725     }
726 
727     /**
728      * @dev See {IERC721-safeTransferFrom}.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public virtual override {
735         safeTransferFrom(from, to, tokenId, "");
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId,
745         bytes memory _data
746     ) public virtual override {
747         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
748         _safeTransfer(from, to, tokenId, _data);
749     }
750 
751     /**
752      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
753      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
754      *
755      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
756      *
757      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
758      * implement alternative mechanisms to perform token transfer, such as signature-based.
759      *
760      * Requirements:
761      *
762      * - `from` cannot be the zero address.
763      * - `to` cannot be the zero address.
764      * - `tokenId` token must exist and be owned by `from`.
765      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _safeTransfer(
770         address from,
771         address to,
772         uint256 tokenId,
773         bytes memory _data
774     ) internal virtual {
775         _transfer(from, to, tokenId);
776         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
777     }
778 
779     /**
780      * @dev Returns whether `tokenId` exists.
781      *
782      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
783      *
784      * Tokens start existing when they are minted (`_mint`),
785      * and stop existing when they are burned (`_burn`).
786      */
787     function _exists(uint256 tokenId) internal view virtual returns (bool) {
788         return _owners[tokenId] != address(0);
789     }
790 
791     /**
792      * @dev Returns whether `spender` is allowed to manage `tokenId`.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must exist.
797      */
798     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
799         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
800         address owner = ERC721.ownerOf(tokenId);
801         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
802     }
803 
804     /**
805      * @dev Safely mints `tokenId` and transfers it to `to`.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must not exist.
810      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _safeMint(address to, uint256 tokenId) internal virtual {
815         _safeMint(to, tokenId, "");
816     }
817 
818     /**
819      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
820      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
821      */
822     function _safeMint(
823         address to,
824         uint256 tokenId,
825         bytes memory _data
826     ) internal virtual {
827         _mint(to, tokenId);
828         require(
829             _checkOnERC721Received(address(0), to, tokenId, _data),
830             "ERC721: transfer to non ERC721Receiver implementer"
831         );
832     }
833 
834     /**
835      * @dev Mints `tokenId` and transfers it to `to`.
836      *
837      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
838      *
839      * Requirements:
840      *
841      * - `tokenId` must not exist.
842      * - `to` cannot be the zero address.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _mint(address to, uint256 tokenId) internal virtual {
847         require(to != address(0), "ERC721: mint to the zero address");
848         require(!_exists(tokenId), "ERC721: token already minted");
849 
850         _beforeTokenTransfer(address(0), to, tokenId);
851 
852         _balances[to] += 1;
853         _owners[tokenId] = to;
854 
855         emit Transfer(address(0), to, tokenId);
856     }
857 
858     /**
859      * @dev Destroys `tokenId`.
860      * The approval is cleared when the token is burned.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must exist.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _burn(uint256 tokenId) internal virtual {
869         address owner = ERC721.ownerOf(tokenId);
870 
871         _beforeTokenTransfer(owner, address(0), tokenId);
872 
873         // Clear approvals
874         _approve(address(0), tokenId);
875 
876         _balances[owner] -= 1;
877         delete _owners[tokenId];
878 
879         emit Transfer(owner, address(0), tokenId);
880     }
881 
882     /**
883      * @dev Transfers `tokenId` from `from` to `to`.
884      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
885      *
886      * Requirements:
887      *
888      * - `to` cannot be the zero address.
889      * - `tokenId` token must be owned by `from`.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _transfer(
894         address from,
895         address to,
896         uint256 tokenId
897     ) internal virtual {
898         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
899         require(to != address(0), "ERC721: transfer to the zero address");
900 
901         _beforeTokenTransfer(from, to, tokenId);
902 
903         // Clear approvals from the previous owner
904         _approve(address(0), tokenId);
905 
906         _balances[from] -= 1;
907         _balances[to] += 1;
908         _owners[tokenId] = to;
909 
910         emit Transfer(from, to, tokenId);
911     }
912 
913     /**
914      * @dev Approve `to` to operate on `tokenId`
915      *
916      * Emits a {Approval} event.
917      */
918     function _approve(address to, uint256 tokenId) internal virtual {
919         _tokenApprovals[tokenId] = to;
920         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
921     }
922 
923     /**
924      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
925      * The call is not executed if the target address is not a contract.
926      *
927      * @param from address representing the previous owner of the given token ID
928      * @param to target address that will receive the tokens
929      * @param tokenId uint256 ID of the token to be transferred
930      * @param _data bytes optional data to send along with the call
931      * @return bool whether the call correctly returned the expected magic value
932      */
933     function _checkOnERC721Received(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) private returns (bool) {
939         if (to.isContract()) {
940             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
941                 return retval == IERC721Receiver.onERC721Received.selector;
942             } catch (bytes memory reason) {
943                 if (reason.length == 0) {
944                     revert("ERC721: transfer to non ERC721Receiver implementer");
945                 } else {
946                     assembly {
947                         revert(add(32, reason), mload(reason))
948                     }
949                 }
950             }
951         } else {
952             return true;
953         }
954     }
955 
956     /**
957      * @dev Hook that is called before any token transfer. This includes minting
958      * and burning.
959      *
960      * Calling conditions:
961      *
962      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
963      * transferred to `to`.
964      * - When `from` is zero, `tokenId` will be minted for `to`.
965      * - When `to` is zero, ``from``'s `tokenId` will be burned.
966      * - `from` and `to` are never both zero.
967      *
968      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
969      */
970     function _beforeTokenTransfer(
971         address from,
972         address to,
973         uint256 tokenId
974     ) internal virtual {}
975 }
976 
977 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
978 
979 
980 pragma solidity ^0.8.0;
981 
982 
983 /**
984  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
985  * @dev See https://eips.ethereum.org/EIPS/eip-721
986  */
987 interface IERC721Enumerable is IERC721 {
988     /**
989      * @dev Returns the total amount of tokens stored by the contract.
990      */
991     function totalSupply() external view returns (uint256);
992 
993     /**
994      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
995      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
996      */
997     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
998 
999     /**
1000      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1001      * Use along with {totalSupply} to enumerate all tokens.
1002      */
1003     function tokenByIndex(uint256 index) external view returns (uint256);
1004 }
1005 
1006 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1007 
1008 
1009 pragma solidity ^0.8.0;
1010 
1011 
1012 
1013 /**
1014  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1015  * enumerability of all the token ids in the contract as well as all token ids owned by each
1016  * account.
1017  */
1018 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1019     // Mapping from owner to list of owned token IDs
1020     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1021 
1022     // Mapping from token ID to index of the owner tokens list
1023     mapping(uint256 => uint256) private _ownedTokensIndex;
1024 
1025     // Array with all token ids, used for enumeration
1026     uint256[] private _allTokens;
1027 
1028     // Mapping from token id to position in the allTokens array
1029     mapping(uint256 => uint256) private _allTokensIndex;
1030 
1031     /**
1032      * @dev See {IERC165-supportsInterface}.
1033      */
1034     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1035         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1040      */
1041     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1042         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1043         return _ownedTokens[owner][index];
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Enumerable-totalSupply}.
1048      */
1049     function totalSupply() public view virtual override returns (uint256) {
1050         return _allTokens.length;
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Enumerable-tokenByIndex}.
1055      */
1056     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1057         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1058         return _allTokens[index];
1059     }
1060 
1061     /**
1062      * @dev Hook that is called before any token transfer. This includes minting
1063      * and burning.
1064      *
1065      * Calling conditions:
1066      *
1067      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1068      * transferred to `to`.
1069      * - When `from` is zero, `tokenId` will be minted for `to`.
1070      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1071      * - `from` cannot be the zero address.
1072      * - `to` cannot be the zero address.
1073      *
1074      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1075      */
1076     function _beforeTokenTransfer(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) internal virtual override {
1081         super._beforeTokenTransfer(from, to, tokenId);
1082 
1083         if (from == address(0)) {
1084             _addTokenToAllTokensEnumeration(tokenId);
1085         } else if (from != to) {
1086             _removeTokenFromOwnerEnumeration(from, tokenId);
1087         }
1088         if (to == address(0)) {
1089             _removeTokenFromAllTokensEnumeration(tokenId);
1090         } else if (to != from) {
1091             _addTokenToOwnerEnumeration(to, tokenId);
1092         }
1093     }
1094 
1095     /**
1096      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1097      * @param to address representing the new owner of the given token ID
1098      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1099      */
1100     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1101         uint256 length = ERC721.balanceOf(to);
1102         _ownedTokens[to][length] = tokenId;
1103         _ownedTokensIndex[tokenId] = length;
1104     }
1105 
1106     /**
1107      * @dev Private function to add a token to this extension's token tracking data structures.
1108      * @param tokenId uint256 ID of the token to be added to the tokens list
1109      */
1110     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1111         _allTokensIndex[tokenId] = _allTokens.length;
1112         _allTokens.push(tokenId);
1113     }
1114 
1115     /**
1116      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1117      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1118      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1119      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1120      * @param from address representing the previous owner of the given token ID
1121      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1122      */
1123     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1124         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1125         // then delete the last slot (swap and pop).
1126 
1127         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1128         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1129 
1130         // When the token to delete is the last token, the swap operation is unnecessary
1131         if (tokenIndex != lastTokenIndex) {
1132             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1133 
1134             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1135             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1136         }
1137 
1138         // This also deletes the contents at the last position of the array
1139         delete _ownedTokensIndex[tokenId];
1140         delete _ownedTokens[from][lastTokenIndex];
1141     }
1142 
1143     /**
1144      * @dev Private function to remove a token from this extension's token tracking data structures.
1145      * This has O(1) time complexity, but alters the order of the _allTokens array.
1146      * @param tokenId uint256 ID of the token to be removed from the tokens list
1147      */
1148     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1149         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1150         // then delete the last slot (swap and pop).
1151 
1152         uint256 lastTokenIndex = _allTokens.length - 1;
1153         uint256 tokenIndex = _allTokensIndex[tokenId];
1154 
1155         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1156         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1157         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1158         uint256 lastTokenId = _allTokens[lastTokenIndex];
1159 
1160         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1161         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1162 
1163         // This also deletes the contents at the last position of the array
1164         delete _allTokensIndex[tokenId];
1165         _allTokens.pop();
1166     }
1167 }
1168 
1169 // File: @openzeppelin/contracts/access/Ownable.sol
1170 
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 /**
1176  * @dev Contract module which provides a basic access control mechanism, where
1177  * there is an account (an owner) that can be granted exclusive access to
1178  * specific functions.
1179  *
1180  * By default, the owner account will be the one that deploys the contract. This
1181  * can later be changed with {transferOwnership}.
1182  *
1183  * This module is used through inheritance. It will make available the modifier
1184  * `onlyOwner`, which can be applied to your functions to restrict their use to
1185  * the owner.
1186  */
1187 abstract contract Ownable is Context {
1188     address private _owner;
1189 
1190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1191 
1192     /**
1193      * @dev Initializes the contract setting the deployer as the initial owner.
1194      */
1195     constructor() {
1196         _setOwner(_msgSender());
1197     }
1198 
1199     /**
1200      * @dev Returns the address of the current owner.
1201      */
1202     function owner() public view virtual returns (address) {
1203         return _owner;
1204     }
1205 
1206     /**
1207      * @dev Throws if called by any account other than the owner.
1208      */
1209     modifier onlyOwner() {
1210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1211         _;
1212     }
1213 
1214     /**
1215      * @dev Leaves the contract without owner. It will not be possible to call
1216      * `onlyOwner` functions anymore. Can only be called by the current owner.
1217      *
1218      * NOTE: Renouncing ownership will leave the contract without an owner,
1219      * thereby removing any functionality that is only available to the owner.
1220      */
1221     function renounceOwnership() public virtual onlyOwner {
1222         _setOwner(address(0));
1223     }
1224 
1225     /**
1226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1227      * Can only be called by the current owner.
1228      */
1229     function transferOwnership(address newOwner) public virtual onlyOwner {
1230         require(newOwner != address(0), "Ownable: new owner is the zero address");
1231         _setOwner(newOwner);
1232     }
1233 
1234     function _setOwner(address newOwner) private {
1235         address oldOwner = _owner;
1236         _owner = newOwner;
1237         emit OwnershipTransferred(oldOwner, newOwner);
1238     }
1239 }
1240 
1241 // File: pixels.sol
1242 
1243 pragma solidity ^0.8.0;
1244 
1245 
1246 
1247 contract Pixels is ERC721Enumerable, Ownable {
1248 
1249     using Strings for uint256;
1250 
1251     string _baseTokenURI;
1252     uint256 private _maxMint = 20;
1253     uint256 private _price = 8 * 10**16; //0.08 ETH;
1254     bool public _paused = false;
1255     uint public constant MAX_ENTRIES = 1024;
1256 
1257     constructor() ERC721("1024 Pixels", "PXLS")  {
1258         setBaseURI("https://api.1024px.net/");
1259     }
1260     
1261     function mint(address _to, uint256 num) public payable {
1262         uint256 supply = totalSupply();
1263 
1264         if(msg.sender != owner()) {
1265           require(!_paused, "Sale Paused");
1266           require( num < (_maxMint+1),"You can adopt a maximum of _maxMint tokens" );
1267           require( msg.value >= _price * num,"Ether sent is not correct" );
1268         }
1269 
1270         require( supply + num < MAX_ENTRIES, "Exceeds maximum supply" );
1271 
1272         for(uint256 i; i < num; i++){
1273           _safeMint( _to, supply + i );
1274         }
1275     }
1276 
1277     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1278         uint256 tokenCount = balanceOf(_owner);
1279 
1280         uint256[] memory tokensId = new uint256[](tokenCount);
1281         for(uint256 i; i < tokenCount; i++){
1282             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1283         }
1284         return tokensId;
1285     }
1286 
1287     function getPrice() public view returns (uint256){
1288         if(msg.sender == owner()) {
1289             return 0;
1290         }
1291         return _price;
1292     }
1293 
1294     function setPrice(uint256 _newPrice) public onlyOwner() {
1295         _price = _newPrice;
1296     }
1297 
1298     function _baseURI() internal view virtual override returns (string memory) {
1299         return _baseTokenURI;
1300     }
1301 
1302     function setBaseURI(string memory baseURI) public onlyOwner {
1303         _baseTokenURI = baseURI;
1304     }
1305 
1306     function pause(bool val) public onlyOwner {
1307         _paused = val;
1308     }
1309 
1310     function withdrawAll() public payable onlyOwner {
1311         require(payable(msg.sender).send(address(this).balance));
1312     }
1313 }