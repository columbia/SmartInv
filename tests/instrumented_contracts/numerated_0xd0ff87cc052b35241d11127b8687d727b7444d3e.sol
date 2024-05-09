1 // File contracts/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
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
29 
30 // File contracts/ERC165.sol
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Implementation of the {IERC165} interface.
38  *
39  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
40  * for the additional interface id that will be supported. For example:
41  *
42  * ```solidity
43  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
44  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
45  * }
46  * ```
47  *
48  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
49  */
50 abstract contract ERC165 is IERC165 {
51     /**
52      * @dev See {IERC165-supportsInterface}.
53      */
54     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
55         return interfaceId == type(IERC165).interfaceId;
56     }
57 }
58 
59 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.2
60 
61 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must exist and be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
108      *
109      * Emits a {Transfer} event.
110      */
111     function safeTransferFrom(
112         address from,
113         address to,
114         uint256 tokenId,
115         bytes calldata data
116     ) external;
117 
118     /**
119      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
120      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
121      *
122      * Requirements:
123      *
124      * - `from` cannot be the zero address.
125      * - `to` cannot be the zero address.
126      * - `tokenId` token must exist and be owned by `from`.
127      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
129      *
130      * Emits a {Transfer} event.
131      */
132     function safeTransferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Transfers `tokenId` token from `from` to `to`.
140      *
141      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address from,
154         address to,
155         uint256 tokenId
156     ) external;
157 
158     /**
159      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
160      * The approval is cleared when the token is transferred.
161      *
162      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
163      *
164      * Requirements:
165      *
166      * - The caller must own the token or be an approved operator.
167      * - `tokenId` must exist.
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address to, uint256 tokenId) external;
172 
173     /**
174      * @dev Approve or remove `operator` as an operator for the caller.
175      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
176      *
177      * Requirements:
178      *
179      * - The `operator` cannot be the caller.
180      *
181      * Emits an {ApprovalForAll} event.
182      */
183     function setApprovalForAll(address operator, bool _approved) external;
184 
185     /**
186      * @dev Returns the account approved for `tokenId` token.
187      *
188      * Requirements:
189      *
190      * - `tokenId` must exist.
191      */
192     function getApproved(uint256 tokenId) external view returns (address operator);
193 
194     /**
195      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
196      *
197      * See {setApprovalForAll}
198      */
199     function isApprovedForAll(address owner, address operator) external view returns (bool);
200 }
201 
202 
203 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.2
204 
205 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @title ERC721 token receiver interface
211  * @dev Interface for any contract that wants to support safeTransfers
212  * from ERC721 asset contracts.
213  */
214 interface IERC721Receiver {
215     /**
216      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
217      * by `operator` from `from`, this function is called.
218      *
219      * It must return its Solidity selector to confirm the token transfer.
220      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
221      *
222      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
223      */
224     function onERC721Received(
225         address operator,
226         address from,
227         uint256 tokenId,
228         bytes calldata data
229     ) external returns (bytes4);
230 }
231 
232 
233 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.2
234 
235 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
241  * @dev See https://eips.ethereum.org/EIPS/eip-721
242  */
243 interface IERC721Metadata is IERC721 {
244     /**
245      * @dev Returns the token collection name.
246      */
247     function name() external view returns (string memory);
248 
249     /**
250      * @dev Returns the token collection symbol.
251      */
252     function symbol() external view returns (string memory);
253 
254     /**
255      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
256      */
257     function tokenURI(uint256 tokenId) external view returns (string memory);
258 }
259 
260 
261 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.7.2
262 
263 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
269  * @dev See https://eips.ethereum.org/EIPS/eip-721
270  */
271 interface IERC721Enumerable is IERC721 {
272     /**
273      * @dev Returns the total amount of tokens stored by the contract.
274      */
275     function totalSupply() external view returns (uint256);
276 
277     /**
278      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
279      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
280      */
281     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
282 
283     /**
284      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
285      * Use along with {totalSupply} to enumerate all tokens.
286      */
287     function tokenByIndex(uint256 index) external view returns (uint256);
288 }
289 
290 
291 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
292 
293 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
294 
295 pragma solidity ^0.8.1;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      *
318      * [IMPORTANT]
319      * ====
320      * You shouldn't rely on `isContract` to protect against flash loan attacks!
321      *
322      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
323      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
324      * constructor.
325      * ====
326      */
327     function isContract(address account) internal view returns (bool) {
328         // This method relies on extcodesize/address.code.length, which returns 0
329         // for contracts in construction, since the code is only stored at the end
330         // of the constructor execution.
331 
332         return account.code.length > 0;
333     }
334 
335     /**
336      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
337      * `recipient`, forwarding all available gas and reverting on errors.
338      *
339      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
340      * of certain opcodes, possibly making contracts go over the 2300 gas limit
341      * imposed by `transfer`, making them unable to receive funds via
342      * `transfer`. {sendValue} removes this limitation.
343      *
344      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
345      *
346      * IMPORTANT: because control is transferred to `recipient`, care must be
347      * taken to not create reentrancy vulnerabilities. Consider using
348      * {ReentrancyGuard} or the
349      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
350      */
351     function sendValue(address payable recipient, uint256 amount) internal {
352         require(address(this).balance >= amount, "Address: insufficient balance");
353 
354         (bool success, ) = recipient.call{value: amount}("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain `call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         return functionCallWithValue(target, data, 0, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but also transferring `value` wei to `target`.
397      *
398      * Requirements:
399      *
400      * - the calling contract must have an ETH balance of at least `value`.
401      * - the called Solidity function must be `payable`.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value
409     ) internal returns (bytes memory) {
410         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(address(this).balance >= value, "Address: insufficient balance for call");
426         require(isContract(target), "Address: call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.call{value: value}(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
439         return functionStaticCall(target, data, "Address: low-level static call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal view returns (bytes memory) {
453         require(isContract(target), "Address: static call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.staticcall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but performing a delegate call.
462      *
463      * _Available since v3.4._
464      */
465     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         require(isContract(target), "Address: delegate call to non-contract");
481 
482         (bool success, bytes memory returndata) = target.delegatecall(data);
483         return verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
488      * revert reason using the provided one.
489      *
490      * _Available since v4.3._
491      */
492     function verifyCallResult(
493         bool success,
494         bytes memory returndata,
495         string memory errorMessage
496     ) internal pure returns (bytes memory) {
497         if (success) {
498             return returndata;
499         } else {
500             // Look for revert reason and bubble it up if present
501             if (returndata.length > 0) {
502                 // The easiest way to bubble the revert reason is using memory via assembly
503                 /// @solidity memory-safe-assembly
504                 assembly {
505                     let returndata_size := mload(returndata)
506                     revert(add(32, returndata), returndata_size)
507                 }
508             } else {
509                 revert(errorMessage);
510             }
511         }
512     }
513 }
514 
515 
516 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Provides information about the current execution context, including the
524  * sender of the transaction and its data. While these are generally available
525  * via msg.sender and msg.data, they should not be accessed in such a direct
526  * manner, since when dealing with meta-transactions the account sending and
527  * paying for execution may not be the actual sender (as far as an application
528  * is concerned).
529  *
530  * This contract is only required for intermediate, library-like contracts.
531  */
532 abstract contract Context {
533     function _msgSender() internal view virtual returns (address) {
534         return msg.sender;
535     }
536 
537     function _msgData() internal view virtual returns (bytes calldata) {
538         return msg.data;
539     }
540 }
541 
542 
543 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.2
544 
545 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @dev String operations.
551  */
552 library Strings {
553     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
554     uint8 private constant _ADDRESS_LENGTH = 20;
555 
556     /**
557      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
558      */
559     function toString(uint256 value) internal pure returns (string memory) {
560         // Inspired by OraclizeAPI's implementation - MIT licence
561         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
562 
563         if (value == 0) {
564             return "0";
565         }
566         uint256 temp = value;
567         uint256 digits;
568         while (temp != 0) {
569             digits++;
570             temp /= 10;
571         }
572         bytes memory buffer = new bytes(digits);
573         while (value != 0) {
574             digits -= 1;
575             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
576             value /= 10;
577         }
578         return string(buffer);
579     }
580 
581     /**
582      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
583      */
584     function toHexString(uint256 value) internal pure returns (string memory) {
585         if (value == 0) {
586             return "0x00";
587         }
588         uint256 temp = value;
589         uint256 length = 0;
590         while (temp != 0) {
591             length++;
592             temp >>= 8;
593         }
594         return toHexString(value, length);
595     }
596 
597     /**
598      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
599      */
600     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
601         bytes memory buffer = new bytes(2 * length + 2);
602         buffer[0] = "0";
603         buffer[1] = "x";
604         for (uint256 i = 2 * length + 1; i > 1; --i) {
605             buffer[i] = _HEX_SYMBOLS[value & 0xf];
606             value >>= 4;
607         }
608         require(value == 0, "Strings: hex length insufficient");
609         return string(buffer);
610     }
611 
612     /**
613      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
614      */
615     function toHexString(address addr) internal pure returns (string memory) {
616         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
617     }
618 }
619 
620 
621 // File contracts/ERC721A.sol
622 
623 // Creator: Chiru Labs
624 
625 pragma solidity ^0.8.4;
626 
627 
628 
629 
630 
631 
632 
633 
634 error ApprovalCallerNotOwnerNorApproved();
635 error ApprovalQueryForNonexistentToken();
636 error ApproveToCaller();
637 error ApprovalToCurrentOwner();
638 error BalanceQueryForZeroAddress();
639 error MintedQueryForZeroAddress();
640 error BurnedQueryForZeroAddress();
641 error AuxQueryForZeroAddress();
642 error MintToZeroAddress();
643 error MintZeroQuantity();
644 error OwnerIndexOutOfBounds();
645 error OwnerQueryForNonexistentToken();
646 error TokenIndexOutOfBounds();
647 error TransferCallerNotOwnerNorApproved();
648 error TransferFromIncorrectOwner();
649 error TransferToNonERC721ReceiverImplementer();
650 error TransferToZeroAddress();
651 error URIQueryForNonexistentToken();
652 
653 /**
654  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
655  * the Metadata extension. Built to optimize for lower gas during batch mints.
656  *
657  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
658  *
659  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
660  *
661  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
662  */
663 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
664     using Address for address;
665     using Strings for uint256;
666 
667     // Compiler will pack this into a single 256bit word.
668     struct TokenOwnership {
669         // The address of the owner.
670         address addr;
671         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
672         uint64 startTimestamp;
673         // Whether the token has been burned.
674         bool burned;
675     }
676 
677     // Compiler will pack this into a single 256bit word.
678     struct AddressData {
679         // Realistically, 2**64-1 is more than enough.
680         uint64 balance;
681         // Keeps track of mint count with minimal overhead for tokenomics.
682         uint64 numberMinted;
683         // Keeps track of burn count with minimal overhead for tokenomics.
684         uint64 numberBurned;
685         // For miscellaneous variable(s) pertaining to the address
686         // (e.g. number of whitelist mint slots used).
687         // If there are multiple variables, please pack them into a uint64.
688         uint64 aux;
689     }
690 
691     // The tokenId of the next token to be minted.
692     uint256 internal _currentIndex;
693 
694     // The number of tokens burned.
695     uint256 internal _burnCounter;
696 
697     // Token name
698     string private _name;
699 
700     // Token symbol
701     string private _symbol;
702 
703     // Mapping from token ID to ownership details
704     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
705     mapping(uint256 => TokenOwnership) internal _ownerships;
706 
707     // Mapping owner address to address data
708     mapping(address => AddressData) private _addressData;
709 
710     // Mapping from token ID to approved address
711     mapping(uint256 => address) private _tokenApprovals;
712 
713     // Mapping from owner to operator approvals
714     mapping(address => mapping(address => bool)) private _operatorApprovals;
715 
716     constructor(string memory name_, string memory symbol_) {
717         _name = name_;
718         _symbol = symbol_;
719         _currentIndex = _startTokenId();
720     }
721 
722     /**
723      * To change the starting tokenId, please override this function.
724      */
725     function _startTokenId() internal view virtual returns (uint256) {
726         return 1;
727     }
728 
729     /**
730      * @dev See {IERC721Enumerable-totalSupply}.
731      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
732      */
733     function totalSupply() public view returns (uint256) {
734         // Counter underflow is impossible as _burnCounter cannot be incremented
735         // more than _currentIndex - _startTokenId() times
736         unchecked {
737             return _currentIndex - _burnCounter - _startTokenId();
738         }
739     }
740 
741     /**
742      * Returns the total amount of tokens minted in the contract.
743      */
744     function _totalMinted() internal view returns (uint256) {
745         // Counter underflow is impossible as _currentIndex does not decrement,
746         // and it is initialized to _startTokenId()
747         unchecked {
748             return _currentIndex - _startTokenId();
749         }
750     }
751 
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
756         return
757             interfaceId == type(IERC721).interfaceId ||
758             interfaceId == type(IERC721Metadata).interfaceId ||
759             super.supportsInterface(interfaceId);
760     }
761 
762     /**
763      * @dev See {IERC721-balanceOf}.
764      */
765     function balanceOf(address owner) public view override returns (uint256) {
766         if (owner == address(0)) revert BalanceQueryForZeroAddress();
767         return uint256(_addressData[owner].balance);
768     }
769 
770     /**
771      * Returns the number of tokens minted by `owner`.
772      */
773     function _numberMinted(address owner) internal view returns (uint256) {
774         if (owner == address(0)) revert MintedQueryForZeroAddress();
775         return uint256(_addressData[owner].numberMinted);
776     }
777 
778     /**
779      * Returns the number of tokens burned by or on behalf of `owner`.
780      */
781     function _numberBurned(address owner) internal view returns (uint256) {
782         if (owner == address(0)) revert BurnedQueryForZeroAddress();
783         return uint256(_addressData[owner].numberBurned);
784     }
785 
786     /**
787      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
788      */
789     function _getAux(address owner) internal view returns (uint64) {
790         if (owner == address(0)) revert AuxQueryForZeroAddress();
791         return _addressData[owner].aux;
792     }
793 
794     /**
795      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
796      * If there are multiple variables, please pack them into a uint64.
797      */
798     function _setAux(address owner, uint64 aux) internal {
799         if (owner == address(0)) revert AuxQueryForZeroAddress();
800         _addressData[owner].aux = aux;
801     }
802 
803 
804     /**
805      * Gas spent here starts off proportional to the maximum mint batch size.
806      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
807      */
808     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
809         uint256 curr = tokenId;
810 
811         unchecked {
812             if (_startTokenId() <= curr && curr < _currentIndex) {
813                 TokenOwnership memory ownership = _ownerships[curr];
814                 if (!ownership.burned) {
815                     if (ownership.addr != address(0)) {
816                         return ownership;
817                     }
818                     // Invariant:
819                     // There will always be an ownership that has an address and is not burned
820                     // before an ownership that does not have an address and is not burned.
821                     // Hence, curr will not underflow.
822                     while (true) {
823                         curr--;
824                         ownership = _ownerships[curr];
825                         if (ownership.addr != address(0)) {
826                             return ownership;
827                         }
828                     }
829                 }
830             }
831         }
832         revert OwnerQueryForNonexistentToken();
833     }
834 
835     /**
836      * @dev See {IERC721-ownerOf}.
837      */
838     function ownerOf(uint256 tokenId) public view override returns (address) {
839         return ownershipOf(tokenId).addr;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
860         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
861 
862         string memory baseURI = _baseURI();
863         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
864     }
865 
866     /**
867      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869      * by default, can be overriden in child contracts.
870      */
871     function _baseURI() internal view virtual returns (string memory) {
872         return '';
873     }
874 
875     /**
876      * @dev See {IERC721-approve}.
877      */
878     function approve(address to, uint256 tokenId) public override {
879         address owner = ERC721A.ownerOf(tokenId);
880         if (to == owner) revert ApprovalToCurrentOwner();
881 
882         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
883             revert ApprovalCallerNotOwnerNorApproved();
884         }
885 
886         _approve(to, tokenId, owner);
887     }
888 
889     /**
890      * @dev See {IERC721-getApproved}.
891      */
892     function getApproved(uint256 tokenId) public view override returns (address) {
893         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
894 
895         return _tokenApprovals[tokenId];
896     }
897 
898     /**
899      * @dev See {IERC721-setApprovalForAll}.
900      */
901     function setApprovalForAll(address operator, bool approved) public override {
902         if (operator == _msgSender()) revert ApproveToCaller();
903 
904         _operatorApprovals[_msgSender()][operator] = approved;
905         emit ApprovalForAll(_msgSender(), operator, approved);
906     }
907 
908     /**
909      * @dev See {IERC721-isApprovedForAll}.
910      */
911     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
912         return _operatorApprovals[owner][operator];
913     }
914 
915     /**
916      * @dev See {IERC721-transferFrom}.
917      */
918     function transferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) public virtual override {
923         _transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         safeTransferFrom(from, to, tokenId, '');
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) public virtual override {
946         _transfer(from, to, tokenId);
947         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
948             revert TransferToNonERC721ReceiverImplementer();
949         }
950     }
951 
952     /**
953      * @dev Returns whether `tokenId` exists.
954      *
955      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
956      *
957      * Tokens start existing when they are minted (`_mint`),
958      */
959     function _exists(uint256 tokenId) internal view returns (bool) {
960         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
961             !_ownerships[tokenId].burned;
962     }
963 
964     function _safeMint(address to, uint256 quantity) internal {
965         _safeMint(to, quantity, '');
966     }
967 
968     /**
969      * @dev Safely mints `quantity` tokens and transfers them to `to`.
970      *
971      * Requirements:
972      *
973      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
974      * - `quantity` must be greater than 0.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _safeMint(
979         address to,
980         uint256 quantity,
981         bytes memory _data
982     ) internal {
983         _mint(to, quantity, _data, true);
984     }
985 
986     /**
987      * @dev Mints `quantity` tokens and transfers them to `to`.
988      *
989      * Requirements:
990      *
991      * - `to` cannot be the zero address.
992      * - `quantity` must be greater than 0.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _mint(
997         address to,
998         uint256 quantity,
999         bytes memory _data,
1000         bool safe
1001     ) internal {
1002         uint256 startTokenId = _currentIndex;
1003         if (to == address(0)) revert MintToZeroAddress();
1004         if (quantity == 0) revert MintZeroQuantity();
1005 
1006         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1007 
1008         // Overflows are incredibly unrealistic.
1009         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1010         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1011         unchecked {
1012             _addressData[to].balance += uint64(quantity);
1013             _addressData[to].numberMinted += uint64(quantity);
1014 
1015             _ownerships[startTokenId].addr = to;
1016             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1017 
1018             uint256 updatedIndex = startTokenId;
1019             uint256 end = updatedIndex + quantity;
1020 
1021             if (safe && to.isContract()) {
1022                 do {
1023                     emit Transfer(address(0), to, updatedIndex);
1024                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1025                         revert TransferToNonERC721ReceiverImplementer();
1026                     }
1027                 } while (updatedIndex != end);
1028                 // Reentrancy protection
1029                 if (_currentIndex != startTokenId) revert();
1030             } else {
1031                 do {
1032                     emit Transfer(address(0), to, updatedIndex++);
1033                 } while (updatedIndex != end);
1034             }
1035             _currentIndex = updatedIndex;
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
1072         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
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
1117         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
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
1164      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1165      *
1166      * @param from address representing the previous owner of the given token ID
1167      * @param to target address that will receive the tokens
1168      * @param tokenId uint256 ID of the token to be transferred
1169      * @param _data bytes optional data to send along with the call
1170      * @return bool whether the call correctly returned the expected magic value
1171      */
1172     function _checkContractOnERC721Received(
1173         address from,
1174         address to,
1175         uint256 tokenId,
1176         bytes memory _data
1177     ) private returns (bool) {
1178         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1179             return retval == IERC721Receiver(to).onERC721Received.selector;
1180         } catch (bytes memory reason) {
1181             if (reason.length == 0) {
1182                 revert TransferToNonERC721ReceiverImplementer();
1183             } else {
1184                 assembly {
1185                     revert(add(32, reason), mload(reason))
1186                 }
1187             }
1188         }
1189     }
1190 
1191     /**
1192      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1193      * And also called before burning one token.
1194      *
1195      * startTokenId - the first token id to be transferred
1196      * quantity - the amount to be transferred
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, `tokenId` will be burned by `from`.
1204      * - `from` and `to` are never both zero.
1205      */
1206     function _beforeTokenTransfers(
1207         address from,
1208         address to,
1209         uint256 startTokenId,
1210         uint256 quantity
1211     ) internal virtual {}
1212 
1213     /**
1214      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1215      * minting.
1216      * And also called after one token has been burned.
1217      *
1218      * startTokenId - the first token id to be transferred
1219      * quantity - the amount to be transferred
1220      *
1221      * Calling conditions:
1222      *
1223      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1224      * transferred to `to`.
1225      * - When `from` is zero, `tokenId` has been minted for `to`.
1226      * - When `to` is zero, `tokenId` has been burned by `from`.
1227      * - `from` and `to` are never both zero.
1228      */
1229     function _afterTokenTransfers(
1230         address from,
1231         address to,
1232         uint256 startTokenId,
1233         uint256 quantity
1234     ) internal virtual {}
1235 }
1236 
1237 
1238 // File contracts/extensions/ERC721ABurnable.sol
1239 
1240 // Creator: Chiru Labs
1241 
1242 pragma solidity ^0.8.4;
1243 
1244 
1245 /**
1246  * @title ERC721A Burnable Token
1247  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1248  */
1249 abstract contract ERC721ABurnable is Context, ERC721A {
1250 
1251     /**
1252      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1253      *
1254      * Requirements:
1255      *
1256      * - The caller must own `tokenId` or be an approved operator.
1257      */
1258     function burn(uint256 tokenId) public virtual {
1259         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1260 
1261         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1262             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1263             getApproved(tokenId) == _msgSender());
1264 
1265         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1266 
1267         _burn(tokenId);
1268     }
1269 }
1270 
1271 
1272 // File contracts/extensions/ERC721AOwnersExplicit.sol
1273 
1274 // Creator: Chiru Labs
1275 
1276 pragma solidity ^0.8.4;
1277 
1278 error AllOwnershipsHaveBeenSet();
1279 error QuantityMustBeNonZero();
1280 error NoTokensMintedYet();
1281 
1282 abstract contract ERC721AOwnersExplicit is ERC721A {
1283     uint256 public nextOwnerToExplicitlySet;
1284 
1285     /**
1286      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1287      */
1288     function _setOwnersExplicit(uint256 quantity) internal {
1289         if (quantity == 0) revert QuantityMustBeNonZero();
1290         if (_currentIndex == _startTokenId()) revert NoTokensMintedYet();
1291         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1292         if (_nextOwnerToExplicitlySet == 0) {
1293             _nextOwnerToExplicitlySet = _startTokenId();
1294         }
1295         if (_nextOwnerToExplicitlySet >= _currentIndex) revert AllOwnershipsHaveBeenSet();
1296 
1297         // Index underflow is impossible.
1298         // Counter or index overflow is incredibly unrealistic.
1299         unchecked {
1300             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1301 
1302             // Set the end index to be the last token index
1303             if (endIndex + 1 > _currentIndex) {
1304                 endIndex = _currentIndex - 1;
1305             }
1306 
1307             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1308                 if (_ownerships[i].addr == address(0) && !_ownerships[i].burned) {
1309                     TokenOwnership memory ownership = ownershipOf(i);
1310                     _ownerships[i].addr = ownership.addr;
1311                     _ownerships[i].startTimestamp = ownership.startTimestamp;
1312                 }
1313             }
1314 
1315             nextOwnerToExplicitlySet = endIndex + 1;
1316         }
1317     }
1318 }
1319 
1320 
1321 // File contracts/mocks/ERC721ABurnableMock.sol
1322 
1323 // Creators: Chiru Labs
1324 
1325 pragma solidity ^0.8.4;
1326 
1327 contract ERC721ABurnableMock is ERC721A, ERC721ABurnable {
1328     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}
1329 
1330     function exists(uint256 tokenId) public view returns (bool) {
1331         return _exists(tokenId);
1332     }
1333 
1334     function safeMint(address to, uint256 quantity) public {
1335         _safeMint(to, quantity);
1336     }
1337     
1338     function getOwnershipAt(uint256 index) public view returns (TokenOwnership memory) {
1339         return _ownerships[index];
1340     }
1341 
1342     function totalMinted() public view returns (uint256) {
1343         return _totalMinted();
1344     }
1345 }
1346 
1347 
1348 // File contracts/mocks/ERC721ABurnableOwnersExplicitMock.sol
1349 
1350 // Creators: Chiru Labs
1351 
1352 pragma solidity ^0.8.4;
1353 
1354 
1355 contract ERC721ABurnableOwnersExplicitMock is ERC721A, ERC721ABurnable, ERC721AOwnersExplicit {
1356     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}
1357 
1358     function exists(uint256 tokenId) public view returns (bool) {
1359         return _exists(tokenId);
1360     }
1361 
1362     function safeMint(address to, uint256 quantity) public {
1363         _safeMint(to, quantity);
1364     }
1365 
1366     function setOwnersExplicit(uint256 quantity) public {
1367         _setOwnersExplicit(quantity);
1368     }
1369 
1370     function getOwnershipAt(uint256 index) public view returns (TokenOwnership memory) {
1371         return _ownerships[index];
1372     }
1373 }
1374 
1375 
1376 // File contracts/mocks/StartTokenIdHelper.sol
1377 
1378 // Creators: Chiru Labs
1379 
1380 pragma solidity ^0.8.4;
1381 
1382 /**
1383  * This Helper is used to return a dynmamic value in the overriden _startTokenId() function.
1384  * Extending this Helper before the ERC721A contract give us access to the herein set `startTokenId`
1385  * to be returned by the overriden `_startTokenId()` function of ERC721A in the ERC721AStartTokenId mocks.
1386  */
1387 contract StartTokenIdHelper {
1388     uint256 public immutable startTokenId;
1389 
1390     constructor(uint256 startTokenId_) {
1391         startTokenId = startTokenId_;
1392     }
1393 }
1394 
1395 
1396 
1397 // File contracts/mocks/ERC721AGasReporterMock.sol
1398 
1399 // Creators: Chiru Labs
1400 
1401 pragma solidity ^0.8.4;
1402 
1403 contract ERC721AGasReporterMock is ERC721A {
1404     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}
1405 
1406     function safeMintOne(address to) public {
1407         _safeMint(to, 1);
1408     }
1409 
1410     function mintOne(address to) public {
1411         _mint(to, 1, '', false);
1412     }
1413 
1414     function safeMintTen(address to) public {
1415         _safeMint(to, 10);
1416     }
1417 
1418     function mintTen(address to) public {
1419         _mint(to, 10, '', false);
1420     }
1421 }
1422 
1423 
1424 // File contracts/mocks/ERC721AMock.sol
1425 
1426 // Creators: Chiru Labs
1427 
1428 pragma solidity ^0.8.4;
1429 
1430 contract ERC721AMock is ERC721A {
1431     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}
1432 
1433     function numberMinted(address owner) public view returns (uint256) {
1434         return _numberMinted(owner);
1435     }
1436 
1437     function totalMinted() public view returns (uint256) {
1438         return _totalMinted();
1439     }
1440 
1441     function getAux(address owner) public view returns (uint64) {
1442         return _getAux(owner);
1443     }
1444 
1445     function setAux(address owner, uint64 aux) public {
1446         _setAux(owner, aux);
1447     }
1448 
1449     function baseURI() public view returns (string memory) {
1450         return _baseURI();
1451     }
1452 
1453     function exists(uint256 tokenId) public view returns (bool) {
1454         return _exists(tokenId);
1455     }
1456 
1457     function safeMint(address to, uint256 quantity) public {
1458         _safeMint(to, quantity);
1459     }
1460 
1461     function safeMint(
1462         address to,
1463         uint256 quantity,
1464         bytes memory _data
1465     ) public {
1466         _safeMint(to, quantity, _data);
1467     }
1468 
1469     function mint(
1470         address to,
1471         uint256 quantity,
1472         bytes memory _data,
1473         bool safe
1474     ) public {
1475         _mint(to, quantity, _data, safe);
1476     }
1477 }
1478 
1479 
1480 // File contracts/mocks/ERC721AOwnersExplicitMock.sol
1481 
1482 // Creators: Chiru Labs
1483 
1484 pragma solidity ^0.8.4;
1485 
1486 contract ERC721AOwnersExplicitMock is ERC721AOwnersExplicit {
1487     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}
1488 
1489     function safeMint(address to, uint256 quantity) public {
1490         _safeMint(to, quantity);
1491     }
1492 
1493     function setOwnersExplicit(uint256 quantity) public {
1494         _setOwnersExplicit(quantity);
1495     }
1496 
1497     function getOwnershipAt(uint256 tokenId) public view returns (TokenOwnership memory) {
1498         return _ownerships[tokenId];
1499     }
1500 }
1501 
1502 // File contracts/mocks/ERC721ReceiverMock.sol
1503 
1504 // Creators: Chiru Labs
1505 
1506 pragma solidity ^0.8.4;
1507 
1508 contract ERC721ReceiverMock is IERC721Receiver {
1509     enum Error {
1510         None,
1511         RevertWithMessage,
1512         RevertWithoutMessage,
1513         Panic
1514     }
1515 
1516     bytes4 private immutable _retval;
1517 
1518     event Received(address operator, address from, uint256 tokenId, bytes data, uint256 gas);
1519 
1520     constructor(bytes4 retval) {
1521         _retval = retval;
1522     }
1523 
1524     function onERC721Received(
1525         address operator,
1526         address from,
1527         uint256 tokenId,
1528         bytes memory data
1529     ) public override returns (bytes4) {
1530         emit Received(operator, from, tokenId, data, 20000);
1531         return _retval;
1532     }
1533 }
1534 
1535 
1536 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1537 
1538 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1539 
1540 pragma solidity ^0.8.0;
1541 
1542 /**
1543  * @dev Contract module which provides a basic access control mechanism, where
1544  * there is an account (an owner) that can be granted exclusive access to
1545  * specific functions.
1546  *
1547  * By default, the owner account will be the one that deploys the contract. This
1548  * can later be changed with {transferOwnership}.
1549  *
1550  * This module is used through inheritance. It will make available the modifier
1551  * `onlyOwner`, which can be applied to your functions to restrict their use to
1552  * the owner.
1553  */
1554 abstract contract Ownable is Context {
1555     address private _owner;
1556 
1557     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1558 
1559     /**
1560      * @dev Initializes the contract setting the deployer as the initial owner.
1561      */
1562     constructor() {
1563         _transferOwnership(_msgSender());
1564     }
1565 
1566     /**
1567      * @dev Throws if called by any account other than the owner.
1568      */
1569     modifier onlyOwner() {
1570         _checkOwner();
1571         _;
1572     }
1573 
1574     /**
1575      * @dev Returns the address of the current owner.
1576      */
1577     function owner() public view virtual returns (address) {
1578         return _owner;
1579     }
1580 
1581     /**
1582      * @dev Throws if the sender is not the owner.
1583      */
1584     function _checkOwner() internal view virtual {
1585         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1586     }
1587 
1588     /**
1589      * @dev Leaves the contract without owner. It will not be possible to call
1590      * `onlyOwner` functions anymore. Can only be called by the current owner.
1591      *
1592      * NOTE: Renouncing ownership will leave the contract without an owner,
1593      * thereby removing any functionality that is only available to the owner.
1594      */
1595     function renounceOwnership() public virtual onlyOwner {
1596         _transferOwnership(address(0));
1597     }
1598 
1599     /**
1600      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1601      * Can only be called by the current owner.
1602      */
1603     function transferOwnership(address newOwner) public virtual onlyOwner {
1604         require(newOwner != address(0), "Ownable: new owner is the zero address");
1605         _transferOwnership(newOwner);
1606     }
1607 
1608     /**
1609      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1610      * Internal function without access restriction.
1611      */
1612     function _transferOwnership(address newOwner) internal virtual {
1613         address oldOwner = _owner;
1614         _owner = newOwner;
1615         emit OwnershipTransferred(oldOwner, newOwner);
1616     }
1617 }
1618 
1619 
1620 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.2
1621 
1622 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1623 
1624 pragma solidity ^0.8.0;
1625 
1626 /**
1627  * @dev Interface for the NFT Royalty Standard.
1628  *
1629  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1630  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1631  *
1632  * _Available since v4.5._
1633  */
1634 interface IERC2981 is IERC165 {
1635     /**
1636      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1637      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1638      */
1639     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1640         external
1641         view
1642         returns (address receiver, uint256 royaltyAmount);
1643 }
1644 
1645 
1646 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.7.2
1647 
1648 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1649 
1650 pragma solidity ^0.8.0;
1651 
1652 
1653 /**
1654  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1655  *
1656  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1657  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1658  *
1659  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1660  * fee is specified in basis points by default.
1661  *
1662  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1663  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1664  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1665  *
1666  * _Available since v4.5._
1667  */
1668 abstract contract ERC2981 is IERC2981, ERC165 {
1669     struct RoyaltyInfo {
1670         address receiver;
1671         uint96 royaltyFraction;
1672     }
1673 
1674     RoyaltyInfo private _defaultRoyaltyInfo;
1675     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1676 
1677     /**
1678      * @dev See {IERC165-supportsInterface}.
1679      */
1680     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1681         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1682     }
1683 
1684     /**
1685      * @inheritdoc IERC2981
1686      */
1687     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1688         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1689 
1690         if (royalty.receiver == address(0)) {
1691             royalty = _defaultRoyaltyInfo;
1692         }
1693 
1694         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1695 
1696         return (royalty.receiver, royaltyAmount);
1697     }
1698 
1699     /**
1700      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1701      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1702      * override.
1703      */
1704     function _feeDenominator() internal pure virtual returns (uint96) {
1705         return 10000;
1706     }
1707 
1708     /**
1709      * @dev Sets the royalty information that all ids in this contract will default to.
1710      *
1711      * Requirements:
1712      *
1713      * - `receiver` cannot be the zero address.
1714      * - `feeNumerator` cannot be greater than the fee denominator.
1715      */
1716     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1717         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1718         require(receiver != address(0), "ERC2981: invalid receiver");
1719 
1720         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1721     }
1722 
1723     /**
1724      * @dev Removes default royalty information.
1725      */
1726     function _deleteDefaultRoyalty() internal virtual {
1727         delete _defaultRoyaltyInfo;
1728     }
1729 
1730     /**
1731      * @dev Sets the royalty information for a specific token id, overriding the global default.
1732      *
1733      * Requirements:
1734      *
1735      * - `receiver` cannot be the zero address.
1736      * - `feeNumerator` cannot be greater than the fee denominator.
1737      */
1738     function _setTokenRoyalty(
1739         uint256 tokenId,
1740         address receiver,
1741         uint96 feeNumerator
1742     ) internal virtual {
1743         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1744         require(receiver != address(0), "ERC2981: Invalid parameters");
1745 
1746         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1747     }
1748 
1749     /**
1750      * @dev Resets royalty information for the token id back to the global default.
1751      */
1752     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1753         delete _tokenRoyaltyInfo[tokenId];
1754     }
1755 }
1756 
1757 
1758 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.7.2
1759 
1760 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
1761 
1762 pragma solidity ^0.8.0;
1763 
1764 /**
1765  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1766  *
1767  * These functions can be used to verify that a message was signed by the holder
1768  * of the private keys of a given address.
1769  */
1770 library ECDSA {
1771     enum RecoverError {
1772         NoError,
1773         InvalidSignature,
1774         InvalidSignatureLength,
1775         InvalidSignatureS,
1776         InvalidSignatureV
1777     }
1778 
1779     function _throwError(RecoverError error) private pure {
1780         if (error == RecoverError.NoError) {
1781             return; // no error: do nothing
1782         } else if (error == RecoverError.InvalidSignature) {
1783             revert("ECDSA: invalid signature");
1784         } else if (error == RecoverError.InvalidSignatureLength) {
1785             revert("ECDSA: invalid signature length");
1786         } else if (error == RecoverError.InvalidSignatureS) {
1787             revert("ECDSA: invalid signature 's' value");
1788         } else if (error == RecoverError.InvalidSignatureV) {
1789             revert("ECDSA: invalid signature 'v' value");
1790         }
1791     }
1792 
1793     /**
1794      * @dev Returns the address that signed a hashed message (`hash`) with
1795      * `signature` or error string. This address can then be used for verification purposes.
1796      *
1797      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1798      * this function rejects them by requiring the `s` value to be in the lower
1799      * half order, and the `v` value to be either 27 or 28.
1800      *
1801      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1802      * verification to be secure: it is possible to craft signatures that
1803      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1804      * this is by receiving a hash of the original message (which may otherwise
1805      * be too long), and then calling {toEthSignedMessageHash} on it.
1806      *
1807      * Documentation for signature generation:
1808      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1809      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1810      *
1811      * _Available since v4.3._
1812      */
1813     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1814         // Check the signature length
1815         // - case 65: r,s,v signature (standard)
1816         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1817         if (signature.length == 65) {
1818             bytes32 r;
1819             bytes32 s;
1820             uint8 v;
1821             // ecrecover takes the signature parameters, and the only way to get them
1822             // currently is to use assembly.
1823             /// @solidity memory-safe-assembly
1824             assembly {
1825                 r := mload(add(signature, 0x20))
1826                 s := mload(add(signature, 0x40))
1827                 v := byte(0, mload(add(signature, 0x60)))
1828             }
1829             return tryRecover(hash, v, r, s);
1830         } else if (signature.length == 64) {
1831             bytes32 r;
1832             bytes32 vs;
1833             // ecrecover takes the signature parameters, and the only way to get them
1834             // currently is to use assembly.
1835             /// @solidity memory-safe-assembly
1836             assembly {
1837                 r := mload(add(signature, 0x20))
1838                 vs := mload(add(signature, 0x40))
1839             }
1840             return tryRecover(hash, r, vs);
1841         } else {
1842             return (address(0), RecoverError.InvalidSignatureLength);
1843         }
1844     }
1845 
1846     /**
1847      * @dev Returns the address that signed a hashed message (`hash`) with
1848      * `signature`. This address can then be used for verification purposes.
1849      *
1850      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1851      * this function rejects them by requiring the `s` value to be in the lower
1852      * half order, and the `v` value to be either 27 or 28.
1853      *
1854      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1855      * verification to be secure: it is possible to craft signatures that
1856      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1857      * this is by receiving a hash of the original message (which may otherwise
1858      * be too long), and then calling {toEthSignedMessageHash} on it.
1859      */
1860     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1861         (address recovered, RecoverError error) = tryRecover(hash, signature);
1862         _throwError(error);
1863         return recovered;
1864     }
1865 
1866     /**
1867      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1868      *
1869      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1870      *
1871      * _Available since v4.3._
1872      */
1873     function tryRecover(
1874         bytes32 hash,
1875         bytes32 r,
1876         bytes32 vs
1877     ) internal pure returns (address, RecoverError) {
1878         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1879         uint8 v = uint8((uint256(vs) >> 255) + 27);
1880         return tryRecover(hash, v, r, s);
1881     }
1882 
1883     /**
1884      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1885      *
1886      * _Available since v4.2._
1887      */
1888     function recover(
1889         bytes32 hash,
1890         bytes32 r,
1891         bytes32 vs
1892     ) internal pure returns (address) {
1893         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1894         _throwError(error);
1895         return recovered;
1896     }
1897 
1898     /**
1899      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1900      * `r` and `s` signature fields separately.
1901      *
1902      * _Available since v4.3._
1903      */
1904     function tryRecover(
1905         bytes32 hash,
1906         uint8 v,
1907         bytes32 r,
1908         bytes32 s
1909     ) internal pure returns (address, RecoverError) {
1910         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1911         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1912         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1913         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1914         //
1915         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1916         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1917         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1918         // these malleable signatures as well.
1919         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1920             return (address(0), RecoverError.InvalidSignatureS);
1921         }
1922         if (v != 27 && v != 28) {
1923             return (address(0), RecoverError.InvalidSignatureV);
1924         }
1925 
1926         // If the signature is valid (and not malleable), return the signer address
1927         address signer = ecrecover(hash, v, r, s);
1928         if (signer == address(0)) {
1929             return (address(0), RecoverError.InvalidSignature);
1930         }
1931 
1932         return (signer, RecoverError.NoError);
1933     }
1934 
1935     /**
1936      * @dev Overload of {ECDSA-recover} that receives the `v`,
1937      * `r` and `s` signature fields separately.
1938      */
1939     function recover(
1940         bytes32 hash,
1941         uint8 v,
1942         bytes32 r,
1943         bytes32 s
1944     ) internal pure returns (address) {
1945         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1946         _throwError(error);
1947         return recovered;
1948     }
1949 
1950     /**
1951      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1952      * produces hash corresponding to the one signed with the
1953      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1954      * JSON-RPC method as part of EIP-191.
1955      *
1956      * See {recover}.
1957      */
1958     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1959         // 32 is the length in bytes of hash,
1960         // enforced by the type signature above
1961         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1962     }
1963 
1964     /**
1965      * @dev Returns an Ethereum Signed Message, created from `s`. This
1966      * produces hash corresponding to the one signed with the
1967      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1968      * JSON-RPC method as part of EIP-191.
1969      *
1970      * See {recover}.
1971      */
1972     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1973         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1974     }
1975 
1976     /**
1977      * @dev Returns an Ethereum Signed Typed Data, created from a
1978      * `domainSeparator` and a `structHash`. This produces hash corresponding
1979      * to the one signed with the
1980      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1981      * JSON-RPC method as part of EIP-712.
1982      *
1983      * See {recover}.
1984      */
1985     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1986         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1987     }
1988 }
1989 
1990 
1991 // File contracts/WumboPass.sol
1992 
1993 /**
1994 ╔╦═╦╦╦╦═╦═╦══╦═╗╔═╦══╦══╦══╗
1995 ║║║║║║║║║║║╔╗║║║║╬║╔╗║══╣══╣
1996 ║║║║║║║║║║║╔╗║║║║╔╣╠╣╠══╠══║
1997 ╚═╩═╩═╩╩═╩╩══╩═╝╚╝╚╝╚╩══╩══╝
1998 by @wumbolabs
1999 **/
2000 
2001 pragma solidity ^0.8.4;
2002 
2003 
2004 
2005 
2006 
2007 contract WumboPass is ERC721A, ERC2981, Ownable {
2008     using Strings for uint256;
2009 
2010     uint256 public ALLOW_LIST_PRICE = 0.1 ether;
2011     uint256 public MINT_PRICE = 0.1 ether;
2012     uint256 constant CLAIM_SUPPLY = 222;
2013     uint256 constant MINT_SUPPLY = 777;
2014     uint256 constant MAX_PER_WALLET = 1;
2015 
2016     mapping(address => bool) public whitelist;
2017 
2018     enum Status {
2019         NOT_LIVE,
2020         PRESALE,
2021         LIVE,
2022         CLAIM,
2023         ENDED
2024     }
2025 
2026     // minting variables
2027     string public baseURI = "ipfs://QmTDw49hJRhKXX9g8fyNuj1sdzVB4ku1xBBHWmQxtTr9jp/";
2028     Status public state = Status.NOT_LIVE;
2029     uint256 public mintCount = 0;
2030     uint256 public claimCount = 0;
2031 
2032     constructor() ERC721A("Wumbo Pass", "WUMBO") {
2033     }
2034 
2035     function _baseURI() internal view virtual override returns (string memory) {
2036         return baseURI;
2037     }
2038 
2039     function mint() external payable {
2040         require(state == Status.LIVE || state == Status.PRESALE, "Wumbo Pass: Mint Not Active");
2041         if(state == Status.PRESALE){
2042             require(whitelist[msg.sender], "Not in whitelist");
2043         }
2044         require(mintCount < MINT_SUPPLY, "Wumbo Pass: Mint Supply Exceeded");
2045         require(msg.value >= (state == Status.LIVE ? MINT_PRICE : ALLOW_LIST_PRICE), "Wumbo Pass: Insufficient ETH");
2046         require(_numberMinted(msg.sender) < MAX_PER_WALLET, "Wumbo Pass: Exceeds Max Per Wallet");
2047         mintCount += 1;
2048         _safeMint(msg.sender, 1);
2049     }
2050 
2051     function claim() external {
2052         require(state == Status.CLAIM, "Wumbo Pass: Claim Not Active");
2053         require(claimCount < CLAIM_SUPPLY, "Wumbo Pass: Mint Supply Exceeded");
2054         require(_numberMinted(msg.sender) < MAX_PER_WALLET, "Wumbo Pass: Exceeds Max Per Wallet");
2055         require(whitelist[msg.sender], "Not in whitelist");
2056         claimCount += 1;
2057         _safeMint(msg.sender, 1);
2058     }
2059 
2060     function setAllowList(address[] calldata addresses) external onlyOwner {
2061         for (uint256 i = 0; i < addresses.length; i++) {
2062             whitelist[addresses[i]] = true;
2063         }
2064     }
2065 
2066     function resetAllowList(address[] calldata addresses) external onlyOwner {
2067         for (uint256 i = 0; i < addresses.length; i++) {
2068             whitelist[addresses[i]] = false;
2069         }
2070     }
2071     
2072     function addWhitelist(address _newEntry) external onlyOwner {
2073         require(!whitelist[_newEntry], "Already in whitelist");
2074         whitelist[_newEntry] = true;
2075     }
2076   
2077     function removeWhitelist(address _newEntry) external onlyOwner {
2078         require(whitelist[_newEntry], "Previous not in whitelist");
2079         whitelist[_newEntry] = false;
2080     }
2081 
2082     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2083         baseURI = _newBaseURI;
2084     }
2085 
2086     function setState(Status _state) external onlyOwner {
2087         state = _state;
2088     }
2089 
2090     function sendRemainingToTreasury(uint256 _qty) external onlyOwner {
2091         require(state == Status.ENDED, "Wumbo Pass: Cannot Claim Unminted Tokens If Sale Live");
2092         require(totalSupply() + _qty <= CLAIM_SUPPLY + MINT_SUPPLY, "Wumbo Pass: Total Supply Minted");
2093 
2094         _safeMint(0x823D8C84126Da1756BE69421c78482d0D24d907e, _qty);
2095     }
2096 
2097     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
2098         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2099         string memory base = _baseURI();
2100 
2101         return string(abi.encodePacked(base, "wumbopass", ".json"));
2102     }
2103 
2104     function setMintCost(uint256 _newCost) external onlyOwner {
2105         MINT_PRICE = _newCost;
2106     }
2107 
2108     function setAllowListCost(uint256 _newCost) external onlyOwner {
2109         ALLOW_LIST_PRICE = _newCost;
2110     }
2111 
2112     /*
2113      * @dev See {ERC2981-_setDefaultRoyalty}.
2114      */
2115     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
2116         _setDefaultRoyalty(receiver, feeNumerator);
2117     }
2118 
2119     /**
2120      * @dev See {ERC2981-_deleteDefaultRoyalty}.
2121      */
2122     function deleteDefaultRoyalty() external onlyOwner {
2123         _deleteDefaultRoyalty();
2124     }
2125 
2126     /**
2127      * @dev See {ERC2981-_setTokenRoyalty}.
2128      */
2129     function setTokenRoyalty(
2130         uint256 tokenId,
2131         address receiver,
2132         uint96 feeNumerator
2133     ) external onlyOwner {
2134         _setTokenRoyalty(tokenId, receiver, feeNumerator);
2135     }
2136 
2137     /**
2138      * @dev See {ERC2981-_resetTokenRoyalty}.
2139      */
2140     function resetTokenRoyalty(uint256 tokenId) external onlyOwner {
2141         _resetTokenRoyalty(tokenId);
2142     }
2143 
2144     /**
2145      * @dev See {IERC165-supportsInterface}.
2146      */
2147     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool)
2148     {
2149         return super.supportsInterface(interfaceId);
2150     }
2151 
2152     function withdraw() external onlyOwner {
2153         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2154         require(success, "Withdraw failed.");
2155     }
2156 }