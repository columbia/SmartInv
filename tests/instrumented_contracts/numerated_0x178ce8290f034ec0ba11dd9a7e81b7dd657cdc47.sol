1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title ERC721 token receiver interface
7  * @dev Interface for any contract that wants to support safeTransfers
8  * from ERC721 asset contracts.
9  */
10 interface IERC721Receiver {
11     /**
12      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
13      * by `operator` from `from`, this function is called.
14      *
15      * It must return its Solidity selector to confirm the token transfer.
16      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
17      *
18      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
19      */
20     function onERC721Received(
21         address operator,
22         address from,
23         uint256 tokenId,
24         bytes calldata data
25     ) external returns (bytes4);
26 }
27 
28 pragma solidity ^0.8.1;
29 
30 /**
31  * @dev Collection of functions related to the address type
32  */
33 library Address {
34     /**
35      * @dev Returns true if `account` is a contract.
36      *
37      * [IMPORTANT]
38      * ====
39      * It is unsafe to assume that an address for which this function returns
40      * false is an externally-owned account (EOA) and not a contract.
41      *
42      * Among others, `isContract` will return false for the following
43      * types of addresses:
44      *
45      *  - an externally-owned account
46      *  - a contract in construction
47      *  - an address where a contract will be created
48      *  - an address where a contract lived, but was destroyed
49      * ====
50      *
51      * [IMPORTANT]
52      * ====
53      * You shouldn't rely on `isContract` to protect against flash loan attacks!
54      *
55      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
56      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
57      * constructor.
58      * ====
59      */
60     function isContract(address account) internal view returns (bool) {
61         // This method relies on extcodesize/address.code.length, which returns 0
62         // for contracts in construction, since the code is only stored at the end
63         // of the constructor execution.
64 
65         return account.code.length > 0;
66     }
67 
68     /**
69      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
70      * `recipient`, forwarding all available gas and reverting on errors.
71      *
72      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
73      * of certain opcodes, possibly making contracts go over the 2300 gas limit
74      * imposed by `transfer`, making them unable to receive funds via
75      * `transfer`. {sendValue} removes this limitation.
76      *
77      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
78      *
79      * IMPORTANT: because control is transferred to `recipient`, care must be
80      * taken to not create reentrancy vulnerabilities. Consider using
81      * {ReentrancyGuard} or the
82      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
83      */
84     function sendValue(address payable recipient, uint256 amount) internal {
85         require(address(this).balance >= amount, "Address: insufficient balance");
86 
87         (bool success, ) = recipient.call{value: amount}("");
88         require(success, "Address: unable to send value, recipient may have reverted");
89     }
90 
91     /**
92      * @dev Performs a Solidity function call using a low level `call`. A
93      * plain `call` is an unsafe replacement for a function call: use this
94      * function instead.
95      *
96      * If `target` reverts with a revert reason, it is bubbled up by this
97      * function (like regular Solidity function calls).
98      *
99      * Returns the raw returned data. To convert to the expected return value,
100      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
101      *
102      * Requirements:
103      *
104      * - `target` must be a contract.
105      * - calling `target` with `data` must not revert.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110         return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
115      * `errorMessage` as a fallback revert reason when `target` reverts.
116      *
117      * _Available since v3.1._
118      */
119     function functionCall(
120         address target,
121         bytes memory data,
122         string memory errorMessage
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, 0, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but also transferring `value` wei to `target`.
130      *
131      * Requirements:
132      *
133      * - the calling contract must have an ETH balance of at least `value`.
134      * - the called Solidity function must be `payable`.
135      *
136      * _Available since v3.1._
137      */
138     function functionCallWithValue(
139         address target,
140         bytes memory data,
141         uint256 value
142     ) internal returns (bytes memory) {
143         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
148      * with `errorMessage` as a fallback revert reason when `target` reverts.
149      *
150      * _Available since v3.1._
151      */
152     function functionCallWithValue(
153         address target,
154         bytes memory data,
155         uint256 value,
156         string memory errorMessage
157     ) internal returns (bytes memory) {
158         require(address(this).balance >= value, "Address: insufficient balance for call");
159         require(isContract(target), "Address: call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.call{value: value}(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a static call.
168      *
169      * _Available since v3.3._
170      */
171     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
172         return functionStaticCall(target, data, "Address: low-level static call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a static call.
178      *
179      * _Available since v3.3._
180      */
181     function functionStaticCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal view returns (bytes memory) {
186         require(isContract(target), "Address: static call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.staticcall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but performing a delegate call.
195      *
196      * _Available since v3.4._
197      */
198     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
204      * but performing a delegate call.
205      *
206      * _Available since v3.4._
207      */
208     function functionDelegateCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(isContract(target), "Address: delegate call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.delegatecall(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
221      * revert reason using the provided one.
222      *
223      * _Available since v4.3._
224      */
225     function verifyCallResult(
226         bool success,
227         bytes memory returndata,
228         string memory errorMessage
229     ) internal pure returns (bytes memory) {
230         if (success) {
231             return returndata;
232         } else {
233             // Look for revert reason and bubble it up if present
234             if (returndata.length > 0) {
235                 // The easiest way to bubble the revert reason is using memory via assembly
236 
237                 assembly {
238                     let returndata_size := mload(returndata)
239                     revert(add(32, returndata), returndata_size)
240                 }
241             } else {
242                 revert(errorMessage);
243             }
244         }
245     }
246 }
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Provides information about the current execution context, including the
252  * sender of the transaction and its data. While these are generally available
253  * via msg.sender and msg.data, they should not be accessed in such a direct
254  * manner, since when dealing with meta-transactions the account sending and
255  * paying for execution may not be the actual sender (as far as an application
256  * is concerned).
257  *
258  * This contract is only required for intermediate, library-like contracts.
259  */
260 abstract contract Context {
261     function _msgSender() internal view virtual returns (address) {
262         return msg.sender;
263     }
264 
265     function _msgData() internal view virtual returns (bytes calldata) {
266         return msg.data;
267     }
268 }
269 
270 pragma solidity ^0.8.0;
271 
272 /**
273  * @dev String operations.
274  */
275 library Strings {
276     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
280      */
281     function toString(uint256 value) internal pure returns (string memory) {
282         // Inspired by OraclizeAPI's implementation - MIT licence
283         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
284 
285         if (value == 0) {
286             return "0";
287         }
288         uint256 temp = value;
289         uint256 digits;
290         while (temp != 0) {
291             digits++;
292             temp /= 10;
293         }
294         bytes memory buffer = new bytes(digits);
295         while (value != 0) {
296             digits -= 1;
297             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
298             value /= 10;
299         }
300         return string(buffer);
301     }
302 
303     /**
304      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
305      */
306     function toHexString(uint256 value) internal pure returns (string memory) {
307         if (value == 0) {
308             return "0x00";
309         }
310         uint256 temp = value;
311         uint256 length = 0;
312         while (temp != 0) {
313             length++;
314             temp >>= 8;
315         }
316         return toHexString(value, length);
317     }
318 
319     /**
320      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
321      */
322     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
323         bytes memory buffer = new bytes(2 * length + 2);
324         buffer[0] = "0";
325         buffer[1] = "x";
326         for (uint256 i = 2 * length + 1; i > 1; --i) {
327             buffer[i] = _HEX_SYMBOLS[value & 0xf];
328             value >>= 4;
329         }
330         require(value == 0, "Strings: hex length insufficient");
331         return string(buffer);
332     }
333 }
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
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Implementation of the {IERC165} interface.
362  *
363  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
364  * for the additional interface id that will be supported. For example:
365  *
366  * ```solidity
367  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
369  * }
370  * ```
371  *
372  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
373  */
374 abstract contract ERC165 is IERC165 {
375     /**
376      * @dev See {IERC165-supportsInterface}.
377      */
378     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379         return interfaceId == type(IERC165).interfaceId;
380     }
381 }
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Required interface of an ERC721 compliant contract.
387  */
388 interface IERC721 is IERC165 {
389     /**
390      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
391      */
392     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
396      */
397     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
401      */
402     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
403 
404     /**
405      * @dev Returns the number of tokens in ``owner``'s account.
406      */
407     function balanceOf(address owner) external view returns (uint256 balance);
408 
409     /**
410      * @dev Returns the owner of the `tokenId` token.
411      *
412      * Requirements:
413      *
414      * - `tokenId` must exist.
415      */
416     function ownerOf(uint256 tokenId) external view returns (address owner);
417 
418     /**
419      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
420      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
421      *
422      * Requirements:
423      *
424      * - `from` cannot be the zero address.
425      * - `to` cannot be the zero address.
426      * - `tokenId` token must exist and be owned by `from`.
427      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
428      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
429      *
430      * Emits a {Transfer} event.
431      */
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 tokenId
436     ) external;
437 
438     /**
439      * @dev Transfers `tokenId` token from `from` to `to`.
440      *
441      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `tokenId` token must be owned by `from`.
448      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
449      *
450      * Emits a {Transfer} event.
451      */
452     function transferFrom(
453         address from,
454         address to,
455         uint256 tokenId
456     ) external;
457 
458     /**
459      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
460      * The approval is cleared when the token is transferred.
461      *
462      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
463      *
464      * Requirements:
465      *
466      * - The caller must own the token or be an approved operator.
467      * - `tokenId` must exist.
468      *
469      * Emits an {Approval} event.
470      */
471     function approve(address to, uint256 tokenId) external;
472 
473     /**
474      * @dev Returns the account approved for `tokenId` token.
475      *
476      * Requirements:
477      *
478      * - `tokenId` must exist.
479      */
480     function getApproved(uint256 tokenId) external view returns (address operator);
481 
482     /**
483      * @dev Approve or remove `operator` as an operator for the caller.
484      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
485      *
486      * Requirements:
487      *
488      * - The `operator` cannot be the caller.
489      *
490      * Emits an {ApprovalForAll} event.
491      */
492     function setApprovalForAll(address operator, bool _approved) external;
493 
494     /**
495      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
496      *
497      * See {setApprovalForAll}
498      */
499     function isApprovedForAll(address owner, address operator) external view returns (bool);
500 
501     /**
502      * @dev Safely transfers `tokenId` token from `from` to `to`.
503      *
504      * Requirements:
505      *
506      * - `from` cannot be the zero address.
507      * - `to` cannot be the zero address.
508      * - `tokenId` token must exist and be owned by `from`.
509      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
510      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
511      *
512      * Emits a {Transfer} event.
513      */
514     function safeTransferFrom(
515         address from,
516         address to,
517         uint256 tokenId,
518         bytes calldata data
519     ) external;
520 }
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 interface IERC721Metadata is IERC721 {
529     /**
530      * @dev Returns the token collection name.
531      */
532     function name() external view returns (string memory);
533 
534     /**
535      * @dev Returns the token collection symbol.
536      */
537     function symbol() external view returns (string memory);
538 
539     /**
540      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
541      */
542     function tokenURI(uint256 tokenId) external view returns (string memory);
543 }
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
549  * @dev See https://eips.ethereum.org/EIPS/eip-721
550  */
551 interface IERC721Enumerable is IERC721 {
552     /**
553      * @dev Returns the total amount of tokens stored by the contract.
554      */
555     function totalSupply() external view returns (uint256);
556 
557     /**
558      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
559      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
560      */
561     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
562 
563     /**
564      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
565      * Use along with {totalSupply} to enumerate all tokens.
566      */
567     function tokenByIndex(uint256 index) external view returns (uint256);
568 }
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Contract module which provides a basic access control mechanism, where
574  * there is an account (an owner) that can be granted exclusive access to
575  * specific functions.
576  *
577  * By default, the owner account will be the one that deploys the contract. This
578  * can later be changed with {transferOwnership}.
579  *
580  * This module is used through inheritance. It will make available the modifier
581  * `onlyOwner`, which can be applied to your functions to restrict their use to
582  * the owner.
583  */
584 abstract contract Ownable is Context {
585     address private _owner;
586 
587     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
588 
589     /**
590      * @dev Initializes the contract setting the deployer as the initial owner.
591      */
592     constructor() {
593         _transferOwnership(_msgSender());
594     }
595 
596     /**
597      * @dev Returns the address of the current owner.
598      */
599     function owner() public view virtual returns (address) {
600         return _owner;
601     }
602 
603     /**
604      * @dev Throws if called by any account other than the owner.
605      */
606     modifier onlyOwner() {
607         require(owner() == _msgSender(), "Ownable: caller is not the owner");
608         _;
609     }
610 
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         _transferOwnership(address(0));
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address newOwner) public virtual onlyOwner {
627         require(newOwner != address(0), "Ownable: new owner is the zero address");
628         _transferOwnership(newOwner);
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Internal function without access restriction.
634      */
635     function _transferOwnership(address newOwner) internal virtual {
636         address oldOwner = _owner;
637         _owner = newOwner;
638         emit OwnershipTransferred(oldOwner, newOwner);
639     }
640 }
641 
642 pragma solidity ^0.8.4;
643 
644 error ApprovalCallerNotOwnerNorApproved();
645 error ApprovalQueryForNonexistentToken();
646 error ApproveToCaller();
647 error ApprovalToCurrentOwner();
648 error BalanceQueryForZeroAddress();
649 error MintedQueryForZeroAddress();
650 error BurnedQueryForZeroAddress();
651 error MintToZeroAddress();
652 error MintZeroQuantity();
653 error OwnerIndexOutOfBounds();
654 error OwnerQueryForNonexistentToken();
655 error TokenIndexOutOfBounds();
656 error TransferCallerNotOwnerNorApproved();
657 error TransferFromIncorrectOwner();
658 error TransferToNonERC721ReceiverImplementer();
659 error TransferToZeroAddress();
660 error URIQueryForNonexistentToken();
661 
662 /**
663  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
664  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
665  *
666  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
667  *
668  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
669  *
670  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
671  */
672 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
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
694     }
695 
696     // Compiler will pack the following 
697     // _currentIndex and _burnCounter into a single 256bit word.
698     
699     // The tokenId of the next token to be minted.
700     uint128 internal _currentIndex;
701 
702     // The number of tokens burned.
703     uint128 internal _burnCounter;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to ownership details
712     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
713     mapping(uint256 => TokenOwnership) internal _ownerships;
714 
715     // Mapping owner address to address data
716     mapping(address => AddressData) private _addressData;
717 
718     // Mapping from token ID to approved address
719     mapping(uint256 => address) private _tokenApprovals;
720 
721     // Mapping from owner to operator approvals
722     mapping(address => mapping(address => bool)) private _operatorApprovals;
723 
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727     }
728 
729     /**
730      * @dev See {IERC721Enumerable-totalSupply}.
731      */
732     function totalSupply() public view override returns (uint256) {
733         // Counter underflow is impossible as _burnCounter cannot be incremented
734         // more than _currentIndex times
735         unchecked {
736             return _currentIndex - _burnCounter;    
737         }
738     }
739 
740     /**
741      * @dev See {IERC721Enumerable-tokenByIndex}.
742      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
743      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
744      */
745     function tokenByIndex(uint256 index) public view override returns (uint256) {
746         uint256 numMintedSoFar = _currentIndex;
747         uint256 tokenIdsIdx;
748 
749         // Counter overflow is impossible as the loop breaks when
750         // uint256 i is equal to another uint256 numMintedSoFar.
751         unchecked {
752             for (uint256 i; i < numMintedSoFar; i++) {
753                 TokenOwnership memory ownership = _ownerships[i];
754                 if (!ownership.burned) {
755                     if (tokenIdsIdx == index) {
756                         return i;
757                     }
758                     tokenIdsIdx++;
759                 }
760             }
761         }
762         revert TokenIndexOutOfBounds();
763     }
764 
765     /**
766      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
767      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
768      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
769      */
770     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
771         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
772         uint256 numMintedSoFar = _currentIndex;
773         uint256 tokenIdsIdx;
774         address currOwnershipAddr;
775 
776         // Counter overflow is impossible as the loop breaks when
777         // uint256 i is equal to another uint256 numMintedSoFar.
778         unchecked {
779             for (uint256 i; i < numMintedSoFar; i++) {
780                 TokenOwnership memory ownership = _ownerships[i];
781                 if (ownership.burned) {
782                     continue;
783                 }
784                 if (ownership.addr != address(0)) {
785                     currOwnershipAddr = ownership.addr;
786                 }
787                 if (currOwnershipAddr == owner) {
788                     if (tokenIdsIdx == index) {
789                         return i;
790                     }
791                     tokenIdsIdx++;
792                 }
793             }
794         }
795 
796         // Execution should never reach this point.
797         revert();
798     }
799 
800     /**
801      * @dev See {IERC165-supportsInterface}.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
804         return
805             interfaceId == type(IERC721).interfaceId ||
806             interfaceId == type(IERC721Metadata).interfaceId ||
807             interfaceId == type(IERC721Enumerable).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view override returns (uint256) {
815         if (owner == address(0)) revert BalanceQueryForZeroAddress();
816         return uint256(_addressData[owner].balance);
817     }
818 
819     function _numberMinted(address owner) internal view returns (uint256) {
820         if (owner == address(0)) revert MintedQueryForZeroAddress();
821         return uint256(_addressData[owner].numberMinted);
822     }
823 
824     function _numberBurned(address owner) internal view returns (uint256) {
825         if (owner == address(0)) revert BurnedQueryForZeroAddress();
826         return uint256(_addressData[owner].numberBurned);
827     }
828 
829     /**
830      * Gas spent here starts off proportional to the maximum mint batch size.
831      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
832      */
833     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
834         uint256 curr = tokenId;
835 
836         unchecked {
837             if (curr < _currentIndex) {
838                 TokenOwnership memory ownership = _ownerships[curr];
839                 if (!ownership.burned) {
840                     if (ownership.addr != address(0)) {
841                         return ownership;
842                     }
843                     // Invariant: 
844                     // There will always be an ownership that has an address and is not burned 
845                     // before an ownership that does not have an address and is not burned.
846                     // Hence, curr will not underflow.
847                     while (true) {
848                         curr--;
849                         ownership = _ownerships[curr];
850                         if (ownership.addr != address(0)) {
851                             return ownership;
852                         }
853                     }
854                 }
855             }
856         }
857         revert OwnerQueryForNonexistentToken();
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view override returns (address) {
864         return ownershipOf(tokenId).addr;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-name}.
869      */
870     function name() public view virtual override returns (string memory) {
871         return _name;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-symbol}.
876      */
877     function symbol() public view virtual override returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-tokenURI}.
883      */
884     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
885         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
886 
887         string memory baseURI = _baseURI();
888         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
889     }
890 
891     /**
892      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
893      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
894      * by default, can be overriden in child contracts.
895      */
896     function _baseURI() internal view virtual returns (string memory) {
897         return '';
898     }
899 
900     /**
901      * @dev See {IERC721-approve}.
902      */
903     function approve(address to, uint256 tokenId) public override {
904         address owner = ERC721A.ownerOf(tokenId);
905         if (to == owner) revert ApprovalToCurrentOwner();
906 
907         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
908             revert ApprovalCallerNotOwnerNorApproved();
909         }
910 
911         _approve(to, tokenId, owner);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId) public view override returns (address) {
918         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved) public override {
927         if (operator == _msgSender()) revert ApproveToCaller();
928 
929         _operatorApprovals[_msgSender()][operator] = approved;
930         emit ApprovalForAll(_msgSender(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         _transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         safeTransferFrom(from, to, tokenId, '');
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) public virtual override {
971         _transfer(from, to, tokenId);
972         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
973             revert TransferToNonERC721ReceiverImplementer();
974         }
975     }
976 
977     /**
978      * @dev Returns whether `tokenId` exists.
979      *
980      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
981      *
982      * Tokens start existing when they are minted (`_mint`),
983      */
984     function _exists(uint256 tokenId) internal view returns (bool) {
985         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
986     }
987 
988     function _safeMint(address to, uint256 quantity) internal {
989         _safeMint(to, quantity, '');
990     }
991 
992     /**
993      * @dev Safely mints `quantity` tokens and transfers them to `to`.
994      *
995      * Requirements:
996      *
997      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
998      * - `quantity` must be greater than 0.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _safeMint(
1003         address to,
1004         uint256 quantity,
1005         bytes memory _data
1006     ) internal {
1007         _mint(to, quantity, _data, true);
1008     }
1009 
1010     /**
1011      * @dev Mints `quantity` tokens and transfers them to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `quantity` must be greater than 0.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _mint(
1021         address to,
1022         uint256 quantity,
1023         bytes memory _data,
1024         bool safe
1025     ) internal {
1026         uint256 startTokenId = _currentIndex;
1027         if (to == address(0)) revert MintToZeroAddress();
1028         if (quantity == 0) revert MintZeroQuantity();
1029 
1030         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1031 
1032         // Overflows are incredibly unrealistic.
1033         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1034         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1035         unchecked {
1036             _addressData[to].balance += uint64(quantity);
1037             _addressData[to].numberMinted += uint64(quantity);
1038 
1039             _ownerships[startTokenId].addr = to;
1040             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1041 
1042             uint256 updatedIndex = startTokenId;
1043 
1044             for (uint256 i; i < quantity; i++) {
1045                 emit Transfer(address(0), to, updatedIndex);
1046                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1047                     revert TransferToNonERC721ReceiverImplementer();
1048                 }
1049                 updatedIndex++;
1050             }
1051 
1052             _currentIndex = uint128(updatedIndex);
1053         }
1054         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1055     }
1056 
1057     /**
1058      * @dev Transfers `tokenId` from `from` to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must be owned by `from`.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _transfer(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) private {
1072         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1073 
1074         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1075             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1076             getApproved(tokenId) == _msgSender());
1077 
1078         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1079         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1080         if (to == address(0)) revert TransferToZeroAddress();
1081 
1082         _beforeTokenTransfers(from, to, tokenId, 1);
1083 
1084         // Clear approvals from the previous owner
1085         _approve(address(0), tokenId, prevOwnership.addr);
1086 
1087         // Underflow of the sender's balance is impossible because we check for
1088         // ownership above and the recipient's balance can't realistically overflow.
1089         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1090         unchecked {
1091             _addressData[from].balance -= 1;
1092             _addressData[to].balance += 1;
1093 
1094             _ownerships[tokenId].addr = to;
1095             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1096 
1097             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1098             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1099             uint256 nextTokenId = tokenId + 1;
1100             if (_ownerships[nextTokenId].addr == address(0)) {
1101                 // This will suffice for checking _exists(nextTokenId),
1102                 // as a burned slot cannot contain the zero address.
1103                 if (nextTokenId < _currentIndex) {
1104                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1105                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1106                 }
1107             }
1108         }
1109 
1110         emit Transfer(from, to, tokenId);
1111         _afterTokenTransfers(from, to, tokenId, 1);
1112     }
1113 
1114     /**
1115      * @dev Destroys `tokenId`.
1116      * The approval is cleared when the token is burned.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _burn(uint256 tokenId) internal virtual {
1125         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1126 
1127         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId, prevOwnership.addr);
1131 
1132         // Underflow of the sender's balance is impossible because we check for
1133         // ownership above and the recipient's balance can't realistically overflow.
1134         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1135         unchecked {
1136             _addressData[prevOwnership.addr].balance -= 1;
1137             _addressData[prevOwnership.addr].numberBurned += 1;
1138 
1139             // Keep track of who burned the token, and the timestamp of burning.
1140             _ownerships[tokenId].addr = prevOwnership.addr;
1141             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1142             _ownerships[tokenId].burned = true;
1143 
1144             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1145             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1146             uint256 nextTokenId = tokenId + 1;
1147             if (_ownerships[nextTokenId].addr == address(0)) {
1148                 // This will suffice for checking _exists(nextTokenId),
1149                 // as a burned slot cannot contain the zero address.
1150                 if (nextTokenId < _currentIndex) {
1151                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1152                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1153                 }
1154             }
1155         }
1156 
1157         emit Transfer(prevOwnership.addr, address(0), tokenId);
1158         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1159 
1160         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1161         unchecked { 
1162             _burnCounter++;
1163         }
1164     }
1165 
1166     /**
1167      * @dev Approve `to` to operate on `tokenId`
1168      *
1169      * Emits a {Approval} event.
1170      */
1171     function _approve(
1172         address to,
1173         uint256 tokenId,
1174         address owner
1175     ) private {
1176         _tokenApprovals[tokenId] = to;
1177         emit Approval(owner, to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1182      * The call is not executed if the target address is not a contract.
1183      *
1184      * @param from address representing the previous owner of the given token ID
1185      * @param to target address that will receive the tokens
1186      * @param tokenId uint256 ID of the token to be transferred
1187      * @param _data bytes optional data to send along with the call
1188      * @return bool whether the call correctly returned the expected magic value
1189      */
1190     function _checkOnERC721Received(
1191         address from,
1192         address to,
1193         uint256 tokenId,
1194         bytes memory _data
1195     ) private returns (bool) {
1196         if (to.isContract()) {
1197             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1198                 return retval == IERC721Receiver(to).onERC721Received.selector;
1199             } catch (bytes memory reason) {
1200                 if (reason.length == 0) {
1201                     revert TransferToNonERC721ReceiverImplementer();
1202                 } else {
1203                     assembly {
1204                         revert(add(32, reason), mload(reason))
1205                     }
1206                 }
1207             }
1208         } else {
1209             return true;
1210         }
1211     }
1212 
1213     /**
1214      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1215      * And also called before burning one token.
1216      *
1217      * startTokenId - the first token id to be transferred
1218      * quantity - the amount to be transferred
1219      *
1220      * Calling conditions:
1221      *
1222      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1223      * transferred to `to`.
1224      * - When `from` is zero, `tokenId` will be minted for `to`.
1225      * - When `to` is zero, `tokenId` will be burned by `from`.
1226      * - `from` and `to` are never both zero.
1227      */
1228     function _beforeTokenTransfers(
1229         address from,
1230         address to,
1231         uint256 startTokenId,
1232         uint256 quantity
1233     ) internal virtual {}
1234 
1235     /**
1236      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1237      * minting.
1238      * And also called after one token has been burned.
1239      *
1240      * startTokenId - the first token id to be transferred
1241      * quantity - the amount to be transferred
1242      *
1243      * Calling conditions:
1244      *
1245      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1246      * transferred to `to`.
1247      * - When `from` is zero, `tokenId` has been minted for `to`.
1248      * - When `to` is zero, `tokenId` has been burned by `from`.
1249      * - `from` and `to` are never both zero.
1250      */
1251     function _afterTokenTransfers(
1252         address from,
1253         address to,
1254         uint256 startTokenId,
1255         uint256 quantity
1256     ) internal virtual {}
1257 }
1258 
1259 contract tree_squirrelz is ERC721A, Ownable {
1260     uint256 MAX_MINTS = 20;
1261     uint256 MAX_SUPPLY = 3500;
1262     uint256 public mintRate = 0.025 ether;
1263     bool public claimIsActive = false;
1264     bool public saleIsActive = false;
1265     mapping(uint => bool) public owlzMap;
1266 
1267     address public constant BARNOWLZ = 0x2a281305a50627a22eC3e7d82aE656AdFee6D964;
1268 
1269     string public baseURI = "";
1270 
1271     constructor() ERC721A("Tree Squirrelz", "sqrlz") {}
1272 
1273     function mint(uint256 quantity) external payable {
1274         // _safeMint's second argument now takes in a quantity, not a tokenId.
1275         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1276         require(quantity <= MAX_MINTS, "You can't mint more than 20 in one transaction");
1277         require(msg.value >= (mintRate * quantity), "Not enough ether sent");
1278         require(saleIsActive, "Public mint period not active");
1279         _safeMint(msg.sender, quantity);
1280     }
1281 
1282     function claimCheck(address user) view public returns (bool) {
1283         uint256 numtokens = IERC721Enumerable(BARNOWLZ).balanceOf(user);
1284         for (uint256 i = 0; i < numtokens; i++) {
1285             uint256 tokenId = IERC721Enumerable(BARNOWLZ).tokenOfOwnerByIndex(user, i);
1286             if(owlzMap[tokenId] == false) {
1287                 return true;
1288             }
1289         }
1290         return false;
1291     }
1292 
1293     function freeClaim(uint numberOfTokens) public payable {
1294         require(claimIsActive, "Claim has not started yet");
1295         require(numberOfTokens <= MAX_MINTS, "You can't claim more than 20 in one transaction");
1296         require(numberOfTokens > 0, "You can't claim 0 squirrelz");
1297         require(claimCheck(msg.sender) == true, "You don't own any owlz eligible for a free claim");
1298 
1299         uint256 j = 0;
1300         uint256 maxClaimable = IERC721Enumerable(BARNOWLZ).balanceOf(msg.sender);
1301         for (uint256 i = 0; i < maxClaimable; i++) {
1302             uint256 tokenId = IERC721Enumerable(BARNOWLZ).tokenOfOwnerByIndex(msg.sender, i);
1303             if (owlzMap[tokenId] != true && totalSupply() < MAX_SUPPLY) {
1304                 owlzMap[tokenId] = true;
1305                 j++;
1306             }
1307             if (j == numberOfTokens || j == maxClaimable) {
1308                 _safeMint(msg.sender, j);
1309                 break;
1310             }
1311         }
1312         
1313     }
1314 
1315     function withdraw() external payable onlyOwner {
1316         payable(owner()).transfer(address(this).balance);
1317     }
1318 
1319     function _baseURI() internal view override returns (string memory) {
1320         return baseURI;
1321     }
1322 
1323     function setMintRate(uint256 _mintRate) public onlyOwner {
1324         mintRate = _mintRate;
1325     }
1326 
1327     function setBaseURI(string memory uri) public onlyOwner {
1328         baseURI = uri;
1329     }
1330 
1331     function flipSaleState() public onlyOwner {
1332         saleIsActive = !saleIsActive;
1333     }
1334 
1335     function flipClaimState() public onlyOwner {
1336         claimIsActive = !claimIsActive;
1337     }
1338 }