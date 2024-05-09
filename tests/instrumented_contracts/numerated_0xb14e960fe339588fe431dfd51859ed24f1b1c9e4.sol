1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.9.1 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25 
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 
34 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
35 
36 
37 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev Required interface of an ERC721 compliant contract.
43  */
44 interface IERC721 is IERC165 {
45     /**
46      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
47      */
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54 
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
59 
60     /**
61      * @dev Returns the number of tokens in ``owner``'s account.
62      */
63     function balanceOf(address owner) external view returns (uint256 balance);
64 
65     /**
66      * @dev Returns the owner of the `tokenId` token.
67      *
68      * Requirements:
69      *
70      * - `tokenId` must exist.
71      */
72     function ownerOf(uint256 tokenId) external view returns (address owner);
73 
74     /**
75      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
76      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must exist and be owned by `from`.
83      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
84      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
85      *
86      * Emits a {Transfer} event.
87      */
88     function safeTransferFrom(
89         address from,
90         address to,
91         uint256 tokenId
92     ) external;
93 
94     /**
95      * @dev Transfers `tokenId` token from `from` to `to`.
96      *
97      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must be owned by `from`.
104      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId) external view returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171 
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 }
178 
179 
180 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @title ERC721 token receiver interface
189  * @dev Interface for any contract that wants to support safeTransfers
190  * from ERC721 asset contracts.
191  */
192 interface IERC721Receiver {
193     /**
194      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
195      * by `operator` from `from`, this function is called.
196      *
197      * It must return its Solidity selector to confirm the token transfer.
198      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
199      *
200      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
201      */
202     function onERC721Received(
203 
204         address operator,
205         address from,
206         uint256 tokenId,
207         bytes calldata data
208     ) external returns (bytes4);
209 }
210 
211 
212 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
221  * @dev See https://eips.ethereum.org/EIPS/eip-721
222  */
223 interface IERC721Metadata is IERC721 {
224     /**
225      * @dev Returns the token collection name.
226      */
227     function name() external view returns (string memory);
228 
229     /**
230      * @dev Returns the token collection symbol.
231      */
232     function symbol() external view returns (string memory);
233 
234 
235     /**
236      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
237      */
238     function tokenURI(uint256 tokenId) external view returns (string memory);
239 }
240 
241 
242 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
243 
244 
245 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
251  * @dev See https://eips.ethereum.org/EIPS/eip-721
252  */
253 interface IERC721Enumerable is IERC721 {
254     /**
255      * @dev Returns the total amount of tokens stored by the contract.
256      */
257     function totalSupply() external view returns (uint256);
258 
259     /**
260      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
261      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
262      */
263     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
264 
265 
266     /**
267      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
268      * Use along with {totalSupply} to enumerate all tokens.
269      */
270     function tokenByIndex(uint256 index) external view returns (uint256);
271 }
272 
273 
274 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
275 
276 
277 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
278 
279 pragma solidity ^0.8.1;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      *
302      * [IMPORTANT]
303      * ====
304      * You shouldn't rely on `isContract` to protect against flash loan attacks!
305      *
306      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
307      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
308      * constructor.
309      * ====
310      */
311     function isContract(address account) internal view returns (bool) {
312         // This method relies on extcodesize/address.code.length, which returns 0
313         // for contracts in construction, since the code is only stored at the end
314         // of the constructor execution.
315 
316         return account.code.length > 0;
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      */
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(address(this).balance >= amount, "Address: insufficient balance");
337 
338         (bool success, ) = recipient.call{value: amount}("");
339         require(success, "Address: unable to send value, recipient may have reverted");
340     }
341 
342     /**
343      * @dev Performs a Solidity function call using a low level `call`. A
344      * plain `call` is an unsafe replacement for a function call: use this
345      * function instead.
346      *
347      * If `target` reverts with a revert reason, it is bubbled up by this
348      * function (like regular Solidity function calls).
349      *
350      * Returns the raw returned data. To convert to the expected return value,
351      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
352      *
353      * Requirements:
354      *
355      * - `target` must be a contract.
356      * - calling `target` with `data` must not revert.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionCall(target, data, "Address: low-level call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but also transferring `value` wei to `target`.
381      *
382      * Requirements:
383      *
384      * - the calling contract must have an ETH balance of at least `value`.
385      * - the called Solidity function must be `payable`.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
399      * with `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         require(address(this).balance >= value, "Address: insufficient balance for call");
410         require(isContract(target), "Address: call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.call{value: value}(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
423         return functionStaticCall(target, data, "Address: low-level static call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.staticcall(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
450         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.delegatecall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
472      * revert reason using the provided one.
473      *
474      * _Available since v4.3._
475      */
476     function verifyCallResult(
477         bool success,
478         bytes memory returndata,
479         string memory errorMessage
480     ) internal pure returns (bytes memory) {
481         if (success) {
482             return returndata;
483         } else {
484             // Look for revert reason and bubble it up if present
485             if (returndata.length > 0) {
486                 // The easiest way to bubble the revert reason is using memory via assembly
487 
488                 assembly {
489                     let returndata_size := mload(returndata)
490                     revert(add(32, returndata), returndata_size)
491                 }
492 
493             } else {
494                 revert(errorMessage);
495             }
496         }
497     }
498 }
499 
500 
501 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Provides information about the current execution context, including the
510  * sender of the transaction and its data. While these are generally available
511  * via msg.sender and msg.data, they should not be accessed in such a direct
512  * manner, since when dealing with meta-transactions the account sending and
513  * paying for execution may not be the actual sender (as far as an application
514  * is concerned).
515  *
516  * This contract is only required for intermediate, library-like contracts.
517  */
518 abstract contract Context {
519     function _msgSender() internal view virtual returns (address) {
520         return msg.sender;
521 
522     }
523 
524     function _msgData() internal view virtual returns (bytes calldata) {
525         return msg.data;
526     }
527 }
528 
529 
530 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev String operations.
539  */
540 library Strings {
541     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
545      */
546     function toString(uint256 value) internal pure returns (string memory) {
547         // Inspired by OraclizeAPI's implementation - MIT licence
548         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
549 
550         if (value == 0) {
551             return "0";
552         }
553         uint256 temp = value;
554         uint256 digits;
555         while (temp != 0) {
556             digits++;
557             temp /= 10;
558         }
559         bytes memory buffer = new bytes(digits);
560         while (value != 0) {
561             digits -= 1;
562             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
563             value /= 10;
564         }
565         return string(buffer);
566     }
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
570      */
571     function toHexString(uint256 value) internal pure returns (string memory) {
572         if (value == 0) {
573             return "0x00";
574         }
575         uint256 temp = value;
576         uint256 length = 0;
577         while (temp != 0) {
578             length++;
579             temp >>= 8;
580         }
581         return toHexString(value, length);
582     }
583 
584     /**
585      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
586      */
587     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
588         bytes memory buffer = new bytes(2 * length + 2);
589         buffer[0] = "0";
590         buffer[1] = "x";
591         for (uint256 i = 2 * length + 1; i > 1; --i) {
592             buffer[i] = _HEX_SYMBOLS[value & 0xf];
593 
594             value >>= 4;
595         }
596         require(value == 0, "Strings: hex length insufficient");
597         return string(buffer);
598     }
599 }
600 
601 
602 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev Implementation of the {IERC165} interface.
611  *
612  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
613  * for the additional interface id that will be supported. For example:
614  *
615  * ```solidity
616  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
618  * }
619  * ```
620  *
621  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
622  */
623 abstract contract ERC165 is IERC165 {
624     /**
625 
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165).interfaceId;
630     }
631 }
632 
633 
634 // File erc721a/contracts/ERC721A.sol@v3.0.0
635 
636 
637 // Creator: Chiru Labs
638 
639 pragma solidity ^0.8.4;
640 
641 
642 
643 
644 
645 
646 
647 
648 error ApprovalCallerNotOwnerNorApproved();
649 error ApprovalQueryForNonexistentToken();
650 error ApproveToCaller();
651 error ApprovalToCurrentOwner();
652 error BalanceQueryForZeroAddress();
653 error MintedQueryForZeroAddress();
654 error BurnedQueryForZeroAddress();
655 error AuxQueryForZeroAddress();
656 error MintToZeroAddress();
657 error MintZeroQuantity();
658 error OwnerIndexOutOfBounds();
659 error OwnerQueryForNonexistentToken();
660 error TokenIndexOutOfBounds();
661 error TransferCallerNotOwnerNorApproved();
662 error TransferFromIncorrectOwner();
663 error TransferToNonERC721ReceiverImplementer();
664 error TransferToZeroAddress();
665 error URIQueryForNonexistentToken();
666 
667 /**
668  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
669  * the Metadata extension. Built to optimize for lower gas during batch mints.
670  *
671  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
672  *
673  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
674  *
675  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
676  */
677 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
678     using Address for address;
679     using Strings for uint256;
680 
681     // Compiler will pack this into a single 256bit word.
682     struct TokenOwnership {
683         // The address of the owner.
684         address addr;
685         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
686         uint64 startTimestamp;
687         // Whether the token has been burned.
688         bool burned;
689     }
690 
691     // Compiler will pack this into a single 256bit word.
692     struct AddressData {
693         // Realistically, 2**64-1 is more than enough.
694         uint64 balance;
695         // Keeps track of mint count with minimal overhead for tokenomics.
696         uint64 numberMinted;
697         // Keeps track of burn count with minimal overhead for tokenomics.
698         uint64 numberBurned;
699         // For miscellaneous variable(s) pertaining to the address
700         // (e.g. number of whitelist mint slots used).
701         // If there are multiple variables, please pack them into a uint64.
702         uint64 aux;
703     }
704 
705     // The tokenId of the next token to be minted.
706     uint256 internal _currentIndex;
707 
708     // The number of tokens burned.
709     uint256 internal _burnCounter;
710 
711     // Token name
712     string private _name;
713 
714     // Token symbol
715     string private _symbol;
716 
717     // Mapping from token ID to ownership details
718     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
719     mapping(uint256 => TokenOwnership) internal _ownerships;
720 
721     // Mapping owner address to address data
722     mapping(address => AddressData) private _addressData;
723 
724     // Mapping from token ID to approved address
725     mapping(uint256 => address) private _tokenApprovals;
726 
727     // Mapping from owner to operator approvals
728     mapping(address => mapping(address => bool)) private _operatorApprovals;
729 
730     constructor(string memory name_, string memory symbol_) {
731         _name = name_;
732         _symbol = symbol_;
733         _currentIndex = _startTokenId();
734     }
735 
736     /**
737      * To change the starting tokenId, please override this function.
738      */
739     function _startTokenId() internal view virtual returns (uint256) {
740         return 0;
741     }
742 
743     /**
744      * @dev See {IERC721Enumerable-totalSupply}.
745      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
746      */
747     function totalSupply() public view returns (uint256) {
748         // Counter underflow is impossible as _burnCounter cannot be incremented
749         // more than _currentIndex - _startTokenId() times
750         unchecked {
751             return _currentIndex - _burnCounter - _startTokenId();
752         }
753     }
754 
755     /**
756      * Returns the total amount of tokens minted in the contract.
757      */
758     function _totalMinted() internal view returns (uint256) {
759         // Counter underflow is impossible as _currentIndex does not decrement,
760         // and it is initialized to _startTokenId()
761         unchecked {
762             return _currentIndex - _startTokenId();
763         }
764     }
765 
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
770         return
771             interfaceId == type(IERC721).interfaceId ||
772             interfaceId == type(IERC721Metadata).interfaceId ||
773             super.supportsInterface(interfaceId);
774     }
775 
776     /**
777      * @dev See {IERC721-balanceOf}.
778      */
779     function balanceOf(address owner) public view override returns (uint256) {
780         if (owner == address(0)) revert BalanceQueryForZeroAddress();
781         return uint256(_addressData[owner].balance);
782     }
783 
784     /**
785      * Returns the number of tokens minted by `owner`.
786      */
787     function _numberMinted(address owner) internal view returns (uint256) {
788         if (owner == address(0)) revert MintedQueryForZeroAddress();
789         return uint256(_addressData[owner].numberMinted);
790     }
791 
792     /**
793      * Returns the number of tokens burned by or on behalf of `owner`.
794      */
795     function _numberBurned(address owner) internal view returns (uint256) {
796         if (owner == address(0)) revert BurnedQueryForZeroAddress();
797         return uint256(_addressData[owner].numberBurned);
798     }
799 
800     /**
801      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
802      */
803     function _getAux(address owner) internal view returns (uint64) {
804         if (owner == address(0)) revert AuxQueryForZeroAddress();
805         return _addressData[owner].aux;
806     }
807 
808     /**
809      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
810      * If there are multiple variables, please pack them into a uint64.
811      */
812     function _setAux(address owner, uint64 aux) internal {
813         if (owner == address(0)) revert AuxQueryForZeroAddress();
814         _addressData[owner].aux = aux;
815     }
816 
817     /**
818      * Gas spent here starts off proportional to the maximum mint batch size.
819      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
820      */
821     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
822         uint256 curr = tokenId;
823 
824         unchecked {
825             if (_startTokenId() <= curr && curr < _currentIndex) {
826                 TokenOwnership memory ownership = _ownerships[curr];
827                 if (!ownership.burned) {
828                     if (ownership.addr != address(0)) {
829                         return ownership;
830                     }
831                     // Invariant:
832                     // There will always be an ownership that has an address and is not burned
833                     // before an ownership that does not have an address and is not burned.
834                     // Hence, curr will not underflow.
835                     while (true) {
836                         curr--;
837                         ownership = _ownerships[curr];
838                         if (ownership.addr != address(0)) {
839                             return ownership;
840                         }
841                     }
842                 }
843             }
844         }
845         revert OwnerQueryForNonexistentToken();
846     }
847 
848     /**
849      * @dev See {IERC721-ownerOf}.
850      */
851     function ownerOf(uint256 tokenId) public view override returns (address) {
852         return ownershipOf(tokenId).addr;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-name}.
857      */
858     function name() public view virtual override returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-symbol}.
864      */
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-tokenURI}.
871      */
872     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
873         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
874 
875         string memory baseURI = _baseURI();
876         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
877     }
878 
879     /**
880      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882      * by default, can be overriden in child contracts.
883      */
884     function _baseURI() internal view virtual returns (string memory) {
885         return '';
886     }
887 
888     /**
889      * @dev See {IERC721-approve}.
890      */
891     function approve(address to, uint256 tokenId) public override {
892         address owner = ERC721A.ownerOf(tokenId);
893         if (to == owner) revert ApprovalToCurrentOwner();
894 
895         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
896             revert ApprovalCallerNotOwnerNorApproved();
897         }
898 
899         _approve(to, tokenId, owner);
900     }
901 
902     /**
903      * @dev See {IERC721-getApproved}.
904      */
905     function getApproved(uint256 tokenId) public view override returns (address) {
906         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
907 
908         return _tokenApprovals[tokenId];
909     }
910 
911     /**
912      * @dev See {IERC721-setApprovalForAll}.
913      */
914     function setApprovalForAll(address operator, bool approved) public override {
915         if (operator == _msgSender()) revert ApproveToCaller();
916 
917         _operatorApprovals[_msgSender()][operator] = approved;
918         emit ApprovalForAll(_msgSender(), operator, approved);
919     }
920 
921     /**
922      * @dev See {IERC721-isApprovedForAll}.
923      */
924     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
925         return _operatorApprovals[owner][operator];
926     }
927 
928     /**
929      * @dev See {IERC721-transferFrom}.
930      */
931     function transferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public virtual override {
936         _transfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         safeTransferFrom(from, to, tokenId, '');
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) public virtual override {
959         _transfer(from, to, tokenId);
960         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
961             revert TransferToNonERC721ReceiverImplementer();
962         }
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      */
972     function _exists(uint256 tokenId) internal view returns (bool) {
973         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
974             !_ownerships[tokenId].burned;
975     }
976 
977     function _safeMint(address to, uint256 quantity) internal {
978         _safeMint(to, quantity, '');
979     }
980 
981     /**
982      * @dev Safely mints `quantity` tokens and transfers them to `to`.
983      *
984      * Requirements:
985      *
986      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
987      * - `quantity` must be greater than 0.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeMint(
992         address to,
993         uint256 quantity,
994         bytes memory _data
995     ) internal {
996         _mint(to, quantity, _data, true);
997     }
998 
999     /**
1000      * @dev Mints `quantity` tokens and transfers them to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _mint(
1010         address to,
1011         uint256 quantity,
1012         bytes memory _data,
1013         bool safe
1014     ) internal {
1015         uint256 startTokenId = _currentIndex;
1016         if (to == address(0)) revert MintToZeroAddress();
1017         if (quantity == 0) revert MintZeroQuantity();
1018 
1019         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1020 
1021         // Overflows are incredibly unrealistic.
1022         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1023         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1024         unchecked {
1025             _addressData[to].balance += uint64(quantity);
1026             _addressData[to].numberMinted += uint64(quantity);
1027 
1028             _ownerships[startTokenId].addr = to;
1029             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1030 
1031             uint256 updatedIndex = startTokenId;
1032             uint256 end = updatedIndex + quantity;
1033 
1034             if (safe && to.isContract()) {
1035                 do {
1036                     emit Transfer(address(0), to, updatedIndex);
1037                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1038                         revert TransferToNonERC721ReceiverImplementer();
1039                     }
1040                 } while (updatedIndex != end);
1041                 // Reentrancy protection
1042                 if (_currentIndex != startTokenId) revert();
1043             } else {
1044                 do {
1045                     emit Transfer(address(0), to, updatedIndex++);
1046                 } while (updatedIndex != end);
1047             }
1048             _currentIndex = updatedIndex;
1049         }
1050         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1051     }
1052 
1053     /**
1054      * @dev Transfers `tokenId` from `from` to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must be owned by `from`.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _transfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) private {
1068         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1069 
1070         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1071             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1072             getApproved(tokenId) == _msgSender());
1073 
1074         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1075         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1076         if (to == address(0)) revert TransferToZeroAddress();
1077 
1078         _beforeTokenTransfers(from, to, tokenId, 1);
1079 
1080         // Clear approvals from the previous owner
1081         _approve(address(0), tokenId, prevOwnership.addr);
1082 
1083         // Underflow of the sender's balance is impossible because we check for
1084         // ownership above and the recipient's balance can't realistically overflow.
1085         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1086         unchecked {
1087             _addressData[from].balance -= 1;
1088             _addressData[to].balance += 1;
1089 
1090             _ownerships[tokenId].addr = to;
1091             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1092 
1093             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1094             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1095             uint256 nextTokenId = tokenId + 1;
1096             if (_ownerships[nextTokenId].addr == address(0)) {
1097                 // This will suffice for checking _exists(nextTokenId),
1098                 // as a burned slot cannot contain the zero address.
1099                 if (nextTokenId < _currentIndex) {
1100                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1101                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1102                 }
1103             }
1104         }
1105 
1106         emit Transfer(from, to, tokenId);
1107         _afterTokenTransfers(from, to, tokenId, 1);
1108     }
1109 
1110     /**
1111      * @dev Destroys `tokenId`.
1112      * The approval is cleared when the token is burned.
1113      *
1114      * Requirements:
1115      *
1116      * - `tokenId` must exist.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _burn(uint256 tokenId) internal virtual {
1121         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1122 
1123         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1124 
1125         // Clear approvals from the previous owner
1126         _approve(address(0), tokenId, prevOwnership.addr);
1127 
1128         // Underflow of the sender's balance is impossible because we check for
1129         // ownership above and the recipient's balance can't realistically overflow.
1130         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1131         unchecked {
1132             _addressData[prevOwnership.addr].balance -= 1;
1133             _addressData[prevOwnership.addr].numberBurned += 1;
1134 
1135             // Keep track of who burned the token, and the timestamp of burning.
1136             _ownerships[tokenId].addr = prevOwnership.addr;
1137             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1138             _ownerships[tokenId].burned = true;
1139 
1140             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1141             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1142             uint256 nextTokenId = tokenId + 1;
1143             if (_ownerships[nextTokenId].addr == address(0)) {
1144                 // This will suffice for checking _exists(nextTokenId),
1145                 // as a burned slot cannot contain the zero address.
1146                 if (nextTokenId < _currentIndex) {
1147                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1148                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1149                 }
1150             }
1151         }
1152 
1153         emit Transfer(prevOwnership.addr, address(0), tokenId);
1154         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1155 
1156         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1157         unchecked {
1158             _burnCounter++;
1159         }
1160     }
1161 
1162     /**
1163      * @dev Approve `to` to operate on `tokenId`
1164      *
1165      * Emits a {Approval} event.
1166      */
1167     function _approve(
1168         address to,
1169         uint256 tokenId,
1170         address owner
1171     ) private {
1172         _tokenApprovals[tokenId] = to;
1173         emit Approval(owner, to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1178      *
1179      * @param from address representing the previous owner of the given token ID
1180      * @param to target address that will receive the tokens
1181      * @param tokenId uint256 ID of the token to be transferred
1182      * @param _data bytes optional data to send along with the call
1183      * @return bool whether the call correctly returned the expected magic value
1184      */
1185     function _checkContractOnERC721Received(
1186         address from,
1187         address to,
1188         uint256 tokenId,
1189         bytes memory _data
1190     ) private returns (bool) {
1191         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1192             return retval == IERC721Receiver(to).onERC721Received.selector;
1193         } catch (bytes memory reason) {
1194             if (reason.length == 0) {
1195                 revert TransferToNonERC721ReceiverImplementer();
1196             } else {
1197                 assembly {
1198                     revert(add(32, reason), mload(reason))
1199                 }
1200             }
1201         }
1202     }
1203 
1204     /**
1205      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1206      * And also called before burning one token.
1207      *
1208      * startTokenId - the first token id to be transferred
1209      * quantity - the amount to be transferred
1210      *
1211      * Calling conditions:
1212      *
1213      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1214      * transferred to `to`.
1215      * - When `from` is zero, `tokenId` will be minted for `to`.
1216      * - When `to` is zero, `tokenId` will be burned by `from`.
1217      * - `from` and `to` are never both zero.
1218      */
1219     function _beforeTokenTransfers(
1220         address from,
1221         address to,
1222         uint256 startTokenId,
1223         uint256 quantity
1224     ) internal virtual {}
1225 
1226     /**
1227      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1228      * minting.
1229      * And also called after one token has been burned.
1230      *
1231      * startTokenId - the first token id to be transferred
1232      * quantity - the amount to be transferred
1233      *
1234      * Calling conditions:
1235      *
1236      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1237      * transferred to `to`.
1238      * - When `from` is zero, `tokenId` has been minted for `to`.
1239      * - When `to` is zero, `tokenId` has been burned by `from`.
1240      * - `from` and `to` are never both zero.
1241      */
1242     function _afterTokenTransfers(
1243 
1244         address from,
1245         address to,
1246         uint256 startTokenId,
1247         uint256 quantity
1248     ) internal virtual {}
1249 }
1250 
1251 
1252 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1253 
1254 
1255 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 /**
1260  * @dev Contract module which provides a basic access control mechanism, where
1261  * there is an account (an owner) that can be granted exclusive access to
1262  * specific functions.
1263  *
1264  * By default, the owner account will be the one that deploys the contract. This
1265  * can later be changed with {transferOwnership}.
1266  *
1267  * This module is used through inheritance. It will make available the modifier
1268  * `onlyOwner`, which can be applied to your functions to restrict their use to
1269  * the owner.
1270  */
1271 abstract contract Ownable is Context {
1272     address private _owner;
1273 
1274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1275 
1276     /**
1277      * @dev Initializes the contract setting the deployer as the initial owner.
1278      */
1279     constructor() {
1280         _transferOwnership(_msgSender());
1281     }
1282 
1283     /**
1284      * @dev Returns the address of the current owner.
1285      */
1286     function owner() public view virtual returns (address) {
1287         return _owner;
1288     }
1289 
1290     /**
1291      * @dev Throws if called by any account other than the owner.
1292      */
1293     modifier onlyOwner() {
1294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1295         _;
1296     }
1297 
1298     /**
1299      * @dev Leaves the contract without owner. It will not be possible to call
1300      * `onlyOwner` functions anymore. Can only be called by the current owner.
1301      *
1302      * NOTE: Renouncing ownership will leave the contract without an owner,
1303      * thereby removing any functionality that is only available to the owner.
1304      */
1305     function renounceOwnership() public virtual onlyOwner {
1306         _transferOwnership(address(0));
1307     }
1308 
1309     /**
1310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1311      * Can only be called by the current owner.
1312      */
1313     function transferOwnership(address newOwner) public virtual onlyOwner {
1314         require(newOwner != address(0), "Ownable: new owner is the zero address");
1315         _transferOwnership(newOwner);
1316     }
1317 
1318     /**
1319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1320      * Internal function without access restriction.
1321      */
1322 
1323     function _transferOwnership(address newOwner) internal virtual {
1324         address oldOwner = _owner;
1325         _owner = newOwner;
1326         emit OwnershipTransferred(oldOwner, newOwner);
1327     }
1328 }
1329 
1330 
1331 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.5.0
1332 
1333 
1334 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1335 
1336 pragma solidity ^0.8.0;
1337 
1338 /**
1339  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1340  *
1341  * These functions can be used to verify that a message was signed by the holder
1342  * of the private keys of a given address.
1343  */
1344 library ECDSA {
1345     enum RecoverError {
1346         NoError,
1347         InvalidSignature,
1348         InvalidSignatureLength,
1349         InvalidSignatureS,
1350         InvalidSignatureV
1351     }
1352 
1353     function _throwError(RecoverError error) private pure {
1354         if (error == RecoverError.NoError) {
1355             return; // no error: do nothing
1356         } else if (error == RecoverError.InvalidSignature) {
1357             revert("ECDSA: invalid signature");
1358         } else if (error == RecoverError.InvalidSignatureLength) {
1359             revert("ECDSA: invalid signature length");
1360         } else if (error == RecoverError.InvalidSignatureS) {
1361             revert("ECDSA: invalid signature 's' value");
1362         } else if (error == RecoverError.InvalidSignatureV) {
1363             revert("ECDSA: invalid signature 'v' value");
1364         }
1365     }
1366 
1367     /**
1368      * @dev Returns the address that signed a hashed message (`hash`) with
1369      * `signature` or error string. This address can then be used for verification purposes.
1370      *
1371      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1372      * this function rejects them by requiring the `s` value to be in the lower
1373      * half order, and the `v` value to be either 27 or 28.
1374      *
1375      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1376      * verification to be secure: it is possible to craft signatures that
1377      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1378      * this is by receiving a hash of the original message (which may otherwise
1379      * be too long), and then calling {toEthSignedMessageHash} on it.
1380      *
1381      * Documentation for signature generation:
1382      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1383      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1384      *
1385      * _Available since v4.3._
1386      */
1387     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1388         // Check the signature length
1389         // - case 65: r,s,v signature (standard)
1390         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1391         if (signature.length == 65) {
1392             bytes32 r;
1393             bytes32 s;
1394             uint8 v;
1395             // ecrecover takes the signature parameters, and the only way to get them
1396             // currently is to use assembly.
1397             assembly {
1398                 r := mload(add(signature, 0x20))
1399                 s := mload(add(signature, 0x40))
1400                 v := byte(0, mload(add(signature, 0x60)))
1401             }
1402             return tryRecover(hash, v, r, s);
1403         } else if (signature.length == 64) {
1404             bytes32 r;
1405             bytes32 vs;
1406             // ecrecover takes the signature parameters, and the only way to get them
1407             // currently is to use assembly.
1408             assembly {
1409                 r := mload(add(signature, 0x20))
1410                 vs := mload(add(signature, 0x40))
1411             }
1412             return tryRecover(hash, r, vs);
1413         } else {
1414             return (address(0), RecoverError.InvalidSignatureLength);
1415         }
1416     }
1417 
1418     /**
1419      * @dev Returns the address that signed a hashed message (`hash`) with
1420      * `signature`. This address can then be used for verification purposes.
1421      *
1422      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1423      * this function rejects them by requiring the `s` value to be in the lower
1424      * half order, and the `v` value to be either 27 or 28.
1425      *
1426      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1427      * verification to be secure: it is possible to craft signatures that
1428      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1429      * this is by receiving a hash of the original message (which may otherwise
1430      * be too long), and then calling {toEthSignedMessageHash} on it.
1431      */
1432     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1433         (address recovered, RecoverError error) = tryRecover(hash, signature);
1434         _throwError(error);
1435         return recovered;
1436     }
1437 
1438     /**
1439      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1440      *
1441      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1442      *
1443      * _Available since v4.3._
1444      */
1445     function tryRecover(
1446         bytes32 hash,
1447         bytes32 r,
1448         bytes32 vs
1449     ) internal pure returns (address, RecoverError) {
1450         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1451         uint8 v = uint8((uint256(vs) >> 255) + 27);
1452         return tryRecover(hash, v, r, s);
1453     }
1454 
1455     /**
1456      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1457      *
1458      * _Available since v4.2._
1459      */
1460     function recover(
1461         bytes32 hash,
1462         bytes32 r,
1463         bytes32 vs
1464     ) internal pure returns (address) {
1465         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1466         _throwError(error);
1467         return recovered;
1468     }
1469 
1470     /**
1471      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1472      * `r` and `s` signature fields separately.
1473      *
1474      * _Available since v4.3._
1475      */
1476     function tryRecover(
1477         bytes32 hash,
1478         uint8 v,
1479         bytes32 r,
1480         bytes32 s
1481     ) internal pure returns (address, RecoverError) {
1482         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1483         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1484         // the valid range for s in (301): 0 < s < secp256k1n ├╖ 2 + 1, and for v in (302): v Γêê {27, 28}. Most
1485         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1486         //
1487         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1488         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1489         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1490         // these malleable signatures as well.
1491         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1492             return (address(0), RecoverError.InvalidSignatureS);
1493         }
1494         if (v != 27 && v != 28) {
1495             return (address(0), RecoverError.InvalidSignatureV);
1496         }
1497 
1498         // If the signature is valid (and not malleable), return the signer address
1499         address signer = ecrecover(hash, v, r, s);
1500         if (signer == address(0)) {
1501             return (address(0), RecoverError.InvalidSignature);
1502         }
1503 
1504         return (signer, RecoverError.NoError);
1505     }
1506 
1507     /**
1508      * @dev Overload of {ECDSA-recover} that receives the `v`,
1509      * `r` and `s` signature fields separately.
1510      */
1511     function recover(
1512         bytes32 hash,
1513         uint8 v,
1514         bytes32 r,
1515         bytes32 s
1516     ) internal pure returns (address) {
1517         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1518         _throwError(error);
1519         return recovered;
1520     }
1521 
1522     /**
1523      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1524      * produces hash corresponding to the one signed with the
1525      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1526      * JSON-RPC method as part of EIP-191.
1527      *
1528      * See {recover}.
1529      */
1530     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1531         // 32 is the length in bytes of hash,
1532         // enforced by the type signature above
1533         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1534     }
1535 
1536     /**
1537      * @dev Returns an Ethereum Signed Message, created from `s`. This
1538      * produces hash corresponding to the one signed with the
1539      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1540      * JSON-RPC method as part of EIP-191.
1541      *
1542      * See {recover}.
1543      */
1544     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1545         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1546     }
1547 
1548     /**
1549      * @dev Returns an Ethereum Signed Typed Data, created from a
1550      * `domainSeparator` and a `structHash`. This produces hash corresponding
1551      * to the one signed with the
1552      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1553      * JSON-RPC method as part of EIP-712.
1554      *
1555 
1556      * See {recover}.
1557      */
1558     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1559         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1560     }
1561 }
1562 
1563 
1564 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1565 
1566 
1567 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1568 
1569 pragma solidity ^0.8.0;
1570 
1571 /**
1572  * @dev These functions deal with verification of Merkle Trees proofs.
1573  *
1574  * The proofs can be generated using the JavaScript library
1575  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1576  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1577  *
1578  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1579  */
1580 library MerkleProof {
1581     /**
1582      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1583      * defined by `root`. For this, a `proof` must be provided, containing
1584      * sibling hashes on the branch from the leaf to the root of the tree. Each
1585      * pair of leaves and each pair of pre-images are assumed to be sorted.
1586      */
1587     function verify(
1588         bytes32[] memory proof,
1589         bytes32 root,
1590         bytes32 leaf
1591     ) internal pure returns (bool) {
1592         return processProof(proof, leaf) == root;
1593     }
1594 
1595     /**
1596      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1597      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1598      * hash matches the root of the tree. When processing the proof, the pairs
1599      * of leafs & pre-images are assumed to be sorted.
1600      *
1601      * _Available since v4.4._
1602      */
1603     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1604         bytes32 computedHash = leaf;
1605         for (uint256 i = 0; i < proof.length; i++) {
1606             bytes32 proofElement = proof[i];
1607             if (computedHash <= proofElement) {
1608                 // Hash(current computed hash + current element of the proof)
1609                 computedHash = _efficientHash(computedHash, proofElement);
1610             } else {
1611                 // Hash(current element of the proof + current computed hash)
1612                 computedHash = _efficientHash(proofElement, computedHash);
1613             }
1614         }
1615         return computedHash;
1616     }
1617 
1618     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1619         assembly {
1620 
1621             mstore(0x00, a)
1622             mstore(0x20, b)
1623             value := keccak256(0x00, 0x40)
1624         }
1625     }
1626 }
1627 
1628 
1629 // File contracts/contract.sol
1630 
1631 
1632 
1633 pragma solidity ^0.8.12;
1634 contract MOE is ERC721A, Ownable {
1635     using Strings for uint256;
1636 
1637     enum MINT_STAGES { STOPPED, PRESALE, SALE }
1638 
1639     uint256 public maxTokensPresale = 4;
1640     uint256 public maxTokensPublic = 10;
1641 
1642     uint256 public tokenPricePresale = 0.075 ether;
1643     uint256 public tokenPricePublicSale = 0.075 ether;
1644 
1645     string public tokenBaseURI = "";
1646     string public unrevealedURI = "ipfs://QmYXEsJpP7SGZpSZnUw7cVD84U1MHf4V21bgxTS7jUwjWQ/";
1647     string public URIExtension = ".json";
1648 
1649     MINT_STAGES public mintStage = MINT_STAGES.STOPPED; // 0 stopped 1 presale 2 sale
1650 
1651     uint256 public constant TEAM_LIMIT = 444;
1652     uint256 public teamMintedAmount = 0;
1653     uint256 public constant BUY_TOTAL_AMOUNT = 4444;
1654     uint256 public boughtAmount = 0;
1655 
1656     bytes32 public whitelistRoot;
1657     mapping(address => uint256) public purchased;
1658 
1659     constructor() ERC721A("WaifuMOE", "MOE") {
1660     }
1661 
1662     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
1663         return 1;
1664     }
1665 
1666     function hasPresaleStarted() private view returns (bool) {
1667         return mintStage == MINT_STAGES.PRESALE;
1668     }
1669 
1670     function hasPublicSaleStarted() private view returns (bool) {
1671         return mintStage == MINT_STAGES.SALE;
1672     }
1673 
1674     function tokenPrice() public view returns (uint256) {
1675         if (mintStage == MINT_STAGES.SALE) {
1676             return tokenPricePublicSale;
1677         } else {
1678             return tokenPricePresale;
1679         }
1680     }
1681 
1682     function min(uint256 a, uint256 b) public pure returns (uint256) {
1683         return a > b ? b : a;
1684     }
1685 
1686     function safeSubtract(uint256 a, uint256 b) public pure returns (uint256) {
1687         if (a < b) {
1688             return 0;
1689         }
1690         return a - b;
1691     }
1692 
1693     function getMaxTokensAllowed(address target, bytes32[] memory proof) public view returns (uint256) {
1694         uint256 tokensAllowed = 0;
1695         if (hasPublicSaleStarted()) {
1696             if(verify(target, proof)) {
1697                 tokensAllowed = safeSubtract(maxTokensPresale + maxTokensPublic, purchased[target]);
1698             } else {
1699                 tokensAllowed = safeSubtract(maxTokensPublic, purchased[target]);
1700             }
1701         } else if (hasPresaleStarted() && verify(target, proof)) {
1702             tokensAllowed = safeSubtract(maxTokensPresale, purchased[target]);
1703         }
1704 
1705         uint256 publicSaleTokensLeft = safeSubtract(BUY_TOTAL_AMOUNT, boughtAmount);
1706         tokensAllowed = min(tokensAllowed, publicSaleTokensLeft);
1707 
1708         return tokensAllowed;
1709     }
1710 
1711 
1712     function getContractInfo(address target, bytes32[] memory proof) external view returns (
1713         bool _hasPresaleStarted,
1714         bool _hasPublicSaleStarted,
1715         uint256 _maxTokensAllowed,
1716         uint256 _tokenPrice,
1717         uint256 _boughtAmount,
1718         uint256 _purchasedAmount,
1719         uint256 _presaleTotalLimit,
1720         bytes32 _whitelistRoot
1721     ) {
1722         _hasPresaleStarted = hasPresaleStarted();
1723         _hasPublicSaleStarted = hasPublicSaleStarted();
1724         _maxTokensAllowed = getMaxTokensAllowed(target, proof);
1725         _tokenPrice = tokenPrice();
1726         _boughtAmount = boughtAmount;
1727         _presaleTotalLimit = maxTokensPresale;
1728         _whitelistRoot = whitelistRoot;
1729         _purchasedAmount = purchased[target];
1730     }
1731 
1732     function setWhitelistRoot(bytes32 _whitelistRoot) public onlyOwner {
1733         whitelistRoot = _whitelistRoot;
1734     }
1735 
1736     function setTokenPricePresale(uint256 val) external onlyOwner {
1737         tokenPricePresale = val;
1738     }
1739 
1740     function setTokenPricePublicSale(uint256 val) external onlyOwner {
1741         tokenPricePublicSale = val;
1742     }
1743 
1744     function verify(address account, bytes32[] memory proof) public view returns (bool)
1745     {
1746         bytes32 leaf = keccak256(abi.encodePacked(account));
1747         return MerkleProof.verify(proof, whitelistRoot, leaf);
1748     }
1749 
1750 
1751     function setMaxTokensPresale(uint256 val) external onlyOwner {
1752         maxTokensPresale = val;
1753     }
1754 
1755     function setMaxTokensPublic(uint256 val) external onlyOwner{
1756         maxTokensPublic = val;
1757     }
1758 
1759     function stopSale() external onlyOwner {
1760         mintStage = MINT_STAGES.STOPPED;
1761     }
1762 
1763     function startPresale() external onlyOwner {
1764         mintStage = MINT_STAGES.PRESALE;
1765     }
1766 
1767     function startPublicSale() external onlyOwner {
1768         mintStage = MINT_STAGES.SALE;
1769     }
1770 
1771     function mintTeam(uint256 amount, address to) external onlyOwner {
1772         require(teamMintedAmount + amount <= TEAM_LIMIT, "Minting more than the team limit");
1773         _safeMint(to, amount);
1774         teamMintedAmount += amount;
1775         boughtAmount += amount;
1776     }
1777 
1778     function mint(uint256 amount, bytes32[] memory proof) external payable {
1779         require(msg.value >= tokenPrice() * amount, "Incorrect ETH sent");
1780         require(amount <= getMaxTokensAllowed(msg.sender, proof), "Cannot mint more than the max allowed tokens");
1781 
1782         _safeMint(msg.sender, amount);
1783         purchased[msg.sender] += amount;
1784 
1785         boughtAmount += amount;
1786     }
1787 
1788     function _baseURI() internal view override(ERC721A) returns (string memory) {
1789         return tokenBaseURI;
1790     }
1791 
1792     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
1793         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1794         string memory baseURI = _baseURI(); 
1795         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), URIExtension)) : unrevealedURI;
1796     }
1797    
1798     function setBaseURI(string calldata URI) external onlyOwner {
1799         tokenBaseURI = URI;
1800     }
1801 
1802     function setUnrevealedURI(string calldata URI) external onlyOwner {
1803         unrevealedURI = URI;
1804     }
1805 
1806     function setURIExtension(string calldata URI) external onlyOwner {
1807         URIExtension = URI;
1808     }
1809 
1810     function withdraw() external onlyOwner {
1811         require(payable(msg.sender).send(address(this).balance));
1812     }
1813 
1814 }