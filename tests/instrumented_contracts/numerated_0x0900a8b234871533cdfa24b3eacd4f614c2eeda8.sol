1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
110 
111 pragma solidity ^0.8.1;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      *
125      * Among others, `isContract` will return false for the following
126      * types of addresses:
127      *
128      *  - an externally-owned account
129      *  - a contract in construction
130      *  - an address where a contract will be created
131      *  - an address where a contract lived, but was destroyed
132      * ====
133      *
134      * [IMPORTANT]
135      * ====
136      * You shouldn't rely on `isContract` to protect against flash loan attacks!
137      *
138      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
139      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
140      * constructor.
141      * ====
142      */
143     function isContract(address account) internal view returns (bool) {
144         // This method relies on extcodesize/address.code.length, which returns 0
145         // for contracts in construction, since the code is only stored at the end
146         // of the constructor execution.
147 
148         return account.code.length > 0;
149     }
150 
151     /**
152      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
153      * `recipient`, forwarding all available gas and reverting on errors.
154      *
155      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
156      * of certain opcodes, possibly making contracts go over the 2300 gas limit
157      * imposed by `transfer`, making them unable to receive funds via
158      * `transfer`. {sendValue} removes this limitation.
159      *
160      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
161      *
162      * IMPORTANT: because control is transferred to `recipient`, care must be
163      * taken to not create reentrancy vulnerabilities. Consider using
164      * {ReentrancyGuard} or the
165      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
166      */
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         (bool success, ) = recipient.call{value: amount}("");
171         require(success, "Address: unable to send value, recipient may have reverted");
172     }
173 
174     /**
175      * @dev Performs a Solidity function call using a low level `call`. A
176      * plain `call` is an unsafe replacement for a function call: use this
177      * function instead.
178      *
179      * If `target` reverts with a revert reason, it is bubbled up by this
180      * function (like regular Solidity function calls).
181      *
182      * Returns the raw returned data. To convert to the expected return value,
183      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
184      *
185      * Requirements:
186      *
187      * - `target` must be a contract.
188      * - calling `target` with `data` must not revert.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
198      * `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, 0, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but also transferring `value` wei to `target`.
213      *
214      * Requirements:
215      *
216      * - the calling contract must have an ETH balance of at least `value`.
217      * - the called Solidity function must be `payable`.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
231      * with `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         require(address(this).balance >= value, "Address: insufficient balance for call");
242         require(isContract(target), "Address: call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.call{value: value}(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
255         return functionStaticCall(target, data, "Address: low-level static call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a static call.
261      *
262      * _Available since v3.3._
263      */
264     function functionStaticCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal view returns (bytes memory) {
269         require(isContract(target), "Address: static call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.staticcall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(isContract(target), "Address: delegate call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
304      * revert reason using the provided one.
305      *
306      * _Available since v4.3._
307      */
308     function verifyCallResult(
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal pure returns (bytes memory) {
313         if (success) {
314             return returndata;
315         } else {
316             // Look for revert reason and bubble it up if present
317             if (returndata.length > 0) {
318                 // The easiest way to bubble the revert reason is using memory via assembly
319 
320                 assembly {
321                     let returndata_size := mload(returndata)
322                     revert(add(32, returndata), returndata_size)
323                 }
324             } else {
325                 revert(errorMessage);
326             }
327         }
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @title ERC721 token receiver interface
340  * @dev Interface for any contract that wants to support safeTransfers
341  * from ERC721 asset contracts.
342  */
343 interface IERC721Receiver {
344     /**
345      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
346      * by `operator` from `from`, this function is called.
347      *
348      * It must return its Solidity selector to confirm the token transfer.
349      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
350      *
351      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
352      */
353     function onERC721Received(
354         address operator,
355         address from,
356         uint256 tokenId,
357         bytes calldata data
358     ) external returns (bytes4);
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Interface of the ERC165 standard, as defined in the
370  * https://eips.ethereum.org/EIPS/eip-165[EIP].
371  *
372  * Implementers can declare support of contract interfaces, which can then be
373  * queried by others ({ERC165Checker}).
374  *
375  * For an implementation, see {ERC165}.
376  */
377 interface IERC165 {
378     /**
379      * @dev Returns true if this contract implements the interface defined by
380      * `interfaceId`. See the corresponding
381      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
382      * to learn more about how these ids are created.
383      *
384      * This function call must use less than 30 000 gas.
385      */
386     function supportsInterface(bytes4 interfaceId) external view returns (bool);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Implementation of the {IERC165} interface.
399  *
400  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
401  * for the additional interface id that will be supported. For example:
402  *
403  * ```solidity
404  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
405  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
406  * }
407  * ```
408  *
409  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
410  */
411 abstract contract ERC165 is IERC165 {
412     /**
413      * @dev See {IERC165-supportsInterface}.
414      */
415     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416         return interfaceId == type(IERC165).interfaceId;
417     }
418 }
419 
420 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
421 
422 
423 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 
428 /**
429  * @dev Required interface of an ERC721 compliant contract.
430  */
431 interface IERC721 is IERC165 {
432     /**
433      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
434      */
435     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
436 
437     /**
438      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
439      */
440     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
441 
442     /**
443      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
444      */
445     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
446 
447     /**
448      * @dev Returns the number of tokens in ``owner``'s account.
449      */
450     function balanceOf(address owner) external view returns (uint256 balance);
451 
452     /**
453      * @dev Returns the owner of the `tokenId` token.
454      *
455      * Requirements:
456      *
457      * - `tokenId` must exist.
458      */
459     function ownerOf(uint256 tokenId) external view returns (address owner);
460 
461     /**
462      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
463      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
464      *
465      * Requirements:
466      *
467      * - `from` cannot be the zero address.
468      * - `to` cannot be the zero address.
469      * - `tokenId` token must exist and be owned by `from`.
470      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
471      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
472      *
473      * Emits a {Transfer} event.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) external;
480 
481     /**
482      * @dev Transfers `tokenId` token from `from` to `to`.
483      *
484      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must be owned by `from`.
491      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
492      *
493      * Emits a {Transfer} event.
494      */
495     function transferFrom(
496         address from,
497         address to,
498         uint256 tokenId
499     ) external;
500 
501     /**
502      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
503      * The approval is cleared when the token is transferred.
504      *
505      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
506      *
507      * Requirements:
508      *
509      * - The caller must own the token or be an approved operator.
510      * - `tokenId` must exist.
511      *
512      * Emits an {Approval} event.
513      */
514     function approve(address to, uint256 tokenId) external;
515 
516     /**
517      * @dev Returns the account approved for `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function getApproved(uint256 tokenId) external view returns (address operator);
524 
525     /**
526      * @dev Approve or remove `operator` as an operator for the caller.
527      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
528      *
529      * Requirements:
530      *
531      * - The `operator` cannot be the caller.
532      *
533      * Emits an {ApprovalForAll} event.
534      */
535     function setApprovalForAll(address operator, bool _approved) external;
536 
537     /**
538      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
539      *
540      * See {setApprovalForAll}
541      */
542     function isApprovedForAll(address owner, address operator) external view returns (bool);
543 
544     /**
545      * @dev Safely transfers `tokenId` token from `from` to `to`.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId,
561         bytes calldata data
562     ) external;
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 
573 /**
574  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
575  * @dev See https://eips.ethereum.org/EIPS/eip-721
576  */
577 interface IERC721Metadata is IERC721 {
578     /**
579      * @dev Returns the token collection name.
580      */
581     function name() external view returns (string memory);
582 
583     /**
584      * @dev Returns the token collection symbol.
585      */
586     function symbol() external view returns (string memory);
587 
588     /**
589      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
590      */
591     function tokenURI(uint256 tokenId) external view returns (string memory);
592 }
593 
594 // File: @openzeppelin/contracts/utils/Strings.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev String operations.
603  */
604 library Strings {
605     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
609      */
610     function toString(uint256 value) internal pure returns (string memory) {
611         // Inspired by OraclizeAPI's implementation - MIT licence
612         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
613 
614         if (value == 0) {
615             return "0";
616         }
617         uint256 temp = value;
618         uint256 digits;
619         while (temp != 0) {
620             digits++;
621             temp /= 10;
622         }
623         bytes memory buffer = new bytes(digits);
624         while (value != 0) {
625             digits -= 1;
626             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
627             value /= 10;
628         }
629         return string(buffer);
630     }
631 
632     /**
633      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
634      */
635     function toHexString(uint256 value) internal pure returns (string memory) {
636         if (value == 0) {
637             return "0x00";
638         }
639         uint256 temp = value;
640         uint256 length = 0;
641         while (temp != 0) {
642             length++;
643             temp >>= 8;
644         }
645         return toHexString(value, length);
646     }
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
650      */
651     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
652         bytes memory buffer = new bytes(2 * length + 2);
653         buffer[0] = "0";
654         buffer[1] = "x";
655         for (uint256 i = 2 * length + 1; i > 1; --i) {
656             buffer[i] = _HEX_SYMBOLS[value & 0xf];
657             value >>= 4;
658         }
659         require(value == 0, "Strings: hex length insufficient");
660         return string(buffer);
661     }
662 }
663 
664 // File: erc721a/contracts/ERC721A.sol
665 
666 
667 // Creator: Chiru Labs
668 
669 pragma solidity ^0.8.4;
670 
671 
672 
673 
674 
675 
676 
677 
678 error ApprovalCallerNotOwnerNorApproved();
679 error ApprovalQueryForNonexistentToken();
680 error ApproveToCaller();
681 error ApprovalToCurrentOwner();
682 error BalanceQueryForZeroAddress();
683 error MintToZeroAddress();
684 error MintZeroQuantity();
685 error OwnerQueryForNonexistentToken();
686 error TransferCallerNotOwnerNorApproved();
687 error TransferFromIncorrectOwner();
688 error TransferToNonERC721ReceiverImplementer();
689 error TransferToZeroAddress();
690 error URIQueryForNonexistentToken();
691 
692 /**
693  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
694  * the Metadata extension. Built to optimize for lower gas during batch mints.
695  *
696  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
697  *
698  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
699  *
700  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
701  */
702 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
703     using Address for address;
704     using Strings for uint256;
705 
706     // Compiler will pack this into a single 256bit word.
707     struct TokenOwnership {
708         // The address of the owner.
709         address addr;
710         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
711         uint64 startTimestamp;
712         // Whether the token has been burned.
713         bool burned;
714     }
715 
716     // Compiler will pack this into a single 256bit word.
717     struct AddressData {
718         // Realistically, 2**64-1 is more than enough.
719         uint64 balance;
720         // Keeps track of mint count with minimal overhead for tokenomics.
721         uint64 numberMinted;
722         // Keeps track of burn count with minimal overhead for tokenomics.
723         uint64 numberBurned;
724         // For miscellaneous variable(s) pertaining to the address
725         // (e.g. number of whitelist mint slots used).
726         // If there are multiple variables, please pack them into a uint64.
727         uint64 aux;
728     }
729 
730     // The tokenId of the next token to be minted.
731     uint256 internal _currentIndex;
732 
733     // The number of tokens burned.
734     uint256 internal _burnCounter;
735 
736     // Token name
737     string private _name;
738 
739     // Token symbol
740     string private _symbol;
741 
742     // Mapping from token ID to ownership details
743     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
744     mapping(uint256 => TokenOwnership) internal _ownerships;
745 
746     // Mapping owner address to address data
747     mapping(address => AddressData) private _addressData;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     constructor(string memory name_, string memory symbol_) {
756         _name = name_;
757         _symbol = symbol_;
758         _currentIndex = _startTokenId();
759     }
760 
761     /**
762      * To change the starting tokenId, please override this function.
763      */
764     function _startTokenId() internal view virtual returns (uint256) {
765         return 0;
766     }
767 
768     /**
769      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
770      */
771     function totalSupply() public view returns (uint256) {
772         // Counter underflow is impossible as _burnCounter cannot be incremented
773         // more than _currentIndex - _startTokenId() times
774         unchecked {
775             return _currentIndex - _burnCounter - _startTokenId();
776         }
777     }
778 
779     /**
780      * Returns the total amount of tokens minted in the contract.
781      */
782     function _totalMinted() internal view returns (uint256) {
783         // Counter underflow is impossible as _currentIndex does not decrement,
784         // and it is initialized to _startTokenId()
785         unchecked {
786             return _currentIndex - _startTokenId();
787         }
788     }
789 
790     /**
791      * @dev See {IERC165-supportsInterface}.
792      */
793     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
794         return
795             interfaceId == type(IERC721).interfaceId ||
796             interfaceId == type(IERC721Metadata).interfaceId ||
797             super.supportsInterface(interfaceId);
798     }
799 
800     /**
801      * @dev See {IERC721-balanceOf}.
802      */
803     function balanceOf(address owner) public view override returns (uint256) {
804         if (owner == address(0)) revert BalanceQueryForZeroAddress();
805         return uint256(_addressData[owner].balance);
806     }
807 
808     /**
809      * Returns the number of tokens minted by `owner`.
810      */
811     function _numberMinted(address owner) internal view returns (uint256) {
812         return uint256(_addressData[owner].numberMinted);
813     }
814 
815     /**
816      * Returns the number of tokens burned by or on behalf of `owner`.
817      */
818     function _numberBurned(address owner) internal view returns (uint256) {
819         return uint256(_addressData[owner].numberBurned);
820     }
821 
822     /**
823      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
824      */
825     function _getAux(address owner) internal view returns (uint64) {
826         return _addressData[owner].aux;
827     }
828 
829     /**
830      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
831      * If there are multiple variables, please pack them into a uint64.
832      */
833     function _setAux(address owner, uint64 aux) internal {
834         _addressData[owner].aux = aux;
835     }
836 
837     /**
838      * Gas spent here starts off proportional to the maximum mint batch size.
839      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
840      */
841     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
842         uint256 curr = tokenId;
843 
844         unchecked {
845             if (_startTokenId() <= curr && curr < _currentIndex) {
846                 TokenOwnership memory ownership = _ownerships[curr];
847                 if (!ownership.burned) {
848                     if (ownership.addr != address(0)) {
849                         return ownership;
850                     }
851                     // Invariant:
852                     // There will always be an ownership that has an address and is not burned
853                     // before an ownership that does not have an address and is not burned.
854                     // Hence, curr will not underflow.
855                     while (true) {
856                         curr--;
857                         ownership = _ownerships[curr];
858                         if (ownership.addr != address(0)) {
859                             return ownership;
860                         }
861                     }
862                 }
863             }
864         }
865         revert OwnerQueryForNonexistentToken();
866     }
867 
868     /**
869      * @dev See {IERC721-ownerOf}.
870      */
871     function ownerOf(uint256 tokenId) public view override returns (address) {
872         return _ownershipOf(tokenId).addr;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-name}.
877      */
878     function name() public view virtual override returns (string memory) {
879         return _name;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-symbol}.
884      */
885     function symbol() public view virtual override returns (string memory) {
886         return _symbol;
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-tokenURI}.
891      */
892     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
893         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
894 
895         string memory baseURI = _baseURI();
896         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
897     }
898 
899     /**
900      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
901      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
902      * by default, can be overriden in child contracts.
903      */
904     function _baseURI() internal view virtual returns (string memory) {
905         return '';
906     }
907 
908     /**
909      * @dev See {IERC721-approve}.
910      */
911     function approve(address to, uint256 tokenId) public override {
912         address owner = ERC721A.ownerOf(tokenId);
913         if (to == owner) revert ApprovalToCurrentOwner();
914 
915         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
916             revert ApprovalCallerNotOwnerNorApproved();
917         }
918 
919         _approve(to, tokenId, owner);
920     }
921 
922     /**
923      * @dev See {IERC721-getApproved}.
924      */
925     function getApproved(uint256 tokenId) public view override returns (address) {
926         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
927 
928         return _tokenApprovals[tokenId];
929     }
930 
931     /**
932      * @dev See {IERC721-setApprovalForAll}.
933      */
934     function setApprovalForAll(address operator, bool approved) public virtual override {
935         if (operator == _msgSender()) revert ApproveToCaller();
936 
937         _operatorApprovals[_msgSender()][operator] = approved;
938         emit ApprovalForAll(_msgSender(), operator, approved);
939     }
940 
941     /**
942      * @dev See {IERC721-isApprovedForAll}.
943      */
944     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
945         return _operatorApprovals[owner][operator];
946     }
947 
948     /**
949      * @dev See {IERC721-transferFrom}.
950      */
951     function transferFrom(
952         address from,
953         address to,
954         uint256 tokenId
955     ) public virtual override {
956         _transfer(from, to, tokenId);
957     }
958 
959     /**
960      * @dev See {IERC721-safeTransferFrom}.
961      */
962     function safeTransferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) public virtual override {
967         safeTransferFrom(from, to, tokenId, '');
968     }
969 
970     /**
971      * @dev See {IERC721-safeTransferFrom}.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) public virtual override {
979         _transfer(from, to, tokenId);
980         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
981             revert TransferToNonERC721ReceiverImplementer();
982         }
983     }
984 
985     /**
986      * @dev Returns whether `tokenId` exists.
987      *
988      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
989      *
990      * Tokens start existing when they are minted (`_mint`),
991      */
992     function _exists(uint256 tokenId) internal view returns (bool) {
993         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
994     }
995 
996     function _safeMint(address to, uint256 quantity) internal {
997         _safeMint(to, quantity, '');
998     }
999 
1000     /**
1001      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1002      *
1003      * Requirements:
1004      *
1005      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1006      * - `quantity` must be greater than 0.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _safeMint(
1011         address to,
1012         uint256 quantity,
1013         bytes memory _data
1014     ) internal {
1015         _mint(to, quantity, _data, true);
1016     }
1017 
1018     /**
1019      * @dev Mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `quantity` must be greater than 0.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _mint(
1029         address to,
1030         uint256 quantity,
1031         bytes memory _data,
1032         bool safe
1033     ) internal {
1034         uint256 startTokenId = _currentIndex;
1035         if (to == address(0)) revert MintToZeroAddress();
1036         if (quantity == 0) revert MintZeroQuantity();
1037 
1038         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1039 
1040         // Overflows are incredibly unrealistic.
1041         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1042         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1043         unchecked {
1044             _addressData[to].balance += uint64(quantity);
1045             _addressData[to].numberMinted += uint64(quantity);
1046 
1047             _ownerships[startTokenId].addr = to;
1048             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1049 
1050             uint256 updatedIndex = startTokenId;
1051             uint256 end = updatedIndex + quantity;
1052 
1053             if (safe && to.isContract()) {
1054                 do {
1055                     emit Transfer(address(0), to, updatedIndex);
1056                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1057                         revert TransferToNonERC721ReceiverImplementer();
1058                     }
1059                 } while (updatedIndex != end);
1060                 // Reentrancy protection
1061                 if (_currentIndex != startTokenId) revert();
1062             } else {
1063                 do {
1064                     emit Transfer(address(0), to, updatedIndex++);
1065                 } while (updatedIndex != end);
1066             }
1067             _currentIndex = updatedIndex;
1068         }
1069         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1070     }
1071 
1072     /**
1073      * @dev Transfers `tokenId` from `from` to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must be owned by `from`.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _transfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) private {
1087         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1088 
1089         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1090 
1091         bool isApprovedOrOwner = (_msgSender() == from ||
1092             isApprovedForAll(from, _msgSender()) ||
1093             getApproved(tokenId) == _msgSender());
1094 
1095         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1096         if (to == address(0)) revert TransferToZeroAddress();
1097 
1098         _beforeTokenTransfers(from, to, tokenId, 1);
1099 
1100         // Clear approvals from the previous owner
1101         _approve(address(0), tokenId, from);
1102 
1103         // Underflow of the sender's balance is impossible because we check for
1104         // ownership above and the recipient's balance can't realistically overflow.
1105         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1106         unchecked {
1107             _addressData[from].balance -= 1;
1108             _addressData[to].balance += 1;
1109 
1110             TokenOwnership storage currSlot = _ownerships[tokenId];
1111             currSlot.addr = to;
1112             currSlot.startTimestamp = uint64(block.timestamp);
1113 
1114             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1115             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1116             uint256 nextTokenId = tokenId + 1;
1117             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1118             if (nextSlot.addr == address(0)) {
1119                 // This will suffice for checking _exists(nextTokenId),
1120                 // as a burned slot cannot contain the zero address.
1121                 if (nextTokenId != _currentIndex) {
1122                     nextSlot.addr = from;
1123                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1124                 }
1125             }
1126         }
1127 
1128         emit Transfer(from, to, tokenId);
1129         _afterTokenTransfers(from, to, tokenId, 1);
1130     }
1131 
1132     /**
1133      * @dev This is equivalent to _burn(tokenId, false)
1134      */
1135     function _burn(uint256 tokenId) internal virtual {
1136         _burn(tokenId, false);
1137     }
1138 
1139     /**
1140      * @dev Destroys `tokenId`.
1141      * The approval is cleared when the token is burned.
1142      *
1143      * Requirements:
1144      *
1145      * - `tokenId` must exist.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1150         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1151 
1152         address from = prevOwnership.addr;
1153 
1154         if (approvalCheck) {
1155             bool isApprovedOrOwner = (_msgSender() == from ||
1156                 isApprovedForAll(from, _msgSender()) ||
1157                 getApproved(tokenId) == _msgSender());
1158 
1159             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         }
1161 
1162         _beforeTokenTransfers(from, address(0), tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, from);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             AddressData storage addressData = _addressData[from];
1172             addressData.balance -= 1;
1173             addressData.numberBurned += 1;
1174 
1175             // Keep track of who burned the token, and the timestamp of burning.
1176             TokenOwnership storage currSlot = _ownerships[tokenId];
1177             currSlot.addr = from;
1178             currSlot.startTimestamp = uint64(block.timestamp);
1179             currSlot.burned = true;
1180 
1181             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1182             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1183             uint256 nextTokenId = tokenId + 1;
1184             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1185             if (nextSlot.addr == address(0)) {
1186                 // This will suffice for checking _exists(nextTokenId),
1187                 // as a burned slot cannot contain the zero address.
1188                 if (nextTokenId != _currentIndex) {
1189                     nextSlot.addr = from;
1190                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1191                 }
1192             }
1193         }
1194 
1195         emit Transfer(from, address(0), tokenId);
1196         _afterTokenTransfers(from, address(0), tokenId, 1);
1197 
1198         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1199         unchecked {
1200             _burnCounter++;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Approve `to` to operate on `tokenId`
1206      *
1207      * Emits a {Approval} event.
1208      */
1209     function _approve(
1210         address to,
1211         uint256 tokenId,
1212         address owner
1213     ) private {
1214         _tokenApprovals[tokenId] = to;
1215         emit Approval(owner, to, tokenId);
1216     }
1217 
1218     /**
1219      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1220      *
1221      * @param from address representing the previous owner of the given token ID
1222      * @param to target address that will receive the tokens
1223      * @param tokenId uint256 ID of the token to be transferred
1224      * @param _data bytes optional data to send along with the call
1225      * @return bool whether the call correctly returned the expected magic value
1226      */
1227     function _checkContractOnERC721Received(
1228         address from,
1229         address to,
1230         uint256 tokenId,
1231         bytes memory _data
1232     ) private returns (bool) {
1233         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1234             return retval == IERC721Receiver(to).onERC721Received.selector;
1235         } catch (bytes memory reason) {
1236             if (reason.length == 0) {
1237                 revert TransferToNonERC721ReceiverImplementer();
1238             } else {
1239                 assembly {
1240                     revert(add(32, reason), mload(reason))
1241                 }
1242             }
1243         }
1244     }
1245 
1246     /**
1247      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1248      * And also called before burning one token.
1249      *
1250      * startTokenId - the first token id to be transferred
1251      * quantity - the amount to be transferred
1252      *
1253      * Calling conditions:
1254      *
1255      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1256      * transferred to `to`.
1257      * - When `from` is zero, `tokenId` will be minted for `to`.
1258      * - When `to` is zero, `tokenId` will be burned by `from`.
1259      * - `from` and `to` are never both zero.
1260      */
1261     function _beforeTokenTransfers(
1262         address from,
1263         address to,
1264         uint256 startTokenId,
1265         uint256 quantity
1266     ) internal virtual {}
1267 
1268     /**
1269      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1270      * minting.
1271      * And also called after one token has been burned.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` has been minted for `to`.
1281      * - When `to` is zero, `tokenId` has been burned by `from`.
1282      * - `from` and `to` are never both zero.
1283      */
1284     function _afterTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 }
1291 
1292 // File: contracts/ZoinkedPunks.sol
1293 
1294 
1295 pragma solidity ^0.8.4;
1296 
1297 
1298 
1299 
1300 contract ZoinkedPunks is ERC721A, Ownable{
1301 
1302     using Strings for uint256;
1303 
1304     bytes32 public merkleRoot;
1305 
1306     string public uriPrefix = "";
1307     string public uriSuffix = ".json";
1308     string public hiddenMetadataUri;
1309 
1310 //Create Setters for price
1311 
1312     uint256 public cost = 0.01 ether;
1313     uint256 public freeSupply = 4000;
1314     uint256 public maxSupply = 4500;
1315     uint256 public maxMintAmountPerTx = 10;
1316 
1317 //Create Setters for status
1318 
1319     bool public paused = true;
1320     bool public revealed = false;
1321 
1322 
1323   constructor() ERC721A("Zoinked Punks", "ZP") {
1324     setHiddenMetadataUri("ipfs://QmPjJ8fVCHbeUPr5FcxtogepA8wtg7AKqXujfXD2BStZmf/hiddengif.json");
1325   }
1326 
1327   modifier mintCompliance(uint256 quantity) {
1328     require(quantity > 0 && quantity <= maxMintAmountPerTx, "Invalid mint amount!");
1329     (totalSupply() + quantity <= maxSupply, "Max supply exceeded!");
1330     _;
1331   }
1332 
1333 
1334   function freeMint(uint256 quantity) public payable mintCompliance(quantity) {
1335     require(!paused, "The contract is paused!");
1336     require(totalSupply() + quantity <= freeSupply,"Not enough free supply!");
1337         _safeMint(msg.sender, quantity);
1338     }
1339 
1340   function devMint(uint256 quantity) external onlyOwner {
1341     require(totalSupply() + quantity <= maxSupply, "Max supply exceeded!");
1342     require(totalSupply() + quantity <= freeSupply,"Not enough free supply!");
1343         _safeMint(msg.sender, quantity);
1344     }
1345 
1346   function mint(uint256 quantity) public payable mintCompliance(quantity)            {
1347     require(!paused, "The contract is paused!");
1348     require(msg.value >= cost * quantity, "Insufficient funds!");
1349         _safeMint(msg.sender, quantity);
1350   
1351   }
1352 
1353   function walletOfOwner(address _owner)
1354     public
1355     view
1356     returns (uint256[] memory)
1357   {
1358     uint256 ownerTokenCount = balanceOf(_owner);
1359     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1360     uint256 currentTokenId = 1;
1361     uint256 ownedTokenIndex = 0;
1362 
1363     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1364       address currentTokenOwner = ownerOf(currentTokenId);
1365 
1366       if (currentTokenOwner == _owner) {
1367         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1368 
1369         ownedTokenIndex++;
1370       }
1371 
1372       currentTokenId++;
1373     }
1374 
1375     return ownedTokenIds;
1376   }
1377 
1378   function tokenURI(uint256 _tokenId)
1379     public
1380     view
1381     virtual
1382     override
1383     returns (string memory)
1384   {
1385     require(
1386       _exists(_tokenId),
1387       "ERC721Metadata: URI query for nonexistent token"
1388     );
1389 
1390     if (revealed == false) {
1391       return hiddenMetadataUri;
1392     }
1393 
1394     string memory currentBaseURI = _baseURI();
1395     return bytes(currentBaseURI).length > 0
1396         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1397         : "";
1398 
1399   }
1400 
1401   function setRevealed(bool _state) public onlyOwner {
1402     revealed = _state;
1403   }
1404 
1405   function setCost(uint256 _cost) public onlyOwner {
1406     cost = _cost;
1407   }
1408 
1409   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1410     maxMintAmountPerTx = _maxMintAmountPerTx;
1411   }
1412 
1413   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1414     hiddenMetadataUri = _hiddenMetadataUri;
1415   }
1416 
1417   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1418     uriPrefix = _uriPrefix;
1419   }
1420   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1421     uriSuffix = _uriSuffix;
1422   }
1423   function setPaused(bool _state) public onlyOwner {
1424     paused = _state;
1425   }
1426 
1427   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1428     merkleRoot = _merkleRoot;
1429   }
1430 
1431   function withdraw() public onlyOwner {
1432     // This will pay Community wallet 10% of the initial sale.
1433     // You can remove this if you want, or keep it in to support your community wallet.
1434     // Just replace with your community wallet address. 
1435     // =============================================================================
1436     (bool hs, ) = payable(0xF2b40f521656d33D0865BDb5ae6aBf59dC30Dc03).call{value: address    (this).balance * 10 / 100}("");
1437     require(hs);
1438     // =============================================================================
1439     // This will transfer the remaining contract balance to the owner.
1440     // Do not remove this otherwise you will not be able to withdraw the funds.
1441     // =============================================================================
1442     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1443     require(os);
1444     // =============================================================================
1445   }
1446 
1447   function _baseURI() internal view virtual override returns (string memory) {
1448     return uriPrefix;
1449   }
1450 }