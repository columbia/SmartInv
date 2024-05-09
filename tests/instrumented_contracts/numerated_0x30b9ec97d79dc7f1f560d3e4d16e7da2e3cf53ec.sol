1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
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
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/utils/Address.sol
178 
179 
180 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
181 
182 pragma solidity ^0.8.1;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      *
205      * [IMPORTANT]
206      * ====
207      * You shouldn't rely on `isContract` to protect against flash loan attacks!
208      *
209      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
210      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
211      * constructor.
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize/address.code.length, which returns 0
216         // for contracts in construction, since the code is only stored at the end
217         // of the constructor execution.
218 
219         return account.code.length > 0;
220     }
221 
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(address(this).balance >= amount, "Address: insufficient balance");
240 
241         (bool success, ) = recipient.call{value: amount}("");
242         require(success, "Address: unable to send value, recipient may have reverted");
243     }
244 
245     /**
246      * @dev Performs a Solidity function call using a low level `call`. A
247      * plain `call` is an unsafe replacement for a function call: use this
248      * function instead.
249      *
250      * If `target` reverts with a revert reason, it is bubbled up by this
251      * function (like regular Solidity function calls).
252      *
253      * Returns the raw returned data. To convert to the expected return value,
254      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
255      *
256      * Requirements:
257      *
258      * - `target` must be a contract.
259      * - calling `target` with `data` must not revert.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionCall(target, data, "Address: low-level call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
269      * `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but also transferring `value` wei to `target`.
284      *
285      * Requirements:
286      *
287      * - the calling contract must have an ETH balance of at least `value`.
288      * - the called Solidity function must be `payable`.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
302      * with `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(address(this).balance >= value, "Address: insufficient balance for call");
313         require(isContract(target), "Address: call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.call{value: value}(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
326         return functionStaticCall(target, data, "Address: low-level static call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.delegatecall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
375      * revert reason using the provided one.
376      *
377      * _Available since v4.3._
378      */
379     function verifyCallResult(
380         bool success,
381         bytes memory returndata,
382         string memory errorMessage
383     ) internal pure returns (bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC721 token receiver interface
411  * @dev Interface for any contract that wants to support safeTransfers
412  * from ERC721 asset contracts.
413  */
414 interface IERC721Receiver {
415     /**
416      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
417      * by `operator` from `from`, this function is called.
418      *
419      * It must return its Solidity selector to confirm the token transfer.
420      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
421      *
422      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
423      */
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Interface of the ERC165 standard, as defined in the
441  * https://eips.ethereum.org/EIPS/eip-165[EIP].
442  *
443  * Implementers can declare support of contract interfaces, which can then be
444  * queried by others ({ERC165Checker}).
445  *
446  * For an implementation, see {ERC165}.
447  */
448 interface IERC165 {
449     /**
450      * @dev Returns true if this contract implements the interface defined by
451      * `interfaceId`. See the corresponding
452      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
453      * to learn more about how these ids are created.
454      *
455      * This function call must use less than 30 000 gas.
456      */
457     function supportsInterface(bytes4 interfaceId) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev Implementation of the {IERC165} interface.
470  *
471  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
472  * for the additional interface id that will be supported. For example:
473  *
474  * ```solidity
475  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
476  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
477  * }
478  * ```
479  *
480  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
481  */
482 abstract contract ERC165 is IERC165 {
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487         return interfaceId == type(IERC165).interfaceId;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev Required interface of an ERC721 compliant contract.
501  */
502 interface IERC721 is IERC165 {
503     /**
504      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
505      */
506     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
515      */
516     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
517 
518     /**
519      * @dev Returns the number of tokens in ``owner``'s account.
520      */
521     function balanceOf(address owner) external view returns (uint256 balance);
522 
523     /**
524      * @dev Returns the owner of the `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function ownerOf(uint256 tokenId) external view returns (address owner);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
534      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) external;
551 
552     /**
553      * @dev Transfers `tokenId` token from `from` to `to`.
554      *
555      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must be owned by `from`.
562      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
563      *
564      * Emits a {Transfer} event.
565      */
566     function transferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
574      * The approval is cleared when the token is transferred.
575      *
576      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
577      *
578      * Requirements:
579      *
580      * - The caller must own the token or be an approved operator.
581      * - `tokenId` must exist.
582      *
583      * Emits an {Approval} event.
584      */
585     function approve(address to, uint256 tokenId) external;
586 
587     /**
588      * @dev Returns the account approved for `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function getApproved(uint256 tokenId) external view returns (address operator);
595 
596     /**
597      * @dev Approve or remove `operator` as an operator for the caller.
598      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
599      *
600      * Requirements:
601      *
602      * - The `operator` cannot be the caller.
603      *
604      * Emits an {ApprovalForAll} event.
605      */
606     function setApprovalForAll(address operator, bool _approved) external;
607 
608     /**
609      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
610      *
611      * See {setApprovalForAll}
612      */
613     function isApprovedForAll(address owner, address operator) external view returns (bool);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
646  * @dev See https://eips.ethereum.org/EIPS/eip-721
647  */
648 interface IERC721Enumerable is IERC721 {
649     /**
650      * @dev Returns the total amount of tokens stored by the contract.
651      */
652     function totalSupply() external view returns (uint256);
653 
654     /**
655      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
656      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
657      */
658     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
659 
660     /**
661      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
662      * Use along with {totalSupply} to enumerate all tokens.
663      */
664     function tokenByIndex(uint256 index) external view returns (uint256);
665 }
666 
667 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Metadata is IERC721 {
680     /**
681      * @dev Returns the token collection name.
682      */
683     function name() external view returns (string memory);
684 
685     /**
686      * @dev Returns the token collection symbol.
687      */
688     function symbol() external view returns (string memory);
689 
690     /**
691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
692      */
693     function tokenURI(uint256 tokenId) external view returns (string memory);
694 }
695 
696 // File: ERC721A.sol
697 
698 
699 // Creator: Chiru Labs
700 
701 pragma solidity ^0.8.0;
702 
703 
704 
705 
706 
707 
708 
709 
710 
711 /**
712  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
713  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
714  *
715  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
716  *
717  * Does not support burning tokens to address(0).
718  */
719 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
720     using Address for address;
721     using Strings for uint256;
722 
723     struct TokenOwnership {
724         address addr;
725         uint64 startTimestamp;
726     }
727 
728     struct AddressData {
729         uint128 balance;
730         uint128 numberMinted;
731     }
732 
733     uint256 private currentIndex = 0;
734 
735     uint256 internal immutable maxBatchSize;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to ownership details
744     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
745     mapping(uint256 => TokenOwnership) private _ownerships;
746 
747     // Mapping owner address to address data
748     mapping(address => AddressData) private _addressData;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     /**
757      * @dev
758      * `maxBatchSize` refers to how much a minter can mint at a time.
759      */
760     constructor(
761         string memory name_,
762         string memory symbol_,
763         uint256 maxBatchSize_
764     ) {
765         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
766         _name = name_;
767         _symbol = symbol_;
768         maxBatchSize = maxBatchSize_;
769     }
770 
771     /**
772      * @dev See {IERC721Enumerable-totalSupply}.
773      */
774     function totalSupply() public view override returns (uint256) {
775         return currentIndex;
776     }
777 
778     /**
779      * @dev See {IERC721Enumerable-tokenByIndex}.
780      */
781     function tokenByIndex(uint256 index) public view override returns (uint256) {
782         require(index < totalSupply(), "ERC721A: global index out of bounds");
783         return index;
784     }
785 
786     /**
787      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
788      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
789      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
790      */
791     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
792         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
793         uint256 numMintedSoFar = totalSupply();
794         uint256 tokenIdsIdx = 0;
795         address currOwnershipAddr = address(0);
796         for (uint256 i = 0; i < numMintedSoFar; i++) {
797             TokenOwnership memory ownership = _ownerships[i];
798             if (ownership.addr != address(0)) {
799                 currOwnershipAddr = ownership.addr;
800             }
801             if (currOwnershipAddr == owner) {
802                 if (tokenIdsIdx == index) {
803                     return i;
804                 }
805                 tokenIdsIdx++;
806             }
807         }
808         revert("ERC721A: unable to get token of owner by index");
809     }
810 
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
815         return
816             interfaceId == type(IERC721).interfaceId ||
817             interfaceId == type(IERC721Metadata).interfaceId ||
818             interfaceId == type(IERC721Enumerable).interfaceId ||
819             super.supportsInterface(interfaceId);
820     }
821 
822     /**
823      * @dev See {IERC721-balanceOf}.
824      */
825     function balanceOf(address owner) public view override returns (uint256) {
826         require(owner != address(0), "ERC721A: balance query for the zero address");
827         return uint256(_addressData[owner].balance);
828     }
829 
830     function _numberMinted(address owner) internal view returns (uint256) {
831         require(owner != address(0), "ERC721A: number minted query for the zero address");
832         return uint256(_addressData[owner].numberMinted);
833     }
834 
835     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
836         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
837 
838         uint256 lowestTokenToCheck;
839         if (tokenId >= maxBatchSize) {
840             lowestTokenToCheck = tokenId - maxBatchSize + 1;
841         }
842 
843         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
844             TokenOwnership memory ownership = _ownerships[curr];
845             if (ownership.addr != address(0)) {
846                 return ownership;
847             }
848         }
849 
850         revert("ERC721A: unable to determine the owner of token");
851     }
852 
853     /**
854      * @dev See {IERC721-ownerOf}.
855      */
856     function ownerOf(uint256 tokenId) public view override returns (address) {
857         return ownershipOf(tokenId).addr;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-name}.
862      */
863     function name() public view virtual override returns (string memory) {
864         return _name;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-symbol}.
869      */
870     function symbol() public view virtual override returns (string memory) {
871         return _symbol;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-tokenURI}.
876      */
877     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
878         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
879 
880         string memory baseURI = _baseURI();
881         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
882     }
883 
884     /**
885      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
886      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
887      * by default, can be overriden in child contracts.
888      */
889     function _baseURI() internal view virtual returns (string memory) {
890         return "";
891     }
892 
893     /**
894      * @dev See {IERC721-approve}.
895      */
896     function approve(address to, uint256 tokenId) public override {
897         address owner = ERC721A.ownerOf(tokenId);
898         require(to != owner, "ERC721A: approval to current owner");
899 
900         require(
901             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
902             "ERC721A: approve caller is not owner nor approved for all"
903         );
904 
905         _approve(to, tokenId, owner);
906     }
907 
908     /**
909      * @dev See {IERC721-getApproved}.
910      */
911     function getApproved(uint256 tokenId) public view override returns (address) {
912         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
913 
914         return _tokenApprovals[tokenId];
915     }
916 
917     /**
918      * @dev See {IERC721-setApprovalForAll}.
919      */
920     function setApprovalForAll(address operator, bool approved) public override {
921         require(operator != _msgSender(), "ERC721A: approve to caller");
922 
923         _operatorApprovals[_msgSender()][operator] = approved;
924         emit ApprovalForAll(_msgSender(), operator, approved);
925     }
926 
927     /**
928      * @dev See {IERC721-isApprovedForAll}.
929      */
930     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
931         return _operatorApprovals[owner][operator];
932     }
933 
934     /**
935      * @dev See {IERC721-transferFrom}.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public override {
942         _transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public override {
953         safeTransferFrom(from, to, tokenId, "");
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) public override {
965         _transfer(from, to, tokenId);
966         require(
967             _checkOnERC721Received(from, to, tokenId, _data),
968             "ERC721A: transfer to non ERC721Receiver implementer"
969         );
970     }
971 
972     /**
973      * @dev Returns whether `tokenId` exists.
974      *
975      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
976      *
977      * Tokens start existing when they are minted (`_mint`),
978      */
979     function _exists(uint256 tokenId) internal view returns (bool) {
980         return tokenId < currentIndex;
981     }
982 
983     function _safeMint(address to, uint256 quantity) internal {
984         _safeMint(to, quantity, "");
985     }
986 
987     /**
988      * @dev Mints `quantity` tokens and transfers them to `to`.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `quantity` cannot be larger than the max batch size.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _safeMint(
998         address to,
999         uint256 quantity,
1000         bytes memory _data
1001     ) internal {
1002         uint256 startTokenId = currentIndex;
1003         require(to != address(0), "ERC721A: mint to the zero address");
1004         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1005         require(!_exists(startTokenId), "ERC721A: token already minted");
1006         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1007 
1008         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1009 
1010         AddressData memory addressData = _addressData[to];
1011         _addressData[to] = AddressData(
1012             addressData.balance + uint128(quantity),
1013             addressData.numberMinted + uint128(quantity)
1014         );
1015         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1016 
1017         uint256 updatedIndex = startTokenId;
1018 
1019         for (uint256 i = 0; i < quantity; i++) {
1020             emit Transfer(address(0), to, updatedIndex);
1021             require(
1022                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1023                 "ERC721A: transfer to non ERC721Receiver implementer"
1024             );
1025             updatedIndex++;
1026         }
1027 
1028         currentIndex = updatedIndex;
1029         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1030     }
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _transfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) private {
1047         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1048 
1049         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1050             getApproved(tokenId) == _msgSender() ||
1051             isApprovedForAll(prevOwnership.addr, _msgSender()));
1052 
1053         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1054 
1055         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1056         require(to != address(0), "ERC721A: transfer to the zero address");
1057 
1058         _beforeTokenTransfers(from, to, tokenId, 1);
1059 
1060         // Clear approvals from the previous owner
1061         _approve(address(0), tokenId, prevOwnership.addr);
1062 
1063         _addressData[from].balance -= 1;
1064         _addressData[to].balance += 1;
1065         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1066 
1067         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1068         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1069         uint256 nextTokenId = tokenId + 1;
1070         if (_ownerships[nextTokenId].addr == address(0)) {
1071             if (_exists(nextTokenId)) {
1072                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1073             }
1074         }
1075 
1076         emit Transfer(from, to, tokenId);
1077         _afterTokenTransfers(from, to, tokenId, 1);
1078     }
1079 
1080     /**
1081      * @dev Approve `to` to operate on `tokenId`
1082      *
1083      * Emits a {Approval} event.
1084      */
1085     function _approve(
1086         address to,
1087         uint256 tokenId,
1088         address owner
1089     ) private {
1090         _tokenApprovals[tokenId] = to;
1091         emit Approval(owner, to, tokenId);
1092     }
1093 
1094     uint256 public nextOwnerToExplicitlySet = 0;
1095 
1096     /**
1097      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1098      */
1099     function _setOwnersExplicit(uint256 quantity) internal {
1100         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1101         require(quantity > 0, "quantity must be nonzero");
1102         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1103         if (endIndex > currentIndex - 1) {
1104             endIndex = currentIndex - 1;
1105         }
1106         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1107         require(_exists(endIndex), "not enough minted yet for this cleanup");
1108         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1109             if (_ownerships[i].addr == address(0)) {
1110                 TokenOwnership memory ownership = ownershipOf(i);
1111                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1112             }
1113         }
1114         nextOwnerToExplicitlySet = endIndex + 1;
1115     }
1116 
1117     /**
1118      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1119      * The call is not executed if the target address is not a contract.
1120      *
1121      * @param from address representing the previous owner of the given token ID
1122      * @param to target address that will receive the tokens
1123      * @param tokenId uint256 ID of the token to be transferred
1124      * @param _data bytes optional data to send along with the call
1125      * @return bool whether the call correctly returned the expected magic value
1126      */
1127     function _checkOnERC721Received(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) private returns (bool) {
1133         if (to.isContract()) {
1134             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1135                 return retval == IERC721Receiver(to).onERC721Received.selector;
1136             } catch (bytes memory reason) {
1137                 if (reason.length == 0) {
1138                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1139                 } else {
1140                     assembly {
1141                         revert(add(32, reason), mload(reason))
1142                     }
1143                 }
1144             }
1145         } else {
1146             return true;
1147         }
1148     }
1149 
1150     /**
1151      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1152      *
1153      * startTokenId - the first token id to be transferred
1154      * quantity - the amount to be transferred
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      */
1162     function _beforeTokenTransfers(
1163         address from,
1164         address to,
1165         uint256 startTokenId,
1166         uint256 quantity
1167     ) internal virtual {}
1168 
1169     /**
1170      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1171      * minting.
1172      *
1173      * startTokenId - the first token id to be transferred
1174      * quantity - the amount to be transferred
1175      *
1176      * Calling conditions:
1177      *
1178      * - when `from` and `to` are both non-zero.
1179      * - `from` and `to` are never both zero.
1180      */
1181     function _afterTokenTransfers(
1182         address from,
1183         address to,
1184         uint256 startTokenId,
1185         uint256 quantity
1186     ) internal virtual {}
1187 }
1188 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1189 
1190 
1191 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1192 
1193 pragma solidity ^0.8.0;
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 
1202 /**
1203  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1204  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1205  * {ERC721Enumerable}.
1206  */
1207 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1208     using Address for address;
1209     using Strings for uint256;
1210 
1211     // Token name
1212     string private _name;
1213 
1214     // Token symbol
1215     string private _symbol;
1216 
1217     // Mapping from token ID to owner address
1218     mapping(uint256 => address) private _owners;
1219 
1220     // Mapping owner address to token count
1221     mapping(address => uint256) private _balances;
1222 
1223     // Mapping from token ID to approved address
1224     mapping(uint256 => address) private _tokenApprovals;
1225 
1226     // Mapping from owner to operator approvals
1227     mapping(address => mapping(address => bool)) private _operatorApprovals;
1228 
1229     /**
1230      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1231      */
1232     constructor(string memory name_, string memory symbol_) {
1233         _name = name_;
1234         _symbol = symbol_;
1235     }
1236 
1237     /**
1238      * @dev See {IERC165-supportsInterface}.
1239      */
1240     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1241         return
1242             interfaceId == type(IERC721).interfaceId ||
1243             interfaceId == type(IERC721Metadata).interfaceId ||
1244             super.supportsInterface(interfaceId);
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-balanceOf}.
1249      */
1250     function balanceOf(address owner) public view virtual override returns (uint256) {
1251         require(owner != address(0), "ERC721: balance query for the zero address");
1252         return _balances[owner];
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-ownerOf}.
1257      */
1258     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1259         address owner = _owners[tokenId];
1260         require(owner != address(0), "ERC721: owner query for nonexistent token");
1261         return owner;
1262     }
1263 
1264     /**
1265      * @dev See {IERC721Metadata-name}.
1266      */
1267     function name() public view virtual override returns (string memory) {
1268         return _name;
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Metadata-symbol}.
1273      */
1274     function symbol() public view virtual override returns (string memory) {
1275         return _symbol;
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Metadata-tokenURI}.
1280      */
1281     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1282         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1283 
1284         string memory baseURI = _baseURI();
1285         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1286     }
1287 
1288     /**
1289      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1290      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1291      * by default, can be overriden in child contracts.
1292      */
1293     function _baseURI() internal view virtual returns (string memory) {
1294         return "";
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-approve}.
1299      */
1300     function approve(address to, uint256 tokenId) public virtual override {
1301         address owner = ERC721.ownerOf(tokenId);
1302         require(to != owner, "ERC721: approval to current owner");
1303 
1304         require(
1305             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1306             "ERC721: approve caller is not owner nor approved for all"
1307         );
1308 
1309         _approve(to, tokenId);
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-getApproved}.
1314      */
1315     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1316         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1317 
1318         return _tokenApprovals[tokenId];
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-setApprovalForAll}.
1323      */
1324     function setApprovalForAll(address operator, bool approved) public virtual override {
1325         _setApprovalForAll(_msgSender(), operator, approved);
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-isApprovedForAll}.
1330      */
1331     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1332         return _operatorApprovals[owner][operator];
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-transferFrom}.
1337      */
1338     function transferFrom(
1339         address from,
1340         address to,
1341         uint256 tokenId
1342     ) public virtual override {
1343         //solhint-disable-next-line max-line-length
1344         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1345 
1346         _transfer(from, to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-safeTransferFrom}.
1351      */
1352     function safeTransferFrom(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) public virtual override {
1357         safeTransferFrom(from, to, tokenId, "");
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-safeTransferFrom}.
1362      */
1363     function safeTransferFrom(
1364         address from,
1365         address to,
1366         uint256 tokenId,
1367         bytes memory _data
1368     ) public virtual override {
1369         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1370         _safeTransfer(from, to, tokenId, _data);
1371     }
1372 
1373     /**
1374      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1375      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1376      *
1377      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1378      *
1379      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1380      * implement alternative mechanisms to perform token transfer, such as signature-based.
1381      *
1382      * Requirements:
1383      *
1384      * - `from` cannot be the zero address.
1385      * - `to` cannot be the zero address.
1386      * - `tokenId` token must exist and be owned by `from`.
1387      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _safeTransfer(
1392         address from,
1393         address to,
1394         uint256 tokenId,
1395         bytes memory _data
1396     ) internal virtual {
1397         _transfer(from, to, tokenId);
1398         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1399     }
1400 
1401     /**
1402      * @dev Returns whether `tokenId` exists.
1403      *
1404      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1405      *
1406      * Tokens start existing when they are minted (`_mint`),
1407      * and stop existing when they are burned (`_burn`).
1408      */
1409     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1410         return _owners[tokenId] != address(0);
1411     }
1412 
1413     /**
1414      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1415      *
1416      * Requirements:
1417      *
1418      * - `tokenId` must exist.
1419      */
1420     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1421         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1422         address owner = ERC721.ownerOf(tokenId);
1423         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1424     }
1425 
1426     /**
1427      * @dev Safely mints `tokenId` and transfers it to `to`.
1428      *
1429      * Requirements:
1430      *
1431      * - `tokenId` must not exist.
1432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _safeMint(address to, uint256 tokenId) internal virtual {
1437         _safeMint(to, tokenId, "");
1438     }
1439 
1440     /**
1441      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1442      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1443      */
1444     function _safeMint(
1445         address to,
1446         uint256 tokenId,
1447         bytes memory _data
1448     ) internal virtual {
1449         _mint(to, tokenId);
1450         require(
1451             _checkOnERC721Received(address(0), to, tokenId, _data),
1452             "ERC721: transfer to non ERC721Receiver implementer"
1453         );
1454     }
1455 
1456     /**
1457      * @dev Mints `tokenId` and transfers it to `to`.
1458      *
1459      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1460      *
1461      * Requirements:
1462      *
1463      * - `tokenId` must not exist.
1464      * - `to` cannot be the zero address.
1465      *
1466      * Emits a {Transfer} event.
1467      */
1468     function _mint(address to, uint256 tokenId) internal virtual {
1469         require(to != address(0), "ERC721: mint to the zero address");
1470         require(!_exists(tokenId), "ERC721: token already minted");
1471 
1472         _beforeTokenTransfer(address(0), to, tokenId);
1473 
1474         _balances[to] += 1;
1475         _owners[tokenId] = to;
1476 
1477         emit Transfer(address(0), to, tokenId);
1478 
1479         _afterTokenTransfer(address(0), to, tokenId);
1480     }
1481 
1482     /**
1483      * @dev Destroys `tokenId`.
1484      * The approval is cleared when the token is burned.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must exist.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _burn(uint256 tokenId) internal virtual {
1493         address owner = ERC721.ownerOf(tokenId);
1494 
1495         _beforeTokenTransfer(owner, address(0), tokenId);
1496 
1497         // Clear approvals
1498         _approve(address(0), tokenId);
1499 
1500         _balances[owner] -= 1;
1501         delete _owners[tokenId];
1502 
1503         emit Transfer(owner, address(0), tokenId);
1504 
1505         _afterTokenTransfer(owner, address(0), tokenId);
1506     }
1507 
1508     /**
1509      * @dev Transfers `tokenId` from `from` to `to`.
1510      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1511      *
1512      * Requirements:
1513      *
1514      * - `to` cannot be the zero address.
1515      * - `tokenId` token must be owned by `from`.
1516      *
1517      * Emits a {Transfer} event.
1518      */
1519     function _transfer(
1520         address from,
1521         address to,
1522         uint256 tokenId
1523     ) internal virtual {
1524         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1525         require(to != address(0), "ERC721: transfer to the zero address");
1526 
1527         _beforeTokenTransfer(from, to, tokenId);
1528 
1529         // Clear approvals from the previous owner
1530         _approve(address(0), tokenId);
1531 
1532         _balances[from] -= 1;
1533         _balances[to] += 1;
1534         _owners[tokenId] = to;
1535 
1536         emit Transfer(from, to, tokenId);
1537 
1538         _afterTokenTransfer(from, to, tokenId);
1539     }
1540 
1541     /**
1542      * @dev Approve `to` to operate on `tokenId`
1543      *
1544      * Emits a {Approval} event.
1545      */
1546     function _approve(address to, uint256 tokenId) internal virtual {
1547         _tokenApprovals[tokenId] = to;
1548         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1549     }
1550 
1551     /**
1552      * @dev Approve `operator` to operate on all of `owner` tokens
1553      *
1554      * Emits a {ApprovalForAll} event.
1555      */
1556     function _setApprovalForAll(
1557         address owner,
1558         address operator,
1559         bool approved
1560     ) internal virtual {
1561         require(owner != operator, "ERC721: approve to caller");
1562         _operatorApprovals[owner][operator] = approved;
1563         emit ApprovalForAll(owner, operator, approved);
1564     }
1565 
1566     /**
1567      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1568      * The call is not executed if the target address is not a contract.
1569      *
1570      * @param from address representing the previous owner of the given token ID
1571      * @param to target address that will receive the tokens
1572      * @param tokenId uint256 ID of the token to be transferred
1573      * @param _data bytes optional data to send along with the call
1574      * @return bool whether the call correctly returned the expected magic value
1575      */
1576     function _checkOnERC721Received(
1577         address from,
1578         address to,
1579         uint256 tokenId,
1580         bytes memory _data
1581     ) private returns (bool) {
1582         if (to.isContract()) {
1583             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1584                 return retval == IERC721Receiver.onERC721Received.selector;
1585             } catch (bytes memory reason) {
1586                 if (reason.length == 0) {
1587                     revert("ERC721: transfer to non ERC721Receiver implementer");
1588                 } else {
1589                     assembly {
1590                         revert(add(32, reason), mload(reason))
1591                     }
1592                 }
1593             }
1594         } else {
1595             return true;
1596         }
1597     }
1598 
1599     /**
1600      * @dev Hook that is called before any token transfer. This includes minting
1601      * and burning.
1602      *
1603      * Calling conditions:
1604      *
1605      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1606      * transferred to `to`.
1607      * - When `from` is zero, `tokenId` will be minted for `to`.
1608      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1609      * - `from` and `to` are never both zero.
1610      *
1611      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1612      */
1613     function _beforeTokenTransfer(
1614         address from,
1615         address to,
1616         uint256 tokenId
1617     ) internal virtual {}
1618 
1619     /**
1620      * @dev Hook that is called after any transfer of tokens. This includes
1621      * minting and burning.
1622      *
1623      * Calling conditions:
1624      *
1625      * - when `from` and `to` are both non-zero.
1626      * - `from` and `to` are never both zero.
1627      *
1628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1629      */
1630     function _afterTokenTransfer(
1631         address from,
1632         address to,
1633         uint256 tokenId
1634     ) internal virtual {}
1635 }
1636 
1637 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1638 
1639 
1640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1641 
1642 pragma solidity ^0.8.0;
1643 
1644 
1645 
1646 /**
1647  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1648  * enumerability of all the token ids in the contract as well as all token ids owned by each
1649  * account.
1650  */
1651 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1652     // Mapping from owner to list of owned token IDs
1653     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1654 
1655     // Mapping from token ID to index of the owner tokens list
1656     mapping(uint256 => uint256) private _ownedTokensIndex;
1657 
1658     // Array with all token ids, used for enumeration
1659     uint256[] private _allTokens;
1660 
1661     // Mapping from token id to position in the allTokens array
1662     mapping(uint256 => uint256) private _allTokensIndex;
1663 
1664     /**
1665      * @dev See {IERC165-supportsInterface}.
1666      */
1667     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1668         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1669     }
1670 
1671     /**
1672      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1673      */
1674     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1675         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1676         return _ownedTokens[owner][index];
1677     }
1678 
1679     /**
1680      * @dev See {IERC721Enumerable-totalSupply}.
1681      */
1682     function totalSupply() public view virtual override returns (uint256) {
1683         return _allTokens.length;
1684     }
1685 
1686     /**
1687      * @dev See {IERC721Enumerable-tokenByIndex}.
1688      */
1689     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1690         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1691         return _allTokens[index];
1692     }
1693 
1694     /**
1695      * @dev Hook that is called before any token transfer. This includes minting
1696      * and burning.
1697      *
1698      * Calling conditions:
1699      *
1700      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1701      * transferred to `to`.
1702      * - When `from` is zero, `tokenId` will be minted for `to`.
1703      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1704      * - `from` cannot be the zero address.
1705      * - `to` cannot be the zero address.
1706      *
1707      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1708      */
1709     function _beforeTokenTransfer(
1710         address from,
1711         address to,
1712         uint256 tokenId
1713     ) internal virtual override {
1714         super._beforeTokenTransfer(from, to, tokenId);
1715 
1716         if (from == address(0)) {
1717             _addTokenToAllTokensEnumeration(tokenId);
1718         } else if (from != to) {
1719             _removeTokenFromOwnerEnumeration(from, tokenId);
1720         }
1721         if (to == address(0)) {
1722             _removeTokenFromAllTokensEnumeration(tokenId);
1723         } else if (to != from) {
1724             _addTokenToOwnerEnumeration(to, tokenId);
1725         }
1726     }
1727 
1728     /**
1729      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1730      * @param to address representing the new owner of the given token ID
1731      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1732      */
1733     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1734         uint256 length = ERC721.balanceOf(to);
1735         _ownedTokens[to][length] = tokenId;
1736         _ownedTokensIndex[tokenId] = length;
1737     }
1738 
1739     /**
1740      * @dev Private function to add a token to this extension's token tracking data structures.
1741      * @param tokenId uint256 ID of the token to be added to the tokens list
1742      */
1743     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1744         _allTokensIndex[tokenId] = _allTokens.length;
1745         _allTokens.push(tokenId);
1746     }
1747 
1748     /**
1749      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1750      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1751      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1752      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1753      * @param from address representing the previous owner of the given token ID
1754      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1755      */
1756     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1757         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1758         // then delete the last slot (swap and pop).
1759 
1760         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1761         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1762 
1763         // When the token to delete is the last token, the swap operation is unnecessary
1764         if (tokenIndex != lastTokenIndex) {
1765             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1766 
1767             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1768             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1769         }
1770 
1771         // This also deletes the contents at the last position of the array
1772         delete _ownedTokensIndex[tokenId];
1773         delete _ownedTokens[from][lastTokenIndex];
1774     }
1775 
1776     /**
1777      * @dev Private function to remove a token from this extension's token tracking data structures.
1778      * This has O(1) time complexity, but alters the order of the _allTokens array.
1779      * @param tokenId uint256 ID of the token to be removed from the tokens list
1780      */
1781     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1782         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1783         // then delete the last slot (swap and pop).
1784 
1785         uint256 lastTokenIndex = _allTokens.length - 1;
1786         uint256 tokenIndex = _allTokensIndex[tokenId];
1787 
1788         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1789         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1790         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1791         uint256 lastTokenId = _allTokens[lastTokenIndex];
1792 
1793         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1794         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1795 
1796         // This also deletes the contents at the last position of the array
1797         delete _allTokensIndex[tokenId];
1798         _allTokens.pop();
1799     }
1800 }
1801 
1802 // File: TastyBonesNFT.sol
1803 
1804 
1805 
1806 pragma solidity >=0.7.0 <0.9.0;
1807 
1808 
1809 
1810 
1811 contract XTastyBones is ERC721A, Ownable {
1812   using Strings for uint256;
1813 
1814   string public baseURI = "ipfs://QmWKH4KNQat2pScZ8mzMzgSfbrNfVrEUQFYbwfPgrQj89S/";
1815   string public baseExtension = ".json";
1816 
1817   uint256 public cost = .01 ether;
1818   uint256 public maxSupply = 10000;
1819 
1820   bool public preSales = true;
1821 
1822   uint256 public freeMintMaxSupply = 0;
1823 
1824   uint256 private maxMintAmount = 20;
1825   
1826   bool public paused = true;
1827 
1828   uint256 public nftPerAddressLimit = 200;
1829   mapping(address => uint256) public addressMintedBalance;
1830 
1831   address[] public whitelistedAddresses;
1832   bool public enableWhitelist = false;
1833 
1834   bool public reveal = false;
1835 
1836   constructor(
1837     string memory _name,
1838     string memory _symbol
1839   ) ERC721A(_name, _symbol, maxMintAmount) {
1840   }
1841 
1842   // internal
1843   function _baseURI() internal view virtual override returns (string memory) {
1844     return baseURI;
1845   }
1846 
1847   modifier isSafeMint(uint256 _mintAmount){
1848     require(_mintAmount > 0, "need to mint at least 1 NFT");
1849     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1850 
1851     uint256 supply = totalSupply();
1852 
1853     if(owner() != msg.sender){
1854       require(!paused, "the contract is paused");
1855       if(preSales){
1856         if(enableWhitelist){
1857           require(isWhitelisted(msg.sender), "user is not whitelisted");
1858         }
1859         require(supply + _mintAmount <= freeMintMaxSupply, "max FREE NFT limit exceeded");
1860 
1861         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1862         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1863       }else{
1864         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1865         require(msg.value >= cost * _mintAmount, "insufficient funds");
1866       }
1867     }else{
1868       require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1869     }
1870     
1871     _;
1872   }
1873 
1874   // public
1875   function mint(uint256 _mintAmount) public payable isSafeMint(_mintAmount) {
1876     addressMintedBalance[msg.sender]+=_mintAmount;
1877     _safeMint(msg.sender, _mintAmount);
1878   }
1879 
1880   function setPreSales(bool _preSales) public onlyOwner{
1881     preSales = _preSales;
1882   }
1883 
1884   function walletOfOwner(address _owner)
1885     public
1886     view
1887     returns (uint256[] memory)
1888   {
1889     uint256 ownerTokenCount = balanceOf(_owner);
1890     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1891     for (uint256 i; i < ownerTokenCount; i++) {
1892       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1893     }
1894     return tokenIds;
1895   }
1896   
1897   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1898     maxSupply = _maxSupply;
1899   }
1900     
1901   function setFreeMintMaxSupply(uint256 _freeMintMaxSupply) public onlyOwner {
1902     freeMintMaxSupply = _freeMintMaxSupply;
1903   }
1904 
1905   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1906     nftPerAddressLimit = _limit;
1907   }
1908   
1909   function setCost(uint256 _newCost) public onlyOwner {
1910     cost = _newCost;
1911   }
1912 
1913   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1914     baseURI = _newBaseURI;
1915   }
1916 
1917   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1918     baseExtension = _newBaseExtension;
1919   }
1920   function pause(bool _state) public onlyOwner {
1921     paused = _state;
1922   }
1923 
1924   function setEnableWhitelist(bool _enableWhitelist) public onlyOwner{
1925     enableWhitelist = _enableWhitelist;
1926   }
1927 
1928   function isWhitelisted(address _user) public view returns (bool) {
1929     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1930       if (whitelistedAddresses[i] == _user) {
1931           return true;
1932       }
1933     }
1934     return false;
1935   }
1936 
1937   function whitelistUsers(address[] calldata _users) public onlyOwner {
1938     delete whitelistedAddresses;
1939     whitelistedAddresses = _users;
1940   }
1941 
1942   function setReveal(bool _reveal) public onlyOwner {
1943     reveal = _reveal;
1944   }
1945  
1946   function withdraw() public payable onlyOwner {
1947     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1948     require(os);
1949   }
1950 
1951   /**
1952    * @dev See {IERC721Metadata-tokenURI}.
1953    */
1954   function tokenURI(uint256 tokenId)
1955     public
1956     view
1957     virtual
1958     override
1959     returns (string memory)
1960   {
1961     require(
1962       _exists(tokenId),
1963       "ERC721Metadata: URI query for nonexistent token"
1964     );
1965 
1966     string memory currentBaseURI = _baseURI();
1967 
1968     if(reveal==false){
1969       return bytes(currentBaseURI).length > 0
1970         ? string(abi.encodePacked(currentBaseURI, "hidden", baseExtension))
1971         : "";
1972     }
1973     
1974     return bytes(currentBaseURI).length > 0
1975         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1976         : "";
1977   }
1978 }