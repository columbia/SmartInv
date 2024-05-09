1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @title ERC721 token receiver interface
410  * @dev Interface for any contract that wants to support safeTransfers
411  * from ERC721 asset contracts.
412  */
413 interface IERC721Receiver {
414     /**
415      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
416      * by `operator` from `from`, this function is called.
417      *
418      * It must return its Solidity selector to confirm the token transfer.
419      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
420      *
421      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
422      */
423     function onERC721Received(
424         address operator,
425         address from,
426         uint256 tokenId,
427         bytes calldata data
428     ) external returns (bytes4);
429 }
430 
431 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Interface of the ERC165 standard, as defined in the
440  * https://eips.ethereum.org/EIPS/eip-165[EIP].
441  *
442  * Implementers can declare support of contract interfaces, which can then be
443  * queried by others ({ERC165Checker}).
444  *
445  * For an implementation, see {ERC165}.
446  */
447 interface IERC165 {
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30 000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 }
458 
459 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Implementation of the {IERC165} interface.
469  *
470  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
471  * for the additional interface id that will be supported. For example:
472  *
473  * ```solidity
474  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
476  * }
477  * ```
478  *
479  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
480  */
481 abstract contract ERC165 is IERC165 {
482     /**
483      * @dev See {IERC165-supportsInterface}.
484      */
485     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486         return interfaceId == type(IERC165).interfaceId;
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Returns the account approved for `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function getApproved(uint256 tokenId) external view returns (address operator);
594 
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Enumerable is IERC721 {
648     /**
649      * @dev Returns the total amount of tokens stored by the contract.
650      */
651     function totalSupply() external view returns (uint256);
652 
653     /**
654      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
655      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
656      */
657     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
658 
659     /**
660      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
661      * Use along with {totalSupply} to enumerate all tokens.
662      */
663     function tokenByIndex(uint256 index) external view returns (uint256);
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Metadata is IERC721 {
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() external view returns (string memory);
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() external view returns (string memory);
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) external view returns (string memory);
693 }
694 
695 // File: erc721a/contracts/ERC721A.sol
696 
697 
698 // Creator: Chiru Labs
699 
700 pragma solidity ^0.8.4;
701 
702 
703 
704 
705 
706 
707 
708 
709 
710 error ApprovalCallerNotOwnerNorApproved();
711 error ApprovalQueryForNonexistentToken();
712 error ApproveToCaller();
713 error ApprovalToCurrentOwner();
714 error BalanceQueryForZeroAddress();
715 error MintedQueryForZeroAddress();
716 error BurnedQueryForZeroAddress();
717 error AuxQueryForZeroAddress();
718 error MintToZeroAddress();
719 error MintZeroQuantity();
720 error OwnerIndexOutOfBounds();
721 error OwnerQueryForNonexistentToken();
722 error TokenIndexOutOfBounds();
723 error TransferCallerNotOwnerNorApproved();
724 error TransferFromIncorrectOwner();
725 error TransferToNonERC721ReceiverImplementer();
726 error TransferToZeroAddress();
727 error URIQueryForNonexistentToken();
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata extension. Built to optimize for lower gas during batch mints.
732  *
733  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
734  *
735  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
736  *
737  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
738  */
739 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
740     using Address for address;
741     using Strings for uint256;
742 
743     // Compiler will pack this into a single 256bit word.
744     struct TokenOwnership {
745         // The address of the owner.
746         address addr;
747         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
748         uint64 startTimestamp;
749         // Whether the token has been burned.
750         bool burned;
751     }
752 
753     // Compiler will pack this into a single 256bit word.
754     struct AddressData {
755         // Realistically, 2**64-1 is more than enough.
756         uint64 balance;
757         // Keeps track of mint count with minimal overhead for tokenomics.
758         uint64 numberMinted;
759         // Keeps track of burn count with minimal overhead for tokenomics.
760         uint64 numberBurned;
761         // For miscellaneous variable(s) pertaining to the address
762         // (e.g. number of whitelist mint slots used).
763         // If there are multiple variables, please pack them into a uint64.
764         uint64 aux;
765     }
766 
767     // The tokenId of the next token to be minted.
768     uint256 internal _currentIndex;
769 
770     // The number of tokens burned.
771     uint256 internal _burnCounter;
772 
773     // Token name
774     string private _name;
775 
776     // Token symbol
777     string private _symbol;
778 
779     // Mapping from token ID to ownership details
780     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
781     mapping(uint256 => TokenOwnership) internal _ownerships;
782 
783     // Mapping owner address to address data
784     mapping(address => AddressData) private _addressData;
785 
786     // Mapping from token ID to approved address
787     mapping(uint256 => address) private _tokenApprovals;
788 
789     // Mapping from owner to operator approvals
790     mapping(address => mapping(address => bool)) private _operatorApprovals;
791 
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795         _currentIndex = _startTokenId();
796     }
797 
798     /**
799      * To change the starting tokenId, please override this function.
800      */
801     function _startTokenId() internal view virtual returns (uint256) {
802         return 0;
803     }
804 
805     /**
806      * @dev See {IERC721Enumerable-totalSupply}.
807      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
808      */
809     function totalSupply() public view returns (uint256) {
810         // Counter underflow is impossible as _burnCounter cannot be incremented
811         // more than _currentIndex - _startTokenId() times
812         unchecked {
813             return _currentIndex - _burnCounter - _startTokenId();
814         }
815     }
816 
817     /**
818      * Returns the total amount of tokens minted in the contract.
819      */
820     function _totalMinted() internal view returns (uint256) {
821         // Counter underflow is impossible as _currentIndex does not decrement,
822         // and it is initialized to _startTokenId()
823         unchecked {
824             return _currentIndex - _startTokenId();
825         }
826     }
827 
828     /**
829      * @dev See {IERC165-supportsInterface}.
830      */
831     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
832         return
833             interfaceId == type(IERC721).interfaceId ||
834             interfaceId == type(IERC721Metadata).interfaceId ||
835             super.supportsInterface(interfaceId);
836     }
837 
838     /**
839      * @dev See {IERC721-balanceOf}.
840      */
841     function balanceOf(address owner) public view override returns (uint256) {
842         if (owner == address(0)) revert BalanceQueryForZeroAddress();
843         return uint256(_addressData[owner].balance);
844     }
845 
846     /**
847      * Returns the number of tokens minted by `owner`.
848      */
849     function _numberMinted(address owner) internal view returns (uint256) {
850         if (owner == address(0)) revert MintedQueryForZeroAddress();
851         return uint256(_addressData[owner].numberMinted);
852     }
853 
854     /**
855      * Returns the number of tokens burned by or on behalf of `owner`.
856      */
857     function _numberBurned(address owner) internal view returns (uint256) {
858         if (owner == address(0)) revert BurnedQueryForZeroAddress();
859         return uint256(_addressData[owner].numberBurned);
860     }
861 
862     /**
863      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
864      */
865     function _getAux(address owner) internal view returns (uint64) {
866         if (owner == address(0)) revert AuxQueryForZeroAddress();
867         return _addressData[owner].aux;
868     }
869 
870     /**
871      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
872      * If there are multiple variables, please pack them into a uint64.
873      */
874     function _setAux(address owner, uint64 aux) internal {
875         if (owner == address(0)) revert AuxQueryForZeroAddress();
876         _addressData[owner].aux = aux;
877     }
878 
879     /**
880      * Gas spent here starts off proportional to the maximum mint batch size.
881      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
882      */
883     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
884         uint256 curr = tokenId;
885 
886         unchecked {
887             if (_startTokenId() <= curr && curr < _currentIndex) {
888                 TokenOwnership memory ownership = _ownerships[curr];
889                 if (!ownership.burned) {
890                     if (ownership.addr != address(0)) {
891                         return ownership;
892                     }
893                     // Invariant:
894                     // There will always be an ownership that has an address and is not burned
895                     // before an ownership that does not have an address and is not burned.
896                     // Hence, curr will not underflow.
897                     while (true) {
898                         curr--;
899                         ownership = _ownerships[curr];
900                         if (ownership.addr != address(0)) {
901                             return ownership;
902                         }
903                     }
904                 }
905             }
906         }
907         revert OwnerQueryForNonexistentToken();
908     }
909 
910     /**
911      * @dev See {IERC721-ownerOf}.
912      */
913     function ownerOf(uint256 tokenId) public view override returns (address) {
914         return ownershipOf(tokenId).addr;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
936 
937         string memory baseURI = _baseURI();
938         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
939     }
940 
941     /**
942      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
943      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
944      * by default, can be overriden in child contracts.
945      */
946     function _baseURI() internal view virtual returns (string memory) {
947         return '';
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public override {
954         address owner = ERC721A.ownerOf(tokenId);
955         if (to == owner) revert ApprovalToCurrentOwner();
956 
957         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
958             revert ApprovalCallerNotOwnerNorApproved();
959         }
960 
961         _approve(to, tokenId, owner);
962     }
963 
964     /**
965      * @dev See {IERC721-getApproved}.
966      */
967     function getApproved(uint256 tokenId) public view override returns (address) {
968         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
969 
970         return _tokenApprovals[tokenId];
971     }
972 
973     /**
974      * @dev See {IERC721-setApprovalForAll}.
975      */
976     function setApprovalForAll(address operator, bool approved) public override {
977         if (operator == _msgSender()) revert ApproveToCaller();
978 
979         _operatorApprovals[_msgSender()][operator] = approved;
980         emit ApprovalForAll(_msgSender(), operator, approved);
981     }
982 
983     /**
984      * @dev See {IERC721-isApprovedForAll}.
985      */
986     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev See {IERC721-transferFrom}.
992      */
993     function transferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public virtual override {
998         _transfer(from, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-safeTransferFrom}.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public virtual override {
1009         safeTransferFrom(from, to, tokenId, '');
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-safeTransferFrom}.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1023             revert TransferToNonERC721ReceiverImplementer();
1024         }
1025     }
1026 
1027     /**
1028      * @dev Returns whether `tokenId` exists.
1029      *
1030      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1031      *
1032      * Tokens start existing when they are minted (`_mint`),
1033      */
1034     function _exists(uint256 tokenId) internal view returns (bool) {
1035         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1036             !_ownerships[tokenId].burned;
1037     }
1038 
1039     function _safeMint(address to, uint256 quantity) internal {
1040         _safeMint(to, quantity, '');
1041     }
1042 
1043     /**
1044      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1049      * - `quantity` must be greater than 0.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _safeMint(
1054         address to,
1055         uint256 quantity,
1056         bytes memory _data
1057     ) internal {
1058         _mint(to, quantity, _data, true);
1059     }
1060 
1061     /**
1062      * @dev Mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - `to` cannot be the zero address.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _mint(
1072         address to,
1073         uint256 quantity,
1074         bytes memory _data,
1075         bool safe
1076     ) internal {
1077         uint256 startTokenId = _currentIndex;
1078         if (to == address(0)) revert MintToZeroAddress();
1079         if (quantity == 0) revert MintZeroQuantity();
1080 
1081         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1082 
1083         // Overflows are incredibly unrealistic.
1084         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1085         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1086         unchecked {
1087             _addressData[to].balance += uint64(quantity);
1088             _addressData[to].numberMinted += uint64(quantity);
1089 
1090             _ownerships[startTokenId].addr = to;
1091             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1092 
1093             uint256 updatedIndex = startTokenId;
1094             uint256 end = updatedIndex + quantity;
1095 
1096             if (safe && to.isContract()) {
1097                 do {
1098                     emit Transfer(address(0), to, updatedIndex);
1099                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1100                         revert TransferToNonERC721ReceiverImplementer();
1101                     }
1102                 } while (updatedIndex != end);
1103                 // Reentrancy protection
1104                 if (_currentIndex != startTokenId) revert();
1105             } else {
1106                 do {
1107                     emit Transfer(address(0), to, updatedIndex++);
1108                 } while (updatedIndex != end);
1109             }
1110             _currentIndex = updatedIndex;
1111         }
1112         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1113     }
1114 
1115     /**
1116      * @dev Transfers `tokenId` from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `to` cannot be the zero address.
1121      * - `tokenId` token must be owned by `from`.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _transfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) private {
1130         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1131 
1132         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1133             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1134             getApproved(tokenId) == _msgSender());
1135 
1136         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1137         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1138         if (to == address(0)) revert TransferToZeroAddress();
1139 
1140         _beforeTokenTransfers(from, to, tokenId, 1);
1141 
1142         // Clear approvals from the previous owner
1143         _approve(address(0), tokenId, prevOwnership.addr);
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1148         unchecked {
1149             _addressData[from].balance -= 1;
1150             _addressData[to].balance += 1;
1151 
1152             _ownerships[tokenId].addr = to;
1153             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1154 
1155             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1156             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1157             uint256 nextTokenId = tokenId + 1;
1158             if (_ownerships[nextTokenId].addr == address(0)) {
1159                 // This will suffice for checking _exists(nextTokenId),
1160                 // as a burned slot cannot contain the zero address.
1161                 if (nextTokenId < _currentIndex) {
1162                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1163                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1164                 }
1165             }
1166         }
1167 
1168         emit Transfer(from, to, tokenId);
1169         _afterTokenTransfers(from, to, tokenId, 1);
1170     }
1171 
1172     /**
1173      * @dev Destroys `tokenId`.
1174      * The approval is cleared when the token is burned.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _burn(uint256 tokenId) internal virtual {
1183         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1184 
1185         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId, prevOwnership.addr);
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             _addressData[prevOwnership.addr].balance -= 1;
1195             _addressData[prevOwnership.addr].numberBurned += 1;
1196 
1197             // Keep track of who burned the token, and the timestamp of burning.
1198             _ownerships[tokenId].addr = prevOwnership.addr;
1199             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1200             _ownerships[tokenId].burned = true;
1201 
1202             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1203             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1204             uint256 nextTokenId = tokenId + 1;
1205             if (_ownerships[nextTokenId].addr == address(0)) {
1206                 // This will suffice for checking _exists(nextTokenId),
1207                 // as a burned slot cannot contain the zero address.
1208                 if (nextTokenId < _currentIndex) {
1209                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1210                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1211                 }
1212             }
1213         }
1214 
1215         emit Transfer(prevOwnership.addr, address(0), tokenId);
1216         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1217 
1218         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1219         unchecked {
1220             _burnCounter++;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Approve `to` to operate on `tokenId`
1226      *
1227      * Emits a {Approval} event.
1228      */
1229     function _approve(
1230         address to,
1231         uint256 tokenId,
1232         address owner
1233     ) private {
1234         _tokenApprovals[tokenId] = to;
1235         emit Approval(owner, to, tokenId);
1236     }
1237 
1238     /**
1239      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1240      *
1241      * @param from address representing the previous owner of the given token ID
1242      * @param to target address that will receive the tokens
1243      * @param tokenId uint256 ID of the token to be transferred
1244      * @param _data bytes optional data to send along with the call
1245      * @return bool whether the call correctly returned the expected magic value
1246      */
1247     function _checkContractOnERC721Received(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory _data
1252     ) private returns (bool) {
1253         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1254             return retval == IERC721Receiver(to).onERC721Received.selector;
1255         } catch (bytes memory reason) {
1256             if (reason.length == 0) {
1257                 revert TransferToNonERC721ReceiverImplementer();
1258             } else {
1259                 assembly {
1260                     revert(add(32, reason), mload(reason))
1261                 }
1262             }
1263         }
1264     }
1265 
1266     /**
1267      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1268      * And also called before burning one token.
1269      *
1270      * startTokenId - the first token id to be transferred
1271      * quantity - the amount to be transferred
1272      *
1273      * Calling conditions:
1274      *
1275      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1276      * transferred to `to`.
1277      * - When `from` is zero, `tokenId` will be minted for `to`.
1278      * - When `to` is zero, `tokenId` will be burned by `from`.
1279      * - `from` and `to` are never both zero.
1280      */
1281     function _beforeTokenTransfers(
1282         address from,
1283         address to,
1284         uint256 startTokenId,
1285         uint256 quantity
1286     ) internal virtual {}
1287 
1288     /**
1289      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1290      * minting.
1291      * And also called after one token has been burned.
1292      *
1293      * startTokenId - the first token id to be transferred
1294      * quantity - the amount to be transferred
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` has been minted for `to`.
1301      * - When `to` is zero, `tokenId` has been burned by `from`.
1302      * - `from` and `to` are never both zero.
1303      */
1304     function _afterTokenTransfers(
1305         address from,
1306         address to,
1307         uint256 startTokenId,
1308         uint256 quantity
1309     ) internal virtual {}
1310 }
1311 
1312 // File: contracts/InvisibleDucks.sol
1313 
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 
1318 
1319  contract InvisibleDucks is ERC721A, Ownable {
1320     using Address for address;
1321     using Strings for uint256;
1322     
1323     string public baseURI;
1324 
1325     uint256 public constant TOTAL_FREE = 999;
1326     uint256 public constant MAX_FREE = 5;
1327     uint256 public constant MAX_PUBLIC = 10;
1328 
1329     string public constant BASE_EXTENSION = ".json";
1330 
1331     uint256 public maxSupply = 6969;
1332     uint256 public price = 0.0069 ether;
1333 
1334     bool public saleActive = false;
1335     bool public adminClaimed = false;
1336 
1337     constructor() ERC721A("InvisibleDucks", "IVDKS") { 
1338     }
1339 
1340     function adminMint() public onlyOwner {
1341         require(!adminClaimed, "Admim has claimed");
1342         adminClaimed = true;
1343         _safeMint( msg.sender, 10); 
1344     }
1345 
1346     function freeMint(uint256 _numberOfMints) private {
1347         require(_numberOfMints > 0 && _numberOfMints <= MAX_FREE, "Invalid mint amount");
1348         if(totalSupply() + _numberOfMints > TOTAL_FREE){
1349             _safeMint( msg.sender, TOTAL_FREE - totalSupply()); 
1350         } else {
1351             _safeMint( msg.sender, _numberOfMints); 
1352         }   
1353     }
1354     
1355     function publicMint(uint256 _numberOfMints) private {
1356         require(_numberOfMints > 0 && _numberOfMints <= MAX_PUBLIC, "Invalid mint amount");
1357         require(totalSupply() + _numberOfMints <= maxSupply, "Purchase would exceed max supply of tokens");
1358         require(price * _numberOfMints == msg.value, "Ether value sent is not correct");
1359         
1360         _safeMint( msg.sender, _numberOfMints );
1361     }
1362 
1363     function mint(uint256 _numberOfMints) public payable {
1364         require(saleActive, "Sales not yet started");
1365         require(tx.origin == msg.sender, "Please no");
1366         if(totalSupply() < TOTAL_FREE){
1367             freeMint(_numberOfMints);
1368         } else {
1369             publicMint(_numberOfMints);
1370         }
1371     }
1372 
1373     function setSupply(uint256 _maxSupply) public onlyOwner {
1374         maxSupply = _maxSupply;
1375     }
1376 
1377     function setPrice(uint256 _price) public onlyOwner {
1378         price = _price;
1379     }
1380 
1381     function toggleSale() public onlyOwner {
1382         saleActive = !saleActive;
1383     }
1384 
1385     function setBaseURI(string memory uri) public onlyOwner {
1386         baseURI = uri;
1387     }
1388     
1389     function _baseURI() internal view override returns (string memory) {
1390         return baseURI;
1391     }
1392 
1393     function tokenURI(uint256 _id) public view virtual override returns (string memory) {
1394          require(
1395             _exists(_id),
1396             "ERC721Metadata: URI query for nonexistent token"
1397         );
1398 
1399         string memory currentBaseURI = _baseURI();
1400         return bytes(currentBaseURI).length > 0
1401             ? string(abi.encodePacked(currentBaseURI, _id.toString(), BASE_EXTENSION))
1402             : "";
1403     }
1404 
1405     function reserve(address to, uint256 quantity) external onlyOwner {
1406         require(totalSupply() + quantity <= maxSupply, "Exceeds supply");
1407         _safeMint(to, quantity);
1408     }
1409 
1410     function withdraw(address _address) public onlyOwner {
1411         uint256 balance = address(this).balance;
1412         payable(_address).transfer(balance);
1413     }    
1414 }