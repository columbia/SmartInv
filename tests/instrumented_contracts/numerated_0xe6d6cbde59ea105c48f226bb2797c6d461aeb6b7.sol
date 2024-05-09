1 // Sources flattened with hardhat v2.9.1 https://hardhat.org
2 
3 // File contracts/oz/contracts/utils/introspection/IERC165.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File contracts/oz/contracts/token/ERC721/IERC721.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File contracts/oz/contracts/token/ERC721/IERC721Receiver.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File contracts/oz/contracts/token/ERC721/extensions/IERC721Metadata.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File contracts/oz/contracts/token/ERC721/extensions/IERC721Enumerable.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
246  * @dev See https://eips.ethereum.org/EIPS/eip-721
247  */
248 interface IERC721Enumerable is IERC721 {
249     /**
250      * @dev Returns the total amount of tokens stored by the contract.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
256      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
257      */
258     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
259 
260     /**
261      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
262      * Use along with {totalSupply} to enumerate all tokens.
263      */
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 
268 // File contracts/oz/contracts/utils/Address.sol
269 
270 
271 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
272 
273 pragma solidity ^0.8.1;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      *
296      * [IMPORTANT]
297      * ====
298      * You shouldn't rely on `isContract` to protect against flash loan attacks!
299      *
300      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
301      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
302      * constructor.
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies on extcodesize/address.code.length, which returns 0
307         // for contracts in construction, since the code is only stored at the end
308         // of the constructor execution.
309 
310         return account.code.length > 0;
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         (bool success, ) = recipient.call{value: amount}("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain `call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393      * with `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         require(isContract(target), "Address: call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.call{value: value}(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
417         return functionStaticCall(target, data, "Address: low-level static call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
466      * revert reason using the provided one.
467      *
468      * _Available since v4.3._
469      */
470     function verifyCallResult(
471         bool success,
472         bytes memory returndata,
473         string memory errorMessage
474     ) internal pure returns (bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 
494 // File contracts/oz/contracts/utils/Context.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Provides information about the current execution context, including the
503  * sender of the transaction and its data. While these are generally available
504  * via msg.sender and msg.data, they should not be accessed in such a direct
505  * manner, since when dealing with meta-transactions the account sending and
506  * paying for execution may not be the actual sender (as far as an application
507  * is concerned).
508  *
509  * This contract is only required for intermediate, library-like contracts.
510  */
511 abstract contract Context {
512     function _msgSender() internal view virtual returns (address) {
513         return msg.sender;
514     }
515 
516     function _msgData() internal view virtual returns (bytes calldata) {
517         return msg.data;
518     }
519 }
520 
521 
522 // File contracts/oz/contracts/utils/Strings.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev String operations.
531  */
532 library Strings {
533     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
537      */
538     function toString(uint256 value) internal pure returns (string memory) {
539         // Inspired by OraclizeAPI's implementation - MIT licence
540         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
541 
542         if (value == 0) {
543             return "0";
544         }
545         uint256 temp = value;
546         uint256 digits;
547         while (temp != 0) {
548             digits++;
549             temp /= 10;
550         }
551         bytes memory buffer = new bytes(digits);
552         while (value != 0) {
553             digits -= 1;
554             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
555             value /= 10;
556         }
557         return string(buffer);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
562      */
563     function toHexString(uint256 value) internal pure returns (string memory) {
564         if (value == 0) {
565             return "0x00";
566         }
567         uint256 temp = value;
568         uint256 length = 0;
569         while (temp != 0) {
570             length++;
571             temp >>= 8;
572         }
573         return toHexString(value, length);
574     }
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
578      */
579     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
580         bytes memory buffer = new bytes(2 * length + 2);
581         buffer[0] = "0";
582         buffer[1] = "x";
583         for (uint256 i = 2 * length + 1; i > 1; --i) {
584             buffer[i] = _HEX_SYMBOLS[value & 0xf];
585             value >>= 4;
586         }
587         require(value == 0, "Strings: hex length insufficient");
588         return string(buffer);
589     }
590 }
591 
592 
593 // File contracts/oz/contracts/utils/introspection/ERC165.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 /**
601  * @dev Implementation of the {IERC165} interface.
602  *
603  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
604  * for the additional interface id that will be supported. For example:
605  *
606  * ```solidity
607  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
609  * }
610  * ```
611  *
612  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
613  */
614 abstract contract ERC165 is IERC165 {
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619         return interfaceId == type(IERC165).interfaceId;
620     }
621 }
622 
623 
624 // File contracts/erc721a.sol
625 
626 
627 // Creator: Chiru Labs
628 
629 pragma solidity ^0.8.4;
630 
631 
632 
633 
634 
635 
636 
637 
638 error ApprovalCallerNotOwnerNorApproved();
639 error ApprovalQueryForNonexistentToken();
640 error ApproveToCaller();
641 error ApprovalToCurrentOwner();
642 error BalanceQueryForZeroAddress();
643 error MintedQueryForZeroAddress();
644 error BurnedQueryForZeroAddress();
645 error AuxQueryForZeroAddress();
646 error MintToZeroAddress();
647 error MintZeroQuantity();
648 error OwnerIndexOutOfBounds();
649 error OwnerQueryForNonexistentToken();
650 error TokenIndexOutOfBounds();
651 error TransferCallerNotOwnerNorApproved();
652 error TransferFromIncorrectOwner();
653 error TransferToNonERC721ReceiverImplementer();
654 error TransferToZeroAddress();
655 error URIQueryForNonexistentToken();
656 
657 /**
658  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
659  * the Metadata extension. Built to optimize for lower gas during batch mints.
660  *
661  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
662  *
663  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
664  *
665  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
666  */
667 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
668     using Address for address;
669     using Strings for uint256;
670 
671     // Compiler will pack this into a single 256bit word.
672     struct TokenOwnership {
673         // The address of the owner.
674         address addr;
675         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
676         uint64 startTimestamp;
677         // Whether the token has been burned.
678         bool burned;
679     }
680 
681     // Compiler will pack this into a single 256bit word.
682     struct AddressData {
683         // Realistically, 2**64-1 is more than enough.
684         uint64 balance;
685         // Keeps track of mint count with minimal overhead for tokenomics.
686         uint64 numberMinted;
687         // Keeps track of burn count with minimal overhead for tokenomics.
688         uint64 numberBurned;
689         // For miscellaneous variable(s) pertaining to the address
690         // (e.g. number of whitelist mint slots used).
691         // If there are multiple variables, please pack them into a uint64.
692         uint64 aux;
693     }
694 
695     // The tokenId of the next token to be minted.
696     uint256 internal _currentIndex;
697 
698     // The number of tokens burned.
699     uint256 internal _burnCounter;
700 
701     // Token name
702     string private _name;
703 
704     // Token symbol
705     string private _symbol;
706 
707     // Mapping from token ID to ownership details
708     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
709     mapping(uint256 => TokenOwnership) internal _ownerships;
710 
711     // Mapping owner address to address data
712     mapping(address => AddressData) private _addressData;
713 
714     // Mapping from token ID to approved address
715     mapping(uint256 => address) private _tokenApprovals;
716 
717     // Mapping from owner to operator approvals
718     mapping(address => mapping(address => bool)) private _operatorApprovals;
719 
720     constructor(string memory name_, string memory symbol_) {
721         _name = name_;
722         _symbol = symbol_;
723         _currentIndex = _startTokenId();
724     }
725 
726     /**
727      * To change the starting tokenId, please override this function.
728      */
729     function _startTokenId() internal view virtual returns (uint256) {
730         return 0;
731     }
732 
733     /**
734      * @dev See {IERC721Enumerable-totalSupply}.
735      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
736      */
737     function totalSupply() public view returns (uint256) {
738         // Counter underflow is impossible as _burnCounter cannot be incremented
739         // more than _currentIndex - _startTokenId() times
740         unchecked {
741             return _currentIndex - _burnCounter - _startTokenId();
742         }
743     }
744 
745     /**
746      * Returns the total amount of tokens minted in the contract.
747      */
748     function _totalMinted() internal view returns (uint256) {
749         // Counter underflow is impossible as _currentIndex does not decrement,
750         // and it is initialized to _startTokenId()
751         unchecked {
752             return _currentIndex - _startTokenId();
753         }
754     }
755 
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId)
760         public
761         view
762         virtual
763         override(ERC165, IERC165)
764         returns (bool)
765     {
766         return
767             interfaceId == type(IERC721).interfaceId ||
768             interfaceId == type(IERC721Metadata).interfaceId ||
769             super.supportsInterface(interfaceId);
770     }
771 
772     /**
773      * @dev See {IERC721-balanceOf}.
774      */
775     function balanceOf(address owner) public view override returns (uint256) {
776         if (owner == address(0)) revert BalanceQueryForZeroAddress();
777         return uint256(_addressData[owner].balance);
778     }
779 
780     /**
781      * Returns the number of tokens minted by `owner`.
782      */
783     function _numberMinted(address owner) internal view returns (uint256) {
784         if (owner == address(0)) revert MintedQueryForZeroAddress();
785         return uint256(_addressData[owner].numberMinted);
786     }
787 
788     /**
789      * Returns the number of tokens burned by or on behalf of `owner`.
790      */
791     function _numberBurned(address owner) internal view returns (uint256) {
792         if (owner == address(0)) revert BurnedQueryForZeroAddress();
793         return uint256(_addressData[owner].numberBurned);
794     }
795 
796     /**
797      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
798      */
799     function _getAux(address owner) internal view returns (uint64) {
800         if (owner == address(0)) revert AuxQueryForZeroAddress();
801         return _addressData[owner].aux;
802     }
803 
804     /**
805      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
806      * If there are multiple variables, please pack them into a uint64.
807      */
808     function _setAux(address owner, uint64 aux) internal {
809         if (owner == address(0)) revert AuxQueryForZeroAddress();
810         _addressData[owner].aux = aux;
811     }
812 
813     /**
814      * Gas spent here starts off proportional to the maximum mint batch size.
815      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
816      */
817     function ownershipOf(uint256 tokenId)
818         internal
819         view
820         returns (TokenOwnership memory)
821     {
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
872     function tokenURI(uint256 tokenId)
873         public
874         view
875         virtual
876         override
877         returns (string memory)
878     {
879         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
880 
881         string memory baseURI = _baseURI();
882         return
883             bytes(baseURI).length != 0
884                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
885                 : "";
886     }
887 
888     /**
889      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
890      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
891      * by default, can be overriden in child contracts.
892      */
893     function _baseURI() internal view virtual returns (string memory) {
894         return "";
895     }
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public override {
901         address owner = ERC721A.ownerOf(tokenId);
902         if (to == owner) revert ApprovalToCurrentOwner();
903 
904         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
905             revert ApprovalCallerNotOwnerNorApproved();
906         }
907 
908         _approve(to, tokenId, owner);
909     }
910 
911     /**
912      * @dev See {IERC721-getApproved}.
913      */
914     function getApproved(uint256 tokenId)
915         public
916         view
917         override
918         returns (address)
919     {
920         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved)
929         public
930         virtual
931         override
932     {
933         if (operator == _msgSender()) revert ApproveToCaller();
934 
935         _operatorApprovals[_msgSender()][operator] = approved;
936         emit ApprovalForAll(_msgSender(), operator, approved);
937     }
938 
939     /**
940      * @dev See {IERC721-isApprovedForAll}.
941      */
942     function isApprovedForAll(address owner, address operator)
943         public
944         view
945         virtual
946         override
947         returns (bool)
948     {
949         return _operatorApprovals[owner][operator];
950     }
951 
952     /**
953      * @dev See {IERC721-transferFrom}.
954      */
955     function transferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) public virtual override {
960         _transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         safeTransferFrom(from, to, tokenId, "");
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) public virtual override {
983         _transfer(from, to, tokenId);
984         if (
985             to.isContract() &&
986             !_checkContractOnERC721Received(from, to, tokenId, _data)
987         ) {
988             revert TransferToNonERC721ReceiverImplementer();
989         }
990     }
991 
992     /**
993      * @dev Returns whether `tokenId` exists.
994      *
995      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
996      *
997      * Tokens start existing when they are minted (`_mint`),
998      */
999     function _exists(uint256 tokenId) internal view returns (bool) {
1000         return
1001             _startTokenId() <= tokenId &&
1002             tokenId < _currentIndex &&
1003             !_ownerships[tokenId].burned;
1004     }
1005 
1006     function _safeMint(address to, uint256 quantity) internal {
1007         _safeMint(to, quantity, "");
1008     }
1009 
1010     /**
1011      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1016      * - `quantity` must be greater than 0.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _safeMint(
1021         address to,
1022         uint256 quantity,
1023         bytes memory _data
1024     ) internal {
1025         _mint(to, quantity, _data, true);
1026     }
1027 
1028     /**
1029      * @dev Mints `quantity` tokens and transfers them to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `to` cannot be the zero address.
1034      * - `quantity` must be greater than 0.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(
1039         address to,
1040         uint256 quantity,
1041         bytes memory _data,
1042         bool safe
1043     ) internal {
1044         uint256 startTokenId = _currentIndex;
1045         if (to == address(0)) revert MintToZeroAddress();
1046         if (quantity == 0) revert MintZeroQuantity();
1047 
1048         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1049 
1050         // Overflows are incredibly unrealistic.
1051         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1052         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1053         unchecked {
1054             _addressData[to].balance += uint64(quantity);
1055             _addressData[to].numberMinted += uint64(quantity);
1056 
1057             _ownerships[startTokenId].addr = to;
1058             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1059 
1060             uint256 updatedIndex = startTokenId;
1061             uint256 end = updatedIndex + quantity;
1062 
1063             if (safe && to.isContract()) {
1064                 do {
1065                     emit Transfer(address(0), to, updatedIndex);
1066                     if (
1067                         !_checkContractOnERC721Received(
1068                             address(0),
1069                             to,
1070                             updatedIndex++,
1071                             _data
1072                         )
1073                     ) {
1074                         revert TransferToNonERC721ReceiverImplementer();
1075                     }
1076                 } while (updatedIndex != end);
1077                 // Reentrancy protection
1078                 if (_currentIndex != startTokenId) revert();
1079             } else {
1080                 do {
1081                     emit Transfer(address(0), to, updatedIndex++);
1082                 } while (updatedIndex != end);
1083             }
1084             _currentIndex = updatedIndex;
1085         }
1086         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1087     }
1088 
1089     /**
1090      * @dev Transfers `tokenId` from `from` to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - `tokenId` token must be owned by `from`.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _transfer(
1100         address from,
1101         address to,
1102         uint256 tokenId
1103     ) private {
1104         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1105 
1106         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1107             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1108             getApproved(tokenId) == _msgSender());
1109 
1110         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1111         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1112         if (to == address(0)) revert TransferToZeroAddress();
1113 
1114         _beforeTokenTransfers(from, to, tokenId, 1);
1115 
1116         // Clear approvals from the previous owner
1117         _approve(address(0), tokenId, prevOwnership.addr);
1118 
1119         // Underflow of the sender's balance is impossible because we check for
1120         // ownership above and the recipient's balance can't realistically overflow.
1121         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1122         unchecked {
1123             _addressData[from].balance -= 1;
1124             _addressData[to].balance += 1;
1125 
1126             _ownerships[tokenId].addr = to;
1127             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1128 
1129             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1130             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1131             uint256 nextTokenId = tokenId + 1;
1132             if (_ownerships[nextTokenId].addr == address(0)) {
1133                 // This will suffice for checking _exists(nextTokenId),
1134                 // as a burned slot cannot contain the zero address.
1135                 if (nextTokenId < _currentIndex) {
1136                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1137                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1138                         .startTimestamp;
1139                 }
1140             }
1141         }
1142 
1143         emit Transfer(from, to, tokenId);
1144         _afterTokenTransfers(from, to, tokenId, 1);
1145     }
1146 
1147     /**
1148      * @dev Destroys `tokenId`.
1149      * The approval is cleared when the token is burned.
1150      *
1151      * Requirements:
1152      *
1153      * - `tokenId` must exist.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _burn(uint256 tokenId) internal virtual {
1158         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1159 
1160         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1161 
1162         // Clear approvals from the previous owner
1163         _approve(address(0), tokenId, prevOwnership.addr);
1164 
1165         // Underflow of the sender's balance is impossible because we check for
1166         // ownership above and the recipient's balance can't realistically overflow.
1167         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1168         unchecked {
1169             _addressData[prevOwnership.addr].balance -= 1;
1170             _addressData[prevOwnership.addr].numberBurned += 1;
1171 
1172             // Keep track of who burned the token, and the timestamp of burning.
1173             _ownerships[tokenId].addr = prevOwnership.addr;
1174             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1175             _ownerships[tokenId].burned = true;
1176 
1177             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1178             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1179             uint256 nextTokenId = tokenId + 1;
1180             if (_ownerships[nextTokenId].addr == address(0)) {
1181                 // This will suffice for checking _exists(nextTokenId),
1182                 // as a burned slot cannot contain the zero address.
1183                 if (nextTokenId < _currentIndex) {
1184                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1185                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1186                         .startTimestamp;
1187                 }
1188             }
1189         }
1190 
1191         emit Transfer(prevOwnership.addr, address(0), tokenId);
1192         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1193 
1194         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1195         unchecked {
1196             _burnCounter++;
1197         }
1198     }
1199 
1200     /**
1201      * @dev Approve `to` to operate on `tokenId`
1202      *
1203      * Emits a {Approval} event.
1204      */
1205     function _approve(
1206         address to,
1207         uint256 tokenId,
1208         address owner
1209     ) private {
1210         _tokenApprovals[tokenId] = to;
1211         emit Approval(owner, to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1216      *
1217      * @param from address representing the previous owner of the given token ID
1218      * @param to target address that will receive the tokens
1219      * @param tokenId uint256 ID of the token to be transferred
1220      * @param _data bytes optional data to send along with the call
1221      * @return bool whether the call correctly returned the expected magic value
1222      */
1223     function _checkContractOnERC721Received(
1224         address from,
1225         address to,
1226         uint256 tokenId,
1227         bytes memory _data
1228     ) private returns (bool) {
1229         try
1230             IERC721Receiver(to).onERC721Received(
1231                 _msgSender(),
1232                 from,
1233                 tokenId,
1234                 _data
1235             )
1236         returns (bytes4 retval) {
1237             return retval == IERC721Receiver(to).onERC721Received.selector;
1238         } catch (bytes memory reason) {
1239             if (reason.length == 0) {
1240                 revert TransferToNonERC721ReceiverImplementer();
1241             } else {
1242                 assembly {
1243                     revert(add(32, reason), mload(reason))
1244                 }
1245             }
1246         }
1247     }
1248 
1249     /**
1250      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1251      * And also called before burning one token.
1252      *
1253      * startTokenId - the first token id to be transferred
1254      * quantity - the amount to be transferred
1255      *
1256      * Calling conditions:
1257      *
1258      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1259      * transferred to `to`.
1260      * - When `from` is zero, `tokenId` will be minted for `to`.
1261      * - When `to` is zero, `tokenId` will be burned by `from`.
1262      * - `from` and `to` are never both zero.
1263      */
1264     function _beforeTokenTransfers(
1265         address from,
1266         address to,
1267         uint256 startTokenId,
1268         uint256 quantity
1269     ) internal virtual {}
1270 
1271     /**
1272      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1273      * minting.
1274      * And also called after one token has been burned.
1275      *
1276      * startTokenId - the first token id to be transferred
1277      * quantity - the amount to be transferred
1278      *
1279      * Calling conditions:
1280      *
1281      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1282      * transferred to `to`.
1283      * - When `from` is zero, `tokenId` has been minted for `to`.
1284      * - When `to` is zero, `tokenId` has been burned by `from`.
1285      * - `from` and `to` are never both zero.
1286      */
1287     function _afterTokenTransfers(
1288         address from,
1289         address to,
1290         uint256 startTokenId,
1291         uint256 quantity
1292     ) internal virtual {}
1293 }
1294 
1295 
1296 // File contracts/oz/contracts/access/Ownable.sol
1297 
1298 
1299 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1300 
1301 pragma solidity ^0.8.0;
1302 
1303 /**
1304  * @dev Contract module which provides a basic access control mechanism, where
1305  * there is an account (an owner) that can be granted exclusive access to
1306  * specific functions.
1307  *
1308  * By default, the owner account will be the one that deploys the contract. This
1309  * can later be changed with {transferOwnership}.
1310  *
1311  * This module is used through inheritance. It will make available the modifier
1312  * `onlyOwner`, which can be applied to your functions to restrict their use to
1313  * the owner.
1314  */
1315 abstract contract Ownable is Context {
1316     address private _owner;
1317 
1318     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1319 
1320     /**
1321      * @dev Initializes the contract setting the deployer as the initial owner.
1322      */
1323     constructor() {
1324         _transferOwnership(_msgSender());
1325     }
1326 
1327     /**
1328      * @dev Returns the address of the current owner.
1329      */
1330     function owner() public view virtual returns (address) {
1331         return _owner;
1332     }
1333 
1334     /**
1335      * @dev Throws if called by any account other than the owner.
1336      */
1337     modifier onlyOwner() {
1338         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1339         _;
1340     }
1341 
1342     /**
1343      * @dev Leaves the contract without owner. It will not be possible to call
1344      * `onlyOwner` functions anymore. Can only be called by the current owner.
1345      *
1346      * NOTE: Renouncing ownership will leave the contract without an owner,
1347      * thereby removing any functionality that is only available to the owner.
1348      */
1349     function renounceOwnership() public virtual onlyOwner {
1350         _transferOwnership(address(0));
1351     }
1352 
1353     /**
1354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1355      * Can only be called by the current owner.
1356      */
1357     function transferOwnership(address newOwner) public virtual onlyOwner {
1358         require(newOwner != address(0), "Ownable: new owner is the zero address");
1359         _transferOwnership(newOwner);
1360     }
1361 
1362     /**
1363      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1364      * Internal function without access restriction.
1365      */
1366     function _transferOwnership(address newOwner) internal virtual {
1367         address oldOwner = _owner;
1368         _owner = newOwner;
1369         emit OwnershipTransferred(oldOwner, newOwner);
1370     }
1371 }
1372 
1373 
1374 // File contracts/oz/contracts/utils/math/SafeMath.sol
1375 
1376 
1377 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 // CAUTION
1382 // This version of SafeMath should only be used with Solidity 0.8 or later,
1383 // because it relies on the compiler's built in overflow checks.
1384 
1385 /**
1386  * @dev Wrappers over Solidity's arithmetic operations.
1387  *
1388  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1389  * now has built in overflow checking.
1390  */
1391 library SafeMath {
1392     /**
1393      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1394      *
1395      * _Available since v3.4._
1396      */
1397     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1398         unchecked {
1399             uint256 c = a + b;
1400             if (c < a) return (false, 0);
1401             return (true, c);
1402         }
1403     }
1404 
1405     /**
1406      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1407      *
1408      * _Available since v3.4._
1409      */
1410     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1411         unchecked {
1412             if (b > a) return (false, 0);
1413             return (true, a - b);
1414         }
1415     }
1416 
1417     /**
1418      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1419      *
1420      * _Available since v3.4._
1421      */
1422     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1423         unchecked {
1424             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1425             // benefit is lost if 'b' is also tested.
1426             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1427             if (a == 0) return (true, 0);
1428             uint256 c = a * b;
1429             if (c / a != b) return (false, 0);
1430             return (true, c);
1431         }
1432     }
1433 
1434     /**
1435      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1436      *
1437      * _Available since v3.4._
1438      */
1439     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1440         unchecked {
1441             if (b == 0) return (false, 0);
1442             return (true, a / b);
1443         }
1444     }
1445 
1446     /**
1447      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1448      *
1449      * _Available since v3.4._
1450      */
1451     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1452         unchecked {
1453             if (b == 0) return (false, 0);
1454             return (true, a % b);
1455         }
1456     }
1457 
1458     /**
1459      * @dev Returns the addition of two unsigned integers, reverting on
1460      * overflow.
1461      *
1462      * Counterpart to Solidity's `+` operator.
1463      *
1464      * Requirements:
1465      *
1466      * - Addition cannot overflow.
1467      */
1468     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1469         return a + b;
1470     }
1471 
1472     /**
1473      * @dev Returns the subtraction of two unsigned integers, reverting on
1474      * overflow (when the result is negative).
1475      *
1476      * Counterpart to Solidity's `-` operator.
1477      *
1478      * Requirements:
1479      *
1480      * - Subtraction cannot overflow.
1481      */
1482     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1483         return a - b;
1484     }
1485 
1486     /**
1487      * @dev Returns the multiplication of two unsigned integers, reverting on
1488      * overflow.
1489      *
1490      * Counterpart to Solidity's `*` operator.
1491      *
1492      * Requirements:
1493      *
1494      * - Multiplication cannot overflow.
1495      */
1496     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1497         return a * b;
1498     }
1499 
1500     /**
1501      * @dev Returns the integer division of two unsigned integers, reverting on
1502      * division by zero. The result is rounded towards zero.
1503      *
1504      * Counterpart to Solidity's `/` operator.
1505      *
1506      * Requirements:
1507      *
1508      * - The divisor cannot be zero.
1509      */
1510     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1511         return a / b;
1512     }
1513 
1514     /**
1515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1516      * reverting when dividing by zero.
1517      *
1518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1519      * opcode (which leaves remaining gas untouched) while Solidity uses an
1520      * invalid opcode to revert (consuming all remaining gas).
1521      *
1522      * Requirements:
1523      *
1524      * - The divisor cannot be zero.
1525      */
1526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1527         return a % b;
1528     }
1529 
1530     /**
1531      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1532      * overflow (when the result is negative).
1533      *
1534      * CAUTION: This function is deprecated because it requires allocating memory for the error
1535      * message unnecessarily. For custom revert reasons use {trySub}.
1536      *
1537      * Counterpart to Solidity's `-` operator.
1538      *
1539      * Requirements:
1540      *
1541      * - Subtraction cannot overflow.
1542      */
1543     function sub(
1544         uint256 a,
1545         uint256 b,
1546         string memory errorMessage
1547     ) internal pure returns (uint256) {
1548         unchecked {
1549             require(b <= a, errorMessage);
1550             return a - b;
1551         }
1552     }
1553 
1554     /**
1555      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1556      * division by zero. The result is rounded towards zero.
1557      *
1558      * Counterpart to Solidity's `/` operator. Note: this function uses a
1559      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1560      * uses an invalid opcode to revert (consuming all remaining gas).
1561      *
1562      * Requirements:
1563      *
1564      * - The divisor cannot be zero.
1565      */
1566     function div(
1567         uint256 a,
1568         uint256 b,
1569         string memory errorMessage
1570     ) internal pure returns (uint256) {
1571         unchecked {
1572             require(b > 0, errorMessage);
1573             return a / b;
1574         }
1575     }
1576 
1577     /**
1578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1579      * reverting with custom message when dividing by zero.
1580      *
1581      * CAUTION: This function is deprecated because it requires allocating memory for the error
1582      * message unnecessarily. For custom revert reasons use {tryMod}.
1583      *
1584      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1585      * opcode (which leaves remaining gas untouched) while Solidity uses an
1586      * invalid opcode to revert (consuming all remaining gas).
1587      *
1588      * Requirements:
1589      *
1590      * - The divisor cannot be zero.
1591      */
1592     function mod(
1593         uint256 a,
1594         uint256 b,
1595         string memory errorMessage
1596     ) internal pure returns (uint256) {
1597         unchecked {
1598             require(b > 0, errorMessage);
1599             return a % b;
1600         }
1601     }
1602 }
1603 
1604 
1605 // File contracts/oz/contracts/utils/math/Math.sol
1606 
1607 
1608 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
1609 
1610 pragma solidity ^0.8.0;
1611 
1612 /**
1613  * @dev Standard math utilities missing in the Solidity language.
1614  */
1615 library Math {
1616     /**
1617      * @dev Returns the largest of two numbers.
1618      */
1619     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1620         return a >= b ? a : b;
1621     }
1622 
1623     /**
1624      * @dev Returns the smallest of two numbers.
1625      */
1626     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1627         return a < b ? a : b;
1628     }
1629 
1630     /**
1631      * @dev Returns the average of two numbers. The result is rounded towards
1632      * zero.
1633      */
1634     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1635         // (a + b) / 2 can overflow.
1636         return (a & b) + (a ^ b) / 2;
1637     }
1638 
1639     /**
1640      * @dev Returns the ceiling of the division of two numbers.
1641      *
1642      * This differs from standard division with `/` in that it rounds up instead
1643      * of rounding down.
1644      */
1645     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1646         // (a + b - 1) / b can overflow on addition, so we distribute.
1647         return a / b + (a % b == 0 ? 0 : 1);
1648     }
1649 }
1650 
1651 
1652 // File contracts/whitelist.sol
1653 
1654 
1655 
1656 pragma solidity ^0.8.4;
1657 
1658 
1659 contract Whitelist is Ownable {
1660     address[] mWhitelistArr;
1661     mapping(address => bool) mWhitelist;
1662 
1663     event AddedToWhitelist(address indexed account);
1664     event RemovedFromWhitelist(address indexed account);
1665 
1666     // modifier onlyWhitelisted() {
1667     //     require(isWhitelisted(msg.sender));
1668     //     _;
1669     // }
1670 
1671     function getWhitelistArraySize() public view returns (uint256) {
1672         return mWhitelistArr.length;
1673     }
1674 
1675     function getWhitelistInRange(uint256 startIndex, uint256 count)
1676         public
1677         view
1678         returns (address[] memory)
1679     {
1680         require(startIndex + 1 <= mWhitelistArr.length, "Out of bounds.");
1681         // clamp to arr size
1682         uint256 endIndex = Math.min(startIndex + count, mWhitelistArr.length);
1683         uint256 newCount = endIndex - startIndex;
1684         address[] memory filteredAddresses = new address[](newCount);
1685         uint256 filterIdx = 0;
1686         for (uint256 i = startIndex; i < endIndex; i++) {
1687             if (isWhitelisted(mWhitelistArr[i])) {
1688                 filteredAddresses[filterIdx++] = mWhitelistArr[i];
1689             }
1690         }
1691         return filteredAddresses;
1692     }
1693 
1694     function batchAddWhitelistAccount(address[] memory _addresses)
1695         public
1696         onlyOwner
1697     {
1698         for (uint256 i = 0; i < _addresses.length; i++) {
1699             mWhitelistArr.push(_addresses[i]);
1700             mWhitelist[_addresses[i]] = true;
1701             emit AddedToWhitelist(_addresses[i]);
1702         }
1703     }
1704 
1705     function batchRemoveWhitelistAccount(address[] memory _addresses)
1706         public
1707         onlyOwner
1708     {
1709         for (uint256 i = 0; i < _addresses.length; i++) {
1710             mWhitelist[_addresses[i]] = false;
1711             emit RemovedFromWhitelist(_addresses[i]);
1712         }
1713     }
1714 
1715     function isWhitelisted(address _address) public view returns (bool) {
1716         return mWhitelist[_address];
1717     }
1718 }
1719 
1720 
1721 // File contracts/sweaty-erc721-v3.sol
1722 
1723 
1724 // Creator: SweatyNFT
1725 
1726 pragma solidity ^0.8.4;
1727 
1728 
1729 
1730 contract SweatyERC721v3 is ERC721A, Ownable, Whitelist {
1731     using SafeMath for uint256;
1732 
1733     string constant CONTRACT_IDENTIFIER = "sweaty-erc721-v3";
1734 
1735     uint256 constant CHAIN_ETHEREUM = 1;
1736     uint256 constant CHAIN_RINKEBY = 4;
1737     uint256 constant CHAIN_POLYGON = 137;
1738     uint256 constant CHAIN_MUMBAI = 80001;
1739 
1740     uint256 constant PER_MINT_FEE_ETH = 0.0001 ether;
1741     uint256 constant PER_MINT_FEE_MATIC = 0.03 ether;
1742     uint256 constant PER_LAZY_MINT_FEE_PERCENT = 5;
1743 
1744     address constant DEVELOPER = 0x0D80C4D1546e7F85b8425c2010A5e521Dd9B9f4f;
1745 
1746     string public mContractInfoId;
1747     uint256 public mMaxSupply;
1748     uint256 public mMintPrice;
1749     string public mBaseURI;
1750     bool public mPaused = false;
1751     bool public mWhitelistEnabled = false;
1752 
1753     uint256 public mPublicMintLimit = 5;
1754     mapping(address => uint256) public mPublicBalances;
1755 
1756     uint256 public mWhitelistMintLimit = 3;
1757     mapping(address => uint256) public mWhitelistBalances;
1758 
1759     constructor(
1760         string memory _contractInfoId,
1761         string memory _name,
1762         string memory _symbol,
1763         uint256 _maxSupply,
1764         uint256 _mintPrice,
1765         string memory _metadataBaseUri
1766     ) ERC721A(_name, _symbol) {
1767         require(_maxSupply > 0, "Max supply cannot be zero.");
1768         require(_mintPrice > 0, "Mint price cannot be zero.");
1769         mContractInfoId = _contractInfoId;
1770         mMaxSupply = _maxSupply;
1771         mMintPrice = _mintPrice;
1772         mBaseURI = _metadataBaseUri;
1773     }
1774 
1775     function getContractIdentifier() public pure returns (string memory) {
1776         return CONTRACT_IDENTIFIER;
1777     }
1778 
1779     function _startTokenId() internal view virtual override returns (uint256) {
1780         return 1;
1781     }
1782 
1783     function setMintPrice(uint256 _mintPrice) external onlyOwner {
1784         mMintPrice = _mintPrice;
1785     }
1786 
1787     function setPaused(bool _paused) public onlyOwner {
1788         mPaused = _paused;
1789     }
1790 
1791     function setWhitelistEnabled(bool _enabled) public onlyOwner {
1792         mWhitelistEnabled = _enabled;
1793     }
1794 
1795     function mintOne() external payable {
1796         require(!mPaused, "Sale paused.");
1797         require(
1798             tokensMinted() + 1 <= mMaxSupply,
1799             "Insufficient tokens remaining."
1800         );
1801         require(msg.value == mMintPrice, "Wrong value.");
1802         require(
1803             !mWhitelistEnabled || isWhitelisted(msg.sender),
1804             "Must be whitelisted."
1805         );
1806         require(
1807             mWhitelistEnabled ||
1808                 mPublicBalances[msg.sender] + 1 <= mPublicMintLimit,
1809             "Public mint limit exceeded."
1810         );
1811         require(
1812             !mWhitelistEnabled ||
1813                 mWhitelistBalances[msg.sender] + 1 <= mWhitelistMintLimit,
1814             "Whitelist mint limit exceeded."
1815         );
1816 
1817         _withdraw(DEVELOPER, msg.value.mul(PER_LAZY_MINT_FEE_PERCENT).div(100));
1818         _safeMint(msg.sender, 1);
1819 
1820         if (mWhitelistEnabled) {
1821             mWhitelistBalances[msg.sender]++;
1822         } else {
1823             mPublicBalances[msg.sender]++;
1824         }
1825     }
1826 
1827     function batchMint(uint256 _amount) external payable onlyOwner {
1828         require(
1829             tokensMinted() + _amount <= mMaxSupply,
1830             "Insufficient tokens remaining."
1831         );
1832         uint256 fee = getOwnerBatchMintFee(_amount);
1833         require(msg.value == fee, "Wrong value.");
1834 
1835         _withdraw(DEVELOPER, fee);
1836         _safeMint(msg.sender, _amount);
1837     }
1838 
1839     function getOwnerBatchMintFee(uint256 _amount)
1840         public
1841         view
1842         returns (uint256)
1843     {
1844         uint256 id;
1845         assembly {
1846             id := chainid()
1847         }
1848         require(
1849             id == CHAIN_ETHEREUM ||
1850                 id == CHAIN_RINKEBY ||
1851                 id == CHAIN_POLYGON ||
1852                 id == CHAIN_MUMBAI,
1853             "Unsupported chain."
1854         );
1855         if (id == CHAIN_ETHEREUM || id == CHAIN_RINKEBY) {
1856             return _amount.mul(PER_MINT_FEE_ETH);
1857         }
1858         if (id == CHAIN_POLYGON) {
1859             return _amount.mul(PER_MINT_FEE_MATIC);
1860         }
1861         return _amount.mul(0.00001 ether);
1862     }
1863 
1864     function tokensMinted() public view returns (uint256) {
1865         return _totalMinted();
1866     }
1867 
1868     function _baseURI() internal view virtual override returns (string memory) {
1869         return mBaseURI;
1870     }
1871 
1872     function setBaseURI(string memory newBaseURI) public onlyOwner {
1873         mBaseURI = newBaseURI;
1874     }
1875 
1876     function _withdraw(address _address, uint256 _amount) private {
1877         (bool success, ) = _address.call{value: _amount}("");
1878         require(success, "Transfer failed.");
1879     }
1880 
1881     function withdrawAll() public onlyOwner {
1882         uint256 balance = address(this).balance;
1883         require(balance > 0, "Balance is zero.");
1884         _withdraw(address(msg.sender), address(this).balance);
1885     }
1886 
1887     function setPublicMintLimit(uint256 _limit) public onlyOwner {
1888         mPublicMintLimit = _limit;
1889     }
1890 
1891     function setWhitelistMintLimit(uint256 _limit) public onlyOwner {
1892         mWhitelistMintLimit = _limit;
1893     }
1894 }