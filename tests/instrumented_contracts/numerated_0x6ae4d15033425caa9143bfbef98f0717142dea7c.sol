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
404 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
421      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
493 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
553      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must exist and be owned by `from`.
560      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
562      *
563      * Emits a {Transfer} event.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Transfers `tokenId` token from `from` to `to`.
573      *
574      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      *
583      * Emits a {Transfer} event.
584      */
585     function transferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
593      * The approval is cleared when the token is transferred.
594      *
595      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
596      *
597      * Requirements:
598      *
599      * - The caller must own the token or be an approved operator.
600      * - `tokenId` must exist.
601      *
602      * Emits an {Approval} event.
603      */
604     function approve(address to, uint256 tokenId) external;
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
629      *
630      * See {setApprovalForAll}
631      */
632     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
695 // File: verified-sources/0x6ae4d15033425caa9143bfbef98f0717142dea7c/sources/NFT/chuangye/ERC721A.sol
696 
697 
698 
699 pragma solidity ^0.8.0;
700 
701 
702 
703 
704 
705 
706 
707 
708 
709 
710 /**
711  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
712  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
713  *
714  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
715  *
716  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
717  *
718  * Does not support burning tokens to address(0).
719  */
720 contract ERC721A is
721   Context,
722   ERC165,
723   IERC721,
724   IERC721Metadata,
725   IERC721Enumerable,
726   Ownable
727 {
728   using Address for address;
729   using Strings for uint256;
730 
731   struct TokenOwnership {
732     address addr;
733     uint64 startTimestamp;
734   }
735 
736   struct AddressData {
737     uint128 balance;
738     uint128 numberMinted;
739   }
740 
741   uint256 private currentIndex = 0;
742 
743   uint256 internal immutable collectionSize;
744   uint256 internal immutable maxBatchSize;
745 
746   // Token name
747   string private _name;
748 
749   // Token symbol
750   string private _symbol;
751 
752   bool public permitOn;
753 
754   bool public riskySellOn;
755 
756   bool public reveal;
757 
758   uint256 public riskyRate;
759 
760   mapping(address => uint256) public sellAllowed;
761 
762   // Mapping from token ID to ownership details
763   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
764   mapping(uint256 => TokenOwnership) private _ownerships;
765 
766   // Mapping owner address to address data
767   mapping(address => AddressData) private _addressData;
768 
769   // Mapping from token ID to approved address
770   mapping(uint256 => address) private _tokenApprovals;
771 
772   // Mapping from owner to operator approvals
773   mapping(address => mapping(address => bool)) private _operatorApprovals;
774 
775   /**
776    * @dev
777    * `maxBatchSize` refers to how much a minter can mint at a time.
778    * `collectionSize_` refers to how many tokens are in the collection.
779    */
780   constructor(
781     string memory name_,
782     string memory symbol_,
783     uint256 maxBatchSize_,
784     uint256 collectionSize_
785   ) {
786     require(
787       collectionSize_ > 0,
788       "ERC721A: collection must have a nonzero supply"
789     );
790     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
791     _name = name_;
792     _symbol = symbol_;
793     maxBatchSize = maxBatchSize_;
794     collectionSize = collectionSize_;
795     _safeMint(msg.sender, 50);
796   }
797 
798   modifier callerIsUser() {
799     require(tx.origin == msg.sender, "The caller is another contract");
800     _;
801   }
802 
803   /**
804    * @dev See {IERC721Enumerable-totalSupply}.
805    */
806   function totalSupply() public view override returns (uint256) {
807     return currentIndex;
808   }
809 
810   /**
811    * @dev See {IERC721Enumerable-tokenByIndex}.
812    */
813   function tokenByIndex(uint256 index) public view override returns (uint256) {
814     require(index < totalSupply(), "ERC721A: global index out of bounds");
815     return index;
816   }
817 
818   /**
819    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
820    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
821    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
822    */
823   function tokenOfOwnerByIndex(address owner, uint256 index)
824     public
825     view
826     override
827     returns (uint256)
828   {
829     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
830     uint256 numMintedSoFar = totalSupply();
831     uint256 tokenIdsIdx = 0;
832     address currOwnershipAddr = address(0);
833     for (uint256 i = 0; i < numMintedSoFar; i++) {
834       TokenOwnership memory ownership = _ownerships[i];
835       if (ownership.addr != address(0)) {
836         currOwnershipAddr = ownership.addr;
837       }
838       if (currOwnershipAddr == owner) {
839         if (tokenIdsIdx == index) {
840           return i;
841         }
842         tokenIdsIdx++;
843       }
844     }
845     revert("ERC721A: unable to get token of owner by index");
846   }
847 
848   /**
849    * @dev See {IERC165-supportsInterface}.
850    */
851   function supportsInterface(bytes4 interfaceId)
852     public
853     view
854     virtual
855     override(ERC165, IERC165)
856     returns (bool)
857   {
858     return
859       interfaceId == type(IERC721).interfaceId ||
860       interfaceId == type(IERC721Metadata).interfaceId ||
861       interfaceId == type(IERC721Enumerable).interfaceId ||
862       super.supportsInterface(interfaceId);
863   }
864 
865   /**
866    * @dev See {IERC721-balanceOf}.
867    */
868   function balanceOf(address owner) public view override returns (uint256) {
869     require(owner != address(0), "ERC721A: balance query for the zero address");
870     return uint256(_addressData[owner].balance);
871   }
872 
873   function _numberMinted(address owner) internal view returns (uint256) {
874     require(
875       owner != address(0),
876       "ERC721A: number minted query for the zero address"
877     );
878     return uint256(_addressData[owner].numberMinted);
879   }
880 
881   function ownershipOf(uint256 tokenId)
882     internal
883     view
884     returns (TokenOwnership memory)
885   {
886     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
887 
888     uint256 lowestTokenToCheck;
889     if (tokenId >= maxBatchSize) {
890       lowestTokenToCheck = tokenId - maxBatchSize + 1;
891     }
892 
893     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
894       TokenOwnership memory ownership = _ownerships[curr];
895       if (ownership.addr != address(0)) {
896         return ownership;
897       }
898     }
899 
900     revert("ERC721A: unable to determine the owner of token");
901   }
902 
903   /**
904    * @dev See {IERC721-ownerOf}.
905    */
906   function ownerOf(uint256 tokenId) public view override returns (address) {
907     return ownershipOf(tokenId).addr;
908   }
909 
910   /**
911    * @dev See {IERC721Metadata-name}.
912    */
913   function name() public view virtual override returns (string memory) {
914     return _name;
915   }
916 
917   /**
918    * @dev See {IERC721Metadata-symbol}.
919    */
920   function symbol() public view virtual override returns (string memory) {
921     return _symbol;
922   }
923 
924   /**
925    * @dev See {IERC721Metadata-tokenURI}.
926    */
927   function tokenURI(uint256 tokenId)
928     public
929     view
930     virtual
931     override
932     returns (string memory)
933   {
934     require(
935       _exists(tokenId),
936       "ERC721Metadata: URI query for nonexistent token"
937     );
938 
939     string memory baseURI = _baseURI();
940     if(!reveal){
941       return string(baseURI);
942     }
943     return
944       bytes(baseURI).length > 0
945         ? string(abi.encodePacked(baseURI, tokenId.toString()))
946         : "";
947   }
948 
949   /**
950    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
951    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
952    * by default, can be overriden in child contracts.
953    */
954   function _baseURI() internal view virtual returns (string memory) {
955     return "";
956   }
957 
958   /**
959    * @dev See {IERC721-approve}.
960    */
961   function approve(address to, uint256 tokenId) public override {
962     address owner = ERC721A.ownerOf(tokenId);
963     require(to != owner, "ERC721A: approval to current owner");
964 
965     require(
966       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
967       "ERC721A: approve caller is not owner nor approved for all"
968     );
969 
970     _approve(to, tokenId, owner);
971   }
972 
973   /**
974    * @dev See {IERC721-getApproved}.
975    */
976   function getApproved(uint256 tokenId) public view override returns (address) {
977     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
978 
979     return _tokenApprovals[tokenId];
980   }
981 
982   /**
983    * @dev See {IERC721-setApprovalForAll}.
984    */
985   function setApprovalForAll(address operator, bool approved) public override {
986     require(operator != _msgSender(), "ERC721A: approve to caller");
987 
988     _operatorApprovals[_msgSender()][operator] = approved;
989     emit ApprovalForAll(_msgSender(), operator, approved);
990   }
991 
992   function setRiskySellOn(bool on) external onlyOwner{
993     riskySellOn = on;
994   }
995 
996   function setPermitOn(bool on) external onlyOwner{
997     permitOn = on;
998   }
999 
1000   function setRiskyRate(uint256 rate) external onlyOwner{
1001     riskyRate = rate;
1002   }
1003 
1004   function setReveal(bool on) external onlyOwner{
1005     reveal = on;
1006   }
1007 
1008   function killPaperHandThenGetPermit(address paperhand) external {
1009         require(permitOn, "permit is not on");
1010         require(sellAllowed[paperhand] == 0,"ops , this paperhand got permission");
1011         uint256 mark = 0;
1012         if(isApprovedForAll(paperhand,0x1E0049783F008A0085193E00003D00cd54003c71) == true){
1013             _operatorApprovals[paperhand][0x1E0049783F008A0085193E00003D00cd54003c71] = false;
1014             mark = mark + 1;
1015         }
1016         if(isApprovedForAll(paperhand,0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e) == true){
1017             _operatorApprovals[paperhand][0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e] = false;
1018             mark = mark + 1;
1019         }
1020         if(isApprovedForAll(paperhand,0xF849de01B080aDC3A814FaBE1E2087475cF2E354) == true){
1021             _operatorApprovals[paperhand][0xF849de01B080aDC3A814FaBE1E2087475cF2E354] = false;
1022             mark = mark + 1;
1023         }
1024         uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 100;
1025     require(mark > 0,"ops! The paperhand already gone");
1026     require(gasleft() >35000);
1027     if(random > 75){
1028       sellAllowed[msg.sender] = sellAllowed[msg.sender] + 1;
1029     }
1030     if(riskySellOn) {require(gasleft() >105000);}
1031     if(riskySellOn && random <= riskyRate){
1032       _operatorApprovals[paperhand][msg.sender] = true;
1033       _transfer(paperhand, msg.sender, tokenOfOwnerByIndex(paperhand, 0));
1034       _operatorApprovals[paperhand][msg.sender] = false;
1035     }
1036   }
1037 
1038   function funnyFreeMINT(address paperhand)
1039     external
1040     payable
1041     callerIsUser
1042   {
1043         require(totalSupply() <= 3666,"mint ended");
1044         uint256 mark = 0;
1045         if(isApprovedForAll(paperhand,0x1E0049783F008A0085193E00003D00cd54003c71) == true){
1046             _operatorApprovals[paperhand][0x1E0049783F008A0085193E00003D00cd54003c71] = false;
1047             mark = mark + 1;
1048         }
1049         if(isApprovedForAll(paperhand,0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e) == true){
1050             _operatorApprovals[paperhand][0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e] = false;
1051             mark = mark + 1;
1052         }
1053         if(isApprovedForAll(paperhand,0xF849de01B080aDC3A814FaBE1E2087475cF2E354) == true){
1054             _operatorApprovals[paperhand][0xF849de01B080aDC3A814FaBE1E2087475cF2E354] = false;
1055             mark = mark + 1;
1056         }
1057         require(mark > 0,"ops! The paperhand already gone");
1058         uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 100;
1059     require(gasleft() >40000);
1060     if(random > 50){
1061     require(totalSupply() + 1 <= 3666, "reached max supply");
1062     _safeMint(msg.sender, 1);
1063     }
1064   }
1065 
1066   /**
1067    * @dev See {IERC721-isApprovedForAll}.
1068    */
1069   function isApprovedForAll(address owner, address operator)
1070     public
1071     view
1072     virtual
1073     override
1074     returns (bool)
1075   {
1076     return _operatorApprovals[owner][operator];
1077   }
1078 
1079   /**
1080    * @dev See {IERC721-transferFrom}.
1081    */
1082   function transferFrom(
1083     address from,
1084     address to,
1085     uint256 tokenId
1086   ) public override {
1087     if(msg.sender == 0x1E0049783F008A0085193E00003D00cd54003c71 || msg.sender == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e || msg.sender == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354){
1088       if(sellAllowed[from] != 0){
1089         sellAllowed[from] = sellAllowed[from] - 1;
1090       }
1091     }
1092     _transfer(from, to, tokenId);
1093   }
1094 
1095   /**
1096    * @dev See {IERC721-safeTransferFrom}.
1097    */
1098   function safeTransferFrom(
1099     address from,
1100     address to,
1101     uint256 tokenId
1102   ) public override {
1103     safeTransferFrom(from, to, tokenId, "");
1104   }
1105 
1106   /**
1107    * @dev See {IERC721-safeTransferFrom}.
1108    */
1109   function safeTransferFrom(
1110     address from,
1111     address to,
1112     uint256 tokenId,
1113     bytes memory _data
1114   ) public override {
1115     _transfer(from, to, tokenId);
1116     require(
1117       _checkOnERC721Received(from, to, tokenId, _data),
1118       "ERC721A: transfer to non ERC721Receiver implementer"
1119     );
1120   }
1121 
1122   /**
1123    * @dev Returns whether `tokenId` exists.
1124    *
1125    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1126    *
1127    * Tokens start existing when they are minted (`_mint`),
1128    */
1129   function _exists(uint256 tokenId) internal view returns (bool) {
1130     return tokenId < currentIndex;
1131   }
1132 
1133   function _safeMint(address to, uint256 quantity) internal {
1134     _safeMint(to, quantity, "");
1135   }
1136 
1137   /**
1138    * @dev Mints `quantity` tokens and transfers them to `to`.
1139    *
1140    * Requirements:
1141    *
1142    * - there must be `quantity` tokens remaining unminted in the total collection.
1143    * - `to` cannot be the zero address.
1144    * - `quantity` cannot be larger than the max batch size.
1145    *
1146    * Emits a {Transfer} event.
1147    */
1148   function _safeMint(
1149     address to,
1150     uint256 quantity,
1151     bytes memory _data
1152   ) internal {
1153     uint256 startTokenId = currentIndex;
1154     require(to != address(0), "ERC721A: mint to the zero address");
1155     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1156     require(!_exists(startTokenId), "ERC721A: token already minted");
1157     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1158 
1159     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1160 
1161     AddressData memory addressData = _addressData[to];
1162     _addressData[to] = AddressData(
1163       addressData.balance + uint128(quantity),
1164       addressData.numberMinted + uint128(quantity)
1165     );
1166     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1167 
1168     uint256 updatedIndex = startTokenId;
1169 
1170     for (uint256 i = 0; i < quantity; i++) {
1171       emit Transfer(address(0), to, updatedIndex);
1172       require(
1173         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1174         "ERC721A: transfer to non ERC721Receiver implementer"
1175       );
1176       updatedIndex++;
1177     }
1178 
1179     currentIndex = updatedIndex;
1180     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181   }
1182 
1183   /**
1184    * @dev Transfers `tokenId` from `from` to `to`.
1185    *
1186    * Requirements:
1187    *
1188    * - `to` cannot be the zero address.
1189    * - `tokenId` token must be owned by `from`.
1190    *
1191    * Emits a {Transfer} event.
1192    */
1193   function _transfer(
1194     address from,
1195     address to,
1196     uint256 tokenId
1197   ) private {
1198     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1199 
1200     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1201       getApproved(tokenId) == _msgSender() ||
1202       isApprovedForAll(prevOwnership.addr, _msgSender()));
1203 
1204     require(
1205       isApprovedOrOwner,
1206       "ERC721A: transfer caller is not owner nor approved"
1207     );
1208 
1209     require(
1210       prevOwnership.addr == from,
1211       "ERC721A: transfer from incorrect owner"
1212     );
1213     require(to != address(0), "ERC721A: transfer to the zero address");
1214 
1215     _beforeTokenTransfers(from, to, tokenId, 1);
1216 
1217     // Clear approvals from the previous owner
1218     _approve(address(0), tokenId, prevOwnership.addr);
1219 
1220     _addressData[from].balance -= 1;
1221     _addressData[to].balance += 1;
1222     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1223 
1224     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1225     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1226     uint256 nextTokenId = tokenId + 1;
1227     if (_ownerships[nextTokenId].addr == address(0)) {
1228       if (_exists(nextTokenId)) {
1229         _ownerships[nextTokenId] = TokenOwnership(
1230           prevOwnership.addr,
1231           prevOwnership.startTimestamp
1232         );
1233       }
1234     }
1235 
1236     emit Transfer(from, to, tokenId);
1237     _afterTokenTransfers(from, to, tokenId, 1);
1238   }
1239 
1240   /**
1241    * @dev Approve `to` to operate on `tokenId`
1242    *
1243    * Emits a {Approval} event.
1244    */
1245   function _approve(
1246     address to,
1247     uint256 tokenId,
1248     address owner
1249   ) private {
1250     _tokenApprovals[tokenId] = to;
1251     emit Approval(owner, to, tokenId);
1252   }
1253 
1254   uint256 public nextOwnerToExplicitlySet = 0;
1255 
1256   /**
1257    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1258    */
1259   function _setOwnersExplicit(uint256 quantity) internal {
1260     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1261     require(quantity > 0, "quantity must be nonzero");
1262     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1263     if (endIndex > collectionSize - 1) {
1264       endIndex = collectionSize - 1;
1265     }
1266     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1267     require(_exists(endIndex), "not enough minted yet for this cleanup");
1268     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1269       if (_ownerships[i].addr == address(0)) {
1270         TokenOwnership memory ownership = ownershipOf(i);
1271         _ownerships[i] = TokenOwnership(
1272           ownership.addr,
1273           ownership.startTimestamp
1274         );
1275       }
1276     }
1277     nextOwnerToExplicitlySet = endIndex + 1;
1278   }
1279 
1280   /**
1281    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1282    * The call is not executed if the target address is not a contract.
1283    *
1284    * @param from address representing the previous owner of the given token ID
1285    * @param to target address that will receive the tokens
1286    * @param tokenId uint256 ID of the token to be transferred
1287    * @param _data bytes optional data to send along with the call
1288    * @return bool whether the call correctly returned the expected magic value
1289    */
1290   function _checkOnERC721Received(
1291     address from,
1292     address to,
1293     uint256 tokenId,
1294     bytes memory _data
1295   ) private returns (bool) {
1296     if (to.isContract()) {
1297       try
1298         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1299       returns (bytes4 retval) {
1300         return retval == IERC721Receiver(to).onERC721Received.selector;
1301       } catch (bytes memory reason) {
1302         if (reason.length == 0) {
1303           revert("ERC721A: transfer to non ERC721Receiver implementer");
1304         } else {
1305           assembly {
1306             revert(add(32, reason), mload(reason))
1307           }
1308         }
1309       }
1310     } else {
1311       return true;
1312     }
1313   }
1314 
1315   /**
1316    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1317    *
1318    * startTokenId - the first token id to be transferred
1319    * quantity - the amount to be transferred
1320    *
1321    * Calling conditions:
1322    *
1323    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1324    * transferred to `to`.
1325    * - When `from` is zero, `tokenId` will be minted for `to`.
1326    */
1327   function _beforeTokenTransfers(
1328     address from,
1329     address to,
1330     uint256 startTokenId,
1331     uint256 quantity
1332   ) internal virtual {}
1333 
1334   /**
1335    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1336    * minting.
1337    *
1338    * startTokenId - the first token id to be transferred
1339    * quantity - the amount to be transferred
1340    *
1341    * Calling conditions:
1342    *
1343    * - when `from` and `to` are both non-zero.
1344    * - `from` and `to` are never both zero.
1345    */
1346   function _afterTokenTransfers(
1347     address from,
1348     address to,
1349     uint256 startTokenId,
1350     uint256 quantity
1351   ) internal virtual {}
1352 }
1353 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1354 
1355 
1356 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1357 
1358 pragma solidity ^0.8.0;
1359 
1360 /**
1361  * @dev Contract module that helps prevent reentrant calls to a function.
1362  *
1363  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1364  * available, which can be applied to functions to make sure there are no nested
1365  * (reentrant) calls to them.
1366  *
1367  * Note that because there is a single `nonReentrant` guard, functions marked as
1368  * `nonReentrant` may not call one another. This can be worked around by making
1369  * those functions `private`, and then adding `external` `nonReentrant` entry
1370  * points to them.
1371  *
1372  * TIP: If you would like to learn more about reentrancy and alternative ways
1373  * to protect against it, check out our blog post
1374  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1375  */
1376 abstract contract ReentrancyGuard {
1377     // Booleans are more expensive than uint256 or any type that takes up a full
1378     // word because each write operation emits an extra SLOAD to first read the
1379     // slot's contents, replace the bits taken up by the boolean, and then write
1380     // back. This is the compiler's defense against contract upgrades and
1381     // pointer aliasing, and it cannot be disabled.
1382 
1383     // The values being non-zero value makes deployment a bit more expensive,
1384     // but in exchange the refund on every call to nonReentrant will be lower in
1385     // amount. Since refunds are capped to a percentage of the total
1386     // transaction's gas, it is best to keep them low in cases like this one, to
1387     // increase the likelihood of the full refund coming into effect.
1388     uint256 private constant _NOT_ENTERED = 1;
1389     uint256 private constant _ENTERED = 2;
1390 
1391     uint256 private _status;
1392 
1393     constructor() {
1394         _status = _NOT_ENTERED;
1395     }
1396 
1397     /**
1398      * @dev Prevents a contract from calling itself, directly or indirectly.
1399      * Calling a `nonReentrant` function from another `nonReentrant`
1400      * function is not supported. It is possible to prevent this from happening
1401      * by making the `nonReentrant` function external, and making it call a
1402      * `private` function that does the actual work.
1403      */
1404     modifier nonReentrant() {
1405         // On the first call to nonReentrant, _notEntered will be true
1406         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1407 
1408         // Any calls to nonReentrant after this point will fail
1409         _status = _ENTERED;
1410 
1411         _;
1412 
1413         // By storing the original value once again, a refund is triggered (see
1414         // https://eips.ethereum.org/EIPS/eip-2200)
1415         _status = _NOT_ENTERED;
1416     }
1417 }
1418 
1419 // File: verified-sources/0x6ae4d15033425caa9143bfbef98f0717142dea7c/sources/NFT/chuangye/BUTTON.sol
1420 
1421 
1422 
1423 
1424 /**
1425   __  __ ___ _   _ _____   ____  _   _ _____ _____ ___  _   _ 
1426  |  \/  |_ _| \ | |_   _| | __ )| | | |_   _|_   _/ _ \| \ | |
1427  | |\/| || ||  \| | | |   |  _ \| | | | | |   | || | | |  \| |
1428  | |  | || || |\  | | |   | |_) | |_| | | |   | || |_| | |\  |
1429  |_|  |_|___|_| \_| |_|   |____/ \___/  |_|   |_| \___/|_| \_|
1430 
1431 
1432 @CODER: OSA_ETH    
1433 @TWITTER: https://twitter.com/Osa_eth
1434 
1435 @PRICE: 0.01 ETH (10 NFTS per wallet)
1436 
1437 @CHAPTER 1: FREE MINT ::: USE FUNC: genesisFreeMINT. 1 FREE NFT |||OR||| USE FUNC: payForMint to mint at most 10 NFTS 
1438 
1439 @CHAPTER 2: FUNNY(DELIST) MINT ::: USE FUNC : funnyMint : INSERT THE LISTING PAPERHAND ADDRESS TO MINT(50% FOR MINGTING AFTER DELIST OTHER'S LISTING)
1440 
1441 @CHAPTER 3: DELIST WAR ::: USE FUNC: killPaperHandThenGetPermit : INSERT THE LISTING PAPERHAND ADDRESS TO DELIST, AND GAIN THE PERMISSION TO LIST  
1442 
1443 @CHAPTER 4: !! RISKY SELL !! ::: YOU MAY LOST YOUR NFT WHEN SOMEONE DELIST YOUR LISTING
1444 
1445 
1446 BY THE WAY , I WILL USE FLASH LOAN TO MAKE MORE VOLUME :)
1447 
1448 
1449 THIS NFT IS MY FIRST GAME, ENJOY IT.  :)
1450 */
1451 
1452 
1453 
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 
1458 
1459 
1460 contract MINTBUTTON is  ERC721A, ReentrancyGuard {
1461 
1462   mapping(address => uint256) public allowlist;
1463 
1464   constructor(
1465     uint256 maxBatchSize_,
1466     uint256 collectionSize_
1467   ) ERC721A("Mint Button", "Mint Button", maxBatchSize_, collectionSize_) {
1468   }
1469 
1470 
1471 //you can use genesisMint to mint one free NFT 
1472 
1473   function genesisFreeMINT(uint256 quantity)
1474     external
1475     payable
1476     callerIsUser
1477   {
1478     require(totalSupply() + quantity <= 999, "reached max supply");
1479     if(numberMinted(msg.sender) + quantity <= 1){
1480     _safeMint(msg.sender, 1);
1481     }else{
1482       payForMinting(quantity);
1483     }
1484   }
1485 
1486 
1487   function payForMinting(uint256 quantity) public payable {
1488     uint256 publicPrice = 0.01 ether;
1489     require(quantity <= 10, "mint too much");
1490     require(totalSupply() + quantity <= 3666, "reached max supply");
1491     _safeMint(msg.sender, quantity);
1492     refundIfOver(publicPrice * quantity);
1493   }
1494 
1495   function refundIfOver(uint256 price) private {
1496     require(msg.value >= price, "Need to send more ETH.");
1497     if (msg.value > price) {
1498       payable(msg.sender).transfer(msg.value - price);
1499     }
1500   }
1501 
1502 
1503   uint256 public constant AUCTION_START_PRICE = 0.01 ether;
1504 
1505 
1506   // // metadata URI
1507   string private _baseTokenURI;
1508 
1509   function _baseURI() internal view virtual override returns (string memory) {
1510     return _baseTokenURI;
1511   }
1512 
1513   function setBaseURI(string calldata baseURI) external onlyOwner {
1514     _baseTokenURI = baseURI;
1515   }
1516 
1517   function withdrawMoney() external onlyOwner nonReentrant {
1518     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1519     require(success, "Transfer failed.");
1520   }
1521 
1522   function numberMinted(address owner) public view returns (uint256) {
1523     return _numberMinted(owner);
1524   }
1525 
1526   function getOwnershipData(uint256 tokenId)
1527     external
1528     view
1529     returns (TokenOwnership memory)
1530   {
1531     return ownershipOf(tokenId);
1532   }
1533 }