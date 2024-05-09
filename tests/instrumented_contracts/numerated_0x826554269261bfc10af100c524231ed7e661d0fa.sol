1 // SPDX-License-Identifier: MIT  
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
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
29 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
30 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId,
84         bytes calldata data
85     ) external;
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns the account approved for `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function getApproved(uint256 tokenId) external view returns (address operator);
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 }
170 
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
172 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
190      */
191     function onERC721Received(
192         address operator,
193         address from,
194         uint256 tokenId,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
200 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209     /**
210      * @dev Returns the token collection name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token collection symbol.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
221      */
222     function tokenURI(uint256 tokenId) external view returns (string memory);
223 }
224 
225 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
226 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
227 
228 pragma solidity ^0.8.1;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      *
251      * [IMPORTANT]
252      * ====
253      * You shouldn't rely on `isContract` to protect against flash loan attacks!
254      *
255      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
256      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
257      * constructor.
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize/address.code.length, which returns 0
262         // for contracts in construction, since the code is only stored at the end
263         // of the constructor execution.
264 
265         return account.code.length > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
449 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         return msg.data;
470     }
471 }
472 
473 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
474 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev String operations.
480  */
481 library Strings {
482     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
486      */
487     function toString(uint256 value) internal pure returns (string memory) {
488         // Inspired by OraclizeAPI's implementation - MIT licence
489         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
490 
491         if (value == 0) {
492             return "0";
493         }
494         uint256 temp = value;
495         uint256 digits;
496         while (temp != 0) {
497             digits++;
498             temp /= 10;
499         }
500         bytes memory buffer = new bytes(digits);
501         while (value != 0) {
502             digits -= 1;
503             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
504             value /= 10;
505         }
506         return string(buffer);
507     }
508 
509     /**
510      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
511      */
512     function toHexString(uint256 value) internal pure returns (string memory) {
513         if (value == 0) {
514             return "0x00";
515         }
516         uint256 temp = value;
517         uint256 length = 0;
518         while (temp != 0) {
519             length++;
520             temp >>= 8;
521         }
522         return toHexString(value, length);
523     }
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
527      */
528     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
529         bytes memory buffer = new bytes(2 * length + 2);
530         buffer[0] = "0";
531         buffer[1] = "x";
532         for (uint256 i = 2 * length + 1; i > 1; --i) {
533             buffer[i] = _HEX_SYMBOLS[value & 0xf];
534             value >>= 4;
535         }
536         require(value == 0, "Strings: hex length insufficient");
537         return string(buffer);
538     }
539 }
540 
541 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
542 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Implementation of the {IERC165} interface.
548  *
549  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
550  * for the additional interface id that will be supported. For example:
551  *
552  * ```solidity
553  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
555  * }
556  * ```
557  *
558  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
559  */
560 abstract contract ERC165 is IERC165 {
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565         return interfaceId == type(IERC165).interfaceId;
566     }
567 }
568 
569 // File erc721a/contracts/ERC721A.sol@v3.2.0
570 // Creator: Chiru Labs
571 
572 pragma solidity ^0.8.4;
573 
574 error ApprovalCallerNotOwnerNorApproved();
575 error ApprovalQueryForNonexistentToken();
576 error ApproveToCaller();
577 error ApprovalToCurrentOwner();
578 error BalanceQueryForZeroAddress();
579 error MintToZeroAddress();
580 error MintZeroQuantity();
581 error OwnerQueryForNonexistentToken();
582 error TransferCallerNotOwnerNorApproved();
583 error TransferFromIncorrectOwner();
584 error TransferToNonERC721ReceiverImplementer();
585 error TransferToZeroAddress();
586 error URIQueryForNonexistentToken();
587 
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension. Built to optimize for lower gas during batch mints.
591  *
592  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
593  *
594  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
595  *
596  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
597  */
598 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
599     using Address for address;
600     using Strings for uint256;
601 
602     // Compiler will pack this into a single 256bit word.
603     struct TokenOwnership {
604         // The address of the owner.
605         address addr;
606         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
607         uint64 startTimestamp;
608         // Whether the token has been burned.
609         bool burned;
610     }
611 
612     // Compiler will pack this into a single 256bit word.
613     struct AddressData {
614         // Realistically, 2**64-1 is more than enough.
615         uint64 balance;
616         // Keeps track of mint count with minimal overhead for tokenomics.
617         uint64 numberMinted;
618         // Keeps track of burn count with minimal overhead for tokenomics.
619         uint64 numberBurned;
620         // For miscellaneous variable(s) pertaining to the address
621         // (e.g. number of whitelist mint slots used).
622         // If there are multiple variables, please pack them into a uint64.
623         uint64 aux;
624     }
625 
626     // The tokenId of the next token to be minted.
627     uint256 internal _currentIndex;
628 
629     // The number of tokens burned.
630     uint256 internal _burnCounter;
631 
632     // Token name
633     string private _name;
634 
635     // Token symbol
636     string private _symbol;
637 
638     // Mapping from token ID to ownership details
639     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
640     mapping(uint256 => TokenOwnership) internal _ownerships;
641 
642     // Mapping owner address to address data
643     mapping(address => AddressData) private _addressData;
644 
645     // Mapping from token ID to approved address
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651     constructor(string memory name_, string memory symbol_) {
652         _name = name_;
653         _symbol = symbol_;
654         _currentIndex = _startTokenId();
655     }
656 
657     /**
658      * To change the starting tokenId, please override this function.
659      */
660     function _startTokenId() internal view virtual returns (uint256) {
661         return 0;
662     }
663 
664     /**
665      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
666      */
667     function totalSupply() public view returns (uint256) {
668         // Counter underflow is impossible as _burnCounter cannot be incremented
669         // more than _currentIndex - _startTokenId() times
670         unchecked {
671             return _currentIndex - _burnCounter - _startTokenId();
672         }
673     }
674 
675     /**
676      * Returns the total amount of tokens minted in the contract.
677      */
678     function _totalMinted() internal view returns (uint256) {
679         // Counter underflow is impossible as _currentIndex does not decrement,
680         // and it is initialized to _startTokenId()
681         unchecked {
682             return _currentIndex - _startTokenId();
683         }
684     }
685 
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
690         return
691             interfaceId == type(IERC721).interfaceId ||
692             interfaceId == type(IERC721Metadata).interfaceId ||
693             super.supportsInterface(interfaceId);
694     }
695 
696     /**
697      * @dev See {IERC721-balanceOf}.
698      */
699     function balanceOf(address owner) public view override returns (uint256) {
700         if (owner == address(0)) revert BalanceQueryForZeroAddress();
701         return uint256(_addressData[owner].balance);
702     }
703 
704     /**
705      * Returns the number of tokens minted by `owner`.
706      */
707     function _numberMinted(address owner) internal view returns (uint256) {
708         return uint256(_addressData[owner].numberMinted);
709     }
710 
711     /**
712      * Returns the number of tokens burned by or on behalf of `owner`.
713      */
714     function _numberBurned(address owner) internal view returns (uint256) {
715         return uint256(_addressData[owner].numberBurned);
716     }
717 
718     /**
719      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
720      */
721     function _getAux(address owner) internal view returns (uint64) {
722         return _addressData[owner].aux;
723     }
724 
725     /**
726      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
727      * If there are multiple variables, please pack them into a uint64.
728      */
729     function _setAux(address owner, uint64 aux) internal {
730         _addressData[owner].aux = aux;
731     }
732 
733     /**
734      * Gas spent here starts off proportional to the maximum mint batch size.
735      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
736      */
737     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
738         uint256 curr = tokenId;
739 
740         unchecked {
741             if (_startTokenId() <= curr && curr < _currentIndex) {
742                 TokenOwnership memory ownership = _ownerships[curr];
743                 if (!ownership.burned) {
744                     if (ownership.addr != address(0)) {
745                         return ownership;
746                     }
747                     // Invariant:
748                     // There will always be an ownership that has an address and is not burned
749                     // before an ownership that does not have an address and is not burned.
750                     // Hence, curr will not underflow.
751                     while (true) {
752                         curr--;
753                         ownership = _ownerships[curr];
754                         if (ownership.addr != address(0)) {
755                             return ownership;
756                         }
757                     }
758                 }
759             }
760         }
761         revert OwnerQueryForNonexistentToken();
762     }
763 
764     /**
765      * @dev See {IERC721-ownerOf}.
766      */
767     function ownerOf(uint256 tokenId) public view override returns (address) {
768         return _ownershipOf(tokenId).addr;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-name}.
773      */
774     function name() public view virtual override returns (string memory) {
775         return _name;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-symbol}.
780      */
781     function symbol() public view virtual override returns (string memory) {
782         return _symbol;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-tokenURI}.
787      */
788     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
789         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
790 
791         string memory baseURI = _baseURI();
792         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
793     }
794 
795     /**
796      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
797      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
798      * by default, can be overriden in child contracts.
799      */
800     function _baseURI() internal view virtual returns (string memory) {
801         return '';
802     }
803 
804     /**
805      * @dev See {IERC721-approve}.
806      */
807     function approve(address to, uint256 tokenId) public override {
808         address owner = ERC721A.ownerOf(tokenId);
809         if (to == owner) revert ApprovalToCurrentOwner();
810 
811         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
812             revert ApprovalCallerNotOwnerNorApproved();
813         }
814 
815         _approve(to, tokenId, owner);
816     }
817 
818     /**
819      * @dev See {IERC721-getApproved}.
820      */
821     function getApproved(uint256 tokenId) public view override returns (address) {
822         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
823 
824         return _tokenApprovals[tokenId];
825     }
826 
827     /**
828      * @dev See {IERC721-setApprovalForAll}.
829      */
830     function setApprovalForAll(address operator, bool approved) public virtual override {
831         if (operator == _msgSender()) revert ApproveToCaller();
832 
833         _operatorApprovals[_msgSender()][operator] = approved;
834         emit ApprovalForAll(_msgSender(), operator, approved);
835     }
836 
837     /**
838      * @dev See {IERC721-isApprovedForAll}.
839      */
840     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
841         return _operatorApprovals[owner][operator];
842     }
843 
844     /**
845      * @dev See {IERC721-transferFrom}.
846      */
847     function transferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         _transfer(from, to, tokenId);
853     }
854 
855     /**
856      * @dev See {IERC721-safeTransferFrom}.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) public virtual override {
863         safeTransferFrom(from, to, tokenId, '');
864     }
865 
866     /**
867      * @dev See {IERC721-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes memory _data
874     ) public virtual override {
875         _transfer(from, to, tokenId);
876         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
877             revert TransferToNonERC721ReceiverImplementer();
878         }
879     }
880 
881     /**
882      * @dev Returns whether `tokenId` exists.
883      *
884      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
885      *
886      * Tokens start existing when they are minted (`_mint`),
887      */
888     function _exists(uint256 tokenId) internal view returns (bool) {
889         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
890     }
891 
892     function _safeMint(address to, uint256 quantity) internal {
893         _safeMint(to, quantity, '');
894     }
895 
896     /**
897      * @dev Safely mints `quantity` tokens and transfers them to `to`.
898      *
899      * Requirements:
900      *
901      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
902      * - `quantity` must be greater than 0.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeMint(
907         address to,
908         uint256 quantity,
909         bytes memory _data
910     ) internal {
911         _mint(to, quantity, _data, true);
912     }
913 
914     /**
915      * @dev Mints `quantity` tokens and transfers them to `to`.
916      *
917      * Requirements:
918      *
919      * - `to` cannot be the zero address.
920      * - `quantity` must be greater than 0.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _mint(
925         address to,
926         uint256 quantity,
927         bytes memory _data,
928         bool safe
929     ) internal {
930         uint256 startTokenId = _currentIndex;
931         if (to == address(0)) revert MintToZeroAddress();
932         if (quantity == 0) revert MintZeroQuantity();
933 
934         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
935 
936         // Overflows are incredibly unrealistic.
937         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
938         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
939         unchecked {
940             _addressData[to].balance += uint64(quantity);
941             _addressData[to].numberMinted += uint64(quantity);
942 
943             _ownerships[startTokenId].addr = to;
944             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
945 
946             uint256 updatedIndex = startTokenId;
947             uint256 end = updatedIndex + quantity;
948 
949             if (safe && to.isContract()) {
950                 do {
951                     emit Transfer(address(0), to, updatedIndex);
952                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
953                         revert TransferToNonERC721ReceiverImplementer();
954                     }
955                 } while (updatedIndex != end);
956                 // Reentrancy protection
957                 if (_currentIndex != startTokenId) revert();
958             } else {
959                 do {
960                     emit Transfer(address(0), to, updatedIndex++);
961                 } while (updatedIndex != end);
962             }
963             _currentIndex = updatedIndex;
964         }
965         _afterTokenTransfers(address(0), to, startTokenId, quantity);
966     }
967 
968     /**
969      * @dev Transfers `tokenId` from `from` to `to`.
970      *
971      * Requirements:
972      *
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must be owned by `from`.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _transfer(
979         address from,
980         address to,
981         uint256 tokenId
982     ) private {
983         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
984 
985         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
986 
987         bool isApprovedOrOwner = (_msgSender() == from ||
988             isApprovedForAll(from, _msgSender()) ||
989             getApproved(tokenId) == _msgSender());
990 
991         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
992         if (to == address(0)) revert TransferToZeroAddress();
993 
994         _beforeTokenTransfers(from, to, tokenId, 1);
995 
996         // Clear approvals from the previous owner
997         _approve(address(0), tokenId, from);
998 
999         // Underflow of the sender's balance is impossible because we check for
1000         // ownership above and the recipient's balance can't realistically overflow.
1001         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1002         unchecked {
1003             _addressData[from].balance -= 1;
1004             _addressData[to].balance += 1;
1005 
1006             TokenOwnership storage currSlot = _ownerships[tokenId];
1007             currSlot.addr = to;
1008             currSlot.startTimestamp = uint64(block.timestamp);
1009 
1010             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1011             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1012             uint256 nextTokenId = tokenId + 1;
1013             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1014             if (nextSlot.addr == address(0)) {
1015                 // This will suffice for checking _exists(nextTokenId),
1016                 // as a burned slot cannot contain the zero address.
1017                 if (nextTokenId != _currentIndex) {
1018                     nextSlot.addr = from;
1019                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1020                 }
1021             }
1022         }
1023 
1024         emit Transfer(from, to, tokenId);
1025         _afterTokenTransfers(from, to, tokenId, 1);
1026     }
1027 
1028     /**
1029      * @dev This is equivalent to _burn(tokenId, false)
1030      */
1031     function _burn(uint256 tokenId) internal virtual {
1032         _burn(tokenId, false);
1033     }
1034 
1035     /**
1036      * @dev Destroys `tokenId`.
1037      * The approval is cleared when the token is burned.
1038      *
1039      * Requirements:
1040      *
1041      * - `tokenId` must exist.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1046         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1047 
1048         address from = prevOwnership.addr;
1049 
1050         if (approvalCheck) {
1051             bool isApprovedOrOwner = (_msgSender() == from ||
1052                 isApprovedForAll(from, _msgSender()) ||
1053                 getApproved(tokenId) == _msgSender());
1054 
1055             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1056         }
1057 
1058         _beforeTokenTransfers(from, address(0), tokenId, 1);
1059 
1060         // Clear approvals from the previous owner
1061         _approve(address(0), tokenId, from);
1062 
1063         // Underflow of the sender's balance is impossible because we check for
1064         // ownership above and the recipient's balance can't realistically overflow.
1065         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1066         unchecked {
1067             AddressData storage addressData = _addressData[from];
1068             addressData.balance -= 1;
1069             addressData.numberBurned += 1;
1070 
1071             // Keep track of who burned the token, and the timestamp of burning.
1072             TokenOwnership storage currSlot = _ownerships[tokenId];
1073             currSlot.addr = from;
1074             currSlot.startTimestamp = uint64(block.timestamp);
1075             currSlot.burned = true;
1076 
1077             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1078             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1079             uint256 nextTokenId = tokenId + 1;
1080             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1081             if (nextSlot.addr == address(0)) {
1082                 // This will suffice for checking _exists(nextTokenId),
1083                 // as a burned slot cannot contain the zero address.
1084                 if (nextTokenId != _currentIndex) {
1085                     nextSlot.addr = from;
1086                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1087                 }
1088             }
1089         }
1090 
1091         emit Transfer(from, address(0), tokenId);
1092         _afterTokenTransfers(from, address(0), tokenId, 1);
1093 
1094         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1095         unchecked {
1096             _burnCounter++;
1097         }
1098     }
1099 
1100     /**
1101      * @dev Approve `to` to operate on `tokenId`
1102      *
1103      * Emits a {Approval} event.
1104      */
1105     function _approve(
1106         address to,
1107         uint256 tokenId,
1108         address owner
1109     ) private {
1110         _tokenApprovals[tokenId] = to;
1111         emit Approval(owner, to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1116      *
1117      * @param from address representing the previous owner of the given token ID
1118      * @param to target address that will receive the tokens
1119      * @param tokenId uint256 ID of the token to be transferred
1120      * @param _data bytes optional data to send along with the call
1121      * @return bool whether the call correctly returned the expected magic value
1122      */
1123     function _checkContractOnERC721Received(
1124         address from,
1125         address to,
1126         uint256 tokenId,
1127         bytes memory _data
1128     ) private returns (bool) {
1129         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1130             return retval == IERC721Receiver(to).onERC721Received.selector;
1131         } catch (bytes memory reason) {
1132             if (reason.length == 0) {
1133                 revert TransferToNonERC721ReceiverImplementer();
1134             } else {
1135                 assembly {
1136                     revert(add(32, reason), mload(reason))
1137                 }
1138             }
1139         }
1140     }
1141 
1142     /**
1143      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1144      * And also called before burning one token.
1145      *
1146      * startTokenId - the first token id to be transferred
1147      * quantity - the amount to be transferred
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, `tokenId` will be burned by `from`.
1155      * - `from` and `to` are never both zero.
1156      */
1157     function _beforeTokenTransfers(
1158         address from,
1159         address to,
1160         uint256 startTokenId,
1161         uint256 quantity
1162     ) internal virtual {}
1163 
1164     /**
1165      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1166      * minting.
1167      * And also called after one token has been burned.
1168      *
1169      * startTokenId - the first token id to be transferred
1170      * quantity - the amount to be transferred
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` has been minted for `to`.
1177      * - When `to` is zero, `tokenId` has been burned by `from`.
1178      * - `from` and `to` are never both zero.
1179      */
1180     function _afterTokenTransfers(
1181         address from,
1182         address to,
1183         uint256 startTokenId,
1184         uint256 quantity
1185     ) internal virtual {}
1186 }
1187 
1188 // File @openzeppelin/contracts/utils/Counters.sol@v4.6.0
1189 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @title Counters
1195  * @author Matt Condon (@shrugs)
1196  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1197  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1198  *
1199  * Include with `using Counters for Counters.Counter;`
1200  */
1201 library Counters {
1202     struct Counter {
1203         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1204         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1205         // this feature: see https://github.com/ethereum/solidity/issues/4637
1206         uint256 _value; // default: 0
1207     }
1208 
1209     function current(Counter storage counter) internal view returns (uint256) {
1210         return counter._value;
1211     }
1212 
1213     function increment(Counter storage counter) internal {
1214         unchecked {
1215             counter._value += 1;
1216         }
1217     }
1218 
1219     function decrement(Counter storage counter) internal {
1220         uint256 value = counter._value;
1221         require(value > 0, "Counter: decrement overflow");
1222         unchecked {
1223             counter._value = value - 1;
1224         }
1225     }
1226 
1227     function reset(Counter storage counter) internal {
1228         counter._value = 0;
1229     }
1230 }
1231 
1232 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1233 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 /**
1238  * @dev Contract module which provides a basic access control mechanism, where
1239  * there is an account (an owner) that can be granted exclusive access to
1240  * specific functions.
1241  *
1242  * By default, the owner account will be the one that deploys the contract. This
1243  * can later be changed with {transferOwnership}.
1244  *
1245  * This module is used through inheritance. It will make available the modifier
1246  * `onlyOwner`, which can be applied to your functions to restrict their use to
1247  * the owner.
1248  */
1249 abstract contract Ownable is Context {
1250     address private _owner;
1251 
1252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1253 
1254     /**
1255      * @dev Initializes the contract setting the deployer as the initial owner.
1256      */
1257     constructor() {
1258         _transferOwnership(_msgSender());
1259     }
1260 
1261     /**
1262      * @dev Returns the address of the current owner.
1263      */
1264     function owner() public view virtual returns (address) {
1265         return _owner;
1266     }
1267 
1268     /**
1269      * @dev Throws if called by any account other than the owner.
1270      */
1271     modifier onlyOwner() {
1272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1273         _;
1274     }
1275 
1276     /**
1277      * @dev Leaves the contract without owner. It will not be possible to call
1278      * `onlyOwner` functions anymore. Can only be called by the current owner.
1279      *
1280      * NOTE: Renouncing ownership will leave the contract without an owner,
1281      * thereby removing any functionality that is only available to the owner.
1282      */
1283     function renounceOwnership() public virtual onlyOwner {
1284         _transferOwnership(address(0));
1285     }
1286 
1287     /**
1288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1289      * Can only be called by the current owner.
1290      */
1291     function transferOwnership(address newOwner) public virtual onlyOwner {
1292         require(newOwner != address(0), "Ownable: new owner is the zero address");
1293         _transferOwnership(newOwner);
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Internal function without access restriction.
1299      */
1300     function _transferOwnership(address newOwner) internal virtual {
1301         address oldOwner = _owner;
1302         _owner = newOwner;
1303         emit OwnershipTransferred(oldOwner, newOwner);
1304     }
1305 }
1306 
1307 
1308 // File contracts/TheNekoNFT.sol
1309 
1310 pragma solidity ^0.8.4;  
1311 contract TheNekoNFT is ERC721A , Ownable { 
1312     constructor() ERC721A("THE NEKO NFT", "NEKO") {}  
1313  
1314 	using Counters for Counters.Counter;
1315     using Strings for uint256;
1316 
1317     address payable private _PaymentAddress = payable(0x51F0f6790dd7795bD8e7C0Ab68854898Eb1FF9b5);
1318 
1319     uint256 public NEKO_MAX = 925;
1320     uint256 private NEKO_ADMIN = 2;
1321     uint256 private NEKO_PUBLIC = NEKO_MAX - NEKO_ADMIN;
1322     
1323     uint256 private PRESALE_PRICE = 0.4 ether;
1324     uint256 private PUBLIC_PRICE = 0.4 ether;
1325     uint256 private REVEAL_DELAY = 96 hours;
1326     uint256 private PRESALE_HOURS = 48 hours;
1327     uint256 private PRESALE_MINT_LIMIT = 5;
1328 	uint256 private PUBLIC_MINT_LIMIT = 3;
1329     
1330     mapping(address => bool) private _mappingWhiteList;
1331     mapping(address => uint256) private _mappingPresaleMintCount;
1332 	mapping(address => uint256) private _mappingPublicMintCount;
1333 
1334     uint256 private _activeDateTime = 1653706619; // (GMT): Saturday, May 28, 2022 2:56:59 AM
1335     string private _tokenBaseURI = "";
1336     string private _revealURI = "";
1337 	
1338 	Counters.Counter private _publicCount;
1339 
1340     function setPaymentAddress(address paymentAddress) external onlyOwner {
1341         _PaymentAddress = payable(paymentAddress);
1342     }
1343 
1344     function setActiveDateTime(uint256 activeDateTime, uint256 presaleHours, uint256 revealDelay) external onlyOwner {
1345         _activeDateTime = activeDateTime;
1346         REVEAL_DELAY = revealDelay;
1347         PRESALE_HOURS = presaleHours;
1348     }
1349 
1350     function setWhiteList(address[] memory whiteListAddress, bool bEnable) external onlyOwner {
1351         for (uint256 i = 0; i < whiteListAddress.length; i++) {
1352             _mappingWhiteList[whiteListAddress[i]] = bEnable;
1353         }
1354     }
1355 
1356     function isWhiteListed(address addr) public view returns (bool) {
1357         return _mappingWhiteList[addr];
1358     }
1359 
1360     function setMintPrice(uint256 presaleMintPrice, uint256 publicMintPrice) external onlyOwner {
1361         PRESALE_PRICE = presaleMintPrice; // Y
1362         PUBLIC_PRICE = publicMintPrice;  // Z
1363     }
1364 
1365     function setPresaleMintMaxLimit(uint256 presaleMintLimit) external onlyOwner {
1366         PRESALE_MINT_LIMIT = presaleMintLimit;
1367     }
1368 	
1369     function setPublicMintMaxLimit(uint256 publicMintLimit) external onlyOwner {
1370         PUBLIC_MINT_LIMIT = publicMintLimit;
1371     }
1372 
1373     function setRevealURI(string memory revealURI) external onlyOwner {
1374         _revealURI = revealURI;
1375     }
1376 
1377     function setBaseURI(string memory baseURI) external onlyOwner {
1378         _tokenBaseURI = baseURI;
1379     }
1380 
1381     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory)
1382     {
1383         require(_exists(tokenId), "Token does not exist");
1384         if (_activeDateTime + REVEAL_DELAY < block.timestamp) {
1385             return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1386         }
1387         return _revealURI;
1388     }
1389 
1390     function withdraw() external onlyOwner {
1391         uint256 balance = address(this).balance;
1392         payable(msg.sender).transfer(balance);
1393     }
1394 
1395     function price() public view returns (uint256) {
1396         if (block.timestamp < _activeDateTime) {
1397             return PRESALE_PRICE;
1398         } else {
1399             return PUBLIC_PRICE;
1400         }
1401     }
1402 
1403     function adminMint(uint256 adminMintAmt) external onlyOwner {
1404         require(block.timestamp < _activeDateTime, "Whitelist started already");
1405         require(0 < adminMintAmt && adminMintAmt < NEKO_MAX, "Admin Mint Amount must lower than NEKO_MAX");
1406         NEKO_ADMIN = adminMintAmt;
1407         NEKO_PUBLIC = NEKO_MAX - NEKO_ADMIN;
1408 		for (uint256 i = 0; i < NEKO_ADMIN; i++) {
1409 			_publicCount.increment();
1410 		}
1411         _safeMint(msg.sender, NEKO_ADMIN);
1412     }
1413 
1414     function purchase(uint256 numberOfTokens) external payable {
1415         require(msg.sender != owner(),"You are owner!");
1416         require(price() * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1417 		require(numberOfTokens + _publicCount.current() < NEKO_MAX, "Purchase would exceed NEKO_MAX");
1418 
1419         if (block.timestamp < _activeDateTime) {
1420             require(_mappingWhiteList[msg.sender] == true, "Not registered to WhiteList");   
1421             require(block.timestamp > _activeDateTime - PRESALE_HOURS , "Mint is not activated for presale");
1422             require(_mappingPresaleMintCount[msg.sender] + numberOfTokens <= PRESALE_MINT_LIMIT,"Amount to high for PRESALE_MINT_LIMIT");
1423             _mappingPresaleMintCount[msg.sender] = _mappingPresaleMintCount[msg.sender] + numberOfTokens;
1424         } else {
1425 			require(block.timestamp > _activeDateTime, "Mint is not activated for public sale");
1426 			require(_mappingPublicMintCount[msg.sender] + numberOfTokens <= PUBLIC_MINT_LIMIT, "Amount to high for PUBLIC_MINT_LIMIT");
1427 			_mappingPublicMintCount[msg.sender] = _mappingPublicMintCount[msg.sender] + numberOfTokens;
1428 		}
1429 		
1430 		for (uint256 i = 0; i < numberOfTokens; i++) {
1431 			_publicCount.increment();
1432 		}
1433 		_PaymentAddress.transfer(msg.value);
1434 		_safeMint(msg.sender, numberOfTokens);
1435     }    
1436 }