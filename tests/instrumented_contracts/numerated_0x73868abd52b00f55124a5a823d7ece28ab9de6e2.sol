1 // SPDX-License-Identifier: MIT
2 // World of Pride
3 // 8000 Nft collection
4 // Price 0.03 ETH
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Address.sol
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      */
207     function isContract(address account) internal view returns (bool) {
208         // This method relies on extcodesize, which returns 0 for contracts in
209         // construction, since the code is only stored at the end of the
210         // constructor execution.
211 
212         uint256 size;
213         assembly {
214             size := extcodesize(account)
215         }
216         return size > 0;
217     }
218 
219     /**
220      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
221      * `recipient`, forwarding all available gas and reverting on errors.
222      *
223      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
224      * of certain opcodes, possibly making contracts go over the 2300 gas limit
225      * imposed by `transfer`, making them unable to receive funds via
226      * `transfer`. {sendValue} removes this limitation.
227      *
228      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
229      *
230      * IMPORTANT: because control is transferred to `recipient`, care must be
231      * taken to not create reentrancy vulnerabilities. Consider using
232      * {ReentrancyGuard} or the
233      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
234      */
235     function sendValue(address payable recipient, uint256 amount) internal {
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         require(success, "Address: unable to send value, recipient may have reverted");
240     }
241 
242     /**
243      * @dev Performs a Solidity function call using a low level `call`. A
244      * plain `call` is an unsafe replacement for a function call: use this
245      * function instead.
246      *
247      * If `target` reverts with a revert reason, it is bubbled up by this
248      * function (like regular Solidity function calls).
249      *
250      * Returns the raw returned data. To convert to the expected return value,
251      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
252      *
253      * Requirements:
254      *
255      * - `target` must be a contract.
256      * - calling `target` with `data` must not revert.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionCall(target, data, "Address: low-level call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, 0, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but also transferring `value` wei to `target`.
281      *
282      * Requirements:
283      *
284      * - the calling contract must have an ETH balance of at least `value`.
285      * - the called Solidity function must be `payable`.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(
290         address target,
291         bytes memory data,
292         uint256 value
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
299      * with `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(address(this).balance >= value, "Address: insufficient balance for call");
310         require(isContract(target), "Address: call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.call{value: value}(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
323         return functionStaticCall(target, data, "Address: low-level static call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal view returns (bytes memory) {
337         require(isContract(target), "Address: static call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.staticcall(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(isContract(target), "Address: delegate call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
372      * revert reason using the provided one.
373      *
374      * _Available since v4.3._
375      */
376     function verifyCallResult(
377         bool success,
378         bytes memory returndata,
379         string memory errorMessage
380     ) internal pure returns (bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @title ERC721 token receiver interface
408  * @dev Interface for any contract that wants to support safeTransfers
409  * from ERC721 asset contracts.
410  */
411 interface IERC721Receiver {
412     /**
413      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
414      * by `operator` from `from`, this function is called.
415      *
416      * It must return its Solidity selector to confirm the token transfer.
417      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
418      *
419      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
420      */
421     function onERC721Received(
422         address operator,
423         address from,
424         uint256 tokenId,
425         bytes calldata data
426     ) external returns (bytes4);
427 }
428 
429 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 /**
437  * @dev Interface of the ERC165 standard, as defined in the
438  * https://eips.ethereum.org/EIPS/eip-165[EIP].
439  *
440  * Implementers can declare support of contract interfaces, which can then be
441  * queried by others ({ERC165Checker}).
442  *
443  * For an implementation, see {ERC165}.
444  */
445 interface IERC165 {
446     /**
447      * @dev Returns true if this contract implements the interface defined by
448      * `interfaceId`. See the corresponding
449      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
450      * to learn more about how these ids are created.
451      *
452      * This function call must use less than 30 000 gas.
453      */
454     function supportsInterface(bytes4 interfaceId) external view returns (bool);
455 }
456 
457 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Implementation of the {IERC165} interface.
467  *
468  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
469  * for the additional interface id that will be supported. For example:
470  *
471  * ```solidity
472  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
474  * }
475  * ```
476  *
477  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
478  */
479 abstract contract ERC165 is IERC165 {
480     /**
481      * @dev See {IERC165-supportsInterface}.
482      */
483     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484         return interfaceId == type(IERC165).interfaceId;
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Required interface of an ERC721 compliant contract.
498  */
499 interface IERC721 is IERC165 {
500     /**
501      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
502      */
503     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
504 
505     /**
506      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
507      */
508     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
512      */
513     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
514 
515     /**
516      * @dev Returns the number of tokens in ``owner``'s account.
517      */
518     function balanceOf(address owner) external view returns (uint256 balance);
519 
520     /**
521      * @dev Returns the owner of the `tokenId` token.
522      *
523      * Requirements:
524      *
525      * - `tokenId` must exist.
526      */
527     function ownerOf(uint256 tokenId) external view returns (address owner);
528 
529     /**
530      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
531      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must exist and be owned by `from`.
538      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId
547     ) external;
548 
549     /**
550      * @dev Transfers `tokenId` token from `from` to `to`.
551      *
552      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      *
561      * Emits a {Transfer} event.
562      */
563     function transferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) external;
568 
569     /**
570      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
571      * The approval is cleared when the token is transferred.
572      *
573      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
574      *
575      * Requirements:
576      *
577      * - The caller must own the token or be an approved operator.
578      * - `tokenId` must exist.
579      *
580      * Emits an {Approval} event.
581      */
582     function approve(address to, uint256 tokenId) external;
583 
584     /**
585      * @dev Returns the account approved for `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function getApproved(uint256 tokenId) external view returns (address operator);
592 
593     /**
594      * @dev Approve or remove `operator` as an operator for the caller.
595      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
596      *
597      * Requirements:
598      *
599      * - The `operator` cannot be the caller.
600      *
601      * Emits an {ApprovalForAll} event.
602      */
603     function setApprovalForAll(address operator, bool _approved) external;
604 
605     /**
606      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
607      *
608      * See {setApprovalForAll}
609      */
610     function isApprovedForAll(address owner, address operator) external view returns (bool);
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId,
629         bytes calldata data
630     ) external;
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
643  * @dev See https://eips.ethereum.org/EIPS/eip-721
644  */
645 interface IERC721Enumerable is IERC721 {
646     /**
647      * @dev Returns the total amount of tokens stored by the contract.
648      */
649     function totalSupply() external view returns (uint256);
650 
651     /**
652      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
653      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
654      */
655     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
656 
657     /**
658      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
659      * Use along with {totalSupply} to enumerate all tokens.
660      */
661     function tokenByIndex(uint256 index) external view returns (uint256);
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 interface IERC721Metadata is IERC721 {
677     /**
678      * @dev Returns the token collection name.
679      */
680     function name() external view returns (string memory);
681 
682     /**
683      * @dev Returns the token collection symbol.
684      */
685     function symbol() external view returns (string memory);
686 
687     /**
688      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
689      */
690     function tokenURI(uint256 tokenId) external view returns (string memory);
691 }
692 
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
699  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
700  *
701  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
702  *
703  * Does not support burning tokens to address(0).
704  *
705  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
706  */
707 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
708     using Address for address;
709     using Strings for uint256;
710 
711     struct TokenOwnership {
712         address addr;
713         uint64 startTimestamp;
714     }
715 
716     struct AddressData {
717         uint128 balance;
718         uint128 numberMinted;
719     }
720 
721     uint256 internal currentIndex = 0;
722 
723     uint256 internal immutable maxBatchSize;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to ownership details
732     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
733     mapping(uint256 => TokenOwnership) internal _ownerships;
734 
735     // Mapping owner address to address data
736     mapping(address => AddressData) private _addressData;
737 
738     // Mapping from token ID to approved address
739     mapping(uint256 => address) private _tokenApprovals;
740 
741     // Mapping from owner to operator approvals
742     mapping(address => mapping(address => bool)) private _operatorApprovals;
743 
744     /**
745      * @dev
746      * `maxBatchSize` refers to how much a minter can mint at a time.
747      */
748     constructor(
749         string memory name_,
750         string memory symbol_,
751         uint256 maxBatchSize_
752     ) {
753         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
754         _name = name_;
755         _symbol = symbol_;
756         maxBatchSize = maxBatchSize_;
757     }
758 
759     /**
760      * @dev See {IERC721Enumerable-totalSupply}.
761      */
762     function totalSupply() public view override returns (uint256) {
763         return currentIndex;
764     }
765 
766     /**
767      * @dev See {IERC721Enumerable-tokenByIndex}.
768      */
769     function tokenByIndex(uint256 index) public view override returns (uint256) {
770         require(index < totalSupply(), 'ERC721A: global index out of bounds');
771         return index;
772     }
773 
774     /**
775      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
776      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
777      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
778      */
779     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
780         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
781         uint256 numMintedSoFar = totalSupply();
782         uint256 tokenIdsIdx = 0;
783         address currOwnershipAddr = address(0);
784         for (uint256 i = 0; i < numMintedSoFar; i++) {
785             TokenOwnership memory ownership = _ownerships[i];
786             if (ownership.addr != address(0)) {
787                 currOwnershipAddr = ownership.addr;
788             }
789             if (currOwnershipAddr == owner) {
790                 if (tokenIdsIdx == index) {
791                     return i;
792                 }
793                 tokenIdsIdx++;
794             }
795         }
796         revert('ERC721A: unable to get token of owner by index');
797     }
798 
799     /**
800      * @dev See {IERC165-supportsInterface}.
801      */
802     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
803         return
804             interfaceId == type(IERC721).interfaceId ||
805             interfaceId == type(IERC721Metadata).interfaceId ||
806             interfaceId == type(IERC721Enumerable).interfaceId ||
807             super.supportsInterface(interfaceId);
808     }
809 
810     /**
811      * @dev See {IERC721-balanceOf}.
812      */
813     function balanceOf(address owner) public view override returns (uint256) {
814         require(owner != address(0), 'ERC721A: balance query for the zero address');
815         return uint256(_addressData[owner].balance);
816     }
817 
818     function _numberMinted(address owner) internal view returns (uint256) {
819         require(owner != address(0), 'ERC721A: number minted query for the zero address');
820         return uint256(_addressData[owner].numberMinted);
821     }
822 
823     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
824         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
825 
826         uint256 lowestTokenToCheck;
827         if (tokenId >= maxBatchSize) {
828             lowestTokenToCheck = tokenId - maxBatchSize + 1;
829         }
830 
831         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
832             TokenOwnership memory ownership = _ownerships[curr];
833             if (ownership.addr != address(0)) {
834                 return ownership;
835             }
836         }
837 
838         revert('ERC721A: unable to determine the owner of token');
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view override returns (address) {
845         return ownershipOf(tokenId).addr;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-name}.
850      */
851     function name() public view virtual override returns (string memory) {
852         return _name;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-symbol}.
857      */
858     function symbol() public view virtual override returns (string memory) {
859         return _symbol;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-tokenURI}.
864      */
865     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
866         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
867 
868         string memory baseURI = _baseURI();
869         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
870     }
871 
872     /**
873      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
874      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
875      * by default, can be overriden in child contracts.
876      */
877     function _baseURI() internal view virtual returns (string memory) {
878         return '';
879     }
880 
881     /**
882      * @dev See {IERC721-approve}.
883      */
884     function approve(address to, uint256 tokenId) public override {
885         address owner = ERC721A.ownerOf(tokenId);
886         require(to != owner, 'ERC721A: approval to current owner');
887 
888         require(
889             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
890             'ERC721A: approve caller is not owner nor approved for all'
891         );
892 
893         _approve(to, tokenId, owner);
894     }
895 
896     /**
897      * @dev See {IERC721-getApproved}.
898      */
899     function getApproved(uint256 tokenId) public view override returns (address) {
900         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved) public override {
909         require(operator != _msgSender(), 'ERC721A: approve to caller');
910 
911         _operatorApprovals[_msgSender()][operator] = approved;
912         emit ApprovalForAll(_msgSender(), operator, approved);
913     }
914 
915     /**
916      * @dev See {IERC721-isApprovedForAll}.
917      */
918     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
919         return _operatorApprovals[owner][operator];
920     }
921 
922     /**
923      * @dev See {IERC721-transferFrom}.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public override {
930         _transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public override {
941         safeTransferFrom(from, to, tokenId, '');
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) public override {
953         _transfer(from, to, tokenId);
954         require(
955             _checkOnERC721Received(from, to, tokenId, _data),
956             'ERC721A: transfer to non ERC721Receiver implementer'
957         );
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted (`_mint`),
966      */
967     function _exists(uint256 tokenId) internal view returns (bool) {
968         return tokenId < currentIndex;
969     }
970 
971     function _safeMint(address to, uint256 quantity) internal {
972         _safeMint(to, quantity, '');
973     }
974 
975     /**
976      * @dev Mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `quantity` cannot be larger than the max batch size.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(
986         address to,
987         uint256 quantity,
988         bytes memory _data
989     ) internal {
990         uint256 startTokenId = currentIndex;
991         require(to != address(0), 'ERC721A: mint to the zero address');
992         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
993         require(!_exists(startTokenId), 'ERC721A: token already minted');
994         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
995         require(quantity > 0, 'ERC721A: quantity must be greater 0');
996 
997         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
998 
999         AddressData memory addressData = _addressData[to];
1000         _addressData[to] = AddressData(
1001             addressData.balance + uint128(quantity),
1002             addressData.numberMinted + uint128(quantity)
1003         );
1004         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1005 
1006         uint256 updatedIndex = startTokenId;
1007 
1008         for (uint256 i = 0; i < quantity; i++) {
1009             emit Transfer(address(0), to, updatedIndex);
1010             require(
1011                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1012                 'ERC721A: transfer to non ERC721Receiver implementer'
1013             );
1014             updatedIndex++;
1015         }
1016 
1017         currentIndex = updatedIndex;
1018         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) private {
1036         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1037 
1038         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1039             getApproved(tokenId) == _msgSender() ||
1040             isApprovedForAll(prevOwnership.addr, _msgSender()));
1041 
1042         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1043 
1044         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1045         require(to != address(0), 'ERC721A: transfer to the zero address');
1046 
1047         _beforeTokenTransfers(from, to, tokenId, 1);
1048 
1049         // Clear approvals from the previous owner
1050         _approve(address(0), tokenId, prevOwnership.addr);
1051 
1052         // Underflow of the sender's balance is impossible because we check for
1053         // ownership above and the recipient's balance can't realistically overflow.
1054         unchecked {
1055             _addressData[from].balance -= 1;
1056             _addressData[to].balance += 1;
1057         }
1058 
1059         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1060 
1061         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063         uint256 nextTokenId = tokenId + 1;
1064         if (_ownerships[nextTokenId].addr == address(0)) {
1065             if (_exists(nextTokenId)) {
1066                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1067             }
1068         }
1069 
1070         emit Transfer(from, to, tokenId);
1071         _afterTokenTransfers(from, to, tokenId, 1);
1072     }
1073 
1074     /**
1075      * @dev Approve `to` to operate on `tokenId`
1076      *
1077      * Emits a {Approval} event.
1078      */
1079     function _approve(
1080         address to,
1081         uint256 tokenId,
1082         address owner
1083     ) private {
1084         _tokenApprovals[tokenId] = to;
1085         emit Approval(owner, to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1090      * The call is not executed if the target address is not a contract.
1091      *
1092      * @param from address representing the previous owner of the given token ID
1093      * @param to target address that will receive the tokens
1094      * @param tokenId uint256 ID of the token to be transferred
1095      * @param _data bytes optional data to send along with the call
1096      * @return bool whether the call correctly returned the expected magic value
1097      */
1098     function _checkOnERC721Received(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) private returns (bool) {
1104         if (to.isContract()) {
1105             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1106                 return retval == IERC721Receiver(to).onERC721Received.selector;
1107             } catch (bytes memory reason) {
1108                 if (reason.length == 0) {
1109                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1110                 } else {
1111                     assembly {
1112                         revert(add(32, reason), mload(reason))
1113                     }
1114                 }
1115             }
1116         } else {
1117             return true;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1123      *
1124      * startTokenId - the first token id to be transferred
1125      * quantity - the amount to be transferred
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      */
1133     function _beforeTokenTransfers(
1134         address from,
1135         address to,
1136         uint256 startTokenId,
1137         uint256 quantity
1138     ) internal virtual {}
1139 
1140     /**
1141      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1142      * minting.
1143      *
1144      * startTokenId - the first token id to be transferred
1145      * quantity - the amount to be transferred
1146      *
1147      * Calling conditions:
1148      *
1149      * - when `from` and `to` are both non-zero.
1150      * - `from` and `to` are never both zero.
1151      */
1152     function _afterTokenTransfers(
1153         address from,
1154         address to,
1155         uint256 startTokenId,
1156         uint256 quantity
1157     ) internal virtual {}
1158 }
1159 
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 contract WorldOfPride is ERC721A, Ownable {
1164   using Strings for uint256;
1165 
1166   string private uriPrefix = "ipfs://QmeXtZ1P1QihbsYWvBprLp8mwcaEfes3NeuXJ7BMjJu5S7/";
1167   string private uriSuffix = ".json";
1168   string public hiddenMetadataUri;
1169   
1170   uint256 public price = 0.03 ether; 
1171   uint256 public maxSupply = 8000; 
1172   uint256 public maxMintAmountPerTx = 50; 
1173   
1174   bool public paused = true;
1175   bool public revealed = true;
1176   mapping(address => uint256) public addressMintedBalance;
1177 
1178 
1179   constructor() ERC721A("World of Pride", "WoP", maxMintAmountPerTx) {
1180     setHiddenMetadataUri("");
1181   }
1182 
1183   modifier mintCompliance(uint256 _mintAmount) {
1184     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1185     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1186     _;
1187   }
1188 
1189   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1190    {
1191     require(!paused, "The contract is paused!");
1192     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1193     
1194     
1195     _safeMint(msg.sender, _mintAmount);
1196   }
1197 
1198    
1199   function Airdrop(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1200     _safeMint(_to, _mintAmount);
1201   }
1202 
1203  
1204   function walletOfOwner(address _owner)
1205     public
1206     view
1207     returns (uint256[] memory)
1208   {
1209     uint256 ownerTokenCount = balanceOf(_owner);
1210     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1211     uint256 currentTokenId = 0;
1212     uint256 ownedTokenIndex = 0;
1213 
1214     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1215       address currentTokenOwner = ownerOf(currentTokenId);
1216 
1217       if (currentTokenOwner == _owner) {
1218         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1219 
1220         ownedTokenIndex++;
1221       }
1222 
1223       currentTokenId++;
1224     }
1225 
1226     return ownedTokenIds;
1227   }
1228 
1229   function tokenURI(uint256 _tokenId)
1230     public
1231     view
1232     virtual
1233     override
1234     returns (string memory)
1235   {
1236     require(
1237       _exists(_tokenId),
1238       "ERC721Metadata: URI query for nonexistent token"
1239     );
1240 
1241     if (revealed == false) {
1242       return hiddenMetadataUri;
1243     }
1244 
1245     string memory currentBaseURI = _baseURI();
1246     return bytes(currentBaseURI).length > 0
1247         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1248         : "";
1249   }
1250 
1251   function setRevealed(bool _state) public onlyOwner {
1252     revealed = _state;
1253   
1254   }
1255 
1256   function setPrice(uint256 _price) public onlyOwner {
1257     price = _price;
1258 
1259   }
1260  
1261   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1262     hiddenMetadataUri = _hiddenMetadataUri;
1263   }
1264 
1265 
1266 
1267   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1268     uriPrefix = _uriPrefix;
1269   }
1270 
1271   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1272     uriSuffix = _uriSuffix;
1273   }
1274 
1275   function setPaused(bool _state) public onlyOwner {
1276     paused = _state;
1277   }
1278 
1279   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1280       _safeMint(_receiver, _mintAmount);
1281   }
1282 
1283   function _baseURI() internal view virtual override returns (string memory) {
1284     return uriPrefix;
1285     
1286   }
1287 
1288     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1289     maxMintAmountPerTx = _maxMintAmountPerTx;
1290 
1291   }
1292 
1293     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1294     maxSupply = _maxSupply;
1295 
1296   }
1297 
1298 
1299   // withdrawall addresses
1300   address t1 = 0x31a59E4f0a2c5F3Dec42B6b809A29dA77C10387E; 
1301   
1302 
1303   function withdrawall() public onlyOwner {
1304         uint256 _balance = address(this).balance;
1305         
1306         require(payable(t1).send(_balance * 100 / 100 ));
1307         
1308     }
1309 
1310   function withdraw() public onlyOwner {
1311     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1312     require(os);
1313     
1314 
1315  
1316   }
1317   
1318 }