1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/utils/Address.sol
100 
101 
102 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
103 
104 pragma solidity ^0.8.1;
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      *
127      * [IMPORTANT]
128      * ====
129      * You shouldn't rely on `isContract` to protect against flash loan attacks!
130      *
131      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
132      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
133      * constructor.
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize/address.code.length, which returns 0
138         // for contracts in construction, since the code is only stored at the end
139         // of the constructor execution.
140 
141         return account.code.length > 0;
142     }
143 
144     /**
145      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
146      * `recipient`, forwarding all available gas and reverting on errors.
147      *
148      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
149      * of certain opcodes, possibly making contracts go over the 2300 gas limit
150      * imposed by `transfer`, making them unable to receive funds via
151      * `transfer`. {sendValue} removes this limitation.
152      *
153      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
154      *
155      * IMPORTANT: because control is transferred to `recipient`, care must be
156      * taken to not create reentrancy vulnerabilities. Consider using
157      * {ReentrancyGuard} or the
158      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
159      */
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{value: amount}("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167     /**
168      * @dev Performs a Solidity function call using a low level `call`. A
169      * plain `call` is an unsafe replacement for a function call: use this
170      * function instead.
171      *
172      * If `target` reverts with a revert reason, it is bubbled up by this
173      * function (like regular Solidity function calls).
174      *
175      * Returns the raw returned data. To convert to the expected return value,
176      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
177      *
178      * Requirements:
179      *
180      * - `target` must be a contract.
181      * - calling `target` with `data` must not revert.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionCall(target, data, "Address: low-level call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
191      * `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
224      * with `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{value: value}(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
248         return functionStaticCall(target, data, "Address: low-level static call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal view returns (bytes memory) {
262         require(isContract(target), "Address: static call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.staticcall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(isContract(target), "Address: delegate call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
297      * revert reason using the provided one.
298      *
299      * _Available since v4.3._
300      */
301     function verifyCallResult(
302         bool success,
303         bytes memory returndata,
304         string memory errorMessage
305     ) internal pure returns (bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 assembly {
314                     let returndata_size := mload(returndata)
315                     revert(add(32, returndata), returndata_size)
316                 }
317             } else {
318                 revert(errorMessage);
319             }
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @title ERC721 token receiver interface
333  * @dev Interface for any contract that wants to support safeTransfers
334  * from ERC721 asset contracts.
335  */
336 interface IERC721Receiver {
337     /**
338      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
339      * by `operator` from `from`, this function is called.
340      *
341      * It must return its Solidity selector to confirm the token transfer.
342      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
343      *
344      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
345      */
346     function onERC721Received(
347         address operator,
348         address from,
349         uint256 tokenId,
350         bytes calldata data
351     ) external returns (bytes4);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Interface of the ERC165 standard, as defined in the
363  * https://eips.ethereum.org/EIPS/eip-165[EIP].
364  *
365  * Implementers can declare support of contract interfaces, which can then be
366  * queried by others ({ERC165Checker}).
367  *
368  * For an implementation, see {ERC165}.
369  */
370 interface IERC165 {
371     /**
372      * @dev Returns true if this contract implements the interface defined by
373      * `interfaceId`. See the corresponding
374      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
375      * to learn more about how these ids are created.
376      *
377      * This function call must use less than 30 000 gas.
378      */
379     function supportsInterface(bytes4 interfaceId) external view returns (bool);
380 }
381 
382 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Implementation of the {IERC165} interface.
392  *
393  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
394  * for the additional interface id that will be supported. For example:
395  *
396  * ```solidity
397  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
398  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
399  * }
400  * ```
401  *
402  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
403  */
404 abstract contract ERC165 is IERC165 {
405     /**
406      * @dev See {IERC165-supportsInterface}.
407      */
408     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
409         return interfaceId == type(IERC165).interfaceId;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Required interface of an ERC721 compliant contract.
423  */
424 interface IERC721 is IERC165 {
425     /**
426      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
432      */
433     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
434 
435     /**
436      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
437      */
438     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
439 
440     /**
441      * @dev Returns the number of tokens in ``owner``'s account.
442      */
443     function balanceOf(address owner) external view returns (uint256 balance);
444 
445     /**
446      * @dev Returns the owner of the `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function ownerOf(uint256 tokenId) external view returns (address owner);
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Transfers `tokenId` token from `from` to `to`.
476      *
477      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
496      * The approval is cleared when the token is transferred.
497      *
498      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
499      *
500      * Requirements:
501      *
502      * - The caller must own the token or be an approved operator.
503      * - `tokenId` must exist.
504      *
505      * Emits an {Approval} event.
506      */
507     function approve(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Returns the account approved for `tokenId` token.
511      *
512      * Requirements:
513      *
514      * - `tokenId` must exist.
515      */
516     function getApproved(uint256 tokenId) external view returns (address operator);
517 
518     /**
519      * @dev Approve or remove `operator` as an operator for the caller.
520      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
521      *
522      * Requirements:
523      *
524      * - The `operator` cannot be the caller.
525      *
526      * Emits an {ApprovalForAll} event.
527      */
528     function setApprovalForAll(address operator, bool _approved) external;
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 
537     /**
538      * @dev Safely transfers `tokenId` token from `from` to `to`.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must exist and be owned by `from`.
545      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
546      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
547      *
548      * Emits a {Transfer} event.
549      */
550     function safeTransferFrom(
551         address from,
552         address to,
553         uint256 tokenId,
554         bytes calldata data
555     ) external;
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Metadata is IERC721 {
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() external view returns (string memory);
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) external view returns (string memory);
585 }
586 
587 // File: contracts/new.sol
588 
589 pragma solidity ^0.8.4;
590 
591 error ApprovalCallerNotOwnerNorApproved();
592 error ApprovalQueryForNonexistentToken();
593 error ApproveToCaller();
594 error ApprovalToCurrentOwner();
595 error BalanceQueryForZeroAddress();
596 error MintToZeroAddress();
597 error MintZeroQuantity();
598 error OwnerQueryForNonexistentToken();
599 error TransferCallerNotOwnerNorApproved();
600 error TransferFromIncorrectOwner();
601 error TransferToNonERC721ReceiverImplementer();
602 error TransferToZeroAddress();
603 error URIQueryForNonexistentToken();
604 
605 /**
606  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
607  * the Metadata extension. Built to optimize for lower gas during batch mints.
608  *
609  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
610  *
611  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
612  *
613  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
614  */
615 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
616     using Address for address;
617     using Strings for uint256;
618 
619     // Compiler will pack this into a single 256bit word.
620     struct TokenOwnership {
621         // The address of the owner.
622         address addr;
623         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
624         uint64 startTimestamp;
625         // Whether the token has been burned.
626         bool burned;
627     }
628 
629     // Compiler will pack this into a single 256bit word.
630     struct AddressData {
631         // Realistically, 2**64-1 is more than enough.
632         uint64 balance;
633         // Keeps track of mint count with minimal overhead for tokenomics.
634         uint64 numberMinted;
635         // Keeps track of burn count with minimal overhead for tokenomics.
636         uint64 numberBurned;
637         // For miscellaneous variable(s) pertaining to the address
638         // (e.g. number of whitelist mint slots used).
639         // If there are multiple variables, please pack them into a uint64.
640         uint64 aux;
641     }
642 
643     // The tokenId of the next token to be minted.
644     uint256 internal _currentIndex;
645 
646     // The number of tokens burned.
647     uint256 internal _burnCounter;
648 
649     // Token name
650     string private _name;
651 
652     // Token symbol
653     string private _symbol;
654 
655     // Mapping from token ID to ownership details
656     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
657     mapping(uint256 => TokenOwnership) internal _ownerships;
658 
659     // Mapping owner address to address data
660     mapping(address => AddressData) private _addressData;
661 
662     // Mapping from token ID to approved address
663     mapping(uint256 => address) private _tokenApprovals;
664 
665     // Mapping from owner to operator approvals
666     mapping(address => mapping(address => bool)) private _operatorApprovals;
667 
668     constructor(string memory name_, string memory symbol_) {
669         _name = name_;
670         _symbol = symbol_;
671         _currentIndex = _startTokenId();
672     }
673 
674     /**
675      * To change the starting tokenId, please override this function.
676      */
677     function _startTokenId() internal view virtual returns (uint256) {
678         return 0;
679     }
680 
681     /**
682      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
683      */
684     function totalSupply() public view returns (uint256) {
685         // Counter underflow is impossible as _burnCounter cannot be incremented
686         // more than _currentIndex - _startTokenId() times
687         unchecked {
688             return _currentIndex - _burnCounter - _startTokenId();
689         }
690     }
691 
692     /**
693      * Returns the total amount of tokens minted in the contract.
694      */
695     function _totalMinted() internal view returns (uint256) {
696         // Counter underflow is impossible as _currentIndex does not decrement,
697         // and it is initialized to _startTokenId()
698         unchecked {
699             return _currentIndex - _startTokenId();
700         }
701     }
702 
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
707         return
708             interfaceId == type(IERC721).interfaceId ||
709             interfaceId == type(IERC721Metadata).interfaceId ||
710             super.supportsInterface(interfaceId);
711     }
712 
713     /**
714      * @dev See {IERC721-balanceOf}.
715      */
716     function balanceOf(address owner) public view override returns (uint256) {
717         if (owner == address(0)) revert BalanceQueryForZeroAddress();
718         return uint256(_addressData[owner].balance);
719     }
720 
721     /**
722      * Returns the number of tokens minted by `owner`.
723      */
724     function _numberMinted(address owner) internal view returns (uint256) {
725         return uint256(_addressData[owner].numberMinted);
726     }
727 
728     /**
729      * Returns the number of tokens burned by or on behalf of `owner`.
730      */
731     function _numberBurned(address owner) internal view returns (uint256) {
732         return uint256(_addressData[owner].numberBurned);
733     }
734 
735     /**
736      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
737      */
738     function _getAux(address owner) internal view returns (uint64) {
739         return _addressData[owner].aux;
740     }
741 
742     /**
743      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
744      * If there are multiple variables, please pack them into a uint64.
745      */
746     function _setAux(address owner, uint64 aux) internal {
747         _addressData[owner].aux = aux;
748     }
749 
750     /**
751      * Gas spent here starts off proportional to the maximum mint batch size.
752      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
753      */
754     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
755         uint256 curr = tokenId;
756 
757         unchecked {
758             if (_startTokenId() <= curr && curr < _currentIndex) {
759                 TokenOwnership memory ownership = _ownerships[curr];
760                 if (!ownership.burned) {
761                     if (ownership.addr != address(0)) {
762                         return ownership;
763                     }
764                     // Invariant:
765                     // There will always be an ownership that has an address and is not burned
766                     // before an ownership that does not have an address and is not burned.
767                     // Hence, curr will not underflow.
768                     while (true) {
769                         curr--;
770                         ownership = _ownerships[curr];
771                         if (ownership.addr != address(0)) {
772                             return ownership;
773                         }
774                     }
775                 }
776             }
777         }
778         revert OwnerQueryForNonexistentToken();
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view override returns (address) {
785         return _ownershipOf(tokenId).addr;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overriden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return '';
819     }
820 
821     /**
822      * @dev See {IERC721-approve}.
823      */
824     function approve(address to, uint256 tokenId) public override {
825         address owner = ERC721A.ownerOf(tokenId);
826         if (to == owner) revert ApprovalToCurrentOwner();
827 
828         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
829             revert ApprovalCallerNotOwnerNorApproved();
830         }
831 
832         _approve(to, tokenId, owner);
833     }
834 
835     /**
836      * @dev See {IERC721-getApproved}.
837      */
838     function getApproved(uint256 tokenId) public view override returns (address) {
839         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
840 
841         return _tokenApprovals[tokenId];
842     }
843 
844     /**
845      * @dev See {IERC721-setApprovalForAll}.
846      */
847     function setApprovalForAll(address operator, bool approved) public virtual override {
848         if (operator == _msgSender()) revert ApproveToCaller();
849 
850         _operatorApprovals[_msgSender()][operator] = approved;
851         emit ApprovalForAll(_msgSender(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-transferFrom}.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         _transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         safeTransferFrom(from, to, tokenId, '');
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) public virtual override {
892         _transfer(from, to, tokenId);
893         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
894             revert TransferToNonERC721ReceiverImplementer();
895         }
896     }
897 
898     /**
899      * @dev Returns whether `tokenId` exists.
900      *
901      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902      *
903      * Tokens start existing when they are minted (`_mint`),
904      */
905     function _exists(uint256 tokenId) internal view returns (bool) {
906         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
907             !_ownerships[tokenId].burned;
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
967             if (safe && to.isContract()) {
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
1006             isApprovedForAll(from, _msgSender()) ||
1007             getApproved(tokenId) == _msgSender());
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
1020         unchecked {
1021             _addressData[from].balance -= 1;
1022             _addressData[to].balance += 1;
1023 
1024             TokenOwnership storage currSlot = _ownerships[tokenId];
1025             currSlot.addr = to;
1026             currSlot.startTimestamp = uint64(block.timestamp);
1027 
1028             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1029             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1030             uint256 nextTokenId = tokenId + 1;
1031             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1032             if (nextSlot.addr == address(0)) {
1033                 // This will suffice for checking _exists(nextTokenId),
1034                 // as a burned slot cannot contain the zero address.
1035                 if (nextTokenId != _currentIndex) {
1036                     nextSlot.addr = from;
1037                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1038                 }
1039             }
1040         }
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
1070                 isApprovedForAll(from, _msgSender()) ||
1071                 getApproved(tokenId) == _msgSender());
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
1084         unchecked {
1085             AddressData storage addressData = _addressData[from];
1086             addressData.balance -= 1;
1087             addressData.numberBurned += 1;
1088 
1089             // Keep track of who burned the token, and the timestamp of burning.
1090             TokenOwnership storage currSlot = _ownerships[tokenId];
1091             currSlot.addr = from;
1092             currSlot.startTimestamp = uint64(block.timestamp);
1093             currSlot.burned = true;
1094 
1095             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1096             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1097             uint256 nextTokenId = tokenId + 1;
1098             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1099             if (nextSlot.addr == address(0)) {
1100                 // This will suffice for checking _exists(nextTokenId),
1101                 // as a burned slot cannot contain the zero address.
1102                 if (nextTokenId != _currentIndex) {
1103                     nextSlot.addr = from;
1104                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1105                 }
1106             }
1107         }
1108 
1109         emit Transfer(from, address(0), tokenId);
1110         _afterTokenTransfers(from, address(0), tokenId, 1);
1111 
1112         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1113         unchecked {
1114             _burnCounter++;
1115         }
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
1205 pragma solidity ^0.8.0;
1206 
1207 /**
1208  * @dev These functions deal with verification of Merkle Trees proofs.
1209  *
1210  * The proofs can be generated using the JavaScript library
1211  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1212  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1213  *
1214  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1215  */
1216 library MerkleProof {
1217     /**
1218      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1219      * defined by `root`. For this, a `proof` must be provided, containing
1220      * sibling hashes on the branch from the leaf to the root of the tree. Each
1221      * pair of leaves and each pair of pre-images are assumed to be sorted.
1222      */
1223     function verify(
1224         bytes32[] memory proof,
1225         bytes32 root,
1226         bytes32 leaf
1227     ) internal pure returns (bool) {
1228         return processProof(proof, leaf) == root;
1229     }
1230 
1231     /**
1232      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1233      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1234      * hash matches the root of the tree. When processing the proof, the pairs
1235      * of leafs & pre-images are assumed to be sorted.
1236      *
1237      * _Available since v4.4._
1238      */
1239     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1240         bytes32 computedHash = leaf;
1241         for (uint256 i = 0; i < proof.length; i++) {
1242             bytes32 proofElement = proof[i];
1243             if (computedHash <= proofElement) {
1244                 // Hash(current computed hash + current element of the proof)
1245                 computedHash = _efficientHash(computedHash, proofElement);
1246             } else {
1247                 // Hash(current element of the proof + current computed hash)
1248                 computedHash = _efficientHash(proofElement, computedHash);
1249             }
1250         }
1251         return computedHash;
1252     }
1253 
1254     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1255         assembly {
1256             mstore(0x00, a)
1257             mstore(0x20, b)
1258             value := keccak256(0x00, 0x40)
1259         }
1260     }
1261 }
1262 abstract contract Ownable is Context {
1263     address private _owner;
1264 
1265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1266 
1267     /**
1268      * @dev Initializes the contract setting the deployer as the initial owner.
1269      */
1270     constructor() {
1271         _transferOwnership(_msgSender());
1272     }
1273 
1274     /**
1275      * @dev Returns the address of the current owner.
1276      */
1277     function owner() public view virtual returns (address) {
1278         return _owner;
1279     }
1280 
1281     /**
1282      * @dev Throws if called by any account other than the owner.
1283      */
1284     modifier onlyOwner() {
1285         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1286         _;
1287     }
1288 
1289     /**
1290      * @dev Leaves the contract without owner. It will not be possible to call
1291      * `onlyOwner` functions anymore. Can only be called by the current owner.
1292      *
1293      * NOTE: Renouncing ownership will leave the contract without an owner,
1294      * thereby removing any functionality that is only available to the owner.
1295      */
1296     function renounceOwnership() public virtual onlyOwner {
1297         _transferOwnership(address(0));
1298     }
1299 
1300     /**
1301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1302      * Can only be called by the current owner.
1303      */
1304     function transferOwnership(address newOwner) public virtual onlyOwner {
1305         require(newOwner != address(0), "Ownable: new owner is the zero address");
1306         _transferOwnership(newOwner);
1307     }
1308 
1309     /**
1310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1311      * Internal function without access restriction.
1312      */
1313     function _transferOwnership(address newOwner) internal virtual {
1314         address oldOwner = _owner;
1315         _owner = newOwner;
1316         emit OwnershipTransferred(oldOwner, newOwner);
1317     }
1318 }
1319 
1320         pragma solidity ^0.8.0;
1321                 
1322         contract CultOfEther_Disciples is ERC721A, Ownable {
1323         using Strings for uint256;
1324 
1325             // Name & Symbol of Project in Constructor 
1326             constructor() ERC721A("Cult Of Ether Disciples", "COED") {}
1327 
1328             //max supply is set to 6666
1329             uint16 public constant maxSupply = 6666;
1330             // uriPrefix is the BaseUri
1331             string public uriPrefix = "ipfs://QmRThQPRGsG8zzdcgSC1FDFRkw49S4rNbhVRh66XSxU86i/";
1332             string public uriSuffix = ".json";
1333             string public hiddenURL = "ipfs://Qmf5K4fB1Xsms2xhHJdooi13iU832aPdsP92Po79PQCQ6H/0.json" ;
1334             //cost for Pulic Mint
1335             uint256 public PublicCost = 0.01 ether;
1336             //cost for WL Mint
1337             uint256 public WLCost = 0.01 ether;
1338             // Max MintAmount per Tx for Public sale
1339             uint8 public MaxMintPublic = 6;
1340             // Max MintAmount Per tx WL
1341             uint8 public MaxMintWL = 6;
1342 
1343             // Pre-sale is active and Public sale is Paused                                                        
1344             bool public PublicSalePaused = true;
1345             bool public WLPaused = false;
1346 
1347             //Collection is set revlead 
1348             bool public reveal =false;
1349             uint16 counter;
1350  
1351   
1352           //WHitelist Merkle Root
1353             bytes32 public whitelistMerkleRoot = 0xd29fd90459ed5b2372c34486c044188ba2a264cd96678f6efbdb3b0194b1f06f;
1354 
1355 
1356         // Function Whitelist mint, Wlhitelist sale max tokens are 3000
1357         //Contract will switch to Public Mint once 3000 tokens are minted
1358           function whitelistMint(uint8 _mintAmount, bytes32[] calldata merkleProof) external payable {
1359             bytes32  leafnode = getLeafNode(msg.sender);
1360             require(_verify(leafnode ,   merkleProof ),  "Invalid merkle proof");
1361             require (_mintAmount <= MaxMintWL, "Exceeds max tx per address");
1362             require(!WLPaused, "Whitelist minting is not active!");
1363             require(msg.value == WLCost * _mintAmount, "Insufficient ethers sent!");
1364             uint16 totalSupply = uint16(totalSupply());
1365           _safeMint(msg.sender , _mintAmount);
1366             counter = counter + _mintAmount ;
1367            // WhiteList-Sale  will be automatically paused after 1000 NFTs are minted in this phase
1368            //And Public sale will Automatically Start
1369             if ( counter >= 3000)
1370              {
1371              WLPaused = true;
1372              PublicSalePaused = false;
1373              counter = 0;
1374              }
1375              delete totalSupply;
1376              delete _mintAmount;
1377             }
1378             
1379         // Function for Public Mint 
1380             function publicMint(uint16 _mintAmount) external payable  {
1381                 uint16 totalSupply = uint16(totalSupply());
1382                 require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1383                 require(_mintAmount <= MaxMintPublic, "Exceeds Allowed mint Amount per transaction.");
1384                 require(!PublicSalePaused, "The contract is paused!");
1385                 require(msg.value == PublicCost * _mintAmount, "Insufficient funds!");
1386 
1387                 _safeMint(msg.sender , _mintAmount);
1388                 
1389                 delete totalSupply;
1390                 delete _mintAmount;
1391                 }
1392 
1393             // Function Owner Mint
1394             function OwnerMint(uint16 _mintAmount) external onlyOwner {
1395                 uint16 totalSupply = uint16(totalSupply());
1396                 require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1397                 _safeMint(msg.sender , _mintAmount);
1398                 delete _mintAmount;
1399                 delete totalSupply;
1400                 }      
1401   
1402          // Function can be used to reserve Tokens
1403             function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1404                 uint16 totalSupply = uint16(totalSupply());
1405                 require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1406                 _safeMint(_receiver , _mintAmount);
1407                 delete _mintAmount;
1408                 delete _receiver;
1409                 delete totalSupply;
1410             }
1411            
1412            // Function Airdrop
1413             function Airdrop(uint16 _mintAmount, address _receiver) external onlyOwner {
1414                 uint16 totalSupply = uint16(totalSupply());
1415                 require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1416                 _safeMint(_receiver , _mintAmount);
1417                 delete _mintAmount;
1418                 delete _receiver;
1419                 delete totalSupply;
1420                 }
1421 
1422             // Function Burn Tokens
1423             function burn(uint _tokenID) external onlyOwner {
1424                 _burn(_tokenID);
1425             }
1426 
1427    
1428            function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1429               require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token" );
1430             if ( reveal == false){
1431             return hiddenURL;
1432             }
1433              string memory currentBaseURI = _baseURI();
1434              return bytes(currentBaseURI).length > 0
1435            ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1436             : "";
1437            }
1438  
1439  
1440            function setWLPaused() external onlyOwner {
1441                 WLPaused = !WLPaused;
1442                 counter = 0;
1443             }
1444 
1445             function setPublicSalePaused() external onlyOwner {
1446                 PublicSalePaused= !PublicSalePaused;
1447                 WLPaused = true;
1448                 counter = 0;
1449             }
1450             
1451             function setWLCost(uint256 _cost) external onlyOwner {
1452                 WLCost = _cost;
1453                 delete _cost;
1454             }
1455 
1456             function setPublicCost(uint256 _cost) external onlyOwner {
1457                 PublicCost = _cost;
1458                 delete _cost;
1459             }
1460 
1461            function setMaxMintWL(uint8 _limit) external onlyOwner{
1462                 MaxMintWL = _limit;
1463                 delete _limit;
1464             }
1465 
1466             function setMaxMintPublic(uint8 _limit) external onlyOwner{
1467                 MaxMintPublic = _limit;
1468                 delete _limit;
1469             }
1470 
1471 
1472            function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1473                 whitelistMerkleRoot = _whitelistMerkleRoot;
1474             }
1475 
1476     
1477            function getLeafNode(address _leaf) internal pure returns (bytes32 temp)
1478              {
1479             return keccak256(abi.encodePacked(_leaf));
1480            }
1481            
1482            function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1483             return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1484             }
1485 
1486            function setBaseURI(string memory _uriPrefix) external onlyOwner {
1487              uriPrefix = _uriPrefix;
1488               }
1489 
1490            function _baseURI() internal view  override returns (string memory) {
1491             return uriPrefix;
1492             }
1493 
1494           function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1495               hiddenURL = _uriPrefix;
1496              }
1497 
1498           function setRevealed() external onlyOwner{
1499              reveal = !reveal;
1500             }
1501 
1502          function withdraw() external onlyOwner {
1503         uint _balance = address(this).balance;
1504          payable(msg.sender).transfer(_balance ); 
1505          }
1506     }