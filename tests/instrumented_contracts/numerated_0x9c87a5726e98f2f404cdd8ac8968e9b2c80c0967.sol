1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
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
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
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
292                 /// @solidity memory-safe-assembly
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
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
396 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
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
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Transfers `tokenId` token from `from` to `to`.
476      *
477      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
496      * The approval is cleared when the token is transferred.
497      *
498      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
499      *
500      * Requirements:
501      *
502      * - The caller must own the token or be an approved operator.
503      * - `tokenId` must exist.
504      *
505      * Emits an {Approval} event.
506      */
507     function approve(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
594 // File: contracts/ERC721L.sol
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
632 contract ERC721L is Context, ERC165, IERC721, IERC721Metadata {
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
695         return 1;
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
842         address owner = ERC721L.ownerOf(tokenId);
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
926     /**
927      * @dev Equivalent to `_safeMint(to, quantity, '')`.
928      */
929     function _safeMint(address to, uint256 quantity) internal {
930         _safeMint(to, quantity, '');
931     }
932 
933     /**
934      * @dev Safely mints `quantity` tokens and transfers them to `to`.
935      *
936      * Requirements:
937      *
938      * - If `to` refers to a smart contract, it must implement 
939      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
940      * - `quantity` must be greater than 0.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _safeMint(
945         address to,
946         uint256 quantity,
947         bytes memory _data
948     ) internal {
949         uint256 startTokenId = _currentIndex;
950         if (to == address(0)) revert MintToZeroAddress();
951         if (quantity == 0) revert MintZeroQuantity();
952 
953         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
954 
955         // Overflows are incredibly unrealistic.
956         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
957         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
958         unchecked {
959             _addressData[to].balance += uint64(quantity);
960             _addressData[to].numberMinted += uint64(quantity);
961 
962             _ownerships[startTokenId].addr = to;
963             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
964 
965             uint256 updatedIndex = startTokenId;
966             uint256 end = updatedIndex + quantity;
967 
968             if (to.isContract()) {
969                 do {
970                     emit Transfer(address(0), to, updatedIndex);
971                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
972                         revert TransferToNonERC721ReceiverImplementer();
973                     }
974                 } while (updatedIndex != end);
975                 // Reentrancy protection
976                 if (_currentIndex != startTokenId) revert();
977             } else {
978                 do {
979                     emit Transfer(address(0), to, updatedIndex++);
980                 } while (updatedIndex != end);
981             }
982             _currentIndex = updatedIndex;
983         }
984         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
997     function _mint(address to, uint256 quantity) internal {
998         uint256 startTokenId = _currentIndex;
999         if (to == address(0)) revert MintToZeroAddress();
1000         if (quantity == 0) revert MintZeroQuantity();
1001 
1002         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1003 
1004         // Overflows are incredibly unrealistic.
1005         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1006         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1007         unchecked {
1008             _addressData[to].balance += uint64(quantity);
1009             _addressData[to].numberMinted += uint64(quantity);
1010 
1011             _ownerships[startTokenId].addr = to;
1012             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1013 
1014             uint256 updatedIndex = startTokenId;
1015             uint256 end = updatedIndex + quantity;
1016 
1017             do {
1018                 emit Transfer(address(0), to, updatedIndex++);
1019             } while (updatedIndex != end);
1020 
1021             _currentIndex = updatedIndex;
1022         }
1023         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1024     }
1025 
1026     /**
1027      * @dev Transfers `tokenId` from `from` to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) private {
1041         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1042 
1043         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1044 
1045         bool isApprovedOrOwner = (_msgSender() == from ||
1046             isApprovedForAll(from, _msgSender()) ||
1047             getApproved(tokenId) == _msgSender());
1048 
1049         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1050         if (to == address(0)) revert TransferToZeroAddress();
1051 
1052         _beforeTokenTransfers(from, to, tokenId, 1);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId, from);
1056 
1057         // Underflow of the sender's balance is impossible because we check for
1058         // ownership above and the recipient's balance can't realistically overflow.
1059         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1060         unchecked {
1061             _addressData[from].balance -= 1;
1062             _addressData[to].balance += 1;
1063 
1064             TokenOwnership storage currSlot = _ownerships[tokenId];
1065             currSlot.addr = to;
1066             currSlot.startTimestamp = uint64(block.timestamp);
1067 
1068             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1069             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1070             uint256 nextTokenId = tokenId + 1;
1071             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1072             if (nextSlot.addr == address(0)) {
1073                 // This will suffice for checking _exists(nextTokenId),
1074                 // as a burned slot cannot contain the zero address.
1075                 if (nextTokenId != _currentIndex) {
1076                     nextSlot.addr = from;
1077                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1078                 }
1079             }
1080         }
1081 
1082         emit Transfer(from, to, tokenId);
1083         _afterTokenTransfers(from, to, tokenId, 1);
1084     }
1085 
1086     /**
1087      * @dev Equivalent to `_burn(tokenId, false)`.
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         _burn(tokenId, false);
1091     }
1092 
1093     /**
1094      * @dev Destroys `tokenId`.
1095      * The approval is cleared when the token is burned.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1104         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1105 
1106         address from = prevOwnership.addr;
1107 
1108         if (approvalCheck) {
1109             bool isApprovedOrOwner = (_msgSender() == from ||
1110                 isApprovedForAll(from, _msgSender()) ||
1111                 getApproved(tokenId) == _msgSender());
1112 
1113             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1114         }
1115 
1116         _beforeTokenTransfers(from, address(0), tokenId, 1);
1117 
1118         // Clear approvals from the previous owner
1119         _approve(address(0), tokenId, from);
1120 
1121         // Underflow of the sender's balance is impossible because we check for
1122         // ownership above and the recipient's balance can't realistically overflow.
1123         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1124         unchecked {
1125             AddressData storage addressData = _addressData[from];
1126             addressData.balance -= 1;
1127             addressData.numberBurned += 1;
1128 
1129             // Keep track of who burned the token, and the timestamp of burning.
1130             TokenOwnership storage currSlot = _ownerships[tokenId];
1131             currSlot.addr = from;
1132             currSlot.startTimestamp = uint64(block.timestamp);
1133             currSlot.burned = true;
1134 
1135             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1136             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1137             uint256 nextTokenId = tokenId + 1;
1138             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1139             if (nextSlot.addr == address(0)) {
1140                 // This will suffice for checking _exists(nextTokenId),
1141                 // as a burned slot cannot contain the zero address.
1142                 if (nextTokenId != _currentIndex) {
1143                     nextSlot.addr = from;
1144                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1145                 }
1146             }
1147         }
1148 
1149         emit Transfer(from, address(0), tokenId);
1150         _afterTokenTransfers(from, address(0), tokenId, 1);
1151 
1152         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1153         unchecked {
1154             _burnCounter++;
1155         }
1156     }
1157 
1158     /**
1159      * @dev Approve `to` to operate on `tokenId`
1160      *
1161      * Emits a {Approval} event.
1162      */
1163     function _approve(
1164         address to,
1165         uint256 tokenId,
1166         address owner
1167     ) private {
1168         _tokenApprovals[tokenId] = to;
1169         emit Approval(owner, to, tokenId);
1170     }
1171 
1172     /**
1173      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1174      *
1175      * @param from address representing the previous owner of the given token ID
1176      * @param to target address that will receive the tokens
1177      * @param tokenId uint256 ID of the token to be transferred
1178      * @param _data bytes optional data to send along with the call
1179      * @return bool whether the call correctly returned the expected magic value
1180      */
1181     function _checkContractOnERC721Received(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) private returns (bool) {
1187         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1188             return retval == IERC721Receiver(to).onERC721Received.selector;
1189         } catch (bytes memory reason) {
1190             if (reason.length == 0) {
1191                 revert TransferToNonERC721ReceiverImplementer();
1192             } else {
1193                 assembly {
1194                     revert(add(32, reason), mload(reason))
1195                 }
1196             }
1197         }
1198     }
1199 
1200     /**
1201      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1202      * And also called before burning one token.
1203      *
1204      * startTokenId - the first token id to be transferred
1205      * quantity - the amount to be transferred
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` will be minted for `to`.
1212      * - When `to` is zero, `tokenId` will be burned by `from`.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _beforeTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 
1222     /**
1223      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1224      * minting.
1225      * And also called after one token has been burned.
1226      *
1227      * startTokenId - the first token id to be transferred
1228      * quantity - the amount to be transferred
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` has been minted for `to`.
1235      * - When `to` is zero, `tokenId` has been burned by `from`.
1236      * - `from` and `to` are never both zero.
1237      */
1238     function _afterTokenTransfers(
1239         address from,
1240         address to,
1241         uint256 startTokenId,
1242         uint256 quantity
1243     ) internal virtual {}
1244     
1245 }
1246 // File: @openzeppelin/contracts/access/Ownable.sol
1247 
1248 
1249 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 
1254 /**
1255  * @dev Contract module which provides a basic access control mechanism, where
1256  * there is an account (an owner) that can be granted exclusive access to
1257  * specific functions.
1258  *
1259  * By default, the owner account will be the one that deploys the contract. This
1260  * can later be changed with {transferOwnership}.
1261  *
1262  * This module is used through inheritance. It will make available the modifier
1263  * `onlyOwner`, which can be applied to your functions to restrict their use to
1264  * the owner.
1265  */
1266 abstract contract Ownable is Context {
1267     address private _owner;
1268 
1269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1270 
1271     /**
1272      * @dev Initializes the contract setting the deployer as the initial owner.
1273      */
1274     constructor() {
1275         _transferOwnership(_msgSender());
1276     }
1277 
1278     /**
1279      * @dev Throws if called by any account other than the owner.
1280      */
1281     modifier onlyOwner() {
1282         _checkOwner();
1283         _;
1284     }
1285 
1286     /**
1287      * @dev Returns the address of the current owner.
1288      */
1289     function owner() public view virtual returns (address) {
1290         return _owner;
1291     }
1292 
1293     /**
1294      * @dev Throws if the sender is not the owner.
1295      */
1296     function _checkOwner() internal view virtual {
1297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1298     }
1299 
1300     /**
1301      * @dev Leaves the contract without owner. It will not be possible to call
1302      * `onlyOwner` functions anymore. Can only be called by the current owner.
1303      *
1304      * NOTE: Renouncing ownership will leave the contract without an owner,
1305      * thereby removing any functionality that is only available to the owner.
1306      */
1307     function renounceOwnership() public virtual onlyOwner {
1308         _transferOwnership(address(0));
1309     }
1310 
1311     /**
1312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1313      * Can only be called by the current owner.
1314      */
1315     function transferOwnership(address newOwner) public virtual onlyOwner {
1316         require(newOwner != address(0), "Ownable: new owner is the zero address");
1317         _transferOwnership(newOwner);
1318     }
1319 
1320     /**
1321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1322      * Internal function without access restriction.
1323      */
1324     function _transferOwnership(address newOwner) internal virtual {
1325         address oldOwner = _owner;
1326         _owner = newOwner;
1327         emit OwnershipTransferred(oldOwner, newOwner);
1328     }
1329 }
1330 
1331 // File: contracts/luckytiger.sol
1332 
1333 
1334 pragma solidity ^0.8.16;
1335 
1336 
1337     /**
1338      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1339      */
1340 contract luckytiger is ERC721L, Ownable {
1341     using Strings for uint256;
1342     string prizeTokenURI;
1343     string baseTokenURI;
1344     address public withdrawAddress = 0x511604E18d63D32ac2605B5f0aF0cF580D21FA49;
1345     bool public pauseMint;
1346     bool lucky;
1347     uint256 public price = 0.01 * 10 ** 18;
1348     uint public constant maxTotal = 1000;
1349     event NEWLucky(uint256 _tokenId, bool lucky);
1350     mapping(address => bool) whiteLists;
1351     mapping(uint256 => bool) tokenId_luckys;
1352     /**
1353      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1354      */
1355     constructor(string memory _prizeTokenURI, string memory _baseTokenURI)  
1356      ERC721L("luckytiger", "LT")  {
1357         prizeTokenURI = _prizeTokenURI;
1358         baseTokenURI = _baseTokenURI;
1359     }
1360     /**
1361      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1362      */ 
1363     function setWhiteLists(address[] calldata to)public onlyOwner {
1364        for(uint32 i = 0; i < to.length; i++){
1365            address _user = to[i];
1366            whiteLists[_user] = true;}
1367     }
1368     function removeWhitelistUser(address _user) public onlyOwner {
1369         whiteLists[_user] = false;
1370     }
1371     function isWhiteList(address _user)public view returns(bool){
1372         return whiteLists[_user];
1373     }
1374     /**
1375      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1376      */
1377     function setMintPrice(uint256 _price) public onlyOwner {
1378         price = _price;
1379     } 
1380     function setPauseMint() public onlyOwner {
1381         pauseMint = !pauseMint;
1382     }
1383     /**
1384      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1385      */
1386     function addBonusPool()public payable{
1387     }
1388     function isPrize(uint256 tokenId) public view returns (bool){
1389         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1390         return tokenId_luckys[tokenId];
1391     }
1392     /**
1393      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1394      */
1395     function freeMint(address _user) public {
1396         uint256 supply = totalSupply(); 
1397         require(!pauseMint, "Pause mint");
1398         require(whiteLists[_user], "Not whiteLists user");
1399         require(supply + 1 <= maxTotal, "Exceeds maximum supply");
1400         _safeMint(msg.sender, 1);
1401         whiteLists[_user] = false;
1402         bool randLucky = _getRandom();
1403         uint256 tokenId = _totalMinted();
1404         emit NEWLucky(tokenId, randLucky);
1405         tokenId_luckys[tokenId] = lucky;
1406         if(tokenId_luckys[tokenId] == true){
1407         require(payable(msg.sender).send((price * 95) / 100));
1408         require(payable(withdrawAddress).send((price * 5) / 100));}
1409     }
1410     /**
1411      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1412      */
1413     function publicMint() public payable {
1414         uint256 supply = totalSupply();
1415         require(!pauseMint, "Pause mint");
1416         require(msg.value >= price, "Ether sent is not correct");
1417         require(supply + 1 <= maxTotal, "Exceeds maximum supply");
1418         _safeMint(msg.sender, 1);
1419         bool randLucky = _getRandom();
1420         uint256 tokenId = _totalMinted();
1421         emit NEWLucky(tokenId, randLucky);
1422         tokenId_luckys[tokenId] = lucky;
1423         if(tokenId_luckys[tokenId] == true){
1424         require(payable(msg.sender).send((price * 190) / 100));
1425         require(payable(withdrawAddress).send((price * 10) / 100));}
1426     }
1427     /**
1428      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1429      */
1430     function withdraw() public onlyOwner {
1431         require(payable(withdrawAddress).send(address(this).balance));
1432     } 
1433     /**
1434      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1435      */  
1436     function _getRandom() private returns(bool) {
1437         uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
1438         uint256 rand = random%2;
1439         if(rand == 0){return lucky = false;}
1440         else         {return lucky = true;}
1441     }
1442     /**
1443      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1444      */
1445     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1446      require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1447       if(tokenId_luckys[tokenId]) {
1448             return string(abi.encodePacked(prizeTokenURI, Strings.toString(tokenId), ".json"));}
1449       else {
1450           return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId), ".json"));}
1451     }
1452     /**
1453      * lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！ lucky！
1454      */
1455 }