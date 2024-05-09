1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
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
559 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
560 
561 
562 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
569  * @dev See https://eips.ethereum.org/EIPS/eip-721
570  */
571 interface IERC721Enumerable is IERC721 {
572     /**
573      * @dev Returns the total amount of tokens stored by the contract.
574      */
575     function totalSupply() external view returns (uint256);
576 
577     /**
578      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
579      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
580      */
581     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
582 
583     /**
584      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
585      * Use along with {totalSupply} to enumerate all tokens.
586      */
587     function tokenByIndex(uint256 index) external view returns (uint256);
588 }
589 
590 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
600  * @dev See https://eips.ethereum.org/EIPS/eip-721
601  */
602 interface IERC721Metadata is IERC721 {
603     /**
604      * @dev Returns the token collection name.
605      */
606     function name() external view returns (string memory);
607 
608     /**
609      * @dev Returns the token collection symbol.
610      */
611     function symbol() external view returns (string memory);
612 
613     /**
614      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
615      */
616     function tokenURI(uint256 tokenId) external view returns (string memory);
617 }
618 
619 // File: contracts/ERC721A_Demo.sol
620 
621 
622 // Creator: Chiru Labs
623 
624 pragma solidity ^0.8.4;
625 
626 error ApprovalCallerNotOwnerNorApproved();
627 error ApprovalQueryForNonexistentToken();
628 error ApproveToCaller();
629 error ApprovalToCurrentOwner();
630 error BalanceQueryForZeroAddress();
631 error MintedQueryForZeroAddress();
632 error BurnedQueryForZeroAddress();
633 error AuxQueryForZeroAddress();
634 error MintToZeroAddress();
635 error MintZeroQuantity();
636 error OwnerIndexOutOfBounds();
637 error OwnerQueryForNonexistentToken();
638 error TokenIndexOutOfBounds();
639 error TransferCallerNotOwnerNorApproved();
640 error TransferFromIncorrectOwner();
641 error TransferToNonERC721ReceiverImplementer();
642 error TransferToZeroAddress();
643 error URIQueryForNonexistentToken();
644 
645 /**
646  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
647  * the Metadata extension. Built to optimize for lower gas during batch mints.
648  *
649  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
650  *
651  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
652  *
653  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
654  */
655 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
656     using Address for address;
657     using Strings for uint256;
658 
659     // Compiler will pack this into a single 256bit word.
660     struct TokenOwnership {
661         // The address of the owner.
662         address addr;
663         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
664         uint64 startTimestamp;
665         // Whether the token has been burned.
666         bool burned;
667     }
668 
669     // Compiler will pack this into a single 256bit word.
670     struct AddressData {
671         // Realistically, 2**64-1 is more than enough.
672         uint64 balance;
673         // Keeps track of mint count with minimal overhead for tokenomics.
674         uint64 numberMinted;
675         // Keeps track of burn count with minimal overhead for tokenomics.
676         uint64 numberBurned;
677         // For miscellaneous variable(s) pertaining to the address
678         // (e.g. number of whitelist mint slots used). 
679         // If there are multiple variables, please pack them into a uint64.
680         uint64 aux;
681     }
682 
683     // The tokenId of the next token to be minted.
684     uint256 internal _currentIndex;
685 
686     // The number of tokens burned.
687     uint256 internal _burnCounter;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to ownership details
696     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
697     mapping(uint256 => TokenOwnership) internal _ownerships;
698 
699     // Mapping owner address to address data
700     mapping(address => AddressData) private _addressData;
701 
702     // Mapping from token ID to approved address
703     mapping(uint256 => address) private _tokenApprovals;
704 
705     // Mapping from owner to operator approvals
706     mapping(address => mapping(address => bool)) private _operatorApprovals;
707 
708     constructor(string memory name_, string memory symbol_) {
709         _name = name_;
710         _symbol = symbol_;
711     }
712 
713     /**
714      * @dev See {IERC721Enumerable-totalSupply}.
715      */
716     function totalSupply() public view returns (uint256) {
717         // Counter underflow is impossible as _burnCounter cannot be incremented
718         // more than _currentIndex times
719         unchecked {
720             return _currentIndex - _burnCounter;    
721         }
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
728         return
729             interfaceId == type(IERC721).interfaceId ||
730             interfaceId == type(IERC721Metadata).interfaceId ||
731             super.supportsInterface(interfaceId);
732     }
733 
734     /**
735      * @dev See {IERC721-balanceOf}.
736      */
737     function balanceOf(address owner) public view override returns (uint256) {
738         if (owner == address(0)) revert BalanceQueryForZeroAddress();
739         return uint256(_addressData[owner].balance);
740     }
741 
742     /**
743      * Returns the number of tokens minted by `owner`.
744      */
745     function _numberMinted(address owner) internal view returns (uint256) {
746         if (owner == address(0)) revert MintedQueryForZeroAddress();
747         return uint256(_addressData[owner].numberMinted);
748     }
749 
750     /**
751      * Returns the number of tokens burned by or on behalf of `owner`.
752      */
753     function _numberBurned(address owner) internal view returns (uint256) {
754         if (owner == address(0)) revert BurnedQueryForZeroAddress();
755         return uint256(_addressData[owner].numberBurned);
756     }
757 
758     /**
759      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
760      */
761     function _getAux(address owner) internal view returns (uint64) {
762         if (owner == address(0)) revert AuxQueryForZeroAddress();
763         return _addressData[owner].aux;
764     }
765 
766     /**
767      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
768      * If there are multiple variables, please pack them into a uint64.
769      */
770     function _setAux(address owner, uint64 aux) internal {
771         if (owner == address(0)) revert AuxQueryForZeroAddress();
772         _addressData[owner].aux = aux;
773     }
774 
775     /**
776      * Gas spent here starts off proportional to the maximum mint batch size.
777      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
778      */
779     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
780         uint256 curr = tokenId;
781 
782         unchecked {
783             if (curr < _currentIndex) {
784                 TokenOwnership memory ownership = _ownerships[curr];
785                 if (!ownership.burned) {
786                     if (ownership.addr != address(0)) {
787                         return ownership;
788                     }
789                     // Invariant: 
790                     // There will always be an ownership that has an address and is not burned 
791                     // before an ownership that does not have an address and is not burned.
792                     // Hence, curr will not underflow.
793                     while (true) {
794                         curr--;
795                         ownership = _ownerships[curr];
796                         if (ownership.addr != address(0)) {
797                             return ownership;
798                         }
799                     }
800                 }
801             }
802         }
803         revert OwnerQueryForNonexistentToken();
804     }
805 
806     /**
807      * @dev See {IERC721-ownerOf}.
808      */
809     function ownerOf(uint256 tokenId) public view override returns (address) {
810         return ownershipOf(tokenId).addr;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-name}.
815      */
816     function name() public view virtual override returns (string memory) {
817         return _name;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-symbol}.
822      */
823     function symbol() public view virtual override returns (string memory) {
824         return _symbol;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-tokenURI}.
829      */
830     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
831         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
832 
833         string memory baseURI = _baseURI();
834         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
835     }
836 
837     /**
838      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
839      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
840      * by default, can be overriden in child contracts.
841      */
842     function _baseURI() internal view virtual returns (string memory) {
843         return '';
844     }
845 
846     /**
847      * @dev See {IERC721-approve}.
848      */
849     function approve(address to, uint256 tokenId) public override {
850         address owner = ERC721A.ownerOf(tokenId);
851         if (to == owner) revert ApprovalToCurrentOwner();
852 
853         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
854             revert ApprovalCallerNotOwnerNorApproved();
855         }
856 
857         _approve(to, tokenId, owner);
858     }
859 
860     /**
861      * @dev See {IERC721-getApproved}.
862      */
863     function getApproved(uint256 tokenId) public view override returns (address) {
864         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
865 
866         return _tokenApprovals[tokenId];
867     }
868 
869     /**
870      * @dev See {IERC721-setApprovalForAll}.
871      */
872     function setApprovalForAll(address operator, bool approved) public override {
873         if (operator == _msgSender()) revert ApproveToCaller();
874 
875         _operatorApprovals[_msgSender()][operator] = approved;
876         emit ApprovalForAll(_msgSender(), operator, approved);
877     }
878 
879     /**
880      * @dev See {IERC721-isApprovedForAll}.
881      */
882     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
883         return _operatorApprovals[owner][operator];
884     }
885 
886     /**
887      * @dev See {IERC721-transferFrom}.
888      */
889     function transferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         _transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         safeTransferFrom(from, to, tokenId, '');
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) public virtual override {
917         _transfer(from, to, tokenId);
918         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
919             revert TransferToNonERC721ReceiverImplementer();
920         }
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      */
930     function _exists(uint256 tokenId) internal view returns (bool) {
931         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
932     }
933 
934     function _safeMint(address to, uint256 quantity) internal {
935         _safeMint(to, quantity, '');
936     }
937 
938     /**
939      * @dev Safely mints `quantity` tokens and transfers them to `to`.
940      *
941      * Requirements:
942      *
943      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
944      * - `quantity` must be greater than 0.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(
949         address to,
950         uint256 quantity,
951         bytes memory _data
952     ) internal {
953         _mint(to, quantity, _data, true);
954     }
955 
956     /**
957      * @dev Mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - `to` cannot be the zero address.
962      * - `quantity` must be greater than 0.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _mint(
967         address to,
968         uint256 quantity,
969         bytes memory _data,
970         bool safe
971     ) internal {
972         uint256 startTokenId = _currentIndex;
973         if (to == address(0)) revert MintToZeroAddress();
974         if (quantity == 0) revert MintZeroQuantity();
975 
976         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
977 
978         // Overflows are incredibly unrealistic.
979         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
980         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
981         unchecked {
982             _addressData[to].balance += uint64(quantity);
983             _addressData[to].numberMinted += uint64(quantity);
984 
985             _ownerships[startTokenId].addr = to;
986             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
987 
988             uint256 updatedIndex = startTokenId;
989 
990             for (uint256 i; i < quantity; i++) {
991                 emit Transfer(address(0), to, updatedIndex);
992                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
993                     revert TransferToNonERC721ReceiverImplementer();
994                 }
995                 updatedIndex++;
996             }
997 
998             _currentIndex = updatedIndex;
999         }
1000         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1001     }
1002 
1003     /**
1004      * @dev Transfers `tokenId` from `from` to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must be owned by `from`.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _transfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) private {
1018         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1019 
1020         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1021             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1022             getApproved(tokenId) == _msgSender());
1023 
1024         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1025         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1026         if (to == address(0)) revert TransferToZeroAddress();
1027 
1028         _beforeTokenTransfers(from, to, tokenId, 1);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId, prevOwnership.addr);
1032 
1033         // Underflow of the sender's balance is impossible because we check for
1034         // ownership above and the recipient's balance can't realistically overflow.
1035         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1036         unchecked {
1037             _addressData[from].balance -= 1;
1038             _addressData[to].balance += 1;
1039 
1040             _ownerships[tokenId].addr = to;
1041             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1042 
1043             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1044             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1045             uint256 nextTokenId = tokenId + 1;
1046             if (_ownerships[nextTokenId].addr == address(0)) {
1047                 // This will suffice for checking _exists(nextTokenId),
1048                 // as a burned slot cannot contain the zero address.
1049                 if (nextTokenId < _currentIndex) {
1050                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1051                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1052                 }
1053             }
1054         }
1055 
1056         emit Transfer(from, to, tokenId);
1057         _afterTokenTransfers(from, to, tokenId, 1);
1058     }
1059 
1060     /**
1061      * @dev Destroys `tokenId`.
1062      * The approval is cleared when the token is burned.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must exist.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _burn(uint256 tokenId) internal virtual {
1071         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1072 
1073         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1074 
1075         // Clear approvals from the previous owner
1076         _approve(address(0), tokenId, prevOwnership.addr);
1077 
1078         // Underflow of the sender's balance is impossible because we check for
1079         // ownership above and the recipient's balance can't realistically overflow.
1080         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1081         unchecked {
1082             _addressData[prevOwnership.addr].balance -= 1;
1083             _addressData[prevOwnership.addr].numberBurned += 1;
1084 
1085             // Keep track of who burned the token, and the timestamp of burning.
1086             _ownerships[tokenId].addr = prevOwnership.addr;
1087             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1088             _ownerships[tokenId].burned = true;
1089 
1090             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1091             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1092             uint256 nextTokenId = tokenId + 1;
1093             if (_ownerships[nextTokenId].addr == address(0)) {
1094                 // This will suffice for checking _exists(nextTokenId),
1095                 // as a burned slot cannot contain the zero address.
1096                 if (nextTokenId < _currentIndex) {
1097                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1098                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1099                 }
1100             }
1101         }
1102 
1103         emit Transfer(prevOwnership.addr, address(0), tokenId);
1104         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1105 
1106         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1107         unchecked { 
1108             _burnCounter++;
1109         }
1110     }
1111 
1112     /**
1113      * @dev Approve `to` to operate on `tokenId`
1114      *
1115      * Emits a {Approval} event.
1116      */
1117     function _approve(
1118         address to,
1119         uint256 tokenId,
1120         address owner
1121     ) private {
1122         _tokenApprovals[tokenId] = to;
1123         emit Approval(owner, to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1128      * The call is not executed if the target address is not a contract.
1129      *
1130      * @param from address representing the previous owner of the given token ID
1131      * @param to target address that will receive the tokens
1132      * @param tokenId uint256 ID of the token to be transferred
1133      * @param _data bytes optional data to send along with the call
1134      * @return bool whether the call correctly returned the expected magic value
1135      */
1136     function _checkOnERC721Received(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) private returns (bool) {
1142         if (to.isContract()) {
1143             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1144                 return retval == IERC721Receiver(to).onERC721Received.selector;
1145             } catch (bytes memory reason) {
1146                 if (reason.length == 0) {
1147                     revert TransferToNonERC721ReceiverImplementer();
1148                 } else {
1149                     assembly {
1150                         revert(add(32, reason), mload(reason))
1151                     }
1152                 }
1153             }
1154         } else {
1155             return true;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1161      * And also called before burning one token.
1162      *
1163      * startTokenId - the first token id to be transferred
1164      * quantity - the amount to be transferred
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, `tokenId` will be burned by `from`.
1172      * - `from` and `to` are never both zero.
1173      */
1174     function _beforeTokenTransfers(
1175         address from,
1176         address to,
1177         uint256 startTokenId,
1178         uint256 quantity
1179     ) internal virtual {}
1180 
1181     /**
1182      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1183      * minting.
1184      * And also called after one token has been burned.
1185      *
1186      * startTokenId - the first token id to be transferred
1187      * quantity - the amount to be transferred
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` has been minted for `to`.
1194      * - When `to` is zero, `tokenId` has been burned by `from`.
1195      * - `from` and `to` are never both zero.
1196      */
1197     function _afterTokenTransfers(
1198         address from,
1199         address to,
1200         uint256 startTokenId,
1201         uint256 quantity
1202     ) internal virtual {}
1203 }
1204 
1205 // File: @openzeppelin/contracts/access/Ownable.sol
1206 pragma solidity ^0.8.0;
1207 
1208 /**
1209  * @dev Contract module which provides a basic access control mechanism, where
1210  * there is an account (an owner) that can be granted exclusive access to
1211  * specific functions.
1212  *
1213  * By default, the owner account will be the one that deploys the contract. This
1214  * can later be changed with {transferOwnership}.
1215  *
1216  * This module is used through inheritance. It will make available the modifier
1217  * `onlyOwner`, which can be applied to your functions to restrict their use to
1218  * the owner.
1219  */
1220 abstract contract Ownable is Context {
1221     address private _owner;
1222 
1223     event OwnershipTransferred(
1224         address indexed previousOwner,
1225         address indexed newOwner
1226     );
1227 
1228     /**
1229      * @dev Initializes the contract setting the deployer as the initial owner.
1230      */
1231     constructor() {
1232         _setOwner(_msgSender());
1233     }
1234 
1235     /**
1236      * @dev Returns the address of the current owner.
1237      */
1238     function owner() public view virtual returns (address) {
1239         return _owner;
1240     }
1241 
1242     /**
1243      * @dev Throws if called by any account other than the owner.
1244      */
1245     modifier onlyOwner() {
1246         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1247         _;
1248     }
1249 
1250     /**
1251      * @dev Leaves the contract without owner. It will not be possible to call
1252      * `onlyOwner` functions anymore. Can only be called by the current owner.
1253      *
1254      * NOTE: Renouncing ownership will leave the contract without an owner,
1255      * thereby removing any functionality that is only available to the owner.
1256      */
1257     function renounceOwnership() public virtual onlyOwner {
1258         _setOwner(address(0));
1259     }
1260 
1261     /**
1262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1263      * Can only be called by the current owner.
1264      */
1265     function transferOwnership(address newOwner) public virtual onlyOwner {
1266         require(
1267             newOwner != address(0),
1268             "Ownable: new owner is the zero address"
1269         );
1270         _setOwner(newOwner);
1271     }
1272 
1273     function _setOwner(address newOwner) private {
1274         address oldOwner = _owner;
1275         _owner = newOwner;
1276         emit OwnershipTransferred(oldOwner, newOwner);
1277     }
1278 }
1279 
1280 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1281 pragma solidity ^0.8.0;
1282 
1283 /**
1284  * @dev Contract module that helps prevent reentrant calls to a function.
1285  *
1286  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1287  * available, which can be applied to functions to make sure there are no nested
1288  * (reentrant) calls to them.
1289  *
1290  * Note that because there is a single `nonReentrant` guard, functions marked as
1291  * `nonReentrant` may not call one another. This can be worked around by making
1292  * those functions `private`, and then adding `external` `nonReentrant` entry
1293  * points to them.
1294  *
1295  * TIP: If you would like to learn more about reentrancy and alternative ways
1296  * to protect against it, check out our blog post
1297  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1298  */
1299 abstract contract ReentrancyGuard {
1300     // Booleans are more expensive than uint256 or any type that takes up a full
1301     // word because each write operation emits an extra SLOAD to first read the
1302     // slot's contents, replace the bits taken up by the boolean, and then write
1303     // back. This is the compiler's defense against contract upgrades and
1304     // pointer aliasing, and it cannot be disabled.
1305 
1306     // The values being non-zero value makes deployment a bit more expensive,
1307     // but in exchange the refund on every call to nonReentrant will be lower in
1308     // amount. Since refunds are capped to a percentage of the total
1309     // transaction's gas, it is best to keep them low in cases like this one, to
1310     // increase the likelihood of the full refund coming into effect.
1311     uint256 private constant _NOT_ENTERED = 1;
1312     uint256 private constant _ENTERED = 2;
1313 
1314     uint256 private _status;
1315 
1316     constructor() {
1317         _status = _NOT_ENTERED;
1318     }
1319 
1320     /**
1321      * @dev Prevents a contract from calling itself, directly or indirectly.
1322      * Calling a `nonReentrant` function from another `nonReentrant`
1323      * function is not supported. It is possible to prevent this from happening
1324      * by making the `nonReentrant` function external, and making it call a
1325      * `private` function that does the actual work.
1326      */
1327     modifier nonReentrant() {
1328         // On the first call to nonReentrant, _notEntered will be true
1329         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1330 
1331         // Any calls to nonReentrant after this point will fail
1332         _status = _ENTERED;
1333 
1334         _;
1335 
1336         // By storing the original value once again, a refund is triggered (see
1337         // https://eips.ethereum.org/EIPS/eip-2200)
1338         _status = _NOT_ENTERED;
1339     }
1340 }
1341 
1342 pragma solidity ^0.8.4;
1343 
1344 /**
1345  * @title ERC721A Burnable Token
1346  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1347  */
1348 abstract contract ERC721ABurnable is Context, ERC721A {
1349 
1350     /**
1351      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1352      *
1353      * Requirements:
1354      *
1355      * - The caller must own `tokenId` or be an approved operator.
1356      */
1357     function burn(uint256 tokenId) public virtual {
1358         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1359 
1360         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1361             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1362             getApproved(tokenId) == _msgSender());
1363 
1364         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1365 
1366         _burn(tokenId);
1367     }
1368 }
1369 
1370 // Smart Contract -- Coded By VSNZLAB
1371 contract PictureDay is ERC721ABurnable, Ownable, ReentrancyGuard {
1372     using Strings for uint256;
1373 
1374     // Variables
1375     string baseURI;
1376     string public baseExtension = ".json"; // Base extension of metadata file
1377     uint256 public cost = 0.1 ether; // Cost of each NFT
1378     uint256 public maxSupply = 5000; // Max amount of NFTs that can be minted in total
1379     uint256 public maxMintAmount = 10; // Max amount to be minted at once
1380     bool public paused = true; // Contract paused when deployed
1381     bool public revealed = false; // NFT collection revealed when deployed
1382     string public notRevealedUri; // URI for placeholder image
1383     uint256 public nftPerAddressLimit = 10; // Maximum NFTs mintable on one wallet
1384     bool public onlyWhitelisted = true; // Whitelist address minting only
1385     mapping(address => bool) members;
1386     event MemberAdded(address member);
1387     event MemberRemoved(address member);
1388     mapping(address => uint256) public addressMintedBalance;
1389     uint256 totalBurned = 0;
1390 
1391     // Constructor
1392     constructor(
1393         string memory _name,
1394         string memory _symbol,
1395         string memory _initBaseURI,
1396         string memory _initNotRevealedUri,
1397         address[] memory _members
1398     ) ERC721A(_name, _symbol) {
1399         for (uint256 i = 0; i < _members.length; i++) {
1400             members[_members[i]] = true;
1401         }
1402         setBaseURI(_initBaseURI);
1403         setNotRevealedURI(_initNotRevealedUri);
1404     }
1405 
1406     // Internal
1407     function _baseURI() internal view virtual override returns (string memory) {
1408         return baseURI;
1409     }
1410 
1411     // Public
1412     // Minting Function
1413     function mint(uint256 _mintAmount) public payable {
1414         uint256 supply = totalSupply();
1415         require(!paused, "The contract is paused.");
1416         if (onlyWhitelisted == true) {
1417             require(
1418                 isMember(msg.sender),
1419                 "Your wallet address is not yet whitelisted."
1420             );
1421         }
1422         require(_mintAmount > 0, "Need to mint at least 1 NFT.");
1423         require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded.");
1424 		if (totalBurned == 0){
1425 			require(supply + _mintAmount <= maxSupply, "Max NFT limit exceeded.");
1426 		}
1427 		else{
1428 			require(supply + totalBurned - 1 + _mintAmount <= maxSupply, "Max NFT limit exceeded.");
1429 		}
1430         
1431         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1432         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded.");
1433 
1434         if (msg.sender != owner()) {
1435             require(msg.value >= cost * _mintAmount, "Insufficient funds.");
1436         }
1437 
1438         for (uint256 i = 1; i <= _mintAmount; i++) {
1439             addressMintedBalance[msg.sender]++;   
1440         }
1441 
1442         _safeMint(msg.sender, _mintAmount);
1443     }
1444 
1445     // Burn
1446     function burn(uint256 tokenId) public override {
1447         totalBurned++;
1448         _burn(tokenId);
1449     }
1450 
1451     // Checks if wallet address is whitelisted or not
1452     function isMember(address _member) public view returns (bool) {
1453         return members[_member];
1454     }
1455 
1456     // Returns token URI against a specific token ID
1457     function tokenURI(uint256 tokenId)
1458         public
1459         view
1460         virtual
1461         override
1462         returns (string memory)
1463     {
1464         require(
1465             _exists(tokenId),
1466             "ERC721Metadata: URI query for nonexistent token"
1467         );
1468 
1469         if (revealed == false) {
1470             return notRevealedUri;
1471         }
1472 
1473         string memory currentBaseURI = _baseURI();
1474         return
1475             bytes(currentBaseURI).length > 0
1476                 ? string(
1477                     abi.encodePacked(
1478                         currentBaseURI,
1479                         tokenId.toString(),
1480                         baseExtension
1481                     )
1482                 )
1483                 : "";
1484     }
1485     
1486     // Update NFT price
1487     function setCost(uint256 _newCost) public onlyOwner {
1488         cost = _newCost;
1489     }
1490 
1491     // Update Max Supply
1492     function setmaxSupply(uint256 _newmaxSupply) public onlyOwner {
1493         maxSupply = _newmaxSupply;
1494     }
1495 
1496     // Update maximum amount of NFTs that can be minted at once.
1497     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1498         maxMintAmount = _newmaxMintAmount;
1499     }
1500 
1501     // Update not revealed/placeholder image URI
1502     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1503         notRevealedUri = _notRevealedURI;
1504     }
1505 
1506     // Update original image URI
1507     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1508         baseURI = _newBaseURI;
1509     }
1510 
1511     // Update extension for metadata file
1512     function setBaseExtension(string memory _newBaseExtension)
1513         public
1514         onlyOwner
1515     {
1516         baseExtension = _newBaseExtension;
1517     }
1518 
1519     // Pause smart contract to stop minting
1520     function pause(bool _state) public onlyOwner {
1521         paused = _state;
1522     }
1523 
1524     // Reveals original NFTs for minted and non-minted NFTs
1525     function setRevealed(bool _state) public onlyOwner {
1526         revealed = _state;
1527     }
1528 
1529     // Sets whether whitelisted wallets can mint only
1530     function setOnlyWhitelisted(bool _state) public onlyOwner {
1531         onlyWhitelisted = _state;
1532     }
1533 
1534     // Updates maximum numbers of NFTs per wallet
1535     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1536         nftPerAddressLimit = _limit;
1537     }
1538 
1539     // Adds wallet address to whitelist
1540     function addMember(address _member) public onlyOwner {
1541         require(!isMember(_member), "Wallet address is already whitelisted.");
1542 
1543         members[_member] = true;
1544         emit MemberAdded(_member);
1545     }
1546 
1547     // Removes wallet address from whitelist
1548     function removeMember(address _member) public onlyOwner {
1549         require(isMember(_member), "Wallet address is not whitelisted.");
1550 
1551         delete members[_member];
1552         emit MemberRemoved(_member);
1553     }
1554 
1555     // Adds list of wallet addresses to whitelist
1556     function addMemberList(address[] memory _memberList) public onlyOwner {
1557         for (uint i = 0; i < _memberList.length; i++) {
1558             require(!isMember(_memberList[i]), "Wallet address is already whitelisted.");
1559             members[_memberList[i]] = true;
1560         }
1561     }
1562 
1563     // Removes list of wallet addresses to whitelist
1564     function removeMemberList(address[] memory _memberList) public onlyOwner {
1565         for (uint i = 0; i < _memberList.length; i++) {
1566             require(isMember(_memberList[i]), "Wallet address is not whitelisted.");
1567             delete members[_memberList[i]];
1568         }
1569     }
1570 
1571     // Withdraw funds from NFT contract
1572     function withdraw() public payable onlyOwner {
1573         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1574         require(os);
1575     }
1576 }