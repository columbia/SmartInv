1 // Sources flattened with hardhat v2.9.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Metadata is IERC721 {
189     /**
190      * @dev Returns the token collection name.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the token collection symbol.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
201      */
202     function tokenURI(uint256 tokenId) external view returns (string memory);
203 }
204 
205 
206 // File erc721a/contracts/IERC721A.sol@v3.3.0
207 
208 
209 // ERC721A Contracts v3.3.0
210 // Creator: Chiru Labs
211 
212 pragma solidity ^0.8.4;
213 
214 
215 /**
216  * @dev Interface of an ERC721A compliant contract.
217  */
218 interface IERC721A is IERC721, IERC721Metadata {
219     /**
220      * The caller must own the token or be an approved operator.
221      */
222     error ApprovalCallerNotOwnerNorApproved();
223 
224     /**
225      * The token does not exist.
226      */
227     error ApprovalQueryForNonexistentToken();
228 
229     /**
230      * The caller cannot approve to their own address.
231      */
232     error ApproveToCaller();
233 
234     /**
235      * The caller cannot approve to the current owner.
236      */
237     error ApprovalToCurrentOwner();
238 
239     /**
240      * Cannot query the balance for the zero address.
241      */
242     error BalanceQueryForZeroAddress();
243 
244     /**
245      * Cannot mint to the zero address.
246      */
247     error MintToZeroAddress();
248 
249     /**
250      * The quantity of tokens minted must be more than zero.
251      */
252     error MintZeroQuantity();
253 
254     /**
255      * The token does not exist.
256      */
257     error OwnerQueryForNonexistentToken();
258 
259     /**
260      * The caller must own the token or be an approved operator.
261      */
262     error TransferCallerNotOwnerNorApproved();
263 
264     /**
265      * The token must be owned by `from`.
266      */
267     error TransferFromIncorrectOwner();
268 
269     /**
270      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
271      */
272     error TransferToNonERC721ReceiverImplementer();
273 
274     /**
275      * Cannot transfer to the zero address.
276      */
277     error TransferToZeroAddress();
278 
279     /**
280      * The token does not exist.
281      */
282     error URIQueryForNonexistentToken();
283 
284     // Compiler will pack this into a single 256bit word.
285     struct TokenOwnership {
286         // The address of the owner.
287         address addr;
288         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
289         uint64 startTimestamp;
290         // Whether the token has been burned.
291         bool burned;
292     }
293 
294     // Compiler will pack this into a single 256bit word.
295     struct AddressData {
296         // Realistically, 2**64-1 is more than enough.
297         uint64 balance;
298         // Keeps track of mint count with minimal overhead for tokenomics.
299         uint64 numberMinted;
300         // Keeps track of burn count with minimal overhead for tokenomics.
301         uint64 numberBurned;
302         // For miscellaneous variable(s) pertaining to the address
303         // (e.g. number of whitelist mint slots used).
304         // If there are multiple variables, please pack them into a uint64.
305         uint64 aux;
306     }
307 
308     /**
309      * @dev Returns the total amount of tokens stored by the contract.
310      *
311      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
312      */
313     function totalSupply() external view returns (uint256);
314 }
315 
316 
317 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @title ERC721 token receiver interface
326  * @dev Interface for any contract that wants to support safeTransfers
327  * from ERC721 asset contracts.
328  */
329 interface IERC721Receiver {
330     /**
331      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
332      * by `operator` from `from`, this function is called.
333      *
334      * It must return its Solidity selector to confirm the token transfer.
335      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
336      *
337      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
338      */
339     function onERC721Received(
340         address operator,
341         address from,
342         uint256 tokenId,
343         bytes calldata data
344     ) external returns (bytes4);
345 }
346 
347 
348 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
349 
350 
351 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
352 
353 pragma solidity ^0.8.1;
354 
355 /**
356  * @dev Collection of functions related to the address type
357  */
358 library Address {
359     /**
360      * @dev Returns true if `account` is a contract.
361      *
362      * [IMPORTANT]
363      * ====
364      * It is unsafe to assume that an address for which this function returns
365      * false is an externally-owned account (EOA) and not a contract.
366      *
367      * Among others, `isContract` will return false for the following
368      * types of addresses:
369      *
370      *  - an externally-owned account
371      *  - a contract in construction
372      *  - an address where a contract will be created
373      *  - an address where a contract lived, but was destroyed
374      * ====
375      *
376      * [IMPORTANT]
377      * ====
378      * You shouldn't rely on `isContract` to protect against flash loan attacks!
379      *
380      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
381      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
382      * constructor.
383      * ====
384      */
385     function isContract(address account) internal view returns (bool) {
386         // This method relies on extcodesize/address.code.length, which returns 0
387         // for contracts in construction, since the code is only stored at the end
388         // of the constructor execution.
389 
390         return account.code.length > 0;
391     }
392 
393     /**
394      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
395      * `recipient`, forwarding all available gas and reverting on errors.
396      *
397      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
398      * of certain opcodes, possibly making contracts go over the 2300 gas limit
399      * imposed by `transfer`, making them unable to receive funds via
400      * `transfer`. {sendValue} removes this limitation.
401      *
402      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
403      *
404      * IMPORTANT: because control is transferred to `recipient`, care must be
405      * taken to not create reentrancy vulnerabilities. Consider using
406      * {ReentrancyGuard} or the
407      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         (bool success, ) = recipient.call{value: amount}("");
413         require(success, "Address: unable to send value, recipient may have reverted");
414     }
415 
416     /**
417      * @dev Performs a Solidity function call using a low level `call`. A
418      * plain `call` is an unsafe replacement for a function call: use this
419      * function instead.
420      *
421      * If `target` reverts with a revert reason, it is bubbled up by this
422      * function (like regular Solidity function calls).
423      *
424      * Returns the raw returned data. To convert to the expected return value,
425      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
426      *
427      * Requirements:
428      *
429      * - `target` must be a contract.
430      * - calling `target` with `data` must not revert.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionCall(target, data, "Address: low-level call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
440      * `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, 0, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but also transferring `value` wei to `target`.
455      *
456      * Requirements:
457      *
458      * - the calling contract must have an ETH balance of at least `value`.
459      * - the called Solidity function must be `payable`.
460      *
461      * _Available since v3.1._
462      */
463     function functionCallWithValue(
464         address target,
465         bytes memory data,
466         uint256 value
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473      * with `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(
478         address target,
479         bytes memory data,
480         uint256 value,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(address(this).balance >= value, "Address: insufficient balance for call");
484         require(isContract(target), "Address: call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.call{value: value}(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
497         return functionStaticCall(target, data, "Address: low-level static call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal view returns (bytes memory) {
511         require(isContract(target), "Address: static call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.staticcall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(isContract(target), "Address: delegate call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.delegatecall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
546      * revert reason using the provided one.
547      *
548      * _Available since v4.3._
549      */
550     function verifyCallResult(
551         bool success,
552         bytes memory returndata,
553         string memory errorMessage
554     ) internal pure returns (bytes memory) {
555         if (success) {
556             return returndata;
557         } else {
558             // Look for revert reason and bubble it up if present
559             if (returndata.length > 0) {
560                 // The easiest way to bubble the revert reason is using memory via assembly
561 
562                 assembly {
563                     let returndata_size := mload(returndata)
564                     revert(add(32, returndata), returndata_size)
565                 }
566             } else {
567                 revert(errorMessage);
568             }
569         }
570     }
571 }
572 
573 
574 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Provides information about the current execution context, including the
583  * sender of the transaction and its data. While these are generally available
584  * via msg.sender and msg.data, they should not be accessed in such a direct
585  * manner, since when dealing with meta-transactions the account sending and
586  * paying for execution may not be the actual sender (as far as an application
587  * is concerned).
588  *
589  * This contract is only required for intermediate, library-like contracts.
590  */
591 abstract contract Context {
592     function _msgSender() internal view virtual returns (address) {
593         return msg.sender;
594     }
595 
596     function _msgData() internal view virtual returns (bytes calldata) {
597         return msg.data;
598     }
599 }
600 
601 
602 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev String operations.
611  */
612 library Strings {
613     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
614 
615     /**
616      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
617      */
618     function toString(uint256 value) internal pure returns (string memory) {
619         // Inspired by OraclizeAPI's implementation - MIT licence
620         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
621 
622         if (value == 0) {
623             return "0";
624         }
625         uint256 temp = value;
626         uint256 digits;
627         while (temp != 0) {
628             digits++;
629             temp /= 10;
630         }
631         bytes memory buffer = new bytes(digits);
632         while (value != 0) {
633             digits -= 1;
634             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
635             value /= 10;
636         }
637         return string(buffer);
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
642      */
643     function toHexString(uint256 value) internal pure returns (string memory) {
644         if (value == 0) {
645             return "0x00";
646         }
647         uint256 temp = value;
648         uint256 length = 0;
649         while (temp != 0) {
650             length++;
651             temp >>= 8;
652         }
653         return toHexString(value, length);
654     }
655 
656     /**
657      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
658      */
659     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
660         bytes memory buffer = new bytes(2 * length + 2);
661         buffer[0] = "0";
662         buffer[1] = "x";
663         for (uint256 i = 2 * length + 1; i > 1; --i) {
664             buffer[i] = _HEX_SYMBOLS[value & 0xf];
665             value >>= 4;
666         }
667         require(value == 0, "Strings: hex length insufficient");
668         return string(buffer);
669     }
670 }
671 
672 
673 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @dev Implementation of the {IERC165} interface.
682  *
683  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
684  * for the additional interface id that will be supported. For example:
685  *
686  * ```solidity
687  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
689  * }
690  * ```
691  *
692  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
693  */
694 abstract contract ERC165 is IERC165 {
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699         return interfaceId == type(IERC165).interfaceId;
700     }
701 }
702 
703 
704 // File erc721a/contracts/ERC721A.sol@v3.3.0
705 
706 
707 // ERC721A Contracts v3.3.0
708 // Creator: Chiru Labs
709 
710 pragma solidity ^0.8.4;
711 
712 
713 
714 
715 
716 
717 /**
718  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
719  * the Metadata extension. Built to optimize for lower gas during batch mints.
720  *
721  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
722  *
723  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
724  *
725  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
726  */
727 contract ERC721A is Context, ERC165, IERC721A {
728     using Address for address;
729     using Strings for uint256;
730 
731     // The tokenId of the next token to be minted.
732     uint256 internal _currentIndex;
733 
734     // The number of tokens burned.
735     uint256 internal _burnCounter;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to ownership details
744     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
745     mapping(uint256 => TokenOwnership) internal _ownerships;
746 
747     // Mapping owner address to address data
748     mapping(address => AddressData) private _addressData;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759         _currentIndex = _startTokenId();
760     }
761 
762     /**
763      * To change the starting tokenId, please override this function.
764      */
765     function _startTokenId() internal view virtual returns (uint256) {
766         return 0;
767     }
768 
769     /**
770      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
771      */
772     function totalSupply() public view override returns (uint256) {
773         // Counter underflow is impossible as _burnCounter cannot be incremented
774         // more than _currentIndex - _startTokenId() times
775         unchecked {
776             return _currentIndex - _burnCounter - _startTokenId();
777         }
778     }
779 
780     /**
781      * Returns the total amount of tokens minted in the contract.
782      */
783     function _totalMinted() internal view returns (uint256) {
784         // Counter underflow is impossible as _currentIndex does not decrement,
785         // and it is initialized to _startTokenId()
786         unchecked {
787             return _currentIndex - _startTokenId();
788         }
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view override returns (uint256) {
805         if (owner == address(0)) revert BalanceQueryForZeroAddress();
806         return uint256(_addressData[owner].balance);
807     }
808 
809     /**
810      * Returns the number of tokens minted by `owner`.
811      */
812     function _numberMinted(address owner) internal view returns (uint256) {
813         return uint256(_addressData[owner].numberMinted);
814     }
815 
816     /**
817      * Returns the number of tokens burned by or on behalf of `owner`.
818      */
819     function _numberBurned(address owner) internal view returns (uint256) {
820         return uint256(_addressData[owner].numberBurned);
821     }
822 
823     /**
824      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
825      */
826     function _getAux(address owner) internal view returns (uint64) {
827         return _addressData[owner].aux;
828     }
829 
830     /**
831      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
832      * If there are multiple variables, please pack them into a uint64.
833      */
834     function _setAux(address owner, uint64 aux) internal {
835         _addressData[owner].aux = aux;
836     }
837 
838     /**
839      * Gas spent here starts off proportional to the maximum mint batch size.
840      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
841      */
842     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
843         uint256 curr = tokenId;
844 
845         unchecked {
846             if (_startTokenId() <= curr) if (curr < _currentIndex) {
847                 TokenOwnership memory ownership = _ownerships[curr];
848                 if (!ownership.burned) {
849                     if (ownership.addr != address(0)) {
850                         return ownership;
851                     }
852                     // Invariant:
853                     // There will always be an ownership that has an address and is not burned
854                     // before an ownership that does not have an address and is not burned.
855                     // Hence, curr will not underflow.
856                     while (true) {
857                         curr--;
858                         ownership = _ownerships[curr];
859                         if (ownership.addr != address(0)) {
860                             return ownership;
861                         }
862                     }
863                 }
864             }
865         }
866         revert OwnerQueryForNonexistentToken();
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId) public view override returns (address) {
873         return _ownershipOf(tokenId).addr;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-name}.
878      */
879     function name() public view virtual override returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-symbol}.
885      */
886     function symbol() public view virtual override returns (string memory) {
887         return _symbol;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-tokenURI}.
892      */
893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
894         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
895 
896         string memory baseURI = _baseURI();
897         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
898     }
899 
900     /**
901      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
902      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
903      * by default, can be overriden in child contracts.
904      */
905     function _baseURI() internal view virtual returns (string memory) {
906         return '';
907     }
908 
909     /**
910      * @dev See {IERC721-approve}.
911      */
912     function approve(address to, uint256 tokenId) public override {
913         address owner = ERC721A.ownerOf(tokenId);
914         if (to == owner) revert ApprovalToCurrentOwner();
915 
916         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
917             revert ApprovalCallerNotOwnerNorApproved();
918         }
919 
920         _approve(to, tokenId, owner);
921     }
922 
923     /**
924      * @dev See {IERC721-getApproved}.
925      */
926     function getApproved(uint256 tokenId) public view override returns (address) {
927         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
928 
929         return _tokenApprovals[tokenId];
930     }
931 
932     /**
933      * @dev See {IERC721-setApprovalForAll}.
934      */
935     function setApprovalForAll(address operator, bool approved) public virtual override {
936         if (operator == _msgSender()) revert ApproveToCaller();
937 
938         _operatorApprovals[_msgSender()][operator] = approved;
939         emit ApprovalForAll(_msgSender(), operator, approved);
940     }
941 
942     /**
943      * @dev See {IERC721-isApprovedForAll}.
944      */
945     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
946         return _operatorApprovals[owner][operator];
947     }
948 
949     /**
950      * @dev See {IERC721-transferFrom}.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         _transfer(from, to, tokenId);
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId
967     ) public virtual override {
968         safeTransferFrom(from, to, tokenId, '');
969     }
970 
971     /**
972      * @dev See {IERC721-safeTransferFrom}.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) public virtual override {
980         _transfer(from, to, tokenId);
981         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
982             revert TransferToNonERC721ReceiverImplementer();
983         }
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      */
993     function _exists(uint256 tokenId) internal view returns (bool) {
994         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
995     }
996 
997     /**
998      * @dev Equivalent to `_safeMint(to, quantity, '')`.
999      */
1000     function _safeMint(address to, uint256 quantity) internal {
1001         _safeMint(to, quantity, '');
1002     }
1003 
1004     /**
1005      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - If `to` refers to a smart contract, it must implement
1010      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1011      * - `quantity` must be greater than 0.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _safeMint(
1016         address to,
1017         uint256 quantity,
1018         bytes memory _data
1019     ) internal {
1020         uint256 startTokenId = _currentIndex;
1021         if (to == address(0)) revert MintToZeroAddress();
1022         if (quantity == 0) revert MintZeroQuantity();
1023 
1024         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1025 
1026         // Overflows are incredibly unrealistic.
1027         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1028         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1029         unchecked {
1030             _addressData[to].balance += uint64(quantity);
1031             _addressData[to].numberMinted += uint64(quantity);
1032 
1033             _ownerships[startTokenId].addr = to;
1034             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1035 
1036             uint256 updatedIndex = startTokenId;
1037             uint256 end = updatedIndex + quantity;
1038 
1039             if (to.isContract()) {
1040                 do {
1041                     emit Transfer(address(0), to, updatedIndex);
1042                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1043                         revert TransferToNonERC721ReceiverImplementer();
1044                     }
1045                 } while (updatedIndex < end);
1046                 // Reentrancy protection
1047                 if (_currentIndex != startTokenId) revert();
1048             } else {
1049                 do {
1050                     emit Transfer(address(0), to, updatedIndex++);
1051                 } while (updatedIndex < end);
1052             }
1053             _currentIndex = updatedIndex;
1054         }
1055         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1056     }
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(address to, uint256 quantity) internal {
1069         uint256 startTokenId = _currentIndex;
1070         if (to == address(0)) revert MintToZeroAddress();
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // Overflows are incredibly unrealistic.
1076         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1077         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1078         unchecked {
1079             _addressData[to].balance += uint64(quantity);
1080             _addressData[to].numberMinted += uint64(quantity);
1081 
1082             _ownerships[startTokenId].addr = to;
1083             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1084 
1085             uint256 updatedIndex = startTokenId;
1086             uint256 end = updatedIndex + quantity;
1087 
1088             do {
1089                 emit Transfer(address(0), to, updatedIndex++);
1090             } while (updatedIndex < end);
1091 
1092             _currentIndex = updatedIndex;
1093         }
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) private {
1112         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1113 
1114         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1115 
1116         bool isApprovedOrOwner = (_msgSender() == from ||
1117             isApprovedForAll(from, _msgSender()) ||
1118             getApproved(tokenId) == _msgSender());
1119 
1120         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1121         if (to == address(0)) revert TransferToZeroAddress();
1122 
1123         _beforeTokenTransfers(from, to, tokenId, 1);
1124 
1125         // Clear approvals from the previous owner
1126         _approve(address(0), tokenId, from);
1127 
1128         // Underflow of the sender's balance is impossible because we check for
1129         // ownership above and the recipient's balance can't realistically overflow.
1130         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1131         unchecked {
1132             _addressData[from].balance -= 1;
1133             _addressData[to].balance += 1;
1134 
1135             TokenOwnership storage currSlot = _ownerships[tokenId];
1136             currSlot.addr = to;
1137             currSlot.startTimestamp = uint64(block.timestamp);
1138 
1139             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1140             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1141             uint256 nextTokenId = tokenId + 1;
1142             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1143             if (nextSlot.addr == address(0)) {
1144                 // This will suffice for checking _exists(nextTokenId),
1145                 // as a burned slot cannot contain the zero address.
1146                 if (nextTokenId != _currentIndex) {
1147                     nextSlot.addr = from;
1148                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1149                 }
1150             }
1151         }
1152 
1153         emit Transfer(from, to, tokenId);
1154         _afterTokenTransfers(from, to, tokenId, 1);
1155     }
1156 
1157     /**
1158      * @dev Equivalent to `_burn(tokenId, false)`.
1159      */
1160     function _burn(uint256 tokenId) internal virtual {
1161         _burn(tokenId, false);
1162     }
1163 
1164     /**
1165      * @dev Destroys `tokenId`.
1166      * The approval is cleared when the token is burned.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1175         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1176 
1177         address from = prevOwnership.addr;
1178 
1179         if (approvalCheck) {
1180             bool isApprovedOrOwner = (_msgSender() == from ||
1181                 isApprovedForAll(from, _msgSender()) ||
1182                 getApproved(tokenId) == _msgSender());
1183 
1184             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1185         }
1186 
1187         _beforeTokenTransfers(from, address(0), tokenId, 1);
1188 
1189         // Clear approvals from the previous owner
1190         _approve(address(0), tokenId, from);
1191 
1192         // Underflow of the sender's balance is impossible because we check for
1193         // ownership above and the recipient's balance can't realistically overflow.
1194         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1195         unchecked {
1196             AddressData storage addressData = _addressData[from];
1197             addressData.balance -= 1;
1198             addressData.numberBurned += 1;
1199 
1200             // Keep track of who burned the token, and the timestamp of burning.
1201             TokenOwnership storage currSlot = _ownerships[tokenId];
1202             currSlot.addr = from;
1203             currSlot.startTimestamp = uint64(block.timestamp);
1204             currSlot.burned = true;
1205 
1206             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1207             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1208             uint256 nextTokenId = tokenId + 1;
1209             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1210             if (nextSlot.addr == address(0)) {
1211                 // This will suffice for checking _exists(nextTokenId),
1212                 // as a burned slot cannot contain the zero address.
1213                 if (nextTokenId != _currentIndex) {
1214                     nextSlot.addr = from;
1215                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1216                 }
1217             }
1218         }
1219 
1220         emit Transfer(from, address(0), tokenId);
1221         _afterTokenTransfers(from, address(0), tokenId, 1);
1222 
1223         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1224         unchecked {
1225             _burnCounter++;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Approve `to` to operate on `tokenId`
1231      *
1232      * Emits a {Approval} event.
1233      */
1234     function _approve(
1235         address to,
1236         uint256 tokenId,
1237         address owner
1238     ) private {
1239         _tokenApprovals[tokenId] = to;
1240         emit Approval(owner, to, tokenId);
1241     }
1242 
1243     /**
1244      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1245      *
1246      * @param from address representing the previous owner of the given token ID
1247      * @param to target address that will receive the tokens
1248      * @param tokenId uint256 ID of the token to be transferred
1249      * @param _data bytes optional data to send along with the call
1250      * @return bool whether the call correctly returned the expected magic value
1251      */
1252     function _checkContractOnERC721Received(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) private returns (bool) {
1258         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259             return retval == IERC721Receiver(to).onERC721Received.selector;
1260         } catch (bytes memory reason) {
1261             if (reason.length == 0) {
1262                 revert TransferToNonERC721ReceiverImplementer();
1263             } else {
1264                 assembly {
1265                     revert(add(32, reason), mload(reason))
1266                 }
1267             }
1268         }
1269     }
1270 
1271     /**
1272      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1273      * And also called before burning one token.
1274      *
1275      * startTokenId - the first token id to be transferred
1276      * quantity - the amount to be transferred
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      * - When `to` is zero, `tokenId` will be burned by `from`.
1284      * - `from` and `to` are never both zero.
1285      */
1286     function _beforeTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 
1293     /**
1294      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1295      * minting.
1296      * And also called after one token has been burned.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` has been minted for `to`.
1306      * - When `to` is zero, `tokenId` has been burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _afterTokenTransfers(
1310         address from,
1311         address to,
1312         uint256 startTokenId,
1313         uint256 quantity
1314     ) internal virtual {}
1315 }
1316 
1317 
1318 // File @openzeppelin/contracts/interfaces/IERC165.sol@v4.5.0
1319 
1320 
1321 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1322 
1323 pragma solidity ^0.8.0;
1324 
1325 
1326 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.5.0
1327 
1328 
1329 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 /**
1334  * @dev Interface for the NFT Royalty Standard.
1335  *
1336  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1337  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1338  *
1339  * _Available since v4.5._
1340  */
1341 interface IERC2981 is IERC165 {
1342     /**
1343      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1344      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1345      */
1346     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1347         external
1348         view
1349         returns (address receiver, uint256 royaltyAmount);
1350 }
1351 
1352 
1353 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.5.0
1354 
1355 
1356 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
1357 
1358 pragma solidity ^0.8.0;
1359 
1360 
1361 /**
1362  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1363  *
1364  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1365  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1366  *
1367  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1368  * fee is specified in basis points by default.
1369  *
1370  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1371  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1372  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1373  *
1374  * _Available since v4.5._
1375  */
1376 abstract contract ERC2981 is IERC2981, ERC165 {
1377     struct RoyaltyInfo {
1378         address receiver;
1379         uint96 royaltyFraction;
1380     }
1381 
1382     RoyaltyInfo private _defaultRoyaltyInfo;
1383     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1384 
1385     /**
1386      * @dev See {IERC165-supportsInterface}.
1387      */
1388     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1389         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1390     }
1391 
1392     /**
1393      * @inheritdoc IERC2981
1394      */
1395     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1396         external
1397         view
1398         virtual
1399         override
1400         returns (address, uint256)
1401     {
1402         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1403 
1404         if (royalty.receiver == address(0)) {
1405             royalty = _defaultRoyaltyInfo;
1406         }
1407 
1408         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1409 
1410         return (royalty.receiver, royaltyAmount);
1411     }
1412 
1413     /**
1414      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1415      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1416      * override.
1417      */
1418     function _feeDenominator() internal pure virtual returns (uint96) {
1419         return 10000;
1420     }
1421 
1422     /**
1423      * @dev Sets the royalty information that all ids in this contract will default to.
1424      *
1425      * Requirements:
1426      *
1427      * - `receiver` cannot be the zero address.
1428      * - `feeNumerator` cannot be greater than the fee denominator.
1429      */
1430     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1431         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1432         require(receiver != address(0), "ERC2981: invalid receiver");
1433 
1434         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1435     }
1436 
1437     /**
1438      * @dev Removes default royalty information.
1439      */
1440     function _deleteDefaultRoyalty() internal virtual {
1441         delete _defaultRoyaltyInfo;
1442     }
1443 
1444     /**
1445      * @dev Sets the royalty information for a specific token id, overriding the global default.
1446      *
1447      * Requirements:
1448      *
1449      * - `tokenId` must be already minted.
1450      * - `receiver` cannot be the zero address.
1451      * - `feeNumerator` cannot be greater than the fee denominator.
1452      */
1453     function _setTokenRoyalty(
1454         uint256 tokenId,
1455         address receiver,
1456         uint96 feeNumerator
1457     ) internal virtual {
1458         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1459         require(receiver != address(0), "ERC2981: Invalid parameters");
1460 
1461         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1462     }
1463 
1464     /**
1465      * @dev Resets royalty information for the token id back to the global default.
1466      */
1467     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1468         delete _tokenRoyaltyInfo[tokenId];
1469     }
1470 }
1471 
1472 
1473 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1474 
1475 
1476 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1477 
1478 pragma solidity ^0.8.0;
1479 
1480 /**
1481  * @dev Contract module which provides a basic access control mechanism, where
1482  * there is an account (an owner) that can be granted exclusive access to
1483  * specific functions.
1484  *
1485  * By default, the owner account will be the one that deploys the contract. This
1486  * can later be changed with {transferOwnership}.
1487  *
1488  * This module is used through inheritance. It will make available the modifier
1489  * `onlyOwner`, which can be applied to your functions to restrict their use to
1490  * the owner.
1491  */
1492 abstract contract Ownable is Context {
1493     address private _owner;
1494 
1495     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1496 
1497     /**
1498      * @dev Initializes the contract setting the deployer as the initial owner.
1499      */
1500     constructor() {
1501         _transferOwnership(_msgSender());
1502     }
1503 
1504     /**
1505      * @dev Returns the address of the current owner.
1506      */
1507     function owner() public view virtual returns (address) {
1508         return _owner;
1509     }
1510 
1511     /**
1512      * @dev Throws if called by any account other than the owner.
1513      */
1514     modifier onlyOwner() {
1515         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1516         _;
1517     }
1518 
1519     /**
1520      * @dev Leaves the contract without owner. It will not be possible to call
1521      * `onlyOwner` functions anymore. Can only be called by the current owner.
1522      *
1523      * NOTE: Renouncing ownership will leave the contract without an owner,
1524      * thereby removing any functionality that is only available to the owner.
1525      */
1526     function renounceOwnership() public virtual onlyOwner {
1527         _transferOwnership(address(0));
1528     }
1529 
1530     /**
1531      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1532      * Can only be called by the current owner.
1533      */
1534     function transferOwnership(address newOwner) public virtual onlyOwner {
1535         require(newOwner != address(0), "Ownable: new owner is the zero address");
1536         _transferOwnership(newOwner);
1537     }
1538 
1539     /**
1540      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1541      * Internal function without access restriction.
1542      */
1543     function _transferOwnership(address newOwner) internal virtual {
1544         address oldOwner = _owner;
1545         _owner = newOwner;
1546         emit OwnershipTransferred(oldOwner, newOwner);
1547     }
1548 }
1549 
1550 
1551 // File contracts/EtherLords.sol
1552 
1553 
1554 /*
1555 
1556      ***** **                *                                   ***** *                                    **
1557   ******  **** *     *     **                                 ******  *                                      **
1558  **   *  * ****     **     **                                **   *  *                                       **
1559 *    *  *   **      **     **                               *    *  *                                        **
1560     *  *          ******** **                  ***  ****        *  *              ****    ***  ****          **      ****
1561    ** **         ********  **  ***      ***     **** **** *    ** **             * ***  *  **** **** *   *** **     * **** *
1562    ** **            **     ** * ***    * ***     **   ****     ** **            *   ****    **   ****   *********  **  ****
1563    ** ******        **     ***   ***  *   ***    **            ** **           **    **     **         **   ****  ****
1564    ** *****         **     **     ** **    ***   **            ** **           **    **     **         **    **     ***
1565    ** **            **     **     ** ********    **            ** **           **    **     **         **    **       ***
1566    *  **            **     **     ** *******     **            *  **           **    **     **         **    **         ***
1567       *             **     **     ** **          **               *            **    **     **         **    **    ****  **
1568   ****         *    **     **     ** ****    *   ***          ****           *  ******      ***        **    **   * **** *
1569  *  ***********      **    **     **  *******     ***        *  *************    ****        ***        *****        ****
1570 *     ******                **    **   *****                *     *********                              ***
1571 *                                 *                         *
1572  **                              *                           **
1573                                 *
1574                                *
1575 */
1576 pragma solidity ^0.8.4;
1577 
1578 interface IRenderContract {
1579     function tokenURI(uint256 tokenId) external view returns (string memory);
1580 }
1581 
1582 contract EtherLords is ERC721A, ERC2981, Ownable {
1583     using Strings for uint256;
1584 
1585     uint256 private _maxLords = 5000;
1586     mapping(address => bool) private _granted;
1587 
1588     constructor(string memory baseURI) ERC721A("EtherLords", "ETHERLORD") {
1589         _baseTokenURI = baseURI;
1590     }
1591 
1592     function soItBegins() external onlyOwner {
1593         require(totalSupply() == 0, "It has already begun.");
1594         _safeMint(owner(), 100);
1595     }
1596 
1597     function grantLordship() external payable {
1598         require(totalSupply() > 0,          "The time will soon come.");
1599         require(tx.origin == msg.sender,    "Contracts shall be denied.");
1600         require(totalSupply() < _maxLords,  "All lordships have been granted.");
1601         require(!_granted[msg.sender],      "Your lordship has already been granted.");
1602         _granted[msg.sender] = true;
1603         _safeMint(msg.sender, 1);
1604     }
1605 
1606     string private _baseTokenURI;
1607 
1608     function _baseURI() internal view virtual override returns (string memory) {
1609         return _baseTokenURI;
1610     }
1611 
1612     function setBaseURI(string calldata baseURI) external onlyOwner {
1613         _baseTokenURI = baseURI;
1614     }
1615 
1616     IRenderContract public _renderContract;
1617     bool public _renderContractLocked;
1618 
1619     function setRenderContract(IRenderContract addr) external onlyOwner {
1620         require(!_renderContractLocked, "There is no turning back.");
1621         _renderContract = addr;
1622     }
1623 
1624     function lockRenderContract(bool confirm) external onlyOwner {
1625         require(confirm == true, "You must give the order, my Lord.");
1626         _renderContractLocked = true;
1627     }
1628 
1629     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1630         require(_exists(tokenId), "The Lord you seek cannot be found.");
1631         if (address(_renderContract) != address(0)) {
1632             return _renderContract.tokenURI(tokenId);
1633         }
1634         return super.tokenURI(tokenId);
1635     }
1636 
1637     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints) external onlyOwner {
1638         _setDefaultRoyalty(receiver, feeBasisPoints);
1639     }
1640 
1641     function supportsInterface(bytes4 interfaceId) public view override(ERC721A, ERC2981) returns (bool) {
1642         return super.supportsInterface(interfaceId);
1643     }
1644 
1645     function withdraw() external onlyOwner {
1646         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1647         require(success, "Failure to execute.");
1648     }
1649 }