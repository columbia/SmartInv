1 // SPDX-License-Identifier: MIT and GPL-3.0
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 
71 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.2
72 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Interface of the ERC165 standard, as defined in the
78  * https://eips.ethereum.org/EIPS/eip-165[EIP].
79  *
80  * Implementers can declare support of contract interfaces, which can then be
81  * queried by others ({ERC165Checker}).
82  *
83  * For an implementation, see {ERC165}.
84  */
85 interface IERC165 {
86     /**
87      * @dev Returns true if this contract implements the interface defined by
88      * `interfaceId`. See the corresponding
89      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
90      * to learn more about how these ids are created.
91      *
92      * This function call must use less than 30 000 gas.
93      */
94     function supportsInterface(bytes4 interfaceId) external view returns (bool);
95 }
96 
97 
98 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.2
99 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Required interface of an ERC721 compliant contract.
105  */
106 interface IERC721 is IERC165 {
107     /**
108      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
114      */
115     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
119      */
120     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
121 
122     /**
123      * @dev Returns the number of tokens in ``owner``'s account.
124      */
125     function balanceOf(address owner) external view returns (uint256 balance);
126 
127     /**
128      * @dev Returns the owner of the `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function ownerOf(uint256 tokenId) external view returns (address owner);
135 
136     /**
137      * @dev Safely transfers `tokenId` token from `from` to `to`.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must exist and be owned by `from`.
144      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146      *
147      * Emits a {Transfer} event.
148      */
149     function safeTransferFrom(
150         address from,
151         address to,
152         uint256 tokenId,
153         bytes calldata data
154     ) external;
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Approve or remove `operator` as an operator for the caller.
213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
214      *
215      * Requirements:
216      *
217      * - The `operator` cannot be the caller.
218      *
219      * Emits an {ApprovalForAll} event.
220      */
221     function setApprovalForAll(address operator, bool _approved) external;
222 
223     /**
224      * @dev Returns the account approved for `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function getApproved(uint256 tokenId) external view returns (address operator);
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 }
239 
240 
241 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.2
242 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @title ERC721 token receiver interface
248  * @dev Interface for any contract that wants to support safeTransfers
249  * from ERC721 asset contracts.
250  */
251 interface IERC721Receiver {
252     /**
253      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
254      * by `operator` from `from`, this function is called.
255      *
256      * It must return its Solidity selector to confirm the token transfer.
257      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
258      *
259      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
260      */
261     function onERC721Received(
262         address operator,
263         address from,
264         uint256 tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 
270 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.2
271 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
277  * @dev See https://eips.ethereum.org/EIPS/eip-721
278  */
279 interface IERC721Metadata is IERC721 {
280     /**
281      * @dev Returns the token collection name.
282      */
283     function name() external view returns (string memory);
284 
285     /**
286      * @dev Returns the token collection symbol.
287      */
288     function symbol() external view returns (string memory);
289 
290     /**
291      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
292      */
293     function tokenURI(uint256 tokenId) external view returns (string memory);
294 }
295 
296 
297 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.7.2
298 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
304  * @dev See https://eips.ethereum.org/EIPS/eip-721
305  */
306 interface IERC721Enumerable is IERC721 {
307     /**
308      * @dev Returns the total amount of tokens stored by the contract.
309      */
310     function totalSupply() external view returns (uint256);
311 
312     /**
313      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
314      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
315      */
316     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
317 
318     /**
319      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
320      * Use along with {totalSupply} to enumerate all tokens.
321      */
322     function tokenByIndex(uint256 index) external view returns (uint256);
323 }
324 
325 
326 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
327 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
328 
329 pragma solidity ^0.8.1;
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      *
352      * [IMPORTANT]
353      * ====
354      * You shouldn't rely on `isContract` to protect against flash loan attacks!
355      *
356      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
357      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
358      * constructor.
359      * ====
360      */
361     function isContract(address account) internal view returns (bool) {
362         // This method relies on extcodesize/address.code.length, which returns 0
363         // for contracts in construction, since the code is only stored at the end
364         // of the constructor execution.
365 
366         return account.code.length > 0;
367     }
368 
369     /**
370      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
371      * `recipient`, forwarding all available gas and reverting on errors.
372      *
373      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
374      * of certain opcodes, possibly making contracts go over the 2300 gas limit
375      * imposed by `transfer`, making them unable to receive funds via
376      * `transfer`. {sendValue} removes this limitation.
377      *
378      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
379      *
380      * IMPORTANT: because control is transferred to `recipient`, care must be
381      * taken to not create reentrancy vulnerabilities. Consider using
382      * {ReentrancyGuard} or the
383      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
384      */
385     function sendValue(address payable recipient, uint256 amount) internal {
386         require(address(this).balance >= amount, "Address: insufficient balance");
387 
388         (bool success, ) = recipient.call{value: amount}("");
389         require(success, "Address: unable to send value, recipient may have reverted");
390     }
391 
392     /**
393      * @dev Performs a Solidity function call using a low level `call`. A
394      * plain `call` is an unsafe replacement for a function call: use this
395      * function instead.
396      *
397      * If `target` reverts with a revert reason, it is bubbled up by this
398      * function (like regular Solidity function calls).
399      *
400      * Returns the raw returned data. To convert to the expected return value,
401      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
402      *
403      * Requirements:
404      *
405      * - `target` must be a contract.
406      * - calling `target` with `data` must not revert.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
411         return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
416      * `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but also transferring `value` wei to `target`.
431      *
432      * Requirements:
433      *
434      * - the calling contract must have an ETH balance of at least `value`.
435      * - the called Solidity function must be `payable`.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value
443     ) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         require(isContract(target), "Address: call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.call{value: value}(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
473         return functionStaticCall(target, data, "Address: low-level static call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal view returns (bytes memory) {
487         require(isContract(target), "Address: static call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.staticcall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(isContract(target), "Address: delegate call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.delegatecall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
522      * revert reason using the provided one.
523      *
524      * _Available since v4.3._
525      */
526     function verifyCallResult(
527         bool success,
528         bytes memory returndata,
529         string memory errorMessage
530     ) internal pure returns (bytes memory) {
531         if (success) {
532             return returndata;
533         } else {
534             // Look for revert reason and bubble it up if present
535             if (returndata.length > 0) {
536                 // The easiest way to bubble the revert reason is using memory via assembly
537                 /// @solidity memory-safe-assembly
538                 assembly {
539                     let returndata_size := mload(returndata)
540                     revert(add(32, returndata), returndata_size)
541                 }
542             } else {
543                 revert(errorMessage);
544             }
545         }
546     }
547 }
548 
549 
550 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
551 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Provides information about the current execution context, including the
557  * sender of the transaction and its data. While these are generally available
558  * via msg.sender and msg.data, they should not be accessed in such a direct
559  * manner, since when dealing with meta-transactions the account sending and
560  * paying for execution may not be the actual sender (as far as an application
561  * is concerned).
562  *
563  * This contract is only required for intermediate, library-like contracts.
564  */
565 abstract contract Context {
566     function _msgSender() internal view virtual returns (address) {
567         return msg.sender;
568     }
569 
570     function _msgData() internal view virtual returns (bytes calldata) {
571         return msg.data;
572     }
573 }
574 
575 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.2
576 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev Implementation of the {IERC165} interface.
582  *
583  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
584  * for the additional interface id that will be supported. For example:
585  *
586  * ```solidity
587  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
589  * }
590  * ```
591  *
592  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
593  */
594 abstract contract ERC165 is IERC165 {
595     /**
596      * @dev See {IERC165-supportsInterface}.
597      */
598     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599         return interfaceId == type(IERC165).interfaceId;
600     }
601 }
602 
603 
604 // File contracts/ERC721A.sol
605 // Creator: Chiru Labs
606 
607 pragma solidity ^0.8.4;
608 
609 
610 error ApprovalCallerNotOwnerNorApproved();
611 error ApprovalQueryForNonexistentToken();
612 error ApproveToCaller();
613 error ApprovalToCurrentOwner();
614 error BalanceQueryForZeroAddress();
615 error MintedQueryForZeroAddress();
616 error BurnedQueryForZeroAddress();
617 error AuxQueryForZeroAddress();
618 error MintToZeroAddress();
619 error MintZeroQuantity();
620 error OwnerIndexOutOfBounds();
621 error OwnerQueryForNonexistentToken();
622 error TokenIndexOutOfBounds();
623 error TransferCallerNotOwnerNorApproved();
624 error TransferFromIncorrectOwner();
625 error TransferToNonERC721ReceiverImplementer();
626 error TransferToZeroAddress();
627 error URIQueryForNonexistentToken();
628 
629 /**
630  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
631  * the Metadata extension. Built to optimize for lower gas during batch mints.
632  *
633  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
634  *
635  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
636  *
637  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
638  */
639 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
640     using Address for address;
641     using Strings for uint256;
642 
643     // Compiler will pack this into a single 256bit word.
644     struct TokenOwnership {
645         // The address of the owner.
646         address addr;
647         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
648         uint64 startTimestamp;
649         // Whether the token has been burned.
650         bool burned;
651     }
652 
653     // Compiler will pack this into a single 256bit word.
654     struct AddressData {
655         // Realistically, 2**64-1 is more than enough.
656         uint64 balance;
657         // Keeps track of mint count with minimal overhead for tokenomics.
658         uint64 numberMinted;
659         // Keeps track of burn count with minimal overhead for tokenomics.
660         uint64 numberBurned;
661         // For miscellaneous variable(s) pertaining to the address
662         // (e.g. number of whitelist mint slots used).
663         // If there are multiple variables, please pack them into a uint64.
664         uint64 aux;
665     }
666 
667     // The tokenId of the next token to be minted.
668     uint256 internal _currentIndex;
669 
670     // The number of tokens burned.
671     uint256 internal _burnCounter;
672 
673     // Token name
674     string private _name;
675 
676     // Token symbol
677     string private _symbol;
678 
679     // Mapping from token ID to ownership details
680     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
681     mapping(uint256 => TokenOwnership) internal _ownerships;
682 
683     // Mapping owner address to address data
684     mapping(address => AddressData) private _addressData;
685 
686     // Mapping from token ID to approved address
687     mapping(uint256 => address) private _tokenApprovals;
688 
689     // Mapping from owner to operator approvals
690     mapping(address => mapping(address => bool)) private _operatorApprovals;
691 
692     constructor(string memory name_, string memory symbol_) {
693         _name = name_;
694         _symbol = symbol_;
695         _currentIndex = _startTokenId();
696     }
697 
698     /**
699      * To change the starting tokenId, please override this function.
700      */
701     function _startTokenId() internal view virtual returns (uint256) {
702         return 1;
703     }
704 
705     /**
706      * @dev See {IERC721Enumerable-totalSupply}.
707      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
708      */
709     function totalSupply() public view returns (uint256) {
710         // Counter underflow is impossible as _burnCounter cannot be incremented
711         // more than _currentIndex - _startTokenId() times
712         unchecked {
713             return _currentIndex - _burnCounter - _startTokenId();
714         }
715     }
716 
717     /**
718      * Returns the total amount of tokens minted in the contract.
719      */
720     function _totalMinted() internal view returns (uint256) {
721         // Counter underflow is impossible as _currentIndex does not decrement,
722         // and it is initialized to _startTokenId()
723         unchecked {
724             return _currentIndex - _startTokenId();
725         }
726     }
727 
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             super.supportsInterface(interfaceId);
736     }
737 
738     /**
739      * @dev See {IERC721-balanceOf}.
740      */
741     function balanceOf(address owner) public view override returns (uint256) {
742         if (owner == address(0)) revert BalanceQueryForZeroAddress();
743         return uint256(_addressData[owner].balance);
744     }
745 
746     /**
747      * Returns the number of tokens minted by `owner`.
748      */
749     function _numberMinted(address owner) internal view returns (uint256) {
750         if (owner == address(0)) revert MintedQueryForZeroAddress();
751         return uint256(_addressData[owner].numberMinted);
752     }
753 
754     /**
755      * Returns the number of tokens burned by or on behalf of `owner`.
756      */
757     function _numberBurned(address owner) internal view returns (uint256) {
758         if (owner == address(0)) revert BurnedQueryForZeroAddress();
759         return uint256(_addressData[owner].numberBurned);
760     }
761 
762     /**
763      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
764      */
765     function _getAux(address owner) internal view returns (uint64) {
766         if (owner == address(0)) revert AuxQueryForZeroAddress();
767         return _addressData[owner].aux;
768     }
769 
770     /**
771      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
772      * If there are multiple variables, please pack them into a uint64.
773      */
774     function _setAux(address owner, uint64 aux) internal {
775         if (owner == address(0)) revert AuxQueryForZeroAddress();
776         _addressData[owner].aux = aux;
777     }
778 
779 
780     /**
781      * Gas spent here starts off proportional to the maximum mint batch size.
782      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
783      */
784     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
785         uint256 curr = tokenId;
786 
787         unchecked {
788             if (_startTokenId() <= curr && curr < _currentIndex) {
789                 TokenOwnership memory ownership = _ownerships[curr];
790                 if (!ownership.burned) {
791                     if (ownership.addr != address(0)) {
792                         return ownership;
793                     }
794                     // Invariant:
795                     // There will always be an ownership that has an address and is not burned
796                     // before an ownership that does not have an address and is not burned.
797                     // Hence, curr will not underflow.
798                     while (true) {
799                         curr--;
800                         ownership = _ownerships[curr];
801                         if (ownership.addr != address(0)) {
802                             return ownership;
803                         }
804                     }
805                 }
806             }
807         }
808         revert OwnerQueryForNonexistentToken();
809     }
810 
811     /**
812      * @dev See {IERC721-ownerOf}.
813      */
814     function ownerOf(uint256 tokenId) public view override returns (address) {
815         return ownershipOf(tokenId).addr;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return '';
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public override {
855         address owner = ERC721A.ownerOf(tokenId);
856         if (to == owner) revert ApprovalToCurrentOwner();
857 
858         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
859             revert ApprovalCallerNotOwnerNorApproved();
860         }
861 
862         _approve(to, tokenId, owner);
863     }
864 
865     /**
866      * @dev See {IERC721-getApproved}.
867      */
868     function getApproved(uint256 tokenId) public view override returns (address) {
869         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
870 
871         return _tokenApprovals[tokenId];
872     }
873 
874     /**
875      * @dev See {IERC721-setApprovalForAll}.
876      */
877     function setApprovalForAll(address operator, bool approved) public override {
878         if (operator == _msgSender()) revert ApproveToCaller();
879 
880         _operatorApprovals[_msgSender()][operator] = approved;
881         emit ApprovalForAll(_msgSender(), operator, approved);
882     }
883 
884     /**
885      * @dev See {IERC721-isApprovedForAll}.
886      */
887     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev See {IERC721-transferFrom}.
893      */
894     function transferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         _transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         safeTransferFrom(from, to, tokenId, '');
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public virtual override {
922         _transfer(from, to, tokenId);
923         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
924             revert TransferToNonERC721ReceiverImplementer();
925         }
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      */
935     function _exists(uint256 tokenId) internal view returns (bool) {
936         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
937             !_ownerships[tokenId].burned;
938     }
939 
940     function _safeMint(address to, uint256 quantity) internal {
941         _safeMint(to, quantity, '');
942     }
943 
944     /**
945      * @dev Safely mints `quantity` tokens and transfers them to `to`.
946      *
947      * Requirements:
948      *
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
950      * - `quantity` must be greater than 0.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _safeMint(
955         address to,
956         uint256 quantity,
957         bytes memory _data
958     ) internal {
959         _mint(to, quantity, _data, true);
960     }
961 
962     /**
963      * @dev Mints `quantity` tokens and transfers them to `to`.
964      *
965      * Requirements:
966      *
967      * - `to` cannot be the zero address.
968      * - `quantity` must be greater than 0.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _mint(
973         address to,
974         uint256 quantity,
975         bytes memory _data,
976         bool safe
977     ) internal {
978         uint256 startTokenId = _currentIndex;
979         if (to == address(0)) revert MintToZeroAddress();
980         if (quantity == 0) revert MintZeroQuantity();
981 
982         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
983 
984         // Overflows are incredibly unrealistic.
985         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
986         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
987         unchecked {
988             _addressData[to].balance += uint64(quantity);
989             _addressData[to].numberMinted += uint64(quantity);
990 
991             _ownerships[startTokenId].addr = to;
992             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
993 
994             uint256 updatedIndex = startTokenId;
995             uint256 end = updatedIndex + quantity;
996 
997             if (safe && to.isContract()) {
998                 do {
999                     emit Transfer(address(0), to, updatedIndex);
1000                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1001                         revert TransferToNonERC721ReceiverImplementer();
1002                     }
1003                 } while (updatedIndex != end);
1004                 // Reentrancy protection
1005                 if (_currentIndex != startTokenId) revert();
1006             } else {
1007                 do {
1008                     emit Transfer(address(0), to, updatedIndex++);
1009                 } while (updatedIndex != end);
1010             }
1011             _currentIndex = updatedIndex;
1012         }
1013         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1014     }
1015 
1016     /**
1017      * @dev Transfers `tokenId` from `from` to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _transfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) private {
1031         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1032 
1033         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1034             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1035             getApproved(tokenId) == _msgSender());
1036 
1037         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1038         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1039         if (to == address(0)) revert TransferToZeroAddress();
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner
1044         _approve(address(0), tokenId, prevOwnership.addr);
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1049         unchecked {
1050             _addressData[from].balance -= 1;
1051             _addressData[to].balance += 1;
1052 
1053             _ownerships[tokenId].addr = to;
1054             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1055 
1056             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1057             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1058             uint256 nextTokenId = tokenId + 1;
1059             if (_ownerships[nextTokenId].addr == address(0)) {
1060                 // This will suffice for checking _exists(nextTokenId),
1061                 // as a burned slot cannot contain the zero address.
1062                 if (nextTokenId < _currentIndex) {
1063                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1064                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1065                 }
1066             }
1067         }
1068 
1069         emit Transfer(from, to, tokenId);
1070         _afterTokenTransfers(from, to, tokenId, 1);
1071     }
1072 
1073     /**
1074      * @dev Destroys `tokenId`.
1075      * The approval is cleared when the token is burned.
1076      *
1077      * Requirements:
1078      *
1079      * - `tokenId` must exist.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _burn(uint256 tokenId) internal virtual {
1084         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1085 
1086         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1087 
1088         // Clear approvals from the previous owner
1089         _approve(address(0), tokenId, prevOwnership.addr);
1090 
1091         // Underflow of the sender's balance is impossible because we check for
1092         // ownership above and the recipient's balance can't realistically overflow.
1093         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1094         unchecked {
1095             _addressData[prevOwnership.addr].balance -= 1;
1096             _addressData[prevOwnership.addr].numberBurned += 1;
1097 
1098             // Keep track of who burned the token, and the timestamp of burning.
1099             _ownerships[tokenId].addr = prevOwnership.addr;
1100             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1101             _ownerships[tokenId].burned = true;
1102 
1103             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1104             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1105             uint256 nextTokenId = tokenId + 1;
1106             if (_ownerships[nextTokenId].addr == address(0)) {
1107                 // This will suffice for checking _exists(nextTokenId),
1108                 // as a burned slot cannot contain the zero address.
1109                 if (nextTokenId < _currentIndex) {
1110                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1111                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1112                 }
1113             }
1114         }
1115 
1116         emit Transfer(prevOwnership.addr, address(0), tokenId);
1117         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1118 
1119         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1120         unchecked {
1121             _burnCounter++;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Approve `to` to operate on `tokenId`
1127      *
1128      * Emits a {Approval} event.
1129      */
1130     function _approve(
1131         address to,
1132         uint256 tokenId,
1133         address owner
1134     ) private {
1135         _tokenApprovals[tokenId] = to;
1136         emit Approval(owner, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1141      *
1142      * @param from address representing the previous owner of the given token ID
1143      * @param to target address that will receive the tokens
1144      * @param tokenId uint256 ID of the token to be transferred
1145      * @param _data bytes optional data to send along with the call
1146      * @return bool whether the call correctly returned the expected magic value
1147      */
1148     function _checkContractOnERC721Received(
1149         address from,
1150         address to,
1151         uint256 tokenId,
1152         bytes memory _data
1153     ) private returns (bool) {
1154         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1155             return retval == IERC721Receiver(to).onERC721Received.selector;
1156         } catch (bytes memory reason) {
1157             if (reason.length == 0) {
1158                 revert TransferToNonERC721ReceiverImplementer();
1159             } else {
1160                 assembly {
1161                     revert(add(32, reason), mload(reason))
1162                 }
1163             }
1164         }
1165     }
1166 
1167     /**
1168      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1169      * And also called before burning one token.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, `tokenId` will be burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _beforeTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1191      * minting.
1192      * And also called after one token has been burned.
1193      *
1194      * startTokenId - the first token id to be transferred
1195      * quantity - the amount to be transferred
1196      *
1197      * Calling conditions:
1198      *
1199      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1200      * transferred to `to`.
1201      * - When `from` is zero, `tokenId` has been minted for `to`.
1202      * - When `to` is zero, `tokenId` has been burned by `from`.
1203      * - `from` and `to` are never both zero.
1204      */
1205     function _afterTokenTransfers(
1206         address from,
1207         address to,
1208         uint256 startTokenId,
1209         uint256 quantity
1210     ) internal virtual {}
1211 }
1212 
1213 
1214 // File contracts/mocks/StartTokenIdHelper.sol
1215 // Creators: Chiru Labs
1216 
1217 pragma solidity ^0.8.4;
1218 
1219 /**
1220  * This Helper is used to return a dynmamic value in the overriden _startTokenId() function.
1221  * Extending this Helper before the ERC721A contract give us access to the herein set `startTokenId`
1222  * to be returned by the overriden `_startTokenId()` function of ERC721A in the ERC721AStartTokenId mocks.
1223  */
1224 contract StartTokenIdHelper {
1225     uint256 public immutable startTokenId;
1226 
1227     constructor(uint256 startTokenId_) {
1228         startTokenId = startTokenId_;
1229     }
1230 }
1231 
1232 
1233 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1234 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 /**
1239  * @dev Contract module which provides a basic access control mechanism, where
1240  * there is an account (an owner) that can be granted exclusive access to
1241  * specific functions.
1242  *
1243  * By default, the owner account will be the one that deploys the contract. This
1244  * can later be changed with {transferOwnership}.
1245  *
1246  * This module is used through inheritance. It will make available the modifier
1247  * `onlyOwner`, which can be applied to your functions to restrict their use to
1248  * the owner.
1249  */
1250 abstract contract Ownable is Context {
1251     address private _owner;
1252 
1253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1254 
1255     /**
1256      * @dev Initializes the contract setting the deployer as the initial owner.
1257      */
1258     constructor() {
1259         _transferOwnership(_msgSender());
1260     }
1261 
1262     /**
1263      * @dev Throws if called by any account other than the owner.
1264      */
1265     modifier onlyOwner() {
1266         _checkOwner();
1267         _;
1268     }
1269 
1270     /**
1271      * @dev Returns the address of the current owner.
1272      */
1273     function owner() public view virtual returns (address) {
1274         return _owner;
1275     }
1276 
1277     /**
1278      * @dev Throws if the sender is not the owner.
1279      */
1280     function _checkOwner() internal view virtual {
1281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1282     }
1283 
1284     /**
1285      * @dev Leaves the contract without owner. It will not be possible to call
1286      * `onlyOwner` functions anymore. Can only be called by the current owner.
1287      *
1288      * NOTE: Renouncing ownership will leave the contract without an owner,
1289      * thereby removing any functionality that is only available to the owner.
1290      */
1291     function renounceOwnership() public virtual onlyOwner {
1292         _transferOwnership(address(0));
1293     }
1294 
1295     /**
1296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1297      * Can only be called by the current owner.
1298      */
1299     function transferOwnership(address newOwner) public virtual onlyOwner {
1300         require(newOwner != address(0), "Ownable: new owner is the zero address");
1301         _transferOwnership(newOwner);
1302     }
1303 
1304     /**
1305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1306      * Internal function without access restriction.
1307      */
1308     function _transferOwnership(address newOwner) internal virtual {
1309         address oldOwner = _owner;
1310         _owner = newOwner;
1311         emit OwnershipTransferred(oldOwner, newOwner);
1312     }
1313 }
1314 
1315 
1316 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.7.2
1317 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 /**
1322  * @dev These functions deal with verification of Merkle Tree proofs.
1323  *
1324  * The proofs can be generated using the JavaScript library
1325  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1326  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1327  *
1328  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1329  *
1330  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1331  * hashing, or use a hash function other than keccak256 for hashing leaves.
1332  * This is because the concatenation of a sorted pair of internal nodes in
1333  * the merkle tree could be reinterpreted as a leaf value.
1334  */
1335 library MerkleProof {
1336     /**
1337      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1338      * defined by `root`. For this, a `proof` must be provided, containing
1339      * sibling hashes on the branch from the leaf to the root of the tree. Each
1340      * pair of leaves and each pair of pre-images are assumed to be sorted.
1341      */
1342     function verify(
1343         bytes32[] memory proof,
1344         bytes32 root,
1345         bytes32 leaf
1346     ) internal pure returns (bool) {
1347         return processProof(proof, leaf) == root;
1348     }
1349 
1350     /**
1351      * @dev Calldata version of {verify}
1352      *
1353      * _Available since v4.7._
1354      */
1355     function verifyCalldata(
1356         bytes32[] calldata proof,
1357         bytes32 root,
1358         bytes32 leaf
1359     ) internal pure returns (bool) {
1360         return processProofCalldata(proof, leaf) == root;
1361     }
1362 
1363     /**
1364      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1365      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1366      * hash matches the root of the tree. When processing the proof, the pairs
1367      * of leafs & pre-images are assumed to be sorted.
1368      *
1369      * _Available since v4.4._
1370      */
1371     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1372         bytes32 computedHash = leaf;
1373         for (uint256 i = 0; i < proof.length; i++) {
1374             computedHash = _hashPair(computedHash, proof[i]);
1375         }
1376         return computedHash;
1377     }
1378 
1379     /**
1380      * @dev Calldata version of {processProof}
1381      *
1382      * _Available since v4.7._
1383      */
1384     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1385         bytes32 computedHash = leaf;
1386         for (uint256 i = 0; i < proof.length; i++) {
1387             computedHash = _hashPair(computedHash, proof[i]);
1388         }
1389         return computedHash;
1390     }
1391 
1392     /**
1393      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1394      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1395      *
1396      * _Available since v4.7._
1397      */
1398     function multiProofVerify(
1399         bytes32[] memory proof,
1400         bool[] memory proofFlags,
1401         bytes32 root,
1402         bytes32[] memory leaves
1403     ) internal pure returns (bool) {
1404         return processMultiProof(proof, proofFlags, leaves) == root;
1405     }
1406 
1407     /**
1408      * @dev Calldata version of {multiProofVerify}
1409      *
1410      * _Available since v4.7._
1411      */
1412     function multiProofVerifyCalldata(
1413         bytes32[] calldata proof,
1414         bool[] calldata proofFlags,
1415         bytes32 root,
1416         bytes32[] memory leaves
1417     ) internal pure returns (bool) {
1418         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1419     }
1420 
1421     /**
1422      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1423      * consuming from one or the other at each step according to the instructions given by
1424      * `proofFlags`.
1425      *
1426      * _Available since v4.7._
1427      */
1428     function processMultiProof(
1429         bytes32[] memory proof,
1430         bool[] memory proofFlags,
1431         bytes32[] memory leaves
1432     ) internal pure returns (bytes32 merkleRoot) {
1433         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1434         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1435         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1436         // the merkle tree.
1437         uint256 leavesLen = leaves.length;
1438         uint256 totalHashes = proofFlags.length;
1439 
1440         // Check proof validity.
1441         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1442 
1443         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1444         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1445         bytes32[] memory hashes = new bytes32[](totalHashes);
1446         uint256 leafPos = 0;
1447         uint256 hashPos = 0;
1448         uint256 proofPos = 0;
1449         // At each step, we compute the next hash using two values:
1450         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1451         //   get the next hash.
1452         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1453         //   `proof` array.
1454         for (uint256 i = 0; i < totalHashes; i++) {
1455             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1456             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1457             hashes[i] = _hashPair(a, b);
1458         }
1459 
1460         if (totalHashes > 0) {
1461             return hashes[totalHashes - 1];
1462         } else if (leavesLen > 0) {
1463             return leaves[0];
1464         } else {
1465             return proof[0];
1466         }
1467     }
1468 
1469     /**
1470      * @dev Calldata version of {processMultiProof}
1471      *
1472      * _Available since v4.7._
1473      */
1474     function processMultiProofCalldata(
1475         bytes32[] calldata proof,
1476         bool[] calldata proofFlags,
1477         bytes32[] memory leaves
1478     ) internal pure returns (bytes32 merkleRoot) {
1479         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1480         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1481         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1482         // the merkle tree.
1483         uint256 leavesLen = leaves.length;
1484         uint256 totalHashes = proofFlags.length;
1485 
1486         // Check proof validity.
1487         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1488 
1489         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1490         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1491         bytes32[] memory hashes = new bytes32[](totalHashes);
1492         uint256 leafPos = 0;
1493         uint256 hashPos = 0;
1494         uint256 proofPos = 0;
1495         // At each step, we compute the next hash using two values:
1496         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1497         //   get the next hash.
1498         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1499         //   `proof` array.
1500         for (uint256 i = 0; i < totalHashes; i++) {
1501             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1502             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1503             hashes[i] = _hashPair(a, b);
1504         }
1505 
1506         if (totalHashes > 0) {
1507             return hashes[totalHashes - 1];
1508         } else if (leavesLen > 0) {
1509             return leaves[0];
1510         } else {
1511             return proof[0];
1512         }
1513     }
1514 
1515     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1516         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1517     }
1518 
1519     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1520         /// @solidity memory-safe-assembly
1521         assembly {
1522             mstore(0x00, a)
1523             mstore(0x20, b)
1524             value := keccak256(0x00, 0x40)
1525         }
1526     }
1527 }
1528 
1529 /**
1530 PumaNitroToken Smart Contract Development by @WumboLabs
1531 **/
1532 
1533 pragma solidity >=0.8.0 <0.9.0;
1534 
1535 
1536 contract PumaNitroToken is ERC721A, Ownable {
1537     using Strings for uint256;
1538 
1539     address public NitroPassContract;
1540 
1541     /// All allowlist set on Merkle Tree
1542     bytes32 public MERKLEROOT = 0x030dbae32c900445b3b687e37c13da2060ed206d1ce3942bb714b4903008ce68;
1543     uint256 constant MAX_SUPPLY = 4000;
1544 
1545     /// PUMA x Catblox NFT holders on August 19th, 2022 9 PM PST
1546     mapping(address => uint256 ) public holderSnapshot;
1547 
1548     struct snapshotAddress {
1549         address user;
1550         uint256 amount;
1551     }
1552 
1553     enum Status {
1554         NOT_LIVE,
1555         WHITELIST_SNAPSHOT,
1556         PUBLIC,
1557         ENDED
1558     }
1559 
1560     /// Minting Variables
1561     string public URI = "ipfs://QmUHJpkxd8ZwXE9G1tAbDyEk4xa6fptAFjVS6AUQtD2WBh/pumanitrotoken.json";
1562     Status public state;
1563     uint256 public claimCount;
1564 
1565     constructor() ERC721A("PUMA Nitro Token", "NITKN") {
1566     }
1567 
1568     function setNitroPassContract(address _NitroPassContract) external onlyOwner {
1569         NitroPassContract = _NitroPassContract;
1570     }
1571 
1572     /// Called by Nitro Pass Contract to burn Nitro Token on minting Nitro Pass
1573     function burnNitroTokenForNitroPass(uint256 NitroTokenId) external {
1574         require(msg.sender == NitroPassContract, "Invalid burner address");
1575         _burn(NitroTokenId);
1576     }
1577 
1578     function burnAllNitroTokens() public onlyOwner {
1579         require(state == Status.ENDED, "PUMA Nitro Token: Still Live");
1580         for (uint256 _tokenId=0; _tokenId<MAX_SUPPLY; _tokenId++) {
1581             if(_exists(_tokenId)) {
1582                 _burn(_tokenId);
1583             }
1584         }
1585     }
1586 
1587     function burnNitroToken(uint256 tokenId) public onlyOwner {
1588         require(state == Status.ENDED, "PUMA Nitro Token: Still Live");
1589         require(_exists(tokenId), 'Token does not exist');
1590         _burn(tokenId);
1591     }
1592 
1593     /// Claimable by someone on snapshot or allowlist 
1594     function claim(bytes32[] calldata _proof) external {
1595         require(msg.sender == tx.origin, "PUMA Nitro Token: Contract Interaction Not Allowed");
1596         require(state == Status.WHITELIST_SNAPSHOT, "PUMA Nitro Token: Claim Is Not Live");
1597         require(MerkleProof.verify(_proof,MERKLEROOT,keccak256(abi.encodePacked(msg.sender))),"Invalid proof.");
1598         uint256 amountClaimable = holderSnapshot[msg.sender];
1599         uint256 amountMinted = _numberMinted(msg.sender);
1600         uint256 netAmountClaimable = amountClaimable - amountMinted;
1601         if (amountClaimable > 0){
1602             require(amountClaimable > amountMinted);
1603             require(claimCount + netAmountClaimable <= MAX_SUPPLY, "PUMA Nitro Token: Mint Supply Exceeded");
1604             claimCount += netAmountClaimable;
1605             holderSnapshot[msg.sender] = 0;
1606         } else {
1607             require(amountMinted < 1);
1608             require(claimCount + 1 <= MAX_SUPPLY, "PUMA Nitro Token: Mint Supply Exceeded");
1609             netAmountClaimable = 1;
1610             claimCount ++;
1611         }
1612         _safeMint(msg.sender, netAmountClaimable);
1613     }
1614     
1615     function publicClaim() external {
1616         require(msg.sender == tx.origin, "PUMA Nitro Token: Contract Interaction Not Allowed");
1617         require(state == Status.PUBLIC, "PUMA Nitro Token: Public not live");
1618         require(_numberMinted(msg.sender) < 1, "PUMA Nitro Token: Exceeds Max Per Wallet");
1619         require(claimCount + 1 <= MAX_SUPPLY, "PUMA Nitro Token: Mint Supply Exceeded");
1620         claimCount++;
1621         _safeMint(msg.sender, 1);
1622     }
1623 
1624     function setSnapshot(snapshotAddress[] calldata addresses) external onlyOwner {
1625         for(uint256 i = 0; i < addresses.length; i++){
1626             holderSnapshot[addresses[i].user] = addresses[i].amount;
1627         }
1628     }
1629 
1630     function resetSnapshot(address[] calldata addresses) external onlyOwner {
1631         for (uint256 i = 0; i < addresses.length; i++) {
1632             holderSnapshot[addresses[i]] = 0;
1633         }
1634     }
1635     
1636     function addSnapshot(address _address, uint256 _amount) external onlyOwner {
1637         require(holderSnapshot[_address] == 0, "PUMA Nitro Token: Already in allowlist");
1638         holderSnapshot[_address] = _amount;
1639     }
1640   
1641     function removeSnapshot(address _newEntry) external onlyOwner {
1642         require(holderSnapshot[_newEntry] != 0, "PUMA Nitro Token: Previous not in allowlist");
1643         holderSnapshot[_newEntry] = 0;
1644     }
1645 
1646     function isWhitelisted(bytes32[] memory proof, bytes32 leaf) external view returns (bool) {
1647         return MerkleProof.verify(proof, MERKLEROOT, leaf);
1648     }
1649 
1650     function setState(Status _state) external onlyOwner {
1651         state = _state;
1652     }
1653 
1654     function setMerkleRoot(bytes32 _root) external onlyOwner {
1655         MERKLEROOT = _root;
1656     }
1657     
1658     function setURI(string calldata _newURI) external onlyOwner {
1659         URI = _newURI;
1660     }
1661 
1662     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1663         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1664         return URI;
1665     }
1666 
1667     function withdrawMoney() external onlyOwner {
1668     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1669     require(success, "Withdraw failed.");
1670     }
1671 
1672 }