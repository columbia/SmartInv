1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-21
3 */
4 
5 // Sources flattened with hardhat v2.6.0 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 
35 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
36 
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Required interface of an ERC721 compliant contract.
42  */
43 interface IERC721 is IERC165 {
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
177 
178 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
179 
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @title ERC721 token receiver interface
185  * @dev Interface for any contract that wants to support safeTransfers
186  * from ERC721 asset contracts.
187  */
188 interface IERC721Receiver {
189     /**
190      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
191      * by `operator` from `from`, this function is called.
192      *
193      * It must return its Solidity selector to confirm the token transfer.
194      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
195      *
196      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
197      */
198     function onERC721Received(
199         address operator,
200         address from,
201         uint256 tokenId,
202         bytes calldata data
203     ) external returns (bytes4);
204 }
205 
206 
207 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
208 
209 
210 pragma solidity ^0.8.0;
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
233 
234 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
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
366         return _verifyCallResult(success, returndata, errorMessage);
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
393         return _verifyCallResult(success, returndata, errorMessage);
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
420         return _verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     function _verifyCallResult(
424         bool success,
425         bytes memory returndata,
426         string memory errorMessage
427     ) private pure returns (bytes memory) {
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434 
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 
447 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
448 
449 
450 pragma solidity ^0.8.0;
451 
452 /*
453  * @dev Provides information about the current execution context, including the
454  * sender of the transaction and its data. While these are generally available
455  * via msg.sender and msg.data, they should not be accessed in such a direct
456  * manner, since when dealing with meta-transactions the account sending and
457  * paying for execution may not be the actual sender (as far as an application
458  * is concerned).
459  *
460  * This contract is only required for intermediate, library-like contracts.
461  */
462 abstract contract Context {
463     function _msgSender() internal view virtual returns (address) {
464         return msg.sender;
465     }
466 
467     function _msgData() internal view virtual returns (bytes calldata) {
468         return msg.data;
469     }
470 }
471 
472 
473 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
474 
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev String operations.
480  */
481 library Strings {
482     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
486      */
487     function toString(uint256 value) internal pure returns (string memory) {
488         // Inspired by OraclizeAPI's implementation - MIT licence
489         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
490 
491         if (value == 0) {
492             return "0";
493         }
494         uint256 temp = value;
495         uint256 digits;
496         while (temp != 0) {
497             digits++;
498             temp /= 10;
499         }
500         bytes memory buffer = new bytes(digits);
501         while (value != 0) {
502             digits -= 1;
503             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
504             value /= 10;
505         }
506         return string(buffer);
507     }
508 
509     /**
510      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
511      */
512     function toHexString(uint256 value) internal pure returns (string memory) {
513         if (value == 0) {
514             return "0x00";
515         }
516         uint256 temp = value;
517         uint256 length = 0;
518         while (temp != 0) {
519             length++;
520             temp >>= 8;
521         }
522         return toHexString(value, length);
523     }
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
527      */
528     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
529         bytes memory buffer = new bytes(2 * length + 2);
530         buffer[0] = "0";
531         buffer[1] = "x";
532         for (uint256 i = 2 * length + 1; i > 1; --i) {
533             buffer[i] = _HEX_SYMBOLS[value & 0xf];
534             value >>= 4;
535         }
536         require(value == 0, "Strings: hex length insufficient");
537         return string(buffer);
538     }
539 }
540 
541 
542 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Implementation of the {IERC165} interface.
549  *
550  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
551  * for the additional interface id that will be supported. For example:
552  *
553  * ```solidity
554  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
556  * }
557  * ```
558  *
559  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
560  */
561 abstract contract ERC165 is IERC165 {
562     /**
563      * @dev See {IERC165-supportsInterface}.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566         return interfaceId == type(IERC165).interfaceId;
567     }
568 }
569 
570 
571 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
572 
573 
574 pragma solidity ^0.8.0;
575 
576 
577 
578 
579 
580 
581 
582 /**
583  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
584  * the Metadata extension, but not including the Enumerable extension, which is available separately as
585  * {ERC721Enumerable}.
586  */
587 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
588     using Address for address;
589     using Strings for uint256;
590 
591     // Token name
592     string private _name;
593 
594     // Token symbol
595     string private _symbol;
596 
597     // Mapping from token ID to owner address
598     mapping(uint256 => address) private _owners;
599 
600     // Mapping owner address to token count
601     mapping(address => uint256) private _balances;
602 
603     // Mapping from token ID to approved address
604     mapping(uint256 => address) private _tokenApprovals;
605 
606     // Mapping from owner to operator approvals
607     mapping(address => mapping(address => bool)) private _operatorApprovals;
608 
609     /**
610      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
611      */
612     constructor(string memory name_, string memory symbol_) {
613         _name = name_;
614         _symbol = symbol_;
615     }
616 
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
621         return
622             interfaceId == type(IERC721).interfaceId ||
623             interfaceId == type(IERC721Metadata).interfaceId ||
624             super.supportsInterface(interfaceId);
625     }
626 
627     /**
628      * @dev See {IERC721-balanceOf}.
629      */
630     function balanceOf(address owner) public view virtual override returns (uint256) {
631         require(owner != address(0), "ERC721: balance query for the zero address");
632         return _balances[owner];
633     }
634 
635     /**
636      * @dev See {IERC721-ownerOf}.
637      */
638     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
639         address owner = _owners[tokenId];
640         require(owner != address(0), "ERC721: owner query for nonexistent token");
641         return owner;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-name}.
646      */
647     function name() public view virtual override returns (string memory) {
648         return _name;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-symbol}.
653      */
654     function symbol() public view virtual override returns (string memory) {
655         return _symbol;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-tokenURI}.
660      */
661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
662         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
663 
664         string memory baseURI = _baseURI();
665         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
666     }
667 
668     /**
669      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
670      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
671      * by default, can be overriden in child contracts.
672      */
673     function _baseURI() internal view virtual returns (string memory) {
674         return "";
675     }
676 
677     /**
678      * @dev See {IERC721-approve}.
679      */
680     function approve(address to, uint256 tokenId) public virtual override {
681         address owner = ERC721.ownerOf(tokenId);
682         require(to != owner, "ERC721: approval to current owner");
683 
684         require(
685             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
686             "ERC721: approve caller is not owner nor approved for all"
687         );
688 
689         _approve(to, tokenId);
690     }
691 
692     /**
693      * @dev See {IERC721-getApproved}.
694      */
695     function getApproved(uint256 tokenId) public view virtual override returns (address) {
696         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
697 
698         return _tokenApprovals[tokenId];
699     }
700 
701     /**
702      * @dev See {IERC721-setApprovalForAll}.
703      */
704     function setApprovalForAll(address operator, bool approved) public virtual override {
705         require(operator != _msgSender(), "ERC721: approve to caller");
706 
707         _operatorApprovals[_msgSender()][operator] = approved;
708         emit ApprovalForAll(_msgSender(), operator, approved);
709     }
710 
711     /**
712      * @dev See {IERC721-isApprovedForAll}.
713      */
714     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
715         return _operatorApprovals[owner][operator];
716     }
717 
718     /**
719      * @dev See {IERC721-transferFrom}.
720      */
721     function transferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) public virtual override {
726         //solhint-disable-next-line max-line-length
727         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
728 
729         _transfer(from, to, tokenId);
730     }
731 
732     /**
733      * @dev See {IERC721-safeTransferFrom}.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) public virtual override {
740         safeTransferFrom(from, to, tokenId, "");
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) public virtual override {
752         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
753         _safeTransfer(from, to, tokenId, _data);
754     }
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
759      *
760      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
761      *
762      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
763      * implement alternative mechanisms to perform token transfer, such as signature-based.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _safeTransfer(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) internal virtual {
780         _transfer(from, to, tokenId);
781         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
782     }
783 
784     /**
785      * @dev Returns whether `tokenId` exists.
786      *
787      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
788      *
789      * Tokens start existing when they are minted (`_mint`),
790      * and stop existing when they are burned (`_burn`).
791      */
792     function _exists(uint256 tokenId) internal view virtual returns (bool) {
793         return _owners[tokenId] != address(0);
794     }
795 
796     /**
797      * @dev Returns whether `spender` is allowed to manage `tokenId`.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
804         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
805         address owner = ERC721.ownerOf(tokenId);
806         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
807     }
808 
809     /**
810      * @dev Safely mints `tokenId` and transfers it to `to`.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must not exist.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _safeMint(address to, uint256 tokenId) internal virtual {
820         _safeMint(to, tokenId, "");
821     }
822 
823     /**
824      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
825      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
826      */
827     function _safeMint(
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) internal virtual {
832         _mint(to, tokenId);
833         require(
834             _checkOnERC721Received(address(0), to, tokenId, _data),
835             "ERC721: transfer to non ERC721Receiver implementer"
836         );
837     }
838 
839     /**
840      * @dev Mints `tokenId` and transfers it to `to`.
841      *
842      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
843      *
844      * Requirements:
845      *
846      * - `tokenId` must not exist.
847      * - `to` cannot be the zero address.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _mint(address to, uint256 tokenId) internal virtual {
852         require(to != address(0), "ERC721: mint to the zero address");
853         require(!_exists(tokenId), "ERC721: token already minted");
854 
855         _beforeTokenTransfer(address(0), to, tokenId);
856 
857         _balances[to] += 1;
858         _owners[tokenId] = to;
859 
860         emit Transfer(address(0), to, tokenId);
861     }
862 
863     /**
864      * @dev Destroys `tokenId`.
865      * The approval is cleared when the token is burned.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _burn(uint256 tokenId) internal virtual {
874         address owner = ERC721.ownerOf(tokenId);
875 
876         _beforeTokenTransfer(owner, address(0), tokenId);
877 
878         // Clear approvals
879         _approve(address(0), tokenId);
880 
881         _balances[owner] -= 1;
882         delete _owners[tokenId];
883 
884         emit Transfer(owner, address(0), tokenId);
885     }
886 
887     /**
888      * @dev Transfers `tokenId` from `from` to `to`.
889      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must be owned by `from`.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _transfer(
899         address from,
900         address to,
901         uint256 tokenId
902     ) internal virtual {
903         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
904         require(to != address(0), "ERC721: transfer to the zero address");
905 
906         _beforeTokenTransfer(from, to, tokenId);
907 
908         // Clear approvals from the previous owner
909         _approve(address(0), tokenId);
910 
911         _balances[from] -= 1;
912         _balances[to] += 1;
913         _owners[tokenId] = to;
914 
915         emit Transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev Approve `to` to operate on `tokenId`
920      *
921      * Emits a {Approval} event.
922      */
923     function _approve(address to, uint256 tokenId) internal virtual {
924         _tokenApprovals[tokenId] = to;
925         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
926     }
927 
928     /**
929      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
930      * The call is not executed if the target address is not a contract.
931      *
932      * @param from address representing the previous owner of the given token ID
933      * @param to target address that will receive the tokens
934      * @param tokenId uint256 ID of the token to be transferred
935      * @param _data bytes optional data to send along with the call
936      * @return bool whether the call correctly returned the expected magic value
937      */
938     function _checkOnERC721Received(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) private returns (bool) {
944         if (to.isContract()) {
945             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
946                 return retval == IERC721Receiver(to).onERC721Received.selector;
947             } catch (bytes memory reason) {
948                 if (reason.length == 0) {
949                     revert("ERC721: transfer to non ERC721Receiver implementer");
950                 } else {
951                     assembly {
952                         revert(add(32, reason), mload(reason))
953                     }
954                 }
955             }
956         } else {
957             return true;
958         }
959     }
960 
961     /**
962      * @dev Hook that is called before any token transfer. This includes minting
963      * and burning.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` will be minted for `to`.
970      * - When `to` is zero, ``from``'s `tokenId` will be burned.
971      * - `from` and `to` are never both zero.
972      *
973      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
974      */
975     function _beforeTokenTransfer(
976         address from,
977         address to,
978         uint256 tokenId
979     ) internal virtual {}
980 }
981 
982 
983 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
984 
985 
986 pragma solidity ^0.8.0;
987 
988 /**
989  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
990  * @dev See https://eips.ethereum.org/EIPS/eip-721
991  */
992 interface IERC721Enumerable is IERC721 {
993     /**
994      * @dev Returns the total amount of tokens stored by the contract.
995      */
996     function totalSupply() external view returns (uint256);
997 
998     /**
999      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1000      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1001      */
1002     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1003 
1004     /**
1005      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1006      * Use along with {totalSupply} to enumerate all tokens.
1007      */
1008     function tokenByIndex(uint256 index) external view returns (uint256);
1009 }
1010 
1011 
1012 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1013 
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 
1018 /**
1019  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1020  * enumerability of all the token ids in the contract as well as all token ids owned by each
1021  * account.
1022  */
1023 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1024     // Mapping from owner to list of owned token IDs
1025     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1026 
1027     // Mapping from token ID to index of the owner tokens list
1028     mapping(uint256 => uint256) private _ownedTokensIndex;
1029 
1030     // Array with all token ids, used for enumeration
1031     uint256[] private _allTokens;
1032 
1033     // Mapping from token id to position in the allTokens array
1034     mapping(uint256 => uint256) private _allTokensIndex;
1035 
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1040         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1045      */
1046     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1048         return _ownedTokens[owner][index];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-totalSupply}.
1053      */
1054     function totalSupply() public view virtual override returns (uint256) {
1055         return _allTokens.length;
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-tokenByIndex}.
1060      */
1061     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1062         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1063         return _allTokens[index];
1064     }
1065 
1066     /**
1067      * @dev Hook that is called before any token transfer. This includes minting
1068      * and burning.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` will be minted for `to`.
1075      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) internal virtual override {
1086         super._beforeTokenTransfer(from, to, tokenId);
1087 
1088         if (from == address(0)) {
1089             _addTokenToAllTokensEnumeration(tokenId);
1090         } else if (from != to) {
1091             _removeTokenFromOwnerEnumeration(from, tokenId);
1092         }
1093         if (to == address(0)) {
1094             _removeTokenFromAllTokensEnumeration(tokenId);
1095         } else if (to != from) {
1096             _addTokenToOwnerEnumeration(to, tokenId);
1097         }
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1102      * @param to address representing the new owner of the given token ID
1103      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1104      */
1105     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1106         uint256 length = ERC721.balanceOf(to);
1107         _ownedTokens[to][length] = tokenId;
1108         _ownedTokensIndex[tokenId] = length;
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's token tracking data structures.
1113      * @param tokenId uint256 ID of the token to be added to the tokens list
1114      */
1115     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1116         _allTokensIndex[tokenId] = _allTokens.length;
1117         _allTokens.push(tokenId);
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1122      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1123      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1124      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1125      * @param from address representing the previous owner of the given token ID
1126      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1127      */
1128     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1129         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1130         // then delete the last slot (swap and pop).
1131 
1132         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1133         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1134 
1135         // When the token to delete is the last token, the swap operation is unnecessary
1136         if (tokenIndex != lastTokenIndex) {
1137             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1138 
1139             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1140             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1141         }
1142 
1143         // This also deletes the contents at the last position of the array
1144         delete _ownedTokensIndex[tokenId];
1145         delete _ownedTokens[from][lastTokenIndex];
1146     }
1147 
1148     /**
1149      * @dev Private function to remove a token from this extension's token tracking data structures.
1150      * This has O(1) time complexity, but alters the order of the _allTokens array.
1151      * @param tokenId uint256 ID of the token to be removed from the tokens list
1152      */
1153     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1154         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1155         // then delete the last slot (swap and pop).
1156 
1157         uint256 lastTokenIndex = _allTokens.length - 1;
1158         uint256 tokenIndex = _allTokensIndex[tokenId];
1159 
1160         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1161         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1162         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1163         uint256 lastTokenId = _allTokens[lastTokenIndex];
1164 
1165         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1166         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1167 
1168         // This also deletes the contents at the last position of the array
1169         delete _allTokensIndex[tokenId];
1170         _allTokens.pop();
1171     }
1172 }
1173 
1174 
1175 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1176 
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 /**
1181  * @dev Contract module which provides a basic access control mechanism, where
1182  * there is an account (an owner) that can be granted exclusive access to
1183  * specific functions.
1184  *
1185  * By default, the owner account will be the one that deploys the contract. This
1186  * can later be changed with {transferOwnership}.
1187  *
1188  * This module is used through inheritance. It will make available the modifier
1189  * `onlyOwner`, which can be applied to your functions to restrict their use to
1190  * the owner.
1191  */
1192 abstract contract Ownable is Context {
1193     address private _owner;
1194 
1195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1196 
1197     /**
1198      * @dev Initializes the contract setting the deployer as the initial owner.
1199      */
1200     constructor() {
1201         _setOwner(_msgSender());
1202     }
1203 
1204     /**
1205      * @dev Returns the address of the current owner.
1206      */
1207     function owner() public view virtual returns (address) {
1208         return _owner;
1209     }
1210 
1211     /**
1212      * @dev Throws if called by any account other than the owner.
1213      */
1214     modifier onlyOwner() {
1215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1216         _;
1217     }
1218 
1219     /**
1220      * @dev Leaves the contract without owner. It will not be possible to call
1221      * `onlyOwner` functions anymore. Can only be called by the current owner.
1222      *
1223      * NOTE: Renouncing ownership will leave the contract without an owner,
1224      * thereby removing any functionality that is only available to the owner.
1225      */
1226     function renounceOwnership() public virtual onlyOwner {
1227         _setOwner(address(0));
1228     }
1229 
1230     /**
1231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1232      * Can only be called by the current owner.
1233      */
1234     function transferOwnership(address newOwner) public virtual onlyOwner {
1235         require(newOwner != address(0), "Ownable: new owner is the zero address");
1236         _setOwner(newOwner);
1237     }
1238 
1239     function _setOwner(address newOwner) private {
1240         address oldOwner = _owner;
1241         _owner = newOwner;
1242         emit OwnershipTransferred(oldOwner, newOwner);
1243     }
1244 }
1245 
1246 
1247 // File contracts/PKKT.sol
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 contract PKKT is ERC721Enumerable, Ownable {
1252     uint256 public constant MAX_KITTIES = 9999;
1253     uint256 public constant FreeSupply  = 4999;
1254     uint256 public constant PaidSupply  = 5000;
1255     address private receiver = 0x5b27fe710c05841bd2b74D5cee5CD65a642dc339;
1256 
1257     mapping(address => bool) private ClaimedFree;
1258     uint256 private _maxPerTx = 11; // Set to one higher than actual, to save gas on lte/gte checks.
1259     uint256 private _price = 0.05 ether; // .01 ETH
1260     uint256 private _saleTime = 1636804800;
1261     uint256 private _freeMinted = 0;
1262     uint256 private _paidMinted = 0;
1263 
1264     string private _baseTokenURI;
1265 
1266     constructor(string memory baseURI)
1267         ERC721("Punk Kitties", "PKKT")
1268     {
1269         setBaseURI(baseURI);
1270     }
1271 
1272     function setBaseURI(string memory baseURI) public onlyOwner {
1273         _baseTokenURI = baseURI;
1274     }
1275 
1276     function _baseURI() internal view virtual override returns (string memory) {
1277         return _baseTokenURI;
1278     }
1279 
1280     function getBaseURI() public view returns (string memory) {
1281         return _baseTokenURI;
1282     }
1283 
1284     function IsClaimedFree(address user) public view returns (bool) {
1285         return ClaimedFree[user];
1286     }
1287 
1288     function getFreeMinted() public view returns (uint256) {
1289         return _freeMinted;
1290     }
1291 
1292     function getPaidMinted() public view returns (uint256) {
1293         return _paidMinted;
1294     }
1295 
1296     function setSaleTime(uint256 _time) public onlyOwner {
1297         _saleTime = _time;
1298     }
1299 
1300     function getSaleTime() public view returns (uint256) {
1301         return _saleTime;
1302     }
1303 
1304     function setPrice(uint256 _newWEIPrice) public onlyOwner {
1305         _price = _newWEIPrice;
1306     }
1307 
1308     function getPrice() public view returns (uint256) {
1309         return _price;
1310     }
1311 
1312     function claim() public {
1313         uint256 totalSupply = totalSupply();
1314         require(block.timestamp >= _saleTime, "Sale is not yet open.");
1315         require(_freeMinted < FreeSupply, "All free kitties are already claimed.");
1316         require(ClaimedFree[msg.sender] == false, "You have already claimed");
1317         _freeMinted += 1;
1318         ClaimedFree[msg.sender] = true;
1319         _safeMint(msg.sender, totalSupply);
1320     }
1321 
1322     function mint(uint256 _count) public payable {
1323         uint256 totalSupply = totalSupply();
1324         require(block.timestamp >= _saleTime, "Sale is not yet open.");
1325         require(
1326             _count < _maxPerTx,
1327             "Woah, Nelly. That's way too many kitties to mint!"
1328         );
1329         
1330         require(
1331             _count + _paidMinted <= PaidSupply,
1332             "This amount of kitties will exceed max paid kitties."
1333         );
1334 
1335         require(_price * _count <= msg.value, "Transaction value too low.");
1336 
1337         for (uint256 i; i < _count; i++) {
1338             _safeMint(msg.sender, totalSupply + i);
1339         }
1340         _paidMinted += _count;
1341     }
1342 
1343     function walletOfOwner(address _owner)
1344         public
1345         view
1346         returns (uint256[] memory)
1347     {
1348         uint256 tokenCount = balanceOf(_owner);
1349         if (tokenCount == 0) {
1350             return new uint256[](0);
1351         }
1352 
1353         uint256[] memory tokensId = new uint256[](tokenCount);
1354         for (uint256 i; i < tokenCount; i++) {
1355             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1356         }
1357         return tokensId;
1358     }
1359 
1360     function withdrawAll() public {
1361         require(payable(receiver).send(address(this).balance));
1362     }
1363 }