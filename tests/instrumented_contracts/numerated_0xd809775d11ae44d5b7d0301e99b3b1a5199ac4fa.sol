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
179 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
180 
181 pragma solidity ^0.8.0;
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
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         assembly {
211             size := extcodesize(account)
212         }
213         return size > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         (bool success, ) = recipient.call{value: amount}("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
296      * with `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
320         return functionStaticCall(target, data, "Address: low-level static call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         require(isContract(target), "Address: static call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(isContract(target), "Address: delegate call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
369      * revert reason using the provided one.
370      *
371      * _Available since v4.3._
372      */
373     function verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) internal pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @title ERC721 token receiver interface
405  * @dev Interface for any contract that wants to support safeTransfers
406  * from ERC721 asset contracts.
407  */
408 interface IERC721Receiver {
409     /**
410      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
411      * by `operator` from `from`, this function is called.
412      *
413      * It must return its Solidity selector to confirm the token transfer.
414      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
415      *
416      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
417      */
418     function onERC721Received(
419         address operator,
420         address from,
421         uint256 tokenId,
422         bytes calldata data
423     ) external returns (bytes4);
424 }
425 
426 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev Interface of the ERC165 standard, as defined in the
435  * https://eips.ethereum.org/EIPS/eip-165[EIP].
436  *
437  * Implementers can declare support of contract interfaces, which can then be
438  * queried by others ({ERC165Checker}).
439  *
440  * For an implementation, see {ERC165}.
441  */
442 interface IERC165 {
443     /**
444      * @dev Returns true if this contract implements the interface defined by
445      * `interfaceId`. See the corresponding
446      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
447      * to learn more about how these ids are created.
448      *
449      * This function call must use less than 30 000 gas.
450      */
451     function supportsInterface(bytes4 interfaceId) external view returns (bool);
452 }
453 
454 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Implementation of the {IERC165} interface.
464  *
465  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
466  * for the additional interface id that will be supported. For example:
467  *
468  * ```solidity
469  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
471  * }
472  * ```
473  *
474  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
475  */
476 abstract contract ERC165 is IERC165 {
477     /**
478      * @dev See {IERC165-supportsInterface}.
479      */
480     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481         return interfaceId == type(IERC165).interfaceId;
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @dev Required interface of an ERC721 compliant contract.
495  */
496 interface IERC721 is IERC165 {
497     /**
498      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
499      */
500     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
501 
502     /**
503      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
504      */
505     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
509      */
510     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
511 
512     /**
513      * @dev Returns the number of tokens in ``owner``'s account.
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516 
517     /**
518      * @dev Returns the owner of the `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function ownerOf(uint256 tokenId) external view returns (address owner);
525 
526     /**
527      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
528      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must exist and be owned by `from`.
535      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
536      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
537      *
538      * Emits a {Transfer} event.
539      */
540     function safeTransferFrom(
541         address from,
542         address to,
543         uint256 tokenId
544     ) external;
545 
546     /**
547      * @dev Transfers `tokenId` token from `from` to `to`.
548      *
549      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      *
558      * Emits a {Transfer} event.
559      */
560     function transferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) external;
565 
566     /**
567      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
568      * The approval is cleared when the token is transferred.
569      *
570      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
571      *
572      * Requirements:
573      *
574      * - The caller must own the token or be an approved operator.
575      * - `tokenId` must exist.
576      *
577      * Emits an {Approval} event.
578      */
579     function approve(address to, uint256 tokenId) external;
580 
581     /**
582      * @dev Returns the account approved for `tokenId` token.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function getApproved(uint256 tokenId) external view returns (address operator);
589 
590     /**
591      * @dev Approve or remove `operator` as an operator for the caller.
592      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
593      *
594      * Requirements:
595      *
596      * - The `operator` cannot be the caller.
597      *
598      * Emits an {ApprovalForAll} event.
599      */
600     function setApprovalForAll(address operator, bool _approved) external;
601 
602     /**
603      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
604      *
605      * See {setApprovalForAll}
606      */
607     function isApprovedForAll(address owner, address operator) external view returns (bool);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes calldata data
627     ) external;
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
640  * @dev See https://eips.ethereum.org/EIPS/eip-721
641  */
642 interface IERC721Enumerable is IERC721 {
643     /**
644      * @dev Returns the total amount of tokens stored by the contract.
645      */
646     function totalSupply() external view returns (uint256);
647 
648     /**
649      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
650      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
651      */
652     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
653 
654     /**
655      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
656      * Use along with {totalSupply} to enumerate all tokens.
657      */
658     function tokenByIndex(uint256 index) external view returns (uint256);
659 }
660 
661 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 
669 /**
670  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
671  * @dev See https://eips.ethereum.org/EIPS/eip-721
672  */
673 interface IERC721Metadata is IERC721 {
674     /**
675      * @dev Returns the token collection name.
676      */
677     function name() external view returns (string memory);
678 
679     /**
680      * @dev Returns the token collection symbol.
681      */
682     function symbol() external view returns (string memory);
683 
684     /**
685      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
686      */
687     function tokenURI(uint256 tokenId) external view returns (string memory);
688 }
689 
690 // File: erc721a/contracts/ERC721A.sol
691 
692 
693 // Creator: Chiru Labs
694 
695 pragma solidity ^0.8.4;
696 
697 
698 
699 
700 
701 
702 
703 
704 
705 error ApprovalCallerNotOwnerNorApproved();
706 error ApprovalQueryForNonexistentToken();
707 error ApproveToCaller();
708 error ApprovalToCurrentOwner();
709 error BalanceQueryForZeroAddress();
710 error MintedQueryForZeroAddress();
711 error BurnedQueryForZeroAddress();
712 error AuxQueryForZeroAddress();
713 error MintToZeroAddress();
714 error MintZeroQuantity();
715 error OwnerIndexOutOfBounds();
716 error OwnerQueryForNonexistentToken();
717 error TokenIndexOutOfBounds();
718 error TransferCallerNotOwnerNorApproved();
719 error TransferFromIncorrectOwner();
720 error TransferToNonERC721ReceiverImplementer();
721 error TransferToZeroAddress();
722 error URIQueryForNonexistentToken();
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension. Built to optimize for lower gas during batch mints.
727  *
728  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
729  *
730  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
731  *
732  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
733  */
734 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     // Compiler will pack this into a single 256bit word.
739     struct TokenOwnership {
740         // The address of the owner.
741         address addr;
742         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
743         uint64 startTimestamp;
744         // Whether the token has been burned.
745         bool burned;
746     }
747 
748     // Compiler will pack this into a single 256bit word.
749     struct AddressData {
750         // Realistically, 2**64-1 is more than enough.
751         uint64 balance;
752         // Keeps track of mint count with minimal overhead for tokenomics.
753         uint64 numberMinted;
754         // Keeps track of burn count with minimal overhead for tokenomics.
755         uint64 numberBurned;
756         // For miscellaneous variable(s) pertaining to the address
757         // (e.g. number of whitelist mint slots used).
758         // If there are multiple variables, please pack them into a uint64.
759         uint64 aux;
760     }
761 
762     // The tokenId of the next token to be minted.
763     uint256 internal _currentIndex;
764 
765     // The number of tokens burned.
766     uint256 internal _burnCounter;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
776     mapping(uint256 => TokenOwnership) internal _ownerships;
777 
778     // Mapping owner address to address data
779     mapping(address => AddressData) private _addressData;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     constructor(string memory name_, string memory symbol_) {
788         _name = name_;
789         _symbol = symbol_;
790         _currentIndex = _startTokenId();
791     }
792 
793     /**
794      * To change the starting tokenId, please override this function.
795      */
796     function _startTokenId() internal view virtual returns (uint256) {
797         return 0;
798     }
799 
800     /**
801      * @dev See {IERC721Enumerable-totalSupply}.
802      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
803      */
804     function totalSupply() public view returns (uint256) {
805         // Counter underflow is impossible as _burnCounter cannot be incremented
806         // more than _currentIndex - _startTokenId() times
807         unchecked {
808             return _currentIndex - _burnCounter - _startTokenId();
809         }
810     }
811 
812     /**
813      * Returns the total amount of tokens minted in the contract.
814      */
815     function _totalMinted() internal view returns (uint256) {
816         // Counter underflow is impossible as _currentIndex does not decrement,
817         // and it is initialized to _startTokenId()
818         unchecked {
819             return _currentIndex - _startTokenId();
820         }
821     }
822 
823     /**
824      * @dev See {IERC165-supportsInterface}.
825      */
826     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
827         return
828             interfaceId == type(IERC721).interfaceId ||
829             interfaceId == type(IERC721Metadata).interfaceId ||
830             super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @dev See {IERC721-balanceOf}.
835      */
836     function balanceOf(address owner) public view override returns (uint256) {
837         if (owner == address(0)) revert BalanceQueryForZeroAddress();
838         return uint256(_addressData[owner].balance);
839     }
840 
841     /**
842      * Returns the number of tokens minted by `owner`.
843      */
844     function _numberMinted(address owner) internal view returns (uint256) {
845         if (owner == address(0)) revert MintedQueryForZeroAddress();
846         return uint256(_addressData[owner].numberMinted);
847     }
848 
849     /**
850      * Returns the number of tokens burned by or on behalf of `owner`.
851      */
852     function _numberBurned(address owner) internal view returns (uint256) {
853         if (owner == address(0)) revert BurnedQueryForZeroAddress();
854         return uint256(_addressData[owner].numberBurned);
855     }
856 
857     /**
858      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
859      */
860     function _getAux(address owner) internal view returns (uint64) {
861         if (owner == address(0)) revert AuxQueryForZeroAddress();
862         return _addressData[owner].aux;
863     }
864 
865     /**
866      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
867      * If there are multiple variables, please pack them into a uint64.
868      */
869     function _setAux(address owner, uint64 aux) internal {
870         if (owner == address(0)) revert AuxQueryForZeroAddress();
871         _addressData[owner].aux = aux;
872     }
873 
874     /**
875      * Gas spent here starts off proportional to the maximum mint batch size.
876      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
877      */
878     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
879         uint256 curr = tokenId;
880 
881         unchecked {
882             if (_startTokenId() <= curr && curr < _currentIndex) {
883                 TokenOwnership memory ownership = _ownerships[curr];
884                 if (!ownership.burned) {
885                     if (ownership.addr != address(0)) {
886                         return ownership;
887                     }
888                     // Invariant:
889                     // There will always be an ownership that has an address and is not burned
890                     // before an ownership that does not have an address and is not burned.
891                     // Hence, curr will not underflow.
892                     while (true) {
893                         curr--;
894                         ownership = _ownerships[curr];
895                         if (ownership.addr != address(0)) {
896                             return ownership;
897                         }
898                     }
899                 }
900             }
901         }
902         revert OwnerQueryForNonexistentToken();
903     }
904 
905     /**
906      * @dev See {IERC721-ownerOf}.
907      */
908     function ownerOf(uint256 tokenId) public view override returns (address) {
909         return ownershipOf(tokenId).addr;
910     }
911 
912     /**
913      * @dev See {IERC721Metadata-name}.
914      */
915     function name() public view virtual override returns (string memory) {
916         return _name;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-symbol}.
921      */
922     function symbol() public view virtual override returns (string memory) {
923         return _symbol;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-tokenURI}.
928      */
929     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
930         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
931 
932         string memory baseURI = _baseURI();
933         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
934     }
935 
936     /**
937      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
938      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
939      * by default, can be overriden in child contracts.
940      */
941     function _baseURI() internal view virtual returns (string memory) {
942         return '';
943     }
944 
945     /**
946      * @dev See {IERC721-approve}.
947      */
948     function approve(address to, uint256 tokenId) public override {
949         address owner = ERC721A.ownerOf(tokenId);
950         if (to == owner) revert ApprovalToCurrentOwner();
951 
952         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
953             revert ApprovalCallerNotOwnerNorApproved();
954         }
955 
956         _approve(to, tokenId, owner);
957     }
958 
959     /**
960      * @dev See {IERC721-getApproved}.
961      */
962     function getApproved(uint256 tokenId) public view override returns (address) {
963         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
964 
965         return _tokenApprovals[tokenId];
966     }
967 
968     /**
969      * @dev See {IERC721-setApprovalForAll}.
970      */
971     function setApprovalForAll(address operator, bool approved) public override {
972         if (operator == _msgSender()) revert ApproveToCaller();
973 
974         _operatorApprovals[_msgSender()][operator] = approved;
975         emit ApprovalForAll(_msgSender(), operator, approved);
976     }
977 
978     /**
979      * @dev See {IERC721-isApprovedForAll}.
980      */
981     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
982         return _operatorApprovals[owner][operator];
983     }
984 
985     /**
986      * @dev See {IERC721-transferFrom}.
987      */
988     function transferFrom(
989         address from,
990         address to,
991         uint256 tokenId
992     ) public virtual override {
993         _transfer(from, to, tokenId);
994     }
995 
996     /**
997      * @dev See {IERC721-safeTransferFrom}.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) public virtual override {
1004         safeTransferFrom(from, to, tokenId, '');
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-safeTransferFrom}.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId,
1014         bytes memory _data
1015     ) public virtual override {
1016         _transfer(from, to, tokenId);
1017         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1018             revert TransferToNonERC721ReceiverImplementer();
1019         }
1020     }
1021 
1022     /**
1023      * @dev Returns whether `tokenId` exists.
1024      *
1025      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1026      *
1027      * Tokens start existing when they are minted (`_mint`),
1028      */
1029     function _exists(uint256 tokenId) internal view returns (bool) {
1030         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1031             !_ownerships[tokenId].burned;
1032     }
1033 
1034     function _safeMint(address to, uint256 quantity) internal {
1035         _safeMint(to, quantity, '');
1036     }
1037 
1038     /**
1039      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1040      *
1041      * Requirements:
1042      *
1043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1044      * - `quantity` must be greater than 0.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _safeMint(
1049         address to,
1050         uint256 quantity,
1051         bytes memory _data
1052     ) internal {
1053         _mint(to, quantity, _data, true);
1054     }
1055 
1056     /**
1057      * @dev Mints `quantity` tokens and transfers them to `to`.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `quantity` must be greater than 0.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _mint(
1067         address to,
1068         uint256 quantity,
1069         bytes memory _data,
1070         bool safe
1071     ) internal {
1072         uint256 startTokenId = _currentIndex;
1073         if (to == address(0)) revert MintToZeroAddress();
1074         if (quantity == 0) revert MintZeroQuantity();
1075 
1076         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1077 
1078         // Overflows are incredibly unrealistic.
1079         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1080         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1081         unchecked {
1082             _addressData[to].balance += uint64(quantity);
1083             _addressData[to].numberMinted += uint64(quantity);
1084 
1085             _ownerships[startTokenId].addr = to;
1086             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1087 
1088             uint256 updatedIndex = startTokenId;
1089             uint256 end = updatedIndex + quantity;
1090 
1091             if (safe && to.isContract()) {
1092                 do {
1093                     emit Transfer(address(0), to, updatedIndex);
1094                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1095                         revert TransferToNonERC721ReceiverImplementer();
1096                     }
1097                 } while (updatedIndex != end);
1098                 // Reentrancy protection
1099                 if (_currentIndex != startTokenId) revert();
1100             } else {
1101                 do {
1102                     emit Transfer(address(0), to, updatedIndex++);
1103                 } while (updatedIndex != end);
1104             }
1105             _currentIndex = updatedIndex;
1106         }
1107         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1108     }
1109 
1110     /**
1111      * @dev Transfers `tokenId` from `from` to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must be owned by `from`.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _transfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) private {
1125         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1126 
1127         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1128             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1129             getApproved(tokenId) == _msgSender());
1130 
1131         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1132         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1133         if (to == address(0)) revert TransferToZeroAddress();
1134 
1135         _beforeTokenTransfers(from, to, tokenId, 1);
1136 
1137         // Clear approvals from the previous owner
1138         _approve(address(0), tokenId, prevOwnership.addr);
1139 
1140         // Underflow of the sender's balance is impossible because we check for
1141         // ownership above and the recipient's balance can't realistically overflow.
1142         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1143         unchecked {
1144             _addressData[from].balance -= 1;
1145             _addressData[to].balance += 1;
1146 
1147             _ownerships[tokenId].addr = to;
1148             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1149 
1150             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1151             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1152             uint256 nextTokenId = tokenId + 1;
1153             if (_ownerships[nextTokenId].addr == address(0)) {
1154                 // This will suffice for checking _exists(nextTokenId),
1155                 // as a burned slot cannot contain the zero address.
1156                 if (nextTokenId < _currentIndex) {
1157                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1158                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, to, tokenId);
1164         _afterTokenTransfers(from, to, tokenId, 1);
1165     }
1166 
1167     /**
1168      * @dev Destroys `tokenId`.
1169      * The approval is cleared when the token is burned.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _burn(uint256 tokenId) internal virtual {
1178         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1179 
1180         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1181 
1182         // Clear approvals from the previous owner
1183         _approve(address(0), tokenId, prevOwnership.addr);
1184 
1185         // Underflow of the sender's balance is impossible because we check for
1186         // ownership above and the recipient's balance can't realistically overflow.
1187         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1188         unchecked {
1189             _addressData[prevOwnership.addr].balance -= 1;
1190             _addressData[prevOwnership.addr].numberBurned += 1;
1191 
1192             // Keep track of who burned the token, and the timestamp of burning.
1193             _ownerships[tokenId].addr = prevOwnership.addr;
1194             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1195             _ownerships[tokenId].burned = true;
1196 
1197             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1198             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1199             uint256 nextTokenId = tokenId + 1;
1200             if (_ownerships[nextTokenId].addr == address(0)) {
1201                 // This will suffice for checking _exists(nextTokenId),
1202                 // as a burned slot cannot contain the zero address.
1203                 if (nextTokenId < _currentIndex) {
1204                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1205                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1206                 }
1207             }
1208         }
1209 
1210         emit Transfer(prevOwnership.addr, address(0), tokenId);
1211         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1212 
1213         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1214         unchecked {
1215             _burnCounter++;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Approve `to` to operate on `tokenId`
1221      *
1222      * Emits a {Approval} event.
1223      */
1224     function _approve(
1225         address to,
1226         uint256 tokenId,
1227         address owner
1228     ) private {
1229         _tokenApprovals[tokenId] = to;
1230         emit Approval(owner, to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1235      *
1236      * @param from address representing the previous owner of the given token ID
1237      * @param to target address that will receive the tokens
1238      * @param tokenId uint256 ID of the token to be transferred
1239      * @param _data bytes optional data to send along with the call
1240      * @return bool whether the call correctly returned the expected magic value
1241      */
1242     function _checkContractOnERC721Received(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) private returns (bool) {
1248         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1249             return retval == IERC721Receiver(to).onERC721Received.selector;
1250         } catch (bytes memory reason) {
1251             if (reason.length == 0) {
1252                 revert TransferToNonERC721ReceiverImplementer();
1253             } else {
1254                 assembly {
1255                     revert(add(32, reason), mload(reason))
1256                 }
1257             }
1258         }
1259     }
1260 
1261     /**
1262      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1263      * And also called before burning one token.
1264      *
1265      * startTokenId - the first token id to be transferred
1266      * quantity - the amount to be transferred
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` will be minted for `to`.
1273      * - When `to` is zero, `tokenId` will be burned by `from`.
1274      * - `from` and `to` are never both zero.
1275      */
1276     function _beforeTokenTransfers(
1277         address from,
1278         address to,
1279         uint256 startTokenId,
1280         uint256 quantity
1281     ) internal virtual {}
1282 
1283     /**
1284      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1285      * minting.
1286      * And also called after one token has been burned.
1287      *
1288      * startTokenId - the first token id to be transferred
1289      * quantity - the amount to be transferred
1290      *
1291      * Calling conditions:
1292      *
1293      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1294      * transferred to `to`.
1295      * - When `from` is zero, `tokenId` has been minted for `to`.
1296      * - When `to` is zero, `tokenId` has been burned by `from`.
1297      * - `from` and `to` are never both zero.
1298      */
1299     function _afterTokenTransfers(
1300         address from,
1301         address to,
1302         uint256 startTokenId,
1303         uint256 quantity
1304     ) internal virtual {}
1305 }
1306 
1307 // File: contracts/InvsbleFrens.sol
1308 
1309 
1310 pragma solidity ^0.8.0;
1311 
1312 
1313 
1314 contract InvsbleFrens is ERC721A, Ownable {
1315   using Strings for uint256;
1316 
1317   string public baseURI;
1318   string public baseExtenstion = ".json";
1319   uint256 public cost = 0.01 ether;
1320   uint256 public maxSupply = 5000;
1321   uint256 maxMintAmount = 25;
1322   bool public paused = true;
1323 
1324   constructor(
1325     string memory _name,
1326     string memory _symbol,
1327     string memory _initBaseURI
1328   ) ERC721A(_name, _symbol) {
1329     setBaseURI(_initBaseURI);
1330   }
1331 
1332   function _baseURI() internal view virtual override returns (string memory) {
1333     return baseURI;
1334   }
1335 
1336   function mint(address _to, uint256 _mintAmount) public payable {
1337     uint256 supply = totalSupply();
1338     require(!paused);
1339     require(_mintAmount > 0);
1340     require(_mintAmount <= maxMintAmount);
1341     require(supply + _mintAmount <= maxSupply);
1342     require(_mintAmount <= maxMintAmount);
1343 
1344     if (msg.sender != owner()) {
1345       require(msg.value >= cost * _mintAmount);
1346     }
1347 
1348     _safeMint(_to, _mintAmount);
1349 
1350   }
1351 
1352 
1353   function tokenURI(uint256 tokenId)
1354     public
1355     view
1356     virtual
1357     override
1358     returns (string memory)
1359   {
1360     require(
1361       _exists(tokenId),
1362       "ERC721Metadata: URI query for nonexistent token"
1363     );
1364 
1365     string memory currentBaseURI = _baseURI();
1366     return
1367       bytes(currentBaseURI).length > 0
1368         ? string(
1369           abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtenstion)
1370         )
1371         : "";
1372   }
1373 
1374   //only owner
1375   function setCost(uint256 _newCost) public onlyOwner {
1376     cost = _newCost;
1377   }
1378 
1379   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1380     maxMintAmount = _newmaxMintAmount;
1381   }
1382 
1383   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1384     baseURI = _newBaseURI;
1385   }
1386 
1387   function SetBaseExtension(string memory _newBaseExtestion) public onlyOwner {
1388     baseExtenstion = _newBaseExtestion;
1389   }
1390 
1391   function pause(bool _state) public onlyOwner {
1392     paused = _state;
1393   }
1394 
1395   function withdraw() public payable onlyOwner {
1396     require(payable(msg.sender).send(address(this).balance));
1397   }
1398 }