1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/utils/Address.sol
102 
103 
104 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
105 
106 pragma solidity ^0.8.1;
107 
108 /**
109  * @dev Collection of functions related to the address type
110  */
111 library Address {
112     /**
113      * @dev Returns true if `account` is a contract.
114      *
115      * [IMPORTANT]
116      * ====
117      * It is unsafe to assume that an address for which this function returns
118      * false is an externally-owned account (EOA) and not a contract.
119      *
120      * Among others, `isContract` will return false for the following
121      * types of addresses:
122      *
123      *  - an externally-owned account
124      *  - a contract in construction
125      *  - an address where a contract will be created
126      *  - an address where a contract lived, but was destroyed
127      * ====
128      *
129      * [IMPORTANT]
130      * ====
131      * You shouldn't rely on `isContract` to protect against flash loan attacks!
132      *
133      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
134      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
135      * constructor.
136      * ====
137      */
138     function isContract(address account) internal view returns (bool) {
139         // This method relies on extcodesize/address.code.length, which returns 0
140         // for contracts in construction, since the code is only stored at the end
141         // of the constructor execution.
142 
143         return account.code.length > 0;
144     }
145 
146     /**
147      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
148      * `recipient`, forwarding all available gas and reverting on errors.
149      *
150      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
151      * of certain opcodes, possibly making contracts go over the 2300 gas limit
152      * imposed by `transfer`, making them unable to receive funds via
153      * `transfer`. {sendValue} removes this limitation.
154      *
155      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
156      *
157      * IMPORTANT: because control is transferred to `recipient`, care must be
158      * taken to not create reentrancy vulnerabilities. Consider using
159      * {ReentrancyGuard} or the
160      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
161      */
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(address(this).balance >= amount, "Address: insufficient balance");
164 
165         (bool success, ) = recipient.call{value: amount}("");
166         require(success, "Address: unable to send value, recipient may have reverted");
167     }
168 
169     /**
170      * @dev Performs a Solidity function call using a low level `call`. A
171      * plain `call` is an unsafe replacement for a function call: use this
172      * function instead.
173      *
174      * If `target` reverts with a revert reason, it is bubbled up by this
175      * function (like regular Solidity function calls).
176      *
177      * Returns the raw returned data. To convert to the expected return value,
178      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
179      *
180      * Requirements:
181      *
182      * - `target` must be a contract.
183      * - calling `target` with `data` must not revert.
184      *
185      * _Available since v3.1._
186      */
187     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionCall(target, data, "Address: low-level call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
193      * `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but also transferring `value` wei to `target`.
208      *
209      * Requirements:
210      *
211      * - the calling contract must have an ETH balance of at least `value`.
212      * - the called Solidity function must be `payable`.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
226      * with `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(
231         address target,
232         bytes memory data,
233         uint256 value,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         require(address(this).balance >= value, "Address: insufficient balance for call");
237         require(isContract(target), "Address: call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.call{value: value}(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
250         return functionStaticCall(target, data, "Address: low-level static call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal view returns (bytes memory) {
264         require(isContract(target), "Address: static call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.staticcall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(isContract(target), "Address: delegate call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.delegatecall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
299      * revert reason using the provided one.
300      *
301      * _Available since v4.3._
302      */
303     function verifyCallResult(
304         bool success,
305         bytes memory returndata,
306         string memory errorMessage
307     ) internal pure returns (bytes memory) {
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 assembly {
316                     let returndata_size := mload(returndata)
317                     revert(add(32, returndata), returndata_size)
318                 }
319             } else {
320                 revert(errorMessage);
321             }
322         }
323     }
324 }
325 
326 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @title ERC721 token receiver interface
335  * @dev Interface for any contract that wants to support safeTransfers
336  * from ERC721 asset contracts.
337  */
338 interface IERC721Receiver {
339     /**
340      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
341      * by `operator` from `from`, this function is called.
342      *
343      * It must return its Solidity selector to confirm the token transfer.
344      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
345      *
346      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
347      */
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Interface of the ERC165 standard, as defined in the
365  * https://eips.ethereum.org/EIPS/eip-165[EIP].
366  *
367  * Implementers can declare support of contract interfaces, which can then be
368  * queried by others ({ERC165Checker}).
369  *
370  * For an implementation, see {ERC165}.
371  */
372 interface IERC165 {
373     /**
374      * @dev Returns true if this contract implements the interface defined by
375      * `interfaceId`. See the corresponding
376      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
377      * to learn more about how these ids are created.
378      *
379      * This function call must use less than 30 000 gas.
380      */
381     function supportsInterface(bytes4 interfaceId) external view returns (bool);
382 }
383 
384 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 
392 /**
393  * @dev Implementation of the {IERC165} interface.
394  *
395  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
396  * for the additional interface id that will be supported. For example:
397  *
398  * ```solidity
399  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
400  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
401  * }
402  * ```
403  *
404  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
405  */
406 abstract contract ERC165 is IERC165 {
407     /**
408      * @dev See {IERC165-supportsInterface}.
409      */
410     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
411         return interfaceId == type(IERC165).interfaceId;
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Required interface of an ERC721 compliant contract.
425  */
426 interface IERC721 is IERC165 {
427     /**
428      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
429      */
430     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
431 
432     /**
433      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
434      */
435     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
436 
437     /**
438      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
439      */
440     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
441 
442     /**
443      * @dev Returns the number of tokens in ``owner``'s account.
444      */
445     function balanceOf(address owner) external view returns (uint256 balance);
446 
447     /**
448      * @dev Returns the owner of the `tokenId` token.
449      *
450      * Requirements:
451      *
452      * - `tokenId` must exist.
453      */
454     function ownerOf(uint256 tokenId) external view returns (address owner);
455 
456     /**
457      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
458      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must exist and be owned by `from`.
465      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Transfers `tokenId` token from `from` to `to`.
478      *
479      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must be owned by `from`.
486      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
487      *
488      * Emits a {Transfer} event.
489      */
490     function transferFrom(
491         address from,
492         address to,
493         uint256 tokenId
494     ) external;
495 
496     /**
497      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
498      * The approval is cleared when the token is transferred.
499      *
500      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
501      *
502      * Requirements:
503      *
504      * - The caller must own the token or be an approved operator.
505      * - `tokenId` must exist.
506      *
507      * Emits an {Approval} event.
508      */
509     function approve(address to, uint256 tokenId) external;
510 
511     /**
512      * @dev Returns the account approved for `tokenId` token.
513      *
514      * Requirements:
515      *
516      * - `tokenId` must exist.
517      */
518     function getApproved(uint256 tokenId) external view returns (address operator);
519 
520     /**
521      * @dev Approve or remove `operator` as an operator for the caller.
522      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
523      *
524      * Requirements:
525      *
526      * - The `operator` cannot be the caller.
527      *
528      * Emits an {ApprovalForAll} event.
529      */
530     function setApprovalForAll(address operator, bool _approved) external;
531 
532     /**
533      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
534      *
535      * See {setApprovalForAll}
536      */
537     function isApprovedForAll(address owner, address operator) external view returns (bool);
538 
539     /**
540      * @dev Safely transfers `tokenId` token from `from` to `to`.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must exist and be owned by `from`.
547      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
548      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
549      *
550      * Emits a {Transfer} event.
551      */
552     function safeTransferFrom(
553         address from,
554         address to,
555         uint256 tokenId,
556         bytes calldata data
557     ) external;
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
570  * @dev See https://eips.ethereum.org/EIPS/eip-721
571  */
572 interface IERC721Metadata is IERC721 {
573     /**
574      * @dev Returns the token collection name.
575      */
576     function name() external view returns (string memory);
577 
578     /**
579      * @dev Returns the token collection symbol.
580      */
581     function symbol() external view returns (string memory);
582 
583     /**
584      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
585      */
586     function tokenURI(uint256 tokenId) external view returns (string memory);
587 }
588 
589 // File: contracts/new.sol
590 
591 
592 
593 
594 pragma solidity ^0.8.4;
595 
596 
597 
598 
599 
600 
601 
602 
603 error ApprovalCallerNotOwnerNorApproved();
604 error ApprovalQueryForNonexistentToken();
605 error ApproveToCaller();
606 error ApprovalToCurrentOwner();
607 error BalanceQueryForZeroAddress();
608 error MintToZeroAddress();
609 error MintZeroQuantity();
610 error OwnerQueryForNonexistentToken();
611 error TransferCallerNotOwnerNorApproved();
612 error TransferFromIncorrectOwner();
613 error TransferToNonERC721ReceiverImplementer();
614 error TransferToZeroAddress();
615 error URIQueryForNonexistentToken();
616 
617 /**
618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
619  * the Metadata extension. Built to optimize for lower gas during batch mints.
620  *
621  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
622  *
623  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
624  *
625  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
626  */
627 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
628     using Address for address;
629     using Strings for uint256;
630 
631     // Compiler will pack this into a single 256bit word.
632     struct TokenOwnership {
633         // The address of the owner.
634         address addr;
635         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
636         uint64 startTimestamp;
637         // Whether the token has been burned.
638         bool burned;
639     }
640 
641     // Compiler will pack this into a single 256bit word.
642     struct AddressData {
643         // Realistically, 2**64-1 is more than enough.
644         uint64 balance;
645         // Keeps track of mint count with minimal overhead for tokenomics.
646         uint64 numberMinted;
647         // Keeps track of burn count with minimal overhead for tokenomics.
648         uint64 numberBurned;
649         // For miscellaneous variable(s) pertaining to the address
650         // (e.g. number of whitelist mint slots used).
651         // If there are multiple variables, please pack them into a uint64.
652         uint64 aux;
653     }
654 
655     // The tokenId of the next token to be minted.
656     uint256 internal _currentIndex;
657 
658     // The number of tokens burned.
659     uint256 internal _burnCounter;
660 
661     // Token name
662     string private _name;
663 
664     // Token symbol
665     string private _symbol;
666 
667     // Mapping from token ID to ownership details
668     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
669     mapping(uint256 => TokenOwnership) internal _ownerships;
670 
671     // Mapping owner address to address data
672     mapping(address => AddressData) private _addressData;
673 
674     // Mapping from token ID to approved address
675     mapping(uint256 => address) private _tokenApprovals;
676 
677     // Mapping from owner to operator approvals
678     mapping(address => mapping(address => bool)) private _operatorApprovals;
679 
680     constructor(string memory name_, string memory symbol_) {
681         _name = name_;
682         _symbol = symbol_;
683         _currentIndex = _startTokenId();
684     }
685 
686     /**
687      * To change the starting tokenId, please override this function.
688      */
689     function _startTokenId() internal view virtual returns (uint256) {
690         return 1;
691     }
692 
693     /**
694      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
695      */
696     function totalSupply() public view returns (uint256) {
697         // Counter underflow is impossible as _burnCounter cannot be incremented
698         // more than _currentIndex - _startTokenId() times
699         unchecked {
700             return _currentIndex - _burnCounter - _startTokenId();
701         }
702     }
703 
704     /**
705      * Returns the total amount of tokens minted in the contract.
706      */
707     function _totalMinted() internal view returns (uint256) {
708         // Counter underflow is impossible as _currentIndex does not decrement,
709         // and it is initialized to _startTokenId()
710         unchecked {
711             return _currentIndex - _startTokenId();
712         }
713     }
714 
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
719         return
720             interfaceId == type(IERC721).interfaceId ||
721             interfaceId == type(IERC721Metadata).interfaceId ||
722             super.supportsInterface(interfaceId);
723     }
724 
725     /**
726      * @dev See {IERC721-balanceOf}.
727      */
728     function balanceOf(address owner) public view override returns (uint256) {
729         if (owner == address(0)) revert BalanceQueryForZeroAddress();
730         return uint256(_addressData[owner].balance);
731     }
732 
733     /**
734      * Returns the number of tokens minted by `owner`.
735      */
736     function _numberMinted(address owner) internal view returns (uint256) {
737         return uint256(_addressData[owner].numberMinted);
738     }
739 
740     /**
741      * Returns the number of tokens burned by or on behalf of `owner`.
742      */
743     function _numberBurned(address owner) internal view returns (uint256) {
744         return uint256(_addressData[owner].numberBurned);
745     }
746 
747     /**
748      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
749      */
750     function _getAux(address owner) internal view returns (uint64) {
751         return _addressData[owner].aux;
752     }
753 
754     /**
755      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
756      * If there are multiple variables, please pack them into a uint64.
757      */
758     function _setAux(address owner, uint64 aux) internal {
759         _addressData[owner].aux = aux;
760     }
761 
762     /**
763      * Gas spent here starts off proportional to the maximum mint batch size.
764      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
765      */
766     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
767         uint256 curr = tokenId;
768 
769         unchecked {
770             if (_startTokenId() <= curr && curr < _currentIndex) {
771                 TokenOwnership memory ownership = _ownerships[curr];
772                 if (!ownership.burned) {
773                     if (ownership.addr != address(0)) {
774                         return ownership;
775                     }
776                     // Invariant:
777                     // There will always be an ownership that has an address and is not burned
778                     // before an ownership that does not have an address and is not burned.
779                     // Hence, curr will not underflow.
780                     while (true) {
781                         curr--;
782                         ownership = _ownerships[curr];
783                         if (ownership.addr != address(0)) {
784                             return ownership;
785                         }
786                     }
787                 }
788             }
789         }
790         revert OwnerQueryForNonexistentToken();
791     }
792 
793     /**
794      * @dev See {IERC721-ownerOf}.
795      */
796     function ownerOf(uint256 tokenId) public view override returns (address) {
797         return _ownershipOf(tokenId).addr;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-name}.
802      */
803     function name() public view virtual override returns (string memory) {
804         return _name;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-symbol}.
809      */
810     function symbol() public view virtual override returns (string memory) {
811         return _symbol;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-tokenURI}.
816      */
817     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
818         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
819 
820         string memory baseURI = _baseURI();
821         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
822     }
823 
824     /**
825      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
826      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
827      * by default, can be overriden in child contracts.
828      */
829     function _baseURI() internal view virtual returns (string memory) {
830         return '';
831     }
832 
833     /**
834      * @dev See {IERC721-approve}.
835      */
836     function approve(address to, uint256 tokenId) public override {
837         address owner = ERC721A.ownerOf(tokenId);
838         if (to == owner) revert ApprovalToCurrentOwner();
839 
840         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
841             revert ApprovalCallerNotOwnerNorApproved();
842         }
843 
844         _approve(to, tokenId, owner);
845     }
846 
847     /**
848      * @dev See {IERC721-getApproved}.
849      */
850     function getApproved(uint256 tokenId) public view override returns (address) {
851         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
852 
853         return _tokenApprovals[tokenId];
854     }
855 
856     /**
857      * @dev See {IERC721-setApprovalForAll}.
858      */
859     function setApprovalForAll(address operator, bool approved) public virtual override {
860         if (operator == _msgSender()) revert ApproveToCaller();
861 
862         _operatorApprovals[_msgSender()][operator] = approved;
863         emit ApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         _transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         safeTransferFrom(from, to, tokenId, '');
893     }
894 
895     /**
896      * @dev See {IERC721-safeTransferFrom}.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) public virtual override {
904         _transfer(from, to, tokenId);
905         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
906             revert TransferToNonERC721ReceiverImplementer();
907         }
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      */
917     function _exists(uint256 tokenId) internal view returns (bool) {
918         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
919             !_ownerships[tokenId].burned;
920     }
921 
922     function _safeMint(address to, uint256 quantity) internal {
923         _safeMint(to, quantity, '');
924     }
925 
926     /**
927      * @dev Safely mints `quantity` tokens and transfers them to `to`.
928      *
929      * Requirements:
930      *
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
932      * - `quantity` must be greater than 0.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(
937         address to,
938         uint256 quantity,
939         bytes memory _data
940     ) internal {
941         _mint(to, quantity, _data, true);
942     }
943 
944     /**
945      * @dev Mints `quantity` tokens and transfers them to `to`.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `quantity` must be greater than 0.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _mint(
955         address to,
956         uint256 quantity,
957         bytes memory _data,
958         bool safe
959     ) internal {
960         uint256 startTokenId = _currentIndex;
961         if (to == address(0)) revert MintToZeroAddress();
962         if (quantity == 0) revert MintZeroQuantity();
963 
964         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
965 
966         // Overflows are incredibly unrealistic.
967         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
968         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
969         unchecked {
970             _addressData[to].balance += uint64(quantity);
971             _addressData[to].numberMinted += uint64(quantity);
972 
973             _ownerships[startTokenId].addr = to;
974             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
975 
976             uint256 updatedIndex = startTokenId;
977             uint256 end = updatedIndex + quantity;
978 
979             if (safe && to.isContract()) {
980                 do {
981                     emit Transfer(address(0), to, updatedIndex);
982                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
983                         revert TransferToNonERC721ReceiverImplementer();
984                     }
985                 } while (updatedIndex != end);
986                 // Reentrancy protection
987                 if (_currentIndex != startTokenId) revert();
988             } else {
989                 do {
990                     emit Transfer(address(0), to, updatedIndex++);
991                 } while (updatedIndex != end);
992             }
993             _currentIndex = updatedIndex;
994         }
995         _afterTokenTransfers(address(0), to, startTokenId, quantity);
996     }
997 
998     /**
999      * @dev Transfers `tokenId` from `from` to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must be owned by `from`.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _transfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) private {
1013         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1014 
1015         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1016 
1017         bool isApprovedOrOwner = (_msgSender() == from ||
1018             isApprovedForAll(from, _msgSender()) ||
1019             getApproved(tokenId) == _msgSender());
1020 
1021         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1022         if (to == address(0)) revert TransferToZeroAddress();
1023 
1024         _beforeTokenTransfers(from, to, tokenId, 1);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId, from);
1028 
1029         // Underflow of the sender's balance is impossible because we check for
1030         // ownership above and the recipient's balance can't realistically overflow.
1031         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1032         unchecked {
1033             _addressData[from].balance -= 1;
1034             _addressData[to].balance += 1;
1035 
1036             TokenOwnership storage currSlot = _ownerships[tokenId];
1037             currSlot.addr = to;
1038             currSlot.startTimestamp = uint64(block.timestamp);
1039 
1040             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1041             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1042             uint256 nextTokenId = tokenId + 1;
1043             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1044             if (nextSlot.addr == address(0)) {
1045                 // This will suffice for checking _exists(nextTokenId),
1046                 // as a burned slot cannot contain the zero address.
1047                 if (nextTokenId != _currentIndex) {
1048                     nextSlot.addr = from;
1049                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1050                 }
1051             }
1052         }
1053 
1054         emit Transfer(from, to, tokenId);
1055         _afterTokenTransfers(from, to, tokenId, 1);
1056     }
1057 
1058     /**
1059      * @dev This is equivalent to _burn(tokenId, false)
1060      */
1061     function _burn(uint256 tokenId) internal virtual {
1062         _burn(tokenId, false);
1063     }
1064 
1065     /**
1066      * @dev Destroys `tokenId`.
1067      * The approval is cleared when the token is burned.
1068      *
1069      * Requirements:
1070      *
1071      * - `tokenId` must exist.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1076         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1077 
1078         address from = prevOwnership.addr;
1079 
1080         if (approvalCheck) {
1081             bool isApprovedOrOwner = (_msgSender() == from ||
1082                 isApprovedForAll(from, _msgSender()) ||
1083                 getApproved(tokenId) == _msgSender());
1084 
1085             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1086         }
1087 
1088         _beforeTokenTransfers(from, address(0), tokenId, 1);
1089 
1090         // Clear approvals from the previous owner
1091         _approve(address(0), tokenId, from);
1092 
1093         // Underflow of the sender's balance is impossible because we check for
1094         // ownership above and the recipient's balance can't realistically overflow.
1095         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1096         unchecked {
1097             AddressData storage addressData = _addressData[from];
1098             addressData.balance -= 1;
1099             addressData.numberBurned += 1;
1100 
1101             // Keep track of who burned the token, and the timestamp of burning.
1102             TokenOwnership storage currSlot = _ownerships[tokenId];
1103             currSlot.addr = from;
1104             currSlot.startTimestamp = uint64(block.timestamp);
1105             currSlot.burned = true;
1106 
1107             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1108             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1109             uint256 nextTokenId = tokenId + 1;
1110             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1111             if (nextSlot.addr == address(0)) {
1112                 // This will suffice for checking _exists(nextTokenId),
1113                 // as a burned slot cannot contain the zero address.
1114                 if (nextTokenId != _currentIndex) {
1115                     nextSlot.addr = from;
1116                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1117                 }
1118             }
1119         }
1120 
1121         emit Transfer(from, address(0), tokenId);
1122         _afterTokenTransfers(from, address(0), tokenId, 1);
1123 
1124         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1125         unchecked {
1126             _burnCounter++;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(
1136         address to,
1137         uint256 tokenId,
1138         address owner
1139     ) private {
1140         _tokenApprovals[tokenId] = to;
1141         emit Approval(owner, to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1146      *
1147      * @param from address representing the previous owner of the given token ID
1148      * @param to target address that will receive the tokens
1149      * @param tokenId uint256 ID of the token to be transferred
1150      * @param _data bytes optional data to send along with the call
1151      * @return bool whether the call correctly returned the expected magic value
1152      */
1153     function _checkContractOnERC721Received(
1154         address from,
1155         address to,
1156         uint256 tokenId,
1157         bytes memory _data
1158     ) private returns (bool) {
1159         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1160             return retval == IERC721Receiver(to).onERC721Received.selector;
1161         } catch (bytes memory reason) {
1162             if (reason.length == 0) {
1163                 revert TransferToNonERC721ReceiverImplementer();
1164             } else {
1165                 assembly {
1166                     revert(add(32, reason), mload(reason))
1167                 }
1168             }
1169         }
1170     }
1171 
1172     /**
1173      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1174      * And also called before burning one token.
1175      *
1176      * startTokenId - the first token id to be transferred
1177      * quantity - the amount to be transferred
1178      *
1179      * Calling conditions:
1180      *
1181      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1182      * transferred to `to`.
1183      * - When `from` is zero, `tokenId` will be minted for `to`.
1184      * - When `to` is zero, `tokenId` will be burned by `from`.
1185      * - `from` and `to` are never both zero.
1186      */
1187     function _beforeTokenTransfers(
1188         address from,
1189         address to,
1190         uint256 startTokenId,
1191         uint256 quantity
1192     ) internal virtual {}
1193 
1194     /**
1195      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1196      * minting.
1197      * And also called after one token has been burned.
1198      *
1199      * startTokenId - the first token id to be transferred
1200      * quantity - the amount to be transferred
1201      *
1202      * Calling conditions:
1203      *
1204      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1205      * transferred to `to`.
1206      * - When `from` is zero, `tokenId` has been minted for `to`.
1207      * - When `to` is zero, `tokenId` has been burned by `from`.
1208      * - `from` and `to` are never both zero.
1209      */
1210     function _afterTokenTransfers(
1211         address from,
1212         address to,
1213         uint256 startTokenId,
1214         uint256 quantity
1215     ) internal virtual {}
1216 }
1217 pragma solidity ^0.8.0;
1218 
1219 /**
1220  * @dev These functions deal with verification of Merkle Trees proofs.
1221  *
1222  * The proofs can be generated using the JavaScript library
1223  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1224  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1225  *
1226  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1227  */
1228 library MerkleProof {
1229     /**
1230      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1231      * defined by `root`. For this, a `proof` must be provided, containing
1232      * sibling hashes on the branch from the leaf to the root of the tree. Each
1233      * pair of leaves and each pair of pre-images are assumed to be sorted.
1234      */
1235     function verify(
1236         bytes32[] memory proof,
1237         bytes32 root,
1238         bytes32 leaf
1239     ) internal pure returns (bool) {
1240         return processProof(proof, leaf) == root;
1241     }
1242 
1243     /**
1244      * @dev Calldata version of {verify}
1245      *
1246      * _Available since v4.7._
1247      */
1248     function verifyCalldata(
1249         bytes32[] calldata proof,
1250         bytes32 root,
1251         bytes32 leaf
1252     ) internal pure returns (bool) {
1253         return processProofCalldata(proof, leaf) == root;
1254     }
1255 
1256     /**
1257      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1258      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1259      * hash matches the root of the tree. When processing the proof, the pairs
1260      * of leafs & pre-images are assumed to be sorted.
1261      *
1262      * _Available since v4.4._
1263      */
1264     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1265         bytes32 computedHash = leaf;
1266         for (uint256 i = 0; i < proof.length; i++) {
1267             computedHash = _hashPair(computedHash, proof[i]);
1268         }
1269         return computedHash;
1270     }
1271 
1272     /**
1273      * @dev Calldata version of {processProof}
1274      *
1275      * _Available since v4.7._
1276      */
1277     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1278         bytes32 computedHash = leaf;
1279         for (uint256 i = 0; i < proof.length; i++) {
1280             computedHash = _hashPair(computedHash, proof[i]);
1281         }
1282         return computedHash;
1283     }
1284 
1285     /**
1286      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1287      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1288      *
1289      * _Available since v4.7._
1290      */
1291     function multiProofVerify(
1292         bytes32[] memory proof,
1293         bool[] memory proofFlags,
1294         bytes32 root,
1295         bytes32[] memory leaves
1296     ) internal pure returns (bool) {
1297         return processMultiProof(proof, proofFlags, leaves) == root;
1298     }
1299 
1300     /**
1301      * @dev Calldata version of {multiProofVerify}
1302      *
1303      * _Available since v4.7._
1304      */
1305     function multiProofVerifyCalldata(
1306         bytes32[] calldata proof,
1307         bool[] calldata proofFlags,
1308         bytes32 root,
1309         bytes32[] memory leaves
1310     ) internal pure returns (bool) {
1311         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1312     }
1313 
1314     /**
1315      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1316      * consuming from one or the other at each step according to the instructions given by
1317      * `proofFlags`.
1318      *
1319      * _Available since v4.7._
1320      */
1321     function processMultiProof(
1322         bytes32[] memory proof,
1323         bool[] memory proofFlags,
1324         bytes32[] memory leaves
1325     ) internal pure returns (bytes32 merkleRoot) {
1326         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1327         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1328         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1329         // the merkle tree.
1330         uint256 leavesLen = leaves.length;
1331         uint256 totalHashes = proofFlags.length;
1332 
1333         // Check proof validity.
1334         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1335 
1336         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1337         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1338         bytes32[] memory hashes = new bytes32[](totalHashes);
1339         uint256 leafPos = 0;
1340         uint256 hashPos = 0;
1341         uint256 proofPos = 0;
1342         // At each step, we compute the next hash using two values:
1343         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1344         //   get the next hash.
1345         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1346         //   `proof` array.
1347         for (uint256 i = 0; i < totalHashes; i++) {
1348             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1349             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1350             hashes[i] = _hashPair(a, b);
1351         }
1352 
1353         if (totalHashes > 0) {
1354             return hashes[totalHashes - 1];
1355         } else if (leavesLen > 0) {
1356             return leaves[0];
1357         } else {
1358             return proof[0];
1359         }
1360     }
1361 
1362     /**
1363      * @dev Calldata version of {processMultiProof}
1364      *
1365      * _Available since v4.7._
1366      */
1367     function processMultiProofCalldata(
1368         bytes32[] calldata proof,
1369         bool[] calldata proofFlags,
1370         bytes32[] memory leaves
1371     ) internal pure returns (bytes32 merkleRoot) {
1372         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1373         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1374         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1375         // the merkle tree.
1376         uint256 leavesLen = leaves.length;
1377         uint256 totalHashes = proofFlags.length;
1378 
1379         // Check proof validity.
1380         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1381 
1382         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1383         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1384         bytes32[] memory hashes = new bytes32[](totalHashes);
1385         uint256 leafPos = 0;
1386         uint256 hashPos = 0;
1387         uint256 proofPos = 0;
1388         // At each step, we compute the next hash using two values:
1389         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1390         //   get the next hash.
1391         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1392         //   `proof` array.
1393         for (uint256 i = 0; i < totalHashes; i++) {
1394             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1395             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1396             hashes[i] = _hashPair(a, b);
1397         }
1398 
1399         if (totalHashes > 0) {
1400             return hashes[totalHashes - 1];
1401         } else if (leavesLen > 0) {
1402             return leaves[0];
1403         } else {
1404             return proof[0];
1405         }
1406     }
1407 
1408     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1409         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1410     }
1411 
1412     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1413         /// @solidity memory-safe-assembly
1414         assembly {
1415             mstore(0x00, a)
1416             mstore(0x20, b)
1417             value := keccak256(0x00, 0x40)
1418         }
1419     }
1420 }
1421 abstract contract Ownable is Context {
1422     address private _owner;
1423 
1424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1425 
1426     /**
1427      * @dev Initializes the contract setting the deployer as the initial owner.
1428      */
1429     constructor() {
1430         _transferOwnership(_msgSender());
1431     }
1432 
1433     /**
1434      * @dev Returns the address of the current owner.
1435      */
1436     function owner() public view virtual returns (address) {
1437         return _owner;
1438     }
1439 
1440     /**
1441      * @dev Throws if called by any account other than the owner.
1442      */
1443     modifier onlyOwner() {
1444         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1445         _;
1446     }
1447 
1448     /**
1449      * @dev Leaves the contract without owner. It will not be possible to call
1450      * `onlyOwner` functions anymore. Can only be called by the current owner.
1451      *
1452      * NOTE: Renouncing ownership will leave the contract without an owner,
1453      * thereby removing any functionality that is only available to the owner.
1454      */
1455     function renounceOwnership() public virtual onlyOwner {
1456         _transferOwnership(address(0));
1457     }
1458 
1459     /**
1460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1461      * Can only be called by the current owner.
1462      */
1463     function transferOwnership(address newOwner) public virtual onlyOwner {
1464         require(newOwner != address(0), "Ownable: new owner is the zero address");
1465         _transferOwnership(newOwner);
1466     }
1467 
1468     /**
1469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1470      * Internal function without access restriction.
1471      */
1472     function _transferOwnership(address newOwner) internal virtual {
1473         address oldOwner = _owner;
1474         _owner = newOwner;
1475         emit OwnershipTransferred(oldOwner, newOwner);
1476     }
1477 }
1478 
1479 pragma solidity ^0.8.13;
1480 
1481 interface IOperatorFilterRegistry {
1482     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1483     function register(address registrant) external;
1484     function registerAndSubscribe(address registrant, address subscription) external;
1485     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1486     function updateOperator(address registrant, address operator, bool filtered) external;
1487     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1488     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1489     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1490     function subscribe(address registrant, address registrantToSubscribe) external;
1491     function unsubscribe(address registrant, bool copyExistingEntries) external;
1492     function subscriptionOf(address addr) external returns (address registrant);
1493     function subscribers(address registrant) external returns (address[] memory);
1494     function subscriberAt(address registrant, uint256 index) external returns (address);
1495     function copyEntriesOf(address registrant, address registrantToCopy) external;
1496     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1497     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1498     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1499     function filteredOperators(address addr) external returns (address[] memory);
1500     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1501     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1502     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1503     function isRegistered(address addr) external returns (bool);
1504     function codeHashOf(address addr) external returns (bytes32);
1505 }
1506 pragma solidity ^0.8.13;
1507 
1508 
1509 
1510 abstract contract OperatorFilterer {
1511     error OperatorNotAllowed(address operator);
1512 
1513     IOperatorFilterRegistry constant operatorFilterRegistry =
1514         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1515 
1516     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1517         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1518         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1519         // order for the modifier to filter addresses.
1520         if (address(operatorFilterRegistry).code.length > 0) {
1521             if (subscribe) {
1522                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1523             } else {
1524                 if (subscriptionOrRegistrantToCopy != address(0)) {
1525                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1526                 } else {
1527                     operatorFilterRegistry.register(address(this));
1528                 }
1529             }
1530         }
1531     }
1532 
1533     modifier onlyAllowedOperator(address from) virtual {
1534         // Check registry code length to facilitate testing in environments without a deployed registry.
1535         if (address(operatorFilterRegistry).code.length > 0) {
1536             // Allow spending tokens from addresses with balance
1537             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1538             // from an EOA.
1539             if (from == msg.sender) {
1540                 _;
1541                 return;
1542             }
1543             if (
1544                 !(
1545                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1546                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1547                 )
1548             ) {
1549                 revert OperatorNotAllowed(msg.sender);
1550             }
1551         }
1552         _;
1553     }
1554 }
1555 pragma solidity ^0.8.13;
1556 
1557 
1558 
1559 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1560     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1561 
1562     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1563 }
1564     pragma solidity ^0.8.13;
1565     
1566     contract HustlersMarketPass is ERC721A, DefaultOperatorFilterer , Ownable {
1567     using Strings for uint256;
1568 
1569 
1570   string private uriPrefix = "ipfs://QmU7jwNYtxSzfbNeAHtTaHwWnykqnwU11jtb5f1DunYppv/";
1571   string private uriSuffix = ".json";
1572  
1573 
1574   uint16 public constant maxSupply = 8000;
1575  
1576                                                              
1577   bool public WLpaused = true;
1578   bool public paused = true;
1579 
1580   mapping (address => uint8) public NFTPerWLAddress;
1581   mapping (address => uint8) public NFTPerAddress;
1582   uint8 public maxMintAmountPerWallet = 1;  
1583   
1584   
1585   bytes32 public whitelistMerkleRoot = 0x7e00bf1322941382c1009b87d1a7b45c9d2da6100a02cc608f41c183c7153a63;
1586   
1587 
1588   constructor() ERC721A("Hustlers MarketPass", "Hustlers MarketPass") {
1589   }
1590 
1591   
1592  
1593   function mint(uint8 _mintAmount) external  {
1594      uint16 totalSupply = uint16(totalSupply());
1595     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1596     uint8 _txPerAddress = NFTPerAddress[msg.sender];
1597      require (_txPerAddress + _mintAmount <= maxMintAmountPerWallet, "Exceeds max nft limit per address");
1598 
1599     require(!paused, "The contract is paused!");
1600    
1601     NFTPerAddress[msg.sender] = _txPerAddress + _mintAmount;
1602     _safeMint(msg.sender , _mintAmount);
1603      
1604      delete totalSupply;
1605      delete _mintAmount;
1606   }
1607   
1608   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1609      uint16 totalSupply = uint16(totalSupply());
1610     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1611      _safeMint(_receiver , _mintAmount);
1612      delete _mintAmount;
1613      delete _receiver;
1614      delete totalSupply;
1615   }
1616 
1617 
1618    
1619   function tokenURI(uint256 _tokenId)
1620     public
1621     view
1622     virtual
1623     override
1624     returns (string memory)
1625   {
1626     require(
1627       _exists(_tokenId),
1628       "ERC721Metadata: URI query for nonexistent token"
1629     );
1630     
1631   
1632 
1633     string memory currentBaseURI = _baseURI();
1634     return bytes(currentBaseURI).length > 0
1635         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1636         : "";
1637   }
1638  
1639    function setWLPaused() external onlyOwner {
1640     WLpaused = !WLpaused;
1641   }
1642 
1643 
1644 
1645 
1646  function setMaxNftLimitPerAddress(uint8 _limit) external onlyOwner{
1647     maxMintAmountPerWallet = _limit;
1648    delete _limit;
1649 
1650 }
1651 function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1652         whitelistMerkleRoot = _whitelistMerkleRoot;
1653     }
1654 
1655     
1656     function getLeafNode(address _leaf) internal pure returns (bytes32 temp)
1657     {
1658         return keccak256(abi.encodePacked(_leaf));
1659     }
1660     function _verify(bytes32 leaf, bytes32[] calldata proof) internal view returns (bool) {
1661         return MerkleProof.verifyCalldata(proof, whitelistMerkleRoot, leaf);
1662     }
1663 
1664 function whitelistMint(uint8 _mintAmount, bytes32[] calldata merkleProof) external {
1665         
1666        bytes32  leafnode = getLeafNode(msg.sender);
1667         uint8 _txPerAddress = NFTPerWLAddress[msg.sender];
1668        require(_verify(leafnode ,   merkleProof   ),  "Invalid merkle proof");
1669        require (_txPerAddress + _mintAmount <= maxMintAmountPerWallet, "Exceeds max nft limit per address");
1670       
1671 
1672 
1673     require(!WLpaused, "Whitelist minting is over!");
1674   
1675        uint16 totalSupply = uint16(totalSupply());
1676     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1677 
1678       
1679      _safeMint(msg.sender , _mintAmount);
1680       NFTPerWLAddress[msg.sender] =_txPerAddress + _mintAmount;
1681      
1682       delete _mintAmount;
1683        delete _txPerAddress;
1684     
1685     }
1686 
1687   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1688     uriPrefix = _uriPrefix;
1689   }
1690  
1691 
1692 
1693   function setPaused() external onlyOwner {
1694     paused = !paused;
1695     WLpaused = true;
1696   }
1697 
1698 
1699   function _baseURI() internal view  override returns (string memory) {
1700     return uriPrefix;
1701   }
1702   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1703         super.transferFrom(from, to, tokenId);
1704     }
1705 
1706     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1707         super.safeTransferFrom(from, to, tokenId);
1708     }
1709 
1710     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1711         public
1712         override
1713         onlyAllowedOperator(from)
1714     {
1715         super.safeTransferFrom(from, to, tokenId, data);
1716     }
1717 }