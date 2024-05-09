1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-25
3 */
4 
5 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
33 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 
41 /**
42  * @dev Required interface of an ERC721 compliant contract.
43  */
44 interface IERC721 is IERC165 {
45     /**
46      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
47      */
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54 
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
59 
60     /**
61      * @dev Returns the number of tokens in ``owner``'s account.
62      */
63     function balanceOf(address owner) external view returns (uint256 balance);
64 
65     /**
66      * @dev Returns the owner of the `tokenId` token.
67      *
68      * Requirements:
69      *
70      * - `tokenId` must exist.
71      */
72     function ownerOf(uint256 tokenId) external view returns (address owner);
73 
74     /**
75      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
76      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must exist and be owned by `from`.
83      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
84      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
85      *
86      * Emits a {Transfer} event.
87      */
88     function safeTransferFrom(
89         address from,
90         address to,
91         uint256 tokenId
92     ) external;
93 
94     /**
95      * @dev Transfers `tokenId` token from `from` to `to`.
96      *
97      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must be owned by `from`.
104      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId) external view returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId,
174         bytes calldata data
175     ) external;
176 }
177 
178 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 // File: @openzeppelin/contracts/utils/Address.sol
238 
239 
240 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize, which returns 0 for contracts in
267         // construction, since the code is only stored at the end of the
268         // constructor execution.
269 
270         uint256 size;
271         assembly {
272             size := extcodesize(account)
273         }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         require(isContract(target), "Address: call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.call{value: value}(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal view returns (bytes memory) {
395         require(isContract(target), "Address: static call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.delegatecall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
430      * revert reason using the provided one.
431      *
432      * _Available since v4.3._
433      */
434     function verifyCallResult(
435         bool success,
436         bytes memory returndata,
437         string memory errorMessage
438     ) internal pure returns (bytes memory) {
439         if (success) {
440             return returndata;
441         } else {
442             // Look for revert reason and bubble it up if present
443             if (returndata.length > 0) {
444                 // The easiest way to bubble the revert reason is using memory via assembly
445 
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/utils/Context.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Provides information about the current execution context, including the
466  * sender of the transaction and its data. While these are generally available
467  * via msg.sender and msg.data, they should not be accessed in such a direct
468  * manner, since when dealing with meta-transactions the account sending and
469  * paying for execution may not be the actual sender (as far as an application
470  * is concerned).
471  *
472  * This contract is only required for intermediate, library-like contracts.
473  */
474 abstract contract Context {
475     function _msgSender() internal view virtual returns (address) {
476         return msg.sender;
477     }
478 
479     function _msgData() internal view virtual returns (bytes calldata) {
480         return msg.data;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/utils/Strings.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev String operations.
493  */
494 library Strings {
495     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
499      */
500     function toString(uint256 value) internal pure returns (string memory) {
501         // Inspired by OraclizeAPI's implementation - MIT licence
502         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
503 
504         if (value == 0) {
505             return "0";
506         }
507         uint256 temp = value;
508         uint256 digits;
509         while (temp != 0) {
510             digits++;
511             temp /= 10;
512         }
513         bytes memory buffer = new bytes(digits);
514         while (value != 0) {
515             digits -= 1;
516             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
517             value /= 10;
518         }
519         return string(buffer);
520     }
521 
522     /**
523      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
524      */
525     function toHexString(uint256 value) internal pure returns (string memory) {
526         if (value == 0) {
527             return "0x00";
528         }
529         uint256 temp = value;
530         uint256 length = 0;
531         while (temp != 0) {
532             length++;
533             temp >>= 8;
534         }
535         return toHexString(value, length);
536     }
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
540      */
541     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
542         bytes memory buffer = new bytes(2 * length + 2);
543         buffer[0] = "0";
544         buffer[1] = "x";
545         for (uint256 i = 2 * length + 1; i > 1; --i) {
546             buffer[i] = _HEX_SYMBOLS[value & 0xf];
547             value >>= 4;
548         }
549         require(value == 0, "Strings: hex length insufficient");
550         return string(buffer);
551     }
552 }
553 
554 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Implementation of the {IERC165} interface.
564  *
565  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
566  * for the additional interface id that will be supported. For example:
567  *
568  * ```solidity
569  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
571  * }
572  * ```
573  *
574  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
575  */
576 abstract contract ERC165 is IERC165 {
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
581         return interfaceId == type(IERC165).interfaceId;
582     }
583 }
584 
585 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 
593 
594 
595 
596 
597 
598 
599 /**
600  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
601  * the Metadata extension, but not including the Enumerable extension, which is available separately as
602  * {ERC721Enumerable}.
603  */
604 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
605     using Address for address;
606     using Strings for uint256;
607 
608     // Token name
609     string private _name;
610 
611     // Token symbol
612     string private _symbol;
613 
614     // Mapping from token ID to owner address
615     mapping(uint256 => address) private _owners;
616 
617     // Mapping owner address to token count
618     mapping(address => uint256) private _balances;
619 
620     // Mapping from token ID to approved address
621     mapping(uint256 => address) private _tokenApprovals;
622 
623     // Mapping from owner to operator approvals
624     mapping(address => mapping(address => bool)) private _operatorApprovals;
625 
626     /**
627      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
628      */
629     constructor(string memory name_, string memory symbol_) {
630         _name = name_;
631         _symbol = symbol_;
632     }
633 
634     /**
635      * @dev See {IERC165-supportsInterface}.
636      */
637     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
638         return
639             interfaceId == type(IERC721).interfaceId ||
640             interfaceId == type(IERC721Metadata).interfaceId ||
641             super.supportsInterface(interfaceId);
642     }
643 
644     /**
645      * @dev See {IERC721-balanceOf}.
646      */
647     function balanceOf(address owner) public view virtual override returns (uint256) {
648         require(owner != address(0), "ERC721: balance query for the zero address");
649         return _balances[owner];
650     }
651 
652     /**
653      * @dev See {IERC721-ownerOf}.
654      */
655     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
656         address owner = _owners[tokenId];
657         require(owner != address(0), "ERC721: owner query for nonexistent token");
658         return owner;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-name}.
663      */
664     function name() public view virtual override returns (string memory) {
665         return _name;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-symbol}.
670      */
671     function symbol() public view virtual override returns (string memory) {
672         return _symbol;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-tokenURI}.
677      */
678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
679         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
680 
681         string memory baseURI = _baseURI();
682         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
683     }
684 
685     /**
686      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
687      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
688      * by default, can be overriden in child contracts.
689      */
690     function _baseURI() internal view virtual returns (string memory) {
691         return "";
692     }
693 
694     /**
695      * @dev See {IERC721-approve}.
696      */
697     function approve(address to, uint256 tokenId) public virtual override {
698         address owner = ERC721.ownerOf(tokenId);
699         require(to != owner, "ERC721: approval to current owner");
700 
701         require(
702             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
703             "ERC721: approve caller is not owner nor approved for all"
704         );
705 
706         _approve(to, tokenId);
707     }
708 
709     /**
710      * @dev See {IERC721-getApproved}.
711      */
712     function getApproved(uint256 tokenId) public view virtual override returns (address) {
713         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
714 
715         return _tokenApprovals[tokenId];
716     }
717 
718     /**
719      * @dev See {IERC721-setApprovalForAll}.
720      */
721     function setApprovalForAll(address operator, bool approved) public virtual override {
722         _setApprovalForAll(_msgSender(), operator, approved);
723     }
724 
725     /**
726      * @dev See {IERC721-isApprovedForAll}.
727      */
728     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
729         return _operatorApprovals[owner][operator];
730     }
731 
732     /**
733      * @dev See {IERC721-transferFrom}.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) public virtual override {
740         //solhint-disable-next-line max-line-length
741         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
742 
743         _transfer(from, to, tokenId);
744     }
745 
746     /**
747      * @dev See {IERC721-safeTransferFrom}.
748      */
749     function safeTransferFrom(
750         address from,
751         address to,
752         uint256 tokenId
753     ) public virtual override {
754         safeTransferFrom(from, to, tokenId, "");
755     }
756 
757     /**
758      * @dev See {IERC721-safeTransferFrom}.
759      */
760     function safeTransferFrom(
761         address from,
762         address to,
763         uint256 tokenId,
764         bytes memory _data
765     ) public virtual override {
766         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
767         _safeTransfer(from, to, tokenId, _data);
768     }
769 
770     /**
771      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
772      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
773      *
774      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
775      *
776      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
777      * implement alternative mechanisms to perform token transfer, such as signature-based.
778      *
779      * Requirements:
780      *
781      * - `from` cannot be the zero address.
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must exist and be owned by `from`.
784      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _safeTransfer(
789         address from,
790         address to,
791         uint256 tokenId,
792         bytes memory _data
793     ) internal virtual {
794         _transfer(from, to, tokenId);
795         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
796     }
797 
798     /**
799      * @dev Returns whether `tokenId` exists.
800      *
801      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
802      *
803      * Tokens start existing when they are minted (`_mint`),
804      * and stop existing when they are burned (`_burn`).
805      */
806     function _exists(uint256 tokenId) internal view virtual returns (bool) {
807         return _owners[tokenId] != address(0);
808     }
809 
810     /**
811      * @dev Returns whether `spender` is allowed to manage `tokenId`.
812      *
813      * Requirements:
814      *
815      * - `tokenId` must exist.
816      */
817     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
818         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
819         address owner = ERC721.ownerOf(tokenId);
820         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
821     }
822 
823     /**
824      * @dev Safely mints `tokenId` and transfers it to `to`.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must not exist.
829      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _safeMint(address to, uint256 tokenId) internal virtual {
834         _safeMint(to, tokenId, "");
835     }
836 
837     /**
838      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
839      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
840      */
841     function _safeMint(
842         address to,
843         uint256 tokenId,
844         bytes memory _data
845     ) internal virtual {
846         _mint(to, tokenId);
847         require(
848             _checkOnERC721Received(address(0), to, tokenId, _data),
849             "ERC721: transfer to non ERC721Receiver implementer"
850         );
851     }
852 
853     /**
854      * @dev Mints `tokenId` and transfers it to `to`.
855      *
856      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
857      *
858      * Requirements:
859      *
860      * - `tokenId` must not exist.
861      * - `to` cannot be the zero address.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _mint(address to, uint256 tokenId) internal virtual {
866         require(to != address(0), "ERC721: mint to the zero address");
867         require(!_exists(tokenId), "ERC721: token already minted");
868 
869         _beforeTokenTransfer(address(0), to, tokenId);
870 
871         _balances[to] += 1;
872         _owners[tokenId] = to;
873 
874         emit Transfer(address(0), to, tokenId);
875     }
876 
877     /**
878      * @dev Destroys `tokenId`.
879      * The approval is cleared when the token is burned.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _burn(uint256 tokenId) internal virtual {
888         address owner = ERC721.ownerOf(tokenId);
889 
890         _beforeTokenTransfer(owner, address(0), tokenId);
891 
892         // Clear approvals
893         _approve(address(0), tokenId);
894 
895         _balances[owner] -= 1;
896         delete _owners[tokenId];
897 
898         emit Transfer(owner, address(0), tokenId);
899     }
900 
901     /**
902      * @dev Transfers `tokenId` from `from` to `to`.
903      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
904      *
905      * Requirements:
906      *
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must be owned by `from`.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _transfer(
913         address from,
914         address to,
915         uint256 tokenId
916     ) internal virtual {
917         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
918         require(to != address(0), "ERC721: transfer to the zero address");
919 
920         _beforeTokenTransfer(from, to, tokenId);
921 
922         // Clear approvals from the previous owner
923         _approve(address(0), tokenId);
924 
925         _balances[from] -= 1;
926         _balances[to] += 1;
927         _owners[tokenId] = to;
928 
929         emit Transfer(from, to, tokenId);
930     }
931 
932     /**
933      * @dev Approve `to` to operate on `tokenId`
934      *
935      * Emits a {Approval} event.
936      */
937     function _approve(address to, uint256 tokenId) internal virtual {
938         _tokenApprovals[tokenId] = to;
939         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
940     }
941 
942     /**
943      * @dev Approve `operator` to operate on all of `owner` tokens
944      *
945      * Emits a {ApprovalForAll} event.
946      */
947     function _setApprovalForAll(
948         address owner,
949         address operator,
950         bool approved
951     ) internal virtual {
952         require(owner != operator, "ERC721: approve to caller");
953         _operatorApprovals[owner][operator] = approved;
954         emit ApprovalForAll(owner, operator, approved);
955     }
956 
957     /**
958      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
959      * The call is not executed if the target address is not a contract.
960      *
961      * @param from address representing the previous owner of the given token ID
962      * @param to target address that will receive the tokens
963      * @param tokenId uint256 ID of the token to be transferred
964      * @param _data bytes optional data to send along with the call
965      * @return bool whether the call correctly returned the expected magic value
966      */
967     function _checkOnERC721Received(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) private returns (bool) {
973         if (to.isContract()) {
974             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
975                 return retval == IERC721Receiver.onERC721Received.selector;
976             } catch (bytes memory reason) {
977                 if (reason.length == 0) {
978                     revert("ERC721: transfer to non ERC721Receiver implementer");
979                 } else {
980                     assembly {
981                         revert(add(32, reason), mload(reason))
982                     }
983                 }
984             }
985         } else {
986             return true;
987         }
988     }
989 
990     /**
991      * @dev Hook that is called before any token transfer. This includes minting
992      * and burning.
993      *
994      * Calling conditions:
995      *
996      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
997      * transferred to `to`.
998      * - When `from` is zero, `tokenId` will be minted for `to`.
999      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1000      * - `from` and `to` are never both zero.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) internal virtual {}
1009 }
1010 
1011 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1012 
1013 
1014 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 
1019 /**
1020  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1021  * @dev See https://eips.ethereum.org/EIPS/eip-721
1022  */
1023 interface IERC721Enumerable is IERC721 {
1024     /**
1025      * @dev Returns the total amount of tokens stored by the contract.
1026      */
1027     function totalSupply() external view returns (uint256);
1028 
1029     /**
1030      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1031      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1032      */
1033     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1034 
1035     /**
1036      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1037      * Use along with {totalSupply} to enumerate all tokens.
1038      */
1039     function tokenByIndex(uint256 index) external view returns (uint256);
1040 }
1041 
1042 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1043 
1044 
1045 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 
1050 
1051 /**
1052  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1053  * enumerability of all the token ids in the contract as well as all token ids owned by each
1054  * account.
1055  */
1056 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1057     // Mapping from owner to list of owned token IDs
1058     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1059 
1060     // Mapping from token ID to index of the owner tokens list
1061     mapping(uint256 => uint256) private _ownedTokensIndex;
1062 
1063     // Array with all token ids, used for enumeration
1064     uint256[] private _allTokens;
1065 
1066     // Mapping from token id to position in the allTokens array
1067     mapping(uint256 => uint256) private _allTokensIndex;
1068 
1069     /**
1070      * @dev See {IERC165-supportsInterface}.
1071      */
1072     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1073         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1078      */
1079     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1080         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1081         return _ownedTokens[owner][index];
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Enumerable-totalSupply}.
1086      */
1087     function totalSupply() public view virtual override returns (uint256) {
1088         return _allTokens.length;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Enumerable-tokenByIndex}.
1093      */
1094     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1095         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1096         return _allTokens[index];
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any token transfer. This includes minting
1101      * and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1109      * - `from` cannot be the zero address.
1110      * - `to` cannot be the zero address.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _beforeTokenTransfer(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) internal virtual override {
1119         super._beforeTokenTransfer(from, to, tokenId);
1120 
1121         if (from == address(0)) {
1122             _addTokenToAllTokensEnumeration(tokenId);
1123         } else if (from != to) {
1124             _removeTokenFromOwnerEnumeration(from, tokenId);
1125         }
1126         if (to == address(0)) {
1127             _removeTokenFromAllTokensEnumeration(tokenId);
1128         } else if (to != from) {
1129             _addTokenToOwnerEnumeration(to, tokenId);
1130         }
1131     }
1132 
1133     /**
1134      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1135      * @param to address representing the new owner of the given token ID
1136      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1137      */
1138     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1139         uint256 length = ERC721.balanceOf(to);
1140         _ownedTokens[to][length] = tokenId;
1141         _ownedTokensIndex[tokenId] = length;
1142     }
1143 
1144     /**
1145      * @dev Private function to add a token to this extension's token tracking data structures.
1146      * @param tokenId uint256 ID of the token to be added to the tokens list
1147      */
1148     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1149         _allTokensIndex[tokenId] = _allTokens.length;
1150         _allTokens.push(tokenId);
1151     }
1152 
1153     /**
1154      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1155      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1156      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1157      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1158      * @param from address representing the previous owner of the given token ID
1159      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1160      */
1161     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1162         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1163         // then delete the last slot (swap and pop).
1164 
1165         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1166         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1167 
1168         // When the token to delete is the last token, the swap operation is unnecessary
1169         if (tokenIndex != lastTokenIndex) {
1170             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1171 
1172             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1173             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1174         }
1175 
1176         // This also deletes the contents at the last position of the array
1177         delete _ownedTokensIndex[tokenId];
1178         delete _ownedTokens[from][lastTokenIndex];
1179     }
1180 
1181     /**
1182      * @dev Private function to remove a token from this extension's token tracking data structures.
1183      * This has O(1) time complexity, but alters the order of the _allTokens array.
1184      * @param tokenId uint256 ID of the token to be removed from the tokens list
1185      */
1186     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1187         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1188         // then delete the last slot (swap and pop).
1189 
1190         uint256 lastTokenIndex = _allTokens.length - 1;
1191         uint256 tokenIndex = _allTokensIndex[tokenId];
1192 
1193         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1194         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1195         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1196         uint256 lastTokenId = _allTokens[lastTokenIndex];
1197 
1198         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1199         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1200 
1201         // This also deletes the contents at the last position of the array
1202         delete _allTokensIndex[tokenId];
1203         _allTokens.pop();
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/access/Ownable.sol
1208 
1209 
1210 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 /**
1216  * @dev Contract module which provides a basic access control mechanism, where
1217  * there is an account (an owner) that can be granted exclusive access to
1218  * specific functions.
1219  *
1220  * By default, the owner account will be the one that deploys the contract. This
1221  * can later be changed with {transferOwnership}.
1222  *
1223  * This module is used through inheritance. It will make available the modifier
1224  * `onlyOwner`, which can be applied to your functions to restrict their use to
1225  * the owner.
1226  */
1227 abstract contract Ownable is Context {
1228     address private _owner;
1229 
1230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1231 
1232     /**
1233      * @dev Initializes the contract setting the deployer as the initial owner.
1234      */
1235     constructor() {
1236         _transferOwnership(_msgSender());
1237     }
1238 
1239     /**
1240      * @dev Returns the address of the current owner.
1241      */
1242     function owner() public view virtual returns (address) {
1243         return _owner;
1244     }
1245 
1246     /**
1247      * @dev Throws if called by any account other than the owner.
1248      */
1249     modifier onlyOwner() {
1250         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1251         _;
1252     }
1253 
1254     /**
1255      * @dev Leaves the contract without owner. It will not be possible to call
1256      * `onlyOwner` functions anymore. Can only be called by the current owner.
1257      *
1258      * NOTE: Renouncing ownership will leave the contract without an owner,
1259      * thereby removing any functionality that is only available to the owner.
1260      */
1261     function renounceOwnership() public virtual onlyOwner {
1262         _transferOwnership(address(0));
1263     }
1264 
1265     /**
1266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1267      * Can only be called by the current owner.
1268      */
1269     function transferOwnership(address newOwner) public virtual onlyOwner {
1270         require(newOwner != address(0), "Ownable: new owner is the zero address");
1271         _transferOwnership(newOwner);
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Internal function without access restriction.
1277      */
1278     function _transferOwnership(address newOwner) internal virtual {
1279         address oldOwner = _owner;
1280         _owner = newOwner;
1281         emit OwnershipTransferred(oldOwner, newOwner);
1282     }
1283 }
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 /**
1288  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1289  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1290  *
1291  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1292  *
1293  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1294  *
1295  * Does not support burning tokens to address(0).
1296  */
1297 contract ERC721A is
1298   Context,
1299   ERC165,
1300   IERC721,
1301   IERC721Metadata,
1302   IERC721Enumerable
1303 {
1304   using Address for address;
1305   using Strings for uint256;
1306 
1307   struct TokenOwnership {
1308     address addr;
1309     uint64 startTimestamp;
1310   }
1311 
1312   struct AddressData {
1313     uint128 balance;
1314     uint128 numberMinted;
1315   }
1316 
1317   uint256 private currentIndex = 0;
1318 
1319   uint256 internal immutable collectionSize;
1320   uint256 internal immutable maxBatchSize;
1321 
1322   // Token name
1323   string private _name;
1324 
1325   // Token symbol
1326   string private _symbol;
1327 
1328   // Mapping from token ID to ownership details
1329   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1330   mapping(uint256 => TokenOwnership) private _ownerships;
1331 
1332   // Mapping owner address to address data
1333   mapping(address => AddressData) private _addressData;
1334 
1335   // Mapping from token ID to approved address
1336   mapping(uint256 => address) private _tokenApprovals;
1337 
1338   // Mapping from owner to operator approvals
1339   mapping(address => mapping(address => bool)) private _operatorApprovals;
1340 
1341   /**
1342    * @dev
1343    * `maxBatchSize` refers to how much a minter can mint at a time.
1344    * `collectionSize_` refers to how many tokens are in the collection.
1345    */
1346   constructor(
1347     string memory name_,
1348     string memory symbol_,
1349     uint256 maxBatchSize_,
1350     uint256 collectionSize_
1351   ) {
1352     require(
1353       collectionSize_ > 0,
1354       "ERC721A: collection must have a nonzero supply"
1355     );
1356     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1357     _name = name_;
1358     _symbol = symbol_;
1359     maxBatchSize = maxBatchSize_;
1360     collectionSize = collectionSize_;
1361   }
1362 
1363   /**
1364    * @dev See {IERC721Enumerable-totalSupply}.
1365    */
1366   function totalSupply() public view override returns (uint256) {
1367     return currentIndex;
1368   }
1369 
1370   /**
1371    * @dev See {IERC721Enumerable-tokenByIndex}.
1372    */
1373   function tokenByIndex(uint256 index) public view override returns (uint256) {
1374     require(index < totalSupply(), "ERC721A: global index out of bounds");
1375     return index;
1376   }
1377 
1378   /**
1379    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1380    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1381    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1382    */
1383   function tokenOfOwnerByIndex(address owner, uint256 index)
1384     public
1385     view
1386     override
1387     returns (uint256)
1388   {
1389     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1390     uint256 numMintedSoFar = totalSupply();
1391     uint256 tokenIdsIdx = 0;
1392     address currOwnershipAddr = address(0);
1393     for (uint256 i = 0; i < numMintedSoFar; i++) {
1394       TokenOwnership memory ownership = _ownerships[i];
1395       if (ownership.addr != address(0)) {
1396         currOwnershipAddr = ownership.addr;
1397       }
1398       if (currOwnershipAddr == owner) {
1399         if (tokenIdsIdx == index) {
1400           return i;
1401         }
1402         tokenIdsIdx++;
1403       }
1404     }
1405     revert("ERC721A: unable to get token of owner by index");
1406   }
1407 
1408   /**
1409    * @dev See {IERC165-supportsInterface}.
1410    */
1411   function supportsInterface(bytes4 interfaceId)
1412     public
1413     view
1414     virtual
1415     override(ERC165, IERC165)
1416     returns (bool)
1417   {
1418     return
1419       interfaceId == type(IERC721).interfaceId ||
1420       interfaceId == type(IERC721Metadata).interfaceId ||
1421       interfaceId == type(IERC721Enumerable).interfaceId ||
1422       super.supportsInterface(interfaceId);
1423   }
1424 
1425   /**
1426    * @dev See {IERC721-balanceOf}.
1427    */
1428   function balanceOf(address owner) public view override returns (uint256) {
1429     require(owner != address(0), "ERC721A: balance query for the zero address");
1430     return uint256(_addressData[owner].balance);
1431   }
1432 
1433   function _numberMinted(address owner) internal view returns (uint256) {
1434     require(
1435       owner != address(0),
1436       "ERC721A: number minted query for the zero address"
1437     );
1438     return uint256(_addressData[owner].numberMinted);
1439   }
1440 
1441   function ownershipOf(uint256 tokenId)
1442     internal
1443     view
1444     returns (TokenOwnership memory)
1445   {
1446     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1447 
1448     uint256 lowestTokenToCheck;
1449     if (tokenId >= maxBatchSize) {
1450       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1451     }
1452 
1453     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1454       TokenOwnership memory ownership = _ownerships[curr];
1455       if (ownership.addr != address(0)) {
1456         return ownership;
1457       }
1458     }
1459 
1460     revert("ERC721A: unable to determine the owner of token");
1461   }
1462 
1463   /**
1464    * @dev See {IERC721-ownerOf}.
1465    */
1466   function ownerOf(uint256 tokenId) public view override returns (address) {
1467     return ownershipOf(tokenId).addr;
1468   }
1469 
1470   /**
1471    * @dev See {IERC721Metadata-name}.
1472    */
1473   function name() public view virtual override returns (string memory) {
1474     return _name;
1475   }
1476 
1477   /**
1478    * @dev See {IERC721Metadata-symbol}.
1479    */
1480   function symbol() public view virtual override returns (string memory) {
1481     return _symbol;
1482   }
1483 
1484   /**
1485    * @dev See {IERC721Metadata-tokenURI}.
1486    */
1487   function tokenURI(uint256 tokenId)
1488     public
1489     view
1490     virtual
1491     override
1492     returns (string memory)
1493   {
1494     require(
1495       _exists(tokenId),
1496       "ERC721Metadata: URI query for nonexistent token"
1497     );
1498 
1499     string memory baseURI = _baseURI();
1500     return
1501       bytes(baseURI).length > 0
1502         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1503         : "";
1504   }
1505 
1506   /**
1507    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1508    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1509    * by default, can be overriden in child contracts.
1510    */
1511   function _baseURI() internal view virtual returns (string memory) {
1512     return "";
1513   }
1514 
1515   /**
1516    * @dev See {IERC721-approve}.
1517    */
1518   function approve(address to, uint256 tokenId) public override {
1519     address owner = ERC721A.ownerOf(tokenId);
1520     require(to != owner, "ERC721A: approval to current owner");
1521 
1522     require(
1523       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1524       "ERC721A: approve caller is not owner nor approved for all"
1525     );
1526 
1527     _approve(to, tokenId, owner);
1528   }
1529 
1530   /**
1531    * @dev See {IERC721-getApproved}.
1532    */
1533   function getApproved(uint256 tokenId) public view override returns (address) {
1534     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1535 
1536     return _tokenApprovals[tokenId];
1537   }
1538 
1539   /**
1540    * @dev See {IERC721-setApprovalForAll}.
1541    */
1542   function setApprovalForAll(address operator, bool approved) public override {
1543     require(operator != _msgSender(), "ERC721A: approve to caller");
1544 
1545     _operatorApprovals[_msgSender()][operator] = approved;
1546     emit ApprovalForAll(_msgSender(), operator, approved);
1547   }
1548 
1549   /**
1550    * @dev See {IERC721-isApprovedForAll}.
1551    */
1552   function isApprovedForAll(address owner, address operator)
1553     public
1554     view
1555     virtual
1556     override
1557     returns (bool)
1558   {
1559     return _operatorApprovals[owner][operator];
1560   }
1561 
1562   /**
1563    * @dev See {IERC721-transferFrom}.
1564    */
1565   function transferFrom(
1566     address from,
1567     address to,
1568     uint256 tokenId
1569   ) public override {
1570     _transfer(from, to, tokenId);
1571   }
1572 
1573   /**
1574    * @dev See {IERC721-safeTransferFrom}.
1575    */
1576   function safeTransferFrom(
1577     address from,
1578     address to,
1579     uint256 tokenId
1580   ) public override {
1581     safeTransferFrom(from, to, tokenId, "");
1582   }
1583 
1584   /**
1585    * @dev See {IERC721-safeTransferFrom}.
1586    */
1587   function safeTransferFrom(
1588     address from,
1589     address to,
1590     uint256 tokenId,
1591     bytes memory _data
1592   ) public override {
1593     _transfer(from, to, tokenId);
1594     require(
1595       _checkOnERC721Received(from, to, tokenId, _data),
1596       "ERC721A: transfer to non ERC721Receiver implementer"
1597     );
1598   }
1599 
1600   /**
1601    * @dev Returns whether `tokenId` exists.
1602    *
1603    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1604    *
1605    * Tokens start existing when they are minted (`_mint`),
1606    */
1607   function _exists(uint256 tokenId) internal view returns (bool) {
1608     return tokenId < currentIndex;
1609   }
1610 
1611   function _safeMint(address to, uint256 quantity) internal {
1612     _safeMint(to, quantity, "");
1613   }
1614 
1615   /**
1616    * @dev Mints `quantity` tokens and transfers them to `to`.
1617    *
1618    * Requirements:
1619    *
1620    * - there must be `quantity` tokens remaining unminted in the total collection.
1621    * - `to` cannot be the zero address.
1622    * - `quantity` cannot be larger than the max batch size.
1623    *
1624    * Emits a {Transfer} event.
1625    */
1626   function _safeMint(
1627     address to,
1628     uint256 quantity,
1629     bytes memory _data
1630   ) internal {
1631     uint256 startTokenId = currentIndex;
1632     require(to != address(0), "ERC721A: mint to the zero address");
1633     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1634     require(!_exists(startTokenId), "ERC721A: token already minted");
1635     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1636 
1637     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1638 
1639     AddressData memory addressData = _addressData[to];
1640     _addressData[to] = AddressData(
1641       addressData.balance + uint128(quantity),
1642       addressData.numberMinted + uint128(quantity)
1643     );
1644     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1645 
1646     uint256 updatedIndex = startTokenId;
1647 
1648     for (uint256 i = 0; i < quantity; i++) {
1649       emit Transfer(address(0), to, updatedIndex);
1650       require(
1651         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1652         "ERC721A: transfer to non ERC721Receiver implementer"
1653       );
1654       updatedIndex++;
1655     }
1656 
1657     currentIndex = updatedIndex;
1658     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1659   }
1660 
1661   /**
1662    * @dev Transfers `tokenId` from `from` to `to`.
1663    *
1664    * Requirements:
1665    *
1666    * - `to` cannot be the zero address.
1667    * - `tokenId` token must be owned by `from`.
1668    *
1669    * Emits a {Transfer} event.
1670    */
1671   function _transfer(
1672     address from,
1673     address to,
1674     uint256 tokenId
1675   ) private {
1676     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1677 
1678     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1679       getApproved(tokenId) == _msgSender() ||
1680       isApprovedForAll(prevOwnership.addr, _msgSender()));
1681 
1682     require(
1683       isApprovedOrOwner,
1684       "ERC721A: transfer caller is not owner nor approved"
1685     );
1686 
1687     require(
1688       prevOwnership.addr == from,
1689       "ERC721A: transfer from incorrect owner"
1690     );
1691     require(to != address(0), "ERC721A: transfer to the zero address");
1692 
1693     _beforeTokenTransfers(from, to, tokenId, 1);
1694 
1695     // Clear approvals from the previous owner
1696     _approve(address(0), tokenId, prevOwnership.addr);
1697 
1698     _addressData[from].balance -= 1;
1699     _addressData[to].balance += 1;
1700     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1701 
1702     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1703     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1704     uint256 nextTokenId = tokenId + 1;
1705     if (_ownerships[nextTokenId].addr == address(0)) {
1706       if (_exists(nextTokenId)) {
1707         _ownerships[nextTokenId] = TokenOwnership(
1708           prevOwnership.addr,
1709           prevOwnership.startTimestamp
1710         );
1711       }
1712     }
1713 
1714     emit Transfer(from, to, tokenId);
1715     _afterTokenTransfers(from, to, tokenId, 1);
1716   }
1717 
1718   /**
1719    * @dev Approve `to` to operate on `tokenId`
1720    *
1721    * Emits a {Approval} event.
1722    */
1723   function _approve(
1724     address to,
1725     uint256 tokenId,
1726     address owner
1727   ) private {
1728     _tokenApprovals[tokenId] = to;
1729     emit Approval(owner, to, tokenId);
1730   }
1731 
1732   uint256 public nextOwnerToExplicitlySet = 0;
1733 
1734   /**
1735    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1736    */
1737   function _setOwnersExplicit(uint256 quantity) internal {
1738     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1739     require(quantity > 0, "quantity must be nonzero");
1740     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1741     if (endIndex > collectionSize - 1) {
1742       endIndex = collectionSize - 1;
1743     }
1744     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1745     require(_exists(endIndex), "not enough minted yet for this cleanup");
1746     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1747       if (_ownerships[i].addr == address(0)) {
1748         TokenOwnership memory ownership = ownershipOf(i);
1749         _ownerships[i] = TokenOwnership(
1750           ownership.addr,
1751           ownership.startTimestamp
1752         );
1753       }
1754     }
1755     nextOwnerToExplicitlySet = endIndex + 1;
1756   }
1757 
1758   /**
1759    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1760    * The call is not executed if the target address is not a contract.
1761    *
1762    * @param from address representing the previous owner of the given token ID
1763    * @param to target address that will receive the tokens
1764    * @param tokenId uint256 ID of the token to be transferred
1765    * @param _data bytes optional data to send along with the call
1766    * @return bool whether the call correctly returned the expected magic value
1767    */
1768   function _checkOnERC721Received(
1769     address from,
1770     address to,
1771     uint256 tokenId,
1772     bytes memory _data
1773   ) private returns (bool) {
1774     if (to.isContract()) {
1775       try
1776         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1777       returns (bytes4 retval) {
1778         return retval == IERC721Receiver(to).onERC721Received.selector;
1779       } catch (bytes memory reason) {
1780         if (reason.length == 0) {
1781           revert("ERC721A: transfer to non ERC721Receiver implementer");
1782         } else {
1783           assembly {
1784             revert(add(32, reason), mload(reason))
1785           }
1786         }
1787       }
1788     } else {
1789       return true;
1790     }
1791   }
1792 
1793   /**
1794    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1795    *
1796    * startTokenId - the first token id to be transferred
1797    * quantity - the amount to be transferred
1798    *
1799    * Calling conditions:
1800    *
1801    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1802    * transferred to `to`.
1803    * - When `from` is zero, `tokenId` will be minted for `to`.
1804    */
1805   function _beforeTokenTransfers(
1806     address from,
1807     address to,
1808     uint256 startTokenId,
1809     uint256 quantity
1810   ) internal virtual {}
1811 
1812   /**
1813    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1814    * minting.
1815    *
1816    * startTokenId - the first token id to be transferred
1817    * quantity - the amount to be transferred
1818    *
1819    * Calling conditions:
1820    *
1821    * - when `from` and `to` are both non-zero.
1822    * - `from` and `to` are never both zero.
1823    */
1824   function _afterTokenTransfers(
1825     address from,
1826     address to,
1827     uint256 startTokenId,
1828     uint256 quantity
1829   ) internal virtual {}
1830 }
1831 
1832 
1833 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1834 
1835 
1836 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1837 
1838 pragma solidity ^0.8.0;
1839 
1840 /**
1841  * @dev These functions deal with verification of Merkle Trees proofs.
1842  *
1843  * The proofs can be generated using the JavaScript library
1844  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1845  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1846  *
1847  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1848  */
1849 library MerkleProof {
1850     /**
1851      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1852      * defined by `root`. For this, a `proof` must be provided, containing
1853      * sibling hashes on the branch from the leaf to the root of the tree. Each
1854      * pair of leaves and each pair of pre-images are assumed to be sorted.
1855      */
1856     function verify(
1857         bytes32[] memory proof,
1858         bytes32 root,
1859         bytes32 leaf
1860     ) internal pure returns (bool) {
1861         return processProof(proof, leaf) == root;
1862     }
1863 
1864     /**
1865      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1866      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1867      * hash matches the root of the tree. When processing the proof, the pairs
1868      * of leafs & pre-images are assumed to be sorted.
1869      *
1870      * _Available since v4.4._
1871      */
1872     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1873         bytes32 computedHash = leaf;
1874         for (uint256 i = 0; i < proof.length; i++) {
1875             bytes32 proofElement = proof[i];
1876             if (computedHash <= proofElement) {
1877                 // Hash(current computed hash + current element of the proof)
1878                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1879             } else {
1880                 // Hash(current element of the proof + current computed hash)
1881                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1882             }
1883         }
1884         return computedHash;
1885     }
1886 }
1887 
1888 
1889 pragma solidity ^0.8.0;
1890 
1891 contract MetaNightClub is ERC721A, Ownable {
1892 
1893     uint public MAX_TOKENS = 6969;
1894     uint public MAX_VIP_TOKENS = 696;
1895     uint public MAX_OG_TOKENS = 2100;
1896 
1897 
1898     uint public vipSupply;
1899     uint public ogSupply;
1900 
1901     string private _baseURIextended;
1902     bool public publicSaleIsActive = false;
1903     bool public preSaleIsActive = false;
1904     bool public privateSaleIsActive = true;
1905     bool public merkleWhitelist = true;
1906 
1907     bytes32 public PRESALE_MERKLE_ROOT = "";
1908 
1909     uint256 public publicSalePrice = 200000000000000000; //0.2
1910     uint256 public preSalePrice = 100000000000000000; //0.1
1911     uint256 public privateSalePrice = 69000000000000000; //0.069
1912     
1913     constructor() ERC721A("MetaNightClub", "MNC", 50, 6969) {
1914 
1915     }
1916 
1917     function publicSaleMint(uint numberOfTokens) public payable {
1918         require(publicSaleIsActive, "Public sale must be active to mint NFTs");
1919         require(totalSupply() + numberOfTokens <= MAX_TOKENS);
1920         require(publicSalePrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1921         _safeMint(msg.sender, numberOfTokens);
1922     }
1923 
1924     function ogSaleMint(bytes32[] calldata _merkleProof, uint numberOfTokens) public payable {
1925         require(preSaleIsActive, "Presale sale must be active to mint NFTs");
1926         require(preSalePrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1927         require(ogSupply + numberOfTokens <= MAX_OG_TOKENS, "Purchase would exceed OG Supply");
1928         if (merkleWhitelist) {
1929             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1930             require(MerkleProof.verify(_merkleProof, PRESALE_MERKLE_ROOT, leaf), "Invalid Proof");
1931         }
1932         ogSupply = ogSupply + numberOfTokens;
1933         _safeMint(msg.sender, numberOfTokens);
1934     }
1935 
1936     function vipSaleMint(uint numberOfTokens) public payable {
1937         require(privateSaleIsActive, "Private sale must be active to mint NFTs");
1938         require(privateSalePrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1939         require(vipSupply + numberOfTokens <= MAX_VIP_TOKENS, "Purchase would exceed VIP Supply");
1940         vipSupply = vipSupply + numberOfTokens;
1941         _safeMint(msg.sender, numberOfTokens);
1942     }
1943 
1944     function airdropNft(address userAddress, uint numberOfTokens) public onlyOwner {
1945         require(totalSupply() + numberOfTokens <= MAX_TOKENS);
1946          _safeMint(userAddress, numberOfTokens);
1947     }
1948 
1949     function setBaseURI(string memory baseURI_) public onlyOwner() {
1950         _baseURIextended = baseURI_;
1951     }
1952 
1953     function _baseURI() internal view virtual override returns (string memory) {
1954         return _baseURIextended;
1955     }
1956 
1957     function flipPublicMintState() public onlyOwner {
1958         publicSaleIsActive = !publicSaleIsActive;
1959     }
1960 
1961     function flipPresaleMintState() public onlyOwner {
1962         preSaleIsActive = !preSaleIsActive;
1963     }
1964 
1965     function flipPrivateMintState() public onlyOwner {
1966         privateSaleIsActive = !privateSaleIsActive;
1967     }
1968 
1969     // in case ethereum makes a surprise
1970     function changePublicPrice(uint256 newPrice) public onlyOwner {
1971         publicSalePrice = newPrice;
1972     }
1973 
1974     function changePresaleMerkleRoot(bytes32 presaleMerkleRoot) public onlyOwner {
1975         PRESALE_MERKLE_ROOT = presaleMerkleRoot;
1976     }
1977 
1978     function flipMerkleState() public onlyOwner {
1979         merkleWhitelist = !merkleWhitelist;
1980     }
1981 
1982     function getHolderTokens(address _owner) public view virtual returns (uint256[] memory) {
1983         uint256 tokenCount = balanceOf(_owner);
1984         uint256[] memory tokensId = new uint256[](tokenCount);
1985         for(uint256 i; i < tokenCount; i++){
1986             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1987         }
1988         return tokensId;
1989     }
1990 
1991     function withdraw() public onlyOwner {
1992         payable(msg.sender).transfer(address(this).balance);
1993     }
1994 }