1 // SPDX-License-Identifier: MIT
2 // ERC721A LEMANO WATCHES
3 
4 pragma solidity ^0.8.4;
5 
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 
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
100 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
101 
102 /**
103  * @dev Collection of functions related to the address type
104  */
105 library Address {
106     /**
107      * @dev Returns true if `account` is a contract.
108      *
109      * [IMPORTANT]
110      * ====
111      * It is unsafe to assume that an address for which this function returns
112      * false is an externally-owned account (EOA) and not a contract.
113      *
114      * Among others, `isContract` will return false for the following
115      * types of addresses:
116      *
117      *  - an externally-owned account
118      *  - a contract in construction
119      *  - an address where a contract will be created
120      *  - an address where a contract lived, but was destroyed
121      * ====
122      *
123      * [IMPORTANT]
124      * ====
125      * You shouldn't rely on `isContract` to protect against flash loan attacks!
126      *
127      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
128      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
129      * constructor.
130      * ====
131      */
132     function isContract(address account) internal view returns (bool) {
133         // This method relies on extcodesize/address.code.length, which returns 0
134         // for contracts in construction, since the code is only stored at the end
135         // of the constructor execution.
136 
137         return account.code.length > 0;
138     }
139 
140     /**
141      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
142      * `recipient`, forwarding all available gas and reverting on errors.
143      *
144      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
145      * of certain opcodes, possibly making contracts go over the 2300 gas limit
146      * imposed by `transfer`, making them unable to receive funds via
147      * `transfer`. {sendValue} removes this limitation.
148      *
149      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
150      *
151      * IMPORTANT: because control is transferred to `recipient`, care must be
152      * taken to not create reentrancy vulnerabilities. Consider using
153      * {ReentrancyGuard} or the
154      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
155      */
156     function sendValue(address payable recipient, uint256 amount) internal {
157         require(address(this).balance >= amount, "Address: insufficient balance");
158 
159         (bool success, ) = recipient.call{value: amount}("");
160         require(success, "Address: unable to send value, recipient may have reverted");
161     }
162 
163     /**
164      * @dev Performs a Solidity function call using a low level `call`. A
165      * plain `call` is an unsafe replacement for a function call: use this
166      * function instead.
167      *
168      * If `target` reverts with a revert reason, it is bubbled up by this
169      * function (like regular Solidity function calls).
170      *
171      * Returns the raw returned data. To convert to the expected return value,
172      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
173      *
174      * Requirements:
175      *
176      * - `target` must be a contract.
177      * - calling `target` with `data` must not revert.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionCall(target, data, "Address: low-level call failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
187      * `errorMessage` as a fallback revert reason when `target` reverts.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, 0, errorMessage);
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
201      * but also transferring `value` wei to `target`.
202      *
203      * Requirements:
204      *
205      * - the calling contract must have an ETH balance of at least `value`.
206      * - the called Solidity function must be `payable`.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
220      * with `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         require(address(this).balance >= value, "Address: insufficient balance for call");
231         require(isContract(target), "Address: call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.call{value: value}(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
244         return functionStaticCall(target, data, "Address: low-level static call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal view returns (bytes memory) {
258         require(isContract(target), "Address: static call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.staticcall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
276      * but performing a delegate call.
277      *
278      * _Available since v3.4._
279      */
280     function functionDelegateCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(isContract(target), "Address: delegate call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.delegatecall(data);
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
293      * revert reason using the provided one.
294      *
295      * _Available since v4.3._
296      */
297     function verifyCallResult(
298         bool success,
299         bytes memory returndata,
300         string memory errorMessage
301     ) internal pure returns (bytes memory) {
302         if (success) {
303             return returndata;
304         } else {
305             // Look for revert reason and bubble it up if present
306             if (returndata.length > 0) {
307                 // The easiest way to bubble the revert reason is using memory via assembly
308 
309                 assembly {
310                     let returndata_size := mload(returndata)
311                     revert(add(32, returndata), returndata_size)
312                 }
313             } else {
314                 revert(errorMessage);
315             }
316         }
317     }
318 }
319 
320 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
324 
325 
326 
327 /**
328  * @title ERC721 token receiver interface
329  * @dev Interface for any contract that wants to support safeTransfers
330  * from ERC721 asset contracts.
331  */
332 interface IERC721Receiver {
333     /**
334      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
335      * by `operator` from `from`, this function is called.
336      *
337      * It must return its Solidity selector to confirm the token transfer.
338      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
339      *
340      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
341      */
342     function onERC721Received(
343         address operator,
344         address from,
345         uint256 tokenId,
346         bytes calldata data
347     ) external returns (bytes4);
348 }
349 
350 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
351 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
352 
353 
354 /**
355  * @dev Interface of the ERC165 standard, as defined in the
356  * https://eips.ethereum.org/EIPS/eip-165[EIP].
357  *
358  * Implementers can declare support of contract interfaces, which can then be
359  * queried by others ({ERC165Checker}).
360  *
361  * For an implementation, see {ERC165}.
362  */
363 interface IERC165 {
364     /**
365      * @dev Returns true if this contract implements the interface defined by
366      * `interfaceId`. See the corresponding
367      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
368      * to learn more about how these ids are created.
369      *
370      * This function call must use less than 30 000 gas.
371      */
372     function supportsInterface(bytes4 interfaceId) external view returns (bool);
373 }
374 
375 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
376 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
377 
378 
379 /**
380  * @dev Implementation of the {IERC165} interface.
381  *
382  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
383  * for the additional interface id that will be supported. For example:
384  *
385  * ```solidity
386  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
387  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
388  * }
389  * ```
390  *
391  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
392  */
393 abstract contract ERC165 is IERC165 {
394     /**
395      * @dev See {IERC165-supportsInterface}.
396      */
397     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
398         return interfaceId == type(IERC165).interfaceId;
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
403 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
404 
405 /**
406  * @dev Required interface of an ERC721 compliant contract.
407  */
408 interface IERC721 is IERC165 {
409     /**
410      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
411      */
412     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
413 
414     /**
415      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
416      */
417     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
418 
419     /**
420      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
421      */
422     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
423 
424     /**
425      * @dev Returns the number of tokens in ``owner``'s account.
426      */
427     function balanceOf(address owner) external view returns (uint256 balance);
428 
429     /**
430      * @dev Returns the owner of the `tokenId` token.
431      *
432      * Requirements:
433      *
434      * - `tokenId` must exist.
435      */
436     function ownerOf(uint256 tokenId) external view returns (address owner);
437 
438     /**
439      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
440      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId
456     ) external;
457 
458     /**
459      * @dev Transfers `tokenId` token from `from` to `to`.
460      *
461      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
462      *
463      * Requirements:
464      *
465      * - `from` cannot be the zero address.
466      * - `to` cannot be the zero address.
467      * - `tokenId` token must be owned by `from`.
468      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
469      *
470      * Emits a {Transfer} event.
471      */
472     function transferFrom(
473         address from,
474         address to,
475         uint256 tokenId
476     ) external;
477 
478     /**
479      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
480      * The approval is cleared when the token is transferred.
481      *
482      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
483      *
484      * Requirements:
485      *
486      * - The caller must own the token or be an approved operator.
487      * - `tokenId` must exist.
488      *
489      * Emits an {Approval} event.
490      */
491     function approve(address to, uint256 tokenId) external;
492 
493     /**
494      * @dev Returns the account approved for `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function getApproved(uint256 tokenId) external view returns (address operator);
501 
502     /**
503      * @dev Approve or remove `operator` as an operator for the caller.
504      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
505      *
506      * Requirements:
507      *
508      * - The `operator` cannot be the caller.
509      *
510      * Emits an {ApprovalForAll} event.
511      */
512     function setApprovalForAll(address operator, bool _approved) external;
513 
514     /**
515      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
516      *
517      * See {setApprovalForAll}
518      */
519     function isApprovedForAll(address owner, address operator) external view returns (bool);
520 
521     /**
522      * @dev Safely transfers `tokenId` token from `from` to `to`.
523      *
524      * Requirements:
525      *
526      * - `from` cannot be the zero address.
527      * - `to` cannot be the zero address.
528      * - `tokenId` token must exist and be owned by `from`.
529      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
530      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
531      *
532      * Emits a {Transfer} event.
533      */
534     function safeTransferFrom(
535         address from,
536         address to,
537         uint256 tokenId,
538         bytes calldata data
539     ) external;
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
544 
545 
546 
547 /**
548  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
549  * @dev See https://eips.ethereum.org/EIPS/eip-721
550  */
551 interface IERC721Metadata is IERC721 {
552     /**
553      * @dev Returns the token collection name.
554      */
555     function name() external view returns (string memory);
556 
557     /**
558      * @dev Returns the token collection symbol.
559      */
560     function symbol() external view returns (string memory);
561 
562     /**
563      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
564      */
565     function tokenURI(uint256 tokenId) external view returns (string memory);
566 }
567 
568 
569 
570 error ApprovalCallerNotOwnerNorApproved();
571 error ApprovalQueryForNonexistentToken();
572 error ApproveToCaller();
573 error ApprovalToCurrentOwner();
574 error BalanceQueryForZeroAddress();
575 error MintToZeroAddress();
576 error MintZeroQuantity();
577 error OwnerQueryForNonexistentToken();
578 error TransferCallerNotOwnerNorApproved();
579 error TransferFromIncorrectOwner();
580 error TransferToNonERC721ReceiverImplementer();
581 error TransferToZeroAddress();
582 error URIQueryForNonexistentToken();
583 
584 /**
585  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
586  * the Metadata extension. Built to optimize for lower gas during batch mints.
587  *
588  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
589  *
590  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
591  *
592  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
593  */
594 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
595     using Address for address;
596     using Strings for uint256;
597 
598     // Compiler will pack this into a single 256bit word.
599     struct TokenOwnership {
600         // The address of the owner.
601         address addr;
602         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
603         uint64 startTimestamp;
604         // Whether the token has been burned.
605        // bool burned;
606     }
607 
608     // Compiler will pack this into a single 256bit word.
609     struct AddressData {
610         // Realistically, 2**64-1 is more than enough.
611         uint64 balance;
612         // Keeps track of mint count with minimal overhead for tokenomics.
613         uint64 numberMinted;
614         // Keeps track of burn count with minimal overhead for tokenomics.
615         //uint64 numberBurned;
616         // For miscellaneous variable(s) pertaining to the address
617         // (e.g. number of whitelist mint slots used).
618         // If there are multiple variables, please pack them into a uint64.
619         //uint64 aux;
620     }
621 
622     // The tokenId of the next token to be minted.
623     uint256 internal _currentIndex;
624 
625     // The number of tokens burned.
626     //uint256 internal _burnCounter;
627 
628     // Token name
629     string private _name;
630 
631     // Token symbol
632     string private _symbol;
633 
634     // Mapping from token ID to ownership details
635     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
636     mapping(uint256 => TokenOwnership) internal _ownerships;
637 
638     // Mapping owner address to address data
639     mapping(address => AddressData) private _addressData;
640 
641     // Mapping from token ID to approved address
642     mapping(uint256 => address) private _tokenApprovals;
643 
644     // Mapping from owner to operator approvals
645     mapping(address => mapping(address => bool)) private _operatorApprovals;
646 
647     mapping (address => uint256 []) internal tokenIdsOwnedBy;
648 
649 
650     /* LEMANO WATCH VARS */
651     address public admin;
652     address payable public lemanoWallet;
653     
654     uint256 public tokenPrice = 0.077 ether;
655 
656     bool public transferIsLocked = true;
657     
658     uint256 public maxMintPerTx = 5 ;
659 
660     uint256 public MAX_SUPPLY = 1953;
661     string public baseURI = "ipfs://QmeA67MkbJKzwAJm5N3eafAFCfqXFLeMrkAP1Mkgf6RtwE/";
662 
663 
664 constructor(string memory name_, string memory symbol_) {
665         _name = name_;
666         _symbol = symbol_;
667         _currentIndex = _startTokenId();
668         admin = msg.sender;
669         lemanoWallet = payable(0xCeC38896B3b936b02be64D98DC7e738f6cA69219);
670     }
671 
672     /**
673      * To change the starting tokenId, please override this function.
674      */
675     function _startTokenId() internal view virtual returns (uint256) {
676         return 1;
677     }
678 
679     /**
680      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
681      */
682     function totalSupply() public view returns (uint256) {
683         // Counter underflow is impossible as _burnCounter cannot be incremented
684         // more than _currentIndex - _startTokenId() times
685         unchecked {
686             return _currentIndex  - _startTokenId();//- _burnCounter
687         }
688     }
689 
690     /**
691      * Returns the total amount of tokens minted in the contract.
692      */
693     function _totalMinted() internal view returns (uint256) {
694         // Counter underflow is impossible as _currentIndex does not decrement,
695         // and it is initialized to _startTokenId()
696         unchecked {
697             return _currentIndex - _startTokenId();
698         }
699     }
700 
701     /**
702      * @dev See {IERC165-supportsInterface}.
703      */
704     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
705         return
706             interfaceId == type(IERC721).interfaceId ||
707             interfaceId == type(IERC721Metadata).interfaceId ||
708             super.supportsInterface(interfaceId);
709     }
710 
711     /**
712      * @dev See {IERC721-balanceOf}.
713      */
714     function balanceOf(address owner) public view override returns (uint256) {
715         if (owner == address(0)) revert BalanceQueryForZeroAddress();
716         return uint256(_addressData[owner].balance);
717     }
718 
719     /**
720      * Returns the number of tokens minted by `owner`.
721      */
722     function _numberMinted(address owner) internal view returns (uint256) {
723         return uint256(_addressData[owner].numberMinted);
724     }
725 
726     /**
727      * Returns the number of tokens burned by or on behalf of `owner`.
728      
729     function _numberBurned(address owner) internal view returns (uint256) {
730         return uint256(_addressData[owner].numberBurned);
731     }
732     */
733     /**
734      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
735    
736     function _getAux(address owner) internal view returns (uint64) {
737         return _addressData[owner].aux;
738     }
739       */
740     /**
741      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
742      * If there are multiple variables, please pack them into a uint64.
743     
744     function _setAux(address owner, uint64 aux) internal {
745         _addressData[owner].aux = aux;
746     }
747      */
748     /**
749      * Gas spent here starts off proportional to the maximum mint batch size.
750      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
751      */
752     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
753         uint256 curr = tokenId;
754 
755         unchecked {
756             if (_startTokenId() <= curr && curr < _currentIndex) {
757                 TokenOwnership memory ownership = _ownerships[curr];
758                 //if (!ownership.burned) {
759                     if (ownership.addr != address(0)) {
760                         return ownership;
761                     }
762                     // Invariant:
763                     // There will always be an ownership that has an address and is not burned
764                     // before an ownership that does not have an address and is not burned.
765                     // Hence, curr will not underflow.
766                     while (true) {
767                         curr--;
768                         ownership = _ownerships[curr];
769                         if (ownership.addr != address(0)) {
770                             return ownership;
771                         }
772                     }
773                // }
774             }
775         }
776         revert OwnerQueryForNonexistentToken();
777     }
778 
779     /**
780      * @dev See {IERC721-ownerOf}.
781      */
782     function ownerOf(uint256 tokenId) public view override returns (address) {
783         return _ownershipOf(tokenId).addr;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
805 
806         //string memory baseURI = _baseURI();
807         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, can be overriden in child contracts.
814      
815     function _baseURI() internal view virtual returns (string memory) {
816         return baseURI;
817     }
818     */
819 
820     /**
821      * @dev See {IERC721-approve}.
822      */
823     function approve(address to, uint256 tokenId) public override {
824         address owner = ERC721A.ownerOf(tokenId);
825         if (to == owner) revert ApprovalToCurrentOwner();
826 
827         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
828             revert ApprovalCallerNotOwnerNorApproved();
829         }
830 
831         _approve(to, tokenId, owner);
832     }
833 
834     /**
835      * @dev See {IERC721-getApproved}.
836      */
837     function getApproved(uint256 tokenId) public view override returns (address) {
838         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
839 
840         return _tokenApprovals[tokenId];
841     }
842 
843     /**
844      * @dev See {IERC721-setApprovalForAll}.
845      */
846     function setApprovalForAll(address operator, bool approved) public virtual override {
847         if (operator == _msgSender()) revert ApproveToCaller();
848 
849         _operatorApprovals[_msgSender()][operator] = approved;
850         emit ApprovalForAll(_msgSender(), operator, approved);
851     }
852 
853     /**
854      * @dev See {IERC721-isApprovedForAll}.
855      */
856     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
857         return _operatorApprovals[owner][operator];
858     }
859 
860     /**
861      * @dev See {IERC721-transferFrom}.
862      */
863     function transferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) public virtual override {
868         _transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         safeTransferFrom(from, to, tokenId, '');
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) public virtual override {
891         _transfer(from, to, tokenId);
892         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
893             revert TransferToNonERC721ReceiverImplementer();
894         }
895     }
896 
897     /**
898      * @dev Returns whether `tokenId` exists.
899      *
900      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901      *
902      * Tokens start existing when they are minted (`_mint`),
903      */
904     function _exists(uint256 tokenId) internal view returns (bool) {
905         return _startTokenId() <= tokenId && tokenId < _currentIndex ;//&&  !_ownerships[tokenId].burned
906     }
907 
908     function _safeMint(address to, uint256 quantity) internal {
909         _safeMint(to, quantity, '');
910     }
911 
912     /**
913      * @dev Safely mints `quantity` tokens and transfers them to `to`.
914      *
915      * Requirements:
916      *
917      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
918      * - `quantity` must be greater than 0.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _safeMint(
923         address to,
924         uint256 quantity,
925         bytes memory _data
926     ) internal {
927         _mint(to, quantity, _data, true);
928     }
929 
930     /**
931      * @dev Mints `quantity` tokens and transfers them to `to`.
932      *
933      * Requirements:
934      *
935      * - `to` cannot be the zero address.
936      * - `quantity` must be greater than 0.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _mint(
941         address to,
942         uint256 quantity,
943         bytes memory _data,
944         bool safe
945     ) internal {
946         uint256 startTokenId = _currentIndex;
947         if (to == address(0)) revert MintToZeroAddress();
948         if (quantity == 0) revert MintZeroQuantity();
949 
950         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
951 
952         // Overflows are incredibly unrealistic.
953         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
954         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
955         unchecked {
956             _addressData[to].balance += uint64(quantity);
957             _addressData[to].numberMinted += uint64(quantity);
958 
959             _ownerships[startTokenId].addr = to;
960             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
961 
962             uint256 updatedIndex = startTokenId;
963             uint256 end = updatedIndex + quantity;
964 
965             if (safe && to.isContract()) {
966                 do {
967                     emit Transfer(address(0), to, updatedIndex);
968                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
969                         revert TransferToNonERC721ReceiverImplementer();
970                     }
971                 } while (updatedIndex != end);
972                 // Reentrancy protection
973                 if (_currentIndex != startTokenId) revert();
974             } else {
975                 do {
976 
977                     tokenIdsOwnedBy[to].push(updatedIndex);
978                     
979                     emit Transfer(address(0), to, updatedIndex++);
980                 } while (updatedIndex != end);
981             }
982             _currentIndex = updatedIndex;
983         }
984         _afterTokenTransfers(address(0), to, startTokenId, quantity);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must be owned by `from`.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _transfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) private {
1002         require(!transferIsLocked || from == admin,"Please wait the Presale End");
1003         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1004 
1005         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1006 
1007         bool isApprovedOrOwner = (_msgSender() == from ||
1008             isApprovedForAll(from, _msgSender()) ||
1009             getApproved(tokenId) == _msgSender());
1010 
1011         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1012         if (to == address(0)) revert TransferToZeroAddress();
1013 
1014         _beforeTokenTransfers(from, to, tokenId, 1);
1015 
1016         // Clear approvals from the previous owner
1017         _approve(address(0), tokenId, from);
1018 
1019         // Underflow of the sender's balance is impossible because we check for
1020         // ownership above and the recipient's balance can't realistically overflow.
1021         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1022         unchecked {
1023             _addressData[from].balance -= 1;
1024             _addressData[to].balance += 1;
1025 
1026             TokenOwnership storage currSlot = _ownerships[tokenId];
1027             currSlot.addr = to;
1028             currSlot.startTimestamp = uint64(block.timestamp);
1029 
1030             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1031             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1032             uint256 nextTokenId = tokenId + 1;
1033             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1034             if (nextSlot.addr == address(0)) {
1035                 // This will suffice for checking _exists(nextTokenId),
1036                 // as a burned slot cannot contain the zero address.
1037                 if (nextTokenId != _currentIndex) {
1038                     nextSlot.addr = from;
1039                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1040                 }
1041             }
1042         }
1043 
1044         //delete preview ownership array
1045         for(uint index = 0;index < tokenIdsOwnedBy[from].length;index++){
1046             if(tokenIdsOwnedBy[from][index]==tokenId){
1047             delete tokenIdsOwnedBy[from][index];
1048                 break;
1049             }
1050         }
1051         tokenIdsOwnedBy[to].push(tokenId);
1052 
1053         emit Transfer(from, to, tokenId);
1054         _afterTokenTransfers(from, to, tokenId, 1);
1055     }
1056 
1057     /**
1058      * @dev This is equivalent to _burn(tokenId, false)
1059    
1060     function _burn(uint256 tokenId) internal virtual {
1061         _burn(tokenId, false);
1062     }  */
1063 
1064     /**
1065      * @dev Destroys `tokenId`.
1066      * The approval is cleared when the token is burned.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      *
1072      * Emits a {Transfer} event.
1073     
1074     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1075         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1076 
1077         address from = prevOwnership.addr;
1078 
1079         if (approvalCheck) {
1080             bool isApprovedOrOwner = (_msgSender() == from ||
1081                 isApprovedForAll(from, _msgSender()) ||
1082                 getApproved(tokenId) == _msgSender());
1083 
1084             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1085         }
1086 
1087         _beforeTokenTransfers(from, address(0), tokenId, 1);
1088 
1089         // Clear approvals from the previous owner
1090         _approve(address(0), tokenId, from);
1091 
1092         // Underflow of the sender's balance is impossible because we check for
1093         // ownership above and the recipient's balance can't realistically overflow.
1094         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1095         unchecked {
1096             AddressData storage addressData = _addressData[from];
1097             addressData.balance -= 1;
1098             addressData.numberBurned += 1;
1099 
1100             // Keep track of who burned the token, and the timestamp of burning.
1101             TokenOwnership storage currSlot = _ownerships[tokenId];
1102             currSlot.addr = from;
1103             currSlot.startTimestamp = uint64(block.timestamp);
1104             currSlot.burned = true;
1105 
1106             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1107             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1108             uint256 nextTokenId = tokenId + 1;
1109             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1110             if (nextSlot.addr == address(0)) {
1111                 // This will suffice for checking _exists(nextTokenId),
1112                 // as a burned slot cannot contain the zero address.
1113                 if (nextTokenId != _currentIndex) {
1114                     nextSlot.addr = from;
1115                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1116                 }
1117             }
1118         }
1119 
1120         emit Transfer(from, address(0), tokenId);
1121         _afterTokenTransfers(from, address(0), tokenId, 1);
1122 
1123         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1124         unchecked {
1125             _burnCounter++;
1126         }
1127     }
1128  */
1129     /**
1130      * @dev Approve `to` to operate on `tokenId`
1131      *
1132      * Emits a {Approval} event.
1133      */
1134     function _approve(
1135         address to,
1136         uint256 tokenId,
1137         address owner
1138     ) private {
1139         _tokenApprovals[tokenId] = to;
1140         emit Approval(owner, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1145      *
1146      * @param from address representing the previous owner of the given token ID
1147      * @param to target address that will receive the tokens
1148      * @param tokenId uint256 ID of the token to be transferred
1149      * @param _data bytes optional data to send along with the call
1150      * @return bool whether the call correctly returned the expected magic value
1151      */
1152     function _checkContractOnERC721Received(
1153         address from,
1154         address to,
1155         uint256 tokenId,
1156         bytes memory _data
1157     ) private returns (bool) {
1158         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1159             return retval == IERC721Receiver(to).onERC721Received.selector;
1160         } catch (bytes memory reason) {
1161             if (reason.length == 0) {
1162                 revert TransferToNonERC721ReceiverImplementer();
1163             } else {
1164                 assembly {
1165                     revert(add(32, reason), mload(reason))
1166                 }
1167             }
1168         }
1169     }
1170 
1171     /**
1172      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1173      * And also called before burning one token.
1174      *
1175      * startTokenId - the first token id to be transferred
1176      * quantity - the amount to be transferred
1177      *
1178      * Calling conditions:
1179      *
1180      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1181      * transferred to `to`.
1182      * - When `from` is zero, `tokenId` will be minted for `to`.
1183      * - When `to` is zero, `tokenId` will be burned by `from`.
1184      * - `from` and `to` are never both zero.
1185      */
1186     function _beforeTokenTransfers(
1187         address from,
1188         address to,
1189         uint256 startTokenId,
1190         uint256 quantity
1191     ) internal virtual {}
1192 
1193     /**
1194      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1195      * minting.
1196      * And also called after one token has been burned.
1197      *
1198      * startTokenId - the first token id to be transferred
1199      * quantity - the amount to be transferred
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` has been minted for `to`.
1206      * - When `to` is zero, `tokenId` has been burned by `from`.
1207      * - `from` and `to` are never both zero.
1208      */
1209     function _afterTokenTransfers(
1210         address from,
1211         address to,
1212         uint256 startTokenId,
1213         uint256 quantity
1214     ) internal virtual {}
1215    
1216     /* @returns tokenIds same owner in 1 call from dapp */
1217     function getTokenIdsOwnedBy(address  _owner) virtual public view returns (uint256 [] memory){
1218 	   return tokenIdsOwnedBy[_owner];
1219 	}
1220 
1221     /* LEMANO WATCH custom functions */
1222 
1223     function mintTokenNFT (uint256 _numTokens) external payable returns (bool success){
1224          uint256 amount = msg.value;
1225          require(totalSupply()+(_numTokens) <= MAX_SUPPLY,"Collection is not more available");
1226          require (_numTokens <= maxMintPerTx ,"Max Mints each transaction");
1227          require(amount >= tokenPrice * _numTokens || admin == msg.sender ,"Not enought amount to buy this NFT");
1228 
1229         _safeMint(msg.sender,_numTokens,'');
1230          
1231         return true;
1232     }
1233 
1234     /* Reveal full collection*/
1235     function setBaseURIpfs (string memory _baseUri)  external  returns (bool success){
1236         require(msg.sender == admin,"Only Admin can act here");
1237         baseURI = _baseUri;
1238         return true;
1239     }
1240 
1241     function withdrawAdmin() public{
1242         require(msg.sender == admin, "Only Admin can act here");
1243         lemanoWallet.transfer(address(this).balance);
1244     }
1245         
1246     function setTokenPrice(uint256 _price) public {
1247         require(msg.sender == admin,"Only Admin can act here");
1248         tokenPrice = _price;
1249     }
1250         
1251     function setTransferIsLocked(bool _isLocked) public {
1252         require(msg.sender == admin,"Only Admin can act here");
1253         transferIsLocked = _isLocked;
1254     }
1255 
1256     function setMaxMintPerTx(uint256 _max) public {
1257         require(msg.sender == admin,"Only Admin can act here");
1258         maxMintPerTx = _max;
1259     }
1260 
1261     function setLemanoWallet(address _address) public {
1262         require(msg.sender == admin,"Only Admin can act here");
1263         lemanoWallet = payable(_address);
1264     }
1265 
1266     function setAdminWallet(address _address) public {
1267         require(msg.sender == admin,"Only Admin can act here");
1268         admin = _address;
1269     }
1270 }
1271 
1272 contract LEMANO_NFT is ERC721A {
1273     
1274   //Name symbol   
1275     constructor() ERC721A("Chronos Dot", "LMNFT")  {
1276 
1277     }
1278 }