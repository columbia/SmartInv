1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
32 
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Required interface of an ERC721 compliant contract.
42  */
43 interface IERC721 is IERC165 {
44     /**
45      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
51      */
52     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56      */
57     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
58 
59     /**
60      * @dev Returns the number of tokens in ``owner``'s account.
61      */
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the `tokenId` token.
66      *
67      * Requirements:
68      *
69      * - `tokenId` must exist.
70      */
71     function ownerOf(uint256 tokenId) external view returns (address owner);
72 
73     /**
74      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
75      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92 
93     /**
94      * @dev Transfers `tokenId` token from `from` to `to`.
95      *
96      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must be owned by `from`.
103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 tokenId
111     ) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId) external view returns (address operator);
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
151      *
152      * See {setApprovalForAll}
153      */
154     function isApprovedForAll(address owner, address operator) external view returns (bool);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166      *
167      * Emits a {Transfer} event.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 }
176 
177 
178 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
208 
209 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
210 
211 
212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 
238 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
239 
240 
241 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
242 
243 pragma solidity ^0.8.1;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      *
266      * [IMPORTANT]
267      * ====
268      * You shouldn't rely on `isContract` to protect against flash loan attacks!
269      *
270      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
271      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
272      * constructor.
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize/address.code.length, which returns 0
277         // for contracts in construction, since the code is only stored at the end
278         // of the constructor execution.
279 
280         return account.code.length > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 
464 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev Provides information about the current execution context, including the
473  * sender of the transaction and its data. While these are generally available
474  * via msg.sender and msg.data, they should not be accessed in such a direct
475  * manner, since when dealing with meta-transactions the account sending and
476  * paying for execution may not be the actual sender (as far as an application
477  * is concerned).
478  *
479  * This contract is only required for intermediate, library-like contracts.
480  */
481 abstract contract Context {
482     function _msgSender() internal view virtual returns (address) {
483         return msg.sender;
484     }
485 
486     function _msgData() internal view virtual returns (bytes calldata) {
487         return msg.data;
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev String operations.
501  */
502 library Strings {
503     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
507      */
508     function toString(uint256 value) internal pure returns (string memory) {
509         // Inspired by OraclizeAPI's implementation - MIT licence
510         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
511 
512         if (value == 0) {
513             return "0";
514         }
515         uint256 temp = value;
516         uint256 digits;
517         while (temp != 0) {
518             digits++;
519             temp /= 10;
520         }
521         bytes memory buffer = new bytes(digits);
522         while (value != 0) {
523             digits -= 1;
524             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
525             value /= 10;
526         }
527         return string(buffer);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
532      */
533     function toHexString(uint256 value) internal pure returns (string memory) {
534         if (value == 0) {
535             return "0x00";
536         }
537         uint256 temp = value;
538         uint256 length = 0;
539         while (temp != 0) {
540             length++;
541             temp >>= 8;
542         }
543         return toHexString(value, length);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
548      */
549     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
550         bytes memory buffer = new bytes(2 * length + 2);
551         buffer[0] = "0";
552         buffer[1] = "x";
553         for (uint256 i = 2 * length + 1; i > 1; --i) {
554             buffer[i] = _HEX_SYMBOLS[value & 0xf];
555             value >>= 4;
556         }
557         require(value == 0, "Strings: hex length insufficient");
558         return string(buffer);
559     }
560 }
561 
562 
563 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev Implementation of the {IERC165} interface.
572  *
573  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
574  * for the additional interface id that will be supported. For example:
575  *
576  * ```solidity
577  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
579  * }
580  * ```
581  *
582  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
583  */
584 abstract contract ERC165 is IERC165 {
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589         return interfaceId == type(IERC165).interfaceId;
590     }
591 }
592 
593 
594 // File contracts/ERC721A.sol
595 
596 
597 // Creator: Chiru Labs
598 
599 pragma solidity ^0.8.4;
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
694         return 0;
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
922         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
923     }
924 
925     /**
926      * @dev Equivalent to `_safeMint(to, quantity, '')`.
927      */
928     function _safeMint(address to, uint256 quantity) internal {
929         _safeMint(to, quantity, '');
930     }
931 
932     /**
933      * @dev Safely mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - If `to` refers to a smart contract, it must implement 
938      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
939      * - `quantity` must be greater than 0.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(
944         address to,
945         uint256 quantity,
946         bytes memory _data
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
957         unchecked {
958             _addressData[to].balance += uint64(quantity);
959             _addressData[to].numberMinted += uint64(quantity);
960 
961             _ownerships[startTokenId].addr = to;
962             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
963 
964             uint256 updatedIndex = startTokenId;
965             uint256 end = updatedIndex + quantity;
966 
967             if (to.isContract()) {
968                 do {
969                     emit Transfer(address(0), to, updatedIndex);
970                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
971                         revert TransferToNonERC721ReceiverImplementer();
972                     }
973                 } while (updatedIndex != end);
974                 // Reentrancy protection
975                 if (_currentIndex != startTokenId) revert();
976             } else {
977                 do {
978                     emit Transfer(address(0), to, updatedIndex++);
979                 } while (updatedIndex != end);
980             }
981             _currentIndex = updatedIndex;
982         }
983         _afterTokenTransfers(address(0), to, startTokenId, quantity);
984     }
985 
986     /**
987      * @dev Mints `quantity` tokens and transfers them to `to`.
988      *
989      * Requirements:
990      *
991      * - `to` cannot be the zero address.
992      * - `quantity` must be greater than 0.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _mint(address to, uint256 quantity) internal {
997         uint256 startTokenId = _currentIndex;
998         if (to == address(0)) revert MintToZeroAddress();
999         if (quantity == 0) revert MintZeroQuantity();
1000 
1001         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1002 
1003         // Overflows are incredibly unrealistic.
1004         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1005         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1006         unchecked {
1007             _addressData[to].balance += uint64(quantity);
1008             _addressData[to].numberMinted += uint64(quantity);
1009 
1010             _ownerships[startTokenId].addr = to;
1011             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1012 
1013             uint256 updatedIndex = startTokenId;
1014             uint256 end = updatedIndex + quantity;
1015 
1016             do {
1017                 emit Transfer(address(0), to, updatedIndex++);
1018             } while (updatedIndex != end);
1019 
1020             _currentIndex = updatedIndex;
1021         }
1022         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) private {
1040         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1041 
1042         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1043 
1044         bool isApprovedOrOwner = (_msgSender() == from ||
1045             isApprovedForAll(from, _msgSender()) ||
1046             getApproved(tokenId) == _msgSender());
1047 
1048         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1049         if (to == address(0)) revert TransferToZeroAddress();
1050 
1051         _beforeTokenTransfers(from, to, tokenId, 1);
1052 
1053         // Clear approvals from the previous owner
1054         _approve(address(0), tokenId, from);
1055 
1056         // Underflow of the sender's balance is impossible because we check for
1057         // ownership above and the recipient's balance can't realistically overflow.
1058         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1059         unchecked {
1060             _addressData[from].balance -= 1;
1061             _addressData[to].balance += 1;
1062 
1063             TokenOwnership storage currSlot = _ownerships[tokenId];
1064             currSlot.addr = to;
1065             currSlot.startTimestamp = uint64(block.timestamp);
1066 
1067             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1068             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1069             uint256 nextTokenId = tokenId + 1;
1070             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1071             if (nextSlot.addr == address(0)) {
1072                 // This will suffice for checking _exists(nextTokenId),
1073                 // as a burned slot cannot contain the zero address.
1074                 if (nextTokenId != _currentIndex) {
1075                     nextSlot.addr = from;
1076                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1077                 }
1078             }
1079         }
1080 
1081         emit Transfer(from, to, tokenId);
1082         _afterTokenTransfers(from, to, tokenId, 1);
1083     }
1084 
1085     /**
1086      * @dev Equivalent to `_burn(tokenId, false)`.
1087      */
1088     function _burn(uint256 tokenId) internal virtual {
1089         _burn(tokenId, false);
1090     }
1091 
1092     /**
1093      * @dev Destroys `tokenId`.
1094      * The approval is cleared when the token is burned.
1095      *
1096      * Requirements:
1097      *
1098      * - `tokenId` must exist.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1103         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1104 
1105         address from = prevOwnership.addr;
1106 
1107         if (approvalCheck) {
1108             bool isApprovedOrOwner = (_msgSender() == from ||
1109                 isApprovedForAll(from, _msgSender()) ||
1110                 getApproved(tokenId) == _msgSender());
1111 
1112             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1113         }
1114 
1115         _beforeTokenTransfers(from, address(0), tokenId, 1);
1116 
1117         // Clear approvals from the previous owner
1118         _approve(address(0), tokenId, from);
1119 
1120         // Underflow of the sender's balance is impossible because we check for
1121         // ownership above and the recipient's balance can't realistically overflow.
1122         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1123         unchecked {
1124             AddressData storage addressData = _addressData[from];
1125             addressData.balance -= 1;
1126             addressData.numberBurned += 1;
1127 
1128             // Keep track of who burned the token, and the timestamp of burning.
1129             TokenOwnership storage currSlot = _ownerships[tokenId];
1130             currSlot.addr = from;
1131             currSlot.startTimestamp = uint64(block.timestamp);
1132             currSlot.burned = true;
1133 
1134             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1135             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1136             uint256 nextTokenId = tokenId + 1;
1137             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1138             if (nextSlot.addr == address(0)) {
1139                 // This will suffice for checking _exists(nextTokenId),
1140                 // as a burned slot cannot contain the zero address.
1141                 if (nextTokenId != _currentIndex) {
1142                     nextSlot.addr = from;
1143                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1144                 }
1145             }
1146         }
1147 
1148         emit Transfer(from, address(0), tokenId);
1149         _afterTokenTransfers(from, address(0), tokenId, 1);
1150 
1151         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1152         unchecked {
1153             _burnCounter++;
1154         }
1155     }
1156 
1157     /**
1158      * @dev Approve `to` to operate on `tokenId`
1159      *
1160      * Emits a {Approval} event.
1161      */
1162     function _approve(
1163         address to,
1164         uint256 tokenId,
1165         address owner
1166     ) private {
1167         _tokenApprovals[tokenId] = to;
1168         emit Approval(owner, to, tokenId);
1169     }
1170 
1171     /**
1172      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1173      *
1174      * @param from address representing the previous owner of the given token ID
1175      * @param to target address that will receive the tokens
1176      * @param tokenId uint256 ID of the token to be transferred
1177      * @param _data bytes optional data to send along with the call
1178      * @return bool whether the call correctly returned the expected magic value
1179      */
1180     function _checkContractOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) private returns (bool) {
1186         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1187             return retval == IERC721Receiver(to).onERC721Received.selector;
1188         } catch (bytes memory reason) {
1189             if (reason.length == 0) {
1190                 revert TransferToNonERC721ReceiverImplementer();
1191             } else {
1192                 assembly {
1193                     revert(add(32, reason), mload(reason))
1194                 }
1195             }
1196         }
1197     }
1198 
1199     /**
1200      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1201      * And also called before burning one token.
1202      *
1203      * startTokenId - the first token id to be transferred
1204      * quantity - the amount to be transferred
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` will be minted for `to`.
1211      * - When `to` is zero, `tokenId` will be burned by `from`.
1212      * - `from` and `to` are never both zero.
1213      */
1214     function _beforeTokenTransfers(
1215         address from,
1216         address to,
1217         uint256 startTokenId,
1218         uint256 quantity
1219     ) internal virtual {}
1220 
1221     /**
1222      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1223      * minting.
1224      * And also called after one token has been burned.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` has been minted for `to`.
1234      * - When `to` is zero, `tokenId` has been burned by `from`.
1235      * - `from` and `to` are never both zero.
1236      */
1237     function _afterTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 }
1244 
1245 
1246 // File contracts/pfpPlus.sol
1247 
1248 pragma solidity ^0.8.9;
1249 
1250 contract pfpPlus is ERC721A {
1251     string private _baseTokenURI;
1252     address private deployer;
1253 
1254     bool public saleIsActive = false;
1255 
1256     uint256 public maxAmount = 1111;
1257     uint256 public maxPerMint = 30;
1258     uint256 public nftPrice = 0.099 ether;
1259 
1260     address projectWallet = 0x18810A0bCDE665eFA07123A6caCfC92527c7907e;
1261     address devWallet = 0x38c0245C7C67576d1E73f3A11c6af76fE8d11dEA;
1262     address renderingWallet = 0x448b3D5B9621f5FD96dEBEC73AD4c35eE306f1F5;
1263     address artWallet = 0x3ec4D95C548FD0284ca51BeaC70034621c7F3989;
1264 
1265     modifier onlyOwner() {
1266         require(msg.sender == deployer, "Permission denied.");
1267         _;
1268     }
1269 
1270     constructor() ERC721A("pfp+", "PFP+") {
1271         deployer = address(msg.sender);
1272     }
1273 
1274     function _baseURI() internal view virtual override returns (string memory) {
1275         return _baseTokenURI;
1276     }
1277 
1278     function setBaseURI(string calldata baseURI) external onlyOwner {
1279         _baseTokenURI = baseURI;
1280     }
1281 
1282     function setMaxPerMint(uint256 newMax) external onlyOwner {
1283         maxPerMint = newMax;
1284     }
1285 
1286     function changeMaxAmount(uint256 newMax) external onlyOwner {
1287         maxAmount = newMax;
1288     }
1289 
1290     function flipSaleState() public onlyOwner {
1291         saleIsActive = !saleIsActive;
1292     }
1293 
1294     function mintReserveTokens(uint256 numberOfTokens) public onlyOwner {
1295         _safeMint(msg.sender, numberOfTokens);
1296         require(totalSupply() <= maxAmount, "Limit reached");
1297     }
1298 
1299     function mintNFT(uint256 numberOfTokens) public payable {
1300         require(saleIsActive, "Sale is not active");
1301         require(
1302             numberOfTokens <= maxPerMint,
1303             "You can't mint that many at once"
1304         );
1305         require(
1306             nftPrice * numberOfTokens <= msg.value,
1307             "Ether value sent is not correct"
1308         );
1309 
1310         _safeMint(msg.sender, numberOfTokens);
1311 
1312         require(totalSupply() <= maxAmount, "Limit reached");
1313     }
1314 
1315     function withdrawMoney() external onlyOwner {
1316         payable(deployer).transfer(address(this).balance);
1317     }
1318 
1319     function withdrawAll() public payable onlyOwner {
1320         uint256 project = (address(this).balance * 30) / 100;
1321         uint256 dev = (address(this).balance * 30) / 100;
1322         uint256 rendering = (address(this).balance * 20) / 100;
1323         uint256 art = (address(this).balance * 20) / 100;
1324 
1325         require(payable(projectWallet).send(project));
1326         require(payable(devWallet).send(dev));
1327         require(payable(renderingWallet).send(rendering));
1328         require(payable(artWallet).send(art));
1329     }
1330 }