1 // SPDX-License-Identifier: MIT AND GPL-3.0
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
174 
175 
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @title ERC721 token receiver interface
181  * @dev Interface for any contract that wants to support safeTransfers
182  * from ERC721 asset contracts.
183  */
184 interface IERC721Receiver {
185     /**
186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
187      * by `operator` from `from`, this function is called.
188      *
189      * It must return its Solidity selector to confirm the token transfer.
190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
191      *
192      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
193      */
194     function onERC721Received(
195         address operator,
196         address from,
197         uint256 tokenId,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
203 
204 
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 // File: @openzeppelin/contracts/utils/Address.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // This method relies on extcodesize, which returns 0 for contracts in
259         // construction, since the code is only stored at the end of the
260         // constructor execution.
261 
262         uint256 size;
263         assembly {
264             size := extcodesize(account)
265         }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         (bool success, ) = recipient.call{value: amount}("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.call{value: value}(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
373         return functionStaticCall(target, data, "Address: low-level static call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.staticcall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(isContract(target), "Address: delegate call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
422      * revert reason using the provided one.
423      *
424      * _Available since v4.3._
425      */
426     function verifyCallResult(
427         bool success,
428         bytes memory returndata,
429         string memory errorMessage
430     ) internal pure returns (bytes memory) {
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/utils/Context.sol
450 
451 
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Provides information about the current execution context, including the
457  * sender of the transaction and its data. While these are generally available
458  * via msg.sender and msg.data, they should not be accessed in such a direct
459  * manner, since when dealing with meta-transactions the account sending and
460  * paying for execution may not be the actual sender (as far as an application
461  * is concerned).
462  *
463  * This contract is only required for intermediate, library-like contracts.
464  */
465 abstract contract Context {
466     function _msgSender() internal view virtual returns (address) {
467         return msg.sender;
468     }
469 
470     function _msgData() internal view virtual returns (bytes calldata) {
471         return msg.data;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/utils/Strings.sol
476 
477 
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev String operations.
483  */
484 library Strings {
485     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
489      */
490     function toString(uint256 value) internal pure returns (string memory) {
491         // Inspired by OraclizeAPI's implementation - MIT licence
492         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
493 
494         if (value == 0) {
495             return "0";
496         }
497         uint256 temp = value;
498         uint256 digits;
499         while (temp != 0) {
500             digits++;
501             temp /= 10;
502         }
503         bytes memory buffer = new bytes(digits);
504         while (value != 0) {
505             digits -= 1;
506             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
507             value /= 10;
508         }
509         return string(buffer);
510     }
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
514      */
515     function toHexString(uint256 value) internal pure returns (string memory) {
516         if (value == 0) {
517             return "0x00";
518         }
519         uint256 temp = value;
520         uint256 length = 0;
521         while (temp != 0) {
522             length++;
523             temp >>= 8;
524         }
525         return toHexString(value, length);
526     }
527 
528     /**
529      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
530      */
531     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
532         bytes memory buffer = new bytes(2 * length + 2);
533         buffer[0] = "0";
534         buffer[1] = "x";
535         for (uint256 i = 2 * length + 1; i > 1; --i) {
536             buffer[i] = _HEX_SYMBOLS[value & 0xf];
537             value >>= 4;
538         }
539         require(value == 0, "Strings: hex length insufficient");
540         return string(buffer);
541     }
542 }
543 
544 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * ```solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * ```
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570         return interfaceId == type(IERC165).interfaceId;
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
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
586 
587 /**
588  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
589  * the Metadata extension, but not including the Enumerable extension, which is available separately as
590  * {ERC721Enumerable}.
591  */
592 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
593     using Address for address;
594     using Strings for uint256;
595 
596     // Token name
597     string private _name;
598 
599     // Token symbol
600     string private _symbol;
601 
602     // Mapping from token ID to owner address
603     mapping(uint256 => address) private _owners;
604 
605     // Mapping owner address to token count
606     mapping(address => uint256) private _balances;
607 
608     // Mapping from token ID to approved address
609     mapping(uint256 => address) private _tokenApprovals;
610 
611     // Mapping from owner to operator approvals
612     mapping(address => mapping(address => bool)) private _operatorApprovals;
613 
614     /**
615      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
616      */
617     constructor(string memory name_, string memory symbol_) {
618         _name = name_;
619         _symbol = symbol_;
620     }
621 
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
626         return
627             interfaceId == type(IERC721).interfaceId ||
628             interfaceId == type(IERC721Metadata).interfaceId ||
629             super.supportsInterface(interfaceId);
630     }
631 
632     /**
633      * @dev See {IERC721-balanceOf}.
634      */
635     function balanceOf(address owner) public view virtual override returns (uint256) {
636         require(owner != address(0), "ERC721: balance query for the zero address");
637         return _balances[owner];
638     }
639 
640     /**
641      * @dev See {IERC721-ownerOf}.
642      */
643     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
644         address owner = _owners[tokenId];
645         require(owner != address(0), "ERC721: owner query for nonexistent token");
646         return owner;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-name}.
651      */
652     function name() public view virtual override returns (string memory) {
653         return _name;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-symbol}.
658      */
659     function symbol() public view virtual override returns (string memory) {
660         return _symbol;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-tokenURI}.
665      */
666     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
667         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
668 
669         string memory baseURI = _baseURI();
670         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
671     }
672 
673     /**
674      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
675      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
676      * by default, can be overriden in child contracts.
677      */
678     function _baseURI() internal view virtual returns (string memory) {
679         return "";
680     }
681 
682     /**
683      * @dev See {IERC721-approve}.
684      */
685     function approve(address to, uint256 tokenId) public virtual override {
686         address owner = ERC721.ownerOf(tokenId);
687         require(to != owner, "ERC721: approval to current owner");
688 
689         require(
690             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
691             "ERC721: approve caller is not owner nor approved for all"
692         );
693 
694         _approve(to, tokenId);
695     }
696 
697     /**
698      * @dev See {IERC721-getApproved}.
699      */
700     function getApproved(uint256 tokenId) public view virtual override returns (address) {
701         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
702 
703         return _tokenApprovals[tokenId];
704     }
705 
706     /**
707      * @dev See {IERC721-setApprovalForAll}.
708      */
709     function setApprovalForAll(address operator, bool approved) public virtual override {
710         require(operator != _msgSender(), "ERC721: approve to caller");
711 
712         _operatorApprovals[_msgSender()][operator] = approved;
713         emit ApprovalForAll(_msgSender(), operator, approved);
714     }
715 
716     /**
717      * @dev See {IERC721-isApprovedForAll}.
718      */
719     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
720         return _operatorApprovals[owner][operator];
721     }
722 
723     /**
724      * @dev See {IERC721-transferFrom}.
725      */
726     function transferFrom(
727         address from,
728         address to,
729         uint256 tokenId
730     ) public virtual override {
731         //solhint-disable-next-line max-line-length
732         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
733 
734         _transfer(from, to, tokenId);
735     }
736 
737     /**
738      * @dev See {IERC721-safeTransferFrom}.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         safeTransferFrom(from, to, tokenId, "");
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes memory _data
756     ) public virtual override {
757         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
758         _safeTransfer(from, to, tokenId, _data);
759     }
760 
761     /**
762      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
763      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
764      *
765      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
766      *
767      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
768      * implement alternative mechanisms to perform token transfer, such as signature-based.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _safeTransfer(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) internal virtual {
785         _transfer(from, to, tokenId);
786         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
787     }
788 
789     /**
790      * @dev Returns whether `tokenId` exists.
791      *
792      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
793      *
794      * Tokens start existing when they are minted (`_mint`),
795      * and stop existing when they are burned (`_burn`).
796      */
797     function _exists(uint256 tokenId) internal view virtual returns (bool) {
798         return _owners[tokenId] != address(0);
799     }
800 
801     /**
802      * @dev Returns whether `spender` is allowed to manage `tokenId`.
803      *
804      * Requirements:
805      *
806      * - `tokenId` must exist.
807      */
808     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
809         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
810         address owner = ERC721.ownerOf(tokenId);
811         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
812     }
813 
814     /**
815      * @dev Safely mints `tokenId` and transfers it to `to`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must not exist.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _safeMint(address to, uint256 tokenId) internal virtual {
825         _safeMint(to, tokenId, "");
826     }
827 
828     /**
829      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
830      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
831      */
832     function _safeMint(
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) internal virtual {
837         _mint(to, tokenId);
838         require(
839             _checkOnERC721Received(address(0), to, tokenId, _data),
840             "ERC721: transfer to non ERC721Receiver implementer"
841         );
842     }
843 
844     /**
845      * @dev Mints `tokenId` and transfers it to `to`.
846      *
847      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
848      *
849      * Requirements:
850      *
851      * - `tokenId` must not exist.
852      * - `to` cannot be the zero address.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _mint(address to, uint256 tokenId) internal virtual {
857         require(to != address(0), "ERC721: mint to the zero address");
858         require(!_exists(tokenId), "ERC721: token already minted");
859 
860         _beforeTokenTransfer(address(0), to, tokenId);
861 
862         _balances[to] += 1;
863         _owners[tokenId] = to;
864 
865         emit Transfer(address(0), to, tokenId);
866     }
867 
868     /**
869      * @dev Destroys `tokenId`.
870      * The approval is cleared when the token is burned.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _burn(uint256 tokenId) internal virtual {
879         address owner = ERC721.ownerOf(tokenId);
880 
881         _beforeTokenTransfer(owner, address(0), tokenId);
882 
883         // Clear approvals
884         _approve(address(0), tokenId);
885 
886         _balances[owner] -= 1;
887         delete _owners[tokenId];
888 
889         emit Transfer(owner, address(0), tokenId);
890     }
891 
892     /**
893      * @dev Transfers `tokenId` from `from` to `to`.
894      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
895      *
896      * Requirements:
897      *
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must be owned by `from`.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _transfer(
904         address from,
905         address to,
906         uint256 tokenId
907     ) internal virtual {
908         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
909         require(to != address(0), "ERC721: transfer to the zero address");
910 
911         _beforeTokenTransfer(from, to, tokenId);
912 
913         // Clear approvals from the previous owner
914         _approve(address(0), tokenId);
915 
916         _balances[from] -= 1;
917         _balances[to] += 1;
918         _owners[tokenId] = to;
919 
920         emit Transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev Approve `to` to operate on `tokenId`
925      *
926      * Emits a {Approval} event.
927      */
928     function _approve(address to, uint256 tokenId) internal virtual {
929         _tokenApprovals[tokenId] = to;
930         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
931     }
932 
933     /**
934      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
935      * The call is not executed if the target address is not a contract.
936      *
937      * @param from address representing the previous owner of the given token ID
938      * @param to target address that will receive the tokens
939      * @param tokenId uint256 ID of the token to be transferred
940      * @param _data bytes optional data to send along with the call
941      * @return bool whether the call correctly returned the expected magic value
942      */
943     function _checkOnERC721Received(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) private returns (bool) {
949         if (to.isContract()) {
950             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
951                 return retval == IERC721Receiver.onERC721Received.selector;
952             } catch (bytes memory reason) {
953                 if (reason.length == 0) {
954                     revert("ERC721: transfer to non ERC721Receiver implementer");
955                 } else {
956                     assembly {
957                         revert(add(32, reason), mload(reason))
958                     }
959                 }
960             }
961         } else {
962             return true;
963         }
964     }
965 
966     /**
967      * @dev Hook that is called before any token transfer. This includes minting
968      * and burning.
969      *
970      * Calling conditions:
971      *
972      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
973      * transferred to `to`.
974      * - When `from` is zero, `tokenId` will be minted for `to`.
975      * - When `to` is zero, ``from``'s `tokenId` will be burned.
976      * - `from` and `to` are never both zero.
977      *
978      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
979      */
980     function _beforeTokenTransfer(
981         address from,
982         address to,
983         uint256 tokenId
984     ) internal virtual {}
985 }
986 
987 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
988 
989 
990 
991 pragma solidity ^0.8.0;
992 
993 
994 /**
995  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
996  * @dev See https://eips.ethereum.org/EIPS/eip-721
997  */
998 interface IERC721Enumerable is IERC721 {
999     /**
1000      * @dev Returns the total amount of tokens stored by the contract.
1001      */
1002     function totalSupply() external view returns (uint256);
1003 
1004     /**
1005      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1006      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1007      */
1008     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1009 
1010     /**
1011      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1012      * Use along with {totalSupply} to enumerate all tokens.
1013      */
1014     function tokenByIndex(uint256 index) external view returns (uint256);
1015 }
1016 
1017 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1018 
1019 
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 
1025 /**
1026  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1027  * enumerability of all the token ids in the contract as well as all token ids owned by each
1028  * account.
1029  */
1030 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1031     // Mapping from owner to list of owned token IDs
1032     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1033 
1034     // Mapping from token ID to index of the owner tokens list
1035     mapping(uint256 => uint256) private _ownedTokensIndex;
1036 
1037     // Array with all token ids, used for enumeration
1038     uint256[] private _allTokens;
1039 
1040     // Mapping from token id to position in the allTokens array
1041     mapping(uint256 => uint256) private _allTokensIndex;
1042 
1043     /**
1044      * @dev See {IERC165-supportsInterface}.
1045      */
1046     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1047         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1052      */
1053     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1054         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1055         return _ownedTokens[owner][index];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-totalSupply}.
1060      */
1061     function totalSupply() public view virtual override returns (uint256) {
1062         return _allTokens.length;
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenByIndex}.
1067      */
1068     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1070         return _allTokens[index];
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any token transfer. This includes minting
1075      * and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` will be minted for `to`.
1082      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual override {
1093         super._beforeTokenTransfer(from, to, tokenId);
1094 
1095         if (from == address(0)) {
1096             _addTokenToAllTokensEnumeration(tokenId);
1097         } else if (from != to) {
1098             _removeTokenFromOwnerEnumeration(from, tokenId);
1099         }
1100         if (to == address(0)) {
1101             _removeTokenFromAllTokensEnumeration(tokenId);
1102         } else if (to != from) {
1103             _addTokenToOwnerEnumeration(to, tokenId);
1104         }
1105     }
1106 
1107     /**
1108      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1109      * @param to address representing the new owner of the given token ID
1110      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1111      */
1112     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1113         uint256 length = ERC721.balanceOf(to);
1114         _ownedTokens[to][length] = tokenId;
1115         _ownedTokensIndex[tokenId] = length;
1116     }
1117 
1118     /**
1119      * @dev Private function to add a token to this extension's token tracking data structures.
1120      * @param tokenId uint256 ID of the token to be added to the tokens list
1121      */
1122     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1123         _allTokensIndex[tokenId] = _allTokens.length;
1124         _allTokens.push(tokenId);
1125     }
1126 
1127     /**
1128      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1129      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1130      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1131      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1132      * @param from address representing the previous owner of the given token ID
1133      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1134      */
1135     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1136         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1137         // then delete the last slot (swap and pop).
1138 
1139         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1140         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1141 
1142         // When the token to delete is the last token, the swap operation is unnecessary
1143         if (tokenIndex != lastTokenIndex) {
1144             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1145 
1146             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1147             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1148         }
1149 
1150         // This also deletes the contents at the last position of the array
1151         delete _ownedTokensIndex[tokenId];
1152         delete _ownedTokens[from][lastTokenIndex];
1153     }
1154 
1155     /**
1156      * @dev Private function to remove a token from this extension's token tracking data structures.
1157      * This has O(1) time complexity, but alters the order of the _allTokens array.
1158      * @param tokenId uint256 ID of the token to be removed from the tokens list
1159      */
1160     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1161         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1162         // then delete the last slot (swap and pop).
1163 
1164         uint256 lastTokenIndex = _allTokens.length - 1;
1165         uint256 tokenIndex = _allTokensIndex[tokenId];
1166 
1167         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1168         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1169         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1170         uint256 lastTokenId = _allTokens[lastTokenIndex];
1171 
1172         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1173         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1174 
1175         // This also deletes the contents at the last position of the array
1176         delete _allTokensIndex[tokenId];
1177         _allTokens.pop();
1178     }
1179 }
1180 
1181 // File: @openzeppelin/contracts/access/Ownable.sol
1182 
1183 
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 
1188 /**
1189  * @dev Contract module which provides a basic access control mechanism, where
1190  * there is an account (an owner) that can be granted exclusive access to
1191  * specific functions.
1192  *
1193  * By default, the owner account will be the one that deploys the contract. This
1194  * can later be changed with {transferOwnership}.
1195  *
1196  * This module is used through inheritance. It will make available the modifier
1197  * `onlyOwner`, which can be applied to your functions to restrict their use to
1198  * the owner.
1199  */
1200 abstract contract Ownable is Context {
1201     address private _owner;
1202 
1203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1204 
1205     /**
1206      * @dev Initializes the contract setting the deployer as the initial owner.
1207      */
1208     constructor() {
1209         _setOwner(_msgSender());
1210     }
1211 
1212     /**
1213      * @dev Returns the address of the current owner.
1214      */
1215     function owner() public view virtual returns (address) {
1216         return _owner;
1217     }
1218 
1219     /**
1220      * @dev Throws if called by any account other than the owner.
1221      */
1222     modifier onlyOwner() {
1223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _setOwner(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _setOwner(newOwner);
1245     }
1246 
1247     function _setOwner(address newOwner) private {
1248         address oldOwner = _owner;
1249         _owner = newOwner;
1250         emit OwnershipTransferred(oldOwner, newOwner);
1251     }
1252 }
1253 
1254 // File: contracts/PicklePunk.sol
1255 
1256 pragma solidity >=0.7.0 <0.9.0;
1257 
1258 
1259 
1260 contract PicklePunk is ERC721Enumerable, Ownable {
1261   using Strings for uint256;
1262   string private baseURI;
1263   string public baseExtension = ".json";
1264   string public notRevealedUri;
1265   uint256 public preSaleCost = 0.1 ether;
1266   uint256 public cost = 0.2 ether;
1267   uint256 public maxSupply = 9999;
1268   uint256 public preSaleMaxSupply = 4250;
1269   uint256 public maxMintAmountPresale = 2;
1270   uint256 public maxMintAmount = 10;
1271   uint256 public nftPerAddressLimitPresale = 2;
1272   uint256 public nftPerAddressLimit = 100;
1273   uint256 public preSaleDate = 1638306000;
1274   uint256 public preSaleEndDate = 1638392400;
1275   uint256 public publicSaleDate = 1638410400;
1276   bool public paused = false;
1277   bool public revealed = false;
1278   mapping(address => bool) whitelistedAddresses;
1279   mapping(address => uint256) public addressMintedBalance;
1280 
1281   constructor(
1282     string memory _name,
1283     string memory _symbol,
1284     string memory _initNotRevealedUri
1285   ) ERC721(_name, _symbol) {
1286     setNotRevealedURI(_initNotRevealedUri);
1287   }
1288 
1289   //MODIFIERS
1290   modifier notPaused {
1291     require(!paused, "the contract is paused");
1292     _;
1293   }
1294 
1295   modifier saleStarted {
1296     require(block.timestamp >= preSaleDate, "Sale has not started yet");
1297     _;
1298   }
1299 
1300   modifier minimumMintAmount(uint256 _mintAmount) {
1301     require(_mintAmount > 0, "need to mint at least 1 NFT");
1302     _;
1303   }
1304 
1305   // INTERNAL
1306   function _baseURI() internal view virtual override returns (string memory) {
1307     return baseURI;
1308   }
1309 
1310   function presaleValidations(
1311     uint256 _ownerMintedCount,
1312     uint256 _mintAmount,
1313     uint256 _supply
1314   ) internal {
1315     uint256 actualCost;
1316     block.timestamp < preSaleEndDate
1317       ? actualCost = preSaleCost
1318       : actualCost = cost;
1319     require(isWhitelisted(msg.sender), "user is not whitelisted");
1320     require(
1321       _ownerMintedCount + _mintAmount <= nftPerAddressLimitPresale,
1322       "max NFT per address exceeded for presale"
1323     );
1324     require(msg.value >= actualCost * _mintAmount, "insufficient funds");
1325     require(
1326       _mintAmount <= maxMintAmountPresale,
1327       "max mint amount per transaction exceeded"
1328     );
1329     require(
1330       _supply + _mintAmount <= preSaleMaxSupply,
1331       "max NFT presale limit exceeded"
1332     );
1333   }
1334 
1335   function publicsaleValidations(uint256 _ownerMintedCount, uint256 _mintAmount)
1336     internal
1337   {
1338     require(
1339       _ownerMintedCount + _mintAmount <= nftPerAddressLimit,
1340       "max NFT per address exceeded"
1341     );
1342     require(msg.value >= cost * _mintAmount, "insufficient funds");
1343     require(
1344       _mintAmount <= maxMintAmount,
1345       "max mint amount per transaction exceeded"
1346     );
1347   }
1348 
1349   //MINT
1350   function mint(uint256 _mintAmount)
1351     public
1352     payable
1353     notPaused
1354     saleStarted
1355     minimumMintAmount(_mintAmount)
1356   {
1357     uint256 supply = totalSupply();
1358     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1359 
1360     //Do some validations depending on which step of the sale we are in
1361     block.timestamp < publicSaleDate
1362       ? presaleValidations(ownerMintedCount, _mintAmount, supply)
1363       : publicsaleValidations(ownerMintedCount, _mintAmount);
1364 
1365     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1366 
1367     for (uint256 i = 1; i <= _mintAmount; i++) {
1368       addressMintedBalance[msg.sender]++;
1369       _safeMint(msg.sender, supply + i);
1370     }
1371   }
1372 
1373   function gift(uint256 _mintAmount, address destination) public onlyOwner {
1374     require(_mintAmount > 0, "need to mint at least 1 NFT");
1375     uint256 supply = totalSupply();
1376     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1377 
1378     for (uint256 i = 1; i <= _mintAmount; i++) {
1379       addressMintedBalance[destination]++;
1380       _safeMint(destination, supply + i);
1381     }
1382   }
1383 
1384   //PUBLIC VIEWS
1385   function isWhitelisted(address _user) public view returns (bool) {
1386     return whitelistedAddresses[_user];
1387   }
1388 
1389   function walletOfOwner(address _owner)
1390     public
1391     view
1392     returns (uint256[] memory)
1393   {
1394     uint256 ownerTokenCount = balanceOf(_owner);
1395     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1396     for (uint256 i; i < ownerTokenCount; i++) {
1397       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1398     }
1399     return tokenIds;
1400   }
1401 
1402   function tokenURI(uint256 tokenId)
1403     public
1404     view
1405     virtual
1406     override
1407     returns (string memory)
1408   {
1409     require(
1410       _exists(tokenId),
1411       "ERC721Metadata: URI query for nonexistent token"
1412     );
1413 
1414     if (!revealed) {
1415       return notRevealedUri;
1416     } else {
1417       string memory currentBaseURI = _baseURI();
1418       return
1419         bytes(currentBaseURI).length > 0
1420           ? string(
1421             abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
1422           )
1423           : "";
1424     }
1425   }
1426 
1427   function getCurrentCost() public view returns (uint256) {
1428     if (block.timestamp < preSaleEndDate) {
1429       return preSaleCost;
1430     } else {
1431       return cost;
1432     }
1433   }
1434 
1435   //ONLY OWNER VIEWS
1436   function getBaseURI() public view onlyOwner returns (string memory) {
1437     return baseURI;
1438   }
1439 
1440   function getContractBalance() public view onlyOwner returns (uint256) {
1441     return address(this).balance;
1442   }
1443 
1444   //ONLY OWNER SETTERS
1445   function reveal() public onlyOwner {
1446     revealed = true;
1447   }
1448 
1449   function pause(bool _state) public onlyOwner {
1450     paused = _state;
1451   }
1452 
1453   function setNftPerAddressLimitPreSale(uint256 _limit) public onlyOwner {
1454     nftPerAddressLimitPresale = _limit;
1455   }
1456 
1457   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1458     nftPerAddressLimit = _limit;
1459   }
1460 
1461   function setPresaleCost(uint256 _newCost) public onlyOwner {
1462     preSaleCost = _newCost;
1463   }
1464 
1465   function setCost(uint256 _newCost) public onlyOwner {
1466     cost = _newCost;
1467   }
1468 
1469   function setmaxMintAmountPreSale(uint256 _newmaxMintAmount) public onlyOwner {
1470     maxMintAmountPresale = _newmaxMintAmount;
1471   }
1472 
1473   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1474     maxMintAmount = _newmaxMintAmount;
1475   }
1476 
1477   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1478     baseURI = _newBaseURI;
1479   }
1480 
1481   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1482     baseExtension = _newBaseExtension;
1483   }
1484 
1485   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1486     notRevealedUri = _notRevealedURI;
1487   }
1488 
1489   function setPresaleMaxSupply(uint256 _newPresaleMaxSupply) public onlyOwner {
1490     preSaleMaxSupply = _newPresaleMaxSupply;
1491   }
1492 
1493   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1494     maxSupply = _maxSupply;
1495   }
1496 
1497   function setPreSaleDate(uint256 _preSaleDate) public onlyOwner {
1498     preSaleDate = _preSaleDate;
1499   }
1500 
1501   function setPreSaleEndDate(uint256 _preSaleEndDate) public onlyOwner {
1502     preSaleEndDate = _preSaleEndDate;
1503   }
1504 
1505   function setPublicSaleDate(uint256 _publicSaleDate) public onlyOwner {
1506     publicSaleDate = _publicSaleDate;
1507   }
1508 
1509   function whitelistUsers(address[] memory addresses) public onlyOwner {
1510     for (uint256 i = 0; i < addresses.length; i++) {
1511       whitelistedAddresses[addresses[i]] = true;
1512     }
1513   }
1514 
1515   function withdraw() public payable onlyOwner {
1516     (bool success, ) = payable(msg.sender).call{ value: address(this).balance }(
1517       ""
1518     );
1519     require(success);
1520   }
1521 }