1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract ReentrancyGuard {
6 
7     uint256 private constant _NOT_ENTERED = 1;
8     uint256 private constant _ENTERED = 2;
9 
10     uint256 private _status;
11 
12     constructor() {
13         _status = _NOT_ENTERED;
14     }
15 
16 
17     modifier nonReentrant() {
18 
19         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
20 
21         _status = _ENTERED;
22 
23         _;
24         _status = _NOT_ENTERED;
25     }
26 }
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35 
36     function toString(uint256 value) internal pure returns (string memory) {
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56 
57     function toHexString(uint256 value) internal pure returns (string memory) {
58         if (value == 0) {
59             return "0x00";
60         }
61         uint256 temp = value;
62         uint256 length = 0;
63         while (temp != 0) {
64             length++;
65             temp >>= 8;
66         }
67         return toHexString(value, length);
68     }
69 
70 
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 pragma solidity ^0.8.0;
85 
86 
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 
100 
101 abstract contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor() {
107         _transferOwnership(_msgSender());
108     }
109 
110     function owner() public view virtual returns (address) {
111         return _owner;
112     }
113 
114     modifier onlyOwner() {
115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119 
120     function renounceOwnership() public virtual onlyOwner {
121         _transferOwnership(address(0));
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Can only be called by the current owner.
127      */
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
135      * Internal function without access restriction.
136      */
137     function _transferOwnership(address newOwner) internal virtual {
138         address oldOwner = _owner;
139         _owner = newOwner;
140         emit OwnershipTransferred(oldOwner, newOwner);
141     }
142 }
143 
144 // File: @openzeppelin/contracts/utils/Address.sol
145 
146 
147 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
148 
149 pragma solidity ^0.8.1;
150 
151 /**
152  * @dev Collection of functions related to the address type
153  */
154 library Address {
155     /**
156      * @dev Returns true if `account` is a contract.
157      *
158      * [IMPORTANT]
159      * ====
160      * It is unsafe to assume that an address for which this function returns
161      * false is an externally-owned account (EOA) and not a contract.
162      *
163      * Among others, `isContract` will return false for the following
164      * types of addresses:
165      *
166      *  - an externally-owned account
167      *  - a contract in construction
168      *  - an address where a contract will be created
169      *  - an address where a contract lived, but was destroyed
170      * ====
171      *
172      * [IMPORTANT]
173      * ====
174      * You shouldn't rely on `isContract` to protect against flash loan attacks!
175      *
176      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
177      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
178      * constructor.
179      * ====
180      */
181     function isContract(address account) internal view returns (bool) {
182         // This method relies on extcodesize/address.code.length, which returns 0
183         // for contracts in construction, since the code is only stored at the end
184         // of the constructor execution.
185 
186         return account.code.length > 0;
187     }
188 
189     /**
190      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
191      * `recipient`, forwarding all available gas and reverting on errors.
192      *
193      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
194      * of certain opcodes, possibly making contracts go over the 2300 gas limit
195      * imposed by `transfer`, making them unable to receive funds via
196      * `transfer`. {sendValue} removes this limitation.
197      *
198      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
199      *
200      * IMPORTANT: because control is transferred to `recipient`, care must be
201      * taken to not create reentrancy vulnerabilities. Consider using
202      * {ReentrancyGuard} or the
203      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
204      */
205     function sendValue(address payable recipient, uint256 amount) internal {
206         require(address(this).balance >= amount, "Address: insufficient balance");
207 
208         (bool success, ) = recipient.call{value: amount}("");
209         require(success, "Address: unable to send value, recipient may have reverted");
210     }
211 
212     /**
213      * @dev Performs a Solidity function call using a low level `call`. A
214      * plain `call` is an unsafe replacement for a function call: use this
215      * function instead.
216      *
217      * If `target` reverts with a revert reason, it is bubbled up by this
218      * function (like regular Solidity function calls).
219      *
220      * Returns the raw returned data. To convert to the expected return value,
221      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
222      *
223      * Requirements:
224      *
225      * - `target` must be a contract.
226      * - calling `target` with `data` must not revert.
227      *
228      * _Available since v3.1._
229      */
230     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
231         return functionCall(target, data, "Address: low-level call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
236      * `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, 0, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but also transferring `value` wei to `target`.
251      *
252      * Requirements:
253      *
254      * - the calling contract must have an ETH balance of at least `value`.
255      * - the called Solidity function must be `payable`.
256      *
257      * _Available since v3.1._
258      */
259     function functionCallWithValue(
260         address target,
261         bytes memory data,
262         uint256 value
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
269      * with `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCallWithValue(
274         address target,
275         bytes memory data,
276         uint256 value,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(address(this).balance >= value, "Address: insufficient balance for call");
280         require(isContract(target), "Address: call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.call{value: value}(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
293         return functionStaticCall(target, data, "Address: low-level static call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
298      * but performing a static call.
299      *
300      * _Available since v3.3._
301      */
302     function functionStaticCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal view returns (bytes memory) {
307         require(isContract(target), "Address: static call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.staticcall(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.4._
318      */
319     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a delegate call.
326      *
327      * _Available since v3.4._
328      */
329     function functionDelegateCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         require(isContract(target), "Address: delegate call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.delegatecall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
342      * revert reason using the provided one.
343      *
344      * _Available since v4.3._
345      */
346     function verifyCallResult(
347         bool success,
348         bytes memory returndata,
349         string memory errorMessage
350     ) internal pure returns (bytes memory) {
351         if (success) {
352             return returndata;
353         } else {
354             // Look for revert reason and bubble it up if present
355             if (returndata.length > 0) {
356                 // The easiest way to bubble the revert reason is using memory via assembly
357 
358                 assembly {
359                     let returndata_size := mload(returndata)
360                     revert(add(32, returndata), returndata_size)
361                 }
362             } else {
363                 revert(errorMessage);
364             }
365         }
366     }
367 }
368 
369 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @title ERC721 token receiver interface
378  * @dev Interface for any contract that wants to support safeTransfers
379  * from ERC721 asset contracts.
380  */
381 interface IERC721Receiver {
382     /**
383      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
384      * by `operator` from `from`, this function is called.
385      *
386      * It must return its Solidity selector to confirm the token transfer.
387      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
388      *
389      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
390      */
391     function onERC721Received(
392         address operator,
393         address from,
394         uint256 tokenId,
395         bytes calldata data
396     ) external returns (bytes4);
397 }
398 
399 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @dev Interface of the ERC165 standard, as defined in the
408  * https://eips.ethereum.org/EIPS/eip-165[EIP].
409  *
410  * Implementers can declare support of contract interfaces, which can then be
411  * queried by others ({ERC165Checker}).
412  *
413  * For an implementation, see {ERC165}.
414  */
415 interface IERC165 {
416     /**
417      * @dev Returns true if this contract implements the interface defined by
418      * `interfaceId`. See the corresponding
419      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
420      * to learn more about how these ids are created.
421      *
422      * This function call must use less than 30 000 gas.
423      */
424     function supportsInterface(bytes4 interfaceId) external view returns (bool);
425 }
426 
427 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 
435 /**
436  * @dev Implementation of the {IERC165} interface.
437  *
438  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
439  * for the additional interface id that will be supported. For example:
440  *
441  * ```solidity
442  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
443  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
444  * }
445  * ```
446  *
447  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
448  */
449 abstract contract ERC165 is IERC165 {
450     /**
451      * @dev See {IERC165-supportsInterface}.
452      */
453     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
454         return interfaceId == type(IERC165).interfaceId;
455     }
456 }
457 
458 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 
466 /**
467  * @dev Required interface of an ERC721 compliant contract.
468  */
469 interface IERC721 is IERC165 {
470     /**
471      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
472      */
473     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
474 
475     /**
476      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
477      */
478     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
479 
480     /**
481      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
482      */
483     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
484 
485     /**
486      * @dev Returns the number of tokens in ``owner``'s account.
487      */
488     function balanceOf(address owner) external view returns (uint256 balance);
489 
490     /**
491      * @dev Returns the owner of the `tokenId` token.
492      *
493      * Requirements:
494      *
495      * - `tokenId` must exist.
496      */
497     function ownerOf(uint256 tokenId) external view returns (address owner);
498 
499     /**
500      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
501      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must exist and be owned by `from`.
508      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
510      *
511      * Emits a {Transfer} event.
512      */
513     function safeTransferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external;
518 
519     /**
520      * @dev Transfers `tokenId` token from `from` to `to`.
521      *
522      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
523      *
524      * Requirements:
525      *
526      * - `from` cannot be the zero address.
527      * - `to` cannot be the zero address.
528      * - `tokenId` token must be owned by `from`.
529      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
530      *
531      * Emits a {Transfer} event.
532      */
533     function transferFrom(
534         address from,
535         address to,
536         uint256 tokenId
537     ) external;
538 
539     /**
540      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
541      * The approval is cleared when the token is transferred.
542      *
543      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
544      *
545      * Requirements:
546      *
547      * - The caller must own the token or be an approved operator.
548      * - `tokenId` must exist.
549      *
550      * Emits an {Approval} event.
551      */
552     function approve(address to, uint256 tokenId) external;
553 
554     /**
555      * @dev Returns the account approved for `tokenId` token.
556      *
557      * Requirements:
558      *
559      * - `tokenId` must exist.
560      */
561     function getApproved(uint256 tokenId) external view returns (address operator);
562 
563     /**
564      * @dev Approve or remove `operator` as an operator for the caller.
565      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
566      *
567      * Requirements:
568      *
569      * - The `operator` cannot be the caller.
570      *
571      * Emits an {ApprovalForAll} event.
572      */
573     function setApprovalForAll(address operator, bool _approved) external;
574 
575     /**
576      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
577      *
578      * See {setApprovalForAll}
579      */
580     function isApprovedForAll(address owner, address operator) external view returns (bool);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId,
599         bytes calldata data
600     ) external;
601 }
602 
603 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 
611 /**
612  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
613  * @dev See https://eips.ethereum.org/EIPS/eip-721
614  */
615 interface IERC721Metadata is IERC721 {
616     /**
617      * @dev Returns the token collection name.
618      */
619     function name() external view returns (string memory);
620 
621     /**
622      * @dev Returns the token collection symbol.
623      */
624     function symbol() external view returns (string memory);
625 
626     /**
627      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
628      */
629     function tokenURI(uint256 tokenId) external view returns (string memory);
630 }
631 
632 // File: contracts/ERC721A.sol
633 
634 
635 // Creator: Chiru Labs
636 
637 pragma solidity ^0.8.4;
638 
639 
640 
641 
642 
643 
644 
645 
646 error ApprovalCallerNotOwnerNorApproved();
647 error ApprovalQueryForNonexistentToken();
648 error ApproveToCaller();
649 error ApprovalToCurrentOwner();
650 error BalanceQueryForZeroAddress();
651 error MintToZeroAddress();
652 error MintZeroQuantity();
653 error OwnerQueryForNonexistentToken();
654 error TransferCallerNotOwnerNorApproved();
655 error TransferFromIncorrectOwner();
656 error TransferToNonERC721ReceiverImplementer();
657 error TransferToZeroAddress();
658 error URIQueryForNonexistentToken();
659 
660 /**
661  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
662  * the Metadata extension. Built to optimize for lower gas during batch mints.
663  *
664  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
665  *
666  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
667  *
668  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
669  */
670 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
671     using Address for address;
672     using Strings for uint256;
673 
674     // Compiler will pack this into a single 256bit word.
675     struct TokenOwnership {
676         // The address of the owner.
677         address addr;
678         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
679         uint64 startTimestamp;
680         // Whether the token has been burned.
681         bool burned;
682     }
683 
684     // Compiler will pack this into a single 256bit word.
685     struct AddressData {
686         // Realistically, 2**64-1 is more than enough.
687         uint64 balance;
688         // Keeps track of mint count with minimal overhead for tokenomics.
689         uint64 numberMinted;
690         // Keeps track of burn count with minimal overhead for tokenomics.
691         uint64 numberBurned;
692         // For miscellaneous variable(s) pertaining to the address
693         // (e.g. number of whitelist mint slots used).
694         // If there are multiple variables, please pack them into a uint64.
695         uint64 aux;
696     }
697 
698     // The tokenId of the next token to be minted.
699     uint256 internal _currentIndex;
700 
701     // The number of tokens burned.
702     uint256 internal _burnCounter;
703 
704     // Token name
705     string private _name;
706 
707     // Token symbol
708     string private _symbol;
709 
710     // Mapping from token ID to ownership details
711     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
712     mapping(uint256 => TokenOwnership) internal _ownerships;
713 
714     // Mapping owner address to address data
715     mapping(address => AddressData) private _addressData;
716 
717     // Mapping from token ID to approved address
718     mapping(uint256 => address) private _tokenApprovals;
719 
720     // Mapping from owner to operator approvals
721     mapping(address => mapping(address => bool)) private _operatorApprovals;
722 
723     constructor(string memory name_, string memory symbol_) {
724         _name = name_;
725         _symbol = symbol_;
726         _currentIndex = _startTokenId();
727     }
728 
729     /**
730      * To change the starting tokenId, please override this function.
731      */
732     function _startTokenId() internal view virtual returns (uint256) {
733         return 1;
734     }
735 
736     /**
737      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
738      */
739     function totalSupply() public view returns (uint256) {
740         // Counter underflow is impossible as _burnCounter cannot be incremented
741         // more than _currentIndex - _startTokenId() times
742         unchecked {
743             return _currentIndex - _burnCounter - _startTokenId();
744         }
745     }
746 
747     /**
748      * Returns the total amount of tokens minted in the contract.
749      */
750     function _totalMinted() internal view returns (uint256) {
751         // Counter underflow is impossible as _currentIndex does not decrement,
752         // and it is initialized to _startTokenId()
753         unchecked {
754             return _currentIndex - _startTokenId();
755         }
756     }
757 
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
762         return
763             interfaceId == type(IERC721).interfaceId ||
764             interfaceId == type(IERC721Metadata).interfaceId ||
765             super.supportsInterface(interfaceId);
766     }
767 
768     /**
769      * @dev See {IERC721-balanceOf}.
770      */
771     function balanceOf(address owner) public view override returns (uint256) {
772         if (owner == address(0)) revert BalanceQueryForZeroAddress();
773         return uint256(_addressData[owner].balance);
774     }
775 
776     /**
777      * Returns the number of tokens minted by `owner`.
778      */
779     function _numberMinted(address owner) internal view returns (uint256) {
780         return uint256(_addressData[owner].numberMinted);
781     }
782 
783     /**
784      * Returns the number of tokens burned by or on behalf of `owner`.
785      */
786     function _numberBurned(address owner) internal view returns (uint256) {
787         return uint256(_addressData[owner].numberBurned);
788     }
789 
790     /**
791      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
792      */
793     function _getAux(address owner) internal view returns (uint64) {
794         return _addressData[owner].aux;
795     }
796 
797     /**
798      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
799      * If there are multiple variables, please pack them into a uint64.
800      */
801     function _setAux(address owner, uint64 aux) internal {
802         _addressData[owner].aux = aux;
803     }
804 
805     /**
806      * Gas spent here starts off proportional to the maximum mint batch size.
807      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
808      */
809     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
810         uint256 curr = tokenId;
811 
812         unchecked {
813             if (_startTokenId() <= curr && curr < _currentIndex) {
814                 TokenOwnership memory ownership = _ownerships[curr];
815                 if (!ownership.burned) {
816                     if (ownership.addr != address(0)) {
817                         return ownership;
818                     }
819                     // Invariant:
820                     // There will always be an ownership that has an address and is not burned
821                     // before an ownership that does not have an address and is not burned.
822                     // Hence, curr will not underflow.
823                     while (true) {
824                         curr--;
825                         ownership = _ownerships[curr];
826                         if (ownership.addr != address(0)) {
827                             return ownership;
828                         }
829                     }
830                 }
831             }
832         }
833         revert OwnerQueryForNonexistentToken();
834     }
835 
836     /**
837      * @dev See {IERC721-ownerOf}.
838      */
839     function ownerOf(uint256 tokenId) public view override returns (address) {
840         return _ownershipOf(tokenId).addr;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-name}.
845      */
846     function name() public view virtual override returns (string memory) {
847         return _name;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-symbol}.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-tokenURI}.
859      */
860     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
861         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
862 
863         string memory baseURI = _baseURI();
864         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
865     }
866 
867     /**
868      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
869      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
870      * by default, can be overriden in child contracts.
871      */
872     function _baseURI() internal view virtual returns (string memory) {
873         return '';
874     }
875 
876     /**
877      * @dev See {IERC721-approve}.
878      */
879     function approve(address to, uint256 tokenId) public override {
880         address owner = ERC721A.ownerOf(tokenId);
881         if (to == owner) revert ApprovalToCurrentOwner();
882 
883         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
884             revert ApprovalCallerNotOwnerNorApproved();
885         }
886 
887         _approve(to, tokenId, owner);
888     }
889 
890     /**
891      * @dev See {IERC721-getApproved}.
892      */
893     function getApproved(uint256 tokenId) public view override returns (address) {
894         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
895 
896         return _tokenApprovals[tokenId];
897     }
898 
899     /**
900      * @dev See {IERC721-setApprovalForAll}.
901      */
902     function setApprovalForAll(address operator, bool approved) public virtual override {
903         if (operator == _msgSender()) revert ApproveToCaller();
904 
905         _operatorApprovals[_msgSender()][operator] = approved;
906         emit ApprovalForAll(_msgSender(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public virtual override {
924         _transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         safeTransferFrom(from, to, tokenId, '');
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public virtual override {
947         _transfer(from, to, tokenId);
948         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
949             revert TransferToNonERC721ReceiverImplementer();
950         }
951     }
952 
953     /**
954      * @dev Returns whether `tokenId` exists.
955      *
956      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
957      *
958      * Tokens start existing when they are minted (`_mint`),
959      */
960     function _exists(uint256 tokenId) internal view returns (bool) {
961         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
962     }
963 
964     /**
965      * @dev Equivalent to `_safeMint(to, quantity, '')`.
966      */
967     function _safeMint(address to, uint256 quantity) internal {
968         _safeMint(to, quantity, '');
969     }
970 
971     /**
972      * @dev Safely mints `quantity` tokens and transfers them to `to`.
973      *
974      * Requirements:
975      *
976      * - If `to` refers to a smart contract, it must implement 
977      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
978      * - `quantity` must be greater than 0.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _safeMint(
983         address to,
984         uint256 quantity,
985         bytes memory _data
986     ) internal {
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
1006             if (to.isContract()) {
1007                 do {
1008                     emit Transfer(address(0), to, updatedIndex);
1009                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1010                         revert TransferToNonERC721ReceiverImplementer();
1011                     }
1012                 } while (updatedIndex != end);
1013                 // Reentrancy protection
1014                 if (_currentIndex != startTokenId) revert();
1015             } else {
1016                 do {
1017                     emit Transfer(address(0), to, updatedIndex++);
1018                 } while (updatedIndex != end);
1019             }
1020             _currentIndex = updatedIndex;
1021         }
1022         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1023     }
1024 
1025     /**
1026      * @dev Mints `quantity` tokens and transfers them to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `quantity` must be greater than 0.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _mint(address to, uint256 quantity) internal {
1036         uint256 startTokenId = _currentIndex;
1037         if (to == address(0)) revert MintToZeroAddress();
1038         if (quantity == 0) revert MintZeroQuantity();
1039 
1040         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042         // Overflows are incredibly unrealistic.
1043         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1044         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1045         unchecked {
1046             _addressData[to].balance += uint64(quantity);
1047             _addressData[to].numberMinted += uint64(quantity);
1048 
1049             _ownerships[startTokenId].addr = to;
1050             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1051 
1052             uint256 updatedIndex = startTokenId;
1053             uint256 end = updatedIndex + quantity;
1054 
1055             do {
1056                 emit Transfer(address(0), to, updatedIndex++);
1057             } while (updatedIndex != end);
1058 
1059             _currentIndex = updatedIndex;
1060         }
1061         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1062     }
1063 
1064     /**
1065      * @dev Transfers `tokenId` from `from` to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must be owned by `from`.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) private {
1079         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1080 
1081         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1082 
1083         bool isApprovedOrOwner = (_msgSender() == from ||
1084             isApprovedForAll(from, _msgSender()) ||
1085             getApproved(tokenId) == _msgSender());
1086 
1087         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1088         if (to == address(0)) revert TransferToZeroAddress();
1089 
1090         _beforeTokenTransfers(from, to, tokenId, 1);
1091 
1092         // Clear approvals from the previous owner
1093         _approve(address(0), tokenId, from);
1094 
1095         // Underflow of the sender's balance is impossible because we check for
1096         // ownership above and the recipient's balance can't realistically overflow.
1097         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1098         unchecked {
1099             _addressData[from].balance -= 1;
1100             _addressData[to].balance += 1;
1101 
1102             TokenOwnership storage currSlot = _ownerships[tokenId];
1103             currSlot.addr = to;
1104             currSlot.startTimestamp = uint64(block.timestamp);
1105 
1106             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
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
1120         emit Transfer(from, to, tokenId);
1121         _afterTokenTransfers(from, to, tokenId, 1);
1122     }
1123 
1124     /**
1125      * @dev Equivalent to `_burn(tokenId, false)`.
1126      */
1127     function _burn(uint256 tokenId) internal virtual {
1128         _burn(tokenId, false);
1129     }
1130 
1131     /**
1132      * @dev Destroys `tokenId`.
1133      * The approval is cleared when the token is burned.
1134      *
1135      * Requirements:
1136      *
1137      * - `tokenId` must exist.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1142         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1143 
1144         address from = prevOwnership.addr;
1145 
1146         if (approvalCheck) {
1147             bool isApprovedOrOwner = (_msgSender() == from ||
1148                 isApprovedForAll(from, _msgSender()) ||
1149                 getApproved(tokenId) == _msgSender());
1150 
1151             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1152         }
1153 
1154         _beforeTokenTransfers(from, address(0), tokenId, 1);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId, from);
1158 
1159         // Underflow of the sender's balance is impossible because we check for
1160         // ownership above and the recipient's balance can't realistically overflow.
1161         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1162         unchecked {
1163             AddressData storage addressData = _addressData[from];
1164             addressData.balance -= 1;
1165             addressData.numberBurned += 1;
1166 
1167             // Keep track of who burned the token, and the timestamp of burning.
1168             TokenOwnership storage currSlot = _ownerships[tokenId];
1169             currSlot.addr = from;
1170             currSlot.startTimestamp = uint64(block.timestamp);
1171             currSlot.burned = true;
1172 
1173             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1174             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1175             uint256 nextTokenId = tokenId + 1;
1176             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1177             if (nextSlot.addr == address(0)) {
1178                 // This will suffice for checking _exists(nextTokenId),
1179                 // as a burned slot cannot contain the zero address.
1180                 if (nextTokenId != _currentIndex) {
1181                     nextSlot.addr = from;
1182                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1183                 }
1184             }
1185         }
1186 
1187         emit Transfer(from, address(0), tokenId);
1188         _afterTokenTransfers(from, address(0), tokenId, 1);
1189 
1190         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1191         unchecked {
1192             _burnCounter++;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Approve `to` to operate on `tokenId`
1198      *
1199      * Emits a {Approval} event.
1200      */
1201     function _approve(
1202         address to,
1203         uint256 tokenId,
1204         address owner
1205     ) private {
1206         _tokenApprovals[tokenId] = to;
1207         emit Approval(owner, to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1212      *
1213      * @param from address representing the previous owner of the given token ID
1214      * @param to target address that will receive the tokens
1215      * @param tokenId uint256 ID of the token to be transferred
1216      * @param _data bytes optional data to send along with the call
1217      * @return bool whether the call correctly returned the expected magic value
1218      */
1219     function _checkContractOnERC721Received(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) private returns (bool) {
1225         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1226             return retval == IERC721Receiver(to).onERC721Received.selector;
1227         } catch (bytes memory reason) {
1228             if (reason.length == 0) {
1229                 revert TransferToNonERC721ReceiverImplementer();
1230             } else {
1231                 assembly {
1232                     revert(add(32, reason), mload(reason))
1233                 }
1234             }
1235         }
1236     }
1237 
1238     /**
1239      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1240      * And also called before burning one token.
1241      *
1242      * startTokenId - the first token id to be transferred
1243      * quantity - the amount to be transferred
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      * - When `to` is zero, `tokenId` will be burned by `from`.
1251      * - `from` and `to` are never both zero.
1252      */
1253     function _beforeTokenTransfers(
1254         address from,
1255         address to,
1256         uint256 startTokenId,
1257         uint256 quantity
1258     ) internal virtual {}
1259 
1260     /**
1261      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1262      * minting.
1263      * And also called after one token has been burned.
1264      *
1265      * startTokenId - the first token id to be transferred
1266      * quantity - the amount to be transferred
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` has been minted for `to`.
1273      * - When `to` is zero, `tokenId` has been burned by `from`.
1274      * - `from` and `to` are never both zero.
1275      */
1276     function _afterTokenTransfers(
1277         address from,
1278         address to,
1279         uint256 startTokenId,
1280         uint256 quantity
1281     ) internal virtual {}
1282 }
1283 
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 
1288 
1289 
1290 
1291 contract GoblinWorld is ERC721A, Ownable, ReentrancyGuard {
1292   using Address for address;
1293   using Strings for uint;
1294 
1295 
1296   string  public  baseTokenURI = "ipfs://QmdKcDHDoB7uNdWyAWZTgqiEaUv3yZ6p7mb5U6B6Vn2ijL/";
1297   uint256  public  maxSupply = 1000;
1298   uint256 public  MAX_MINTS_PER_TX = 20;
1299   uint256 public  PUBLIC_SALE_PRICE = 0.001 ether;
1300   uint256 public  NUM_FREE_MINTS = 300;
1301   uint256 public  MAX_FREE_PER_WALLET = 1;
1302   uint256 public freeNFTAlreadyMinted = 0;
1303   bool public isPublicSaleActive = false;
1304 
1305   constructor(
1306 
1307   ) ERC721A("Goblin World", "GW") {
1308 
1309   }
1310 
1311 
1312   function mint(uint256 numberOfTokens)
1313       external
1314       payable
1315   {
1316     require(isPublicSaleActive, "Public sale is not open");
1317     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1318 
1319     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1320         require(
1321             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1322             "Incorrect ETH value sent"
1323         );
1324     } else {
1325         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1326         require(
1327             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value || msg.sender == owner(),
1328             "Incorrect ETH value sent"
1329         );
1330         require(
1331             numberOfTokens <= MAX_MINTS_PER_TX,
1332             "Max mints per transaction exceeded"
1333         );
1334         } else {
1335             require(
1336                 numberOfTokens <= MAX_FREE_PER_WALLET,
1337                 "Max mints per transaction exceeded"
1338             );
1339             freeNFTAlreadyMinted += numberOfTokens;
1340         }
1341     }
1342     _safeMint(msg.sender, numberOfTokens);
1343   }
1344 
1345   function setBaseURI(string memory baseURI)
1346     public
1347     onlyOwner
1348   {
1349     baseTokenURI = baseURI;
1350   }
1351 
1352   function treasuryMint(uint quantity)
1353     public
1354     onlyOwner
1355   {
1356     require(
1357       quantity > 0,
1358       "Invalid mint amount"
1359     );
1360     require(
1361       totalSupply() + quantity <= maxSupply,
1362       "Maximum supply exceeded"
1363     );
1364     _safeMint(msg.sender, quantity);
1365   }
1366 
1367   function withdraw()
1368     public
1369     onlyOwner
1370     nonReentrant
1371   {
1372     Address.sendValue(payable(msg.sender), address(this).balance);
1373   }
1374 
1375   function tokenURI(uint _tokenId)
1376     public
1377     view
1378     virtual
1379     override
1380     returns (string memory)
1381   {
1382     require(
1383       _exists(_tokenId),
1384       "ERC721Metadata: URI query for nonexistent token"
1385     );
1386     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1387   }
1388 
1389   function _baseURI()
1390     internal
1391     view
1392     virtual
1393     override
1394     returns (string memory)
1395   {
1396     return baseTokenURI;
1397   }
1398 
1399   function setIsPublicSaleActive(bool _isPublicSaleActive)
1400       external
1401       onlyOwner
1402   {
1403       isPublicSaleActive = _isPublicSaleActive;
1404   }
1405 
1406   function setNumFreeMints(uint256 _numfreemints)
1407       external
1408       onlyOwner
1409   {
1410       NUM_FREE_MINTS = _numfreemints;
1411   }
1412 
1413   function setSalePrice(uint256 _price)
1414       external
1415       onlyOwner
1416   {
1417       PUBLIC_SALE_PRICE = _price;
1418   }
1419 
1420   function setMaxLimitPerTransaction(uint256 _limit)
1421       external
1422       onlyOwner
1423   {
1424       MAX_MINTS_PER_TX = _limit;
1425   }
1426 
1427   function setFreeLimitPerWallet(uint256 _limit)
1428       external
1429       onlyOwner
1430   {
1431       MAX_FREE_PER_WALLET = _limit;
1432   }
1433 }