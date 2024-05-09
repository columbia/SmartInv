1 // File contracts/Archive/lib/utils/introspection/IERC165.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.4;
7 
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File contracts/Archive/lib/token/ERC721/IERC721.sol
32 
33 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
34 
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 
175 // File contracts/Archive/lib/token/ERC721/IERC721Receiver.sol
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
178 
179 
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 
205 // File contracts/Archive/lib/token/ERC721/extensions/IERC721Metadata.sol
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
208 
209 
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216     /**
217      * @dev Returns the token collection name.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the token collection symbol.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228      */
229     function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 
233 // File contracts/Archive/lib/utils/Address.sol
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
236 
237 
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         uint256 size;
266         assembly {
267             size := extcodesize(account)
268         }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 
453 // File contracts/Archive/lib/utils/Context.sol
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
456 
457 
458 
459 /**
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view virtual returns (bytes calldata) {
475         return msg.data;
476     }
477 }
478 
479 
480 // File contracts/Archive/lib/utils/Strings.sol
481 
482 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
483 
484 
485 
486 /**
487  * @dev String operations.
488  */
489 library Strings {
490     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
494      */
495     function toString(uint256 value) internal pure returns (string memory) {
496         // Inspired by OraclizeAPI's implementation - MIT licence
497         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
498 
499         if (value == 0) {
500             return "0";
501         }
502         uint256 temp = value;
503         uint256 digits;
504         while (temp != 0) {
505             digits++;
506             temp /= 10;
507         }
508         bytes memory buffer = new bytes(digits);
509         while (value != 0) {
510             digits -= 1;
511             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
512             value /= 10;
513         }
514         return string(buffer);
515     }
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
519      */
520     function toHexString(uint256 value) internal pure returns (string memory) {
521         if (value == 0) {
522             return "0x00";
523         }
524         uint256 temp = value;
525         uint256 length = 0;
526         while (temp != 0) {
527             length++;
528             temp >>= 8;
529         }
530         return toHexString(value, length);
531     }
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
535      */
536     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
537         bytes memory buffer = new bytes(2 * length + 2);
538         buffer[0] = "0";
539         buffer[1] = "x";
540         for (uint256 i = 2 * length + 1; i > 1; --i) {
541             buffer[i] = _HEX_SYMBOLS[value & 0xf];
542             value >>= 4;
543         }
544         require(value == 0, "Strings: hex length insufficient");
545         return string(buffer);
546     }
547 }
548 
549 
550 // File contracts/Archive/lib/utils/introspection/ERC165.sol
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 
580 // File contracts/Archive/lib/token/ERC721A.sol
581 
582 // Creator: Chiru Labs
583 
584 
585 
586 
587 
588 
589 
590 
591 
592     error ApprovalCallerNotOwnerNorApproved();
593     error ApprovalQueryForNonexistentToken();
594     error ApproveToCaller();
595     error ApprovalToCurrentOwner();
596     error BalanceQueryForZeroAddress();
597     error MintToZeroAddress();
598     error MintZeroQuantity();
599     error OwnerQueryForNonexistentToken();
600     error TransferCallerNotOwnerNorApproved();
601     error TransferFromIncorrectOwner();
602     error TransferToNonERC721ReceiverImplementer();
603     error TransferToZeroAddress();
604     error URIQueryForNonexistentToken();
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata extension. Built to optimize for lower gas during batch mints.
609  *
610  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
611  *
612  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
613  *
614  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
615  */
616 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
617     using Address for address;
618     using Strings for uint256;
619 
620     // Compiler will pack this into a single 256bit word.
621     struct TokenOwnership {
622         // The address of the owner.
623         address addr;
624         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
625         uint64 startTimestamp;
626         // Whether the token has been burned.
627         bool burned;
628     }
629 
630     // Compiler will pack this into a single 256bit word.
631     struct AddressData {
632         // Realistically, 2**64-1 is more than enough.
633         uint64 balance;
634         // Keeps track of mint count with minimal overhead for tokenomics.
635         uint64 numberMinted;
636         // Keeps track of burn count with minimal overhead for tokenomics.
637         uint64 numberBurned;
638         // For miscellaneous variable(s) pertaining to the address
639         // (e.g. number of whitelist mint slots used).
640         // If there are multiple variables, please pack them into a uint64.
641         uint64 aux;
642     }
643 
644     // The tokenId of the next token to be minted.
645     uint256 internal _currentIndex;
646 
647     // The number of tokens burned.
648     uint256 internal _burnCounter;
649 
650     // Token name
651     string private _name;
652 
653     // Token symbol
654     string private _symbol;
655 
656     // Mapping from token ID to ownership details
657     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
658     mapping(uint256 => TokenOwnership) internal _ownerships;
659 
660     // Mapping owner address to address data
661     mapping(address => AddressData) private _addressData;
662 
663     // Mapping from token ID to approved address
664     mapping(uint256 => address) private _tokenApprovals;
665 
666     // Mapping from owner to operator approvals
667     mapping(address => mapping(address => bool)) private _operatorApprovals;
668 
669     constructor(string memory name_, string memory symbol_) {
670         _name = name_;
671         _symbol = symbol_;
672         _currentIndex = _startTokenId();
673     }
674 
675     /**
676      * To change the starting tokenId, please override this function.
677      */
678     function _startTokenId() internal view virtual returns (uint256) {
679         return 0;
680     }
681 
682     /**
683      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
684      */
685     function totalSupply() public view returns (uint256) {
686         // Counter underflow is impossible as _burnCounter cannot be incremented
687         // more than _currentIndex - _startTokenId() times
688     unchecked {
689         return _currentIndex - _burnCounter - _startTokenId();
690     }
691     }
692 
693     /**
694      * Returns the total amount of tokens minted in the contract.
695      */
696     function _totalMinted() internal view returns (uint256) {
697         // Counter underflow is impossible as _currentIndex does not decrement,
698         // and it is initialized to _startTokenId()
699     unchecked {
700         return _currentIndex - _startTokenId();
701     }
702     }
703 
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
708         return
709         interfaceId == type(IERC721).interfaceId ||
710         interfaceId == type(IERC721Metadata).interfaceId ||
711         super.supportsInterface(interfaceId);
712     }
713 
714     /**
715      * @dev See {IERC721-balanceOf}.
716      */
717     function balanceOf(address owner) public view override returns (uint256) {
718         if (owner == address(0)) revert BalanceQueryForZeroAddress();
719         return uint256(_addressData[owner].balance);
720     }
721 
722     /**
723      * Returns the number of tokens minted by `owner`.
724      */
725     function _numberMinted(address owner) internal view returns (uint256) {
726         return uint256(_addressData[owner].numberMinted);
727     }
728 
729     /**
730      * Returns the number of tokens burned by or on behalf of `owner`.
731      */
732     function _numberBurned(address owner) internal view returns (uint256) {
733         return uint256(_addressData[owner].numberBurned);
734     }
735 
736     /**
737      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
738      */
739     function _getAux(address owner) internal view returns (uint64) {
740         return _addressData[owner].aux;
741     }
742 
743     /**
744      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
745      * If there are multiple variables, please pack them into a uint64.
746      */
747     function _setAux(address owner, uint64 aux) internal {
748         _addressData[owner].aux = aux;
749     }
750 
751     /**
752      * Gas spent here starts off proportional to the maximum mint batch size.
753      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
754      */
755     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
756         uint256 curr = tokenId;
757 
758     unchecked {
759         if (_startTokenId() <= curr && curr < _currentIndex) {
760             TokenOwnership memory ownership = _ownerships[curr];
761             if (!ownership.burned) {
762                 if (ownership.addr != address(0)) {
763                     return ownership;
764                 }
765                 // Invariant:
766                 // There will always be an ownership that has an address and is not burned
767                 // before an ownership that does not have an address and is not burned.
768                 // Hence, curr will not underflow.
769                 while (true) {
770                     curr--;
771                     ownership = _ownerships[curr];
772                     if (ownership.addr != address(0)) {
773                         return ownership;
774                     }
775                 }
776             }
777         }
778     }
779         revert OwnerQueryForNonexistentToken();
780     }
781 
782     /**
783      * @dev See {IERC721-ownerOf}.
784      */
785     function ownerOf(uint256 tokenId) public view override returns (address) {
786         return _ownershipOf(tokenId).addr;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-name}.
791      */
792     function name() public view virtual override returns (string memory) {
793         return _name;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-symbol}.
798      */
799     function symbol() public view virtual override returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-tokenURI}.
805      */
806     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
807         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
808 
809         string memory baseURI = _baseURI();
810         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
811     }
812 
813     /**
814      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
815      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
816      * by default, can be overriden in child contracts.
817      */
818     function _baseURI() internal view virtual returns (string memory) {
819         return '';
820     }
821 
822     /**
823      * @dev See {IERC721-approve}.
824      */
825     function approve(address to, uint256 tokenId) public override {
826         address owner = ERC721A.ownerOf(tokenId);
827         if (to == owner) revert ApprovalToCurrentOwner();
828 
829         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
830             revert ApprovalCallerNotOwnerNorApproved();
831         }
832 
833         _approve(to, tokenId, owner);
834     }
835 
836     /**
837      * @dev See {IERC721-getApproved}.
838      */
839     function getApproved(uint256 tokenId) public view override returns (address) {
840         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
841 
842         return _tokenApprovals[tokenId];
843     }
844 
845     /**
846      * @dev See {IERC721-setApprovalForAll}.
847      */
848     function setApprovalForAll(address operator, bool approved) public virtual override {
849         if (operator == _msgSender()) revert ApproveToCaller();
850 
851         _operatorApprovals[_msgSender()][operator] = approved;
852         emit ApprovalForAll(_msgSender(), operator, approved);
853     }
854 
855     /**
856      * @dev See {IERC721-isApprovedForAll}.
857      */
858     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
859         return _operatorApprovals[owner][operator];
860     }
861 
862     /**
863      * @dev See {IERC721-transferFrom}.
864      */
865     function transferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         _transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         safeTransferFrom(from, to, tokenId, '');
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) public virtual override {
893         _transfer(from, to, tokenId);
894         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
895             revert TransferToNonERC721ReceiverImplementer();
896         }
897     }
898 
899     /**
900      * @dev Returns whether `tokenId` exists.
901      *
902      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
903      *
904      * Tokens start existing when they are minted (`_mint`),
905      */
906     function _exists(uint256 tokenId) internal view returns (bool) {
907         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
908     }
909 
910     function _safeMint(address to, uint256 quantity) internal {
911         _safeMint(to, quantity, '');
912     }
913 
914     /**
915      * @dev Safely mints `quantity` tokens and transfers them to `to`.
916      *
917      * Requirements:
918      *
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
920      * - `quantity` must be greater than 0.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _safeMint(
925         address to,
926         uint256 quantity,
927         bytes memory _data
928     ) internal {
929         _mint(to, quantity, _data, true);
930     }
931 
932     /**
933      * @dev Mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - `to` cannot be the zero address.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _mint(
943         address to,
944         uint256 quantity,
945         bytes memory _data,
946         bool safe
947     ) internal {
948         uint256 startTokenId = _currentIndex;
949         if (to == address(0)) revert MintToZeroAddress();
950         if (quantity == 0) revert MintZeroQuantity();
951 
952         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
953 
954         // Overflows are incredibly unrealistic.
955         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
956         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
957     unchecked {
958         _addressData[to].balance += uint64(quantity);
959         _addressData[to].numberMinted += uint64(quantity);
960 
961         _ownerships[startTokenId].addr = to;
962         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
963 
964         uint256 updatedIndex = startTokenId;
965         uint256 end = updatedIndex + quantity;
966 
967         if (safe && to.isContract()) {
968             do {
969                 emit Transfer(address(0), to, updatedIndex);
970                 if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
971                     revert TransferToNonERC721ReceiverImplementer();
972                 }
973             } while (updatedIndex != end);
974             // Reentrancy protection
975             if (_currentIndex != startTokenId) revert();
976         } else {
977             do {
978                 emit Transfer(address(0), to, updatedIndex++);
979             } while (updatedIndex != end);
980         }
981         _currentIndex = updatedIndex;
982     }
983         _afterTokenTransfers(address(0), to, startTokenId, quantity);
984     }
985 
986     /**
987      * @dev Transfers `tokenId` from `from` to `to`.
988      *
989      * Requirements:
990      *
991      * - `to` cannot be the zero address.
992      * - `tokenId` token must be owned by `from`.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _transfer(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) private {
1001         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1002 
1003         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1004 
1005         bool isApprovedOrOwner = (_msgSender() == from ||
1006         isApprovedForAll(from, _msgSender()) ||
1007         getApproved(tokenId) == _msgSender());
1008 
1009         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1010         if (to == address(0)) revert TransferToZeroAddress();
1011 
1012         _beforeTokenTransfers(from, to, tokenId, 1);
1013 
1014         // Clear approvals from the previous owner
1015         _approve(address(0), tokenId, from);
1016 
1017         // Underflow of the sender's balance is impossible because we check for
1018         // ownership above and the recipient's balance can't realistically overflow.
1019         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1020     unchecked {
1021         _addressData[from].balance -= 1;
1022         _addressData[to].balance += 1;
1023 
1024         TokenOwnership storage currSlot = _ownerships[tokenId];
1025         currSlot.addr = to;
1026         currSlot.startTimestamp = uint64(block.timestamp);
1027 
1028         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1029         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1030         uint256 nextTokenId = tokenId + 1;
1031         TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1032         if (nextSlot.addr == address(0)) {
1033             // This will suffice for checking _exists(nextTokenId),
1034             // as a burned slot cannot contain the zero address.
1035             if (nextTokenId != _currentIndex) {
1036                 nextSlot.addr = from;
1037                 nextSlot.startTimestamp = prevOwnership.startTimestamp;
1038             }
1039         }
1040     }
1041 
1042         emit Transfer(from, to, tokenId);
1043         _afterTokenTransfers(from, to, tokenId, 1);
1044     }
1045 
1046     /**
1047      * @dev This is equivalent to _burn(tokenId, false)
1048      */
1049     function _burn(uint256 tokenId) internal virtual {
1050         _burn(tokenId, false);
1051     }
1052 
1053     /**
1054      * @dev Destroys `tokenId`.
1055      * The approval is cleared when the token is burned.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1064         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1065 
1066         address from = prevOwnership.addr;
1067 
1068         if (approvalCheck) {
1069             bool isApprovedOrOwner = (_msgSender() == from ||
1070             isApprovedForAll(from, _msgSender()) ||
1071             getApproved(tokenId) == _msgSender());
1072 
1073             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1074         }
1075 
1076         _beforeTokenTransfers(from, address(0), tokenId, 1);
1077 
1078         // Clear approvals from the previous owner
1079         _approve(address(0), tokenId, from);
1080 
1081         // Underflow of the sender's balance is impossible because we check for
1082         // ownership above and the recipient's balance can't realistically overflow.
1083         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1084     unchecked {
1085         AddressData storage addressData = _addressData[from];
1086         addressData.balance -= 1;
1087         addressData.numberBurned += 1;
1088 
1089         // Keep track of who burned the token, and the timestamp of burning.
1090         TokenOwnership storage currSlot = _ownerships[tokenId];
1091         currSlot.addr = from;
1092         currSlot.startTimestamp = uint64(block.timestamp);
1093         currSlot.burned = true;
1094 
1095         // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1096         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1097         uint256 nextTokenId = tokenId + 1;
1098         TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1099         if (nextSlot.addr == address(0)) {
1100             // This will suffice for checking _exists(nextTokenId),
1101             // as a burned slot cannot contain the zero address.
1102             if (nextTokenId != _currentIndex) {
1103                 nextSlot.addr = from;
1104                 nextSlot.startTimestamp = prevOwnership.startTimestamp;
1105             }
1106         }
1107     }
1108 
1109         emit Transfer(from, address(0), tokenId);
1110         _afterTokenTransfers(from, address(0), tokenId, 1);
1111 
1112         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1113     unchecked {
1114         _burnCounter++;
1115     }
1116     }
1117 
1118     /**
1119      * @dev Approve `to` to operate on `tokenId`
1120      *
1121      * Emits a {Approval} event.
1122      */
1123     function _approve(
1124         address to,
1125         uint256 tokenId,
1126         address owner
1127     ) private {
1128         _tokenApprovals[tokenId] = to;
1129         emit Approval(owner, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1134      *
1135      * @param from address representing the previous owner of the given token ID
1136      * @param to target address that will receive the tokens
1137      * @param tokenId uint256 ID of the token to be transferred
1138      * @param _data bytes optional data to send along with the call
1139      * @return bool whether the call correctly returned the expected magic value
1140      */
1141     function _checkContractOnERC721Received(
1142         address from,
1143         address to,
1144         uint256 tokenId,
1145         bytes memory _data
1146     ) private returns (bool) {
1147         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1148             return retval == IERC721Receiver(to).onERC721Received.selector;
1149         } catch (bytes memory reason) {
1150             if (reason.length == 0) {
1151                 revert TransferToNonERC721ReceiverImplementer();
1152             } else {
1153                 assembly {
1154                     revert(add(32, reason), mload(reason))
1155                 }
1156             }
1157         }
1158     }
1159 
1160     /**
1161      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1162      * And also called before burning one token.
1163      *
1164      * startTokenId - the first token id to be transferred
1165      * quantity - the amount to be transferred
1166      *
1167      * Calling conditions:
1168      *
1169      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1170      * transferred to `to`.
1171      * - When `from` is zero, `tokenId` will be minted for `to`.
1172      * - When `to` is zero, `tokenId` will be burned by `from`.
1173      * - `from` and `to` are never both zero.
1174      */
1175     function _beforeTokenTransfers(
1176         address from,
1177         address to,
1178         uint256 startTokenId,
1179         uint256 quantity
1180     ) internal virtual {}
1181 
1182     /**
1183      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1184      * minting.
1185      * And also called after one token has been burned.
1186      *
1187      * startTokenId - the first token id to be transferred
1188      * quantity - the amount to be transferred
1189      *
1190      * Calling conditions:
1191      *
1192      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1193      * transferred to `to`.
1194      * - When `from` is zero, `tokenId` has been minted for `to`.
1195      * - When `to` is zero, `tokenId` has been burned by `from`.
1196      * - `from` and `to` are never both zero.
1197      */
1198     function _afterTokenTransfers(
1199         address from,
1200         address to,
1201         uint256 startTokenId,
1202         uint256 quantity
1203     ) internal virtual {}
1204 }
1205 
1206 
1207 // File contracts/Archive/lib/token/ERC721AOwnersExplicit.sol
1208 
1209 // Creator: Chiru Labs
1210 
1211 
1212 
1213     error AllOwnershipsHaveBeenSet();
1214     error QuantityMustBeNonZero();
1215     error NoTokensMintedYet();
1216 
1217 abstract contract ERC721AOwnersExplicit is ERC721A {
1218     uint256 public nextOwnerToExplicitlySet;
1219 
1220     /**
1221      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1222      */
1223     function _setOwnersExplicit(uint256 quantity) internal {
1224         if (quantity == 0) revert QuantityMustBeNonZero();
1225         if (_currentIndex == _startTokenId()) revert NoTokensMintedYet();
1226         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1227         if (_nextOwnerToExplicitlySet == 0) {
1228             _nextOwnerToExplicitlySet = _startTokenId();
1229         }
1230         if (_nextOwnerToExplicitlySet >= _currentIndex) revert AllOwnershipsHaveBeenSet();
1231 
1232         // Index underflow is impossible.
1233         // Counter or index overflow is incredibly unrealistic.
1234     unchecked {
1235         uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1236 
1237         // Set the end index to be the last token index
1238         if (endIndex + 1 > _currentIndex) {
1239             endIndex = _currentIndex - 1;
1240         }
1241 
1242         for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1243             if (_ownerships[i].addr == address(0) && !_ownerships[i].burned) {
1244                 TokenOwnership memory ownership = _ownershipOf(i);
1245                 _ownerships[i].addr = ownership.addr;
1246                 _ownerships[i].startTimestamp = ownership.startTimestamp;
1247             }
1248         }
1249 
1250         nextOwnerToExplicitlySet = endIndex + 1;
1251     }
1252     }
1253 }
1254 
1255 
1256 // File contracts/Archive/lib/token/ERC721/extensions/ERC721Ownable.sol
1257 
1258 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1259 
1260 
1261 
1262 /**
1263  * @dev Contract module which provides a basic access control mechanism, where
1264  * there is an account (an owner) that can be granted exclusive access to
1265  * specific functions.
1266  *
1267  * By default, the owner account will be the one that deploys the contract. This
1268  * can later be changed with {transferOwnership}.
1269  *
1270  * This module is used through inheritance. It will make available the modifier
1271  * `onlyOwner`, which can be applied to your functions to restrict their use to
1272  * the owner.
1273  */
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
1297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
1332 
1333 // File contracts/Archive/lib/utils/cryptography/MerkleProof.sol
1334 
1335 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1336 
1337 
1338 
1339 /**
1340  * @dev These functions deal with verification of Merkle Trees proofs.
1341  *
1342  * The proofs can be generated using the JavaScript library
1343  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1344  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1345  *
1346  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1347  */
1348 library MerkleProof {
1349     /**
1350      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1351      * defined by `root`. For this, a `proof` must be provided, containing
1352      * sibling hashes on the branch from the leaf to the root of the tree. Each
1353      * pair of leaves and each pair of pre-images are assumed to be sorted.
1354      */
1355     function verify(
1356         bytes32[] memory proof,
1357         bytes32 root,
1358         bytes32 leaf
1359     ) internal pure returns (bool) {
1360         return processProof(proof, leaf) == root;
1361     }
1362 
1363     /**
1364      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1365      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1366      * hash matches the root of the tree. When processing the proof, the pairs
1367      * of leafs & pre-images are assumed to be sorted.
1368      *
1369      * _Available since v4.4._
1370      */
1371     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1372         bytes32 computedHash = leaf;
1373         for (uint256 i = 0; i < proof.length; i++) {
1374             bytes32 proofElement = proof[i];
1375             if (computedHash <= proofElement) {
1376                 // Hash(current computed hash + current element of the proof)
1377                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1378             } else {
1379                 // Hash(current element of the proof + current computed hash)
1380                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1381             }
1382         }
1383         return computedHash;
1384     }
1385 }
1386 
1387 
1388 // File contracts/Archive/contracts/Erc721amp.sol
1389 
1390 // Creators: Chiru Labs
1391 
1392 
1393 
1394 
1395 // import "../lib/utils/ReentrancyGuard.sol";
1396 
1397 contract ERC721AMP is ERC721AOwnersExplicit, Ownable {
1398     // Mint Sale dates
1399     uint32 private wlSaleStartTime;
1400     uint32 private publicSaleStartTime;
1401 
1402     // Max Supply
1403     uint16 public constant maxSupply = 6000;
1404 
1405     // Mint config
1406     uint16 private constant maxBatchSize = 20;
1407     uint16 private constant maxWlMintNumber = 12;
1408     uint16 private constant maxMintTx = 12;
1409 
1410     // Number of NFTs reserved for the dev & marketing team
1411     uint16 private constant devMintAmount = 60;
1412     bool private devMinted = false;
1413 
1414     bytes32 private rootmt;
1415 
1416     // Mint Price
1417     uint256 public constant mintPrice = 0.18 ether;
1418     uint256 public constant wlMintPrice = 0.149 ether;
1419 
1420     // Metadata URI
1421     string private _baseTokenURI;
1422 
1423     constructor(string memory name_, string memory symbol_)
1424     ERC721A(name_, symbol_)
1425     {}
1426 
1427     modifier callerIsUser() {
1428         require(tx.origin == msg.sender, "The caller is another contract");
1429         _;
1430     }
1431 
1432     function numberMinted(address owner) public view returns (uint256) {
1433         return _numberMinted(owner);
1434     }
1435 
1436     function totalMinted() public view returns (uint256) {
1437         return _totalMinted();
1438     }
1439 
1440     function baseURI() public view returns (string memory) {
1441         return _baseURI();
1442     }
1443 
1444     function exists(uint256 tokenId) public view returns (bool) {
1445         return _exists(tokenId);
1446     }
1447 
1448     // Verifying whitelist spot
1449     function checkValidity(bytes32[] calldata _merkleProof)
1450     public
1451     view
1452     returns (bool)
1453     {
1454         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1455         require(
1456             MerkleProof.verify(_merkleProof, rootmt, leaf),
1457             "Incorrect proof"
1458         );
1459         return true;
1460     }
1461 
1462     function setRootMerkleHash(bytes32 _rootmt) external onlyOwner {
1463         rootmt = _rootmt;
1464     }
1465 
1466     // Mint dates could be set to a distant future to stop the mint
1467     function setMintDates(uint32 wlDate, uint32 publicDate) external onlyOwner {
1468         require(wlDate != 0 && publicDate != 0, "dates must be defined");
1469         wlSaleStartTime = wlDate;
1470         publicSaleStartTime = publicDate;
1471     }
1472 
1473     function publicMint(address to, uint256 quantity)
1474     external
1475     payable
1476     callerIsUser
1477     {
1478         require(isPublicSaleOn(), "public sale has not started yet");
1479         require(quantity <= maxMintTx, "can not mint this many at once");
1480         require(msg.value >= mintPrice * quantity, "need to send more ETH");
1481         safeMint(to, quantity);
1482     }
1483 
1484     // Only whitelisted addresses are authorized to mint during the Whitelist Mint
1485     function whitelistMint(
1486         address to,
1487         uint256 quantity,
1488         bytes32[] calldata _merkleProof
1489     ) external payable {
1490         require(isWlSaleOn(), "whitelist sale has not started yet");
1491         require(
1492             numberMinted(to) + quantity <= maxWlMintNumber,
1493             "can not mint this many"
1494         );
1495         // Checking address to instead of _msgSender()
1496         bytes32 leaf = keccak256(abi.encodePacked(to));
1497         require(
1498             MerkleProof.verify(_merkleProof, rootmt, leaf),
1499             "Incorrect proof"
1500         );
1501         require(msg.value >= wlMintPrice * quantity, "need to send more ETH");
1502         safeMint(to, quantity);
1503     }
1504 
1505     function safeMint(address to, uint256 quantity) private {
1506         require(
1507             totalSupply() + quantity <= maxSupply,
1508             "insufficient remaining supply for desired mint amount"
1509         );
1510         require(
1511             quantity > 0 && quantity <= maxBatchSize,
1512             "incorrect mint quantity"
1513         );
1514 
1515         _safeMint(to, quantity);
1516     }
1517 
1518     receive() external payable {}
1519 
1520     function isWlSaleOn() public view returns (bool) {
1521         uint256 _wlSaleStartTime = uint256(wlSaleStartTime);
1522         return _wlSaleStartTime != 0 && block.timestamp >= _wlSaleStartTime;
1523     }
1524 
1525     function isPublicSaleOn() public view returns (bool) {
1526         uint256 _publicSaleStartTime = uint256(publicSaleStartTime);
1527         return
1528         _publicSaleStartTime != 0 &&
1529         block.timestamp >= _publicSaleStartTime;
1530     }
1531 
1532     // Executed only once at contract creation to generate NFTs for marketing and developers
1533     function devMint(address _address) external onlyOwner {
1534         uint _mintQuantity = devMintAmount;
1535         uint _maxBatchSize = maxBatchSize;
1536         require(devMinted == false, "Dev already minted");
1537         require(
1538             totalSupply() + _mintQuantity <= maxSupply,
1539             "insufficient supply"
1540         );
1541         require(
1542             _mintQuantity % _maxBatchSize == 0,
1543             "can only mint a multiple of the maxBatchSize"
1544         );
1545         uint numChunks = _mintQuantity / _maxBatchSize;
1546         devMinted = true;
1547         for (uint i = 0; i < numChunks; i++) {
1548             _safeMint(_address, _maxBatchSize);
1549         }
1550     }
1551 
1552     function _baseURI() internal view virtual override returns (string memory) {
1553         return _baseTokenURI;
1554     }
1555 
1556     function setBaseURI(string calldata baseURIValue) external onlyOwner {
1557         _baseTokenURI = baseURIValue;
1558     }
1559 
1560     function withdraw() external onlyOwner {
1561         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1562         require(success, "Transfer failed.");
1563     }
1564 
1565     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1566         _setOwnersExplicit(quantity);
1567     }
1568 
1569     function getOwnershipData(uint256 tokenId)
1570     external
1571     view
1572     returns (TokenOwnership memory)
1573     {
1574         return _ownershipOf(tokenId);
1575     }
1576 }
1577 
1578 
1579 // File contracts/Archive/contracts/MP.sol
1580 
1581 
1582 
1583 contract MetaPlaces is ERC721AMP {
1584     constructor() ERC721AMP("MP", "MP") {}
1585 
1586     function mint(uint256 quantity) external payable {
1587         // _safeMint's second argument now takes in a quantity, not a tokenId.
1588         _safeMint(msg.sender, quantity);
1589     }
1590 }