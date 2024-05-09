1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 // File: @openzeppelin/contracts/utils/Context.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @dev Provides information about the current execution context, including the
563  * sender of the transaction and its data. While these are generally available
564  * via msg.sender and msg.data, they should not be accessed in such a direct
565  * manner, since when dealing with meta-transactions the account sending and
566  * paying for execution may not be the actual sender (as far as an application
567  * is concerned).
568  *
569  * This contract is only required for intermediate, library-like contracts.
570  */
571 abstract contract Context {
572     function _msgSender() internal view virtual returns (address) {
573         return msg.sender;
574     }
575 
576     function _msgData() internal view virtual returns (bytes calldata) {
577         return msg.data;
578     }
579 }
580 
581 // File: erc721a/contracts/ERC721A.sol
582 
583 
584 // Creator: Chiru Labs
585 
586 pragma solidity ^0.8.4;
587 
588 
589 
590 
591 
592 
593 
594 
595 error ApprovalCallerNotOwnerNorApproved();
596 error ApprovalQueryForNonexistentToken();
597 error ApproveToCaller();
598 error ApprovalToCurrentOwner();
599 error BalanceQueryForZeroAddress();
600 error MintToZeroAddress();
601 error MintZeroQuantity();
602 error OwnerQueryForNonexistentToken();
603 error TransferCallerNotOwnerNorApproved();
604 error TransferFromIncorrectOwner();
605 error TransferToNonERC721ReceiverImplementer();
606 error TransferToZeroAddress();
607 error URIQueryForNonexistentToken();
608 
609 /**
610  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
611  * the Metadata extension. Built to optimize for lower gas during batch mints.
612  *
613  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
614  *
615  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
616  *
617  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
618  */
619 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
620     using Address for address;
621     using Strings for uint256;
622 
623     // Compiler will pack this into a single 256bit word.
624     struct TokenOwnership {
625         // The address of the owner.
626         address addr;
627         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
628         uint64 startTimestamp;
629         // Whether the token has been burned.
630         bool burned;
631     }
632 
633     // Compiler will pack this into a single 256bit word.
634     struct AddressData {
635         // Realistically, 2**64-1 is more than enough.
636         uint64 balance;
637         // Keeps track of mint count with minimal overhead for tokenomics.
638         uint64 numberMinted;
639         // Keeps track of burn count with minimal overhead for tokenomics.
640         uint64 numberBurned;
641         // For miscellaneous variable(s) pertaining to the address
642         // (e.g. number of whitelist mint slots used).
643         // If there are multiple variables, please pack them into a uint64.
644         uint64 aux;
645     }
646 
647     // The tokenId of the next token to be minted.
648     uint256 internal _currentIndex;
649 
650     // The number of tokens burned.
651     uint256 internal _burnCounter;
652 
653     // Token name
654     string private _name;
655 
656     // Token symbol
657     string private _symbol;
658 
659     // Mapping from token ID to ownership details
660     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
661     mapping(uint256 => TokenOwnership) internal _ownerships;
662 
663     // Mapping owner address to address data
664     mapping(address => AddressData) private _addressData;
665 
666     // Mapping from token ID to approved address
667     mapping(uint256 => address) private _tokenApprovals;
668 
669     // Mapping from owner to operator approvals
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675         _currentIndex = _startTokenId();
676     }
677 
678     /**
679      * To change the starting tokenId, please override this function.
680      */
681     function _startTokenId() internal view virtual returns (uint256) {
682         return 0;
683     }
684 
685     /**
686      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
687      */
688     function totalSupply() public view returns (uint256) {
689         // Counter underflow is impossible as _burnCounter cannot be incremented
690         // more than _currentIndex - _startTokenId() times
691         unchecked {
692             return _currentIndex - _burnCounter - _startTokenId();
693         }
694     }
695 
696     /**
697      * Returns the total amount of tokens minted in the contract.
698      */
699     function _totalMinted() internal view returns (uint256) {
700         // Counter underflow is impossible as _currentIndex does not decrement,
701         // and it is initialized to _startTokenId()
702         unchecked {
703             return _currentIndex - _startTokenId();
704         }
705     }
706 
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
711         return
712             interfaceId == type(IERC721).interfaceId ||
713             interfaceId == type(IERC721Metadata).interfaceId ||
714             super.supportsInterface(interfaceId);
715     }
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view override returns (uint256) {
721         if (owner == address(0)) revert BalanceQueryForZeroAddress();
722         return uint256(_addressData[owner].balance);
723     }
724 
725     /**
726      * Returns the number of tokens minted by `owner`.
727      */
728     function _numberMinted(address owner) internal view returns (uint256) {
729         return uint256(_addressData[owner].numberMinted);
730     }
731 
732     /**
733      * Returns the number of tokens burned by or on behalf of `owner`.
734      */
735     function _numberBurned(address owner) internal view returns (uint256) {
736         return uint256(_addressData[owner].numberBurned);
737     }
738 
739     /**
740      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
741      */
742     function _getAux(address owner) internal view returns (uint64) {
743         return _addressData[owner].aux;
744     }
745 
746     /**
747      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
748      * If there are multiple variables, please pack them into a uint64.
749      */
750     function _setAux(address owner, uint64 aux) internal {
751         _addressData[owner].aux = aux;
752     }
753 
754     /**
755      * Gas spent here starts off proportional to the maximum mint batch size.
756      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
757      */
758     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
759         uint256 curr = tokenId;
760 
761         unchecked {
762             if (_startTokenId() <= curr && curr < _currentIndex) {
763                 TokenOwnership memory ownership = _ownerships[curr];
764                 if (!ownership.burned) {
765                     if (ownership.addr != address(0)) {
766                         return ownership;
767                     }
768                     // Invariant:
769                     // There will always be an ownership that has an address and is not burned
770                     // before an ownership that does not have an address and is not burned.
771                     // Hence, curr will not underflow.
772                     while (true) {
773                         curr--;
774                         ownership = _ownerships[curr];
775                         if (ownership.addr != address(0)) {
776                             return ownership;
777                         }
778                     }
779                 }
780             }
781         }
782         revert OwnerQueryForNonexistentToken();
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId) public view override returns (address) {
789         return _ownershipOf(tokenId).addr;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-name}.
794      */
795     function name() public view virtual override returns (string memory) {
796         return _name;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-symbol}.
801      */
802     function symbol() public view virtual override returns (string memory) {
803         return _symbol;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-tokenURI}.
808      */
809     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
810         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
811 
812         string memory baseURI = _baseURI();
813         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
814     }
815 
816     /**
817      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
818      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
819      * by default, can be overriden in child contracts.
820      */
821     function _baseURI() internal view virtual returns (string memory) {
822         return '';
823     }
824 
825     /**
826      * @dev See {IERC721-approve}.
827      */
828     function approve(address to, uint256 tokenId) public override {
829         address owner = ERC721A.ownerOf(tokenId);
830         if (to == owner) revert ApprovalToCurrentOwner();
831 
832         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
833             revert ApprovalCallerNotOwnerNorApproved();
834         }
835 
836         _approve(to, tokenId, owner);
837     }
838 
839     /**
840      * @dev See {IERC721-getApproved}.
841      */
842     function getApproved(uint256 tokenId) public view override returns (address) {
843         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
844 
845         return _tokenApprovals[tokenId];
846     }
847 
848     /**
849      * @dev See {IERC721-setApprovalForAll}.
850      */
851     function setApprovalForAll(address operator, bool approved) public virtual override {
852         if (operator == _msgSender()) revert ApproveToCaller();
853 
854         _operatorApprovals[_msgSender()][operator] = approved;
855         emit ApprovalForAll(_msgSender(), operator, approved);
856     }
857 
858     /**
859      * @dev See {IERC721-isApprovedForAll}.
860      */
861     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
862         return _operatorApprovals[owner][operator];
863     }
864 
865     /**
866      * @dev See {IERC721-transferFrom}.
867      */
868     function transferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public virtual override {
873         _transfer(from, to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-safeTransferFrom}.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId
883     ) public virtual override {
884         safeTransferFrom(from, to, tokenId, '');
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) public virtual override {
896         _transfer(from, to, tokenId);
897         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
898             revert TransferToNonERC721ReceiverImplementer();
899         }
900     }
901 
902     /**
903      * @dev Returns whether `tokenId` exists.
904      *
905      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
906      *
907      * Tokens start existing when they are minted (`_mint`),
908      */
909     function _exists(uint256 tokenId) internal view returns (bool) {
910         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
911             !_ownerships[tokenId].burned;
912     }
913 
914     function _safeMint(address to, uint256 quantity) internal {
915         _safeMint(to, quantity, '');
916     }
917 
918     /**
919      * @dev Safely mints `quantity` tokens and transfers them to `to`.
920      *
921      * Requirements:
922      *
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
924      * - `quantity` must be greater than 0.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeMint(
929         address to,
930         uint256 quantity,
931         bytes memory _data
932     ) internal {
933         _mint(to, quantity, _data, true);
934     }
935 
936     /**
937      * @dev Mints `quantity` tokens and transfers them to `to`.
938      *
939      * Requirements:
940      *
941      * - `to` cannot be the zero address.
942      * - `quantity` must be greater than 0.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _mint(
947         address to,
948         uint256 quantity,
949         bytes memory _data,
950         bool safe
951     ) internal {
952         uint256 startTokenId = _currentIndex;
953         if (to == address(0)) revert MintToZeroAddress();
954         if (quantity == 0) revert MintZeroQuantity();
955 
956         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
957 
958         // Overflows are incredibly unrealistic.
959         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
960         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
961         unchecked {
962             _addressData[to].balance += uint64(quantity);
963             _addressData[to].numberMinted += uint64(quantity);
964 
965             _ownerships[startTokenId].addr = to;
966             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
967 
968             uint256 updatedIndex = startTokenId;
969             uint256 end = updatedIndex + quantity;
970 
971             if (safe && to.isContract()) {
972                 do {
973                     emit Transfer(address(0), to, updatedIndex);
974                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
975                         revert TransferToNonERC721ReceiverImplementer();
976                     }
977                 } while (updatedIndex != end);
978                 // Reentrancy protection
979                 if (_currentIndex != startTokenId) revert();
980             } else {
981                 do {
982                     emit Transfer(address(0), to, updatedIndex++);
983                 } while (updatedIndex != end);
984             }
985             _currentIndex = updatedIndex;
986         }
987         _afterTokenTransfers(address(0), to, startTokenId, quantity);
988     }
989 
990     /**
991      * @dev Transfers `tokenId` from `from` to `to`.
992      *
993      * Requirements:
994      *
995      * - `to` cannot be the zero address.
996      * - `tokenId` token must be owned by `from`.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _transfer(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) private {
1005         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1006 
1007         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1008 
1009         bool isApprovedOrOwner = (_msgSender() == from ||
1010             isApprovedForAll(from, _msgSender()) ||
1011             getApproved(tokenId) == _msgSender());
1012 
1013         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1014         if (to == address(0)) revert TransferToZeroAddress();
1015 
1016         _beforeTokenTransfers(from, to, tokenId, 1);
1017 
1018         // Clear approvals from the previous owner
1019         _approve(address(0), tokenId, from);
1020 
1021         // Underflow of the sender's balance is impossible because we check for
1022         // ownership above and the recipient's balance can't realistically overflow.
1023         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1024         unchecked {
1025             _addressData[from].balance -= 1;
1026             _addressData[to].balance += 1;
1027 
1028             TokenOwnership storage currSlot = _ownerships[tokenId];
1029             currSlot.addr = to;
1030             currSlot.startTimestamp = uint64(block.timestamp);
1031 
1032             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1033             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1034             uint256 nextTokenId = tokenId + 1;
1035             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1036             if (nextSlot.addr == address(0)) {
1037                 // This will suffice for checking _exists(nextTokenId),
1038                 // as a burned slot cannot contain the zero address.
1039                 if (nextTokenId != _currentIndex) {
1040                     nextSlot.addr = from;
1041                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1042                 }
1043             }
1044         }
1045 
1046         emit Transfer(from, to, tokenId);
1047         _afterTokenTransfers(from, to, tokenId, 1);
1048     }
1049 
1050     /**
1051      * @dev This is equivalent to _burn(tokenId, false)
1052      */
1053     function _burn(uint256 tokenId) internal virtual {
1054         _burn(tokenId, false);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1068         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1069 
1070         address from = prevOwnership.addr;
1071 
1072         if (approvalCheck) {
1073             bool isApprovedOrOwner = (_msgSender() == from ||
1074                 isApprovedForAll(from, _msgSender()) ||
1075                 getApproved(tokenId) == _msgSender());
1076 
1077             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1078         }
1079 
1080         _beforeTokenTransfers(from, address(0), tokenId, 1);
1081 
1082         // Clear approvals from the previous owner
1083         _approve(address(0), tokenId, from);
1084 
1085         // Underflow of the sender's balance is impossible because we check for
1086         // ownership above and the recipient's balance can't realistically overflow.
1087         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1088         unchecked {
1089             AddressData storage addressData = _addressData[from];
1090             addressData.balance -= 1;
1091             addressData.numberBurned += 1;
1092 
1093             // Keep track of who burned the token, and the timestamp of burning.
1094             TokenOwnership storage currSlot = _ownerships[tokenId];
1095             currSlot.addr = from;
1096             currSlot.startTimestamp = uint64(block.timestamp);
1097             currSlot.burned = true;
1098 
1099             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1100             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1101             uint256 nextTokenId = tokenId + 1;
1102             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1103             if (nextSlot.addr == address(0)) {
1104                 // This will suffice for checking _exists(nextTokenId),
1105                 // as a burned slot cannot contain the zero address.
1106                 if (nextTokenId != _currentIndex) {
1107                     nextSlot.addr = from;
1108                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1109                 }
1110             }
1111         }
1112 
1113         emit Transfer(from, address(0), tokenId);
1114         _afterTokenTransfers(from, address(0), tokenId, 1);
1115 
1116         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1117         unchecked {
1118             _burnCounter++;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Approve `to` to operate on `tokenId`
1124      *
1125      * Emits a {Approval} event.
1126      */
1127     function _approve(
1128         address to,
1129         uint256 tokenId,
1130         address owner
1131     ) private {
1132         _tokenApprovals[tokenId] = to;
1133         emit Approval(owner, to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1138      *
1139      * @param from address representing the previous owner of the given token ID
1140      * @param to target address that will receive the tokens
1141      * @param tokenId uint256 ID of the token to be transferred
1142      * @param _data bytes optional data to send along with the call
1143      * @return bool whether the call correctly returned the expected magic value
1144      */
1145     function _checkContractOnERC721Received(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) private returns (bool) {
1151         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1152             return retval == IERC721Receiver(to).onERC721Received.selector;
1153         } catch (bytes memory reason) {
1154             if (reason.length == 0) {
1155                 revert TransferToNonERC721ReceiverImplementer();
1156             } else {
1157                 assembly {
1158                     revert(add(32, reason), mload(reason))
1159                 }
1160             }
1161         }
1162     }
1163 
1164     /**
1165      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1166      * And also called before burning one token.
1167      *
1168      * startTokenId - the first token id to be transferred
1169      * quantity - the amount to be transferred
1170      *
1171      * Calling conditions:
1172      *
1173      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1174      * transferred to `to`.
1175      * - When `from` is zero, `tokenId` will be minted for `to`.
1176      * - When `to` is zero, `tokenId` will be burned by `from`.
1177      * - `from` and `to` are never both zero.
1178      */
1179     function _beforeTokenTransfers(
1180         address from,
1181         address to,
1182         uint256 startTokenId,
1183         uint256 quantity
1184     ) internal virtual {}
1185 
1186     /**
1187      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1188      * minting.
1189      * And also called after one token has been burned.
1190      *
1191      * startTokenId - the first token id to be transferred
1192      * quantity - the amount to be transferred
1193      *
1194      * Calling conditions:
1195      *
1196      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1197      * transferred to `to`.
1198      * - When `from` is zero, `tokenId` has been minted for `to`.
1199      * - When `to` is zero, `tokenId` has been burned by `from`.
1200      * - `from` and `to` are never both zero.
1201      */
1202     function _afterTokenTransfers(
1203         address from,
1204         address to,
1205         uint256 startTokenId,
1206         uint256 quantity
1207     ) internal virtual {}
1208 }
1209 
1210 // File: @openzeppelin/contracts/access/Ownable.sol
1211 
1212 
1213 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 
1218 /**
1219  * @dev Contract module which provides a basic access control mechanism, where
1220  * there is an account (an owner) that can be granted exclusive access to
1221  * specific functions.
1222  *
1223  * By default, the owner account will be the one that deploys the contract. This
1224  * can later be changed with {transferOwnership}.
1225  *
1226  * This module is used through inheritance. It will make available the modifier
1227  * `onlyOwner`, which can be applied to your functions to restrict their use to
1228  * the owner.
1229  */
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
1253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
1288 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1289 
1290 
1291 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1292 
1293 pragma solidity ^0.8.0;
1294 
1295 /**
1296  * @dev These functions deal with verification of Merkle Trees proofs.
1297  *
1298  * The proofs can be generated using the JavaScript library
1299  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1300  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1301  *
1302  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1303  *
1304  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1305  * hashing, or use a hash function other than keccak256 for hashing leaves.
1306  * This is because the concatenation of a sorted pair of internal nodes in
1307  * the merkle tree could be reinterpreted as a leaf value.
1308  */
1309 library MerkleProof {
1310     /**
1311      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1312      * defined by `root`. For this, a `proof` must be provided, containing
1313      * sibling hashes on the branch from the leaf to the root of the tree. Each
1314      * pair of leaves and each pair of pre-images are assumed to be sorted.
1315      */
1316     function verify(
1317         bytes32[] memory proof,
1318         bytes32 root,
1319         bytes32 leaf
1320     ) internal pure returns (bool) {
1321         return processProof(proof, leaf) == root;
1322     }
1323 
1324     /**
1325      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1326      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1327      * hash matches the root of the tree. When processing the proof, the pairs
1328      * of leafs & pre-images are assumed to be sorted.
1329      *
1330      * _Available since v4.4._
1331      */
1332     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1333         bytes32 computedHash = leaf;
1334         for (uint256 i = 0; i < proof.length; i++) {
1335             bytes32 proofElement = proof[i];
1336             if (computedHash <= proofElement) {
1337                 // Hash(current computed hash + current element of the proof)
1338                 computedHash = _efficientHash(computedHash, proofElement);
1339             } else {
1340                 // Hash(current element of the proof + current computed hash)
1341                 computedHash = _efficientHash(proofElement, computedHash);
1342             }
1343         }
1344         return computedHash;
1345     }
1346 
1347     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1348         assembly {
1349             mstore(0x00, a)
1350             mstore(0x20, b)
1351             value := keccak256(0x00, 0x40)
1352         }
1353     }
1354 }
1355 
1356 // File: hardhat/console.sol
1357 
1358 
1359 pragma solidity >= 0.4.22 <0.9.0;
1360 
1361 library console {
1362 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1363 
1364 	function _sendLogPayload(bytes memory payload) private view {
1365 		uint256 payloadLength = payload.length;
1366 		address consoleAddress = CONSOLE_ADDRESS;
1367 		assembly {
1368 			let payloadStart := add(payload, 32)
1369 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1370 		}
1371 	}
1372 
1373 	function log() internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log()"));
1375 	}
1376 
1377 	function logInt(int p0) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1379 	}
1380 
1381 	function logUint(uint p0) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1383 	}
1384 
1385 	function logString(string memory p0) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1387 	}
1388 
1389 	function logBool(bool p0) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1391 	}
1392 
1393 	function logAddress(address p0) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1395 	}
1396 
1397 	function logBytes(bytes memory p0) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1399 	}
1400 
1401 	function logBytes1(bytes1 p0) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1403 	}
1404 
1405 	function logBytes2(bytes2 p0) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1407 	}
1408 
1409 	function logBytes3(bytes3 p0) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1411 	}
1412 
1413 	function logBytes4(bytes4 p0) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1415 	}
1416 
1417 	function logBytes5(bytes5 p0) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1419 	}
1420 
1421 	function logBytes6(bytes6 p0) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1423 	}
1424 
1425 	function logBytes7(bytes7 p0) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1427 	}
1428 
1429 	function logBytes8(bytes8 p0) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1431 	}
1432 
1433 	function logBytes9(bytes9 p0) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1435 	}
1436 
1437 	function logBytes10(bytes10 p0) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1439 	}
1440 
1441 	function logBytes11(bytes11 p0) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1443 	}
1444 
1445 	function logBytes12(bytes12 p0) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1447 	}
1448 
1449 	function logBytes13(bytes13 p0) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1451 	}
1452 
1453 	function logBytes14(bytes14 p0) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1455 	}
1456 
1457 	function logBytes15(bytes15 p0) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1459 	}
1460 
1461 	function logBytes16(bytes16 p0) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1463 	}
1464 
1465 	function logBytes17(bytes17 p0) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1467 	}
1468 
1469 	function logBytes18(bytes18 p0) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1471 	}
1472 
1473 	function logBytes19(bytes19 p0) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1475 	}
1476 
1477 	function logBytes20(bytes20 p0) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1479 	}
1480 
1481 	function logBytes21(bytes21 p0) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1483 	}
1484 
1485 	function logBytes22(bytes22 p0) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1487 	}
1488 
1489 	function logBytes23(bytes23 p0) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1491 	}
1492 
1493 	function logBytes24(bytes24 p0) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1495 	}
1496 
1497 	function logBytes25(bytes25 p0) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1499 	}
1500 
1501 	function logBytes26(bytes26 p0) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1503 	}
1504 
1505 	function logBytes27(bytes27 p0) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1507 	}
1508 
1509 	function logBytes28(bytes28 p0) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1511 	}
1512 
1513 	function logBytes29(bytes29 p0) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1515 	}
1516 
1517 	function logBytes30(bytes30 p0) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1519 	}
1520 
1521 	function logBytes31(bytes31 p0) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1523 	}
1524 
1525 	function logBytes32(bytes32 p0) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1527 	}
1528 
1529 	function log(uint p0) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1531 	}
1532 
1533 	function log(string memory p0) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1535 	}
1536 
1537 	function log(bool p0) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1539 	}
1540 
1541 	function log(address p0) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1543 	}
1544 
1545 	function log(uint p0, uint p1) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1547 	}
1548 
1549 	function log(uint p0, string memory p1) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1551 	}
1552 
1553 	function log(uint p0, bool p1) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1555 	}
1556 
1557 	function log(uint p0, address p1) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1559 	}
1560 
1561 	function log(string memory p0, uint p1) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1563 	}
1564 
1565 	function log(string memory p0, string memory p1) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1567 	}
1568 
1569 	function log(string memory p0, bool p1) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1571 	}
1572 
1573 	function log(string memory p0, address p1) internal view {
1574 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1575 	}
1576 
1577 	function log(bool p0, uint p1) internal view {
1578 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1579 	}
1580 
1581 	function log(bool p0, string memory p1) internal view {
1582 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1583 	}
1584 
1585 	function log(bool p0, bool p1) internal view {
1586 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1587 	}
1588 
1589 	function log(bool p0, address p1) internal view {
1590 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1591 	}
1592 
1593 	function log(address p0, uint p1) internal view {
1594 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1595 	}
1596 
1597 	function log(address p0, string memory p1) internal view {
1598 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1599 	}
1600 
1601 	function log(address p0, bool p1) internal view {
1602 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1603 	}
1604 
1605 	function log(address p0, address p1) internal view {
1606 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1607 	}
1608 
1609 	function log(uint p0, uint p1, uint p2) internal view {
1610 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1611 	}
1612 
1613 	function log(uint p0, uint p1, string memory p2) internal view {
1614 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1615 	}
1616 
1617 	function log(uint p0, uint p1, bool p2) internal view {
1618 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1619 	}
1620 
1621 	function log(uint p0, uint p1, address p2) internal view {
1622 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1623 	}
1624 
1625 	function log(uint p0, string memory p1, uint p2) internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1627 	}
1628 
1629 	function log(uint p0, string memory p1, string memory p2) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1631 	}
1632 
1633 	function log(uint p0, string memory p1, bool p2) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1635 	}
1636 
1637 	function log(uint p0, string memory p1, address p2) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1639 	}
1640 
1641 	function log(uint p0, bool p1, uint p2) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1643 	}
1644 
1645 	function log(uint p0, bool p1, string memory p2) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1647 	}
1648 
1649 	function log(uint p0, bool p1, bool p2) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1651 	}
1652 
1653 	function log(uint p0, bool p1, address p2) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1655 	}
1656 
1657 	function log(uint p0, address p1, uint p2) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1659 	}
1660 
1661 	function log(uint p0, address p1, string memory p2) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1663 	}
1664 
1665 	function log(uint p0, address p1, bool p2) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1667 	}
1668 
1669 	function log(uint p0, address p1, address p2) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1671 	}
1672 
1673 	function log(string memory p0, uint p1, uint p2) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1675 	}
1676 
1677 	function log(string memory p0, uint p1, string memory p2) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1679 	}
1680 
1681 	function log(string memory p0, uint p1, bool p2) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1683 	}
1684 
1685 	function log(string memory p0, uint p1, address p2) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1687 	}
1688 
1689 	function log(string memory p0, string memory p1, uint p2) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1691 	}
1692 
1693 	function log(string memory p0, string memory p1, string memory p2) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1695 	}
1696 
1697 	function log(string memory p0, string memory p1, bool p2) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1699 	}
1700 
1701 	function log(string memory p0, string memory p1, address p2) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1703 	}
1704 
1705 	function log(string memory p0, bool p1, uint p2) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1707 	}
1708 
1709 	function log(string memory p0, bool p1, string memory p2) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1711 	}
1712 
1713 	function log(string memory p0, bool p1, bool p2) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1715 	}
1716 
1717 	function log(string memory p0, bool p1, address p2) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1719 	}
1720 
1721 	function log(string memory p0, address p1, uint p2) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1723 	}
1724 
1725 	function log(string memory p0, address p1, string memory p2) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1727 	}
1728 
1729 	function log(string memory p0, address p1, bool p2) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1731 	}
1732 
1733 	function log(string memory p0, address p1, address p2) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1735 	}
1736 
1737 	function log(bool p0, uint p1, uint p2) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1739 	}
1740 
1741 	function log(bool p0, uint p1, string memory p2) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1743 	}
1744 
1745 	function log(bool p0, uint p1, bool p2) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1747 	}
1748 
1749 	function log(bool p0, uint p1, address p2) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1751 	}
1752 
1753 	function log(bool p0, string memory p1, uint p2) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1755 	}
1756 
1757 	function log(bool p0, string memory p1, string memory p2) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1759 	}
1760 
1761 	function log(bool p0, string memory p1, bool p2) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1763 	}
1764 
1765 	function log(bool p0, string memory p1, address p2) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1767 	}
1768 
1769 	function log(bool p0, bool p1, uint p2) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1771 	}
1772 
1773 	function log(bool p0, bool p1, string memory p2) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1775 	}
1776 
1777 	function log(bool p0, bool p1, bool p2) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1779 	}
1780 
1781 	function log(bool p0, bool p1, address p2) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1783 	}
1784 
1785 	function log(bool p0, address p1, uint p2) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1787 	}
1788 
1789 	function log(bool p0, address p1, string memory p2) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1791 	}
1792 
1793 	function log(bool p0, address p1, bool p2) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1795 	}
1796 
1797 	function log(bool p0, address p1, address p2) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1799 	}
1800 
1801 	function log(address p0, uint p1, uint p2) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1803 	}
1804 
1805 	function log(address p0, uint p1, string memory p2) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1807 	}
1808 
1809 	function log(address p0, uint p1, bool p2) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1811 	}
1812 
1813 	function log(address p0, uint p1, address p2) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1815 	}
1816 
1817 	function log(address p0, string memory p1, uint p2) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1819 	}
1820 
1821 	function log(address p0, string memory p1, string memory p2) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1823 	}
1824 
1825 	function log(address p0, string memory p1, bool p2) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1827 	}
1828 
1829 	function log(address p0, string memory p1, address p2) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1831 	}
1832 
1833 	function log(address p0, bool p1, uint p2) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1835 	}
1836 
1837 	function log(address p0, bool p1, string memory p2) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1839 	}
1840 
1841 	function log(address p0, bool p1, bool p2) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1843 	}
1844 
1845 	function log(address p0, bool p1, address p2) internal view {
1846 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1847 	}
1848 
1849 	function log(address p0, address p1, uint p2) internal view {
1850 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1851 	}
1852 
1853 	function log(address p0, address p1, string memory p2) internal view {
1854 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1855 	}
1856 
1857 	function log(address p0, address p1, bool p2) internal view {
1858 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1859 	}
1860 
1861 	function log(address p0, address p1, address p2) internal view {
1862 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1863 	}
1864 
1865 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1866 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1867 	}
1868 
1869 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1870 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1871 	}
1872 
1873 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1874 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1875 	}
1876 
1877 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1878 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1879 	}
1880 
1881 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1882 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1883 	}
1884 
1885 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1886 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1887 	}
1888 
1889 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1890 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1891 	}
1892 
1893 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1894 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1895 	}
1896 
1897 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1898 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1899 	}
1900 
1901 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1902 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1903 	}
1904 
1905 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1906 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1907 	}
1908 
1909 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1910 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1911 	}
1912 
1913 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1914 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1915 	}
1916 
1917 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1918 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1919 	}
1920 
1921 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1922 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1923 	}
1924 
1925 	function log(uint p0, uint p1, address p2, address p3) internal view {
1926 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1927 	}
1928 
1929 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1930 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1931 	}
1932 
1933 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1934 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1935 	}
1936 
1937 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1938 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1939 	}
1940 
1941 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1942 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1943 	}
1944 
1945 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1946 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1947 	}
1948 
1949 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1950 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1951 	}
1952 
1953 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1954 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1955 	}
1956 
1957 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1958 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1959 	}
1960 
1961 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1962 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1963 	}
1964 
1965 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1966 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1967 	}
1968 
1969 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1970 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1971 	}
1972 
1973 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1974 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1975 	}
1976 
1977 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1978 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1979 	}
1980 
1981 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1982 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1983 	}
1984 
1985 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1986 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1987 	}
1988 
1989 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1990 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1991 	}
1992 
1993 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1994 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1995 	}
1996 
1997 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1998 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1999 	}
2000 
2001 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2002 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2003 	}
2004 
2005 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2006 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2007 	}
2008 
2009 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2010 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2011 	}
2012 
2013 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2014 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2015 	}
2016 
2017 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2018 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2019 	}
2020 
2021 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2022 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2023 	}
2024 
2025 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2026 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2027 	}
2028 
2029 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2030 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2031 	}
2032 
2033 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2034 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2035 	}
2036 
2037 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2038 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2039 	}
2040 
2041 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2042 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2043 	}
2044 
2045 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2046 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2047 	}
2048 
2049 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2050 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2051 	}
2052 
2053 	function log(uint p0, bool p1, address p2, address p3) internal view {
2054 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2055 	}
2056 
2057 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2058 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2059 	}
2060 
2061 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2062 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2063 	}
2064 
2065 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2066 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2067 	}
2068 
2069 	function log(uint p0, address p1, uint p2, address p3) internal view {
2070 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2071 	}
2072 
2073 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2074 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2075 	}
2076 
2077 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2078 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2079 	}
2080 
2081 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2082 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2083 	}
2084 
2085 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2086 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2087 	}
2088 
2089 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2090 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2091 	}
2092 
2093 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2094 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2095 	}
2096 
2097 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2098 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2099 	}
2100 
2101 	function log(uint p0, address p1, bool p2, address p3) internal view {
2102 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2103 	}
2104 
2105 	function log(uint p0, address p1, address p2, uint p3) internal view {
2106 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2107 	}
2108 
2109 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2110 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2111 	}
2112 
2113 	function log(uint p0, address p1, address p2, bool p3) internal view {
2114 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2115 	}
2116 
2117 	function log(uint p0, address p1, address p2, address p3) internal view {
2118 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2119 	}
2120 
2121 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2122 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2123 	}
2124 
2125 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2126 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2127 	}
2128 
2129 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2130 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2131 	}
2132 
2133 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2134 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2135 	}
2136 
2137 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2138 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2139 	}
2140 
2141 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2142 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2143 	}
2144 
2145 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2146 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2147 	}
2148 
2149 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2150 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2151 	}
2152 
2153 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2154 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2155 	}
2156 
2157 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2158 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2159 	}
2160 
2161 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2162 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2163 	}
2164 
2165 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2166 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2167 	}
2168 
2169 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2170 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2171 	}
2172 
2173 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2174 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2175 	}
2176 
2177 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2178 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2179 	}
2180 
2181 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2182 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2183 	}
2184 
2185 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2186 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2187 	}
2188 
2189 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2190 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2191 	}
2192 
2193 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2194 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2195 	}
2196 
2197 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2198 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2199 	}
2200 
2201 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2202 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2203 	}
2204 
2205 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2206 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2207 	}
2208 
2209 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2210 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2211 	}
2212 
2213 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2214 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2215 	}
2216 
2217 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2218 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2219 	}
2220 
2221 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2222 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2223 	}
2224 
2225 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2226 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2227 	}
2228 
2229 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2230 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2231 	}
2232 
2233 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2234 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2235 	}
2236 
2237 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2238 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2239 	}
2240 
2241 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2242 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2243 	}
2244 
2245 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2246 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2247 	}
2248 
2249 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2250 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2251 	}
2252 
2253 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2254 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2255 	}
2256 
2257 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2258 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2259 	}
2260 
2261 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2262 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2263 	}
2264 
2265 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2266 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2267 	}
2268 
2269 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2270 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2271 	}
2272 
2273 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2274 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2275 	}
2276 
2277 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2278 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2279 	}
2280 
2281 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2282 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2283 	}
2284 
2285 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2286 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2287 	}
2288 
2289 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2290 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2291 	}
2292 
2293 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2294 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2295 	}
2296 
2297 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2298 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2299 	}
2300 
2301 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2302 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2303 	}
2304 
2305 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2306 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2307 	}
2308 
2309 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2310 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2311 	}
2312 
2313 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2314 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2315 	}
2316 
2317 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2318 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2319 	}
2320 
2321 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2322 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2323 	}
2324 
2325 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2326 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2327 	}
2328 
2329 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2330 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2331 	}
2332 
2333 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2334 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2335 	}
2336 
2337 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2338 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2339 	}
2340 
2341 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2342 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2343 	}
2344 
2345 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2346 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2347 	}
2348 
2349 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2350 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2351 	}
2352 
2353 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2354 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2355 	}
2356 
2357 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2358 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2359 	}
2360 
2361 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2362 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2363 	}
2364 
2365 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2366 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2367 	}
2368 
2369 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2370 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2371 	}
2372 
2373 	function log(string memory p0, address p1, address p2, address p3) internal view {
2374 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2375 	}
2376 
2377 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2378 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2379 	}
2380 
2381 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2382 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2383 	}
2384 
2385 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2386 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2387 	}
2388 
2389 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2390 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2391 	}
2392 
2393 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2394 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2395 	}
2396 
2397 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2398 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2399 	}
2400 
2401 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2402 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2403 	}
2404 
2405 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2406 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2407 	}
2408 
2409 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2410 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2411 	}
2412 
2413 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2414 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2415 	}
2416 
2417 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2418 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2419 	}
2420 
2421 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2422 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2423 	}
2424 
2425 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2426 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2427 	}
2428 
2429 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2430 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2431 	}
2432 
2433 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2434 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2435 	}
2436 
2437 	function log(bool p0, uint p1, address p2, address p3) internal view {
2438 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2439 	}
2440 
2441 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2442 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2443 	}
2444 
2445 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2446 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2447 	}
2448 
2449 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2450 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2451 	}
2452 
2453 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2454 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2455 	}
2456 
2457 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2458 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2459 	}
2460 
2461 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2462 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2463 	}
2464 
2465 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2466 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2467 	}
2468 
2469 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2470 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2471 	}
2472 
2473 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2474 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2475 	}
2476 
2477 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2478 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2479 	}
2480 
2481 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2482 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2483 	}
2484 
2485 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2486 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2487 	}
2488 
2489 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2490 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2491 	}
2492 
2493 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2494 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2495 	}
2496 
2497 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2498 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2499 	}
2500 
2501 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2502 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2503 	}
2504 
2505 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2506 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2507 	}
2508 
2509 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2510 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2511 	}
2512 
2513 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2514 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2515 	}
2516 
2517 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2518 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2519 	}
2520 
2521 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2522 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2523 	}
2524 
2525 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2526 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2527 	}
2528 
2529 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2530 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2531 	}
2532 
2533 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2534 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2535 	}
2536 
2537 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2538 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2539 	}
2540 
2541 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2542 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2543 	}
2544 
2545 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2546 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2547 	}
2548 
2549 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2550 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2551 	}
2552 
2553 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2554 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2555 	}
2556 
2557 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2558 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2559 	}
2560 
2561 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2562 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2563 	}
2564 
2565 	function log(bool p0, bool p1, address p2, address p3) internal view {
2566 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2567 	}
2568 
2569 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2570 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2571 	}
2572 
2573 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2574 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2575 	}
2576 
2577 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2578 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2579 	}
2580 
2581 	function log(bool p0, address p1, uint p2, address p3) internal view {
2582 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2583 	}
2584 
2585 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2586 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2587 	}
2588 
2589 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2590 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2591 	}
2592 
2593 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2594 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2595 	}
2596 
2597 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2598 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2599 	}
2600 
2601 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2602 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2603 	}
2604 
2605 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2606 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2607 	}
2608 
2609 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2610 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2611 	}
2612 
2613 	function log(bool p0, address p1, bool p2, address p3) internal view {
2614 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2615 	}
2616 
2617 	function log(bool p0, address p1, address p2, uint p3) internal view {
2618 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2619 	}
2620 
2621 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2622 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2623 	}
2624 
2625 	function log(bool p0, address p1, address p2, bool p3) internal view {
2626 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2627 	}
2628 
2629 	function log(bool p0, address p1, address p2, address p3) internal view {
2630 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2631 	}
2632 
2633 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2634 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2635 	}
2636 
2637 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2638 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2639 	}
2640 
2641 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2642 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2643 	}
2644 
2645 	function log(address p0, uint p1, uint p2, address p3) internal view {
2646 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2647 	}
2648 
2649 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2650 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2651 	}
2652 
2653 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2654 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2655 	}
2656 
2657 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2658 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2659 	}
2660 
2661 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2662 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2663 	}
2664 
2665 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2666 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2667 	}
2668 
2669 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2670 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2671 	}
2672 
2673 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2674 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2675 	}
2676 
2677 	function log(address p0, uint p1, bool p2, address p3) internal view {
2678 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2679 	}
2680 
2681 	function log(address p0, uint p1, address p2, uint p3) internal view {
2682 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2683 	}
2684 
2685 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2686 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2687 	}
2688 
2689 	function log(address p0, uint p1, address p2, bool p3) internal view {
2690 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2691 	}
2692 
2693 	function log(address p0, uint p1, address p2, address p3) internal view {
2694 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2695 	}
2696 
2697 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2698 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2699 	}
2700 
2701 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2702 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2703 	}
2704 
2705 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2706 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2707 	}
2708 
2709 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2710 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2711 	}
2712 
2713 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2714 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2715 	}
2716 
2717 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2718 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2719 	}
2720 
2721 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2722 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2723 	}
2724 
2725 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2726 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2727 	}
2728 
2729 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2730 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2731 	}
2732 
2733 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2734 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2735 	}
2736 
2737 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2738 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2739 	}
2740 
2741 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2742 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2743 	}
2744 
2745 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2746 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2747 	}
2748 
2749 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2750 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2751 	}
2752 
2753 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2754 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2755 	}
2756 
2757 	function log(address p0, string memory p1, address p2, address p3) internal view {
2758 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2759 	}
2760 
2761 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2762 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2763 	}
2764 
2765 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2766 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2767 	}
2768 
2769 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2770 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2771 	}
2772 
2773 	function log(address p0, bool p1, uint p2, address p3) internal view {
2774 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2775 	}
2776 
2777 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2778 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2779 	}
2780 
2781 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2782 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2783 	}
2784 
2785 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2786 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2787 	}
2788 
2789 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2790 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2791 	}
2792 
2793 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2794 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2795 	}
2796 
2797 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2798 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2799 	}
2800 
2801 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2802 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2803 	}
2804 
2805 	function log(address p0, bool p1, bool p2, address p3) internal view {
2806 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2807 	}
2808 
2809 	function log(address p0, bool p1, address p2, uint p3) internal view {
2810 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2811 	}
2812 
2813 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2814 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2815 	}
2816 
2817 	function log(address p0, bool p1, address p2, bool p3) internal view {
2818 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2819 	}
2820 
2821 	function log(address p0, bool p1, address p2, address p3) internal view {
2822 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2823 	}
2824 
2825 	function log(address p0, address p1, uint p2, uint p3) internal view {
2826 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2827 	}
2828 
2829 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2830 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2831 	}
2832 
2833 	function log(address p0, address p1, uint p2, bool p3) internal view {
2834 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2835 	}
2836 
2837 	function log(address p0, address p1, uint p2, address p3) internal view {
2838 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2839 	}
2840 
2841 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2842 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2843 	}
2844 
2845 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2846 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2847 	}
2848 
2849 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2850 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2851 	}
2852 
2853 	function log(address p0, address p1, string memory p2, address p3) internal view {
2854 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2855 	}
2856 
2857 	function log(address p0, address p1, bool p2, uint p3) internal view {
2858 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2859 	}
2860 
2861 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2862 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2863 	}
2864 
2865 	function log(address p0, address p1, bool p2, bool p3) internal view {
2866 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2867 	}
2868 
2869 	function log(address p0, address p1, bool p2, address p3) internal view {
2870 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2871 	}
2872 
2873 	function log(address p0, address p1, address p2, uint p3) internal view {
2874 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2875 	}
2876 
2877 	function log(address p0, address p1, address p2, string memory p3) internal view {
2878 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2879 	}
2880 
2881 	function log(address p0, address p1, address p2, bool p3) internal view {
2882 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2883 	}
2884 
2885 	function log(address p0, address p1, address p2, address p3) internal view {
2886 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2887 	}
2888 
2889 }
2890 
2891 // File: contracts/kujira.sol
2892 
2893 //SPDX-License-Identifier: Unlicense
2894 pragma solidity ^0.8.0;
2895 
2896 
2897 
2898 
2899 
2900 
2901 contract KujiraWhales is ERC721A, Ownable {
2902     using Strings for uint256;
2903 
2904     mapping(address => uint256) numberToMint;
2905     bool public mintOpen = false;
2906     bool public revealed = false;
2907     string public notRevealedURI;
2908     string public baseTokenURI;
2909 
2910     constructor() ERC721A("Kujira no konton", "knw"){}
2911 
2912     function whitelistMint(uint256 _nbr) public {
2913         require(mintOpen, "the mint is not open");
2914         require(numberToMint[msg.sender] >= _nbr, "you don't have enough nft to mint");
2915         numberToMint[msg.sender] = numberToMint[msg.sender] - _nbr;
2916         _safeMint(msg.sender, _nbr);
2917     }
2918 
2919     function setOwner(address[] memory _addresses, uint256[] memory _nbr) public onlyOwner {
2920         require(_addresses.length > 0, "array addresses is empty");
2921         require(_nbr.length > 0, "array nbr is empty");
2922         require(_nbr.length == _addresses.length, "not same size");
2923         for (uint256 i = 0; i < _nbr.length; i++) {
2924             numberToMint[_addresses[i]] = _nbr[i];
2925         }
2926     }
2927 
2928     function tokenURI(uint256 tokenId)
2929         public
2930         view
2931         virtual
2932         override
2933         returns (string memory)
2934     {
2935         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2936 
2937         if(!revealed) {
2938             return notRevealedURI;
2939         }
2940         string memory baseURI = baseTokenURI;
2941         return bytes(baseURI).length > 0
2942             ? string(abi.encodePacked(baseURI, tokenId.toString()))
2943             : "";
2944     }
2945 
2946     function addressHasToMint(address _address) public view returns(uint256) {
2947         return numberToMint[_address];
2948     }
2949 
2950     function setMint(bool _val) public onlyOwner {
2951         mintOpen = _val;
2952     }
2953 
2954     function reveal() public onlyOwner {
2955         revealed = true;
2956     }
2957 
2958     function setBaseURI(string memory _baseURI) public onlyOwner {
2959         baseTokenURI = _baseURI;
2960     }
2961 
2962     function setNotRevealURI(string memory _notRevealedURI) public onlyOwner {
2963         notRevealedURI = _notRevealedURI;
2964     }
2965 
2966     function withdraw() public payable onlyOwner {
2967         (bool os, ) = payable(owner()).call{ value: address(this).balance }("");
2968         require(os);
2969     }
2970 }