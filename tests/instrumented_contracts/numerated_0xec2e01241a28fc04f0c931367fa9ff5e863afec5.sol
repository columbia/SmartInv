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
660 // File: contracts/ERC721/ERC721QD.sol
661 
662 
663 pragma solidity ^0.8.11;
664 
665 //------------------------------------------------------------------------------
666 //------------------------------------------------------------------------------
667 
668 //----------------------------------------------------------------------------
669 //----------------------------------------------------------------------------
670 
671 
672 
673 
674 
675 
676 
677 
678 /**
679  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721
680  *  [ERC721] Non-Fungible Token Standard
681  *
682  *  This implmentation of ERC721 needs a maximum number of NFTs to provide
683  *  efficient minting.  Storage for balance are no longer required reducing
684  *  gas significantly.  This comes at the price of calculating the balance by
685  *  iterating through the entire number of maximum NFTs, but enables the
686  *  possibility of creating sections of sequential mint.
687  */
688 contract ERC721QD is Context, ERC165, IERC721, IERC721Metadata {
689     using Address for address;
690     using Strings for uint256;
691 
692     //Max Supply
693     uint256 private _maxSupply;
694 
695     // Token name
696     string private _name;
697 
698     // Token symbol
699     string private _symbol;
700 
701     // Mapping from token ID to owner address
702     mapping(uint256 => address) internal _owners;
703 
704     // Mapping from token ID to approved address
705     mapping(uint256 => address) private _tokenApprovals;
706 
707     // Mapping from owner to operator approvals
708     mapping(address => mapping(address => bool)) private _operatorApprovals;
709 
710     /**
711      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
712      */
713     constructor(string memory name_, string memory symbol_, uint256 maxSupply_) {
714         _name = name_;
715         _symbol = symbol_;
716         _maxSupply = maxSupply_;
717     }
718 
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
723         return
724             interfaceId == type(IERC721).interfaceId ||
725             interfaceId == type(IERC721Metadata).interfaceId ||
726             super.supportsInterface(interfaceId);
727     }
728 
729     /**
730      * @dev See {IERC721-balanceOf}.
731      */
732     function balanceOf(address owner) public view virtual override returns (uint256 balance) {
733         require(owner != address(0), "ERC721: balance query for the zero address");
734         unchecked {
735             for (uint256 i = 0; i < _maxSupply; ++i) {
736                 if (_owners[i] == owner) {
737                     ++balance;
738                 }
739             }
740         }
741     }
742 
743     /**
744      * @dev See {IERC721-ownerOf}.
745      */
746     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
747         require(_exists(tokenId), "ERC721: owner query for nonexistent token");
748         address owner = _owners[tokenId];
749         return owner;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-name}.
754      */
755     function name() public view virtual override returns (string memory) {
756         return _name;
757     }
758 
759     /**
760      * @dev Returns the MaxSupply for the Smart Contract
761      */
762     function maxSupply() public view virtual returns (uint256) {
763         return _maxSupply;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-symbol}.
768      */
769     function symbol() public view virtual override returns (string memory) {
770         return _symbol;
771     }    
772 
773     /**
774      * @dev See {IERC721Metadata-tokenURI}.
775      */
776     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
777         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
778 
779         string memory baseURI = _baseURI();
780         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
781     }
782 
783     /**
784      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
785      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
786      * by default, can be overriden in child contracts.
787      */
788     function _baseURI() internal view virtual returns (string memory) {
789         return "";
790     }
791 
792     /**
793      * @dev See {IERC721-approve}.
794      */
795     function approve(address to, uint256 tokenId) public virtual override {
796         address owner = ERC721QD.ownerOf(tokenId);
797         require(to != owner, "ERC721: approval to current owner");
798 
799         require(
800             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
801             "ERC721: approve caller is not owner nor approved for all"
802         );
803 
804         _approve(to, tokenId);
805     }
806 
807     /**
808      * @dev See {IERC721-getApproved}.
809      */
810     function getApproved(uint256 tokenId) public view virtual override returns (address) {
811         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
812 
813         return _tokenApprovals[tokenId];
814     }
815 
816     /**
817      * @dev See {IERC721-setApprovalForAll}.
818      */
819     function setApprovalForAll(address operator, bool approved) public virtual override {
820         _setApprovalForAll(_msgSender(), operator, approved);
821     }
822 
823     /**
824      * @dev See {IERC721-isApprovedForAll}.
825      */
826     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
827         return _operatorApprovals[owner][operator];
828     }
829 
830     /**
831      * @dev See {IERC721-transferFrom}.
832      */
833     function transferFrom(
834         address from,
835         address to,
836         uint256 tokenId
837     ) public virtual override {
838         //solhint-disable-next-line max-line-length
839         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
840 
841         _transfer(from, to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-safeTransferFrom}.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         safeTransferFrom(from, to, tokenId, "");
853     }
854 
855     /**
856      * @dev See {IERC721-safeTransferFrom}.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes memory _data
863     ) public virtual override {
864         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
865         _safeTransfer(from, to, tokenId, _data);
866     }
867 
868     /**
869      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
870      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
871      *
872      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
873      *
874      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
875      * implement alternative mechanisms to perform token transfer, such as signature-based.
876      *
877      * Requirements:
878      *
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must exist and be owned by `from`.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _safeTransfer(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) internal virtual {
892         _transfer(from, to, tokenId);
893         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
894     }
895 
896     /**
897      * @dev Returns whether `tokenId` exists.
898      *
899      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
900      *
901      * Tokens start existing when they are minted (`_mint`),
902      * and stop existing when they are burned (`_burn`).
903      */
904     function _exists(uint256 tokenId) internal view virtual returns (bool) {
905         return tokenId < _maxSupply && _owners[tokenId] != address(0);
906     }
907 
908     /**
909      * @dev Returns whether `spender` is allowed to manage `tokenId`.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      */
915     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
916         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
917         address owner = ERC721QD.ownerOf(tokenId);
918         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
919     }
920 
921     /**
922      * @dev Safely mints `tokenId` and transfers it to `to`.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must not exist.
927      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _safeMint(address to, uint256 tokenId) internal virtual {
932         _safeMint(to, tokenId, "");
933     }
934 
935     /**
936      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
937      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
938      */
939     function _safeMint(
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) internal virtual {
944         _mint(to,tokenId);
945         require(
946             _checkOnERC721Received(address(0), to, tokenId, _data),
947             "ERC721: transfer to non ERC721Receiver implementer"
948         );
949     }
950 
951     /**
952      * @dev Mints `tokenId` and transfers it to `to`.
953      *
954      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
955      *
956      * Requirements:
957      *
958      * - `tokenId` must not exist.
959      * - `to` cannot be the zero address.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _mint(address to, uint256 tokenId) internal virtual{
964         require(to != address(0), "ERC721: mint to the zero address");
965         require(!_exists(tokenId), "ERC721: token already minted");
966 
967         _beforeTokenTransfer(address(0), to, tokenId);
968         _owners[tokenId] = to;
969 
970         emit Transfer(address(0), to, tokenId);
971     }
972 
973     /**
974      * @dev Destroys `tokenId`.
975      * The approval is cleared when the token is burned.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must exist.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _burn(uint256 tokenId) internal virtual {
984         address owner = ERC721QD.ownerOf(tokenId);
985 
986         _beforeTokenTransfer(owner, address(0), tokenId);
987 
988         // Clear approvals
989         _approve(address(0), tokenId);
990 
991         delete _owners[tokenId];
992 
993         emit Transfer(owner, address(0), tokenId);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
999      *
1000      * Requirements:
1001      *
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {
1012         require(ERC721QD.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1013         require(to != address(0), "ERC721: transfer to the zero address");
1014 
1015         _beforeTokenTransfer(from, to, tokenId);
1016 
1017         // Clear approvals from the previous owner
1018         _approve(address(0), tokenId);
1019 
1020         _owners[tokenId] = to;
1021 
1022         emit Transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Approve `to` to operate on `tokenId`
1027      *
1028      * Emits a {Approval} event.
1029      */
1030     function _approve(address to, uint256 tokenId) internal virtual {
1031         _tokenApprovals[tokenId] = to;
1032         emit Approval(ERC721QD.ownerOf(tokenId), to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Approve `operator` to operate on all of `owner` tokens
1037      *
1038      * Emits a {ApprovalForAll} event.
1039      */
1040     function _setApprovalForAll(
1041         address owner,
1042         address operator,
1043         bool approved
1044     ) internal virtual {
1045         require(owner != operator, "ERC721: approve to caller");
1046         _operatorApprovals[owner][operator] = approved;
1047         emit ApprovalForAll(owner, operator, approved);
1048     }
1049 
1050     /**
1051      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1052      * The call is not executed if the target address is not a contract.
1053      *
1054      * @param from address representing the previous owner of the given token ID
1055      * @param to target address that will receive the tokens
1056      * @param tokenId uint256 ID of the token to be transferred
1057      * @param _data bytes optional data to send along with the call
1058      * @return bool whether the call correctly returned the expected magic value
1059      */
1060     function _checkOnERC721Received(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) private returns (bool) {
1066         if (to.isContract()) {
1067             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1068                 return retval == IERC721Receiver.onERC721Received.selector;
1069             } catch (bytes memory reason) {
1070                 if (reason.length == 0) {
1071                     revert("ERC721: transfer to non ERC721Receiver implementer");
1072                 } else {
1073                     assembly {
1074                         revert(add(32, reason), mload(reason))
1075                     }
1076                 }
1077             }
1078         } else {
1079             return true;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any token transfer. This includes minting
1085      * and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1093      * - `from` and `to` are never both zero.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) internal virtual {}
1102 }
1103 // File: contracts/ERC721/ERC721QDPlus.sol
1104 
1105 
1106 pragma solidity ^0.8.11;
1107 
1108 //------------------------------------------------------------------------------
1109 //------------------------------------------------------------------------------
1110 
1111 /**
1112  * @dev This is a no storage implemntation of the optional extension {ERC721}
1113  * defined in the EIP that adds enumerability of all the token ids in the
1114  * contract as well as all token ids owned by each account. These functions
1115  * are mainly for convienence and should NEVER be called from inside a
1116  * contract on the chain. This implementation can't be used for projects 
1117  * with more than 5000 NFTs.
1118  */
1119 abstract contract ERC721QDPlus is ERC721QD {
1120     address constant zero = address(0);
1121 
1122     //track mint count for sequencial projects
1123     uint256 private _tottalSupply = 0; 
1124 
1125     /**
1126      * @dev See {IERC721Enumerable-totalSupply}.
1127      */
1128     function totalSupply()
1129         public
1130         view
1131         virtual
1132         returns (uint256)
1133     {
1134         return _tottalSupply;
1135     }
1136 
1137     function addTotalSupply (uint256 i)
1138         internal
1139     {
1140         _tottalSupply += i;
1141     }
1142 
1143     /**
1144      * @dev Destroys `tokenId`.
1145      * The approval is cleared when the token is burned.
1146      * The _tottalSupply is subtracted when the token is burned.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must exist.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _burn(uint256 tokenId) 
1155         internal 
1156         virtual  
1157         override
1158     {
1159         address owner = ERC721QD.ownerOf(tokenId);
1160 
1161         _beforeTokenTransfer(owner, address(0), tokenId);
1162 
1163         _approve(address(0), tokenId);
1164 
1165         delete _owners[tokenId];
1166 
1167         _tottalSupply--;
1168 
1169         emit Transfer(owner, address(0), tokenId);
1170     }
1171 
1172 }
1173 // File: contracts/0xapemfers.sol
1174 
1175 
1176 pragma solidity ^0.8.11;
1177 
1178 //------------------------------------------------------------------------------
1179 //------------------------------------------------------------------------------
1180 
1181 
1182 
1183 
1184 contract xApemfers is ERC721QDPlus, Ownable  {
1185   using Strings for uint256;
1186 
1187   //NFT cost
1188   uint128 constant public publicCost = 0.0069 ether;
1189 
1190   //erc721 metadata
1191   string constant private _name   = "0xapemfers";
1192   string constant private _symbol = "0xapemfers";
1193 
1194   //project max info
1195   uint16 constant private _maxSupply  = 8888;
1196   uint16 constant private _maxFreeSupply  = 4440;
1197   uint8  constant private _maxPerTnx  = 20; 
1198 
1199   //NFT stage Paused  = 0, Presale = 1, Public = 2. 
1200   uint8  private  _projectStage = 0;
1201   bool   public   reveled = false;
1202 
1203   //NFT URI
1204   string private _projectURI;
1205   string private _projectHiddenURI; 
1206   
1207   //payees shares for the project
1208   address[] private _payees;
1209   uint[] private _payeesShares;
1210 
1211   //Admin Addresses
1212   address[1] private _adminAddresses;  
1213 
1214   //track mint count for sequencial projects
1215   uint16 private _currentTokenId; 
1216 
1217   constructor(
1218     uint16 initialTokenId_,
1219     string memory projectURI_,
1220     address[] memory payees_,
1221     uint[] memory payeesShares_
1222    ) 
1223     ERC721QD(_name, _symbol, _maxSupply)
1224    {
1225     _projectURI = projectURI_;
1226     _payees = payees_;
1227     _payeesShares = payeesShares_;
1228     _currentTokenId = initialTokenId_ - 1;
1229     _adminAddresses = [msg.sender];
1230   }
1231 
1232   //-------------------------------------------------------------------------
1233   // modifiers
1234   //-------------------------------------------------------------------------
1235   modifier onlyAdmin() {
1236     require(isAdmin(), "caller not admin");
1237     _;
1238   }
1239 
1240   modifier inPublicSale() {
1241       require(_projectStage == 2, "contract is not on public sale");
1242       _;
1243   }   
1244 
1245   //-------------------------------------------------------------------------
1246   // internal
1247   //-------------------------------------------------------------------------
1248   function isAdmin() internal view returns(bool) {
1249     for(uint16 i = 0; i < _adminAddresses.length; i++){
1250       if(_adminAddresses[i] == msg.sender)
1251         return true;
1252     }
1253     return false;
1254   }
1255 
1256   function _baseURI() internal view virtual override returns (string memory) {
1257     return _projectURI;
1258   }
1259 
1260   //standart mint verification used by other functions
1261   function _mintNFT(address _to, uint256 _quantity, uint128 _price) private {
1262       require(_quantity <= _maxPerTnx, "Max per Tx exceeded.");
1263       require(_quantity * _price <= msg.value, "Insufficient funds.");
1264       require(_quantity + _currentTokenId <= _maxSupply,"Purchase exceeds available supply.");
1265       for (uint256 i = 0; i < _quantity; i++) {
1266           _currentTokenId++;
1267           _safeMint(_to, _currentTokenId);
1268       }
1269       addTotalSupply(_quantity);
1270   }    
1271 
1272   //-------------------------------------------------------------------------
1273   // public
1274   //-------------------------------------------------------------------------
1275   // @dev mint the _quantity to the message.sender
1276   // @param _quantity is the quantity that will be minted
1277   function publicMint(uint256 _quantity) public payable inPublicSale {
1278       _mintNFT(msg.sender, _quantity, publicCost);
1279   }
1280 
1281   // @dev mint the _quantity to the message.sender for free
1282   // @param _quantity is the quantity that will be minted
1283   function publicFreeMint(uint256 _quantity) public payable inPublicSale {
1284       require(_quantity + _currentTokenId <= _maxFreeSupply, "Purchase exceeds available free supply.");
1285       _mintNFT(msg.sender, _quantity, 0);
1286   }
1287 
1288   // @dev show the correct URI for the token, using the _tokenId, shows the _projectHiddenURI if it's not on the public sale
1289   // @param _tokenId points to the id of the NFT in the Smart Contract
1290   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1291     require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1292     if(!reveled)
1293       return _projectHiddenURI;
1294     return string(abi.encodePacked(_baseURI(), _tokenId.toString(), ".json"));
1295   }
1296 
1297   //@dev returns the information about the public sale
1298   function isPublicSale() public view returns(bool){
1299     return _projectStage == 2;
1300   }  
1301 
1302   // @dev returns the _maxFreeSupply.
1303   function maxFreeSupply() public pure returns(uint16) {
1304       return _maxFreeSupply;
1305   }
1306 
1307   //-------------------------------------------------------------------------
1308   // public only owner setter
1309   //-------------------------------------------------------------------------
1310   // @dev set a new _projectURI for the Smart Contract
1311   // @param projectURI_ the new URI
1312   function setProjectURI(string memory projectURI_) public onlyOwner {
1313     _projectURI = projectURI_;
1314   }
1315 
1316   // @dev set a new _projectHiddenURI for the Smart Contract
1317   // @param projectHiddenURI_ the new URI
1318   function setProjectHiddenURI(string memory projectHiddenURI_) public onlyOwner {
1319     _projectHiddenURI = projectHiddenURI_;
1320   }
1321 
1322   // @dev set a new _projectStage for the Smart Contract | Paused  = 0, Presale = 1, Public = 2. 
1323   // @param projectStage_ the new URI
1324   function setProjectStagePaused() public onlyOwner {
1325     _projectStage = 0;
1326   } 
1327 
1328   // @dev set a new _projectStage for the Smart Contract | Paused  = 0, Presale = 1, Public = 2. 
1329   // @param projectStage_ the new URI
1330   function setProjectStagePublic() public onlyOwner {
1331     _projectStage = 2;
1332   }
1333 
1334   // @dev set the reveled to false if it's true or to true if it's false.
1335   function setReveled() public onlyOwner {
1336       reveled = !reveled;
1337   }
1338     
1339   //-------------------------------------------------------------------------
1340   // public only admin
1341   //-------------------------------------------------------------------------    
1342   // @dev release all the funds in the smart contract for the team using the release function from PaymentSplitter
1343   function releaseFunds() external onlyAdmin {
1344     uint256 _balance = address(this).balance;
1345     for (uint256 i = 0; i < _payees.length; i++) {     
1346         (bool os, ) = payable(_payees[i]).call{value: _balance*_payeesShares[i]/100}("");
1347         require(os);
1348     }
1349   }
1350 }