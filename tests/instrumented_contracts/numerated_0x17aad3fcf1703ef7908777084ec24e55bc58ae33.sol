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
695 // File: contracts/ClementineNFT2.sol
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
710 
711 error ApprovalCallerNotOwnerNorApproved();
712 error ApprovalQueryForNonexistentToken();
713 error ApproveToCaller();
714 error ApprovalToCurrentOwner();
715 error BalanceQueryForZeroAddress();
716 error MintedQueryForZeroAddress();
717 error BurnedQueryForZeroAddress();
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
731  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
732  *
733  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
734  *
735  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
736  *
737  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
738  */
739 contract ERC721A is
740     Context,
741     ERC165,
742     IERC721,
743     IERC721Metadata,
744     IERC721Enumerable
745 {
746     using Address for address;
747     using Strings for uint256;
748 
749     // Compiler will pack this into a single 256bit word.
750     struct TokenOwnership {
751         // The address of the owner.
752         address addr;
753         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
754         uint64 startTimestamp;
755         // Whether the token has been burned.
756         bool burned;
757     }
758 
759     // Compiler will pack this into a single 256bit word.
760     struct AddressData {
761         // Realistically, 2**64-1 is more than enough.
762         uint64 balance;
763         // Keeps track of mint count with minimal overhead for tokenomics.
764         uint64 numberMinted;
765         // Keeps track of burn count with minimal overhead for tokenomics.
766         uint64 numberBurned;
767     }
768 
769     // The tokenId of the next token to be minted.
770     uint256 internal _currentIndex;
771 
772     // The number of tokens burned.
773     uint256 internal _burnCounter;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to ownership details
782     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
783     mapping(uint256 => TokenOwnership) internal _ownerships;
784 
785     // Mapping owner address to address data
786     mapping(address => AddressData) private _addressData;
787 
788     // Mapping from token ID to approved address
789     mapping(uint256 => address) private _tokenApprovals;
790 
791     // Mapping from owner to operator approvals
792     mapping(address => mapping(address => bool)) private _operatorApprovals;
793 
794     constructor(string memory name_, string memory symbol_) {
795         _name = name_;
796         _symbol = symbol_;
797     }
798 
799     /**
800      * @dev See {IERC721Enumerable-totalSupply}.
801      */
802     function totalSupply() public view override returns (uint256) {
803         // Counter underflow is impossible as _burnCounter cannot be incremented
804         // more than _currentIndex times
805         unchecked {
806             return _currentIndex - _burnCounter;
807         }
808     }
809 
810     /**
811      * @dev See {IERC721Enumerable-tokenByIndex}.
812      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
813      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
814      */
815     function tokenByIndex(uint256 index)
816         public
817         view
818         override
819         returns (uint256)
820     {
821         uint256 numMintedSoFar = _currentIndex;
822         uint256 tokenIdsIdx;
823 
824         // Counter overflow is impossible as the loop breaks when
825         // uint256 i is equal to another uint256 numMintedSoFar.
826         unchecked {
827             for (uint256 i; i < numMintedSoFar; i++) {
828                 TokenOwnership memory ownership = _ownerships[i];
829                 if (!ownership.burned) {
830                     if (tokenIdsIdx == index) {
831                         return i;
832                     }
833                     tokenIdsIdx++;
834                 }
835             }
836         }
837         revert TokenIndexOutOfBounds();
838     }
839 
840     /**
841      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
842      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
843      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
844      */
845     function tokenOfOwnerByIndex(address owner, uint256 index)
846         public
847         view
848         override
849         returns (uint256)
850     {
851         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
852         uint256 numMintedSoFar = _currentIndex;
853         uint256 tokenIdsIdx;
854         address currOwnershipAddr;
855 
856         // Counter overflow is impossible as the loop breaks when
857         // uint256 i is equal to another uint256 numMintedSoFar.
858         unchecked {
859             for (uint256 i; i < numMintedSoFar; i++) {
860                 TokenOwnership memory ownership = _ownerships[i];
861                 if (ownership.burned) {
862                     continue;
863                 }
864                 if (ownership.addr != address(0)) {
865                     currOwnershipAddr = ownership.addr;
866                 }
867                 if (currOwnershipAddr == owner) {
868                     if (tokenIdsIdx == index) {
869                         return i;
870                     }
871                     tokenIdsIdx++;
872                 }
873             }
874         }
875 
876         // Execution should never reach this point.
877         revert();
878     }
879 
880     /**
881      * @dev See {IERC165-supportsInterface}.
882      */
883     function supportsInterface(bytes4 interfaceId)
884         public
885         view
886         virtual
887         override(ERC165, IERC165)
888         returns (bool)
889     {
890         return
891             interfaceId == type(IERC721).interfaceId ||
892             interfaceId == type(IERC721Metadata).interfaceId ||
893             interfaceId == type(IERC721Enumerable).interfaceId ||
894             super.supportsInterface(interfaceId);
895     }
896 
897     /**
898      * @dev See {IERC721-balanceOf}.
899      */
900     function balanceOf(address owner) public view override returns (uint256) {
901         if (owner == address(0)) revert BalanceQueryForZeroAddress();
902         return uint256(_addressData[owner].balance);
903     }
904 
905     function _numberMinted(address owner) internal view returns (uint256) {
906         if (owner == address(0)) revert MintedQueryForZeroAddress();
907         return uint256(_addressData[owner].numberMinted);
908     }
909 
910     function _numberBurned(address owner) internal view returns (uint256) {
911         if (owner == address(0)) revert BurnedQueryForZeroAddress();
912         return uint256(_addressData[owner].numberBurned);
913     }
914 
915     /**
916      * Gas spent here starts off proportional to the maximum mint batch size.
917      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
918      */
919     function ownershipOf(uint256 tokenId)
920         internal
921         view
922         returns (TokenOwnership memory)
923     {
924         uint256 curr = tokenId;
925 
926         unchecked {
927             if (curr < _currentIndex) {
928                 TokenOwnership memory ownership = _ownerships[curr];
929                 if (!ownership.burned) {
930                     if (ownership.addr != address(0)) {
931                         return ownership;
932                     }
933                     // Invariant:
934                     // There will always be an ownership that has an address and is not burned
935                     // before an ownership that does not have an address and is not burned.
936                     // Hence, curr will not underflow.
937                     while (true) {
938                         curr--;
939                         ownership = _ownerships[curr];
940                         if (ownership.addr != address(0)) {
941                             return ownership;
942                         }
943                     }
944                 }
945             }
946         }
947         revert OwnerQueryForNonexistentToken();
948     }
949 
950     /**
951      * @dev See {IERC721-ownerOf}.
952      */
953     function ownerOf(uint256 tokenId) public view override returns (address) {
954         return ownershipOf(tokenId).addr;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-name}.
959      */
960     function name() public view virtual override returns (string memory) {
961         return _name;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-symbol}.
966      */
967     function symbol() public view virtual override returns (string memory) {
968         return _symbol;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-tokenURI}.
973      */
974     function tokenURI(uint256 tokenId)
975         public
976         view
977         virtual
978         override
979         returns (string memory)
980     {
981         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
982 
983         string memory baseURI = _baseURI();
984         return
985             bytes(baseURI).length != 0
986                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
987                 : "";
988     }
989 
990     /**
991      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
992      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
993      * by default, can be overriden in child contracts.
994      */
995     function _baseURI() internal view virtual returns (string memory) {
996         return "";
997     }
998 
999     /**
1000      * @dev See {IERC721-approve}.
1001      */
1002     function approve(address to, uint256 tokenId) public override {
1003         address owner = ERC721A.ownerOf(tokenId);
1004         if (to == owner) revert ApprovalToCurrentOwner();
1005 
1006         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1007             revert ApprovalCallerNotOwnerNorApproved();
1008         }
1009 
1010         _approve(to, tokenId, owner);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-getApproved}.
1015      */
1016     function getApproved(uint256 tokenId)
1017         public
1018         view
1019         override
1020         returns (address)
1021     {
1022         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1023 
1024         return _tokenApprovals[tokenId];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-setApprovalForAll}.
1029      */
1030     function setApprovalForAll(address operator, bool approved)
1031         public
1032         override
1033     {
1034         if (operator == _msgSender()) revert ApproveToCaller();
1035 
1036         _operatorApprovals[_msgSender()][operator] = approved;
1037         emit ApprovalForAll(_msgSender(), operator, approved);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-isApprovedForAll}.
1042      */
1043     function isApprovedForAll(address owner, address operator)
1044         public
1045         view
1046         virtual
1047         override
1048         returns (bool)
1049     {
1050         return _operatorApprovals[owner][operator];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-transferFrom}.
1055      */
1056     function transferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         _transfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         safeTransferFrom(from, to, tokenId, "");
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) public virtual override {
1084         _transfer(from, to, tokenId);
1085         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1086             revert TransferToNonERC721ReceiverImplementer();
1087         }
1088     }
1089 
1090     /**
1091      * @dev Returns whether `tokenId` exists.
1092      *
1093      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1094      *
1095      * Tokens start existing when they are minted (`_mint`),
1096      */
1097     function _exists(uint256 tokenId) internal view returns (bool) {
1098         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1099     }
1100 
1101     function _safeMint(address to, uint256 quantity) internal {
1102         _safeMint(to, quantity, "");
1103     }
1104 
1105     /**
1106      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1107      *
1108      * Requirements:
1109      *
1110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1111      * - `quantity` must be greater than 0.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _safeMint(
1116         address to,
1117         uint256 quantity,
1118         bytes memory _data
1119     ) internal {
1120         _mint(to, quantity, _data, true);
1121     }
1122 
1123     /**
1124      * @dev Mints `quantity` tokens and transfers them to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `quantity` must be greater than 0.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _mint(
1134         address to,
1135         uint256 quantity,
1136         bytes memory _data,
1137         bool safe
1138     ) internal {
1139         uint256 startTokenId = _currentIndex;
1140         if (to == address(0)) revert MintToZeroAddress();
1141         if (quantity == 0) revert MintZeroQuantity();
1142 
1143         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1144 
1145         // Overflows are incredibly unrealistic.
1146         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1147         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1148         unchecked {
1149             _addressData[to].balance += uint64(quantity);
1150             _addressData[to].numberMinted += uint64(quantity);
1151 
1152             _ownerships[startTokenId].addr = to;
1153             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1154 
1155             uint256 updatedIndex = startTokenId;
1156 
1157             for (uint256 i; i < quantity; i++) {
1158                 emit Transfer(address(0), to, updatedIndex);
1159                 if (
1160                     safe &&
1161                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
1162                 ) {
1163                     revert TransferToNonERC721ReceiverImplementer();
1164                 }
1165                 updatedIndex++;
1166             }
1167 
1168             _currentIndex = updatedIndex;
1169         }
1170         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _transfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) private {
1188         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1189 
1190         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1191             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1192             getApproved(tokenId) == _msgSender());
1193 
1194         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1196         if (to == address(0)) revert TransferToZeroAddress();
1197 
1198         _beforeTokenTransfers(from, to, tokenId, 1);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId, prevOwnership.addr);
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             _addressData[from].balance -= 1;
1208             _addressData[to].balance += 1;
1209 
1210             _ownerships[tokenId].addr = to;
1211             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1212 
1213             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1214             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1215             uint256 nextTokenId = tokenId + 1;
1216             if (_ownerships[nextTokenId].addr == address(0)) {
1217                 // This will suffice for checking _exists(nextTokenId),
1218                 // as a burned slot cannot contain the zero address.
1219                 if (nextTokenId < _currentIndex) {
1220                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1221                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1222                         .startTimestamp;
1223                 }
1224             }
1225         }
1226 
1227         emit Transfer(from, to, tokenId);
1228         _afterTokenTransfers(from, to, tokenId, 1);
1229     }
1230 
1231     /**
1232      * @dev Destroys `tokenId`.
1233      * The approval is cleared when the token is burned.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _burn(uint256 tokenId) internal virtual {
1242         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1243 
1244         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1245 
1246         // Clear approvals from the previous owner
1247         _approve(address(0), tokenId, prevOwnership.addr);
1248 
1249         // Underflow of the sender's balance is impossible because we check for
1250         // ownership above and the recipient's balance can't realistically overflow.
1251         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1252         unchecked {
1253             _addressData[prevOwnership.addr].balance -= 1;
1254             _addressData[prevOwnership.addr].numberBurned += 1;
1255 
1256             // Keep track of who burned the token, and the timestamp of burning.
1257             _ownerships[tokenId].addr = prevOwnership.addr;
1258             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1259             _ownerships[tokenId].burned = true;
1260 
1261             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1262             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1263             uint256 nextTokenId = tokenId + 1;
1264             if (_ownerships[nextTokenId].addr == address(0)) {
1265                 // This will suffice for checking _exists(nextTokenId),
1266                 // as a burned slot cannot contain the zero address.
1267                 if (nextTokenId < _currentIndex) {
1268                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1269                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1270                         .startTimestamp;
1271                 }
1272             }
1273         }
1274 
1275         emit Transfer(prevOwnership.addr, address(0), tokenId);
1276         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1277 
1278         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1279         unchecked {
1280             _burnCounter++;
1281         }
1282     }
1283 
1284     /**
1285      * @dev Approve `to` to operate on `tokenId`
1286      *
1287      * Emits a {Approval} event.
1288      */
1289     function _approve(
1290         address to,
1291         uint256 tokenId,
1292         address owner
1293     ) private {
1294         _tokenApprovals[tokenId] = to;
1295         emit Approval(owner, to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1300      * The call is not executed if the target address is not a contract.
1301      *
1302      * @param from address representing the previous owner of the given token ID
1303      * @param to target address that will receive the tokens
1304      * @param tokenId uint256 ID of the token to be transferred
1305      * @param _data bytes optional data to send along with the call
1306      * @return bool whether the call correctly returned the expected magic value
1307      */
1308     function _checkOnERC721Received(
1309         address from,
1310         address to,
1311         uint256 tokenId,
1312         bytes memory _data
1313     ) private returns (bool) {
1314         if (to.isContract()) {
1315             try
1316                 IERC721Receiver(to).onERC721Received(
1317                     _msgSender(),
1318                     from,
1319                     tokenId,
1320                     _data
1321                 )
1322             returns (bytes4 retval) {
1323                 return retval == IERC721Receiver(to).onERC721Received.selector;
1324             } catch (bytes memory reason) {
1325                 if (reason.length == 0) {
1326                     revert TransferToNonERC721ReceiverImplementer();
1327                 } else {
1328                     assembly {
1329                         revert(add(32, reason), mload(reason))
1330                     }
1331                 }
1332             }
1333         } else {
1334             return true;
1335         }
1336     }
1337 
1338     /**
1339      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1340      * And also called before burning one token.
1341      *
1342      * startTokenId - the first token id to be transferred
1343      * quantity - the amount to be transferred
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _beforeTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1362      * minting.
1363      * And also called after one token has been burned.
1364      *
1365      * startTokenId - the first token id to be transferred
1366      * quantity - the amount to be transferred
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` has been minted for `to`.
1373      * - When `to` is zero, `tokenId` has been burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _afterTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 }
1383 
1384 pragma solidity ^0.8.4;
1385 
1386 contract ClementineNFT2 is ERC721A, Ownable {
1387     using Strings for uint256;
1388 
1389     string baseURI;
1390     string public baseExtension = ".json";
1391     uint256 public cost = 0.2 ether;
1392     uint256 public hallPassCost = 0.1 ether;
1393     uint256 public maxSupply = 10010;
1394     uint256 public maxMintAmount = 5;
1395     uint256 public hallPasses = 0;
1396     bool public paused = true;
1397     bool public revealed = false;
1398     bool public hallPassOnly = false;
1399     bool public limitPublic = true;
1400     string public notRevealedUri;
1401 
1402     // Number of Hall Passes an address has remaining.
1403     mapping(address => uint8) public hallPass;
1404 
1405     constructor(string memory _initNotRevealedUri)
1406         ERC721A("Clementine's Nightmare", "CLEM")
1407     {
1408         setNotRevealedURI(_initNotRevealedUri);
1409     }
1410 
1411     // internal
1412     function _baseURI() internal view virtual override returns (string memory) {
1413         return baseURI;
1414     }
1415 
1416     // public
1417     function mint(uint256 _mintAmount) public payable {
1418         uint256 supply = totalSupply();
1419         require(!paused);
1420         require(_mintAmount > 0);
1421         require(supply + _mintAmount <= maxSupply);
1422 
1423         if (msg.sender != owner()) {
1424             // Don't exceed the max mint amount per tx.
1425             require(_mintAmount <= maxMintAmount);
1426 
1427             // Hall Pass settings.
1428             if (hallPassOnly == true) {
1429                 // They have enough hall passes to mint.
1430                 require(hallPass[msg.sender] >= _mintAmount);
1431                 // They have the right payment.
1432                 require(msg.value >= hallPassCost * _mintAmount);
1433                 // _mintAmount bounds check above. Safe typecast.
1434                 hallPass[msg.sender] -= uint8(_mintAmount);
1435             } else {
1436                 // Save supply for Hall passes.
1437                 if (limitPublic) {
1438                     require((supply + _mintAmount) <= (maxSupply - hallPasses));
1439                 }
1440                 // Has the right payment.
1441                 require(msg.value >= cost * _mintAmount);
1442             }
1443         }
1444 
1445         _safeMint(msg.sender, _mintAmount);
1446     }
1447 
1448     function walletOfOwner(address _owner)
1449         public
1450         view
1451         returns (uint256[] memory)
1452     {
1453         uint256 ownerTokenCount = balanceOf(_owner);
1454         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1455         for (uint256 i; i < ownerTokenCount; i++) {
1456             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1457         }
1458         return tokenIds;
1459     }
1460 
1461     function tokenURI(uint256 tokenId)
1462         public
1463         view
1464         virtual
1465         override
1466         returns (string memory)
1467     {
1468         require(
1469             _exists(tokenId),
1470             "ERC721AMetadata: URI query for nonexistent token"
1471         );
1472 
1473         if (revealed == false) {
1474             return notRevealedUri;
1475         }
1476 
1477         string memory currentBaseURI = _baseURI();
1478         return
1479             bytes(currentBaseURI).length > 0
1480                 ? string(
1481                     abi.encodePacked(
1482                         currentBaseURI,
1483                         tokenId.toString(),
1484                         baseExtension
1485                     )
1486                 )
1487                 : "";
1488     }
1489 
1490     // owner
1491     function reveal() public onlyOwner {
1492         revealed = true;
1493     }
1494 
1495     function setCost(uint256 _newCost) public onlyOwner {
1496         cost = _newCost;
1497     }
1498 
1499     function setHallPassCost(uint256 _newHallPassCost) public onlyOwner {
1500         hallPassCost = _newHallPassCost;
1501     }
1502 
1503     function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1504         maxMintAmount = _newMaxMintAmount;
1505     }
1506 
1507     function setLimitPublic(bool _newLimitPublic) public onlyOwner {
1508         limitPublic = _newLimitPublic;
1509     }
1510 
1511     function setHallPassOnly(bool _newHallPassOnly) public onlyOwner {
1512         hallPassOnly = _newHallPassOnly;
1513     }
1514 
1515     function seedHallPass(address[] memory addresses, uint8[] memory counts)
1516         external
1517         onlyOwner
1518     {
1519         require(addresses.length == counts.length);
1520 
1521         uint256 passCount;
1522 
1523         for (uint256 i = 0; i < addresses.length; i++) {
1524             hallPass[addresses[i]] = counts[i];
1525             passCount += counts[i];
1526         }
1527 
1528         hallPasses += passCount;
1529     }
1530 
1531     function removeHallPass(address[] memory addresses) external onlyOwner {
1532         uint256 passCount;
1533 
1534         for (uint256 i = 0; i < addresses.length; i++) {
1535             passCount += hallPass[addresses[i]];
1536             hallPass[addresses[i]] = 0;
1537         }
1538 
1539         hallPasses -= passCount;
1540     }
1541 
1542     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1543         notRevealedUri = _notRevealedURI;
1544     }
1545 
1546     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1547         baseURI = _newBaseURI;
1548     }
1549 
1550     function pause(bool _state) public onlyOwner {
1551         paused = _state;
1552     }
1553 
1554     function withdraw() public payable onlyOwner {
1555         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1556         require(os);
1557     }
1558 }