1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: contracts/StartTokenIdHelper.sol
7 
8 
9 // ERC721A Contracts v3.3.0
10 // Creators: Chiru Labs
11 
12 pragma solidity ^0.8.4;
13 
14 /**
15  * This Helper is used to return a dynmamic value in the overriden _startTokenId() function.
16  * Extending this Helper before the ERC721A contract give us access to the herein set `startTokenId`
17  * to be returned by the overriden `_startTokenId()` function of ERC721A in the ERC721AStartTokenId mocks.
18  */
19 contract StartTokenIdHelper {
20     uint256 public startTokenId;
21 
22     constructor(uint256 startTokenId_) {
23         startTokenId = startTokenId_;
24     }
25 }
26 // File: @openzeppelin/contracts/utils/Strings.sol
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/Context.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         return msg.data;
120     }
121 }
122 
123 // File: @openzeppelin/contracts/access/Ownable.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 
131 /**
132  * @dev Contract module which provides a basic access control mechanism, where
133  * there is an account (an owner) that can be granted exclusive access to
134  * specific functions.
135  *
136  * By default, the owner account will be the one that deploys the contract. This
137  * can later be changed with {transferOwnership}.
138  *
139  * This module is used through inheritance. It will make available the modifier
140  * `onlyOwner`, which can be applied to your functions to restrict their use to
141  * the owner.
142  */
143 abstract contract Ownable is Context {
144     address private _owner;
145 
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147 
148     /**
149      * @dev Initializes the contract setting the deployer as the initial owner.
150      */
151     constructor() {
152         _transferOwnership(_msgSender());
153     }
154 
155     /**
156      * @dev Returns the address of the current owner.
157      */
158     function owner() public view virtual returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyOwner() {
166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169 
170     /**
171      * @dev Leaves the contract without owner. It will not be possible to call
172      * `onlyOwner` functions anymore. Can only be called by the current owner.
173      *
174      * NOTE: Renouncing ownership will leave the contract without an owner,
175      * thereby removing any functionality that is only available to the owner.
176      */
177     function renounceOwnership() public virtual onlyOwner {
178         _transferOwnership(address(0));
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Can only be called by the current owner.
184      */
185     function transferOwnership(address newOwner) public virtual onlyOwner {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         _transferOwnership(newOwner);
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      * Internal function without access restriction.
193      */
194     function _transferOwnership(address newOwner) internal virtual {
195         address oldOwner = _owner;
196         _owner = newOwner;
197         emit OwnershipTransferred(oldOwner, newOwner);
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Address.sol
202 
203 
204 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
205 
206 pragma solidity ^0.8.1;
207 
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      *
229      * [IMPORTANT]
230      * ====
231      * You shouldn't rely on `isContract` to protect against flash loan attacks!
232      *
233      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
234      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
235      * constructor.
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize/address.code.length, which returns 0
240         // for contracts in construction, since the code is only stored at the end
241         // of the constructor execution.
242 
243         return account.code.length > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         (bool success, ) = recipient.call{value: amount}("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 
269     /**
270      * @dev Performs a Solidity function call using a low level `call`. A
271      * plain `call` is an unsafe replacement for a function call: use this
272      * function instead.
273      *
274      * If `target` reverts with a revert reason, it is bubbled up by this
275      * function (like regular Solidity function calls).
276      *
277      * Returns the raw returned data. To convert to the expected return value,
278      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
279      *
280      * Requirements:
281      *
282      * - `target` must be a contract.
283      * - calling `target` with `data` must not revert.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionCall(target, data, "Address: low-level call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
293      * `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
350         return functionStaticCall(target, data, "Address: low-level static call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
399      * revert reason using the provided one.
400      *
401      * _Available since v4.3._
402      */
403     function verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) internal pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
427 
428 
429 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @title ERC721 token receiver interface
435  * @dev Interface for any contract that wants to support safeTransfers
436  * from ERC721 asset contracts.
437  */
438 interface IERC721Receiver {
439     /**
440      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
441      * by `operator` from `from`, this function is called.
442      *
443      * It must return its Solidity selector to confirm the token transfer.
444      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
445      *
446      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
447      */
448     function onERC721Received(
449         address operator,
450         address from,
451         uint256 tokenId,
452         bytes calldata data
453     ) external returns (bytes4);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @dev Interface of the ERC165 standard, as defined in the
465  * https://eips.ethereum.org/EIPS/eip-165[EIP].
466  *
467  * Implementers can declare support of contract interfaces, which can then be
468  * queried by others ({ERC165Checker}).
469  *
470  * For an implementation, see {ERC165}.
471  */
472 interface IERC165 {
473     /**
474      * @dev Returns true if this contract implements the interface defined by
475      * `interfaceId`. See the corresponding
476      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
477      * to learn more about how these ids are created.
478      *
479      * This function call must use less than 30 000 gas.
480      */
481     function supportsInterface(bytes4 interfaceId) external view returns (bool);
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Implementation of the {IERC165} interface.
494  *
495  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
496  * for the additional interface id that will be supported. For example:
497  *
498  * ```solidity
499  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
501  * }
502  * ```
503  *
504  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
505  */
506 abstract contract ERC165 is IERC165 {
507     /**
508      * @dev See {IERC165-supportsInterface}.
509      */
510     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511         return interfaceId == type(IERC165).interfaceId;
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
516 
517 
518 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @dev Required interface of an ERC721 compliant contract.
525  */
526 interface IERC721 is IERC165 {
527     /**
528      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
529      */
530     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
534      */
535     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
539      */
540     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
541 
542     /**
543      * @dev Returns the number of tokens in ``owner``'s account.
544      */
545     function balanceOf(address owner) external view returns (uint256 balance);
546 
547     /**
548      * @dev Returns the owner of the `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function ownerOf(uint256 tokenId) external view returns (address owner);
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId,
573         bytes calldata data
574     ) external;
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
578      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Approve or remove `operator` as an operator for the caller.
633      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
634      *
635      * Requirements:
636      *
637      * - The `operator` cannot be the caller.
638      *
639      * Emits an {ApprovalForAll} event.
640      */
641     function setApprovalForAll(address operator, bool _approved) external;
642 
643     /**
644      * @dev Returns the account approved for `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function getApproved(uint256 tokenId) external view returns (address operator);
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Metadata is IERC721 {
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external view returns (string memory);
687 }
688 
689 // File: contracts/IERC721A.sol
690 
691 
692 // ERC721A Contracts v3.3.0
693 // Creator: Chiru Labs
694 
695 pragma solidity ^0.8.4;
696 
697 
698 
699 /**
700  * @dev Interface of an ERC721A compliant contract.
701  */
702 interface IERC721A is IERC721, IERC721Metadata {
703     /**
704      * The caller must own the token or be an approved operator.
705      */
706     error ApprovalCallerNotOwnerNorApproved();
707 
708     /**
709      * The token does not exist.
710      */
711     error ApprovalQueryForNonexistentToken();
712 
713     /**
714      * The caller cannot approve to their own address.
715      */
716     error ApproveToCaller();
717 
718     /**
719      * The caller cannot approve to the current owner.
720      */
721     error ApprovalToCurrentOwner();
722 
723     /**
724      * Cannot query the balance for the zero address.
725      */
726     error BalanceQueryForZeroAddress();
727 
728     /**
729      * Cannot mint to the zero address.
730      */
731     error MintToZeroAddress();
732 
733     /**
734      * The quantity of tokens minted must be more than zero.
735      */
736     error MintZeroQuantity();
737 
738     /**
739      * The token does not exist.
740      */
741     error OwnerQueryForNonexistentToken();
742 
743     /**
744      * The caller must own the token or be an approved operator.
745      */
746     error TransferCallerNotOwnerNorApproved();
747 
748     /**
749      * The token must be owned by `from`.
750      */
751     error TransferFromIncorrectOwner();
752 
753     /**
754      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
755      */
756     error TransferToNonERC721ReceiverImplementer();
757 
758     /**
759      * Cannot transfer to the zero address.
760      */
761     error TransferToZeroAddress();
762 
763     /**
764      * The token does not exist.
765      */
766     error URIQueryForNonexistentToken();
767 
768     // Compiler will pack this into a single 256bit word.
769     struct TokenOwnership {
770         // The address of the owner.
771         address addr;
772         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
773         uint64 startTimestamp;
774         // Whether the token has been burned.
775         bool burned;
776     }
777 
778     // Compiler will pack this into a single 256bit word.
779     struct AddressData {
780         // Realistically, 2**64-1 is more than enough.
781         uint64 balance;
782         // Keeps track of mint count with minimal overhead for tokenomics.
783         uint64 numberMinted;
784         // Keeps track of burn count with minimal overhead for tokenomics.
785         uint64 numberBurned;
786         // For miscellaneous variable(s) pertaining to the address
787         // (e.g. number of whitelist mint slots used).
788         // If there are multiple variables, please pack them into a uint64.
789         uint64 aux;
790     }
791 
792     /**
793      * @dev Returns the total amount of tokens stored by the contract.
794      * 
795      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
796      */
797     function totalSupply() external view returns (uint256);
798 }
799 
800 // File: contracts/ERC721A.sol
801 
802 
803 // ERC721A Contracts v3.3.0
804 // Creator: Chiru Labs
805 
806 pragma solidity ^0.8.4;
807 
808 
809 
810 
811 
812 
813 
814 /**
815  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
816  * the Metadata extension. Built to optimize for lower gas during batch mints.
817  *
818  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
819  *
820  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
821  *
822  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
823  */
824 contract ERC721A is Context, ERC165, IERC721A {
825     using Address for address;
826     using Strings for uint256;
827 
828     // The tokenId of the next token to be minted.
829     uint256 internal _currentIndex;
830 
831     // The number of tokens burned.
832     uint256 internal _burnCounter;
833 
834     // Token name
835     string private _name;
836 
837     // Token symbol
838     string private _symbol;
839 
840     // Mapping from token ID to ownership details
841     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
842     mapping(uint256 => TokenOwnership) internal _ownerships;
843 
844     // Mapping owner address to address data
845     mapping(address => AddressData) private _addressData;
846 
847     // Mapping from token ID to approved address
848     mapping(uint256 => address) private _tokenApprovals;
849 
850     // Mapping from owner to operator approvals
851     mapping(address => mapping(address => bool)) private _operatorApprovals;
852 
853     constructor(string memory name_, string memory symbol_) {
854         _name = name_;
855         _symbol = symbol_;
856         _currentIndex = _startTokenId();
857     }
858 
859     /**
860      * To change the starting tokenId, please override this function.
861      */
862     function _startTokenId() internal view virtual returns (uint256) {
863         return 0;
864     }
865 
866     /**
867      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
868      */
869     function totalSupply() public view override returns (uint256) {
870         // Counter underflow is impossible as _burnCounter cannot be incremented
871         // more than _currentIndex - _startTokenId() times
872         unchecked {
873             return _currentIndex - _burnCounter - _startTokenId();
874         }
875     }
876 
877     /**
878      * Returns the total amount of tokens minted in the contract.
879      */
880     function _totalMinted() internal view returns (uint256) {
881         // Counter underflow is impossible as _currentIndex does not decrement,
882         // and it is initialized to _startTokenId()
883         unchecked {
884             return _currentIndex - _startTokenId();
885         }
886     }
887 
888     /**
889      * @dev See {IERC165-supportsInterface}.
890      */
891     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
892         return
893             interfaceId == type(IERC721).interfaceId ||
894             interfaceId == type(IERC721Metadata).interfaceId ||
895             super.supportsInterface(interfaceId);
896     }
897 
898     /**
899      * @dev See {IERC721-balanceOf}.
900      */
901     function balanceOf(address owner) public view override returns (uint256) {
902         if (owner == address(0)) revert BalanceQueryForZeroAddress();
903         return uint256(_addressData[owner].balance);
904     }
905 
906     /**
907      * Returns the number of tokens minted by `owner`.
908      */
909     function _numberMinted(address owner) internal view returns (uint256) {
910         return uint256(_addressData[owner].numberMinted);
911     }
912 
913     /**
914      * Returns the number of tokens burned by or on behalf of `owner`.
915      */
916     function _numberBurned(address owner) internal view returns (uint256) {
917         return uint256(_addressData[owner].numberBurned);
918     }
919 
920     /**
921      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
922      */
923     function _getAux(address owner) internal view returns (uint64) {
924         return _addressData[owner].aux;
925     }
926 
927     /**
928      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
929      * If there are multiple variables, please pack them into a uint64.
930      */
931     function _setAux(address owner, uint64 aux) internal {
932         _addressData[owner].aux = aux;
933     }
934 
935     /**
936      * Gas spent here starts off proportional to the maximum mint batch size.
937      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
938      */
939     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
940         uint256 curr = tokenId;
941 
942         unchecked {
943             if (_startTokenId() <= curr) if (curr < _currentIndex) {
944                 TokenOwnership memory ownership = _ownerships[curr];
945                 if (!ownership.burned) {
946                     if (ownership.addr != address(0)) {
947                         return ownership;
948                     }
949                     // Invariant:
950                     // There will always be an ownership that has an address and is not burned
951                     // before an ownership that does not have an address and is not burned.
952                     // Hence, curr will not underflow.
953                     while (true) {
954                         curr--;
955                         ownership = _ownerships[curr];
956                         if (ownership.addr != address(0)) {
957                             return ownership;
958                         }
959                     }
960                 }
961             }
962         }
963         revert OwnerQueryForNonexistentToken();
964     }
965 
966     /**
967      * @dev See {IERC721-ownerOf}.
968      */
969     function ownerOf(uint256 tokenId) public view override returns (address) {
970         return _ownershipOf(tokenId).addr;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-name}.
975      */
976     function name() public view virtual override returns (string memory) {
977         return _name;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-symbol}.
982      */
983     function symbol() public view virtual override returns (string memory) {
984         return _symbol;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-tokenURI}.
989      */
990     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
991         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
992 
993         string memory baseURI = _baseURI();
994         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
995     }
996 
997     /**
998      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
999      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1000      * by default, can be overriden in child contracts.
1001      */
1002     function _baseURI() internal view virtual returns (string memory) {
1003         return '';
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-approve}.
1008      */
1009     function approve(address to, uint256 tokenId) public override {
1010         address owner = ERC721A.ownerOf(tokenId);
1011         if (to == owner) revert ApprovalToCurrentOwner();
1012 
1013         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1014             revert ApprovalCallerNotOwnerNorApproved();
1015         }
1016 
1017         _approve(to, tokenId, owner);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-getApproved}.
1022      */
1023     function getApproved(uint256 tokenId) public view override returns (address) {
1024         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1025 
1026         return _tokenApprovals[tokenId];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-setApprovalForAll}.
1031      */
1032     function setApprovalForAll(address operator, bool approved) public virtual override {
1033         if (operator == _msgSender()) revert ApproveToCaller();
1034 
1035         _operatorApprovals[_msgSender()][operator] = approved;
1036         emit ApprovalForAll(_msgSender(), operator, approved);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-isApprovedForAll}.
1041      */
1042     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1043         return _operatorApprovals[owner][operator];
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-transferFrom}.
1048      */
1049     function transferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         _transfer(from, to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-safeTransferFrom}.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) public virtual override {
1065         safeTransferFrom(from, to, tokenId, '');
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-safeTransferFrom}.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) public virtual override {
1077         _transfer(from, to, tokenId);
1078         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1079             revert TransferToNonERC721ReceiverImplementer();
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns whether `tokenId` exists.
1085      *
1086      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1087      *
1088      * Tokens start existing when they are minted (`_mint`),
1089      */
1090     function _exists(uint256 tokenId) internal view returns (bool) {
1091         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1092     }
1093 
1094     /**
1095      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1096      */
1097     function _safeMint(address to, uint256 quantity) internal {
1098         _safeMint(to, quantity, '');
1099     }
1100 
1101     /**
1102      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - If `to` refers to a smart contract, it must implement
1107      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1108      * - `quantity` must be greater than 0.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _safeMint(
1113         address to,
1114         uint256 quantity,
1115         bytes memory _data
1116     ) internal {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) revert MintZeroQuantity();
1120 
1121         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1122 
1123         // Overflows are incredibly unrealistic.
1124         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1125         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1126         unchecked {
1127             _addressData[to].balance += uint64(quantity);
1128             _addressData[to].numberMinted += uint64(quantity);
1129 
1130             _ownerships[startTokenId].addr = to;
1131             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1132 
1133             uint256 updatedIndex = startTokenId;
1134             uint256 end = updatedIndex + quantity;
1135 
1136             if (to.isContract()) {
1137                 do {
1138                     emit Transfer(address(0), to, updatedIndex);
1139                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1140                         revert TransferToNonERC721ReceiverImplementer();
1141                     }
1142                 } while (updatedIndex < end);
1143                 // Reentrancy protection
1144                 if (_currentIndex != startTokenId) revert();
1145             } else {
1146                 do {
1147                     emit Transfer(address(0), to, updatedIndex++);
1148                 } while (updatedIndex < end);
1149             }
1150             _currentIndex = updatedIndex;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154 
1155     /**
1156      * @dev Mints `quantity` tokens and transfers them to `to`.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _mint(address to, uint256 quantity) internal {
1166         uint256 startTokenId = _currentIndex;
1167         if (to == address(0)) revert MintToZeroAddress();
1168         if (quantity == 0) revert MintZeroQuantity();
1169 
1170         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1171 
1172         // Overflows are incredibly unrealistic.
1173         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1174         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1175         unchecked {
1176             _addressData[to].balance += uint64(quantity);
1177             _addressData[to].numberMinted += uint64(quantity);
1178 
1179             _ownerships[startTokenId].addr = to;
1180             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1181 
1182             uint256 updatedIndex = startTokenId;
1183             uint256 end = updatedIndex + quantity;
1184 
1185             do {
1186                 emit Transfer(address(0), to, updatedIndex++);
1187             } while (updatedIndex < end);
1188 
1189             _currentIndex = updatedIndex;
1190         }
1191         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1192     }
1193 
1194     /**
1195      * @dev Transfers `tokenId` from `from` to `to`.
1196      *
1197      * Requirements:
1198      *
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must be owned by `from`.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _transfer(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) private {
1209         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1210 
1211         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1212 
1213         bool isApprovedOrOwner = (_msgSender() == from ||
1214             isApprovedForAll(from, _msgSender()) ||
1215             getApproved(tokenId) == _msgSender());
1216 
1217         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1218         if (to == address(0)) revert TransferToZeroAddress();
1219 
1220         _beforeTokenTransfers(from, to, tokenId, 1);
1221 
1222         // Clear approvals from the previous owner
1223         _approve(address(0), tokenId, from);
1224 
1225         // Underflow of the sender's balance is impossible because we check for
1226         // ownership above and the recipient's balance can't realistically overflow.
1227         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1228         unchecked {
1229             _addressData[from].balance -= 1;
1230             _addressData[to].balance += 1;
1231 
1232             TokenOwnership storage currSlot = _ownerships[tokenId];
1233             currSlot.addr = to;
1234             currSlot.startTimestamp = uint64(block.timestamp);
1235 
1236             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1237             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1238             uint256 nextTokenId = tokenId + 1;
1239             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1240             if (nextSlot.addr == address(0)) {
1241                 // This will suffice for checking _exists(nextTokenId),
1242                 // as a burned slot cannot contain the zero address.
1243                 if (nextTokenId != _currentIndex) {
1244                     nextSlot.addr = from;
1245                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1246                 }
1247             }
1248         }
1249 
1250         emit Transfer(from, to, tokenId);
1251         _afterTokenTransfers(from, to, tokenId, 1);
1252     }
1253 
1254     /**
1255      * @dev Equivalent to `_burn(tokenId, false)`.
1256      */
1257     function _burn(uint256 tokenId) internal virtual {
1258         _burn(tokenId, false);
1259     }
1260 
1261     /**
1262      * @dev Destroys `tokenId`.
1263      * The approval is cleared when the token is burned.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1272         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1273 
1274         address from = prevOwnership.addr;
1275 
1276         if (approvalCheck) {
1277             bool isApprovedOrOwner = (_msgSender() == from ||
1278                 isApprovedForAll(from, _msgSender()) ||
1279                 getApproved(tokenId) == _msgSender());
1280 
1281             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1282         }
1283 
1284         _beforeTokenTransfers(from, address(0), tokenId, 1);
1285 
1286         // Clear approvals from the previous owner
1287         _approve(address(0), tokenId, from);
1288 
1289         // Underflow of the sender's balance is impossible because we check for
1290         // ownership above and the recipient's balance can't realistically overflow.
1291         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1292         unchecked {
1293             AddressData storage addressData = _addressData[from];
1294             addressData.balance -= 1;
1295             addressData.numberBurned += 1;
1296 
1297             // Keep track of who burned the token, and the timestamp of burning.
1298             TokenOwnership storage currSlot = _ownerships[tokenId];
1299             currSlot.addr = from;
1300             currSlot.startTimestamp = uint64(block.timestamp);
1301             currSlot.burned = true;
1302 
1303             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1304             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1305             uint256 nextTokenId = tokenId + 1;
1306             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1307             if (nextSlot.addr == address(0)) {
1308                 // This will suffice for checking _exists(nextTokenId),
1309                 // as a burned slot cannot contain the zero address.
1310                 if (nextTokenId != _currentIndex) {
1311                     nextSlot.addr = from;
1312                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1313                 }
1314             }
1315         }
1316 
1317         emit Transfer(from, address(0), tokenId);
1318         _afterTokenTransfers(from, address(0), tokenId, 1);
1319 
1320         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1321         unchecked {
1322             _burnCounter++;
1323         }
1324     }
1325 
1326     /**
1327      * @dev Approve `to` to operate on `tokenId`
1328      *
1329      * Emits a {Approval} event.
1330      */
1331     function _approve(
1332         address to,
1333         uint256 tokenId,
1334         address owner
1335     ) private {
1336         _tokenApprovals[tokenId] = to;
1337         emit Approval(owner, to, tokenId);
1338     }
1339 
1340     /**
1341      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1342      *
1343      * @param from address representing the previous owner of the given token ID
1344      * @param to target address that will receive the tokens
1345      * @param tokenId uint256 ID of the token to be transferred
1346      * @param _data bytes optional data to send along with the call
1347      * @return bool whether the call correctly returned the expected magic value
1348      */
1349     function _checkContractOnERC721Received(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory _data
1354     ) private returns (bool) {
1355         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1356             return retval == IERC721Receiver(to).onERC721Received.selector;
1357         } catch (bytes memory reason) {
1358             if (reason.length == 0) {
1359                 revert TransferToNonERC721ReceiverImplementer();
1360             } else {
1361                 assembly {
1362                     revert(add(32, reason), mload(reason))
1363                 }
1364             }
1365         }
1366     }
1367 
1368     /**
1369      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1370      * And also called before burning one token.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` will be minted for `to`.
1380      * - When `to` is zero, `tokenId` will be burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _beforeTokenTransfers(
1384         address from,
1385         address to,
1386         uint256 startTokenId,
1387         uint256 quantity
1388     ) internal virtual {}
1389 
1390     /**
1391      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1392      * minting.
1393      * And also called after one token has been burned.
1394      *
1395      * startTokenId - the first token id to be transferred
1396      * quantity - the amount to be transferred
1397      *
1398      * Calling conditions:
1399      *
1400      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1401      * transferred to `to`.
1402      * - When `from` is zero, `tokenId` has been minted for `to`.
1403      * - When `to` is zero, `tokenId` has been burned by `from`.
1404      * - `from` and `to` are never both zero.
1405      */
1406     function _afterTokenTransfers(
1407         address from,
1408         address to,
1409         uint256 startTokenId,
1410         uint256 quantity
1411     ) internal virtual {}
1412 }
1413 
1414 // File: contracts/trolltowns.sol
1415 
1416 
1417 
1418 pragma solidity ^0.8.4;
1419 
1420 
1421 
1422 
1423 contract trolltowns is StartTokenIdHelper, ERC721A, Ownable {
1424     using Strings for uint256;
1425 
1426     string baseURI;
1427     uint256 private _maxAmount;
1428     uint256 private _mintAmount;
1429     uint256 private _maxTXAmount;
1430 
1431     constructor(string memory name_, string memory symbol_) StartTokenIdHelper(1) ERC721A(name_, symbol_) {
1432         baseURI = "https://mnn.mypinata.cloud/ipfs/QmW3iP4s4DhiReQzXUHtui5SbYwWQ1CXB3waqzEtcijJF3/";
1433         _maxAmount = 10000;
1434         _mintAmount = 9000;
1435         _maxTXAmount = 10;
1436     }
1437 
1438     function numberMinted(address owner) public view returns (uint256) {
1439         return _numberMinted(owner);
1440     }
1441 
1442     function totalMinted() public view returns (uint256) {
1443         return _totalMinted();
1444     }
1445 
1446     function getAux(address owner) public view returns (uint64) {
1447         return _getAux(owner);
1448     }
1449 
1450     function setAux(address owner, uint64 aux) public {
1451         _setAux(owner, aux);
1452     }
1453 
1454     function _baseURI() internal view override returns (string memory) {
1455         return baseURI;
1456     }
1457 
1458     function setBaseURI(string memory baseURI_) public onlyOwner {
1459         baseURI = baseURI_;
1460     }
1461 
1462     function maxAmount() public view returns (uint256) {
1463         return _maxAmount;
1464     }
1465 
1466     function setMaxAmount(uint256 maxAmount_) public onlyOwner {
1467         _maxAmount = maxAmount_;
1468     }
1469 
1470     function mintAmount() public view returns (uint256) {
1471         return _mintAmount;
1472     }
1473 
1474     function setMintAmount(uint256 mintAmount_) public onlyOwner {
1475         _mintAmount = mintAmount_;
1476     }
1477 
1478     function _startTokenId() internal view override returns (uint256) {
1479         return startTokenId;
1480     }
1481 
1482     function exists(uint256 tokenId) public view returns (bool) {
1483         return _exists(tokenId);
1484     }
1485 
1486     function burn(uint256 tokenId, bool approvalCheck) public onlyOwner {
1487         _burn(tokenId, approvalCheck);
1488     }
1489 
1490     function airDropMint(address to, uint256 quantity) external onlyOwner {
1491         require(totalMinted() + quantity <= _maxAmount, "Exceed max amount");
1492         _safeMint(to, quantity);
1493     }
1494 
1495     function mint(uint256 quantity) external {
1496         // _safeMint's second argument now takes in a quantity, not a tokenId.
1497         require(quantity <= _maxTXAmount, "Exceed TX amount");
1498         require(totalMinted() + quantity <= _mintAmount, "Exceed mint amount");
1499 
1500         _safeMint(msg.sender, quantity);
1501     }
1502 
1503     function withdraw() external payable onlyOwner {
1504         uint256 amount = address(this).balance;
1505         Address.sendValue(payable(msg.sender), amount);
1506     }
1507 }