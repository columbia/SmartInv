1 // File: contracts\CollectionProxy\IERC1538.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /// @title ERC1538 Transparent Contract Standard
6 /// @dev Required interface
7 ///  Note: the ERC-165 identifier for this interface is 0x61455567
8 interface IERC1538 {
9 
10     /// @dev This emits when one or a set of functions are updated in a transparent contract.
11     ///  The message string should give a short description of the change and why
12     ///  the change was made.
13     event CommitMessage(string message);
14 
15     /// @dev This emits for each function that is updated in a transparent contract.
16     ///  functionId is the bytes4 of the keccak256 of the function signature.
17     ///  oldDelegate is the delegate contract address of the old delegate contract if
18     ///  the function is being replaced or removed.
19     ///  oldDelegate is the zero value address(0) if a function is being added for the
20     ///  first time.
21     ///  newDelegate is the delegate contract address of the new delegate contract if
22     ///  the function is being added for the first time or if the function is being
23     ///  replaced.
24     ///  newDelegate is the zero value address(0) if the function is being removed.
25     event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);
26 
27     /// @notice Updates functions in a transparent contract.
28     /// @dev If the value of _delegate is zero then the functions specified
29     ///  in _functionSignatures are removed.
30     ///  If the value of _delegate is a delegate contract address then the functions
31     ///  specified in _functionSignatures will be delegated to that address.
32     /// @param _delegate The address of a delegate contract to delegate to or zero
33     ///        to remove functions.
34     /// @param _functionSignatures A list of function signatures listed one after the other
35     /// @param _commitMessage A short description of the change and why it is made
36     ///        This message is passed to the CommitMessage event.
37     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) external;
38 }
39 
40 // File: contracts\CollectionProxy\ProxyBaseStorage.sol
41 
42 pragma solidity ^0.8.0;
43 
44 ///////////////////////////////////////////////////////////////////////////////////////////////////
45 /**
46  * @title ProxyBaseStorage
47  * @dev Defining base storage for the proxy contract.
48  */
49 ///////////////////////////////////////////////////////////////////////////////////////////////////
50 
51 contract ProxyBaseStorage {
52 
53     //////////////////////////////////////////// VARS /////////////////////////////////////////////
54 
55     // maps functions to the delegate contracts that execute the functions.
56     // funcId => delegate contract
57     mapping(bytes4 => address) public delegates;
58 
59     // array of function signatures supported by the contract.
60     bytes[] public funcSignatures;
61 
62     // maps each function signature to its position in the funcSignatures array.
63     // signature => index+1
64     mapping(bytes => uint256) internal funcSignatureToIndex;
65 
66     // proxy address of itself, can be used for cross-delegate calls but also safety checking.
67     address proxy;
68 
69     ///////////////////////////////////////////////////////////////////////////////////////////////
70 
71 }
72 
73 // File: @openzeppelin\contracts\utils\introspection\IERC165.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Interface of the ERC165 standard, as defined in the
82  * https://eips.ethereum.org/EIPS/eip-165[EIP].
83  *
84  * Implementers can declare support of contract interfaces, which can then be
85  * queried by others ({ERC165Checker}).
86  *
87  * For an implementation, see {ERC165}.
88  */
89 interface IERC165 {
90     /**
91      * @dev Returns true if this contract implements the interface defined by
92      * `interfaceId`. See the corresponding
93      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
94      * to learn more about how these ids are created.
95      *
96      * This function call must use less than 30 000 gas.
97      */
98     function supportsInterface(bytes4 interfaceId) external view returns (bool);
99 }
100 
101 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Required interface of an ERC721 compliant contract.
110  */
111 interface IERC721 is IERC165 {
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
143      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId
159     ) external;
160 
161     /**
162      * @dev Transfers `tokenId` token from `from` to `to`.
163      *
164      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
183      * The approval is cleared when the token is transferred.
184      *
185      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
186      *
187      * Requirements:
188      *
189      * - The caller must own the token or be an approved operator.
190      * - `tokenId` must exist.
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address to, uint256 tokenId) external;
195 
196     /**
197      * @dev Returns the account approved for `tokenId` token.
198      *
199      * Requirements:
200      *
201      * - `tokenId` must exist.
202      */
203     function getApproved(uint256 tokenId) external view returns (address operator);
204 
205     /**
206      * @dev Approve or remove `operator` as an operator for the caller.
207      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
208      *
209      * Requirements:
210      *
211      * - The `operator` cannot be the caller.
212      *
213      * Emits an {ApprovalForAll} event.
214      */
215     function setApprovalForAll(address operator, bool _approved) external;
216 
217     /**
218      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
219      *
220      * See {setApprovalForAll}
221      */
222     function isApprovedForAll(address owner, address operator) external view returns (bool);
223 
224     /**
225      * @dev Safely transfers `tokenId` token from `from` to `to`.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must exist and be owned by `from`.
232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
234      *
235      * Emits a {Transfer} event.
236      */
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId,
241         bytes calldata data
242     ) external;
243 }
244 
245 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
266      */
267     function onERC721Received(
268         address operator,
269         address from,
270         uint256 tokenId,
271         bytes calldata data
272     ) external returns (bytes4);
273 }
274 
275 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
284  * @dev See https://eips.ethereum.org/EIPS/eip-721
285  */
286 interface IERC721Metadata is IERC721 {
287     /**
288      * @dev Returns the token collection name.
289      */
290     function name() external view returns (string memory);
291 
292     /**
293      * @dev Returns the token collection symbol.
294      */
295     function symbol() external view returns (string memory);
296 
297     /**
298      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
299      */
300     function tokenURI(uint256 tokenId) external view returns (string memory);
301 }
302 
303 // File: @openzeppelin\contracts\utils\Address.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      */
331     function isContract(address account) internal view returns (bool) {
332         // This method relies on extcodesize, which returns 0 for contracts in
333         // construction, since the code is only stored at the end of the
334         // constructor execution.
335 
336         uint256 size;
337         assembly {
338             size := extcodesize(account)
339         }
340         return size > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         (bool success, ) = recipient.call{value: amount}("");
363         require(success, "Address: unable to send value, recipient may have reverted");
364     }
365 
366     /**
367      * @dev Performs a Solidity function call using a low level `call`. A
368      * plain `call` is an unsafe replacement for a function call: use this
369      * function instead.
370      *
371      * If `target` reverts with a revert reason, it is bubbled up by this
372      * function (like regular Solidity function calls).
373      *
374      * Returns the raw returned data. To convert to the expected return value,
375      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
376      *
377      * Requirements:
378      *
379      * - `target` must be a contract.
380      * - calling `target` with `data` must not revert.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionCall(target, data, "Address: low-level call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
390      * `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but also transferring `value` wei to `target`.
405      *
406      * Requirements:
407      *
408      * - the calling contract must have an ETH balance of at least `value`.
409      * - the called Solidity function must be `payable`.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value
417     ) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
423      * with `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 value,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.call{value: value}(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
447         return functionStaticCall(target, data, "Address: low-level static call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
474         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.delegatecall(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
496      * revert reason using the provided one.
497      *
498      * _Available since v4.3._
499      */
500     function verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) internal pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511 
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 // File: @openzeppelin\contracts\utils\Context.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Provides information about the current execution context, including the
532  * sender of the transaction and its data. While these are generally available
533  * via msg.sender and msg.data, they should not be accessed in such a direct
534  * manner, since when dealing with meta-transactions the account sending and
535  * paying for execution may not be the actual sender (as far as an application
536  * is concerned).
537  *
538  * This contract is only required for intermediate, library-like contracts.
539  */
540 abstract contract Context {
541     function _msgSender() internal view virtual returns (address) {
542         return msg.sender;
543     }
544 
545     function _msgData() internal view virtual returns (bytes calldata) {
546         return msg.data;
547     }
548 }
549 
550 // File: @openzeppelin\contracts\utils\Strings.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev String operations.
559  */
560 library Strings {
561     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
562 
563     /**
564      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
565      */
566     function toString(uint256 value) internal pure returns (string memory) {
567         // Inspired by OraclizeAPI's implementation - MIT licence
568         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
569 
570         if (value == 0) {
571             return "0";
572         }
573         uint256 temp = value;
574         uint256 digits;
575         while (temp != 0) {
576             digits++;
577             temp /= 10;
578         }
579         bytes memory buffer = new bytes(digits);
580         while (value != 0) {
581             digits -= 1;
582             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
583             value /= 10;
584         }
585         return string(buffer);
586     }
587 
588     /**
589      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
590      */
591     function toHexString(uint256 value) internal pure returns (string memory) {
592         if (value == 0) {
593             return "0x00";
594         }
595         uint256 temp = value;
596         uint256 length = 0;
597         while (temp != 0) {
598             length++;
599             temp >>= 8;
600         }
601         return toHexString(value, length);
602     }
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
606      */
607     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
608         bytes memory buffer = new bytes(2 * length + 2);
609         buffer[0] = "0";
610         buffer[1] = "x";
611         for (uint256 i = 2 * length + 1; i > 1; --i) {
612             buffer[i] = _HEX_SYMBOLS[value & 0xf];
613             value >>= 4;
614         }
615         require(value == 0, "Strings: hex length insufficient");
616         return string(buffer);
617     }
618 }
619 
620 // File: @openzeppelin\contracts\utils\introspection\ERC165.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Implementation of the {IERC165} interface.
629  *
630  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
631  * for the additional interface id that will be supported. For example:
632  *
633  * ```solidity
634  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
635  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
636  * }
637  * ```
638  *
639  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
640  */
641 abstract contract ERC165 is IERC165 {
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
646         return interfaceId == type(IERC165).interfaceId;
647     }
648 }
649 
650 // File: contracts\ERC721A.sol
651 
652 
653 // Creator: Chiru Labs
654 
655 pragma solidity ^0.8.4;
656 
657 
658 
659 
660 
661 
662 
663 error ApprovalCallerNotOwnerNorApproved();
664 error ApprovalQueryForNonexistentToken();
665 error ApproveToCaller();
666 error ApprovalToCurrentOwner();
667 error BalanceQueryForZeroAddress();
668 error MintToZeroAddress();
669 error MintZeroQuantity();
670 error OwnerQueryForNonexistentToken();
671 error TransferCallerNotOwnerNorApproved();
672 error TransferFromIncorrectOwner();
673 error TransferToNonERC721ReceiverImplementer();
674 error TransferToZeroAddress();
675 error URIQueryForNonexistentToken();
676 
677 /**
678  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
679  * the Metadata extension. Built to optimize for lower gas during batch mints.
680  *
681  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
682  *
683  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
684  *
685  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
686  */
687 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
688     using Address for address;
689     using Strings for uint256;
690 
691     // Compiler will pack this into a single 256bit word.
692     struct TokenOwnership {
693         // The address of the owner.
694         address addr;
695         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
696         uint64 startTimestamp;
697         // Whether the token has been burned.
698         bool burned;
699     }
700 
701     // Compiler will pack this into a single 256bit word.
702     struct AddressData {
703         // Realistically, 2**64-1 is more than enough.
704         uint64 balance;
705         // Keeps track of mint count with minimal overhead for tokenomics.
706         uint64 numberMinted;
707         // Keeps track of burn count with minimal overhead for tokenomics.
708         uint64 numberBurned;
709         // For miscellaneous variable(s) pertaining to the address
710         // (e.g. number of whitelist mint slots used).
711         // If there are multiple variables, please pack them into a uint64.
712         uint64 aux;
713     }
714 
715     // The tokenId of the next token to be minted.
716     uint256 internal _currentIndex;
717 
718     // The number of tokens burned.
719     uint256 internal _burnCounter;
720 
721     // Token name
722     string private _name;
723 
724     // Token symbol
725     string private _symbol;
726 
727     // Mapping from token ID to ownership details
728     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
729     mapping(uint256 => TokenOwnership) internal _ownerships;
730 
731     // Mapping owner address to address data
732     mapping(address => AddressData) internal _addressData;
733 
734     // Mapping from token ID to approved address
735     mapping(uint256 => address) internal _tokenApprovals;
736 
737     // Mapping from owner to operator approvals
738     mapping(address => mapping(address => bool)) internal _operatorApprovals;
739 
740     constructor(string memory name_, string memory symbol_) {
741         _name = name_;
742         _symbol = symbol_;
743         _currentIndex = _startTokenId();
744     }
745 
746     /**
747      * To change the starting tokenId, please override this function.
748      */
749     function _startTokenId() internal view virtual returns (uint256) {
750         return 1;
751     }
752 
753     /**
754      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
755      */
756     function totalSupply() public view returns (uint256) {
757         // Counter underflow is impossible as _burnCounter cannot be incremented
758         // more than _currentIndex - _startTokenId() times
759         unchecked {
760             return _currentIndex - _burnCounter - _startTokenId();
761         }
762     }
763 
764     /**
765      * Returns the total amount of tokens minted in the contract.
766      */
767     function _totalMinted() internal view returns (uint256) {
768         // Counter underflow is impossible as _currentIndex does not decrement,
769         // and it is initialized to _startTokenId()
770         unchecked {
771             return _currentIndex - _startTokenId();
772         }
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
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
826     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
827         uint256 curr = tokenId;
828 
829         unchecked {
830             if (_startTokenId() <= curr && curr < _currentIndex) {
831                 TokenOwnership memory ownership = _ownerships[curr];
832                 if (!ownership.burned) {
833                     if (ownership.addr != address(0)) {
834                         return ownership;
835                     }
836                     // Invariant:
837                     // There will always be an ownership that has an address and is not burned
838                     // before an ownership that does not have an address and is not burned.
839                     // Hence, curr will not underflow.
840                     while (true) {
841                         curr--;
842                         ownership = _ownerships[curr];
843                         if (ownership.addr != address(0)) {
844                             return ownership;
845                         }
846                     }
847                 }
848             }
849         }
850         revert OwnerQueryForNonexistentToken();
851     }
852 
853     /**
854      * @dev See {IERC721-ownerOf}.
855      */
856     function ownerOf(uint256 tokenId) public view override returns (address) {
857         return _ownershipOf(tokenId).addr;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-name}.
862      */
863     function name() public view virtual override returns (string memory) {
864         return _name;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-symbol}.
869      */
870     function symbol() public view virtual override returns (string memory) {
871         return _symbol;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-tokenURI}.
876      */
877     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
878         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
879 
880         string memory baseURI = _baseURI();
881         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
882     }
883 
884     /**
885      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
886      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
887      * by default, can be overriden in child contracts.
888      */
889     function _baseURI() internal view virtual returns (string memory) {
890         return '';
891     }
892 
893     /**
894      * @dev See {IERC721-approve}.
895      */
896     function approve(address to, uint256 tokenId) public override {
897         address owner = ERC721A.ownerOf(tokenId);
898         if (to == owner) revert ApprovalToCurrentOwner();
899 
900         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
901             revert ApprovalCallerNotOwnerNorApproved();
902         }
903 
904         _approve(to, tokenId, owner);
905     }
906 
907     /**
908      * @dev See {IERC721-getApproved}.
909      */
910     function getApproved(uint256 tokenId) public view override returns (address) {
911         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
912 
913         return _tokenApprovals[tokenId];
914     }
915 
916     /**
917      * @dev See {IERC721-setApprovalForAll}.
918      */
919     function setApprovalForAll(address operator, bool approved) public virtual override {
920         if (operator == _msgSender()) revert ApproveToCaller();
921 
922         _operatorApprovals[_msgSender()][operator] = approved;
923         emit ApprovalForAll(_msgSender(), operator, approved);
924     }
925 
926     /**
927      * @dev See {IERC721-isApprovedForAll}.
928      */
929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
930         return _operatorApprovals[owner][operator];
931     }
932 
933     /**
934      * @dev See {IERC721-transferFrom}.
935      */
936     function transferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         _transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         safeTransferFrom(from, to, tokenId, '');
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         _transfer(from, to, tokenId);
965         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
966             revert TransferToNonERC721ReceiverImplementer();
967         }
968     }
969 
970     /**
971      * @dev Returns whether `tokenId` exists.
972      *
973      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
974      *
975      * Tokens start existing when they are minted (`_mint`),
976      */
977     function _exists(uint256 tokenId) internal view returns (bool) {
978         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
979     }
980 
981     /**
982      * @dev Equivalent to `_safeMint(to, quantity, '')`.
983      */
984     function _safeMint(address to, uint256 quantity) internal returns(uint256, uint256) {
985        return _safeMint(to, quantity, '');
986     }
987 
988     /**
989      * @dev Safely mints `quantity` tokens and transfers them to `to`.
990      *
991      * Requirements:
992      *
993      * - If `to` refers to a smart contract, it must implement 
994      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
995      * - `quantity` must be greater than 0.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _safeMint(
1000         address to,
1001         uint256 quantity,
1002         bytes memory _data
1003     ) internal returns(uint256, uint256) {
1004         uint256 startTokenId = _currentIndex;
1005         if (to == address(0)) revert MintToZeroAddress();
1006         if (quantity == 0) revert MintZeroQuantity();
1007 
1008         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1009 
1010         // Overflows are incredibly unrealistic.
1011         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1012         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1013         unchecked {
1014             _addressData[to].balance += uint64(quantity);
1015             _addressData[to].numberMinted += uint64(quantity);
1016 
1017             _ownerships[startTokenId].addr = to;
1018             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1019 
1020             uint256 updatedIndex = startTokenId;
1021             uint256 end = updatedIndex + quantity;
1022 
1023             if (to.isContract()) {
1024                 do {
1025                     emit Transfer(address(0), to, updatedIndex);
1026                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1027                         revert TransferToNonERC721ReceiverImplementer();
1028                     }
1029                 } while (updatedIndex != end);
1030                 // Reentrancy protection
1031                 if (_currentIndex != startTokenId) revert();
1032             } else {
1033                 do {
1034                 // emit MintWithTokenURI(address(this), updatedIndex, to, "");
1035 
1036                     emit Transfer(address(0), to, updatedIndex++);
1037                 } while (updatedIndex != end);
1038             }
1039             _currentIndex = updatedIndex;
1040         }
1041         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1042         return(startTokenId,_currentIndex-1);
1043     }
1044 
1045     
1046 
1047     /**
1048      * @dev Mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _mint(address to, uint256 quantity) internal {
1058         uint256 startTokenId = _currentIndex;
1059         if (to == address(0)) revert MintToZeroAddress();
1060         if (quantity == 0) revert MintZeroQuantity();
1061 
1062         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1063 
1064         // Overflows are incredibly unrealistic.
1065         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1066         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1067         unchecked {
1068             _addressData[to].balance += uint64(quantity);
1069             _addressData[to].numberMinted += uint64(quantity);
1070 
1071             _ownerships[startTokenId].addr = to;
1072             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1073 
1074             uint256 updatedIndex = startTokenId;
1075             uint256 end = updatedIndex + quantity;
1076 
1077             do {
1078                 // emit MintWithTokenURI(address(this), updatedIndex, to, "");
1079                 emit Transfer(address(0), to, updatedIndex++);
1080                 
1081             } while (updatedIndex != end);
1082 
1083             _currentIndex = updatedIndex;
1084         }
1085         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1086     }
1087 
1088     /**
1089      * @dev Transfers `tokenId` from `from` to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `tokenId` token must be owned by `from`.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _transfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) internal {
1103         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1104 
1105         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1106 
1107         bool isApprovedOrOwner = (_msgSender() == from ||
1108             isApprovedForAll(from, _msgSender()) ||
1109             getApproved(tokenId) == _msgSender());
1110 
1111         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1112         if (to == address(0)) revert TransferToZeroAddress();
1113 
1114         _beforeTokenTransfers(from, to, tokenId, 1);
1115 
1116         // Clear approvals from the previous owner
1117         _approve(address(0), tokenId, from);
1118 
1119         // Underflow of the sender's balance is impossible because we check for
1120         // ownership above and the recipient's balance can't realistically overflow.
1121         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1122         unchecked {
1123             _addressData[from].balance -= 1;
1124             _addressData[to].balance += 1;
1125 
1126             TokenOwnership storage currSlot = _ownerships[tokenId];
1127             currSlot.addr = to;
1128             currSlot.startTimestamp = uint64(block.timestamp);
1129 
1130             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1131             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1132             uint256 nextTokenId = tokenId + 1;
1133             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1134             if (nextSlot.addr == address(0)) {
1135                 // This will suffice for checking _exists(nextTokenId),
1136                 // as a burned slot cannot contain the zero address.
1137                 if (nextTokenId != _currentIndex) {
1138                     nextSlot.addr = from;
1139                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1140                 }
1141             }
1142         }
1143 
1144         emit Transfer(from, to, tokenId);
1145         _afterTokenTransfers(from, to, tokenId, 1);
1146     }
1147 
1148     /**
1149      * @dev Transfers `tokenId` from `from` to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _transferAdmin(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) internal {
1163         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1164 
1165 
1166         if (to == address(0)) revert TransferToZeroAddress();
1167 
1168         _beforeTokenTransfers(from, to, tokenId, 1);
1169 
1170         // Clear approvals from the previous owner
1171         _approve(address(0), tokenId, from);
1172 
1173         // Underflow of the sender's balance is impossible because we check for
1174         // ownership above and the recipient's balance can't realistically overflow.
1175         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1176         unchecked {
1177             _addressData[from].balance -= 1;
1178             _addressData[to].balance += 1;
1179 
1180             TokenOwnership storage currSlot = _ownerships[tokenId];
1181             currSlot.addr = to;
1182             currSlot.startTimestamp = uint64(block.timestamp);
1183 
1184             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1185             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1186             uint256 nextTokenId = tokenId + 1;
1187             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1188             if (nextSlot.addr == address(0)) {
1189                 // This will suffice for checking _exists(nextTokenId),
1190                 // as a burned slot cannot contain the zero address.
1191                 if (nextTokenId != _currentIndex) {
1192                     nextSlot.addr = from;
1193                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1194                 }
1195             }
1196         }
1197 
1198         emit Transfer(from, to, tokenId);
1199         _afterTokenTransfers(from, to, tokenId, 1);
1200     }
1201 
1202     /**
1203      * @dev Equivalent to `_burn(tokenId, false)`.
1204      */
1205     function _burn(uint256 tokenId) internal virtual {
1206         _burn(tokenId, false);
1207     }
1208 
1209     /**
1210      * @dev Destroys `tokenId`.
1211      * The approval is cleared when the token is burned.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1220         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1221 
1222         address from = prevOwnership.addr;
1223 
1224         if (approvalCheck) {
1225             bool isApprovedOrOwner = (_msgSender() == from ||
1226                 isApprovedForAll(from, _msgSender()) ||
1227                 getApproved(tokenId) == _msgSender());
1228 
1229             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1230         }
1231 
1232         _beforeTokenTransfers(from, address(0), tokenId, 1);
1233 
1234         // Clear approvals from the previous owner
1235         _approve(address(0), tokenId, from);
1236 
1237         // Underflow of the sender's balance is impossible because we check for
1238         // ownership above and the recipient's balance can't realistically overflow.
1239         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1240         unchecked {
1241             AddressData storage addressData = _addressData[from];
1242             addressData.balance -= 1;
1243             addressData.numberBurned += 1;
1244 
1245             // Keep track of who burned the token, and the timestamp of burning.
1246             TokenOwnership storage currSlot = _ownerships[tokenId];
1247             currSlot.addr = from;
1248             currSlot.startTimestamp = uint64(block.timestamp);
1249             currSlot.burned = true;
1250 
1251             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1252             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1253             uint256 nextTokenId = tokenId + 1;
1254             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1255             if (nextSlot.addr == address(0)) {
1256                 // This will suffice for checking _exists(nextTokenId),
1257                 // as a burned slot cannot contain the zero address.
1258                 if (nextTokenId != _currentIndex) {
1259                     nextSlot.addr = from;
1260                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, address(0), tokenId);
1266         _afterTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1269         unchecked {
1270             _burnCounter++;
1271         }
1272     }
1273 
1274     /**
1275      * @dev Approve `to` to operate on `tokenId`
1276      *
1277      * Emits a {Approval} event.
1278      */
1279     function _approve(
1280         address to,
1281         uint256 tokenId,
1282         address owner
1283     ) private {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(owner, to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1290      *
1291      * @param from address representing the previous owner of the given token ID
1292      * @param to target address that will receive the tokens
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes optional data to send along with the call
1295      * @return bool whether the call correctly returned the expected magic value
1296      */
1297     function _checkContractOnERC721Received(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) internal returns (bool) {
1303         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1304             return retval == IERC721Receiver(to).onERC721Received.selector;
1305         } catch (bytes memory reason) {
1306             if (reason.length == 0) {
1307                 revert TransferToNonERC721ReceiverImplementer();
1308             } else {
1309                 assembly {
1310                     revert(add(32, reason), mload(reason))
1311                 }
1312             }
1313         }
1314     }
1315 
1316     /**
1317      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1318      * And also called before burning one token.
1319      *
1320      * startTokenId - the first token id to be transferred
1321      * quantity - the amount to be transferred
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` will be minted for `to`.
1328      * - When `to` is zero, `tokenId` will be burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _beforeTokenTransfers(
1332         address from,
1333         address to,
1334         uint256 startTokenId,
1335         uint256 quantity
1336     ) internal virtual {}
1337 
1338     /**
1339      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1340      * minting.
1341      * And also called after one token has been burned.
1342      *
1343      * startTokenId - the first token id to be transferred
1344      * quantity - the amount to be transferred
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` has been minted for `to`.
1351      * - When `to` is zero, `tokenId` has been burned by `from`.
1352      * - `from` and `to` are never both zero.
1353      */
1354     function _afterTokenTransfers(
1355         address from,
1356         address to,
1357         uint256 startTokenId,
1358         uint256 quantity
1359     ) internal virtual {}
1360      event MintWithTokenURI(address indexed collection, uint256 indexed tokenId, address minter, string tokenURI);
1361 }
1362 
1363 // File: contracts\extensions\ERC721AQueryable.sol
1364 
1365 
1366 // Creator: Chiru Labs
1367 
1368 pragma solidity ^0.8.4;
1369 
1370 error InvalidQueryRange();
1371 
1372 /**
1373  * @title ERC721A Queryable
1374  * @dev ERC721A subclass with convenience query functions.
1375  */
1376 abstract contract ERC721AQueryable is ERC721A {
1377     /**
1378      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1379      *
1380      * If the `tokenId` is out of bounds:
1381      *   - `addr` = `address(0)`
1382      *   - `startTimestamp` = `0`
1383      *   - `burned` = `false`
1384      *
1385      * If the `tokenId` is burned:
1386      *   - `addr` = `<Address of owner before token was burned>`
1387      *   - `startTimestamp` = `<Timestamp when token was burned>`
1388      *   - `burned = `true`
1389      *
1390      * Otherwise:
1391      *   - `addr` = `<Address of owner>`
1392      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1393      *   - `burned = `false`
1394      */
1395     function explicitOwnershipOf(uint256 tokenId) public view returns (TokenOwnership memory) {
1396         TokenOwnership memory ownership;
1397         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1398             return ownership;
1399         }
1400         ownership = _ownerships[tokenId];
1401         if (ownership.burned) {
1402             return ownership;
1403         }
1404         return _ownershipOf(tokenId);
1405     }
1406 
1407     /**
1408      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1409      * See {ERC721AQueryable-explicitOwnershipOf}
1410      */
1411     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory) {
1412         unchecked {
1413             uint256 tokenIdsLength = tokenIds.length;
1414             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1415             for (uint256 i; i != tokenIdsLength; ++i) {
1416                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1417             }
1418             return ownerships;
1419         }
1420     }
1421 
1422     /**
1423      * @dev Returns an array of token IDs owned by `owner`,
1424      * in the range [`start`, `stop`)
1425      * (i.e. `start <= tokenId < stop`).
1426      *
1427      * This function allows for tokens to be queried if the collection
1428      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1429      *
1430      * Requirements:
1431      *
1432      * - `start` < `stop`
1433      */
1434     function tokensOfOwnerIn(
1435         address owner,
1436         uint256 start,
1437         uint256 stop
1438     ) external view returns (uint256[] memory) {
1439         unchecked {
1440             if (start > stop) revert InvalidQueryRange();
1441             uint256 tokenIdsIdx;
1442             uint256 stopLimit = _currentIndex + 1;
1443             // Set `start = max(start, _startTokenId())`.
1444             if (start < _startTokenId()) {
1445                 start = _startTokenId();
1446             }
1447             // Set `stop = min(stop, _currentIndex)`.
1448             if (stop > stopLimit) {
1449                 stop = stopLimit;
1450             }
1451             uint256 tokenIdsMaxLength = balanceOf(owner);
1452             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1453             // to cater for cases where `balanceOf(owner)` is too big.
1454             if (start < stop) {
1455                 uint256 rangeLength = stop - start;
1456                 if (rangeLength < tokenIdsMaxLength) {
1457                     tokenIdsMaxLength = rangeLength;
1458                 }
1459             } else {
1460                 tokenIdsMaxLength = 0;
1461             }
1462             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1463             if (tokenIdsMaxLength == 0) {
1464                 return tokenIds;
1465             }
1466             // We need to call `explicitOwnershipOf(start)`,
1467             // because the slot at `start` may not be initialized.
1468             TokenOwnership memory ownership = explicitOwnershipOf(start);
1469             address currOwnershipAddr;
1470             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1471             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1472             if (!ownership.burned) {
1473                 currOwnershipAddr = ownership.addr;
1474             }
1475             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1476                 ownership = _ownerships[i];
1477                 if (ownership.burned) {
1478                     continue;
1479                 }
1480                 if (ownership.addr != address(0)) {
1481                     currOwnershipAddr = ownership.addr;
1482                 }
1483                 if (currOwnershipAddr == owner) {
1484                     tokenIds[tokenIdsIdx++] = i;
1485                 }
1486             }
1487             // Downsize the array to fit.
1488             assembly {
1489                 mstore(tokenIds, tokenIdsIdx)
1490             }
1491             return tokenIds;
1492         }
1493     }
1494 
1495     /**
1496      * @dev Returns an array of token IDs owned by `owner`.
1497      *
1498      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1499      * It is meant to be called off-chain.
1500      *
1501      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1502      * multiple smaller scans if the collection is large enough to cause
1503      * an out-of-gas error (10K pfp collections should be fine).
1504      */
1505     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1506         unchecked {
1507             uint256 tokenIdsIdx;
1508             address currOwnershipAddr;
1509             uint256 tokenIdsLength = balanceOf(owner);
1510             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1511             TokenOwnership memory ownership;
1512             for (uint256 i = _startTokenId(); tokenIdsIdx <= tokenIdsLength; ++i) {
1513                 ownership = _ownerships[i];
1514                 if (ownership.burned) {
1515                     continue;
1516                 }
1517                 if (ownership.addr != address(0)) {
1518                     currOwnershipAddr = ownership.addr;
1519                 }
1520                 if (currOwnershipAddr == owner) {
1521                     tokenIds[tokenIdsIdx++] = i;
1522                 }
1523             }
1524             return tokenIds;
1525         }
1526     }
1527 }
1528 
1529 // File: @openzeppelin\contracts\utils\Counters.sol
1530 
1531 
1532 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 /**
1537  * @title Counters
1538  * @author Matt Condon (@shrugs)
1539  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1540  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1541  *
1542  * Include with `using Counters for Counters.Counter;`
1543  */
1544 library Counters {
1545     struct Counter {
1546         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1547         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1548         // this feature: see https://github.com/ethereum/solidity/issues/4637
1549         uint256 _value; // default: 0
1550     }
1551 
1552     function current(Counter storage counter) internal view returns (uint256) {
1553         return counter._value;
1554     }
1555 
1556     function increment(Counter storage counter) internal {
1557         unchecked {
1558             counter._value += 1;
1559         }
1560     }
1561 
1562     function decrement(Counter storage counter) internal {
1563         uint256 value = counter._value;
1564         require(value > 0, "Counter: decrement overflow");
1565         unchecked {
1566             counter._value = value - 1;
1567         }
1568     }
1569 
1570     function reset(Counter storage counter) internal {
1571         counter._value = 0;
1572     }
1573 }
1574 
1575 // File: contracts\CollectionProxy\CollectionStorage.sol
1576 
1577 
1578 pragma solidity >=0.4.22 <0.9.0;
1579 
1580 /**
1581 > Collection
1582 @notice this contract is standard ERC721 to used as xanalia user's collection managing his NFTs
1583  */
1584 contract CollectionStorage {
1585 using Counters for Counters.Counter;
1586 
1587 // Counters.Counter tokenIds;
1588 string public baseURI;
1589 mapping(address => bool) _allowAddress;
1590 
1591  Counters.Counter roundId;
1592  struct Round {
1593      uint256 startTime;
1594      uint256 endTime;
1595      uint256 price;
1596      address seller;
1597      bool isPublic;
1598      uint256 limit;
1599      uint256 maxSupply;
1600      Counters.Counter supply;
1601      
1602  }
1603  mapping(uint256 => Round) roundInfo;
1604  struct userInfo {
1605      bool isWhiteList;
1606      Counters.Counter purchases;
1607  }
1608  mapping(address => mapping(uint256 => userInfo)) user;
1609 
1610  uint256 internal MaxSupply;
1611  uint256 internal supply;
1612 }
1613 
1614 // File: contracts\CollectionProxy\Ownable.sol
1615 
1616 
1617 
1618 pragma solidity ^0.8.0;
1619 
1620 /**
1621  * @dev Contract module which provides a basic access control mechanism, where
1622  * there is an account (an owner) that can be granted exclusive access to
1623  * specific functions.
1624  *
1625  * By default, the owner account will be the one that deploys the contract. This
1626  * can later be changed with {transferOwnership}.
1627  *
1628  * This module is used through inheritance. It will make available the modifier
1629  * `onlyOwner`, which can be applied to your functions to restrict their use to
1630  * the owner.
1631  */
1632 abstract contract Ownable is Context {
1633     address private _owner;
1634 
1635     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1636 
1637     /**
1638      * @dev Initializes the contract setting the deployer as the initial owner.
1639      */
1640     constructor() {
1641         _setOwner(_msgSender());
1642     }
1643 
1644     /**
1645      * @dev Returns the address of the current owner.
1646      */
1647     function owner() public view virtual returns (address) {
1648         return _owner;
1649     }
1650 
1651     /**
1652      * @dev Throws if called by any account other than the owner.
1653      */
1654     modifier onlyOwner() {
1655         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1656         _;
1657     }
1658 
1659     /**
1660      * @dev Leaves the contract without owner. It will not be possible to call
1661      * `onlyOwner` functions anymore. Can only be called by the current owner.
1662      *
1663      * NOTE: Renouncing ownership will leave the contract without an owner,
1664      * thereby removing any functionality that is only available to the owner.
1665      */
1666     function renounceOwnership() public virtual onlyOwner {
1667         _setOwner(address(0));
1668     }
1669 
1670     /**
1671      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1672      * Can only be called by the current owner.
1673      */
1674     function transferOwnership(address newOwner) public virtual onlyOwner {
1675         require(newOwner != address(0), "Ownable: new owner is the zero address");
1676         _setOwner(newOwner);
1677     }
1678 
1679     function _setOwner(address newOwner) internal {
1680         address oldOwner = _owner;
1681         _owner = newOwner;
1682         emit OwnershipTransferred(oldOwner, newOwner);
1683     }
1684 }
1685 
1686 // File: contracts\CollectionProxy\CollectionProxy.sol
1687 
1688 pragma solidity ^0.8.4;
1689 
1690 
1691 
1692 
1693 
1694 ///////////////////////////////////////////////////////////////////////////////////////////////////
1695 /**
1696  * @title ProxyReceiver Contract
1697  * @dev Handles forwarding calls to receiver delegates while offering transparency of updates.
1698  *      Follows ERC-1538 standard.
1699  *
1700  *    NOTE: Not recommended for direct use in a production contract, as no security control.
1701  *          Provided as simple example only.
1702  */
1703 ///////////////////////////////////////////////////////////////////////////////////////////////////
1704 
1705 contract CollectionProxy is ProxyBaseStorage, IERC1538, ERC721AQueryable, Ownable, CollectionStorage {
1706 using Strings for uint256;
1707 
1708     constructor()ERC721A("XANA: Genesis", "XGS") {
1709 
1710         proxy = address(this);
1711         _allowAddress[msg.sender] = true;
1712         baseURI = "https://testapi.xanalia.com/xanalia/get-nft-meta?tokenId=";
1713         MaxSupply = 10000;
1714     
1715         //Adding ERC1538 updateContract function
1716         bytes memory signature = "updateContract(address,string,string)";
1717         bytes4 funcId = bytes4(keccak256(signature));
1718         delegates[funcId] = proxy;
1719         funcSignatures.push(signature);
1720         funcSignatureToIndex[signature] = funcSignatures.length;
1721        
1722         emit FunctionUpdate(funcId, address(0), proxy, string(signature));
1723         
1724         emit CommitMessage("Added ERC1538 updateContract function at contract creation");
1725     }
1726 
1727     ///////////////////////////////////////////////////////////////////////////////////////////////
1728 
1729     fallback() external payable {
1730         if (msg.sig == bytes4(0) && msg.value != uint(0)) { // skipping ethers/BNB received to delegate
1731             return;
1732         }
1733         address delegate = delegates[msg.sig];
1734         require(delegate != address(0), "Function does not exist.");
1735         assembly {
1736             let ptr := mload(0x40)
1737             calldatacopy(ptr, 0, calldatasize())
1738             let result := delegatecall(gas(), delegate, ptr, calldatasize(), 0, 0)
1739             let size := returndatasize()
1740             returndatacopy(ptr, 0, size)
1741             switch result
1742             case 0 {revert(ptr, size)}
1743             default {return (ptr, size)}
1744         }
1745     }
1746 
1747     ///////////////////////////////////////////////////////////////////////////////////////////////
1748 
1749     /// @notice Updates functions in a transparent contract.
1750     /// @dev If the value of _delegate is zero then the functions specified
1751     ///  in _functionSignatures are removed.
1752     ///  If the value of _delegate is a delegate contract address then the functions
1753     ///  specified in _functionSignatures will be delegated to that address.
1754     /// @param _delegate The address of a delegate contract to delegate to or zero
1755     /// @param _functionSignatures A list of function signatures listed one after the other
1756     /// @param _commitMessage A short description of the change and why it is made
1757     ///        This message is passed to the CommitMessage event.
1758     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) override onlyOwner external {
1759         // pos is first used to check the size of the delegate contract.
1760         // After that pos is the current memory location of _functionSignatures.
1761         // It is used to move through the characters of _functionSignatures
1762         uint256 pos;
1763         if(_delegate != address(0)) {
1764             assembly {
1765                 pos := extcodesize(_delegate)
1766             }
1767             require(pos > 0, "_delegate address is not a contract and is not address(0)");
1768         }
1769 
1770         // creates a bytes version of _functionSignatures
1771         bytes memory signatures = bytes(_functionSignatures);
1772         // stores the position in memory where _functionSignatures ends.
1773         uint256 signaturesEnd;
1774         // stores the starting position of a function signature in _functionSignatures
1775         uint256 start;
1776         assembly {
1777             pos := add(signatures,32)
1778             start := pos
1779             signaturesEnd := add(pos,mload(signatures))
1780         }
1781         // the function id of the current function signature
1782         bytes4 funcId;
1783         // the delegate address that is being replaced or address(0) if removing functions
1784         address oldDelegate;
1785         // the length of the current function signature in _functionSignatures
1786         uint256 num;
1787         // the current character in _functionSignatures
1788         uint256 char;
1789         // the position of the current function signature in the funcSignatures array
1790         uint256 index;
1791         // the last position in the funcSignatures array
1792         uint256 lastIndex;
1793         // parse the _functionSignatures string and handle each function
1794         for (; pos < signaturesEnd; pos++) {
1795             assembly {char := byte(0,mload(pos))}
1796             // 0x29 == )
1797             if (char == 0x29) {
1798                 pos++;
1799                 num = (pos - start);
1800                 start = pos;
1801                 assembly {
1802                     mstore(signatures,num)
1803                 }
1804                 funcId = bytes4(keccak256(signatures));
1805                 oldDelegate = delegates[funcId];
1806                 if(_delegate == address(0)) {
1807                     index = funcSignatureToIndex[signatures];
1808                     require(index != 0, "Function does not exist.");
1809                     index--;
1810                     lastIndex = funcSignatures.length - 1;
1811                     if (index != lastIndex) {
1812                         funcSignatures[index] = funcSignatures[lastIndex];
1813                         funcSignatureToIndex[funcSignatures[lastIndex]] = index + 1;
1814                     }
1815                     funcSignatures.pop();
1816                     delete funcSignatureToIndex[signatures];
1817                     delete delegates[funcId];
1818                     emit FunctionUpdate(funcId, oldDelegate, address(0), string(signatures));
1819                 }
1820                 else if (funcSignatureToIndex[signatures] == 0) {
1821                     require(oldDelegate == address(0), "FuncId clash.");
1822                     delegates[funcId] = _delegate;
1823                     funcSignatures.push(signatures);
1824                     funcSignatureToIndex[signatures] = funcSignatures.length;
1825                     emit FunctionUpdate(funcId, address(0), _delegate, string(signatures));
1826                 }
1827                 else if (delegates[funcId] != _delegate) {
1828                     delegates[funcId] = _delegate;
1829                     emit FunctionUpdate(funcId, oldDelegate, _delegate, string(signatures));
1830 
1831                 }
1832                 assembly {signatures := add(signatures,num)}
1833             }
1834         }
1835         emit CommitMessage(_commitMessage);
1836     }
1837 
1838     function _baseURI() internal view virtual override returns (string memory) {
1839       return baseURI;
1840     }
1841 
1842  /**
1843      * @dev See {IERC721Metadata-tokenURI}.
1844      */
1845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1846         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1847 
1848         string memory baseURI = _baseURI();
1849         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1850     }
1851 
1852     ///////////////////////////////////////////////////////////////////////////////////////////////
1853 
1854 }
1855 
1856 ///////////////////////////////////////////////////////////////////////////////////////////////////