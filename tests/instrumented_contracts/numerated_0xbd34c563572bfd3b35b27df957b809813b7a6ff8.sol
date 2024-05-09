1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-10
3 */
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
33 
34 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
178 
179 pragma solidity ^0.8.0;
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
204 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
232 
233 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
239  * @dev See https://eips.ethereum.org/EIPS/eip-721
240  */
241 interface IERC721Enumerable is IERC721 {
242     /**
243      * @dev Returns the total amount of tokens stored by the contract.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
249      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
250      */
251     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
252 
253     /**
254      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
255      * Use along with {totalSupply} to enumerate all tokens.
256      */
257     function tokenByIndex(uint256 index) external view returns (uint256);
258 }
259 
260 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
261 
262 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
263 
264 pragma solidity ^0.8.1;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      *
287      * [IMPORTANT]
288      * ====
289      * You shouldn't rely on `isContract` to protect against flash loan attacks!
290      *
291      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
292      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
293      * constructor.
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize/address.code.length, which returns 0
298         // for contracts in construction, since the code is only stored at the end
299         // of the constructor execution.
300 
301         return account.code.length > 0;
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         (bool success, ) = recipient.call{value: amount}("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain `call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(
375         address target,
376         bytes memory data,
377         uint256 value
378     ) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         require(isContract(target), "Address: call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.call{value: value}(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
408         return functionStaticCall(target, data, "Address: low-level static call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         require(isContract(target), "Address: static call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         require(isContract(target), "Address: delegate call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.delegatecall(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
457      * revert reason using the provided one.
458      *
459      * _Available since v4.3._
460      */
461     function verifyCallResult(
462         bool success,
463         bytes memory returndata,
464         string memory errorMessage
465     ) internal pure returns (bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
485 
486 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Provides information about the current execution context, including the
492  * sender of the transaction and its data. While these are generally available
493  * via msg.sender and msg.data, they should not be accessed in such a direct
494  * manner, since when dealing with meta-transactions the account sending and
495  * paying for execution may not be the actual sender (as far as an application
496  * is concerned).
497  *
498  * This contract is only required for intermediate, library-like contracts.
499  */
500 abstract contract Context {
501     function _msgSender() internal view virtual returns (address) {
502         return msg.sender;
503     }
504 
505     function _msgData() internal view virtual returns (bytes calldata) {
506         return msg.data;
507     }
508 }
509 
510 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev String operations.
518  */
519 library Strings {
520     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
521 
522     /**
523      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
524      */
525     function toString(uint256 value) internal pure returns (string memory) {
526         // Inspired by OraclizeAPI's implementation - MIT licence
527         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
528 
529         if (value == 0) {
530             return "0";
531         }
532         uint256 temp = value;
533         uint256 digits;
534         while (temp != 0) {
535             digits++;
536             temp /= 10;
537         }
538         bytes memory buffer = new bytes(digits);
539         while (value != 0) {
540             digits -= 1;
541             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
542             value /= 10;
543         }
544         return string(buffer);
545     }
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
549      */
550     function toHexString(uint256 value) internal pure returns (string memory) {
551         if (value == 0) {
552             return "0x00";
553         }
554         uint256 temp = value;
555         uint256 length = 0;
556         while (temp != 0) {
557             length++;
558             temp >>= 8;
559         }
560         return toHexString(value, length);
561     }
562 
563     /**
564      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
565      */
566     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
567         bytes memory buffer = new bytes(2 * length + 2);
568         buffer[0] = "0";
569         buffer[1] = "x";
570         for (uint256 i = 2 * length + 1; i > 1; --i) {
571             buffer[i] = _HEX_SYMBOLS[value & 0xf];
572             value >>= 4;
573         }
574         require(value == 0, "Strings: hex length insufficient");
575         return string(buffer);
576     }
577 }
578 
579 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
580 
581 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Implementation of the {IERC165} interface.
587  *
588  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
589  * for the additional interface id that will be supported. For example:
590  *
591  * ```solidity
592  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
594  * }
595  * ```
596  *
597  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
598  */
599 abstract contract ERC165 is IERC165 {
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604         return interfaceId == type(IERC165).interfaceId;
605     }
606 }
607 
608 // File erc721a/contracts/ERC721A.sol@v3.0.0
609 
610 // Creator: Chiru Labs
611 
612 pragma solidity ^0.8.4;
613 
614 error ApprovalCallerNotOwnerNorApproved();
615 error ApprovalQueryForNonexistentToken();
616 error ApproveToCaller();
617 error ApprovalToCurrentOwner();
618 error BalanceQueryForZeroAddress();
619 error MintedQueryForZeroAddress();
620 error BurnedQueryForZeroAddress();
621 error AuxQueryForZeroAddress();
622 error MintToZeroAddress();
623 error MintZeroQuantity();
624 error OwnerIndexOutOfBounds();
625 error OwnerQueryForNonexistentToken();
626 error TokenIndexOutOfBounds();
627 error TransferCallerNotOwnerNorApproved();
628 error TransferFromIncorrectOwner();
629 error TransferToNonERC721ReceiverImplementer();
630 error TransferToZeroAddress();
631 error URIQueryForNonexistentToken();
632 
633 /**
634  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
635  * the Metadata extension. Built to optimize for lower gas during batch mints.
636  *
637  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
638  *
639  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
640  *
641  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
642  */
643 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
644     using Address for address;
645     using Strings for uint256;
646 
647     // Compiler will pack this into a single 256bit word.
648     struct TokenOwnership {
649         // The address of the owner.
650         address addr;
651         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
652         uint64 startTimestamp;
653         // Whether the token has been burned.
654         bool burned;
655     }
656 
657     // Compiler will pack this into a single 256bit word.
658     struct AddressData {
659         // Realistically, 2**64-1 is more than enough.
660         uint64 balance;
661         // Keeps track of mint count with minimal overhead for tokenomics.
662         uint64 numberMinted;
663         // Keeps track of burn count with minimal overhead for tokenomics.
664         uint64 numberBurned;
665         // For miscellaneous variable(s) pertaining to the address
666         // (e.g. number of whitelist mint slots used).
667         // If there are multiple variables, please pack them into a uint64.
668         uint64 aux;
669     }
670 
671     // The tokenId of the next token to be minted.
672     uint256 internal _currentIndex;
673 
674     // The number of tokens burned.
675     uint256 internal _burnCounter;
676 
677     // Token name
678     string private _name;
679 
680     // Token symbol
681     string private _symbol;
682 
683     // Mapping from token ID to ownership details
684     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
685     mapping(uint256 => TokenOwnership) internal _ownerships;
686 
687     // Mapping owner address to address data
688     mapping(address => AddressData) private _addressData;
689 
690     // Mapping from token ID to approved address
691     mapping(uint256 => address) private _tokenApprovals;
692 
693     // Mapping from owner to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     constructor(string memory name_, string memory symbol_) {
697         _name = name_;
698         _symbol = symbol_;
699         _currentIndex = _startTokenId();
700     }
701 
702     /**
703      * To change the starting tokenId, please override this function.
704      */
705     function _startTokenId() internal view virtual returns (uint256) {
706         return 0;
707     }
708 
709     /**
710      * @dev See {IERC721Enumerable-totalSupply}.
711      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
712      */
713     function totalSupply() public view returns (uint256) {
714         // Counter underflow is impossible as _burnCounter cannot be incremented
715         // more than _currentIndex - _startTokenId() times
716         unchecked {
717             return _currentIndex - _burnCounter - _startTokenId();
718         }
719     }
720 
721     /**
722      * Returns the total amount of tokens minted in the contract.
723      */
724     function _totalMinted() internal view returns (uint256) {
725         // Counter underflow is impossible as _currentIndex does not decrement,
726         // and it is initialized to _startTokenId()
727         unchecked {
728             return _currentIndex - _startTokenId();
729         }
730     }
731 
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
736         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
737     }
738 
739     /**
740      * @dev See {IERC721-balanceOf}.
741      */
742     function balanceOf(address owner) public view override returns (uint256) {
743         if (owner == address(0)) revert BalanceQueryForZeroAddress();
744         return uint256(_addressData[owner].balance);
745     }
746 
747     /**
748      * Returns the number of tokens minted by `owner`.
749      */
750     function _numberMinted(address owner) internal view returns (uint256) {
751         if (owner == address(0)) revert MintedQueryForZeroAddress();
752         return uint256(_addressData[owner].numberMinted);
753     }
754 
755     /**
756      * Returns the number of tokens burned by or on behalf of `owner`.
757      */
758     function _numberBurned(address owner) internal view returns (uint256) {
759         if (owner == address(0)) revert BurnedQueryForZeroAddress();
760         return uint256(_addressData[owner].numberBurned);
761     }
762 
763     /**
764      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
765      */
766     function _getAux(address owner) internal view returns (uint64) {
767         if (owner == address(0)) revert AuxQueryForZeroAddress();
768         return _addressData[owner].aux;
769     }
770 
771     /**
772      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
773      * If there are multiple variables, please pack them into a uint64.
774      */
775     function _setAux(address owner, uint64 aux) internal {
776         if (owner == address(0)) revert AuxQueryForZeroAddress();
777         _addressData[owner].aux = aux;
778     }
779 
780     /**
781      * Gas spent here starts off proportional to the maximum mint batch size.
782      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
783      */
784     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
785         uint256 curr = tokenId;
786 
787         unchecked {
788             if (_startTokenId() <= curr && curr < _currentIndex) {
789                 TokenOwnership memory ownership = _ownerships[curr];
790                 if (!ownership.burned) {
791                     if (ownership.addr != address(0)) {
792                         return ownership;
793                     }
794                     // Invariant:
795                     // There will always be an ownership that has an address and is not burned
796                     // before an ownership that does not have an address and is not burned.
797                     // Hence, curr will not underflow.
798                     while (true) {
799                         curr--;
800                         ownership = _ownerships[curr];
801                         if (ownership.addr != address(0)) {
802                             return ownership;
803                         }
804                     }
805                 }
806             }
807         }
808         revert OwnerQueryForNonexistentToken();
809     }
810 
811     /**
812      * @dev See {IERC721-ownerOf}.
813      */
814     function ownerOf(uint256 tokenId) public view override returns (address) {
815         return ownershipOf(tokenId).addr;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return "";
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public override {
855         address owner = ERC721A.ownerOf(tokenId);
856         if (to == owner) revert ApprovalToCurrentOwner();
857 
858         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
859             revert ApprovalCallerNotOwnerNorApproved();
860         }
861 
862         _approve(to, tokenId, owner);
863     }
864 
865     /**
866      * @dev See {IERC721-getApproved}.
867      */
868     function getApproved(uint256 tokenId) public view override returns (address) {
869         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
870 
871         return _tokenApprovals[tokenId];
872     }
873 
874     /**
875      * @dev See {IERC721-setApprovalForAll}.
876      */
877     function setApprovalForAll(address operator, bool approved) public override {
878         if (operator == _msgSender()) revert ApproveToCaller();
879 
880         _operatorApprovals[_msgSender()][operator] = approved;
881         emit ApprovalForAll(_msgSender(), operator, approved);
882     }
883 
884     /**
885      * @dev See {IERC721-isApprovedForAll}.
886      */
887     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev See {IERC721-transferFrom}.
893      */
894     function transferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         _transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         safeTransferFrom(from, to, tokenId, "");
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public virtual override {
922         _transfer(from, to, tokenId);
923         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
924             revert TransferToNonERC721ReceiverImplementer();
925         }
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      */
935     function _exists(uint256 tokenId) internal view returns (bool) {
936         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
937     }
938 
939     function _safeMint(address to, uint256 quantity) internal {
940         _safeMint(to, quantity, "");
941     }
942 
943     /**
944      * @dev Safely mints `quantity` tokens and transfers them to `to`.
945      *
946      * Requirements:
947      *
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
949      * - `quantity` must be greater than 0.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _safeMint(
954         address to,
955         uint256 quantity,
956         bytes memory _data
957     ) internal {
958         _mint(to, quantity, _data, true);
959     }
960 
961     /**
962      * @dev Mints `quantity` tokens and transfers them to `to`.
963      *
964      * Requirements:
965      *
966      * - `to` cannot be the zero address.
967      * - `quantity` must be greater than 0.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _mint(
972         address to,
973         uint256 quantity,
974         bytes memory _data,
975         bool safe
976     ) internal {
977         uint256 startTokenId = _currentIndex;
978         if (to == address(0)) revert MintToZeroAddress();
979         if (quantity == 0) revert MintZeroQuantity();
980 
981         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
982 
983         // Overflows are incredibly unrealistic.
984         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
985         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
986         unchecked {
987             _addressData[to].balance += uint64(quantity);
988             _addressData[to].numberMinted += uint64(quantity);
989 
990             _ownerships[startTokenId].addr = to;
991             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
992 
993             uint256 updatedIndex = startTokenId;
994             uint256 end = updatedIndex + quantity;
995 
996             if (safe && to.isContract()) {
997                 do {
998                     emit Transfer(address(0), to, updatedIndex);
999                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1000                         revert TransferToNonERC721ReceiverImplementer();
1001                     }
1002                 } while (updatedIndex != end);
1003                 // Reentrancy protection
1004                 if (_currentIndex != startTokenId) revert();
1005             } else {
1006                 do {
1007                     emit Transfer(address(0), to, updatedIndex++);
1008                 } while (updatedIndex != end);
1009             }
1010             _currentIndex = updatedIndex;
1011         }
1012         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) private {
1030         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1031 
1032         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || isApprovedForAll(prevOwnership.addr, _msgSender()) || getApproved(tokenId) == _msgSender());
1033 
1034         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1035         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1036         if (to == address(0)) revert TransferToZeroAddress();
1037 
1038         _beforeTokenTransfers(from, to, tokenId, 1);
1039 
1040         // Clear approvals from the previous owner
1041         _approve(address(0), tokenId, prevOwnership.addr);
1042 
1043         // Underflow of the sender's balance is impossible because we check for
1044         // ownership above and the recipient's balance can't realistically overflow.
1045         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1046         unchecked {
1047             _addressData[from].balance -= 1;
1048             _addressData[to].balance += 1;
1049 
1050             _ownerships[tokenId].addr = to;
1051             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1052 
1053             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1054             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1055             uint256 nextTokenId = tokenId + 1;
1056             if (_ownerships[nextTokenId].addr == address(0)) {
1057                 // This will suffice for checking _exists(nextTokenId),
1058                 // as a burned slot cannot contain the zero address.
1059                 if (nextTokenId < _currentIndex) {
1060                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1061                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1062                 }
1063             }
1064         }
1065 
1066         emit Transfer(from, to, tokenId);
1067         _afterTokenTransfers(from, to, tokenId, 1);
1068     }
1069 
1070     /**
1071      * @dev Destroys `tokenId`.
1072      * The approval is cleared when the token is burned.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must exist.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _burn(uint256 tokenId) internal virtual {
1081         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1082 
1083         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId, prevOwnership.addr);
1087 
1088         // Underflow of the sender's balance is impossible because we check for
1089         // ownership above and the recipient's balance can't realistically overflow.
1090         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1091         unchecked {
1092             _addressData[prevOwnership.addr].balance -= 1;
1093             _addressData[prevOwnership.addr].numberBurned += 1;
1094 
1095             // Keep track of who burned the token, and the timestamp of burning.
1096             _ownerships[tokenId].addr = prevOwnership.addr;
1097             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1098             _ownerships[tokenId].burned = true;
1099 
1100             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1101             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1102             uint256 nextTokenId = tokenId + 1;
1103             if (_ownerships[nextTokenId].addr == address(0)) {
1104                 // This will suffice for checking _exists(nextTokenId),
1105                 // as a burned slot cannot contain the zero address.
1106                 if (nextTokenId < _currentIndex) {
1107                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1108                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1109                 }
1110             }
1111         }
1112 
1113         emit Transfer(prevOwnership.addr, address(0), tokenId);
1114         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
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
1210 // File erc721a/contracts/extensions/ERC721AOwnersExplicit.sol@v3.0.0
1211 
1212 // Creator: Chiru Labs
1213 
1214 pragma solidity ^0.8.4;
1215 
1216 error AllOwnershipsHaveBeenSet();
1217 error QuantityMustBeNonZero();
1218 error NoTokensMintedYet();
1219 
1220 abstract contract ERC721AOwnersExplicit is ERC721A {
1221     uint256 public nextOwnerToExplicitlySet;
1222 
1223     /**
1224      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1225      */
1226     function _setOwnersExplicit(uint256 quantity) internal {
1227         if (quantity == 0) revert QuantityMustBeNonZero();
1228         if (_currentIndex == _startTokenId()) revert NoTokensMintedYet();
1229         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1230         if (_nextOwnerToExplicitlySet == 0) {
1231             _nextOwnerToExplicitlySet = _startTokenId();
1232         }
1233         if (_nextOwnerToExplicitlySet >= _currentIndex) revert AllOwnershipsHaveBeenSet();
1234 
1235         // Index underflow is impossible.
1236         // Counter or index overflow is incredibly unrealistic.
1237         unchecked {
1238             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1239 
1240             // Set the end index to be the last token index
1241             if (endIndex + 1 > _currentIndex) {
1242                 endIndex = _currentIndex - 1;
1243             }
1244 
1245             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1246                 if (_ownerships[i].addr == address(0) && !_ownerships[i].burned) {
1247                     TokenOwnership memory ownership = ownershipOf(i);
1248                     _ownerships[i].addr = ownership.addr;
1249                     _ownerships[i].startTimestamp = ownership.startTimestamp;
1250                 }
1251             }
1252 
1253             nextOwnerToExplicitlySet = endIndex + 1;
1254         }
1255     }
1256 }
1257 
1258 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1259 
1260 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1261 
1262 pragma solidity ^0.8.0;
1263 
1264 /**
1265  * @dev Contract module which provides a basic access control mechanism, where
1266  * there is an account (an owner) that can be granted exclusive access to
1267  * specific functions.
1268  *
1269  * By default, the owner account will be the one that deploys the contract. This
1270  * can later be changed with {transferOwnership}.
1271  *
1272  * This module is used through inheritance. It will make available the modifier
1273  * `onlyOwner`, which can be applied to your functions to restrict their use to
1274  * the owner.
1275  */
1276 abstract contract Ownable is Context {
1277     address private _owner;
1278 
1279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1280 
1281     /**
1282      * @dev Initializes the contract setting the deployer as the initial owner.
1283      */
1284     constructor() {
1285         _transferOwnership(_msgSender());
1286     }
1287 
1288     /**
1289      * @dev Returns the address of the current owner.
1290      */
1291     function owner() public view virtual returns (address) {
1292         return _owner;
1293     }
1294 
1295     /**
1296      * @dev Throws if called by any account other than the owner.
1297      */
1298     modifier onlyOwner() {
1299         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1300         _;
1301     }
1302 
1303     /**
1304      * @dev Leaves the contract without owner. It will not be possible to call
1305      * `onlyOwner` functions anymore. Can only be called by the current owner.
1306      *
1307      * NOTE: Renouncing ownership will leave the contract without an owner,
1308      * thereby removing any functionality that is only available to the owner.
1309      */
1310     function renounceOwnership() public virtual onlyOwner {
1311         _transferOwnership(address(0));
1312     }
1313 
1314     /**
1315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1316      * Can only be called by the current owner.
1317      */
1318     function transferOwnership(address newOwner) public virtual onlyOwner {
1319         require(newOwner != address(0), "Ownable: new owner is the zero address");
1320         _transferOwnership(newOwner);
1321     }
1322 
1323     /**
1324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1325      * Internal function without access restriction.
1326      */
1327     function _transferOwnership(address newOwner) internal virtual {
1328         address oldOwner = _owner;
1329         _owner = newOwner;
1330         emit OwnershipTransferred(oldOwner, newOwner);
1331     }
1332 }
1333 
1334 // File contracts/NFT.sol
1335 
1336 pragma solidity ^0.8.4;
1337 
1338 contract NFT is ERC721A, ERC721AOwnersExplicit, Ownable {
1339     address public manager;
1340     string public _baseTokenURI;
1341 
1342     modifier onlyManager() {
1343         require(manager == _msgSender(), "Only manager can mint");
1344         _;
1345     }
1346 
1347     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {
1348         manager = msg.sender;
1349     }
1350 
1351     function safeMint(address to, uint256 quantity) external onlyManager {
1352         _safeMint(to, quantity);
1353     }
1354 
1355     function setManager(address to) external onlyOwner {
1356         manager = to;
1357     }
1358 
1359     function setBaseURI(string calldata baseURI) external onlyOwner {
1360         _baseTokenURI = baseURI;
1361     }
1362 
1363     function _baseURI() internal view override returns (string memory) {
1364         return _baseTokenURI;
1365     }
1366 }