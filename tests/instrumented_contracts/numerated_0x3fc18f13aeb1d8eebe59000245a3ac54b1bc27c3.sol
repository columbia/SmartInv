1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.1;
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
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  * from ERC721 asset contracts.
168  */
169 interface IERC721Receiver {
170     /**
171      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
172      * by `operator` from `from`, this function is called.
173      *
174      * It must return its Solidity selector to confirm the token transfer.
175      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
176      *
177      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
178      */
179     function onERC721Received(
180         address operator,
181         address from,
182         uint256 tokenId,
183         bytes calldata data
184     ) external returns (bytes4);
185 }
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192     /**
193      * @dev Returns the token collection name.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the token collection symbol.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
204      */
205     function tokenURI(uint256 tokenId) external view returns (string memory);
206 }
207 
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Enumerable is IERC721 {
214     /**
215      * @dev Returns the total amount of tokens stored by the contract.
216      */
217     function totalSupply() external view returns (uint256);
218 
219     /**
220      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
221      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
222      */
223     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
224 
225     /**
226      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
227      * Use along with {totalSupply} to enumerate all tokens.
228      */
229     function tokenByIndex(uint256 index) external view returns (uint256);
230 }
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      *
253      * [IMPORTANT]
254      * ====
255      * You shouldn't rely on `isContract` to protect against flash loan attacks!
256      *
257      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
258      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
259      * constructor.
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize/address.code.length, which returns 0
264         // for contracts in construction, since the code is only stored at the end
265         // of the constructor execution.
266 
267         return account.code.length > 0;
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         (bool success, ) = recipient.call{value: amount}("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain `call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         require(isContract(target), "Address: call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.call{value: value}(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal view returns (bytes memory) {
388         require(isContract(target), "Address: static call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(isContract(target), "Address: delegate call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.delegatecall(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
423      * revert reason using the provided one.
424      *
425      * _Available since v4.3._
426      */
427     function verifyCallResult(
428         bool success,
429         bytes memory returndata,
430         string memory errorMessage
431     ) internal pure returns (bytes memory) {
432         if (success) {
433             return returndata;
434         } else {
435             // Look for revert reason and bubble it up if present
436             if (returndata.length > 0) {
437                 // The easiest way to bubble the revert reason is using memory via assembly
438 
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 
451 /**
452  * @dev Provides information about the current execution context, including the
453  * sender of the transaction and its data. While these are generally available
454  * via msg.sender and msg.data, they should not be accessed in such a direct
455  * manner, since when dealing with meta-transactions the account sending and
456  * paying for execution may not be the actual sender (as far as an application
457  * is concerned).
458  *
459  * This contract is only required for intermediate, library-like contracts.
460  */
461 abstract contract Context {
462     function _msgSender() internal view virtual returns (address) {
463         return msg.sender;
464     }
465 
466     function _msgData() internal view virtual returns (bytes calldata) {
467         return msg.data;
468     }
469 }
470 
471 /**
472  * @dev String operations.
473  */
474 library Strings {
475     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
479      */
480     function toString(uint256 value) internal pure returns (string memory) {
481         // Inspired by OraclizeAPI's implementation - MIT licence
482         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
483 
484         if (value == 0) {
485             return "0";
486         }
487         uint256 temp = value;
488         uint256 digits;
489         while (temp != 0) {
490             digits++;
491             temp /= 10;
492         }
493         bytes memory buffer = new bytes(digits);
494         while (value != 0) {
495             digits -= 1;
496             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
497             value /= 10;
498         }
499         return string(buffer);
500     }
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
504      */
505     function toHexString(uint256 value) internal pure returns (string memory) {
506         if (value == 0) {
507             return "0x00";
508         }
509         uint256 temp = value;
510         uint256 length = 0;
511         while (temp != 0) {
512             length++;
513             temp >>= 8;
514         }
515         return toHexString(value, length);
516     }
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
520      */
521     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
522         bytes memory buffer = new bytes(2 * length + 2);
523         buffer[0] = "0";
524         buffer[1] = "x";
525         for (uint256 i = 2 * length + 1; i > 1; --i) {
526             buffer[i] = _HEX_SYMBOLS[value & 0xf];
527             value >>= 4;
528         }
529         require(value == 0, "Strings: hex length insufficient");
530         return string(buffer);
531     }
532 }
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * ```solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * ```
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 
558 
559 
560 
561 error ApprovalCallerNotOwnerNorApproved();
562 error ApprovalQueryForNonexistentToken();
563 error ApproveToCaller();
564 error ApprovalToCurrentOwner();
565 error BalanceQueryForZeroAddress();
566 error MintedQueryForZeroAddress();
567 error BurnedQueryForZeroAddress();
568 error MintToZeroAddress();
569 error MintZeroQuantity();
570 error OwnerIndexOutOfBounds();
571 error OwnerQueryForNonexistentToken();
572 error TokenIndexOutOfBounds();
573 error TransferCallerNotOwnerNorApproved();
574 error TransferFromIncorrectOwner();
575 error TransferToNonERC721ReceiverImplementer();
576 error TransferToZeroAddress();
577 error URIQueryForNonexistentToken();
578 
579 /**
580  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
581  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
582  *
583  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
584  *
585  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
586  *
587  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
588  */
589 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
590     using Address for address;
591     using Strings for uint256;
592 
593     // Compiler will pack this into a single 256bit word.
594     struct TokenOwnership {
595         // The address of the owner.
596         address addr;
597         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
598         uint64 startTimestamp;
599         // Whether the token has been burned.
600         bool burned;
601     }
602 
603     // Compiler will pack this into a single 256bit word.
604     struct AddressData {
605         // Realistically, 2**64-1 is more than enough.
606         uint64 balance;
607         // Keeps track of mint count with minimal overhead for tokenomics.
608         uint64 numberMinted;
609         // Keeps track of burn count with minimal overhead for tokenomics.
610         uint64 numberBurned;
611     }
612 
613     // Compiler will pack the following 
614     // _currentIndex and _burnCounter into a single 256bit word.
615     
616     // The tokenId of the next token to be minted.
617     uint128 internal _currentIndex;
618 
619     // The number of tokens burned.
620     uint128 internal _burnCounter;
621 
622     // Token name
623     string private _name;
624 
625     // Token symbol
626     string private _symbol;
627 
628     // Mapping from token ID to ownership details
629     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
630     mapping(uint256 => TokenOwnership) internal _ownerships;
631 
632     // Mapping owner address to address data
633     mapping(address => AddressData) private _addressData;
634 
635     // Mapping from token ID to approved address
636     mapping(uint256 => address) private _tokenApprovals;
637 
638     // Mapping from owner to operator approvals
639     mapping(address => mapping(address => bool)) private _operatorApprovals;
640 
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
644     }
645 
646     /**
647      * @dev See {IERC721Enumerable-totalSupply}.
648      */
649     function totalSupply() public view override returns (uint256) {
650         // Counter underflow is impossible as _burnCounter cannot be incremented
651         // more than _currentIndex times
652         unchecked {
653             return _currentIndex - _burnCounter;    
654         }
655     }
656 
657     /**
658      * @dev See {IERC721Enumerable-tokenByIndex}.
659      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
660      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
661      */
662     function tokenByIndex(uint256 index) public view override returns (uint256) {
663         uint256 numMintedSoFar = _currentIndex;
664         uint256 tokenIdsIdx;
665 
666         // Counter overflow is impossible as the loop breaks when
667         // uint256 i is equal to another uint256 numMintedSoFar.
668         unchecked {
669             for (uint256 i; i < numMintedSoFar; i++) {
670                 TokenOwnership memory ownership = _ownerships[i];
671                 if (!ownership.burned) {
672                     if (tokenIdsIdx == index) {
673                         return i;
674                     }
675                     tokenIdsIdx++;
676                 }
677             }
678         }
679         revert TokenIndexOutOfBounds();
680     }
681 
682     /**
683      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
684      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
685      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
686      */
687     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
688         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
689         uint256 numMintedSoFar = _currentIndex;
690         uint256 tokenIdsIdx;
691         address currOwnershipAddr;
692 
693         // Counter overflow is impossible as the loop breaks when
694         // uint256 i is equal to another uint256 numMintedSoFar.
695         unchecked {
696             for (uint256 i; i < numMintedSoFar; i++) {
697                 TokenOwnership memory ownership = _ownerships[i];
698                 if (ownership.burned) {
699                     continue;
700                 }
701                 if (ownership.addr != address(0)) {
702                     currOwnershipAddr = ownership.addr;
703                 }
704                 if (currOwnershipAddr == owner) {
705                     if (tokenIdsIdx == index) {
706                         return i;
707                     }
708                     tokenIdsIdx++;
709                 }
710             }
711         }
712 
713         // Execution should never reach this point.
714         revert();
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
721         return
722             interfaceId == type(IERC721).interfaceId ||
723             interfaceId == type(IERC721Metadata).interfaceId ||
724             interfaceId == type(IERC721Enumerable).interfaceId ||
725             super.supportsInterface(interfaceId);
726     }
727 
728     /**
729      * @dev See {IERC721-balanceOf}.
730      */
731     function balanceOf(address owner) public view override returns (uint256) {
732         if (owner == address(0)) revert BalanceQueryForZeroAddress();
733         return uint256(_addressData[owner].balance);
734     }
735 
736     function _numberMinted(address owner) internal view returns (uint256) {
737         if (owner == address(0)) revert MintedQueryForZeroAddress();
738         return uint256(_addressData[owner].numberMinted);
739     }
740 
741     function _numberBurned(address owner) internal view returns (uint256) {
742         if (owner == address(0)) revert BurnedQueryForZeroAddress();
743         return uint256(_addressData[owner].numberBurned);
744     }
745 
746     /**
747      * Gas spent here starts off proportional to the maximum mint batch size.
748      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
749      */
750     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
751         uint256 curr = tokenId;
752 
753         unchecked {
754             if (curr < _currentIndex) {
755                 TokenOwnership memory ownership = _ownerships[curr];
756                 if (!ownership.burned) {
757                     if (ownership.addr != address(0)) {
758                         return ownership;
759                     }
760                     // Invariant: 
761                     // There will always be an ownership that has an address and is not burned 
762                     // before an ownership that does not have an address and is not burned.
763                     // Hence, curr will not underflow.
764                     while (true) {
765                         curr--;
766                         ownership = _ownerships[curr];
767                         if (ownership.addr != address(0)) {
768                             return ownership;
769                         }
770                     }
771                 }
772             }
773         }
774         revert OwnerQueryForNonexistentToken();
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view override returns (address) {
781         return ownershipOf(tokenId).addr;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-name}.
786      */
787     function name() public view virtual override returns (string memory) {
788         return _name;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-symbol}.
793      */
794     function symbol() public view virtual override returns (string memory) {
795         return _symbol;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-tokenURI}.
800      */
801     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
802         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
803 
804         string memory baseURI = _baseURI();
805         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
806     }
807 
808     /**
809      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
810      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
811      * by default, can be overriden in child contracts.
812      */
813     function _baseURI() internal view virtual returns (string memory) {
814         return '';
815     }
816 
817     /**
818      * @dev See {IERC721-approve}.
819      */
820     function approve(address to, uint256 tokenId) public override {
821         address owner = ERC721A.ownerOf(tokenId);
822         if (to == owner) revert ApprovalToCurrentOwner();
823 
824         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
825             revert ApprovalCallerNotOwnerNorApproved();
826         }
827 
828         _approve(to, tokenId, owner);
829     }
830 
831     /**
832      * @dev See {IERC721-getApproved}.
833      */
834     function getApproved(uint256 tokenId) public view override returns (address) {
835         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
836 
837         return _tokenApprovals[tokenId];
838     }
839 
840     /**
841      * @dev See {IERC721-setApprovalForAll}.
842      */
843     function setApprovalForAll(address operator, bool approved) public override {
844         if (operator == _msgSender()) revert ApproveToCaller();
845 
846         _operatorApprovals[_msgSender()][operator] = approved;
847         emit ApprovalForAll(_msgSender(), operator, approved);
848     }
849 
850     /**
851      * @dev See {IERC721-isApprovedForAll}.
852      */
853     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
854         return _operatorApprovals[owner][operator];
855     }
856 
857     /**
858      * @dev See {IERC721-transferFrom}.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         _transfer(from, to, tokenId);
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) public virtual override {
876         safeTransferFrom(from, to, tokenId, '');
877     }
878 
879     /**
880      * @dev See {IERC721-safeTransferFrom}.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) public virtual override {
888         _transfer(from, to, tokenId);
889         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
890             revert TransferToNonERC721ReceiverImplementer();
891         }
892     }
893 
894     /**
895      * @dev Returns whether `tokenId` exists.
896      *
897      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
898      *
899      * Tokens start existing when they are minted (`_mint`),
900      */
901     function _exists(uint256 tokenId) internal view returns (bool) {
902         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
903     }
904 
905     function _safeMint(address to, uint256 quantity) internal {
906         _safeMint(to, quantity, '');
907     }
908 
909     /**
910      * @dev Safely mints `quantity` tokens and transfers them to `to`.
911      *
912      * Requirements:
913      *
914      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
915      * - `quantity` must be greater than 0.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeMint(
920         address to,
921         uint256 quantity,
922         bytes memory _data
923     ) internal {
924         _mint(to, quantity, _data, true);
925     }
926 
927     /**
928      * @dev Mints `quantity` tokens and transfers them to `to`.
929      *
930      * Requirements:
931      *
932      * - `to` cannot be the zero address.
933      * - `quantity` must be greater than 0.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _mint(
938         address to,
939         uint256 quantity,
940         bytes memory _data,
941         bool safe
942     ) internal {
943         uint256 startTokenId = _currentIndex;
944         if (to == address(0)) revert MintToZeroAddress();
945         if (quantity == 0) revert MintZeroQuantity();
946 
947         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
948 
949         // Overflows are incredibly unrealistic.
950         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
951         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
952         unchecked {
953             _addressData[to].balance += uint64(quantity);
954             _addressData[to].numberMinted += uint64(quantity);
955 
956             _ownerships[startTokenId].addr = to;
957             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
958 
959             uint256 updatedIndex = startTokenId;
960 
961             for (uint256 i; i < quantity; i++) {
962                 emit Transfer(address(0), to, updatedIndex);
963                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
964                     revert TransferToNonERC721ReceiverImplementer();
965                 }
966                 updatedIndex++;
967             }
968 
969             _currentIndex = uint128(updatedIndex);
970         }
971         _afterTokenTransfers(address(0), to, startTokenId, quantity);
972     }
973 
974     /**
975      * @dev Transfers `tokenId` from `from` to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must be owned by `from`.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _transfer(
985         address from,
986         address to,
987         uint256 tokenId
988     ) private {
989         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
990 
991         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
992             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
993             getApproved(tokenId) == _msgSender());
994 
995         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
996         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
997         if (to == address(0)) revert TransferToZeroAddress();
998 
999         _beforeTokenTransfers(from, to, tokenId, 1);
1000 
1001         // Clear approvals from the previous owner
1002         _approve(address(0), tokenId, prevOwnership.addr);
1003 
1004         // Underflow of the sender's balance is impossible because we check for
1005         // ownership above and the recipient's balance can't realistically overflow.
1006         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1007         unchecked {
1008             _addressData[from].balance -= 1;
1009             _addressData[to].balance += 1;
1010 
1011             _ownerships[tokenId].addr = to;
1012             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1013 
1014             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1015             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1016             uint256 nextTokenId = tokenId + 1;
1017             if (_ownerships[nextTokenId].addr == address(0)) {
1018                 // This will suffice for checking _exists(nextTokenId),
1019                 // as a burned slot cannot contain the zero address.
1020                 if (nextTokenId < _currentIndex) {
1021                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1022                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1023                 }
1024             }
1025         }
1026 
1027         emit Transfer(from, to, tokenId);
1028         _afterTokenTransfers(from, to, tokenId, 1);
1029     }
1030 
1031     /**
1032      * @dev Destroys `tokenId`.
1033      * The approval is cleared when the token is burned.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _burn(uint256 tokenId) internal virtual {
1042         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1043 
1044         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1045 
1046         // Clear approvals from the previous owner
1047         _approve(address(0), tokenId, prevOwnership.addr);
1048 
1049         // Underflow of the sender's balance is impossible because we check for
1050         // ownership above and the recipient's balance can't realistically overflow.
1051         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1052         unchecked {
1053             _addressData[prevOwnership.addr].balance -= 1;
1054             _addressData[prevOwnership.addr].numberBurned += 1;
1055 
1056             // Keep track of who burned the token, and the timestamp of burning.
1057             _ownerships[tokenId].addr = prevOwnership.addr;
1058             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1059             _ownerships[tokenId].burned = true;
1060 
1061             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1062             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063             uint256 nextTokenId = tokenId + 1;
1064             if (_ownerships[nextTokenId].addr == address(0)) {
1065                 // This will suffice for checking _exists(nextTokenId),
1066                 // as a burned slot cannot contain the zero address.
1067                 if (nextTokenId < _currentIndex) {
1068                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1069                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1070                 }
1071             }
1072         }
1073 
1074         emit Transfer(prevOwnership.addr, address(0), tokenId);
1075         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1076 
1077         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1078         unchecked { 
1079             _burnCounter++;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Approve `to` to operate on `tokenId`
1085      *
1086      * Emits a {Approval} event.
1087      */
1088     function _approve(
1089         address to,
1090         uint256 tokenId,
1091         address owner
1092     ) private {
1093         _tokenApprovals[tokenId] = to;
1094         emit Approval(owner, to, tokenId);
1095     }
1096 
1097     /**
1098      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1099      * The call is not executed if the target address is not a contract.
1100      *
1101      * @param from address representing the previous owner of the given token ID
1102      * @param to target address that will receive the tokens
1103      * @param tokenId uint256 ID of the token to be transferred
1104      * @param _data bytes optional data to send along with the call
1105      * @return bool whether the call correctly returned the expected magic value
1106      */
1107     function _checkOnERC721Received(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) private returns (bool) {
1113         if (to.isContract()) {
1114             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1115                 return retval == IERC721Receiver(to).onERC721Received.selector;
1116             } catch (bytes memory reason) {
1117                 if (reason.length == 0) {
1118                     revert TransferToNonERC721ReceiverImplementer();
1119                 } else {
1120                     assembly {
1121                         revert(add(32, reason), mload(reason))
1122                     }
1123                 }
1124             }
1125         } else {
1126             return true;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1132      * And also called before burning one token.
1133      *
1134      * startTokenId - the first token id to be transferred
1135      * quantity - the amount to be transferred
1136      *
1137      * Calling conditions:
1138      *
1139      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1140      * transferred to `to`.
1141      * - When `from` is zero, `tokenId` will be minted for `to`.
1142      * - When `to` is zero, `tokenId` will be burned by `from`.
1143      * - `from` and `to` are never both zero.
1144      */
1145     function _beforeTokenTransfers(
1146         address from,
1147         address to,
1148         uint256 startTokenId,
1149         uint256 quantity
1150     ) internal virtual {}
1151 
1152     /**
1153      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1154      * minting.
1155      * And also called after one token has been burned.
1156      *
1157      * startTokenId - the first token id to be transferred
1158      * quantity - the amount to be transferred
1159      *
1160      * Calling conditions:
1161      *
1162      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1163      * transferred to `to`.
1164      * - When `from` is zero, `tokenId` has been minted for `to`.
1165      * - When `to` is zero, `tokenId` has been burned by `from`.
1166      * - `from` and `to` are never both zero.
1167      */
1168     function _afterTokenTransfers(
1169         address from,
1170         address to,
1171         uint256 startTokenId,
1172         uint256 quantity
1173     ) internal virtual {}
1174 }
1175 
1176 
1177 /**
1178  * @dev Contract module which provides a basic access control mechanism, where
1179  * there is an account (an owner) that can be granted exclusive access to
1180  * specific functions.
1181  *
1182  * By default, the owner account will be the one that deploys the contract. This
1183  * can later be changed with {transferOwnership}.
1184  *
1185  * This module is used through inheritance. It will make available the modifier
1186  * `onlyOwner`, which can be applied to your functions to restrict their use to
1187  * the owner.
1188  */
1189 abstract contract Ownable is Context {
1190     address private _owner;
1191 
1192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1193 
1194     /**
1195      * @dev Initializes the contract setting the deployer as the initial owner.
1196      */
1197     constructor() {
1198         _transferOwnership(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns the address of the current owner.
1203      */
1204     function owner() public view virtual returns (address) {
1205         return _owner;
1206     }
1207 
1208     /**
1209      * @dev Throws if called by any account other than the owner.
1210      */
1211     modifier onlyOwner() {
1212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1213         _;
1214     }
1215 
1216     /**
1217      * @dev Leaves the contract without owner. It will not be possible to call
1218      * `onlyOwner` functions anymore. Can only be called by the current owner.
1219      *
1220      * NOTE: Renouncing ownership will leave the contract without an owner,
1221      * thereby removing any functionality that is only available to the owner.
1222      */
1223     function renounceOwnership() public virtual onlyOwner {
1224         _transferOwnership(address(0));
1225     }
1226 
1227     /**
1228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1229      * Can only be called by the current owner.
1230      */
1231     function transferOwnership(address newOwner) public virtual onlyOwner {
1232         require(newOwner != address(0), "Ownable: new owner is the zero address");
1233         _transferOwnership(newOwner);
1234     }
1235 
1236     /**
1237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1238      * Internal function without access restriction.
1239      */
1240     function _transferOwnership(address newOwner) internal virtual {
1241         address oldOwner = _owner;
1242         _owner = newOwner;
1243         emit OwnershipTransferred(oldOwner, newOwner);
1244     }
1245 }
1246 
1247 
1248 // CAUTION
1249 // This version of SafeMath should only be used with Solidity 0.8 or later,
1250 // because it relies on the compiler's built in overflow checks.
1251 
1252 /**
1253  * @dev Wrappers over Solidity's arithmetic operations.
1254  *
1255  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1256  * now has built in overflow checking.
1257  */
1258 library SafeMath {
1259     /**
1260      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1261      *
1262      * _Available since v3.4._
1263      */
1264     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1265         unchecked {
1266             uint256 c = a + b;
1267             if (c < a) return (false, 0);
1268             return (true, c);
1269         }
1270     }
1271 
1272     /**
1273      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1274      *
1275      * _Available since v3.4._
1276      */
1277     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1278         unchecked {
1279             if (b > a) return (false, 0);
1280             return (true, a - b);
1281         }
1282     }
1283 
1284     /**
1285      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1286      *
1287      * _Available since v3.4._
1288      */
1289     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1290         unchecked {
1291             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1292             // benefit is lost if 'b' is also tested.
1293             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1294             if (a == 0) return (true, 0);
1295             uint256 c = a * b;
1296             if (c / a != b) return (false, 0);
1297             return (true, c);
1298         }
1299     }
1300 
1301     /**
1302      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1303      *
1304      * _Available since v3.4._
1305      */
1306     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1307         unchecked {
1308             if (b == 0) return (false, 0);
1309             return (true, a / b);
1310         }
1311     }
1312 
1313     /**
1314      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1315      *
1316      * _Available since v3.4._
1317      */
1318     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1319         unchecked {
1320             if (b == 0) return (false, 0);
1321             return (true, a % b);
1322         }
1323     }
1324 
1325     /**
1326      * @dev Returns the addition of two unsigned integers, reverting on
1327      * overflow.
1328      *
1329      * Counterpart to Solidity's `+` operator.
1330      *
1331      * Requirements:
1332      *
1333      * - Addition cannot overflow.
1334      */
1335     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1336         return a + b;
1337     }
1338 
1339     /**
1340      * @dev Returns the subtraction of two unsigned integers, reverting on
1341      * overflow (when the result is negative).
1342      *
1343      * Counterpart to Solidity's `-` operator.
1344      *
1345      * Requirements:
1346      *
1347      * - Subtraction cannot overflow.
1348      */
1349     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1350         return a - b;
1351     }
1352 
1353     /**
1354      * @dev Returns the multiplication of two unsigned integers, reverting on
1355      * overflow.
1356      *
1357      * Counterpart to Solidity's `*` operator.
1358      *
1359      * Requirements:
1360      *
1361      * - Multiplication cannot overflow.
1362      */
1363     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1364         return a * b;
1365     }
1366 
1367     /**
1368      * @dev Returns the integer division of two unsigned integers, reverting on
1369      * division by zero. The result is rounded towards zero.
1370      *
1371      * Counterpart to Solidity's `/` operator.
1372      *
1373      * Requirements:
1374      *
1375      * - The divisor cannot be zero.
1376      */
1377     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1378         return a / b;
1379     }
1380 
1381     /**
1382      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1383      * reverting when dividing by zero.
1384      *
1385      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1386      * opcode (which leaves remaining gas untouched) while Solidity uses an
1387      * invalid opcode to revert (consuming all remaining gas).
1388      *
1389      * Requirements:
1390      *
1391      * - The divisor cannot be zero.
1392      */
1393     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1394         return a % b;
1395     }
1396 
1397     /**
1398      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1399      * overflow (when the result is negative).
1400      *
1401      * CAUTION: This function is deprecated because it requires allocating memory for the error
1402      * message unnecessarily. For custom revert reasons use {trySub}.
1403      *
1404      * Counterpart to Solidity's `-` operator.
1405      *
1406      * Requirements:
1407      *
1408      * - Subtraction cannot overflow.
1409      */
1410     function sub(
1411         uint256 a,
1412         uint256 b,
1413         string memory errorMessage
1414     ) internal pure returns (uint256) {
1415         unchecked {
1416             require(b <= a, errorMessage);
1417             return a - b;
1418         }
1419     }
1420 
1421     /**
1422      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1423      * division by zero. The result is rounded towards zero.
1424      *
1425      * Counterpart to Solidity's `/` operator. Note: this function uses a
1426      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1427      * uses an invalid opcode to revert (consuming all remaining gas).
1428      *
1429      * Requirements:
1430      *
1431      * - The divisor cannot be zero.
1432      */
1433     function div(
1434         uint256 a,
1435         uint256 b,
1436         string memory errorMessage
1437     ) internal pure returns (uint256) {
1438         unchecked {
1439             require(b > 0, errorMessage);
1440             return a / b;
1441         }
1442     }
1443 
1444     /**
1445      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1446      * reverting with custom message when dividing by zero.
1447      *
1448      * CAUTION: This function is deprecated because it requires allocating memory for the error
1449      * message unnecessarily. For custom revert reasons use {tryMod}.
1450      *
1451      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1452      * opcode (which leaves remaining gas untouched) while Solidity uses an
1453      * invalid opcode to revert (consuming all remaining gas).
1454      *
1455      * Requirements:
1456      *
1457      * - The divisor cannot be zero.
1458      */
1459     function mod(
1460         uint256 a,
1461         uint256 b,
1462         string memory errorMessage
1463     ) internal pure returns (uint256) {
1464         unchecked {
1465             require(b > 0, errorMessage);
1466             return a % b;
1467         }
1468     }
1469 }
1470 
1471 
1472 /**
1473  * @dev Contract module that helps prevent reentrant calls to a function.
1474  *
1475  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1476  * available, which can be applied to functions to make sure there are no nested
1477  * (reentrant) calls to them.
1478  *
1479  * Note that because there is a single `nonReentrant` guard, functions marked as
1480  * `nonReentrant` may not call one another. This can be worked around by making
1481  * those functions `private`, and then adding `external` `nonReentrant` entry
1482  * points to them.
1483  *
1484  * TIP: If you would like to learn more about reentrancy and alternative ways
1485  * to protect against it, check out our blog post
1486  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1487  */
1488 abstract contract ReentrancyGuard {
1489     // Booleans are more expensive than uint256 or any type that takes up a full
1490     // word because each write operation emits an extra SLOAD to first read the
1491     // slot's contents, replace the bits taken up by the boolean, and then write
1492     // back. This is the compiler's defense against contract upgrades and
1493     // pointer aliasing, and it cannot be disabled.
1494 
1495     // The values being non-zero value makes deployment a bit more expensive,
1496     // but in exchange the refund on every call to nonReentrant will be lower in
1497     // amount. Since refunds are capped to a percentage of the total
1498     // transaction's gas, it is best to keep them low in cases like this one, to
1499     // increase the likelihood of the full refund coming into effect.
1500     uint256 private constant _NOT_ENTERED = 1;
1501     uint256 private constant _ENTERED = 2;
1502 
1503     uint256 private _status;
1504 
1505     constructor() {
1506         _status = _NOT_ENTERED;
1507     }
1508 
1509     /**
1510      * @dev Prevents a contract from calling itself, directly or indirectly.
1511      * Calling a `nonReentrant` function from another `nonReentrant`
1512      * function is not supported. It is possible to prevent this from happening
1513      * by making the `nonReentrant` function external, and making it call a
1514      * `private` function that does the actual work.
1515      */
1516     modifier nonReentrant() {
1517         // On the first call to nonReentrant, _notEntered will be true
1518         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1519 
1520         // Any calls to nonReentrant after this point will fail
1521         _status = _ENTERED;
1522 
1523         _;
1524 
1525         // By storing the original value once again, a refund is triggered (see
1526         // https://eips.ethereum.org/EIPS/eip-2200)
1527         _status = _NOT_ENTERED;
1528     }
1529 }
1530 
1531 
1532 contract InventorsNFT is ERC721A, ReentrancyGuard, Ownable{
1533   using SafeMath for uint256;
1534   using Address for address;
1535   using Strings for uint256;
1536 
1537   uint256 public constant presalePrice = 0.12 ether;
1538   uint256 public constant salePrice = 0.14 ether;
1539   uint256 public constant maxPurchase = 20;
1540   uint256 public constant maxPrePurchase = 4;
1541 
1542   bool private _saleActive = false;
1543   bool private _presaleActive = false;
1544   uint256 private _maxInventors = 7777;
1545   string private _baseTokenURI; // set later
1546   
1547 
1548   event InventorMinted(address sender, uint256 quantity);
1549 
1550   constructor(uint256 _totalInventors) ERC721A('Inventors NFT', 'INFT') {
1551     _maxInventors = _totalInventors;
1552   }
1553 
1554   // api
1555 
1556   /**
1557    * @dev Returns the URI to the contract metadata
1558    */
1559    
1560   function contractURI() public pure returns (string memory) {
1561     return 'ipfs://QmaqkerewNmEBqAesJHRk8yoLzm6HWgbt9L2U1njAb5TEE';
1562   }
1563 
1564   /**
1565    * @dev Internal function to return the base uri for all tokens
1566    */
1567   function _baseURI() internal view virtual override returns (string memory) {
1568     return _baseTokenURI;
1569   }
1570 
1571   /**
1572    * @dev Returns list of token ids owned by address without the need for IERC721Enumerable
1573    */
1574   function verifyOwnership(address _owner)
1575     external
1576     view
1577     returns (uint256[] memory)
1578   {
1579     uint256 ownerTokenCount = balanceOf(_owner);
1580     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1581     uint256 k = 0;
1582     for (uint256 i = 1; i <= _maxInventors; i++) {
1583       if (_exists(i) && _owner == ownerOf(i)) {
1584         tokenIds[k] = i;
1585         k++;
1586       }
1587     }
1588     delete k;
1589     return tokenIds;
1590   }
1591 
1592   modifier onlyValidQuantity(uint256 quantity) {
1593     require(totalSupply() + quantity <= _maxInventors, 'Exceeds supply');
1594     require(quantity <= maxPurchase, '20 Max');
1595     _;
1596   }
1597 
1598   modifier onlyPreValidQuantity(uint256 quantity) {
1599     require(totalSupply() + quantity <= _maxInventors, 'Exceeds supply');
1600     require(quantity <= maxPrePurchase, '4 Max');
1601     _;
1602   }
1603 
1604   function mintInventor(uint256 quantity)
1605     external
1606     payable
1607     onlyValidQuantity(quantity)
1608   {
1609     require(_saleActive, 'Sale not active');
1610     require(!_presaleActive, 'Presale active');
1611     require(salePrice.mul(quantity) == msg.value, 'Wrong amount');
1612     _safeMint(msg.sender, quantity);
1613     emit InventorMinted(msg.sender, quantity);
1614   }
1615 
1616   function preSaleMint(uint256 quantity)
1617     external
1618     payable
1619     onlyPreValidQuantity(quantity)
1620   {
1621     require(_presaleActive, 'Presale not active');
1622     require(!_saleActive, 'Sale active');
1623     require(presalePrice.mul(quantity) == msg.value, 'Wrong amount');
1624     _safeMint(msg.sender, quantity);
1625     emit InventorMinted(msg.sender, quantity);
1626   }
1627 
1628   // only owner functions
1629 
1630   /**
1631    *  @dev Setting aside inventors for marketing and other purposes.
1632   */  
1633 
1634   function reserveInventors(uint quantity) 
1635     external 
1636     onlyOwner     
1637     {
1638         require(totalSupply() + quantity <= _maxInventors, 'Exceeds supply');
1639      _safeMint(msg.sender, quantity);
1640     }
1641 
1642   /**
1643    * @dev Setter for the Sale State
1644    */
1645   function setSaleState(bool _newSaleActive) external onlyOwner {
1646     _saleActive = _newSaleActive;
1647   }
1648 
1649   /**
1650    * @dev Setter for the Presale State
1651    */
1652   function setPresaleState(bool _newPresaleActive) external onlyOwner {
1653     _presaleActive = _newPresaleActive;
1654   }
1655 
1656   /**
1657    * @dev Setter for the Base URI
1658    */
1659   function setBaseURI(string calldata baseURI) external onlyOwner {
1660     _baseTokenURI = baseURI;
1661   }
1662   
1663 
1664   function disburse() external payable onlyOwner {
1665     (bool success, ) = payable(msg.sender).call{ value: address(this).balance }(
1666       ''
1667     );
1668     require(success);
1669   }
1670 
1671   // fallback functions to handle someone sending ETH to contract
1672   fallback() external payable {}
1673 
1674   receive() external payable {}
1675 }