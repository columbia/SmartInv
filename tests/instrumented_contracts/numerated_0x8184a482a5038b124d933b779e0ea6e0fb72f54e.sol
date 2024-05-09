1 // Sources flattened with hardhat v2.5.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
176 
177 
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 
205 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
206 
207 
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216     /**
217      * @dev Returns the token collection name.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the token collection symbol.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228      */
229     function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 
233 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
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
450 
451 pragma solidity ^0.8.0;
452 
453 /*
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         return msg.data;
470     }
471 }
472 
473 
474 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
475 
476 
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev String operations.
482  */
483 library Strings {
484     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
488      */
489     function toString(uint256 value) internal pure returns (string memory) {
490         // Inspired by OraclizeAPI's implementation - MIT licence
491         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
492 
493         if (value == 0) {
494             return "0";
495         }
496         uint256 temp = value;
497         uint256 digits;
498         while (temp != 0) {
499             digits++;
500             temp /= 10;
501         }
502         bytes memory buffer = new bytes(digits);
503         while (value != 0) {
504             digits -= 1;
505             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
506             value /= 10;
507         }
508         return string(buffer);
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
513      */
514     function toHexString(uint256 value) internal pure returns (string memory) {
515         if (value == 0) {
516             return "0x00";
517         }
518         uint256 temp = value;
519         uint256 length = 0;
520         while (temp != 0) {
521             length++;
522             temp >>= 8;
523         }
524         return toHexString(value, length);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
529      */
530     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
531         bytes memory buffer = new bytes(2 * length + 2);
532         buffer[0] = "0";
533         buffer[1] = "x";
534         for (uint256 i = 2 * length + 1; i > 1; --i) {
535             buffer[i] = _HEX_SYMBOLS[value & 0xf];
536             value >>= 4;
537         }
538         require(value == 0, "Strings: hex length insufficient");
539         return string(buffer);
540     }
541 }
542 
543 
544 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev Implementation of the {IERC165} interface.
552  *
553  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
554  * for the additional interface id that will be supported. For example:
555  *
556  * ```solidity
557  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
559  * }
560  * ```
561  *
562  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
563  */
564 abstract contract ERC165 is IERC165 {
565     /**
566      * @dev See {IERC165-supportsInterface}.
567      */
568     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569         return interfaceId == type(IERC165).interfaceId;
570     }
571 }
572 
573 
574 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
575 
576 
577 
578 pragma solidity ^0.8.0;
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
950                 return retval == IERC721Receiver(to).onERC721Received.selector;
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
986 
987 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
988 
989 
990 
991 pragma solidity ^0.8.0;
992 
993 /**
994  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
995  * @dev See https://eips.ethereum.org/EIPS/eip-721
996  */
997 interface IERC721Enumerable is IERC721 {
998     /**
999      * @dev Returns the total amount of tokens stored by the contract.
1000      */
1001     function totalSupply() external view returns (uint256);
1002 
1003     /**
1004      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1005      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1006      */
1007     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1008 
1009     /**
1010      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1011      * Use along with {totalSupply} to enumerate all tokens.
1012      */
1013     function tokenByIndex(uint256 index) external view returns (uint256);
1014 }
1015 
1016 
1017 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1018 
1019 
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 /**
1025  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1026  * enumerability of all the token ids in the contract as well as all token ids owned by each
1027  * account.
1028  */
1029 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1030     // Mapping from owner to list of owned token IDs
1031     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1032 
1033     // Mapping from token ID to index of the owner tokens list
1034     mapping(uint256 => uint256) private _ownedTokensIndex;
1035 
1036     // Array with all token ids, used for enumeration
1037     uint256[] private _allTokens;
1038 
1039     // Mapping from token id to position in the allTokens array
1040     mapping(uint256 => uint256) private _allTokensIndex;
1041 
1042     /**
1043      * @dev See {IERC165-supportsInterface}.
1044      */
1045     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1046         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1051      */
1052     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1053         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1054         return _ownedTokens[owner][index];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-totalSupply}.
1059      */
1060     function totalSupply() public view virtual override returns (uint256) {
1061         return _allTokens.length;
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-tokenByIndex}.
1066      */
1067     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1068         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1069         return _allTokens[index];
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before any token transfer. This includes minting
1074      * and burning.
1075      *
1076      * Calling conditions:
1077      *
1078      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1079      * transferred to `to`.
1080      * - When `from` is zero, `tokenId` will be minted for `to`.
1081      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual override {
1092         super._beforeTokenTransfer(from, to, tokenId);
1093 
1094         if (from == address(0)) {
1095             _addTokenToAllTokensEnumeration(tokenId);
1096         } else if (from != to) {
1097             _removeTokenFromOwnerEnumeration(from, tokenId);
1098         }
1099         if (to == address(0)) {
1100             _removeTokenFromAllTokensEnumeration(tokenId);
1101         } else if (to != from) {
1102             _addTokenToOwnerEnumeration(to, tokenId);
1103         }
1104     }
1105 
1106     /**
1107      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1108      * @param to address representing the new owner of the given token ID
1109      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1110      */
1111     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1112         uint256 length = ERC721.balanceOf(to);
1113         _ownedTokens[to][length] = tokenId;
1114         _ownedTokensIndex[tokenId] = length;
1115     }
1116 
1117     /**
1118      * @dev Private function to add a token to this extension's token tracking data structures.
1119      * @param tokenId uint256 ID of the token to be added to the tokens list
1120      */
1121     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1122         _allTokensIndex[tokenId] = _allTokens.length;
1123         _allTokens.push(tokenId);
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1128      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1129      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1130      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1131      * @param from address representing the previous owner of the given token ID
1132      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1133      */
1134     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1135         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1136         // then delete the last slot (swap and pop).
1137 
1138         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1139         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1140 
1141         // When the token to delete is the last token, the swap operation is unnecessary
1142         if (tokenIndex != lastTokenIndex) {
1143             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1144 
1145             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1146             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1147         }
1148 
1149         // This also deletes the contents at the last position of the array
1150         delete _ownedTokensIndex[tokenId];
1151         delete _ownedTokens[from][lastTokenIndex];
1152     }
1153 
1154     /**
1155      * @dev Private function to remove a token from this extension's token tracking data structures.
1156      * This has O(1) time complexity, but alters the order of the _allTokens array.
1157      * @param tokenId uint256 ID of the token to be removed from the tokens list
1158      */
1159     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1160         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1161         // then delete the last slot (swap and pop).
1162 
1163         uint256 lastTokenIndex = _allTokens.length - 1;
1164         uint256 tokenIndex = _allTokensIndex[tokenId];
1165 
1166         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1167         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1168         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1169         uint256 lastTokenId = _allTokens[lastTokenIndex];
1170 
1171         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1172         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1173 
1174         // This also deletes the contents at the last position of the array
1175         delete _allTokensIndex[tokenId];
1176         _allTokens.pop();
1177     }
1178 }
1179 
1180 
1181 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.2.0
1182 
1183 
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 
1188 /**
1189  * @title ERC721 Burnable Token
1190  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1191  */
1192 abstract contract ERC721Burnable is Context, ERC721 {
1193     /**
1194      * @dev Burns `tokenId`. See {ERC721-_burn}.
1195      *
1196      * Requirements:
1197      *
1198      * - The caller must own `tokenId` or be an approved operator.
1199      */
1200     function burn(uint256 tokenId) public virtual {
1201         //solhint-disable-next-line max-line-length
1202         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1203         _burn(tokenId);
1204     }
1205 }
1206 
1207 
1208 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1209 
1210 
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 /**
1215  * @dev Contract module which provides a basic access control mechanism, where
1216  * there is an account (an owner) that can be granted exclusive access to
1217  * specific functions.
1218  *
1219  * By default, the owner account will be the one that deploys the contract. This
1220  * can later be changed with {transferOwnership}.
1221  *
1222  * This module is used through inheritance. It will make available the modifier
1223  * `onlyOwner`, which can be applied to your functions to restrict their use to
1224  * the owner.
1225  */
1226 abstract contract Ownable is Context {
1227     address private _owner;
1228 
1229     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1230 
1231     /**
1232      * @dev Initializes the contract setting the deployer as the initial owner.
1233      */
1234     constructor() {
1235         _setOwner(_msgSender());
1236     }
1237 
1238     /**
1239      * @dev Returns the address of the current owner.
1240      */
1241     function owner() public view virtual returns (address) {
1242         return _owner;
1243     }
1244 
1245     /**
1246      * @dev Throws if called by any account other than the owner.
1247      */
1248     modifier onlyOwner() {
1249         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1250         _;
1251     }
1252 
1253     /**
1254      * @dev Leaves the contract without owner. It will not be possible to call
1255      * `onlyOwner` functions anymore. Can only be called by the current owner.
1256      *
1257      * NOTE: Renouncing ownership will leave the contract without an owner,
1258      * thereby removing any functionality that is only available to the owner.
1259      */
1260     function renounceOwnership() public virtual onlyOwner {
1261         _setOwner(address(0));
1262     }
1263 
1264     /**
1265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1266      * Can only be called by the current owner.
1267      */
1268     function transferOwnership(address newOwner) public virtual onlyOwner {
1269         require(newOwner != address(0), "Ownable: new owner is the zero address");
1270         _setOwner(newOwner);
1271     }
1272 
1273     function _setOwner(address newOwner) private {
1274         address oldOwner = _owner;
1275         _owner = newOwner;
1276         emit OwnershipTransferred(oldOwner, newOwner);
1277     }
1278 }
1279 
1280 
1281 // File @openzeppelin/contracts/utils/Counters.sol@v4.2.0
1282 
1283 
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 /**
1288  * @title Counters
1289  * @author Matt Condon (@shrugs)
1290  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1291  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1292  *
1293  * Include with `using Counters for Counters.Counter;`
1294  */
1295 library Counters {
1296     struct Counter {
1297         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1298         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1299         // this feature: see https://github.com/ethereum/solidity/issues/4637
1300         uint256 _value; // default: 0
1301     }
1302 
1303     function current(Counter storage counter) internal view returns (uint256) {
1304         return counter._value;
1305     }
1306 
1307     function increment(Counter storage counter) internal {
1308         unchecked {
1309             counter._value += 1;
1310         }
1311     }
1312 
1313     function decrement(Counter storage counter) internal {
1314         uint256 value = counter._value;
1315         require(value > 0, "Counter: decrement overflow");
1316         unchecked {
1317             counter._value = value - 1;
1318         }
1319     }
1320 
1321     function reset(Counter storage counter) internal {
1322         counter._value = 0;
1323     }
1324 }
1325 
1326 
1327 // File contracts/Wanderer.sol
1328 
1329 
1330 pragma solidity ^0.8.2;
1331 
1332 
1333 
1334 
1335 
1336 contract Wanderer is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
1337     using Counters for Counters.Counter;
1338 
1339     Counters.Counter private _tokenIdCounter;
1340 
1341     // Where funds should be sent to
1342     address payable public fundsTo;
1343 
1344     // Maximum supply of the NFT
1345     uint256 public maxSupply;
1346 
1347     // Maximum mints per transaction
1348     uint256 public maxPerTx;
1349 
1350     // Is sale on?
1351     bool public sale;
1352 
1353     // Sale price
1354     uint256 public pricePer;
1355 
1356     constructor(address payable fundsTo_, uint256 maxSupply_, uint256 maxPerTx_, uint256 pricePer_) ERC721("Wanderers", "WANDERER") {
1357         fundsTo = fundsTo_;
1358         maxSupply = maxSupply_;
1359         maxPerTx = maxPerTx_;
1360         sale = false;
1361         pricePer = pricePer_;
1362     }
1363 
1364     function updateFundsTo(address payable newFundsTo) public onlyOwner {
1365         fundsTo = newFundsTo;
1366     }
1367 
1368     function enableSale() public onlyOwner {
1369         sale = true;
1370     }
1371 
1372     function claimBalance() public onlyOwner {
1373         (bool success, ) = fundsTo.call{value: address(this).balance}("");
1374         require(success, "transfer failed");
1375     }
1376 
1377     function safeMint(address to, uint256 quantity) payable public {
1378         // Sale must be enabled
1379         require(sale, "Sale disabled");
1380         // Cannot mint 0
1381         require(quantity != 0, "Requested quantity cannot be zero");
1382         // Cannot mint more than maximum
1383         require(quantity <= maxPerTx, "Requested quantity more than maximum");
1384         // Transaction must have at least quantity * price (any more is considered a tip)
1385         require(quantity * pricePer <= msg.value, "Not enough ether sent");
1386         // Mint operation cannot lead to more than max supply
1387         require(super.totalSupply() + quantity <= maxSupply, "Total supply will exceed limit");
1388 
1389         for (uint256 i = 0; i < quantity; i++) {
1390             _safeMint(to, _tokenIdCounter.current());
1391             _tokenIdCounter.increment();
1392         }
1393     }
1394 
1395     function preMint(address to, uint256 quantity) public onlyOwner {
1396         // Sale must NOT be enabled
1397         require(!sale, "Sale already in progress");
1398         require(quantity != 0, "Requested quantity cannot be zero");
1399         require(super.totalSupply() + quantity <= maxSupply, "Total supply will exceed limit");
1400 
1401         for (uint256 i = 0; i < quantity; i++) {
1402             _safeMint(to, _tokenIdCounter.current());
1403             _tokenIdCounter.increment();
1404         }
1405     }
1406 
1407     function _baseURI() internal pure override returns (string memory) {
1408         return "ipfs://QmNnWrwfAbsnWvyTgGpaYLdh1oAkBR5B74MjwZh8stTL97/";
1409     }
1410 
1411     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1412         super._beforeTokenTransfer(from, to, tokenId);
1413     }
1414 
1415     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1416         return super.supportsInterface(interfaceId);
1417     }
1418 }