1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
3 
4 pragma solidity ^0.8.1;
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      *
27      * [IMPORTANT]
28      * ====
29      * You shouldn't rely on `isContract` to protect against flash loan attacks!
30      *
31      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
32      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
33      * constructor.
34      * ====
35      */
36     function isContract(address account) internal view returns (bool) {
37         // This method relies on extcodesize/address.code.length, which returns 0
38         // for contracts in construction, since the code is only stored at the end
39         // of the constructor execution.
40 
41         return account.code.length > 0;
42     }
43 
44     /**
45      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
46      * `recipient`, forwarding all available gas and reverting on errors.
47      *
48      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
49      * of certain opcodes, possibly making contracts go over the 2300 gas limit
50      * imposed by `transfer`, making them unable to receive funds via
51      * `transfer`. {sendValue} removes this limitation.
52      *
53      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
54      *
55      * IMPORTANT: because control is transferred to `recipient`, care must be
56      * taken to not create reentrancy vulnerabilities. Consider using
57      * {ReentrancyGuard} or the
58      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
59      */
60     function sendValue(address payable recipient, uint256 amount) internal {
61         require(address(this).balance >= amount, "Address: insufficient balance");
62 
63         (bool success, ) = recipient.call{value: amount}("");
64         require(success, "Address: unable to send value, recipient may have reverted");
65     }
66 
67     /**
68      * @dev Performs a Solidity function call using a low level `call`. A
69      * plain `call` is an unsafe replacement for a function call: use this
70      * function instead.
71      *
72      * If `target` reverts with a revert reason, it is bubbled up by this
73      * function (like regular Solidity function calls).
74      *
75      * Returns the raw returned data. To convert to the expected return value,
76      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
77      *
78      * Requirements:
79      *
80      * - `target` must be a contract.
81      * - calling `target` with `data` must not revert.
82      *
83      * _Available since v3.1._
84      */
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86         return functionCall(target, data, "Address: low-level call failed");
87     }
88 
89     /**
90      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
91      * `errorMessage` as a fallback revert reason when `target` reverts.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(
96         address target,
97         bytes memory data,
98         string memory errorMessage
99     ) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
105      * but also transferring `value` wei to `target`.
106      *
107      * Requirements:
108      *
109      * - the calling contract must have an ETH balance of at least `value`.
110      * - the called Solidity function must be `payable`.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(
115         address target,
116         bytes memory data,
117         uint256 value
118     ) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
124      * with `errorMessage` as a fallback revert reason when `target` reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         require(address(this).balance >= value, "Address: insufficient balance for call");
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return verifyCallResult(success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         require(isContract(target), "Address: static call to non-contract");
163 
164         (bool success, bytes memory returndata) = target.staticcall(data);
165         return verifyCallResult(success, returndata, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but performing a delegate call.
171      *
172      * _Available since v3.4._
173      */
174     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
180      * but performing a delegate call.
181      *
182      * _Available since v3.4._
183      */
184     function functionDelegateCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         require(isContract(target), "Address: delegate call to non-contract");
190 
191         (bool success, bytes memory returndata) = target.delegatecall(data);
192         return verifyCallResult(success, returndata, errorMessage);
193     }
194 
195     /**
196      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
197      * revert reason using the provided one.
198      *
199      * _Available since v4.3._
200      */
201     function verifyCallResult(
202         bool success,
203         bytes memory returndata,
204         string memory errorMessage
205     ) internal pure returns (bytes memory) {
206         if (success) {
207             return returndata;
208         } else {
209             // Look for revert reason and bubble it up if present
210             if (returndata.length > 0) {
211                 // The easiest way to bubble the revert reason is using memory via assembly
212 
213                 assembly {
214                     let returndata_size := mload(returndata)
215                     revert(add(32, returndata), returndata_size)
216                 }
217             } else {
218                 revert(errorMessage);
219             }
220         }
221     }
222 }
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248 
249 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev String operations.
255  */
256 library Strings {
257     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
261      */
262     function toString(uint256 value) internal pure returns (string memory) {
263         // Inspired by OraclizeAPI's implementation - MIT licence
264         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
265 
266         if (value == 0) {
267             return "0";
268         }
269         uint256 temp = value;
270         uint256 digits;
271         while (temp != 0) {
272             digits++;
273             temp /= 10;
274         }
275         bytes memory buffer = new bytes(digits);
276         while (value != 0) {
277             digits -= 1;
278             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
279             value /= 10;
280         }
281         return string(buffer);
282     }
283 
284     /**
285      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
286      */
287     function toHexString(uint256 value) internal pure returns (string memory) {
288         if (value == 0) {
289             return "0x00";
290         }
291         uint256 temp = value;
292         uint256 length = 0;
293         while (temp != 0) {
294             length++;
295             temp >>= 8;
296         }
297         return toHexString(value, length);
298     }
299 
300     /**
301      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
302      */
303     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
304         bytes memory buffer = new bytes(2 * length + 2);
305         buffer[0] = "0";
306         buffer[1] = "x";
307         for (uint256 i = 2 * length + 1; i > 1; --i) {
308             buffer[i] = _HEX_SYMBOLS[value & 0xf];
309             value >>= 4;
310         }
311         require(value == 0, "Strings: hex length insufficient");
312         return string(buffer);
313     }
314 }
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Contract module which provides a basic access control mechanism, where
323  * there is an account (an owner) that can be granted exclusive access to
324  * specific functions.
325  *
326  * By default, the owner account will be the one that deploys the contract. This
327  * can later be changed with {transferOwnership}.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 abstract contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor() {
342         _transferOwnership(_msgSender());
343     }
344 
345     /**
346      * @dev Returns the address of the current owner.
347      */
348     function owner() public view virtual returns (address) {
349         return _owner;
350     }
351 
352     /**
353      * @dev Throws if called by any account other than the owner.
354      */
355     modifier onlyOwner() {
356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
357         _;
358     }
359 
360     /**
361      * @dev Leaves the contract without owner. It will not be possible to call
362      * `onlyOwner` functions anymore. Can only be called by the current owner.
363      *
364      * NOTE: Renouncing ownership will leave the contract without an owner,
365      * thereby removing any functionality that is only available to the owner.
366      */
367     function renounceOwnership() public virtual onlyOwner {
368         _transferOwnership(address(0));
369     }
370 
371     /**
372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
373      * Can only be called by the current owner.
374      */
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         _transferOwnership(newOwner);
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Internal function without access restriction.
383      */
384     function _transferOwnership(address newOwner) internal virtual {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @dev Interface of the ERC165 standard, as defined in the
397  * https://eips.ethereum.org/EIPS/eip-165[EIP].
398  *
399  * Implementers can declare support of contract interfaces, which can then be
400  * queried by others ({ERC165Checker}).
401  *
402  * For an implementation, see {ERC165}.
403  */
404 interface IERC165 {
405     /**
406      * @dev Returns true if this contract implements the interface defined by
407      * `interfaceId`. See the corresponding
408      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
409      * to learn more about how these ids are created.
410      *
411      * This function call must use less than 30 000 gas.
412      */
413     function supportsInterface(bytes4 interfaceId) external view returns (bool);
414 }
415 
416 
417 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Implementation of the {IERC165} interface.
424  *
425  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
426  * for the additional interface id that will be supported. For example:
427  *
428  * ```solidity
429  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
431  * }
432  * ```
433  *
434  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
435  */
436 abstract contract ERC165 is IERC165 {
437     /**
438      * @dev See {IERC165-supportsInterface}.
439      */
440     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
441         return interfaceId == type(IERC165).interfaceId;
442     }
443 }
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Required interface of an ERC721 compliant contract.
453  */
454 interface IERC721 is IERC165 {
455     /**
456      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
457      */
458     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
459 
460     /**
461      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
462      */
463     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
467      */
468     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
469 
470     /**
471      * @dev Returns the number of tokens in ``owner``'s account.
472      */
473     function balanceOf(address owner) external view returns (uint256 balance);
474 
475     /**
476      * @dev Returns the owner of the `tokenId` token.
477      *
478      * Requirements:
479      *
480      * - `tokenId` must exist.
481      */
482     function ownerOf(uint256 tokenId) external view returns (address owner);
483 
484     /**
485      * @dev Safely transfers `tokenId` token from `from` to `to`.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must exist and be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
494      *
495      * Emits a {Transfer} event.
496      */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId,
501         bytes calldata data
502     ) external;
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
506      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must exist and be owned by `from`.
513      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
514      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
515      *
516      * Emits a {Transfer} event.
517      */
518     function safeTransferFrom(
519         address from,
520         address to,
521         uint256 tokenId
522     ) external;
523 
524     /**
525      * @dev Transfers `tokenId` token from `from` to `to`.
526      *
527      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
528      *
529      * Requirements:
530      *
531      * - `from` cannot be the zero address.
532      * - `to` cannot be the zero address.
533      * - `tokenId` token must be owned by `from`.
534      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
535      *
536      * Emits a {Transfer} event.
537      */
538     function transferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) external;
543 
544     /**
545      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
546      * The approval is cleared when the token is transferred.
547      *
548      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
549      *
550      * Requirements:
551      *
552      * - The caller must own the token or be an approved operator.
553      * - `tokenId` must exist.
554      *
555      * Emits an {Approval} event.
556      */
557     function approve(address to, uint256 tokenId) external;
558 
559     /**
560      * @dev Approve or remove `operator` as an operator for the caller.
561      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
562      *
563      * Requirements:
564      *
565      * - The `operator` cannot be the caller.
566      *
567      * Emits an {ApprovalForAll} event.
568      */
569     function setApprovalForAll(address operator, bool _approved) external;
570 
571     /**
572      * @dev Returns the account approved for `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function getApproved(uint256 tokenId) external view returns (address operator);
579 
580     /**
581      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
582      *
583      * See {setApprovalForAll}
584      */
585     function isApprovedForAll(address owner, address operator) external view returns (bool);
586 }
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @title ERC721 token receiver interface
595  * @dev Interface for any contract that wants to support safeTransfers
596  * from ERC721 asset contracts.
597  */
598 interface IERC721Receiver {
599     /**
600      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
601      * by `operator` from `from`, this function is called.
602      *
603      * It must return its Solidity selector to confirm the token transfer.
604      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
605      *
606      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
607      */
608     function onERC721Received(
609         address operator,
610         address from,
611         uint256 tokenId,
612         bytes calldata data
613     ) external returns (bytes4);
614 }
615 
616 
617 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 /**
623  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
624  * @dev See https://eips.ethereum.org/EIPS/eip-721
625  */
626 interface IERC721Metadata is IERC721 {
627     /**
628      * @dev Returns the token collection name.
629      */
630     function name() external view returns (string memory);
631 
632     /**
633      * @dev Returns the token collection symbol.
634      */
635     function symbol() external view returns (string memory);
636 
637     /**
638      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
639      */
640     function tokenURI(uint256 tokenId) external view returns (string memory);
641 }
642 
643 
644 // Creator: Chiru Labs
645 
646 pragma solidity ^0.8.4;
647 
648 error ApprovalCallerNotOwnerNorApproved();
649 error ApprovalQueryForNonexistentToken();
650 error ApproveToCaller();
651 error ApprovalToCurrentOwner();
652 error BalanceQueryForZeroAddress();
653 error MintToZeroAddress();
654 error MintZeroQuantity();
655 error OwnerQueryForNonexistentToken();
656 error TransferCallerNotOwnerNorApproved();
657 error TransferFromIncorrectOwner();
658 error TransferToNonERC721ReceiverImplementer();
659 error TransferToZeroAddress();
660 error URIQueryForNonexistentToken();
661 
662 /**
663  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
664  * the Metadata extension. Built to optimize for lower gas during batch mints.
665  *
666  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
667  *
668  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
669  *
670  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
671  */
672 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
673     using Address for address;
674     using Strings for uint256;
675 
676     // Compiler will pack this into a single 256bit word.
677     struct TokenOwnership {
678         // The address of the owner.
679         address addr;
680         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
681         uint64 startTimestamp;
682         // Whether the token has been burned.
683         bool burned;
684     }
685 
686     // Compiler will pack this into a single 256bit word.
687     struct AddressData {
688         // Realistically, 2**64-1 is more than enough.
689         uint64 balance;
690         // Keeps track of mint count with minimal overhead for tokenomics.
691         uint64 numberMinted;
692         // Keeps track of burn count with minimal overhead for tokenomics.
693         uint64 numberBurned;
694         // For miscellaneous variable(s) pertaining to the address
695         // (e.g. number of whitelist mint slots used).
696         // If there are multiple variables, please pack them into a uint64.
697         uint64 aux;
698     }
699 
700     // The tokenId of the next token to be minted.
701     uint256 internal _currentIndex;
702 
703     // The number of tokens burned.
704     uint256 internal _burnCounter;
705 
706     // Token name
707     string private _name;
708 
709     // Token symbol
710     string private _symbol;
711 
712     // Mapping from token ID to ownership details
713     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
714     mapping(uint256 => TokenOwnership) internal _ownerships;
715 
716     // Mapping owner address to address data
717     mapping(address => AddressData) private _addressData;
718 
719     // Mapping from token ID to approved address
720     mapping(uint256 => address) private _tokenApprovals;
721 
722     // Mapping from owner to operator approvals
723     mapping(address => mapping(address => bool)) private _operatorApprovals;
724 
725     constructor(string memory name_, string memory symbol_) {
726         _name = name_;
727         _symbol = symbol_;
728         _currentIndex = _startTokenId();
729     }
730 
731     /**
732      * To change the starting tokenId, please override this function.
733      */
734     function _startTokenId() internal view virtual returns (uint256) {
735         return 0;
736     }
737 
738     /**
739      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
740      */
741     function totalSupply() public view returns (uint256) {
742         // Counter underflow is impossible as _burnCounter cannot be incremented
743         // more than _currentIndex - _startTokenId() times
744         unchecked {
745             return _currentIndex - _burnCounter - _startTokenId();
746         }
747     }
748 
749     /**
750      * Returns the total amount of tokens minted in the contract.
751      */
752     function _totalMinted() internal view returns (uint256) {
753         // Counter underflow is impossible as _currentIndex does not decrement,
754         // and it is initialized to _startTokenId()
755         unchecked {
756             return _currentIndex - _startTokenId();
757         }
758     }
759 
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
764         return
765             interfaceId == type(IERC721).interfaceId ||
766             interfaceId == type(IERC721Metadata).interfaceId ||
767             super.supportsInterface(interfaceId);
768     }
769 
770     /**
771      * @dev See {IERC721-balanceOf}.
772      */
773     function balanceOf(address owner) public view override returns (uint256) {
774         if (owner == address(0)) revert BalanceQueryForZeroAddress();
775         return uint256(_addressData[owner].balance);
776     }
777 
778     /**
779      * Returns the number of tokens minted by `owner`.
780      */
781     function _numberMinted(address owner) internal view returns (uint256) {
782         return uint256(_addressData[owner].numberMinted);
783     }
784 
785     /**
786      * Returns the number of tokens burned by or on behalf of `owner`.
787      */
788     function _numberBurned(address owner) internal view returns (uint256) {
789         return uint256(_addressData[owner].numberBurned);
790     }
791 
792     /**
793      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
794      */
795     function _getAux(address owner) internal view returns (uint64) {
796         return _addressData[owner].aux;
797     }
798 
799     /**
800      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
801      * If there are multiple variables, please pack them into a uint64.
802      */
803     function _setAux(address owner, uint64 aux) internal {
804         _addressData[owner].aux = aux;
805     }
806 
807     /**
808      * Gas spent here starts off proportional to the maximum mint batch size.
809      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
810      */
811     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
812         uint256 curr = tokenId;
813 
814         unchecked {
815             if (_startTokenId() <= curr && curr < _currentIndex) {
816                 TokenOwnership memory ownership = _ownerships[curr];
817                 if (!ownership.burned) {
818                     if (ownership.addr != address(0)) {
819                         return ownership;
820                     }
821                     // Invariant:
822                     // There will always be an ownership that has an address and is not burned
823                     // before an ownership that does not have an address and is not burned.
824                     // Hence, curr will not underflow.
825                     while (true) {
826                         curr--;
827                         ownership = _ownerships[curr];
828                         if (ownership.addr != address(0)) {
829                             return ownership;
830                         }
831                     }
832                 }
833             }
834         }
835         revert OwnerQueryForNonexistentToken();
836     }
837 
838     /**
839      * @dev See {IERC721-ownerOf}.
840      */
841     function ownerOf(uint256 tokenId) public view override returns (address) {
842         return _ownershipOf(tokenId).addr;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-name}.
847      */
848     function name() public view virtual override returns (string memory) {
849         return _name;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-symbol}.
854      */
855     function symbol() public view virtual override returns (string memory) {
856         return _symbol;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-tokenURI}.
861      */
862     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
863         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
864 
865         string memory baseURI = _baseURI();
866         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
867     }
868 
869     /**
870      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
871      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
872      * by default, can be overriden in child contracts.
873      */
874     function _baseURI() internal view virtual returns (string memory) {
875         return '';
876     }
877 
878     /**
879      * @dev See {IERC721-approve}.
880      */
881     function approve(address to, uint256 tokenId) public override {
882         address owner = ERC721A.ownerOf(tokenId);
883         if (to == owner) revert ApprovalToCurrentOwner();
884 
885         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
886             revert ApprovalCallerNotOwnerNorApproved();
887         }
888 
889         _approve(to, tokenId, owner);
890     }
891 
892     /**
893      * @dev See {IERC721-getApproved}.
894      */
895     function getApproved(uint256 tokenId) public view override returns (address) {
896         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
897 
898         return _tokenApprovals[tokenId];
899     }
900 
901     /**
902      * @dev See {IERC721-setApprovalForAll}.
903      */
904     function setApprovalForAll(address operator, bool approved) public virtual override {
905         if (operator == _msgSender()) revert ApproveToCaller();
906 
907         _operatorApprovals[_msgSender()][operator] = approved;
908         emit ApprovalForAll(_msgSender(), operator, approved);
909     }
910 
911     /**
912      * @dev See {IERC721-isApprovedForAll}.
913      */
914     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
915         return _operatorApprovals[owner][operator];
916     }
917 
918     /**
919      * @dev See {IERC721-transferFrom}.
920      */
921     function transferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public virtual override {
926         _transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) public virtual override {
937         safeTransferFrom(from, to, tokenId, '');
938     }
939 
940     /**
941      * @dev See {IERC721-safeTransferFrom}.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) public virtual override {
949         _transfer(from, to, tokenId);
950         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
951             revert TransferToNonERC721ReceiverImplementer();
952         }
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      */
962     function _exists(uint256 tokenId) internal view returns (bool) {
963         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
964     }
965 
966     function _safeMint(address to, uint256 quantity) internal {
967         _safeMint(to, quantity, '');
968     }
969 
970     /**
971      * @dev Safely mints `quantity` tokens and transfers them to `to`.
972      *
973      * Requirements:
974      *
975      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
976      * - `quantity` must be greater than 0.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeMint(
981         address to,
982         uint256 quantity,
983         bytes memory _data
984     ) internal {
985         _mint(to, quantity, _data, true);
986     }
987 
988     /**
989      * @dev Mints `quantity` tokens and transfers them to `to`.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - `quantity` must be greater than 0.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _mint(
999         address to,
1000         uint256 quantity,
1001         bytes memory _data,
1002         bool safe
1003     ) internal {
1004         uint256 startTokenId = _currentIndex;
1005         if (to == address(0)) revert MintToZeroAddress();
1006         if (quantity == 0) revert MintZeroQuantity();
1007 
1008         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1009 
1010         // Overflows are incredibly unrealistic.
1011         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1012         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1013         unchecked {
1014             _addressData[to].balance += uint64(quantity);
1015             _addressData[to].numberMinted += uint64(quantity);
1016 
1017             _ownerships[startTokenId].addr = to;
1018             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1019 
1020             uint256 updatedIndex = startTokenId;
1021             uint256 end = updatedIndex + quantity;
1022 
1023             if (safe && to.isContract()) {
1024                 do {
1025                     emit Transfer(address(0), to, updatedIndex);
1026                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1027                         revert TransferToNonERC721ReceiverImplementer();
1028                     }
1029                 } while (updatedIndex != end);
1030                 // Reentrancy protection
1031                 if (_currentIndex != startTokenId) revert();
1032             } else {
1033                 do {
1034                     emit Transfer(address(0), to, updatedIndex++);
1035                 } while (updatedIndex != end);
1036             }
1037             _currentIndex = updatedIndex;
1038         }
1039         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1040     }
1041 
1042     /**
1043      * @dev Transfers `tokenId` from `from` to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must be owned by `from`.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _transfer(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) private {
1057         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1058 
1059         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1060 
1061         bool isApprovedOrOwner = (_msgSender() == from ||
1062             isApprovedForAll(from, _msgSender()) ||
1063             getApproved(tokenId) == _msgSender());
1064 
1065         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1066         if (to == address(0)) revert TransferToZeroAddress();
1067 
1068         _beforeTokenTransfers(from, to, tokenId, 1);
1069 
1070         // Clear approvals from the previous owner
1071         _approve(address(0), tokenId, from);
1072 
1073         // Underflow of the sender's balance is impossible because we check for
1074         // ownership above and the recipient's balance can't realistically overflow.
1075         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1076         unchecked {
1077             _addressData[from].balance -= 1;
1078             _addressData[to].balance += 1;
1079 
1080             TokenOwnership storage currSlot = _ownerships[tokenId];
1081             currSlot.addr = to;
1082             currSlot.startTimestamp = uint64(block.timestamp);
1083 
1084             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1085             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1086             uint256 nextTokenId = tokenId + 1;
1087             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1088             if (nextSlot.addr == address(0)) {
1089                 // This will suffice for checking _exists(nextTokenId),
1090                 // as a burned slot cannot contain the zero address.
1091                 if (nextTokenId != _currentIndex) {
1092                     nextSlot.addr = from;
1093                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1094                 }
1095             }
1096         }
1097 
1098         emit Transfer(from, to, tokenId);
1099         _afterTokenTransfers(from, to, tokenId, 1);
1100     }
1101 
1102     /**
1103      * @dev This is equivalent to _burn(tokenId, false)
1104      */
1105     function _burn(uint256 tokenId) internal virtual {
1106         _burn(tokenId, false);
1107     }
1108 
1109     /**
1110      * @dev Destroys `tokenId`.
1111      * The approval is cleared when the token is burned.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must exist.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1120         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1121 
1122         address from = prevOwnership.addr;
1123 
1124         if (approvalCheck) {
1125             bool isApprovedOrOwner = (_msgSender() == from ||
1126                 isApprovedForAll(from, _msgSender()) ||
1127                 getApproved(tokenId) == _msgSender());
1128 
1129             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1130         }
1131 
1132         _beforeTokenTransfers(from, address(0), tokenId, 1);
1133 
1134         // Clear approvals from the previous owner
1135         _approve(address(0), tokenId, from);
1136 
1137         // Underflow of the sender's balance is impossible because we check for
1138         // ownership above and the recipient's balance can't realistically overflow.
1139         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1140         unchecked {
1141             AddressData storage addressData = _addressData[from];
1142             addressData.balance -= 1;
1143             addressData.numberBurned += 1;
1144 
1145             // Keep track of who burned the token, and the timestamp of burning.
1146             TokenOwnership storage currSlot = _ownerships[tokenId];
1147             currSlot.addr = from;
1148             currSlot.startTimestamp = uint64(block.timestamp);
1149             currSlot.burned = true;
1150 
1151             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1152             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1153             uint256 nextTokenId = tokenId + 1;
1154             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1155             if (nextSlot.addr == address(0)) {
1156                 // This will suffice for checking _exists(nextTokenId),
1157                 // as a burned slot cannot contain the zero address.
1158                 if (nextTokenId != _currentIndex) {
1159                     nextSlot.addr = from;
1160                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1161                 }
1162             }
1163         }
1164 
1165         emit Transfer(from, address(0), tokenId);
1166         _afterTokenTransfers(from, address(0), tokenId, 1);
1167 
1168         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1169         unchecked {
1170             _burnCounter++;
1171         }
1172     }
1173 
1174     /**
1175      * @dev Approve `to` to operate on `tokenId`
1176      *
1177      * Emits a {Approval} event.
1178      */
1179     function _approve(
1180         address to,
1181         uint256 tokenId,
1182         address owner
1183     ) private {
1184         _tokenApprovals[tokenId] = to;
1185         emit Approval(owner, to, tokenId);
1186     }
1187 
1188     /**
1189      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1190      *
1191      * @param from address representing the previous owner of the given token ID
1192      * @param to target address that will receive the tokens
1193      * @param tokenId uint256 ID of the token to be transferred
1194      * @param _data bytes optional data to send along with the call
1195      * @return bool whether the call correctly returned the expected magic value
1196      */
1197     function _checkContractOnERC721Received(
1198         address from,
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) private returns (bool) {
1203         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1204             return retval == IERC721Receiver(to).onERC721Received.selector;
1205         } catch (bytes memory reason) {
1206             if (reason.length == 0) {
1207                 revert TransferToNonERC721ReceiverImplementer();
1208             } else {
1209                 assembly {
1210                     revert(add(32, reason), mload(reason))
1211                 }
1212             }
1213         }
1214     }
1215 
1216     /**
1217      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1218      * And also called before burning one token.
1219      *
1220      * startTokenId - the first token id to be transferred
1221      * quantity - the amount to be transferred
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` will be minted for `to`.
1228      * - When `to` is zero, `tokenId` will be burned by `from`.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _beforeTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 
1238     /**
1239      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1240      * minting.
1241      * And also called after one token has been burned.
1242      *
1243      * startTokenId - the first token id to be transferred
1244      * quantity - the amount to be transferred
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` has been minted for `to`.
1251      * - When `to` is zero, `tokenId` has been burned by `from`.
1252      * - `from` and `to` are never both zero.
1253      */
1254     function _afterTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 }
1261 
1262 
1263 contract Hiros is ERC721A, Ownable {
1264     using Strings for uint256;
1265 
1266     uint256 public constant PRICE = 0.0 ether;
1267     uint16 public constant MAX_SUPPLY = 3008;
1268     uint16 public constant MAX_SUPPLY_MINT = 2807;
1269     uint8 public constant MAX_MINT_AMOUNT = 10;
1270     string private _base_uri = "";
1271     string private _hidden_base_uri = "";
1272     bool public _paused = false;
1273 
1274     constructor(string memory hidden_base_uri) ERC721A("Hiros", "HIR") {
1275         setHiddenBaseURI(hidden_base_uri);
1276         mint(8); // Gods
1277         setPaused(true);
1278     }
1279 
1280     function mint(uint16 count) public payable {
1281         require(!_paused, "The contract is paused!");
1282         require(count > 0, "Amount must be larger than 0!");
1283         require(MAX_SUPPLY >= totalSupply() + count, "Total supply reached!");
1284         
1285         if (msg.sender != owner()) {
1286             require(MAX_SUPPLY_MINT >= totalSupply() + count, "Total public supply reached!");
1287             require(count <= MAX_MINT_AMOUNT, "Amount needs to be at most MAX_MINT_AMOUNT!");
1288             require(balanceOf(msg.sender) < MAX_MINT_AMOUNT, "Every minter is allowed to mint at most MAX_MINT_AMOUNT!");
1289         }
1290         _safeMint(msg.sender, count);
1291     }
1292 
1293     function mintOwnerOnly(address to, uint16 count) public payable onlyOwner {
1294         require(count > 0, "Amount must be larger than 0!");
1295         require(MAX_SUPPLY >= totalSupply() + count, "Total supply reached!");
1296         _safeMint(to, count);
1297     }
1298 
1299     function setHiddenBaseURI(string memory hidden_base_uri) public onlyOwner {
1300         _hidden_base_uri = hidden_base_uri;
1301     }
1302     
1303     function setBaseURI(string memory base_uri) public onlyOwner {
1304         _base_uri = base_uri;
1305     }
1306 
1307     function _HiddenBaseURI() internal view returns(string memory) {
1308         return _hidden_base_uri;
1309     }
1310 
1311     function _baseURI() internal view virtual override returns (string memory) {
1312         return _base_uri;
1313     }
1314 
1315     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1316         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1317         if (keccak256(abi.encodePacked(_base_uri)) == keccak256(abi.encodePacked(""))) {
1318             return _hidden_base_uri;
1319         }
1320 
1321         string memory baseURI = _baseURI();
1322         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1323     }
1324 
1325     function setPaused(bool paused) public onlyOwner {
1326         _paused = paused;
1327     }
1328 
1329     // We don't really need this, because of free mint
1330     function withdraw() public onlyOwner {
1331         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1332         require(success, "Transfer failed.");
1333     }
1334 
1335 }