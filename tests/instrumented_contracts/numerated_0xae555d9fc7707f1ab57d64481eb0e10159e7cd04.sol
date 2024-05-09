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
922      /**
923      * @dev Returns whether `spender` is allowed to manage `tokenId`.
924      *
925      * Requirements:
926      *
927      * - `tokenId` must exist.
928      */
929     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
930         address owner = ERC721A.ownerOf(tokenId);
931         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
932     }
933 
934     function _safeMint(address to, uint256 quantity) internal {
935         _safeMint(to, quantity, '');
936     }
937 
938     /**
939      * @dev Safely mints `quantity` tokens and transfers them to `to`.
940      *
941      * Requirements:
942      *
943      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
944      * - `quantity` must be greater than 0.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(
949         address to,
950         uint256 quantity,
951         bytes memory _data
952     ) internal {
953         _mint(to, quantity, _data, true);
954     }
955 
956     /**
957      * @dev Mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - `to` cannot be the zero address.
962      * - `quantity` must be greater than 0.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _mint(
967         address to,
968         uint256 quantity,
969         bytes memory _data,
970         bool safe
971     ) internal {
972         uint256 startTokenId = _currentIndex;
973         if (to == address(0)) revert MintToZeroAddress();
974         if (quantity == 0) revert MintZeroQuantity();
975 
976         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
977 
978         // Overflows are incredibly unrealistic.
979         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
980         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
981         unchecked {
982             _addressData[to].balance += uint64(quantity);
983             _addressData[to].numberMinted += uint64(quantity);
984 
985             _ownerships[startTokenId].addr = to;
986             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
987 
988             uint256 updatedIndex = startTokenId;
989             uint256 end = updatedIndex + quantity;
990 
991             if (safe && to.isContract()) {
992                 do {
993                     emit Transfer(address(0), to, updatedIndex);
994                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
995                         revert TransferToNonERC721ReceiverImplementer();
996                     }
997                 } while (updatedIndex != end);
998                 // Reentrancy protection
999                 if (_currentIndex != startTokenId) revert();
1000             } else {
1001                 do {
1002                     emit Transfer(address(0), to, updatedIndex++);
1003                 } while (updatedIndex != end);
1004             }
1005             _currentIndex = updatedIndex;
1006         }
1007         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1008     }
1009 
1010     /**
1011      * @dev Transfers `tokenId` from `from` to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _transfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) private {
1025         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1026 
1027         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1028 
1029         bool isApprovedOrOwner = (_msgSender() == from ||
1030             isApprovedForAll(from, _msgSender()) ||
1031             getApproved(tokenId) == _msgSender());
1032 
1033         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1034         if (to == address(0)) revert TransferToZeroAddress();
1035 
1036         _beforeTokenTransfers(from, to, tokenId, 1);
1037 
1038         // Clear approvals from the previous owner
1039         _approve(address(0), tokenId, from);
1040 
1041         // Underflow of the sender's balance is impossible because we check for
1042         // ownership above and the recipient's balance can't realistically overflow.
1043         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1044         unchecked {
1045             _addressData[from].balance -= 1;
1046             _addressData[to].balance += 1;
1047 
1048             TokenOwnership storage currSlot = _ownerships[tokenId];
1049             currSlot.addr = to;
1050             currSlot.startTimestamp = uint64(block.timestamp);
1051 
1052             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1053             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1054             uint256 nextTokenId = tokenId + 1;
1055             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1056             if (nextSlot.addr == address(0)) {
1057                 // This will suffice for checking _exists(nextTokenId),
1058                 // as a burned slot cannot contain the zero address.
1059                 if (nextTokenId != _currentIndex) {
1060                     nextSlot.addr = from;
1061                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1062                 }
1063             }
1064         }
1065 
1066         emit Transfer(from, to, tokenId);
1067         _afterTokenTransfers(from, to, tokenId, 1);
1068     }
1069 
1070     /**
1071      * @dev This is equivalent to _burn(tokenId, false)
1072      */
1073     function _burn(uint256 tokenId) internal virtual {
1074         _burn(tokenId, false);
1075     }
1076 
1077     /**
1078      * @dev Destroys `tokenId`.
1079      * The approval is cleared when the token is burned.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1088         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1089 
1090         address from = prevOwnership.addr;
1091 
1092         if (approvalCheck) {
1093             bool isApprovedOrOwner = (_msgSender() == from ||
1094                 isApprovedForAll(from, _msgSender()) ||
1095                 getApproved(tokenId) == _msgSender());
1096 
1097             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1098         }
1099 
1100         _beforeTokenTransfers(from, address(0), tokenId, 1);
1101 
1102         // Clear approvals from the previous owner
1103         _approve(address(0), tokenId, from);
1104 
1105         // Underflow of the sender's balance is impossible because we check for
1106         // ownership above and the recipient's balance can't realistically overflow.
1107         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1108         unchecked {
1109             AddressData storage addressData = _addressData[from];
1110             addressData.balance -= 1;
1111             addressData.numberBurned += 1;
1112 
1113             // Keep track of who burned the token, and the timestamp of burning.
1114             TokenOwnership storage currSlot = _ownerships[tokenId];
1115             currSlot.addr = from;
1116             currSlot.startTimestamp = uint64(block.timestamp);
1117             currSlot.burned = true;
1118 
1119             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1120             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1121             uint256 nextTokenId = tokenId + 1;
1122             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1123             if (nextSlot.addr == address(0)) {
1124                 // This will suffice for checking _exists(nextTokenId),
1125                 // as a burned slot cannot contain the zero address.
1126                 if (nextTokenId != _currentIndex) {
1127                     nextSlot.addr = from;
1128                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1129                 }
1130             }
1131         }
1132 
1133         emit Transfer(from, address(0), tokenId);
1134         _afterTokenTransfers(from, address(0), tokenId, 1);
1135 
1136         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1137         unchecked {
1138             _burnCounter++;
1139         }
1140     }
1141 
1142     /**
1143      * @dev Approve `to` to operate on `tokenId`
1144      *
1145      * Emits a {Approval} event.
1146      */
1147     function _approve(
1148         address to,
1149         uint256 tokenId,
1150         address owner
1151     ) private {
1152         _tokenApprovals[tokenId] = to;
1153         emit Approval(owner, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1158      *
1159      * @param from address representing the previous owner of the given token ID
1160      * @param to target address that will receive the tokens
1161      * @param tokenId uint256 ID of the token to be transferred
1162      * @param _data bytes optional data to send along with the call
1163      * @return bool whether the call correctly returned the expected magic value
1164      */
1165     function _checkContractOnERC721Received(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) private returns (bool) {
1171         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1172             return retval == IERC721Receiver(to).onERC721Received.selector;
1173         } catch (bytes memory reason) {
1174             if (reason.length == 0) {
1175                 revert TransferToNonERC721ReceiverImplementer();
1176             } else {
1177                 assembly {
1178                     revert(add(32, reason), mload(reason))
1179                 }
1180             }
1181         }
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1186      * And also called before burning one token.
1187      *
1188      * startTokenId - the first token id to be transferred
1189      * quantity - the amount to be transferred
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` will be minted for `to`.
1196      * - When `to` is zero, `tokenId` will be burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _beforeTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 
1206     /**
1207      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1208      * minting.
1209      * And also called after one token has been burned.
1210      *
1211      * startTokenId - the first token id to be transferred
1212      * quantity - the amount to be transferred
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` has been minted for `to`.
1219      * - When `to` is zero, `tokenId` has been burned by `from`.
1220      * - `from` and `to` are never both zero.
1221      */
1222     function _afterTokenTransfers(
1223         address from,
1224         address to,
1225         uint256 startTokenId,
1226         uint256 quantity
1227     ) internal virtual {}
1228 }
1229 
1230 abstract contract Ownable is Context {
1231     address private _owner;
1232 
1233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1234 
1235     /**
1236      * @dev Initializes the contract setting the deployer as the initial owner.
1237      */
1238     constructor() {
1239         _transferOwnership(_msgSender());
1240     }
1241 
1242     /**
1243      * @dev Returns the address of the current owner.
1244      */
1245     function owner() public view virtual returns (address) {
1246         return _owner;
1247     }
1248 
1249     /**
1250      * @dev Throws if called by any account other than the owner.
1251      */
1252     modifier onlyOwner() {
1253         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1254         _;
1255     }
1256 
1257     /**
1258      * @dev Leaves the contract without owner. It will not be possible to call
1259      * `onlyOwner` functions anymore. Can only be called by the current owner.
1260      *
1261      * NOTE: Renouncing ownership will leave the contract without an owner,
1262      * thereby removing any functionality that is only available to the owner.
1263      */
1264     function renounceOwnership() public virtual onlyOwner {
1265         _transferOwnership(address(0));
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Can only be called by the current owner.
1271      */
1272     function transferOwnership(address newOwner) public virtual onlyOwner {
1273         require(newOwner != address(0), "Ownable: new owner is the zero address");
1274         _transferOwnership(newOwner);
1275     }
1276 
1277     /**
1278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1279      * Internal function without access restriction.
1280      */
1281     function _transferOwnership(address newOwner) internal virtual {
1282         address oldOwner = _owner;
1283         _owner = newOwner;
1284         emit OwnershipTransferred(oldOwner, newOwner);
1285     }
1286 }
1287 
1288 // File: closedsea/src/OperatorFilterer.sol
1289 
1290 
1291 pragma solidity ^0.8.4;
1292 
1293 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
1294 /// mandatory on-chain royalty enforcement in order for new collections to
1295 /// receive royalties.
1296 /// For more information, see:
1297 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
1298 abstract contract OperatorFilterer {
1299     /// @dev The default OpenSea operator blocklist subscription.
1300     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1301 
1302     /// @dev The OpenSea operator filter registry.
1303     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1304 
1305     /// @dev Registers the current contract to OpenSea's operator filter,
1306     /// and subscribe to the default OpenSea operator blocklist.
1307     /// Note: Will not revert nor update existing settings for repeated registration.
1308     function _registerForOperatorFiltering() internal virtual {
1309         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1310     }
1311 
1312     /// @dev Registers the current contract to OpenSea's operator filter.
1313     /// Note: Will not revert nor update existing settings for repeated registration.
1314     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
1315         internal
1316         virtual
1317     {
1318         /// @solidity memory-safe-assembly
1319         assembly {
1320             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
1321 
1322             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
1323             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
1324 
1325             for {} iszero(subscribe) {} {
1326                 if iszero(subscriptionOrRegistrantToCopy) {
1327                     functionSelector := 0x4420e486 // `register(address)`.
1328                     break
1329                 }
1330                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
1331                 break
1332             }
1333             // Store the function selector.
1334             mstore(0x00, shl(224, functionSelector))
1335             // Store the `address(this)`.
1336             mstore(0x04, address())
1337             // Store the `subscriptionOrRegistrantToCopy`.
1338             mstore(0x24, subscriptionOrRegistrantToCopy)
1339             // Register into the registry.
1340             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
1341                 // If the function selector has not been overwritten,
1342                 // it is an out-of-gas error.
1343                 if eq(shr(224, mload(0x00)), functionSelector) {
1344                     // To prevent gas under-estimation.
1345                     revert(0, 0)
1346                 }
1347             }
1348             // Restore the part of the free memory pointer that was overwritten,
1349             // which is guaranteed to be zero, because of Solidity's memory size limits.
1350             mstore(0x24, 0)
1351         }
1352     }
1353 
1354     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
1355     modifier onlyAllowedOperator(address from) virtual {
1356         if (from != msg.sender) {
1357             if (!_isPriorityOperator(msg.sender)) {
1358                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
1359             }
1360         }
1361         _;
1362     }
1363 
1364     /// @dev Modifier to guard a function from approving a blocked operator..
1365     modifier onlyAllowedOperatorApproval(address operator) virtual {
1366         if (!_isPriorityOperator(operator)) {
1367             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
1368         }
1369         _;
1370     }
1371 
1372     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
1373     function _revertIfBlocked(address operator) private view {
1374         /// @solidity memory-safe-assembly
1375         assembly {
1376             // Store the function selector of `isOperatorAllowed(address,address)`,
1377             // shifted left by 6 bytes, which is enough for 8tb of memory.
1378             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
1379             mstore(0x00, 0xc6171134001122334455)
1380             // Store the `address(this)`.
1381             mstore(0x1a, address())
1382             // Store the `operator`.
1383             mstore(0x3a, operator)
1384 
1385             // `isOperatorAllowed` always returns true if it does not revert.
1386             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
1387                 // Bubble up the revert if the staticcall reverts.
1388                 returndatacopy(0x00, 0x00, returndatasize())
1389                 revert(0x00, returndatasize())
1390             }
1391 
1392             // We'll skip checking if `from` is inside the blacklist.
1393             // Even though that can block transferring out of wrapper contracts,
1394             // we don't want tokens to be stuck.
1395 
1396             // Restore the part of the free memory pointer that was overwritten,
1397             // which is guaranteed to be zero, if less than 8tb of memory is used.
1398             mstore(0x3a, 0)
1399         }
1400     }
1401 
1402     /// @dev For deriving contracts to override, so that operator filtering
1403     /// can be turned on / off.
1404     /// Returns true by default.
1405     function _operatorFilteringEnabled() internal view virtual returns (bool) {
1406         return true;
1407     }
1408 
1409     /// @dev For deriving contracts to override, so that preferred marketplaces can
1410     /// skip operator filtering, helping users save gas.
1411     /// Returns false for all inputs by default.
1412     function _isPriorityOperator(address) internal view virtual returns (bool) {
1413         return false;
1414     }
1415 }
1416 // File: @openzeppelin/contracts@4.8.2/token/ERC721/extensions/ERC721Burnable.sol
1417 
1418 
1419 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 
1424 
1425 /**
1426  * @title ERC721 Burnable Token
1427  * @dev ERC721 Token that can be burned (destroyed).
1428  */
1429 abstract contract ERC721Burnable is Context, ERC721A {
1430     /**
1431      * @dev Burns `tokenId`. See {ERC721-_burn}.
1432      *
1433      * Requirements:
1434      *
1435      * - The caller must own `tokenId` or be an approved operator.
1436      */
1437     function burn(uint256 tokenId) public virtual {
1438         //solhint-disable-next-line max-line-length
1439         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1440         _burn(tokenId);
1441     }
1442 }
1443 
1444 
1445     pragma solidity ^0.8.13;
1446     
1447     contract RaveRush is ERC721A, Ownable,  OperatorFilterer, ERC721Burnable {
1448     using Strings for uint256;
1449 
1450 
1451   string private uriPrefix = "ipfs://bafybeifgjvseikwzvfn4eixlc5hr6kzrrlskkroomhowzplu34uf7wd2ba/";
1452   string private uriSuffix = ".json";
1453   string private hiddenURL;
1454 
1455   
1456   
1457 
1458   uint256 public cost = 0.002 ether;
1459  
1460   
1461 
1462   uint16 public maxSupply = 1000;
1463   uint8 public maxMintAmountPerTx = 5;
1464    uint8 public maxMintAmountPerWallet = 10;
1465     uint8 public maxFreeMintAmountPerWallet = 1;
1466     uint256 public freeNFTAlreadyMinted = 0;
1467      uint256 public  NUM_FREE_MINTS = 1000;
1468      bool public operatorFilteringEnabled;
1469                                                              
1470  
1471   bool public paused = true;
1472   bool public reveal = true;
1473 
1474 
1475  
1476   
1477   
1478  
1479   
1480 
1481     constructor(
1482     string memory _tokenName,
1483     string memory _tokenSymbol
1484    
1485   ) ERC721A(_tokenName, _tokenSymbol) {
1486      _registerForOperatorFiltering();
1487         operatorFilteringEnabled = true;
1488   }
1489 
1490    modifier callerIsUser() {
1491     require(tx.origin == msg.sender, "The caller is another contract");
1492     _;
1493   }
1494   
1495  
1496  
1497   function Mint(uint256 _mintAmount)
1498       external
1499       payable
1500       callerIsUser
1501   {
1502     require(!paused, "The contract is paused!");
1503     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1504      require (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerWallet, "max NFT per address exceeded");
1505     
1506 
1507     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1508         require(
1509             (cost * _mintAmount) <= msg.value,
1510             "Incorrect ETH value sent"
1511         );
1512     }
1513      else {
1514         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1515         require(
1516             (cost * _mintAmount) <= msg.value,
1517             "Incorrect ETH value sent"
1518         );
1519         require(
1520             _mintAmount <= maxMintAmountPerTx,
1521             "Max mints per transaction exceeded"
1522         );
1523         } else {
1524             require(
1525                 _mintAmount <= maxFreeMintAmountPerWallet,
1526                 "Max mints per transaction exceeded"
1527             );
1528             freeNFTAlreadyMinted += _mintAmount;
1529         }
1530     }
1531     _safeMint(msg.sender, _mintAmount);
1532   }
1533 
1534   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1535      uint16 totalSupply = uint16(totalSupply());
1536     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1537      _safeMint(_receiver , _mintAmount);
1538      delete _mintAmount;
1539      delete _receiver;
1540      delete totalSupply;
1541   }
1542 
1543   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1544      uint16 totalSupply = uint16(totalSupply());
1545      uint totalAmount =   _amountPerAddress * addresses.length;
1546     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1547      for (uint256 i = 0; i < addresses.length; i++) {
1548             _safeMint(addresses[i], _amountPerAddress);
1549         }
1550 
1551      delete _amountPerAddress;
1552      delete totalSupply;
1553   }
1554 
1555  
1556 
1557   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1558       maxSupply = _maxSupply;
1559   }
1560 
1561 
1562 
1563    
1564   function tokenURI(uint256 _tokenId)
1565     public
1566     view
1567     virtual
1568     override
1569     returns (string memory)
1570   {
1571     require(
1572       _exists(_tokenId),
1573       "ERC721Metadata: URI query for nonexistent token"
1574     );
1575     
1576   
1577 if ( reveal == false)
1578 {
1579     return hiddenURL;
1580 }
1581     
1582 
1583     string memory currentBaseURI = _baseURI();
1584     return bytes(currentBaseURI).length > 0
1585         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1586         : "";
1587   }
1588 
1589 
1590  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1591     maxFreeMintAmountPerWallet = _limit;
1592    delete _limit;
1593 
1594 }
1595 
1596     
1597    function seturiSuffix(string memory _uriSuffix) external onlyOwner {
1598     uriSuffix = _uriSuffix;
1599   }
1600 
1601 
1602   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1603     uriPrefix = _uriPrefix;
1604   }
1605    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1606     hiddenURL = _uriPrefix;
1607   }
1608 function setNumFreeMints(uint256 _numfreemints)
1609       external
1610       onlyOwner
1611   {
1612       NUM_FREE_MINTS = _numfreemints;
1613   }
1614 
1615   function setPaused() external onlyOwner {
1616     paused = !paused;
1617 
1618   }
1619 
1620   function setCost(uint _cost) external onlyOwner{
1621       cost = _cost;
1622 
1623   }
1624 
1625  function setRevealed() external onlyOwner{
1626      reveal = !reveal;
1627  }
1628 
1629   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1630       maxMintAmountPerTx = _maxtx;
1631 
1632   }
1633 
1634  
1635 
1636   function withdraw() public onlyOwner  {
1637     // This will transfer the remaining contract balance to the owner.
1638     // Do not remove this otherwise you will not be able to withdraw the funds.
1639     // =============================================================================
1640     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1641     require(os);
1642     // =============================================================================
1643   }
1644 
1645 
1646   function _baseURI() internal view  override returns (string memory) {
1647     return uriPrefix;
1648   }
1649     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1650     ERC721A.transferFrom(from, to, tokenId);
1651   }
1652 
1653   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1654     ERC721A.safeTransferFrom(from, to, tokenId);
1655   }
1656 
1657   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1658     public
1659     override
1660     onlyAllowedOperator(from)
1661   {
1662     ERC721A.safeTransferFrom(from, to, tokenId, data);
1663   }
1664      function setOperatorFilteringEnabled(bool value) public onlyOwner {
1665         operatorFilteringEnabled = value;
1666     }
1667 
1668     function _operatorFilteringEnabled() internal view override returns (bool) {
1669         return operatorFilteringEnabled;
1670     }
1671 }