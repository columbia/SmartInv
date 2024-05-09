1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-24
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Address.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
79 
80 pragma solidity ^0.8.1;
81 
82 /**
83  * @dev Collection of functions related to the address type
84  */
85 library Address {
86     /**
87      * @dev Returns true if `account` is a contract.
88      *
89      * [IMPORTANT]
90      * ====
91      * It is unsafe to assume that an address for which this function returns
92      * false is an externally-owned account (EOA) and not a contract.
93      *
94      * Among others, `isContract` will return false for the following
95      * types of addresses:
96      *
97      *  - an externally-owned account
98      *  - a contract in construction
99      *  - an address where a contract will be created
100      *  - an address where a contract lived, but was destroyed
101      * ====
102      *
103      * [IMPORTANT]
104      * ====
105      * You shouldn't rely on `isContract` to protect against flash loan attacks!
106      *
107      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
108      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
109      * constructor.
110      * ====
111      */
112     function isContract(address account) internal view returns (bool) {
113         // This method relies on extcodesize/address.code.length, which returns 0
114         // for contracts in construction, since the code is only stored at the end
115         // of the constructor execution.
116 
117         return account.code.length > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         (bool success, ) = recipient.call{value: amount}("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 
143     /**
144      * @dev Performs a Solidity function call using a low level `call`. A
145      * plain `call` is an unsafe replacement for a function call: use this
146      * function instead.
147      *
148      * If `target` reverts with a revert reason, it is bubbled up by this
149      * function (like regular Solidity function calls).
150      *
151      * Returns the raw returned data. To convert to the expected return value,
152      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
153      *
154      * Requirements:
155      *
156      * - `target` must be a contract.
157      * - calling `target` with `data` must not revert.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionCall(target, data, "Address: low-level call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
167      * `errorMessage` as a fallback revert reason when `target` reverts.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, 0, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but also transferring `value` wei to `target`.
182      *
183      * Requirements:
184      *
185      * - the calling contract must have an ETH balance of at least `value`.
186      * - the called Solidity function must be `payable`.
187      *
188      * _Available since v3.1._
189      */
190     function functionCallWithValue(
191         address target,
192         bytes memory data,
193         uint256 value
194     ) internal returns (bytes memory) {
195         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
200      * with `errorMessage` as a fallback revert reason when `target` reverts.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(address(this).balance >= value, "Address: insufficient balance for call");
211         require(isContract(target), "Address: call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.call{value: value}(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
224         return functionStaticCall(target, data, "Address: low-level static call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         require(isContract(target), "Address: static call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.staticcall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         require(isContract(target), "Address: delegate call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.delegatecall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
273      * revert reason using the provided one.
274      *
275      * _Available since v4.3._
276      */
277     function verifyCallResult(
278         bool success,
279         bytes memory returndata,
280         string memory errorMessage
281     ) internal pure returns (bytes memory) {
282         if (success) {
283             return returndata;
284         } else {
285             // Look for revert reason and bubble it up if present
286             if (returndata.length > 0) {
287                 // The easiest way to bubble the revert reason is using memory via assembly
288 
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
301 
302 
303 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @title ERC721 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  * from ERC721 asset contracts.
311  */
312 interface IERC721Receiver {
313     /**
314      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
315      * by `operator` from `from`, this function is called.
316      *
317      * It must return its Solidity selector to confirm the token transfer.
318      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
319      *
320      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
321      */
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Interface of the ERC165 standard, as defined in the
339  * https://eips.ethereum.org/EIPS/eip-165[EIP].
340  *
341  * Implementers can declare support of contract interfaces, which can then be
342  * queried by others ({ERC165Checker}).
343  *
344  * For an implementation, see {ERC165}.
345  */
346 interface IERC165 {
347     /**
348      * @dev Returns true if this contract implements the interface defined by
349      * `interfaceId`. See the corresponding
350      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
351      * to learn more about how these ids are created.
352      *
353      * This function call must use less than 30 000 gas.
354      */
355     function supportsInterface(bytes4 interfaceId) external view returns (bool);
356 }
357 
358 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 
366 /**
367  * @dev Implementation of the {IERC165} interface.
368  *
369  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
370  * for the additional interface id that will be supported. For example:
371  *
372  * ```solidity
373  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
374  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
375  * }
376  * ```
377  *
378  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
379  */
380 abstract contract ERC165 is IERC165 {
381     /**
382      * @dev See {IERC165-supportsInterface}.
383      */
384     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
385         return interfaceId == type(IERC165).interfaceId;
386     }
387 }
388 
389 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Required interface of an ERC721 compliant contract.
399  */
400 interface IERC721 is IERC165 {
401     /**
402      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
413      */
414     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId,
447         bytes calldata data
448     ) external;
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
452      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Transfers `tokenId` token from `from` to `to`.
472      *
473      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
492      * The approval is cleared when the token is transferred.
493      *
494      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
495      *
496      * Requirements:
497      *
498      * - The caller must own the token or be an approved operator.
499      * - `tokenId` must exist.
500      *
501      * Emits an {Approval} event.
502      */
503     function approve(address to, uint256 tokenId) external;
504 
505     /**
506      * @dev Approve or remove `operator` as an operator for the caller.
507      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
508      *
509      * Requirements:
510      *
511      * - The `operator` cannot be the caller.
512      *
513      * Emits an {ApprovalForAll} event.
514      */
515     function setApprovalForAll(address operator, bool _approved) external;
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
527      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
528      *
529      * See {setApprovalForAll}
530      */
531     function isApprovedForAll(address owner, address operator) external view returns (bool);
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
544  * @dev See https://eips.ethereum.org/EIPS/eip-721
545  */
546 interface IERC721Metadata is IERC721 {
547     /**
548      * @dev Returns the token collection name.
549      */
550     function name() external view returns (string memory);
551 
552     /**
553      * @dev Returns the token collection symbol.
554      */
555     function symbol() external view returns (string memory);
556 
557     /**
558      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
559      */
560     function tokenURI(uint256 tokenId) external view returns (string memory);
561 }
562 
563 // File: @openzeppelin/contracts/utils/Context.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev Provides information about the current execution context, including the
572  * sender of the transaction and its data. While these are generally available
573  * via msg.sender and msg.data, they should not be accessed in such a direct
574  * manner, since when dealing with meta-transactions the account sending and
575  * paying for execution may not be the actual sender (as far as an application
576  * is concerned).
577  *
578  * This contract is only required for intermediate, library-like contracts.
579  */
580 abstract contract Context {
581     function _msgSender() internal view virtual returns (address) {
582         return msg.sender;
583     }
584 
585     function _msgData() internal view virtual returns (bytes calldata) {
586         return msg.data;
587     }
588 }
589 
590 // File: ERC721A.sol
591 
592 
593 // Creator: Chiru Labs
594 
595 pragma solidity ^0.8.7;
596 
597 error ApprovalCallerNotOwnerNorApproved();
598 error ApprovalQueryForNonexistentToken();
599 error ApproveToCaller();
600 error ApprovalToCurrentOwner();
601 error BalanceQueryForZeroAddress();
602 error MintToZeroAddress();
603 error MintZeroQuantity();
604 error OwnerQueryForNonexistentToken();
605 error TransferCallerNotOwnerNorApproved();
606 error TransferFromIncorrectOwner();
607 error TransferToNonERC721ReceiverImplementer();
608 error TransferToZeroAddress();
609 error URIQueryForNonexistentToken();
610 
611 /**
612  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
613  * the Metadata extension. Built to optimize for lower gas during batch mints.
614  *
615  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
616  *
617  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
618  *
619  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
620  */
621 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
622     using Address for address;
623     using Strings for uint256;
624 
625     // Compiler will pack this into a single 256bit word.
626     struct TokenOwnership {
627         // The address of the owner.
628         address addr;
629         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
630         uint64 startTimestamp;
631         // Whether the token has been burned.
632         bool burned;
633     }
634 
635     // Compiler will pack this into a single 256bit word.
636     struct AddressData {
637         // Realistically, 2**64-1 is more than enough.
638         uint64 balance;
639         // Keeps track of mint count with minimal overhead for tokenomics.
640         uint64 numberMinted;
641         // Keeps track of burn count with minimal overhead for tokenomics.
642         uint64 numberBurned;
643         // For miscellaneous variable(s) pertaining to the address
644         // (e.g. number of whitelist mint slots used).
645         // If there are multiple variables, please pack them into a uint64.
646         uint64 aux;
647     }
648 
649     // The tokenId of the next token to be minted.
650     uint256 internal _currentIndex;
651 
652     // The number of tokens burned.
653     uint256 internal _burnCounter;
654 
655     // Token name
656     string private _name;
657 
658     // Token symbol
659     string private _symbol;
660 
661     // Mapping from token ID to ownership details
662     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
663     mapping(uint256 => TokenOwnership) internal _ownerships;
664 
665     // Mapping owner address to address data
666     mapping(address => AddressData) private _addressData;
667 
668     // Mapping from token ID to approved address
669     mapping(uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674     constructor(string memory name_, string memory symbol_) {
675         _name = name_;
676         _symbol = symbol_;
677         _currentIndex = _startTokenId();
678     }
679 
680     /**
681      * To change the starting tokenId, please override this function.
682      */
683     function _startTokenId() internal view virtual returns (uint256) {
684         return 0;
685     }
686 
687     /**
688      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
689      */
690     function totalSupply() public view returns (uint256) {
691         // Counter underflow is impossible as _burnCounter cannot be incremented
692         // more than _currentIndex - _startTokenId() times
693         unchecked {
694             return _currentIndex - _burnCounter - _startTokenId();
695         }
696     }
697 
698     /**
699      * Returns the total amount of tokens minted in the contract.
700      */
701     function _totalMinted() internal view returns (uint256) {
702         // Counter underflow is impossible as _currentIndex does not decrement,
703         // and it is initialized to _startTokenId()
704         unchecked {
705             return _currentIndex - _startTokenId();
706         }
707     }
708 
709     /**
710      * @dev See {IERC165-supportsInterface}.
711      */
712     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
713         return
714             interfaceId == type(IERC721).interfaceId ||
715             interfaceId == type(IERC721Metadata).interfaceId ||
716             super.supportsInterface(interfaceId);
717     }
718 
719     /**
720      * @dev See {IERC721-balanceOf}.
721      */
722     function balanceOf(address owner) public view override returns (uint256) {
723         if (owner == address(0)) revert BalanceQueryForZeroAddress();
724         return uint256(_addressData[owner].balance);
725     }
726 
727     /**
728      * Returns the number of tokens minted by `owner`.
729      */
730     function _numberMinted(address owner) internal view returns (uint256) {
731         return uint256(_addressData[owner].numberMinted);
732     }
733 
734     /**
735      * Returns the number of tokens burned by or on behalf of `owner`.
736      */
737     function _numberBurned(address owner) internal view returns (uint256) {
738         return uint256(_addressData[owner].numberBurned);
739     }
740 
741     /**
742      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
743      */
744     function _getAux(address owner) internal view returns (uint64) {
745         return _addressData[owner].aux;
746     }
747 
748     /**
749      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
750      * If there are multiple variables, please pack them into a uint64.
751      */
752     function _setAux(address owner, uint64 aux) internal {
753         _addressData[owner].aux = aux;
754     }
755 
756     /**
757      * Gas spent here starts off proportional to the maximum mint batch size.
758      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
759      */
760     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
761         uint256 curr = tokenId;
762 
763         unchecked {
764             if (_startTokenId() <= curr && curr < _currentIndex) {
765                 TokenOwnership memory ownership = _ownerships[curr];
766                 if (!ownership.burned) {
767                     if (ownership.addr != address(0)) {
768                         return ownership;
769                     }
770                     // Invariant:
771                     // There will always be an ownership that has an address and is not burned
772                     // before an ownership that does not have an address and is not burned.
773                     // Hence, curr will not underflow.
774                     while (true) {
775                         curr--;
776                         ownership = _ownerships[curr];
777                         if (ownership.addr != address(0)) {
778                             return ownership;
779                         }
780                     }
781                 }
782             }
783         }
784         revert OwnerQueryForNonexistentToken();
785     }
786 
787     /**
788      * @dev See {IERC721-ownerOf}.
789      */
790     function ownerOf(uint256 tokenId) public view override returns (address) {
791         return _ownershipOf(tokenId).addr;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-name}.
796      */
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-symbol}.
803      */
804     function symbol() public view virtual override returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overriden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return '';
825     }
826 
827     /**
828      * @dev See {IERC721-approve}.
829      */
830     function approve(address to, uint256 tokenId) public override {
831         address owner = ERC721A.ownerOf(tokenId);
832         if (to == owner) revert ApprovalToCurrentOwner();
833 
834         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
835             revert ApprovalCallerNotOwnerNorApproved();
836         }
837 
838         _approve(to, tokenId, owner);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId) public view override returns (address) {
845         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
846 
847         return _tokenApprovals[tokenId];
848     }
849 
850     /**
851      * @dev See {IERC721-setApprovalForAll}.
852      */
853     function setApprovalForAll(address operator, bool approved) public virtual override {
854         if (operator == _msgSender()) revert ApproveToCaller();
855 
856         _operatorApprovals[_msgSender()][operator] = approved;
857         emit ApprovalForAll(_msgSender(), operator, approved);
858     }
859 
860     /**
861      * @dev See {IERC721-isApprovedForAll}.
862      */
863     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
864         return _operatorApprovals[owner][operator];
865     }
866 
867     /**
868      * @dev See {IERC721-transferFrom}.
869      */
870     function transferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         _transfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         safeTransferFrom(from, to, tokenId, '');
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) public virtual override {
898         _transfer(from, to, tokenId);
899         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
900             revert TransferToNonERC721ReceiverImplementer();
901         }
902     }
903 
904     /**
905      * @dev Returns whether `tokenId` exists.
906      *
907      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
908      *
909      * Tokens start existing when they are minted (`_mint`),
910      */
911     function _exists(uint256 tokenId) internal view returns (bool) {
912         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
913     }
914 
915     /**
916      * @dev Equivalent to `_safeMint(to, quantity, '')`.
917      */
918     function _safeMint(address to, uint256 quantity) internal {
919         _safeMint(to, quantity, '');
920     }
921 
922     /**
923      * @dev Safely mints `quantity` tokens and transfers them to `to`.
924      *
925      * Requirements:
926      *
927      * - If `to` refers to a smart contract, it must implement 
928      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
929      * - `quantity` must be greater than 0.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _safeMint(
934         address to,
935         uint256 quantity,
936         bytes memory _data
937     ) internal {
938         uint256 startTokenId = _currentIndex;
939         if (to == address(0)) revert MintToZeroAddress();
940         if (quantity == 0) revert MintZeroQuantity();
941 
942         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
943 
944         // Overflows are incredibly unrealistic.
945         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
946         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
947         unchecked {
948             _addressData[to].balance += uint64(quantity);
949             _addressData[to].numberMinted += uint64(quantity);
950 
951             _ownerships[startTokenId].addr = to;
952             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
953 
954             uint256 updatedIndex = startTokenId;
955             uint256 end = updatedIndex + quantity;
956 
957             if (to.isContract()) {
958                 do {
959                     emit Transfer(address(0), to, updatedIndex);
960                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
961                         revert TransferToNonERC721ReceiverImplementer();
962                     }
963                 } while (updatedIndex != end);
964                 // Reentrancy protection
965                 if (_currentIndex != startTokenId) revert();
966             } else {
967                 do {
968                     emit Transfer(address(0), to, updatedIndex++);
969                 } while (updatedIndex != end);
970             }
971             _currentIndex = updatedIndex;
972         }
973         _afterTokenTransfers(address(0), to, startTokenId, quantity);
974     }
975 
976     /**
977      * @dev Mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `quantity` must be greater than 0.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _mint(address to, uint256 quantity) internal {
987         uint256 startTokenId = _currentIndex;
988         if (to == address(0)) revert MintToZeroAddress();
989         if (quantity == 0) revert MintZeroQuantity();
990 
991         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
992 
993         // Overflows are incredibly unrealistic.
994         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
995         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
996         unchecked {
997             _addressData[to].balance += uint64(quantity);
998             _addressData[to].numberMinted += uint64(quantity);
999 
1000             _ownerships[startTokenId].addr = to;
1001             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1002 
1003             uint256 updatedIndex = startTokenId;
1004             uint256 end = updatedIndex + quantity;
1005 
1006             do {
1007                 emit Transfer(address(0), to, updatedIndex++);
1008             } while (updatedIndex != end);
1009 
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
1030         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1031 
1032         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1033 
1034         bool isApprovedOrOwner = (_msgSender() == from ||
1035             isApprovedForAll(from, _msgSender()) ||
1036             getApproved(tokenId) == _msgSender());
1037 
1038         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1039         if (to == address(0)) revert TransferToZeroAddress();
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner
1044         _approve(address(0), tokenId, from);
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1049         unchecked {
1050             _addressData[from].balance -= 1;
1051             _addressData[to].balance += 1;
1052 
1053             TokenOwnership storage currSlot = _ownerships[tokenId];
1054             currSlot.addr = to;
1055             currSlot.startTimestamp = uint64(block.timestamp);
1056 
1057             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1058             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1059             uint256 nextTokenId = tokenId + 1;
1060             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1061             if (nextSlot.addr == address(0)) {
1062                 // This will suffice for checking _exists(nextTokenId),
1063                 // as a burned slot cannot contain the zero address.
1064                 if (nextTokenId != _currentIndex) {
1065                     nextSlot.addr = from;
1066                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1067                 }
1068             }
1069         }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev Equivalent to `_burn(tokenId, false)`.
1077      */
1078     function _burn(uint256 tokenId) internal virtual {
1079         _burn(tokenId, false);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1093         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1094 
1095         address from = prevOwnership.addr;
1096 
1097         if (approvalCheck) {
1098             bool isApprovedOrOwner = (_msgSender() == from ||
1099                 isApprovedForAll(from, _msgSender()) ||
1100                 getApproved(tokenId) == _msgSender());
1101 
1102             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1103         }
1104 
1105         _beforeTokenTransfers(from, address(0), tokenId, 1);
1106 
1107         // Clear approvals from the previous owner
1108         _approve(address(0), tokenId, from);
1109 
1110         // Underflow of the sender's balance is impossible because we check for
1111         // ownership above and the recipient's balance can't realistically overflow.
1112         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1113         unchecked {
1114             AddressData storage addressData = _addressData[from];
1115             addressData.balance -= 1;
1116             addressData.numberBurned += 1;
1117 
1118             // Keep track of who burned the token, and the timestamp of burning.
1119             TokenOwnership storage currSlot = _ownerships[tokenId];
1120             currSlot.addr = from;
1121             currSlot.startTimestamp = uint64(block.timestamp);
1122             currSlot.burned = true;
1123 
1124             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1125             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1126             uint256 nextTokenId = tokenId + 1;
1127             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1128             if (nextSlot.addr == address(0)) {
1129                 // This will suffice for checking _exists(nextTokenId),
1130                 // as a burned slot cannot contain the zero address.
1131                 if (nextTokenId != _currentIndex) {
1132                     nextSlot.addr = from;
1133                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1134                 }
1135             }
1136         }
1137 
1138         emit Transfer(from, address(0), tokenId);
1139         _afterTokenTransfers(from, address(0), tokenId, 1);
1140 
1141         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1142         unchecked {
1143             _burnCounter++;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Approve `to` to operate on `tokenId`
1149      *
1150      * Emits a {Approval} event.
1151      */
1152     function _approve(
1153         address to,
1154         uint256 tokenId,
1155         address owner
1156     ) private {
1157         _tokenApprovals[tokenId] = to;
1158         emit Approval(owner, to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1163      *
1164      * @param from address representing the previous owner of the given token ID
1165      * @param to target address that will receive the tokens
1166      * @param tokenId uint256 ID of the token to be transferred
1167      * @param _data bytes optional data to send along with the call
1168      * @return bool whether the call correctly returned the expected magic value
1169      */
1170     function _checkContractOnERC721Received(
1171         address from,
1172         address to,
1173         uint256 tokenId,
1174         bytes memory _data
1175     ) private returns (bool) {
1176         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1177             return retval == IERC721Receiver(to).onERC721Received.selector;
1178         } catch (bytes memory reason) {
1179             if (reason.length == 0) {
1180                 revert TransferToNonERC721ReceiverImplementer();
1181             } else {
1182                 assembly {
1183                     revert(add(32, reason), mload(reason))
1184                 }
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1191      * And also called before burning one token.
1192      *
1193      * startTokenId - the first token id to be transferred
1194      * quantity - the amount to be transferred
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, `tokenId` will be burned by `from`.
1202      * - `from` and `to` are never both zero.
1203      */
1204     function _beforeTokenTransfers(
1205         address from,
1206         address to,
1207         uint256 startTokenId,
1208         uint256 quantity
1209     ) internal virtual {}
1210 
1211     /**
1212      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1213      * minting.
1214      * And also called after one token has been burned.
1215      *
1216      * startTokenId - the first token id to be transferred
1217      * quantity - the amount to be transferred
1218      *
1219      * Calling conditions:
1220      *
1221      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1222      * transferred to `to`.
1223      * - When `from` is zero, `tokenId` has been minted for `to`.
1224      * - When `to` is zero, `tokenId` has been burned by `from`.
1225      * - `from` and `to` are never both zero.
1226      */
1227     function _afterTokenTransfers(
1228         address from,
1229         address to,
1230         uint256 startTokenId,
1231         uint256 quantity
1232     ) internal virtual {}
1233 }
1234 // File: @openzeppelin/contracts/access/Ownable.sol
1235 
1236 
1237 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 
1242 /**
1243  * @dev Contract module which provides a basic access control mechanism, where
1244  * there is an account (an owner) that can be granted exclusive access to
1245  * specific functions.
1246  *
1247  * By default, the owner account will be the one that deploys the contract. This
1248  * can later be changed with {transferOwnership}.
1249  *
1250  * This module is used through inheritance. It will make available the modifier
1251  * `onlyOwner`, which can be applied to your functions to restrict their use to
1252  * the owner.
1253  */
1254 abstract contract Ownable is Context {
1255     address private _owner;
1256 
1257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1258 
1259     /**
1260      * @dev Initializes the contract setting the deployer as the initial owner.
1261      */
1262     constructor() {
1263         _transferOwnership(_msgSender());
1264     }
1265 
1266     /**
1267      * @dev Returns the address of the current owner.
1268      */
1269     function owner() public view virtual returns (address) {
1270         return _owner;
1271     }
1272 
1273     /**
1274      * @dev Throws if called by any account other than the owner.
1275      */
1276     modifier onlyOwner() {
1277         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1278         _;
1279     }
1280 
1281     /**
1282      * @dev Leaves the contract without owner. It will not be possible to call
1283      * `onlyOwner` functions anymore. Can only be called by the current owner.
1284      *
1285      * NOTE: Renouncing ownership will leave the contract without an owner,
1286      * thereby removing any functionality that is only available to the owner.
1287      */
1288     function renounceOwnership() public virtual onlyOwner {
1289         _transferOwnership(address(0));
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Can only be called by the current owner.
1295      */
1296     function transferOwnership(address newOwner) public virtual onlyOwner {
1297         require(newOwner != address(0), "Ownable: new owner is the zero address");
1298         _transferOwnership(newOwner);
1299     }
1300 
1301     /**
1302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1303      * Internal function without access restriction.
1304      */
1305     function _transferOwnership(address newOwner) internal virtual {
1306         address oldOwner = _owner;
1307         _owner = newOwner;
1308         emit OwnershipTransferred(oldOwner, newOwner);
1309     }
1310 }
1311 
1312 // File: franks.sol
1313 
1314 
1315 
1316 pragma solidity ^0.8.7;
1317 
1318 
1319 
1320 contract KYC is ERC721A, Ownable {
1321 
1322     string public baseURI = "ipfs://QmWJ1e56BPqnZkbswsFp6EhRaqHgkG8HkAobTHmKYSSh8r/";
1323     uint256 public constant MAX_SUPPLY = 2222;
1324     uint256 public MINT_PRICE = 0.0029 ether;
1325     uint256 public constant MAX_PER_TX_FREE = 3;
1326     uint256 public constant MAX_PER_TX_PAID = 10;
1327     uint256 public constant FREE_AMOUNT = 500;
1328 
1329     constructor() ERC721A("KYC", "KYC") {
1330     }
1331 
1332   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1333         require(_exists(_tokenId), "Token does not exist.");
1334         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), ".json"));
1335     }
1336 
1337     function setBaseURI(string memory _baseURI) external onlyOwner {
1338         baseURI = _baseURI;
1339     }
1340 
1341     function setMintPrice(uint256 _price) external onlyOwner {
1342         MINT_PRICE = _price;
1343     }
1344 
1345     function publicMint(uint256 count) external payable {
1346         require(totalSupply() + count <= MAX_SUPPLY, "Excedes max supply.");
1347         require(totalSupply() + count > FREE_AMOUNT ? count <= MAX_PER_TX_PAID : count <= MAX_PER_TX_FREE, "Exceeds max per transaction.");
1348         if (msg.sender != owner() && (totalSupply() > FREE_AMOUNT)) {
1349             require(msg.value >= count * MINT_PRICE, "Amount sent less than the cost of minting NFT(s)");
1350         }
1351         _safeMint(_msgSender(), count);
1352     }
1353 
1354     function withdrawMoney() external onlyOwner {
1355         (bool success, ) = _msgSender().call{value: address(this).balance}("");
1356         require(success, "Transfer failed.");
1357     }
1358 }