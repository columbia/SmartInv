1 // File: contracts/AngryApesPortalPass.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/Address.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
104 
105 pragma solidity ^0.8.1;
106 
107 /**
108  * @dev Collection of functions related to the address type
109  */
110 library Address {
111     /**
112      * @dev Returns true if `account` is a contract.
113      *
114      * [IMPORTANT]
115      * ====
116      * It is unsafe to assume that an address for which this function returns
117      * false is an externally-owned account (EOA) and not a contract.
118      *
119      * Among others, `isContract` will return false for the following
120      * types of addresses:
121      *
122      *  - an externally-owned account
123      *  - a contract in construction
124      *  - an address where a contract will be created
125      *  - an address where a contract lived, but was destroyed
126      * ====
127      *
128      * [IMPORTANT]
129      * ====
130      * You shouldn't rely on `isContract` to protect against flash loan attacks!
131      *
132      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
133      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
134      * constructor.
135      * ====
136      */
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize/address.code.length, which returns 0
139         // for contracts in construction, since the code is only stored at the end
140         // of the constructor execution.
141 
142         return account.code.length > 0;
143     }
144 
145     /**
146      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
147      * `recipient`, forwarding all available gas and reverting on errors.
148      *
149      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
150      * of certain opcodes, possibly making contracts go over the 2300 gas limit
151      * imposed by `transfer`, making them unable to receive funds via
152      * `transfer`. {sendValue} removes this limitation.
153      *
154      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
155      *
156      * IMPORTANT: because control is transferred to `recipient`, care must be
157      * taken to not create reentrancy vulnerabilities. Consider using
158      * {ReentrancyGuard} or the
159      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
160      */
161     function sendValue(address payable recipient, uint256 amount) internal {
162         require(address(this).balance >= amount, "Address: insufficient balance");
163 
164         (bool success, ) = recipient.call{value: amount}("");
165         require(success, "Address: unable to send value, recipient may have reverted");
166     }
167 
168     /**
169      * @dev Performs a Solidity function call using a low level `call`. A
170      * plain `call` is an unsafe replacement for a function call: use this
171      * function instead.
172      *
173      * If `target` reverts with a revert reason, it is bubbled up by this
174      * function (like regular Solidity function calls).
175      *
176      * Returns the raw returned data. To convert to the expected return value,
177      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
178      *
179      * Requirements:
180      *
181      * - `target` must be a contract.
182      * - calling `target` with `data` must not revert.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionCall(target, data, "Address: low-level call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
192      * `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, 0, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but also transferring `value` wei to `target`.
207      *
208      * Requirements:
209      *
210      * - the calling contract must have an ETH balance of at least `value`.
211      * - the called Solidity function must be `payable`.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value
219     ) internal returns (bytes memory) {
220         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
225      * with `errorMessage` as a fallback revert reason when `target` reverts.
226      *
227      * _Available since v3.1._
228      */
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         require(address(this).balance >= value, "Address: insufficient balance for call");
236         require(isContract(target), "Address: call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.call{value: value}(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
249         return functionStaticCall(target, data, "Address: low-level static call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a static call.
255      *
256      * _Available since v3.3._
257      */
258     function functionStaticCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal view returns (bytes memory) {
263         require(isContract(target), "Address: static call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.staticcall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but performing a delegate call.
272      *
273      * _Available since v3.4._
274      */
275     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
276         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
281      * but performing a delegate call.
282      *
283      * _Available since v3.4._
284      */
285     function functionDelegateCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         require(isContract(target), "Address: delegate call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.delegatecall(data);
293         return verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
298      * revert reason using the provided one.
299      *
300      * _Available since v4.3._
301      */
302     function verifyCallResult(
303         bool success,
304         bytes memory returndata,
305         string memory errorMessage
306     ) internal pure returns (bytes memory) {
307         if (success) {
308             return returndata;
309         } else {
310             // Look for revert reason and bubble it up if present
311             if (returndata.length > 0) {
312                 // The easiest way to bubble the revert reason is using memory via assembly
313 
314                 assembly {
315                     let returndata_size := mload(returndata)
316                     revert(add(32, returndata), returndata_size)
317                 }
318             } else {
319                 revert(errorMessage);
320             }
321         }
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @title ERC721 token receiver interface
334  * @dev Interface for any contract that wants to support safeTransfers
335  * from ERC721 asset contracts.
336  */
337 interface IERC721Receiver {
338     /**
339      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
340      * by `operator` from `from`, this function is called.
341      *
342      * It must return its Solidity selector to confirm the token transfer.
343      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
344      *
345      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
346      */
347     function onERC721Received(
348         address operator,
349         address from,
350         uint256 tokenId,
351         bytes calldata data
352     ) external returns (bytes4);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Interface of the ERC165 standard, as defined in the
364  * https://eips.ethereum.org/EIPS/eip-165[EIP].
365  *
366  * Implementers can declare support of contract interfaces, which can then be
367  * queried by others ({ERC165Checker}).
368  *
369  * For an implementation, see {ERC165}.
370  */
371 interface IERC165 {
372     /**
373      * @dev Returns true if this contract implements the interface defined by
374      * `interfaceId`. See the corresponding
375      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
376      * to learn more about how these ids are created.
377      *
378      * This function call must use less than 30 000 gas.
379      */
380     function supportsInterface(bytes4 interfaceId) external view returns (bool);
381 }
382 
383 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 
391 /**
392  * @dev Implementation of the {IERC165} interface.
393  *
394  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
395  * for the additional interface id that will be supported. For example:
396  *
397  * ```solidity
398  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
399  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
400  * }
401  * ```
402  *
403  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
404  */
405 abstract contract ERC165 is IERC165 {
406     /**
407      * @dev See {IERC165-supportsInterface}.
408      */
409     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410         return interfaceId == type(IERC165).interfaceId;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
415 
416 
417 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Required interface of an ERC721 compliant contract.
424  */
425 interface IERC721 is IERC165 {
426     /**
427      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
433      */
434     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
435 
436     /**
437      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
438      */
439     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
440 
441     /**
442      * @dev Returns the number of tokens in ``owner``'s account.
443      */
444     function balanceOf(address owner) external view returns (uint256 balance);
445 
446     /**
447      * @dev Returns the owner of the `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function ownerOf(uint256 tokenId) external view returns (address owner);
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
457      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must exist and be owned by `from`.
464      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
466      *
467      * Emits a {Transfer} event.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Transfers `tokenId` token from `from` to `to`.
477      *
478      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
497      * The approval is cleared when the token is transferred.
498      *
499      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
500      *
501      * Requirements:
502      *
503      * - The caller must own the token or be an approved operator.
504      * - `tokenId` must exist.
505      *
506      * Emits an {Approval} event.
507      */
508     function approve(address to, uint256 tokenId) external;
509 
510     /**
511      * @dev Returns the account approved for `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function getApproved(uint256 tokenId) external view returns (address operator);
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
522      *
523      * Requirements:
524      *
525      * - The `operator` cannot be the caller.
526      *
527      * Emits an {ApprovalForAll} event.
528      */
529     function setApprovalForAll(address operator, bool _approved) external;
530 
531     /**
532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
533      *
534      * See {setApprovalForAll}
535      */
536     function isApprovedForAll(address owner, address operator) external view returns (bool);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`.
540      *
541      * Requirements:
542      *
543      * - `from` cannot be the zero address.
544      * - `to` cannot be the zero address.
545      * - `tokenId` token must exist and be owned by `from`.
546      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 tokenId,
555         bytes calldata data
556     ) external;
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
569  * @dev See https://eips.ethereum.org/EIPS/eip-721
570  */
571 interface IERC721Metadata is IERC721 {
572     /**
573      * @dev Returns the token collection name.
574      */
575     function name() external view returns (string memory);
576 
577     /**
578      * @dev Returns the token collection symbol.
579      */
580     function symbol() external view returns (string memory);
581 
582     /**
583      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
584      */
585     function tokenURI(uint256 tokenId) external view returns (string memory);
586 }
587 
588 // File: contracts/new.sol
589 
590 
591 
592 
593 pragma solidity ^0.8.4;
594 
595 
596 
597 
598 
599 
600 
601 
602 error ApprovalCallerNotOwnerNorApproved();
603 error ApprovalQueryForNonexistentToken();
604 error ApproveToCaller();
605 error ApprovalToCurrentOwner();
606 error BalanceQueryForZeroAddress();
607 error MintToZeroAddress();
608 error MintZeroQuantity();
609 error OwnerQueryForNonexistentToken();
610 error TransferCallerNotOwnerNorApproved();
611 error TransferFromIncorrectOwner();
612 error TransferToNonERC721ReceiverImplementer();
613 error TransferToZeroAddress();
614 error URIQueryForNonexistentToken();
615 
616 /**
617  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
618  * the Metadata extension. Built to optimize for lower gas during batch mints.
619  *
620  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
621  *
622  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
623  *
624  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
625  */
626 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
627     using Address for address;
628     using Strings for uint256;
629 
630     // Compiler will pack this into a single 256bit word.
631     struct TokenOwnership {
632         // The address of the owner.
633         address addr;
634         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
635         uint64 startTimestamp;
636         // Whether the token has been burned.
637         bool burned;
638     }
639 
640     // Compiler will pack this into a single 256bit word.
641     struct AddressData {
642         // Realistically, 2**64-1 is more than enough.
643         uint64 balance;
644         // Keeps track of mint count with minimal overhead for tokenomics.
645         uint64 numberMinted;
646         // Keeps track of burn count with minimal overhead for tokenomics.
647         uint64 numberBurned;
648         // For miscellaneous variable(s) pertaining to the address
649         // (e.g. number of whitelist mint slots used).
650         // If there are multiple variables, please pack them into a uint64.
651         uint64 aux;
652     }
653 
654     // The tokenId of the next token to be minted.
655     uint256 internal _currentIndex;
656 
657     // The number of tokens burned.
658     uint256 internal _burnCounter;
659 
660     // Token name
661     string private _name;
662 
663     // Token symbol
664     string private _symbol;
665 
666     // Mapping from token ID to ownership details
667     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
668     mapping(uint256 => TokenOwnership) internal _ownerships;
669 
670     // Mapping owner address to address data
671     mapping(address => AddressData) private _addressData;
672 
673     // Mapping from token ID to approved address
674     mapping(uint256 => address) private _tokenApprovals;
675 
676     // Mapping from owner to operator approvals
677     mapping(address => mapping(address => bool)) private _operatorApprovals;
678 
679     constructor(string memory name_, string memory symbol_) {
680         _name = name_;
681         _symbol = symbol_;
682         _currentIndex = _startTokenId();
683     }
684 
685     /**
686      * To change the starting tokenId, please override this function.
687      */
688     function _startTokenId() internal view virtual returns (uint256) {
689         return 1;
690     }
691 
692     /**
693      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
694      */
695     function totalSupply() public view returns (uint256) {
696         // Counter underflow is impossible as _burnCounter cannot be incremented
697         // more than _currentIndex - _startTokenId() times
698         unchecked {
699             return _currentIndex - _burnCounter - _startTokenId();
700         }
701     }
702 
703     /**
704      * Returns the total amount of tokens minted in the contract.
705      */
706     function _totalMinted() internal view returns (uint256) {
707         // Counter underflow is impossible as _currentIndex does not decrement,
708         // and it is initialized to _startTokenId()
709         unchecked {
710             return _currentIndex - _startTokenId();
711         }
712     }
713 
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
718         return
719             interfaceId == type(IERC721).interfaceId ||
720             interfaceId == type(IERC721Metadata).interfaceId ||
721             interfaceId == type(IERC2981).interfaceId ||
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
836     function approve(address to, uint256 tokenId) public virtual {
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
1244      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1245      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1246      * hash matches the root of the tree. When processing the proof, the pairs
1247      * of leafs & pre-images are assumed to be sorted.
1248      *
1249      * _Available since v4.4._
1250      */
1251     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1252         bytes32 computedHash = leaf;
1253         for (uint256 i = 0; i < proof.length; i++) {
1254             bytes32 proofElement = proof[i];
1255             if (computedHash <= proofElement) {
1256                 // Hash(current computed hash + current element of the proof)
1257                 computedHash = _efficientHash(computedHash, proofElement);
1258             } else {
1259                 // Hash(current element of the proof + current computed hash)
1260                 computedHash = _efficientHash(proofElement, computedHash);
1261             }
1262         }
1263         return computedHash;
1264     }
1265 
1266     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1267         assembly {
1268             mstore(0x00, a)
1269             mstore(0x20, b)
1270             value := keccak256(0x00, 0x40)
1271         }
1272     }
1273 }
1274 abstract contract Ownable is Context {
1275     address private _owner;
1276 
1277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1278 
1279     /**
1280      * @dev Initializes the contract setting the deployer as the initial owner.
1281      */
1282     constructor() {
1283         _transferOwnership(_msgSender());
1284     }
1285 
1286     /**
1287      * @dev Returns the address of the current owner.
1288      */
1289     function owner() public view virtual returns (address) {
1290         return _owner;
1291     }
1292 
1293     /**
1294      * @dev Throws if called by any account other than the owner.
1295      */
1296     modifier onlyOwner() {
1297         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1298         _;
1299     }
1300 
1301     /**
1302      * @dev Leaves the contract without owner. It will not be possible to call
1303      * `onlyOwner` functions anymore. Can only be called by the current owner.
1304      *
1305      * NOTE: Renouncing ownership will leave the contract without an owner,
1306      * thereby removing any functionality that is only available to the owner.
1307      */
1308     function renounceOwnership() public virtual onlyOwner {
1309         _transferOwnership(address(0));
1310     }
1311 
1312     /**
1313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1314      * Can only be called by the current owner.
1315      */
1316     function transferOwnership(address newOwner) public virtual onlyOwner {
1317         require(newOwner != address(0), "Ownable: new owner is the zero address");
1318         _transferOwnership(newOwner);
1319     }
1320 
1321     /**
1322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1323      * Internal function without access restriction.
1324      */
1325     function _transferOwnership(address newOwner) internal virtual {
1326         address oldOwner = _owner;
1327         _owner = newOwner;
1328         emit OwnershipTransferred(oldOwner, newOwner);
1329     }
1330 }
1331 
1332 interface IERC2981 is IERC165 {
1333     /// ERC165 bytes to add to interface array - set in parent contract
1334     /// implementing this standard
1335     ///
1336     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1337     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1338     /// _registerInterface(_INTERFACE_ID_ERC2981);
1339 
1340     /// @notice Called with the sale price to determine how much royalty
1341     //          is owed and to whom.
1342     /// @param _tokenId - the NFT asset queried for royalty information
1343     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
1344     /// @return receiver - address of who should be sent the royalty payment
1345     /// @return royaltyAmount - the royalty payment amount for _salePrice
1346     function royaltyInfo(
1347         uint256 _tokenId,
1348         uint256 _salePrice
1349     ) external view returns (
1350         address receiver,
1351         uint256 royaltyAmount
1352     );
1353 }
1354 
1355 interface IOperatorFilterRegistry {
1356     /**
1357      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1358      *         true if supplied registrant address is not registered.
1359      */
1360     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1361 
1362     /**
1363      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1364      */
1365     function register(address registrant) external;
1366 
1367     /**
1368      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1369      */
1370     function registerAndSubscribe(address registrant, address subscription) external;
1371 
1372     /**
1373      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1374      *         address without subscribing.
1375      */
1376     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1377 
1378     /**
1379      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1380      *         Note that this does not remove any filtered addresses or codeHashes.
1381      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1382      */
1383     function unregister(address addr) external;
1384 
1385     /**
1386      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1387      */
1388     function updateOperator(address registrant, address operator, bool filtered) external;
1389 
1390     /**
1391      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1392      */
1393     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1394 
1395     /**
1396      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1397      */
1398     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1399 
1400     /**
1401      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1402      */
1403     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1404 
1405     /**
1406      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1407      *         subscription if present.
1408      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1409      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1410      *         used.
1411      */
1412     function subscribe(address registrant, address registrantToSubscribe) external;
1413 
1414     /**
1415      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1416      */
1417     function unsubscribe(address registrant, bool copyExistingEntries) external;
1418 
1419     /**
1420      * @notice Get the subscription address of a given registrant, if any.
1421      */
1422     function subscriptionOf(address addr) external returns (address registrant);
1423 
1424     /**
1425      * @notice Get the set of addresses subscribed to a given registrant.
1426      *         Note that order is not guaranteed as updates are made.
1427      */
1428     function subscribers(address registrant) external returns (address[] memory);
1429 
1430     /**
1431      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1432      *         Note that order is not guaranteed as updates are made.
1433      */
1434     function subscriberAt(address registrant, uint256 index) external returns (address);
1435 
1436     /**
1437      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1438      */
1439     function copyEntriesOf(address registrant, address registrantToCopy) external;
1440 
1441     /**
1442      * @notice Returns true if operator is filtered by a given address or its subscription.
1443      */
1444     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1445 
1446     /**
1447      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1448      */
1449     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1450 
1451     /**
1452      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1453      */
1454     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1455 
1456     /**
1457      * @notice Returns a list of filtered operators for a given address or its subscription.
1458      */
1459     function filteredOperators(address addr) external returns (address[] memory);
1460 
1461     /**
1462      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1463      *         Note that order is not guaranteed as updates are made.
1464      */
1465     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1466 
1467     /**
1468      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1469      *         its subscription.
1470      *         Note that order is not guaranteed as updates are made.
1471      */
1472     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1473 
1474     /**
1475      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1476      *         its subscription.
1477      *         Note that order is not guaranteed as updates are made.
1478      */
1479     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1480 
1481     /**
1482      * @notice Returns true if an address has registered
1483      */
1484     function isRegistered(address addr) external returns (bool);
1485 
1486     /**
1487      * @dev Convenience method to compute the code hash of an arbitrary contract
1488      */
1489     function codeHashOf(address addr) external returns (bytes32);
1490 }
1491 
1492 abstract contract OperatorFilterer {
1493     /// @dev Emitted when an operator is not allowed.
1494     error OperatorNotAllowed(address operator);
1495 
1496     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1497         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1498 
1499     /// @dev The constructor that is called when the contract is being deployed.
1500     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1501         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1502         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1503         // order for the modifier to filter addresses.
1504         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1505             if (subscribe) {
1506                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1507             } else {
1508                 if (subscriptionOrRegistrantToCopy != address(0)) {
1509                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1510                 } else {
1511                     OPERATOR_FILTER_REGISTRY.register(address(this));
1512                 }
1513             }
1514         }
1515     }
1516 
1517     /**
1518      * @dev A helper function to check if an operator is allowed.
1519      */
1520     modifier onlyAllowedOperator(address from) virtual {
1521         // Allow spending tokens from addresses with balance
1522         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1523         // from an EOA.
1524         if (from != msg.sender) {
1525             _checkFilterOperator(msg.sender);
1526         }
1527         _;
1528     }
1529 
1530     /**
1531      * @dev A helper function to check if an operator approval is allowed.
1532      */
1533     modifier onlyAllowedOperatorApproval(address operator) virtual {
1534         _checkFilterOperator(operator);
1535         _;
1536     }
1537 
1538     /**
1539      * @dev A helper function to check if an operator is allowed.
1540      */
1541     function _checkFilterOperator(address operator) internal view virtual {
1542         // Check registry code length to facilitate testing in environments without a deployed registry.
1543         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1544             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1545             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1546             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1547                 revert OperatorNotAllowed(operator);
1548             }
1549         }
1550     }
1551 }
1552 
1553 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1554     /// @dev The constructor that is called when the contract is being deployed.
1555     constructor() OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {}
1556 }
1557 
1558 pragma solidity >=0.7.0 <0.9.0;
1559 
1560 contract AngryApesPortalPass is DefaultOperatorFilterer, ERC721A, IERC2981, Ownable {
1561   using Strings for uint256;
1562   string public baseURI = "ipfs://QmdJmkpZiFGf9WYuSAjzaCAY9hZcrhTqHurT7rsYYSandX";
1563   uint256 public maxSupply = 4250;
1564   constructor(
1565     string memory _name,
1566     string memory _symbol
1567   ) ERC721A(_name, _symbol) {
1568   }
1569   function _baseURI() internal view virtual override returns (string memory) {
1570     return baseURI;
1571   }
1572   function mint(uint256 _mintAmount, address _receivingAddress) public payable onlyOwner {
1573     if(totalSupply() + _mintAmount > maxSupply) {
1574         revert();
1575     }
1576     _safeMint(_receivingAddress, _mintAmount);
1577   }
1578   function tokenURI(uint256 tokenId)
1579     public
1580     view
1581     virtual
1582     override
1583     returns (string memory)
1584   {
1585     require(
1586       _exists(tokenId),
1587       "ERC721Metadata: URI query for nonexistent token"
1588     );
1589     string memory currentBaseURI = _baseURI();
1590     return currentBaseURI;
1591   }
1592   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1593     baseURI = _newBaseURI;
1594   }
1595     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1596     public
1597     pure
1598     override
1599     returns (address receiver, uint256 royaltyAmount)
1600   {
1601     return (0xE7DEbDCfd92a2b6f7AB03B4b3c73494CAdCCB371,(5 * salePrice)/100);
1602   }
1603     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1604         super.setApprovalForAll(operator, approved);
1605     }
1606 
1607     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1608         super.approve(operator, tokenId);
1609     }
1610 
1611     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1612         super.transferFrom(from, to, tokenId);
1613     }
1614 
1615     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1616         super.safeTransferFrom(from, to, tokenId);
1617     }
1618 
1619     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1620         public
1621         override
1622         onlyAllowedOperator(from)
1623     {
1624         super.safeTransferFrom(from, to, tokenId, data);
1625     }
1626 }