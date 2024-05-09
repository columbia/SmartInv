1 // File: @openzeppelin\contracts\utils\introspection\IERC165.sol
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
29 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
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
173 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
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
203 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
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
231 // File: @openzeppelin\contracts\utils\Address.sol
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
456 // File: @openzeppelin\contracts\utils\Context.sol
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
483 // File: @openzeppelin\contracts\utils\Strings.sol
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
561 // File: @openzeppelin\contracts\utils\introspection\ERC165.sol
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Implementation of the {IERC165} interface.
569  *
570  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
571  * for the additional interface id that will be supported. For example:
572  *
573  * ```solidity
574  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
576  * }
577  * ```
578  *
579  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
580  */
581 abstract contract ERC165 is IERC165 {
582     /**
583      * @dev See {IERC165-supportsInterface}.
584      */
585     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
586         return interfaceId == type(IERC165).interfaceId;
587     }
588 }
589 
590 // File: contracts\ERC721A.sol
591 
592 pragma solidity ^0.8.0;
593 /**
594  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
595  * the Metadata extension. Built to optimize for lower gas during batch mints.
596  *
597  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
598  *
599  * Does not support burning tokens to address(0).
600  *
601  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
602  */
603 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
604     using Address for address;
605     using Strings for uint256;
606 
607     struct TokenOwnership {
608         address addr;
609         uint64 startTimestamp;
610     }
611 
612     struct AddressData {
613         uint128 balance;
614         uint128 numberMinted;
615     }
616 
617     uint256 internal currentIndex;
618 
619     // Token name
620     string private _name;
621 
622     // Token symbol
623     string private _symbol;
624 
625     // Mapping from token ID to ownership details
626     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
627     mapping(uint256 => TokenOwnership) internal _ownerships;
628 
629     // Mapping owner address to address data
630     mapping(address => AddressData) private _addressData;
631 
632     // Mapping from token ID to approved address
633     mapping(uint256 => address) private _tokenApprovals;
634 
635     // Mapping from owner to operator approvals
636     mapping(address => mapping(address => bool)) private _operatorApprovals;
637 
638     constructor(string memory name_, string memory symbol_) {
639         _name = name_;
640         _symbol = symbol_;
641     }
642 
643     function totalSupply() public view returns (uint256) {
644         return currentIndex;
645     }
646 
647     /**
648      * @dev See {IERC165-supportsInterface}.
649      */
650     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
651         return
652         interfaceId == type(IERC721).interfaceId ||
653         interfaceId == type(IERC721Metadata).interfaceId ||
654         super.supportsInterface(interfaceId);
655     }
656 
657     /**
658      * @dev See {IERC721-balanceOf}.
659      */
660     function balanceOf(address owner) public view override returns (uint256) {
661         require(owner != address(0), 'ERC721A: balance query for the zero address');
662         return uint256(_addressData[owner].balance);
663     }
664 
665     function _numberMinted(address owner) internal view returns (uint256) {
666         require(owner != address(0), 'ERC721A: number minted query for the zero address');
667         return uint256(_addressData[owner].numberMinted);
668     }
669 
670     /**
671      * Gas spent here starts off proportional to the maximum mint batch size.
672      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
673      */
674     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
675         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
676 
677     unchecked {
678         for (uint256 curr = tokenId; curr >= 0; curr--) {
679             TokenOwnership memory ownership = _ownerships[curr];
680             if (ownership.addr != address(0)) {
681                 return ownership;
682             }
683         }
684     }
685 
686         revert('ERC721A: unable to determine the owner of token');
687     }
688 
689     /**
690      * @dev See {IERC721-ownerOf}.
691      */
692     function ownerOf(uint256 tokenId) public view override returns (address) {
693         return ownershipOf(tokenId).addr;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-name}.
698      */
699     function name() public view virtual override returns (string memory) {
700         return _name;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-symbol}.
705      */
706     function symbol() public view virtual override returns (string memory) {
707         return _symbol;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-tokenURI}.
712      */
713     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
714         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
715 
716         string memory baseURI = _baseURI();
717         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
718     }
719 
720     /**
721      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
722      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
723      * by default, can be overriden in child contracts.
724      */
725     function _baseURI() internal view virtual returns (string memory) {
726         return '';
727     }
728 
729     /**
730      * @dev See {IERC721-approve}.
731      */
732     function approve(address to, uint256 tokenId) public override {
733         address owner = ERC721A.ownerOf(tokenId);
734         require(to != owner, 'ERC721A: approval to current owner');
735 
736         require(
737             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
738             'ERC721A: approve caller is not owner nor approved for all'
739         );
740 
741         _approve(to, tokenId, owner);
742     }
743 
744     /**
745      * @dev See {IERC721-getApproved}.
746      */
747     function getApproved(uint256 tokenId) public view override returns (address) {
748         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
749 
750         return _tokenApprovals[tokenId];
751     }
752 
753     /**
754      * @dev See {IERC721-setApprovalForAll}.
755      */
756     function setApprovalForAll(address operator, bool approved) public override {
757         require(operator != _msgSender(), 'ERC721A: approve to caller');
758 
759         _operatorApprovals[_msgSender()][operator] = approved;
760         emit ApprovalForAll(_msgSender(), operator, approved);
761     }
762 
763     /**
764      * @dev See {IERC721-isApprovedForAll}.
765      */
766     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
767         return _operatorApprovals[owner][operator];
768     }
769 
770     /**
771      * @dev See {IERC721-transferFrom}.
772      */
773     function transferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) public override {
778         _transfer(from, to, tokenId);
779     }
780 
781     /**
782      * @dev See {IERC721-safeTransferFrom}.
783      */
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 tokenId
788     ) public override {
789         safeTransferFrom(from, to, tokenId, '');
790     }
791 
792     /**
793      * @dev See {IERC721-safeTransferFrom}.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) public override {
801         _transfer(from, to, tokenId);
802         require(
803             _checkOnERC721Received(from, to, tokenId, _data),
804             'ERC721A: transfer to non ERC721Receiver implementer'
805         );
806     }
807 
808     /**
809      * @dev Returns whether `tokenId` exists.
810      *
811      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
812      *
813      * Tokens start existing when they are minted (`_mint`),
814      */
815     function _exists(uint256 tokenId) internal view returns (bool) {
816         return tokenId < currentIndex;
817     }
818 
819     function _safeMint(address to, uint256 quantity) internal {
820         _safeMint(to, quantity, '');
821     }
822 
823     /**
824      * @dev Safely mints `quantity` tokens and transfers them to `to`.
825      *
826      * Requirements:
827      *
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
829      * - `quantity` must be greater than 0.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _safeMint(
834         address to,
835         uint256 quantity,
836         bytes memory _data
837     ) internal {
838         _mint(to, quantity, _data, true);
839     }
840 
841     /**
842      * @dev Mints `quantity` tokens and transfers them to `to`.
843      *
844      * Requirements:
845      *
846      * - `to` cannot be the zero address.
847      * - `quantity` must be greater than 0.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _mint(
852         address to,
853         uint256 quantity,
854         bytes memory _data,
855         bool safe
856     ) internal {
857         uint256 startTokenId = currentIndex;
858         require(to != address(0), 'ERC721A: mint to the zero address');
859         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
860 
861         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
862 
863         // Overflows are incredibly unrealistic.
864         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
865         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
866     unchecked {
867         _addressData[to].balance += uint128(quantity);
868         _addressData[to].numberMinted += uint128(quantity);
869 
870         _ownerships[startTokenId].addr = to;
871         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
872 
873         uint256 updatedIndex = startTokenId;
874 
875         for (uint256 i; i < quantity; i++) {
876             emit Transfer(address(0), to, updatedIndex);
877             if (safe) {
878                 require(
879                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
880                     'ERC721A: transfer to non ERC721Receiver implementer'
881                 );
882             }
883 
884             updatedIndex++;
885         }
886 
887         currentIndex = updatedIndex;
888     }
889 
890         _afterTokenTransfers(address(0), to, startTokenId, quantity);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
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
907     ) private {
908         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
909 
910         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
911         getApproved(tokenId) == _msgSender() ||
912         isApprovedForAll(prevOwnership.addr, _msgSender()));
913 
914         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
915 
916         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
917         require(to != address(0), 'ERC721A: transfer to the zero address');
918 
919         _beforeTokenTransfers(from, to, tokenId, 1);
920 
921         // Clear approvals from the previous owner
922         _approve(address(0), tokenId, prevOwnership.addr);
923 
924         // Underflow of the sender's balance is impossible because we check for
925         // ownership above and the recipient's balance can't realistically overflow.
926         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
927     unchecked {
928         _addressData[from].balance -= 1;
929         _addressData[to].balance += 1;
930 
931         _ownerships[tokenId].addr = to;
932         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
933 
934         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
935         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
936         uint256 nextTokenId = tokenId + 1;
937         if (_ownerships[nextTokenId].addr == address(0)) {
938             if (_exists(nextTokenId)) {
939                 _ownerships[nextTokenId].addr = prevOwnership.addr;
940                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
941             }
942         }
943     }
944 
945         emit Transfer(from, to, tokenId);
946         _afterTokenTransfers(from, to, tokenId, 1);
947     }
948 
949     /**
950      * @dev Approve `to` to operate on `tokenId`
951      *
952      * Emits a {Approval} event.
953      */
954     function _approve(
955         address to,
956         uint256 tokenId,
957         address owner
958     ) private {
959         _tokenApprovals[tokenId] = to;
960         emit Approval(owner, to, tokenId);
961     }
962 
963     /**
964      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
965      * The call is not executed if the target address is not a contract.
966      *
967      * @param from address representing the previous owner of the given token ID
968      * @param to target address that will receive the tokens
969      * @param tokenId uint256 ID of the token to be transferred
970      * @param _data bytes optional data to send along with the call
971      * @return bool whether the call correctly returned the expected magic value
972      */
973     function _checkOnERC721Received(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) private returns (bool) {
979         if (to.isContract()) {
980             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
981                 return retval == IERC721Receiver(to).onERC721Received.selector;
982             } catch (bytes memory reason) {
983                 if (reason.length == 0) {
984                     revert('ERC721A: transfer to non ERC721Receiver implementer');
985                 } else {
986                     assembly {
987                         revert(add(32, reason), mload(reason))
988                     }
989                 }
990             }
991         } else {
992             return true;
993         }
994     }
995 
996     /**
997      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
998      *
999      * startTokenId - the first token id to be transferred
1000      * quantity - the amount to be transferred
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` will be minted for `to`.
1007      */
1008     function _beforeTokenTransfers(
1009         address from,
1010         address to,
1011         uint256 startTokenId,
1012         uint256 quantity
1013     ) internal virtual {}
1014 
1015     /**
1016      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1017      * minting.
1018      *
1019      * startTokenId - the first token id to be transferred
1020      * quantity - the amount to be transferred
1021      *
1022      * Calling conditions:
1023      *
1024      * - when `from` and `to` are both non-zero.
1025      * - `from` and `to` are never both zero.
1026      */
1027     function _afterTokenTransfers(
1028         address from,
1029         address to,
1030         uint256 startTokenId,
1031         uint256 quantity
1032     ) internal virtual {}
1033 }
1034 
1035 // File: @openzeppelin\contracts\access\Ownable.sol
1036 
1037 
1038 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 /**
1043  * @dev Contract module which provides a basic access control mechanism, where
1044  * there is an account (an owner) that can be granted exclusive access to
1045  * specific functions.
1046  *
1047  * By default, the owner account will be the one that deploys the contract. This
1048  * can later be changed with {transferOwnership}.
1049  *
1050  * This module is used through inheritance. It will make available the modifier
1051  * `onlyOwner`, which can be applied to your functions to restrict their use to
1052  * the owner.
1053  */
1054 abstract contract Ownable is Context {
1055     address private _owner;
1056 
1057     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1058 
1059     /**
1060      * @dev Initializes the contract setting the deployer as the initial owner.
1061      */
1062     constructor() {
1063         _transferOwnership(_msgSender());
1064     }
1065 
1066     /**
1067      * @dev Throws if called by any account other than the owner.
1068      */
1069     modifier onlyOwner() {
1070         _checkOwner();
1071         _;
1072     }
1073 
1074     /**
1075      * @dev Returns the address of the current owner.
1076      */
1077     function owner() public view virtual returns (address) {
1078         return _owner;
1079     }
1080 
1081     /**
1082      * @dev Throws if the sender is not the owner.
1083      */
1084     function _checkOwner() internal view virtual {
1085         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1086     }
1087 
1088     /**
1089      * @dev Leaves the contract without owner. It will not be possible to call
1090      * `onlyOwner` functions anymore. Can only be called by the current owner.
1091      *
1092      * NOTE: Renouncing ownership will leave the contract without an owner,
1093      * thereby removing any functionality that is only available to the owner.
1094      */
1095     function renounceOwnership() public virtual onlyOwner {
1096         _transferOwnership(address(0));
1097     }
1098 
1099     /**
1100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1101      * Can only be called by the current owner.
1102      */
1103     function transferOwnership(address newOwner) public virtual onlyOwner {
1104         require(newOwner != address(0), "Ownable: new owner is the zero address");
1105         _transferOwnership(newOwner);
1106     }
1107 
1108     /**
1109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1110      * Internal function without access restriction.
1111      */
1112     function _transferOwnership(address newOwner) internal virtual {
1113         address oldOwner = _owner;
1114         _owner = newOwner;
1115         emit OwnershipTransferred(oldOwner, newOwner);
1116     }
1117 }
1118 
1119 // File: @openzeppelin\contracts\security\ReentrancyGuard.sol
1120 
1121 
1122 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 /**
1127  * @dev Contract module that helps prevent reentrant calls to a function.
1128  *
1129  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1130  * available, which can be applied to functions to make sure there are no nested
1131  * (reentrant) calls to them.
1132  *
1133  * Note that because there is a single `nonReentrant` guard, functions marked as
1134  * `nonReentrant` may not call one another. This can be worked around by making
1135  * those functions `private`, and then adding `external` `nonReentrant` entry
1136  * points to them.
1137  *
1138  * TIP: If you would like to learn more about reentrancy and alternative ways
1139  * to protect against it, check out our blog post
1140  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1141  */
1142 abstract contract ReentrancyGuard {
1143     // Booleans are more expensive than uint256 or any type that takes up a full
1144     // word because each write operation emits an extra SLOAD to first read the
1145     // slot's contents, replace the bits taken up by the boolean, and then write
1146     // back. This is the compiler's defense against contract upgrades and
1147     // pointer aliasing, and it cannot be disabled.
1148 
1149     // The values being non-zero value makes deployment a bit more expensive,
1150     // but in exchange the refund on every call to nonReentrant will be lower in
1151     // amount. Since refunds are capped to a percentage of the total
1152     // transaction's gas, it is best to keep them low in cases like this one, to
1153     // increase the likelihood of the full refund coming into effect.
1154     uint256 private constant _NOT_ENTERED = 1;
1155     uint256 private constant _ENTERED = 2;
1156 
1157     uint256 private _status;
1158 
1159     constructor() {
1160         _status = _NOT_ENTERED;
1161     }
1162 
1163     /**
1164      * @dev Prevents a contract from calling itself, directly or indirectly.
1165      * Calling a `nonReentrant` function from another `nonReentrant`
1166      * function is not supported. It is possible to prevent this from happening
1167      * by making the `nonReentrant` function external, and making it call a
1168      * `private` function that does the actual work.
1169      */
1170     modifier nonReentrant() {
1171         // On the first call to nonReentrant, _notEntered will be true
1172         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1173 
1174         // Any calls to nonReentrant after this point will fail
1175         _status = _ENTERED;
1176 
1177         _;
1178 
1179         // By storing the original value once again, a refund is triggered (see
1180         // https://eips.ethereum.org/EIPS/eip-2200)
1181         _status = _NOT_ENTERED;
1182     }
1183 }
1184 
1185 // File: contracts\ApeNounsWTF.sol
1186 
1187 
1188 //////////////////////////////////////////////////////////////////////////////////////////////////////////
1189 /////////////////////////█▀▀█ █▀▀█ █▀▀ █▀▀▄ █▀▀█ █░░█ █▀▀▄ █▀▀ █░░░█ ▀▀█▀▀ █▀▀////////////////////////////
1190 /////////////////////////█▄▄█ █░░█ █▀▀ █░░█ █░░█ █░░█ █░░█ ▀▀█ █▄█▄█ ░░█░░ █▀▀////////////////////////////
1191 /////////////////////////▀░░▀ █▀▀▀ ▀▀▀ ▀░░▀ ▀▀▀▀ ░▀▀▀ ▀░░▀ ▀▀▀ ░▀░▀░ ░░▀░░ ▀░░////////////////////////////
1192 //////////////////////////////////////////////////////////////////////////////////////////////////////////
1193 
1194 pragma solidity ^0.8.2;
1195 contract ApeNounsWTF is ERC721A, Ownable, ReentrancyGuard {
1196     using Strings for uint256;
1197 
1198     string private BASE_URI = '';
1199 
1200     uint256 public PRICE = 0 ether; // Free mint ( ^^)Y
1201 
1202     constructor() ERC721A("ApeNounsWTF", "ANT") {
1203     }
1204 
1205     function _baseURI() internal view virtual override returns (string memory) {
1206         return BASE_URI;
1207     }
1208 
1209     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1210         BASE_URI = customBaseURI_;
1211     }
1212 
1213     modifier mintCompliance(uint256 _howManyMint) {
1214         // max 10 mints per txn
1215         require(_howManyMint > 0 && _howManyMint < 11, "Invalid mint amount!");
1216         // max supply is 15000
1217         require(currentIndex + _howManyMint < 15000, "Max supply exceeded!");
1218         _;
1219     }
1220 
1221     // for minters
1222     function mint(uint256 _howManyMint) public payable mintCompliance(_howManyMint) {
1223         uint256 _totalMintAmount = currentIndex + _howManyMint;
1224         if(_totalMintAmount >= 9000) {
1225             PRICE = 0.00123 ether;
1226         }
1227 
1228         uint256 price = PRICE * _howManyMint;
1229         require(msg.value >= price, "You have Insufficient funds!");
1230         
1231         _safeMint(msg.sender, _howManyMint);
1232     }
1233 
1234     // official use only - airdrops & giveaways
1235     function mintOwner(address _to, uint256 _howManyMint) public mintCompliance(_howManyMint) onlyOwner {
1236         _safeMint(_to, _howManyMint);
1237     }
1238 
1239     address private constant payoutAdd =
1240     0x311819c3509D9D59A6d2e29810263C358e8A1773;
1241 
1242     function withdraw() public onlyOwner nonReentrant {
1243         uint256 balance = address(this).balance;
1244         Address.sendValue(payable(payoutAdd), balance);
1245     }
1246     
1247     function tokenURI(uint256 tokenId)
1248         public
1249         view
1250         override
1251         returns (string memory)
1252     {
1253         require(_exists(tokenId), "Non-existent token!");
1254         string memory baseURI = BASE_URI;
1255         return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
1256         
1257     }
1258 }