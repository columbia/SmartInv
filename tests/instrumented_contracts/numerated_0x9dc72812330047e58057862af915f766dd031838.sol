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
1046 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1047 
1048 
1049 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 /**
1054  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1055  * @dev See https://eips.ethereum.org/EIPS/eip-721
1056  */
1057 interface IERC721Enumerable is IERC721 {
1058     /**
1059      * @dev Returns the total amount of tokens stored by the contract.
1060      */
1061     function totalSupply() external view returns (uint256);
1062 
1063     /**
1064      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1065      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1066      */
1067     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1068 
1069     /**
1070      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1071      * Use along with {totalSupply} to enumerate all tokens.
1072      */
1073     function tokenByIndex(uint256 index) external view returns (uint256);
1074 }
1075 
1076 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1077 
1078 
1079 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 
1084 /**
1085  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1086  * enumerability of all the token ids in the contract as well as all token ids owned by each
1087  * account.
1088  */
1089 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1090     // Mapping from owner to list of owned token IDs
1091     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1092 
1093     // Mapping from token ID to index of the owner tokens list
1094     mapping(uint256 => uint256) private _ownedTokensIndex;
1095 
1096     // Array with all token ids, used for enumeration
1097     uint256[] private _allTokens;
1098 
1099     // Mapping from token id to position in the allTokens array
1100     mapping(uint256 => uint256) private _allTokensIndex;
1101 
1102     /**
1103      * @dev See {IERC165-supportsInterface}.
1104      */
1105     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1106         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1111      */
1112     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1113         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1114         return _ownedTokens[owner][index];
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Enumerable-totalSupply}.
1119      */
1120     function totalSupply() public view virtual override returns (uint256) {
1121         return _allTokens.length;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Enumerable-tokenByIndex}.
1126      */
1127     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1128         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1129         return _allTokens[index];
1130     }
1131 
1132     /**
1133      * @dev Hook that is called before any token transfer. This includes minting
1134      * and burning.
1135      *
1136      * Calling conditions:
1137      *
1138      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1139      * transferred to `to`.
1140      * - When `from` is zero, `tokenId` will be minted for `to`.
1141      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1142      * - `from` cannot be the zero address.
1143      * - `to` cannot be the zero address.
1144      *
1145      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1146      */
1147     function _beforeTokenTransfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) internal virtual override {
1152         super._beforeTokenTransfer(from, to, tokenId);
1153 
1154         if (from == address(0)) {
1155             _addTokenToAllTokensEnumeration(tokenId);
1156         } else if (from != to) {
1157             _removeTokenFromOwnerEnumeration(from, tokenId);
1158         }
1159         if (to == address(0)) {
1160             _removeTokenFromAllTokensEnumeration(tokenId);
1161         } else if (to != from) {
1162             _addTokenToOwnerEnumeration(to, tokenId);
1163         }
1164     }
1165 
1166     /**
1167      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1168      * @param to address representing the new owner of the given token ID
1169      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1170      */
1171     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1172         uint256 length = ERC721.balanceOf(to);
1173         _ownedTokens[to][length] = tokenId;
1174         _ownedTokensIndex[tokenId] = length;
1175     }
1176 
1177     /**
1178      * @dev Private function to add a token to this extension's token tracking data structures.
1179      * @param tokenId uint256 ID of the token to be added to the tokens list
1180      */
1181     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1182         _allTokensIndex[tokenId] = _allTokens.length;
1183         _allTokens.push(tokenId);
1184     }
1185 
1186     /**
1187      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1188      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1189      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1190      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1191      * @param from address representing the previous owner of the given token ID
1192      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1193      */
1194     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1195         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1196         // then delete the last slot (swap and pop).
1197 
1198         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1199         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1200 
1201         // When the token to delete is the last token, the swap operation is unnecessary
1202         if (tokenIndex != lastTokenIndex) {
1203             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1204 
1205             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1206             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1207         }
1208 
1209         // This also deletes the contents at the last position of the array
1210         delete _ownedTokensIndex[tokenId];
1211         delete _ownedTokens[from][lastTokenIndex];
1212     }
1213 
1214     /**
1215      * @dev Private function to remove a token from this extension's token tracking data structures.
1216      * This has O(1) time complexity, but alters the order of the _allTokens array.
1217      * @param tokenId uint256 ID of the token to be removed from the tokens list
1218      */
1219     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1220         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1221         // then delete the last slot (swap and pop).
1222 
1223         uint256 lastTokenIndex = _allTokens.length - 1;
1224         uint256 tokenIndex = _allTokensIndex[tokenId];
1225 
1226         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1227         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1228         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1229         uint256 lastTokenId = _allTokens[lastTokenIndex];
1230 
1231         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1232         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1233 
1234         // This also deletes the contents at the last position of the array
1235         delete _allTokensIndex[tokenId];
1236         _allTokens.pop();
1237     }
1238 }
1239 
1240 // File: @openzeppelin/contracts/access/Ownable.sol
1241 
1242 
1243 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 /**
1248  * @dev Contract module which provides a basic access control mechanism, where
1249  * there is an account (an owner) that can be granted exclusive access to
1250  * specific functions.
1251  *
1252  * By default, the owner account will be the one that deploys the contract. This
1253  * can later be changed with {transferOwnership}.
1254  *
1255  * This module is used through inheritance. It will make available the modifier
1256  * `onlyOwner`, which can be applied to your functions to restrict their use to
1257  * the owner.
1258  */
1259 abstract contract Ownable is Context {
1260     address private _owner;
1261 
1262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1263 
1264     /**
1265      * @dev Initializes the contract setting the deployer as the initial owner.
1266      */
1267     constructor() {
1268         _transferOwnership(_msgSender());
1269     }
1270 
1271     /**
1272      * @dev Throws if called by any account other than the owner.
1273      */
1274     modifier onlyOwner() {
1275         _checkOwner();
1276         _;
1277     }
1278 
1279     /**
1280      * @dev Returns the address of the current owner.
1281      */
1282     function owner() public view virtual returns (address) {
1283         return _owner;
1284     }
1285 
1286     /**
1287      * @dev Throws if the sender is not the owner.
1288      */
1289     function _checkOwner() internal view virtual {
1290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1291     }
1292 
1293     /**
1294      * @dev Leaves the contract without owner. It will not be possible to call
1295      * `onlyOwner` functions anymore. Can only be called by the current owner.
1296      *
1297      * NOTE: Renouncing ownership will leave the contract without an owner,
1298      * thereby removing any functionality that is only available to the owner.
1299      */
1300     function renounceOwnership() public virtual onlyOwner {
1301         _transferOwnership(address(0));
1302     }
1303 
1304     /**
1305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1306      * Can only be called by the current owner.
1307      */
1308     function transferOwnership(address newOwner) public virtual onlyOwner {
1309         require(newOwner != address(0), "Ownable: new owner is the zero address");
1310         _transferOwnership(newOwner);
1311     }
1312 
1313     /**
1314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1315      * Internal function without access restriction.
1316      */
1317     function _transferOwnership(address newOwner) internal virtual {
1318         address oldOwner = _owner;
1319         _owner = newOwner;
1320         emit OwnershipTransferred(oldOwner, newOwner);
1321     }
1322 }
1323 
1324 // File: @openzeppelin/contracts/utils/Counters.sol
1325 
1326 
1327 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 /**
1332  * @title Counters
1333  * @author Matt Condon (@shrugs)
1334  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1335  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1336  *
1337  * Include with `using Counters for Counters.Counter;`
1338  */
1339 library Counters {
1340     struct Counter {
1341         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1342         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1343         // this feature: see https://github.com/ethereum/solidity/issues/4637
1344         uint256 _value; // default: 0
1345     }
1346 
1347     function current(Counter storage counter) internal view returns (uint256) {
1348         return counter._value;
1349     }
1350 
1351     function increment(Counter storage counter) internal {
1352         unchecked {
1353             counter._value += 1;
1354         }
1355     }
1356 
1357     function decrement(Counter storage counter) internal {
1358         uint256 value = counter._value;
1359         require(value > 0, "Counter: decrement overflow");
1360         unchecked {
1361             counter._value = value - 1;
1362         }
1363     }
1364 
1365     function reset(Counter storage counter) internal {
1366         counter._value = 0;
1367     }
1368 }
1369 
1370 // File: @openzeppelin/contracts/utils/Base64.sol
1371 
1372 
1373 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
1374 
1375 pragma solidity ^0.8.0;
1376 
1377 /**
1378  * @dev Provides a set of functions to operate with Base64 strings.
1379  *
1380  * _Available since v4.5._
1381  */
1382 library Base64 {
1383     /**
1384      * @dev Base64 Encoding/Decoding Table
1385      */
1386     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1387 
1388     /**
1389      * @dev Converts a `bytes` to its Bytes64 `string` representation.
1390      */
1391     function encode(bytes memory data) internal pure returns (string memory) {
1392         /**
1393          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
1394          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
1395          */
1396         if (data.length == 0) return "";
1397 
1398         // Loads the table into memory
1399         string memory table = _TABLE;
1400 
1401         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
1402         // and split into 4 numbers of 6 bits.
1403         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
1404         // - `data.length + 2`  -> Round up
1405         // - `/ 3`              -> Number of 3-bytes chunks
1406         // - `4 *`              -> 4 characters for each chunk
1407         string memory result = new string(4 * ((data.length + 2) / 3));
1408 
1409         /// @solidity memory-safe-assembly
1410         assembly {
1411             // Prepare the lookup table (skip the first "length" byte)
1412             let tablePtr := add(table, 1)
1413 
1414             // Prepare result pointer, jump over length
1415             let resultPtr := add(result, 32)
1416 
1417             // Run over the input, 3 bytes at a time
1418             for {
1419                 let dataPtr := data
1420                 let endPtr := add(data, mload(data))
1421             } lt(dataPtr, endPtr) {
1422 
1423             } {
1424                 // Advance 3 bytes
1425                 dataPtr := add(dataPtr, 3)
1426                 let input := mload(dataPtr)
1427 
1428                 // To write each character, shift the 3 bytes (18 bits) chunk
1429                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
1430                 // and apply logical AND with 0x3F which is the number of
1431                 // the previous character in the ASCII table prior to the Base64 Table
1432                 // The result is then added to the table to get the character to write,
1433                 // and finally write it in the result pointer but with a left shift
1434                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
1435 
1436                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1437                 resultPtr := add(resultPtr, 1) // Advance
1438 
1439                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1440                 resultPtr := add(resultPtr, 1) // Advance
1441 
1442                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1443                 resultPtr := add(resultPtr, 1) // Advance
1444 
1445                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
1446                 resultPtr := add(resultPtr, 1) // Advance
1447             }
1448 
1449             // When data `bytes` is not exactly 3 bytes long
1450             // it is padded with `=` characters at the end
1451             switch mod(mload(data), 3)
1452             case 1 {
1453                 mstore8(sub(resultPtr, 1), 0x3d)
1454                 mstore8(sub(resultPtr, 2), 0x3d)
1455             }
1456             case 2 {
1457                 mstore8(sub(resultPtr, 1), 0x3d)
1458             }
1459         }
1460 
1461         return result;
1462     }
1463 }
1464 
1465 // File: contracts/ProjectMaybeMintPass.sol
1466 
1467 
1468 pragma solidity ^0.8.1;
1469 
1470 
1471 
1472 
1473 contract ProjectMaybeMintPass is ERC721Enumerable, Ownable {
1474     using Counters for Counters.Counter;
1475 
1476     Counters.Counter private _tokenIdCounter;
1477     string private _baseUri;
1478     string uriSuffix = ".json";
1479     
1480     uint256 public constant MAX_SUPPLY = 500;
1481     uint256 public constant OG_SUPPLY = 130;
1482     uint256 public maxMintQuantity = 1;
1483     bool public isOGSalesActive = true;
1484     bool public isWLSalesActive = false;
1485     bool public isSalesActive = true;
1486     
1487     mapping(address => bool) private OGAddresses;
1488     mapping(address => bool) private WLAddresses;
1489 
1490     constructor(string memory baseUri) ERC721("Project Maybe Mint Pass", "PROJECTMAYBE") {
1491         _baseUri = baseUri;
1492     }
1493     
1494     function mint() external payable { 
1495         uint256 supply = totalSupply();
1496         uint256[] memory ownerTokenIds = walletOfOwner(msg.sender);
1497         require(isSalesActive, "mint is not active");
1498         require(ownerTokenIds.length < maxMintQuantity, "Cannot mint more than maximum quantity");
1499         if (isOGSalesActive) {
1500             require(OGAddresses[msg.sender] == true, "address not in the OG list");
1501             require(supply < OG_SUPPLY, "Exceeds maximum OG supply");
1502         }
1503         if (isWLSalesActive) {
1504             require(WLAddresses[msg.sender] == true, "address not in the whitelist");
1505         }
1506         require(supply < MAX_SUPPLY, "Exceeds maximum supply");
1507         
1508         safeMint(msg.sender);
1509     }
1510 
1511     function safeMint(address to) internal {
1512         _tokenIdCounter.increment();
1513         uint256 tokenId = _tokenIdCounter.current();
1514         _safeMint(to, tokenId);
1515     }
1516 
1517     // mint unclaimed tokens to _to
1518     function mintUnclaimed(address _to, uint256[] memory _tokenIds) external onlyOwner {
1519         for(uint256 i=0; i < _tokenIds.length; i++) {
1520             _safeMint(_to, _tokenIds[i]);
1521         }
1522     }
1523 
1524     // give presale access to whitelist addresses
1525     function giveWLAccess(address[] memory _addresses) external onlyOwner {
1526         for (uint256 i = 0; i < _addresses.length; i++) {
1527             WLAddresses[_addresses[i]] = true;
1528         }
1529     }
1530 
1531     // give presale access to OG addresses
1532     function giveOGAccess(address[] memory _addresses) external onlyOwner {
1533         for (uint256 i = 0; i < _addresses.length; i++) {
1534             OGAddresses[_addresses[i]] = true;
1535         }
1536     }
1537 
1538     // get token URI of given token ID
1539     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1540         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1541         return string(abi.encodePacked(_baseUri, Strings.toString(_tokenId), uriSuffix));
1542     }
1543 
1544     // return all token IDs minted by _owner
1545     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1546         uint256 tokenCount = balanceOf(_owner);
1547 
1548         uint256[] memory tokensId = new uint256[](tokenCount);
1549         for(uint256 i; i < tokenCount; i++){
1550             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1551         }
1552         return tokensId;
1553     }
1554 
1555     function baseURI() external view returns (string memory) {
1556         return _baseUri;
1557     }
1558 
1559     function setBaseURI(string memory newBaseUri) external onlyOwner {
1560         _baseUri = newBaseUri;
1561     }
1562 
1563     function toggleOGSales() external onlyOwner {
1564         isOGSalesActive = !isOGSalesActive;
1565     }
1566 
1567     function toggleWLSales() external onlyOwner {
1568         isWLSalesActive = !isWLSalesActive;
1569     }
1570 
1571     function toggleSales() external onlyOwner {
1572         isSalesActive = !isSalesActive;
1573     }
1574 }
1575 
1576 // File: contracts/Tiro.sol
1577 
1578 
1579 pragma solidity ^0.8.0;
1580 
1581 
1582 
1583 
1584 
1585 
1586 
1587 contract Tiro is ERC721Enumerable, Ownable {
1588     using Counters for Counters.Counter;
1589 
1590     Counters.Counter private _tokenIdCounter;
1591     string private _baseUri;
1592     
1593     uint256 public constant MAX_SUPPLY = 1111;
1594     uint256 public constant GOLD_MINT_PASS_MAX = 100;
1595     uint256 public price = 0.015 ether;
1596     uint256 public maxMintQuantity = 3;
1597     bool public isMintPassActive = true;
1598     bool public isWLActive = false;
1599     bool public isSalesActive = true;
1600 
1601     mapping(address => bool) private _wlAccess;
1602     mapping(uint256 => address) private _mintPassHolders;
1603     mapping(uint256 => address) private _usedMintPass;
1604 
1605     constructor(string memory baseUri) ERC721("TIRO - Time Is Running Out", "TIRO") {
1606         _baseUri = baseUri;
1607     }
1608     
1609     function mint(uint quantity, uint256[] memory mintPassTokenIds) external payable {
1610         uint256 mintedQuantity = totalSupply();
1611         uint256[] memory ownerTokenIds = walletOfOwner(msg.sender);
1612         uint256 paidMintQuantity = quantity;
1613         require(isSalesActive, "sales is not active");
1614         require(mintedQuantity < MAX_SUPPLY, "All sold out");
1615         if (mintPassTokenIds.length > 0) {
1616             for(uint256 i=0; i < mintPassTokenIds.length; i++) {
1617                 // check if the msg.sender is indeed the snapshot address for the mint pass tokenID
1618                 require(_mintPassHolders[mintPassTokenIds[i]-1] == msg.sender, "Sender is not a rightful owner of the submitted Mint Passes");
1619                 require(usedMintPassByTokenId(mintPassTokenIds[i]) == address(0), "At least one of the Mint Passes had already been used");
1620             }
1621 
1622             // count mint other than from mint pass
1623             uint256 freemintQuantity = _covertMintPassQuantity(mintPassTokenIds);
1624             paidMintQuantity = quantity - freemintQuantity;
1625         }
1626         require(paidMintQuantity >= 0, "paid quantity cannot be negative");
1627         // paid mint
1628         if (paidMintQuantity >= 1) {
1629             if (isMintPassActive) {
1630                 // guard off anyone who tries to mint more than the number of mint pass during the pre-WL time
1631                 require(paidMintQuantity == 0, "No paid mint during Mint Pass hour");
1632             }
1633             else {
1634                 if (isWLActive) {
1635                     require(_wlAccess[msg.sender] == true, "address not in the whitelist");
1636                 }
1637                 require(paidMintQuantity <= maxMintQuantity, "Cannot mint more than maximum quantity per wallet");
1638                 require(ownerTokenIds.length <= maxMintQuantity, "Cannot mint more than maximum quantity per wallet");
1639             }
1640             require(mintedQuantity + quantity <= MAX_SUPPLY, "Exceeds maximum supply");
1641             require(msg.value >= price * paidMintQuantity, "ether send is under price");
1642         } 
1643         else {
1644             // if holder uses mint pass and remaining quantity is less than number of mint pass, allow holder to mint everything that is left
1645             if (mintedQuantity + quantity > MAX_SUPPLY) {
1646                 quantity = MAX_SUPPLY - mintedQuantity;
1647             }
1648         }
1649 
1650         // update the mint pass tokens as used
1651         for(uint256 i=0; i < mintPassTokenIds.length; i++) {
1652             _usedMintPass[mintPassTokenIds[i]] = msg.sender;
1653         }
1654         
1655         for (uint256 i = 0; i < quantity; i++) {
1656             safeMint(msg.sender);
1657         }
1658     }
1659 
1660     function safeMint(address to) internal {
1661         _tokenIdCounter.increment();
1662         uint256 tokenId = _tokenIdCounter.current();
1663         _safeMint(to, tokenId);
1664     }
1665 
1666     function _covertMintPassQuantity(uint256[] memory mintPassTokenIds) internal pure returns (uint256) {
1667         uint256 mintPassQuantity = mintPassTokenIds.length;
1668         for (uint256 i=0; i < mintPassTokenIds.length; i++) {
1669             // Gold Mint Pass gets 2 Free mint
1670             if (mintPassTokenIds[i] <= GOLD_MINT_PASS_MAX) {
1671                 mintPassQuantity += 1;
1672             }
1673         }
1674         return mintPassQuantity;
1675     }
1676 
1677     // mint unclaimed tokens to _to
1678     function mintUnclaimed(address to, uint256[] memory tokenIds) external onlyOwner {
1679         for(uint256 i=0; i < tokenIds.length; i++) {
1680             _safeMint(to, tokenIds[i]);
1681         }
1682     }
1683 
1684     // assign mint pass holders addresses
1685     function snapshotMintPassHolders(address[] memory addresses) external onlyOwner {
1686         for (uint256 i = 0; i < addresses.length; i++) {
1687             _mintPassHolders[i] = addresses[i];
1688         }
1689     }
1690 
1691     // give presale access to whitelist addresses
1692     function give_wlAccess(address[] memory addresses) external onlyOwner {
1693         for (uint256 i = 0; i < addresses.length; i++) {
1694             _wlAccess[addresses[i]] = true;
1695         }
1696     }
1697 
1698     // get token URI of given token ID
1699     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1700         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1701         return string(abi.encodePacked(_baseUri, Strings.toString(_tokenId), ".json"));
1702     }
1703 
1704     // return all token IDs minted by _owner
1705     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1706         uint256 tokenCount = balanceOf(_owner);
1707 
1708         uint256[] memory tokensId = new uint256[](tokenCount);
1709         for(uint256 i; i < tokenCount; i++){
1710             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1711         }
1712         return tokensId;
1713     }
1714 
1715     // return address of whom used the mint pass token
1716     function usedMintPassByTokenId(uint256 tokenId) public view returns (address) {
1717         return _usedMintPass[tokenId];
1718     }
1719 
1720     function baseURI() external view returns (string memory) {
1721         return _baseUri;
1722     }
1723 
1724     function setBaseURI(string memory newBaseUri) external onlyOwner {
1725         _baseUri = newBaseUri;
1726     }
1727 
1728     function toggleSales(bool mintpass, bool wl, bool sales, uint256 newPrice) external onlyOwner {
1729         isMintPassActive = mintpass;
1730         isWLActive = wl;
1731         isSalesActive = sales;
1732         price = newPrice;
1733     }
1734     
1735     function withdrawAll() external onlyOwner {
1736         require(payable(msg.sender).send(address(this).balance));
1737     }
1738 }