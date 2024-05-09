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
1046 // File: @openzeppelin/contracts/access/Ownable.sol
1047 
1048 
1049 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 /**
1054  * @dev Contract module which provides a basic access control mechanism, where
1055  * there is an account (an owner) that can be granted exclusive access to
1056  * specific functions.
1057  *
1058  * By default, the owner account will be the one that deploys the contract. This
1059  * can later be changed with {transferOwnership}.
1060  *
1061  * This module is used through inheritance. It will make available the modifier
1062  * `onlyOwner`, which can be applied to your functions to restrict their use to
1063  * the owner.
1064  */
1065 abstract contract Ownable is Context {
1066     address private _owner;
1067 
1068     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1069 
1070     /**
1071      * @dev Initializes the contract setting the deployer as the initial owner.
1072      */
1073     constructor() {
1074         _transferOwnership(_msgSender());
1075     }
1076 
1077     /**
1078      * @dev Throws if called by any account other than the owner.
1079      */
1080     modifier onlyOwner() {
1081         _checkOwner();
1082         _;
1083     }
1084 
1085     /**
1086      * @dev Returns the address of the current owner.
1087      */
1088     function owner() public view virtual returns (address) {
1089         return _owner;
1090     }
1091 
1092     /**
1093      * @dev Throws if the sender is not the owner.
1094      */
1095     function _checkOwner() internal view virtual {
1096         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1097     }
1098 
1099     /**
1100      * @dev Leaves the contract without owner. It will not be possible to call
1101      * `onlyOwner` functions anymore. Can only be called by the current owner.
1102      *
1103      * NOTE: Renouncing ownership will leave the contract without an owner,
1104      * thereby removing any functionality that is only available to the owner.
1105      */
1106     function renounceOwnership() public virtual onlyOwner {
1107         _transferOwnership(address(0));
1108     }
1109 
1110     /**
1111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1112      * Can only be called by the current owner.
1113      */
1114     function transferOwnership(address newOwner) public virtual onlyOwner {
1115         require(newOwner != address(0), "Ownable: new owner is the zero address");
1116         _transferOwnership(newOwner);
1117     }
1118 
1119     /**
1120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1121      * Internal function without access restriction.
1122      */
1123     function _transferOwnership(address newOwner) internal virtual {
1124         address oldOwner = _owner;
1125         _owner = newOwner;
1126         emit OwnershipTransferred(oldOwner, newOwner);
1127     }
1128 }
1129 
1130 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1131 
1132 
1133 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 /**
1138  * @dev These functions deal with verification of Merkle Tree proofs.
1139  *
1140  * The proofs can be generated using the JavaScript library
1141  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1142  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1143  *
1144  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1145  *
1146  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1147  * hashing, or use a hash function other than keccak256 for hashing leaves.
1148  * This is because the concatenation of a sorted pair of internal nodes in
1149  * the merkle tree could be reinterpreted as a leaf value.
1150  */
1151 library MerkleProof {
1152     /**
1153      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1154      * defined by `root`. For this, a `proof` must be provided, containing
1155      * sibling hashes on the branch from the leaf to the root of the tree. Each
1156      * pair of leaves and each pair of pre-images are assumed to be sorted.
1157      */
1158     function verify(
1159         bytes32[] memory proof,
1160         bytes32 root,
1161         bytes32 leaf
1162     ) internal pure returns (bool) {
1163         return processProof(proof, leaf) == root;
1164     }
1165 
1166     /**
1167      * @dev Calldata version of {verify}
1168      *
1169      * _Available since v4.7._
1170      */
1171     function verifyCalldata(
1172         bytes32[] calldata proof,
1173         bytes32 root,
1174         bytes32 leaf
1175     ) internal pure returns (bool) {
1176         return processProofCalldata(proof, leaf) == root;
1177     }
1178 
1179     /**
1180      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1181      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1182      * hash matches the root of the tree. When processing the proof, the pairs
1183      * of leafs & pre-images are assumed to be sorted.
1184      *
1185      * _Available since v4.4._
1186      */
1187     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1188         bytes32 computedHash = leaf;
1189         for (uint256 i = 0; i < proof.length; i++) {
1190             computedHash = _hashPair(computedHash, proof[i]);
1191         }
1192         return computedHash;
1193     }
1194 
1195     /**
1196      * @dev Calldata version of {processProof}
1197      *
1198      * _Available since v4.7._
1199      */
1200     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1201         bytes32 computedHash = leaf;
1202         for (uint256 i = 0; i < proof.length; i++) {
1203             computedHash = _hashPair(computedHash, proof[i]);
1204         }
1205         return computedHash;
1206     }
1207 
1208     /**
1209      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1210      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1211      *
1212      * _Available since v4.7._
1213      */
1214     function multiProofVerify(
1215         bytes32[] memory proof,
1216         bool[] memory proofFlags,
1217         bytes32 root,
1218         bytes32[] memory leaves
1219     ) internal pure returns (bool) {
1220         return processMultiProof(proof, proofFlags, leaves) == root;
1221     }
1222 
1223     /**
1224      * @dev Calldata version of {multiProofVerify}
1225      *
1226      * _Available since v4.7._
1227      */
1228     function multiProofVerifyCalldata(
1229         bytes32[] calldata proof,
1230         bool[] calldata proofFlags,
1231         bytes32 root,
1232         bytes32[] memory leaves
1233     ) internal pure returns (bool) {
1234         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1235     }
1236 
1237     /**
1238      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1239      * consuming from one or the other at each step according to the instructions given by
1240      * `proofFlags`.
1241      *
1242      * _Available since v4.7._
1243      */
1244     function processMultiProof(
1245         bytes32[] memory proof,
1246         bool[] memory proofFlags,
1247         bytes32[] memory leaves
1248     ) internal pure returns (bytes32 merkleRoot) {
1249         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1250         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1251         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1252         // the merkle tree.
1253         uint256 leavesLen = leaves.length;
1254         uint256 totalHashes = proofFlags.length;
1255 
1256         // Check proof validity.
1257         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1258 
1259         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1260         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1261         bytes32[] memory hashes = new bytes32[](totalHashes);
1262         uint256 leafPos = 0;
1263         uint256 hashPos = 0;
1264         uint256 proofPos = 0;
1265         // At each step, we compute the next hash using two values:
1266         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1267         //   get the next hash.
1268         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1269         //   `proof` array.
1270         for (uint256 i = 0; i < totalHashes; i++) {
1271             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1272             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1273             hashes[i] = _hashPair(a, b);
1274         }
1275 
1276         if (totalHashes > 0) {
1277             return hashes[totalHashes - 1];
1278         } else if (leavesLen > 0) {
1279             return leaves[0];
1280         } else {
1281             return proof[0];
1282         }
1283     }
1284 
1285     /**
1286      * @dev Calldata version of {processMultiProof}
1287      *
1288      * _Available since v4.7._
1289      */
1290     function processMultiProofCalldata(
1291         bytes32[] calldata proof,
1292         bool[] calldata proofFlags,
1293         bytes32[] memory leaves
1294     ) internal pure returns (bytes32 merkleRoot) {
1295         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1296         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1297         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1298         // the merkle tree.
1299         uint256 leavesLen = leaves.length;
1300         uint256 totalHashes = proofFlags.length;
1301 
1302         // Check proof validity.
1303         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1304 
1305         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1306         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1307         bytes32[] memory hashes = new bytes32[](totalHashes);
1308         uint256 leafPos = 0;
1309         uint256 hashPos = 0;
1310         uint256 proofPos = 0;
1311         // At each step, we compute the next hash using two values:
1312         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1313         //   get the next hash.
1314         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1315         //   `proof` array.
1316         for (uint256 i = 0; i < totalHashes; i++) {
1317             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1318             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1319             hashes[i] = _hashPair(a, b);
1320         }
1321 
1322         if (totalHashes > 0) {
1323             return hashes[totalHashes - 1];
1324         } else if (leavesLen > 0) {
1325             return leaves[0];
1326         } else {
1327             return proof[0];
1328         }
1329     }
1330 
1331     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1332         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1333     }
1334 
1335     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1336         /// @solidity memory-safe-assembly
1337         assembly {
1338             mstore(0x00, a)
1339             mstore(0x20, b)
1340             value := keccak256(0x00, 0x40)
1341         }
1342     }
1343 }
1344 
1345 // File: contracts/ISupportMint.sol
1346 
1347 
1348 pragma solidity >=0.4.22 <0.9.0;
1349 
1350 interface ISupportMint {
1351     function mint(address to) external;
1352 }
1353 
1354 // File: contracts/NftMelter.sol
1355 
1356 pragma solidity >=0.4.22 <0.9.0;
1357 pragma experimental ABIEncoderV2;
1358 
1359 
1360 
1361 contract NftMelter is Ownable {
1362     address public BLACK_HOLE = 0x000000000000000000000000000000000000dEaD;
1363     bytes32 public merkleRoot;
1364 
1365     function setMerkleRoot(bytes32 value) public onlyOwner {
1366         merkleRoot = value;
1367     }
1368 
1369     function compose(address partNft, uint[] memory tokenids, uint partPerProductCount, address productNft, bytes32[] calldata _merkleProof) public {
1370         if (merkleRoot != 0) {
1371             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1372             require(
1373                 MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1374                 "Invalid proof."
1375             );
1376         }
1377 
1378         require(tokenids.length % partPerProductCount == 0, "INVALID_TOKEN_COUNT");
1379 
1380         for (uint i = 0; i < tokenids.length; i += partPerProductCount) {
1381             for (uint j = 0; j < partPerProductCount; j++) {
1382                 ERC721(partNft).safeTransferFrom(msg.sender, BLACK_HOLE, tokenids[i + j]);
1383             }
1384 
1385             ISupportMint(productNft).mint(msg.sender);
1386         }
1387     }
1388 }