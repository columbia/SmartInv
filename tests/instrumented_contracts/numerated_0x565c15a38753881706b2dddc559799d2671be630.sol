1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-31
3 */
4 
5 // SPDX-License-Identifier: MIT
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
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/access/Ownable.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Address.sol
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev Collection of functions related to the address type
189  */
190 library Address {
191     /**
192      * @dev Returns true if `account` is a contract.
193      *
194      * [IMPORTANT]
195      * ====
196      * It is unsafe to assume that an address for which this function returns
197      * false is an externally-owned account (EOA) and not a contract.
198      *
199      * Among others, `isContract` will return false for the following
200      * types of addresses:
201      *
202      *  - an externally-owned account
203      *  - a contract in construction
204      *  - an address where a contract will be created
205      *  - an address where a contract lived, but was destroyed
206      * ====
207      */
208     function isContract(address account) internal view returns (bool) {
209         // This method relies on extcodesize, which returns 0 for contracts in
210         // construction, since the code is only stored at the end of the
211         // constructor execution.
212 
213         uint256 size;
214         assembly {
215             size := extcodesize(account)
216         }
217         return size > 0;
218     }
219 
220     /**
221      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
222      * `recipient`, forwarding all available gas and reverting on errors.
223      *
224      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
225      * of certain opcodes, possibly making contracts go over the 2300 gas limit
226      * imposed by `transfer`, making them unable to receive funds via
227      * `transfer`. {sendValue} removes this limitation.
228      *
229      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
230      *
231      * IMPORTANT: because control is transferred to `recipient`, care must be
232      * taken to not create reentrancy vulnerabilities. Consider using
233      * {ReentrancyGuard} or the
234      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
235      */
236     function sendValue(address payable recipient, uint256 amount) internal {
237         require(address(this).balance >= amount, "Address: insufficient balance");
238 
239         (bool success,) = recipient.call{value : amount}("");
240         require(success, "Address: unable to send value, recipient may have reverted");
241     }
242 
243     /**
244      * @dev Performs a Solidity function call using a low level `call`. A
245      * plain `call` is an unsafe replacement for a function call: use this
246      * function instead.
247      *
248      * If `target` reverts with a revert reason, it is bubbled up by this
249      * function (like regular Solidity function calls).
250      *
251      * Returns the raw returned data. To convert to the expected return value,
252      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
253      *
254      * Requirements:
255      *
256      * - `target` must be a contract.
257      * - calling `target` with `data` must not revert.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionCall(target, data, "Address: low-level call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
267      * `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, 0, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but also transferring `value` wei to `target`.
282      *
283      * Requirements:
284      *
285      * - the calling contract must have an ETH balance of at least `value`.
286      * - the called Solidity function must be `payable`.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
300      * with `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(address(this).balance >= value, "Address: insufficient balance for call");
311         require(isContract(target), "Address: call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.call{value : value}(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
324         return functionStaticCall(target, data, "Address: low-level static call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal view returns (bytes memory) {
338         require(isContract(target), "Address: static call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.staticcall(data);
341         return verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(isContract(target), "Address: delegate call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.delegatecall(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
373      * revert reason using the provided one.
374      *
375      * _Available since v4.3._
376      */
377     function verifyCallResult(
378         bool success,
379         bytes memory returndata,
380         string memory errorMessage
381     ) internal pure returns (bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
401 
402 
403 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @title ERC721 token receiver interface
409  * @dev Interface for any contract that wants to support safeTransfers
410  * from ERC721 asset contracts.
411  */
412 interface IERC721Receiver {
413     /**
414      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
415      * by `operator` from `from`, this function is called.
416      *
417      * It must return its Solidity selector to confirm the token transfer.
418      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
419      *
420      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
421      */
422     function onERC721Received(
423         address operator,
424         address from,
425         uint256 tokenId,
426         bytes calldata data
427     ) external returns (bytes4);
428 }
429 
430 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Interface of the ERC165 standard, as defined in the
439  * https://eips.ethereum.org/EIPS/eip-165[EIP].
440  *
441  * Implementers can declare support of contract interfaces, which can then be
442  * queried by others ({ERC165Checker}).
443  *
444  * For an implementation, see {ERC165}.
445  */
446 interface IERC165 {
447     /**
448      * @dev Returns true if this contract implements the interface defined by
449      * `interfaceId`. See the corresponding
450      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
451      * to learn more about how these ids are created.
452      *
453      * This function call must use less than 30 000 gas.
454      */
455     function supportsInterface(bytes4 interfaceId) external view returns (bool);
456 }
457 
458 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 
466 /**
467  * @dev Implementation of the {IERC165} interface.
468  *
469  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
470  * for the additional interface id that will be supported. For example:
471  *
472  * ```solidity
473  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
475  * }
476  * ```
477  *
478  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
479  */
480 abstract contract ERC165 is IERC165 {
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      */
484     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485         return interfaceId == type(IERC165).interfaceId;
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @dev Required interface of an ERC721 compliant contract.
499  */
500 interface IERC721 is IERC165 {
501     /**
502      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
503      */
504     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
508      */
509     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
510 
511     /**
512      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
513      */
514     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
515 
516     /**
517      * @dev Returns the number of tokens in ``owner``'s account.
518      */
519     function balanceOf(address owner) external view returns (uint256 balance);
520 
521     /**
522      * @dev Returns the owner of the `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function ownerOf(uint256 tokenId) external view returns (address owner);
529 
530     /**
531      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
532      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId
548     ) external;
549 
550     /**
551      * @dev Transfers `tokenId` token from `from` to `to`.
552      *
553      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must be owned by `from`.
560      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
561      *
562      * Emits a {Transfer} event.
563      */
564     function transferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
572      * The approval is cleared when the token is transferred.
573      *
574      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
575      *
576      * Requirements:
577      *
578      * - The caller must own the token or be an approved operator.
579      * - `tokenId` must exist.
580      *
581      * Emits an {Approval} event.
582      */
583     function approve(address to, uint256 tokenId) external;
584 
585     /**
586      * @dev Returns the account approved for `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function getApproved(uint256 tokenId) external view returns (address operator);
593 
594     /**
595      * @dev Approve or remove `operator` as an operator for the caller.
596      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
597      *
598      * Requirements:
599      *
600      * - The `operator` cannot be the caller.
601      *
602      * Emits an {ApprovalForAll} event.
603      */
604     function setApprovalForAll(address operator, bool _approved) external;
605 
606     /**
607      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
608      *
609      * See {setApprovalForAll}
610      */
611     function isApprovedForAll(address owner, address operator) external view returns (bool);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes calldata data
631     ) external;
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
644  * @dev See https://eips.ethereum.org/EIPS/eip-721
645  */
646 interface IERC721Enumerable is IERC721 {
647     /**
648      * @dev Returns the total amount of tokens stored by the contract.
649      */
650     function totalSupply() external view returns (uint256);
651 
652     /**
653      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
654      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
655      */
656     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
657 
658     /**
659      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
660      * Use along with {totalSupply} to enumerate all tokens.
661      */
662     function tokenByIndex(uint256 index) external view returns (uint256);
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Metadata is IERC721 {
678     /**
679      * @dev Returns the token collection name.
680      */
681     function name() external view returns (string memory);
682 
683     /**
684      * @dev Returns the token collection symbol.
685      */
686     function symbol() external view returns (string memory);
687 
688     /**
689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
690      */
691     function tokenURI(uint256 tokenId) external view returns (string memory);
692 }
693 
694 // File: contracts/LowerGas.sol
695 
696 pragma solidity ^0.8.0;
697 
698 /**
699  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
700  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
701  *
702  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
703  *
704  * Does not support burning tokens to address(0).
705  *
706  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
707  */
708 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
709     using Address for address;
710     using Strings for uint256;
711 
712     struct TokenOwnership {
713         address addr;
714         uint64 startTimestamp;
715     }
716 
717     struct AddressData {
718         uint128 balance;
719         uint128 numberMinted;
720     }
721 
722     uint256 internal currentIndex = 0;
723 
724     uint256 internal immutable maxBatchSize;
725 
726     // Token name
727     string private _name;
728 
729     // Token symbol
730     string private _symbol;
731 
732     // Mapping from token ID to ownership details
733     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
734     mapping(uint256 => TokenOwnership) internal _ownerships;
735 
736     // Mapping owner address to address data
737     mapping(address => AddressData) private _addressData;
738 
739     // Mapping from token ID to approved address
740     mapping(uint256 => address) private _tokenApprovals;
741 
742     // Mapping from owner to operator approvals
743     mapping(address => mapping(address => bool)) private _operatorApprovals;
744 
745     /**
746      * @dev
747      * `maxBatchSize` refers to how much a minter can mint at a time.
748      */
749     constructor(
750         string memory name_,
751         string memory symbol_,
752         uint256 maxBatchSize_
753     ) {
754         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
755         _name = name_;
756         _symbol = symbol_;
757         maxBatchSize = maxBatchSize_;
758     }
759 
760     /**
761      * @dev See {IERC721Enumerable-totalSupply}.
762      */
763     function totalSupply() public view override returns (uint256) {
764         return currentIndex;
765     }
766 
767     /**
768      * @dev See {IERC721Enumerable-tokenByIndex}.
769      */
770     function tokenByIndex(uint256 index) public view override returns (uint256) {
771         require(index < totalSupply(), 'ERC721A: global index out of bounds');
772         return index;
773     }
774 
775     /**
776      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
777      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
778      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
779      */
780     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
781         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
782         uint256 numMintedSoFar = totalSupply();
783         uint256 tokenIdsIdx = 0;
784         address currOwnershipAddr = address(0);
785         for (uint256 i = 0; i < numMintedSoFar; i++) {
786             TokenOwnership memory ownership = _ownerships[i];
787             if (ownership.addr != address(0)) {
788                 currOwnershipAddr = ownership.addr;
789             }
790             if (currOwnershipAddr == owner) {
791                 if (tokenIdsIdx == index) {
792                     return i;
793                 }
794                 tokenIdsIdx++;
795             }
796         }
797         revert('ERC721A: unable to get token of owner by index');
798     }
799 
800     /**
801      * @dev See {IERC165-supportsInterface}.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
804         return
805         interfaceId == type(IERC721).interfaceId ||
806         interfaceId == type(IERC721Metadata).interfaceId ||
807         interfaceId == type(IERC721Enumerable).interfaceId ||
808         super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view override returns (uint256) {
815         require(owner != address(0), 'ERC721A: balance query for the zero address');
816         return uint256(_addressData[owner].balance);
817     }
818 
819     function _numberMinted(address owner) internal view returns (uint256) {
820         require(owner != address(0), 'ERC721A: number minted query for the zero address');
821         return uint256(_addressData[owner].numberMinted);
822     }
823 
824     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
825         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
826 
827         uint256 lowestTokenToCheck;
828         if (tokenId >= maxBatchSize) {
829             lowestTokenToCheck = tokenId - maxBatchSize + 1;
830         }
831 
832         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
833             TokenOwnership memory ownership = _ownerships[curr];
834             if (ownership.addr != address(0)) {
835                 return ownership;
836             }
837         }
838 
839         revert('ERC721A: unable to determine the owner of token');
840     }
841 
842     /**
843      * @dev See {IERC721-ownerOf}.
844      */
845     function ownerOf(uint256 tokenId) public view override returns (address) {
846         return ownershipOf(tokenId).addr;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overriden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return '';
880     }
881 
882     /**
883      * @dev See {IERC721-approve}.
884      */
885     function approve(address to, uint256 tokenId) public override {
886         address owner = ERC721A.ownerOf(tokenId);
887         require(to != owner, 'ERC721A: approval to current owner');
888 
889         require(
890             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
891             'ERC721A: approve caller is not owner nor approved for all'
892         );
893 
894         _approve(to, tokenId, owner);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view override returns (address) {
901         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public override {
910         require(operator != _msgSender(), 'ERC721A: approve to caller');
911 
912         _operatorApprovals[_msgSender()][operator] = approved;
913         emit ApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public override {
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public override {
942         safeTransferFrom(from, to, tokenId, '');
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public override {
954         _transfer(from, to, tokenId);
955         require(
956             _checkOnERC721Received(from, to, tokenId, _data),
957             'ERC721A: transfer to non ERC721Receiver implementer'
958         );
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      */
968     function _exists(uint256 tokenId) internal view returns (bool) {
969         return tokenId < currentIndex;
970     }
971 
972     function _safeMint(address to, uint256 quantity) internal {
973         _safeMint(to, quantity, '');
974     }
975 
976     /**
977      * @dev Mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `quantity` cannot be larger than the max batch size.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeMint(
987         address to,
988         uint256 quantity,
989         bytes memory _data
990     ) internal {
991         uint256 startTokenId = currentIndex;
992         require(to != address(0), 'ERC721A: mint to the zero address');
993         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
994         require(!_exists(startTokenId), 'ERC721A: token already minted');
995         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
996         require(quantity > 0, 'ERC721A: quantity must be greater 0');
997 
998         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
999 
1000         AddressData memory addressData = _addressData[to];
1001         _addressData[to] = AddressData(
1002             addressData.balance + uint128(quantity),
1003             addressData.numberMinted + uint128(quantity)
1004         );
1005         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1006 
1007         uint256 updatedIndex = startTokenId;
1008 
1009         for (uint256 i = 0; i < quantity; i++) {
1010             emit Transfer(address(0), to, updatedIndex);
1011             require(
1012                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1013                 'ERC721A: transfer to non ERC721Receiver implementer'
1014             );
1015             updatedIndex++;
1016         }
1017 
1018         currentIndex = updatedIndex;
1019         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1020     }
1021 
1022     /**
1023      * @dev Transfers `tokenId` from `from` to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must be owned by `from`.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _transfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) private {
1037         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1038 
1039         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1040         getApproved(tokenId) == _msgSender() ||
1041         isApprovedForAll(prevOwnership.addr, _msgSender()));
1042 
1043         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1044 
1045         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1046         require(to != address(0), 'ERC721A: transfer to the zero address');
1047 
1048         _beforeTokenTransfers(from, to, tokenId, 1);
1049 
1050         // Clear approvals from the previous owner
1051         _approve(address(0), tokenId, prevOwnership.addr);
1052 
1053         // Underflow of the sender's balance is impossible because we check for
1054         // ownership above and the recipient's balance can't realistically overflow.
1055     unchecked {
1056         _addressData[from].balance -= 1;
1057         _addressData[to].balance += 1;
1058     }
1059 
1060         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1061 
1062         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1063         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1064         uint256 nextTokenId = tokenId + 1;
1065         if (_ownerships[nextTokenId].addr == address(0)) {
1066             if (_exists(nextTokenId)) {
1067                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1068             }
1069         }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev Approve `to` to operate on `tokenId`
1077      *
1078      * Emits a {Approval} event.
1079      */
1080     function _approve(
1081         address to,
1082         uint256 tokenId,
1083         address owner
1084     ) private {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(owner, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1107                 return retval == IERC721Receiver(to).onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1111                 } else {
1112                     assembly {
1113                         revert(add(32, reason), mload(reason))
1114                     }
1115                 }
1116             }
1117         } else {
1118             return true;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1124      *
1125      * startTokenId - the first token id to be transferred
1126      * quantity - the amount to be transferred
1127      *
1128      * Calling conditions:
1129      *
1130      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1131      * transferred to `to`.
1132      * - When `from` is zero, `tokenId` will be minted for `to`.
1133      */
1134     function _beforeTokenTransfers(
1135         address from,
1136         address to,
1137         uint256 startTokenId,
1138         uint256 quantity
1139     ) internal virtual {}
1140 
1141     /**
1142      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1143      * minting.
1144      *
1145      * startTokenId - the first token id to be transferred
1146      * quantity - the amount to be transferred
1147      *
1148      * Calling conditions:
1149      *
1150      * - when `from` and `to` are both non-zero.
1151      * - `from` and `to` are never both zero.
1152      */
1153     function _afterTokenTransfers(
1154         address from,
1155         address to,
1156         uint256 startTokenId,
1157         uint256 quantity
1158     ) internal virtual {}
1159 }
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 contract xPunks is ERC721A, Ownable {
1164     using Strings for uint256;
1165 
1166     string public uriPrefix = "";
1167     string public uriSuffix = ".json";
1168     mapping(address => bool) whitelist;
1169 
1170     uint256 public cost = 0.00 ether;
1171     uint256 public maxSupply = 10000;
1172     uint256 public maxMintAmountPerTx = 100;
1173     uint256 public nftPerAddressLimitWl = 10;
1174 
1175     bool public paused = true;
1176     bool public onlyWhitelisted = true;
1177 
1178     mapping(address => uint256) public addressMintedBalance;
1179 
1180     constructor() ERC721A("0xPunks", "0xPunk", maxMintAmountPerTx) {
1181         whitelist[0x8950507282B85127eBf0c27465a3CBc5079e9B8B] = true;
1182         whitelist[0xa7868550a0B397Da722D9705AA49B7299B8A33EF] = true;
1183         whitelist[0x76433F75F03af38621937eA1dF9D2AfD7a40e945] = true;
1184         whitelist[0xb58b6370d7d28f00906811AA591C4AB7e64D17cF] = true;
1185         whitelist[0x0423A96A0f5e937182080FB49b552003B8385F98] = true;
1186         whitelist[0x3ef083f9f48B5f3b7734aA582f7BF04cf2D4b173] = true;
1187         whitelist[0xC23C131474F297445C80E01a82d2C26710e1eE04] = true;
1188         whitelist[0x66c31c7f9f7b83e9f3dD7D4a1927718699C0Fd23] = true;
1189         whitelist[0x060A8aCd75600A9C1BA459BE7552D39a8240c406] = true;
1190         whitelist[0xaB0DFa07aC5E991C3932E871B6891C6af7C61394] = true;
1191         whitelist[0x0705A9B50f75bF6217bd0489B30DC50516982EFA] = true;
1192         whitelist[0xbDBA43F98D3609a92e92fA4e94Adca011E3dD10C] = true;
1193         whitelist[0x0B74DF5BF962f95059a27bFBE24811eD7529B86D] = true;
1194         whitelist[0xE1698607C930dC6330C5706827c033e1A810C8cd] = true;
1195         whitelist[0x43A85e0Bc901BbA74fbEC5c968cc8A5BD58ed9D4] = true;
1196         whitelist[0x709273edc511F6180f36dCebbF93d61E0e3e79e4] = true;
1197         whitelist[0xcbee667d79772E21522B4e9130B567bA5094F08d] = true;
1198         whitelist[0x87133bd017ae8E811d7b98Ebe542F03D532E4Bd2] = true;
1199         whitelist[0xDfae7A193E246E6D99bF340193e5Ffa738D4EAbB] = true;
1200         whitelist[0x9876449DE01A64a87F765aA72651CC795E44ef29] = true;
1201         whitelist[0x8E2AF953De826e92E4bB253906D216a6d82BF4D0] = true;
1202         whitelist[0x8EDb8FFDc0E690Bb5852a7d83D48246F18250D18] = true;
1203         whitelist[0x3c0508B8F5c3e45119c6927A1ac49849fC67d32A] = true;
1204         whitelist[0x7196dFb5a25f4A444a905Dc7e712E41c325D60EE] = true;
1205         whitelist[0xb670357Fa3FAeDe5DC91CBe9F5D2A9D4e6dB3435] = true;
1206         whitelist[0x69305Eb29BFdBf46eB194Fd148722DD76Ba82A72] = true;
1207         whitelist[0xEEdD9171c591e01161c1b28a1D4a1db4eC030CEe] = true;
1208         whitelist[0xeEeC3aD8773a980f42C50DC4167ae3F3C7BE2Ee1] = true;
1209         whitelist[0x80c0088A56828BB0930bC28B93fcE0415B611d4e] = true;
1210         whitelist[0xe4f5DC22B0d48f3243b90Dd7efd4d9a26Ad24EDF] = true;
1211         whitelist[0x082fd10c51Ae3f47E0d6AeC3D81506a9FF7c2D93] = true;
1212         whitelist[0xD415BC63A4d4966D52B638fC5f3B7ede7BffCAa2] = true;
1213         whitelist[0x60aBc21754286A71D75b51947143A59319BA27fC] = true;
1214         whitelist[0x6C6Bd1b569d8C6067514fbF94221330316d6d424] = true;
1215         whitelist[0x6abe2A3Ff9DCb5389cf3c15A347B68CF539332c8] = true;
1216         whitelist[0x5D9398a9a9b88764f49eBc7F0fdc8344bAd3C58d] = true;
1217         whitelist[0x7d3C13FC1037652545395882Ba64C3F024E30841] = true;
1218         whitelist[0x3a766e5FEb4a955103a5B57463593FE66B0C8dFD] = true;
1219         whitelist[0x9841f6cDDE91ACa364C71b43469A8c9B021E096a] = true;
1220         whitelist[0x6031B736D50F0D4845eB756169E74F7e3756e157] = true;
1221         whitelist[0xb5A38E6Fa233Ad318eE22BED6B50a6EACB1f23ca] = true;
1222         whitelist[0xDD41Ef8F9ce193abeD960ab9d30db0a0dee1DD29] = true;
1223         whitelist[0xB1bb090F332743Cb2c618271f0a069d6d0F26b86] = true;
1224         whitelist[0xbd8394B4040485984031f7956eAf106e1B30966D] = true;
1225         whitelist[0xEc2bDcb9d003593752246c5C582417b4732388AF] = true;
1226         whitelist[0x95181454510CCcD77EC910146a79BBc5619Daf76] = true;
1227         whitelist[0x2FA5D2dFA5317d7E0a5012547a23787A99F37B02] = true;
1228         whitelist[0x2E1d22353c8BFBf09B46e62D1F48Bd5b66dadE1f] = true;
1229         whitelist[0x940618ce8741C7eC2e95A6f11D79F9252A5Cce15] = true;
1230         whitelist[0x76f6AD15694FEEE5F3a055baD2E45D185f0048be] = true;
1231         whitelist[0x4df3772b95A745Fc850B7f636A17FA6169171468] = true;
1232         whitelist[0x75576DaB750c88B3CA8eb2B5510C47e3BF7c78a4] = true;
1233         whitelist[0xf6b4E7e3605C72EaEf290eB4C90C4bDB128c0DAb] = true;
1234         whitelist[0xAB8EA35D2e200bF9089b7E9Bee47568Fdb211012] = true;
1235         whitelist[0xB5c6D5bd47cDf90B897AA3D10c82aFa8178E6E95] = true;
1236         whitelist[0x53475949ACf6C33CDb9d38663c5Ca1337f9a4aC8] = true;
1237         whitelist[0x4547E9f00d6653CbA21eAf876407eC402044e7d1] = true;
1238         whitelist[0x5E70F21d15a4338Cc73829320a1633E078e2a7DB] = true;
1239         whitelist[0xaB2F5627B9DE831d75ab893D21Df0193E484c2c5] = true;
1240         whitelist[0xDc13005aBCEB471e3513f1a4A1b3279A215EE926] = true;
1241         whitelist[0xc012d72Cd1d05B5d4A69361C8f1d292516F6E46f] = true;
1242         whitelist[0xB527f9b886231Bd5609264767521b1A22A81bc32] = true;
1243         whitelist[0xaF3c7adA8Cb623B2b4cd2Aa497F2689fcA1DB192] = true;
1244         whitelist[0xD53bCC6a2C2d4C60D889Bb9bB34913dA58b9d104] = true;
1245         whitelist[0x112f7E9307736149540954EFDCd4A0B60881496d] = true;
1246         whitelist[0x23b5Da4853B2C846aF5554B9FB68Bf5686B5353a] = true;
1247         whitelist[0x640e5b00aB5e4368A2BB077255A8B5E27C87997E] = true;
1248         whitelist[0x8A1d7a7e230849d88Cd237Bb446bb38BBeacc051] = true;
1249         whitelist[0xdbeAF92c601721Da293ad636903627e0955D94c5] = true;
1250         whitelist[0xB438105f9049294bAbdC8040f1F8D1d6FF7570c4] = true;
1251         whitelist[0x288F4336Ed3A09B1efE622C1cdcDBf4b168FCA39] = true;
1252         whitelist[0xeDF6714512eb99Dc339741CA8FBb47CF77448d3C] = true;
1253         whitelist[0x3aE5f284430b14a12ffd4E2Be6ed425c15650D20] = true;
1254         whitelist[0x6a575eCAe3d5cCc4bB1fAf2342eB77170b19A412] = true;
1255         whitelist[0x03A8726172fA51D64b0c3D583dE5876e73d73d0e] = true;
1256         whitelist[0x1608Ff5289837bE911607a1384C6FC4eeb42f162] = true;
1257         whitelist[0x6003838aFef9c93f050070F5b947acCaC61C8dC1] = true;
1258         whitelist[0xD9498e2fc646B5882e78a6243FB5EfAeDc1cD85f] = true;
1259         whitelist[0x222d6b7D7270F63d1e55587f5703F71Bf48f5305] = true;
1260         whitelist[0x399b5B66B70AD7B884a4b91A41049a5D0023076B] = true;
1261         whitelist[0x54d6d8Ae3BF787d89A673241F14817886f057aEC] = true;
1262         whitelist[0x2BD0A65B7E0f5759ce21E380269a42b615E8eA15] = true;
1263         whitelist[0xf11Fa70332dF9f3b40498bD3D8E837d69CAB76eC] = true;
1264         whitelist[0x3541500AA53bC242ae50498E91850a3dE89F4dfc] = true;
1265         whitelist[0xED47dE07c8a00c7d3eC096598A1a50e1467Ca65B] = true;
1266         whitelist[0xc605564e306a7bDC86d34Cf0CA39826BC34A5780] = true;
1267         whitelist[0x616aBaAEE8D6CEac7d6B8a81DabBF24614A8A71A] = true;
1268         whitelist[0x93b48aA209Dc9d9760ffB979A004a9623E085608] = true;
1269         whitelist[0x65C540ab906d287D3DE03B1BeB0A928e95AE4a68] = true;
1270         whitelist[0x14a88E30B610Cd12A029BC8B182d80d0C5cBF130] = true;
1271         whitelist[0x5887f4967b086123D0034945A180B4AE404BAB59] = true;
1272         whitelist[0x216967cC1E2bc57A296A55b9687AC184485374a9] = true;
1273         whitelist[0x08924f908484eA57EFe132C0dbA1924Cd1B9eE7E] = true;
1274         whitelist[0x505A09A559b3Dd0a9DEf9E0A4a37aDc9aA3f18E2] = true;
1275         whitelist[0xb266E542c645627da44821b1010C25768E23e112] = true;
1276         whitelist[0x884d9a4C073096Ee84951bf079F8E17bC23AdD05] = true;
1277         whitelist[0xcbF727141be136C8B3993f06893c5c7466bAC013] = true;
1278         whitelist[0x929a12d5d22ffEf6E39Bc1c2276e1EB61f73dA4e] = true;
1279         whitelist[0xdEe822Bf349F4f27aAab0FC2301e35eb4b9fE82B] = true;
1280         whitelist[0xfD69501D62BF232c2fF1A186c9757047E37B7469] = true;
1281         whitelist[0xB5A2370E6e741c6A12c40E6FF8FC6852D38e88cE] = true;
1282         whitelist[0x36D7e86212Eff3837671ddb76F5111A4E5fE6f9F] = true;
1283         whitelist[0x974F851a17dDE74aBA727eEdbC310492778e5aAF] = true;
1284         whitelist[0x075CaFcDa6cC6B472ED9ac0A23D22730a112Fc11] = true;
1285         whitelist[0x1878166eE6d72E287c75bc169ef2c4e7eA5B7a5E] = true;
1286         whitelist[0xf390fBf1993F2559F5425309D5230D74e9a0B84c] = true;
1287         whitelist[0xA7f1a10c9F862444d2E87f4EC91293B9926181EF] = true;
1288         whitelist[0x4B8Db3EeE0dBf35a3D13d910e48Ab29b57EAf381] = true;
1289         whitelist[0xc95332cd0f986Dc8bFa9ec137bB846530Bb7C993] = true;
1290         whitelist[0x7F4F5983e886fC61a054b6b5566adc0652799e24] = true;
1291         whitelist[0xf72E7c395e252926C11152d59e28f35bD204508A] = true;
1292         whitelist[0x4A52b132a00330fa03c87a563D7909A38d8afee8] = true;
1293         whitelist[0x7cA9089962600A9e708444aE2Cf0AfFDcC0577E0] = true;
1294         whitelist[0x67B1045f193B35a31C90BE77e3f1C3da95339799] = true;
1295         whitelist[0x894d3BE637D08Dd563a4F0680d07bfF63F5023bb] = true;
1296         whitelist[0x825e825D65ce535bac38617d25D0F6182ACa5A80] = true;
1297         whitelist[0xA56AC6Bf86212B039c0d5a4F32039B8DA1a9c6AE] = true;
1298         whitelist[0x91cB240fdF49c9231A44391a7B899ab8D8EBEa85] = true;
1299         whitelist[0xdC65010f53576BFf30F7eb3a6B4C055E50e1dD59] = true;
1300         whitelist[0x718bc2a2646d3bd44a4949817e9eC3977E63c7F9] = true;
1301         whitelist[0xc6D22E96b86811dcA83F4b710610F5ab697534b5] = true;
1302         whitelist[0xE181b5C3bA16b6b13b5Bf3FEbe569C7BF300358c] = true;
1303         whitelist[0x3A8B8d1d156477BF6Fd20f248eF8b2f1d03fB251] = true;
1304         whitelist[0xa85352ff10189979e9A2d051Ff7BeF36CfA4105E] = true;
1305         whitelist[0x267d7aDC497CdaCc9E986b03E76030173c2f071F] = true;
1306         whitelist[0x61299F94ede485b997760e5fC789f432D82ba60e] = true;
1307         whitelist[0x1B7C38ED20337Eb5107E4d2324D6fb7485B0828B] = true;
1308         whitelist[0x8A53b410031c6C606CD495DFE1F3e65003dC384C] = true;
1309         whitelist[0xF0BF03895366f562A5d079EbED178Ebb0F3C137f] = true;
1310         whitelist[0x9050618292cFd34C7768e1DF8B0C14CaFE99AE2D] = true;
1311         whitelist[0x3F5d7a01D9A32817d9cE7EEb85cF40e95c32Cb84] = true;
1312         whitelist[0xA26c5F0b89322cd75828d5085Db8164287315df3] = true;
1313         whitelist[0x101A0778cda24359A096342A2Aa45eF52A6Ec1dF] = true;
1314         whitelist[0xffC81e8FF9A40727d7df97233F1Fae26344EB90C] = true;
1315         whitelist[0x8BB8056D9B8A6f7c19d292182E8bD0555703619D] = true;
1316         whitelist[0xAfC2F698a08B957CCc33a2D931AacEf2F970959E] = true;
1317         whitelist[0x154500Ccb9cC55A0E390966AA53Fe10E7DA1047d] = true;
1318         whitelist[0x332EEbd4bC9027176ABac020B32FB401B685b622] = true;
1319         whitelist[0x4a8A003acC8a2c0329286e46650bE18dfe2cb12d] = true;
1320         whitelist[0x18A47791DFd3A120BbB74dCcB78080773642B904] = true;
1321         whitelist[0xc42480b588Aff1B9f15Db3845fb74299195C8FCE] = true;
1322         whitelist[0x3679a16c418da3416F0D69C9F2458B2bFF795661] = true;
1323         whitelist[0xCE8115142c4F1a6800eFE097B7906C69391A4E0f] = true;
1324         whitelist[0xb87887822e4F856D9c9BeE711970474b2804e85B] = true;
1325         whitelist[0x823b47733E2B3eE86cfF4263CE3Df8FF3FD733c3] = true;
1326         whitelist[0x8f4EA43f0CAf2a8D9Bb0dC4d2e23C809F13807da] = true;
1327         whitelist[0x888E0021b852BB4acE259e2a1E635d4dF090955c] = true;
1328         whitelist[0x453AE45bd4a672A708902C5ecF7da9C746C22aE2] = true;
1329         whitelist[0x06b745CB7564E6c7B1eaB76aa017000229f1fF7c] = true;
1330         whitelist[0xF514Cda5173cDf41b2f1784cBc3dAAb68cd177bd] = true;
1331         whitelist[0x585f2C2142550503E5441f1257512C6EDE6E9C14] = true;
1332         whitelist[0x56CF2aFF10c47CcD54ea9bEF6c723fDdA18c09c8] = true;
1333         whitelist[0x24C6E698a4bC01A70223F9d10bB6C4B7c62C3654] = true;
1334         whitelist[0xc0206D84Ac53242B48700ee4d31292c9A039F56D] = true;
1335         whitelist[0x3D7E059A0805cEe4eAd6052725E2738275E873d2] = true;
1336         whitelist[0x7f87b63c5DE256E81cC9465C3364d2c288837406] = true;
1337         whitelist[0xF7ce09F3df6c357dd3337F5700b0ec64E4b4cd1B] = true;
1338         whitelist[0x352469270f9AebcF41503fAa69f9d9a2Dd21271F] = true;
1339         whitelist[0xf9d1144F72E59Cf2Ec1c0A9e1a35a93B41B28F95] = true;
1340         whitelist[0x7597CF59d781d626D851D3301AD7DAb682692788] = true;
1341         whitelist[0x0e8aF8a5ad2dE05d29092b0456089ad46657c67e] = true;
1342         whitelist[0xEb7BC5C16C0E31Aa4f386E7B1D529c45D7750AC7] = true;
1343         whitelist[0xEb7BC5C16C0E31Aa4f386E7B1D529c45D7750AC7] = true;
1344         whitelist[0x780CFD2F5fA3E3cB8F99Bc14A0879C698Db04583] = true;
1345         whitelist[0xe6E416d39Dd0b521dA1b59D3af4D8930e6d5626B] = true;
1346         whitelist[0xA79042D975C435b5B02196e363F4A09147230ebf] = true;
1347         whitelist[0x732Bb12525961f5853154DeB9d0a4Aacd2eB240f] = true;
1348         whitelist[0x70D7B21f7585c02A665aD6AC0C900AF0cEAB2b55] = true;
1349         whitelist[0x0E01800b3Edf3933657d08aa39FE2152FC325E97] = true;
1350         whitelist[0x7301A502ce32e15838Ec1E4F10e2BFc2Ec3bf0a0] = true;
1351         whitelist[0x1Ccf5898c6Fa8208BAA2918A4fB4E283069bd1bE] = true;
1352         whitelist[0x64A060C7b979e1de998Bca7AE30BB700fDaf6998] = true;
1353         whitelist[0xF514CD2D661ad6bE472df3b7398492F40609bFEC] = true;
1354         whitelist[0x8A1137F86d2e33BF6a1Fb97159B0327bf1bE19ff] = true;
1355         whitelist[0x8D8f852De8698013E015A2a3260Df7409cB352E7] = true;
1356         whitelist[0x530e6E083E6D842DD883D9D1F59a8733dA1Dbf9d] = true;
1357         whitelist[0x5356d041cFdE0fbFa7691327AC29Fe9709C3F6B7] = true;
1358         whitelist[0x74D6D53dD045220DCE6999b5C9a2E468d881c6c6] = true;
1359         whitelist[0x299E736200fC47486f7BCfE04D5EEA8C7D0a7006] = true;
1360         whitelist[0xb26a76fB5dA1a3cd337bC11be8b0222D2ab16e91] = true;
1361         whitelist[0xeb42523A092CeaFb6b5b52b0a88d3F88154A3494] = true;
1362         whitelist[0x173aaE27F24539142452Fe2FC2927F6966B04664] = true;
1363         whitelist[0x5Ab733A1cbBd39f452BdC6869CE30e7BBBA3D3D0] = true;
1364         whitelist[0x649343619d5D1cd7a5C7D9553eD756BDa225B608] = true;
1365     }
1366 
1367     /**
1368       * @dev validates whitelist
1369     */
1370     modifier isWhitelisted(address _sender) {
1371         require(whitelist[msg.sender], "Address does not exist in OG list");
1372         _;
1373     }
1374 
1375     modifier mintCompliance(uint256 _mintAmount) {
1376         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1377         require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1378         _;
1379     }
1380 
1381     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1382         require(!paused, "The contract is paused!");
1383         require(!onlyWhitelisted, "Presale is on");
1384         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1385 
1386         _safeMint(msg.sender, _mintAmount);
1387     }
1388 
1389     function mintWhitelist(uint256 _mintAmount) public payable isWhitelisted(msg.sender) {
1390         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1391         require(!paused, "The contract is paused!");
1392         require(onlyWhitelisted, "Presale has ended");
1393         require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1394         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1395 
1396         addressMintedBalance[msg.sender] += _mintAmount;
1397         _safeMint(msg.sender, _mintAmount);
1398     }
1399 
1400     function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1401         _safeMint(_to, _mintAmount);
1402     }
1403 
1404     function walletOfOwner(address _owner)
1405     public
1406     view
1407     returns (uint256[] memory)
1408     {
1409         uint256 ownerTokenCount = balanceOf(_owner);
1410         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1411         uint256 currentTokenId = 0;
1412         uint256 ownedTokenIndex = 0;
1413 
1414         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1415             address currentTokenOwner = ownerOf(currentTokenId);
1416 
1417             if (currentTokenOwner == _owner) {
1418                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1419 
1420                 ownedTokenIndex++;
1421             }
1422 
1423             currentTokenId++;
1424         }
1425 
1426         return ownedTokenIds;
1427     }
1428 
1429     function tokenURI(uint256 _tokenId)
1430     public
1431     view
1432     virtual
1433     override
1434     returns (string memory)
1435     {
1436         require(
1437             _exists(_tokenId),
1438             "ERC721Metadata: URI query for nonexistent token"
1439         );
1440 
1441         string memory currentBaseURI = _baseURI();
1442         return bytes(currentBaseURI).length > 0
1443         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1444         : "";
1445     }
1446 
1447     function setOnlyWhitelisted(bool _state) public onlyOwner {
1448         onlyWhitelisted = _state;
1449     }
1450 
1451     function setCost(uint256 _cost) public onlyOwner {
1452         cost = _cost;
1453     }
1454 
1455     function setNftPerAddressLimitWl(uint256 _limit) public onlyOwner {
1456         nftPerAddressLimitWl = _limit;
1457     }
1458 
1459     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1460         uriPrefix = _uriPrefix;
1461     }
1462 
1463     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1464         uriSuffix = _uriSuffix;
1465     }
1466 
1467     function setPaused(bool _state) public onlyOwner {
1468         paused = _state;
1469     }
1470 
1471     function withdraw() public onlyOwner {
1472         (bool os,) = payable(owner()).call{value : address(this).balance}("");
1473         require(os);
1474     }
1475 
1476     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1477         _safeMint(_receiver, _mintAmount);
1478     }
1479 
1480     function _baseURI() internal view virtual override returns (string memory) {
1481         return uriPrefix;
1482     }
1483 }