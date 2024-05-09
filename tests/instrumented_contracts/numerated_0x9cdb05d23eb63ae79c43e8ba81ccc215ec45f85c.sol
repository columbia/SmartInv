1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length)
60         internal
61         pure
62         returns (string memory)
63     {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Address.sol
103 
104 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
105 
106 pragma solidity ^0.8.1;
107 
108 /**
109  * @dev Collection of functions related to the address type
110  */
111 library Address {
112     /**
113      * @dev Returns true if `account` is a contract.
114      *
115      * [IMPORTANT]
116      * ====
117      * It is unsafe to assume that an address for which this function returns
118      * false is an externally-owned account (EOA) and not a contract.
119      *
120      * Among others, `isContract` will return false for the following
121      * types of addresses:
122      *
123      *  - an externally-owned account
124      *  - a contract in construction
125      *  - an address where a contract will be created
126      *  - an address where a contract lived, but was destroyed
127      * ====
128      *
129      * [IMPORTANT]
130      * ====
131      * You shouldn't rely on `isContract` to protect against flash loan attacks!
132      *
133      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
134      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
135      * constructor.
136      * ====
137      */
138     function isContract(address account) internal view returns (bool) {
139         // This method relies on extcodesize/address.code.length, which returns 0
140         // for contracts in construction, since the code is only stored at the end
141         // of the constructor execution.
142 
143         return account.code.length > 0;
144     }
145 
146     /**
147      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
148      * `recipient`, forwarding all available gas and reverting on errors.
149      *
150      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
151      * of certain opcodes, possibly making contracts go over the 2300 gas limit
152      * imposed by `transfer`, making them unable to receive funds via
153      * `transfer`. {sendValue} removes this limitation.
154      *
155      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
156      *
157      * IMPORTANT: because control is transferred to `recipient`, care must be
158      * taken to not create reentrancy vulnerabilities. Consider using
159      * {ReentrancyGuard} or the
160      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
161      */
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(
164             address(this).balance >= amount,
165             "Address: insufficient balance"
166         );
167 
168         (bool success, ) = recipient.call{value: amount}("");
169         require(
170             success,
171             "Address: unable to send value, recipient may have reverted"
172         );
173     }
174 
175     /**
176      * @dev Performs a Solidity function call using a low level `call`. A
177      * plain `call` is an unsafe replacement for a function call: use this
178      * function instead.
179      *
180      * If `target` reverts with a revert reason, it is bubbled up by this
181      * function (like regular Solidity function calls).
182      *
183      * Returns the raw returned data. To convert to the expected return value,
184      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
185      *
186      * Requirements:
187      *
188      * - `target` must be a contract.
189      * - calling `target` with `data` must not revert.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(address target, bytes memory data)
194         internal
195         returns (bytes memory)
196     {
197         return functionCall(target, data, "Address: low-level call failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
202      * `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         return functionCallWithValue(target, data, 0, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but also transferring `value` wei to `target`.
217      *
218      * Requirements:
219      *
220      * - the calling contract must have an ETH balance of at least `value`.
221      * - the called Solidity function must be `payable`.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value
229     ) internal returns (bytes memory) {
230         return
231             functionCallWithValue(
232                 target,
233                 data,
234                 value,
235                 "Address: low-level call with value failed"
236             );
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
241      * with `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCallWithValue(
246         address target,
247         bytes memory data,
248         uint256 value,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         require(
252             address(this).balance >= value,
253             "Address: insufficient balance for call"
254         );
255         require(isContract(target), "Address: call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.call{value: value}(
258             data
259         );
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(address target, bytes memory data)
270         internal
271         view
272         returns (bytes memory)
273     {
274         return
275             functionStaticCall(
276                 target,
277                 data,
278                 "Address: low-level static call failed"
279             );
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a static call.
285      *
286      * _Available since v3.3._
287      */
288     function functionStaticCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal view returns (bytes memory) {
293         require(isContract(target), "Address: static call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.staticcall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but performing a delegate call.
302      *
303      * _Available since v3.4._
304      */
305     function functionDelegateCall(address target, bytes memory data)
306         internal
307         returns (bytes memory)
308     {
309         return
310             functionDelegateCall(
311                 target,
312                 data,
313                 "Address: low-level delegate call failed"
314             );
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(isContract(target), "Address: delegate call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.delegatecall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
336      * revert reason using the provided one.
337      *
338      * _Available since v4.3._
339      */
340     function verifyCallResult(
341         bool success,
342         bytes memory returndata,
343         string memory errorMessage
344     ) internal pure returns (bytes memory) {
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
364 
365 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @title ERC721 token receiver interface
371  * @dev Interface for any contract that wants to support safeTransfers
372  * from ERC721 asset contracts.
373  */
374 interface IERC721Receiver {
375     /**
376      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
377      * by `operator` from `from`, this function is called.
378      *
379      * It must return its Solidity selector to confirm the token transfer.
380      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
381      *
382      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
383      */
384     function onERC721Received(
385         address operator,
386         address from,
387         uint256 tokenId,
388         bytes calldata data
389     ) external returns (bytes4);
390 }
391 
392 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
393 
394 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @dev Interface of the ERC165 standard, as defined in the
400  * https://eips.ethereum.org/EIPS/eip-165[EIP].
401  *
402  * Implementers can declare support of contract interfaces, which can then be
403  * queried by others ({ERC165Checker}).
404  *
405  * For an implementation, see {ERC165}.
406  */
407 interface IERC165 {
408     /**
409      * @dev Returns true if this contract implements the interface defined by
410      * `interfaceId`. See the corresponding
411      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
412      * to learn more about how these ids are created.
413      *
414      * This function call must use less than 30 000 gas.
415      */
416     function supportsInterface(bytes4 interfaceId) external view returns (bool);
417 }
418 
419 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
420 
421 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Implementation of the {IERC165} interface.
427  *
428  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
429  * for the additional interface id that will be supported. For example:
430  *
431  * ```solidity
432  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
434  * }
435  * ```
436  *
437  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
438  */
439 abstract contract ERC165 is IERC165 {
440     /**
441      * @dev See {IERC165-supportsInterface}.
442      */
443     function supportsInterface(bytes4 interfaceId)
444         public
445         view
446         virtual
447         override
448         returns (bool)
449     {
450         return interfaceId == type(IERC165).interfaceId;
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
455 
456 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Required interface of an ERC721 compliant contract.
462  */
463 interface IERC721 is IERC165 {
464     /**
465      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
466      */
467     event Transfer(
468         address indexed from,
469         address indexed to,
470         uint256 indexed tokenId
471     );
472 
473     /**
474      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
475      */
476     event Approval(
477         address indexed owner,
478         address indexed approved,
479         uint256 indexed tokenId
480     );
481 
482     /**
483      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
484      */
485     event ApprovalForAll(
486         address indexed owner,
487         address indexed operator,
488         bool approved
489     );
490 
491     /**
492      * @dev Returns the number of tokens in ``owner``'s account.
493      */
494     function balanceOf(address owner) external view returns (uint256 balance);
495 
496     /**
497      * @dev Returns the owner of the `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function ownerOf(uint256 tokenId) external view returns (address owner);
504 
505     /**
506      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
507      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must exist and be owned by `from`.
514      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
515      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
516      *
517      * Emits a {Transfer} event.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId
523     ) external;
524 
525     /**
526      * @dev Transfers `tokenId` token from `from` to `to`.
527      *
528      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must be owned by `from`.
535      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
536      *
537      * Emits a {Transfer} event.
538      */
539     function transferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
547      * The approval is cleared when the token is transferred.
548      *
549      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
550      *
551      * Requirements:
552      *
553      * - The caller must own the token or be an approved operator.
554      * - `tokenId` must exist.
555      *
556      * Emits an {Approval} event.
557      */
558     function approve(address to, uint256 tokenId) external;
559 
560     /**
561      * @dev Returns the account approved for `tokenId` token.
562      *
563      * Requirements:
564      *
565      * - `tokenId` must exist.
566      */
567     function getApproved(uint256 tokenId)
568         external
569         view
570         returns (address operator);
571 
572     /**
573      * @dev Approve or remove `operator` as an operator for the caller.
574      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
575      *
576      * Requirements:
577      *
578      * - The `operator` cannot be the caller.
579      *
580      * Emits an {ApprovalForAll} event.
581      */
582     function setApprovalForAll(address operator, bool _approved) external;
583 
584     /**
585      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
586      *
587      * See {setApprovalForAll}
588      */
589     function isApprovedForAll(address owner, address operator)
590         external
591         view
592         returns (bool);
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId,
611         bytes calldata data
612     ) external;
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
616 
617 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 /**
622  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
623  * @dev See https://eips.ethereum.org/EIPS/eip-721
624  */
625 interface IERC721Metadata is IERC721 {
626     /**
627      * @dev Returns the token collection name.
628      */
629     function name() external view returns (string memory);
630 
631     /**
632      * @dev Returns the token collection symbol.
633      */
634     function symbol() external view returns (string memory);
635 
636     /**
637      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
638      */
639     function tokenURI(uint256 tokenId) external view returns (string memory);
640 }
641 
642 // File: contracts/new.sol
643 
644 pragma solidity ^0.8.4;
645 
646 error ApprovalCallerNotOwnerNorApproved();
647 error ApprovalQueryForNonexistentToken();
648 error ApproveToCaller();
649 error ApprovalToCurrentOwner();
650 error BalanceQueryForZeroAddress();
651 error MintToZeroAddress();
652 error MintZeroQuantity();
653 error OwnerQueryForNonexistentToken();
654 error TransferCallerNotOwnerNorApproved();
655 error TransferFromIncorrectOwner();
656 error TransferToNonERC721ReceiverImplementer();
657 error TransferToZeroAddress();
658 error URIQueryForNonexistentToken();
659 
660 /**
661  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
662  * the Metadata extension. Built to optimize for lower gas during batch mints.
663  *
664  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
665  *
666  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
667  *
668  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
669  */
670 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
671     using Address for address;
672     using Strings for uint256;
673 
674     // Compiler will pack this into a single 256bit word.
675     struct TokenOwnership {
676         // The address of the owner.
677         address addr;
678         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
679         uint64 startTimestamp;
680         // Whether the token has been burned.
681         bool burned;
682     }
683 
684     // Compiler will pack this into a single 256bit word.
685     struct AddressData {
686         // Realistically, 2**64-1 is more than enough.
687         uint64 balance;
688         // Keeps track of mint count with minimal overhead for tokenomics.
689         uint64 numberMinted;
690         // Keeps track of burn count with minimal overhead for tokenomics.
691         uint64 numberBurned;
692         // For miscellaneous variable(s) pertaining to the address
693         // (e.g. number of whitelist mint slots used).
694         // If there are multiple variables, please pack them into a uint64.
695         uint64 aux;
696     }
697 
698     // The tokenId of the next token to be minted.
699     uint256 internal _currentIndex;
700 
701     // The number of tokens burned.
702     uint256 internal _burnCounter;
703 
704     // Token name
705     string private _name;
706 
707     // Token symbol
708     string private _symbol;
709 
710     // Mapping from token ID to ownership details
711     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
712     mapping(uint256 => TokenOwnership) internal _ownerships;
713 
714     // Mapping owner address to address data
715     mapping(address => AddressData) private _addressData;
716 
717     // Mapping from token ID to approved address
718     mapping(uint256 => address) private _tokenApprovals;
719 
720     // Mapping from owner to operator approvals
721     mapping(address => mapping(address => bool)) private _operatorApprovals;
722 
723     constructor(string memory name_, string memory symbol_) {
724         _name = name_;
725         _symbol = symbol_;
726         _currentIndex = _startTokenId();
727     }
728 
729     /**
730      * To change the starting tokenId, please override this function.
731      */
732     function _startTokenId() internal view virtual returns (uint256) {
733         return 0;
734     }
735 
736     /**
737      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
738      */
739     function totalSupply() public view returns (uint256) {
740         // Counter underflow is impossible as _burnCounter cannot be incremented
741         // more than _currentIndex - _startTokenId() times
742         unchecked {
743             return _currentIndex - _burnCounter - _startTokenId();
744         }
745     }
746 
747     /**
748      * Returns the total amount of tokens minted in the contract.
749      */
750     function _totalMinted() internal view returns (uint256) {
751         // Counter underflow is impossible as _currentIndex does not decrement,
752         // and it is initialized to _startTokenId()
753         unchecked {
754             return _currentIndex - _startTokenId();
755         }
756     }
757 
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId)
762         public
763         view
764         virtual
765         override(ERC165, IERC165)
766         returns (bool)
767     {
768         return
769             interfaceId == type(IERC721).interfaceId ||
770             interfaceId == type(IERC721Metadata).interfaceId ||
771             super.supportsInterface(interfaceId);
772     }
773 
774     /**
775      * @dev See {IERC721-balanceOf}.
776      */
777     function balanceOf(address owner) public view override returns (uint256) {
778         if (owner == address(0)) revert BalanceQueryForZeroAddress();
779         return uint256(_addressData[owner].balance);
780     }
781 
782     /**
783      * Returns the number of tokens minted by `owner`.
784      */
785     function _numberMinted(address owner) internal view returns (uint256) {
786         return uint256(_addressData[owner].numberMinted);
787     }
788 
789     /**
790      * Returns the number of tokens burned by or on behalf of `owner`.
791      */
792     function _numberBurned(address owner) internal view returns (uint256) {
793         return uint256(_addressData[owner].numberBurned);
794     }
795 
796     /**
797      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
798      */
799     function _getAux(address owner) internal view returns (uint64) {
800         return _addressData[owner].aux;
801     }
802 
803     /**
804      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
805      * If there are multiple variables, please pack them into a uint64.
806      */
807     function _setAux(address owner, uint64 aux) internal {
808         _addressData[owner].aux = aux;
809     }
810 
811     /**
812      * Gas spent here starts off proportional to the maximum mint batch size.
813      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
814      */
815     function _ownershipOf(uint256 tokenId)
816         internal
817         view
818         returns (TokenOwnership memory)
819     {
820         uint256 curr = tokenId;
821 
822         unchecked {
823             if (_startTokenId() <= curr && curr < _currentIndex) {
824                 TokenOwnership memory ownership = _ownerships[curr];
825                 if (!ownership.burned) {
826                     if (ownership.addr != address(0)) {
827                         return ownership;
828                     }
829                     // Invariant:
830                     // There will always be an ownership that has an address and is not burned
831                     // before an ownership that does not have an address and is not burned.
832                     // Hence, curr will not underflow.
833                     while (true) {
834                         curr--;
835                         ownership = _ownerships[curr];
836                         if (ownership.addr != address(0)) {
837                             return ownership;
838                         }
839                     }
840                 }
841             }
842         }
843         revert OwnerQueryForNonexistentToken();
844     }
845 
846     /**
847      * @dev See {IERC721-ownerOf}.
848      */
849     function ownerOf(uint256 tokenId) public view override returns (address) {
850         return _ownershipOf(tokenId).addr;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-name}.
855      */
856     function name() public view virtual override returns (string memory) {
857         return _name;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-symbol}.
862      */
863     function symbol() public view virtual override returns (string memory) {
864         return _symbol;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-tokenURI}.
869      */
870     function tokenURI(uint256 tokenId)
871         public
872         view
873         virtual
874         override
875         returns (string memory)
876     {
877         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
878 
879         string memory baseURI = _baseURI();
880         return
881             bytes(baseURI).length != 0
882                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
883                 : "";
884     }
885 
886     /**
887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
889      * by default, can be overriden in child contracts.
890      */
891     function _baseURI() internal view virtual returns (string memory) {
892         return "";
893     }
894 
895     /**
896      * @dev See {IERC721-approve}.
897      */
898     function approve(address to, uint256 tokenId) public override {
899         address owner = ERC721A.ownerOf(tokenId);
900         if (to == owner) revert ApprovalToCurrentOwner();
901 
902         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
903             revert ApprovalCallerNotOwnerNorApproved();
904         }
905 
906         _approve(to, tokenId, owner);
907     }
908 
909     /**
910      * @dev See {IERC721-getApproved}.
911      */
912     function getApproved(uint256 tokenId)
913         public
914         view
915         override
916         returns (address)
917     {
918         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved)
927         public
928         virtual
929         override
930     {
931         if (operator == _msgSender()) revert ApproveToCaller();
932 
933         _operatorApprovals[_msgSender()][operator] = approved;
934         emit ApprovalForAll(_msgSender(), operator, approved);
935     }
936 
937     /**
938      * @dev See {IERC721-isApprovedForAll}.
939      */
940     function isApprovedForAll(address owner, address operator)
941         public
942         view
943         virtual
944         override
945         returns (bool)
946     {
947         return _operatorApprovals[owner][operator];
948     }
949 
950     /**
951      * @dev See {IERC721-transferFrom}.
952      */
953     function transferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         _transfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         safeTransferFrom(from, to, tokenId, "");
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) public virtual override {
981         _transfer(from, to, tokenId);
982         if (
983             to.isContract() &&
984             !_checkContractOnERC721Received(from, to, tokenId, _data)
985         ) {
986             revert TransferToNonERC721ReceiverImplementer();
987         }
988     }
989 
990     /**
991      * @dev Returns whether `tokenId` exists.
992      *
993      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994      *
995      * Tokens start existing when they are minted (`_mint`),
996      */
997     function _exists(uint256 tokenId) internal view returns (bool) {
998         return
999             _startTokenId() <= tokenId &&
1000             tokenId < _currentIndex &&
1001             !_ownerships[tokenId].burned;
1002     }
1003 
1004     function _safeMint(address to, uint256 quantity) internal {
1005         _safeMint(to, quantity, "");
1006     }
1007 
1008     /**
1009      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1014      * - `quantity` must be greater than 0.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _safeMint(
1019         address to,
1020         uint256 quantity,
1021         bytes memory _data
1022     ) internal {
1023         _mint(to, quantity, _data, true);
1024     }
1025 
1026     /**
1027      * @dev Mints `quantity` tokens and transfers them to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _mint(
1037         address to,
1038         uint256 quantity,
1039         bytes memory _data,
1040         bool safe
1041     ) internal {
1042         uint256 startTokenId = _currentIndex;
1043         if (to == address(0)) revert MintToZeroAddress();
1044         if (quantity == 0) revert MintZeroQuantity();
1045 
1046         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1047 
1048         // Overflows are incredibly unrealistic.
1049         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1050         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1051         unchecked {
1052             _addressData[to].balance += uint64(quantity);
1053             _addressData[to].numberMinted += uint64(quantity);
1054 
1055             _ownerships[startTokenId].addr = to;
1056             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1057 
1058             uint256 updatedIndex = startTokenId;
1059             uint256 end = updatedIndex + quantity;
1060 
1061             if (safe && to.isContract()) {
1062                 do {
1063                     emit Transfer(address(0), to, updatedIndex);
1064                     if (
1065                         !_checkContractOnERC721Received(
1066                             address(0),
1067                             to,
1068                             updatedIndex++,
1069                             _data
1070                         )
1071                     ) {
1072                         revert TransferToNonERC721ReceiverImplementer();
1073                     }
1074                 } while (updatedIndex != end);
1075                 // Reentrancy protection
1076                 if (_currentIndex != startTokenId) revert();
1077             } else {
1078                 do {
1079                     emit Transfer(address(0), to, updatedIndex++);
1080                 } while (updatedIndex != end);
1081             }
1082             _currentIndex = updatedIndex;
1083         }
1084         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1085     }
1086 
1087     /**
1088      * @dev Transfers `tokenId` from `from` to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `tokenId` token must be owned by `from`.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _transfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) private {
1102         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1103 
1104         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1105 
1106         bool isApprovedOrOwner = (_msgSender() == from ||
1107             isApprovedForAll(from, _msgSender()) ||
1108             getApproved(tokenId) == _msgSender());
1109 
1110         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1111         if (to == address(0)) revert TransferToZeroAddress();
1112 
1113         _beforeTokenTransfers(from, to, tokenId, 1);
1114 
1115         // Clear approvals from the previous owner
1116         _approve(address(0), tokenId, from);
1117 
1118         // Underflow of the sender's balance is impossible because we check for
1119         // ownership above and the recipient's balance can't realistically overflow.
1120         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1121         unchecked {
1122             _addressData[from].balance -= 1;
1123             _addressData[to].balance += 1;
1124 
1125             TokenOwnership storage currSlot = _ownerships[tokenId];
1126             currSlot.addr = to;
1127             currSlot.startTimestamp = uint64(block.timestamp);
1128 
1129             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1130             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1131             uint256 nextTokenId = tokenId + 1;
1132             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1133             if (nextSlot.addr == address(0)) {
1134                 // This will suffice for checking _exists(nextTokenId),
1135                 // as a burned slot cannot contain the zero address.
1136                 if (nextTokenId != _currentIndex) {
1137                     nextSlot.addr = from;
1138                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1139                 }
1140             }
1141         }
1142 
1143         emit Transfer(from, to, tokenId);
1144         _afterTokenTransfers(from, to, tokenId, 1);
1145     }
1146 
1147     /**
1148      * @dev This is equivalent to _burn(tokenId, false)
1149      */
1150     function _burn(uint256 tokenId) internal virtual {
1151         _burn(tokenId, false);
1152     }
1153 
1154     /**
1155      * @dev Destroys `tokenId`.
1156      * The approval is cleared when the token is burned.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1165         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1166 
1167         address from = prevOwnership.addr;
1168 
1169         if (approvalCheck) {
1170             bool isApprovedOrOwner = (_msgSender() == from ||
1171                 isApprovedForAll(from, _msgSender()) ||
1172                 getApproved(tokenId) == _msgSender());
1173 
1174             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1175         }
1176 
1177         _beforeTokenTransfers(from, address(0), tokenId, 1);
1178 
1179         // Clear approvals from the previous owner
1180         _approve(address(0), tokenId, from);
1181 
1182         // Underflow of the sender's balance is impossible because we check for
1183         // ownership above and the recipient's balance can't realistically overflow.
1184         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1185         unchecked {
1186             AddressData storage addressData = _addressData[from];
1187             addressData.balance -= 1;
1188             addressData.numberBurned += 1;
1189 
1190             // Keep track of who burned the token, and the timestamp of burning.
1191             TokenOwnership storage currSlot = _ownerships[tokenId];
1192             currSlot.addr = from;
1193             currSlot.startTimestamp = uint64(block.timestamp);
1194             currSlot.burned = true;
1195 
1196             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1197             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1198             uint256 nextTokenId = tokenId + 1;
1199             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1200             if (nextSlot.addr == address(0)) {
1201                 // This will suffice for checking _exists(nextTokenId),
1202                 // as a burned slot cannot contain the zero address.
1203                 if (nextTokenId != _currentIndex) {
1204                     nextSlot.addr = from;
1205                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1206                 }
1207             }
1208         }
1209 
1210         emit Transfer(from, address(0), tokenId);
1211         _afterTokenTransfers(from, address(0), tokenId, 1);
1212 
1213         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1214         unchecked {
1215             _burnCounter++;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Approve `to` to operate on `tokenId`
1221      *
1222      * Emits a {Approval} event.
1223      */
1224     function _approve(
1225         address to,
1226         uint256 tokenId,
1227         address owner
1228     ) private {
1229         _tokenApprovals[tokenId] = to;
1230         emit Approval(owner, to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1235      *
1236      * @param from address representing the previous owner of the given token ID
1237      * @param to target address that will receive the tokens
1238      * @param tokenId uint256 ID of the token to be transferred
1239      * @param _data bytes optional data to send along with the call
1240      * @return bool whether the call correctly returned the expected magic value
1241      */
1242     function _checkContractOnERC721Received(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) private returns (bool) {
1248         try
1249             IERC721Receiver(to).onERC721Received(
1250                 _msgSender(),
1251                 from,
1252                 tokenId,
1253                 _data
1254             )
1255         returns (bytes4 retval) {
1256             return retval == IERC721Receiver(to).onERC721Received.selector;
1257         } catch (bytes memory reason) {
1258             if (reason.length == 0) {
1259                 revert TransferToNonERC721ReceiverImplementer();
1260             } else {
1261                 assembly {
1262                     revert(add(32, reason), mload(reason))
1263                 }
1264             }
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1270      * And also called before burning one token.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` will be minted for `to`.
1280      * - When `to` is zero, `tokenId` will be burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _beforeTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1292      * minting.
1293      * And also called after one token has been burned.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` has been minted for `to`.
1303      * - When `to` is zero, `tokenId` has been burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _afterTokenTransfers(
1307         address from,
1308         address to,
1309         uint256 startTokenId,
1310         uint256 quantity
1311     ) internal virtual {}
1312 }
1313 pragma solidity ^0.8.0;
1314 
1315 /**
1316  * @dev These functions deal with verification of Merkle Trees proofs.
1317  *
1318  * The proofs can be generated using the JavaScript library
1319  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1320  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1321  *
1322  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1323  */
1324 library MerkleProof {
1325     /**
1326      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1327      * defined by `root`. For this, a `proof` must be provided, containing
1328      * sibling hashes on the branch from the leaf to the root of the tree. Each
1329      * pair of leaves and each pair of pre-images are assumed to be sorted.
1330      */
1331     function verify(
1332         bytes32[] memory proof,
1333         bytes32 root,
1334         bytes32 leaf
1335     ) internal pure returns (bool) {
1336         return processProof(proof, leaf) == root;
1337     }
1338 
1339     /**
1340      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1341      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1342      * hash matches the root of the tree. When processing the proof, the pairs
1343      * of leafs & pre-images are assumed to be sorted.
1344      *
1345      * _Available since v4.4._
1346      */
1347     function processProof(bytes32[] memory proof, bytes32 leaf)
1348         internal
1349         pure
1350         returns (bytes32)
1351     {
1352         bytes32 computedHash = leaf;
1353         for (uint256 i = 0; i < proof.length; i++) {
1354             bytes32 proofElement = proof[i];
1355             if (computedHash <= proofElement) {
1356                 // Hash(current computed hash + current element of the proof)
1357                 computedHash = _efficientHash(computedHash, proofElement);
1358             } else {
1359                 // Hash(current element of the proof + current computed hash)
1360                 computedHash = _efficientHash(proofElement, computedHash);
1361             }
1362         }
1363         return computedHash;
1364     }
1365 
1366     function _efficientHash(bytes32 a, bytes32 b)
1367         private
1368         pure
1369         returns (bytes32 value)
1370     {
1371         assembly {
1372             mstore(0x00, a)
1373             mstore(0x20, b)
1374             value := keccak256(0x00, 0x40)
1375         }
1376     }
1377 }
1378 
1379 abstract contract Ownable is Context {
1380     address private _owner;
1381 
1382     event OwnershipTransferred(
1383         address indexed previousOwner,
1384         address indexed newOwner
1385     );
1386 
1387     /**
1388      * @dev Initializes the contract setting the deployer as the initial owner.
1389      */
1390     constructor() {
1391         _transferOwnership(_msgSender());
1392     }
1393 
1394     /**
1395      * @dev Returns the address of the current owner.
1396      */
1397     function owner() public view virtual returns (address) {
1398         return _owner;
1399     }
1400 
1401     /**
1402      * @dev Throws if called by any account other than the owner.
1403      */
1404     modifier onlyOwner() {
1405         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1406         _;
1407     }
1408 
1409     /**
1410      * @dev Leaves the contract without owner. It will not be possible to call
1411      * `onlyOwner` functions anymore. Can only be called by the current owner.
1412      *
1413      * NOTE: Renouncing ownership will leave the contract without an owner,
1414      * thereby removing any functionality that is only available to the owner.
1415      */
1416     function renounceOwnership() public virtual onlyOwner {
1417         _transferOwnership(address(0));
1418     }
1419 
1420     /**
1421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1422      * Can only be called by the current owner.
1423      */
1424     function transferOwnership(address newOwner) public virtual onlyOwner {
1425         require(
1426             newOwner != address(0),
1427             "Ownable: new owner is the zero address"
1428         );
1429         _transferOwnership(newOwner);
1430     }
1431 
1432     /**
1433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1434      * Internal function without access restriction.
1435      */
1436     function _transferOwnership(address newOwner) internal virtual {
1437         address oldOwner = _owner;
1438         _owner = newOwner;
1439         emit OwnershipTransferred(oldOwner, newOwner);
1440     }
1441 }
1442 pragma solidity ^0.8.7;
1443 
1444 contract CubeMonkeysBusinessCards is ERC721A, Ownable {
1445     using Strings for uint256;
1446 
1447     string private uriPrefix = "ipfs://QmXLUeRkMWF4ET4R37U9MrBwbNZY8zHiWstAEZrKJMSgCp/";
1448     string private uriSuffix = ".json";
1449     string public hiddenMetadataUri;
1450 
1451     uint256 public cost = 0.0 ether;
1452 
1453     uint16 public constant maxSupply = 10000;
1454 
1455     bool public WLpaused = false;
1456     bool public paused = true;
1457     bool public whitelistMintNotOver = true;
1458     
1459     mapping(address => uint8) public NFTPerWLAddress;
1460     mapping(address => uint8) public NFTPerAddress;
1461     uint8 public maxMintAmountPerWallet = 10;
1462 
1463     bytes32 public whitelistMerkleRoot;
1464     bool public revealed = false;
1465 
1466     constructor() ERC721A("Cube Monkeys Business Cards", "CMBC") {
1467         setHiddenMetadataUri(
1468             "ipfs://QmZcbNbT3sC84UK1ddF8mzhWhvdN9Ad7XDKQALjdLgCDNM/hidden.json"
1469         );
1470     }
1471 //MINT FUNCTION HERE
1472     function mint(uint8 _mintAmount) external payable {
1473         uint16 totalSupply = uint16(totalSupply());
1474         require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1475         uint8 Nft = NFTPerAddress[msg.sender];
1476         require(
1477             _mintAmount + Nft <= maxMintAmountPerWallet,
1478             "Exceeds max Nfts allowed per wallet."
1479         );
1480 
1481         require(!paused, "The contract is paused!");
1482         require(!whitelistMintNotOver, "Whitelist minting is NOT over! Get back to work ya Cube Monkey.");
1483 
1484         if (Nft == 0) {
1485             require(
1486                 msg.value >= cost * (_mintAmount - 1),
1487                 "Insufficient funds!"
1488             );
1489         } else {
1490             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1491         }
1492         _safeMint(msg.sender, _mintAmount);
1493         NFTPerAddress[msg.sender] = _mintAmount + Nft;
1494 
1495         delete totalSupply;
1496         delete _mintAmount;
1497     }
1498 
1499     function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1500         uint16 totalSupply = uint16(totalSupply());
1501         require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1502         _safeMint(_receiver, _mintAmount);
1503         delete _mintAmount;
1504         delete _receiver;
1505         delete totalSupply;
1506     }
1507 
1508     function tokenURI(uint256 _tokenId)
1509         public
1510         view
1511         virtual
1512         override
1513         returns (string memory)
1514     {
1515         require(
1516             _exists(_tokenId),
1517             "ERC721Metadata: URI query for nonexistent token"
1518         );
1519 
1520         if (revealed == false) {
1521             return hiddenMetadataUri;
1522         }
1523 
1524         string memory currentBaseURI = _baseURI();
1525         return
1526             bytes(currentBaseURI).length > 0
1527                 ? string(
1528                     abi.encodePacked(
1529                         currentBaseURI,
1530                         _tokenId.toString(),
1531                         uriSuffix
1532                     )
1533                 )
1534                 : "";
1535     }
1536 
1537     function setRevealed(bool _state) public onlyOwner {
1538         revealed = _state;
1539     }
1540 
1541     function setwhitelistMintNotOver() external onlyOwner {
1542         whitelistMintNotOver = !whitelistMintNotOver;
1543     }
1544 
1545     function setWLPaused() external onlyOwner {
1546         WLpaused = !WLpaused;
1547     }
1548 
1549     function setMaxMintAmountPerWallet(uint8 _limit) external onlyOwner {
1550         maxMintAmountPerWallet = _limit;
1551         delete _limit;
1552     }
1553 
1554     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot)
1555         external
1556         onlyOwner
1557     {
1558         whitelistMerkleRoot = _whitelistMerkleRoot;
1559     }
1560 
1561     function getLeafNode(address _leaf) internal pure returns (bytes32 temp) {
1562         return keccak256(abi.encodePacked(_leaf));
1563     }
1564 
1565     function _verify(bytes32 leaf, bytes32[] memory proof)
1566         internal
1567         view
1568         returns (bool)
1569     {
1570         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1571     }
1572 
1573     function whitelistMint(uint8 _mintAmount, bytes32[] calldata merkleProof)
1574         external
1575         payable
1576     {
1577         bytes32 leafnode = getLeafNode(msg.sender);
1578         uint8 _txPerAddress = NFTPerWLAddress[msg.sender];
1579         require(_verify(leafnode, merkleProof), "Invalid merkle proof");
1580         require(
1581             _txPerAddress + _mintAmount <= maxMintAmountPerWallet,
1582             "Exceeds max nft allowed per address"
1583         );
1584 
1585         require(!WLpaused, "Whitelist minting is over!");
1586 
1587         if (_txPerAddress >= 2) {
1588             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1589         } else {
1590             uint8 costAmount = _mintAmount + _txPerAddress;
1591             if (costAmount > 2) {
1592                 costAmount = costAmount - 2;
1593                 require(msg.value >= cost * costAmount, "Insufficient funds!");
1594             }
1595         }
1596 
1597         _safeMint(msg.sender, _mintAmount);
1598         NFTPerWLAddress[msg.sender] = _txPerAddress + _mintAmount;
1599 
1600         delete _mintAmount;
1601         delete _txPerAddress;
1602     }
1603 
1604     function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1605         uriPrefix = _uriPrefix;
1606     }
1607 
1608     function setPaused() external onlyOwner {
1609         paused = !paused;
1610         WLpaused = true;
1611     }
1612 
1613     function setCost(uint256 _cost) external onlyOwner {
1614         cost = _cost;
1615     }
1616 
1617     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1618         public
1619         onlyOwner
1620     {
1621         hiddenMetadataUri = _hiddenMetadataUri;
1622     }
1623 
1624     function withdraw() external onlyOwner {
1625         uint256 _balance = address(this).balance;
1626         payable(msg.sender).transfer(_balance);
1627     }
1628 
1629     function _baseURI() internal view override returns (string memory) {
1630         return uriPrefix;
1631     }
1632 }