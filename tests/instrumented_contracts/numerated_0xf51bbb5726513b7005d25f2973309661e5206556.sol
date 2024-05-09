1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.2.2
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
70 }
71 
72 
73 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.2
74 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Interface of the ERC165 standard, as defined in the
80  * https://eips.ethereum.org/EIPS/eip-165[EIP].
81  *
82  * Implementers can declare support of contract interfaces, which can then be
83  * queried by others ({ERC165Checker}).
84  *
85  * For an implementation, see {ERC165}.
86  */
87 interface IERC165 {
88     /**
89      * @dev Returns true if this contract implements the interface defined by
90      * `interfaceId`. See the corresponding
91      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
92      * to learn more about how these ids are created.
93      *
94      * This function call must use less than 30 000 gas.
95      */
96     function supportsInterface(bytes4 interfaceId) external view returns (bool);
97 }
98 
99 
100 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.2
101 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Required interface of an ERC721 compliant contract.
107  */
108 interface IERC721 is IERC165 {
109     /**
110      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
113 
114     /**
115      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
116      */
117     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
118 
119     /**
120      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
121      */
122     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
123 
124     /**
125      * @dev Returns the number of tokens in ``owner``'s account.
126      */
127     function balanceOf(address owner) external view returns (uint256 balance);
128 
129     /**
130      * @dev Returns the owner of the `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function ownerOf(uint256 tokenId) external view returns (address owner);
137 
138     /**
139      * @dev Safely transfers `tokenId` token from `from` to `to`.
140      *
141      * Requirements:
142      *
143      * - `from` cannot be the zero address.
144      * - `to` cannot be the zero address.
145      * - `tokenId` token must exist and be owned by `from`.
146      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
148      *
149      * Emits a {Transfer} event.
150      */
151     function safeTransferFrom(
152         address from,
153         address to,
154         uint256 tokenId,
155         bytes calldata data
156     ) external;
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
160      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId
176     ) external;
177 
178     /**
179      * @dev Transfers `tokenId` token from `from` to `to`.
180      *
181      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must be owned by `from`.
188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
200      * The approval is cleared when the token is transferred.
201      *
202      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
203      *
204      * Requirements:
205      *
206      * - The caller must own the token or be an approved operator.
207      * - `tokenId` must exist.
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address to, uint256 tokenId) external;
212 
213     /**
214      * @dev Approve or remove `operator` as an operator for the caller.
215      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
216      *
217      * Requirements:
218      *
219      * - The `operator` cannot be the caller.
220      *
221      * Emits an {ApprovalForAll} event.
222      */
223     function setApprovalForAll(address operator, bool _approved) external;
224 
225     /**
226      * @dev Returns the account approved for `tokenId` token.
227      *
228      * Requirements:
229      *
230      * - `tokenId` must exist.
231      */
232     function getApproved(uint256 tokenId) external view returns (address operator);
233 
234     /**
235      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
236      *
237      * See {setApprovalForAll}
238      */
239     function isApprovedForAll(address owner, address operator) external view returns (bool);
240 }
241 
242 
243 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.2
244 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @title ERC721 token receiver interface
250  * @dev Interface for any contract that wants to support safeTransfers
251  * from ERC721 asset contracts.
252  */
253 interface IERC721Receiver {
254     /**
255      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
256      * by `operator` from `from`, this function is called.
257      *
258      * It must return its Solidity selector to confirm the token transfer.
259      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
260      *
261      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
262      */
263     function onERC721Received(
264         address operator,
265         address from,
266         uint256 tokenId,
267         bytes calldata data
268     ) external returns (bytes4);
269 }
270 
271 
272 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.2
273 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
279  * @dev See https://eips.ethereum.org/EIPS/eip-721
280  */
281 interface IERC721Metadata is IERC721 {
282     /**
283      * @dev Returns the token collection name.
284      */
285     function name() external view returns (string memory);
286 
287     /**
288      * @dev Returns the token collection symbol.
289      */
290     function symbol() external view returns (string memory);
291 
292     /**
293      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
294      */
295     function tokenURI(uint256 tokenId) external view returns (string memory);
296 }
297 
298 
299 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.7.2
300 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
306  * @dev See https://eips.ethereum.org/EIPS/eip-721
307  */
308 interface IERC721Enumerable is IERC721 {
309     /**
310      * @dev Returns the total amount of tokens stored by the contract.
311      */
312     function totalSupply() external view returns (uint256);
313 
314     /**
315      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
316      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
317      */
318     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
319 
320     /**
321      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
322      * Use along with {totalSupply} to enumerate all tokens.
323      */
324     function tokenByIndex(uint256 index) external view returns (uint256);
325 }
326 
327 
328 // File @openzeppelin/contracts/utils/Address.sol@v4.7.2
329 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
330 
331 pragma solidity ^0.8.1;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      *
354      * [IMPORTANT]
355      * ====
356      * You shouldn't rely on `isContract` to protect against flash loan attacks!
357      *
358      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
359      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
360      * constructor.
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // This method relies on extcodesize/address.code.length, which returns 0
365         // for contracts in construction, since the code is only stored at the end
366         // of the constructor execution.
367 
368         return account.code.length > 0;
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         (bool success, ) = recipient.call{value: amount}("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain `call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(
442         address target,
443         bytes memory data,
444         uint256 value
445     ) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         require(address(this).balance >= value, "Address: insufficient balance for call");
462         require(isContract(target), "Address: call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.call{value: value}(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
475         return functionStaticCall(target, data, "Address: low-level static call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal view returns (bytes memory) {
489         require(isContract(target), "Address: static call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.staticcall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
502         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a delegate call.
508      *
509      * _Available since v3.4._
510      */
511     function functionDelegateCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         require(isContract(target), "Address: delegate call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.delegatecall(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
524      * revert reason using the provided one.
525      *
526      * _Available since v4.3._
527      */
528     function verifyCallResult(
529         bool success,
530         bytes memory returndata,
531         string memory errorMessage
532     ) internal pure returns (bytes memory) {
533         if (success) {
534             return returndata;
535         } else {
536             // Look for revert reason and bubble it up if present
537             if (returndata.length > 0) {
538                 // The easiest way to bubble the revert reason is using memory via assembly
539                 /// @solidity memory-safe-assembly
540                 assembly {
541                     let returndata_size := mload(returndata)
542                     revert(add(32, returndata), returndata_size)
543                 }
544             } else {
545                 revert(errorMessage);
546             }
547         }
548     }
549 }
550 
551 
552 // File @openzeppelin/contracts/utils/Context.sol@v4.7.2
553 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Provides information about the current execution context, including the
559  * sender of the transaction and its data. While these are generally available
560  * via msg.sender and msg.data, they should not be accessed in such a direct
561  * manner, since when dealing with meta-transactions the account sending and
562  * paying for execution may not be the actual sender (as far as an application
563  * is concerned).
564  *
565  * This contract is only required for intermediate, library-like contracts.
566  */
567 abstract contract Context {
568     function _msgSender() internal view virtual returns (address) {
569         return msg.sender;
570     }
571 
572     function _msgData() internal view virtual returns (bytes calldata) {
573         return msg.data;
574     }
575 }
576 
577 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.2
578 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 /**
583  * @dev Implementation of the {IERC165} interface.
584  *
585  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
586  * for the additional interface id that will be supported. For example:
587  *
588  * ```solidity
589  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
591  * }
592  * ```
593  *
594  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
595  */
596 abstract contract ERC165 is IERC165 {
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      */
600     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
601         return interfaceId == type(IERC165).interfaceId;
602     }
603 }
604 
605 
606 // File contracts/ERC721A.sol
607 // Creator: Chiru Labs
608 
609 pragma solidity ^0.8.4;
610 
611 
612 error ApprovalCallerNotOwnerNorApproved();
613 error ApprovalQueryForNonexistentToken();
614 error ApproveToCaller();
615 error ApprovalToCurrentOwner();
616 error BalanceQueryForZeroAddress();
617 error MintedQueryForZeroAddress();
618 error BurnedQueryForZeroAddress();
619 error AuxQueryForZeroAddress();
620 error MintToZeroAddress();
621 error MintZeroQuantity();
622 error OwnerIndexOutOfBounds();
623 error OwnerQueryForNonexistentToken();
624 error TokenIndexOutOfBounds();
625 error TransferCallerNotOwnerNorApproved();
626 error TransferFromIncorrectOwner();
627 error TransferToNonERC721ReceiverImplementer();
628 error TransferToZeroAddress();
629 error URIQueryForNonexistentToken();
630 
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
633  * the Metadata extension. Built to optimize for lower gas during batch mints.
634  *
635  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
636  *
637  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
638  *
639  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
640  */
641 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
642     using Address for address;
643     using Strings for uint256;
644 
645     // Compiler will pack this into a single 256bit word.
646     struct TokenOwnership {
647         // The address of the owner.
648         address addr;
649         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
650         uint64 startTimestamp;
651         // Whether the token has been burned.
652         bool burned;
653     }
654 
655     // Compiler will pack this into a single 256bit word.
656     struct AddressData {
657         // Realistically, 2**64-1 is more than enough.
658         uint64 balance;
659         // Keeps track of mint count with minimal overhead for tokenomics.
660         uint64 numberMinted;
661         // Keeps track of burn count with minimal overhead for tokenomics.
662         uint64 numberBurned;
663         // For miscellaneous variable(s) pertaining to the address
664         // (e.g. number of whitelist mint slots used).
665         // If there are multiple variables, please pack them into a uint64.
666         uint64 aux;
667     }
668 
669     // The tokenId of the next token to be minted.
670     uint256 internal _currentIndex;
671 
672     // The number of tokens burned.
673     uint256 internal _burnCounter;
674 
675     // Token name
676     string private _name;
677 
678     // Token symbol
679     string private _symbol;
680 
681     // Mapping from token ID to ownership details
682     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
683     mapping(uint256 => TokenOwnership) internal _ownerships;
684 
685     // Mapping owner address to address data
686     mapping(address => AddressData) private _addressData;
687 
688     // Mapping from token ID to approved address
689     mapping(uint256 => address) private _tokenApprovals;
690 
691     // Mapping from owner to operator approvals
692     mapping(address => mapping(address => bool)) private _operatorApprovals;
693 
694     constructor(string memory name_, string memory symbol_) {
695         _name = name_;
696         _symbol = symbol_;
697         _currentIndex = _startTokenId();
698     }
699 
700     /**
701      * To change the starting tokenId, please override this function.
702      */
703     function _startTokenId() internal view virtual returns (uint256) {
704         return 1;
705     }
706 
707     /**
708      * @dev See {IERC721Enumerable-totalSupply}.
709      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
710      */
711     function totalSupply() public view returns (uint256) {
712         // Counter underflow is impossible as _burnCounter cannot be incremented
713         // more than _currentIndex - _startTokenId() times
714         unchecked {
715             return _currentIndex - _burnCounter - _startTokenId();
716         }
717     }
718 
719     /**
720      * Returns the total amount of tokens minted in the contract.
721      */
722     function _totalMinted() internal view returns (uint256) {
723         // Counter underflow is impossible as _currentIndex does not decrement,
724         // and it is initialized to _startTokenId()
725         unchecked {
726             return _currentIndex - _startTokenId();
727         }
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
734         return
735             interfaceId == type(IERC721).interfaceId ||
736             interfaceId == type(IERC721Metadata).interfaceId ||
737             super.supportsInterface(interfaceId);
738     }
739 
740     /**
741      * @dev See {IERC721-balanceOf}.
742      */
743     function balanceOf(address owner) public view override returns (uint256) {
744         if (owner == address(0)) revert BalanceQueryForZeroAddress();
745         return uint256(_addressData[owner].balance);
746     }
747 
748     /**
749      * Returns the number of tokens minted by `owner`.
750      */
751     function _numberMinted(address owner) internal view returns (uint256) {
752         if (owner == address(0)) revert MintedQueryForZeroAddress();
753         return uint256(_addressData[owner].numberMinted);
754     }
755 
756     /**
757      * Returns the number of tokens burned by or on behalf of `owner`.
758      */
759     function _numberBurned(address owner) internal view returns (uint256) {
760         if (owner == address(0)) revert BurnedQueryForZeroAddress();
761         return uint256(_addressData[owner].numberBurned);
762     }
763 
764     /**
765      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
766      */
767     function _getAux(address owner) internal view returns (uint64) {
768         if (owner == address(0)) revert AuxQueryForZeroAddress();
769         return _addressData[owner].aux;
770     }
771 
772     /**
773      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
774      * If there are multiple variables, please pack them into a uint64.
775      */
776     function _setAux(address owner, uint64 aux) internal {
777         if (owner == address(0)) revert AuxQueryForZeroAddress();
778         _addressData[owner].aux = aux;
779     }
780 
781 
782     /**
783      * Gas spent here starts off proportional to the maximum mint batch size.
784      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
785      */
786     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
787         uint256 curr = tokenId;
788 
789         unchecked {
790             if (_startTokenId() <= curr && curr < _currentIndex) {
791                 TokenOwnership memory ownership = _ownerships[curr];
792                 if (!ownership.burned) {
793                     if (ownership.addr != address(0)) {
794                         return ownership;
795                     }
796                     // Invariant:
797                     // There will always be an ownership that has an address and is not burned
798                     // before an ownership that does not have an address and is not burned.
799                     // Hence, curr will not underflow.
800                     while (true) {
801                         curr--;
802                         ownership = _ownerships[curr];
803                         if (ownership.addr != address(0)) {
804                             return ownership;
805                         }
806                     }
807                 }
808             }
809         }
810         revert OwnerQueryForNonexistentToken();
811     }
812 
813     /**
814      * @dev See {IERC721-ownerOf}.
815      */
816     function ownerOf(uint256 tokenId) public view override returns (address) {
817         return ownershipOf(tokenId).addr;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-name}.
822      */
823     function name() public view virtual override returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-symbol}.
829      */
830     function symbol() public view virtual override returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-tokenURI}.
836      */
837     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
838         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
839 
840         string memory baseURI = _baseURI();
841         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
842     }
843 
844     /**
845      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
846      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
847      * by default, can be overriden in child contracts.
848      */
849     function _baseURI() internal view virtual returns (string memory) {
850         return '';
851     }
852 
853     /**
854      * @dev See {IERC721-approve}.
855      */
856     function approve(address to, uint256 tokenId) public override {
857         address owner = ERC721A.ownerOf(tokenId);
858         if (to == owner) revert ApprovalToCurrentOwner();
859 
860         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
861             revert ApprovalCallerNotOwnerNorApproved();
862         }
863 
864         _approve(to, tokenId, owner);
865     }
866 
867     /**
868      * @dev See {IERC721-getApproved}.
869      */
870     function getApproved(uint256 tokenId) public view override returns (address) {
871         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
872 
873         return _tokenApprovals[tokenId];
874     }
875 
876     /**
877      * @dev See {IERC721-setApprovalForAll}.
878      */
879     function setApprovalForAll(address operator, bool approved) public override {
880         if (operator == _msgSender()) revert ApproveToCaller();
881 
882         _operatorApprovals[_msgSender()][operator] = approved;
883         emit ApprovalForAll(_msgSender(), operator, approved);
884     }
885 
886     /**
887      * @dev See {IERC721-isApprovedForAll}.
888      */
889     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
890         return _operatorApprovals[owner][operator];
891     }
892 
893     /**
894      * @dev See {IERC721-transferFrom}.
895      */
896     function transferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         _transfer(from, to, tokenId);
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         safeTransferFrom(from, to, tokenId, '');
913     }
914 
915     /**
916      * @dev See {IERC721-safeTransferFrom}.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) public virtual override {
924         _transfer(from, to, tokenId);
925         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
926             revert TransferToNonERC721ReceiverImplementer();
927         }
928     }
929 
930     /**
931      * @dev Returns whether `tokenId` exists.
932      *
933      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
934      *
935      * Tokens start existing when they are minted (`_mint`),
936      */
937     function _exists(uint256 tokenId) internal view returns (bool) {
938         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
939             !_ownerships[tokenId].burned;
940     }
941 
942     function _safeMint(address to, uint256 quantity) internal {
943         _safeMint(to, quantity, '');
944     }
945 
946     /**
947      * @dev Safely mints `quantity` tokens and transfers them to `to`.
948      *
949      * Requirements:
950      *
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
952      * - `quantity` must be greater than 0.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _safeMint(
957         address to,
958         uint256 quantity,
959         bytes memory _data
960     ) internal {
961         _mint(to, quantity, _data, true);
962     }
963 
964     /**
965      * @dev Mints `quantity` tokens and transfers them to `to`.
966      *
967      * Requirements:
968      *
969      * - `to` cannot be the zero address.
970      * - `quantity` must be greater than 0.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _mint(
975         address to,
976         uint256 quantity,
977         bytes memory _data,
978         bool safe
979     ) internal {
980         uint256 startTokenId = _currentIndex;
981         if (to == address(0)) revert MintToZeroAddress();
982         if (quantity == 0) revert MintZeroQuantity();
983 
984         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
985 
986         // Overflows are incredibly unrealistic.
987         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
988         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
989         unchecked {
990             _addressData[to].balance += uint64(quantity);
991             _addressData[to].numberMinted += uint64(quantity);
992 
993             _ownerships[startTokenId].addr = to;
994             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
995 
996             uint256 updatedIndex = startTokenId;
997             uint256 end = updatedIndex + quantity;
998 
999             if (safe && to.isContract()) {
1000                 do {
1001                     emit Transfer(address(0), to, updatedIndex);
1002                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1003                         revert TransferToNonERC721ReceiverImplementer();
1004                     }
1005                 } while (updatedIndex != end);
1006                 // Reentrancy protection
1007                 if (_currentIndex != startTokenId) revert();
1008             } else {
1009                 do {
1010                     emit Transfer(address(0), to, updatedIndex++);
1011                 } while (updatedIndex != end);
1012             }
1013             _currentIndex = updatedIndex;
1014         }
1015         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) private {
1033         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1034 
1035         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1036             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1037             getApproved(tokenId) == _msgSender());
1038 
1039         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1040         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1041         if (to == address(0)) revert TransferToZeroAddress();
1042 
1043         _beforeTokenTransfers(from, to, tokenId, 1);
1044 
1045         // Clear approvals from the previous owner
1046         _approve(address(0), tokenId, prevOwnership.addr);
1047 
1048         // Underflow of the sender's balance is impossible because we check for
1049         // ownership above and the recipient's balance can't realistically overflow.
1050         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1051         unchecked {
1052             _addressData[from].balance -= 1;
1053             _addressData[to].balance += 1;
1054 
1055             _ownerships[tokenId].addr = to;
1056             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1057 
1058             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1059             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1060             uint256 nextTokenId = tokenId + 1;
1061             if (_ownerships[nextTokenId].addr == address(0)) {
1062                 // This will suffice for checking _exists(nextTokenId),
1063                 // as a burned slot cannot contain the zero address.
1064                 if (nextTokenId < _currentIndex) {
1065                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1066                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1067                 }
1068             }
1069         }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev Destroys `tokenId`.
1077      * The approval is cleared when the token is burned.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1087 
1088         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1089 
1090         // Clear approvals from the previous owner
1091         _approve(address(0), tokenId, prevOwnership.addr);
1092 
1093         // Underflow of the sender's balance is impossible because we check for
1094         // ownership above and the recipient's balance can't realistically overflow.
1095         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1096         unchecked {
1097             _addressData[prevOwnership.addr].balance -= 1;
1098             _addressData[prevOwnership.addr].numberBurned += 1;
1099 
1100             // Keep track of who burned the token, and the timestamp of burning.
1101             _ownerships[tokenId].addr = prevOwnership.addr;
1102             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1103             _ownerships[tokenId].burned = true;
1104 
1105             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1106             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1107             uint256 nextTokenId = tokenId + 1;
1108             if (_ownerships[nextTokenId].addr == address(0)) {
1109                 // This will suffice for checking _exists(nextTokenId),
1110                 // as a burned slot cannot contain the zero address.
1111                 if (nextTokenId < _currentIndex) {
1112                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1113                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1114                 }
1115             }
1116         }
1117 
1118         emit Transfer(prevOwnership.addr, address(0), tokenId);
1119         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1120 
1121         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1122         unchecked {
1123             _burnCounter++;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Approve `to` to operate on `tokenId`
1129      *
1130      * Emits a {Approval} event.
1131      */
1132     function _approve(
1133         address to,
1134         uint256 tokenId,
1135         address owner
1136     ) private {
1137         _tokenApprovals[tokenId] = to;
1138         emit Approval(owner, to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1143      *
1144      * @param from address representing the previous owner of the given token ID
1145      * @param to target address that will receive the tokens
1146      * @param tokenId uint256 ID of the token to be transferred
1147      * @param _data bytes optional data to send along with the call
1148      * @return bool whether the call correctly returned the expected magic value
1149      */
1150     function _checkContractOnERC721Received(
1151         address from,
1152         address to,
1153         uint256 tokenId,
1154         bytes memory _data
1155     ) private returns (bool) {
1156         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1157             return retval == IERC721Receiver(to).onERC721Received.selector;
1158         } catch (bytes memory reason) {
1159             if (reason.length == 0) {
1160                 revert TransferToNonERC721ReceiverImplementer();
1161             } else {
1162                 assembly {
1163                     revert(add(32, reason), mload(reason))
1164                 }
1165             }
1166         }
1167     }
1168 
1169     /**
1170      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1171      * And also called before burning one token.
1172      *
1173      * startTokenId - the first token id to be transferred
1174      * quantity - the amount to be transferred
1175      *
1176      * Calling conditions:
1177      *
1178      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1179      * transferred to `to`.
1180      * - When `from` is zero, `tokenId` will be minted for `to`.
1181      * - When `to` is zero, `tokenId` will be burned by `from`.
1182      * - `from` and `to` are never both zero.
1183      */
1184     function _beforeTokenTransfers(
1185         address from,
1186         address to,
1187         uint256 startTokenId,
1188         uint256 quantity
1189     ) internal virtual {}
1190 
1191     /**
1192      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1193      * minting.
1194      * And also called after one token has been burned.
1195      *
1196      * startTokenId - the first token id to be transferred
1197      * quantity - the amount to be transferred
1198      *
1199      * Calling conditions:
1200      *
1201      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1202      * transferred to `to`.
1203      * - When `from` is zero, `tokenId` has been minted for `to`.
1204      * - When `to` is zero, `tokenId` has been burned by `from`.
1205      * - `from` and `to` are never both zero.
1206      */
1207     function _afterTokenTransfers(
1208         address from,
1209         address to,
1210         uint256 startTokenId,
1211         uint256 quantity
1212     ) internal virtual {}
1213 }
1214 
1215 
1216 // File contracts/mocks/StartTokenIdHelper.sol
1217 // Creators: Chiru Labs
1218 
1219 pragma solidity ^0.8.4;
1220 
1221 /**
1222  * This Helper is used to return a dynmamic value in the overriden _startTokenId() function.
1223  * Extending this Helper before the ERC721A contract give us access to the herein set `startTokenId`
1224  * to be returned by the overriden `_startTokenId()` function of ERC721A in the ERC721AStartTokenId mocks.
1225  */
1226 contract StartTokenIdHelper {
1227     uint256 public immutable startTokenId;
1228 
1229     constructor(uint256 startTokenId_) {
1230         startTokenId = startTokenId_;
1231     }
1232 }
1233 
1234 
1235 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.2
1236 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 /**
1241  * @dev Contract module which provides a basic access control mechanism, where
1242  * there is an account (an owner) that can be granted exclusive access to
1243  * specific functions.
1244  *
1245  * By default, the owner account will be the one that deploys the contract. This
1246  * can later be changed with {transferOwnership}.
1247  *
1248  * This module is used through inheritance. It will make available the modifier
1249  * `onlyOwner`, which can be applied to your functions to restrict their use to
1250  * the owner.
1251  */
1252 abstract contract Ownable is Context {
1253     address private _owner;
1254 
1255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1256 
1257     /**
1258      * @dev Initializes the contract setting the deployer as the initial owner.
1259      */
1260     constructor() {
1261         _transferOwnership(_msgSender());
1262     }
1263 
1264     /**
1265      * @dev Throws if called by any account other than the owner.
1266      */
1267     modifier onlyOwner() {
1268         _checkOwner();
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Returns the address of the current owner.
1274      */
1275     function owner() public view virtual returns (address) {
1276         return _owner;
1277     }
1278 
1279     /**
1280      * @dev Throws if the sender is not the owner.
1281      */
1282     function _checkOwner() internal view virtual {
1283         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1284     }
1285 
1286     /**
1287      * @dev Leaves the contract without owner. It will not be possible to call
1288      * `onlyOwner` functions anymore. Can only be called by the current owner.
1289      *
1290      * NOTE: Renouncing ownership will leave the contract without an owner,
1291      * thereby removing any functionality that is only available to the owner.
1292      */
1293     function renounceOwnership() public virtual onlyOwner {
1294         _transferOwnership(address(0));
1295     }
1296 
1297     /**
1298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1299      * Can only be called by the current owner.
1300      */
1301     function transferOwnership(address newOwner) public virtual onlyOwner {
1302         require(newOwner != address(0), "Ownable: new owner is the zero address");
1303         _transferOwnership(newOwner);
1304     }
1305 
1306     /**
1307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1308      * Internal function without access restriction.
1309      */
1310     function _transferOwnership(address newOwner) internal virtual {
1311         address oldOwner = _owner;
1312         _owner = newOwner;
1313         emit OwnershipTransferred(oldOwner, newOwner);
1314     }
1315 }
1316 
1317 /**
1318 PumaNitropass Smart Contract Development by @WumboLabs
1319 **/
1320 
1321 pragma solidity >=0.8.0 <0.9.0;
1322 
1323 interface PumaNitroToken {
1324     function balanceOf(address account)
1325         external
1326         view
1327         returns (uint256);
1328 
1329     function burnNitroTokenForNitroPass(uint256) external;
1330 
1331     function ownerOf(uint256 tokenId) external view returns (address);
1332 }
1333 
1334 interface PumaPhysical {
1335     function mint(address, uint256) external;
1336 }
1337 
1338 interface PumaForever {
1339     function mint(address, uint256) external;
1340 }
1341 
1342 contract PumaNitroPass is ERC721A, Ownable {
1343     using Strings for uint256;
1344     
1345     /// Contract interactions
1346     address private ForeverContract;
1347     address private PhysicalContract;
1348     address public TokenContract;
1349 
1350     /// Supply
1351     uint256 public constant MAX_SUPPLY = 4000;
1352     uint256 public PRICE = 0.2 ether;
1353     uint256 public MAX_PUBLIC_MINT = 1; // only 1 mint during pre or pub sale
1354 
1355     /// Status
1356     enum Status {
1357         NOT_LIVE,
1358         TOKEN_MINT,
1359         ONE_HOUR_MINT,
1360         PUBLIC,
1361         BURN_PASS,
1362         ENDED
1363     }
1364 
1365     /// Minting Variables
1366     string public baseURI = "https://puma-blackbox-prod.herokuapp.com/api/pass/";
1367     Status public state;
1368 
1369     mapping(address => uint256 ) public tokenAmountBurnedByAddress;
1370 
1371     constructor() ERC721A("PUMA Nitropass", "NPASS") {
1372     }
1373 
1374     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1375         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1376         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1377     }
1378 
1379     function ownerMint(uint256 _amount) external onlyOwner {
1380         require(state == Status.NOT_LIVE || state == Status.TOKEN_MINT, "PUMA Nitropass: Status must be not live or during 48 hour window");
1381         require(totalSupply() + _amount <= MAX_SUPPLY, "PUMA Nitropass: Mint amount exceeds supply");
1382         _safeMint(msg.sender, _amount);
1383     }
1384 
1385     function getRemainingSupply() external view returns (uint256) {
1386         return MAX_SUPPLY - totalSupply();
1387     }
1388 
1389     function getTokenAmountBurnedByAddress(address _address) public view returns (uint256) {
1390         require(_exists(tokenAmountBurnedByAddress[_address]), "PUMA Nitropass: Address has not burned any Nitro Tokens");
1391         return tokenAmountBurnedByAddress[_address];
1392     }
1393 
1394     function setForeverContract(address _ForeverContract) external onlyOwner {
1395         ForeverContract = _ForeverContract;
1396     }
1397 
1398     function setPhysicalContract(address _PhysicalContract) external onlyOwner {
1399         PhysicalContract = _PhysicalContract;
1400     }
1401 
1402     function setTokenContract(address _TokenContract) external onlyOwner {
1403         TokenContract = _TokenContract;
1404     }
1405 
1406     /// Burn all unused Nitropasses at a later date
1407     function burnAllNitroPasses() external onlyOwner {
1408         require(state == Status.ENDED, "PUMA Nitropass: Still Live");
1409         for (uint256 i; i<MAX_SUPPLY; i++) {
1410             if(_exists(i)) {
1411                 _burn(i);
1412             }
1413         }
1414     }
1415 
1416     /// Burn Nitropass on minting Forever and Physical
1417     function burnNitroPassAndMintForeverPhysical(uint256[] memory NitroPassIds) external {
1418         require(state == Status.BURN_PASS, "PUMA Nitropass: Status must be on Burn Pass");
1419         uint256 mintQuantity = NitroPassIds.length;
1420         require(balanceOf(msg.sender) >= mintQuantity, "PUMA Nitropass: Caller does not own enough Nitropass");
1421         require(PhysicalContract != address(0) && ForeverContract != address(0), "PUMA Nitropass: Set PhysicalContract and ForeverContract");
1422         uint256 burnCounter;
1423         for (uint256 i = 0; i < NitroPassIds.length; i++) {
1424             uint256 tokenId = NitroPassIds[i];
1425             require(msg.sender == ownerOf(tokenId), "PUMA Nitropass: Caller does not own NitroPassId");
1426             burnCounter++;
1427             _burn(tokenId);
1428         }
1429         PumaPhysical(PhysicalContract).mint(msg.sender, burnCounter);
1430         PumaForever(ForeverContract).mint(msg.sender, burnCounter);
1431     }
1432 
1433     function burnNitroTokenforNitroPass(uint256[] memory tokenIds) external payable {
1434         require(state == Status.TOKEN_MINT, "PUMA Nitropass: Token burn is not live");
1435         uint256 mintQuantity = tokenIds.length;
1436         require(PumaNitroToken(TokenContract).balanceOf(msg.sender) >= mintQuantity, "PUMA Nitropass: Caller does not own enough Nitro Tokens");
1437         require(TokenContract != address(0), "PUMA Nitropass: Set TokenContract");
1438         require(msg.value == PRICE * mintQuantity, "PUMA Nitropass: Not enough payment to mint Nitropass");      
1439         uint256 mintCounter;  
1440         for (uint256 i = 0; i < tokenIds.length; i++) {
1441             uint256 tokenId = tokenIds[i];
1442             address owner = PumaNitroToken(TokenContract).ownerOf(tokenId);
1443             require(msg.sender == owner, "PUMA Nitropass: Message sender is not owner of tokenid");
1444             tokenAmountBurnedByAddress[owner]++;
1445             mintCounter++;
1446             PumaNitroToken(TokenContract).burnNitroTokenForNitroPass(tokenId);
1447         }
1448         _safeMint(msg.sender, mintCounter);
1449     }
1450 
1451     function oneHourMint(uint256 _mintAmount) external payable {
1452         require(state == Status.ONE_HOUR_MINT, "PUMA Nitropass: One hour window not open");
1453         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "PUMA Nitropass: Mint amount exceeds supply");
1454         require(msg.value == PRICE * _mintAmount, "PUMA Nitropass: Not enough payment to mint Nitropass");     
1455         require(_numberMinted(msg.sender) + _mintAmount <= tokenAmountBurnedByAddress[msg.sender] * 2, "PUMA Nitropass: Not enough tokens burned in 48 hours window");
1456         require(_mintAmount <= tokenAmountBurnedByAddress[msg.sender], "PUMA Nitropass: Not enough tokens burned to mint that amount");
1457         _safeMint(msg.sender, _mintAmount);
1458     }
1459 
1460     function publicMint() external payable {
1461         require(state == Status.PUBLIC, "PUMA Nitropass: Public not live");
1462         require(msg.sender == tx.origin, "PUMA Nitropass: Contract Interaction Not Allowed");
1463         require(totalSupply() + 1 <= MAX_SUPPLY, "PUMA Nitropass: Mint Supply Exceeded");
1464         require(msg.value == PRICE, "PUMA Nitropass: Not enough payment to mint Nitropass");
1465         require(_numberMinted(msg.sender) < MAX_PUBLIC_MINT, "PUMA Nitropass: Exceeds Max Per Wallet");
1466         _safeMint(msg.sender, 1);
1467     }
1468 
1469     function setState(Status _state) external onlyOwner {
1470         state = _state;
1471     }
1472     
1473     function setURI(string calldata _newURI) external onlyOwner {
1474         baseURI = _newURI;
1475     }
1476 
1477     function withdrawMoney() external onlyOwner {
1478         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1479         require(success, "Withdraw failed.");
1480     }
1481 
1482 }