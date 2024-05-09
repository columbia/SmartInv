1 // SPDX-License-Identifier: MIT
2 //Developer Info:
3 //Written by Ghazanfar Perdakh
4 //Email: uchihaghazanfar@gmail.com
5 //Whatsapp NO.: +923331578650
6 //fiverr: fiverr.com/ghazanfarperdakh
7 
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Context.sol
79 
80 
81 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         return msg.data;
102     }
103 }
104 
105 // File: @openzeppelin/contracts/utils/Address.sol
106 
107 
108 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
109 
110 pragma solidity ^0.8.1;
111 
112 /**
113  * @dev Collection of functions related to the address type
114  */
115 library Address {
116     /**
117      * @dev Returns true if `account` is a contract.
118      *
119      * [IMPORTANT]
120      * ====
121      * It is unsafe to assume that an address for which this function returns
122      * false is an externally-owned account (EOA) and not a contract.
123      *
124      * Among others, `isContract` will return false for the following
125      * types of addresses:
126      *
127      *  - an externally-owned account
128      *  - a contract in construction
129      *  - an address where a contract will be created
130      *  - an address where a contract lived, but was destroyed
131      * ====
132      *
133      * [IMPORTANT]
134      * ====
135      * You shouldn't rely on `isContract` to protect against flash loan attacks!
136      *
137      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
138      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
139      * constructor.
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize/address.code.length, which returns 0
144         // for contracts in construction, since the code is only stored at the end
145         // of the constructor execution.
146 
147         return account.code.length > 0;
148     }
149 
150     /**
151      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
152      * `recipient`, forwarding all available gas and reverting on errors.
153      *
154      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
155      * of certain opcodes, possibly making contracts go over the 2300 gas limit
156      * imposed by `transfer`, making them unable to receive funds via
157      * `transfer`. {sendValue} removes this limitation.
158      *
159      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
160      *
161      * IMPORTANT: because control is transferred to `recipient`, care must be
162      * taken to not create reentrancy vulnerabilities. Consider using
163      * {ReentrancyGuard} or the
164      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
165      */
166     function sendValue(address payable recipient, uint256 amount) internal {
167         require(address(this).balance >= amount, "Address: insufficient balance");
168 
169         (bool success, ) = recipient.call{value: amount}("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172 
173     /**
174      * @dev Performs a Solidity function call using a low level `call`. A
175      * plain `call` is an unsafe replacement for a function call: use this
176      * function instead.
177      *
178      * If `target` reverts with a revert reason, it is bubbled up by this
179      * function (like regular Solidity function calls).
180      *
181      * Returns the raw returned data. To convert to the expected return value,
182      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
183      *
184      * Requirements:
185      *
186      * - `target` must be a contract.
187      * - calling `target` with `data` must not revert.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionCall(target, data, "Address: low-level call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
197      * `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, 0, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but also transferring `value` wei to `target`.
212      *
213      * Requirements:
214      *
215      * - the calling contract must have an ETH balance of at least `value`.
216      * - the called Solidity function must be `payable`.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(
221         address target,
222         bytes memory data,
223         uint256 value
224     ) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
230      * with `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCallWithValue(
235         address target,
236         bytes memory data,
237         uint256 value,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         require(address(this).balance >= value, "Address: insufficient balance for call");
241         require(isContract(target), "Address: call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.call{value: value}(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
254         return functionStaticCall(target, data, "Address: low-level static call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a static call.
260      *
261      * _Available since v3.3._
262      */
263     function functionStaticCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal view returns (bytes memory) {
268         require(isContract(target), "Address: static call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.staticcall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a delegate call.
277      *
278      * _Available since v3.4._
279      */
280     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a delegate call.
287      *
288      * _Available since v3.4._
289      */
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         require(isContract(target), "Address: delegate call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.delegatecall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
303      * revert reason using the provided one.
304      *
305      * _Available since v4.3._
306      */
307     function verifyCallResult(
308         bool success,
309         bytes memory returndata,
310         string memory errorMessage
311     ) internal pure returns (bytes memory) {
312         if (success) {
313             return returndata;
314         } else {
315             // Look for revert reason and bubble it up if present
316             if (returndata.length > 0) {
317                 // The easiest way to bubble the revert reason is using memory via assembly
318 
319                 assembly {
320                     let returndata_size := mload(returndata)
321                     revert(add(32, returndata), returndata_size)
322                 }
323             } else {
324                 revert(errorMessage);
325             }
326         }
327     }
328 }
329 
330 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @title ERC721 token receiver interface
339  * @dev Interface for any contract that wants to support safeTransfers
340  * from ERC721 asset contracts.
341  */
342 interface IERC721Receiver {
343     /**
344      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
345      * by `operator` from `from`, this function is called.
346      *
347      * It must return its Solidity selector to confirm the token transfer.
348      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
349      *
350      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
351      */
352     function onERC721Received(
353         address operator,
354         address from,
355         uint256 tokenId,
356         bytes calldata data
357     ) external returns (bytes4);
358 }
359 
360 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Interface of the ERC165 standard, as defined in the
369  * https://eips.ethereum.org/EIPS/eip-165[EIP].
370  *
371  * Implementers can declare support of contract interfaces, which can then be
372  * queried by others ({ERC165Checker}).
373  *
374  * For an implementation, see {ERC165}.
375  */
376 interface IERC165 {
377     /**
378      * @dev Returns true if this contract implements the interface defined by
379      * `interfaceId`. See the corresponding
380      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
381      * to learn more about how these ids are created.
382      *
383      * This function call must use less than 30 000 gas.
384      */
385     function supportsInterface(bytes4 interfaceId) external view returns (bool);
386 }
387 
388 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
389 
390 
391 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Implementation of the {IERC165} interface.
398  *
399  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
400  * for the additional interface id that will be supported. For example:
401  *
402  * ```solidity
403  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
404  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
405  * }
406  * ```
407  *
408  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
409  */
410 abstract contract ERC165 is IERC165 {
411     /**
412      * @dev See {IERC165-supportsInterface}.
413      */
414     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
415         return interfaceId == type(IERC165).interfaceId;
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
420 
421 
422 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 
427 /**
428  * @dev Required interface of an ERC721 compliant contract.
429  */
430 interface IERC721 is IERC165 {
431     /**
432      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
433      */
434     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
435 
436     /**
437      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
438      */
439     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
440 
441     /**
442      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
443      */
444     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
445 
446     /**
447      * @dev Returns the number of tokens in ``owner``'s account.
448      */
449     function balanceOf(address owner) external view returns (uint256 balance);
450 
451     /**
452      * @dev Returns the owner of the `tokenId` token.
453      *
454      * Requirements:
455      *
456      * - `tokenId` must exist.
457      */
458     function ownerOf(uint256 tokenId) external view returns (address owner);
459 
460     /**
461      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
462      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must exist and be owned by `from`.
469      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
470      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
471      *
472      * Emits a {Transfer} event.
473      */
474     function safeTransferFrom(
475         address from,
476         address to,
477         uint256 tokenId
478     ) external;
479 
480     /**
481      * @dev Transfers `tokenId` token from `from` to `to`.
482      *
483      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must be owned by `from`.
490      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
491      *
492      * Emits a {Transfer} event.
493      */
494     function transferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) external;
499 
500     /**
501      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
502      * The approval is cleared when the token is transferred.
503      *
504      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
505      *
506      * Requirements:
507      *
508      * - The caller must own the token or be an approved operator.
509      * - `tokenId` must exist.
510      *
511      * Emits an {Approval} event.
512      */
513     function approve(address to, uint256 tokenId) external;
514 
515     /**
516      * @dev Returns the account approved for `tokenId` token.
517      *
518      * Requirements:
519      *
520      * - `tokenId` must exist.
521      */
522     function getApproved(uint256 tokenId) external view returns (address operator);
523 
524     /**
525      * @dev Approve or remove `operator` as an operator for the caller.
526      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
527      *
528      * Requirements:
529      *
530      * - The `operator` cannot be the caller.
531      *
532      * Emits an {ApprovalForAll} event.
533      */
534     function setApprovalForAll(address operator, bool _approved) external;
535 
536     /**
537      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
538      *
539      * See {setApprovalForAll}
540      */
541     function isApprovedForAll(address owner, address operator) external view returns (bool);
542 
543     /**
544      * @dev Safely transfers `tokenId` token from `from` to `to`.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must exist and be owned by `from`.
551      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 tokenId,
560         bytes calldata data
561     ) external;
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
574  * @dev See https://eips.ethereum.org/EIPS/eip-721
575  */
576 interface IERC721Metadata is IERC721 {
577     /**
578      * @dev Returns the token collection name.
579      */
580     function name() external view returns (string memory);
581 
582     /**
583      * @dev Returns the token collection symbol.
584      */
585     function symbol() external view returns (string memory);
586 
587     /**
588      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
589      */
590     function tokenURI(uint256 tokenId) external view returns (string memory);
591 }
592 
593 // File: contracts/new.sol
594 
595 
596 
597 
598 pragma solidity ^0.8.4;
599 
600 
601 
602 
603 
604 
605 
606 
607 error ApprovalCallerNotOwnerNorApproved();
608 error ApprovalQueryForNonexistentToken();
609 error ApproveToCaller();
610 error ApprovalToCurrentOwner();
611 error BalanceQueryForZeroAddress();
612 error MintToZeroAddress();
613 error MintZeroQuantity();
614 error OwnerQueryForNonexistentToken();
615 error TransferCallerNotOwnerNorApproved();
616 error TransferFromIncorrectOwner();
617 error TransferToNonERC721ReceiverImplementer();
618 error TransferToZeroAddress();
619 error URIQueryForNonexistentToken();
620 
621 /**
622  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
623  * the Metadata extension. Built to optimize for lower gas during batch mints.
624  *
625  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
626  *
627  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
628  *
629  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
630  */
631 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
632     using Address for address;
633     using Strings for uint256;
634 
635     // Compiler will pack this into a single 256bit word.
636     struct TokenOwnership {
637         // The address of the owner.
638         address addr;
639         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
640         uint64 startTimestamp;
641         // Whether the token has been burned.
642         bool burned;
643     }
644 
645     // Compiler will pack this into a single 256bit word.
646     struct AddressData {
647         // Realistically, 2**64-1 is more than enough.
648         uint64 balance;
649         // Keeps track of mint count with minimal overhead for tokenomics.
650         uint64 numberMinted;
651         // Keeps track of burn count with minimal overhead for tokenomics.
652         uint64 numberBurned;
653         // For miscellaneous variable(s) pertaining to the address
654         // (e.g. number of whitelist mint slots used).
655         // If there are multiple variables, please pack them into a uint64.
656         uint64 aux;
657     }
658 
659     // The tokenId of the next token to be minted.
660     uint256 internal _currentIndex;
661 
662     // The number of tokens burned.
663     uint256 internal _burnCounter;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to ownership details
672     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
673     mapping(uint256 => TokenOwnership) internal _ownerships;
674 
675     // Mapping owner address to address data
676     mapping(address => AddressData) private _addressData;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687         _currentIndex = _startTokenId();
688     }
689 
690     /**
691      * To change the starting tokenId, please override this function.
692      */
693     function _startTokenId() internal view virtual returns (uint256) {
694         return 1;
695     }
696 
697     /**
698      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
699      */
700     function totalSupply() public view returns (uint256) {
701         // Counter underflow is impossible as _burnCounter cannot be incremented
702         // more than _currentIndex - _startTokenId() times
703         unchecked {
704             return _currentIndex - _burnCounter - _startTokenId();
705         }
706     }
707 
708     /**
709      * Returns the total amount of tokens minted in the contract.
710      */
711     function _totalMinted() internal view returns (uint256) {
712         // Counter underflow is impossible as _currentIndex does not decrement,
713         // and it is initialized to _startTokenId()
714         unchecked {
715             return _currentIndex - _startTokenId();
716         }
717     }
718 
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
723         return
724             interfaceId == type(IERC721).interfaceId ||
725             interfaceId == type(IERC721Metadata).interfaceId ||
726             super.supportsInterface(interfaceId);
727     }
728 
729     /**
730      * @dev See {IERC721-balanceOf}.
731      */
732     function balanceOf(address owner) public view override returns (uint256) {
733         if (owner == address(0)) revert BalanceQueryForZeroAddress();
734         return uint256(_addressData[owner].balance);
735     }
736 
737     /**
738      * Returns the number of tokens minted by `owner`.
739      */
740     function _numberMinted(address owner) internal view returns (uint256) {
741         return uint256(_addressData[owner].numberMinted);
742     }
743 
744     /**
745      * Returns the number of tokens burned by or on behalf of `owner`.
746      */
747     function _numberBurned(address owner) internal view returns (uint256) {
748         return uint256(_addressData[owner].numberBurned);
749     }
750 
751     /**
752      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
753      */
754     function _getAux(address owner) internal view returns (uint64) {
755         return _addressData[owner].aux;
756     }
757 
758     /**
759      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
760      * If there are multiple variables, please pack them into a uint64.
761      */
762     function _setAux(address owner, uint64 aux) internal {
763         _addressData[owner].aux = aux;
764     }
765 
766     /**
767      * Gas spent here starts off proportional to the maximum mint batch size.
768      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
769      */
770     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
771         uint256 curr = tokenId;
772 
773         unchecked {
774             if (_startTokenId() <= curr && curr < _currentIndex) {
775                 TokenOwnership memory ownership = _ownerships[curr];
776                 if (!ownership.burned) {
777                     if (ownership.addr != address(0)) {
778                         return ownership;
779                     }
780                     // Invariant:
781                     // There will always be an ownership that has an address and is not burned
782                     // before an ownership that does not have an address and is not burned.
783                     // Hence, curr will not underflow.
784                     while (true) {
785                         curr--;
786                         ownership = _ownerships[curr];
787                         if (ownership.addr != address(0)) {
788                             return ownership;
789                         }
790                     }
791                 }
792             }
793         }
794         revert OwnerQueryForNonexistentToken();
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId) public view override returns (address) {
801         return _ownershipOf(tokenId).addr;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
822         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
823 
824         string memory baseURI = _baseURI();
825         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
826     }
827 
828     /**
829      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
830      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
831      * by default, can be overriden in child contracts.
832      */
833     function _baseURI() internal view virtual returns (string memory) {
834         return '';
835     }
836 
837     /**
838      * @dev See {IERC721-approve}.
839      */
840     function approve(address to, uint256 tokenId) public override {
841         address owner = ERC721A.ownerOf(tokenId);
842         if (to == owner) revert ApprovalToCurrentOwner();
843 
844         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
845             revert ApprovalCallerNotOwnerNorApproved();
846         }
847 
848         _approve(to, tokenId, owner);
849     }
850 
851     /**
852      * @dev See {IERC721-getApproved}.
853      */
854     function getApproved(uint256 tokenId) public view override returns (address) {
855         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
856 
857         return _tokenApprovals[tokenId];
858     }
859 
860     /**
861      * @dev See {IERC721-setApprovalForAll}.
862      */
863     function setApprovalForAll(address operator, bool approved) public virtual override {
864         if (operator == _msgSender()) revert ApproveToCaller();
865 
866         _operatorApprovals[_msgSender()][operator] = approved;
867         emit ApprovalForAll(_msgSender(), operator, approved);
868     }
869 
870     /**
871      * @dev See {IERC721-isApprovedForAll}.
872      */
873     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
874         return _operatorApprovals[owner][operator];
875     }
876 
877     /**
878      * @dev See {IERC721-transferFrom}.
879      */
880     function transferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         _transfer(from, to, tokenId);
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public virtual override {
896         safeTransferFrom(from, to, tokenId, '');
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) public virtual override {
908         _transfer(from, to, tokenId);
909         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
910             revert TransferToNonERC721ReceiverImplementer();
911         }
912     }
913 
914     /**
915      * @dev Returns whether `tokenId` exists.
916      *
917      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
918      *
919      * Tokens start existing when they are minted (`_mint`),
920      */
921     function _exists(uint256 tokenId) internal view returns (bool) {
922         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
923             !_ownerships[tokenId].burned;
924     }
925 
926     function _safeMint(address to, uint256 quantity) internal {
927         _safeMint(to, quantity, '');
928     }
929 
930     /**
931      * @dev Safely mints `quantity` tokens and transfers them to `to`.
932      *
933      * Requirements:
934      *
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
936      * - `quantity` must be greater than 0.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeMint(
941         address to,
942         uint256 quantity,
943         bytes memory _data
944     ) internal {
945         _mint(to, quantity, _data, true);
946     }
947 
948     /**
949      * @dev Mints `quantity` tokens and transfers them to `to`.
950      *
951      * Requirements:
952      *
953      * - `to` cannot be the zero address.
954      * - `quantity` must be greater than 0.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _mint(
959         address to,
960         uint256 quantity,
961         bytes memory _data,
962         bool safe
963     ) internal {
964         uint256 startTokenId = _currentIndex;
965         if (to == address(0)) revert MintToZeroAddress();
966         if (quantity == 0) revert MintZeroQuantity();
967 
968         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
969 
970         // Overflows are incredibly unrealistic.
971         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
972         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
973         unchecked {
974             _addressData[to].balance += uint64(quantity);
975             _addressData[to].numberMinted += uint64(quantity);
976 
977             _ownerships[startTokenId].addr = to;
978             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
979 
980             uint256 updatedIndex = startTokenId;
981             uint256 end = updatedIndex + quantity;
982 
983             if (safe && to.isContract()) {
984                 do {
985                     emit Transfer(address(0), to, updatedIndex);
986                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
987                         revert TransferToNonERC721ReceiverImplementer();
988                     }
989                 } while (updatedIndex != end);
990                 // Reentrancy protection
991                 if (_currentIndex != startTokenId) revert();
992             } else {
993                 do {
994                     emit Transfer(address(0), to, updatedIndex++);
995                 } while (updatedIndex != end);
996             }
997             _currentIndex = updatedIndex;
998         }
999         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1000     }
1001 
1002     /**
1003      * @dev Transfers `tokenId` from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) private {
1017         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1018 
1019         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1020 
1021         bool isApprovedOrOwner = (_msgSender() == from ||
1022             isApprovedForAll(from, _msgSender()) ||
1023             getApproved(tokenId) == _msgSender());
1024 
1025         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1026         if (to == address(0)) revert TransferToZeroAddress();
1027 
1028         _beforeTokenTransfers(from, to, tokenId, 1);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId, from);
1032 
1033         // Underflow of the sender's balance is impossible because we check for
1034         // ownership above and the recipient's balance can't realistically overflow.
1035         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1036         unchecked {
1037             _addressData[from].balance -= 1;
1038             _addressData[to].balance += 1;
1039 
1040             TokenOwnership storage currSlot = _ownerships[tokenId];
1041             currSlot.addr = to;
1042             currSlot.startTimestamp = uint64(block.timestamp);
1043 
1044             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1045             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1046             uint256 nextTokenId = tokenId + 1;
1047             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1048             if (nextSlot.addr == address(0)) {
1049                 // This will suffice for checking _exists(nextTokenId),
1050                 // as a burned slot cannot contain the zero address.
1051                 if (nextTokenId != _currentIndex) {
1052                     nextSlot.addr = from;
1053                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1054                 }
1055             }
1056         }
1057 
1058         emit Transfer(from, to, tokenId);
1059         _afterTokenTransfers(from, to, tokenId, 1);
1060     }
1061 
1062     /**
1063      * @dev This is equivalent to _burn(tokenId, false)
1064      */
1065     function _burn(uint256 tokenId) internal virtual {
1066         _burn(tokenId, false);
1067     }
1068 
1069     /**
1070      * @dev Destroys `tokenId`.
1071      * The approval is cleared when the token is burned.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1080         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1081 
1082         address from = prevOwnership.addr;
1083 
1084         if (approvalCheck) {
1085             bool isApprovedOrOwner = (_msgSender() == from ||
1086                 isApprovedForAll(from, _msgSender()) ||
1087                 getApproved(tokenId) == _msgSender());
1088 
1089             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1090         }
1091 
1092         _beforeTokenTransfers(from, address(0), tokenId, 1);
1093 
1094         // Clear approvals from the previous owner
1095         _approve(address(0), tokenId, from);
1096 
1097         // Underflow of the sender's balance is impossible because we check for
1098         // ownership above and the recipient's balance can't realistically overflow.
1099         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1100         unchecked {
1101             AddressData storage addressData = _addressData[from];
1102             addressData.balance -= 1;
1103             addressData.numberBurned += 1;
1104 
1105             // Keep track of who burned the token, and the timestamp of burning.
1106             TokenOwnership storage currSlot = _ownerships[tokenId];
1107             currSlot.addr = from;
1108             currSlot.startTimestamp = uint64(block.timestamp);
1109             currSlot.burned = true;
1110 
1111             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1112             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1113             uint256 nextTokenId = tokenId + 1;
1114             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1115             if (nextSlot.addr == address(0)) {
1116                 // This will suffice for checking _exists(nextTokenId),
1117                 // as a burned slot cannot contain the zero address.
1118                 if (nextTokenId != _currentIndex) {
1119                     nextSlot.addr = from;
1120                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1121                 }
1122             }
1123         }
1124 
1125         emit Transfer(from, address(0), tokenId);
1126         _afterTokenTransfers(from, address(0), tokenId, 1);
1127 
1128         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1129         unchecked {
1130             _burnCounter++;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Approve `to` to operate on `tokenId`
1136      *
1137      * Emits a {Approval} event.
1138      */
1139     function _approve(
1140         address to,
1141         uint256 tokenId,
1142         address owner
1143     ) private {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(owner, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1150      *
1151      * @param from address representing the previous owner of the given token ID
1152      * @param to target address that will receive the tokens
1153      * @param tokenId uint256 ID of the token to be transferred
1154      * @param _data bytes optional data to send along with the call
1155      * @return bool whether the call correctly returned the expected magic value
1156      */
1157     function _checkContractOnERC721Received(
1158         address from,
1159         address to,
1160         uint256 tokenId,
1161         bytes memory _data
1162     ) private returns (bool) {
1163         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1164             return retval == IERC721Receiver(to).onERC721Received.selector;
1165         } catch (bytes memory reason) {
1166             if (reason.length == 0) {
1167                 revert TransferToNonERC721ReceiverImplementer();
1168             } else {
1169                 assembly {
1170                     revert(add(32, reason), mload(reason))
1171                 }
1172             }
1173         }
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1178      * And also called before burning one token.
1179      *
1180      * startTokenId - the first token id to be transferred
1181      * quantity - the amount to be transferred
1182      *
1183      * Calling conditions:
1184      *
1185      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1186      * transferred to `to`.
1187      * - When `from` is zero, `tokenId` will be minted for `to`.
1188      * - When `to` is zero, `tokenId` will be burned by `from`.
1189      * - `from` and `to` are never both zero.
1190      */
1191     function _beforeTokenTransfers(
1192         address from,
1193         address to,
1194         uint256 startTokenId,
1195         uint256 quantity
1196     ) internal virtual {}
1197 
1198     /**
1199      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1200      * minting.
1201      * And also called after one token has been burned.
1202      *
1203      * startTokenId - the first token id to be transferred
1204      * quantity - the amount to be transferred
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` has been minted for `to`.
1211      * - When `to` is zero, `tokenId` has been burned by `from`.
1212      * - `from` and `to` are never both zero.
1213      */
1214     function _afterTokenTransfers(
1215         address from,
1216         address to,
1217         uint256 startTokenId,
1218         uint256 quantity
1219     ) internal virtual {}
1220 }
1221 pragma solidity ^0.8.0;
1222 
1223 /**
1224  * @dev These functions deal with verification of Merkle Trees proofs.
1225  *
1226  * The proofs can be generated using the JavaScript library
1227  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1228  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1229  *
1230  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1231  */
1232 library MerkleProof {
1233     /**
1234      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1235      * defined by `root`. For this, a `proof` must be provided, containing
1236      * sibling hashes on the branch from the leaf to the root of the tree. Each
1237      * pair of leaves and each pair of pre-images are assumed to be sorted.
1238      */
1239     function verify(
1240         bytes32[] memory proof,
1241         bytes32 root,
1242         bytes32 leaf
1243     ) internal pure returns (bool) {
1244         return processProof(proof, leaf) == root;
1245     }
1246 
1247     /**
1248      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1249      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1250      * hash matches the root of the tree. When processing the proof, the pairs
1251      * of leafs & pre-images are assumed to be sorted.
1252      *
1253      * _Available since v4.4._
1254      */
1255     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1256         bytes32 computedHash = leaf;
1257         for (uint256 i = 0; i < proof.length; i++) {
1258             bytes32 proofElement = proof[i];
1259             if (computedHash <= proofElement) {
1260                 // Hash(current computed hash + current element of the proof)
1261                 computedHash = _efficientHash(computedHash, proofElement);
1262             } else {
1263                 // Hash(current element of the proof + current computed hash)
1264                 computedHash = _efficientHash(proofElement, computedHash);
1265             }
1266         }
1267         return computedHash;
1268     }
1269 
1270     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1271         assembly {
1272             mstore(0x00, a)
1273             mstore(0x20, b)
1274             value := keccak256(0x00, 0x40)
1275         }
1276     }
1277 }
1278 abstract contract Ownable is Context {
1279     address private _owner;
1280 
1281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1282 
1283     /**
1284      * @dev Initializes the contract setting the deployer as the initial owner.
1285      */
1286     constructor() {
1287         _transferOwnership(_msgSender());
1288     }
1289 
1290     /**
1291      * @dev Returns the address of the current owner.
1292      */
1293     function owner() public view virtual returns (address) {
1294         return _owner;
1295     }
1296 
1297     /**
1298      * @dev Throws if called by any account other than the owner.
1299      */
1300     modifier onlyOwner() {
1301         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1302         _;
1303     }
1304 
1305     /**
1306      * @dev Leaves the contract without owner. It will not be possible to call
1307      * `onlyOwner` functions anymore. Can only be called by the current owner.
1308      *
1309      * NOTE: Renouncing ownership will leave the contract without an owner,
1310      * thereby removing any functionality that is only available to the owner.
1311      */
1312     function renounceOwnership() public virtual onlyOwner {
1313         _transferOwnership(address(0));
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      * Can only be called by the current owner.
1319      */
1320     function transferOwnership(address newOwner) public virtual onlyOwner {
1321         require(newOwner != address(0), "Ownable: new owner is the zero address");
1322         _transferOwnership(newOwner);
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Internal function without access restriction.
1328      */
1329     function _transferOwnership(address newOwner) internal virtual {
1330         address oldOwner = _owner;
1331         _owner = newOwner;
1332         emit OwnershipTransferred(oldOwner, newOwner);
1333     }
1334 }
1335     pragma solidity ^0.8.7;
1336     
1337     contract GroovyDoodles is ERC721A, Ownable {
1338     using Strings for uint256;
1339 
1340 
1341   string private uriPrefix ;
1342   string private uriSuffix = ".json";
1343   string public hiddenURL = "ipfs://QmXHJYbZAVyAMaYesbqB1gu1YFsg4pc7UdGzcXE9kWMuTL";
1344 
1345   
1346   
1347 
1348   uint256 public cost = 0.01 ether;
1349 
1350 
1351   uint16 public constant maxSupply = 8888;
1352     
1353   uint8 public maxMintAmountPerTx = 10;
1354                                                              
1355   
1356   bool public paused = true;
1357   bool public reveal =false;
1358   mapping (address => uint8) public NFTPerWLAddress;
1359   uint8 public maxFreeMintAmountPerWallet = 5;  
1360   
1361   
1362   bytes32 public whitelistMerkleRoot = 0x66097a72dcaa3275a3597c3fdb73300b981b8da4d91e15592c8a48209918c7c8;
1363   
1364 
1365   constructor() ERC721A("Groovy Doodles", "GDood") {
1366   }
1367 
1368   
1369  
1370   function mint(uint8 _mintAmount) external payable  {
1371      uint16 totalSupply = uint16(totalSupply());
1372     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1373     require(_mintAmount <= maxMintAmountPerTx, "Exceeds max limit per transaction.");
1374 
1375     require(!paused, "The contract is paused!");
1376     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1377 
1378     _safeMint(msg.sender , _mintAmount);
1379      
1380      delete totalSupply;
1381      delete _mintAmount;
1382   }
1383   
1384   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1385      uint16 totalSupply = uint16(totalSupply());
1386     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1387      _safeMint(_receiver , _mintAmount);
1388      delete _mintAmount;
1389      delete _receiver;
1390      delete totalSupply;
1391   }
1392 
1393  
1394 
1395    
1396   function tokenURI(uint256 _tokenId)
1397     public
1398     view
1399     virtual
1400     override
1401     returns (string memory)
1402   {
1403     require(
1404       _exists(_tokenId),
1405       "ERC721Metadata: URI query for nonexistent token"
1406     );
1407     
1408   
1409 if ( reveal == false)
1410 {
1411     return hiddenURL;
1412 }
1413     
1414 
1415     string memory currentBaseURI = _baseURI();
1416     return bytes(currentBaseURI).length > 0
1417         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1418         : "";
1419   }
1420  
1421    
1422  
1423 
1424 
1425  function setMaxFreeMintAmountPerWallet(uint8 _limit) external onlyOwner{
1426     maxFreeMintAmountPerWallet = _limit;
1427    delete _limit;
1428 
1429 }
1430 function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1431         whitelistMerkleRoot = _whitelistMerkleRoot;
1432     }
1433 
1434     
1435     function getLeafNode(address _leaf) internal pure returns (bytes32 temp)
1436     {
1437         return keccak256(abi.encodePacked(_leaf));
1438     }
1439     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1440         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1441     }
1442 
1443 function whitelistMint(uint8 _mintAmount, bytes32[] calldata merkleProof) external  payable{
1444         
1445        bytes32  leafnode = getLeafNode(msg.sender);
1446         uint8 _txPerAddress = NFTPerWLAddress[msg.sender];
1447        require(_verify(leafnode ,   merkleProof   ),  "Invalid merkle proof");
1448         require(!paused, "Sale has not started");
1449 
1450      if(_txPerAddress >= maxFreeMintAmountPerWallet)
1451     {
1452     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1453     }
1454     else {
1455          uint8 costAmount = _mintAmount + _txPerAddress;
1456         if(costAmount > maxFreeMintAmountPerWallet)
1457        {
1458         costAmount = costAmount - maxFreeMintAmountPerWallet;
1459         require(msg.value >= cost * costAmount, "Insufficient funds!");
1460        }
1461        
1462          
1463     }
1464      _safeMint(msg.sender , _mintAmount);
1465       NFTPerWLAddress[msg.sender] =_txPerAddress + _mintAmount;
1466       
1467       delete _mintAmount;
1468        delete _txPerAddress;
1469     
1470     }
1471 
1472   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1473     uriPrefix = _uriPrefix;
1474   }
1475    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1476     hiddenURL = _uriPrefix;
1477   }
1478 
1479 
1480   function setPaused() external onlyOwner {
1481     paused = !paused;
1482   }
1483 
1484   function setCost(uint _cost) external onlyOwner{
1485       cost = _cost;
1486 
1487   }
1488 
1489  function setRevealed() external onlyOwner{
1490      reveal = !reveal;
1491  }
1492 
1493   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1494       maxMintAmountPerTx = _maxtx;
1495 
1496   }
1497 
1498  
1499 
1500   function withdraw() external onlyOwner {
1501   uint _balance = address(this).balance;
1502      payable(msg.sender).transfer(_balance ); 
1503        
1504   }
1505 
1506 
1507   function _baseURI() internal view  override returns (string memory) {
1508     return uriPrefix;
1509   }
1510 }