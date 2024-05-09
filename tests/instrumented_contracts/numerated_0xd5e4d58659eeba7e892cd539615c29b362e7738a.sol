1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-03-30
5 */
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Context.sol
78 
79 
80 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes calldata) {
100         return msg.data;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/utils/Address.sol
105 
106 
107 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
108 
109 pragma solidity ^0.8.1;
110 
111 /**
112  * @dev Collection of functions related to the address type
113  */
114 library Address {
115     /**
116      * @dev Returns true if `account` is a contract.
117      *
118      * [IMPORTANT]
119      * ====
120      * It is unsafe to assume that an address for which this function returns
121      * false is an externally-owned account (EOA) and not a contract.
122      *
123      * Among others, `isContract` will return false for the following
124      * types of addresses:
125      *
126      *  - an externally-owned account
127      *  - a contract in construction
128      *  - an address where a contract will be created
129      *  - an address where a contract lived, but was destroyed
130      * ====
131      *
132      * [IMPORTANT]
133      * ====
134      * You shouldn't rely on `isContract` to protect against flash loan attacks!
135      *
136      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
137      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
138      * constructor.
139      * ====
140      */
141     function isContract(address account) internal view returns (bool) {
142         // This method relies on extcodesize/address.code.length, which returns 0
143         // for contracts in construction, since the code is only stored at the end
144         // of the constructor execution.
145 
146         return account.code.length > 0;
147     }
148 
149     /**
150      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
151      * `recipient`, forwarding all available gas and reverting on errors.
152      *
153      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
154      * of certain opcodes, possibly making contracts go over the 2300 gas limit
155      * imposed by `transfer`, making them unable to receive funds via
156      * `transfer`. {sendValue} removes this limitation.
157      *
158      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
159      *
160      * IMPORTANT: because control is transferred to `recipient`, care must be
161      * taken to not create reentrancy vulnerabilities. Consider using
162      * {ReentrancyGuard} or the
163      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
164      */
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         (bool success, ) = recipient.call{value: amount}("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171 
172     /**
173      * @dev Performs a Solidity function call using a low level `call`. A
174      * plain `call` is an unsafe replacement for a function call: use this
175      * function instead.
176      *
177      * If `target` reverts with a revert reason, it is bubbled up by this
178      * function (like regular Solidity function calls).
179      *
180      * Returns the raw returned data. To convert to the expected return value,
181      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
182      *
183      * Requirements:
184      *
185      * - `target` must be a contract.
186      * - calling `target` with `data` must not revert.
187      *
188      * _Available since v3.1._
189      */
190     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionCall(target, data, "Address: low-level call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
196      * `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, 0, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but also transferring `value` wei to `target`.
211      *
212      * Requirements:
213      *
214      * - the calling contract must have an ETH balance of at least `value`.
215      * - the called Solidity function must be `payable`.
216      *
217      * _Available since v3.1._
218      */
219     function functionCallWithValue(
220         address target,
221         bytes memory data,
222         uint256 value
223     ) internal returns (bytes memory) {
224         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
229      * with `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         require(address(this).balance >= value, "Address: insufficient balance for call");
240         require(isContract(target), "Address: call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.call{value: value}(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a static call.
249      *
250      * _Available since v3.3._
251      */
252     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
253         return functionStaticCall(target, data, "Address: low-level static call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a static call.
259      *
260      * _Available since v3.3._
261      */
262     function functionStaticCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal view returns (bytes memory) {
267         require(isContract(target), "Address: static call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.staticcall(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but performing a delegate call.
276      *
277      * _Available since v3.4._
278      */
279     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
285      * but performing a delegate call.
286      *
287      * _Available since v3.4._
288      */
289     function functionDelegateCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         require(isContract(target), "Address: delegate call to non-contract");
295 
296         (bool success, bytes memory returndata) = target.delegatecall(data);
297         return verifyCallResult(success, returndata, errorMessage);
298     }
299 
300     /**
301      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
302      * revert reason using the provided one.
303      *
304      * _Available since v4.3._
305      */
306     function verifyCallResult(
307         bool success,
308         bytes memory returndata,
309         string memory errorMessage
310     ) internal pure returns (bytes memory) {
311         if (success) {
312             return returndata;
313         } else {
314             // Look for revert reason and bubble it up if present
315             if (returndata.length > 0) {
316                 // The easiest way to bubble the revert reason is using memory via assembly
317 
318                 assembly {
319                     let returndata_size := mload(returndata)
320                     revert(add(32, returndata), returndata_size)
321                 }
322             } else {
323                 revert(errorMessage);
324             }
325         }
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @title ERC721 token receiver interface
338  * @dev Interface for any contract that wants to support safeTransfers
339  * from ERC721 asset contracts.
340  */
341 interface IERC721Receiver {
342     /**
343      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
344      * by `operator` from `from`, this function is called.
345      *
346      * It must return its Solidity selector to confirm the token transfer.
347      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
348      *
349      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
350      */
351     function onERC721Received(
352         address operator,
353         address from,
354         uint256 tokenId,
355         bytes calldata data
356     ) external returns (bytes4);
357 }
358 
359 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @dev Interface of the ERC165 standard, as defined in the
368  * https://eips.ethereum.org/EIPS/eip-165[EIP].
369  *
370  * Implementers can declare support of contract interfaces, which can then be
371  * queried by others ({ERC165Checker}).
372  *
373  * For an implementation, see {ERC165}.
374  */
375 interface IERC165 {
376     /**
377      * @dev Returns true if this contract implements the interface defined by
378      * `interfaceId`. See the corresponding
379      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
380      * to learn more about how these ids are created.
381      *
382      * This function call must use less than 30 000 gas.
383      */
384     function supportsInterface(bytes4 interfaceId) external view returns (bool);
385 }
386 
387 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Implementation of the {IERC165} interface.
397  *
398  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
399  * for the additional interface id that will be supported. For example:
400  *
401  * ```solidity
402  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
404  * }
405  * ```
406  *
407  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
408  */
409 abstract contract ERC165 is IERC165 {
410     /**
411      * @dev See {IERC165-supportsInterface}.
412      */
413     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
414         return interfaceId == type(IERC165).interfaceId;
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 
426 /**
427  * @dev Required interface of an ERC721 compliant contract.
428  */
429 interface IERC721 is IERC165 {
430     /**
431      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
432      */
433     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
434 
435     /**
436      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
437      */
438     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
439 
440     /**
441      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
442      */
443     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
444 
445     /**
446      * @dev Returns the number of tokens in ``owner``'s account.
447      */
448     function balanceOf(address owner) external view returns (uint256 balance);
449 
450     /**
451      * @dev Returns the owner of the `tokenId` token.
452      *
453      * Requirements:
454      *
455      * - `tokenId` must exist.
456      */
457     function ownerOf(uint256 tokenId) external view returns (address owner);
458 
459     /**
460      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
461      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
462      *
463      * Requirements:
464      *
465      * - `from` cannot be the zero address.
466      * - `to` cannot be the zero address.
467      * - `tokenId` token must exist and be owned by `from`.
468      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
469      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
470      *
471      * Emits a {Transfer} event.
472      */
473     function safeTransferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external;
478 
479     /**
480      * @dev Transfers `tokenId` token from `from` to `to`.
481      *
482      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must be owned by `from`.
489      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
490      *
491      * Emits a {Transfer} event.
492      */
493     function transferFrom(
494         address from,
495         address to,
496         uint256 tokenId
497     ) external;
498 
499     /**
500      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
501      * The approval is cleared when the token is transferred.
502      *
503      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
504      *
505      * Requirements:
506      *
507      * - The caller must own the token or be an approved operator.
508      * - `tokenId` must exist.
509      *
510      * Emits an {Approval} event.
511      */
512     function approve(address to, uint256 tokenId) external;
513 
514     /**
515      * @dev Returns the account approved for `tokenId` token.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function getApproved(uint256 tokenId) external view returns (address operator);
522 
523     /**
524      * @dev Approve or remove `operator` as an operator for the caller.
525      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
526      *
527      * Requirements:
528      *
529      * - The `operator` cannot be the caller.
530      *
531      * Emits an {ApprovalForAll} event.
532      */
533     function setApprovalForAll(address operator, bool _approved) external;
534 
535     /**
536      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
537      *
538      * See {setApprovalForAll}
539      */
540     function isApprovedForAll(address owner, address operator) external view returns (bool);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId,
559         bytes calldata data
560     ) external;
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 /**
572  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
573  * @dev See https://eips.ethereum.org/EIPS/eip-721
574  */
575 interface IERC721Metadata is IERC721 {
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() external view returns (string memory);
580 
581     /**
582      * @dev Returns the token collection symbol.
583      */
584     function symbol() external view returns (string memory);
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) external view returns (string memory);
590 }
591 
592 // File: erc721a/contracts/ERC721A.sol
593 
594 
595 // Creator: Chiru Labs
596 
597 pragma solidity ^0.8.4;
598 
599 
600 
601 
602 
603 
604 
605 
606 error ApprovalCallerNotOwnerNorApproved();
607 error ApprovalQueryForNonexistentToken();
608 error ApproveToCaller();
609 error ApprovalToCurrentOwner();
610 error BalanceQueryForZeroAddress();
611 error MintToZeroAddress();
612 error MintZeroQuantity();
613 error OwnerQueryForNonexistentToken();
614 error TransferCallerNotOwnerNorApproved();
615 error TransferFromIncorrectOwner();
616 error TransferToNonERC721ReceiverImplementer();
617 error TransferToZeroAddress();
618 error URIQueryForNonexistentToken();
619 
620 /**
621  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
622  * the Metadata extension. Built to optimize for lower gas during batch mints.
623  *
624  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
625  *
626  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
627  *
628  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
629  */
630 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
631     using Address for address;
632     using Strings for uint256;
633 
634     // Compiler will pack this into a single 256bit word.
635     struct TokenOwnership {
636         // The address of the owner.
637         address addr;
638         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
639         uint64 startTimestamp;
640         // Whether the token has been burned.
641         bool burned;
642     }
643 
644     // Compiler will pack this into a single 256bit word.
645     struct AddressData {
646         // Realistically, 2**64-1 is more than enough.
647         uint64 balance;
648         // Keeps track of mint count with minimal overhead for tokenomics.
649         uint64 numberMinted;
650         // Keeps track of burn count with minimal overhead for tokenomics.
651         uint64 numberBurned;
652         // For miscellaneous variable(s) pertaining to the address
653         // (e.g. number of whitelist mint slots used).
654         // If there are multiple variables, please pack them into a uint64.
655         uint64 aux;
656     }
657 
658     // The tokenId of the next token to be minted.
659     uint256 internal _currentIndex;
660 
661     // The number of tokens burned.
662     uint256 internal _burnCounter;
663 
664     // Token name
665     string private _name;
666 
667     // Token symbol
668     string private _symbol;
669 
670     // Mapping from token ID to ownership details
671     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
672     mapping(uint256 => TokenOwnership) internal _ownerships;
673 
674     // Mapping owner address to address data
675     mapping(address => AddressData) private _addressData;
676 
677     // Mapping from token ID to approved address
678     mapping(uint256 => address) private _tokenApprovals;
679 
680     // Mapping from owner to operator approvals
681     mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683     constructor(string memory name_, string memory symbol_) {
684         _name = name_;
685         _symbol = symbol_;
686         _currentIndex = _startTokenId();
687     }
688 
689     /**
690      * To change the starting tokenId, please override this function.
691      */
692     function _startTokenId() internal view virtual returns (uint256) {
693         return 0;
694     }
695 
696     /**
697      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
698      */
699     function totalSupply() public view returns (uint256) {
700         // Counter underflow is impossible as _burnCounter cannot be incremented
701         // more than _currentIndex - _startTokenId() times
702         unchecked {
703             return _currentIndex - _burnCounter - _startTokenId();
704         }
705     }
706 
707     /**
708      * Returns the total amount of tokens minted in the contract.
709      */
710     function _totalMinted() internal view returns (uint256) {
711         // Counter underflow is impossible as _currentIndex does not decrement,
712         // and it is initialized to _startTokenId()
713         unchecked {
714             return _currentIndex - _startTokenId();
715         }
716     }
717 
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
722         return
723             interfaceId == type(IERC721).interfaceId ||
724             interfaceId == type(IERC721Metadata).interfaceId ||
725             super.supportsInterface(interfaceId);
726     }
727 
728     /**
729      * @dev See {IERC721-balanceOf}.
730      */
731     function balanceOf(address owner) public view override returns (uint256) {
732         if (owner == address(0)) revert BalanceQueryForZeroAddress();
733         return uint256(_addressData[owner].balance);
734     }
735 
736     /**
737      * Returns the number of tokens minted by `owner`.
738      */
739     function _numberMinted(address owner) internal view returns (uint256) {
740         return uint256(_addressData[owner].numberMinted);
741     }
742 
743     /**
744      * Returns the number of tokens burned by or on behalf of `owner`.
745      */
746     function _numberBurned(address owner) internal view returns (uint256) {
747         return uint256(_addressData[owner].numberBurned);
748     }
749 
750     /**
751      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
752      */
753     function _getAux(address owner) internal view returns (uint64) {
754         return _addressData[owner].aux;
755     }
756 
757     /**
758      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
759      * If there are multiple variables, please pack them into a uint64.
760      */
761     function _setAux(address owner, uint64 aux) internal {
762         _addressData[owner].aux = aux;
763     }
764 
765     /**
766      * Gas spent here starts off proportional to the maximum mint batch size.
767      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
768      */
769     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
770         uint256 curr = tokenId;
771 
772         unchecked {
773             if (_startTokenId() <= curr && curr < _currentIndex) {
774                 TokenOwnership memory ownership = _ownerships[curr];
775                 if (!ownership.burned) {
776                     if (ownership.addr != address(0)) {
777                         return ownership;
778                     }
779                     // Invariant:
780                     // There will always be an ownership that has an address and is not burned
781                     // before an ownership that does not have an address and is not burned.
782                     // Hence, curr will not underflow.
783                     while (true) {
784                         curr--;
785                         ownership = _ownerships[curr];
786                         if (ownership.addr != address(0)) {
787                             return ownership;
788                         }
789                     }
790                 }
791             }
792         }
793         revert OwnerQueryForNonexistentToken();
794     }
795 
796     /**
797      * @dev See {IERC721-ownerOf}.
798      */
799     function ownerOf(uint256 tokenId) public view override returns (address) {
800         return _ownershipOf(tokenId).addr;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-name}.
805      */
806     function name() public view virtual override returns (string memory) {
807         return _name;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-symbol}.
812      */
813     function symbol() public view virtual override returns (string memory) {
814         return _symbol;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-tokenURI}.
819      */
820     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
821         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
822 
823         string memory baseURI = _baseURI();
824         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
825     }
826 
827     /**
828      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
829      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
830      * by default, can be overriden in child contracts.
831      */
832     function _baseURI() internal view virtual returns (string memory) {
833         return '';
834     }
835 
836     /**
837      * @dev See {IERC721-approve}.
838      */
839     function approve(address to, uint256 tokenId) public override {
840         address owner = ERC721A.ownerOf(tokenId);
841         if (to == owner) revert ApprovalToCurrentOwner();
842 
843         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
844             revert ApprovalCallerNotOwnerNorApproved();
845         }
846 
847         _approve(to, tokenId, owner);
848     }
849 
850     /**
851      * @dev See {IERC721-getApproved}.
852      */
853     function getApproved(uint256 tokenId) public view override returns (address) {
854         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved) public virtual override {
863         if (operator == _msgSender()) revert ApproveToCaller();
864 
865         _operatorApprovals[_msgSender()][operator] = approved;
866         emit ApprovalForAll(_msgSender(), operator, approved);
867     }
868 
869     /**
870      * @dev See {IERC721-isApprovedForAll}.
871      */
872     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
873         return _operatorApprovals[owner][operator];
874     }
875 
876     /**
877      * @dev See {IERC721-transferFrom}.
878      */
879     function transferFrom(
880         address from,
881         address to,
882         uint256 tokenId
883     ) public virtual override {
884         _transfer(from, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         safeTransferFrom(from, to, tokenId, '');
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) public virtual override {
907         _transfer(from, to, tokenId);
908         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
909             revert TransferToNonERC721ReceiverImplementer();
910         }
911     }
912 
913     /**
914      * @dev Returns whether `tokenId` exists.
915      *
916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
917      *
918      * Tokens start existing when they are minted (`_mint`),
919      */
920     function _exists(uint256 tokenId) internal view returns (bool) {
921         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
922             !_ownerships[tokenId].burned;
923     }
924 
925     function _safeMint(address to, uint256 quantity) internal {
926         _safeMint(to, quantity, '');
927     }
928 
929     /**
930      * @dev Safely mints `quantity` tokens and transfers them to `to`.
931      *
932      * Requirements:
933      *
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
935      * - `quantity` must be greater than 0.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeMint(
940         address to,
941         uint256 quantity,
942         bytes memory _data
943     ) internal {
944         _mint(to, quantity, _data, true);
945     }
946 
947     /**
948      * @dev Mints `quantity` tokens and transfers them to `to`.
949      *
950      * Requirements:
951      *
952      * - `to` cannot be the zero address.
953      * - `quantity` must be greater than 0.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _mint(
958         address to,
959         uint256 quantity,
960         bytes memory _data,
961         bool safe
962     ) internal {
963         uint256 startTokenId = _currentIndex;
964         if (to == address(0)) revert MintToZeroAddress();
965         if (quantity == 0) revert MintZeroQuantity();
966 
967         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
968 
969         // Overflows are incredibly unrealistic.
970         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
971         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
972         unchecked {
973             _addressData[to].balance += uint64(quantity);
974             _addressData[to].numberMinted += uint64(quantity);
975 
976             _ownerships[startTokenId].addr = to;
977             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
978 
979             uint256 updatedIndex = startTokenId;
980             uint256 end = updatedIndex + quantity;
981 
982             if (safe && to.isContract()) {
983                 do {
984                     emit Transfer(address(0), to, updatedIndex);
985                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
986                         revert TransferToNonERC721ReceiverImplementer();
987                     }
988                 } while (updatedIndex != end);
989                 // Reentrancy protection
990                 if (_currentIndex != startTokenId) revert();
991             } else {
992                 do {
993                     emit Transfer(address(0), to, updatedIndex++);
994                 } while (updatedIndex != end);
995             }
996             _currentIndex = updatedIndex;
997         }
998         _afterTokenTransfers(address(0), to, startTokenId, quantity);
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _transfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) private {
1016         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1017 
1018         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1019 
1020         bool isApprovedOrOwner = (_msgSender() == from ||
1021             isApprovedForAll(from, _msgSender()) ||
1022             getApproved(tokenId) == _msgSender());
1023 
1024         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1025         if (to == address(0)) revert TransferToZeroAddress();
1026 
1027         _beforeTokenTransfers(from, to, tokenId, 1);
1028 
1029         // Clear approvals from the previous owner
1030         _approve(address(0), tokenId, from);
1031 
1032         // Underflow of the sender's balance is impossible because we check for
1033         // ownership above and the recipient's balance can't realistically overflow.
1034         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1035         unchecked {
1036             _addressData[from].balance -= 1;
1037             _addressData[to].balance += 1;
1038 
1039             TokenOwnership storage currSlot = _ownerships[tokenId];
1040             currSlot.addr = to;
1041             currSlot.startTimestamp = uint64(block.timestamp);
1042 
1043             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1044             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1045             uint256 nextTokenId = tokenId + 1;
1046             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1047             if (nextSlot.addr == address(0)) {
1048                 // This will suffice for checking _exists(nextTokenId),
1049                 // as a burned slot cannot contain the zero address.
1050                 if (nextTokenId != _currentIndex) {
1051                     nextSlot.addr = from;
1052                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1053                 }
1054             }
1055         }
1056 
1057         emit Transfer(from, to, tokenId);
1058         _afterTokenTransfers(from, to, tokenId, 1);
1059     }
1060 
1061     /**
1062      * @dev This is equivalent to _burn(tokenId, false)
1063      */
1064     function _burn(uint256 tokenId) internal virtual {
1065         _burn(tokenId, false);
1066     }
1067 
1068     /**
1069      * @dev Destroys `tokenId`.
1070      * The approval is cleared when the token is burned.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1079         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1080 
1081         address from = prevOwnership.addr;
1082 
1083         if (approvalCheck) {
1084             bool isApprovedOrOwner = (_msgSender() == from ||
1085                 isApprovedForAll(from, _msgSender()) ||
1086                 getApproved(tokenId) == _msgSender());
1087 
1088             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1089         }
1090 
1091         _beforeTokenTransfers(from, address(0), tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, from);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             AddressData storage addressData = _addressData[from];
1101             addressData.balance -= 1;
1102             addressData.numberBurned += 1;
1103 
1104             // Keep track of who burned the token, and the timestamp of burning.
1105             TokenOwnership storage currSlot = _ownerships[tokenId];
1106             currSlot.addr = from;
1107             currSlot.startTimestamp = uint64(block.timestamp);
1108             currSlot.burned = true;
1109 
1110             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1111             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1112             uint256 nextTokenId = tokenId + 1;
1113             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1114             if (nextSlot.addr == address(0)) {
1115                 // This will suffice for checking _exists(nextTokenId),
1116                 // as a burned slot cannot contain the zero address.
1117                 if (nextTokenId != _currentIndex) {
1118                     nextSlot.addr = from;
1119                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1120                 }
1121             }
1122         }
1123 
1124         emit Transfer(from, address(0), tokenId);
1125         _afterTokenTransfers(from, address(0), tokenId, 1);
1126 
1127         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1128         unchecked {
1129             _burnCounter++;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Approve `to` to operate on `tokenId`
1135      *
1136      * Emits a {Approval} event.
1137      */
1138     function _approve(
1139         address to,
1140         uint256 tokenId,
1141         address owner
1142     ) private {
1143         _tokenApprovals[tokenId] = to;
1144         emit Approval(owner, to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1149      *
1150      * @param from address representing the previous owner of the given token ID
1151      * @param to target address that will receive the tokens
1152      * @param tokenId uint256 ID of the token to be transferred
1153      * @param _data bytes optional data to send along with the call
1154      * @return bool whether the call correctly returned the expected magic value
1155      */
1156     function _checkContractOnERC721Received(
1157         address from,
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) private returns (bool) {
1162         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1163             return retval == IERC721Receiver(to).onERC721Received.selector;
1164         } catch (bytes memory reason) {
1165             if (reason.length == 0) {
1166                 revert TransferToNonERC721ReceiverImplementer();
1167             } else {
1168                 assembly {
1169                     revert(add(32, reason), mload(reason))
1170                 }
1171             }
1172         }
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1177      * And also called before burning one token.
1178      *
1179      * startTokenId - the first token id to be transferred
1180      * quantity - the amount to be transferred
1181      *
1182      * Calling conditions:
1183      *
1184      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1185      * transferred to `to`.
1186      * - When `from` is zero, `tokenId` will be minted for `to`.
1187      * - When `to` is zero, `tokenId` will be burned by `from`.
1188      * - `from` and `to` are never both zero.
1189      */
1190     function _beforeTokenTransfers(
1191         address from,
1192         address to,
1193         uint256 startTokenId,
1194         uint256 quantity
1195     ) internal virtual {}
1196 
1197     /**
1198      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1199      * minting.
1200      * And also called after one token has been burned.
1201      *
1202      * startTokenId - the first token id to be transferred
1203      * quantity - the amount to be transferred
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` has been minted for `to`.
1210      * - When `to` is zero, `tokenId` has been burned by `from`.
1211      * - `from` and `to` are never both zero.
1212      */
1213     function _afterTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 }
1220 
1221 // File: Okami.sol
1222 
1223 
1224 
1225 pragma solidity ^0.8.4;
1226 
1227 
1228 contract Okami is ERC721A {
1229     using Strings for uint256;
1230 
1231     string public baseURI;
1232     string public baseExtension = ".json";
1233     string public notRevealedUri;
1234     uint256 public cost = 0.15 ether;
1235     uint256 public costWL = 0.125 ether;
1236     uint256 public maxSupply = 5000;
1237     uint256 public maxMintAmount = 5;
1238     uint256 public nftPerAddressLimit = 20;
1239     bool public revealed = false;
1240     mapping(address => uint256) public addressMintedBalance;
1241     mapping(address => bool) public addressWhitelisted;
1242 
1243     uint256 public currentState = 1;
1244     address[] public whitelistedAddresses;
1245 
1246     address _owner = 0x9A754044FbfA95d15b252453c1BB5401320A8386;
1247 
1248     constructor() ERC721A("Okami", "OKAMI") {
1249         setNotRevealedURI(
1250             "https://bunn.mypinata.cloud/ipfs/QmR8AR2569bcvNZ1uKUYctApo8GTMz8fTTQpeNbGXC7RnQ"
1251         );
1252         _owner = _msgSender();
1253     }
1254 
1255     // internal
1256     function _baseURI() internal view virtual override returns (string memory) {
1257         return baseURI;
1258     }
1259 
1260     function mint(uint256 _mintAmount) public payable {
1261         uint256 supply = totalSupply();
1262         require(_mintAmount > 0, "need to mint at least 1 NFT");
1263         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1264         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1265         if (msg.sender != owner()) {
1266             require(currentState > 0, "the contract is paused");
1267 
1268             if (currentState == 1) {
1269                 require(isWhitelisted(msg.sender), "user is not whitelisted");
1270                 require(
1271                     msg.value >= costWL * _mintAmount,
1272                     "insufficient funds"
1273                 );
1274             } else if (currentState == 2) {
1275                 require(msg.value >= cost * _mintAmount, "insufficient funds");
1276             }
1277             require(
1278                 _mintAmount <= maxMintAmount,
1279                 "max mint amount per session exceeded"
1280             );
1281             require(
1282                 ownerMintedCount + _mintAmount <= nftPerAddressLimit,
1283                 "max NFT per address exceeded"
1284             );
1285         }
1286 
1287         addressMintedBalance[msg.sender] = ownerMintedCount + _mintAmount;
1288         _safeMint(msg.sender, _mintAmount);
1289     }
1290 
1291     function isWhitelisted(address _user) public view returns (bool) {
1292         return addressWhitelisted[_user];
1293     }
1294 
1295     function tokenURI(uint256 tokenId)
1296         public
1297         view
1298         virtual
1299         override
1300         returns (string memory)
1301     {
1302         require(
1303             _exists(tokenId),
1304             "ERC721Metadata: URI query for nonexistent token"
1305         );
1306 
1307         if (revealed == false) {
1308             return notRevealedUri;
1309         }
1310 
1311         string memory currentBaseURI = _baseURI();
1312         return
1313             bytes(currentBaseURI).length > 0
1314                 ? string(
1315                     abi.encodePacked(
1316                         currentBaseURI,
1317                         tokenId.toString(),
1318                         baseExtension
1319                     )
1320                 )
1321                 : "";
1322     }
1323 
1324     function setNewOwner(address _newOwner) public onlyOwner {
1325         _owner = _newOwner;
1326     }
1327 
1328     function owner() public view returns (address) {
1329         return _owner;
1330     }
1331 
1332     modifier onlyOwner() {
1333         require(owner() == _msgSender(), "caller is not the owner");
1334         _;
1335     }
1336 
1337     //only owner
1338     function reveal() public onlyOwner {
1339         revealed = true;
1340     }
1341 
1342     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1343         nftPerAddressLimit = _limit;
1344     }
1345 
1346     function setCost(uint256 _newCost) public onlyOwner {
1347         cost = _newCost;
1348     }
1349 
1350     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1351         maxMintAmount = _newmaxMintAmount;
1352     }
1353 
1354     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1355         baseURI = _newBaseURI;
1356     }
1357 
1358     function setBaseExtension(string memory _newBaseExtension)
1359         public
1360         onlyOwner
1361     {
1362         baseExtension = _newBaseExtension;
1363     }
1364 
1365     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1366         notRevealedUri = _notRevealedURI;
1367     }
1368 
1369     function pause() public onlyOwner {
1370         currentState = 0;
1371     }
1372 
1373     function setOnlyWhitelisted() public onlyOwner {
1374         currentState = 1;
1375     }
1376 
1377     function setPublic() public onlyOwner {
1378         currentState = 2;
1379     }
1380 
1381     function whitelistUsers(address[] calldata _users) public onlyOwner {
1382         for (uint256 i = 0; i < _users.length; i++) {
1383             addressWhitelisted[_users[i]] = true;
1384         }
1385     }
1386 
1387     function removeUserFromWhitelist(address _user) public onlyOwner {
1388         addressWhitelisted[_user] = false;
1389     }
1390 
1391     function setPublicCost(uint256 _price) public onlyOwner {
1392         cost = _price;
1393     }
1394 
1395     function setWLCost(uint256 _price) public onlyOwner {
1396         costWL = _price;
1397     }
1398 
1399     function withdraw() public payable onlyOwner {
1400         // This will payout the owner the contract balance.
1401         // Do not remove this otherwise you will not be able to withdraw the funds.
1402         // =============================================================================
1403         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1404         require(os);
1405         // =============================================================================
1406     }
1407 }