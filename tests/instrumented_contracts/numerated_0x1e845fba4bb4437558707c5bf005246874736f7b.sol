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
613 // File: erc721a/contracts/ERC721A.sol
614 
615 
616 // Creator: Chiru Labs
617 
618 pragma solidity ^0.8.4;
619 
620 
621 
622 
623 
624 
625 
626 
627 error ApprovalCallerNotOwnerNorApproved();
628 error ApprovalQueryForNonexistentToken();
629 error ApproveToCaller();
630 error ApprovalToCurrentOwner();
631 error BalanceQueryForZeroAddress();
632 error MintedQueryForZeroAddress();
633 error BurnedQueryForZeroAddress();
634 error MintToZeroAddress();
635 error MintZeroQuantity();
636 error OwnerIndexOutOfBounds();
637 error OwnerQueryForNonexistentToken();
638 error TokenIndexOutOfBounds();
639 error TransferCallerNotOwnerNorApproved();
640 error TransferFromIncorrectOwner();
641 error TransferToNonERC721ReceiverImplementer();
642 error TransferToZeroAddress();
643 error URIQueryForNonexistentToken();
644 
645 /**
646  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
647  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
648  *
649  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
650  *
651  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
652  *
653  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
654  */
655 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
656     using Address for address;
657     using Strings for uint256;
658 
659     // Compiler will pack this into a single 256bit word.
660     struct TokenOwnership {
661         // The address of the owner.
662         address addr;
663         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
664         uint64 startTimestamp;
665         // Whether the token has been burned.
666         bool burned;
667     }
668 
669     // Compiler will pack this into a single 256bit word.
670     struct AddressData {
671         // Realistically, 2**64-1 is more than enough.
672         uint64 balance;
673         // Keeps track of mint count with minimal overhead for tokenomics.
674         uint64 numberMinted;
675         // Keeps track of burn count with minimal overhead for tokenomics.
676         uint64 numberBurned;
677     }
678 
679     // Compiler will pack the following 
680     // _currentIndex and _burnCounter into a single 256bit word.
681     
682     // The tokenId of the next token to be minted.
683     uint128 internal _currentIndex;
684 
685     // The number of tokens burned.
686     uint128 internal _burnCounter;
687 
688     // Token name
689     string private _name;
690 
691     // Token symbol
692     string private _symbol;
693 
694     // Mapping from token ID to ownership details
695     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
696     mapping(uint256 => TokenOwnership) internal _ownerships;
697 
698     // Mapping owner address to address data
699     mapping(address => AddressData) private _addressData;
700 
701     // Mapping from token ID to approved address
702     mapping(uint256 => address) private _tokenApprovals;
703 
704     // Mapping from owner to operator approvals
705     mapping(address => mapping(address => bool)) private _operatorApprovals;
706 
707     constructor(string memory name_, string memory symbol_) {
708         _name = name_;
709         _symbol = symbol_;
710     }
711 
712     /**
713      * @dev See {IERC721Enumerable-totalSupply}.
714      */
715     function totalSupply() public view override returns (uint256) {
716         // Counter underflow is impossible as _burnCounter cannot be incremented
717         // more than _currentIndex times
718         unchecked {
719             return _currentIndex - _burnCounter;    
720         }
721     }
722 
723     /**
724      * @dev See {IERC721Enumerable-tokenByIndex}.
725      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
726      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
727      */
728     function tokenByIndex(uint256 index) public view override returns (uint256) {
729         uint256 numMintedSoFar = _currentIndex;
730         uint256 tokenIdsIdx;
731 
732         // Counter overflow is impossible as the loop breaks when
733         // uint256 i is equal to another uint256 numMintedSoFar.
734         unchecked {
735             for (uint256 i; i < numMintedSoFar; i++) {
736                 TokenOwnership memory ownership = _ownerships[i];
737                 if (!ownership.burned) {
738                     if (tokenIdsIdx == index) {
739                         return i;
740                     }
741                     tokenIdsIdx++;
742                 }
743             }
744         }
745         revert TokenIndexOutOfBounds();
746     }
747 
748     /**
749      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
750      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
751      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
752      */
753     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
754         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
755         uint256 numMintedSoFar = _currentIndex;
756         uint256 tokenIdsIdx;
757         address currOwnershipAddr;
758 
759         // Counter overflow is impossible as the loop breaks when
760         // uint256 i is equal to another uint256 numMintedSoFar.
761         unchecked {
762             for (uint256 i; i < numMintedSoFar; i++) {
763                 TokenOwnership memory ownership = _ownerships[i];
764                 if (ownership.burned) {
765                     continue;
766                 }
767                 if (ownership.addr != address(0)) {
768                     currOwnershipAddr = ownership.addr;
769                 }
770                 if (currOwnershipAddr == owner) {
771                     if (tokenIdsIdx == index) {
772                         return i;
773                     }
774                     tokenIdsIdx++;
775                 }
776             }
777         }
778 
779         // Execution should never reach this point.
780         revert();
781     }
782 
783     /**
784      * @dev See {IERC165-supportsInterface}.
785      */
786     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
787         return
788             interfaceId == type(IERC721).interfaceId ||
789             interfaceId == type(IERC721Metadata).interfaceId ||
790             interfaceId == type(IERC721Enumerable).interfaceId ||
791             super.supportsInterface(interfaceId);
792     }
793 
794     /**
795      * @dev See {IERC721-balanceOf}.
796      */
797     function balanceOf(address owner) public view override returns (uint256) {
798         if (owner == address(0)) revert BalanceQueryForZeroAddress();
799         return uint256(_addressData[owner].balance);
800     }
801 
802     function _numberMinted(address owner) internal view returns (uint256) {
803         if (owner == address(0)) revert MintedQueryForZeroAddress();
804         return uint256(_addressData[owner].numberMinted);
805     }
806 
807     function _numberBurned(address owner) internal view returns (uint256) {
808         if (owner == address(0)) revert BurnedQueryForZeroAddress();
809         return uint256(_addressData[owner].numberBurned);
810     }
811 
812     /**
813      * Gas spent here starts off proportional to the maximum mint batch size.
814      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
815      */
816     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
817         uint256 curr = tokenId;
818 
819         unchecked {
820             if (curr < _currentIndex) {
821                 TokenOwnership memory ownership = _ownerships[curr];
822                 if (!ownership.burned) {
823                     if (ownership.addr != address(0)) {
824                         return ownership;
825                     }
826                     // Invariant: 
827                     // There will always be an ownership that has an address and is not burned 
828                     // before an ownership that does not have an address and is not burned.
829                     // Hence, curr will not underflow.
830                     while (true) {
831                         curr--;
832                         ownership = _ownerships[curr];
833                         if (ownership.addr != address(0)) {
834                             return ownership;
835                         }
836                     }
837                 }
838             }
839         }
840         revert OwnerQueryForNonexistentToken();
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view override returns (address) {
847         return ownershipOf(tokenId).addr;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public override {
887         address owner = ERC721A.ownerOf(tokenId);
888         if (to == owner) revert ApprovalToCurrentOwner();
889 
890         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
891             revert ApprovalCallerNotOwnerNorApproved();
892         }
893 
894         _approve(to, tokenId, owner);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view override returns (address) {
901         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public override {
910         if (operator == _msgSender()) revert ApproveToCaller();
911 
912         _operatorApprovals[_msgSender()][operator] = approved;
913         emit ApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         safeTransferFrom(from, to, tokenId, '');
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public virtual override {
954         _transfer(from, to, tokenId);
955         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
956             revert TransferToNonERC721ReceiverImplementer();
957         }
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted (`_mint`),
966      */
967     function _exists(uint256 tokenId) internal view returns (bool) {
968         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
969     }
970 
971     function _safeMint(address to, uint256 quantity) internal {
972         _safeMint(to, quantity, '');
973     }
974 
975     /**
976      * @dev Safely mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
981      * - `quantity` must be greater than 0.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(
986         address to,
987         uint256 quantity,
988         bytes memory _data
989     ) internal {
990         _mint(to, quantity, _data, true);
991     }
992 
993     /**
994      * @dev Mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - `to` cannot be the zero address.
999      * - `quantity` must be greater than 0.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _mint(
1004         address to,
1005         uint256 quantity,
1006         bytes memory _data,
1007         bool safe
1008     ) internal {
1009         uint256 startTokenId = _currentIndex;
1010         if (to == address(0)) revert MintToZeroAddress();
1011         if (quantity == 0) revert MintZeroQuantity();
1012 
1013         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1014 
1015         // Overflows are incredibly unrealistic.
1016         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1017         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1018         unchecked {
1019             _addressData[to].balance += uint64(quantity);
1020             _addressData[to].numberMinted += uint64(quantity);
1021 
1022             _ownerships[startTokenId].addr = to;
1023             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1024 
1025             uint256 updatedIndex = startTokenId;
1026 
1027             for (uint256 i; i < quantity; i++) {
1028                 emit Transfer(address(0), to, updatedIndex);
1029                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1030                     revert TransferToNonERC721ReceiverImplementer();
1031                 }
1032                 updatedIndex++;
1033             }
1034 
1035             _currentIndex = uint128(updatedIndex);
1036         }
1037         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must be owned by `from`.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _transfer(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) private {
1055         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1056 
1057         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1058             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1059             getApproved(tokenId) == _msgSender());
1060 
1061         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1062         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1063         if (to == address(0)) revert TransferToZeroAddress();
1064 
1065         _beforeTokenTransfers(from, to, tokenId, 1);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId, prevOwnership.addr);
1069 
1070         // Underflow of the sender's balance is impossible because we check for
1071         // ownership above and the recipient's balance can't realistically overflow.
1072         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1073         unchecked {
1074             _addressData[from].balance -= 1;
1075             _addressData[to].balance += 1;
1076 
1077             _ownerships[tokenId].addr = to;
1078             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1079 
1080             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1081             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1082             uint256 nextTokenId = tokenId + 1;
1083             if (_ownerships[nextTokenId].addr == address(0)) {
1084                 // This will suffice for checking _exists(nextTokenId),
1085                 // as a burned slot cannot contain the zero address.
1086                 if (nextTokenId < _currentIndex) {
1087                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1088                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1089                 }
1090             }
1091         }
1092 
1093         emit Transfer(from, to, tokenId);
1094         _afterTokenTransfers(from, to, tokenId, 1);
1095     }
1096 
1097     /**
1098      * @dev Destroys `tokenId`.
1099      * The approval is cleared when the token is burned.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must exist.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _burn(uint256 tokenId) internal virtual {
1108         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1109 
1110         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1111 
1112         // Clear approvals from the previous owner
1113         _approve(address(0), tokenId, prevOwnership.addr);
1114 
1115         // Underflow of the sender's balance is impossible because we check for
1116         // ownership above and the recipient's balance can't realistically overflow.
1117         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1118         unchecked {
1119             _addressData[prevOwnership.addr].balance -= 1;
1120             _addressData[prevOwnership.addr].numberBurned += 1;
1121 
1122             // Keep track of who burned the token, and the timestamp of burning.
1123             _ownerships[tokenId].addr = prevOwnership.addr;
1124             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1125             _ownerships[tokenId].burned = true;
1126 
1127             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1128             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1129             uint256 nextTokenId = tokenId + 1;
1130             if (_ownerships[nextTokenId].addr == address(0)) {
1131                 // This will suffice for checking _exists(nextTokenId),
1132                 // as a burned slot cannot contain the zero address.
1133                 if (nextTokenId < _currentIndex) {
1134                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1135                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1136                 }
1137             }
1138         }
1139 
1140         emit Transfer(prevOwnership.addr, address(0), tokenId);
1141         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1142 
1143         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1144         unchecked { 
1145             _burnCounter++;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Approve `to` to operate on `tokenId`
1151      *
1152      * Emits a {Approval} event.
1153      */
1154     function _approve(
1155         address to,
1156         uint256 tokenId,
1157         address owner
1158     ) private {
1159         _tokenApprovals[tokenId] = to;
1160         emit Approval(owner, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1165      * The call is not executed if the target address is not a contract.
1166      *
1167      * @param from address representing the previous owner of the given token ID
1168      * @param to target address that will receive the tokens
1169      * @param tokenId uint256 ID of the token to be transferred
1170      * @param _data bytes optional data to send along with the call
1171      * @return bool whether the call correctly returned the expected magic value
1172      */
1173     function _checkOnERC721Received(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) private returns (bool) {
1179         if (to.isContract()) {
1180             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1181                 return retval == IERC721Receiver(to).onERC721Received.selector;
1182             } catch (bytes memory reason) {
1183                 if (reason.length == 0) {
1184                     revert TransferToNonERC721ReceiverImplementer();
1185                 } else {
1186                     assembly {
1187                         revert(add(32, reason), mload(reason))
1188                     }
1189                 }
1190             }
1191         } else {
1192             return true;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1198      * And also called before burning one token.
1199      *
1200      * startTokenId - the first token id to be transferred
1201      * quantity - the amount to be transferred
1202      *
1203      * Calling conditions:
1204      *
1205      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1206      * transferred to `to`.
1207      * - When `from` is zero, `tokenId` will be minted for `to`.
1208      * - When `to` is zero, `tokenId` will be burned by `from`.
1209      * - `from` and `to` are never both zero.
1210      */
1211     function _beforeTokenTransfers(
1212         address from,
1213         address to,
1214         uint256 startTokenId,
1215         uint256 quantity
1216     ) internal virtual {}
1217 
1218     /**
1219      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1220      * minting.
1221      * And also called after one token has been burned.
1222      *
1223      * startTokenId - the first token id to be transferred
1224      * quantity - the amount to be transferred
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` has been minted for `to`.
1231      * - When `to` is zero, `tokenId` has been burned by `from`.
1232      * - `from` and `to` are never both zero.
1233      */
1234     function _afterTokenTransfers(
1235         address from,
1236         address to,
1237         uint256 startTokenId,
1238         uint256 quantity
1239     ) internal virtual {}
1240 }
1241 
1242 // File: @openzeppelin/contracts/access/Ownable.sol
1243 
1244 
1245 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 /**
1250  * @dev Contract module which provides a basic access control mechanism, where
1251  * there is an account (an owner) that can be granted exclusive access to
1252  * specific functions.
1253  *
1254  * By default, the owner account will be the one that deploys the contract. This
1255  * can later be changed with {transferOwnership}.
1256  *
1257  * This module is used through inheritance. It will make available the modifier
1258  * `onlyOwner`, which can be applied to your functions to restrict their use to
1259  * the owner.
1260  */
1261 abstract contract Ownable is Context {
1262     address private _owner;
1263 
1264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1265 
1266     /**
1267      * @dev Initializes the contract setting the deployer as the initial owner.
1268      */
1269     constructor() {
1270         _transferOwnership(_msgSender());
1271     }
1272 
1273     /**
1274      * @dev Returns the address of the current owner.
1275      */
1276     function owner() public view virtual returns (address) {
1277         return _owner;
1278     }
1279 
1280     /**
1281      * @dev Throws if called by any account other than the owner.
1282      */
1283     modifier onlyOwner() {
1284         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1285         _;
1286     }
1287 
1288     /**
1289      * @dev Leaves the contract without owner. It will not be possible to call
1290      * `onlyOwner` functions anymore. Can only be called by the current owner.
1291      *
1292      * NOTE: Renouncing ownership will leave the contract without an owner,
1293      * thereby removing any functionality that is only available to the owner.
1294      */
1295     function renounceOwnership() public virtual onlyOwner {
1296         _transferOwnership(address(0));
1297     }
1298 
1299     /**
1300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1301      * Can only be called by the current owner.
1302      */
1303     function transferOwnership(address newOwner) public virtual onlyOwner {
1304         require(newOwner != address(0), "Ownable: new owner is the zero address");
1305         _transferOwnership(newOwner);
1306     }
1307 
1308     /**
1309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1310      * Internal function without access restriction.
1311      */
1312     function _transferOwnership(address newOwner) internal virtual {
1313         address oldOwner = _owner;
1314         _owner = newOwner;
1315         emit OwnershipTransferred(oldOwner, newOwner);
1316     }
1317 }
1318 
1319 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1320 
1321 
1322 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 /**
1327  * @dev Contract module that helps prevent reentrant calls to a function.
1328  *
1329  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1330  * available, which can be applied to functions to make sure there are no nested
1331  * (reentrant) calls to them.
1332  *
1333  * Note that because there is a single `nonReentrant` guard, functions marked as
1334  * `nonReentrant` may not call one another. This can be worked around by making
1335  * those functions `private`, and then adding `external` `nonReentrant` entry
1336  * points to them.
1337  *
1338  * TIP: If you would like to learn more about reentrancy and alternative ways
1339  * to protect against it, check out our blog post
1340  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1341  */
1342 abstract contract ReentrancyGuard {
1343     // Booleans are more expensive than uint256 or any type that takes up a full
1344     // word because each write operation emits an extra SLOAD to first read the
1345     // slot's contents, replace the bits taken up by the boolean, and then write
1346     // back. This is the compiler's defense against contract upgrades and
1347     // pointer aliasing, and it cannot be disabled.
1348 
1349     // The values being non-zero value makes deployment a bit more expensive,
1350     // but in exchange the refund on every call to nonReentrant will be lower in
1351     // amount. Since refunds are capped to a percentage of the total
1352     // transaction's gas, it is best to keep them low in cases like this one, to
1353     // increase the likelihood of the full refund coming into effect.
1354     uint256 private constant _NOT_ENTERED = 1;
1355     uint256 private constant _ENTERED = 2;
1356 
1357     uint256 private _status;
1358 
1359     constructor() {
1360         _status = _NOT_ENTERED;
1361     }
1362 
1363     /**
1364      * @dev Prevents a contract from calling itself, directly or indirectly.
1365      * Calling a `nonReentrant` function from another `nonReentrant`
1366      * function is not supported. It is possible to prevent this from happening
1367      * by making the `nonReentrant` function external, and making it call a
1368      * `private` function that does the actual work.
1369      */
1370     modifier nonReentrant() {
1371         // On the first call to nonReentrant, _notEntered will be true
1372         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1373 
1374         // Any calls to nonReentrant after this point will fail
1375         _status = _ENTERED;
1376 
1377         _;
1378 
1379         // By storing the original value once again, a refund is triggered (see
1380         // https://eips.ethereum.org/EIPS/eip-2200)
1381         _status = _NOT_ENTERED;
1382     }
1383 }
1384 
1385 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1386 
1387 
1388 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1389 
1390 pragma solidity ^0.8.0;
1391 
1392 // CAUTION
1393 // This version of SafeMath should only be used with Solidity 0.8 or later,
1394 // because it relies on the compiler's built in overflow checks.
1395 
1396 /**
1397  * @dev Wrappers over Solidity's arithmetic operations.
1398  *
1399  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1400  * now has built in overflow checking.
1401  */
1402 library SafeMath {
1403     /**
1404      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1405      *
1406      * _Available since v3.4._
1407      */
1408     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1409         unchecked {
1410             uint256 c = a + b;
1411             if (c < a) return (false, 0);
1412             return (true, c);
1413         }
1414     }
1415 
1416     /**
1417      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1418      *
1419      * _Available since v3.4._
1420      */
1421     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1422         unchecked {
1423             if (b > a) return (false, 0);
1424             return (true, a - b);
1425         }
1426     }
1427 
1428     /**
1429      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1430      *
1431      * _Available since v3.4._
1432      */
1433     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1434         unchecked {
1435             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1436             // benefit is lost if 'b' is also tested.
1437             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1438             if (a == 0) return (true, 0);
1439             uint256 c = a * b;
1440             if (c / a != b) return (false, 0);
1441             return (true, c);
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1447      *
1448      * _Available since v3.4._
1449      */
1450     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1451         unchecked {
1452             if (b == 0) return (false, 0);
1453             return (true, a / b);
1454         }
1455     }
1456 
1457     /**
1458      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1459      *
1460      * _Available since v3.4._
1461      */
1462     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1463         unchecked {
1464             if (b == 0) return (false, 0);
1465             return (true, a % b);
1466         }
1467     }
1468 
1469     /**
1470      * @dev Returns the addition of two unsigned integers, reverting on
1471      * overflow.
1472      *
1473      * Counterpart to Solidity's `+` operator.
1474      *
1475      * Requirements:
1476      *
1477      * - Addition cannot overflow.
1478      */
1479     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1480         return a + b;
1481     }
1482 
1483     /**
1484      * @dev Returns the subtraction of two unsigned integers, reverting on
1485      * overflow (when the result is negative).
1486      *
1487      * Counterpart to Solidity's `-` operator.
1488      *
1489      * Requirements:
1490      *
1491      * - Subtraction cannot overflow.
1492      */
1493     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1494         return a - b;
1495     }
1496 
1497     /**
1498      * @dev Returns the multiplication of two unsigned integers, reverting on
1499      * overflow.
1500      *
1501      * Counterpart to Solidity's `*` operator.
1502      *
1503      * Requirements:
1504      *
1505      * - Multiplication cannot overflow.
1506      */
1507     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1508         return a * b;
1509     }
1510 
1511     /**
1512      * @dev Returns the integer division of two unsigned integers, reverting on
1513      * division by zero. The result is rounded towards zero.
1514      *
1515      * Counterpart to Solidity's `/` operator.
1516      *
1517      * Requirements:
1518      *
1519      * - The divisor cannot be zero.
1520      */
1521     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1522         return a / b;
1523     }
1524 
1525     /**
1526      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1527      * reverting when dividing by zero.
1528      *
1529      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1530      * opcode (which leaves remaining gas untouched) while Solidity uses an
1531      * invalid opcode to revert (consuming all remaining gas).
1532      *
1533      * Requirements:
1534      *
1535      * - The divisor cannot be zero.
1536      */
1537     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1538         return a % b;
1539     }
1540 
1541     /**
1542      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1543      * overflow (when the result is negative).
1544      *
1545      * CAUTION: This function is deprecated because it requires allocating memory for the error
1546      * message unnecessarily. For custom revert reasons use {trySub}.
1547      *
1548      * Counterpart to Solidity's `-` operator.
1549      *
1550      * Requirements:
1551      *
1552      * - Subtraction cannot overflow.
1553      */
1554     function sub(
1555         uint256 a,
1556         uint256 b,
1557         string memory errorMessage
1558     ) internal pure returns (uint256) {
1559         unchecked {
1560             require(b <= a, errorMessage);
1561             return a - b;
1562         }
1563     }
1564 
1565     /**
1566      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1567      * division by zero. The result is rounded towards zero.
1568      *
1569      * Counterpart to Solidity's `/` operator. Note: this function uses a
1570      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1571      * uses an invalid opcode to revert (consuming all remaining gas).
1572      *
1573      * Requirements:
1574      *
1575      * - The divisor cannot be zero.
1576      */
1577     function div(
1578         uint256 a,
1579         uint256 b,
1580         string memory errorMessage
1581     ) internal pure returns (uint256) {
1582         unchecked {
1583             require(b > 0, errorMessage);
1584             return a / b;
1585         }
1586     }
1587 
1588     /**
1589      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1590      * reverting with custom message when dividing by zero.
1591      *
1592      * CAUTION: This function is deprecated because it requires allocating memory for the error
1593      * message unnecessarily. For custom revert reasons use {tryMod}.
1594      *
1595      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1596      * opcode (which leaves remaining gas untouched) while Solidity uses an
1597      * invalid opcode to revert (consuming all remaining gas).
1598      *
1599      * Requirements:
1600      *
1601      * - The divisor cannot be zero.
1602      */
1603     function mod(
1604         uint256 a,
1605         uint256 b,
1606         string memory errorMessage
1607     ) internal pure returns (uint256) {
1608         unchecked {
1609             require(b > 0, errorMessage);
1610             return a % b;
1611         }
1612     }
1613 }
1614 
1615 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1616 
1617 
1618 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1619 
1620 pragma solidity ^0.8.0;
1621 
1622 /**
1623  * @dev These functions deal with verification of Merkle Trees proofs.
1624  *
1625  * The proofs can be generated using the JavaScript library
1626  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1627  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1628  *
1629  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1630  */
1631 library MerkleProof {
1632     /**
1633      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1634      * defined by `root`. For this, a `proof` must be provided, containing
1635      * sibling hashes on the branch from the leaf to the root of the tree. Each
1636      * pair of leaves and each pair of pre-images are assumed to be sorted.
1637      */
1638     function verify(
1639         bytes32[] memory proof,
1640         bytes32 root,
1641         bytes32 leaf
1642     ) internal pure returns (bool) {
1643         return processProof(proof, leaf) == root;
1644     }
1645 
1646     /**
1647      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1648      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1649      * hash matches the root of the tree. When processing the proof, the pairs
1650      * of leafs & pre-images are assumed to be sorted.
1651      *
1652      * _Available since v4.4._
1653      */
1654     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1655         bytes32 computedHash = leaf;
1656         for (uint256 i = 0; i < proof.length; i++) {
1657             bytes32 proofElement = proof[i];
1658             if (computedHash <= proofElement) {
1659                 // Hash(current computed hash + current element of the proof)
1660                 computedHash = _efficientHash(computedHash, proofElement);
1661             } else {
1662                 // Hash(current element of the proof + current computed hash)
1663                 computedHash = _efficientHash(proofElement, computedHash);
1664             }
1665         }
1666         return computedHash;
1667     }
1668 
1669     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1670         assembly {
1671             mstore(0x00, a)
1672             mstore(0x20, b)
1673             value := keccak256(0x00, 0x40)
1674         }
1675     }
1676 }
1677 
1678 // File: contracts/siimplex.sol
1679 
1680 
1681 
1682 pragma solidity ^0.8.4;
1683 
1684 
1685 
1686 
1687 
1688 contract siimplex is ERC721A, Ownable, ReentrancyGuard {
1689 
1690     using Strings for uint256;
1691 
1692     bytes32 public MERKLE_ROOT; 
1693 
1694     uint256 public PRICE;
1695     string private BASE_URI;
1696 
1697     bool public IS_PRE_SALE_ACTIVE;
1698     bool public IS_PUBLIC_SALE_ACTIVE;
1699     
1700     uint256 public MAX_MINT_PER_TRANSACTION;
1701     uint256 public MAX_FREE_MINT_PER_WALLET;
1702     
1703     uint256 public MAX_FREE_MINT_SUPPLY; 
1704     uint256 public MAX_SUPPLY;
1705     
1706     mapping(address => uint256) private freeMintCounts;
1707 
1708     constructor(
1709         bytes32 merkleRoot, 
1710         uint256 price, 
1711         string memory baseURI, 
1712         uint256 maxFreeMintPerWallet, 
1713         uint256 maxMintPerTransaction,
1714         uint256 maxFreeMintSupply,
1715         uint256 maxSupply
1716         ) ERC721A("siimplex", "siimplex") {
1717 
1718         MERKLE_ROOT = merkleRoot;
1719         
1720         PRICE = price;
1721         
1722         BASE_URI = baseURI;
1723 
1724         IS_PRE_SALE_ACTIVE = false;
1725         IS_PUBLIC_SALE_ACTIVE = false;
1726 
1727         MAX_FREE_MINT_PER_WALLET = maxFreeMintPerWallet;
1728         MAX_MINT_PER_TRANSACTION = maxMintPerTransaction;
1729 
1730         MAX_FREE_MINT_SUPPLY = maxFreeMintSupply;
1731         MAX_SUPPLY = maxSupply;
1732     }
1733 
1734     function _baseURI() internal view virtual override returns (string memory) {
1735         return BASE_URI;
1736     }
1737 
1738     function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
1739         MERKLE_ROOT = newMerkleRoot;
1740     }
1741 
1742     function setMaxFreeMintPerWallet(uint256 maxFreeMint) external onlyOwner {
1743         MAX_FREE_MINT_PER_WALLET = maxFreeMint;
1744     }
1745 
1746     function setMaxMintPerTransaction(uint256 newMaxMintPerTransaction) external onlyOwner {
1747         MAX_MINT_PER_TRANSACTION = newMaxMintPerTransaction;
1748     }
1749 
1750     function setPrice(uint256 customPrice) external onlyOwner {
1751         PRICE = customPrice;
1752     }
1753     
1754     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1755         require(newMaxSupply < MAX_SUPPLY, "New max supply must be lower than current");
1756         require(newMaxSupply >= _currentIndex, "New max supply lower than total number of mints");
1757         MAX_SUPPLY = newMaxSupply;
1758     }
1759 
1760     function raiseMaxFreeMintSupply(uint256 newMaxFreeMintSupply) external onlyOwner {
1761         require(newMaxFreeMintSupply <= MAX_SUPPLY, "New max free mint supply must be lower or equal to max supply");
1762         require(newMaxFreeMintSupply > MAX_FREE_MINT_SUPPLY, "New max free mint supply must be higher than current");
1763         require(newMaxFreeMintSupply > _currentIndex, "New max free mint supply must be higher than the current index");
1764 
1765         MAX_FREE_MINT_SUPPLY = newMaxFreeMintSupply;
1766     }
1767 
1768     function setBaseURI(string memory newBaseURI) external onlyOwner {
1769         BASE_URI = newBaseURI;
1770     }
1771 
1772     function setPreSaleActive(bool preSaleIsActive) external onlyOwner {
1773         IS_PRE_SALE_ACTIVE = preSaleIsActive;
1774     }
1775 
1776     function setPublicSaleActive(bool publicSaleIsActive) external onlyOwner {
1777         IS_PUBLIC_SALE_ACTIVE = publicSaleIsActive;
1778     }
1779 
1780     modifier validMintAmount(uint256 _mintAmount) {
1781         require(_mintAmount > 0, "Must mint at least one token");
1782         require(_currentIndex + _mintAmount <= MAX_SUPPLY, "Exceeded max tokens minted");
1783         _;
1784     }
1785 
1786     function freeMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable validMintAmount(_mintAmount) {
1787         require(IS_PRE_SALE_ACTIVE, "Pre-sale is not active");
1788         require(MerkleProof.verify(_merkleProof, MERKLE_ROOT, keccak256(abi.encodePacked(msg.sender))), "Address is not whitelisted");
1789         require(freeMintCounts[msg.sender] + _mintAmount <= MAX_FREE_MINT_PER_WALLET, "Max amount of free mints per wallet exceeded");
1790         require(totalSupply() + _mintAmount <= MAX_FREE_MINT_SUPPLY, "Max free mint supply exceeded");
1791 
1792         freeMintCounts[msg.sender] += _mintAmount;
1793 
1794         _safeMint(msg.sender, _mintAmount);
1795     }
1796 
1797     function mint(uint256 _mintAmount) public payable validMintAmount(_mintAmount) {
1798         require(IS_PUBLIC_SALE_ACTIVE, "Public sale is not active");
1799         require(_mintAmount <= MAX_MINT_PER_TRANSACTION, "Max amount of mints per transaction exceeded");
1800         require(msg.value >= SafeMath.mul(PRICE, _mintAmount), "Insufficient funds");
1801         
1802         _safeMint(msg.sender, _mintAmount);
1803     }
1804 
1805     function mintOwner(address _to, uint256 _mintAmount) public onlyOwner {
1806         require(_mintAmount > 0, "Must mint at least one token");
1807         require(_currentIndex + _mintAmount <= MAX_SUPPLY, "Exceeded max tokens minted");
1808         
1809         _safeMint(_to, _mintAmount);
1810     }
1811 
1812     address private constant payoutAddress = 0xDaA7E2c646E2A9A6ab9bCB503881eD790A849C49;
1813 
1814     function withdraw() public onlyOwner nonReentrant {
1815         uint256 balance = address(this).balance;
1816         Address.sendValue(payable(payoutAddress), balance);
1817     }
1818 
1819 }