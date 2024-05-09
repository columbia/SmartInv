1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
28 
29 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(
41         address indexed from,
42         address indexed to,
43         uint256 indexed tokenId
44     );
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(
50         address indexed owner,
51         address indexed approved,
52         uint256 indexed tokenId
53     );
54 
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(
59         address indexed owner,
60         address indexed operator,
61         bool approved
62     );
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId)
141         external
142         view
143         returns (address operator);
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
159      *
160      * See {setApprovalForAll}
161      */
162     function isApprovedForAll(address owner, address operator)
163         external
164         view
165         returns (bool);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 }
187 
188 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
189 
190 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @title ERC721 token receiver interface
196  * @dev Interface for any contract that wants to support safeTransfers
197  * from ERC721 asset contracts.
198  */
199 interface IERC721Receiver {
200     /**
201      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
202      * by `operator` from `from`, this function is called.
203      *
204      * It must return its Solidity selector to confirm the token transfer.
205      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
206      *
207      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
208      */
209     function onERC721Received(
210         address operator,
211         address from,
212         uint256 tokenId,
213         bytes calldata data
214     ) external returns (bytes4);
215 }
216 
217 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
218 
219 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 interface IERC721Metadata is IERC721 {
228     /**
229      * @dev Returns the token collection name.
230      */
231     function name() external view returns (string memory);
232 
233     /**
234      * @dev Returns the token collection symbol.
235      */
236     function symbol() external view returns (string memory);
237 
238     /**
239      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
240      */
241     function tokenURI(uint256 tokenId) external view returns (string memory);
242 }
243 
244 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
245 
246 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
252  * @dev See https://eips.ethereum.org/EIPS/eip-721
253  */
254 interface IERC721Enumerable is IERC721 {
255     /**
256      * @dev Returns the total amount of tokens stored by the contract.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
262      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
263      */
264     function tokenOfOwnerByIndex(address owner, uint256 index)
265         external
266         view
267         returns (uint256);
268 
269     /**
270      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
271      * Use along with {totalSupply} to enumerate all tokens.
272      */
273     function tokenByIndex(uint256 index) external view returns (uint256);
274 }
275 
276 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
277 
278 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
279 
280 pragma solidity ^0.8.1;
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      *
303      * [IMPORTANT]
304      * ====
305      * You shouldn't rely on `isContract` to protect against flash loan attacks!
306      *
307      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
308      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
309      * constructor.
310      * ====
311      */
312     function isContract(address account) internal view returns (bool) {
313         // This method relies on extcodesize/address.code.length, which returns 0
314         // for contracts in construction, since the code is only stored at the end
315         // of the constructor execution.
316 
317         return account.code.length > 0;
318     }
319 
320     /**
321      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
322      * `recipient`, forwarding all available gas and reverting on errors.
323      *
324      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
325      * of certain opcodes, possibly making contracts go over the 2300 gas limit
326      * imposed by `transfer`, making them unable to receive funds via
327      * `transfer`. {sendValue} removes this limitation.
328      *
329      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
330      *
331      * IMPORTANT: because control is transferred to `recipient`, care must be
332      * taken to not create reentrancy vulnerabilities. Consider using
333      * {ReentrancyGuard} or the
334      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
335      */
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(
338             address(this).balance >= amount,
339             "Address: insufficient balance"
340         );
341 
342         (bool success, ) = recipient.call{value: amount}("");
343         require(
344             success,
345             "Address: unable to send value, recipient may have reverted"
346         );
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain `call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data)
368         internal
369         returns (bytes memory)
370     {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return
405             functionCallWithValue(
406                 target,
407                 data,
408                 value,
409                 "Address: low-level call with value failed"
410             );
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(
426             address(this).balance >= value,
427             "Address: insufficient balance for call"
428         );
429         require(isContract(target), "Address: call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.call{value: value}(
432             data
433         );
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data)
444         internal
445         view
446         returns (bytes memory)
447     {
448         return
449             functionStaticCall(
450                 target,
451                 data,
452                 "Address: low-level static call failed"
453             );
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data)
480         internal
481         returns (bytes memory)
482     {
483         return
484             functionDelegateCall(
485                 target,
486                 data,
487                 "Address: low-level delegate call failed"
488             );
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(
498         address target,
499         bytes memory data,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         require(isContract(target), "Address: delegate call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.delegatecall(data);
505         return verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
510      * revert reason using the provided one.
511      *
512      * _Available since v4.3._
513      */
514     function verifyCallResult(
515         bool success,
516         bytes memory returndata,
517         string memory errorMessage
518     ) internal pure returns (bytes memory) {
519         if (success) {
520             return returndata;
521         } else {
522             // Look for revert reason and bubble it up if present
523             if (returndata.length > 0) {
524                 // The easiest way to bubble the revert reason is using memory via assembly
525 
526                 assembly {
527                     let returndata_size := mload(returndata)
528                     revert(add(32, returndata), returndata_size)
529                 }
530             } else {
531                 revert(errorMessage);
532             }
533         }
534     }
535 }
536 
537 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
538 
539 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev Provides information about the current execution context, including the
545  * sender of the transaction and its data. While these are generally available
546  * via msg.sender and msg.data, they should not be accessed in such a direct
547  * manner, since when dealing with meta-transactions the account sending and
548  * paying for execution may not be the actual sender (as far as an application
549  * is concerned).
550  *
551  * This contract is only required for intermediate, library-like contracts.
552  */
553 abstract contract Context {
554     function _msgSender() internal view virtual returns (address) {
555         return msg.sender;
556     }
557 
558     function _msgData() internal view virtual returns (bytes calldata) {
559         return msg.data;
560     }
561 }
562 
563 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
564 
565 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev String operations.
571  */
572 library Strings {
573     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
574 
575     /**
576      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
577      */
578     function toString(uint256 value) internal pure returns (string memory) {
579         // Inspired by OraclizeAPI's implementation - MIT licence
580         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
581 
582         if (value == 0) {
583             return "0";
584         }
585         uint256 temp = value;
586         uint256 digits;
587         while (temp != 0) {
588             digits++;
589             temp /= 10;
590         }
591         bytes memory buffer = new bytes(digits);
592         while (value != 0) {
593             digits -= 1;
594             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
595             value /= 10;
596         }
597         return string(buffer);
598     }
599 
600     /**
601      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
602      */
603     function toHexString(uint256 value) internal pure returns (string memory) {
604         if (value == 0) {
605             return "0x00";
606         }
607         uint256 temp = value;
608         uint256 length = 0;
609         while (temp != 0) {
610             length++;
611             temp >>= 8;
612         }
613         return toHexString(value, length);
614     }
615 
616     /**
617      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
618      */
619     function toHexString(uint256 value, uint256 length)
620         internal
621         pure
622         returns (string memory)
623     {
624         bytes memory buffer = new bytes(2 * length + 2);
625         buffer[0] = "0";
626         buffer[1] = "x";
627         for (uint256 i = 2 * length + 1; i > 1; --i) {
628             buffer[i] = _HEX_SYMBOLS[value & 0xf];
629             value >>= 4;
630         }
631         require(value == 0, "Strings: hex length insufficient");
632         return string(buffer);
633     }
634 }
635 
636 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
637 
638 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @dev Implementation of the {IERC165} interface.
644  *
645  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
646  * for the additional interface id that will be supported. For example:
647  *
648  * ```solidity
649  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
650  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
651  * }
652  * ```
653  *
654  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
655  */
656 abstract contract ERC165 is IERC165 {
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId)
661         public
662         view
663         virtual
664         override
665         returns (bool)
666     {
667         return interfaceId == type(IERC165).interfaceId;
668     }
669 }
670 
671 // File erc721a/contracts/ERC721A.sol@v3.0.0
672 
673 // Creator: Chiru Labs
674 
675 pragma solidity ^0.8.4;
676 
677 error ApprovalCallerNotOwnerNorApproved();
678 error ApprovalQueryForNonexistentToken();
679 error ApproveToCaller();
680 error ApprovalToCurrentOwner();
681 error BalanceQueryForZeroAddress();
682 error MintedQueryForZeroAddress();
683 error BurnedQueryForZeroAddress();
684 error AuxQueryForZeroAddress();
685 error MintToZeroAddress();
686 error MintZeroQuantity();
687 error OwnerIndexOutOfBounds();
688 error OwnerQueryForNonexistentToken();
689 error TokenIndexOutOfBounds();
690 error TransferCallerNotOwnerNorApproved();
691 error TransferFromIncorrectOwner();
692 error TransferToNonERC721ReceiverImplementer();
693 error TransferToZeroAddress();
694 error URIQueryForNonexistentToken();
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata extension. Built to optimize for lower gas during batch mints.
699  *
700  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
701  *
702  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
703  *
704  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
705  */
706 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
707     using Address for address;
708     using Strings for uint256;
709 
710     // Compiler will pack this into a single 256bit word.
711     struct TokenOwnership {
712         // The address of the owner.
713         address addr;
714         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
715         uint64 startTimestamp;
716         // Whether the token has been burned.
717         bool burned;
718     }
719 
720     // Compiler will pack this into a single 256bit word.
721     struct AddressData {
722         // Realistically, 2**64-1 is more than enough.
723         uint64 balance;
724         // Keeps track of mint count with minimal overhead for tokenomics.
725         uint64 numberMinted;
726         // Keeps track of burn count with minimal overhead for tokenomics.
727         uint64 numberBurned;
728         // For miscellaneous variable(s) pertaining to the address
729         // (e.g. number of whitelist mint slots used).
730         // If there are multiple variables, please pack them into a uint64.
731         uint64 aux;
732     }
733 
734     // The tokenId of the next token to be minted.
735     uint256 internal _currentIndex;
736 
737     // The number of tokens burned.
738     uint256 internal _burnCounter;
739 
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     // Mapping from token ID to ownership details
747     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
748     mapping(uint256 => TokenOwnership) internal _ownerships;
749 
750     // Mapping owner address to address data
751     mapping(address => AddressData) private _addressData;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762         _currentIndex = _startTokenId();
763     }
764 
765     /**
766      * To change the starting tokenId, please override this function.
767      */
768     function _startTokenId() internal view virtual returns (uint256) {
769         return 0;
770     }
771 
772     /**
773      * @dev See {IERC721Enumerable-totalSupply}.
774      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
775      */
776     function totalSupply() public view returns (uint256) {
777         // Counter underflow is impossible as _burnCounter cannot be incremented
778         // more than _currentIndex - _startTokenId() times
779         unchecked {
780             return _currentIndex - _burnCounter - _startTokenId();
781         }
782     }
783 
784     /**
785      * Returns the total amount of tokens minted in the contract.
786      */
787     function _totalMinted() internal view returns (uint256) {
788         // Counter underflow is impossible as _currentIndex does not decrement,
789         // and it is initialized to _startTokenId()
790         unchecked {
791             return _currentIndex - _startTokenId();
792         }
793     }
794 
795     /**
796      * @dev See {IERC165-supportsInterface}.
797      */
798     function supportsInterface(bytes4 interfaceId)
799         public
800         view
801         virtual
802         override(ERC165, IERC165)
803         returns (bool)
804     {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view override returns (uint256) {
815         if (owner == address(0)) revert BalanceQueryForZeroAddress();
816         return uint256(_addressData[owner].balance);
817     }
818 
819     /**
820      * Returns the number of tokens minted by `owner`.
821      */
822     function _numberMinted(address owner) internal view returns (uint256) {
823         if (owner == address(0)) revert MintedQueryForZeroAddress();
824         return uint256(_addressData[owner].numberMinted);
825     }
826 
827     /**
828      * Returns the number of tokens burned by or on behalf of `owner`.
829      */
830     function _numberBurned(address owner) internal view returns (uint256) {
831         if (owner == address(0)) revert BurnedQueryForZeroAddress();
832         return uint256(_addressData[owner].numberBurned);
833     }
834 
835     /**
836      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
837      */
838     function _getAux(address owner) internal view returns (uint64) {
839         if (owner == address(0)) revert AuxQueryForZeroAddress();
840         return _addressData[owner].aux;
841     }
842 
843     /**
844      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
845      * If there are multiple variables, please pack them into a uint64.
846      */
847     function _setAux(address owner, uint64 aux) internal {
848         if (owner == address(0)) revert AuxQueryForZeroAddress();
849         _addressData[owner].aux = aux;
850     }
851 
852     /**
853      * Gas spent here starts off proportional to the maximum mint batch size.
854      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
855      */
856     function ownershipOf(uint256 tokenId)
857         internal
858         view
859         returns (TokenOwnership memory)
860     {
861         uint256 curr = tokenId;
862 
863         unchecked {
864             if (_startTokenId() <= curr && curr < _currentIndex) {
865                 TokenOwnership memory ownership = _ownerships[curr];
866                 if (!ownership.burned) {
867                     if (ownership.addr != address(0)) {
868                         return ownership;
869                     }
870                     // Invariant:
871                     // There will always be an ownership that has an address and is not burned
872                     // before an ownership that does not have an address and is not burned.
873                     // Hence, curr will not underflow.
874                     while (true) {
875                         curr--;
876                         ownership = _ownerships[curr];
877                         if (ownership.addr != address(0)) {
878                             return ownership;
879                         }
880                     }
881                 }
882             }
883         }
884         revert OwnerQueryForNonexistentToken();
885     }
886 
887     /**
888      * @dev See {IERC721-ownerOf}.
889      */
890     function ownerOf(uint256 tokenId) public view override returns (address) {
891         return ownershipOf(tokenId).addr;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-name}.
896      */
897     function name() public view virtual override returns (string memory) {
898         return _name;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-symbol}.
903      */
904     function symbol() public view virtual override returns (string memory) {
905         return _symbol;
906     }
907 
908     /**
909      * @dev See {IERC721Metadata-tokenURI}.
910      */
911     function tokenURI(uint256 tokenId)
912         public
913         view
914         virtual
915         override
916         returns (string memory)
917     {
918         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
919 
920         string memory baseURI = _baseURI();
921         return
922             bytes(baseURI).length != 0
923                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
924                 : "";
925     }
926 
927     /**
928      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
929      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
930      * by default, can be overriden in child contracts.
931      */
932     function _baseURI() internal view virtual returns (string memory) {
933         return "";
934     }
935 
936     /**
937      * @dev See {IERC721-approve}.
938      */
939     function approve(address to, uint256 tokenId) public override {
940         address owner = ERC721A.ownerOf(tokenId);
941         if (to == owner) revert ApprovalToCurrentOwner();
942 
943         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
944             revert ApprovalCallerNotOwnerNorApproved();
945         }
946 
947         _approve(to, tokenId, owner);
948     }
949 
950     /**
951      * @dev See {IERC721-getApproved}.
952      */
953     function getApproved(uint256 tokenId)
954         public
955         view
956         override
957         returns (address)
958     {
959         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
960 
961         return _tokenApprovals[tokenId];
962     }
963 
964     /**
965      * @dev See {IERC721-setApprovalForAll}.
966      */
967     function setApprovalForAll(address operator, bool approved)
968         public
969         override
970     {
971         if (operator == _msgSender()) revert ApproveToCaller();
972 
973         _operatorApprovals[_msgSender()][operator] = approved;
974         emit ApprovalForAll(_msgSender(), operator, approved);
975     }
976 
977     /**
978      * @dev See {IERC721-isApprovedForAll}.
979      */
980     function isApprovedForAll(address owner, address operator)
981         public
982         view
983         virtual
984         override
985         returns (bool)
986     {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev See {IERC721-transferFrom}.
992      */
993     function transferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public virtual override {
998         _transfer(from, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public virtual override {
1009         safeTransferFrom(from, to, tokenId, "");
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022         if (
1023             to.isContract() &&
1024             !_checkContractOnERC721Received(from, to, tokenId, _data)
1025         ) {
1026             revert TransferToNonERC721ReceiverImplementer();
1027         }
1028     }
1029 
1030     /**
1031      * @dev Returns whether `tokenId` exists.
1032      *
1033      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1034      *
1035      * Tokens start existing when they are minted (`_mint`),
1036      */
1037     function _exists(uint256 tokenId) internal view returns (bool) {
1038         return
1039             _startTokenId() <= tokenId &&
1040             tokenId < _currentIndex &&
1041             !_ownerships[tokenId].burned;
1042     }
1043 
1044     function _safeMint(address to, uint256 quantity) internal {
1045         _safeMint(to, quantity, "");
1046     }
1047 
1048     /**
1049      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1054      * - `quantity` must be greater than 0.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 quantity,
1061         bytes memory _data
1062     ) internal {
1063         _mint(to, quantity, _data, true);
1064     }
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _mint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data,
1080         bool safe
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint64(quantity);
1093             _addressData[to].numberMinted += uint64(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099             uint256 end = updatedIndex + quantity;
1100 
1101             if (safe && to.isContract()) {
1102                 do {
1103                     emit Transfer(address(0), to, updatedIndex);
1104                     if (
1105                         !_checkContractOnERC721Received(
1106                             address(0),
1107                             to,
1108                             updatedIndex++,
1109                             _data
1110                         )
1111                     ) {
1112                         revert TransferToNonERC721ReceiverImplementer();
1113                     }
1114                 } while (updatedIndex != end);
1115                 // Reentrancy protection
1116                 if (_currentIndex != startTokenId) revert();
1117             } else {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex++);
1120                 } while (updatedIndex != end);
1121             }
1122             _currentIndex = updatedIndex;
1123         }
1124         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1125     }
1126 
1127     /**
1128      * @dev Transfers `tokenId` from `from` to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - `tokenId` token must be owned by `from`.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _transfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) private {
1142         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1143 
1144         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1145             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1146             getApproved(tokenId) == _msgSender());
1147 
1148         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1149         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1150         if (to == address(0)) revert TransferToZeroAddress();
1151 
1152         _beforeTokenTransfers(from, to, tokenId, 1);
1153 
1154         // Clear approvals from the previous owner
1155         _approve(address(0), tokenId, prevOwnership.addr);
1156 
1157         // Underflow of the sender's balance is impossible because we check for
1158         // ownership above and the recipient's balance can't realistically overflow.
1159         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1160         unchecked {
1161             _addressData[from].balance -= 1;
1162             _addressData[to].balance += 1;
1163 
1164             _ownerships[tokenId].addr = to;
1165             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1166 
1167             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1168             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1169             uint256 nextTokenId = tokenId + 1;
1170             if (_ownerships[nextTokenId].addr == address(0)) {
1171                 // This will suffice for checking _exists(nextTokenId),
1172                 // as a burned slot cannot contain the zero address.
1173                 if (nextTokenId < _currentIndex) {
1174                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1175                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1176                         .startTimestamp;
1177                 }
1178             }
1179         }
1180 
1181         emit Transfer(from, to, tokenId);
1182         _afterTokenTransfers(from, to, tokenId, 1);
1183     }
1184 
1185     /**
1186      * @dev Destroys `tokenId`.
1187      * The approval is cleared when the token is burned.
1188      *
1189      * Requirements:
1190      *
1191      * - `tokenId` must exist.
1192      *
1193      * Emits a {Transfer} event.
1194      */
1195     function _burn(uint256 tokenId) internal virtual {
1196         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1197 
1198         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId, prevOwnership.addr);
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             _addressData[prevOwnership.addr].balance -= 1;
1208             _addressData[prevOwnership.addr].numberBurned += 1;
1209 
1210             // Keep track of who burned the token, and the timestamp of burning.
1211             _ownerships[tokenId].addr = prevOwnership.addr;
1212             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1213             _ownerships[tokenId].burned = true;
1214 
1215             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1216             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1217             uint256 nextTokenId = tokenId + 1;
1218             if (_ownerships[nextTokenId].addr == address(0)) {
1219                 // This will suffice for checking _exists(nextTokenId),
1220                 // as a burned slot cannot contain the zero address.
1221                 if (nextTokenId < _currentIndex) {
1222                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1223                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1224                         .startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(prevOwnership.addr, address(0), tokenId);
1230         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1231 
1232         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1233         unchecked {
1234             _burnCounter++;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Approve `to` to operate on `tokenId`
1240      *
1241      * Emits a {Approval} event.
1242      */
1243     function _approve(
1244         address to,
1245         uint256 tokenId,
1246         address owner
1247     ) private {
1248         _tokenApprovals[tokenId] = to;
1249         emit Approval(owner, to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param _data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkContractOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) private returns (bool) {
1267         try
1268             IERC721Receiver(to).onERC721Received(
1269                 _msgSender(),
1270                 from,
1271                 tokenId,
1272                 _data
1273             )
1274         returns (bytes4 retval) {
1275             return retval == IERC721Receiver(to).onERC721Received.selector;
1276         } catch (bytes memory reason) {
1277             if (reason.length == 0) {
1278                 revert TransferToNonERC721ReceiverImplementer();
1279             } else {
1280                 assembly {
1281                     revert(add(32, reason), mload(reason))
1282                 }
1283             }
1284         }
1285     }
1286 
1287     /**
1288      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1289      * And also called before burning one token.
1290      *
1291      * startTokenId - the first token id to be transferred
1292      * quantity - the amount to be transferred
1293      *
1294      * Calling conditions:
1295      *
1296      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1297      * transferred to `to`.
1298      * - When `from` is zero, `tokenId` will be minted for `to`.
1299      * - When `to` is zero, `tokenId` will be burned by `from`.
1300      * - `from` and `to` are never both zero.
1301      */
1302     function _beforeTokenTransfers(
1303         address from,
1304         address to,
1305         uint256 startTokenId,
1306         uint256 quantity
1307     ) internal virtual {}
1308 
1309     /**
1310      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1311      * minting.
1312      * And also called after one token has been burned.
1313      *
1314      * startTokenId - the first token id to be transferred
1315      * quantity - the amount to be transferred
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` has been minted for `to`.
1322      * - When `to` is zero, `tokenId` has been burned by `from`.
1323      * - `from` and `to` are never both zero.
1324      */
1325     function _afterTokenTransfers(
1326         address from,
1327         address to,
1328         uint256 startTokenId,
1329         uint256 quantity
1330     ) internal virtual {}
1331 }
1332 
1333 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1334 
1335 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1336 
1337 pragma solidity ^0.8.0;
1338 
1339 /**
1340  * @dev Contract module which provides a basic access control mechanism, where
1341  * there is an account (an owner) that can be granted exclusive access to
1342  * specific functions.
1343  *
1344  * By default, the owner account will be the one that deploys the contract. This
1345  * can later be changed with {transferOwnership}.
1346  *
1347  * This module is used through inheritance. It will make available the modifier
1348  * `onlyOwner`, which can be applied to your functions to restrict their use to
1349  * the owner.
1350  */
1351 abstract contract Ownable is Context {
1352     address private _owner;
1353 
1354     event OwnershipTransferred(
1355         address indexed previousOwner,
1356         address indexed newOwner
1357     );
1358 
1359     /**
1360      * @dev Initializes the contract setting the deployer as the initial owner.
1361      */
1362     constructor() {
1363         _transferOwnership(_msgSender());
1364     }
1365 
1366     /**
1367      * @dev Returns the address of the current owner.
1368      */
1369     function owner() public view virtual returns (address) {
1370         return _owner;
1371     }
1372 
1373     /**
1374      * @dev Throws if called by any account other than the owner.
1375      */
1376     modifier onlyOwner() {
1377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1378         _;
1379     }
1380 
1381     /**
1382      * @dev Leaves the contract without owner. It will not be possible to call
1383      * `onlyOwner` functions anymore. Can only be called by the current owner.
1384      *
1385      * NOTE: Renouncing ownership will leave the contract without an owner,
1386      * thereby removing any functionality that is only available to the owner.
1387      */
1388     function renounceOwnership() public virtual onlyOwner {
1389         _transferOwnership(address(0));
1390     }
1391 
1392     /**
1393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1394      * Can only be called by the current owner.
1395      */
1396     function transferOwnership(address newOwner) public virtual onlyOwner {
1397         require(
1398             newOwner != address(0),
1399             "Ownable: new owner is the zero address"
1400         );
1401         _transferOwnership(newOwner);
1402     }
1403 
1404     /**
1405      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1406      * Internal function without access restriction.
1407      */
1408     function _transferOwnership(address newOwner) internal virtual {
1409         address oldOwner = _owner;
1410         _owner = newOwner;
1411         emit OwnershipTransferred(oldOwner, newOwner);
1412     }
1413 }
1414 
1415 // File contracts/LifeMapBook.sol
1416 
1417 pragma solidity ^0.8.0;
1418 
1419 contract LifeMapBook is ERC721A, Ownable {
1420     string public baseURI;
1421 
1422     constructor(string memory uri) ERC721A("LifeMapBook", "LMB") {
1423         baseURI = uri;
1424     }
1425 
1426     function batchMint(address[] calldata addresses) external payable {
1427         require(
1428             addresses.length < 50,
1429             "LMB: Number Of Addresses Size Must Be Less Than 50"
1430         );
1431         for (uint256 index = 0; index < addresses.length; index++) {
1432             _safeMint(addresses[index], 1);
1433         }
1434     }
1435 
1436     /**
1437      * @dev See {IERC721Metadata-tokenURI}.
1438      */
1439     function tokenURI(uint256 tokenId)
1440         public
1441         view
1442         virtual
1443         override
1444         returns (string memory)
1445     {
1446         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
1447     }
1448 
1449     /**
1450      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1451      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1452      * by default, can be overriden in child contracts.
1453      */
1454 
1455     function _baseURI() internal view virtual override returns (string memory) {
1456         return baseURI;
1457     }
1458 
1459     /**
1460      * @dev Sets a new URI for all token types, by relying on the token type ID
1461      * substitution mechanism
1462      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1463      *
1464      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1465      * URI or any of the amounts in the JSON file at said URI will be replaced by
1466      * clients with the token type ID.
1467      *
1468      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1469      * interpreted by clients as
1470      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1471      * for token type ID 0x4cce0.
1472      *
1473      * See {uri}.
1474      *
1475      * Because these URIs cannot be meaningfully represented by the {URI} event,
1476      * this function emits no events.
1477      */
1478     function setURI(string memory newuri) public onlyOwner {
1479         baseURI = newuri;
1480     }
1481 
1482     /**
1483      * @dev Destroys `tokenId`.
1484      * The approval is cleared when the token is burned.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must exist.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function burn(uint256 tokenId) public {
1493         require(
1494             ownerOf(tokenId) == _msgSender(),
1495             "LMB: You Are Not The Owner Of The Token"
1496         );
1497         super._burn(tokenId);
1498     }
1499 }