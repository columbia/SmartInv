1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 // "SPDX-License-Identifier: UNLICENSED"
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC165 standard, as defined in the
14  * https://eips.ethereum.org/EIPS/eip-165[EIP].
15  *
16  * Implementers can declare support of contract interfaces, which can then be
17  * queried by others ({ERC165Checker}).
18  *
19  * For an implementation, see {ERC165}.
20  */
21 interface IERC165 {
22     /**
23      * @dev Returns true if this contract implements the interface defined by
24      * `interfaceId`. See the corresponding
25      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 
34 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
35 
36 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
178 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 
236 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // This method relies on extcodesize, which returns 0 for contracts in
265         // construction, since the code is only stored at the end of the
266         // constructor execution.
267 
268         uint256 size;
269         assembly {
270             size := extcodesize(account)
271         }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         (bool success, ) = recipient.call{value: amount}("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain `call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317         return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         require(isContract(target), "Address: call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.call{value: value}(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379         return functionStaticCall(target, data, "Address: low-level static call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal view returns (bytes memory) {
393         require(isContract(target), "Address: static call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.staticcall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(isContract(target), "Address: delegate call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.delegatecall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
428      * revert reason using the provided one.
429      *
430      * _Available since v4.3._
431      */
432     function verifyCallResult(
433         bool success,
434         bytes memory returndata,
435         string memory errorMessage
436     ) internal pure returns (bytes memory) {
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443 
444                 assembly {
445                     let returndata_size := mload(returndata)
446                     revert(add(32, returndata), returndata_size)
447                 }
448             } else {
449                 revert(errorMessage);
450             }
451         }
452     }
453 }
454 
455 
456 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 /**
463  * @dev Provides information about the current execution context, including the
464  * sender of the transaction and its data. While these are generally available
465  * via msg.sender and msg.data, they should not be accessed in such a direct
466  * manner, since when dealing with meta-transactions the account sending and
467  * paying for execution may not be the actual sender (as far as an application
468  * is concerned).
469  *
470  * This contract is only required for intermediate, library-like contracts.
471  */
472 abstract contract Context {
473     function _msgSender() internal view virtual returns (address) {
474         return msg.sender;
475     }
476 
477     function _msgData() internal view virtual returns (bytes calldata) {
478         return msg.data;
479     }
480 }
481 
482 
483 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev String operations.
491  */
492 library Strings {
493     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
494 
495     /**
496      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
497      */
498     function toString(uint256 value) internal pure returns (string memory) {
499         // Inspired by OraclizeAPI's implementation - MIT licence
500         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
501 
502         if (value == 0) {
503             return "0";
504         }
505         uint256 temp = value;
506         uint256 digits;
507         while (temp != 0) {
508             digits++;
509             temp /= 10;
510         }
511         bytes memory buffer = new bytes(digits);
512         while (value != 0) {
513             digits -= 1;
514             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
515             value /= 10;
516         }
517         return string(buffer);
518     }
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
522      */
523     function toHexString(uint256 value) internal pure returns (string memory) {
524         if (value == 0) {
525             return "0x00";
526         }
527         uint256 temp = value;
528         uint256 length = 0;
529         while (temp != 0) {
530             length++;
531             temp >>= 8;
532         }
533         return toHexString(value, length);
534     }
535 
536     /**
537      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
538      */
539     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
540         bytes memory buffer = new bytes(2 * length + 2);
541         buffer[0] = "0";
542         buffer[1] = "x";
543         for (uint256 i = 2 * length + 1; i > 1; --i) {
544             buffer[i] = _HEX_SYMBOLS[value & 0xf];
545             value >>= 4;
546         }
547         require(value == 0, "Strings: hex length insufficient");
548         return string(buffer);
549     }
550 }
551 
552 
553 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev Implementation of the {IERC165} interface.
561  *
562  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
563  * for the additional interface id that will be supported. For example:
564  *
565  * ```solidity
566  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
568  * }
569  * ```
570  *
571  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
572  */
573 abstract contract ERC165 is IERC165 {
574     /**
575      * @dev See {IERC165-supportsInterface}.
576      */
577     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578         return interfaceId == type(IERC165).interfaceId;
579     }
580 }
581 
582 
583 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.1
584 
585 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
586 
587 pragma solidity ^0.8.0;
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
1007 
1008 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
1009 
1010 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 /**
1015  * @dev Contract module which provides a basic access control mechanism, where
1016  * there is an account (an owner) that can be granted exclusive access to
1017  * specific functions.
1018  *
1019  * By default, the owner account will be the one that deploys the contract. This
1020  * can later be changed with {transferOwnership}.
1021  *
1022  * This module is used through inheritance. It will make available the modifier
1023  * `onlyOwner`, which can be applied to your functions to restrict their use to
1024  * the owner.
1025  */
1026 abstract contract Ownable is Context {
1027     address private _owner;
1028 
1029     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1030 
1031     /**
1032      * @dev Initializes the contract setting the deployer as the initial owner.
1033      */
1034     constructor() {
1035         _transferOwnership(_msgSender());
1036     }
1037 
1038     /**
1039      * @dev Returns the address of the current owner.
1040      */
1041     function owner() public view virtual returns (address) {
1042         return _owner;
1043     }
1044 
1045     /**
1046      * @dev Throws if called by any account other than the owner.
1047      */
1048     modifier onlyOwner() {
1049         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1050         _;
1051     }
1052 
1053     /**
1054      * @dev Leaves the contract without owner. It will not be possible to call
1055      * `onlyOwner` functions anymore. Can only be called by the current owner.
1056      *
1057      * NOTE: Renouncing ownership will leave the contract without an owner,
1058      * thereby removing any functionality that is only available to the owner.
1059      */
1060     function renounceOwnership() public virtual onlyOwner {
1061         _transferOwnership(address(0));
1062     }
1063 
1064     /**
1065      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1066      * Can only be called by the current owner.
1067      */
1068     function transferOwnership(address newOwner) public virtual onlyOwner {
1069         require(newOwner != address(0), "Ownable: new owner is the zero address");
1070         _transferOwnership(newOwner);
1071     }
1072 
1073     /**
1074      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1075      * Internal function without access restriction.
1076      */
1077     function _transferOwnership(address newOwner) internal virtual {
1078         address oldOwner = _owner;
1079         _owner = newOwner;
1080         emit OwnershipTransferred(oldOwner, newOwner);
1081     }
1082 }
1083 
1084 
1085 // File contracts/NFTArtGen.sol
1086 
1087 
1088 pragma solidity ^0.8.4;
1089 
1090 
1091 
1092 // 
1093 // Built by https://nft-generator.art
1094 // 
1095 contract NFTArtGen is ERC721, Ownable {
1096     string internal baseUri;
1097 
1098     uint256 public cost = 0.05 ether;
1099     uint32 public maxPerMint = 5;
1100     uint32 public maxPerWallet = 20;
1101     uint32 public supply = 0;
1102     uint32 public totalSupply = 0;
1103     bool public open = false;
1104     mapping(address => uint256) internal addressMintedMap;
1105 
1106     uint32 private commission = 49; // 4.9%
1107     address private author = 0x460Fd5059E7301680fA53E63bbBF7272E643e89C;
1108 
1109     constructor(
1110         string memory _uri,
1111         string memory _name,
1112         string memory _symbol,
1113         uint32 _totalSupply,
1114         uint256 _cost,
1115         bool _open
1116     ) ERC721(_name, _symbol) {
1117         baseUri = _uri;
1118         totalSupply = _totalSupply;
1119         cost = _cost;
1120         open = _open;
1121     }
1122 
1123     // ------ Author Only ------
1124 
1125     function setCommission(uint32 _commision) public {
1126         require(msg.sender == author, "Incorrect Address");
1127         commission = _commision;
1128     }
1129 
1130     // ------ Owner Only ------
1131 
1132     function setCost(uint256 _cost) public onlyOwner {
1133         cost = _cost;
1134     }
1135 
1136     function setOpen(bool _open) public onlyOwner {
1137         open = _open;
1138     }
1139 
1140     function setMaxPerWallet(uint32 _max) public onlyOwner {
1141         maxPerWallet = _max;
1142     }
1143 
1144     function setMaxPerMint(uint32 _max) public onlyOwner {
1145         maxPerMint = _max;
1146     }
1147 
1148     function airdrop(address[] calldata to) public onlyOwner {
1149         for (uint32 i = 0; i < to.length; i++) {
1150             require(1 + supply <= totalSupply, "Limit reached");
1151             _safeMint(to[i], ++supply, "");
1152         }
1153     }
1154 
1155     function withdraw() public payable onlyOwner {
1156         (bool success, ) = payable(msg.sender).call{
1157             value: address(this).balance
1158         }("");
1159         require(success);
1160     }
1161 
1162     // ------ Mint! ------
1163 
1164     function mint(uint32 count) external payable preMintChecks(count) {
1165         require(open == true, "Mint not open");
1166         performMint(count);
1167     }
1168 
1169     function performMint(uint32 count) internal {
1170         for (uint32 i = 0; i < count; i++) {
1171             _safeMint(msg.sender, ++supply, "");
1172         }
1173         
1174         addressMintedMap[msg.sender] += count;
1175 
1176         (bool success, ) = payable(author).call{
1177             value: (msg.value * commission) / 1000
1178         }("");
1179         require(success);
1180     }
1181 
1182     // ------ Read ------
1183 
1184     // ------ Modifiers ------
1185 
1186     modifier preMintChecks(uint32 count) {
1187         require(count > 0, "Mint at least one.");
1188         require(count < maxPerMint + 1, "Max mint reached.");
1189         require(msg.value >= cost * count, "Not enough fund.");
1190         require(supply + count < totalSupply + 1, "Mint sold out");
1191         require(
1192             addressMintedMap[msg.sender] + count <= maxPerWallet,
1193             "Max total mint reached"
1194         );
1195         _;
1196     }
1197 }
1198 
1199 
1200 // File contracts/utils/Revealable.sol
1201 
1202 
1203 pragma solidity ^0.8.4;
1204 
1205 abstract contract Revealable is NFTArtGen {
1206     bool public revealed = false;
1207     string internal uriNotRevealed;
1208 
1209     function setUnrevealedURI(string memory _uri) public onlyOwner {
1210         uriNotRevealed = _uri;
1211     }
1212 
1213     function reveal() public onlyOwner {
1214         revealed = true;
1215     }
1216 }
1217 
1218 
1219 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.1
1220 
1221 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 /**
1226  * @dev These functions deal with verification of Merkle Trees proofs.
1227  *
1228  * The proofs can be generated using the JavaScript library
1229  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1230  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1231  *
1232  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1233  */
1234 library MerkleProof {
1235     /**
1236      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1237      * defined by `root`. For this, a `proof` must be provided, containing
1238      * sibling hashes on the branch from the leaf to the root of the tree. Each
1239      * pair of leaves and each pair of pre-images are assumed to be sorted.
1240      */
1241     function verify(
1242         bytes32[] memory proof,
1243         bytes32 root,
1244         bytes32 leaf
1245     ) internal pure returns (bool) {
1246         return processProof(proof, leaf) == root;
1247     }
1248 
1249     /**
1250      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1251      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1252      * hash matches the root of the tree. When processing the proof, the pairs
1253      * of leafs & pre-images are assumed to be sorted.
1254      *
1255      * _Available since v4.4._
1256      */
1257     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1258         bytes32 computedHash = leaf;
1259         for (uint256 i = 0; i < proof.length; i++) {
1260             bytes32 proofElement = proof[i];
1261             if (computedHash <= proofElement) {
1262                 // Hash(current computed hash + current element of the proof)
1263                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1264             } else {
1265                 // Hash(current element of the proof + current computed hash)
1266                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1267             }
1268         }
1269         return computedHash;
1270     }
1271 }
1272 
1273 
1274 // File contracts/utils/Presaleable.sol
1275 
1276 
1277 pragma solidity ^0.8.4;
1278 
1279 
1280 abstract contract Presaleable is NFTArtGen {
1281     bool public presaleOpen = false;
1282     bytes32 private merkleRoot;
1283 
1284     function setPresaleOpen(bool _open) public onlyOwner {
1285         presaleOpen = _open;
1286     }
1287 
1288     function setPreSaleAddresses(bytes32 root) public onlyOwner {
1289         merkleRoot = root;
1290     }
1291 
1292     function presaleMint(uint32 count, bytes32[] calldata proof)
1293         external
1294         payable
1295         preMintChecks(count)
1296     {
1297         require(presaleOpen, "Presale not open");
1298         require(merkleRoot != "", "Presale not ready");
1299         require(
1300             MerkleProof.verify(
1301                 proof,
1302                 merkleRoot,
1303                 keccak256(abi.encodePacked(msg.sender))
1304             ),
1305             "Not a presale member"
1306         );
1307 
1308         performMint(count);
1309     }
1310 }
1311 
1312 
1313 // File contracts/extensions/PresaleReveal.sol
1314 
1315 
1316 pragma solidity ^0.8.4;
1317 
1318 
1319 
1320 contract NFTArtGenPresaleReveal is NFTArtGen, Revealable, Presaleable {
1321     constructor(
1322         string memory _uri,
1323         string memory _name,
1324         string memory _symbol,
1325         uint32 _totalSupply,
1326         uint256 _cost,
1327         bool _open
1328     ) NFTArtGen(_uri, _name, _symbol, _totalSupply, _cost, _open) {}
1329 
1330     function tokenURI(uint256 _tokenId)
1331         public
1332         view
1333         override
1334         returns (string memory)
1335     {
1336         require(_tokenId <= supply, "Not minted yet");
1337         if (revealed == false) {
1338             return string(
1339                 abi.encodePacked(uriNotRevealed, Strings.toString(_tokenId), ".json")
1340             );
1341         }
1342 
1343         return
1344             string(
1345                 abi.encodePacked(baseUri, Strings.toString(_tokenId), ".json")
1346             );
1347     }
1348 }