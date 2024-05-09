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
32 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
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
70      * @dev Safely transfers `tokenId` token from `from` to `to`.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId,
86         bytes calldata data
87     ) external;
88 
89     /**
90      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
91      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must exist and be owned by `from`.
98      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
99      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
100      *
101      * Emits a {Transfer} event.
102      */
103     function safeTransferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(
124         address from,
125         address to,
126         uint256 tokenId
127     ) external;
128 
129     /**
130      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
131      * The approval is cleared when the token is transferred.
132      *
133      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
134      *
135      * Requirements:
136      *
137      * - The caller must own the token or be an approved operator.
138      * - `tokenId` must exist.
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address to, uint256 tokenId) external;
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns the account approved for `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function getApproved(uint256 tokenId) external view returns (address operator);
164 
165     /**
166      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
167      *
168      * See {setApprovalForAll}
169      */
170     function isApprovedForAll(address owner, address operator) external view returns (bool);
171 }
172 
173 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  * from ERC721 asset contracts.
184  */
185 interface IERC721Receiver {
186     /**
187      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
188      * by `operator` from `from`, this function is called.
189      *
190      * It must return its Solidity selector to confirm the token transfer.
191      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
192      *
193      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
194      */
195     function onERC721Received(
196         address operator,
197         address from,
198         uint256 tokenId,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
235 
236 pragma solidity ^0.8.1;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      *
259      * [IMPORTANT]
260      * ====
261      * You shouldn't rely on `isContract` to protect against flash loan attacks!
262      *
263      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
264      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
265      * constructor.
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize/address.code.length, which returns 0
270         // for contracts in construction, since the code is only stored at the end
271         // of the constructor execution.
272 
273         return account.code.length > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         (bool success, ) = recipient.call{value: amount}("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain `call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         require(isContract(target), "Address: call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.call{value: value}(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.staticcall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(isContract(target), "Address: delegate call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.delegatecall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
429      * revert reason using the provided one.
430      *
431      * _Available since v4.3._
432      */
433     function verifyCallResult(
434         bool success,
435         bytes memory returndata,
436         string memory errorMessage
437     ) internal pure returns (bytes memory) {
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444                 /// @solidity memory-safe-assembly
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/utils/Context.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @dev Provides information about the current execution context, including the
465  * sender of the transaction and its data. While these are generally available
466  * via msg.sender and msg.data, they should not be accessed in such a direct
467  * manner, since when dealing with meta-transactions the account sending and
468  * paying for execution may not be the actual sender (as far as an application
469  * is concerned).
470  *
471  * This contract is only required for intermediate, library-like contracts.
472  */
473 abstract contract Context {
474     function _msgSender() internal view virtual returns (address) {
475         return msg.sender;
476     }
477 
478     function _msgData() internal view virtual returns (bytes calldata) {
479         return msg.data;
480     }
481 }
482 
483 // File: @openzeppelin/contracts/utils/Strings.sol
484 
485 
486 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev String operations.
492  */
493 library Strings {
494     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
495     uint8 private constant _ADDRESS_LENGTH = 20;
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
552 
553     /**
554      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
555      */
556     function toHexString(address addr) internal pure returns (string memory) {
557         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
558     }
559 }
560 
561 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev Implementation of the {IERC165} interface.
570  *
571  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
572  * for the additional interface id that will be supported. For example:
573  *
574  * ```solidity
575  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
577  * }
578  * ```
579  *
580  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
581  */
582 abstract contract ERC165 is IERC165 {
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587         return interfaceId == type(IERC165).interfaceId;
588     }
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
592 
593 
594 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 
600 
601 
602 
603 
604 /**
605  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
606  * the Metadata extension, but not including the Enumerable extension, which is available separately as
607  * {ERC721Enumerable}.
608  */
609 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
610     using Address for address;
611     using Strings for uint256;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to owner address
620     mapping(uint256 => address) private _owners;
621 
622     // Mapping owner address to token count
623     mapping(address => uint256) private _balances;
624 
625     // Mapping from token ID to approved address
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     /**
632      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
633      */
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637     }
638 
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
643         return
644             interfaceId == type(IERC721).interfaceId ||
645             interfaceId == type(IERC721Metadata).interfaceId ||
646             super.supportsInterface(interfaceId);
647     }
648 
649     /**
650      * @dev See {IERC721-balanceOf}.
651      */
652     function balanceOf(address owner) public view virtual override returns (uint256) {
653         require(owner != address(0), "ERC721: address zero is not a valid owner");
654         return _balances[owner];
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
661         address owner = _owners[tokenId];
662         require(owner != address(0), "ERC721: invalid token ID");
663         return owner;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-name}.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-symbol}.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-tokenURI}.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         _requireMinted(tokenId);
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, can be overridden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return "";
697     }
698 
699     /**
700      * @dev See {IERC721-approve}.
701      */
702     function approve(address to, uint256 tokenId) public virtual override {
703         address owner = ERC721.ownerOf(tokenId);
704         require(to != owner, "ERC721: approval to current owner");
705 
706         require(
707             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
708             "ERC721: approve caller is not token owner nor approved for all"
709         );
710 
711         _approve(to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-getApproved}.
716      */
717     function getApproved(uint256 tokenId) public view virtual override returns (address) {
718         _requireMinted(tokenId);
719 
720         return _tokenApprovals[tokenId];
721     }
722 
723     /**
724      * @dev See {IERC721-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         _setApprovalForAll(_msgSender(), operator, approved);
728     }
729 
730     /**
731      * @dev See {IERC721-isApprovedForAll}.
732      */
733     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         //solhint-disable-next-line max-line-length
746         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
747 
748         _transfer(from, to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         safeTransferFrom(from, to, tokenId, "");
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes memory data
770     ) public virtual override {
771         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
772         _safeTransfer(from, to, tokenId, data);
773     }
774 
775     /**
776      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
777      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
778      *
779      * `data` is additional data, it has no specified format and it is sent in call to `to`.
780      *
781      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
782      * implement alternative mechanisms to perform token transfer, such as signature-based.
783      *
784      * Requirements:
785      *
786      * - `from` cannot be the zero address.
787      * - `to` cannot be the zero address.
788      * - `tokenId` token must exist and be owned by `from`.
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _safeTransfer(
794         address from,
795         address to,
796         uint256 tokenId,
797         bytes memory data
798     ) internal virtual {
799         _transfer(from, to, tokenId);
800         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
801     }
802 
803     /**
804      * @dev Returns whether `tokenId` exists.
805      *
806      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
807      *
808      * Tokens start existing when they are minted (`_mint`),
809      * and stop existing when they are burned (`_burn`).
810      */
811     function _exists(uint256 tokenId) internal view virtual returns (bool) {
812         return _owners[tokenId] != address(0);
813     }
814 
815     /**
816      * @dev Returns whether `spender` is allowed to manage `tokenId`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      */
822     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
823         address owner = ERC721.ownerOf(tokenId);
824         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
825     }
826 
827     /**
828      * @dev Safely mints `tokenId` and transfers it to `to`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeMint(address to, uint256 tokenId) internal virtual {
838         _safeMint(to, tokenId, "");
839     }
840 
841     /**
842      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
843      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
844      */
845     function _safeMint(
846         address to,
847         uint256 tokenId,
848         bytes memory data
849     ) internal virtual {
850         _mint(to, tokenId);
851         require(
852             _checkOnERC721Received(address(0), to, tokenId, data),
853             "ERC721: transfer to non ERC721Receiver implementer"
854         );
855     }
856 
857     /**
858      * @dev Mints `tokenId` and transfers it to `to`.
859      *
860      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - `to` cannot be the zero address.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _mint(address to, uint256 tokenId) internal virtual {
870         require(to != address(0), "ERC721: mint to the zero address");
871         require(!_exists(tokenId), "ERC721: token already minted");
872 
873         _beforeTokenTransfer(address(0), to, tokenId);
874 
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(address(0), to, tokenId);
879 
880         _afterTokenTransfer(address(0), to, tokenId);
881     }
882 
883     /**
884      * @dev Destroys `tokenId`.
885      * The approval is cleared when the token is burned.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _burn(uint256 tokenId) internal virtual {
894         address owner = ERC721.ownerOf(tokenId);
895 
896         _beforeTokenTransfer(owner, address(0), tokenId);
897 
898         // Clear approvals
899         _approve(address(0), tokenId);
900 
901         _balances[owner] -= 1;
902         delete _owners[tokenId];
903 
904         emit Transfer(owner, address(0), tokenId);
905 
906         _afterTokenTransfer(owner, address(0), tokenId);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) internal virtual {
925         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
926         require(to != address(0), "ERC721: transfer to the zero address");
927 
928         _beforeTokenTransfer(from, to, tokenId);
929 
930         // Clear approvals from the previous owner
931         _approve(address(0), tokenId);
932 
933         _balances[from] -= 1;
934         _balances[to] += 1;
935         _owners[tokenId] = to;
936 
937         emit Transfer(from, to, tokenId);
938 
939         _afterTokenTransfer(from, to, tokenId);
940     }
941 
942     /**
943      * @dev Approve `to` to operate on `tokenId`
944      *
945      * Emits an {Approval} event.
946      */
947     function _approve(address to, uint256 tokenId) internal virtual {
948         _tokenApprovals[tokenId] = to;
949         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
950     }
951 
952     /**
953      * @dev Approve `operator` to operate on all of `owner` tokens
954      *
955      * Emits an {ApprovalForAll} event.
956      */
957     function _setApprovalForAll(
958         address owner,
959         address operator,
960         bool approved
961     ) internal virtual {
962         require(owner != operator, "ERC721: approve to caller");
963         _operatorApprovals[owner][operator] = approved;
964         emit ApprovalForAll(owner, operator, approved);
965     }
966 
967     /**
968      * @dev Reverts if the `tokenId` has not been minted yet.
969      */
970     function _requireMinted(uint256 tokenId) internal view virtual {
971         require(_exists(tokenId), "ERC721: invalid token ID");
972     }
973 
974     /**
975      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
976      * The call is not executed if the target address is not a contract.
977      *
978      * @param from address representing the previous owner of the given token ID
979      * @param to target address that will receive the tokens
980      * @param tokenId uint256 ID of the token to be transferred
981      * @param data bytes optional data to send along with the call
982      * @return bool whether the call correctly returned the expected magic value
983      */
984     function _checkOnERC721Received(
985         address from,
986         address to,
987         uint256 tokenId,
988         bytes memory data
989     ) private returns (bool) {
990         if (to.isContract()) {
991             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
992                 return retval == IERC721Receiver.onERC721Received.selector;
993             } catch (bytes memory reason) {
994                 if (reason.length == 0) {
995                     revert("ERC721: transfer to non ERC721Receiver implementer");
996                 } else {
997                     /// @solidity memory-safe-assembly
998                     assembly {
999                         revert(add(32, reason), mload(reason))
1000                     }
1001                 }
1002             }
1003         } else {
1004             return true;
1005         }
1006     }
1007 
1008     /**
1009      * @dev Hook that is called before any token transfer. This includes minting
1010      * and burning.
1011      *
1012      * Calling conditions:
1013      *
1014      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1015      * transferred to `to`.
1016      * - When `from` is zero, `tokenId` will be minted for `to`.
1017      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1018      * - `from` and `to` are never both zero.
1019      *
1020      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1021      */
1022     function _beforeTokenTransfer(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) internal virtual {}
1027 
1028     /**
1029      * @dev Hook that is called after any transfer of tokens. This includes
1030      * minting and burning.
1031      *
1032      * Calling conditions:
1033      *
1034      * - when `from` and `to` are both non-zero.
1035      * - `from` and `to` are never both zero.
1036      *
1037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1038      */
1039     function _afterTokenTransfer(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) internal virtual {}
1044 }
1045 
1046 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1047 
1048 
1049 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 /**
1054  * @dev ERC721 token with storage based token URI management.
1055  */
1056 abstract contract ERC721URIStorage is ERC721 {
1057     using Strings for uint256;
1058 
1059     // Optional mapping for token URIs
1060     mapping(uint256 => string) private _tokenURIs;
1061 
1062     /**
1063      * @dev See {IERC721Metadata-tokenURI}.
1064      */
1065     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1066         _requireMinted(tokenId);
1067 
1068         string memory _tokenURI = _tokenURIs[tokenId];
1069         string memory base = _baseURI();
1070 
1071         // If there is no base URI, return the token URI.
1072         if (bytes(base).length == 0) {
1073             return _tokenURI;
1074         }
1075         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1076         if (bytes(_tokenURI).length > 0) {
1077             return string(abi.encodePacked(base, _tokenURI));
1078         }
1079 
1080         return super.tokenURI(tokenId);
1081     }
1082 
1083     /**
1084      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      */
1090     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1091         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1092         _tokenURIs[tokenId] = _tokenURI;
1093     }
1094 
1095     /**
1096      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1097      * token-specific URI was set for the token, and if so, it deletes the token URI from
1098      * the storage mapping.
1099      */
1100     function _burn(uint256 tokenId) internal virtual override {
1101         super._burn(tokenId);
1102 
1103         if (bytes(_tokenURIs[tokenId]).length != 0) {
1104             delete _tokenURIs[tokenId];
1105         }
1106     }
1107 }
1108 
1109 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1110 
1111 
1112 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1113 
1114 pragma solidity ^0.8.0;
1115 
1116 /**
1117  * @dev _Available since v3.1._
1118  */
1119 interface IERC1155Receiver is IERC165 {
1120     /**
1121      * @dev Handles the receipt of a single ERC1155 token type. This function is
1122      * called at the end of a `safeTransferFrom` after the balance has been updated.
1123      *
1124      * NOTE: To accept the transfer, this must return
1125      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1126      * (i.e. 0xf23a6e61, or its own function selector).
1127      *
1128      * @param operator The address which initiated the transfer (i.e. msg.sender)
1129      * @param from The address which previously owned the token
1130      * @param id The ID of the token being transferred
1131      * @param value The amount of tokens being transferred
1132      * @param data Additional data with no specified format
1133      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1134      */
1135     function onERC1155Received(
1136         address operator,
1137         address from,
1138         uint256 id,
1139         uint256 value,
1140         bytes calldata data
1141     ) external returns (bytes4);
1142 
1143     /**
1144      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1145      * is called at the end of a `safeBatchTransferFrom` after the balances have
1146      * been updated.
1147      *
1148      * NOTE: To accept the transfer(s), this must return
1149      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1150      * (i.e. 0xbc197c81, or its own function selector).
1151      *
1152      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1153      * @param from The address which previously owned the token
1154      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1155      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1156      * @param data Additional data with no specified format
1157      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1158      */
1159     function onERC1155BatchReceived(
1160         address operator,
1161         address from,
1162         uint256[] calldata ids,
1163         uint256[] calldata values,
1164         bytes calldata data
1165     ) external returns (bytes4);
1166 }
1167 
1168 // File: @openzeppelin/contracts/access/Ownable.sol
1169 
1170 
1171 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1172 
1173 pragma solidity ^0.8.0;
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
1196         _transferOwnership(_msgSender());
1197     }
1198 
1199     /**
1200      * @dev Throws if called by any account other than the owner.
1201      */
1202     modifier onlyOwner() {
1203         _checkOwner();
1204         _;
1205     }
1206 
1207     /**
1208      * @dev Returns the address of the current owner.
1209      */
1210     function owner() public view virtual returns (address) {
1211         return _owner;
1212     }
1213 
1214     /**
1215      * @dev Throws if the sender is not the owner.
1216      */
1217     function _checkOwner() internal view virtual {
1218         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1219     }
1220 
1221     /**
1222      * @dev Leaves the contract without owner. It will not be possible to call
1223      * `onlyOwner` functions anymore. Can only be called by the current owner.
1224      *
1225      * NOTE: Renouncing ownership will leave the contract without an owner,
1226      * thereby removing any functionality that is only available to the owner.
1227      */
1228     function renounceOwnership() public virtual onlyOwner {
1229         _transferOwnership(address(0));
1230     }
1231 
1232     /**
1233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1234      * Can only be called by the current owner.
1235      */
1236     function transferOwnership(address newOwner) public virtual onlyOwner {
1237         require(newOwner != address(0), "Ownable: new owner is the zero address");
1238         _transferOwnership(newOwner);
1239     }
1240 
1241     /**
1242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1243      * Internal function without access restriction.
1244      */
1245     function _transferOwnership(address newOwner) internal virtual {
1246         address oldOwner = _owner;
1247         _owner = newOwner;
1248         emit OwnershipTransferred(oldOwner, newOwner);
1249     }
1250 }
1251 
1252 // File: @openzeppelin/contracts/utils/Counters.sol
1253 
1254 
1255 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 /**
1260  * @title Counters
1261  * @author Matt Condon (@shrugs)
1262  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1263  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1264  *
1265  * Include with `using Counters for Counters.Counter;`
1266  */
1267 library Counters {
1268     struct Counter {
1269         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1270         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1271         // this feature: see https://github.com/ethereum/solidity/issues/4637
1272         uint256 _value; // default: 0
1273     }
1274 
1275     function current(Counter storage counter) internal view returns (uint256) {
1276         return counter._value;
1277     }
1278 
1279     function increment(Counter storage counter) internal {
1280         unchecked {
1281             counter._value += 1;
1282         }
1283     }
1284 
1285     function decrement(Counter storage counter) internal {
1286         uint256 value = counter._value;
1287         require(value > 0, "Counter: decrement overflow");
1288         unchecked {
1289             counter._value = value - 1;
1290         }
1291     }
1292 
1293     function reset(Counter storage counter) internal {
1294         counter._value = 0;
1295     }
1296 }
1297 
1298 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1299 
1300 
1301 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
1302 
1303 pragma solidity ^0.8.0;
1304 
1305 /**
1306  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1307  *
1308  * These functions can be used to verify that a message was signed by the holder
1309  * of the private keys of a given address.
1310  */
1311 library ECDSA {
1312     enum RecoverError {
1313         NoError,
1314         InvalidSignature,
1315         InvalidSignatureLength,
1316         InvalidSignatureS,
1317         InvalidSignatureV
1318     }
1319 
1320     function _throwError(RecoverError error) private pure {
1321         if (error == RecoverError.NoError) {
1322             return; // no error: do nothing
1323         } else if (error == RecoverError.InvalidSignature) {
1324             revert("ECDSA: invalid signature");
1325         } else if (error == RecoverError.InvalidSignatureLength) {
1326             revert("ECDSA: invalid signature length");
1327         } else if (error == RecoverError.InvalidSignatureS) {
1328             revert("ECDSA: invalid signature 's' value");
1329         } else if (error == RecoverError.InvalidSignatureV) {
1330             revert("ECDSA: invalid signature 'v' value");
1331         }
1332     }
1333 
1334     /**
1335      * @dev Returns the address that signed a hashed message (`hash`) with
1336      * `signature` or error string. This address can then be used for verification purposes.
1337      *
1338      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1339      * this function rejects them by requiring the `s` value to be in the lower
1340      * half order, and the `v` value to be either 27 or 28.
1341      *
1342      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1343      * verification to be secure: it is possible to craft signatures that
1344      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1345      * this is by receiving a hash of the original message (which may otherwise
1346      * be too long), and then calling {toEthSignedMessageHash} on it.
1347      *
1348      * Documentation for signature generation:
1349      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1350      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1351      *
1352      * _Available since v4.3._
1353      */
1354     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1355         // Check the signature length
1356         // - case 65: r,s,v signature (standard)
1357         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1358         if (signature.length == 65) {
1359             bytes32 r;
1360             bytes32 s;
1361             uint8 v;
1362             // ecrecover takes the signature parameters, and the only way to get them
1363             // currently is to use assembly.
1364             /// @solidity memory-safe-assembly
1365             assembly {
1366                 r := mload(add(signature, 0x20))
1367                 s := mload(add(signature, 0x40))
1368                 v := byte(0, mload(add(signature, 0x60)))
1369             }
1370             return tryRecover(hash, v, r, s);
1371         } else if (signature.length == 64) {
1372             bytes32 r;
1373             bytes32 vs;
1374             // ecrecover takes the signature parameters, and the only way to get them
1375             // currently is to use assembly.
1376             /// @solidity memory-safe-assembly
1377             assembly {
1378                 r := mload(add(signature, 0x20))
1379                 vs := mload(add(signature, 0x40))
1380             }
1381             return tryRecover(hash, r, vs);
1382         } else {
1383             return (address(0), RecoverError.InvalidSignatureLength);
1384         }
1385     }
1386 
1387     /**
1388      * @dev Returns the address that signed a hashed message (`hash`) with
1389      * `signature`. This address can then be used for verification purposes.
1390      *
1391      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1392      * this function rejects them by requiring the `s` value to be in the lower
1393      * half order, and the `v` value to be either 27 or 28.
1394      *
1395      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1396      * verification to be secure: it is possible to craft signatures that
1397      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1398      * this is by receiving a hash of the original message (which may otherwise
1399      * be too long), and then calling {toEthSignedMessageHash} on it.
1400      */
1401     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1402         (address recovered, RecoverError error) = tryRecover(hash, signature);
1403         _throwError(error);
1404         return recovered;
1405     }
1406 
1407     /**
1408      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1409      *
1410      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1411      *
1412      * _Available since v4.3._
1413      */
1414     function tryRecover(
1415         bytes32 hash,
1416         bytes32 r,
1417         bytes32 vs
1418     ) internal pure returns (address, RecoverError) {
1419         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1420         uint8 v = uint8((uint256(vs) >> 255) + 27);
1421         return tryRecover(hash, v, r, s);
1422     }
1423 
1424     /**
1425      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1426      *
1427      * _Available since v4.2._
1428      */
1429     function recover(
1430         bytes32 hash,
1431         bytes32 r,
1432         bytes32 vs
1433     ) internal pure returns (address) {
1434         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1435         _throwError(error);
1436         return recovered;
1437     }
1438 
1439     /**
1440      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1441      * `r` and `s` signature fields separately.
1442      *
1443      * _Available since v4.3._
1444      */
1445     function tryRecover(
1446         bytes32 hash,
1447         uint8 v,
1448         bytes32 r,
1449         bytes32 s
1450     ) internal pure returns (address, RecoverError) {
1451         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1452         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1453         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1454         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1455         //
1456         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1457         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1458         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1459         // these malleable signatures as well.
1460         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1461             return (address(0), RecoverError.InvalidSignatureS);
1462         }
1463         if (v != 27 && v != 28) {
1464             return (address(0), RecoverError.InvalidSignatureV);
1465         }
1466 
1467         // If the signature is valid (and not malleable), return the signer address
1468         address signer = ecrecover(hash, v, r, s);
1469         if (signer == address(0)) {
1470             return (address(0), RecoverError.InvalidSignature);
1471         }
1472 
1473         return (signer, RecoverError.NoError);
1474     }
1475 
1476     /**
1477      * @dev Overload of {ECDSA-recover} that receives the `v`,
1478      * `r` and `s` signature fields separately.
1479      */
1480     function recover(
1481         bytes32 hash,
1482         uint8 v,
1483         bytes32 r,
1484         bytes32 s
1485     ) internal pure returns (address) {
1486         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1487         _throwError(error);
1488         return recovered;
1489     }
1490 
1491     /**
1492      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1493      * produces hash corresponding to the one signed with the
1494      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1495      * JSON-RPC method as part of EIP-191.
1496      *
1497      * See {recover}.
1498      */
1499     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1500         // 32 is the length in bytes of hash,
1501         // enforced by the type signature above
1502         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1503     }
1504 
1505     /**
1506      * @dev Returns an Ethereum Signed Message, created from `s`. This
1507      * produces hash corresponding to the one signed with the
1508      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1509      * JSON-RPC method as part of EIP-191.
1510      *
1511      * See {recover}.
1512      */
1513     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1514         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1515     }
1516 
1517     /**
1518      * @dev Returns an Ethereum Signed Typed Data, created from a
1519      * `domainSeparator` and a `structHash`. This produces hash corresponding
1520      * to the one signed with the
1521      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1522      * JSON-RPC method as part of EIP-712.
1523      *
1524      * See {recover}.
1525      */
1526     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1527         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1528     }
1529 }
1530 
1531 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1532 
1533 
1534 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1535 
1536 pragma solidity ^0.8.0;
1537 
1538 /**
1539  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1540  *
1541  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1542  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1543  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1544  *
1545  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1546  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1547  * ({_hashTypedDataV4}).
1548  *
1549  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1550  * the chain id to protect against replay attacks on an eventual fork of the chain.
1551  *
1552  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1553  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1554  *
1555  * _Available since v3.4._
1556  */
1557 abstract contract EIP712 {
1558     /* solhint-disable var-name-mixedcase */
1559     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1560     // invalidate the cached domain separator if the chain id changes.
1561     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1562     uint256 private immutable _CACHED_CHAIN_ID;
1563     address private immutable _CACHED_THIS;
1564 
1565     bytes32 private immutable _HASHED_NAME;
1566     bytes32 private immutable _HASHED_VERSION;
1567     bytes32 private immutable _TYPE_HASH;
1568 
1569     /* solhint-enable var-name-mixedcase */
1570 
1571     /**
1572      * @dev Initializes the domain separator and parameter caches.
1573      *
1574      * The meaning of `name` and `version` is specified in
1575      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1576      *
1577      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1578      * - `version`: the current major version of the signing domain.
1579      *
1580      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1581      * contract upgrade].
1582      */
1583     constructor(string memory name, string memory version) {
1584         bytes32 hashedName = keccak256(bytes(name));
1585         bytes32 hashedVersion = keccak256(bytes(version));
1586         bytes32 typeHash = keccak256(
1587             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1588         );
1589         _HASHED_NAME = hashedName;
1590         _HASHED_VERSION = hashedVersion;
1591         _CACHED_CHAIN_ID = block.chainid;
1592         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1593         _CACHED_THIS = address(this);
1594         _TYPE_HASH = typeHash;
1595     }
1596 
1597     /**
1598      * @dev Returns the domain separator for the current chain.
1599      */
1600     function _domainSeparatorV4() internal view returns (bytes32) {
1601         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1602             return _CACHED_DOMAIN_SEPARATOR;
1603         } else {
1604             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1605         }
1606     }
1607 
1608     function _buildDomainSeparator(
1609         bytes32 typeHash,
1610         bytes32 nameHash,
1611         bytes32 versionHash
1612     ) private view returns (bytes32) {
1613         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1614     }
1615 
1616     /**
1617      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1618      * function returns the hash of the fully encoded EIP712 message for this domain.
1619      *
1620      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1621      *
1622      * ```solidity
1623      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1624      *     keccak256("Mail(address to,string contents)"),
1625      *     mailTo,
1626      *     keccak256(bytes(mailContents))
1627      * )));
1628      * address signer = ECDSA.recover(digest, signature);
1629      * ```
1630      */
1631     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1632         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1633     }
1634 }
1635 
1636 // File: RareShoeCapsules.sol
1637 
1638 
1639 pragma solidity ^0.8.2;
1640 
1641 
1642 
1643 
1644 
1645 
1646 contract RareShoeCapsules is ERC721URIStorage, IERC1155Receiver, IERC721Receiver, EIP712, Ownable {
1647     using Counters for Counters.Counter;
1648 
1649     Counters.Counter private _tokenIdCounter;
1650 
1651     string _baseUri;
1652 
1653     uint public constant MAX_SUPPLY = 3000;
1654 
1655     uint public price = 0.08 ether;
1656 
1657     mapping(address => uint) public _addressToMintedFreeTokens;
1658 
1659     constructor() ERC721("Rare Shoe Capsules", "RSHOEC") EIP712("RSHOEC", "1.0.0") {}
1660 
1661     function _baseURI() internal view override returns (string memory) {
1662         return _baseUri;
1663     }
1664 
1665    function burnMint(address receiver,  string memory tokenURI) external payable returns (uint256) {
1666         require(totalSupply() <= MAX_SUPPLY, "not enough supply remaining");
1667         require(_addressToMintedFreeTokens[receiver] > 0, "not enough burned tokens");
1668 
1669         _addressToMintedFreeTokens[receiver] -= 1;
1670 
1671         uint256 tokenId = _tokenIdCounter.current();
1672         _tokenIdCounter.increment();
1673         _safeMint(receiver, tokenId);
1674         _setTokenURI(tokenId, tokenURI);
1675         return tokenId;
1676     }
1677 
1678     function mint(address receiver,  string memory tokenURI) external payable returns (uint256) {
1679         require(totalSupply() <= MAX_SUPPLY, "not enough supply remaining");
1680         require(msg.value >= price, "ether sent is under price");
1681 
1682         uint256 tokenId = _tokenIdCounter.current();
1683         _tokenIdCounter.increment();
1684         _safeMint(receiver, tokenId);
1685         _setTokenURI(tokenId, tokenURI);
1686         return tokenId;
1687     }
1688 
1689     function totalSupply() public view returns (uint) {
1690         return _tokenIdCounter.current();
1691     }
1692 
1693     function addFreeMint(address wallet, uint quantity) external onlyOwner {
1694         _addressToMintedFreeTokens[wallet] += quantity;
1695     }
1696 
1697     function setBaseURI(string memory newBaseURI) external onlyOwner {
1698         _baseUri = newBaseURI;
1699     }
1700 
1701     function setPrice(uint newPrice) external onlyOwner {
1702         price = newPrice;
1703     }
1704 
1705     function withdrawAll(address payable to) external onlyOwner {
1706         to.transfer(address(this).balance);
1707     }
1708 
1709     function onERC721Received(address, address from, uint256, bytes memory) public virtual override returns (bytes4) {
1710         _addressToMintedFreeTokens[from] += 1;
1711         return this.onERC721Received.selector;
1712     }
1713 
1714     function onERC1155Received(address, address from, uint256, uint256, bytes memory) public virtual override returns (bytes4) {
1715         _addressToMintedFreeTokens[from] += 1;
1716         return this.onERC1155Received.selector;
1717     }
1718 
1719     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {
1720         return this.onERC1155BatchReceived.selector;
1721     }
1722 }