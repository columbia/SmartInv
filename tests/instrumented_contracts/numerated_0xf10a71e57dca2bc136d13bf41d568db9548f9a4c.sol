1 //SPDX-License-Identifier: Unlicense
2 // Sources flattened with hardhat v2.10.1 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
5 
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 indexed tokenId
48     );
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(
54         address indexed owner,
55         address indexed approved,
56         uint256 indexed tokenId
57     );
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(
63         address indexed owner,
64         address indexed operator,
65         bool approved
66     );
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(
96         address from,
97         address to,
98         uint256 tokenId,
99         bytes calldata data
100     ) external;
101 
102     /**
103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must exist and be owned by `from`.
111      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
113      *
114      * Emits a {Transfer} event.
115      */
116     function safeTransferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Transfers `tokenId` token from `from` to `to`.
124      *
125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address from,
138         address to,
139         uint256 tokenId
140     ) external;
141 
142     /**
143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
144      * The approval is cleared when the token is transferred.
145      *
146      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
147      *
148      * Requirements:
149      *
150      * - The caller must own the token or be an approved operator.
151      * - `tokenId` must exist.
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address to, uint256 tokenId) external;
156 
157     /**
158      * @dev Approve or remove `operator` as an operator for the caller.
159      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
160      *
161      * Requirements:
162      *
163      * - The `operator` cannot be the caller.
164      *
165      * Emits an {ApprovalForAll} event.
166      */
167     function setApprovalForAll(address operator, bool _approved) external;
168 
169     /**
170      * @dev Returns the account approved for `tokenId` token.
171      *
172      * Requirements:
173      *
174      * - `tokenId` must exist.
175      */
176     function getApproved(uint256 tokenId)
177         external
178         view
179         returns (address operator);
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator)
187         external
188         view
189         returns (bool);
190 }
191 
192 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.0
193 
194 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC721 token receiver interface
200  * @dev Interface for any contract that wants to support safeTransfers
201  * from ERC721 asset contracts.
202  */
203 interface IERC721Receiver {
204     /**
205      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
206      * by `operator` from `from`, this function is called.
207      *
208      * It must return its Solidity selector to confirm the token transfer.
209      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
210      *
211      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
212      */
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
220 
221 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.0
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
229  * @dev See https://eips.ethereum.org/EIPS/eip-721
230  */
231 interface IERC721Metadata is IERC721 {
232     /**
233      * @dev Returns the token collection name.
234      */
235     function name() external view returns (string memory);
236 
237     /**
238      * @dev Returns the token collection symbol.
239      */
240     function symbol() external view returns (string memory);
241 
242     /**
243      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
244      */
245     function tokenURI(uint256 tokenId) external view returns (string memory);
246 }
247 
248 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
249 
250 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
251 
252 pragma solidity ^0.8.1;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      *
275      * [IMPORTANT]
276      * ====
277      * You shouldn't rely on `isContract` to protect against flash loan attacks!
278      *
279      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
280      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
281      * constructor.
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies on extcodesize/address.code.length, which returns 0
286         // for contracts in construction, since the code is only stored at the end
287         // of the constructor execution.
288 
289         return account.code.length > 0;
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(
310             address(this).balance >= amount,
311             "Address: insufficient balance"
312         );
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(
316             success,
317             "Address: unable to send value, recipient may have reverted"
318         );
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain `call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data)
340         internal
341         returns (bytes memory)
342     {
343         return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value
375     ) internal returns (bytes memory) {
376         return
377             functionCallWithValue(
378                 target,
379                 data,
380                 value,
381                 "Address: low-level call with value failed"
382             );
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(
398             address(this).balance >= value,
399             "Address: insufficient balance for call"
400         );
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(
404             data
405         );
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(address target, bytes memory data)
416         internal
417         view
418         returns (bytes memory)
419     {
420         return
421             functionStaticCall(
422                 target,
423                 data,
424                 "Address: low-level static call failed"
425             );
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.staticcall(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(address target, bytes memory data)
452         internal
453         returns (bytes memory)
454     {
455         return
456             functionDelegateCall(
457                 target,
458                 data,
459                 "Address: low-level delegate call failed"
460             );
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(isContract(target), "Address: delegate call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
482      * revert reason using the provided one.
483      *
484      * _Available since v4.3._
485      */
486     function verifyCallResult(
487         bool success,
488         bytes memory returndata,
489         string memory errorMessage
490     ) internal pure returns (bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497                 /// @solidity memory-safe-assembly
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
510 
511 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Provides information about the current execution context, including the
517  * sender of the transaction and its data. While these are generally available
518  * via msg.sender and msg.data, they should not be accessed in such a direct
519  * manner, since when dealing with meta-transactions the account sending and
520  * paying for execution may not be the actual sender (as far as an application
521  * is concerned).
522  *
523  * This contract is only required for intermediate, library-like contracts.
524  */
525 abstract contract Context {
526     function _msgSender() internal view virtual returns (address) {
527         return msg.sender;
528     }
529 
530     function _msgData() internal view virtual returns (bytes calldata) {
531         return msg.data;
532     }
533 }
534 
535 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.0
536 
537 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev String operations.
543  */
544 library Strings {
545     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
546     uint8 private constant _ADDRESS_LENGTH = 20;
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
550      */
551     function toString(uint256 value) internal pure returns (string memory) {
552         // Inspired by OraclizeAPI's implementation - MIT licence
553         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
554 
555         if (value == 0) {
556             return "0";
557         }
558         uint256 temp = value;
559         uint256 digits;
560         while (temp != 0) {
561             digits++;
562             temp /= 10;
563         }
564         bytes memory buffer = new bytes(digits);
565         while (value != 0) {
566             digits -= 1;
567             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
568             value /= 10;
569         }
570         return string(buffer);
571     }
572 
573     /**
574      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
575      */
576     function toHexString(uint256 value) internal pure returns (string memory) {
577         if (value == 0) {
578             return "0x00";
579         }
580         uint256 temp = value;
581         uint256 length = 0;
582         while (temp != 0) {
583             length++;
584             temp >>= 8;
585         }
586         return toHexString(value, length);
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
591      */
592     function toHexString(uint256 value, uint256 length)
593         internal
594         pure
595         returns (string memory)
596     {
597         bytes memory buffer = new bytes(2 * length + 2);
598         buffer[0] = "0";
599         buffer[1] = "x";
600         for (uint256 i = 2 * length + 1; i > 1; --i) {
601             buffer[i] = _HEX_SYMBOLS[value & 0xf];
602             value >>= 4;
603         }
604         require(value == 0, "Strings: hex length insufficient");
605         return string(buffer);
606     }
607 
608     /**
609      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
610      */
611     function toHexString(address addr) internal pure returns (string memory) {
612         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
613     }
614 }
615 
616 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.0
617 
618 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Implementation of the {IERC165} interface.
624  *
625  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
626  * for the additional interface id that will be supported. For example:
627  *
628  * ```solidity
629  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
630  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
631  * }
632  * ```
633  *
634  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
635  */
636 abstract contract ERC165 is IERC165 {
637     /**
638      * @dev See {IERC165-supportsInterface}.
639      */
640     function supportsInterface(bytes4 interfaceId)
641         public
642         view
643         virtual
644         override
645         returns (bool)
646     {
647         return interfaceId == type(IERC165).interfaceId;
648     }
649 }
650 
651 // File contracts/ERC721A.sol
652 
653 // Creator: Chiru Labs
654 
655 pragma solidity ^0.8.4;
656 
657 error ApprovalCallerNotOwnerNorApproved();
658 error ApprovalQueryForNonexistentToken();
659 error ApproveToCaller();
660 error ApprovalToCurrentOwner();
661 error BalanceQueryForZeroAddress();
662 error MintToZeroAddress();
663 error MintZeroQuantity();
664 error OwnerQueryForNonexistentToken();
665 error TransferCallerNotOwnerNorApproved();
666 error TransferFromIncorrectOwner();
667 error TransferToNonERC721ReceiverImplementer();
668 error TransferToZeroAddress();
669 error URIQueryForNonexistentToken();
670 
671 /**
672  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
673  * the Metadata extension. Built to optimize for lower gas during batch mints.
674  *
675  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
676  *
677  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
678  *
679  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
680  */
681 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
682     using Address for address;
683     using Strings for uint256;
684 
685     // Compiler will pack this into a single 256bit word.
686     struct TokenOwnership {
687         // The address of the owner.
688         address addr;
689         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
690         uint64 startTimestamp;
691         // Whether the token has been burned.
692         bool burned;
693     }
694 
695     // Compiler will pack this into a single 256bit word.
696     struct AddressData {
697         // Realistically, 2**64-1 is more than enough.
698         uint64 balance;
699         // Keeps track of mint count with minimal overhead for tokenomics.
700         uint64 numberMinted;
701         // Keeps track of burn count with minimal overhead for tokenomics.
702         uint64 numberBurned;
703         // For miscellaneous variable(s) pertaining to the address
704         // (e.g. number of whitelist mint slots used).
705         // If there are multiple variables, please pack them into a uint64.
706         uint64 aux;
707     }
708 
709     // The tokenId of the next token to be minted.
710     uint256 internal _currentIndex;
711 
712     // The number of tokens burned.
713     uint256 internal _burnCounter;
714 
715     // Token name
716     string private _name;
717 
718     // Token symbol
719     string private _symbol;
720 
721     // Mapping from token ID to ownership details
722     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
723     mapping(uint256 => TokenOwnership) internal _ownerships;
724 
725     // Mapping owner address to address data
726     mapping(address => AddressData) private _addressData;
727 
728     // Mapping from token ID to approved address
729     mapping(uint256 => address) private _tokenApprovals;
730 
731     // Mapping from owner to operator approvals
732     mapping(address => mapping(address => bool)) internal _operatorApprovals;
733 
734     constructor(string memory name_, string memory symbol_) {
735         _name = name_;
736         _symbol = symbol_;
737         _currentIndex = _startTokenId();
738     }
739 
740     /**
741      * To change the starting tokenId, please override this function.
742      */
743     function _startTokenId() internal view virtual returns (uint256) {
744         return 0;
745     }
746 
747     /**
748      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
749      */
750     function totalSupply() public view returns (uint256) {
751         // Counter underflow is impossible as _burnCounter cannot be incremented
752         // more than _currentIndex - _startTokenId() times
753         unchecked {
754             return _currentIndex - _burnCounter - _startTokenId();
755         }
756     }
757 
758     /**
759      * Returns the total amount of tokens minted in the contract.
760      */
761     function _totalMinted() internal view returns (uint256) {
762         // Counter underflow is impossible as _currentIndex does not decrement,
763         // and it is initialized to _startTokenId()
764         unchecked {
765             return _currentIndex - _startTokenId();
766         }
767     }
768 
769     /**
770      * @dev See {IERC165-supportsInterface}.
771      */
772     function supportsInterface(bytes4 interfaceId)
773         public
774         view
775         virtual
776         override(ERC165, IERC165)
777         returns (bool)
778     {
779         return
780             interfaceId == type(IERC721).interfaceId ||
781             interfaceId == type(IERC721Metadata).interfaceId ||
782             super.supportsInterface(interfaceId);
783     }
784 
785     /**
786      * @dev See {IERC721-balanceOf}.
787      */
788     function balanceOf(address owner) public view override returns (uint256) {
789         if (owner == address(0)) revert BalanceQueryForZeroAddress();
790         return uint256(_addressData[owner].balance);
791     }
792 
793     /**
794      * Returns the number of tokens minted by `owner`.
795      */
796     function _numberMinted(address owner) internal view returns (uint256) {
797         return uint256(_addressData[owner].numberMinted);
798     }
799 
800     /**
801      * Returns the number of tokens burned by or on behalf of `owner`.
802      */
803     function _numberBurned(address owner) internal view returns (uint256) {
804         return uint256(_addressData[owner].numberBurned);
805     }
806 
807     /**
808      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
809      */
810     function _getAux(address owner) internal view returns (uint64) {
811         return _addressData[owner].aux;
812     }
813 
814     /**
815      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
816      * If there are multiple variables, please pack them into a uint64.
817      */
818     function _setAux(address owner, uint64 aux) internal {
819         _addressData[owner].aux = aux;
820     }
821 
822     /**
823      * Gas spent here starts off proportional to the maximum mint batch size.
824      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
825      */
826     function _ownershipOf(uint256 tokenId)
827         internal
828         view
829         returns (TokenOwnership memory)
830     {
831         uint256 curr = tokenId;
832 
833         unchecked {
834             if (_startTokenId() <= curr && curr < _currentIndex) {
835                 TokenOwnership memory ownership = _ownerships[curr];
836                 if (!ownership.burned) {
837                     if (ownership.addr != address(0)) {
838                         return ownership;
839                     }
840                     // Invariant:
841                     // There will always be an ownership that has an address and is not burned
842                     // before an ownership that does not have an address and is not burned.
843                     // Hence, curr will not underflow.
844                     while (true) {
845                         curr--;
846                         ownership = _ownerships[curr];
847                         if (ownership.addr != address(0)) {
848                             return ownership;
849                         }
850                     }
851                 }
852             }
853         }
854         revert OwnerQueryForNonexistentToken();
855     }
856 
857     /**
858      * @dev See {IERC721-ownerOf}.
859      */
860     function ownerOf(uint256 tokenId) public view override returns (address) {
861         return _ownershipOf(tokenId).addr;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-name}.
866      */
867     function name() public view virtual override returns (string memory) {
868         return _name;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-symbol}.
873      */
874     function symbol() public view virtual override returns (string memory) {
875         return _symbol;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-tokenURI}.
880      */
881     function tokenURI(uint256 tokenId)
882         public
883         view
884         virtual
885         override
886         returns (string memory)
887     {
888         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
889 
890         string memory baseURI = _baseURI();
891         return
892             bytes(baseURI).length != 0
893                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
894                 : "";
895     }
896 
897     /**
898      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
899      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
900      * by default, can be overriden in child contracts.
901      */
902     function _baseURI() internal view virtual returns (string memory) {
903         return "";
904     }
905 
906     /**
907      * @dev See {IERC721-approve}.
908      */
909     function approve(address to, uint256 tokenId) public virtual {}
910 
911     /**
912      * @dev See {IERC721-getApproved}.
913      */
914     function getApproved(uint256 tokenId)
915         public
916         view
917         override
918         returns (address)
919     {
920         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved)
929         public
930         virtual
931     {}
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator)
937         public
938         view
939         virtual
940         override
941         returns (bool)
942     {
943         return _operatorApprovals[owner][operator];
944     }
945 
946     /**
947      * @dev See {IERC721-transferFrom}.
948      */
949     function transferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         _transfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId
964     ) public virtual override {
965         safeTransferFrom(from, to, tokenId, "");
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) public virtual override {
977         _transfer(from, to, tokenId);
978         if (
979             to.isContract() &&
980             !_checkContractOnERC721Received(from, to, tokenId, _data)
981         ) {
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
994         return
995             _startTokenId() <= tokenId &&
996             tokenId < _currentIndex &&
997             !_ownerships[tokenId].burned;
998     }
999 
1000     /**
1001      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1002      */
1003     function _safeMint(address to, uint256 quantity) internal {
1004         _safeMint(to, quantity, "");
1005     }
1006 
1007     /**
1008      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - If `to` refers to a smart contract, it must implement
1013      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1014      * - `quantity` must be greater than 0.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _safeMint(
1019         address to,
1020         uint256 quantity,
1021         bytes memory _data
1022     ) internal {
1023         uint256 startTokenId = _currentIndex;
1024         if (to == address(0)) revert MintToZeroAddress();
1025         if (quantity == 0) revert MintZeroQuantity();
1026 
1027         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029         // Overflows are incredibly unrealistic.
1030         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1031         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1032         unchecked {
1033             _addressData[to].balance += uint64(quantity);
1034             _addressData[to].numberMinted += uint64(quantity);
1035 
1036             _ownerships[startTokenId].addr = to;
1037             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1038 
1039             uint256 updatedIndex = startTokenId;
1040             uint256 end = updatedIndex + quantity;
1041 
1042             if (to.isContract()) {
1043                 do {
1044                     emit Transfer(address(0), to, updatedIndex);
1045                     if (
1046                         !_checkContractOnERC721Received(
1047                             address(0),
1048                             to,
1049                             updatedIndex++,
1050                             _data
1051                         )
1052                     ) {
1053                         revert TransferToNonERC721ReceiverImplementer();
1054                     }
1055                 } while (updatedIndex != end);
1056                 // Reentrancy protection
1057                 if (_currentIndex != startTokenId) revert();
1058             } else {
1059                 do {
1060                     emit Transfer(address(0), to, updatedIndex++);
1061                 } while (updatedIndex != end);
1062             }
1063             _currentIndex = updatedIndex;
1064         }
1065         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1066     }
1067 
1068     /**
1069      * @dev Mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - `to` cannot be the zero address.
1074      * - `quantity` must be greater than 0.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _mint(address to, uint256 quantity) internal {
1079         uint256 startTokenId = _currentIndex;
1080         if (to == address(0)) revert MintToZeroAddress();
1081         if (quantity == 0) revert MintZeroQuantity();
1082 
1083         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1084 
1085         // Overflows are incredibly unrealistic.
1086         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1087         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1088         unchecked {
1089             _addressData[to].balance += uint64(quantity);
1090             _addressData[to].numberMinted += uint64(quantity);
1091 
1092             _ownerships[startTokenId].addr = to;
1093             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1094 
1095             uint256 updatedIndex = startTokenId;
1096             uint256 end = updatedIndex + quantity;
1097 
1098             do {
1099                 emit Transfer(address(0), to, updatedIndex++);
1100             } while (updatedIndex != end);
1101 
1102             _currentIndex = updatedIndex;
1103         }
1104         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1105     }
1106 
1107     /**
1108      * @dev Transfers `tokenId` from `from` to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must be owned by `from`.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _transfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) private {
1122         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1123 
1124         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1125 
1126         bool isApprovedOrOwner = (_msgSender() == from ||
1127             isApprovedForAll(from, _msgSender()) ||
1128             getApproved(tokenId) == _msgSender());
1129 
1130         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1131         if (to == address(0)) revert TransferToZeroAddress();
1132 
1133         _beforeTokenTransfers(from, to, tokenId, 1);
1134 
1135         // Clear approvals from the previous owner
1136         _approve(address(0), tokenId, from);
1137 
1138         // Underflow of the sender's balance is impossible because we check for
1139         // ownership above and the recipient's balance can't realistically overflow.
1140         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1141         unchecked {
1142             _addressData[from].balance -= 1;
1143             _addressData[to].balance += 1;
1144 
1145             TokenOwnership storage currSlot = _ownerships[tokenId];
1146             currSlot.addr = to;
1147             currSlot.startTimestamp = uint64(block.timestamp);
1148 
1149             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1150             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1151             uint256 nextTokenId = tokenId + 1;
1152             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1153             if (nextSlot.addr == address(0)) {
1154                 // This will suffice for checking _exists(nextTokenId),
1155                 // as a burned slot cannot contain the zero address.
1156                 if (nextTokenId != _currentIndex) {
1157                     nextSlot.addr = from;
1158                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, to, tokenId);
1164         _afterTokenTransfers(from, to, tokenId, 1);
1165     }
1166 
1167     /**
1168      * @dev Equivalent to `_burn(tokenId, false)`.
1169      */
1170     function _burn(uint256 tokenId) internal virtual {
1171         _burn(tokenId, false);
1172     }
1173 
1174     /**
1175      * @dev Destroys `tokenId`.
1176      * The approval is cleared when the token is burned.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must exist.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1185         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1186 
1187         address from = prevOwnership.addr;
1188 
1189         if (approvalCheck) {
1190             bool isApprovedOrOwner = (_msgSender() == from ||
1191                 isApprovedForAll(from, _msgSender()) ||
1192                 getApproved(tokenId) == _msgSender());
1193 
1194             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         }
1196 
1197         _beforeTokenTransfers(from, address(0), tokenId, 1);
1198 
1199         // Clear approvals from the previous owner
1200         _approve(address(0), tokenId, from);
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             AddressData storage addressData = _addressData[from];
1207             addressData.balance -= 1;
1208             addressData.numberBurned += 1;
1209 
1210             // Keep track of who burned the token, and the timestamp of burning.
1211             TokenOwnership storage currSlot = _ownerships[tokenId];
1212             currSlot.addr = from;
1213             currSlot.startTimestamp = uint64(block.timestamp);
1214             currSlot.burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1220             if (nextSlot.addr == address(0)) {
1221                 // This will suffice for checking _exists(nextTokenId),
1222                 // as a burned slot cannot contain the zero address.
1223                 if (nextTokenId != _currentIndex) {
1224                     nextSlot.addr = from;
1225                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(from, address(0), tokenId);
1231         _afterTokenTransfers(from, address(0), tokenId, 1);
1232 
1233         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1234         unchecked {
1235             _burnCounter++;
1236         }
1237     }
1238 
1239     /**
1240      * @dev Approve `to` to operate on `tokenId`
1241      *
1242      * Emits a {Approval} event.
1243      */
1244     function _approve(
1245         address to,
1246         uint256 tokenId,
1247         address owner
1248     ) internal {
1249         _tokenApprovals[tokenId] = to;
1250         emit Approval(owner, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1255      *
1256      * @param from address representing the previous owner of the given token ID
1257      * @param to target address that will receive the tokens
1258      * @param tokenId uint256 ID of the token to be transferred
1259      * @param _data bytes optional data to send along with the call
1260      * @return bool whether the call correctly returned the expected magic value
1261      */
1262     function _checkContractOnERC721Received(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) private returns (bool) {
1268         try
1269             IERC721Receiver(to).onERC721Received(
1270                 _msgSender(),
1271                 from,
1272                 tokenId,
1273                 _data
1274             )
1275         returns (bytes4 retval) {
1276             return retval == IERC721Receiver(to).onERC721Received.selector;
1277         } catch (bytes memory reason) {
1278             if (reason.length == 0) {
1279                 revert TransferToNonERC721ReceiverImplementer();
1280             } else {
1281                 assembly {
1282                     revert(add(32, reason), mload(reason))
1283                 }
1284             }
1285         }
1286     }
1287 
1288     /**
1289      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1290      * And also called before burning one token.
1291      *
1292      * startTokenId - the first token id to be transferred
1293      * quantity - the amount to be transferred
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, `tokenId` will be burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _beforeTokenTransfers(
1304         address from,
1305         address to,
1306         uint256 startTokenId,
1307         uint256 quantity
1308     ) internal virtual {}
1309 
1310     /**
1311      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1312      * minting.
1313      * And also called after one token has been burned.
1314      *
1315      * startTokenId - the first token id to be transferred
1316      * quantity - the amount to be transferred
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` has been minted for `to`.
1323      * - When `to` is zero, `tokenId` has been burned by `from`.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _afterTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 }
1333 
1334 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
1335 
1336 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 /**
1341  * @dev Contract module which provides a basic access control mechanism, where
1342  * there is an account (an owner) that can be granted exclusive access to
1343  * specific functions.
1344  *
1345  * By default, the owner account will be the one that deploys the contract. This
1346  * can later be changed with {transferOwnership}.
1347  *
1348  * This module is used through inheritance. It will make available the modifier
1349  * `onlyOwner`, which can be applied to your functions to restrict their use to
1350  * the owner.
1351  */
1352 abstract contract Ownable is Context {
1353     address private _owner;
1354 
1355     event OwnershipTransferred(
1356         address indexed previousOwner,
1357         address indexed newOwner
1358     );
1359 
1360     /**
1361      * @dev Initializes the contract setting the deployer as the initial owner.
1362      */
1363     constructor() {
1364         _transferOwnership(_msgSender());
1365     }
1366 
1367     /**
1368      * @dev Throws if called by any account other than the owner.
1369      */
1370     modifier onlyOwner() {
1371         _checkOwner();
1372         _;
1373     }
1374 
1375     /**
1376      * @dev Returns the address of the current owner.
1377      */
1378     function owner() public view virtual returns (address) {
1379         return _owner;
1380     }
1381 
1382     /**
1383      * @dev Throws if the sender is not the owner.
1384      */
1385     function _checkOwner() internal view virtual {
1386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1387     }
1388 
1389     /**
1390      * @dev Leaves the contract without owner. It will not be possible to call
1391      * `onlyOwner` functions anymore. Can only be called by the current owner.
1392      *
1393      * NOTE: Renouncing ownership will leave the contract without an owner,
1394      * thereby removing any functionality that is only available to the owner.
1395      */
1396     function renounceOwnership() public virtual onlyOwner {
1397         _transferOwnership(address(0));
1398     }
1399 
1400     /**
1401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1402      * Can only be called by the current owner.
1403      */
1404     function transferOwnership(address newOwner) public virtual onlyOwner {
1405         require(
1406             newOwner != address(0),
1407             "Ownable: new owner is the zero address"
1408         );
1409         _transferOwnership(newOwner);
1410     }
1411 
1412     /**
1413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1414      * Internal function without access restriction.
1415      */
1416     function _transferOwnership(address newOwner) internal virtual {
1417         address oldOwner = _owner;
1418         _owner = newOwner;
1419         emit OwnershipTransferred(oldOwner, newOwner);
1420     }
1421 }
1422 
1423 // File contracts/Floaties.sol
1424 
1425 pragma solidity ^0.8.9;
1426 
1427 contract Floaties is ERC721A, Ownable {
1428     string private _baseTokenURI;
1429 
1430     mapping(address => bool) public bannedExchanges;
1431     mapping(address => bool) public whitelist;
1432 
1433     bool public whitelistIsOpen = false;
1434     bool public saleIsActive = false;
1435     bool public whitelistSaleIsActive = false;
1436 
1437     uint256 public maxAmount = 3333;
1438     uint256 public maxPerMint = 30;
1439     uint256 public nftPrice = 0.07 ether;
1440 
1441     uint256 public maxWhitelist = 1000;
1442     uint256 public whitelistLength = 0;
1443 
1444     address private mktWallet = 0xd6544adA9811B74899EB7aAEE742a8B9f552C5Cf;
1445     address private lowIQWallet = 0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA;
1446     address private devWallet = 0x5f55F579beB3beaD4163604a630731556B52a9f0;
1447     address private artWallet = 0xa64c09B57d311f0a9240b75f6Ead51f83D1732EA;
1448     address private copyWallet = 0xB09e818F51E054eB50b570ED476951aB0F974b14;
1449     address private ideaWallet = 0x9114B6E313A29fd8eCe8Ca8fE7A834024434DA18;
1450 
1451     constructor() ERC721A("Floaties", "FLOATIES") {}
1452 
1453     receive() external payable {}
1454 
1455     function _baseURI() internal view virtual override returns (string memory) {
1456         return _baseTokenURI;
1457     }
1458 
1459     function setBaseURI(string calldata baseURI) external onlyOwner {
1460         _baseTokenURI = baseURI;
1461     }
1462 
1463     function flipSaleState() public onlyOwner {
1464         saleIsActive = !saleIsActive;
1465     }
1466 
1467     function flipWhitelistSaleState() public onlyOwner {
1468         whitelistSaleIsActive = !whitelistSaleIsActive;
1469     }
1470 
1471     function flipWhitelistOpen() public onlyOwner {
1472         whitelistIsOpen = !whitelistIsOpen;
1473     }
1474 
1475     function mintReserveTokens(uint256 numberOfTokens) public onlyOwner {
1476         _safeMint(msg.sender, numberOfTokens);
1477         require(totalSupply() <= maxAmount, "Limit reached");
1478     }
1479 
1480     function mintNFTWhitelist(uint256 numberOfTokens) public payable {
1481         require(whitelistSaleIsActive, "Whitelist sale is not active");
1482         require(
1483             numberOfTokens <= maxPerMint,
1484             "You can't mint that many at once"
1485         );
1486         require(
1487             nftPrice * numberOfTokens <= msg.value,
1488             "Ether value incorrect"
1489         );
1490         require(whitelist[msg.sender], "Not whitelisted");
1491 
1492         _safeMint(msg.sender, numberOfTokens);
1493 
1494         require(totalSupply() <= maxAmount, "Limit reached");
1495     }
1496 
1497     function mintNFT(uint256 numberOfTokens) public payable {
1498         require(saleIsActive, "Sale is not active");
1499         require(
1500             numberOfTokens <= maxPerMint,
1501             "You can't mint that many at once"
1502         );
1503         require(
1504             nftPrice * numberOfTokens <= msg.value,
1505             "Ether value sent is not correct"
1506         );
1507 
1508         _safeMint(msg.sender, numberOfTokens);
1509 
1510         require(totalSupply() <= maxAmount, "Limit reached");
1511     }
1512 
1513     function withdrawMoney() external onlyOwner {
1514         payable(msg.sender).transfer(address(this).balance);
1515     }
1516 
1517     function withdrawAll() public onlyOwner {
1518         uint256 dev = (address(this).balance * 1575) / 10000;
1519         uint256 art = (address(this).balance * 1575) / 10000;
1520         uint256 copy = (address(this).balance * 1575) / 10000;
1521         uint256 idea = (address(this).balance * 1575) / 10000;
1522         uint256 lowiq = (address(this).balance * 900) / 10000;
1523         uint256 mkt = (address(this).balance * 1800) / 10000;
1524 
1525         require(payable(devWallet).send(dev));
1526         require(payable(artWallet).send(art));
1527         require(payable(copyWallet).send(copy));
1528         require(payable(mktWallet).send(mkt));
1529         require(payable(ideaWallet).send(idea));
1530         require(payable(lowIQWallet).send(lowiq));
1531     }
1532 
1533     function addBannedExchange(address account) external onlyOwner {
1534         bannedExchanges[account] = true;
1535     }
1536 
1537     function removeBannedExchange(address account) external onlyOwner {
1538         bannedExchanges[account] = false;
1539     }
1540 
1541     function setWhitelistLimit(uint256 newMax) external onlyOwner {
1542         maxWhitelist = newMax;
1543     }
1544 
1545     function approve(address to, uint256 tokenId) public override {
1546         address owner = ERC721A.ownerOf(tokenId);
1547         if (to == owner) revert ApprovalToCurrentOwner();
1548 
1549         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1550             revert ApprovalCallerNotOwnerNorApproved();
1551         }
1552         require(!bannedExchanges[to], "This exchange is not allowed.");
1553 
1554         _approve(to, tokenId, owner);
1555     }
1556 
1557     function setApprovalForAll(address operator, bool approved)
1558         public
1559         override
1560     {
1561         require(!bannedExchanges[operator], "This exchange is not allowed.");
1562 
1563         if (operator == _msgSender()) revert ApproveToCaller();
1564 
1565         _operatorApprovals[_msgSender()][operator] = approved;
1566         emit ApprovalForAll(_msgSender(), operator, approved);
1567     }
1568 
1569     function addToWhitelist(address wallet) external onlyOwner {
1570         whitelistLength++;
1571         whitelist[wallet] = true;
1572     }
1573 
1574     function addSelfToWhitelist() external {
1575         require(whitelistIsOpen, "Whitelist not open");
1576         require(whitelistLength < maxWhitelist, "Whitelist is full");
1577         require(!whitelist[msg.sender], "You are already on the whitelist.");
1578         whitelistLength++;
1579         whitelist[msg.sender] = true;
1580     }
1581 
1582     function removeFromWhitelist(address wallet) external onlyOwner {
1583         require(whitelistLength > 0, "Whitelist is empty");
1584         whitelistLength--;
1585         whitelist[wallet] = false;
1586     }
1587 }