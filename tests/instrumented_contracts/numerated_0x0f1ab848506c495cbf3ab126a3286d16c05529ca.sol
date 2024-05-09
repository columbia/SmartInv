1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-31
3 */
4 
5 // SPDX-License-Identifier: MIT AND GPL-3.0
6 
7 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
33 
34 
35 
36 pragma solidity ^0.8.0;
37 
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
177 
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
206 
207 
208 
209 pragma solidity ^0.8.0;
210 
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         uint256 size;
266         assembly {
267             size := extcodesize(account)
268         }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/Context.sol
453 
454 
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Provides information about the current execution context, including the
460  * sender of the transaction and its data. While these are generally available
461  * via msg.sender and msg.data, they should not be accessed in such a direct
462  * manner, since when dealing with meta-transactions the account sending and
463  * paying for execution may not be the actual sender (as far as an application
464  * is concerned).
465  *
466  * This contract is only required for intermediate, library-like contracts.
467  */
468 abstract contract Context {
469     function _msgSender() internal view virtual returns (address) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view virtual returns (bytes calldata) {
474         return msg.data;
475     }
476 }
477 
478 // File: @openzeppelin/contracts/utils/Strings.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev String operations.
486  */
487 library Strings {
488     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
492      */
493     function toString(uint256 value) internal pure returns (string memory) {
494         // Inspired by OraclizeAPI's implementation - MIT licence
495         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
496 
497         if (value == 0) {
498             return "0";
499         }
500         uint256 temp = value;
501         uint256 digits;
502         while (temp != 0) {
503             digits++;
504             temp /= 10;
505         }
506         bytes memory buffer = new bytes(digits);
507         while (value != 0) {
508             digits -= 1;
509             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
510             value /= 10;
511         }
512         return string(buffer);
513     }
514 
515     /**
516      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
517      */
518     function toHexString(uint256 value) internal pure returns (string memory) {
519         if (value == 0) {
520             return "0x00";
521         }
522         uint256 temp = value;
523         uint256 length = 0;
524         while (temp != 0) {
525             length++;
526             temp >>= 8;
527         }
528         return toHexString(value, length);
529     }
530 
531     /**
532      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
533      */
534     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
535         bytes memory buffer = new bytes(2 * length + 2);
536         buffer[0] = "0";
537         buffer[1] = "x";
538         for (uint256 i = 2 * length + 1; i > 1; --i) {
539             buffer[i] = _HEX_SYMBOLS[value & 0xf];
540             value >>= 4;
541         }
542         require(value == 0, "Strings: hex length insufficient");
543         return string(buffer);
544     }
545 }
546 
547 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev Implementation of the {IERC165} interface.
556  *
557  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
558  * for the additional interface id that will be supported. For example:
559  *
560  * ```solidity
561  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
563  * }
564  * ```
565  *
566  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
567  */
568 abstract contract ERC165 is IERC165 {
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
573         return interfaceId == type(IERC165).interfaceId;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 
584 
585 
586 
587 
588 
589 
590 /**
591  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
592  * the Metadata extension, but not including the Enumerable extension, which is available separately as
593  * {ERC721Enumerable}.
594  */
595 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
596     using Address for address;
597     using Strings for uint256;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to owner address
606     mapping(uint256 => address) private _owners;
607 
608     // Mapping owner address to token count
609     mapping(address => uint256) private _balances;
610 
611     // Mapping from token ID to approved address
612     mapping(uint256 => address) private _tokenApprovals;
613 
614     // Mapping from owner to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     /**
618      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
619      */
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623     }
624 
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
629         return
630             interfaceId == type(IERC721).interfaceId ||
631             interfaceId == type(IERC721Metadata).interfaceId ||
632             super.supportsInterface(interfaceId);
633     }
634 
635     /**
636      * @dev See {IERC721-balanceOf}.
637      */
638     function balanceOf(address owner) public view virtual override returns (uint256) {
639         require(owner != address(0), "ERC721: balance query for the zero address");
640         return _balances[owner];
641     }
642 
643     /**
644      * @dev See {IERC721-ownerOf}.
645      */
646     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
647         address owner = _owners[tokenId];
648         require(owner != address(0), "ERC721: owner query for nonexistent token");
649         return owner;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-name}.
654      */
655     function name() public view virtual override returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-symbol}.
661      */
662     function symbol() public view virtual override returns (string memory) {
663         return _symbol;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-tokenURI}.
668      */
669     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
670         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
671 
672         string memory baseURI = _baseURI();
673         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
674     }
675 
676     /**
677      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
678      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
679      * by default, can be overriden in child contracts.
680      */
681     function _baseURI() internal view virtual returns (string memory) {
682         return "";
683     }
684 
685     /**
686      * @dev See {IERC721-approve}.
687      */
688     function approve(address to, uint256 tokenId) public virtual override {
689         address owner = ERC721.ownerOf(tokenId);
690         require(to != owner, "ERC721: approval to current owner");
691 
692         require(
693             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
694             "ERC721: approve caller is not owner nor approved for all"
695         );
696 
697         _approve(to, tokenId);
698     }
699 
700     /**
701      * @dev See {IERC721-getApproved}.
702      */
703     function getApproved(uint256 tokenId) public view virtual override returns (address) {
704         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
705 
706         return _tokenApprovals[tokenId];
707     }
708 
709     /**
710      * @dev See {IERC721-setApprovalForAll}.
711      */
712     function setApprovalForAll(address operator, bool approved) public virtual override {
713         require(operator != _msgSender(), "ERC721: approve to caller");
714 
715         _operatorApprovals[_msgSender()][operator] = approved;
716         emit ApprovalForAll(_msgSender(), operator, approved);
717     }
718 
719     /**
720      * @dev See {IERC721-isApprovedForAll}.
721      */
722     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
723         return _operatorApprovals[owner][operator];
724     }
725 
726     /**
727      * @dev See {IERC721-transferFrom}.
728      */
729     function transferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         //solhint-disable-next-line max-line-length
735         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
736 
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, "");
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761         _safeTransfer(from, to, tokenId, _data);
762     }
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
766      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
767      *
768      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
769      *
770      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
771      * implement alternative mechanisms to perform token transfer, such as signature-based.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _safeTransfer(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes memory _data
787     ) internal virtual {
788         _transfer(from, to, tokenId);
789         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
790     }
791 
792     /**
793      * @dev Returns whether `tokenId` exists.
794      *
795      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
796      *
797      * Tokens start existing when they are minted (`_mint`),
798      * and stop existing when they are burned (`_burn`).
799      */
800     function _exists(uint256 tokenId) internal view virtual returns (bool) {
801         return _owners[tokenId] != address(0);
802     }
803 
804     /**
805      * @dev Returns whether `spender` is allowed to manage `tokenId`.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
812         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
813         address owner = ERC721.ownerOf(tokenId);
814         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
815     }
816 
817     /**
818      * @dev Safely mints `tokenId` and transfers it to `to`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must not exist.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _safeMint(address to, uint256 tokenId) internal virtual {
828         _safeMint(to, tokenId, "");
829     }
830 
831     /**
832      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
833      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
834      */
835     function _safeMint(
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) internal virtual {
840         _mint(to, tokenId);
841         require(
842             _checkOnERC721Received(address(0), to, tokenId, _data),
843             "ERC721: transfer to non ERC721Receiver implementer"
844         );
845     }
846 
847     /**
848      * @dev Mints `tokenId` and transfers it to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
851      *
852      * Requirements:
853      *
854      * - `tokenId` must not exist.
855      * - `to` cannot be the zero address.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _mint(address to, uint256 tokenId) internal virtual {
860         require(to != address(0), "ERC721: mint to the zero address");
861         require(!_exists(tokenId), "ERC721: token already minted");
862 
863         _beforeTokenTransfer(address(0), to, tokenId);
864 
865         _balances[to] += 1;
866         _owners[tokenId] = to;
867 
868         emit Transfer(address(0), to, tokenId);
869     }
870 
871     /**
872      * @dev Destroys `tokenId`.
873      * The approval is cleared when the token is burned.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _burn(uint256 tokenId) internal virtual {
882         address owner = ERC721.ownerOf(tokenId);
883 
884         _beforeTokenTransfer(owner, address(0), tokenId);
885 
886         // Clear approvals
887         _approve(address(0), tokenId);
888 
889         _balances[owner] -= 1;
890         delete _owners[tokenId];
891 
892         emit Transfer(owner, address(0), tokenId);
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _transfer(
907         address from,
908         address to,
909         uint256 tokenId
910     ) internal virtual {
911         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
912         require(to != address(0), "ERC721: transfer to the zero address");
913 
914         _beforeTokenTransfer(from, to, tokenId);
915 
916         // Clear approvals from the previous owner
917         _approve(address(0), tokenId);
918 
919         _balances[from] -= 1;
920         _balances[to] += 1;
921         _owners[tokenId] = to;
922 
923         emit Transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev Approve `to` to operate on `tokenId`
928      *
929      * Emits a {Approval} event.
930      */
931     function _approve(address to, uint256 tokenId) internal virtual {
932         _tokenApprovals[tokenId] = to;
933         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
934     }
935 
936     /**
937      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
938      * The call is not executed if the target address is not a contract.
939      *
940      * @param from address representing the previous owner of the given token ID
941      * @param to target address that will receive the tokens
942      * @param tokenId uint256 ID of the token to be transferred
943      * @param _data bytes optional data to send along with the call
944      * @return bool whether the call correctly returned the expected magic value
945      */
946     function _checkOnERC721Received(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) private returns (bool) {
952         if (to.isContract()) {
953             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
954                 return retval == IERC721Receiver.onERC721Received.selector;
955             } catch (bytes memory reason) {
956                 if (reason.length == 0) {
957                     revert("ERC721: transfer to non ERC721Receiver implementer");
958                 } else {
959                     assembly {
960                         revert(add(32, reason), mload(reason))
961                     }
962                 }
963             }
964         } else {
965             return true;
966         }
967     }
968 
969     /**
970      * @dev Hook that is called before any token transfer. This includes minting
971      * and burning.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` will be minted for `to`.
978      * - When `to` is zero, ``from``'s `tokenId` will be burned.
979      * - `from` and `to` are never both zero.
980      *
981      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
982      */
983     function _beforeTokenTransfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) internal virtual {}
988 }
989 
990 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
991 
992 
993 
994 pragma solidity ^0.8.0;
995 
996 
997 /**
998  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
999  * @dev See https://eips.ethereum.org/EIPS/eip-721
1000  */
1001 interface IERC721Enumerable is IERC721 {
1002     /**
1003      * @dev Returns the total amount of tokens stored by the contract.
1004      */
1005     function totalSupply() external view returns (uint256);
1006 
1007     /**
1008      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1009      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1010      */
1011     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1012 
1013     /**
1014      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1015      * Use along with {totalSupply} to enumerate all tokens.
1016      */
1017     function tokenByIndex(uint256 index) external view returns (uint256);
1018 }
1019 
1020 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1021 
1022 
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 
1028 /**
1029  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1030  * enumerability of all the token ids in the contract as well as all token ids owned by each
1031  * account.
1032  */
1033 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1034     // Mapping from owner to list of owned token IDs
1035     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1036 
1037     // Mapping from token ID to index of the owner tokens list
1038     mapping(uint256 => uint256) private _ownedTokensIndex;
1039 
1040     // Array with all token ids, used for enumeration
1041     uint256[] private _allTokens;
1042 
1043     // Mapping from token id to position in the allTokens array
1044     mapping(uint256 => uint256) private _allTokensIndex;
1045 
1046     /**
1047      * @dev See {IERC165-supportsInterface}.
1048      */
1049     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1050         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1055      */
1056     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1057         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1058         return _ownedTokens[owner][index];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Enumerable-totalSupply}.
1063      */
1064     function totalSupply() public view virtual override returns (uint256) {
1065         return _allTokens.length;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-tokenByIndex}.
1070      */
1071     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1072         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1073         return _allTokens[index];
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any token transfer. This includes minting
1078      * and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1086      * - `from` cannot be the zero address.
1087      * - `to` cannot be the zero address.
1088      *
1089      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1090      */
1091     function _beforeTokenTransfer(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) internal virtual override {
1096         super._beforeTokenTransfer(from, to, tokenId);
1097 
1098         if (from == address(0)) {
1099             _addTokenToAllTokensEnumeration(tokenId);
1100         } else if (from != to) {
1101             _removeTokenFromOwnerEnumeration(from, tokenId);
1102         }
1103         if (to == address(0)) {
1104             _removeTokenFromAllTokensEnumeration(tokenId);
1105         } else if (to != from) {
1106             _addTokenToOwnerEnumeration(to, tokenId);
1107         }
1108     }
1109 
1110     /**
1111      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1112      * @param to address representing the new owner of the given token ID
1113      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1114      */
1115     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1116         uint256 length = ERC721.balanceOf(to);
1117         _ownedTokens[to][length] = tokenId;
1118         _ownedTokensIndex[tokenId] = length;
1119     }
1120 
1121     /**
1122      * @dev Private function to add a token to this extension's token tracking data structures.
1123      * @param tokenId uint256 ID of the token to be added to the tokens list
1124      */
1125     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1126         _allTokensIndex[tokenId] = _allTokens.length;
1127         _allTokens.push(tokenId);
1128     }
1129 
1130     /**
1131      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1132      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1133      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1134      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1135      * @param from address representing the previous owner of the given token ID
1136      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1137      */
1138     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1139         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1140         // then delete the last slot (swap and pop).
1141 
1142         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1143         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1144 
1145         // When the token to delete is the last token, the swap operation is unnecessary
1146         if (tokenIndex != lastTokenIndex) {
1147             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1148 
1149             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1150             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1151         }
1152 
1153         // This also deletes the contents at the last position of the array
1154         delete _ownedTokensIndex[tokenId];
1155         delete _ownedTokens[from][lastTokenIndex];
1156     }
1157 
1158     /**
1159      * @dev Private function to remove a token from this extension's token tracking data structures.
1160      * This has O(1) time complexity, but alters the order of the _allTokens array.
1161      * @param tokenId uint256 ID of the token to be removed from the tokens list
1162      */
1163     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1164         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1165         // then delete the last slot (swap and pop).
1166 
1167         uint256 lastTokenIndex = _allTokens.length - 1;
1168         uint256 tokenIndex = _allTokensIndex[tokenId];
1169 
1170         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1171         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1172         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1173         uint256 lastTokenId = _allTokens[lastTokenIndex];
1174 
1175         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1176         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1177 
1178         // This also deletes the contents at the last position of the array
1179         delete _allTokensIndex[tokenId];
1180         _allTokens.pop();
1181     }
1182 }
1183 
1184 // File: @openzeppelin/contracts/access/Ownable.sol
1185 
1186 
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 
1191 /**
1192  * @dev Contract module which provides a basic access control mechanism, where
1193  * there is an account (an owner) that can be granted exclusive access to
1194  * specific functions.
1195  *
1196  * By default, the owner account will be the one that deploys the contract. This
1197  * can later be changed with {transferOwnership}.
1198  *
1199  * This module is used through inheritance. It will make available the modifier
1200  * `onlyOwner`, which can be applied to your functions to restrict their use to
1201  * the owner.
1202  */
1203 abstract contract Ownable is Context {
1204     address private _owner;
1205 
1206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1207 
1208     /**
1209      * @dev Initializes the contract setting the deployer as the initial owner.
1210      */
1211     constructor() {
1212         _setOwner(_msgSender());
1213     }
1214 
1215     /**
1216      * @dev Returns the address of the current owner.
1217      */
1218     function owner() public view virtual returns (address) {
1219         return _owner;
1220     }
1221 
1222     /**
1223      * @dev Throws if called by any account other than the owner.
1224      */
1225     modifier onlyOwner() {
1226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1227         _;
1228     }
1229 
1230     /**
1231      * @dev Leaves the contract without owner. It will not be possible to call
1232      * `onlyOwner` functions anymore. Can only be called by the current owner.
1233      *
1234      * NOTE: Renouncing ownership will leave the contract without an owner,
1235      * thereby removing any functionality that is only available to the owner.
1236      */
1237     function renounceOwnership() public virtual onlyOwner {
1238         _setOwner(address(0));
1239     }
1240 
1241     /**
1242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1243      * Can only be called by the current owner.
1244      */
1245     function transferOwnership(address newOwner) public virtual onlyOwner {
1246         require(newOwner != address(0), "Ownable: new owner is the zero address");
1247         _setOwner(newOwner);
1248     }
1249 
1250     function _setOwner(address newOwner) private {
1251         address oldOwner = _owner;
1252         _owner = newOwner;
1253         emit OwnershipTransferred(oldOwner, newOwner);
1254     }
1255 }
1256 
1257 // File: contracts/piligrim.sol
1258 
1259 pragma solidity >=0.7.0 <0.9.0;
1260 
1261 
1262 
1263 contract Piligrim is ERC721Enumerable, Ownable {
1264     using Strings for uint256;
1265     string private baseURI;
1266     string public baseExtension = ".json";
1267     string public notRevealedUri;
1268     uint256 public preSaleCost = 0.02 ether;
1269     uint256 public cost = 0.02 ether;
1270     uint256 public maxSupply = 2222;
1271     uint256 public preSaleMaxSupply = 2222;
1272     uint256 public maxMintAmountPresale = 9;
1273     uint256 public maxMintAmount = 9;
1274     uint256 public nftPerAddressLimitPresale = 9;
1275     uint256 public nftPerAddressLimit = 9;
1276     uint256 public preSaleDate = 1647554200;
1277     uint256 public preSaleEndDate = 1652180399;
1278     uint256 public publicSaleDate = 1652180400;
1279     bool public paused = false;
1280     bool public revealed = false;
1281     mapping(address => bool) whitelistedAddresses;
1282     mapping(address => uint256) public addressMintedBalance;
1283 
1284     constructor(string memory _name, string memory _symbol, string memory _initNotRevealedUri) ERC721(_name, _symbol) {
1285         setNotRevealedURI(_initNotRevealedUri);
1286     }
1287     
1288     //MODIFIERS
1289     modifier notPaused {
1290          require(!paused, "the contract is paused");
1291          _;
1292     }
1293 
1294     modifier saleStarted {
1295         require(block.timestamp >= preSaleDate, "Sale has not started yet");
1296         _;
1297     }
1298 
1299     modifier minimumMintAmount(uint256 _mintAmount) {
1300         require(_mintAmount > 0, "need to mint at least 1 NFT");
1301         _;
1302     }
1303 
1304     // INTERNAL
1305     function _baseURI() internal view virtual override returns (string memory) {
1306         return baseURI;
1307     }
1308 
1309     function presaleValidations(uint256 _ownerMintedCount, uint256 _mintAmount, uint256 _supply) internal {
1310             uint256 actualCost;
1311             block.timestamp < preSaleEndDate ? actualCost = preSaleCost : actualCost = cost;
1312             require(isWhitelisted(msg.sender), "user is not whitelisted");
1313             require(_ownerMintedCount + _mintAmount <= nftPerAddressLimitPresale, "max NFT per address exceeded for presale");
1314             require(msg.value >= actualCost * _mintAmount, "insufficient funds");
1315             require(_mintAmount <= maxMintAmountPresale,"max mint amount per transaction exceeded");
1316             require(_supply + _mintAmount <= preSaleMaxSupply,"max NFT presale limit exceeded");
1317     }
1318 
1319     function publicsaleValidations(uint256 _ownerMintedCount, uint256 _mintAmount) internal {
1320         require(_ownerMintedCount + _mintAmount <= nftPerAddressLimit,"max NFT per address exceeded");
1321         require(msg.value >= cost * _mintAmount, "insufficient funds");
1322         require(_mintAmount <= maxMintAmount,"max mint amount per transaction exceeded");
1323     }
1324 
1325     //MINT
1326     function mint(uint256 _mintAmount) public payable notPaused saleStarted minimumMintAmount(_mintAmount) {
1327         uint256 supply = totalSupply();
1328         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1329 
1330         //Do some validations depending on which step of the sale we are in
1331         block.timestamp < publicSaleDate ? presaleValidations(ownerMintedCount, _mintAmount, supply) : publicsaleValidations(ownerMintedCount, _mintAmount);
1332 
1333         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1334 
1335         for (uint256 i = 1; i <= _mintAmount; i++) {
1336             addressMintedBalance[msg.sender]++;
1337             _safeMint(msg.sender, supply + i);
1338         }
1339     }
1340     
1341     function gift(uint256 _mintAmount, address destination) public onlyOwner {
1342         require(_mintAmount > 0, "need to mint at least 1 NFT");
1343         uint256 supply = totalSupply();
1344         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1345 
1346         for (uint256 i = 1; i <= _mintAmount; i++) {
1347             addressMintedBalance[destination]++;
1348             _safeMint(destination, supply + i);
1349         }
1350     }
1351 
1352     //PUBLIC VIEWS
1353     function isWhitelisted(address _user) public view returns (bool) {
1354         return whitelistedAddresses[_user];
1355     }
1356 
1357     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1358         uint256 ownerTokenCount = balanceOf(_owner);
1359         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1360         for (uint256 i; i < ownerTokenCount; i++) {
1361             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1362         }
1363         return tokenIds;
1364     }
1365 
1366     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1367         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1368 
1369         if (!revealed) {
1370             return notRevealedUri;
1371         } else {
1372             string memory currentBaseURI = _baseURI();
1373             return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI,tokenId.toString(), baseExtension)) : "";
1374         }
1375     }
1376 
1377     function getCurrentCost() public view returns (uint256) {
1378         if (block.timestamp < preSaleEndDate) {
1379             return preSaleCost;
1380         } else {
1381             return cost;
1382         }
1383     }
1384 
1385     //ONLY OWNER VIEWS
1386     function getBaseURI() public view onlyOwner returns (string memory) {
1387         return baseURI;
1388     }
1389 
1390     function getContractBalance() public view onlyOwner returns (uint256) {
1391         return address(this).balance;
1392     }
1393 
1394     //ONLY OWNER SETTERS
1395 
1396     function reveal() public onlyOwner {
1397         revealed = true;
1398     }
1399 
1400     function pause(bool _state) public onlyOwner {
1401         paused = _state;
1402     }
1403     
1404     function setNftPerAddressLimitPreSale(uint256 _limit) public onlyOwner {
1405         nftPerAddressLimitPresale = _limit;
1406     }
1407 
1408     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1409         nftPerAddressLimit = _limit;
1410     }
1411 
1412     function setPresaleCost(uint256 _newCost) public onlyOwner {
1413         preSaleCost = _newCost;
1414     }
1415 
1416     function setCost(uint256 _newCost) public onlyOwner {
1417         cost = _newCost;
1418     }
1419     
1420     function setmaxMintAmountPreSale(uint256 _newmaxMintAmount) public onlyOwner {
1421         maxMintAmountPresale = _newmaxMintAmount;
1422     }
1423 
1424     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1425         maxMintAmount = _newmaxMintAmount;
1426     }
1427 
1428     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1429         baseURI = _newBaseURI;
1430     }
1431 
1432     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1433         baseExtension = _newBaseExtension;
1434     }
1435 
1436     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1437         notRevealedUri = _notRevealedURI;
1438     }
1439 
1440     function setPresaleMaxSupply(uint256 _newPresaleMaxSupply) public onlyOwner {
1441         preSaleMaxSupply = _newPresaleMaxSupply;
1442     }
1443 
1444     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1445         maxSupply = _maxSupply;
1446     }
1447 
1448     function setPreSaleDate(uint256 _preSaleDate) public onlyOwner {
1449         preSaleDate = _preSaleDate;
1450     }
1451 
1452     function setPreSaleEndDate(uint256 _preSaleEndDate) public onlyOwner {
1453         preSaleEndDate = _preSaleEndDate;
1454     }
1455 
1456     function setPublicSaleDate(uint256 _publicSaleDate) public onlyOwner {
1457         publicSaleDate = _publicSaleDate;
1458     }
1459 
1460     function whitelistUsers(address[] memory addresses) public onlyOwner {
1461         for (uint256 i = 0; i < addresses.length; i++) {
1462             whitelistedAddresses[addresses[i]] = true;
1463         }
1464     }
1465 
1466     function withdraw() public payable onlyOwner {
1467         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1468         require(success);
1469     }
1470 }