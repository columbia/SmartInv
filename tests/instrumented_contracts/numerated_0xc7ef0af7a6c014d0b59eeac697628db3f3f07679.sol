1 /**
2 
3  ____  ____  _  _  ___ 
4 (  _ \(  _ \( \/ )/ __)
5  ) _ < )___/ \  /( (__ 
6 (____/(__)   (__) \___)
7 
8 */
9 // SPDX-License-Identifier: MIT
10 
11 // File: @openzeppelin/contracts/utils/Strings.sol
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/Address.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
111 
112 pragma solidity ^0.8.1;
113 
114 /**
115  * @dev Collection of functions related to the address type
116  */
117 library Address {
118     /**
119      * @dev Returns true if `account` is a contract.
120      *
121      * [IMPORTANT]
122      * ====
123      * It is unsafe to assume that an address for which this function returns
124      * false is an externally-owned account (EOA) and not a contract.
125      *
126      * Among others, `isContract` will return false for the following
127      * types of addresses:
128      *
129      *  - an externally-owned account
130      *  - a contract in construction
131      *  - an address where a contract will be created
132      *  - an address where a contract lived, but was destroyed
133      * ====
134      *
135      * [IMPORTANT]
136      * ====
137      * You shouldn't rely on `isContract` to protect against flash loan attacks!
138      *
139      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
140      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
141      * constructor.
142      * ====
143      */
144     function isContract(address account) internal view returns (bool) {
145         // This method relies on extcodesize/address.code.length, which returns 0
146         // for contracts in construction, since the code is only stored at the end
147         // of the constructor execution.
148 
149         return account.code.length > 0;
150     }
151 
152     /**
153      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
154      * `recipient`, forwarding all available gas and reverting on errors.
155      *
156      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
157      * of certain opcodes, possibly making contracts go over the 2300 gas limit
158      * imposed by `transfer`, making them unable to receive funds via
159      * `transfer`. {sendValue} removes this limitation.
160      *
161      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
162      *
163      * IMPORTANT: because control is transferred to `recipient`, care must be
164      * taken to not create reentrancy vulnerabilities. Consider using
165      * {ReentrancyGuard} or the
166      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
167      */
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(address(this).balance >= amount, "Address: insufficient balance");
170 
171         (bool success, ) = recipient.call{value: amount}("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 
175     /**
176      * @dev Performs a Solidity function call using a low level `call`. A
177      * plain `call` is an unsafe replacement for a function call: use this
178      * function instead.
179      *
180      * If `target` reverts with a revert reason, it is bubbled up by this
181      * function (like regular Solidity function calls).
182      *
183      * Returns the raw returned data. To convert to the expected return value,
184      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
185      *
186      * Requirements:
187      *
188      * - `target` must be a contract.
189      * - calling `target` with `data` must not revert.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionCall(target, data, "Address: low-level call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
199      * `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, 0, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but also transferring `value` wei to `target`.
214      *
215      * Requirements:
216      *
217      * - the calling contract must have an ETH balance of at least `value`.
218      * - the called Solidity function must be `payable`.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value
226     ) internal returns (bytes memory) {
227         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
232      * with `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         require(address(this).balance >= value, "Address: insufficient balance for call");
243         require(isContract(target), "Address: call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.call{value: value}(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
256         return functionStaticCall(target, data, "Address: low-level static call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal view returns (bytes memory) {
270         require(isContract(target), "Address: static call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.staticcall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(isContract(target), "Address: delegate call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.delegatecall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
305      * revert reason using the provided one.
306      *
307      * _Available since v4.3._
308      */
309     function verifyCallResult(
310         bool success,
311         bytes memory returndata,
312         string memory errorMessage
313     ) internal pure returns (bytes memory) {
314         if (success) {
315             return returndata;
316         } else {
317             // Look for revert reason and bubble it up if present
318             if (returndata.length > 0) {
319                 // The easiest way to bubble the revert reason is using memory via assembly
320 
321                 assembly {
322                     let returndata_size := mload(returndata)
323                     revert(add(32, returndata), returndata_size)
324                 }
325             } else {
326                 revert(errorMessage);
327             }
328         }
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @title ERC721 token receiver interface
341  * @dev Interface for any contract that wants to support safeTransfers
342  * from ERC721 asset contracts.
343  */
344 interface IERC721Receiver {
345     /**
346      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
347      * by `operator` from `from`, this function is called.
348      *
349      * It must return its Solidity selector to confirm the token transfer.
350      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
351      *
352      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
353      */
354     function onERC721Received(
355         address operator,
356         address from,
357         uint256 tokenId,
358         bytes calldata data
359     ) external returns (bytes4);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Interface of the ERC165 standard, as defined in the
371  * https://eips.ethereum.org/EIPS/eip-165[EIP].
372  *
373  * Implementers can declare support of contract interfaces, which can then be
374  * queried by others ({ERC165Checker}).
375  *
376  * For an implementation, see {ERC165}.
377  */
378 interface IERC165 {
379     /**
380      * @dev Returns true if this contract implements the interface defined by
381      * `interfaceId`. See the corresponding
382      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
383      * to learn more about how these ids are created.
384      *
385      * This function call must use less than 30 000 gas.
386      */
387     function supportsInterface(bytes4 interfaceId) external view returns (bool);
388 }
389 
390 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Implementation of the {IERC165} interface.
400  *
401  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
402  * for the additional interface id that will be supported. For example:
403  *
404  * ```solidity
405  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
406  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
407  * }
408  * ```
409  *
410  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
411  */
412 abstract contract ERC165 is IERC165 {
413     /**
414      * @dev See {IERC165-supportsInterface}.
415      */
416     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
417         return interfaceId == type(IERC165).interfaceId;
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev Required interface of an ERC721 compliant contract.
431  */
432 interface IERC721 is IERC165 {
433     /**
434      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
440      */
441     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
442 
443     /**
444      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
445      */
446     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
447 
448     /**
449      * @dev Returns the number of tokens in ``owner``'s account.
450      */
451     function balanceOf(address owner) external view returns (uint256 balance);
452 
453     /**
454      * @dev Returns the owner of the `tokenId` token.
455      *
456      * Requirements:
457      *
458      * - `tokenId` must exist.
459      */
460     function ownerOf(uint256 tokenId) external view returns (address owner);
461 
462     /**
463      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
464      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must exist and be owned by `from`.
471      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
472      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
473      *
474      * Emits a {Transfer} event.
475      */
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) external;
481 
482     /**
483      * @dev Transfers `tokenId` token from `from` to `to`.
484      *
485      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
504      * The approval is cleared when the token is transferred.
505      *
506      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
507      *
508      * Requirements:
509      *
510      * - The caller must own the token or be an approved operator.
511      * - `tokenId` must exist.
512      *
513      * Emits an {Approval} event.
514      */
515     function approve(address to, uint256 tokenId) external;
516 
517     /**
518      * @dev Returns the account approved for `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function getApproved(uint256 tokenId) external view returns (address operator);
525 
526     /**
527      * @dev Approve or remove `operator` as an operator for the caller.
528      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
529      *
530      * Requirements:
531      *
532      * - The `operator` cannot be the caller.
533      *
534      * Emits an {ApprovalForAll} event.
535      */
536     function setApprovalForAll(address operator, bool _approved) external;
537 
538     /**
539      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
540      *
541      * See {setApprovalForAll}
542      */
543     function isApprovedForAll(address owner, address operator) external view returns (bool);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must exist and be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
555      *
556      * Emits a {Transfer} event.
557      */
558     function safeTransferFrom(
559         address from,
560         address to,
561         uint256 tokenId,
562         bytes calldata data
563     ) external;
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577  */
578 interface IERC721Metadata is IERC721 {
579     /**
580      * @dev Returns the token collection name.
581      */
582     function name() external view returns (string memory);
583 
584     /**
585      * @dev Returns the token collection symbol.
586      */
587     function symbol() external view returns (string memory);
588 
589     /**
590      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
591      */
592     function tokenURI(uint256 tokenId) external view returns (string memory);
593 }
594 
595 // File: contracts/new.sol
596 
597 
598 
599 
600 pragma solidity ^0.8.4;
601 
602 
603 
604 
605 
606 
607 
608 
609 error ApprovalCallerNotOwnerNorApproved();
610 error ApprovalQueryForNonexistentToken();
611 error ApproveToCaller();
612 error ApprovalToCurrentOwner();
613 error BalanceQueryForZeroAddress();
614 error MintToZeroAddress();
615 error MintZeroQuantity();
616 error OwnerQueryForNonexistentToken();
617 error TransferCallerNotOwnerNorApproved();
618 error TransferFromIncorrectOwner();
619 error TransferToNonERC721ReceiverImplementer();
620 error TransferToZeroAddress();
621 error URIQueryForNonexistentToken();
622 
623 /**
624  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
625  * the Metadata extension. Built to optimize for lower gas during batch mints.
626  *
627  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
628  *
629  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
630  *
631  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
632  */
633 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
634     using Address for address;
635     using Strings for uint256;
636 
637     // Compiler will pack this into a single 256bit word.
638     struct TokenOwnership {
639         // The address of the owner.
640         address addr;
641         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
642         uint64 startTimestamp;
643         // Whether the token has been burned.
644         bool burned;
645     }
646 
647     // Compiler will pack this into a single 256bit word.
648     struct AddressData {
649         // Realistically, 2**64-1 is more than enough.
650         uint64 balance;
651         // Keeps track of mint count with minimal overhead for tokenomics.
652         uint64 numberMinted;
653         // Keeps track of burn count with minimal overhead for tokenomics.
654         uint64 numberBurned;
655         // For miscellaneous variable(s) pertaining to the address
656         // (e.g. number of whitelist mint slots used).
657         // If there are multiple variables, please pack them into a uint64.
658         uint64 aux;
659     }
660 
661     // The tokenId of the next token to be minted.
662     uint256 internal _currentIndex;
663 
664     // The number of tokens burned.
665     uint256 internal _burnCounter;
666 
667     // Token name
668     string private _name;
669 
670     // Token symbol
671     string private _symbol;
672 
673     // Mapping from token ID to ownership details
674     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
675     mapping(uint256 => TokenOwnership) internal _ownerships;
676 
677     // Mapping owner address to address data
678     mapping(address => AddressData) private _addressData;
679 
680     // Mapping from token ID to approved address
681     mapping(uint256 => address) private _tokenApprovals;
682 
683     // Mapping from owner to operator approvals
684     mapping(address => mapping(address => bool)) private _operatorApprovals;
685 
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689         _currentIndex = _startTokenId();
690     }
691 
692     /**
693      * To change the starting tokenId, please override this function.
694      */
695     function _startTokenId() internal view virtual returns (uint256) {
696         return 0;
697     }
698 
699     /**
700      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
701      */
702     function totalSupply() public view returns (uint256) {
703         // Counter underflow is impossible as _burnCounter cannot be incremented
704         // more than _currentIndex - _startTokenId() times
705         unchecked {
706             return _currentIndex - _burnCounter - _startTokenId();
707         }
708     }
709 
710     /**
711      * Returns the total amount of tokens minted in the contract.
712      */
713     function _totalMinted() internal view returns (uint256) {
714         // Counter underflow is impossible as _currentIndex does not decrement,
715         // and it is initialized to _startTokenId()
716         unchecked {
717             return _currentIndex - _startTokenId();
718         }
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
725         return
726             interfaceId == type(IERC721).interfaceId ||
727             interfaceId == type(IERC721Metadata).interfaceId ||
728             super.supportsInterface(interfaceId);
729     }
730 
731     /**
732      * @dev See {IERC721-balanceOf}.
733      */
734     function balanceOf(address owner) public view override returns (uint256) {
735         if (owner == address(0)) revert BalanceQueryForZeroAddress();
736         return uint256(_addressData[owner].balance);
737     }
738 
739     /**
740      * Returns the number of tokens minted by `owner`.
741      */
742     function _numberMinted(address owner) internal view returns (uint256) {
743         return uint256(_addressData[owner].numberMinted);
744     }
745 
746     /**
747      * Returns the number of tokens burned by or on behalf of `owner`.
748      */
749     function _numberBurned(address owner) internal view returns (uint256) {
750         return uint256(_addressData[owner].numberBurned);
751     }
752 
753     /**
754      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
755      */
756     function _getAux(address owner) internal view returns (uint64) {
757         return _addressData[owner].aux;
758     }
759 
760     /**
761      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
762      * If there are multiple variables, please pack them into a uint64.
763      */
764     function _setAux(address owner, uint64 aux) internal {
765         _addressData[owner].aux = aux;
766     }
767 
768     /**
769      * Gas spent here starts off proportional to the maximum mint batch size.
770      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
771      */
772     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
773         uint256 curr = tokenId;
774 
775         unchecked {
776             if (_startTokenId() <= curr && curr < _currentIndex) {
777                 TokenOwnership memory ownership = _ownerships[curr];
778                 if (!ownership.burned) {
779                     if (ownership.addr != address(0)) {
780                         return ownership;
781                     }
782                     // Invariant:
783                     // There will always be an ownership that has an address and is not burned
784                     // before an ownership that does not have an address and is not burned.
785                     // Hence, curr will not underflow.
786                     while (true) {
787                         curr--;
788                         ownership = _ownerships[curr];
789                         if (ownership.addr != address(0)) {
790                             return ownership;
791                         }
792                     }
793                 }
794             }
795         }
796         revert OwnerQueryForNonexistentToken();
797     }
798 
799     /**
800      * @dev See {IERC721-ownerOf}.
801      */
802     function ownerOf(uint256 tokenId) public view override returns (address) {
803         return _ownershipOf(tokenId).addr;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-name}.
808      */
809     function name() public view virtual override returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-symbol}.
815      */
816     function symbol() public view virtual override returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-tokenURI}.
822      */
823     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
824         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
825 
826         string memory baseURI = _baseURI();
827         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
828     }
829 
830     /**
831      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
832      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
833      * by default, can be overriden in child contracts.
834      */
835     function _baseURI() internal view virtual returns (string memory) {
836         return '';
837     }
838 
839     /**
840      * @dev See {IERC721-approve}.
841      */
842     function approve(address to, uint256 tokenId) public override {
843         address owner = ERC721A.ownerOf(tokenId);
844         if (to == owner) revert ApprovalToCurrentOwner();
845 
846         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
847             revert ApprovalCallerNotOwnerNorApproved();
848         }
849 
850         _approve(to, tokenId, owner);
851     }
852 
853     /**
854      * @dev See {IERC721-getApproved}.
855      */
856     function getApproved(uint256 tokenId) public view override returns (address) {
857         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev See {IERC721-setApprovalForAll}.
864      */
865     function setApprovalForAll(address operator, bool approved) public virtual override {
866         if (operator == _msgSender()) revert ApproveToCaller();
867 
868         _operatorApprovals[_msgSender()][operator] = approved;
869         emit ApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         _transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         safeTransferFrom(from, to, tokenId, '');
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) public virtual override {
910         _transfer(from, to, tokenId);
911         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
912             revert TransferToNonERC721ReceiverImplementer();
913         }
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      */
923     function _exists(uint256 tokenId) internal view returns (bool) {
924         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
925             !_ownerships[tokenId].burned;
926     }
927 
928     function _safeMint(address to, uint256 quantity) internal {
929         _safeMint(to, quantity, '');
930     }
931 
932     /**
933      * @dev Safely mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _safeMint(
943         address to,
944         uint256 quantity,
945         bytes memory _data
946     ) internal {
947         _mint(to, quantity, _data, true);
948     }
949 
950     /**
951      * @dev Mints `quantity` tokens and transfers them to `to`.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - `quantity` must be greater than 0.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _mint(
961         address to,
962         uint256 quantity,
963         bytes memory _data,
964         bool safe
965     ) internal {
966         uint256 startTokenId = _currentIndex;
967         if (to == address(0)) revert MintToZeroAddress();
968         if (quantity == 0) revert MintZeroQuantity();
969 
970         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
971 
972         // Overflows are incredibly unrealistic.
973         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
974         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
975         unchecked {
976             _addressData[to].balance += uint64(quantity);
977             _addressData[to].numberMinted += uint64(quantity);
978 
979             _ownerships[startTokenId].addr = to;
980             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
981 
982             uint256 updatedIndex = startTokenId;
983             uint256 end = updatedIndex + quantity;
984 
985             if (safe && to.isContract()) {
986                 do {
987                     emit Transfer(address(0), to, updatedIndex);
988                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
989                         revert TransferToNonERC721ReceiverImplementer();
990                     }
991                 } while (updatedIndex != end);
992                 // Reentrancy protection
993                 if (_currentIndex != startTokenId) revert();
994             } else {
995                 do {
996                     emit Transfer(address(0), to, updatedIndex++);
997                 } while (updatedIndex != end);
998             }
999             _currentIndex = updatedIndex;
1000         }
1001         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _transfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) private {
1019         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1020 
1021         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1022 
1023         bool isApprovedOrOwner = (_msgSender() == from ||
1024             isApprovedForAll(from, _msgSender()) ||
1025             getApproved(tokenId) == _msgSender());
1026 
1027         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1028         if (to == address(0)) revert TransferToZeroAddress();
1029 
1030         _beforeTokenTransfers(from, to, tokenId, 1);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId, from);
1034 
1035         // Underflow of the sender's balance is impossible because we check for
1036         // ownership above and the recipient's balance can't realistically overflow.
1037         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1038         unchecked {
1039             _addressData[from].balance -= 1;
1040             _addressData[to].balance += 1;
1041 
1042             TokenOwnership storage currSlot = _ownerships[tokenId];
1043             currSlot.addr = to;
1044             currSlot.startTimestamp = uint64(block.timestamp);
1045 
1046             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1047             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1048             uint256 nextTokenId = tokenId + 1;
1049             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1050             if (nextSlot.addr == address(0)) {
1051                 // This will suffice for checking _exists(nextTokenId),
1052                 // as a burned slot cannot contain the zero address.
1053                 if (nextTokenId != _currentIndex) {
1054                     nextSlot.addr = from;
1055                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1056                 }
1057             }
1058         }
1059 
1060         emit Transfer(from, to, tokenId);
1061         _afterTokenTransfers(from, to, tokenId, 1);
1062     }
1063 
1064     /**
1065      * @dev This is equivalent to _burn(tokenId, false)
1066      */
1067     function _burn(uint256 tokenId) internal virtual {
1068         _burn(tokenId, false);
1069     }
1070 
1071     /**
1072      * @dev Destroys `tokenId`.
1073      * The approval is cleared when the token is burned.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1082         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1083 
1084         address from = prevOwnership.addr;
1085 
1086         if (approvalCheck) {
1087             bool isApprovedOrOwner = (_msgSender() == from ||
1088                 isApprovedForAll(from, _msgSender()) ||
1089                 getApproved(tokenId) == _msgSender());
1090 
1091             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1092         }
1093 
1094         _beforeTokenTransfers(from, address(0), tokenId, 1);
1095 
1096         // Clear approvals from the previous owner
1097         _approve(address(0), tokenId, from);
1098 
1099         // Underflow of the sender's balance is impossible because we check for
1100         // ownership above and the recipient's balance can't realistically overflow.
1101         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1102         unchecked {
1103             AddressData storage addressData = _addressData[from];
1104             addressData.balance -= 1;
1105             addressData.numberBurned += 1;
1106 
1107             // Keep track of who burned the token, and the timestamp of burning.
1108             TokenOwnership storage currSlot = _ownerships[tokenId];
1109             currSlot.addr = from;
1110             currSlot.startTimestamp = uint64(block.timestamp);
1111             currSlot.burned = true;
1112 
1113             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1114             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1115             uint256 nextTokenId = tokenId + 1;
1116             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1117             if (nextSlot.addr == address(0)) {
1118                 // This will suffice for checking _exists(nextTokenId),
1119                 // as a burned slot cannot contain the zero address.
1120                 if (nextTokenId != _currentIndex) {
1121                     nextSlot.addr = from;
1122                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1123                 }
1124             }
1125         }
1126 
1127         emit Transfer(from, address(0), tokenId);
1128         _afterTokenTransfers(from, address(0), tokenId, 1);
1129 
1130         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1131         unchecked {
1132             _burnCounter++;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Approve `to` to operate on `tokenId`
1138      *
1139      * Emits a {Approval} event.
1140      */
1141     function _approve(
1142         address to,
1143         uint256 tokenId,
1144         address owner
1145     ) private {
1146         _tokenApprovals[tokenId] = to;
1147         emit Approval(owner, to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1152      *
1153      * @param from address representing the previous owner of the given token ID
1154      * @param to target address that will receive the tokens
1155      * @param tokenId uint256 ID of the token to be transferred
1156      * @param _data bytes optional data to send along with the call
1157      * @return bool whether the call correctly returned the expected magic value
1158      */
1159     function _checkContractOnERC721Received(
1160         address from,
1161         address to,
1162         uint256 tokenId,
1163         bytes memory _data
1164     ) private returns (bool) {
1165         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1166             return retval == IERC721Receiver(to).onERC721Received.selector;
1167         } catch (bytes memory reason) {
1168             if (reason.length == 0) {
1169                 revert TransferToNonERC721ReceiverImplementer();
1170             } else {
1171                 assembly {
1172                     revert(add(32, reason), mload(reason))
1173                 }
1174             }
1175         }
1176     }
1177 
1178     /**
1179      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1180      * And also called before burning one token.
1181      *
1182      * startTokenId - the first token id to be transferred
1183      * quantity - the amount to be transferred
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` will be minted for `to`.
1190      * - When `to` is zero, `tokenId` will be burned by `from`.
1191      * - `from` and `to` are never both zero.
1192      */
1193     function _beforeTokenTransfers(
1194         address from,
1195         address to,
1196         uint256 startTokenId,
1197         uint256 quantity
1198     ) internal virtual {}
1199 
1200     /**
1201      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1202      * minting.
1203      * And also called after one token has been burned.
1204      *
1205      * startTokenId - the first token id to be transferred
1206      * quantity - the amount to be transferred
1207      *
1208      * Calling conditions:
1209      *
1210      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1211      * transferred to `to`.
1212      * - When `from` is zero, `tokenId` has been minted for `to`.
1213      * - When `to` is zero, `tokenId` has been burned by `from`.
1214      * - `from` and `to` are never both zero.
1215      */
1216     function _afterTokenTransfers(
1217         address from,
1218         address to,
1219         uint256 startTokenId,
1220         uint256 quantity
1221     ) internal virtual {}
1222 }
1223 
1224 abstract contract Ownable is Context {
1225     address private _owner;
1226 
1227     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1228 
1229     /**
1230      * @dev Initializes the contract setting the deployer as the initial owner.
1231      */
1232     constructor() {
1233         _transferOwnership(_msgSender());
1234     }
1235 
1236     /**
1237      * @dev Returns the address of the current owner.
1238      */
1239     function owner() public view virtual returns (address) {
1240         return _owner;
1241     }
1242 
1243     /**
1244      * @dev Throws if called by any account other than the owner.
1245      */
1246     modifier onlyOwner() {
1247         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1248         _;
1249     }
1250 
1251     /**
1252      * @dev Leaves the contract without owner. It will not be possible to call
1253      * `onlyOwner` functions anymore. Can only be called by the current owner.
1254      *
1255      * NOTE: Renouncing ownership will leave the contract without an owner,
1256      * thereby removing any functionality that is only available to the owner.
1257      */
1258     function renounceOwnership() public virtual onlyOwner {
1259         _transferOwnership(address(0));
1260     }
1261 
1262     /**
1263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1264      * Can only be called by the current owner.
1265      */
1266     function transferOwnership(address newOwner) public virtual onlyOwner {
1267         require(newOwner != address(0), "Ownable: new owner is the zero address");
1268         _transferOwnership(newOwner);
1269     }
1270 
1271     /**
1272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1273      * Internal function without access restriction.
1274      */
1275     function _transferOwnership(address newOwner) internal virtual {
1276         address oldOwner = _owner;
1277         _owner = newOwner;
1278         emit OwnershipTransferred(oldOwner, newOwner);
1279     }
1280 }
1281     pragma solidity ^0.8.7;
1282     
1283     contract BPYC is ERC721A, Ownable {
1284     using Strings for uint256;
1285 
1286 
1287   string private uriPrefix ;
1288   string private uriSuffix = ".json";
1289   string public hiddenURL;
1290 
1291   
1292   
1293 
1294   uint256 public cost = 0.002 ether;
1295   uint256 public whiteListCost = 0 ;
1296   
1297 
1298   uint16 public maxSupply = 999;
1299   uint8 public maxMintAmountPerTx = 11;
1300     uint8 public maxFreeMintAmountPerWallet = 1;
1301                                                              
1302   bool public WLpaused = true;
1303   bool public paused = true;
1304   bool public reveal =false;
1305   mapping (address => uint8) public NFTPerWLAddress;
1306    mapping (address => uint8) public NFTPerPublicAddress;
1307   mapping (address => bool) public isWhitelisted;
1308  
1309   
1310   
1311  
1312   
1313 
1314   constructor() ERC721A("BPYC", "YIELDING") {
1315   }
1316 
1317  function burn(uint[] calldata token) external onlyOwner{
1318      for(uint i ; i <token.length ; i ++)
1319    _burn(token[i]);
1320  }
1321   
1322 
1323   
1324  
1325   function mint(uint8 _mintAmount) external payable  {
1326      uint16 totalSupply = uint16(totalSupply());
1327      uint8 nft = NFTPerPublicAddress[msg.sender];
1328     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1329     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1330 
1331     require(!paused, "The contract is paused!");
1332     
1333       if(nft >= maxFreeMintAmountPerWallet)
1334     {
1335     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1336     }
1337     else {
1338          uint8 costAmount = _mintAmount + nft;
1339         if(costAmount > maxFreeMintAmountPerWallet)
1340        {
1341         costAmount = costAmount - maxFreeMintAmountPerWallet;
1342         require(msg.value >= cost * costAmount, "Insufficient funds!");
1343        }
1344        
1345          
1346     }
1347     
1348 
1349 
1350     _safeMint(msg.sender , _mintAmount);
1351 
1352     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1353      
1354      delete totalSupply;
1355      delete _mintAmount;
1356   }
1357   
1358   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1359      uint16 totalSupply = uint16(totalSupply());
1360     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1361      _safeMint(_receiver , _mintAmount);
1362      delete _mintAmount;
1363      delete _receiver;
1364      delete totalSupply;
1365   }
1366 
1367   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1368      uint16 totalSupply = uint16(totalSupply());
1369      uint totalAmount =   _amountPerAddress * addresses.length;
1370     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1371      for (uint256 i = 0; i < addresses.length; i++) {
1372             _safeMint(addresses[i], _amountPerAddress);
1373         }
1374 
1375      delete _amountPerAddress;
1376      delete totalSupply;
1377   }
1378 
1379  
1380 
1381   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1382       maxSupply = _maxSupply;
1383   }
1384 
1385 
1386 
1387    
1388   function tokenURI(uint256 _tokenId)
1389     public
1390     view
1391     virtual
1392     override
1393     returns (string memory)
1394   {
1395     require(
1396       _exists(_tokenId),
1397       "ERC721Metadata: URI query for nonexistent token"
1398     );
1399     
1400   
1401 if ( reveal == false)
1402 {
1403     return hiddenURL;
1404 }
1405     
1406 
1407     string memory currentBaseURI = _baseURI();
1408     return bytes(currentBaseURI).length > 0
1409         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1410         : "";
1411   }
1412  
1413    function setWLPaused() external onlyOwner {
1414     WLpaused = !WLpaused;
1415   }
1416   function setWLCost(uint256 _cost) external onlyOwner {
1417     whiteListCost = _cost;
1418     delete _cost;
1419   }
1420 
1421 
1422 
1423  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1424     maxFreeMintAmountPerWallet = _limit;
1425    delete _limit;
1426 
1427 }
1428 
1429     
1430   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1431         for(uint8 i = 0; i < entries.length; i++) {
1432             isWhitelisted[entries[i]] = true;
1433         }   
1434     }
1435 
1436     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1437         for(uint8 i = 0; i < entries.length; i++) {
1438              isWhitelisted[entries[i]] = false;
1439         }
1440     }
1441 
1442 function whitelistMint(uint8 _mintAmount) external payable {
1443         
1444     
1445         uint8 nft = NFTPerWLAddress[msg.sender];
1446        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1447 
1448        require (nft + _mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per address");
1449       
1450 
1451 
1452     require(!WLpaused, "Whitelist minting is over!");
1453          if(nft >= maxFreeMintAmountPerWallet)
1454     {
1455     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1456     }
1457     else {
1458          uint8 costAmount = _mintAmount + nft;
1459         if(costAmount > maxFreeMintAmountPerWallet)
1460        {
1461         costAmount = costAmount - maxFreeMintAmountPerWallet;
1462         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1463        }
1464        
1465          
1466     }
1467     
1468     
1469 
1470      _safeMint(msg.sender , _mintAmount);
1471       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1472      
1473       delete _mintAmount;
1474        delete nft;
1475     
1476     }
1477 
1478   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1479     uriPrefix = _uriPrefix;
1480   }
1481    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1482     hiddenURL = _uriPrefix;
1483   }
1484 
1485 
1486   function setPaused() external onlyOwner {
1487     paused = !paused;
1488     WLpaused = true;
1489   }
1490 
1491   function setCost(uint _cost) external onlyOwner{
1492       cost = _cost;
1493 
1494   }
1495 
1496  function setRevealed() external onlyOwner{
1497      reveal = !reveal;
1498  }
1499 
1500   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1501       maxMintAmountPerTx = _maxtx;
1502 
1503   }
1504 
1505  
1506 
1507   function withdraw() external onlyOwner {
1508   uint _balance = address(this).balance;
1509      payable(msg.sender).transfer(_balance ); 
1510        
1511   }
1512 
1513 
1514   function _baseURI() internal view  override returns (string memory) {
1515     return uriPrefix;
1516   }
1517 }