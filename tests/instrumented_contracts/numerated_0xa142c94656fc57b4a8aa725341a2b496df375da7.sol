1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  * from ERC721 asset contracts.
184  */
185 interface IERC721Receiver {
186     /**
187      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
188      * by `operator` from `from`, this function is called.
189      *
190      * It must return its Solidity selector to confirm the token transfer.
191      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
192      *
193      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
194      */
195     function onERC721Received(
196         address operator,
197         address from,
198         uint256 tokenId,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
240  * @dev See https://eips.ethereum.org/EIPS/eip-721
241  */
242 interface IERC721Enumerable is IERC721 {
243     /**
244      * @dev Returns the total amount of tokens stored by the contract.
245      */
246     function totalSupply() external view returns (uint256);
247 
248     /**
249      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
250      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
251      */
252     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
253 
254     /**
255      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
256      * Use along with {totalSupply} to enumerate all tokens.
257      */
258     function tokenByIndex(uint256 index) external view returns (uint256);
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 
264 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
265 
266 pragma solidity ^0.8.1;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      *
289      * [IMPORTANT]
290      * ====
291      * You shouldn't rely on `isContract` to protect against flash loan attacks!
292      *
293      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
294      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
295      * constructor.
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize/address.code.length, which returns 0
300         // for contracts in construction, since the code is only stored at the end
301         // of the constructor execution.
302 
303         return account.code.length > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         (bool success, ) = recipient.call{value: amount}("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain `call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.call{value: value}(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
410         return functionStaticCall(target, data, "Address: low-level static call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(isContract(target), "Address: delegate call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.delegatecall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
459      * revert reason using the provided one.
460      *
461      * _Available since v4.3._
462      */
463     function verifyCallResult(
464         bool success,
465         bytes memory returndata,
466         string memory errorMessage
467     ) internal pure returns (bytes memory) {
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 // File: @openzeppelin/contracts/utils/Context.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes calldata) {
509         return msg.data;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/utils/Strings.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev String operations.
522  */
523 library Strings {
524     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
528      */
529     function toString(uint256 value) internal pure returns (string memory) {
530         // Inspired by OraclizeAPI's implementation - MIT licence
531         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
532 
533         if (value == 0) {
534             return "0";
535         }
536         uint256 temp = value;
537         uint256 digits;
538         while (temp != 0) {
539             digits++;
540             temp /= 10;
541         }
542         bytes memory buffer = new bytes(digits);
543         while (value != 0) {
544             digits -= 1;
545             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
546             value /= 10;
547         }
548         return string(buffer);
549     }
550 
551     /**
552      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
553      */
554     function toHexString(uint256 value) internal pure returns (string memory) {
555         if (value == 0) {
556             return "0x00";
557         }
558         uint256 temp = value;
559         uint256 length = 0;
560         while (temp != 0) {
561             length++;
562             temp >>= 8;
563         }
564         return toHexString(value, length);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
569      */
570     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
571         bytes memory buffer = new bytes(2 * length + 2);
572         buffer[0] = "0";
573         buffer[1] = "x";
574         for (uint256 i = 2 * length + 1; i > 1; --i) {
575             buffer[i] = _HEX_SYMBOLS[value & 0xf];
576             value >>= 4;
577         }
578         require(value == 0, "Strings: hex length insufficient");
579         return string(buffer);
580     }
581 }
582 
583 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Implementation of the {IERC165} interface.
592  *
593  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
594  * for the additional interface id that will be supported. For example:
595  *
596  * ```solidity
597  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
598  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
599  * }
600  * ```
601  *
602  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
603  */
604 abstract contract ERC165 is IERC165 {
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
609         return interfaceId == type(IERC165).interfaceId;
610     }
611 }
612 
613 // File: contracts/ERC721G/ERC721G.sol
614 
615 
616 // Creator: Chiru Labs
617 // Modifications Copyright (c) 2022 Cyber Manufacture Co.
618 
619 pragma solidity ^0.8.4;
620 
621 
622 
623 
624 
625 
626 
627 
628 error ApprovalCallerNotOwnerNorApproved();
629 error ApprovalQueryForNonexistentToken();
630 error ApproveToCaller();
631 error ApprovalToCurrentOwner();
632 error BalanceQueryForZeroAddress();
633 error MintedQueryForZeroAddress();
634 error BurnedQueryForZeroAddress();
635 error MintToZeroAddress();
636 error MintZeroQuantity();
637 error OwnerIndexOutOfBounds();
638 error OwnerQueryForNonexistentToken();
639 error TokenIndexOutOfBounds();
640 error TransferCallerNotOwnerNorApproved();
641 error TransferFromIncorrectOwner();
642 error TransferToNonERC721ReceiverImplementer();
643 error TransferToZeroAddress();
644 error URIQueryForNonexistentToken();
645 
646 /**
647  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
648  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
649  *
650  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
651  *
652  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
653  *
654  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
655  */
656 contract ERC721G is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
657     using Address for address;
658     using Strings for uint256;
659 
660     // Compiler will pack this into a single 256bit word.
661     struct TokenOwnership {
662         // The address of the owner.
663         address addr;
664         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
665         uint64 startTimestamp;
666         // Whether the token has been burned.
667         bool burned;
668     }
669 
670     // Compiler will pack this into a single 256bit word.
671     struct AddressData {
672         // Realistically, 2**64-1 is more than enough.
673         uint64 balance;
674         // Keeps track of mint count with minimal overhead for tokenomics.
675         uint64 numberMinted;
676         // Keeps track of burn count with minimal overhead for tokenomics.
677         uint64 numberBurned;
678     }
679 
680     // Compiler will pack the following 
681     // _currentIndex and _burnCounter into a single 256bit word.
682     
683     // The tokenId of the next token to be minted.
684     uint128 internal _currentIndex;
685 
686     // The number of tokens burned.
687     uint128 internal _burnCounter;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to ownership details
696     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
697     mapping(uint256 => TokenOwnership) internal _ownerships;
698 
699     // Mapping owner address to address data
700     mapping(address => AddressData) private _addressData;
701 
702     // Mapping from token ID to approved address
703     mapping(uint256 => address) private _tokenApprovals;
704 
705     // Mapping from owner to operator approvals
706     mapping(address => mapping(address => bool)) private _operatorApprovals;
707 
708     constructor(string memory name_, string memory symbol_) {
709         _name = name_;
710         _symbol = symbol_;
711     }
712 
713     /**
714      * @dev See {IERC721Enumerable-totalSupply}.
715      */
716     function totalSupply() public view override returns (uint256) {
717         // Counter underflow is impossible as _burnCounter cannot be incremented
718         // more than _currentIndex times
719         unchecked {
720             return _currentIndex - _burnCounter;    
721         }
722     }
723 
724     /**
725      * @dev See {IERC721Enumerable-tokenByIndex}.
726      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
727      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
728      */
729     function tokenByIndex(uint256 index) public view override returns (uint256) {
730         uint256 numMintedSoFar = _currentIndex;
731         uint256 tokenIdsIdx;
732 
733         // Counter overflow is impossible as the loop breaks when
734         // uint256 i is equal to another uint256 numMintedSoFar.
735         unchecked {
736             for (uint256 i; i < numMintedSoFar; i++) {
737                 TokenOwnership memory ownership = _ownerships[i];
738                 if (!ownership.burned) {
739                     if (tokenIdsIdx == index) {
740                         return i;
741                     }
742                     tokenIdsIdx++;
743                 }
744             }
745         }
746         revert TokenIndexOutOfBounds();
747     }
748 
749     /**
750      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
751      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
752      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
753      */
754     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
755         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
756         uint256 numMintedSoFar = _currentIndex;
757         uint256 tokenIdsIdx;
758         address currOwnershipAddr;
759 
760         // Counter overflow is impossible as the loop breaks when
761         // uint256 i is equal to another uint256 numMintedSoFar.
762         unchecked {
763             for (uint256 i; i < numMintedSoFar; i++) {
764                 TokenOwnership memory ownership = _ownerships[i];
765                 if (ownership.burned) {
766                     continue;
767                 }
768                 if (ownership.addr != address(0)) {
769                     currOwnershipAddr = ownership.addr;
770                 }
771                 if (currOwnershipAddr == owner) {
772                     if (tokenIdsIdx == index) {
773                         return i;
774                     }
775                     tokenIdsIdx++;
776                 }
777             }
778         }
779 
780         // Execution should never reach this point.
781         revert();
782     }
783 
784     /**
785      * @dev See {IERC165-supportsInterface}.
786      */
787     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
788         return
789             interfaceId == type(IERC721).interfaceId ||
790             interfaceId == type(IERC721Metadata).interfaceId ||
791             interfaceId == type(IERC721Enumerable).interfaceId ||
792             super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC721-balanceOf}.
797      */
798     function balanceOf(address owner) public view override returns (uint256) {
799         if (owner == address(0)) revert BalanceQueryForZeroAddress();
800         return uint256(_addressData[owner].balance);
801     }
802 
803     function _numberMinted(address owner) internal view returns (uint256) {
804         if (owner == address(0)) revert MintedQueryForZeroAddress();
805         return uint256(_addressData[owner].numberMinted);
806     }
807 
808     function _numberBurned(address owner) internal view returns (uint256) {
809         if (owner == address(0)) revert BurnedQueryForZeroAddress();
810         return uint256(_addressData[owner].numberBurned);
811     }
812 
813     /**
814      * Gas spent here starts off proportional to the maximum mint batch size.
815      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
816      */
817     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
818         uint256 curr = tokenId;
819 
820         unchecked {
821             if (curr < _currentIndex) {
822                 TokenOwnership memory ownership = _ownerships[curr];
823                 if (!ownership.burned) {
824                     if (ownership.addr != address(0)) {
825                         return ownership;
826                     }
827                     // Invariant: 
828                     // There will always be an ownership that has an address and is not burned 
829                     // before an ownership that does not have an address and is not burned.
830                     // Hence, curr will not underflow.
831                     while (true) {
832                         curr--;
833                         ownership = _ownerships[curr];
834                         if (ownership.addr != address(0)) {
835                             return ownership;
836                         }
837                     }
838                 }
839             }
840         }
841         revert OwnerQueryForNonexistentToken();
842     }
843 
844     /**
845      * @dev See {IERC721-ownerOf}.
846      */
847     function ownerOf(uint256 tokenId) public view override returns (address) {
848         return ownershipOf(tokenId).addr;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-name}.
853      */
854     function name() public view virtual override returns (string memory) {
855         return _name;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-symbol}.
860      */
861     function symbol() public view virtual override returns (string memory) {
862         return _symbol;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-tokenURI}.
867      */
868     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
869         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
870 
871         string memory baseURI = _baseURI();
872         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
873     }
874 
875     /**
876      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
877      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
878      * by default, can be overriden in child contracts.
879      */
880     function _baseURI() internal view virtual returns (string memory) {
881         return '';
882     }
883 
884     /**
885      * @dev See {IERC721-approve}.
886      */
887     function approve(address to, uint256 tokenId) public override {
888         address owner = ERC721G.ownerOf(tokenId);
889         if (to == owner) revert ApprovalToCurrentOwner();
890 
891         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
892             revert ApprovalCallerNotOwnerNorApproved();
893         }
894 
895         _approve(to, tokenId, owner);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view override returns (address) {
902         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public override {
911         if (operator == _msgSender()) revert ApproveToCaller();
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         _transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public virtual override {
943         safeTransferFrom(from, to, tokenId, '');
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public virtual override {
955         _transfer(from, to, tokenId);
956         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
957             revert TransferToNonERC721ReceiverImplementer();
958         }
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      */
968     function _exists(uint256 tokenId) internal view returns (bool) {
969         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
970     }
971 
972     function _safeMint(address to, uint256 quantity) internal {
973         _safeMint(to, quantity, '');
974     }
975 
976     /**
977      * @dev Safely mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
982      * - `quantity` must be greater than 0.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeMint(
987         address to,
988         uint256 quantity,
989         bytes memory _data
990     ) internal {
991         _mint(to, quantity, _data, true);
992     }
993 
994     /**
995      * @dev Mints `quantity` tokens and transfers them to `to`.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `quantity` must be greater than 0.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(
1005         address to,
1006         uint256 quantity,
1007         bytes memory _data,
1008         bool safe
1009     ) internal {
1010         uint256 startTokenId = _currentIndex;
1011         if (to == address(0)) revert MintToZeroAddress();
1012         if (quantity == 0) revert MintZeroQuantity();
1013 
1014         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1015 
1016         // Overflows are incredibly unrealistic.
1017         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1018         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1019         unchecked {
1020             _addressData[to].balance += uint64(quantity);
1021             _addressData[to].numberMinted += uint64(quantity);
1022 
1023             _ownerships[startTokenId].addr = to;
1024             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1025 
1026             uint256 updatedIndex = startTokenId;
1027 
1028             for (uint256 i; i < quantity; i++) {
1029                 emit Transfer(address(0), to, updatedIndex);
1030                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1031                     revert TransferToNonERC721ReceiverImplementer();
1032                 }
1033                 updatedIndex++;
1034             }
1035 
1036             _currentIndex = uint128(updatedIndex);
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
1056         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1057 
1058         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1059             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1060             getApproved(tokenId) == _msgSender());
1061 
1062         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1063         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1064         if (to == address(0)) revert TransferToZeroAddress();
1065 
1066         _beforeTokenTransfers(from, to, tokenId, 1);
1067 
1068         // Clear approvals from the previous owner
1069         _approve(address(0), tokenId, prevOwnership.addr);
1070 
1071         // Underflow of the sender's balance is impossible because we check for
1072         // ownership above and the recipient's balance can't realistically overflow.
1073         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1074         unchecked {
1075             _addressData[from].balance -= 1;
1076             _addressData[to].balance += 1;
1077 
1078             _ownerships[tokenId].addr = to;
1079             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1080 
1081             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1082             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1083             uint256 nextTokenId = tokenId + 1;
1084             if (_ownerships[nextTokenId].addr == address(0)) {
1085                 // This will suffice for checking _exists(nextTokenId),
1086                 // as a burned slot cannot contain the zero address.
1087                 if (nextTokenId < _currentIndex) {
1088                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1089                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1090                 }
1091             }
1092         }
1093 
1094         emit Transfer(from, to, tokenId);
1095         _afterTokenTransfers(from, to, tokenId, 1);
1096     }
1097 
1098     /**
1099      * @dev Destroys `tokenId`.
1100      * The approval is cleared when the token is burned.
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must exist.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _burn(uint256 tokenId) internal virtual {
1109         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1110 
1111         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1112 
1113         // Clear approvals from the previous owner
1114         _approve(address(0), tokenId, prevOwnership.addr);
1115 
1116         // Underflow of the sender's balance is impossible because we check for
1117         // ownership above and the recipient's balance can't realistically overflow.
1118         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1119         unchecked {
1120             _addressData[prevOwnership.addr].balance -= 1;
1121             _addressData[prevOwnership.addr].numberBurned += 1;
1122 
1123             // Keep track of who burned the token, and the timestamp of burning.
1124             _ownerships[tokenId].addr = prevOwnership.addr;
1125             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1126             _ownerships[tokenId].burned = true;
1127 
1128             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1129             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1130             uint256 nextTokenId = tokenId + 1;
1131             if (_ownerships[nextTokenId].addr == address(0)) {
1132                 // This will suffice for checking _exists(nextTokenId),
1133                 // as a burned slot cannot contain the zero address.
1134                 if (nextTokenId < _currentIndex) {
1135                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1136                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1137                 }
1138             }
1139         }
1140 
1141         emit Transfer(prevOwnership.addr, address(0), tokenId);
1142         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1143 
1144         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1145         unchecked { 
1146             _burnCounter++;
1147         }
1148     }
1149 
1150     /**
1151      * @dev Approve `to` to operate on `tokenId`
1152      *
1153      * Emits a {Approval} event.
1154      */
1155     function _approve(
1156         address to,
1157         uint256 tokenId,
1158         address owner
1159     ) private {
1160         _tokenApprovals[tokenId] = to;
1161         emit Approval(owner, to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1166      * The call is not executed if the target address is not a contract.
1167      *
1168      * @param from address representing the previous owner of the given token ID
1169      * @param to target address that will receive the tokens
1170      * @param tokenId uint256 ID of the token to be transferred
1171      * @param _data bytes optional data to send along with the call
1172      * @return bool whether the call correctly returned the expected magic value
1173      */
1174     function _checkOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         if (to.isContract()) {
1181             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1182                 return retval == IERC721Receiver(to).onERC721Received.selector;
1183             } catch (bytes memory reason) {
1184                 if (reason.length == 0) {
1185                     revert TransferToNonERC721ReceiverImplementer();
1186                 } else {
1187                     assembly {
1188                         revert(add(32, reason), mload(reason))
1189                     }
1190                 }
1191             }
1192         } else {
1193             return true;
1194         }
1195     }
1196 
1197     /**
1198      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1199      * And also called before burning one token.
1200      *
1201      * startTokenId - the first token id to be transferred
1202      * quantity - the amount to be transferred
1203      *
1204      * Calling conditions:
1205      *
1206      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1207      * transferred to `to`.
1208      * - When `from` is zero, `tokenId` will be minted for `to`.
1209      * - When `to` is zero, `tokenId` will be burned by `from`.
1210      * - `from` and `to` are never both zero.
1211      */
1212     function _beforeTokenTransfers(
1213         address from,
1214         address to,
1215         uint256 startTokenId,
1216         uint256 quantity
1217     ) internal virtual {}
1218 
1219     /**
1220      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1221      * minting.
1222      * And also called after one token has been burned.
1223      *
1224      * startTokenId - the first token id to be transferred
1225      * quantity - the amount to be transferred
1226      *
1227      * Calling conditions:
1228      *
1229      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1230      * transferred to `to`.
1231      * - When `from` is zero, `tokenId` has been minted for `to`.
1232      * - When `to` is zero, `tokenId` has been burned by `from`.
1233      * - `from` and `to` are never both zero.
1234      */
1235     function _afterTokenTransfers(
1236         address from,
1237         address to,
1238         uint256 startTokenId,
1239         uint256 quantity
1240     ) internal virtual {}
1241 }
1242 
1243 // File: @openzeppelin/contracts/access/Ownable.sol
1244 
1245 
1246 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 /**
1251  * @dev Contract module which provides a basic access control mechanism, where
1252  * there is an account (an owner) that can be granted exclusive access to
1253  * specific functions.
1254  *
1255  * By default, the owner account will be the one that deploys the contract. This
1256  * can later be changed with {transferOwnership}.
1257  *
1258  * This module is used through inheritance. It will make available the modifier
1259  * `onlyOwner`, which can be applied to your functions to restrict their use to
1260  * the owner.
1261  */
1262 abstract contract Ownable is Context {
1263     address private _owner;
1264 
1265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1266 
1267     /**
1268      * @dev Initializes the contract setting the deployer as the initial owner.
1269      */
1270     constructor() {
1271         _transferOwnership(_msgSender());
1272     }
1273 
1274     /**
1275      * @dev Returns the address of the current owner.
1276      */
1277     function owner() public view virtual returns (address) {
1278         return _owner;
1279     }
1280 
1281     /**
1282      * @dev Throws if called by any account other than the owner.
1283      */
1284     modifier onlyOwner() {
1285         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1286         _;
1287     }
1288 
1289     /**
1290      * @dev Leaves the contract without owner. It will not be possible to call
1291      * `onlyOwner` functions anymore. Can only be called by the current owner.
1292      *
1293      * NOTE: Renouncing ownership will leave the contract without an owner,
1294      * thereby removing any functionality that is only available to the owner.
1295      */
1296     function renounceOwnership() public virtual onlyOwner {
1297         _transferOwnership(address(0));
1298     }
1299 
1300     /**
1301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1302      * Can only be called by the current owner.
1303      */
1304     function transferOwnership(address newOwner) public virtual onlyOwner {
1305         require(newOwner != address(0), "Ownable: new owner is the zero address");
1306         _transferOwnership(newOwner);
1307     }
1308 
1309     /**
1310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1311      * Internal function without access restriction.
1312      */
1313     function _transferOwnership(address newOwner) internal virtual {
1314         address oldOwner = _owner;
1315         _owner = newOwner;
1316         emit OwnershipTransferred(oldOwner, newOwner);
1317     }
1318 }
1319 
1320 // File: contracts/@rarible/royalties/contracts/LibPart.sol
1321 
1322 
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 library LibPart {
1327     bytes32 public constant TYPE_HASH = keccak256("Part(address account,uint96 value)");
1328 
1329     struct Part {
1330         address payable account;
1331         uint96 value;
1332     }
1333 
1334     function hash(Part memory part) internal pure returns (bytes32) {
1335         return keccak256(abi.encode(TYPE_HASH, part.account, part.value));
1336     }
1337 }
1338 
1339 // File: contracts/@rarible/royalties/contracts/impl/AbstractRoyalties.sol
1340 
1341 
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 abstract contract AbstractRoyalties {
1346     mapping (uint256 => LibPart.Part[]) public royalties;
1347 
1348     function _saveRoyalties(uint256 _id, LibPart.Part[] memory _royalties) internal {
1349         for (uint i = 0; i < _royalties.length; i++) {
1350             require(_royalties[i].account != address(0x0), "Recipient should be present");
1351             require(_royalties[i].value != 0, "Royalty value should be positive");
1352             royalties[_id].push(_royalties[i]);
1353         }
1354         _onRoyaltiesSet(_id, _royalties);
1355     }
1356 
1357     function _updateAccount(uint256 _id, address _from, address _to) internal {
1358         uint length = royalties[_id].length;
1359         for(uint i = 0; i < length; i++) {
1360             if (royalties[_id][i].account == _from) {
1361                 royalties[_id][i].account = payable(address(uint160(_to)));
1362             }
1363         }
1364     }
1365 
1366     function _onRoyaltiesSet(uint256 _id, LibPart.Part[] memory _royalties) virtual internal;
1367 }
1368 
1369 // File: contracts/@rarible/royalties/contracts/RoyaltiesV2.sol
1370 
1371 
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 interface RoyaltiesV2 {
1376     event RoyaltiesSet(uint256 tokenId, LibPart.Part[] royalties);
1377 
1378     function getRaribleV2Royalties(uint256 id) external view returns (LibPart.Part[] memory);
1379 }
1380 
1381 // File: contracts/@rarible/royalties/contracts/impl/RoyaltiesV2Impl.sol
1382 
1383 
1384 
1385 pragma solidity ^0.8.0;
1386 
1387 
1388 contract RoyaltiesV2Impl is AbstractRoyalties, RoyaltiesV2 {
1389     function getRaribleV2Royalties(uint256 id) override external view returns (LibPart.Part[] memory) {
1390         return royalties[id];
1391     }
1392 
1393     function _onRoyaltiesSet(uint256 _id, LibPart.Part[] memory _royalties) override internal {
1394         emit RoyaltiesSet(_id, _royalties);
1395     }
1396 }
1397 
1398 // File: contracts/@rarible/royalties/contracts/LibRoyaltiesV2.sol
1399 
1400 
1401 
1402 pragma solidity ^0.8.0;
1403 
1404 library LibRoyaltiesV2 {
1405     /*
1406     * bytes4(keccak256('getRoyalties(LibAsset.AssetType)')) == 0x44c74bcc
1407     */
1408     bytes4 constant _INTERFACE_ID_ROYALTIES = 0x44c74bcc;
1409 }
1410 
1411 // File: contracts/GAMAv2.sol
1412 
1413 pragma solidity ^0.8.4;
1414 
1415 
1416 
1417 
1418 
1419 /// By John Whitton (github: johnwhitton), Aaron Li (github: polymorpher)
1420 contract GAMAv2 is ERC721G, Ownable, RoyaltiesV2Impl {
1421     bytes32 internal salt;
1422     uint256 public maxGamaTokens;
1423     uint256 public mintPrice;
1424     uint256 public maxPerMint;
1425     uint256 public startIndex;
1426 
1427     string public provenanceHash = "";
1428     uint256 public offsetValue;
1429 
1430     bool public metadataFrozen;
1431     bool public provenanceFrozen;
1432     bool public saleIsActive;
1433     bool public saleStarted;
1434 
1435     mapping(uint256 => string) internal metadataUris;
1436     string internal _contractUri;
1437     string public temporaryTokenUri;
1438     string internal baseUri;
1439     address internal revenueAccount;
1440 
1441     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1442 
1443     event SetBaseUri(string baseUri);
1444     event SetStartIndex(uint256 index);
1445     event GAMAMint(uint256 lastTokenId, uint256 numTokens, address initialOwner);
1446     event GAMAMintCommunity(uint256 lastTokenId, uint256 numTokens, address initialOwner);
1447     event GAMABurn(uint256 id);
1448     event GAMABatchBurn(uint256[] ids);
1449     event GAMATransfer(uint256 id, address from, address to, address operator);
1450     event GAMASetup(uint32 coolingPeriod_, uint32 shipNumber_, string contractUri);
1451 
1452     constructor(bool _saleIsActive, bool _metadataFrozen, bool _provenanceFrozen, uint256 _maxGamaTokens, uint256 _mintPrice, uint256 _maxPerMint, string memory _baseUri, string memory contractUri_) ERC721G("GAMA Space Station v2", "GAMAv2") {
1453         saleIsActive = _saleIsActive;
1454         if (saleIsActive) {
1455             saleStarted = true;
1456         }
1457         metadataFrozen = _metadataFrozen;
1458         provenanceFrozen = _provenanceFrozen;
1459         maxGamaTokens = _maxGamaTokens;
1460         mintPrice = _mintPrice;
1461         maxPerMint = _maxPerMint;
1462         baseUri = _baseUri;
1463         _contractUri = contractUri_;
1464     }
1465 
1466     modifier whenSaleActive {
1467         require(saleIsActive, "GAMAv2: Sale is not active");
1468         _;
1469     }
1470 
1471     modifier whenMetadataNotFrozen {
1472         require(!metadataFrozen, "GAMAv2: Metadata is frozen");
1473         _;
1474     }
1475 
1476     modifier whenProvenanceNotFrozen {
1477         require(!provenanceFrozen, "GAMAv2: Provenance is frozen");
1478         _;
1479     }
1480 
1481     // ------------------
1482     // Explicit overrides
1483     // ------------------
1484 
1485     function _burn(uint256 tokenId) internal virtual override(ERC721G) {
1486         super._burn(tokenId);
1487     }
1488 
1489     function setTemporaryTokenUri(string memory uri) public onlyOwner {
1490         temporaryTokenUri = uri;
1491     }
1492 
1493     function tokenURI(uint256 tokenId) public view virtual override(ERC721G) returns (string memory) {
1494         if (!metadataFrozen && bytes(temporaryTokenUri).length > 0) {
1495             return temporaryTokenUri;
1496         }
1497         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1498         uint256 tid = tokenId;
1499         if (tid >= offsetValue) {
1500             tid = ((startIndex + tid - offsetValue) % (maxGamaTokens - offsetValue)) + offsetValue ;
1501         }
1502 
1503         if (bytes(metadataUris[tokenId]).length == 0) {
1504             return bytes(baseUri).length != 0 ? string(abi.encodePacked(baseUri, uint2str(tid))) : '';
1505         }
1506         return metadataUris[tokenId];
1507     }
1508 
1509     function setStartIndex() external onlyOwner {
1510         startIndex = uint256(keccak256(abi.encodePacked(blockhash(block.number - 2), bytes20(msg.sender), bytes32(totalSupply())))) % (maxGamaTokens - offsetValue);
1511         emit SetStartIndex(startIndex);
1512     }
1513 
1514     function _baseURI() internal view override returns (string memory) {
1515         return baseUri;
1516     }
1517 
1518     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1519         return interfaceId == this.name.selector ||
1520         interfaceId == this.symbol.selector ||
1521         interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES ||
1522         interfaceId == _INTERFACE_ID_ERC2981 ||
1523         ERC721G.supportsInterface(interfaceId);
1524     }
1525 
1526     // ------------------
1527     // Utility view functions
1528     // ------------------
1529 
1530     function exists(uint256 _tokenId) public view returns (bool) {
1531         return _exists(_tokenId);
1532     }
1533 
1534     //TODO review if we need to override the contractURI
1535     function contractURI() public view returns (string memory) {
1536         return _contractUri;
1537     }
1538 
1539 
1540     // ------------------
1541     // Functions for external (user) minting
1542     // ------------------
1543 
1544     function mintGAMA(uint256 amount) external payable whenSaleActive {
1545         require(totalSupply() + amount < maxGamaTokens, "GAMAv2: Purchase would exceed cap");
1546         require(amount <= maxPerMint, "GAMAv2: Amount exceeds max per mint");
1547         require(mintPrice * amount <= msg.value, "GAMAv2: Ether value sent is not correct");
1548         uint256 excess = msg.value - (amount * mintPrice);
1549         if (excess > 0) {
1550             payable(msg.sender).transfer(excess);
1551         }
1552         _safeMint(msg.sender, amount);
1553         emit GAMAMint(totalSupply(), amount, msg.sender);
1554     }
1555 
1556     function burn(uint256 id) public onlyOwner() whenMetadataNotFrozen() {
1557         ERC721G._burn(id);
1558         emit GAMABurn(id);
1559     }
1560 
1561     function batchBurn(uint256[] memory ids) public onlyOwner() whenMetadataNotFrozen() {
1562         for (uint32 i = 0; i < ids.length; i++) {
1563             uint256 id = ids[i];
1564             ERC721G._burn(id);
1565         }
1566         emit GAMABatchBurn(ids);
1567     }
1568 
1569     // ------------------
1570     // Functions for the owner (GAMA minting contracts)
1571     // ------------------
1572 
1573     function freezeMetadata() external onlyOwner whenMetadataNotFrozen {
1574         metadataFrozen = true;
1575     }
1576 
1577     function freezeProvenance() external onlyOwner whenProvenanceNotFrozen {
1578         provenanceFrozen = true;
1579     }
1580 
1581     function toggleSaleState() external onlyOwner {
1582         require ((saleIsActive || (offsetValue != 0)), "cannot start sale until airdrop is complete and offset set"); 
1583         saleIsActive = !saleIsActive;
1584         if (saleIsActive && !saleStarted) {
1585             saleStarted = true;
1586         }
1587     }
1588 
1589     function setContractUri(string memory uri_) public onlyOwner() {
1590         _contractUri = uri_;
1591     }
1592 
1593     function setProvenanceHash(string memory _provenanceHash) external onlyOwner whenProvenanceNotFrozen {
1594         provenanceHash = _provenanceHash;
1595     }
1596 
1597     function setOffsetValue(uint256 _offsetValue) external onlyOwner {
1598         require(!saleStarted, "sale already begun");
1599         offsetValue = _offsetValue;
1600     }
1601 
1602     function setMaxPerMint(uint256 _maxPerMint) external onlyOwner {
1603         maxPerMint = _maxPerMint;
1604     }
1605 
1606     function setMintPrice(uint256 _mintPrice) external onlyOwner {
1607         mintPrice = _mintPrice;
1608     }
1609 
1610     function setBaseUri(string memory _baseUri) external onlyOwner whenMetadataNotFrozen {
1611         baseUri = _baseUri;
1612         emit SetBaseUri(baseUri);
1613     }
1614 
1615     function mintForCommunity(address _to, uint256 _numberOfTokens) external onlyOwner {
1616         require(_to != address(0), "GAMAv2: Cannot mint to zero address.");
1617         require(totalSupply() + _numberOfTokens < maxGamaTokens, "GAMAv2: Minting would exceed cap");
1618         _safeMint(_to, _numberOfTokens);
1619         emit GAMAMintCommunity(totalSupply(), _numberOfTokens, _to);
1620     }
1621 
1622     function withdraw(uint256 amount, bool shouldUseRevenueAccount) public {
1623         require(msg.sender == Ownable.owner() || msg.sender == revenueAccount, "unauthorized");
1624         address a = shouldUseRevenueAccount ? revenueAccount : Ownable.owner();
1625         (bool success,) = a.call{value : amount}("");
1626         require(success);
1627     }
1628 
1629     function setUri(uint256 id, string memory uri_) public onlyOwner() whenMetadataNotFrozen {
1630         metadataUris[id] = uri_;
1631     }
1632 
1633     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1634         if (_i == 0) {
1635             return "0";
1636         }
1637         uint j = _i;
1638         uint len;
1639         while (j != 0) {
1640             len++;
1641             j /= 10;
1642         }
1643         bytes memory bstr = new bytes(len);
1644         uint k = len;
1645         while (_i != 0) {
1646             k = k - 1;
1647             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1648             bytes1 b1 = bytes1(temp);
1649             bstr[k] = b1;
1650             _i /= 10;
1651         }
1652         return string(bstr);
1653     }
1654 
1655     function setRevenueAccount(address account) public onlyOwner() {
1656         revenueAccount = account;
1657     }
1658 
1659     function setRoyalties(uint _tokenId, address payable _royaltiesReceipientAddress, uint96 _percentageBasisPoints) public  onlyOwner() {
1660         LibPart.Part[] memory _royalties = new LibPart.Part[](1);
1661         _royalties[0].value = _percentageBasisPoints;
1662         _royalties[0].account = _royaltiesReceipientAddress;
1663         _saveRoyalties(_tokenId, _royalties);
1664     }
1665 
1666     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external  view returns (address receiver, uint256 royaltyAmount) {
1667         LibPart.Part[] memory _royalties = royalties[_tokenId];
1668         if (_royalties.length > 0) {
1669             return (_royalties[0].account, (_salePrice * _royalties[0].value) / 10000);
1670         }
1671         return (address(0), 0);
1672 
1673     }
1674 
1675     receive() external payable {
1676 
1677     }
1678 
1679     // ------------------
1680     // Utility function for getting the tokens of a certain address
1681     // ------------------
1682 
1683     function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
1684         uint256 tokenCount = balanceOf(_owner);
1685         if (tokenCount == 0) {
1686             return new uint256[](0);
1687         } else {
1688             uint256[] memory result = new uint256[](tokenCount);
1689             for (uint256 index; index < tokenCount; index++) {
1690                 result[index] = tokenOfOwnerByIndex(_owner, index);
1691             }
1692             return result;
1693         }
1694     }
1695 }