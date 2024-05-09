1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-17
3 */
4 
5 // File lib/utils/introspection/IERC165.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.4;
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
32 // File lib/token/ERC721/IERC721.sol
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 
173 // File lib/token/ERC721/IERC721Receiver.sol
174 
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
190      */
191     function onERC721Received(
192         address operator,
193         address from,
194         uint256 tokenId,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 
200 // File lib/token/ERC721/extensions/IERC721Metadata.sol
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Metadata is IERC721 {
207     /**
208      * @dev Returns the token collection name.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the token collection symbol.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
219      */
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
222 
223 
224 // File lib/utils/Address.sol
225 
226 
227 /**
228  * @dev Collection of functions related to the address type
229  */
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // This method relies on extcodesize, which returns 0 for contracts in
250         // construction, since the code is only stored at the end of the
251         // constructor execution.
252 
253         uint256 size;
254         assembly {
255             size := extcodesize(account)
256         }
257         return size > 0;
258     }
259 
260     /**
261      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262      * `recipient`, forwarding all available gas and reverting on errors.
263      *
264      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265      * of certain opcodes, possibly making contracts go over the 2300 gas limit
266      * imposed by `transfer`, making them unable to receive funds via
267      * `transfer`. {sendValue} removes this limitation.
268      *
269      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270      *
271      * IMPORTANT: because control is transferred to `recipient`, care must be
272      * taken to not create reentrancy vulnerabilities. Consider using
273      * {ReentrancyGuard} or the
274      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275      */
276     function sendValue(address payable recipient, uint256 amount) internal {
277         require(address(this).balance >= amount, "Address: insufficient balance");
278 
279         (bool success, ) = recipient.call{value: amount}("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain `call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, 0, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but also transferring `value` wei to `target`.
322      *
323      * Requirements:
324      *
325      * - the calling contract must have an ETH balance of at least `value`.
326      * - the called Solidity function must be `payable`.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         require(isContract(target), "Address: call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.call{value: value}(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
364         return functionStaticCall(target, data, "Address: low-level static call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.staticcall(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(isContract(target), "Address: delegate call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.delegatecall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
413      * revert reason using the provided one.
414      *
415      * _Available since v4.3._
416      */
417     function verifyCallResult(
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal pure returns (bytes memory) {
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 
441 // File lib/utils/Context.sol
442 
443 
444 /**
445  * @dev Provides information about the current execution context, including the
446  * sender of the transaction and its data. While these are generally available
447  * via msg.sender and msg.data, they should not be accessed in such a direct
448  * manner, since when dealing with meta-transactions the account sending and
449  * paying for execution may not be the actual sender (as far as an application
450  * is concerned).
451  *
452  * This contract is only required for intermediate, library-like contracts.
453  */
454 abstract contract Context {
455     function _msgSender() internal view virtual returns (address) {
456         return msg.sender;
457     }
458 
459     function _msgData() internal view virtual returns (bytes calldata) {
460         return msg.data;
461     }
462 }
463 
464 
465 // File lib/utils/Strings.sol
466 
467 
468 /**
469  * @dev String operations.
470  */
471 library Strings {
472     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
476      */
477     function toString(uint256 value) internal pure returns (string memory) {
478         // Inspired by OraclizeAPI's implementation - MIT licence
479         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
480 
481         if (value == 0) {
482             return "0";
483         }
484         uint256 temp = value;
485         uint256 digits;
486         while (temp != 0) {
487             digits++;
488             temp /= 10;
489         }
490         bytes memory buffer = new bytes(digits);
491         while (value != 0) {
492             digits -= 1;
493             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
494             value /= 10;
495         }
496         return string(buffer);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
501      */
502     function toHexString(uint256 value) internal pure returns (string memory) {
503         if (value == 0) {
504             return "0x00";
505         }
506         uint256 temp = value;
507         uint256 length = 0;
508         while (temp != 0) {
509             length++;
510             temp >>= 8;
511         }
512         return toHexString(value, length);
513     }
514 
515     /**
516      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
517      */
518     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
519         bytes memory buffer = new bytes(2 * length + 2);
520         buffer[0] = "0";
521         buffer[1] = "x";
522         for (uint256 i = 2 * length + 1; i > 1; --i) {
523             buffer[i] = _HEX_SYMBOLS[value & 0xf];
524             value >>= 4;
525         }
526         require(value == 0, "Strings: hex length insufficient");
527         return string(buffer);
528     }
529 }
530 
531 
532 // File lib/utils/introspection/ERC165.sol
533 
534 
535 /**
536  * @dev Implementation of the {IERC165} interface.
537  *
538  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
539  * for the additional interface id that will be supported. For example:
540  *
541  * ```solidity
542  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
544  * }
545  * ```
546  *
547  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
548  */
549 abstract contract ERC165 is IERC165 {
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         return interfaceId == type(IERC165).interfaceId;
555     }
556 }
557 
558 
559 // File lib/token/ERC721A.sol
560 
561 
562 
563 
564 
565 
566 
567 
568 
569 error ApprovalCallerNotOwnerNorApproved();
570 error ApprovalQueryForNonexistentToken();
571 error ApproveToCaller();
572 error ApprovalToCurrentOwner();
573 error BalanceQueryForZeroAddress();
574 error MintToZeroAddress();
575 error MintZeroQuantity();
576 error OwnerQueryForNonexistentToken();
577 error TransferCallerNotOwnerNorApproved();
578 error TransferFromIncorrectOwner();
579 error TransferToNonERC721ReceiverImplementer();
580 error TransferToZeroAddress();
581 error URIQueryForNonexistentToken();
582 
583 interface IOperatorFilterRegistry {
584     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
585     function register(address registrant) external;
586     function registerAndSubscribe(address registrant, address subscription) external;
587     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
588     function updateOperator(address registrant, address operator, bool filtered) external;
589     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
590     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
591     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
592     function subscribe(address registrant, address registrantToSubscribe) external;
593     function unsubscribe(address registrant, bool copyExistingEntries) external;
594     function subscriptionOf(address addr) external returns (address registrant);
595     function subscribers(address registrant) external returns (address[] memory);
596     function subscriberAt(address registrant, uint256 index) external returns (address);
597     function copyEntriesOf(address registrant, address registrantToCopy) external;
598     function isOperatorFiltered(address registrant, address operator) external returns (bool);
599     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
600     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
601     function filteredOperators(address addr) external returns (address[] memory);
602     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
603     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
604     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
605     function isRegistered(address addr) external returns (bool);
606     function codeHashOf(address addr) external returns (bytes32);
607 }
608 
609 abstract contract OperatorFilterer {
610     error OperatorNotAllowed(address operator);
611 
612     IOperatorFilterRegistry constant operatorFilterRegistry =
613     IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
614 
615     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
616         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
617         // will not revert, but the contract will need to be registered with the registry once it is deployed in
618         // order for the modifier to filter addresses.
619         if (address(operatorFilterRegistry).code.length > 0) {
620             if (subscribe) {
621                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
622             } else {
623                 if (subscriptionOrRegistrantToCopy != address(0)) {
624                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
625                 } else {
626                     operatorFilterRegistry.register(address(this));
627                 }
628             }
629         }
630     }
631 
632     modifier onlyAllowedOperator(address from) virtual {
633         // Check registry code length to facilitate testing in environments without a deployed registry.
634         if (address(operatorFilterRegistry).code.length > 0) {
635             // Allow spending tokens from addresses with balance
636             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
637             // from an EOA.
638             if (from == msg.sender) {
639                 _;
640                 return;
641             }
642             if (
643                 !(
644             operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
645             && operatorFilterRegistry.isOperatorAllowed(address(this), from)
646             )
647             ) {
648                 revert OperatorNotAllowed(msg.sender);
649             }
650         }
651         _;
652     }
653 }
654 
655 abstract contract DefaultOperatorFilterer is OperatorFilterer {
656     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
657 
658     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
659 }
660 
661 /**
662  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
663  * the Metadata extension. Built to optimize for lower gas during batch mints.
664  *
665  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
666  *
667  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
668  *
669  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
670  */
671 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, DefaultOperatorFilterer {
672     using Address for address;
673     using Strings for uint256;
674 
675     // Compiler will pack this into a single 256bit word.
676     struct TokenOwnership {
677         // The address of the owner.
678         address addr;
679         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
680         uint64 startTimestamp;
681         // Whether the token has been burned.
682         bool burned;
683     }
684 
685     // Compiler will pack this into a single 256bit word.
686     struct AddressData {
687         // Realistically, 2**64-1 is more than enough.
688         uint64 balance;
689         // Keeps track of mint count with minimal overhead for tokenomics.
690         uint64 numberMinted;
691         // Keeps track of burn count with minimal overhead for tokenomics.
692         uint64 numberBurned;
693         // For miscellaneous variable(s) pertaining to the address
694         // (e.g. number of whitelist mint slots used).
695         // If there are multiple variables, please pack them into a uint64.
696         uint64 aux;
697     }
698 
699     // The tokenId of the next token to be minted.
700     uint256 internal _currentIndex;
701 
702     // The number of tokens burned.
703     uint256 internal _burnCounter;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to ownership details
712     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
713     mapping(uint256 => TokenOwnership) internal _ownerships;
714 
715     // Mapping owner address to address data
716     mapping(address => AddressData) private _addressData;
717 
718     // Mapping from token ID to approved address
719     mapping(uint256 => address) private _tokenApprovals;
720 
721     // Mapping from owner to operator approvals
722     mapping(address => mapping(address => bool)) private _operatorApprovals;
723 
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727         _currentIndex = _startTokenId();
728     }
729 
730     /**
731      * To change the starting tokenId, please override this function.
732      */
733     function _startTokenId() internal view virtual returns (uint256) {
734         return 0;
735     }
736 
737     /**
738      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
739      */
740     function totalSupply() public view returns (uint256) {
741         // Counter underflow is impossible as _burnCounter cannot be incremented
742         // more than _currentIndex - _startTokenId() times
743         unchecked {
744             return _currentIndex - _burnCounter - _startTokenId();
745         }
746     }
747 
748     /**
749      * Returns the total amount of tokens minted in the contract.
750      */
751     function _totalMinted() internal view returns (uint256) {
752         // Counter underflow is impossible as _currentIndex does not decrement,
753         // and it is initialized to _startTokenId()
754         unchecked {
755             return _currentIndex - _startTokenId();
756         }
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view override returns (uint256) {
773         if (owner == address(0)) revert BalanceQueryForZeroAddress();
774         return uint256(_addressData[owner].balance);
775     }
776 
777     /**
778      * Returns the number of tokens minted by `owner`.
779      */
780     function _numberMinted(address owner) internal view returns (uint256) {
781         return uint256(_addressData[owner].numberMinted);
782     }
783 
784     /**
785      * Returns the number of tokens burned by or on behalf of `owner`.
786      */
787     function _numberBurned(address owner) internal view returns (uint256) {
788         return uint256(_addressData[owner].numberBurned);
789     }
790 
791     /**
792      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
793      */
794     function _getAux(address owner) internal view returns (uint64) {
795         return _addressData[owner].aux;
796     }
797 
798     /**
799      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
800      * If there are multiple variables, please pack them into a uint64.
801      */
802     function _setAux(address owner, uint64 aux) internal {
803         _addressData[owner].aux = aux;
804     }
805 
806     /**
807      * Gas spent here starts off proportional to the maximum mint batch size.
808      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
809      */
810     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
811         uint256 curr = tokenId;
812 
813         unchecked {
814             if (_startTokenId() <= curr && curr < _currentIndex) {
815                 TokenOwnership memory ownership = _ownerships[curr];
816                 if (!ownership.burned) {
817                     if (ownership.addr != address(0)) {
818                         return ownership;
819                     }
820                     // Invariant:
821                     // There will always be an ownership that has an address and is not burned
822                     // before an ownership that does not have an address and is not burned.
823                     // Hence, curr will not underflow.
824                     while (true) {
825                         curr--;
826                         ownership = _ownerships[curr];
827                         if (ownership.addr != address(0)) {
828                             return ownership;
829                         }
830                     }
831                 }
832             }
833         }
834         revert OwnerQueryForNonexistentToken();
835     }
836 
837     /**
838      * @dev See {IERC721-ownerOf}.
839      */
840     function ownerOf(uint256 tokenId) public view override returns (address) {
841         return _ownershipOf(tokenId).addr;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-name}.
846      */
847     function name() public view virtual override returns (string memory) {
848         return _name;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-symbol}.
853      */
854     function symbol() public view virtual override returns (string memory) {
855         return _symbol;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-tokenURI}.
860      */
861     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
862         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
863 
864         string memory baseURI = _baseURI();
865         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
866     }
867 
868     /**
869      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
870      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
871      * by default, can be overriden in child contracts.
872      */
873     function _baseURI() internal view virtual returns (string memory) {
874         return '';
875     }
876 
877     /**
878      * @dev See {IERC721-approve}.
879      */
880     function approve(address to, uint256 tokenId) public override {
881         address owner = ERC721A.ownerOf(tokenId);
882         if (to == owner) revert ApprovalToCurrentOwner();
883 
884         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
885             revert ApprovalCallerNotOwnerNorApproved();
886         }
887 
888         _approve(to, tokenId, owner);
889     }
890 
891     /**
892      * @dev See {IERC721-getApproved}.
893      */
894     function getApproved(uint256 tokenId) public view override returns (address) {
895         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
896 
897         return _tokenApprovals[tokenId];
898     }
899 
900     /**
901      * @dev See {IERC721-setApprovalForAll}.
902      */
903     function setApprovalForAll(address operator, bool approved) public virtual override {
904         if (operator == _msgSender()) revert ApproveToCaller();
905 
906         _operatorApprovals[_msgSender()][operator] = approved;
907         emit ApprovalForAll(_msgSender(), operator, approved);
908     }
909 
910     /**
911      * @dev See {IERC721-isApprovedForAll}.
912      */
913     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
914         return _operatorApprovals[owner][operator];
915     }
916 
917     /**
918      * @dev See {IERC721-transferFrom}.
919      */
920     function transferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public onlyAllowedOperator(from) virtual override {
925         _transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public onlyAllowedOperator(from) virtual override {
936         safeTransferFrom(from, to, tokenId, '');
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public onlyAllowedOperator(from) virtual override {
948         _transfer(from, to, tokenId);
949         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
950             revert TransferToNonERC721ReceiverImplementer();
951         }
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      */
961     function _exists(uint256 tokenId) internal view returns (bool) {
962         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
963     }
964 
965     function _safeMint(address to, uint256 quantity) internal {
966         _safeMint(to, quantity, '');
967     }
968 
969     /**
970      * @dev Safely mints `quantity` tokens and transfers them to `to`.
971      *
972      * Requirements:
973      *
974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
975      * - `quantity` must be greater than 0.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeMint(
980         address to,
981         uint256 quantity,
982         bytes memory _data
983     ) internal {
984         _mint(to, quantity, _data, true);
985     }
986 
987     /**
988      * @dev Mints `quantity` tokens and transfers them to `to`.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `quantity` must be greater than 0.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(
998         address to,
999         uint256 quantity,
1000         bytes memory _data,
1001         bool safe
1002     ) internal {
1003         uint256 startTokenId = _currentIndex;
1004         if (to == address(0)) revert MintToZeroAddress();
1005         if (quantity == 0) revert MintZeroQuantity();
1006 
1007         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1008 
1009         // Overflows are incredibly unrealistic.
1010         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1011         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1012         unchecked {
1013             _addressData[to].balance += uint64(quantity);
1014             _addressData[to].numberMinted += uint64(quantity);
1015 
1016             _ownerships[startTokenId].addr = to;
1017             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1018 
1019             uint256 updatedIndex = startTokenId;
1020             uint256 end = updatedIndex + quantity;
1021 
1022             if (safe && to.isContract()) {
1023                 do {
1024                     emit Transfer(address(0), to, updatedIndex);
1025                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1026                         revert TransferToNonERC721ReceiverImplementer();
1027                     }
1028                 } while (updatedIndex != end);
1029                 // Reentrancy protection
1030                 if (_currentIndex != startTokenId) revert();
1031             } else {
1032                 do {
1033                     emit Transfer(address(0), to, updatedIndex++);
1034                 } while (updatedIndex != end);
1035             }
1036             _currentIndex = updatedIndex;
1037         }
1038         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1039     }
1040 
1041     /**
1042      * @dev Transfers `tokenId` from `from` to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) private {
1056         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1057 
1058         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1059 
1060         bool isApprovedOrOwner = (_msgSender() == from ||
1061             isApprovedForAll(from, _msgSender()) ||
1062             getApproved(tokenId) == _msgSender());
1063 
1064         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1065         if (to == address(0)) revert TransferToZeroAddress();
1066 
1067         _beforeTokenTransfers(from, to, tokenId, 1);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId, from);
1071 
1072         // Underflow of the sender's balance is impossible because we check for
1073         // ownership above and the recipient's balance can't realistically overflow.
1074         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1075         unchecked {
1076             _addressData[from].balance -= 1;
1077             _addressData[to].balance += 1;
1078 
1079             TokenOwnership storage currSlot = _ownerships[tokenId];
1080             currSlot.addr = to;
1081             currSlot.startTimestamp = uint64(block.timestamp);
1082 
1083             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1084             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1085             uint256 nextTokenId = tokenId + 1;
1086             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1087             if (nextSlot.addr == address(0)) {
1088                 // This will suffice for checking _exists(nextTokenId),
1089                 // as a burned slot cannot contain the zero address.
1090                 if (nextTokenId != _currentIndex) {
1091                     nextSlot.addr = from;
1092                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1093                 }
1094             }
1095         }
1096 
1097         emit Transfer(from, to, tokenId);
1098         _afterTokenTransfers(from, to, tokenId, 1);
1099     }
1100 
1101     /**
1102      * @dev This is equivalent to _burn(tokenId, false)
1103      */
1104     function _burn(uint256 tokenId) internal virtual {
1105         _burn(tokenId, false);
1106     }
1107 
1108     /**
1109      * @dev Destroys `tokenId`.
1110      * The approval is cleared when the token is burned.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must exist.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1119         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1120 
1121         address from = prevOwnership.addr;
1122 
1123         if (approvalCheck) {
1124             bool isApprovedOrOwner = (_msgSender() == from ||
1125                 isApprovedForAll(from, _msgSender()) ||
1126                 getApproved(tokenId) == _msgSender());
1127 
1128             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1129         }
1130 
1131         _beforeTokenTransfers(from, address(0), tokenId, 1);
1132 
1133         // Clear approvals from the previous owner
1134         _approve(address(0), tokenId, from);
1135 
1136         // Underflow of the sender's balance is impossible because we check for
1137         // ownership above and the recipient's balance can't realistically overflow.
1138         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1139         unchecked {
1140             AddressData storage addressData = _addressData[from];
1141             addressData.balance -= 1;
1142             addressData.numberBurned += 1;
1143 
1144             // Keep track of who burned the token, and the timestamp of burning.
1145             TokenOwnership storage currSlot = _ownerships[tokenId];
1146             currSlot.addr = from;
1147             currSlot.startTimestamp = uint64(block.timestamp);
1148             currSlot.burned = true;
1149 
1150             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1151             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1152             uint256 nextTokenId = tokenId + 1;
1153             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1154             if (nextSlot.addr == address(0)) {
1155                 // This will suffice for checking _exists(nextTokenId),
1156                 // as a burned slot cannot contain the zero address.
1157                 if (nextTokenId != _currentIndex) {
1158                     nextSlot.addr = from;
1159                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1160                 }
1161             }
1162         }
1163 
1164         emit Transfer(from, address(0), tokenId);
1165         _afterTokenTransfers(from, address(0), tokenId, 1);
1166 
1167         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1168         unchecked {
1169             _burnCounter++;
1170         }
1171     }
1172 
1173     /**
1174      * @dev Approve `to` to operate on `tokenId`
1175      *
1176      * Emits a {Approval} event.
1177      */
1178     function _approve(
1179         address to,
1180         uint256 tokenId,
1181         address owner
1182     ) private {
1183         _tokenApprovals[tokenId] = to;
1184         emit Approval(owner, to, tokenId);
1185     }
1186 
1187     /**
1188      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1189      *
1190      * @param from address representing the previous owner of the given token ID
1191      * @param to target address that will receive the tokens
1192      * @param tokenId uint256 ID of the token to be transferred
1193      * @param _data bytes optional data to send along with the call
1194      * @return bool whether the call correctly returned the expected magic value
1195      */
1196     function _checkContractOnERC721Received(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) private returns (bool) {
1202         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1203             return retval == IERC721Receiver(to).onERC721Received.selector;
1204         } catch (bytes memory reason) {
1205             if (reason.length == 0) {
1206                 revert TransferToNonERC721ReceiverImplementer();
1207             } else {
1208                 assembly {
1209                     revert(add(32, reason), mload(reason))
1210                 }
1211             }
1212         }
1213     }
1214 
1215     /**
1216      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1217      * And also called before burning one token.
1218      *
1219      * startTokenId - the first token id to be transferred
1220      * quantity - the amount to be transferred
1221      *
1222      * Calling conditions:
1223      *
1224      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1225      * transferred to `to`.
1226      * - When `from` is zero, `tokenId` will be minted for `to`.
1227      * - When `to` is zero, `tokenId` will be burned by `from`.
1228      * - `from` and `to` are never both zero.
1229      */
1230     function _beforeTokenTransfers(
1231         address from,
1232         address to,
1233         uint256 startTokenId,
1234         uint256 quantity
1235     ) internal virtual {}
1236 
1237     /**
1238      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1239      * minting.
1240      * And also called after one token has been burned.
1241      *
1242      * startTokenId - the first token id to be transferred
1243      * quantity - the amount to be transferred
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` has been minted for `to`.
1250      * - When `to` is zero, `tokenId` has been burned by `from`.
1251      * - `from` and `to` are never both zero.
1252      */
1253     function _afterTokenTransfers(
1254         address from,
1255         address to,
1256         uint256 startTokenId,
1257         uint256 quantity
1258     ) internal virtual {}
1259 }
1260 
1261 
1262 // File lib/token/ERC721AOwnersExplicit.sol
1263 
1264 
1265 error AllOwnershipsHaveBeenSet();
1266 error QuantityMustBeNonZero();
1267 error NoTokensMintedYet();
1268 
1269 abstract contract ERC721AOwnersExplicit is ERC721A {
1270     uint256 public nextOwnerToExplicitlySet;
1271 
1272     /**
1273      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1274      */
1275     function _setOwnersExplicit(uint256 quantity) internal {
1276         if (quantity == 0) revert QuantityMustBeNonZero();
1277         if (_currentIndex == _startTokenId()) revert NoTokensMintedYet();
1278         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1279         if (_nextOwnerToExplicitlySet == 0) {
1280             _nextOwnerToExplicitlySet = _startTokenId();
1281         }
1282         if (_nextOwnerToExplicitlySet >= _currentIndex) revert AllOwnershipsHaveBeenSet();
1283 
1284         // Index underflow is impossible.
1285         // Counter or index overflow is incredibly unrealistic.
1286         unchecked {
1287             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1288 
1289             // Set the end index to be the last token index
1290             if (endIndex + 1 > _currentIndex) {
1291                 endIndex = _currentIndex - 1;
1292             }
1293 
1294             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1295                 if (_ownerships[i].addr == address(0) && !_ownerships[i].burned) {
1296                     TokenOwnership memory ownership = _ownershipOf(i);
1297                     _ownerships[i].addr = ownership.addr;
1298                     _ownerships[i].startTimestamp = ownership.startTimestamp;
1299                 }
1300             }
1301 
1302             nextOwnerToExplicitlySet = endIndex + 1;
1303         }
1304     }
1305 }
1306 
1307 
1308 // File lib/token/ERC721/extensions/ERC721Ownable.sol
1309 
1310 
1311 /**
1312  * @dev Contract module which provides a basic access control mechanism, where
1313  * there is an account (an owner) that can be granted exclusive access to
1314  * specific functions.
1315  *
1316  * By default, the owner account will be the one that deploys the contract. This
1317  * can later be changed with {transferOwnership}.
1318  *
1319  * This module is used through inheritance. It will make available the modifier
1320  * `onlyOwner`, which can be applied to your functions to restrict their use to
1321  * the owner.
1322  */
1323 abstract contract Ownable is Context {
1324     address private _owner;
1325 
1326     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1327 
1328     /**
1329      * @dev Initializes the contract setting the deployer as the initial owner.
1330      */
1331     constructor() {
1332         _transferOwnership(_msgSender());
1333     }
1334 
1335     /**
1336      * @dev Returns the address of the current owner.
1337      */
1338     function owner() public view virtual returns (address) {
1339         return _owner;
1340     }
1341 
1342     /**
1343      * @dev Throws if called by any account other than the owner.
1344      */
1345     modifier onlyOwner() {
1346         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1347         _;
1348     }
1349 
1350     /**
1351      * @dev Leaves the contract without owner. It will not be possible to call
1352      * `onlyOwner` functions anymore. Can only be called by the current owner.
1353      *
1354      * NOTE: Renouncing ownership will leave the contract without an owner,
1355      * thereby removing any functionality that is only available to the owner.
1356      */
1357     function renounceOwnership() public virtual onlyOwner {
1358         _transferOwnership(address(0));
1359     }
1360 
1361     /**
1362      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1363      * Can only be called by the current owner.
1364      */
1365     function transferOwnership(address newOwner) public virtual onlyOwner {
1366         require(newOwner != address(0), "Ownable: new owner is the zero address");
1367         _transferOwnership(newOwner);
1368     }
1369 
1370     /**
1371      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1372      * Internal function without access restriction.
1373      */
1374     function _transferOwnership(address newOwner) internal virtual {
1375         address oldOwner = _owner;
1376         _owner = newOwner;
1377         emit OwnershipTransferred(oldOwner, newOwner);
1378     }
1379 }
1380 
1381 
1382 // File lib/utils/cryptography/MerkleProof.sol
1383 
1384 
1385 /**
1386  * @dev These functions deal with verification of Merkle Trees proofs.
1387  *
1388  * The proofs can be generated using the JavaScript library
1389  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1390  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1391  *
1392  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1393  */
1394 library MerkleProof {
1395     /**
1396      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1397      * defined by `root`. For this, a `proof` must be provided, containing
1398      * sibling hashes on the branch from the leaf to the root of the tree. Each
1399      * pair of leaves and each pair of pre-images are assumed to be sorted.
1400      */
1401     function verify(
1402         bytes32[] memory proof,
1403         bytes32 root,
1404         bytes32 leaf
1405     ) internal pure returns (bool) {
1406         return processProof(proof, leaf) == root;
1407     }
1408 
1409     /**
1410      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1411      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1412      * hash matches the root of the tree. When processing the proof, the pairs
1413      * of leafs & pre-images are assumed to be sorted.
1414      *
1415      * _Available since v4.4._
1416      */
1417     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1418         bytes32 computedHash = leaf;
1419         for (uint256 i = 0; i < proof.length; i++) {
1420             bytes32 proofElement = proof[i];
1421             if (computedHash <= proofElement) {
1422                 // Hash(current computed hash + current element of the proof)
1423                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1424             } else {
1425                 // Hash(current element of the proof + current computed hash)
1426                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1427             }
1428         }
1429         return computedHash;
1430     }
1431 }
1432 
1433 
1434 
1435 // import "../lib/utils/ReentrancyGuard.sol";
1436 
1437 contract ERC721AMSO is ERC721AOwnersExplicit, Ownable {
1438     uint16 public airdropsClaimed;
1439     uint16 public maxAirdropClaims = 50;
1440     struct AirdropClaim {
1441         address user;
1442         uint256 amount;
1443     }
1444 
1445     // Mint Sale dates
1446     uint32 private wlSaleStartTime;
1447 
1448     // Max Supply
1449     uint16 public maxSupply = 4000;
1450 
1451     // Mint config
1452     uint16 private constant maxBatchSize = 20;
1453     uint16 public maxWlMintNumber = 1;
1454 
1455     bytes32 private rootmt;
1456 
1457     // Mint Price
1458     uint256 public wlMintPrice = 0 ether;
1459 
1460     // Metadata URI
1461     string private _baseTokenURI;
1462 
1463     constructor(string memory name_, string memory symbol_)
1464         ERC721A(name_, symbol_)
1465     {}
1466 
1467     modifier callerIsUser() {
1468         require(tx.origin == msg.sender, "The caller is another contract");
1469         _;
1470     }
1471 
1472     event MintInitiated(
1473         uint256 wlMintPrice,
1474         uint16 maxAirdropClaims,
1475         uint16 maxSupply
1476     );
1477 
1478     function initiateMint(
1479         uint256 _wlMintPrice,
1480         uint16 _maxAirdropClaims,
1481         uint16 _maxSupply
1482     ) external onlyOwner {
1483         require(
1484             _maxAirdropClaims > airdropsClaimed
1485             && _maxSupply > totalSupply(),
1486             "MetaplacesSmallOffices::initiateMint: wrong supplies provided"
1487         );
1488 
1489         wlMintPrice = _wlMintPrice;
1490         maxAirdropClaims = _maxAirdropClaims;
1491         maxSupply = _maxSupply;
1492 
1493         emit MintInitiated(
1494             _wlMintPrice,
1495             _maxAirdropClaims,
1496             _maxSupply
1497         );
1498     }
1499 
1500     function setMaxWlMintNumber(uint16 _maxWlMintNumber) public onlyOwner {
1501         require(
1502             _maxWlMintNumber != 0,
1503             "maxWlMintNumber cannot be zero"
1504         );
1505         maxWlMintNumber = _maxWlMintNumber;
1506     }
1507 
1508     function numberMinted(address owner) public view returns (uint256) {
1509         return _numberMinted(owner);
1510     }
1511 
1512     function totalMinted() public view returns (uint256) {
1513         return _totalMinted();
1514     }
1515 
1516     function baseURI() public view returns (string memory) {
1517         return _baseURI();
1518     }
1519 
1520     function exists(uint256 tokenId) public view returns (bool) {
1521         return _exists(tokenId);
1522     }
1523 
1524     // Verifying whitelist spot
1525     function checkValidity(bytes32[] calldata _merkleProof)
1526         public
1527         view
1528         returns (bool)
1529     {
1530         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1531         require(
1532             MerkleProof.verify(_merkleProof, rootmt, leaf),
1533             "Incorrect proof"
1534         );
1535         return true;
1536     }
1537 
1538     function setRootMerkleHash(bytes32 _rootmt) external onlyOwner {
1539         rootmt = _rootmt;
1540     }
1541 
1542     // Mint dates could be set to a distant future to stop the mint
1543     function setMintDates(uint32 wlDate) external onlyOwner {
1544         require(wlDate != 0, "date must be defined");
1545         wlSaleStartTime = wlDate;
1546     }
1547 
1548     // Only whitelisted addresses are authorized to mint during the Whitelist Mint
1549     function whitelistMint(
1550         address to,
1551         uint256 quantity,
1552         bytes32[] calldata _merkleProof
1553     ) external payable {
1554         require(isWlSaleOn(), "whitelist sale has not started yet");
1555         require(
1556             numberMinted(to) + quantity <= maxWlMintNumber,
1557             "can not mint this many"
1558         );
1559         // Checking address to instead of _msgSender()
1560         bytes32 leaf = keccak256(abi.encodePacked(to));
1561         require(
1562             MerkleProof.verify(_merkleProof, rootmt, leaf),
1563             "Incorrect proof"
1564         );
1565         require(msg.value >= wlMintPrice * quantity, "need to send more ETH");
1566         safeMint(to, quantity);
1567     }
1568 
1569     function safeMint(address to, uint256 quantity) private {
1570         require(
1571             totalSupply() + quantity <= maxSupply,
1572             "insufficient remaining supply for desired mint amount"
1573         );
1574         require(
1575             quantity > 0 && quantity <= maxBatchSize,
1576             "incorrect mint quantity"
1577         );
1578 
1579         _safeMint(to, quantity);
1580     }
1581 
1582     receive() external payable {}
1583 
1584     function isWlSaleOn() public view returns (bool) {
1585         uint256 _wlSaleStartTime = uint256(wlSaleStartTime);
1586         return _wlSaleStartTime != 0 && block.timestamp >= _wlSaleStartTime;
1587     }
1588 
1589     function airdropClaims(
1590         AirdropClaim[] calldata airdropClaimList
1591     ) external onlyOwner {
1592         uint256 tokensBeingClaimed;
1593         for (uint256 i = 0; i < airdropClaimList.length; i++)
1594             tokensBeingClaimed += airdropClaimList[i].amount;
1595 
1596         require(
1597             tokensBeingClaimed + airdropsClaimed <= maxAirdropClaims,
1598             "cannot mint"
1599         );
1600 
1601         airdropsClaimed += uint16(tokensBeingClaimed);
1602 
1603         for (uint256 i = 0; i < airdropClaimList.length; i++)
1604             _safeMint(airdropClaimList[i].user, airdropClaimList[i].amount);
1605     }
1606 
1607     function _baseURI() internal view virtual override returns (string memory) {
1608         return _baseTokenURI;
1609     }
1610 
1611     function setBaseURI(string calldata baseURIValue) external onlyOwner {
1612         _baseTokenURI = baseURIValue;
1613     }
1614 
1615     function withdraw() external onlyOwner {
1616         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1617         require(success, "Transfer failed.");
1618     }
1619 
1620     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1621         _setOwnersExplicit(quantity);
1622     }
1623 
1624     function getOwnershipData(uint256 tokenId)
1625         external
1626         view
1627         returns (TokenOwnership memory)
1628     {
1629         return _ownershipOf(tokenId);
1630     }
1631 }
1632 
1633 
1634 // File contracts/MP.sol
1635 
1636 
1637 
1638 contract MetaplacesSmallOffices is ERC721AMSO {
1639   constructor() ERC721AMSO("Small Offices", "MSO") {}
1640 }