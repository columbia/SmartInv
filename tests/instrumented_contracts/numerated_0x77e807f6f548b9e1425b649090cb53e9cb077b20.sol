1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-22
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
7 
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
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 /**
171  * @title ERC721 token receiver interface
172  * @dev Interface for any contract that wants to support safeTransfers
173  * from ERC721 asset contracts.
174  */
175 interface IERC721Receiver {
176     /**
177      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
178      * by `operator` from `from`, this function is called.
179      *
180      * It must return its Solidity selector to confirm the token transfer.
181      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
182      *
183      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
184      */
185     function onERC721Received(
186         address operator,
187         address from,
188         uint256 tokenId,
189         bytes calldata data
190     ) external returns (bytes4);
191 }
192 
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Metadata is IERC721 {
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 
216 /**
217  * @dev Collection of functions related to the address type
218  */
219 library Address {
220     /**
221      * @dev Returns true if `account` is a contract.
222      *
223      * [IMPORTANT]
224      * ====
225      * It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      *
228      * Among others, `isContract` will return false for the following
229      * types of addresses:
230      *
231      *  - an externally-owned account
232      *  - a contract in construction
233      *  - an address where a contract will be created
234      *  - an address where a contract lived, but was destroyed
235      * ====
236      *
237      * [IMPORTANT]
238      * ====
239      * You shouldn't rely on `isContract` to protect against flash loan attacks!
240      *
241      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
242      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
243      * constructor.
244      * ====
245      */
246     function isContract(address account) internal view returns (bool) {
247         // This method relies on extcodesize/address.code.length, which returns 0
248         // for contracts in construction, since the code is only stored at the end
249         // of the constructor execution.
250 
251         return account.code.length > 0;
252     }
253 
254     /**
255      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
256      * `recipient`, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by `transfer`, making them unable to receive funds via
261      * `transfer`. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to `recipient`, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         (bool success, ) = recipient.call{value: amount}("");
274         require(success, "Address: unable to send value, recipient may have reverted");
275     }
276 
277     /**
278      * @dev Performs a Solidity function call using a low level `call`. A
279      * plain `call` is an unsafe replacement for a function call: use this
280      * function instead.
281      *
282      * If `target` reverts with a revert reason, it is bubbled up by this
283      * function (like regular Solidity function calls).
284      *
285      * Returns the raw returned data. To convert to the expected return value,
286      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
287      *
288      * Requirements:
289      *
290      * - `target` must be a contract.
291      * - calling `target` with `data` must not revert.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
301      * `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but also transferring `value` wei to `target`.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least `value`.
320      * - the called Solidity function must be `payable`.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
334      * with `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         require(isContract(target), "Address: call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.call{value: value}(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.staticcall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.delegatecall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
407      * revert reason using the provided one.
408      *
409      * _Available since v4.3._
410      */
411     function verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) internal pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 
435 /**
436  * @dev Provides information about the current execution context, including the
437  * sender of the transaction and its data. While these are generally available
438  * via msg.sender and msg.data, they should not be accessed in such a direct
439  * manner, since when dealing with meta-transactions the account sending and
440  * paying for execution may not be the actual sender (as far as an application
441  * is concerned).
442  *
443  * This contract is only required for intermediate, library-like contracts.
444  */
445 abstract contract Context {
446     function _msgSender() internal view virtual returns (address) {
447         return msg.sender;
448     }
449 
450     function _msgData() internal view virtual returns (bytes calldata) {
451         return msg.data;
452     }
453 }
454 
455 
456 /**
457  * @dev String operations.
458  */
459 library Strings {
460     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
464      */
465     function toString(uint256 value) internal pure returns (string memory) {
466         // Inspired by OraclizeAPI's implementation - MIT licence
467         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
468 
469         if (value == 0) {
470             return "0";
471         }
472         uint256 temp = value;
473         uint256 digits;
474         while (temp != 0) {
475             digits++;
476             temp /= 10;
477         }
478         bytes memory buffer = new bytes(digits);
479         while (value != 0) {
480             digits -= 1;
481             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
482             value /= 10;
483         }
484         return string(buffer);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
489      */
490     function toHexString(uint256 value) internal pure returns (string memory) {
491         if (value == 0) {
492             return "0x00";
493         }
494         uint256 temp = value;
495         uint256 length = 0;
496         while (temp != 0) {
497             length++;
498             temp >>= 8;
499         }
500         return toHexString(value, length);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
505      */
506     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
507         bytes memory buffer = new bytes(2 * length + 2);
508         buffer[0] = "0";
509         buffer[1] = "x";
510         for (uint256 i = 2 * length + 1; i > 1; --i) {
511             buffer[i] = _HEX_SYMBOLS[value & 0xf];
512             value >>= 4;
513         }
514         require(value == 0, "Strings: hex length insufficient");
515         return string(buffer);
516     }
517 }
518 
519 
520 /**
521  * @dev Implementation of the {IERC165} interface.
522  *
523  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
524  * for the additional interface id that will be supported. For example:
525  *
526  * ```solidity
527  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
529  * }
530  * ```
531  *
532  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
533  */
534 abstract contract ERC165 is IERC165 {
535     /**
536      * @dev See {IERC165-supportsInterface}.
537      */
538     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539         return interfaceId == type(IERC165).interfaceId;
540     }
541 }
542 
543 pragma solidity ^0.8.4;
544 
545 error ApprovalCallerNotOwnerNorApproved();
546 error ApprovalQueryForNonexistentToken();
547 error ApproveToCaller();
548 error ApprovalToCurrentOwner();
549 error BalanceQueryForZeroAddress();
550 error MintToZeroAddress();
551 error MintZeroQuantity();
552 error OwnerQueryForNonexistentToken();
553 error TransferCallerNotOwnerNorApproved();
554 error TransferFromIncorrectOwner();
555 error TransferToNonERC721ReceiverImplementer();
556 error TransferToZeroAddress();
557 error URIQueryForNonexistentToken();
558 
559 /**
560  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
561  * the Metadata extension. Built to optimize for lower gas during batch mints.
562  *
563  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
564  *
565  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
566  *
567  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
568  */
569 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
570     using Address for address;
571     using Strings for uint256;
572 
573     // Compiler will pack this into a single 256bit word.
574     struct TokenOwnership {
575         // The address of the owner.
576         address addr;
577         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
578         uint64 startTimestamp;
579         // Whether the token has been burned.
580         bool burned;
581     }
582 
583     // Compiler will pack this into a single 256bit word.
584     struct AddressData {
585         // Realistically, 2**64-1 is more than enough.
586         uint64 balance;
587         // Keeps track of mint count with minimal overhead for tokenomics.
588         uint64 numberMinted;
589         // Keeps track of burn count with minimal overhead for tokenomics.
590         uint64 numberBurned;
591         // For miscellaneous variable(s) pertaining to the address
592         // (e.g. number of whitelist mint slots used).
593         // If there are multiple variables, please pack them into a uint64.
594         uint64 aux;
595     }
596 
597     // The tokenId of the next token to be minted.
598     uint256 internal _currentIndex;
599 
600     // The number of tokens burned.
601     uint256 internal _burnCounter;
602 
603     // Token name
604     string private _name;
605 
606     // Token symbol
607     string private _symbol;
608 
609     // Mapping from token ID to ownership details
610     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
611     mapping(uint256 => TokenOwnership) internal _ownerships;
612 
613     // Mapping owner address to address data
614     mapping(address => AddressData) private _addressData;
615 
616     // Mapping from token ID to approved address
617     mapping(uint256 => address) private _tokenApprovals;
618 
619     // Mapping from owner to operator approvals
620     mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622     constructor(string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625         _currentIndex = _startTokenId();
626     }
627 
628     /**
629      * To change the starting tokenId, please override this function.
630      */
631     function _startTokenId() internal view virtual returns (uint256) {
632         return 0;
633     }
634 
635     /**
636      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
637      */
638     function totalSupply() public view returns (uint256) {
639         // Counter underflow is impossible as _burnCounter cannot be incremented
640         // more than _currentIndex - _startTokenId() times
641         unchecked {
642             return _currentIndex - _burnCounter - _startTokenId();
643         }
644     }
645 
646     /**
647      * Returns the total amount of tokens minted in the contract.
648      */
649     function _totalMinted() internal view returns (uint256) {
650         // Counter underflow is impossible as _currentIndex does not decrement,
651         // and it is initialized to _startTokenId()
652         unchecked {
653             return _currentIndex - _startTokenId();
654         }
655     }
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
661         return
662             interfaceId == type(IERC721).interfaceId ||
663             interfaceId == type(IERC721Metadata).interfaceId ||
664             super.supportsInterface(interfaceId);
665     }
666 
667     /**
668      * @dev See {IERC721-balanceOf}.
669      */
670     function balanceOf(address owner) public view override returns (uint256) {
671         if (owner == address(0)) revert BalanceQueryForZeroAddress();
672         return uint256(_addressData[owner].balance);
673     }
674 
675     /**
676      * Returns the number of tokens minted by `owner`.
677      */
678     function _numberMinted(address owner) internal view returns (uint256) {
679         return uint256(_addressData[owner].numberMinted);
680     }
681 
682     /**
683      * Returns the number of tokens burned by or on behalf of `owner`.
684      */
685     function _numberBurned(address owner) internal view returns (uint256) {
686         return uint256(_addressData[owner].numberBurned);
687     }
688 
689     /**
690      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
691      */
692     function _getAux(address owner) internal view returns (uint64) {
693         return _addressData[owner].aux;
694     }
695 
696     /**
697      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
698      * If there are multiple variables, please pack them into a uint64.
699      */
700     function _setAux(address owner, uint64 aux) internal {
701         _addressData[owner].aux = aux;
702     }
703 
704     /**
705      * Gas spent here starts off proportional to the maximum mint batch size.
706      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
707      */
708     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
709         uint256 curr = tokenId;
710 
711         unchecked {
712             if (_startTokenId() <= curr && curr < _currentIndex) {
713                 TokenOwnership memory ownership = _ownerships[curr];
714                 if (!ownership.burned) {
715                     if (ownership.addr != address(0)) {
716                         return ownership;
717                     }
718                     // Invariant:
719                     // There will always be an ownership that has an address and is not burned
720                     // before an ownership that does not have an address and is not burned.
721                     // Hence, curr will not underflow.
722                     while (true) {
723                         curr--;
724                         ownership = _ownerships[curr];
725                         if (ownership.addr != address(0)) {
726                             return ownership;
727                         }
728                     }
729                 }
730             }
731         }
732         revert OwnerQueryForNonexistentToken();
733     }
734 
735     /**
736      * @dev See {IERC721-ownerOf}.
737      */
738     function ownerOf(uint256 tokenId) public view override returns (address) {
739         return _ownershipOf(tokenId).addr;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-name}.
744      */
745     function name() public view virtual override returns (string memory) {
746         return _name;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-symbol}.
751      */
752     function symbol() public view virtual override returns (string memory) {
753         return _symbol;
754     }
755 
756     /**
757      * @dev See {IERC721Metadata-tokenURI}.
758      */
759     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
760         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
761 
762         string memory baseURI = _baseURI();
763         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
764     }
765 
766     /**
767      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
768      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
769      * by default, can be overriden in child contracts.
770      */
771     function _baseURI() internal view virtual returns (string memory) {
772         return '';
773     }
774 
775     /**
776      * @dev See {IERC721-approve}.
777      */
778     function approve(address to, uint256 tokenId) public override {
779         address owner = ERC721A.ownerOf(tokenId);
780         if (to == owner) revert ApprovalToCurrentOwner();
781 
782         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
783             revert ApprovalCallerNotOwnerNorApproved();
784         }
785 
786         _approve(to, tokenId, owner);
787     }
788 
789     /**
790      * @dev See {IERC721-getApproved}.
791      */
792     function getApproved(uint256 tokenId) public view override returns (address) {
793         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
794 
795         return _tokenApprovals[tokenId];
796     }
797 
798     /**
799      * @dev See {IERC721-setApprovalForAll}.
800      */
801     function setApprovalForAll(address operator, bool approved) public virtual override {
802         if (operator == _msgSender()) revert ApproveToCaller();
803 
804         _operatorApprovals[_msgSender()][operator] = approved;
805         emit ApprovalForAll(_msgSender(), operator, approved);
806     }
807 
808     /**
809      * @dev See {IERC721-isApprovedForAll}.
810      */
811     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
812         return _operatorApprovals[owner][operator];
813     }
814 
815     /**
816      * @dev See {IERC721-transferFrom}.
817      */
818     function transferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) public virtual override {
823         _transfer(from, to, tokenId);
824     }
825 
826     /**
827      * @dev See {IERC721-safeTransferFrom}.
828      */
829     function safeTransferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public virtual override {
834         safeTransferFrom(from, to, tokenId, '');
835     }
836 
837     /**
838      * @dev See {IERC721-safeTransferFrom}.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes memory _data
845     ) public virtual override {
846         _transfer(from, to, tokenId);
847         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
848             revert TransferToNonERC721ReceiverImplementer();
849         }
850     }
851 
852     /**
853      * @dev Returns whether `tokenId` exists.
854      *
855      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
856      *
857      * Tokens start existing when they are minted (`_mint`),
858      */
859     function _exists(uint256 tokenId) internal view returns (bool) {
860         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
861             !_ownerships[tokenId].burned;
862     }
863 
864     function _safeMint(address to, uint256 quantity) internal {
865         _safeMint(to, quantity, '');
866     }
867 
868     /**
869      * @dev Safely mints `quantity` tokens and transfers them to `to`.
870      *
871      * Requirements:
872      *
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
874      * - `quantity` must be greater than 0.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _safeMint(
879         address to,
880         uint256 quantity,
881         bytes memory _data
882     ) internal {
883         _mint(to, quantity, _data, true);
884     }
885 
886     /**
887      * @dev Mints `quantity` tokens and transfers them to `to`.
888      *
889      * Requirements:
890      *
891      * - `to` cannot be the zero address.
892      * - `quantity` must be greater than 0.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _mint(
897         address to,
898         uint256 quantity,
899         bytes memory _data,
900         bool safe
901     ) internal {
902         uint256 startTokenId = _currentIndex;
903         if (to == address(0)) revert MintToZeroAddress();
904         if (quantity == 0) revert MintZeroQuantity();
905 
906         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
907 
908         // Overflows are incredibly unrealistic.
909         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
910         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
911         unchecked {
912             _addressData[to].balance += uint64(quantity);
913             _addressData[to].numberMinted += uint64(quantity);
914 
915             _ownerships[startTokenId].addr = to;
916             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
917 
918             uint256 updatedIndex = startTokenId;
919             uint256 end = updatedIndex + quantity;
920 
921             if (safe && to.isContract()) {
922                 do {
923                     emit Transfer(address(0), to, updatedIndex);
924                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
925                         revert TransferToNonERC721ReceiverImplementer();
926                     }
927                 } while (updatedIndex != end);
928                 // Reentrancy protection
929                 if (_currentIndex != startTokenId) revert();
930             } else {
931                 do {
932                     emit Transfer(address(0), to, updatedIndex++);
933                 } while (updatedIndex != end);
934             }
935             _currentIndex = updatedIndex;
936         }
937         _afterTokenTransfers(address(0), to, startTokenId, quantity);
938     }
939 
940     /**
941      * @dev Transfers `tokenId` from `from` to `to`.
942      *
943      * Requirements:
944      *
945      * - `to` cannot be the zero address.
946      * - `tokenId` token must be owned by `from`.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _transfer(
951         address from,
952         address to,
953         uint256 tokenId
954     ) private {
955         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
956 
957         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
958 
959         bool isApprovedOrOwner = (_msgSender() == from ||
960             isApprovedForAll(from, _msgSender()) ||
961             getApproved(tokenId) == _msgSender());
962 
963         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
964         if (to == address(0)) revert TransferToZeroAddress();
965 
966         _beforeTokenTransfers(from, to, tokenId, 1);
967 
968         // Clear approvals from the previous owner
969         _approve(address(0), tokenId, from);
970 
971         // Underflow of the sender's balance is impossible because we check for
972         // ownership above and the recipient's balance can't realistically overflow.
973         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
974         unchecked {
975             _addressData[from].balance -= 1;
976             _addressData[to].balance += 1;
977 
978             TokenOwnership storage currSlot = _ownerships[tokenId];
979             currSlot.addr = to;
980             currSlot.startTimestamp = uint64(block.timestamp);
981 
982             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
983             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
984             uint256 nextTokenId = tokenId + 1;
985             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
986             if (nextSlot.addr == address(0)) {
987                 // This will suffice for checking _exists(nextTokenId),
988                 // as a burned slot cannot contain the zero address.
989                 if (nextTokenId != _currentIndex) {
990                     nextSlot.addr = from;
991                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
992                 }
993             }
994         }
995 
996         emit Transfer(from, to, tokenId);
997         _afterTokenTransfers(from, to, tokenId, 1);
998     }
999 
1000     /**
1001      * @dev This is equivalent to _burn(tokenId, false)
1002      */
1003     function _burn(uint256 tokenId) internal virtual {
1004         _burn(tokenId, false);
1005     }
1006 
1007     /**
1008      * @dev Destroys `tokenId`.
1009      * The approval is cleared when the token is burned.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1018         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1019 
1020         address from = prevOwnership.addr;
1021 
1022         if (approvalCheck) {
1023             bool isApprovedOrOwner = (_msgSender() == from ||
1024                 isApprovedForAll(from, _msgSender()) ||
1025                 getApproved(tokenId) == _msgSender());
1026 
1027             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1028         }
1029 
1030         _beforeTokenTransfers(from, address(0), tokenId, 1);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId, from);
1034 
1035         // Underflow of the sender's balance is impossible because we check for
1036         // ownership above and the recipient's balance can't realistically overflow.
1037         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1038         unchecked {
1039             AddressData storage addressData = _addressData[from];
1040             addressData.balance -= 1;
1041             addressData.numberBurned += 1;
1042 
1043             // Keep track of who burned the token, and the timestamp of burning.
1044             TokenOwnership storage currSlot = _ownerships[tokenId];
1045             currSlot.addr = from;
1046             currSlot.startTimestamp = uint64(block.timestamp);
1047             currSlot.burned = true;
1048 
1049             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1050             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1051             uint256 nextTokenId = tokenId + 1;
1052             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1053             if (nextSlot.addr == address(0)) {
1054                 // This will suffice for checking _exists(nextTokenId),
1055                 // as a burned slot cannot contain the zero address.
1056                 if (nextTokenId != _currentIndex) {
1057                     nextSlot.addr = from;
1058                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1059                 }
1060             }
1061         }
1062 
1063         emit Transfer(from, address(0), tokenId);
1064         _afterTokenTransfers(from, address(0), tokenId, 1);
1065 
1066         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1067         unchecked {
1068             _burnCounter++;
1069         }
1070     }
1071 
1072     /**
1073      * @dev Approve `to` to operate on `tokenId`
1074      *
1075      * Emits a {Approval} event.
1076      */
1077     function _approve(
1078         address to,
1079         uint256 tokenId,
1080         address owner
1081     ) private {
1082         _tokenApprovals[tokenId] = to;
1083         emit Approval(owner, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1088      *
1089      * @param from address representing the previous owner of the given token ID
1090      * @param to target address that will receive the tokens
1091      * @param tokenId uint256 ID of the token to be transferred
1092      * @param _data bytes optional data to send along with the call
1093      * @return bool whether the call correctly returned the expected magic value
1094      */
1095     function _checkContractOnERC721Received(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) private returns (bool) {
1101         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1102             return retval == IERC721Receiver(to).onERC721Received.selector;
1103         } catch (bytes memory reason) {
1104             if (reason.length == 0) {
1105                 revert TransferToNonERC721ReceiverImplementer();
1106             } else {
1107                 assembly {
1108                     revert(add(32, reason), mload(reason))
1109                 }
1110             }
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1116      * And also called before burning one token.
1117      *
1118      * startTokenId - the first token id to be transferred
1119      * quantity - the amount to be transferred
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` will be minted for `to`.
1126      * - When `to` is zero, `tokenId` will be burned by `from`.
1127      * - `from` and `to` are never both zero.
1128      */
1129     function _beforeTokenTransfers(
1130         address from,
1131         address to,
1132         uint256 startTokenId,
1133         uint256 quantity
1134     ) internal virtual {}
1135 
1136     /**
1137      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1138      * minting.
1139      * And also called after one token has been burned.
1140      *
1141      * startTokenId - the first token id to be transferred
1142      * quantity - the amount to be transferred
1143      *
1144      * Calling conditions:
1145      *
1146      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1147      * transferred to `to`.
1148      * - When `from` is zero, `tokenId` has been minted for `to`.
1149      * - When `to` is zero, `tokenId` has been burned by `from`.
1150      * - `from` and `to` are never both zero.
1151      */
1152     function _afterTokenTransfers(
1153         address from,
1154         address to,
1155         uint256 startTokenId,
1156         uint256 quantity
1157     ) internal virtual {}
1158 }
1159 
1160 /**
1161  * @title Counters
1162  * @author Matt Condon (@shrugs)
1163  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1164  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1165  *
1166  * Include with `using Counters for Counters.Counter;`
1167  */
1168 library Counters {
1169     struct Counter {
1170         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1171         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1172         // this feature: see https://github.com/ethereum/solidity/issues/4637
1173         uint256 _value; // default: 0
1174     }
1175 
1176     function current(Counter storage counter) internal view returns (uint256) {
1177         return counter._value;
1178     }
1179 
1180     function increment(Counter storage counter) internal {
1181         unchecked {
1182             counter._value += 1;
1183         }
1184     }
1185 
1186     function decrement(Counter storage counter) internal {
1187         uint256 value = counter._value;
1188         require(value > 0, "Counter: decrement overflow");
1189         unchecked {
1190             counter._value = value - 1;
1191         }
1192     }
1193 
1194     function reset(Counter storage counter) internal {
1195         counter._value = 0;
1196     }
1197 }
1198 
1199 
1200 /**
1201  * @dev Wrappers over Solidity's arithmetic operations.
1202  *
1203  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1204  * now has built in overflow checking.
1205  */
1206 library SafeMath {
1207     /**
1208      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1213         unchecked {
1214             uint256 c = a + b;
1215             if (c < a) return (false, 0);
1216             return (true, c);
1217         }
1218     }
1219 
1220     /**
1221      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1222      *
1223      * _Available since v3.4._
1224      */
1225     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1226         unchecked {
1227             if (b > a) return (false, 0);
1228             return (true, a - b);
1229         }
1230     }
1231 
1232     /**
1233      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1234      *
1235      * _Available since v3.4._
1236      */
1237     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1238         unchecked {
1239             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1240             // benefit is lost if 'b' is also tested.
1241             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1242             if (a == 0) return (true, 0);
1243             uint256 c = a * b;
1244             if (c / a != b) return (false, 0);
1245             return (true, c);
1246         }
1247     }
1248 
1249     /**
1250      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1251      *
1252      * _Available since v3.4._
1253      */
1254     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1255         unchecked {
1256             if (b == 0) return (false, 0);
1257             return (true, a / b);
1258         }
1259     }
1260 
1261     /**
1262      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1263      *
1264      * _Available since v3.4._
1265      */
1266     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1267         unchecked {
1268             if (b == 0) return (false, 0);
1269             return (true, a % b);
1270         }
1271     }
1272 
1273     /**
1274      * @dev Returns the addition of two unsigned integers, reverting on
1275      * overflow.
1276      *
1277      * Counterpart to Solidity's `+` operator.
1278      *
1279      * Requirements:
1280      *
1281      * - Addition cannot overflow.
1282      */
1283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1284         return a + b;
1285     }
1286 
1287     /**
1288      * @dev Returns the subtraction of two unsigned integers, reverting on
1289      * overflow (when the result is negative).
1290      *
1291      * Counterpart to Solidity's `-` operator.
1292      *
1293      * Requirements:
1294      *
1295      * - Subtraction cannot overflow.
1296      */
1297     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1298         return a - b;
1299     }
1300 
1301     /**
1302      * @dev Returns the multiplication of two unsigned integers, reverting on
1303      * overflow.
1304      *
1305      * Counterpart to Solidity's `*` operator.
1306      *
1307      * Requirements:
1308      *
1309      * - Multiplication cannot overflow.
1310      */
1311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1312         return a * b;
1313     }
1314 
1315     /**
1316      * @dev Returns the integer division of two unsigned integers, reverting on
1317      * division by zero. The result is rounded towards zero.
1318      *
1319      * Counterpart to Solidity's `/` operator.
1320      *
1321      * Requirements:
1322      *
1323      * - The divisor cannot be zero.
1324      */
1325     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1326         return a / b;
1327     }
1328 
1329     /**
1330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1331      * reverting when dividing by zero.
1332      *
1333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1334      * opcode (which leaves remaining gas untouched) while Solidity uses an
1335      * invalid opcode to revert (consuming all remaining gas).
1336      *
1337      * Requirements:
1338      *
1339      * - The divisor cannot be zero.
1340      */
1341     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1342         return a % b;
1343     }
1344 
1345     /**
1346      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1347      * overflow (when the result is negative).
1348      *
1349      * CAUTION: This function is deprecated because it requires allocating memory for the error
1350      * message unnecessarily. For custom revert reasons use {trySub}.
1351      *
1352      * Counterpart to Solidity's `-` operator.
1353      *
1354      * Requirements:
1355      *
1356      * - Subtraction cannot overflow.
1357      */
1358     function sub(
1359         uint256 a,
1360         uint256 b,
1361         string memory errorMessage
1362     ) internal pure returns (uint256) {
1363         unchecked {
1364             require(b <= a, errorMessage);
1365             return a - b;
1366         }
1367     }
1368 
1369     /**
1370      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1371      * division by zero. The result is rounded towards zero.
1372      *
1373      * Counterpart to Solidity's `/` operator. Note: this function uses a
1374      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1375      * uses an invalid opcode to revert (consuming all remaining gas).
1376      *
1377      * Requirements:
1378      *
1379      * - The divisor cannot be zero.
1380      */
1381     function div(
1382         uint256 a,
1383         uint256 b,
1384         string memory errorMessage
1385     ) internal pure returns (uint256) {
1386         unchecked {
1387             require(b > 0, errorMessage);
1388             return a / b;
1389         }
1390     }
1391 
1392     /**
1393      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1394      * reverting with custom message when dividing by zero.
1395      *
1396      * CAUTION: This function is deprecated because it requires allocating memory for the error
1397      * message unnecessarily. For custom revert reasons use {tryMod}.
1398      *
1399      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1400      * opcode (which leaves remaining gas untouched) while Solidity uses an
1401      * invalid opcode to revert (consuming all remaining gas).
1402      *
1403      * Requirements:
1404      *
1405      * - The divisor cannot be zero.
1406      */
1407     function mod(
1408         uint256 a,
1409         uint256 b,
1410         string memory errorMessage
1411     ) internal pure returns (uint256) {
1412         unchecked {
1413             require(b > 0, errorMessage);
1414             return a % b;
1415         }
1416     }
1417 }
1418 
1419 abstract contract Ownable is Context {
1420     address private _owner;
1421 
1422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1423 
1424     /**
1425      * @dev Initializes the contract setting the deployer as the initial owner.
1426      */
1427     constructor() {
1428         _transferOwnership(_msgSender());
1429     }
1430 
1431     /**
1432      * @dev Returns the address of the current owner.
1433      */
1434     function owner() public view virtual returns (address) {
1435         return _owner;
1436     }
1437 
1438     /**
1439      * @dev Throws if called by any account other than the owner.
1440      */
1441     modifier onlyOwner() {
1442         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1443         _;
1444     }
1445 
1446     /**
1447      * @dev Leaves the contract without owner. It will not be possible to call
1448      * `onlyOwner` functions anymore. Can only be called by the current owner.
1449      *
1450      * NOTE: Renouncing ownership will leave the contract without an owner,
1451      * thereby removing any functionality that is only available to the owner.
1452      */
1453     function renounceOwnership() public virtual onlyOwner {
1454         _transferOwnership(address(0));
1455     }
1456 
1457     /**
1458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1459      * Can only be called by the current owner.
1460      */
1461     function transferOwnership(address newOwner) public virtual onlyOwner {
1462         require(newOwner != address(0), "Ownable: new owner is the zero address");
1463         _transferOwnership(newOwner);
1464     }
1465 
1466     /**
1467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1468      * Internal function without access restriction.
1469      */
1470     function _transferOwnership(address newOwner) internal virtual {
1471         address oldOwner = _owner;
1472         _owner = newOwner;
1473         emit OwnershipTransferred(oldOwner, newOwner);
1474     }
1475 }
1476 
1477 contract ParaPreppers is ERC721A, Ownable {
1478 
1479     using SafeMath for uint256;
1480     using Counters for Counters.Counter;
1481 
1482     string public baseTokenURI = "https://nft.parapreppernft.com/ipfs/QmXrZcpzkqjV5haNqN4oUs3HhXtH95kqRG9cfAWbVz7Kqi/";
1483     address[] public array;
1484 
1485     constructor() ERC721A("OG Para Preppers", "OGPP") {
1486     }
1487 
1488     function setMintAddress(address[] memory addr) external onlyOwner {
1489         array = addr;
1490     }
1491 
1492     function _baseURI() internal view virtual override returns (string memory) {
1493         return baseTokenURI;
1494     }
1495 
1496     //  Set the base uri for token
1497     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1498         baseTokenURI = _baseTokenURI;
1499     }
1500 
1501     function massMint() public onlyOwner {
1502         for(uint256 i=0; i<array.length; i++) {
1503             _safeMint(array[i], 1);
1504         }
1505     }
1506 
1507     function singleMint(address addr) public onlyOwner {
1508         _safeMint(addr, 1);
1509     }
1510 
1511 }