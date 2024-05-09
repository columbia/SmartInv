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
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
173 
174 
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @title ERC721 token receiver interface
180  * @dev Interface for any contract that wants to support safeTransfers
181  * from ERC721 asset contracts.
182  */
183 interface IERC721Receiver {
184     /**
185      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
186      * by `operator` from `from`, this function is called.
187      *
188      * It must return its Solidity selector to confirm the token transfer.
189      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
190      *
191      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
192      */
193     function onERC721Received(
194         address operator,
195         address from,
196         uint256 tokenId,
197         bytes calldata data
198     ) external returns (bytes4);
199 }
200 
201 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
202 
203 
204 
205 pragma solidity ^0.8.0;
206 
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 // File: @openzeppelin/contracts/utils/Address.sol
230 
231 
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies on extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         assembly {
263             size := extcodesize(account)
264         }
265         return size > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 // File: @openzeppelin/contracts/utils/Context.sol
449 
450 
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Provides information about the current execution context, including the
456  * sender of the transaction and its data. While these are generally available
457  * via msg.sender and msg.data, they should not be accessed in such a direct
458  * manner, since when dealing with meta-transactions the account sending and
459  * paying for execution may not be the actual sender (as far as an application
460  * is concerned).
461  *
462  * This contract is only required for intermediate, library-like contracts.
463  */
464 abstract contract Context {
465     function _msgSender() internal view virtual returns (address) {
466         return msg.sender;
467     }
468 
469     function _msgData() internal view virtual returns (bytes calldata) {
470         return msg.data;
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/Strings.sol
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
543 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
544 
545 
546 
547 pragma solidity ^0.8.0;
548 
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
573 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
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
986 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
987 
988 
989 
990 pragma solidity ^0.8.0;
991 
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
1016 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1017 
1018 
1019 
1020 pragma solidity ^0.8.0;
1021 
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
1180 // File: @openzeppelin/contracts/access/Ownable.sol
1181 
1182 
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 /**
1188  * @dev Contract module which provides a basic access control mechanism, where
1189  * there is an account (an owner) that can be granted exclusive access to
1190  * specific functions.
1191  *
1192  * By default, the owner account will be the one that deploys the contract. This
1193  * can later be changed with {transferOwnership}.
1194  *
1195  * This module is used through inheritance. It will make available the modifier
1196  * `onlyOwner`, which can be applied to your functions to restrict their use to
1197  * the owner.
1198  */
1199 abstract contract Ownable is Context {
1200     address private _owner;
1201 
1202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1203 
1204     /**
1205      * @dev Initializes the contract setting the deployer as the initial owner.
1206      */
1207     constructor() {
1208         _setOwner(_msgSender());
1209     }
1210 
1211     /**
1212      * @dev Returns the address of the current owner.
1213      */
1214     function owner() public view virtual returns (address) {
1215         return _owner;
1216     }
1217 
1218     /**
1219      * @dev Throws if called by any account other than the owner.
1220      */
1221     modifier onlyOwner() {
1222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1223         _;
1224     }
1225 
1226     /**
1227      * @dev Leaves the contract without owner. It will not be possible to call
1228      * `onlyOwner` functions anymore. Can only be called by the current owner.
1229      *
1230      * NOTE: Renouncing ownership will leave the contract without an owner,
1231      * thereby removing any functionality that is only available to the owner.
1232      */
1233     function renounceOwnership() public virtual onlyOwner {
1234         _setOwner(address(0));
1235     }
1236 
1237     /**
1238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1239      * Can only be called by the current owner.
1240      */
1241     function transferOwnership(address newOwner) public virtual onlyOwner {
1242         require(newOwner != address(0), "Ownable: new owner is the zero address");
1243         _setOwner(newOwner);
1244     }
1245 
1246     function _setOwner(address newOwner) private {
1247         address oldOwner = _owner;
1248         _owner = newOwner;
1249         emit OwnershipTransferred(oldOwner, newOwner);
1250     }
1251 }
1252 
1253 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1254 
1255 
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 /**
1260  * @dev Contract module that helps prevent reentrant calls to a function.
1261  *
1262  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1263  * available, which can be applied to functions to make sure there are no nested
1264  * (reentrant) calls to them.
1265  *
1266  * Note that because there is a single `nonReentrant` guard, functions marked as
1267  * `nonReentrant` may not call one another. This can be worked around by making
1268  * those functions `private`, and then adding `external` `nonReentrant` entry
1269  * points to them.
1270  *
1271  * TIP: If you would like to learn more about reentrancy and alternative ways
1272  * to protect against it, check out our blog post
1273  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1274  */
1275 abstract contract ReentrancyGuard {
1276     // Booleans are more expensive than uint256 or any type that takes up a full
1277     // word because each write operation emits an extra SLOAD to first read the
1278     // slot's contents, replace the bits taken up by the boolean, and then write
1279     // back. This is the compiler's defense against contract upgrades and
1280     // pointer aliasing, and it cannot be disabled.
1281 
1282     // The values being non-zero value makes deployment a bit more expensive,
1283     // but in exchange the refund on every call to nonReentrant will be lower in
1284     // amount. Since refunds are capped to a percentage of the total
1285     // transaction's gas, it is best to keep them low in cases like this one, to
1286     // increase the likelihood of the full refund coming into effect.
1287     uint256 private constant _NOT_ENTERED = 1;
1288     uint256 private constant _ENTERED = 2;
1289 
1290     uint256 private _status;
1291 
1292     constructor() {
1293         _status = _NOT_ENTERED;
1294     }
1295 
1296     /**
1297      * @dev Prevents a contract from calling itself, directly or indirectly.
1298      * Calling a `nonReentrant` function from another `nonReentrant`
1299      * function is not supported. It is possible to prevent this from happening
1300      * by making the `nonReentrant` function external, and make it call a
1301      * `private` function that does the actual work.
1302      */
1303     modifier nonReentrant() {
1304         // On the first call to nonReentrant, _notEntered will be true
1305         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1306 
1307         // Any calls to nonReentrant after this point will fail
1308         _status = _ENTERED;
1309 
1310         _;
1311 
1312         // By storing the original value once again, a refund is triggered (see
1313         // https://eips.ethereum.org/EIPS/eip-2200)
1314         _status = _NOT_ENTERED;
1315     }
1316 }
1317 
1318 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1319 
1320 
1321 
1322 pragma solidity ^0.8.0;
1323 
1324 /**
1325  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1326  *
1327  * These functions can be used to verify that a message was signed by the holder
1328  * of the private keys of a given address.
1329  */
1330 library ECDSA {
1331     enum RecoverError {
1332         NoError,
1333         InvalidSignature,
1334         InvalidSignatureLength,
1335         InvalidSignatureS,
1336         InvalidSignatureV
1337     }
1338 
1339     function _throwError(RecoverError error) private pure {
1340         if (error == RecoverError.NoError) {
1341             return; // no error: do nothing
1342         } else if (error == RecoverError.InvalidSignature) {
1343             revert("ECDSA: invalid signature");
1344         } else if (error == RecoverError.InvalidSignatureLength) {
1345             revert("ECDSA: invalid signature length");
1346         } else if (error == RecoverError.InvalidSignatureS) {
1347             revert("ECDSA: invalid signature 's' value");
1348         } else if (error == RecoverError.InvalidSignatureV) {
1349             revert("ECDSA: invalid signature 'v' value");
1350         }
1351     }
1352 
1353     /**
1354      * @dev Returns the address that signed a hashed message (`hash`) with
1355      * `signature` or error string. This address can then be used for verification purposes.
1356      *
1357      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1358      * this function rejects them by requiring the `s` value to be in the lower
1359      * half order, and the `v` value to be either 27 or 28.
1360      *
1361      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1362      * verification to be secure: it is possible to craft signatures that
1363      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1364      * this is by receiving a hash of the original message (which may otherwise
1365      * be too long), and then calling {toEthSignedMessageHash} on it.
1366      *
1367      * Documentation for signature generation:
1368      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1369      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1370      *
1371      * _Available since v4.3._
1372      */
1373     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1374         // Check the signature length
1375         // - case 65: r,s,v signature (standard)
1376         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1377         if (signature.length == 65) {
1378             bytes32 r;
1379             bytes32 s;
1380             uint8 v;
1381             // ecrecover takes the signature parameters, and the only way to get them
1382             // currently is to use assembly.
1383             assembly {
1384                 r := mload(add(signature, 0x20))
1385                 s := mload(add(signature, 0x40))
1386                 v := byte(0, mload(add(signature, 0x60)))
1387             }
1388             return tryRecover(hash, v, r, s);
1389         } else if (signature.length == 64) {
1390             bytes32 r;
1391             bytes32 vs;
1392             // ecrecover takes the signature parameters, and the only way to get them
1393             // currently is to use assembly.
1394             assembly {
1395                 r := mload(add(signature, 0x20))
1396                 vs := mload(add(signature, 0x40))
1397             }
1398             return tryRecover(hash, r, vs);
1399         } else {
1400             return (address(0), RecoverError.InvalidSignatureLength);
1401         }
1402     }
1403 
1404     /**
1405      * @dev Returns the address that signed a hashed message (`hash`) with
1406      * `signature`. This address can then be used for verification purposes.
1407      *
1408      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1409      * this function rejects them by requiring the `s` value to be in the lower
1410      * half order, and the `v` value to be either 27 or 28.
1411      *
1412      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1413      * verification to be secure: it is possible to craft signatures that
1414      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1415      * this is by receiving a hash of the original message (which may otherwise
1416      * be too long), and then calling {toEthSignedMessageHash} on it.
1417      */
1418     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1419         (address recovered, RecoverError error) = tryRecover(hash, signature);
1420         _throwError(error);
1421         return recovered;
1422     }
1423 
1424     /**
1425      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1426      *
1427      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1428      *
1429      * _Available since v4.3._
1430      */
1431     function tryRecover(
1432         bytes32 hash,
1433         bytes32 r,
1434         bytes32 vs
1435     ) internal pure returns (address, RecoverError) {
1436         bytes32 s;
1437         uint8 v;
1438         assembly {
1439             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1440             v := add(shr(255, vs), 27)
1441         }
1442         return tryRecover(hash, v, r, s);
1443     }
1444 
1445     /**
1446      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1447      *
1448      * _Available since v4.2._
1449      */
1450     function recover(
1451         bytes32 hash,
1452         bytes32 r,
1453         bytes32 vs
1454     ) internal pure returns (address) {
1455         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1456         _throwError(error);
1457         return recovered;
1458     }
1459 
1460     /**
1461      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1462      * `r` and `s` signature fields separately.
1463      *
1464      * _Available since v4.3._
1465      */
1466     function tryRecover(
1467         bytes32 hash,
1468         uint8 v,
1469         bytes32 r,
1470         bytes32 s
1471     ) internal pure returns (address, RecoverError) {
1472         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1473         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1474         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1475         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1476         //
1477         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1478         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1479         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1480         // these malleable signatures as well.
1481         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1482             return (address(0), RecoverError.InvalidSignatureS);
1483         }
1484         if (v != 27 && v != 28) {
1485             return (address(0), RecoverError.InvalidSignatureV);
1486         }
1487 
1488         // If the signature is valid (and not malleable), return the signer address
1489         address signer = ecrecover(hash, v, r, s);
1490         if (signer == address(0)) {
1491             return (address(0), RecoverError.InvalidSignature);
1492         }
1493 
1494         return (signer, RecoverError.NoError);
1495     }
1496 
1497     /**
1498      * @dev Overload of {ECDSA-recover} that receives the `v`,
1499      * `r` and `s` signature fields separately.
1500      */
1501     function recover(
1502         bytes32 hash,
1503         uint8 v,
1504         bytes32 r,
1505         bytes32 s
1506     ) internal pure returns (address) {
1507         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1508         _throwError(error);
1509         return recovered;
1510     }
1511 
1512     /**
1513      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1514      * produces hash corresponding to the one signed with the
1515      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1516      * JSON-RPC method as part of EIP-191.
1517      *
1518      * See {recover}.
1519      */
1520     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1521         // 32 is the length in bytes of hash,
1522         // enforced by the type signature above
1523         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1524     }
1525 
1526     /**
1527      * @dev Returns an Ethereum Signed Typed Data, created from a
1528      * `domainSeparator` and a `structHash`. This produces hash corresponding
1529      * to the one signed with the
1530      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1531      * JSON-RPC method as part of EIP-712.
1532      *
1533      * See {recover}.
1534      */
1535     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1536         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1537     }
1538 }
1539 
1540 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1541 
1542 
1543 
1544 pragma solidity ^0.8.0;
1545 
1546 
1547 /**
1548  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1549  *
1550  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1551  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1552  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1553  *
1554  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1555  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1556  * ({_hashTypedDataV4}).
1557  *
1558  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1559  * the chain id to protect against replay attacks on an eventual fork of the chain.
1560  *
1561  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1562  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1563  *
1564  * _Available since v3.4._
1565  */
1566 abstract contract EIP712 {
1567     /* solhint-disable var-name-mixedcase */
1568     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1569     // invalidate the cached domain separator if the chain id changes.
1570     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1571     uint256 private immutable _CACHED_CHAIN_ID;
1572 
1573     bytes32 private immutable _HASHED_NAME;
1574     bytes32 private immutable _HASHED_VERSION;
1575     bytes32 private immutable _TYPE_HASH;
1576 
1577     /* solhint-enable var-name-mixedcase */
1578 
1579     /**
1580      * @dev Initializes the domain separator and parameter caches.
1581      *
1582      * The meaning of `name` and `version` is specified in
1583      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1584      *
1585      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1586      * - `version`: the current major version of the signing domain.
1587      *
1588      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1589      * contract upgrade].
1590      */
1591     constructor(string memory name, string memory version) {
1592         bytes32 hashedName = keccak256(bytes(name));
1593         bytes32 hashedVersion = keccak256(bytes(version));
1594         bytes32 typeHash = keccak256(
1595             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1596         );
1597         _HASHED_NAME = hashedName;
1598         _HASHED_VERSION = hashedVersion;
1599         _CACHED_CHAIN_ID = block.chainid;
1600         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1601         _TYPE_HASH = typeHash;
1602     }
1603 
1604     /**
1605      * @dev Returns the domain separator for the current chain.
1606      */
1607     function _domainSeparatorV4() internal view returns (bytes32) {
1608         if (block.chainid == _CACHED_CHAIN_ID) {
1609             return _CACHED_DOMAIN_SEPARATOR;
1610         } else {
1611             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1612         }
1613     }
1614 
1615     function _buildDomainSeparator(
1616         bytes32 typeHash,
1617         bytes32 nameHash,
1618         bytes32 versionHash
1619     ) private view returns (bytes32) {
1620         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1621     }
1622 
1623     /**
1624      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1625      * function returns the hash of the fully encoded EIP712 message for this domain.
1626      *
1627      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1628      *
1629      * ```solidity
1630      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1631      *     keccak256("Mail(address to,string contents)"),
1632      *     mailTo,
1633      *     keccak256(bytes(mailContents))
1634      * )));
1635      * address signer = ECDSA.recover(digest, signature);
1636      * ```
1637      */
1638     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1639         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1640     }
1641 }
1642 
1643 // File: contracts/Yedolegacy.sol
1644 
1645 
1646 pragma solidity ^0.8.0;
1647 
1648 
1649 
1650 
1651 
1652 
1653 contract Yedolegacy is EIP712, ERC721, ERC721Enumerable, Ownable {
1654     using Strings for uint256;
1655 
1656     struct FeesWallets {
1657         address wallet;
1658         uint256 fees;
1659     }
1660 
1661     FeesWallets[] public feesWallets;
1662 
1663     bool public isBaseUrlFrozen = false;
1664     string public unrevealedTokenUri =
1665         "ipfs://QmYo4oUxavCjvwqQgrtNo5CussY4RffmDhNdA1azp8cn2v";
1666     bool public isRevealed = false;
1667     uint256 public startingIndex = 0;
1668 
1669     bool public saleIsActive = false;
1670     bool public whitelistSaleIsActive = false;
1671     bool public freeTokenIsActive = false;
1672     string private _baseURIextended;
1673 
1674     uint256 public tokenPrice = 0.07 ether;
1675 
1676     uint256 public privateDropIndex = 0;
1677 
1678     uint256 public constant MAX_SUPPLY = 4899;
1679     uint256 public constant MAX_PRIVATE_SUPPLY = 50;
1680     uint256 public constant MAX_PUBLIC_MINT_PER_TRANSACTION = 10;
1681     uint256 public constant MAX_PUBLIC_MINT_PER_TRANSACTION_WHITELIST = 7;
1682 
1683     string private constant SIGNING_DOMAIN = "Yedo";
1684     string private constant SIGNATURE_VERSION = "1";
1685 
1686     mapping(address => bool) public freeClaimeds;
1687 
1688     address private whiteListeSigner =
1689         0xaaaaA22ADAC5F89E965e271C33F52e2545A0231e;
1690 
1691     constructor()
1692         ERC721("Yedolegacy", "YLGCY")
1693         EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION)
1694     {
1695         // Smartcontract Dev fees 2.8%
1696         feesWallets.push(
1697             FeesWallets(0xffe6788BE411C4353B3b2c546D0401D4d8B2b3eD, 280)
1698         );
1699 
1700         // Partner Fees 5%
1701         feesWallets.push(
1702             FeesWallets(0x92178Cdcf11E9f77F378503D05415D8BEb9E7bcF, 500)
1703         );
1704     }
1705 
1706     function _beforeTokenTransfer(
1707         address from,
1708         address to,
1709         uint256 tokenId
1710     ) internal override(ERC721, ERC721Enumerable) {
1711         super._beforeTokenTransfer(from, to, tokenId);
1712     }
1713 
1714     function tokenURI(uint256 tokenId)
1715         public
1716         view
1717         override
1718         returns (string memory)
1719     {
1720         require(
1721             _exists(tokenId),
1722             "ERC721Metadata: URI query for nonexistent token"
1723         );
1724         if (!isRevealed) {
1725             return unrevealedTokenUri;
1726         }
1727 
1728         string memory baseURI = _baseURI();
1729         return
1730             bytes(baseURI).length > 0
1731                 ? string(
1732                     abi.encodePacked(
1733                         baseURI,
1734                         ((startingIndex + tokenId) % MAX_SUPPLY).toString()
1735                     )
1736                 )
1737                 : "";
1738     }
1739 
1740     function _baseURI() internal view virtual override returns (string memory) {
1741         return _baseURIextended;
1742     }
1743 
1744     function supportsInterface(bytes4 interfaceId)
1745         public
1746         view
1747         virtual
1748         override(ERC721, ERC721Enumerable)
1749         returns (bool)
1750     {
1751         return super.supportsInterface(interfaceId);
1752     }
1753 
1754     function setTokenPrice(uint256 price_) external onlyOwner {
1755         tokenPrice = price_;
1756     }
1757 
1758     function setWhiteListSigner(address signer) external onlyOwner {
1759         whiteListeSigner = signer;
1760     }
1761 
1762     function freezeBaseUrl() external onlyOwner {
1763         isBaseUrlFrozen = true;
1764     }
1765 
1766     function reveal(string memory baseUrl_) external onlyOwner {
1767         require(!isRevealed);
1768         startingIndex =
1769             uint256(
1770                 keccak256(abi.encodePacked(block.difficulty, block.timestamp))
1771             ) %
1772             MAX_SUPPLY;
1773         _baseURIextended = baseUrl_;
1774         isRevealed = true;
1775     }
1776 
1777     function setUnrevealedURI(string memory unrevealedTokenUri_)
1778         external
1779         onlyOwner
1780     {
1781         unrevealedTokenUri = unrevealedTokenUri_;
1782     }
1783 
1784     function setBaseURI(string memory baseURI_) external onlyOwner {
1785         require(!isBaseUrlFrozen);
1786         _baseURIextended = baseURI_;
1787     }
1788 
1789     function setSaleState(bool newState) public onlyOwner {
1790         saleIsActive = newState;
1791     }
1792 
1793     function setFreeTokensState(bool newState) public onlyOwner {
1794         freeTokenIsActive = newState;
1795     }
1796 
1797     function setWhitelisteSaleState(bool newState) public onlyOwner {
1798         whitelistSaleIsActive = newState;
1799     }
1800 
1801     function addFeesWallet(address wallet, uint256 feesPercentageX100)
1802         public
1803         onlyOwner
1804     {
1805         uint256 totalFees = 0;
1806         for (uint256 i = 0; i < feesWallets.length; i++) {
1807             totalFees += feesWallets[i].fees;
1808         }
1809         require(totalFees + feesPercentageX100 < 10000);
1810         feesWallets.push(FeesWallets(wallet, feesPercentageX100));
1811     }
1812 
1813     function withdraw() external onlyOwner {
1814         uint256 balance = address(this).balance;
1815         for (uint256 i = 0; i < feesWallets.length; i++) {
1816             uint256 fee = (balance * feesWallets[i].fees) / 10000;
1817             // We don't use transfer because any fail would cause funds to be locked forever
1818             payable(feesWallets[i].wallet).call{value: fee}("");
1819         }
1820         payable(msg.sender).call{value: address(this).balance}("");
1821     }
1822 
1823     function buyPrivateTokens(address[] memory _to) public onlyOwner {
1824         uint256 ts = totalSupply();
1825         for (uint256 i = 0; i < _to.length; i++) {
1826             privateDropIndex += 1;
1827             require(privateDropIndex <= MAX_PRIVATE_SUPPLY, "private sale max");
1828             _safeMint(_to[i], ts + i);
1829         }
1830     }
1831 
1832     function buyTokens(uint256 numberOfTokens) public payable {
1833         require(saleIsActive, "sale not open");
1834         require(
1835             numberOfTokens <= MAX_PUBLIC_MINT_PER_TRANSACTION,
1836             "too many token per transaction"
1837         );
1838         applyBuyToken(numberOfTokens);
1839     }
1840 
1841     function applyBuyToken(uint256 numberOfTokens) private {
1842         uint256 ts = totalSupply();
1843         require(ts + numberOfTokens <= MAX_SUPPLY, "not enough supply");
1844         require(
1845             tokenPrice * numberOfTokens <= msg.value,
1846             "invalid ethers sent"
1847         );
1848         for (uint256 i = 0; i < numberOfTokens; i++) {
1849             _safeMint(msg.sender, ts + i);
1850         }
1851     }
1852 
1853     function claimFreeTokens(uint256 numberOfTokens, bytes calldata signature)
1854         public
1855     {
1856         require(freeTokenIsActive, "Free claim not open");
1857         require(freeClaimeds[msg.sender] == false, "already claimed");
1858         verifyFreeSignature(signature, msg.sender, numberOfTokens);
1859         uint256 ts = totalSupply();
1860         require(ts + numberOfTokens <= MAX_SUPPLY, "not enough supply");
1861         freeClaimeds[msg.sender] = true;
1862         for (uint256 i = 0; i < numberOfTokens; i++) {
1863             _safeMint(msg.sender, ts + i);
1864         }
1865     }
1866 
1867     function verifyFreeSignature(
1868         bytes calldata signature,
1869         address targetWallet,
1870         uint256 numberOfTokens
1871     ) internal view {
1872         bytes32 digest = hashFreeSignature(targetWallet, numberOfTokens);
1873         address result = ECDSA.recover(digest, signature);
1874         require(result == whiteListeSigner, "bad signature");
1875     }
1876 
1877     function hashFreeSignature(address targetWallet, uint256 max)
1878         internal
1879         view
1880         returns (bytes32)
1881     {
1882         return
1883             _hashTypedDataV4(
1884                 keccak256(
1885                     abi.encode(
1886                         keccak256("Ticket(address wallet,uint256 max)"),
1887                         targetWallet,
1888                         max
1889                     )
1890                 )
1891             );
1892     }
1893 
1894     function buyTokenWithWhiteList(
1895         uint256 numberOfTokens,
1896         bytes calldata signature
1897     ) public payable {
1898         require(whitelistSaleIsActive, "whitelist sale not open");
1899         require(
1900             numberOfTokens <= MAX_PUBLIC_MINT_PER_TRANSACTION_WHITELIST,
1901             "too many token per transaction"
1902         );
1903         verifyWhitelistSignature(signature, msg.sender);
1904         applyBuyToken(numberOfTokens);
1905     }
1906 
1907     function verifyWhitelistSignature(
1908         bytes calldata signature,
1909         address targetWallet
1910     ) internal view {
1911         bytes32 digest = hashWhitelisteSignature(targetWallet);
1912         address result = ECDSA.recover(digest, signature);
1913         require(result == whiteListeSigner, "bad signature");
1914     }
1915 
1916     function hashWhitelisteSignature(address targetWallet)
1917         internal
1918         view
1919         returns (bytes32)
1920     {
1921         return
1922             _hashTypedDataV4(
1923                 keccak256(
1924                     abi.encode(
1925                         keccak256("Ticket(address wallet)"),
1926                         targetWallet
1927                     )
1928                 )
1929             );
1930     }
1931 }