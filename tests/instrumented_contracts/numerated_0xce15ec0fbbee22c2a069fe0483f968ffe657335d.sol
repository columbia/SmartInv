1 // SPDX-License-Identifier: MIT
2 // Creator: Chiru Labs
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _transferOwnership(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Internal function without access restriction.
166      */
167     function _transferOwnership(address newOwner) internal virtual {
168         address oldOwner = _owner;
169         _owner = newOwner;
170         emit OwnershipTransferred(oldOwner, newOwner);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Address.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Collection of functions related to the address type
183  */
184 library Address {
185     /**
186      * @dev Returns true if `account` is a contract.
187      *
188      * [IMPORTANT]
189      * ====
190      * It is unsafe to assume that an address for which this function returns
191      * false is an externally-owned account (EOA) and not a contract.
192      *
193      * Among others, `isContract` will return false for the following
194      * types of addresses:
195      *
196      *  - an externally-owned account
197      *  - a contract in construction
198      *  - an address where a contract will be created
199      *  - an address where a contract lived, but was destroyed
200      * ====
201      */
202     function isContract(address account) internal view returns (bool) {
203         // This method relies on extcodesize, which returns 0 for contracts in
204         // construction, since the code is only stored at the end of the
205         // constructor execution.
206 
207         uint256 size;
208         assembly {
209             size := extcodesize(account)
210         }
211         return size > 0;
212     }
213 
214     /**
215      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
216      * `recipient`, forwarding all available gas and reverting on errors.
217      *
218      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
219      * of certain opcodes, possibly making contracts go over the 2300 gas limit
220      * imposed by `transfer`, making them unable to receive funds via
221      * `transfer`. {sendValue} removes this limitation.
222      *
223      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
224      *
225      * IMPORTANT: because control is transferred to `recipient`, care must be
226      * taken to not create reentrancy vulnerabilities. Consider using
227      * {ReentrancyGuard} or the
228      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
229      */
230     function sendValue(address payable recipient, uint256 amount) internal {
231         require(address(this).balance >= amount, "Address: insufficient balance");
232 
233         (bool success, ) = recipient.call{value: amount}("");
234         require(success, "Address: unable to send value, recipient may have reverted");
235     }
236 
237     /**
238      * @dev Performs a Solidity function call using a low level `call`. A
239      * plain `call` is an unsafe replacement for a function call: use this
240      * function instead.
241      *
242      * If `target` reverts with a revert reason, it is bubbled up by this
243      * function (like regular Solidity function calls).
244      *
245      * Returns the raw returned data. To convert to the expected return value,
246      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
247      *
248      * Requirements:
249      *
250      * - `target` must be a contract.
251      * - calling `target` with `data` must not revert.
252      *
253      * _Available since v3.1._
254      */
255     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionCall(target, data, "Address: low-level call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
261      * `errorMessage` as a fallback revert reason when `target` reverts.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, 0, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but also transferring `value` wei to `target`.
276      *
277      * Requirements:
278      *
279      * - the calling contract must have an ETH balance of at least `value`.
280      * - the called Solidity function must be `payable`.
281      *
282      * _Available since v3.1._
283      */
284     function functionCallWithValue(
285         address target,
286         bytes memory data,
287         uint256 value
288     ) internal returns (bytes memory) {
289         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
294      * with `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCallWithValue(
299         address target,
300         bytes memory data,
301         uint256 value,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         require(address(this).balance >= value, "Address: insufficient balance for call");
305         require(isContract(target), "Address: call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.call{value: value}(data);
308         return verifyCallResult(success, returndata, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but performing a static call.
314      *
315      * _Available since v3.3._
316      */
317     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
318         return functionStaticCall(target, data, "Address: low-level static call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal view returns (bytes memory) {
332         require(isContract(target), "Address: static call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.staticcall(data);
335         return verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but performing a delegate call.
341      *
342      * _Available since v3.4._
343      */
344     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(isContract(target), "Address: delegate call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.delegatecall(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
367      * revert reason using the provided one.
368      *
369      * _Available since v4.3._
370      */
371     function verifyCallResult(
372         bool success,
373         bytes memory returndata,
374         string memory errorMessage
375     ) internal pure returns (bytes memory) {
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @title ERC721 token receiver interface
403  * @dev Interface for any contract that wants to support safeTransfers
404  * from ERC721 asset contracts.
405  */
406 interface IERC721Receiver {
407     /**
408      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
409      * by `operator` from `from`, this function is called.
410      *
411      * It must return its Solidity selector to confirm the token transfer.
412      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
413      *
414      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
415      */
416     function onERC721Received(
417         address operator,
418         address from,
419         uint256 tokenId,
420         bytes calldata data
421     ) external returns (bytes4);
422 }
423 
424 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
425 
426 
427 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @dev Interface of the ERC165 standard, as defined in the
433  * https://eips.ethereum.org/EIPS/eip-165[EIP].
434  *
435  * Implementers can declare support of contract interfaces, which can then be
436  * queried by others ({ERC165Checker}).
437  *
438  * For an implementation, see {ERC165}.
439  */
440 interface IERC165 {
441     /**
442      * @dev Returns true if this contract implements the interface defined by
443      * `interfaceId`. See the corresponding
444      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
445      * to learn more about how these ids are created.
446      *
447      * This function call must use less than 30 000 gas.
448      */
449     function supportsInterface(bytes4 interfaceId) external view returns (bool);
450 }
451 
452 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 
460 /**
461  * @dev Implementation of the {IERC165} interface.
462  *
463  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
464  * for the additional interface id that will be supported. For example:
465  *
466  * ```solidity
467  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
469  * }
470  * ```
471  *
472  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
473  */
474 abstract contract ERC165 is IERC165 {
475     /**
476      * @dev See {IERC165-supportsInterface}.
477      */
478     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479         return interfaceId == type(IERC165).interfaceId;
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 
491 /**
492  * @dev Required interface of an ERC721 compliant contract.
493  */
494 interface IERC721 is IERC165 {
495     /**
496      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
497      */
498     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
499 
500     /**
501      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
502      */
503     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
504 
505     /**
506      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
507      */
508     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
509 
510     /**
511      * @dev Returns the number of tokens in ``owner``'s account.
512      */
513     function balanceOf(address owner) external view returns (uint256 balance);
514 
515     /**
516      * @dev Returns the owner of the `tokenId` token.
517      *
518      * Requirements:
519      *
520      * - `tokenId` must exist.
521      */
522     function ownerOf(uint256 tokenId) external view returns (address owner);
523 
524     /**
525      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
526      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must exist and be owned by `from`.
533      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
534      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
535      *
536      * Emits a {Transfer} event.
537      */
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) external;
543 
544     /**
545      * @dev Transfers `tokenId` token from `from` to `to`.
546      *
547      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      *
556      * Emits a {Transfer} event.
557      */
558     function transferFrom(
559         address from,
560         address to,
561         uint256 tokenId
562     ) external;
563 
564     /**
565      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
566      * The approval is cleared when the token is transferred.
567      *
568      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
569      *
570      * Requirements:
571      *
572      * - The caller must own the token or be an approved operator.
573      * - `tokenId` must exist.
574      *
575      * Emits an {Approval} event.
576      */
577     function approve(address to, uint256 tokenId) external;
578 
579     /**
580      * @dev Returns the account approved for `tokenId` token.
581      *
582      * Requirements:
583      *
584      * - `tokenId` must exist.
585      */
586     function getApproved(uint256 tokenId) external view returns (address operator);
587 
588     /**
589      * @dev Approve or remove `operator` as an operator for the caller.
590      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
591      *
592      * Requirements:
593      *
594      * - The `operator` cannot be the caller.
595      *
596      * Emits an {ApprovalForAll} event.
597      */
598     function setApprovalForAll(address operator, bool _approved) external;
599 
600     /**
601      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
602      *
603      * See {setApprovalForAll}
604      */
605     function isApprovedForAll(address owner, address operator) external view returns (bool);
606 
607     /**
608      * @dev Safely transfers `tokenId` token from `from` to `to`.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must exist and be owned by `from`.
615      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId,
624         bytes calldata data
625     ) external;
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
629 
630 
631 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 /**
637  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
638  * @dev See https://eips.ethereum.org/EIPS/eip-721
639  */
640 interface IERC721Enumerable is IERC721 {
641     /**
642      * @dev Returns the total amount of tokens stored by the contract.
643      */
644     function totalSupply() external view returns (uint256);
645 
646     /**
647      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
648      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
649      */
650     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
651 
652     /**
653      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
654      * Use along with {totalSupply} to enumerate all tokens.
655      */
656     function tokenByIndex(uint256 index) external view returns (uint256);
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 
667 /**
668  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
669  * @dev See https://eips.ethereum.org/EIPS/eip-721
670  */
671 interface IERC721Metadata is IERC721 {
672     /**
673      * @dev Returns the token collection name.
674      */
675     function name() external view returns (string memory);
676 
677     /**
678      * @dev Returns the token collection symbol.
679      */
680     function symbol() external view returns (string memory);
681 
682     /**
683      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
684      */
685     function tokenURI(uint256 tokenId) external view returns (string memory);
686 }
687 
688 // File: contracts/LowerGas.sol
689 
690 
691 // Creator: Chiru Labs
692 
693 
694 pragma solidity ^0.8.0;
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
699  *
700  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
701  *
702  * Does not support burning tokens to address(0).
703  *
704  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
705  */
706 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
707     using Address for address;
708     using Strings for uint256;
709 
710     struct TokenOwnership {
711         address addr;
712         uint64 startTimestamp;
713     }
714 
715     struct AddressData {
716         uint128 balance;
717         uint128 numberMinted;
718     }
719 
720     uint256 internal currentIndex = 0;
721 
722     uint256 internal immutable maxBatchSize;
723 
724     // Token name
725     string private _name;
726 
727     // Token symbol
728     string private _symbol;
729 
730     // Mapping from token ID to ownership details
731     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
732     mapping(uint256 => TokenOwnership) internal _ownerships;
733 
734     // Mapping owner address to address data
735     mapping(address => AddressData) private _addressData;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     /**
744      * @dev
745      * `maxBatchSize` refers to how much a minter can mint at a time.
746      */
747     constructor(
748         string memory name_,
749         string memory symbol_,
750         uint256 maxBatchSize_
751     ) {
752         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
753         _name = name_;
754         _symbol = symbol_;
755         maxBatchSize = maxBatchSize_;
756     }
757 
758     /**
759      * @dev See {IERC721Enumerable-totalSupply}.
760      */
761     function totalSupply() public view override returns (uint256) {
762         return currentIndex;
763     }
764 
765     /**
766      * @dev See {IERC721Enumerable-tokenByIndex}.
767      */
768     function tokenByIndex(uint256 index) public view override returns (uint256) {
769         require(index < totalSupply(), 'ERC721A: global index out of bounds');
770         return index;
771     }
772 
773     /**
774      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
775      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
776      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
777      */
778     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
779         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
780         uint256 numMintedSoFar = totalSupply();
781         uint256 tokenIdsIdx = 0;
782         address currOwnershipAddr = address(0);
783         for (uint256 i = 0; i < numMintedSoFar; i++) {
784             TokenOwnership memory ownership = _ownerships[i];
785             if (ownership.addr != address(0)) {
786                 currOwnershipAddr = ownership.addr;
787             }
788             if (currOwnershipAddr == owner) {
789                 if (tokenIdsIdx == index) {
790                     return i;
791                 }
792                 tokenIdsIdx++;
793             }
794         }
795         revert('ERC721A: unable to get token of owner by index');
796     }
797 
798     /**
799      * @dev See {IERC165-supportsInterface}.
800      */
801     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
802         return
803             interfaceId == type(IERC721).interfaceId ||
804             interfaceId == type(IERC721Metadata).interfaceId ||
805             interfaceId == type(IERC721Enumerable).interfaceId ||
806             super.supportsInterface(interfaceId);
807     }
808 
809     /**
810      * @dev See {IERC721-balanceOf}.
811      */
812     function balanceOf(address owner) public view override returns (uint256) {
813         require(owner != address(0), 'ERC721A: balance query for the zero address');
814         return uint256(_addressData[owner].balance);
815     }
816 
817     function _numberMinted(address owner) internal view returns (uint256) {
818         require(owner != address(0), 'ERC721A: number minted query for the zero address');
819         return uint256(_addressData[owner].numberMinted);
820     }
821 
822     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
823         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
824 
825         uint256 lowestTokenToCheck;
826         if (tokenId >= maxBatchSize) {
827             lowestTokenToCheck = tokenId - maxBatchSize + 1;
828         }
829 
830         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
831             TokenOwnership memory ownership = _ownerships[curr];
832             if (ownership.addr != address(0)) {
833                 return ownership;
834             }
835         }
836 
837         revert('ERC721A: unable to determine the owner of token');
838     }
839 
840     /**
841      * @dev See {IERC721-ownerOf}.
842      */
843     function ownerOf(uint256 tokenId) public view override returns (address) {
844         return ownershipOf(tokenId).addr;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-name}.
849      */
850     function name() public view virtual override returns (string memory) {
851         return _name;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-symbol}.
856      */
857     function symbol() public view virtual override returns (string memory) {
858         return _symbol;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-tokenURI}.
863      */
864     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
865         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
866 
867         string memory baseURI = _baseURI();
868         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
869     }
870 
871     /**
872      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
873      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
874      * by default, can be overriden in child contracts.
875      */
876     function _baseURI() internal view virtual returns (string memory) {
877         return '';
878     }
879 
880     /**
881      * @dev See {IERC721-approve}.
882      */
883     function approve(address to, uint256 tokenId) public override {
884         address owner = ERC721A.ownerOf(tokenId);
885         require(to != owner, 'ERC721A: approval to current owner');
886 
887         require(
888             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
889             'ERC721A: approve caller is not owner nor approved for all'
890         );
891 
892         _approve(to, tokenId, owner);
893     }
894 
895     /**
896      * @dev See {IERC721-getApproved}.
897      */
898     function getApproved(uint256 tokenId) public view override returns (address) {
899         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
900 
901         return _tokenApprovals[tokenId];
902     }
903 
904     /**
905      * @dev See {IERC721-setApprovalForAll}.
906      */
907     function setApprovalForAll(address operator, bool approved) public override {
908         require(operator != _msgSender(), 'ERC721A: approve to caller');
909 
910         _operatorApprovals[_msgSender()][operator] = approved;
911         emit ApprovalForAll(_msgSender(), operator, approved);
912     }
913 
914     /**
915      * @dev See {IERC721-isApprovedForAll}.
916      */
917     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
918         return _operatorApprovals[owner][operator];
919     }
920 
921     /**
922      * @dev See {IERC721-transferFrom}.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public override {
929         _transfer(from, to, tokenId);
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public override {
940         safeTransferFrom(from, to, tokenId, '');
941     }
942 
943     /**
944      * @dev See {IERC721-safeTransferFrom}.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) public override {
952         _transfer(from, to, tokenId);
953         require(
954             _checkOnERC721Received(from, to, tokenId, _data),
955             'ERC721A: transfer to non ERC721Receiver implementer'
956         );
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      */
966     function _exists(uint256 tokenId) internal view returns (bool) {
967         return tokenId < currentIndex;
968     }
969 
970     function _safeMint(address to, uint256 quantity) internal {
971         _safeMint(to, quantity, '');
972     }
973 
974     /**
975      * @dev Mints `quantity` tokens and transfers them to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `quantity` cannot be larger than the max batch size.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _safeMint(
985         address to,
986         uint256 quantity,
987         bytes memory _data
988     ) internal {
989         uint256 startTokenId = currentIndex;
990         require(to != address(0), 'ERC721A: mint to the zero address');
991         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
992         require(!_exists(startTokenId), 'ERC721A: token already minted');
993         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
994         require(quantity > 0, 'ERC721A: quantity must be greater 0');
995 
996         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
997 
998         AddressData memory addressData = _addressData[to];
999         _addressData[to] = AddressData(
1000             addressData.balance + uint128(quantity),
1001             addressData.numberMinted + uint128(quantity)
1002         );
1003         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1004 
1005         uint256 updatedIndex = startTokenId;
1006 
1007         for (uint256 i = 0; i < quantity; i++) {
1008             emit Transfer(address(0), to, updatedIndex);
1009             require(
1010                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1011                 'ERC721A: transfer to non ERC721Receiver implementer'
1012             );
1013             updatedIndex++;
1014         }
1015 
1016         currentIndex = updatedIndex;
1017         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) private {
1035         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1036 
1037         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1038             getApproved(tokenId) == _msgSender() ||
1039             isApprovedForAll(prevOwnership.addr, _msgSender()));
1040 
1041         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1042 
1043         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1044         require(to != address(0), 'ERC721A: transfer to the zero address');
1045 
1046         _beforeTokenTransfers(from, to, tokenId, 1);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId, prevOwnership.addr);
1050 
1051         // Underflow of the sender's balance is impossible because we check for
1052         // ownership above and the recipient's balance can't realistically overflow.
1053         unchecked {
1054             _addressData[from].balance -= 1;
1055             _addressData[to].balance += 1;
1056         }
1057 
1058         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1059 
1060         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1061         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1062         uint256 nextTokenId = tokenId + 1;
1063         if (_ownerships[nextTokenId].addr == address(0)) {
1064             if (_exists(nextTokenId)) {
1065                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1066             }
1067         }
1068 
1069         emit Transfer(from, to, tokenId);
1070         _afterTokenTransfers(from, to, tokenId, 1);
1071     }
1072 
1073     /**
1074      * @dev Approve `to` to operate on `tokenId`
1075      *
1076      * Emits a {Approval} event.
1077      */
1078     function _approve(
1079         address to,
1080         uint256 tokenId,
1081         address owner
1082     ) private {
1083         _tokenApprovals[tokenId] = to;
1084         emit Approval(owner, to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1089      * The call is not executed if the target address is not a contract.
1090      *
1091      * @param from address representing the previous owner of the given token ID
1092      * @param to target address that will receive the tokens
1093      * @param tokenId uint256 ID of the token to be transferred
1094      * @param _data bytes optional data to send along with the call
1095      * @return bool whether the call correctly returned the expected magic value
1096      */
1097     function _checkOnERC721Received(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) private returns (bool) {
1103         if (to.isContract()) {
1104             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1105                 return retval == IERC721Receiver(to).onERC721Received.selector;
1106             } catch (bytes memory reason) {
1107                 if (reason.length == 0) {
1108                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1109                 } else {
1110                     assembly {
1111                         revert(add(32, reason), mload(reason))
1112                     }
1113                 }
1114             }
1115         } else {
1116             return true;
1117         }
1118     }
1119 
1120     /**
1121      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1122      *
1123      * startTokenId - the first token id to be transferred
1124      * quantity - the amount to be transferred
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      */
1132     function _beforeTokenTransfers(
1133         address from,
1134         address to,
1135         uint256 startTokenId,
1136         uint256 quantity
1137     ) internal virtual {}
1138 
1139     /**
1140      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1141      * minting.
1142      *
1143      * startTokenId - the first token id to be transferred
1144      * quantity - the amount to be transferred
1145      *
1146      * Calling conditions:
1147      *
1148      * - when `from` and `to` are both non-zero.
1149      * - `from` and `to` are never both zero.
1150      */
1151     function _afterTokenTransfers(
1152         address from,
1153         address to,
1154         uint256 startTokenId,
1155         uint256 quantity
1156     ) internal virtual {}
1157 }
1158 
1159 pragma solidity ^0.8.13;
1160 
1161 contract FireMoonBirds is ERC721A, Ownable {
1162   using Strings for uint256;
1163   
1164   uint256 public mintPrice = 0.019 ether;
1165 
1166   uint256 public package1Qty = 5;
1167   uint256 public package1Price = 0.049 ether;
1168   uint256 public package2Qty = 10;
1169   uint256 public package2Price = 0.089 ether;
1170   uint256 public package3Qty = 10;
1171   uint256 public package3Price = 0.95 ether;
1172 
1173   uint256 public maxSupply = 4888;
1174   uint256 public maxFreeMint = 4888;
1175   uint256 public freeMintPerWallet = 3;
1176   string public baseTokenURI = "";
1177   string public hiddenURI = "https://gateway.pinata.cloud/ipfs/QmPqCg4cQDwZ6avxpXSG7sV1X3c6vqjqSvNL1AADS8oq4h";
1178 
1179   bool public openMint = false;
1180   bool public revealed = false;
1181 
1182   bool public onFreeMint = true;
1183   bool public onPackageSale = true;
1184   bool public on1Free1 = true;
1185 
1186   mapping(address => uint256) public addressMintedBalance;
1187 
1188   constructor() ERC721A("Fire Moon Birds", "firemoonbirds", 100) {  }
1189 
1190   function mintPackage(uint256 _packageNumber) external payable {
1191     require(openMint, "The contract is not open to mint yet!");
1192     require(onPackageSale, "Invalid Mint, Packgage promotion has ended!");
1193 
1194     uint256 _mintAmount = 0;
1195     uint256 _packagePrice = mintPrice;
1196     if(_packageNumber == 1) {
1197         _mintAmount = package1Qty;
1198         _packagePrice = package1Price;
1199     }
1200     else if(_packageNumber == 2) {
1201         _mintAmount = package2Qty;
1202         _packagePrice = package2Price;
1203     }
1204     else if(_packageNumber == 3) {
1205         _mintAmount = package3Qty;
1206         _packagePrice = package3Price;
1207     }
1208 
1209     require(_mintAmount > 0, "Nothing to mint!");
1210     require(msg.value >= _packagePrice, "Insufficient funds!");
1211     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1212 
1213     _safeMint(msg.sender, _mintAmount);
1214   }
1215 
1216   function mintFree() external payable {
1217     require(openMint, "The contract is not open to mint yet!");
1218     require(onFreeMint, "The contract is not open for free mint");
1219     require(balanceOf(_msgSender()) < freeMintPerWallet, "Max free mint per wallet exceeded!");
1220     require(currentIndex + freeMintPerWallet <= maxFreeMint, "Max free mint exceeded!");
1221     require(currentIndex + freeMintPerWallet <= maxSupply, "Max supply exceeded!");
1222 
1223     _safeMint(msg.sender, freeMintPerWallet);
1224   }
1225 
1226   function mint(uint256 _mintAmount) external payable {
1227     require(openMint, "The contract is not open to mint yet!");
1228     require(msg.value >= mintPrice * _mintAmount, "Insufficient funds!");
1229 
1230     if(on1Free1){
1231         _mintAmount = _mintAmount * 2;
1232     }
1233     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1234 
1235     _safeMint(msg.sender, _mintAmount);
1236   }
1237   
1238   function mintBatch(address _to, uint256 _mintAmount) public onlyOwner {
1239     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1240     _safeMint(_to, _mintAmount);
1241   }
1242 
1243   function tokenURI(uint256 _tokenId)
1244     public
1245     view
1246     virtual
1247     override
1248     returns (string memory)
1249   {
1250     require(
1251       _exists(_tokenId),
1252       "ERC721Metadata: URI query for nonexistent token"
1253     );
1254 
1255     if (revealed == false) {
1256       return hiddenURI;
1257     }
1258 
1259     return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId), ".json"));
1260   }
1261 
1262   function withdraw() external onlyOwner {
1263     payable(owner()).transfer(address(this).balance);
1264   }
1265 
1266   function setPackage(uint256 _packageNumber, uint256 _packagePrice, uint256 _packageQty) external onlyOwner {
1267     if(_packageNumber == 1){
1268         package1Qty = _packageQty;
1269         package1Price = _packagePrice;
1270     }
1271     else if(_packageNumber == 2){
1272         package2Qty = _packageQty;
1273         package2Price = _packagePrice;
1274     }
1275     else if(_packageNumber == 3){
1276         package3Qty = _packageQty;
1277         package3Price = _packagePrice;
1278     }
1279   }
1280 
1281   function setMaxFreeMint(uint256 _maxFreeMint) public onlyOwner {
1282     maxFreeMint = _maxFreeMint;
1283   }
1284 
1285   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1286     maxSupply = _maxSupply;
1287   }
1288 
1289   function setFreeMintPerWallet(uint256 _freeMintPerWallet) public onlyOwner {
1290     freeMintPerWallet = _freeMintPerWallet;
1291   }
1292 
1293   function setBaseUri(string memory _uri) external onlyOwner {
1294     baseTokenURI = _uri;
1295   }
1296 
1297   function setOn1Free1(bool _state) public onlyOwner {
1298     on1Free1 = _state;
1299   }
1300 
1301   function setOnPackageSale(bool _state) public onlyOwner {
1302     onPackageSale = _state;
1303   }
1304 
1305   function setFreeMint(bool _state) public onlyOwner {
1306     onFreeMint = _state;
1307   }
1308   function setOpenMint(bool _state) public onlyOwner {
1309     openMint = _state;
1310   }
1311 
1312   function setRevealed(bool _state) public onlyOwner {
1313     revealed = _state;
1314   }
1315 
1316   function setPrice(uint256 _price) public onlyOwner {
1317     mintPrice = _price;
1318   }
1319 
1320 }