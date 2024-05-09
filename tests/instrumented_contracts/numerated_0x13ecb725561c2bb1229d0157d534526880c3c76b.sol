1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-28
3 */
4 
5 // SPDX-License-Identifier: MIT
6 //Developer Info:
7 
8 
9 
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21 
22     /**
23      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
24      */
25     function toString(uint256 value) internal pure returns (string memory) {
26         // Inspired by OraclizeAPI's implementation - MIT licence
27         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
28 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
49      */
50     function toHexString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0x00";
53         }
54         uint256 temp = value;
55         uint256 length = 0;
56         while (temp != 0) {
57             length++;
58             temp >>= 8;
59         }
60         return toHexString(value, length);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
65      */
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
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
594 // File: contracts/new.sol
595 
596 
597 
598 
599 pragma solidity ^0.8.4;
600 
601 
602 
603 
604 
605 
606 
607 
608 error ApprovalCallerNotOwnerNorApproved();
609 error ApprovalQueryForNonexistentToken();
610 error ApproveToCaller();
611 error ApprovalToCurrentOwner();
612 error BalanceQueryForZeroAddress();
613 error MintToZeroAddress();
614 error MintZeroQuantity();
615 error OwnerQueryForNonexistentToken();
616 error TransferCallerNotOwnerNorApproved();
617 error TransferFromIncorrectOwner();
618 error TransferToNonERC721ReceiverImplementer();
619 error TransferToZeroAddress();
620 error URIQueryForNonexistentToken();
621 
622 /**
623  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
624  * the Metadata extension. Built to optimize for lower gas during batch mints.
625  *
626  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
627  *
628  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
629  *
630  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
631  */
632 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
633     using Address for address;
634     using Strings for uint256;
635 
636     // Compiler will pack this into a single 256bit word.
637     struct TokenOwnership {
638         // The address of the owner.
639         address addr;
640         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
641         uint64 startTimestamp;
642         // Whether the token has been burned.
643         bool burned;
644     }
645 
646     // Compiler will pack this into a single 256bit word.
647     struct AddressData {
648         // Realistically, 2**64-1 is more than enough.
649         uint64 balance;
650         // Keeps track of mint count with minimal overhead for tokenomics.
651         uint64 numberMinted;
652         // Keeps track of burn count with minimal overhead for tokenomics.
653         uint64 numberBurned;
654         // For miscellaneous variable(s) pertaining to the address
655         // (e.g. number of whitelist mint slots used).
656         // If there are multiple variables, please pack them into a uint64.
657         uint64 aux;
658     }
659 
660     // The tokenId of the next token to be minted.
661     uint256 internal _currentIndex;
662 
663     // The number of tokens burned.
664     uint256 internal _burnCounter;
665 
666     // Token name
667     string private _name;
668 
669     // Token symbol
670     string private _symbol;
671 
672     // Mapping from token ID to ownership details
673     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
674     mapping(uint256 => TokenOwnership) internal _ownerships;
675 
676     // Mapping owner address to address data
677     mapping(address => AddressData) private _addressData;
678 
679     // Mapping from token ID to approved address
680     mapping(uint256 => address) private _tokenApprovals;
681 
682     // Mapping from owner to operator approvals
683     mapping(address => mapping(address => bool)) private _operatorApprovals;
684 
685     constructor(string memory name_, string memory symbol_) {
686         _name = name_;
687         _symbol = symbol_;
688         _currentIndex = _startTokenId();
689     }
690 
691     /**
692      * To change the starting tokenId, please override this function.
693      */
694     function _startTokenId() internal view virtual returns (uint256) {
695         return 0;
696     }
697 
698     /**
699      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
700      */
701     function totalSupply() public view returns (uint256) {
702         // Counter underflow is impossible as _burnCounter cannot be incremented
703         // more than _currentIndex - _startTokenId() times
704         unchecked {
705             return _currentIndex - _burnCounter - _startTokenId();
706         }
707     }
708 
709     /**
710      * Returns the total amount of tokens minted in the contract.
711      */
712     function _totalMinted() internal view returns (uint256) {
713         // Counter underflow is impossible as _currentIndex does not decrement,
714         // and it is initialized to _startTokenId()
715         unchecked {
716             return _currentIndex - _startTokenId();
717         }
718     }
719 
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
724         return
725             interfaceId == type(IERC721).interfaceId ||
726             interfaceId == type(IERC721Metadata).interfaceId ||
727             super.supportsInterface(interfaceId);
728     }
729 
730     /**
731      * @dev See {IERC721-balanceOf}.
732      */
733     function balanceOf(address owner) public view override returns (uint256) {
734         if (owner == address(0)) revert BalanceQueryForZeroAddress();
735         return uint256(_addressData[owner].balance);
736     }
737 
738     /**
739      * Returns the number of tokens minted by `owner`.
740      */
741     function _numberMinted(address owner) internal view returns (uint256) {
742         return uint256(_addressData[owner].numberMinted);
743     }
744 
745     /**
746      * Returns the number of tokens burned by or on behalf of `owner`.
747      */
748     function _numberBurned(address owner) internal view returns (uint256) {
749         return uint256(_addressData[owner].numberBurned);
750     }
751 
752     /**
753      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
754      */
755     function _getAux(address owner) internal view returns (uint64) {
756         return _addressData[owner].aux;
757     }
758 
759     /**
760      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
761      * If there are multiple variables, please pack them into a uint64.
762      */
763     function _setAux(address owner, uint64 aux) internal {
764         _addressData[owner].aux = aux;
765     }
766 
767     /**
768      * Gas spent here starts off proportional to the maximum mint batch size.
769      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
770      */
771     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
772         uint256 curr = tokenId;
773 
774         unchecked {
775             if (_startTokenId() <= curr && curr < _currentIndex) {
776                 TokenOwnership memory ownership = _ownerships[curr];
777                 if (!ownership.burned) {
778                     if (ownership.addr != address(0)) {
779                         return ownership;
780                     }
781                     // Invariant:
782                     // There will always be an ownership that has an address and is not burned
783                     // before an ownership that does not have an address and is not burned.
784                     // Hence, curr will not underflow.
785                     while (true) {
786                         curr--;
787                         ownership = _ownerships[curr];
788                         if (ownership.addr != address(0)) {
789                             return ownership;
790                         }
791                     }
792                 }
793             }
794         }
795         revert OwnerQueryForNonexistentToken();
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId) public view override returns (address) {
802         return _ownershipOf(tokenId).addr;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
824 
825         string memory baseURI = _baseURI();
826         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, can be overriden in child contracts.
833      */
834     function _baseURI() internal view virtual returns (string memory) {
835         return '';
836     }
837 
838     /**
839      * @dev See {IERC721-approve}.
840      */
841     function approve(address to, uint256 tokenId) public virtual override {
842         address owner = ERC721A.ownerOf(tokenId);
843         if (to == owner) revert ApprovalToCurrentOwner();
844 
845         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
846             revert ApprovalCallerNotOwnerNorApproved();
847         }
848 
849         _approve(to, tokenId, owner);
850     }
851 
852     /**
853      * @dev See {IERC721-getApproved}.
854      */
855     function getApproved(uint256 tokenId) public view override returns (address) {
856         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
857 
858         return _tokenApprovals[tokenId];
859     }
860 
861     /**
862      * @dev See {IERC721-setApprovalForAll}.
863      */
864     function setApprovalForAll(address operator, bool approved) public virtual override {
865         if (operator == _msgSender()) revert ApproveToCaller();
866 
867         _operatorApprovals[_msgSender()][operator] = approved;
868         emit ApprovalForAll(_msgSender(), operator, approved);
869     }
870 
871     /**
872      * @dev See {IERC721-isApprovedForAll}.
873      */
874     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
875         return _operatorApprovals[owner][operator];
876     }
877 
878     /**
879      * @dev See {IERC721-transferFrom}.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         _transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         safeTransferFrom(from, to, tokenId, '');
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) public virtual override {
909         _transfer(from, to, tokenId);
910         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
911             revert TransferToNonERC721ReceiverImplementer();
912         }
913     }
914 
915     /**
916      * @dev Returns whether `tokenId` exists.
917      *
918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
919      *
920      * Tokens start existing when they are minted (`_mint`),
921      */
922     function _exists(uint256 tokenId) internal view returns (bool) {
923         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
924             !_ownerships[tokenId].burned;
925     }
926 
927     function _safeMint(address to, uint256 quantity) internal {
928         _safeMint(to, quantity, '');
929     }
930 
931     /**
932      * @dev Safely mints `quantity` tokens and transfers them to `to`.
933      *
934      * Requirements:
935      *
936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
937      * - `quantity` must be greater than 0.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeMint(
942         address to,
943         uint256 quantity,
944         bytes memory _data
945     ) internal {
946         _mint(to, quantity, _data, true);
947     }
948 
949     /**
950      * @dev Mints `quantity` tokens and transfers them to `to`.
951      *
952      * Requirements:
953      *
954      * - `to` cannot be the zero address.
955      * - `quantity` must be greater than 0.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _mint(
960         address to,
961         uint256 quantity,
962         bytes memory _data,
963         bool safe
964     ) internal {
965         uint256 startTokenId = _currentIndex;
966         if (to == address(0)) revert MintToZeroAddress();
967         if (quantity == 0) revert MintZeroQuantity();
968 
969         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
970 
971         // Overflows are incredibly unrealistic.
972         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
973         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
974         unchecked {
975             _addressData[to].balance += uint64(quantity);
976             _addressData[to].numberMinted += uint64(quantity);
977 
978             _ownerships[startTokenId].addr = to;
979             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
980 
981             uint256 updatedIndex = startTokenId;
982             uint256 end = updatedIndex + quantity;
983 
984             if (safe && to.isContract()) {
985                 do {
986                     emit Transfer(address(0), to, updatedIndex);
987                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
988                         revert TransferToNonERC721ReceiverImplementer();
989                     }
990                 } while (updatedIndex != end);
991                 // Reentrancy protection
992                 if (_currentIndex != startTokenId) revert();
993             } else {
994                 do {
995                     emit Transfer(address(0), to, updatedIndex++);
996                 } while (updatedIndex != end);
997             }
998             _currentIndex = updatedIndex;
999         }
1000         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1001     }
1002 
1003     /**
1004      * @dev Transfers `tokenId` from `from` to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must be owned by `from`.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _transfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) private {
1018         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1019 
1020         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1021 
1022         bool isApprovedOrOwner = (_msgSender() == from ||
1023             isApprovedForAll(from, _msgSender()) ||
1024             getApproved(tokenId) == _msgSender());
1025 
1026         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1027         if (to == address(0)) revert TransferToZeroAddress();
1028 
1029         _beforeTokenTransfers(from, to, tokenId, 1);
1030 
1031         // Clear approvals from the previous owner
1032         _approve(address(0), tokenId, from);
1033 
1034         // Underflow of the sender's balance is impossible because we check for
1035         // ownership above and the recipient's balance can't realistically overflow.
1036         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1037         unchecked {
1038             _addressData[from].balance -= 1;
1039             _addressData[to].balance += 1;
1040 
1041             TokenOwnership storage currSlot = _ownerships[tokenId];
1042             currSlot.addr = to;
1043             currSlot.startTimestamp = uint64(block.timestamp);
1044 
1045             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1046             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1047             uint256 nextTokenId = tokenId + 1;
1048             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1049             if (nextSlot.addr == address(0)) {
1050                 // This will suffice for checking _exists(nextTokenId),
1051                 // as a burned slot cannot contain the zero address.
1052                 if (nextTokenId != _currentIndex) {
1053                     nextSlot.addr = from;
1054                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1055                 }
1056             }
1057         }
1058 
1059         emit Transfer(from, to, tokenId);
1060         _afterTokenTransfers(from, to, tokenId, 1);
1061     }
1062 
1063     /**
1064      * @dev This is equivalent to _burn(tokenId, false)
1065      */
1066     function _burn(uint256 tokenId) internal virtual {
1067         _burn(tokenId, false);
1068     }
1069 
1070     /**
1071      * @dev Destroys `tokenId`.
1072      * The approval is cleared when the token is burned.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1081         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1082 
1083         address from = prevOwnership.addr;
1084 
1085         if (approvalCheck) {
1086             bool isApprovedOrOwner = (_msgSender() == from ||
1087                 isApprovedForAll(from, _msgSender()) ||
1088                 getApproved(tokenId) == _msgSender());
1089 
1090             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1091         }
1092 
1093         _beforeTokenTransfers(from, address(0), tokenId, 1);
1094 
1095         // Clear approvals from the previous owner
1096         _approve(address(0), tokenId, from);
1097 
1098         // Underflow of the sender's balance is impossible because we check for
1099         // ownership above and the recipient's balance can't realistically overflow.
1100         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1101         unchecked {
1102             AddressData storage addressData = _addressData[from];
1103             addressData.balance -= 1;
1104             addressData.numberBurned += 1;
1105 
1106             // Keep track of who burned the token, and the timestamp of burning.
1107             TokenOwnership storage currSlot = _ownerships[tokenId];
1108             currSlot.addr = from;
1109             currSlot.startTimestamp = uint64(block.timestamp);
1110             currSlot.burned = true;
1111 
1112             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1113             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1114             uint256 nextTokenId = tokenId + 1;
1115             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1116             if (nextSlot.addr == address(0)) {
1117                 // This will suffice for checking _exists(nextTokenId),
1118                 // as a burned slot cannot contain the zero address.
1119                 if (nextTokenId != _currentIndex) {
1120                     nextSlot.addr = from;
1121                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1122                 }
1123             }
1124         }
1125 
1126         emit Transfer(from, address(0), tokenId);
1127         _afterTokenTransfers(from, address(0), tokenId, 1);
1128 
1129         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1130         unchecked {
1131             _burnCounter++;
1132         }
1133     }
1134 
1135     /**
1136      * @dev Approve `to` to operate on `tokenId`
1137      *
1138      * Emits a {Approval} event.
1139      */
1140     function _approve(
1141         address to,
1142         uint256 tokenId,
1143         address owner
1144     ) private {
1145         _tokenApprovals[tokenId] = to;
1146         emit Approval(owner, to, tokenId);
1147     }
1148 
1149     /**
1150      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1151      *
1152      * @param from address representing the previous owner of the given token ID
1153      * @param to target address that will receive the tokens
1154      * @param tokenId uint256 ID of the token to be transferred
1155      * @param _data bytes optional data to send along with the call
1156      * @return bool whether the call correctly returned the expected magic value
1157      */
1158     function _checkContractOnERC721Received(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) private returns (bool) {
1164         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1165             return retval == IERC721Receiver(to).onERC721Received.selector;
1166         } catch (bytes memory reason) {
1167             if (reason.length == 0) {
1168                 revert TransferToNonERC721ReceiverImplementer();
1169             } else {
1170                 assembly {
1171                     revert(add(32, reason), mload(reason))
1172                 }
1173             }
1174         }
1175     }
1176 
1177     /**
1178      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1179      * And also called before burning one token.
1180      *
1181      * startTokenId - the first token id to be transferred
1182      * quantity - the amount to be transferred
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, `tokenId` will be burned by `from`.
1190      * - `from` and `to` are never both zero.
1191      */
1192     function _beforeTokenTransfers(
1193         address from,
1194         address to,
1195         uint256 startTokenId,
1196         uint256 quantity
1197     ) internal virtual {}
1198 
1199     /**
1200      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1201      * minting.
1202      * And also called after one token has been burned.
1203      *
1204      * startTokenId - the first token id to be transferred
1205      * quantity - the amount to be transferred
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` has been minted for `to`.
1212      * - When `to` is zero, `tokenId` has been burned by `from`.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _afterTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 }
1222 
1223 abstract contract Ownable is Context {
1224     address private _owner;
1225 
1226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1227 
1228     /**
1229      * @dev Initializes the contract setting the deployer as the initial owner.
1230      */
1231     constructor() {
1232         _transferOwnership(_msgSender());
1233     }
1234 
1235     /**
1236      * @dev Returns the address of the current owner.
1237      */
1238     function owner() public view virtual returns (address) {
1239         return _owner;
1240     }
1241 
1242     /**
1243      * @dev Throws if called by any account other than the owner.
1244      */
1245     modifier onlyOwner() {
1246         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1247         _;
1248     }
1249 
1250     /**
1251      * @dev Leaves the contract without owner. It will not be possible to call
1252      * `onlyOwner` functions anymore. Can only be called by the current owner.
1253      *
1254      * NOTE: Renouncing ownership will leave the contract without an owner,
1255      * thereby removing any functionality that is only available to the owner.
1256      */
1257     function renounceOwnership() public virtual onlyOwner {
1258         _transferOwnership(address(0));
1259     }
1260 
1261     /**
1262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1263      * Can only be called by the current owner.
1264      */
1265     function transferOwnership(address newOwner) public virtual onlyOwner {
1266         require(newOwner != address(0), "Ownable: new owner is the zero address");
1267         _transferOwnership(newOwner);
1268     }
1269 
1270     /**
1271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1272      * Internal function without access restriction.
1273      */
1274     function _transferOwnership(address newOwner) internal virtual {
1275         address oldOwner = _owner;
1276         _owner = newOwner;
1277         emit OwnershipTransferred(oldOwner, newOwner);
1278     }
1279 }
1280 
1281 interface IOperatorFilterRegistry {
1282     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1283     function register(address registrant) external;
1284     function registerAndSubscribe(address registrant, address subscription) external;
1285     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1286     function unregister(address addr) external;
1287     function updateOperator(address registrant, address operator, bool filtered) external;
1288     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1289     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1290     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1291     function subscribe(address registrant, address registrantToSubscribe) external;
1292     function unsubscribe(address registrant, bool copyExistingEntries) external;
1293     function subscriptionOf(address addr) external returns (address registrant);
1294     function subscribers(address registrant) external returns (address[] memory);
1295     function subscriberAt(address registrant, uint256 index) external returns (address);
1296     function copyEntriesOf(address registrant, address registrantToCopy) external;
1297     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1298     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1299     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1300     function filteredOperators(address addr) external returns (address[] memory);
1301     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1302     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1303     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1304     function isRegistered(address addr) external returns (bool);
1305     function codeHashOf(address addr) external returns (bytes32);
1306 }
1307 
1308 /**
1309  * @title  OperatorFilterer
1310  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1311  *         registrant's entries in the OperatorFilterRegistry.
1312  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1313  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1314  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1315  */
1316 abstract contract OperatorFilterer {
1317     error OperatorNotAllowed(address operator);
1318 
1319     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1320         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1321 
1322     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1323         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1324         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1325         // order for the modifier to filter addresses.
1326         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1327             if (subscribe) {
1328                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1329             } else {
1330                 if (subscriptionOrRegistrantToCopy != address(0)) {
1331                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1332                 } else {
1333                     OPERATOR_FILTER_REGISTRY.register(address(this));
1334                 }
1335             }
1336         }
1337     }
1338 
1339     modifier onlyAllowedOperator(address from) virtual {
1340         // Allow spending tokens from addresses with balance
1341         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1342         // from an EOA.
1343         if (from != msg.sender) {
1344             _checkFilterOperator(msg.sender);
1345         }
1346         _;
1347     }
1348 
1349     modifier onlyAllowedOperatorApproval(address operator) virtual {
1350         _checkFilterOperator(operator);
1351         _;
1352     }
1353 
1354     function _checkFilterOperator(address operator) internal view virtual {
1355         // Check registry code length to facilitate testing in environments without a deployed registry.
1356         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1357             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1358                 revert OperatorNotAllowed(operator);
1359             }
1360         }
1361     }
1362 }
1363 
1364 /**
1365  * @title  DefaultOperatorFilterer
1366  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1367  */
1368 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1369     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1370 
1371     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1372 }
1373 
1374 
1375 pragma solidity ^0.8.7;
1376     
1377 contract GBYC is DefaultOperatorFilterer, ERC721A, Ownable {
1378     using Strings for uint256;
1379 
1380 
1381   string private uriPrefix ;
1382   string private uriSuffix = ".json";
1383   string public hiddenURL;
1384 
1385   
1386   
1387 
1388   uint256 public cost = 0.0055 ether;
1389  
1390   
1391 
1392   uint16 public maxSupply = 1800;
1393   uint8 public maxMintAmountPerTx = 5;
1394   uint8 public maxFreeMintAmountPerWallet = 1;
1395                                                              
1396  
1397   bool public paused = true;
1398   bool public reveal =false;
1399 
1400    mapping (address => uint8) public NFTPerPublicAddress;
1401 
1402  
1403   
1404   
1405  
1406   
1407 
1408   constructor() ERC721A("Grumpy Bear Yacht Club", "GBYC") {
1409   }
1410 
1411 
1412   
1413  
1414   function mint(uint8 _mintAmount) external payable  {
1415      uint16 totalSupply = uint16(totalSupply());
1416      uint8 nft = NFTPerPublicAddress[msg.sender];
1417     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1418     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1419 
1420     require(!paused, "The contract is paused!");
1421     
1422       if(nft >= maxFreeMintAmountPerWallet)
1423     {
1424     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1425     }
1426     else {
1427          uint8 costAmount = _mintAmount + nft;
1428         if(costAmount > maxFreeMintAmountPerWallet)
1429        {
1430         costAmount = costAmount - maxFreeMintAmountPerWallet;
1431         require(msg.value >= cost * costAmount, "Insufficient funds!");
1432        }
1433        
1434          
1435     }
1436     
1437 
1438 
1439     _safeMint(msg.sender , _mintAmount);
1440 
1441     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1442      
1443      delete totalSupply;
1444      delete _mintAmount;
1445   }
1446   
1447   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1448      uint16 totalSupply = uint16(totalSupply());
1449     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1450      _safeMint(_receiver , _mintAmount);
1451      delete _mintAmount;
1452      delete _receiver;
1453      delete totalSupply;
1454   }
1455 
1456   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1457      uint16 totalSupply = uint16(totalSupply());
1458      uint totalAmount =   _amountPerAddress * addresses.length;
1459     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1460      for (uint256 i = 0; i < addresses.length; i++) {
1461             _safeMint(addresses[i], _amountPerAddress);
1462         }
1463 
1464      delete _amountPerAddress;
1465      delete totalSupply;
1466   }
1467 
1468  
1469 
1470   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1471       maxSupply = _maxSupply;
1472   }
1473 
1474 
1475 
1476    
1477   function tokenURI(uint256 _tokenId)
1478     public
1479     view
1480     virtual
1481     override
1482     returns (string memory)
1483   {
1484     require(
1485       _exists(_tokenId),
1486       "ERC721Metadata: URI query for nonexistent token"
1487     );
1488     
1489   
1490 if ( reveal == false)
1491 {
1492     return hiddenURL;
1493 }
1494     
1495 
1496     string memory currentBaseURI = _baseURI();
1497     return bytes(currentBaseURI).length > 0
1498         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1499         : "";
1500   }
1501  
1502  
1503 
1504 
1505  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1506     maxFreeMintAmountPerWallet = _limit;
1507    delete _limit;
1508 
1509 }
1510 
1511     
1512   
1513 
1514   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1515     uriPrefix = _uriPrefix;
1516   }
1517    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1518     hiddenURL = _uriPrefix;
1519   }
1520 
1521 
1522   function setPaused() external onlyOwner {
1523     paused = !paused;
1524    
1525   }
1526 
1527   function setCost(uint _cost) external onlyOwner{
1528       cost = _cost;
1529 
1530   }
1531 
1532  function setRevealed() external onlyOwner{
1533      reveal = !reveal;
1534  }
1535 
1536   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1537       maxMintAmountPerTx = _maxtx;
1538 
1539   }
1540 
1541  
1542 
1543   function withdraw() external onlyOwner {
1544   uint _balance = address(this).balance;
1545      payable(msg.sender).transfer(_balance ); 
1546        
1547   }
1548 
1549 
1550   function _baseURI() internal view  override returns (string memory) {
1551     return uriPrefix;
1552   }
1553 
1554   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1555     super.setApprovalForAll(operator, approved);
1556   }
1557 
1558   function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1559     super.approve(operator, tokenId);
1560   }
1561 
1562   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1563     super.transferFrom(from, to, tokenId);
1564   }
1565 
1566   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1567     super.safeTransferFrom(from, to, tokenId);
1568   }
1569 
1570   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1571     public
1572     override
1573     onlyAllowedOperator(from)
1574   {
1575     super.safeTransferFrom(from, to, tokenId, data);
1576   }
1577 }