1 // SPDX-License-Identifier: MIT
2 // Creator: Chiru Labs
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
180 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
181 
182 pragma solidity ^0.8.0;
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
204      */
205     function isContract(address account) internal view returns (bool) {
206         // This method relies on extcodesize, which returns 0 for contracts in
207         // construction, since the code is only stored at the end of the
208         // constructor execution.
209 
210         uint256 size;
211         assembly {
212             size := extcodesize(account)
213         }
214         return size > 0;
215     }
216 
217     /**
218      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
219      * `recipient`, forwarding all available gas and reverting on errors.
220      *
221      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
222      * of certain opcodes, possibly making contracts go over the 2300 gas limit
223      * imposed by `transfer`, making them unable to receive funds via
224      * `transfer`. {sendValue} removes this limitation.
225      *
226      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
227      *
228      * IMPORTANT: because control is transferred to `recipient`, care must be
229      * taken to not create reentrancy vulnerabilities. Consider using
230      * {ReentrancyGuard} or the
231      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
232      */
233     function sendValue(address payable recipient, uint256 amount) internal {
234         require(address(this).balance >= amount, "Address: insufficient balance");
235 
236         (bool success, ) = recipient.call{value: amount}("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain `call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, 0, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but also transferring `value` wei to `target`.
279      *
280      * Requirements:
281      *
282      * - the calling contract must have an ETH balance of at least `value`.
283      * - the called Solidity function must be `payable`.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(address(this).balance >= value, "Address: insufficient balance for call");
308         require(isContract(target), "Address: call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.call{value: value}(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
321         return functionStaticCall(target, data, "Address: low-level static call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.staticcall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(isContract(target), "Address: delegate call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.delegatecall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
370      * revert reason using the provided one.
371      *
372      * _Available since v4.3._
373      */
374     function verifyCallResult(
375         bool success,
376         bytes memory returndata,
377         string memory errorMessage
378     ) internal pure returns (bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @title ERC721 token receiver interface
406  * @dev Interface for any contract that wants to support safeTransfers
407  * from ERC721 asset contracts.
408  */
409 interface IERC721Receiver {
410     /**
411      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
412      * by `operator` from `from`, this function is called.
413      *
414      * It must return its Solidity selector to confirm the token transfer.
415      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
416      *
417      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
418      */
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @dev Interface of the ERC165 standard, as defined in the
436  * https://eips.ethereum.org/EIPS/eip-165[EIP].
437  *
438  * Implementers can declare support of contract interfaces, which can then be
439  * queried by others ({ERC165Checker}).
440  *
441  * For an implementation, see {ERC165}.
442  */
443 interface IERC165 {
444     /**
445      * @dev Returns true if this contract implements the interface defined by
446      * `interfaceId`. See the corresponding
447      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
448      * to learn more about how these ids are created.
449      *
450      * This function call must use less than 30 000 gas.
451      */
452     function supportsInterface(bytes4 interfaceId) external view returns (bool);
453 }
454 
455 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @dev Implementation of the {IERC165} interface.
465  *
466  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
467  * for the additional interface id that will be supported. For example:
468  *
469  * ```solidity
470  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
472  * }
473  * ```
474  *
475  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
476  */
477 abstract contract ERC165 is IERC165 {
478     /**
479      * @dev See {IERC165-supportsInterface}.
480      */
481     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482         return interfaceId == type(IERC165).interfaceId;
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Required interface of an ERC721 compliant contract.
496  */
497 interface IERC721 is IERC165 {
498     /**
499      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
502 
503     /**
504      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
505      */
506     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
510      */
511     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
512 
513     /**
514      * @dev Returns the number of tokens in ``owner``'s account.
515      */
516     function balanceOf(address owner) external view returns (uint256 balance);
517 
518     /**
519      * @dev Returns the owner of the `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function ownerOf(uint256 tokenId) external view returns (address owner);
526 
527     /**
528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Transfers `tokenId` token from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
569      * The approval is cleared when the token is transferred.
570      *
571      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
572      *
573      * Requirements:
574      *
575      * - The caller must own the token or be an approved operator.
576      * - `tokenId` must exist.
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address to, uint256 tokenId) external;
581 
582     /**
583      * @dev Returns the account approved for `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function getApproved(uint256 tokenId) external view returns (address operator);
590 
591     /**
592      * @dev Approve or remove `operator` as an operator for the caller.
593      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
605      *
606      * See {setApprovalForAll}
607      */
608     function isApprovedForAll(address owner, address operator) external view returns (bool);
609 
610     /**
611      * @dev Safely transfers `tokenId` token from `from` to `to`.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId,
627         bytes calldata data
628     ) external;
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Enumerable is IERC721 {
644     /**
645      * @dev Returns the total amount of tokens stored by the contract.
646      */
647     function totalSupply() external view returns (uint256);
648 
649     /**
650      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
651      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
652      */
653     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
654 
655     /**
656      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
657      * Use along with {totalSupply} to enumerate all tokens.
658      */
659     function tokenByIndex(uint256 index) external view returns (uint256);
660 }
661 
662 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Metadata is IERC721 {
675     /**
676      * @dev Returns the token collection name.
677      */
678     function name() external view returns (string memory);
679 
680     /**
681      * @dev Returns the token collection symbol.
682      */
683     function symbol() external view returns (string memory);
684 
685     /**
686      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
687      */
688     function tokenURI(uint256 tokenId) external view returns (string memory);
689 }
690 
691 // File: contracts/LowerGas.sol
692 
693 
694 // Creator: Chiru Labs
695 
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
702  *
703  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
704  *
705  * Does not support burning tokens to address(0).
706  *
707  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
708  */
709 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
710     using Address for address;
711     using Strings for uint256;
712 
713     struct TokenOwnership {
714         address addr;
715         uint64 startTimestamp;
716     }
717 
718     struct AddressData {
719         uint128 balance;
720         uint128 numberMinted;
721     }
722 
723     uint256 internal currentIndex = 0;
724 
725     uint256 internal immutable maxBatchSize;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to ownership details
734     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
735     mapping(uint256 => TokenOwnership) internal _ownerships;
736 
737     // Mapping owner address to address data
738     mapping(address => AddressData) private _addressData;
739 
740     // Mapping from token ID to approved address
741     mapping(uint256 => address) private _tokenApprovals;
742 
743     // Mapping from owner to operator approvals
744     mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746     /**
747      * @dev
748      * `maxBatchSize` refers to how much a minter can mint at a time.
749      */
750     constructor(
751         string memory name_,
752         string memory symbol_,
753         uint256 maxBatchSize_
754     ) {
755         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
756         _name = name_;
757         _symbol = symbol_;
758         maxBatchSize = maxBatchSize_;
759     }
760 
761     /**
762      * @dev See {IERC721Enumerable-totalSupply}.
763      */
764     function totalSupply() public view override returns (uint256) {
765         return currentIndex;
766     }
767 
768     /**
769      * @dev See {IERC721Enumerable-tokenByIndex}.
770      */
771     function tokenByIndex(uint256 index) public view override returns (uint256) {
772         require(index < totalSupply(), 'ERC721A: global index out of bounds');
773         return index;
774     }
775 
776     /**
777      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
778      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
779      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
780      */
781     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
782         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
783         uint256 numMintedSoFar = totalSupply();
784         uint256 tokenIdsIdx = 0;
785         address currOwnershipAddr = address(0);
786         for (uint256 i = 0; i < numMintedSoFar; i++) {
787             TokenOwnership memory ownership = _ownerships[i];
788             if (ownership.addr != address(0)) {
789                 currOwnershipAddr = ownership.addr;
790             }
791             if (currOwnershipAddr == owner) {
792                 if (tokenIdsIdx == index) {
793                     return i;
794                 }
795                 tokenIdsIdx++;
796             }
797         }
798         revert('ERC721A: unable to get token of owner by index');
799     }
800 
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             interfaceId == type(IERC721Enumerable).interfaceId ||
809             super.supportsInterface(interfaceId);
810     }
811 
812     /**
813      * @dev See {IERC721-balanceOf}.
814      */
815     function balanceOf(address owner) public view override returns (uint256) {
816         require(owner != address(0), 'ERC721A: balance query for the zero address');
817         return uint256(_addressData[owner].balance);
818     }
819 
820     function _numberMinted(address owner) internal view returns (uint256) {
821         require(owner != address(0), 'ERC721A: number minted query for the zero address');
822         return uint256(_addressData[owner].numberMinted);
823     }
824 
825     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
826         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
827 
828         uint256 lowestTokenToCheck;
829         if (tokenId >= maxBatchSize) {
830             lowestTokenToCheck = tokenId - maxBatchSize + 1;
831         }
832 
833         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
834             TokenOwnership memory ownership = _ownerships[curr];
835             if (ownership.addr != address(0)) {
836                 return ownership;
837             }
838         }
839 
840         revert('ERC721A: unable to determine the owner of token');
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view override returns (address) {
847         return ownershipOf(tokenId).addr;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public override {
887         address owner = ERC721A.ownerOf(tokenId);
888         require(to != owner, 'ERC721A: approval to current owner');
889 
890         require(
891             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             'ERC721A: approve caller is not owner nor approved for all'
893         );
894 
895         _approve(to, tokenId, owner);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view override returns (address) {
902         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public override {
911         require(operator != _msgSender(), 'ERC721A: approve to caller');
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public override {
932         _transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public override {
943         safeTransferFrom(from, to, tokenId, '');
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public override {
955         _transfer(from, to, tokenId);
956         require(
957             _checkOnERC721Received(from, to, tokenId, _data),
958             'ERC721A: transfer to non ERC721Receiver implementer'
959         );
960     }
961 
962     /**
963      * @dev Returns whether `tokenId` exists.
964      *
965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
966      *
967      * Tokens start existing when they are minted (`_mint`),
968      */
969     function _exists(uint256 tokenId) internal view returns (bool) {
970         return tokenId < currentIndex;
971     }
972 
973     function _safeMint(address to, uint256 quantity) internal {
974         _safeMint(to, quantity, '');
975     }
976 
977     /**
978      * @dev Mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `quantity` cannot be larger than the max batch size.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _safeMint(
988         address to,
989         uint256 quantity,
990         bytes memory _data
991     ) internal {
992         uint256 startTokenId = currentIndex;
993         require(to != address(0), 'ERC721A: mint to the zero address');
994         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
995         require(!_exists(startTokenId), 'ERC721A: token already minted');
996         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
997         require(quantity > 0, 'ERC721A: quantity must be greater 0');
998 
999         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1000 
1001         AddressData memory addressData = _addressData[to];
1002         _addressData[to] = AddressData(
1003             addressData.balance + uint128(quantity),
1004             addressData.numberMinted + uint128(quantity)
1005         );
1006         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1007 
1008         uint256 updatedIndex = startTokenId;
1009 
1010         for (uint256 i = 0; i < quantity; i++) {
1011             emit Transfer(address(0), to, updatedIndex);
1012             require(
1013                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1014                 'ERC721A: transfer to non ERC721Receiver implementer'
1015             );
1016             updatedIndex++;
1017         }
1018 
1019         currentIndex = updatedIndex;
1020         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1021     }
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must be owned by `from`.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _transfer(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) private {
1038         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1039 
1040         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1041             getApproved(tokenId) == _msgSender() ||
1042             isApprovedForAll(prevOwnership.addr, _msgSender()));
1043 
1044         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1045 
1046         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1047         require(to != address(0), 'ERC721A: transfer to the zero address');
1048 
1049         _beforeTokenTransfers(from, to, tokenId, 1);
1050 
1051         // Clear approvals from the previous owner
1052         _approve(address(0), tokenId, prevOwnership.addr);
1053 
1054         // Underflow of the sender's balance is impossible because we check for
1055         // ownership above and the recipient's balance can't realistically overflow.
1056         unchecked {
1057             _addressData[from].balance -= 1;
1058             _addressData[to].balance += 1;
1059         }
1060 
1061         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1062 
1063         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1064         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1065         uint256 nextTokenId = tokenId + 1;
1066         if (_ownerships[nextTokenId].addr == address(0)) {
1067             if (_exists(nextTokenId)) {
1068                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1069             }
1070         }
1071 
1072         emit Transfer(from, to, tokenId);
1073         _afterTokenTransfers(from, to, tokenId, 1);
1074     }
1075 
1076     /**
1077      * @dev Approve `to` to operate on `tokenId`
1078      *
1079      * Emits a {Approval} event.
1080      */
1081     function _approve(
1082         address to,
1083         uint256 tokenId,
1084         address owner
1085     ) private {
1086         _tokenApprovals[tokenId] = to;
1087         emit Approval(owner, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1092      * The call is not executed if the target address is not a contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         if (to.isContract()) {
1107             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1108                 return retval == IERC721Receiver(to).onERC721Received.selector;
1109             } catch (bytes memory reason) {
1110                 if (reason.length == 0) {
1111                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1112                 } else {
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1125      *
1126      * startTokenId - the first token id to be transferred
1127      * quantity - the amount to be transferred
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      */
1135     function _beforeTokenTransfers(
1136         address from,
1137         address to,
1138         uint256 startTokenId,
1139         uint256 quantity
1140     ) internal virtual {}
1141 
1142     /**
1143      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1144      * minting.
1145      *
1146      * startTokenId - the first token id to be transferred
1147      * quantity - the amount to be transferred
1148      *
1149      * Calling conditions:
1150      *
1151      * - when `from` and `to` are both non-zero.
1152      * - `from` and `to` are never both zero.
1153      */
1154     function _afterTokenTransfers(
1155         address from,
1156         address to,
1157         uint256 startTokenId,
1158         uint256 quantity
1159     ) internal virtual {}
1160 }
1161 
1162 pragma solidity ^0.8.14;
1163 
1164 contract GoblinNouns is ERC721A, Ownable {
1165   using Strings for uint256;
1166   
1167   uint256 public mintPrice = 0.005 ether;
1168 
1169   uint256 public mintMany1Price = 0.015 ether;
1170   uint256 public mintMany1Qty = 5;
1171   uint256 public mintMany2Price = 0.02 ether;
1172   uint256 public mintMany2Qty = 10;
1173 
1174   uint256 public maxSupply = 5555;
1175   uint256 public maxFreeMint = 500;
1176   uint256 public freeMintPerWallet = 9;
1177   uint256 public oneFreeX = 0;
1178 
1179   string public baseTokenURI = "https://gateway.pinata.cloud/ipfs/QmRW6527FD89rJBXPGVZMuT39TNgXZtG5YzXJBpDZk9Hkc/";
1180   string public hiddenURI = "";
1181 
1182   bool public openMint = true;
1183   bool public revealed = true;
1184 
1185   mapping(address => uint256) public addressMintedBalance;
1186 
1187   constructor() ERC721A("Goblin Nouns", "goblinnouns", 101) {  }
1188 
1189   function mint(uint256 _mintAmount) external payable {
1190     require(openMint, "The contract is not open to mint yet!");
1191     uint256 _mintPrice = currentMintPrice();
1192 
1193     if(currentIndex < maxFreeMint) {
1194         require(balanceOf(_msgSender()) < freeMintPerWallet, "Max free mint exceeded!");
1195         _mintAmount = freeMintPerWallet;
1196     }
1197     require(msg.value >= _mintPrice * _mintAmount, "Insufficient funds!");
1198 
1199     if(currentIndex >= maxFreeMint && oneFreeX > 0) {
1200         _mintAmount = _mintAmount * oneFreeX;
1201     }
1202     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1203 
1204     _safeMint(msg.sender, _mintAmount);
1205   }
1206   
1207   function mintMany(uint256 _mintManySet) external payable {
1208     require(openMint, "The contract is not open to mint yet!");
1209 
1210     uint256 _mintPrice = mintMany1Price;
1211     uint256 _mintAmount = mintMany1Qty;
1212 
1213     if(_mintManySet == 2) {
1214         _mintPrice = mintMany2Price;
1215         _mintAmount = mintMany2Qty;
1216     }
1217 
1218     require(msg.value >= _mintPrice, "Insufficient funds!");
1219     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1220 
1221     _safeMint(msg.sender, _mintAmount);
1222   }
1223 
1224   function mintManyPrice(uint256 _mintManySet) public view virtual returns (uint256)
1225   {
1226     uint256 _mintPrice = mintMany1Price;
1227 
1228     if(_mintManySet == 1) {
1229         _mintPrice = mintMany1Price;
1230     }
1231     else if(_mintManySet == 2) {
1232         _mintPrice = mintMany2Price;
1233     }
1234 
1235     return _mintPrice;
1236   }
1237 
1238   function currentMintPrice() public view virtual returns (uint256)
1239   {
1240     uint256 _mintPrice = mintPrice;
1241 
1242     if(currentIndex < maxFreeMint){
1243        _mintPrice = 0;
1244     }
1245 
1246     return _mintPrice;
1247   }
1248 
1249   function tokenURI(uint256 _tokenId)
1250     public
1251     view
1252     virtual
1253     override
1254     returns (string memory)
1255   {
1256     require(
1257       _exists(_tokenId),
1258       "ERC721Metadata: URI query for nonexistent token"
1259     );
1260 
1261     if (revealed == false) {
1262       return hiddenURI;
1263     }
1264 
1265     return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId), ".json"));
1266   }
1267 
1268   function withdraw() external onlyOwner {
1269     payable(owner()).transfer(address(this).balance);
1270   }
1271 
1272 
1273   function setMintMany(uint256 _mintManySet, uint256 _mintprice, uint256 _mintQty) public onlyOwner {
1274     if(_mintManySet == 1) {
1275         mintMany1Price = _mintprice;
1276         mintMany1Qty = _mintQty;
1277     }
1278     else if(_mintManySet == 2) {
1279         mintMany2Price = _mintprice;
1280         mintMany2Qty = _mintQty;
1281     }
1282   }
1283 
1284   function setMaxFreeMint(uint256 _maxFreeMint) public onlyOwner {
1285     maxFreeMint = _maxFreeMint;
1286   }
1287   function setFreeMintPerWallet(uint256 _freeMintPerWallet) public onlyOwner {
1288     freeMintPerWallet = _freeMintPerWallet;
1289   }
1290   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1291     maxSupply = _maxSupply;
1292   }
1293   function setOneFreeX(uint256 _oneFreeX) public onlyOwner {
1294     oneFreeX = _oneFreeX;
1295   }
1296 
1297   function setOpenMint(bool _state) public onlyOwner {
1298     openMint = _state;
1299   }
1300 
1301   function setPrice(uint256 _price) public onlyOwner {
1302     mintPrice = _price;
1303   }
1304 
1305   function setBaseUri(string memory _uri) external onlyOwner {
1306     baseTokenURI = _uri;
1307   }
1308   function setRevealed(bool _state) public onlyOwner {
1309     revealed = _state;
1310   }
1311   function setHiddenUri(string memory _uri) external onlyOwner {
1312     hiddenURI = _uri;
1313   }
1314 }