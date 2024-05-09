1 /**
2 .___________. __    __   _______         ___      .______          ___      .______        _______.
3 |           ||  |  |  | |   ____|       /   \     |   _  \        /   \     |   _  \      /       |
4 `---|  |----`|  |__|  | |  |__         /  ^  \    |  |_)  |      /  ^  \    |  |_)  |    |   (----`
5     |  |     |   __   | |   __|       /  /_\  \   |      /      /  /_\  \   |   _  <      \   \    
6     |  |     |  |  |  | |  |____     /  _____  \  |  |\  \----./  _____  \  |  |_)  | .----)   |   
7     |__|     |__|  |__| |_______|   /__/     \__\ | _| `._____/__/     \__\ |______/  |_______/                                                                                                       
8 */
9 // @author divergence.xyz
10 // SPDX-License-Identifier: MIT 
11 // File: @openzeppelin/contracts/utils/Strings.sol
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
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Implementation of the {IERC165} interface.
372  *
373  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
374  * for the additional interface id that will be supported. For example:
375  *
376  * ```solidity
377  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
379  * }
380  * ```
381  *
382  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
383  */
384 abstract contract ERC165 is IERC165 {
385     /**
386      * @dev See {IERC165-supportsInterface}.
387      */
388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Required interface of an ERC721 compliant contract.
403  */
404 interface IERC721 is IERC165 {
405     /**
406      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
412      */
413     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
417      */
418     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
419 
420     /**
421      * @dev Returns the number of tokens in ``owner``'s account.
422      */
423     function balanceOf(address owner) external view returns (uint256 balance);
424 
425     /**
426      * @dev Returns the owner of the `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function ownerOf(uint256 tokenId) external view returns (address owner);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
436      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must exist and be owned by `from`.
443      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
444      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
445      *
446      * Emits a {Transfer} event.
447      */
448     function safeTransferFrom(
449         address from,
450         address to,
451         uint256 tokenId
452     ) external;
453 
454     /**
455      * @dev Transfers `tokenId` token from `from` to `to`.
456      *
457      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must be owned by `from`.
464      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
465      *
466      * Emits a {Transfer} event.
467      */
468     function transferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
476      * The approval is cleared when the token is transferred.
477      *
478      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
479      *
480      * Requirements:
481      *
482      * - The caller must own the token or be an approved operator.
483      * - `tokenId` must exist.
484      *
485      * Emits an {Approval} event.
486      */
487     function approve(address to, uint256 tokenId) external;
488 
489     /**
490      * @dev Returns the account approved for `tokenId` token.
491      *
492      * Requirements:
493      *
494      * - `tokenId` must exist.
495      */
496     function getApproved(uint256 tokenId) external view returns (address operator);
497 
498     /**
499      * @dev Approve or remove `operator` as an operator for the caller.
500      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
501      *
502      * Requirements:
503      *
504      * - The `operator` cannot be the caller.
505      *
506      * Emits an {ApprovalForAll} event.
507      */
508     function setApprovalForAll(address operator, bool _approved) external;
509 
510     /**
511      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
512      *
513      * See {setApprovalForAll}
514      */
515     function isApprovedForAll(address owner, address operator) external view returns (bool);
516 
517     /**
518      * @dev Safely transfers `tokenId` token from `from` to `to`.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must exist and be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
527      *
528      * Emits a {Transfer} event.
529      */
530     function safeTransferFrom(
531         address from,
532         address to,
533         uint256 tokenId,
534         bytes calldata data
535     ) external;
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Metadata is IERC721 {
551     /**
552      * @dev Returns the token collection name.
553      */
554     function name() external view returns (string memory);
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() external view returns (string memory);
560 
561     /**
562      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
563      */
564     function tokenURI(uint256 tokenId) external view returns (string memory);
565 }
566 
567 // File: @openzeppelin/contracts/utils/Context.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Provides information about the current execution context, including the
576  * sender of the transaction and its data. While these are generally available
577  * via msg.sender and msg.data, they should not be accessed in such a direct
578  * manner, since when dealing with meta-transactions the account sending and
579  * paying for execution may not be the actual sender (as far as an application
580  * is concerned).
581  *
582  * This contract is only required for intermediate, library-like contracts.
583  */
584 abstract contract Context {
585     function _msgSender() internal view virtual returns (address) {
586         return msg.sender;
587     }
588 
589     function _msgData() internal view virtual returns (bytes calldata) {
590         return msg.data;
591     }
592 }
593 
594 // File: erc721a/contracts/ERC721A.sol
595 
596 
597 // Creator: Chiru Labs
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
841     function approve(address to, uint256 tokenId) public override {
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
923         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
924     }
925 
926     function _safeMint(address to, uint256 quantity) internal {
927         _safeMint(to, quantity, '');
928     }
929 
930     /**
931      * @dev Safely mints `quantity` tokens and transfers them to `to`.
932      *
933      * Requirements:
934      *
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
936      * - `quantity` must be greater than 0.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeMint(
941         address to,
942         uint256 quantity,
943         bytes memory _data
944     ) internal {
945         _mint(to, quantity, _data, true);
946     }
947 
948     /**
949      * @dev Mints `quantity` tokens and transfers them to `to`.
950      *
951      * Requirements:
952      *
953      * - `to` cannot be the zero address.
954      * - `quantity` must be greater than 0.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _mint(
959         address to,
960         uint256 quantity,
961         bytes memory _data,
962         bool safe
963     ) internal {
964         uint256 startTokenId = _currentIndex;
965         if (to == address(0)) revert MintToZeroAddress();
966         if (quantity == 0) revert MintZeroQuantity();
967 
968         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
969 
970         // Overflows are incredibly unrealistic.
971         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
972         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
973         unchecked {
974             _addressData[to].balance += uint64(quantity);
975             _addressData[to].numberMinted += uint64(quantity);
976 
977             _ownerships[startTokenId].addr = to;
978             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
979 
980             uint256 updatedIndex = startTokenId;
981             uint256 end = updatedIndex + quantity;
982 
983             if (safe && to.isContract()) {
984                 do {
985                     emit Transfer(address(0), to, updatedIndex);
986                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
987                         revert TransferToNonERC721ReceiverImplementer();
988                     }
989                 } while (updatedIndex != end);
990                 // Reentrancy protection
991                 if (_currentIndex != startTokenId) revert();
992             } else {
993                 do {
994                     emit Transfer(address(0), to, updatedIndex++);
995                 } while (updatedIndex != end);
996             }
997             _currentIndex = updatedIndex;
998         }
999         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1000     }
1001 
1002     /**
1003      * @dev Transfers `tokenId` from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) private {
1017         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1018 
1019         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1020 
1021         bool isApprovedOrOwner = (_msgSender() == from ||
1022             isApprovedForAll(from, _msgSender()) ||
1023             getApproved(tokenId) == _msgSender());
1024 
1025         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1026         if (to == address(0)) revert TransferToZeroAddress();
1027 
1028         _beforeTokenTransfers(from, to, tokenId, 1);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId, from);
1032 
1033         // Underflow of the sender's balance is impossible because we check for
1034         // ownership above and the recipient's balance can't realistically overflow.
1035         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1036         unchecked {
1037             _addressData[from].balance -= 1;
1038             _addressData[to].balance += 1;
1039 
1040             TokenOwnership storage currSlot = _ownerships[tokenId];
1041             currSlot.addr = to;
1042             currSlot.startTimestamp = uint64(block.timestamp);
1043 
1044             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1045             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1046             uint256 nextTokenId = tokenId + 1;
1047             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1048             if (nextSlot.addr == address(0)) {
1049                 // This will suffice for checking _exists(nextTokenId),
1050                 // as a burned slot cannot contain the zero address.
1051                 if (nextTokenId != _currentIndex) {
1052                     nextSlot.addr = from;
1053                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1054                 }
1055             }
1056         }
1057 
1058         emit Transfer(from, to, tokenId);
1059         _afterTokenTransfers(from, to, tokenId, 1);
1060     }
1061 
1062     /**
1063      * @dev This is equivalent to _burn(tokenId, false)
1064      */
1065     function _burn(uint256 tokenId) internal virtual {
1066         _burn(tokenId, false);
1067     }
1068 
1069     /**
1070      * @dev Destroys `tokenId`.
1071      * The approval is cleared when the token is burned.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1080         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1081 
1082         address from = prevOwnership.addr;
1083 
1084         if (approvalCheck) {
1085             bool isApprovedOrOwner = (_msgSender() == from ||
1086                 isApprovedForAll(from, _msgSender()) ||
1087                 getApproved(tokenId) == _msgSender());
1088 
1089             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1090         }
1091 
1092         _beforeTokenTransfers(from, address(0), tokenId, 1);
1093 
1094         // Clear approvals from the previous owner
1095         _approve(address(0), tokenId, from);
1096 
1097         // Underflow of the sender's balance is impossible because we check for
1098         // ownership above and the recipient's balance can't realistically overflow.
1099         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1100         unchecked {
1101             AddressData storage addressData = _addressData[from];
1102             addressData.balance -= 1;
1103             addressData.numberBurned += 1;
1104 
1105             // Keep track of who burned the token, and the timestamp of burning.
1106             TokenOwnership storage currSlot = _ownerships[tokenId];
1107             currSlot.addr = from;
1108             currSlot.startTimestamp = uint64(block.timestamp);
1109             currSlot.burned = true;
1110 
1111             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1112             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1113             uint256 nextTokenId = tokenId + 1;
1114             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1115             if (nextSlot.addr == address(0)) {
1116                 // This will suffice for checking _exists(nextTokenId),
1117                 // as a burned slot cannot contain the zero address.
1118                 if (nextTokenId != _currentIndex) {
1119                     nextSlot.addr = from;
1120                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1121                 }
1122             }
1123         }
1124 
1125         emit Transfer(from, address(0), tokenId);
1126         _afterTokenTransfers(from, address(0), tokenId, 1);
1127 
1128         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1129         unchecked {
1130             _burnCounter++;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Approve `to` to operate on `tokenId`
1136      *
1137      * Emits a {Approval} event.
1138      */
1139     function _approve(
1140         address to,
1141         uint256 tokenId,
1142         address owner
1143     ) private {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(owner, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1150      *
1151      * @param from address representing the previous owner of the given token ID
1152      * @param to target address that will receive the tokens
1153      * @param tokenId uint256 ID of the token to be transferred
1154      * @param _data bytes optional data to send along with the call
1155      * @return bool whether the call correctly returned the expected magic value
1156      */
1157     function _checkContractOnERC721Received(
1158         address from,
1159         address to,
1160         uint256 tokenId,
1161         bytes memory _data
1162     ) private returns (bool) {
1163         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1164             return retval == IERC721Receiver(to).onERC721Received.selector;
1165         } catch (bytes memory reason) {
1166             if (reason.length == 0) {
1167                 revert TransferToNonERC721ReceiverImplementer();
1168             } else {
1169                 assembly {
1170                     revert(add(32, reason), mload(reason))
1171                 }
1172             }
1173         }
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1178      * And also called before burning one token.
1179      *
1180      * startTokenId - the first token id to be transferred
1181      * quantity - the amount to be transferred
1182      *
1183      * Calling conditions:
1184      *
1185      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1186      * transferred to `to`.
1187      * - When `from` is zero, `tokenId` will be minted for `to`.
1188      * - When `to` is zero, `tokenId` will be burned by `from`.
1189      * - `from` and `to` are never both zero.
1190      */
1191     function _beforeTokenTransfers(
1192         address from,
1193         address to,
1194         uint256 startTokenId,
1195         uint256 quantity
1196     ) internal virtual {}
1197 
1198     /**
1199      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1200      * minting.
1201      * And also called after one token has been burned.
1202      *
1203      * startTokenId - the first token id to be transferred
1204      * quantity - the amount to be transferred
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` has been minted for `to`.
1211      * - When `to` is zero, `tokenId` has been burned by `from`.
1212      * - `from` and `to` are never both zero.
1213      */
1214     function _afterTokenTransfers(
1215         address from,
1216         address to,
1217         uint256 startTokenId,
1218         uint256 quantity
1219     ) internal virtual {}
1220 }
1221 
1222 // File: @openzeppelin/contracts/access/Ownable.sol
1223 
1224 
1225 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1226 
1227 pragma solidity ^0.8.0;
1228 
1229 
1230 /**
1231  * @dev Contract module which provides a basic access control mechanism, where
1232  * there is an account (an owner) that can be granted exclusive access to
1233  * specific functions.
1234  *
1235  * By default, the owner account will be the one that deploys the contract. This
1236  * can later be changed with {transferOwnership}.
1237  *
1238  * This module is used through inheritance. It will make available the modifier
1239  * `onlyOwner`, which can be applied to your functions to restrict their use to
1240  * the owner.
1241  */
1242 abstract contract Ownable is Context {
1243     address private _owner;
1244 
1245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1246 
1247     /**
1248      * @dev Initializes the contract setting the deployer as the initial owner.
1249      */
1250     constructor() {
1251         _transferOwnership(_msgSender());
1252     }
1253 
1254     /**
1255      * @dev Returns the address of the current owner.
1256      */
1257     function owner() public view virtual returns (address) {
1258         return _owner;
1259     }
1260 
1261     /**
1262      * @dev Throws if called by any account other than the owner.
1263      */
1264     modifier onlyOwner() {
1265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1266         _;
1267     }
1268 
1269     /**
1270      * @dev Leaves the contract without owner. It will not be possible to call
1271      * `onlyOwner` functions anymore. Can only be called by the current owner.
1272      *
1273      * NOTE: Renouncing ownership will leave the contract without an owner,
1274      * thereby removing any functionality that is only available to the owner.
1275      */
1276     function renounceOwnership() public virtual onlyOwner {
1277         _transferOwnership(address(0));
1278     }
1279 
1280     /**
1281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1282      * Can only be called by the current owner.
1283      */
1284     function transferOwnership(address newOwner) public virtual onlyOwner {
1285         require(newOwner != address(0), "Ownable: new owner is the zero address");
1286         _transferOwnership(newOwner);
1287     }
1288 
1289     /**
1290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1291      * Internal function without access restriction.
1292      */
1293     function _transferOwnership(address newOwner) internal virtual {
1294         address oldOwner = _owner;
1295         _owner = newOwner;
1296         emit OwnershipTransferred(oldOwner, newOwner);
1297     }
1298 }
1299 
1300 // File: contracts/TheArabs.sol
1301 
1302 
1303 pragma solidity >=0.8.0 <0.9.0;
1304 
1305 
1306 
1307 
1308 
1309 contract TheArabs is ERC721A, Ownable { 
1310 
1311   using Strings for uint256;
1312 
1313   string public uriPrefix = "ipfs://Qmbuh4zu93c4U6dzyT6bdiosi1sPoq7zStuxmbcjgmoYsH/";
1314   string public uriSuffix = ".json"; 
1315   string public hiddenMetadataUri;
1316   
1317   uint256 public cost = 0.003 ether; 
1318 
1319   uint256 public maxSupply = 5555; 
1320   uint256 public maxMintAmountPerTx = 10; 
1321   uint256 public totalMaxMintAmount = 11; 
1322 
1323   uint256 public freeMaxMintAmount = 1; 
1324 
1325   bool public paused = true;
1326   bool public publicSale = false;
1327   bool public revealed = true;
1328 
1329   mapping(address => uint256) public addressMintedBalance; 
1330 
1331   constructor() ERC721A("TheArabs", "Arabs") { 
1332         setHiddenMetadataUri("ipfs://__CID__/hidden.json"); 
1333             ownerMint(50); 
1334     } 
1335 
1336   // MODIFIERS 
1337   
1338   modifier mintCompliance(uint256 _mintAmount) {
1339     if (msg.sender != owner()) { 
1340         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1341     }
1342     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1343     _;
1344   } 
1345 
1346   modifier mintPriceCompliance(uint256 _mintAmount) {
1347     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1348    if (ownerMintedCount >= freeMaxMintAmount) {
1349         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1350    }
1351         _;
1352   }
1353 
1354   // MINTS 
1355 
1356    function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1357     require(!paused, 'The contract is paused!'); 
1358     require(publicSale, "Not open to public yet!");
1359     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1360 
1361     if (ownerMintedCount < freeMaxMintAmount) {  
1362             require(ownerMintedCount + _mintAmount <= freeMaxMintAmount, "Exceeded Free Mint Limit");
1363         } else if (ownerMintedCount >= freeMaxMintAmount) { 
1364             require(ownerMintedCount + _mintAmount <= totalMaxMintAmount, "Exceeded Mint Limit");
1365         }
1366 
1367     _safeMint(_msgSender(), _mintAmount);
1368     for (uint256 i = 1; i <=_mintAmount; i++){
1369         addressMintedBalance[msg.sender]++;
1370     }
1371   }
1372 
1373   function ownerMint(uint256 _mintAmount) public payable onlyOwner {
1374      require(_mintAmount > 0, 'Invalid mint amount!');
1375      require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1376     _safeMint(_msgSender(), _mintAmount);
1377   }
1378 
1379 function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1380     _safeMint(_receiver, _mintAmount);
1381   }
1382   
1383   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1384     uint256 ownerTokenCount = balanceOf(_owner);
1385     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1386     uint256 currentTokenId = _startTokenId();
1387     uint256 ownedTokenIndex = 0;
1388     address latestOwnerAddress;
1389 
1390     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1391       TokenOwnership memory ownership = _ownerships[currentTokenId];
1392 
1393       if (!ownership.burned && ownership.addr != address(0)) {
1394         latestOwnerAddress = ownership.addr;
1395       }
1396 
1397       if (latestOwnerAddress == _owner) {
1398         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1399 
1400         ownedTokenIndex++;
1401       }
1402 
1403       currentTokenId++;
1404     }
1405 
1406     return ownedTokenIds;
1407   }
1408 
1409   function _startTokenId() internal view virtual override returns (uint256) {
1410     return 1;
1411   }
1412 
1413   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1414     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1415 
1416     if (revealed == false) {
1417       return hiddenMetadataUri;
1418     }
1419 
1420     string memory currentBaseURI = _baseURI();
1421     return bytes(currentBaseURI).length > 0
1422         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1423         : '';
1424   }
1425 
1426   function setRevealed(bool _state) public onlyOwner {
1427     revealed = _state;
1428   }
1429 
1430   function setCost(uint256 _cost) public onlyOwner {
1431     cost = _cost; 
1432   }
1433 
1434    function setFreeMaxMintAmount(uint256 _freeMaxMintAmount) public onlyOwner {
1435     freeMaxMintAmount = _freeMaxMintAmount; 
1436   }
1437 
1438   function setTotalMaxMintAmount(uint _amount) public onlyOwner {
1439       require(_amount <= maxSupply, "Exceed total amount");
1440       totalMaxMintAmount = _amount;
1441   }
1442 
1443   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1444     maxMintAmountPerTx = _maxMintAmountPerTx;
1445   }
1446 
1447   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1448     hiddenMetadataUri = _hiddenMetadataUri;
1449   }
1450 
1451   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1452     uriPrefix = _uriPrefix;
1453   }
1454 
1455   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1456     uriSuffix = _uriSuffix;
1457   }
1458 
1459   function setPaused(bool _state) public onlyOwner {
1460     paused = _state;
1461   }
1462 
1463   function setPublicSale(bool _state) public onlyOwner {
1464     publicSale = _state;
1465   }
1466 
1467   // WITHDRAW
1468     function withdraw() public payable onlyOwner {
1469   
1470     (bool os, ) = payable(owner()).call{value: address(this).balance}(""); 
1471     require(os);
1472    
1473   }
1474 
1475   function _baseURI() internal view virtual override returns (string memory) {
1476     return uriPrefix;
1477   }
1478 }