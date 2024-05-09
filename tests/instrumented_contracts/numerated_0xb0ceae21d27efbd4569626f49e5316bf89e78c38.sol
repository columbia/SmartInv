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
1217 
1218 abstract contract Ownable is Context {
1219     address private _owner;
1220 
1221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1222 
1223     /**
1224      * @dev Initializes the contract setting the deployer as the initial owner.
1225      */
1226     constructor() {
1227         _transferOwnership(_msgSender());
1228     }
1229 
1230     /**
1231      * @dev Returns the address of the current owner.
1232      */
1233     function owner() public view virtual returns (address) {
1234         return _owner;
1235     }
1236 
1237     /**
1238      * @dev Throws if called by any account other than the owner.
1239      */
1240     modifier onlyOwner() {
1241         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1242         _;
1243     }
1244 
1245     /**
1246      * @dev Leaves the contract without owner. It will not be possible to call
1247      * `onlyOwner` functions anymore. Can only be called by the current owner.
1248      *
1249      * NOTE: Renouncing ownership will leave the contract without an owner,
1250      * thereby removing any functionality that is only available to the owner.
1251      */
1252     function renounceOwnership() public virtual onlyOwner {
1253         _transferOwnership(address(0));
1254     }
1255 
1256     /**
1257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1258      * Can only be called by the current owner.
1259      */
1260     function transferOwnership(address newOwner) public virtual onlyOwner {
1261         require(newOwner != address(0), "Ownable: new owner is the zero address");
1262         _transferOwnership(newOwner);
1263     }
1264 
1265     /**
1266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1267      * Internal function without access restriction.
1268      */
1269     function _transferOwnership(address newOwner) internal virtual {
1270         address oldOwner = _owner;
1271         _owner = newOwner;
1272         emit OwnershipTransferred(oldOwner, newOwner);
1273     }
1274 }
1275 
1276 // File: closedsea/src/OperatorFilterer.sol
1277 
1278 
1279 pragma solidity ^0.8.4;
1280 
1281 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
1282 /// mandatory on-chain royalty enforcement in order for new collections to
1283 /// receive royalties.
1284 /// For more information, see:
1285 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
1286 abstract contract OperatorFilterer {
1287     /// @dev The default OpenSea operator blocklist subscription.
1288     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1289 
1290     /// @dev The OpenSea operator filter registry.
1291     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1292 
1293     /// @dev Registers the current contract to OpenSea's operator filter,
1294     /// and subscribe to the default OpenSea operator blocklist.
1295     /// Note: Will not revert nor update existing settings for repeated registration.
1296     function _registerForOperatorFiltering() internal virtual {
1297         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1298     }
1299 
1300     /// @dev Registers the current contract to OpenSea's operator filter.
1301     /// Note: Will not revert nor update existing settings for repeated registration.
1302     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
1303         internal
1304         virtual
1305     {
1306         /// @solidity memory-safe-assembly
1307         assembly {
1308             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
1309 
1310             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
1311             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
1312 
1313             for {} iszero(subscribe) {} {
1314                 if iszero(subscriptionOrRegistrantToCopy) {
1315                     functionSelector := 0x4420e486 // `register(address)`.
1316                     break
1317                 }
1318                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
1319                 break
1320             }
1321             // Store the function selector.
1322             mstore(0x00, shl(224, functionSelector))
1323             // Store the `address(this)`.
1324             mstore(0x04, address())
1325             // Store the `subscriptionOrRegistrantToCopy`.
1326             mstore(0x24, subscriptionOrRegistrantToCopy)
1327             // Register into the registry.
1328             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
1329                 // If the function selector has not been overwritten,
1330                 // it is an out-of-gas error.
1331                 if eq(shr(224, mload(0x00)), functionSelector) {
1332                     // To prevent gas under-estimation.
1333                     revert(0, 0)
1334                 }
1335             }
1336             // Restore the part of the free memory pointer that was overwritten,
1337             // which is guaranteed to be zero, because of Solidity's memory size limits.
1338             mstore(0x24, 0)
1339         }
1340     }
1341 
1342     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
1343     modifier onlyAllowedOperator(address from) virtual {
1344         if (from != msg.sender) {
1345             if (!_isPriorityOperator(msg.sender)) {
1346                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
1347             }
1348         }
1349         _;
1350     }
1351 
1352     /// @dev Modifier to guard a function from approving a blocked operator..
1353     modifier onlyAllowedOperatorApproval(address operator) virtual {
1354         if (!_isPriorityOperator(operator)) {
1355             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
1356         }
1357         _;
1358     }
1359 
1360     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
1361     function _revertIfBlocked(address operator) private view {
1362         /// @solidity memory-safe-assembly
1363         assembly {
1364             // Store the function selector of `isOperatorAllowed(address,address)`,
1365             // shifted left by 6 bytes, which is enough for 8tb of memory.
1366             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
1367             mstore(0x00, 0xc6171134001122334455)
1368             // Store the `address(this)`.
1369             mstore(0x1a, address())
1370             // Store the `operator`.
1371             mstore(0x3a, operator)
1372 
1373             // `isOperatorAllowed` always returns true if it does not revert.
1374             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
1375                 // Bubble up the revert if the staticcall reverts.
1376                 returndatacopy(0x00, 0x00, returndatasize())
1377                 revert(0x00, returndatasize())
1378             }
1379 
1380             // We'll skip checking if `from` is inside the blacklist.
1381             // Even though that can block transferring out of wrapper contracts,
1382             // we don't want tokens to be stuck.
1383 
1384             // Restore the part of the free memory pointer that was overwritten,
1385             // which is guaranteed to be zero, if less than 8tb of memory is used.
1386             mstore(0x3a, 0)
1387         }
1388     }
1389 
1390     /// @dev For deriving contracts to override, so that operator filtering
1391     /// can be turned on / off.
1392     /// Returns true by default.
1393     function _operatorFilteringEnabled() internal view virtual returns (bool) {
1394         return true;
1395     }
1396 
1397     /// @dev For deriving contracts to override, so that preferred marketplaces can
1398     /// skip operator filtering, helping users save gas.
1399     /// Returns false for all inputs by default.
1400     function _isPriorityOperator(address) internal view virtual returns (bool) {
1401         return false;
1402     }
1403 }
1404 
1405 
1406     pragma solidity ^0.8.13;
1407     
1408     contract PE_AI_PE  is ERC721A, Ownable,  OperatorFilterer {
1409     using Strings for uint256;
1410 
1411 
1412   string private uriPrefix = "ipfs://bafybeigp5mxslwv43unledlbrqqhkbi76wepxunf45elenwi5q7lowaah4/";
1413   string private uriSuffix = ".json";
1414   string private hiddenURL;
1415 
1416   
1417   
1418 
1419   uint256 public cost = 0.003 ether;
1420  
1421   
1422 
1423   uint16 public maxSupply = 550;
1424   uint8 public maxMintAmountPerTx = 5;
1425    uint8 public maxMintAmountPerWallet = 5;
1426     uint8 public maxFreeMintAmountPerWallet = 0;
1427     uint256 public freeNFTAlreadyMinted = 0;
1428      uint256 public  NUM_FREE_MINTS = 0;
1429      bool public operatorFilteringEnabled;
1430                                                              
1431  
1432   bool public paused = true;
1433   bool public reveal = true;
1434 
1435 
1436  
1437   
1438   
1439  
1440   
1441 
1442     constructor(
1443     string memory _tokenName,
1444     string memory _tokenSymbol
1445    
1446   ) ERC721A(_tokenName, _tokenSymbol) {
1447      _registerForOperatorFiltering();
1448         operatorFilteringEnabled = true;
1449   }
1450 
1451    modifier callerIsUser() {
1452     require(tx.origin == msg.sender, "The caller is another contract");
1453     _;
1454   }
1455   
1456  
1457  
1458   function Mint(uint256 _mintAmount)
1459       external
1460       payable
1461       callerIsUser
1462   {
1463     require(!paused, "The contract is paused!");
1464     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1465      require (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerWallet, "max NFT per address exceeded");
1466     
1467 
1468     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1469         require(
1470             (cost * _mintAmount) <= msg.value,
1471             "Incorrect ETH value sent"
1472         );
1473     }
1474      else {
1475         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1476         require(
1477             (cost * _mintAmount) <= msg.value,
1478             "Incorrect ETH value sent"
1479         );
1480         require(
1481             _mintAmount <= maxMintAmountPerTx,
1482             "Max mints per transaction exceeded"
1483         );
1484         } else {
1485             require(
1486                 _mintAmount <= maxFreeMintAmountPerWallet,
1487                 "Max mints per transaction exceeded"
1488             );
1489             freeNFTAlreadyMinted += _mintAmount;
1490         }
1491     }
1492     _safeMint(msg.sender, _mintAmount);
1493   }
1494 
1495   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1496      uint16 totalSupply = uint16(totalSupply());
1497     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1498      _safeMint(_receiver , _mintAmount);
1499      delete _mintAmount;
1500      delete _receiver;
1501      delete totalSupply;
1502   }
1503 
1504   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1505      uint16 totalSupply = uint16(totalSupply());
1506      uint totalAmount =   _amountPerAddress * addresses.length;
1507     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1508      for (uint256 i = 0; i < addresses.length; i++) {
1509             _safeMint(addresses[i], _amountPerAddress);
1510         }
1511 
1512      delete _amountPerAddress;
1513      delete totalSupply;
1514   }
1515 
1516  
1517 
1518   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1519       maxSupply = _maxSupply;
1520   }
1521 
1522 
1523 
1524    
1525   function tokenURI(uint256 _tokenId)
1526     public
1527     view
1528     virtual
1529     override
1530     returns (string memory)
1531   {
1532     require(
1533       _exists(_tokenId),
1534       "ERC721Metadata: URI query for nonexistent token"
1535     );
1536     
1537   
1538 if ( reveal == false)
1539 {
1540     return hiddenURL;
1541 }
1542     
1543 
1544     string memory currentBaseURI = _baseURI();
1545     return bytes(currentBaseURI).length > 0
1546         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1547         : "";
1548   }
1549 
1550 
1551  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1552     maxFreeMintAmountPerWallet = _limit;
1553    delete _limit;
1554 
1555 }
1556 
1557     
1558    function seturiSuffix(string memory _uriSuffix) external onlyOwner {
1559     uriSuffix = _uriSuffix;
1560   }
1561 
1562 
1563   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1564     uriPrefix = _uriPrefix;
1565   }
1566    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1567     hiddenURL = _uriPrefix;
1568   }
1569 function setNumFreeMints(uint256 _numfreemints)
1570       external
1571       onlyOwner
1572   {
1573       NUM_FREE_MINTS = _numfreemints;
1574   }
1575 
1576   function setPaused() external onlyOwner {
1577     paused = !paused;
1578 
1579   }
1580 
1581   function setCost(uint _cost) external onlyOwner{
1582       cost = _cost;
1583 
1584   }
1585 
1586  function setRevealed() external onlyOwner{
1587      reveal = !reveal;
1588  }
1589 
1590   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1591       maxMintAmountPerTx = _maxtx;
1592 
1593   }
1594 
1595  
1596 
1597   function withdraw() public onlyOwner  {
1598     // This will transfer the remaining contract balance to the owner.
1599     // Do not remove this otherwise you will not be able to withdraw the funds.
1600     // =============================================================================
1601     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1602     require(os);
1603     // =============================================================================
1604   }
1605 
1606 
1607   function _baseURI() internal view  override returns (string memory) {
1608     return uriPrefix;
1609   }
1610     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1611     ERC721A.transferFrom(from, to, tokenId);
1612   }
1613 
1614   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1615     ERC721A.safeTransferFrom(from, to, tokenId);
1616   }
1617 
1618   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1619     public
1620     override
1621     onlyAllowedOperator(from)
1622   {
1623     ERC721A.safeTransferFrom(from, to, tokenId, data);
1624   }
1625      function setOperatorFilteringEnabled(bool value) public onlyOwner {
1626         operatorFilteringEnabled = value;
1627     }
1628 
1629     function _operatorFilteringEnabled() internal view override returns (bool) {
1630         return operatorFilteringEnabled;
1631     }
1632 }