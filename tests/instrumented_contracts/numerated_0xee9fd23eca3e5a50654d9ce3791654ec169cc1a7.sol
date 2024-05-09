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
631 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Metadata is IERC721 {
644     /**
645      * @dev Returns the token collection name.
646      */
647     function name() external view returns (string memory);
648 
649     /**
650      * @dev Returns the token collection symbol.
651      */
652     function symbol() external view returns (string memory);
653 
654     /**
655      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
656      */
657     function tokenURI(uint256 tokenId) external view returns (string memory);
658 }
659 
660 // File: contracts/ERC721/.sol
661 
662 
663 pragma solidity ^0.8.11;
664 
665 //------------------------------------------------------------------------------
666 //------------------------------------------------------------------------------
667 
668 //----------------------------------------------------------------------------
669 // Openzeppelin contracts
670 //----------------------------------------------------------------------------
671 
672 
673 
674 
675 
676 
677 
678 
679 /**
680  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721
681  *  [ERC721] Non-Fungible Token Standard
682  *
683  *  This implmentation of ERC721 needs a maximum number of NFTs to provide
684  *  efficient minting.  Storage for balance are no longer required reducing
685  *  gas significantly.  This comes at the price of calculating the balance by
686  *  iterating through the entire number of maximum NFTs, but enables the
687  *  possibility of creating sections of sequential mint.
688  */
689 contract ERC721QD is Context, ERC165, IERC721, IERC721Metadata {
690     using Address for address;
691     using Strings for uint256;
692 
693     //Max Supply
694     uint256 private _maxSupply;
695 
696     // Token name
697     string private _name;
698 
699     // Token symbol
700     string private _symbol;
701 
702     // Mapping from token ID to owner address
703     mapping(uint256 => address) internal _owners;
704 
705     // Mapping from token ID to approved address
706     mapping(uint256 => address) private _tokenApprovals;
707 
708     // Mapping from owner to operator approvals
709     mapping(address => mapping(address => bool)) private _operatorApprovals;
710 
711     /**
712      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
713      */
714     constructor(string memory name_, string memory symbol_, uint256 maxSupply_) {
715         _name = name_;
716         _symbol = symbol_;
717         _maxSupply = maxSupply_;
718     }
719 
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
724         return
725             interfaceId == type(IERC721).interfaceId ||
726             interfaceId == type(IERC721Metadata).interfaceId ||
727             super.supportsInterface(interfaceId);
728     }
729 
730     /**
731      * @dev See {IERC721-balanceOf}.
732      */
733     function balanceOf(address owner) public view virtual override returns (uint256 balance) {
734         require(owner != address(0), "ERC721: balance query for the zero address");
735         unchecked {
736             for (uint256 i = 0; i < _maxSupply; ++i) {
737                 if (_owners[i] == owner) {
738                     ++balance;
739                 }
740             }
741         }
742     }
743 
744     /**
745      * @dev See {IERC721-ownerOf}.
746      */
747     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
748         require(_exists(tokenId), "ERC721: owner query for nonexistent token");
749         address owner = _owners[tokenId];
750         return owner;
751     }
752 
753     /**
754      * @dev See {IERC721Metadata-name}.
755      */
756     function name() public view virtual override returns (string memory) {
757         return _name;
758     }
759 
760     /**
761      * @dev Returns the MaxSupply for the Smart Contract
762      */
763     function maxSupply() public view virtual returns (uint256) {
764         return _maxSupply;
765     }
766 
767     /**
768      * @dev See {IERC721Metadata-symbol}.
769      */
770     function symbol() public view virtual override returns (string memory) {
771         return _symbol;
772     }    
773 
774     /**
775      * @dev See {IERC721Metadata-tokenURI}.
776      */
777     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
778         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
779 
780         string memory baseURI = _baseURI();
781         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
782     }
783 
784     /**
785      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
786      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
787      * by default, can be overriden in child contracts.
788      */
789     function _baseURI() internal view virtual returns (string memory) {
790         return "";
791     }
792 
793     /**
794      * @dev See {IERC721-approve}.
795      */
796     function approve(address to, uint256 tokenId) public virtual override {
797         address owner = ERC721QD.ownerOf(tokenId);
798         require(to != owner, "ERC721: approval to current owner");
799 
800         require(
801             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
802             "ERC721: approve caller is not owner nor approved for all"
803         );
804 
805         _approve(to, tokenId);
806     }
807 
808     /**
809      * @dev See {IERC721-getApproved}.
810      */
811     function getApproved(uint256 tokenId) public view virtual override returns (address) {
812         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
813 
814         return _tokenApprovals[tokenId];
815     }
816 
817     /**
818      * @dev See {IERC721-setApprovalForAll}.
819      */
820     function setApprovalForAll(address operator, bool approved) public virtual override {
821         _setApprovalForAll(_msgSender(), operator, approved);
822     }
823 
824     /**
825      * @dev See {IERC721-isApprovedForAll}.
826      */
827     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
828         return _operatorApprovals[owner][operator];
829     }
830 
831     /**
832      * @dev See {IERC721-transferFrom}.
833      */
834     function transferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public virtual override {
839         //solhint-disable-next-line max-line-length
840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
841 
842         _transfer(from, to, tokenId);
843     }
844 
845     /**
846      * @dev See {IERC721-safeTransferFrom}.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         safeTransferFrom(from, to, tokenId, "");
854     }
855 
856     /**
857      * @dev See {IERC721-safeTransferFrom}.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) public virtual override {
865         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
866         _safeTransfer(from, to, tokenId, _data);
867     }
868 
869     /**
870      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
871      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
872      *
873      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
874      *
875      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
876      * implement alternative mechanisms to perform token transfer, such as signature-based.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must exist and be owned by `from`.
883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _safeTransfer(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) internal virtual {
893         _transfer(from, to, tokenId);
894         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
895     }
896 
897     /**
898      * @dev Returns whether `tokenId` exists.
899      *
900      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901      *
902      * Tokens start existing when they are minted (`_mint`),
903      * and stop existing when they are burned (`_burn`).
904      */
905     function _exists(uint256 tokenId) internal view virtual returns (bool) {
906         return tokenId < _maxSupply && _owners[tokenId] != address(0);
907     }
908 
909     /**
910      * @dev Returns whether `spender` is allowed to manage `tokenId`.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      */
916     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
917         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
918         address owner = ERC721QD.ownerOf(tokenId);
919         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
920     }
921 
922     /**
923      * @dev Safely mints `tokenId` and transfers it to `to`.
924      *
925      * Requirements:
926      *
927      * - `tokenId` must not exist.
928      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _safeMint(address to, uint256 tokenId) internal virtual {
933         _safeMint(to, tokenId, "");
934     }
935 
936     /**
937      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
938      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
939      */
940     function _safeMint(
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) internal virtual {
945         _mint(to,tokenId);
946         require(
947             _checkOnERC721Received(address(0), to, tokenId, _data),
948             "ERC721: transfer to non ERC721Receiver implementer"
949         );
950     }
951 
952     /**
953      * @dev Mints `tokenId` and transfers it to `to`.
954      *
955      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
956      *
957      * Requirements:
958      *
959      * - `tokenId` must not exist.
960      * - `to` cannot be the zero address.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _mint(address to, uint256 tokenId) internal virtual{
965         require(to != address(0), "ERC721: mint to the zero address");
966         require(!_exists(tokenId), "ERC721: token already minted");
967 
968         _beforeTokenTransfer(address(0), to, tokenId);
969         _owners[tokenId] = to;
970 
971         emit Transfer(address(0), to, tokenId);
972     }
973 
974     /**
975      * @dev Destroys `tokenId`.
976      * The approval is cleared when the token is burned.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must exist.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _burn(uint256 tokenId) internal virtual {
985         address owner = ERC721QD.ownerOf(tokenId);
986 
987         _beforeTokenTransfer(owner, address(0), tokenId);
988 
989         // Clear approvals
990         _approve(address(0), tokenId);
991 
992         delete _owners[tokenId];
993 
994         emit Transfer(owner, address(0), tokenId);
995     }
996 
997     /**
998      * @dev Transfers `tokenId` from `from` to `to`.
999      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1000      *
1001      * Requirements:
1002      *
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must be owned by `from`.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _transfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) internal virtual {
1013         require(ERC721QD.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1014         require(to != address(0), "ERC721: transfer to the zero address");
1015 
1016         _beforeTokenTransfer(from, to, tokenId);
1017 
1018         // Clear approvals from the previous owner
1019         _approve(address(0), tokenId);
1020 
1021         _owners[tokenId] = to;
1022 
1023         emit Transfer(from, to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev Approve `to` to operate on `tokenId`
1028      *
1029      * Emits a {Approval} event.
1030      */
1031     function _approve(address to, uint256 tokenId) internal virtual {
1032         _tokenApprovals[tokenId] = to;
1033         emit Approval(ERC721QD.ownerOf(tokenId), to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Approve `operator` to operate on all of `owner` tokens
1038      *
1039      * Emits a {ApprovalForAll} event.
1040      */
1041     function _setApprovalForAll(
1042         address owner,
1043         address operator,
1044         bool approved
1045     ) internal virtual {
1046         require(owner != operator, "ERC721: approve to caller");
1047         _operatorApprovals[owner][operator] = approved;
1048         emit ApprovalForAll(owner, operator, approved);
1049     }
1050 
1051     /**
1052      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1053      * The call is not executed if the target address is not a contract.
1054      *
1055      * @param from address representing the previous owner of the given token ID
1056      * @param to target address that will receive the tokens
1057      * @param tokenId uint256 ID of the token to be transferred
1058      * @param _data bytes optional data to send along with the call
1059      * @return bool whether the call correctly returned the expected magic value
1060      */
1061     function _checkOnERC721Received(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) private returns (bool) {
1067         if (to.isContract()) {
1068             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1069                 return retval == IERC721Receiver.onERC721Received.selector;
1070             } catch (bytes memory reason) {
1071                 if (reason.length == 0) {
1072                     revert("ERC721: transfer to non ERC721Receiver implementer");
1073                 } else {
1074                     assembly {
1075                         revert(add(32, reason), mload(reason))
1076                     }
1077                 }
1078             }
1079         } else {
1080             return true;
1081         }
1082     }
1083 
1084     /**
1085      * @dev Hook that is called before any token transfer. This includes minting
1086      * and burning.
1087      *
1088      * Calling conditions:
1089      *
1090      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1091      * transferred to `to`.
1092      * - When `from` is zero, `tokenId` will be minted for `to`.
1093      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1094      * - `from` and `to` are never both zero.
1095      *
1096      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1097      */
1098     function _beforeTokenTransfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) internal virtual {}
1103 }
1104 // File: contracts/ERC721/ERC721QDPlus.sol
1105 
1106 
1107 pragma solidity ^0.8.11;
1108 
1109 //------------------------------------------------------------------------------
1110 //------------------------------------------------------------------------------
1111 
1112 /**
1113  * @dev This is a no storage implemntation of the optional extension {ERC721}
1114  * defined in the EIP that adds enumerability of all the token ids in the
1115  * contract as well as all token ids owned by each account. These functions
1116  * are mainly for convienence and should NEVER be called from inside a
1117  * contract on the chain. This implementation can't be used for projects 
1118  * with more than 5000 NFTs.
1119  */
1120 abstract contract ERC721QDPlus is ERC721QD {
1121     address constant zero = address(0);
1122 
1123     //track mint count for sequencial projects
1124     uint256 private _tottalSupply = 0; 
1125 
1126     /**
1127      * @dev See {IERC721Enumerable-totalSupply}.
1128      */
1129     function totalSupply()
1130         public
1131         view
1132         virtual
1133         returns (uint256)
1134     {
1135         return _tottalSupply;
1136     }
1137 
1138     function addTotalSupply (uint256 i)
1139         internal
1140     {
1141         _tottalSupply += i;
1142     }
1143 
1144     /**
1145      * @dev Destroys `tokenId`.
1146      * The approval is cleared when the token is burned.
1147      * The _tottalSupply is subtracted when the token is burned.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must exist.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _burn(uint256 tokenId) 
1156         internal 
1157         virtual  
1158         override
1159     {
1160         address owner = ERC721QD.ownerOf(tokenId);
1161 
1162         _beforeTokenTransfer(owner, address(0), tokenId);
1163 
1164         _approve(address(0), tokenId);
1165 
1166         delete _owners[tokenId];
1167 
1168         _tottalSupply--;
1169 
1170         emit Transfer(owner, address(0), tokenId);
1171     }
1172 
1173 }
1174 // File: contracts/ukrApes.sol
1175 
1176 
1177 pragma solidity ^0.8.11;
1178 
1179 //------------------------------------------------------------------------------
1180 //------------------------------------------------------------------------------
1181 
1182 
1183 
1184 
1185 contract ukrApes is ERC721QDPlus, Ownable  {
1186   using Strings for uint256;
1187 
1188   //NFT cost
1189   uint128 constant public publicCost = 0.01 ether;
1190 
1191   //erc721 metadata
1192   string constant private _name   = "ukrApes";
1193   string constant private _symbol = "ukrApes";
1194 
1195   //project max info
1196   uint16 constant private _maxSupply  = 10000;
1197   uint16 constant private _maxFreeSupply  = 2000;
1198   uint8  constant private _maxPerTnx  = 20; 
1199 
1200   //NFT stage Paused  = 0, Presale = 1, Public = 2. 
1201   uint8  private  _projectStage = 0;
1202   bool   public   reveled = false;
1203 
1204   //NFT URI
1205   string private _projectURI;
1206   string private _projectHiddenURI; 
1207   
1208   //payees shares for the project
1209   address[] private _payees;
1210   uint[] private _payeesShares;
1211 
1212   //Admin Addresses
1213   address[1] private _adminAddresses;  
1214 
1215   //track mint count for sequencial projects
1216   uint16 private _currentTokenId; 
1217 
1218   constructor(
1219     uint16 initialTokenId_,
1220     string memory projectURI_,
1221     address[] memory payees_,
1222     uint[] memory payeesShares_
1223    ) 
1224     ERC721QD(_name, _symbol, _maxSupply)
1225    {
1226     _projectURI = projectURI_;
1227     _payees = payees_;
1228     _payeesShares = payeesShares_;
1229     _currentTokenId = initialTokenId_ - 1;
1230     _adminAddresses = [msg.sender];
1231   }
1232 
1233   //-------------------------------------------------------------------------
1234   // modifiers
1235   //-------------------------------------------------------------------------
1236   modifier onlyAdmin() {
1237     require(isAdmin(), "caller not admin");
1238     _;
1239   }
1240 
1241   modifier inPublicSale() {
1242       require(_projectStage == 2, "contract is not on public sale");
1243       _;
1244   }   
1245 
1246   //-------------------------------------------------------------------------
1247   // internal
1248   //-------------------------------------------------------------------------
1249   function isAdmin() internal view returns(bool) {
1250     for(uint16 i = 0; i < _adminAddresses.length; i++){
1251       if(_adminAddresses[i] == msg.sender)
1252         return true;
1253     }
1254     return false;
1255   }
1256 
1257   function _baseURI() internal view virtual override returns (string memory) {
1258     return _projectURI;
1259   }
1260 
1261   //standart mint verification used by other functions
1262   function _mintNFT(address _to, uint256 _quantity, uint128 _price) private {
1263       require(_quantity <= _maxPerTnx, "Max per Tx exceeded.");
1264       require(_quantity * _price <= msg.value, "Insufficient funds.");
1265       require(_quantity + _currentTokenId <= _maxSupply,"Purchase exceeds available supply.");
1266       for (uint256 i = 0; i < _quantity; i++) {
1267           _currentTokenId++;
1268           _safeMint(_to, _currentTokenId);
1269       }
1270       addTotalSupply(_quantity);
1271   }    
1272 
1273   //-------------------------------------------------------------------------
1274   // public
1275   //-------------------------------------------------------------------------
1276   // @dev mint the _quantity to the message.sender
1277   // @param _quantity is the quantity that will be minted
1278   function publicMint(uint256 _quantity) public payable inPublicSale {
1279       _mintNFT(msg.sender, _quantity, publicCost);
1280   }
1281 
1282   // @dev mint the _quantity to the message.sender for free
1283   // @param _quantity is the quantity that will be minted
1284   function publicFreeMint(uint256 _quantity) public payable inPublicSale {
1285       require(_quantity + _currentTokenId <= _maxFreeSupply, "Purchase exceeds available free supply.");
1286       _mintNFT(msg.sender, _quantity, 0);
1287   }
1288 
1289   // @dev show the correct URI for the token, using the _tokenId, shows the _projectHiddenURI if it's not on the public sale
1290   // @param _tokenId points to the id of the NFT in the Smart Contract
1291   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1292     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1293     if(!reveled)
1294       return _projectHiddenURI;
1295     return string(abi.encodePacked(_baseURI(), _tokenId.toString(), ".json"));
1296   }
1297 
1298   //@dev returns the information about the public sale
1299   function isPublicSale() public view returns(bool){
1300     return _projectStage == 2;
1301   }  
1302 
1303   // @dev returns the _maxFreeSupply.
1304   function maxFreeSupply() public pure returns(uint16) {
1305       return _maxFreeSupply;
1306   }
1307 
1308   //-------------------------------------------------------------------------
1309   // public only owner setter
1310   //-------------------------------------------------------------------------
1311   // @dev set a new _projectURI for the Smart Contract
1312   // @param projectURI_ the new URI
1313   function setProjectURI(string memory projectURI_) public onlyOwner {
1314     _projectURI = projectURI_;
1315   }
1316 
1317   // @dev set a new _projectHiddenURI for the Smart Contract
1318   // @param projectHiddenURI_ the new URI
1319   function setProjectHiddenURI(string memory projectHiddenURI_) public onlyOwner {
1320     _projectHiddenURI = projectHiddenURI_;
1321   }
1322 
1323   // @dev set a new _projectStage for the Smart Contract | Paused  = 0, Presale = 1, Public = 2. 
1324   // @param projectStage_ the new URI
1325   function setProjectStagePaused() public onlyOwner {
1326     _projectStage = 0;
1327   } 
1328 
1329   // @dev set a new _projectStage for the Smart Contract | Paused  = 0, Presale = 1, Public = 2. 
1330   // @param projectStage_ the new URI
1331   function setProjectStagePublic() public onlyOwner {
1332     _projectStage = 2;
1333   }
1334 
1335   // @dev set the reveled to false if it's true or to true if it's false.
1336   function setReveled() public onlyOwner {
1337       reveled = !reveled;
1338   }
1339     
1340   //-------------------------------------------------------------------------
1341   // public only admin
1342   //-------------------------------------------------------------------------    
1343   // @dev release all the funds in the smart contract for the team using the release function from PaymentSplitter
1344   function releaseFunds() external onlyAdmin {
1345     uint256 _balance = address(this).balance;
1346     for (uint256 i = 0; i < _payees.length; i++) {     
1347         (bool os, ) = payable(_payees[i]).call{value: _balance*_payeesShares[i]/100}("");
1348         require(os);
1349     }
1350   }
1351 }