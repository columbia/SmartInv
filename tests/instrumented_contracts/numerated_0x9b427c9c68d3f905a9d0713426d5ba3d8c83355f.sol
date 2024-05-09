1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
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
174 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
204 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
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
236 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 // File: @openzeppelin/contracts/utils/Context.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         return msg.data;
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/Strings.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev String operations.
489  */
490 library Strings {
491     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
495      */
496     function toString(uint256 value) internal pure returns (string memory) {
497         // Inspired by OraclizeAPI's implementation - MIT licence
498         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
499 
500         if (value == 0) {
501             return "0";
502         }
503         uint256 temp = value;
504         uint256 digits;
505         while (temp != 0) {
506             digits++;
507             temp /= 10;
508         }
509         bytes memory buffer = new bytes(digits);
510         while (value != 0) {
511             digits -= 1;
512             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
513             value /= 10;
514         }
515         return string(buffer);
516     }
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
520      */
521     function toHexString(uint256 value) internal pure returns (string memory) {
522         if (value == 0) {
523             return "0x00";
524         }
525         uint256 temp = value;
526         uint256 length = 0;
527         while (temp != 0) {
528             length++;
529             temp >>= 8;
530         }
531         return toHexString(value, length);
532     }
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
536      */
537     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
538         bytes memory buffer = new bytes(2 * length + 2);
539         buffer[0] = "0";
540         buffer[1] = "x";
541         for (uint256 i = 2 * length + 1; i > 1; --i) {
542             buffer[i] = _HEX_SYMBOLS[value & 0xf];
543             value >>= 4;
544         }
545         require(value == 0, "Strings: hex length insufficient");
546         return string(buffer);
547     }
548 }
549 
550 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Implementation of the {IERC165} interface.
560  *
561  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
562  * for the additional interface id that will be supported. For example:
563  *
564  * ```solidity
565  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
567  * }
568  * ```
569  *
570  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
571  */
572 abstract contract ERC165 is IERC165 {
573     /**
574      * @dev See {IERC165-supportsInterface}.
575      */
576     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577         return interfaceId == type(IERC165).interfaceId;
578     }
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 
590 
591 
592 
593 
594 
595 /**
596  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
597  * the Metadata extension, but not including the Enumerable extension, which is available separately as
598  * {ERC721Enumerable}.
599  */
600 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
601     using Address for address;
602     using Strings for uint256;
603 
604     // Token name
605     string private _name;
606 
607     // Token symbol
608     string private _symbol;
609 
610     // Mapping from token ID to owner address
611     mapping(uint256 => address) private _owners;
612 
613     // Mapping owner address to token count
614     mapping(address => uint256) private _balances;
615 
616     // Mapping from token ID to approved address
617     mapping(uint256 => address) private _tokenApprovals;
618 
619     // Mapping from owner to operator approvals
620     mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622     /**
623      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
624      */
625     constructor(string memory name_, string memory symbol_) {
626         _name = name_;
627         _symbol = symbol_;
628     }
629 
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      */
633     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
634         return
635             interfaceId == type(IERC721).interfaceId ||
636             interfaceId == type(IERC721Metadata).interfaceId ||
637             super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC721-balanceOf}.
642      */
643     function balanceOf(address owner) public view virtual override returns (uint256) {
644         require(owner != address(0), "ERC721: balance query for the zero address");
645         return _balances[owner];
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
652         address owner = _owners[tokenId];
653         require(owner != address(0), "ERC721: owner query for nonexistent token");
654         return owner;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-tokenURI}.
673      */
674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
675         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
676 
677         string memory baseURI = _baseURI();
678         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
679     }
680 
681     /**
682      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
683      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
684      * by default, can be overriden in child contracts.
685      */
686     function _baseURI() internal view virtual returns (string memory) {
687         return "";
688     }
689 
690     /**
691      * @dev See {IERC721-approve}.
692      */
693     function approve(address to, uint256 tokenId) public virtual override {
694         address owner = ERC721.ownerOf(tokenId);
695         require(to != owner, "ERC721: approval to current owner");
696 
697         require(
698             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
699             "ERC721: approve caller is not owner nor approved for all"
700         );
701 
702         _approve(to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-getApproved}.
707      */
708     function getApproved(uint256 tokenId) public view virtual override returns (address) {
709         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
710 
711         return _tokenApprovals[tokenId];
712     }
713 
714     /**
715      * @dev See {IERC721-setApprovalForAll}.
716      */
717     function setApprovalForAll(address operator, bool approved) public virtual override {
718         _setApprovalForAll(_msgSender(), operator, approved);
719     }
720 
721     /**
722      * @dev See {IERC721-isApprovedForAll}.
723      */
724     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
725         return _operatorApprovals[owner][operator];
726     }
727 
728     /**
729      * @dev See {IERC721-transferFrom}.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         //solhint-disable-next-line max-line-length
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738 
739         _transfer(from, to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         safeTransferFrom(from, to, tokenId, "");
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public virtual override {
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
763         _safeTransfer(from, to, tokenId, _data);
764     }
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
768      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
769      *
770      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
771      *
772      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
773      * implement alternative mechanisms to perform token transfer, such as signature-based.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _safeTransfer(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes memory _data
789     ) internal virtual {
790         _transfer(from, to, tokenId);
791         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
792     }
793 
794     /**
795      * @dev Returns whether `tokenId` exists.
796      *
797      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
798      *
799      * Tokens start existing when they are minted (`_mint`),
800      * and stop existing when they are burned (`_burn`).
801      */
802     function _exists(uint256 tokenId) internal view virtual returns (bool) {
803         return _owners[tokenId] != address(0);
804     }
805 
806     /**
807      * @dev Returns whether `spender` is allowed to manage `tokenId`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
814         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
815         address owner = ERC721.ownerOf(tokenId);
816         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
817     }
818 
819     /**
820      * @dev Safely mints `tokenId` and transfers it to `to`.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must not exist.
825      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _safeMint(address to, uint256 tokenId) internal virtual {
830         _safeMint(to, tokenId, "");
831     }
832 
833     /**
834      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
835      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
836      */
837     function _safeMint(
838         address to,
839         uint256 tokenId,
840         bytes memory _data
841     ) internal virtual {
842         _mint(to, tokenId);
843         require(
844             _checkOnERC721Received(address(0), to, tokenId, _data),
845             "ERC721: transfer to non ERC721Receiver implementer"
846         );
847     }
848 
849     /**
850      * @dev Mints `tokenId` and transfers it to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - `to` cannot be the zero address.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _mint(address to, uint256 tokenId) internal virtual {
862         require(to != address(0), "ERC721: mint to the zero address");
863         require(!_exists(tokenId), "ERC721: token already minted");
864 
865         _beforeTokenTransfer(address(0), to, tokenId);
866 
867         _balances[to] += 1;
868         _owners[tokenId] = to;
869 
870         emit Transfer(address(0), to, tokenId);
871     }
872 
873     /**
874      * @dev Destroys `tokenId`.
875      * The approval is cleared when the token is burned.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _burn(uint256 tokenId) internal virtual {
884         address owner = ERC721.ownerOf(tokenId);
885 
886         _beforeTokenTransfer(owner, address(0), tokenId);
887 
888         // Clear approvals
889         _approve(address(0), tokenId);
890 
891         _balances[owner] -= 1;
892         delete _owners[tokenId];
893 
894         emit Transfer(owner, address(0), tokenId);
895     }
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
900      *
901      * Requirements:
902      *
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must be owned by `from`.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _transfer(
909         address from,
910         address to,
911         uint256 tokenId
912     ) internal virtual {
913         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
914         require(to != address(0), "ERC721: transfer to the zero address");
915 
916         _beforeTokenTransfer(from, to, tokenId);
917 
918         // Clear approvals from the previous owner
919         _approve(address(0), tokenId);
920 
921         _balances[from] -= 1;
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev Approve `to` to operate on `tokenId`
930      *
931      * Emits a {Approval} event.
932      */
933     function _approve(address to, uint256 tokenId) internal virtual {
934         _tokenApprovals[tokenId] = to;
935         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
936     }
937 
938     /**
939      * @dev Approve `operator` to operate on all of `owner` tokens
940      *
941      * Emits a {ApprovalForAll} event.
942      */
943     function _setApprovalForAll(
944         address owner,
945         address operator,
946         bool approved
947     ) internal virtual {
948         require(owner != operator, "ERC721: approve to caller");
949         _operatorApprovals[owner][operator] = approved;
950         emit ApprovalForAll(owner, operator, approved);
951     }
952 
953     /**
954      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
955      * The call is not executed if the target address is not a contract.
956      *
957      * @param from address representing the previous owner of the given token ID
958      * @param to target address that will receive the tokens
959      * @param tokenId uint256 ID of the token to be transferred
960      * @param _data bytes optional data to send along with the call
961      * @return bool whether the call correctly returned the expected magic value
962      */
963     function _checkOnERC721Received(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) private returns (bool) {
969         if (to.isContract()) {
970             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
971                 return retval == IERC721Receiver.onERC721Received.selector;
972             } catch (bytes memory reason) {
973                 if (reason.length == 0) {
974                     revert("ERC721: transfer to non ERC721Receiver implementer");
975                 } else {
976                     assembly {
977                         revert(add(32, reason), mload(reason))
978                     }
979                 }
980             }
981         } else {
982             return true;
983         }
984     }
985 
986     /**
987      * @dev Hook that is called before any token transfer. This includes minting
988      * and burning.
989      *
990      * Calling conditions:
991      *
992      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
993      * transferred to `to`.
994      * - When `from` is zero, `tokenId` will be minted for `to`.
995      * - When `to` is zero, ``from``'s `tokenId` will be burned.
996      * - `from` and `to` are never both zero.
997      *
998      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
999      */
1000     function _beforeTokenTransfer(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) internal virtual {}
1005 }
1006 
1007 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1017  * @dev See https://eips.ethereum.org/EIPS/eip-721
1018  */
1019 interface IERC721Enumerable is IERC721 {
1020     /**
1021      * @dev Returns the total amount of tokens stored by the contract.
1022      */
1023     function totalSupply() external view returns (uint256);
1024 
1025     /**
1026      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1027      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1028      */
1029     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1030 
1031     /**
1032      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1033      * Use along with {totalSupply} to enumerate all tokens.
1034      */
1035     function tokenByIndex(uint256 index) external view returns (uint256);
1036 }
1037 
1038 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 
1046 
1047 /**
1048  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1049  * enumerability of all the token ids in the contract as well as all token ids owned by each
1050  * account.
1051  */
1052 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1053     // Mapping from owner to list of owned token IDs
1054     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1055 
1056     // Mapping from token ID to index of the owner tokens list
1057     mapping(uint256 => uint256) private _ownedTokensIndex;
1058 
1059     // Array with all token ids, used for enumeration
1060     uint256[] private _allTokens;
1061 
1062     // Mapping from token id to position in the allTokens array
1063     mapping(uint256 => uint256) private _allTokensIndex;
1064 
1065     /**
1066      * @dev See {IERC165-supportsInterface}.
1067      */
1068     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1069         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1074      */
1075     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1076         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1077         return _ownedTokens[owner][index];
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-totalSupply}.
1082      */
1083     function totalSupply() public view virtual override returns (uint256) {
1084         return _allTokens.length;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Enumerable-tokenByIndex}.
1089      */
1090     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1091         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1092         return _allTokens[index];
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any token transfer. This includes minting
1097      * and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1105      * - `from` cannot be the zero address.
1106      * - `to` cannot be the zero address.
1107      *
1108      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1109      */
1110     function _beforeTokenTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual override {
1115         super._beforeTokenTransfer(from, to, tokenId);
1116 
1117         if (from == address(0)) {
1118             _addTokenToAllTokensEnumeration(tokenId);
1119         } else if (from != to) {
1120             _removeTokenFromOwnerEnumeration(from, tokenId);
1121         }
1122         if (to == address(0)) {
1123             _removeTokenFromAllTokensEnumeration(tokenId);
1124         } else if (to != from) {
1125             _addTokenToOwnerEnumeration(to, tokenId);
1126         }
1127     }
1128 
1129     /**
1130      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1131      * @param to address representing the new owner of the given token ID
1132      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1133      */
1134     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1135         uint256 length = ERC721.balanceOf(to);
1136         _ownedTokens[to][length] = tokenId;
1137         _ownedTokensIndex[tokenId] = length;
1138     }
1139 
1140     /**
1141      * @dev Private function to add a token to this extension's token tracking data structures.
1142      * @param tokenId uint256 ID of the token to be added to the tokens list
1143      */
1144     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1145         _allTokensIndex[tokenId] = _allTokens.length;
1146         _allTokens.push(tokenId);
1147     }
1148 
1149     /**
1150      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1151      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1152      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1153      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1154      * @param from address representing the previous owner of the given token ID
1155      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1156      */
1157     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1158         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1159         // then delete the last slot (swap and pop).
1160 
1161         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1162         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1163 
1164         // When the token to delete is the last token, the swap operation is unnecessary
1165         if (tokenIndex != lastTokenIndex) {
1166             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1167 
1168             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1169             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1170         }
1171 
1172         // This also deletes the contents at the last position of the array
1173         delete _ownedTokensIndex[tokenId];
1174         delete _ownedTokens[from][lastTokenIndex];
1175     }
1176 
1177     /**
1178      * @dev Private function to remove a token from this extension's token tracking data structures.
1179      * This has O(1) time complexity, but alters the order of the _allTokens array.
1180      * @param tokenId uint256 ID of the token to be removed from the tokens list
1181      */
1182     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1183         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1184         // then delete the last slot (swap and pop).
1185 
1186         uint256 lastTokenIndex = _allTokens.length - 1;
1187         uint256 tokenIndex = _allTokensIndex[tokenId];
1188 
1189         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1190         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1191         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1192         uint256 lastTokenId = _allTokens[lastTokenIndex];
1193 
1194         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1195         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1196 
1197         // This also deletes the contents at the last position of the array
1198         delete _allTokensIndex[tokenId];
1199         _allTokens.pop();
1200     }
1201 }
1202 
1203 // File: @openzeppelin/contracts/access/Ownable.sol
1204 
1205 
1206 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 
1211 /**
1212  * @dev Contract module which provides a basic access control mechanism, where
1213  * there is an account (an owner) that can be granted exclusive access to
1214  * specific functions.
1215  *
1216  * By default, the owner account will be the one that deploys the contract. This
1217  * can later be changed with {transferOwnership}.
1218  *
1219  * This module is used through inheritance. It will make available the modifier
1220  * `onlyOwner`, which can be applied to your functions to restrict their use to
1221  * the owner.
1222  */
1223 abstract contract Ownable is Context {
1224     address private _owner;
1225 
1226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1227 
1228     /**
1229      * @dev Initializes the contract setting the deployer as the initial owner.
1230      */
1231     constructor() {
1232         _transferOwnership(_msgSender());
1233     }
1234 
1235     /**
1236      * @dev Returns the address of the current owner.
1237      */
1238     function owner() public view virtual returns (address) {
1239         return _owner;
1240     }
1241 
1242     /**
1243      * @dev Throws if called by any account other than the owner.
1244      */
1245     modifier onlyOwner() {
1246         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1247         _;
1248     }
1249 
1250     /**
1251      * @dev Leaves the contract without owner. It will not be possible to call
1252      * `onlyOwner` functions anymore. Can only be called by the current owner.
1253      *
1254      * NOTE: Renouncing ownership will leave the contract without an owner,
1255      * thereby removing any functionality that is only available to the owner.
1256      */
1257     function renounceOwnership() public virtual onlyOwner {
1258         _transferOwnership(address(0));
1259     }
1260 
1261     /**
1262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1263      * Can only be called by the current owner.
1264      */
1265     function transferOwnership(address newOwner) public virtual onlyOwner {
1266         require(newOwner != address(0), "Ownable: new owner is the zero address");
1267         _transferOwnership(newOwner);
1268     }
1269 
1270     /**
1271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1272      * Internal function without access restriction.
1273      */
1274     function _transferOwnership(address newOwner) internal virtual {
1275         address oldOwner = _owner;
1276         _owner = newOwner;
1277         emit OwnershipTransferred(oldOwner, newOwner);
1278     }
1279 }
1280 
1281 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1282 
1283 
1284 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 /**
1289  * @dev These functions deal with verification of Merkle Trees proofs.
1290  *
1291  * The proofs can be generated using the JavaScript library
1292  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1293  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1294  *
1295  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1296  */
1297 library MerkleProof {
1298     /**
1299      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1300      * defined by `root`. For this, a `proof` must be provided, containing
1301      * sibling hashes on the branch from the leaf to the root of the tree. Each
1302      * pair of leaves and each pair of pre-images are assumed to be sorted.
1303      */
1304     function verify(
1305         bytes32[] memory proof,
1306         bytes32 root,
1307         bytes32 leaf
1308     ) internal pure returns (bool) {
1309         return processProof(proof, leaf) == root;
1310     }
1311 
1312     /**
1313      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1314      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1315      * hash matches the root of the tree. When processing the proof, the pairs
1316      * of leafs & pre-images are assumed to be sorted.
1317      *
1318      * _Available since v4.4._
1319      */
1320     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1321         bytes32 computedHash = leaf;
1322         for (uint256 i = 0; i < proof.length; i++) {
1323             bytes32 proofElement = proof[i];
1324             if (computedHash <= proofElement) {
1325                 // Hash(current computed hash + current element of the proof)
1326                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1327             } else {
1328                 // Hash(current element of the proof + current computed hash)
1329                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1330             }
1331         }
1332         return computedHash;
1333     }
1334 }
1335 
1336 // File: contracts/Metasyndicate.sol
1337 
1338 
1339 pragma solidity ^0.8.0;
1340 
1341 
1342 
1343 
1344 
1345 contract MetasyndicateNft is ERC721Enumerable, Ownable {
1346 
1347     uint public MAX_TOKENS = 7777;
1348     uint public MAX_PRIVATE_TOKENS = 777;
1349     uint public MAX_PRESALE_TOKENS = 1777;
1350     uint public MAX_RESERVED_TOKENS = 446;
1351 
1352     uint public privateSupply;
1353     uint public presaleSupply;
1354     uint public reservedSupply;
1355 
1356     string private _baseURIextended;
1357     bool public publicIsActive = false;
1358     bool public presaleIsActive = false;
1359     bool public privateIsActive = true;
1360     bool public merkleWhitelist = true;
1361 
1362     uint public publicMaxTokenPurchase = 20;
1363     
1364     uint256 public publicPrice = 200000000000000000; //0.2
1365     uint256 public presalePrice = 150000000000000000; //0.15
1366     uint256 public privatePrice = 100000000000000000; //0.1
1367 
1368     bytes32 public PRESALE_MERKLE_ROOT = "";
1369     
1370     constructor() ERC721("MetaSyndicate", "MSYN") {
1371 
1372     }
1373 
1374     function publicMint(uint numberOfTokens) public payable {
1375         require(publicIsActive, "Public sale must be active to mint NFTs");
1376         require(numberOfTokens <= publicMaxTokenPurchase, "Exceeded the max token purchase");
1377         require(publicPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1378         require(totalSupply() + numberOfTokens <= MAX_TOKENS - MAX_RESERVED_TOKENS, "Purchase would exceed max supply of tokens");
1379         for(uint i = 0; i < numberOfTokens; i++) {
1380             uint mintIndex = totalSupply() + 1;
1381             _safeMint(msg.sender, mintIndex);
1382         }
1383     }
1384 
1385     function presaleMint(bytes32[] calldata _merkleProof, uint numberOfTokens) public payable {
1386         require(presaleIsActive, "Presale sale must be active to mint NFTs");
1387         require(numberOfTokens <= publicMaxTokenPurchase, "Exceeded max token purchase");
1388         require(presalePrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1389         require(totalSupply() + numberOfTokens <= MAX_TOKENS - MAX_RESERVED_TOKENS, "Purchase would exceed max supply of total tokens");
1390         require(presaleSupply + numberOfTokens <= MAX_PRESALE_TOKENS, "Purchase would exceed max supply of presale tokens");
1391 
1392         if (merkleWhitelist) {
1393             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1394             require(MerkleProof.verify(_merkleProof, PRESALE_MERKLE_ROOT, leaf), "Invalid Proof");
1395         }
1396 
1397         for(uint i = 0; i < numberOfTokens; i++) {
1398             uint mintIndex = totalSupply() + 1;
1399             presaleSupply = presaleSupply + 1;
1400             _safeMint(msg.sender, mintIndex);
1401         }
1402     }
1403 
1404     function privateMint(uint numberOfTokens) public payable {
1405         require(privateIsActive, "Private sale must be active to mint NFTs");
1406         require(privatePrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1407         require(privateSupply + numberOfTokens <= MAX_PRIVATE_TOKENS, "Purchase would exceed max supply of tokens");
1408         for(uint i = 0; i < numberOfTokens; i++) {
1409             uint mintIndex = totalSupply() + 1;
1410             privateSupply = privateSupply + 1;
1411             _safeMint(msg.sender, mintIndex);
1412         }
1413     }
1414 
1415     function airdropNft(address userAddress, uint numberOfTokens) public onlyOwner {
1416         require(reservedSupply + numberOfTokens <= MAX_RESERVED_TOKENS, "Purchase would exceed max supply of total tokens");
1417         for(uint i = 0; i < numberOfTokens; i++) {
1418             uint mintIndex = totalSupply() + 1;
1419             reservedSupply = reservedSupply + 1;
1420             _safeMint(userAddress, mintIndex);
1421         }
1422     }
1423 
1424     function setBaseURI(string memory baseURI_) public onlyOwner() {
1425         _baseURIextended = baseURI_;
1426     }
1427 
1428     function _baseURI() internal view virtual override returns (string memory) {
1429         return _baseURIextended;
1430     }
1431 
1432     function flipPublicMintState() public onlyOwner {
1433         publicIsActive = !publicIsActive;
1434     }
1435 
1436     function flipPresaleMintState() public onlyOwner {
1437         presaleIsActive = !presaleIsActive;
1438     }
1439 
1440     function flipPrivateMintState() public onlyOwner {
1441         privateIsActive = !privateIsActive;
1442     }
1443 
1444     function flipMerkleState() public onlyOwner {
1445         merkleWhitelist = !merkleWhitelist;
1446     }
1447 
1448     function changePresaleMerkleRoot(bytes32 presaleMerkleRoot) public onlyOwner {
1449         PRESALE_MERKLE_ROOT = presaleMerkleRoot;
1450     }
1451 
1452     function getHolderTokens(address _owner) public view virtual returns (uint256[] memory) {
1453         uint256 tokenCount = balanceOf(_owner);
1454         uint256[] memory tokensId = new uint256[](tokenCount);
1455         for(uint256 i; i < tokenCount; i++){
1456             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1457         }
1458         return tokensId;
1459     }
1460 
1461     function withdraw() public onlyOwner {
1462         payable(msg.sender).transfer(address(this).balance);
1463     }
1464 }