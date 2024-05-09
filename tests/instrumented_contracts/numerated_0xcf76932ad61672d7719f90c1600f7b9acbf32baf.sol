1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev String operations.
75  */
76 library Strings {
77     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
81      */
82     function toString(uint256 value) internal pure returns (string memory) {
83         // Inspired by OraclizeAPI's implementation - MIT licence
84         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
85 
86         if (value == 0) {
87             return "0";
88         }
89         uint256 temp = value;
90         uint256 digits;
91         while (temp != 0) {
92             digits++;
93             temp /= 10;
94         }
95         bytes memory buffer = new bytes(digits);
96         while (value != 0) {
97             digits -= 1;
98             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
99             value /= 10;
100         }
101         return string(buffer);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
106      */
107     function toHexString(uint256 value) internal pure returns (string memory) {
108         if (value == 0) {
109             return "0x00";
110         }
111         uint256 temp = value;
112         uint256 length = 0;
113         while (temp != 0) {
114             length++;
115             temp >>= 8;
116         }
117         return toHexString(value, length);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
122      */
123     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
124         bytes memory buffer = new bytes(2 * length + 2);
125         buffer[0] = "0";
126         buffer[1] = "x";
127         for (uint256 i = 2 * length + 1; i > 1; --i) {
128             buffer[i] = _HEX_SYMBOLS[value & 0xf];
129             value >>= 4;
130         }
131         require(value == 0, "Strings: hex length insufficient");
132         return string(buffer);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/Context.sol
137 
138 
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 
166 pragma solidity ^0.8.0;
167 
168 
169 /**
170  * @dev Contract module which provides a basic access control mechanism, where
171  * there is an account (an owner) that can be granted exclusive access to
172  * specific functions.
173  *
174  * By default, the owner account will be the one that deploys the contract. This
175  * can later be changed with {transferOwnership}.
176  *
177  * This module is used through inheritance. It will make available the modifier
178  * `onlyOwner`, which can be applied to your functions to restrict their use to
179  * the owner.
180  */
181 abstract contract Ownable is Context {
182     address private _owner;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     /**
187      * @dev Initializes the contract setting the deployer as the initial owner.
188      */
189     constructor() {
190         _setOwner(_msgSender());
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if called by any account other than the owner.
202      */
203     modifier onlyOwner() {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205         _;
206     }
207 
208     /**
209      * @dev Leaves the contract without owner. It will not be possible to call
210      * `onlyOwner` functions anymore. Can only be called by the current owner.
211      *
212      * NOTE: Renouncing ownership will leave the contract without an owner,
213      * thereby removing any functionality that is only available to the owner.
214      */
215     function renounceOwnership() public virtual onlyOwner {
216         _setOwner(address(0));
217     }
218 
219     /**
220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
221      * Can only be called by the current owner.
222      */
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         _setOwner(newOwner);
226     }
227 
228     function _setOwner(address newOwner) private {
229         address oldOwner = _owner;
230         _owner = newOwner;
231         emit OwnershipTransferred(oldOwner, newOwner);
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Address.sol
236 
237 
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize, which returns 0 for contracts in
264         // construction, since the code is only stored at the end of the
265         // constructor execution.
266 
267         uint256 size;
268         assembly {
269             size := extcodesize(account)
270         }
271         return size > 0;
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         (bool success, ) = recipient.call{value: amount}("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain `call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.call{value: value}(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
378         return functionStaticCall(target, data, "Address: low-level static call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal view returns (bytes memory) {
392         require(isContract(target), "Address: static call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.staticcall(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(isContract(target), "Address: delegate call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.delegatecall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
427      * revert reason using the provided one.
428      *
429      * _Available since v4.3._
430      */
431     function verifyCallResult(
432         bool success,
433         bytes memory returndata,
434         string memory errorMessage
435     ) internal pure returns (bytes memory) {
436         if (success) {
437             return returndata;
438         } else {
439             // Look for revert reason and bubble it up if present
440             if (returndata.length > 0) {
441                 // The easiest way to bubble the revert reason is using memory via assembly
442 
443                 assembly {
444                     let returndata_size := mload(returndata)
445                     revert(add(32, returndata), returndata_size)
446                 }
447             } else {
448                 revert(errorMessage);
449             }
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
455 
456 
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @title ERC721 token receiver interface
462  * @dev Interface for any contract that wants to support safeTransfers
463  * from ERC721 asset contracts.
464  */
465 interface IERC721Receiver {
466     /**
467      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
468      * by `operator` from `from`, this function is called.
469      *
470      * It must return its Solidity selector to confirm the token transfer.
471      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
472      *
473      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
474      */
475     function onERC721Received(
476         address operator,
477         address from,
478         uint256 tokenId,
479         bytes calldata data
480     ) external returns (bytes4);
481 }
482 
483 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
484 
485 
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
511 
512 
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
541 
542 
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev Required interface of an ERC721 compliant contract.
549  */
550 interface IERC721 is IERC165 {
551     /**
552      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
558      */
559     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
563      */
564     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
565 
566     /**
567      * @dev Returns the number of tokens in ``owner``'s account.
568      */
569     function balanceOf(address owner) external view returns (uint256 balance);
570 
571     /**
572      * @dev Returns the owner of the `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function ownerOf(uint256 tokenId) external view returns (address owner);
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
582      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must exist and be owned by `from`.
589      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591      *
592      * Emits a {Transfer} event.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Transfers `tokenId` token from `from` to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
622      * The approval is cleared when the token is transferred.
623      *
624      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
625      *
626      * Requirements:
627      *
628      * - The caller must own the token or be an approved operator.
629      * - `tokenId` must exist.
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address to, uint256 tokenId) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Approve or remove `operator` as an operator for the caller.
646      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
647      *
648      * Requirements:
649      *
650      * - The `operator` cannot be the caller.
651      *
652      * Emits an {ApprovalForAll} event.
653      */
654     function setApprovalForAll(address operator, bool _approved) external;
655 
656     /**
657      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
658      *
659      * See {setApprovalForAll}
660      */
661     function isApprovedForAll(address owner, address operator) external view returns (bool);
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId,
680         bytes calldata data
681     ) external;
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
685 
686 
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Metadata is IERC721 {
696     /**
697      * @dev Returns the token collection name.
698      */
699     function name() external view returns (string memory);
700 
701     /**
702      * @dev Returns the token collection symbol.
703      */
704     function symbol() external view returns (string memory);
705 
706     /**
707      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708      */
709     function tokenURI(uint256 tokenId) external view returns (string memory);
710 }
711 
712 // File: contracts/ERC721A.sol
713 
714 
715 // Creator: Chiru Labs
716 
717 pragma solidity ^0.8.4;
718 
719 
720 
721 
722 
723 
724 
725 
726 error ApprovalCallerNotOwnerNorApproved();
727 error ApprovalQueryForNonexistentToken();
728 error ApproveToCaller();
729 error ApprovalToCurrentOwner();
730 error BalanceQueryForZeroAddress();
731 error MintToZeroAddress();
732 error MintZeroQuantity();
733 error OwnerQueryForNonexistentToken();
734 error TransferCallerNotOwnerNorApproved();
735 error TransferFromIncorrectOwner();
736 error TransferToNonERC721ReceiverImplementer();
737 error TransferToZeroAddress();
738 error URIQueryForNonexistentToken();
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata extension. Built to optimize for lower gas during batch mints.
743  *
744  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
745  *
746  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
747  *
748  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
749  */
750 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
751     using Address for address;
752     using Strings for uint256;
753 
754     // Compiler will pack this into a single 256bit word.
755     struct TokenOwnership {
756         // The address of the owner.
757         address addr;
758         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
759         uint64 startTimestamp;
760         // Whether the token has been burned.
761         bool burned;
762     }
763 
764     // Compiler will pack this into a single 256bit word.
765     struct AddressData {
766         // Realistically, 2**64-1 is more than enough.
767         uint64 balance;
768         // Keeps track of mint count with minimal overhead for tokenomics.
769         uint64 numberMinted;
770         // Keeps track of burn count with minimal overhead for tokenomics.
771         uint64 numberBurned;
772         // For miscellaneous variable(s) pertaining to the address
773         // (e.g. number of whitelist mint slots used).
774         // If there are multiple variables, please pack them into a uint64.
775         uint64 aux;
776     }
777 
778     // The tokenId of the next token to be minted.
779     uint256 internal _currentIndex;
780 
781     // The number of tokens burned.
782     uint256 internal _burnCounter;
783 
784     // Token name
785     string private _name;
786 
787     // Token symbol
788     string private _symbol;
789 
790     // Mapping from token ID to ownership details
791     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
792     mapping(uint256 => TokenOwnership) internal _ownerships;
793 
794     // Mapping owner address to address data
795     mapping(address => AddressData) private _addressData;
796 
797     // Mapping from token ID to approved address
798     mapping(uint256 => address) private _tokenApprovals;
799 
800     // Mapping from owner to operator approvals
801     mapping(address => mapping(address => bool)) private _operatorApprovals;
802 
803     constructor(string memory name_, string memory symbol_) {
804         _name = name_;
805         _symbol = symbol_;
806         _currentIndex = _startTokenId();
807     }
808 
809     /**
810      * To change the starting tokenId, please override this function.
811      */
812     function _startTokenId() internal view virtual returns (uint256) {
813         return 0;
814     }
815 
816     /**
817      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
818      */
819     function totalSupply() public view returns (uint256) {
820         // Counter underflow is impossible as _burnCounter cannot be incremented
821         // more than _currentIndex - _startTokenId() times
822         unchecked {
823             return _currentIndex - _burnCounter - _startTokenId();
824         }
825     }
826 
827     /**
828      * Returns the total amount of tokens minted in the contract.
829      */
830     function _totalMinted() internal view returns (uint256) {
831         // Counter underflow is impossible as _currentIndex does not decrement,
832         // and it is initialized to _startTokenId()
833         unchecked {
834             return _currentIndex - _startTokenId();
835         }
836     }
837 
838     /**
839      * @dev See {IERC165-supportsInterface}.
840      */
841     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
842         return
843             interfaceId == type(IERC721).interfaceId ||
844             interfaceId == type(IERC721Metadata).interfaceId ||
845             super.supportsInterface(interfaceId);
846     }
847 
848     /**
849      * @dev See {IERC721-balanceOf}.
850      */
851     function balanceOf(address owner) public view override returns (uint256) {
852         if (owner == address(0)) revert BalanceQueryForZeroAddress();
853         return uint256(_addressData[owner].balance);
854     }
855 
856     /**
857      * Returns the number of tokens minted by `owner`.
858      */
859     function _numberMinted(address owner) internal view returns (uint256) {
860         return uint256(_addressData[owner].numberMinted);
861     }
862 
863     /**
864      * Returns the number of tokens burned by or on behalf of `owner`.
865      */
866     function _numberBurned(address owner) internal view returns (uint256) {
867         return uint256(_addressData[owner].numberBurned);
868     }
869 
870     /**
871      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
872      */
873     function _getAux(address owner) internal view returns (uint64) {
874         return _addressData[owner].aux;
875     }
876 
877     /**
878      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
879      * If there are multiple variables, please pack them into a uint64.
880      */
881     function _setAux(address owner, uint64 aux) internal {
882         _addressData[owner].aux = aux;
883     }
884 
885     /**
886      * Gas spent here starts off proportional to the maximum mint batch size.
887      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
888      */
889     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
890         uint256 curr = tokenId;
891 
892         unchecked {
893             if (_startTokenId() <= curr && curr < _currentIndex) {
894                 TokenOwnership memory ownership = _ownerships[curr];
895                 if (!ownership.burned) {
896                     if (ownership.addr != address(0)) {
897                         return ownership;
898                     }
899                     // Invariant:
900                     // There will always be an ownership that has an address and is not burned
901                     // before an ownership that does not have an address and is not burned.
902                     // Hence, curr will not underflow.
903                     while (true) {
904                         curr--;
905                         ownership = _ownerships[curr];
906                         if (ownership.addr != address(0)) {
907                             return ownership;
908                         }
909                     }
910                 }
911             }
912         }
913         revert OwnerQueryForNonexistentToken();
914     }
915 
916     /**
917      * @dev See {IERC721-ownerOf}.
918      */
919     function ownerOf(uint256 tokenId) public view override returns (address) {
920         return _ownershipOf(tokenId).addr;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-name}.
925      */
926     function name() public view virtual override returns (string memory) {
927         return _name;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-symbol}.
932      */
933     function symbol() public view virtual override returns (string memory) {
934         return _symbol;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-tokenURI}.
939      */
940     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
941         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
942 
943         string memory baseURI = _baseURI();
944         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
945     }
946 
947     /**
948      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
949      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
950      * by default, can be overriden in child contracts.
951      */
952     function _baseURI() internal view virtual returns (string memory) {
953         return '';
954     }
955 
956     /**
957      * @dev See {IERC721-approve}.
958      */
959     function approve(address to, uint256 tokenId) public override {
960         address owner = ERC721A.ownerOf(tokenId);
961         if (to == owner) revert ApprovalToCurrentOwner();
962 
963         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
964             revert ApprovalCallerNotOwnerNorApproved();
965         }
966 
967         _approve(to, tokenId, owner);
968     }
969 
970     /**
971      * @dev See {IERC721-getApproved}.
972      */
973     function getApproved(uint256 tokenId) public view override returns (address) {
974         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
975 
976         return _tokenApprovals[tokenId];
977     }
978 
979     /**
980      * @dev See {IERC721-setApprovalForAll}.
981      */
982     function setApprovalForAll(address operator, bool approved) public virtual override {
983         if (operator == _msgSender()) revert ApproveToCaller();
984 
985         _operatorApprovals[_msgSender()][operator] = approved;
986         emit ApprovalForAll(_msgSender(), operator, approved);
987     }
988 
989     /**
990      * @dev See {IERC721-isApprovedForAll}.
991      */
992     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
993         return _operatorApprovals[owner][operator];
994     }
995 
996     /**
997      * @dev See {IERC721-transferFrom}.
998      */
999     function transferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) public virtual override {
1004         _transfer(from, to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-safeTransferFrom}.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         safeTransferFrom(from, to, tokenId, '');
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) public virtual override {
1027         _transfer(from, to, tokenId);
1028         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1029             revert TransferToNonERC721ReceiverImplementer();
1030         }
1031     }
1032 
1033     /**
1034      * @dev Returns whether `tokenId` exists.
1035      *
1036      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1037      *
1038      * Tokens start existing when they are minted (`_mint`),
1039      */
1040     function _exists(uint256 tokenId) internal view returns (bool) {
1041         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1042             !_ownerships[tokenId].burned;
1043     }
1044 
1045     function _safeMint(address to, uint256 quantity) internal {
1046         _safeMint(to, quantity, '');
1047     }
1048 
1049     /**
1050      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1055      * - `quantity` must be greater than 0.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _safeMint(
1060         address to,
1061         uint256 quantity,
1062         bytes memory _data
1063     ) internal {
1064         _mint(to, quantity, _data, true);
1065     }
1066 
1067     /**
1068      * @dev Mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - `to` cannot be the zero address.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _mint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data,
1081         bool safe
1082     ) internal {
1083         uint256 startTokenId = _currentIndex;
1084         if (to == address(0)) revert MintToZeroAddress();
1085         if (quantity == 0) revert MintZeroQuantity();
1086 
1087         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1088 
1089         // Overflows are incredibly unrealistic.
1090         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1091         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1092         unchecked {
1093             _addressData[to].balance += uint64(quantity);
1094             _addressData[to].numberMinted += uint64(quantity);
1095 
1096             _ownerships[startTokenId].addr = to;
1097             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1098 
1099             uint256 updatedIndex = startTokenId;
1100             uint256 end = updatedIndex + quantity;
1101 
1102             if (safe && to.isContract()) {
1103                 do {
1104                     emit Transfer(address(0), to, updatedIndex);
1105                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1106                         revert TransferToNonERC721ReceiverImplementer();
1107                     }
1108                 } while (updatedIndex != end);
1109                 // Reentrancy protection
1110                 if (_currentIndex != startTokenId) revert();
1111             } else {
1112                 do {
1113                     emit Transfer(address(0), to, updatedIndex++);
1114                 } while (updatedIndex != end);
1115             }
1116             _currentIndex = updatedIndex;
1117         }
1118         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119     }
1120 
1121     /**
1122      * @dev Transfers `tokenId` from `from` to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must be owned by `from`.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _transfer(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) private {
1136         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1137 
1138         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1139 
1140         bool isApprovedOrOwner = (_msgSender() == from ||
1141             isApprovedForAll(from, _msgSender()) ||
1142             getApproved(tokenId) == _msgSender());
1143 
1144         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1145         if (to == address(0)) revert TransferToZeroAddress();
1146 
1147         _beforeTokenTransfers(from, to, tokenId, 1);
1148 
1149         // Clear approvals from the previous owner
1150         _approve(address(0), tokenId, from);
1151 
1152         // Underflow of the sender's balance is impossible because we check for
1153         // ownership above and the recipient's balance can't realistically overflow.
1154         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1155         unchecked {
1156             _addressData[from].balance -= 1;
1157             _addressData[to].balance += 1;
1158 
1159             TokenOwnership storage currSlot = _ownerships[tokenId];
1160             currSlot.addr = to;
1161             currSlot.startTimestamp = uint64(block.timestamp);
1162 
1163             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1164             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1165             uint256 nextTokenId = tokenId + 1;
1166             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1167             if (nextSlot.addr == address(0)) {
1168                 // This will suffice for checking _exists(nextTokenId),
1169                 // as a burned slot cannot contain the zero address.
1170                 if (nextTokenId != _currentIndex) {
1171                     nextSlot.addr = from;
1172                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1173                 }
1174             }
1175         }
1176 
1177         emit Transfer(from, to, tokenId);
1178         _afterTokenTransfers(from, to, tokenId, 1);
1179     }
1180 
1181     /**
1182      * @dev This is equivalent to _burn(tokenId, false)
1183      */
1184     function _burn(uint256 tokenId) internal virtual {
1185         _burn(tokenId, false);
1186     }
1187 
1188     /**
1189      * @dev Destroys `tokenId`.
1190      * The approval is cleared when the token is burned.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1199         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1200 
1201         address from = prevOwnership.addr;
1202 
1203         if (approvalCheck) {
1204             bool isApprovedOrOwner = (_msgSender() == from ||
1205                 isApprovedForAll(from, _msgSender()) ||
1206                 getApproved(tokenId) == _msgSender());
1207 
1208             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1209         }
1210 
1211         _beforeTokenTransfers(from, address(0), tokenId, 1);
1212 
1213         // Clear approvals from the previous owner
1214         _approve(address(0), tokenId, from);
1215 
1216         // Underflow of the sender's balance is impossible because we check for
1217         // ownership above and the recipient's balance can't realistically overflow.
1218         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1219         unchecked {
1220             AddressData storage addressData = _addressData[from];
1221             addressData.balance -= 1;
1222             addressData.numberBurned += 1;
1223 
1224             // Keep track of who burned the token, and the timestamp of burning.
1225             TokenOwnership storage currSlot = _ownerships[tokenId];
1226             currSlot.addr = from;
1227             currSlot.startTimestamp = uint64(block.timestamp);
1228             currSlot.burned = true;
1229 
1230             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1231             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1232             uint256 nextTokenId = tokenId + 1;
1233             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1234             if (nextSlot.addr == address(0)) {
1235                 // This will suffice for checking _exists(nextTokenId),
1236                 // as a burned slot cannot contain the zero address.
1237                 if (nextTokenId != _currentIndex) {
1238                     nextSlot.addr = from;
1239                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1240                 }
1241             }
1242         }
1243 
1244         emit Transfer(from, address(0), tokenId);
1245         _afterTokenTransfers(from, address(0), tokenId, 1);
1246 
1247         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1248         unchecked {
1249             _burnCounter++;
1250         }
1251     }
1252 
1253     /**
1254      * @dev Approve `to` to operate on `tokenId`
1255      *
1256      * Emits a {Approval} event.
1257      */
1258     function _approve(
1259         address to,
1260         uint256 tokenId,
1261         address owner
1262     ) private {
1263         _tokenApprovals[tokenId] = to;
1264         emit Approval(owner, to, tokenId);
1265     }
1266 
1267     /**
1268      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1269      *
1270      * @param from address representing the previous owner of the given token ID
1271      * @param to target address that will receive the tokens
1272      * @param tokenId uint256 ID of the token to be transferred
1273      * @param _data bytes optional data to send along with the call
1274      * @return bool whether the call correctly returned the expected magic value
1275      */
1276     function _checkContractOnERC721Received(
1277         address from,
1278         address to,
1279         uint256 tokenId,
1280         bytes memory _data
1281     ) private returns (bool) {
1282         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1283             return retval == IERC721Receiver(to).onERC721Received.selector;
1284         } catch (bytes memory reason) {
1285             if (reason.length == 0) {
1286                 revert TransferToNonERC721ReceiverImplementer();
1287             } else {
1288                 assembly {
1289                     revert(add(32, reason), mload(reason))
1290                 }
1291             }
1292         }
1293     }
1294 
1295     /**
1296      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1297      * And also called before burning one token.
1298      *
1299      * startTokenId - the first token id to be transferred
1300      * quantity - the amount to be transferred
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` will be minted for `to`.
1307      * - When `to` is zero, `tokenId` will be burned by `from`.
1308      * - `from` and `to` are never both zero.
1309      */
1310     function _beforeTokenTransfers(
1311         address from,
1312         address to,
1313         uint256 startTokenId,
1314         uint256 quantity
1315     ) internal virtual {}
1316 
1317     /**
1318      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1319      * minting.
1320      * And also called after one token has been burned.
1321      *
1322      * startTokenId - the first token id to be transferred
1323      * quantity - the amount to be transferred
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` has been minted for `to`.
1330      * - When `to` is zero, `tokenId` has been burned by `from`.
1331      * - `from` and `to` are never both zero.
1332      */
1333     function _afterTokenTransfers(
1334         address from,
1335         address to,
1336         uint256 startTokenId,
1337         uint256 quantity
1338     ) internal virtual {}
1339 }
1340 
1341 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1342 
1343 
1344 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1345 
1346 pragma solidity ^0.8.0;
1347 
1348 /**
1349  * @dev These functions deal with verification of Merkle Trees proofs.
1350  *
1351  * The proofs can be generated using the JavaScript library
1352  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1353  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1354  *
1355  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1356  */
1357 library MerkleProof {
1358     /**
1359      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1360      * defined by `root`. For this, a `proof` must be provided, containing
1361      * sibling hashes on the branch from the leaf to the root of the tree. Each
1362      * pair of leaves and each pair of pre-images are assumed to be sorted.
1363      */
1364     function verify(
1365         bytes32[] memory proof,
1366         bytes32 root,
1367         bytes32 leaf
1368     ) internal pure returns (bool) {
1369         return processProof(proof, leaf) == root;
1370     }
1371 
1372     /**
1373      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1374      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1375      * hash matches the root of the tree. When processing the proof, the pairs
1376      * of leafs & pre-images are assumed to be sorted.
1377      *
1378      * _Available since v4.4._
1379      */
1380     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1381         bytes32 computedHash = leaf;
1382         for (uint256 i = 0; i < proof.length; i++) {
1383             bytes32 proofElement = proof[i];
1384             if (computedHash <= proofElement) {
1385                 // Hash(current computed hash + current element of the proof)
1386                 computedHash = _efficientHash(computedHash, proofElement);
1387             } else {
1388                 // Hash(current element of the proof + current computed hash)
1389                 computedHash = _efficientHash(proofElement, computedHash);
1390             }
1391         }
1392         return computedHash;
1393     }
1394 
1395     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1396         assembly {
1397             mstore(0x00, a)
1398             mstore(0x20, b)
1399             value := keccak256(0x00, 0x40)
1400         }
1401     }
1402 }
1403 
1404 // File: contracts/Robomito.sol
1405 
1406 
1407 
1408 pragma solidity ^0.8.4;
1409 
1410 
1411 
1412 
1413 
1414 
1415 /*
1416     ____          __                       _  __       
1417    / __ \ ____   / /_   ____   ____ ___   (_)/ /_ ____ 
1418   / /_/ // __ \ / __ \ / __ \ / __ `__ \ / // __// __ \
1419  / _, _// /_/ // /_/ // /_/ // / / / / // // /_ / /_/ /
1420 /_/ |_| \____//_.___/ \____//_/ /_/ /_//_/ \__/ \____/ 
1421 
1422 */
1423 
1424 
1425 
1426 
1427 contract Robomito is ERC721A, Ownable, ReentrancyGuard {
1428     address private constant creator1 =
1429         0x0140D50CDb7408882ba92551DE191f3F9a4645fa;
1430     address private constant creator2 =
1431         0x02085D99239BeAdcB82bd6c4CC55a5bB79E3f487;
1432     address private constant creator3 =
1433         0x768a93fA0C1213aa1411456a8056b7EBEE94bEaF;
1434     address private constant creator4 =
1435         0xE2BFf72848B50e2385E63c23681695e990eC42cb;
1436 
1437     using Strings for uint256;
1438     using MerkleProof for bytes32[];
1439 
1440     string private _baseTokenURI;
1441     bool private _saleStatus = false;
1442     bool private _claimStatus = false;
1443     bool private _presaleStatus = false;
1444     uint256 private _salePrice = 0.08 ether;
1445 	uint256 private _preSalePrice = 0.066 ether;
1446 
1447 	uint256 private _reservedSupply = 150;
1448 	address private _marketAddress = 0xbF0a44954F37C9DcE6b9B1Bd779088A8324BE8eb;
1449 	uint256 private _marketMintSupply = 100;
1450     
1451 	bytes32 private _claimMerkleRoot;
1452     bytes32 private _presaleMerkleRoot;
1453 
1454     mapping(address => bool) private _mintedClaim;
1455     mapping(address => uint256) private _whitelistMints;
1456 
1457     uint256 private MAX_MINTS_PER_WHITELIST = 10;
1458     uint256 private MAX_MINTS_PER_TX = 20;
1459 	
1460     uint256 public MAX_SUPPLY = 3333;
1461 	
1462 
1463     constructor() ERC721A("Robomito", "ROBOMITO") {}
1464 
1465     modifier callerIsUser() {
1466         require(tx.origin == msg.sender, "The caller is another contract");
1467         _;
1468     }
1469 
1470     modifier verify(
1471         address account,
1472         bytes32[] calldata merkleProof,
1473         bytes32 merkleRoot
1474     ) {
1475         require(
1476             merkleProof.verify(
1477                 merkleRoot,
1478                 keccak256(abi.encodePacked(account))
1479             ),
1480             "Address not listed"
1481         );
1482         _;
1483     }
1484 
1485     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1486         _baseTokenURI = newBaseURI;
1487     }
1488 
1489     function setClaimMerkleRoot(bytes32 root) external onlyOwner {
1490         _claimMerkleRoot = root;
1491     }
1492 
1493     function setPresaleMerkleRoot(bytes32 root) external onlyOwner {
1494         _presaleMerkleRoot = root;
1495     }
1496 
1497 	function setMarketAddress(address marketAddress) external onlyOwner {
1498         _marketAddress = marketAddress;
1499     }
1500 
1501     function setMaxMintPerWhitelist(uint256 maxMint) external onlyOwner {
1502         MAX_MINTS_PER_WHITELIST = maxMint;
1503     }
1504 
1505     function setMaxMintPerTx(uint256 maxMint) external onlyOwner {
1506         MAX_MINTS_PER_TX = maxMint;
1507     }
1508 
1509     function setSalePrice(uint256 price) external onlyOwner {
1510         _salePrice = price;
1511     }
1512 
1513 	function setPresalePrice(uint256 price) external onlyOwner {
1514         _preSalePrice = price;
1515     }
1516 
1517     function toggleClaimStatus() external onlyOwner {
1518         _claimStatus = !_claimStatus;
1519     }
1520 
1521     function togglePresaleStatus() external onlyOwner {
1522         _presaleStatus = !_presaleStatus;
1523     }
1524 
1525     function toggleSaleStatus() external onlyOwner {
1526         _saleStatus = !_saleStatus;
1527     }
1528 
1529     function withdrawAll(uint256 leftPercent) external onlyOwner {
1530 
1531 		if (leftPercent < 0 || leftPercent > 1000)
1532             revert("value range must be between 0 - 1000");
1533 
1534 		uint256 pricePercent = 1000 - leftPercent;
1535 		if(leftPercent > 999)
1536 			pricePercent = 1000;
1537 		uint256 balance = address(this).balance * pricePercent / 1000;
1538 		uint256 amountToCreator1 = (balance * 310) / 1000;
1539 		uint256 amountToCreator2 = (balance * 310) / 1000;
1540 		uint256 amountToCreator3 = (balance * 305) / 1000;
1541 		uint256 amountToCreator4 = (balance * 75) / 1000;
1542         withdraw(creator1, amountToCreator1);
1543         withdraw(creator2, amountToCreator2);
1544 		withdraw(creator3, amountToCreator3);
1545 		withdraw(creator4, amountToCreator4);
1546     }
1547 
1548     function withdraw(address account, uint256 amount) internal {
1549         (bool os, ) = payable(account).call{value: amount}("");
1550         require(os, "Failed to send ether");
1551     }
1552 
1553     function _baseURI() internal view virtual override returns (string memory) {
1554         return _baseTokenURI;
1555     }
1556 
1557     function claimMint(bytes32[] calldata merkleProof)
1558         external
1559         nonReentrant
1560         callerIsUser
1561         verify(msg.sender, merkleProof, _claimMerkleRoot)
1562     {
1563         if (!isClaimActive()) revert("Sale not started");
1564         if (hasMintedClaim(msg.sender)) revert("Amount exceeds claim limit");
1565         if (totalSupply() + 1 > (MAX_SUPPLY - _reservedSupply)) revert("Amount exceeds supply");
1566         _mintedClaim[msg.sender] = true;
1567         _safeMint(msg.sender, 1);
1568     }
1569 
1570 	function marketMint(uint256 quantity)
1571         external
1572         nonReentrant
1573         callerIsUser
1574     {
1575         if (!isSaleActive()) revert("Sale not started");
1576 		if(msg.sender != _marketAddress)
1577 			revert("only market address can mint");
1578         if (quantity > _marketMintSupply)
1579             revert("Amount exceeds mint supply limit");
1580 		if(_marketMintSupply < 1)
1581 			revert("no market supply left");
1582         if (totalSupply() + quantity > (MAX_SUPPLY - _reservedSupply))
1583             revert("Amount exceeds supply");
1584 		
1585 		_marketMintSupply -= quantity;
1586         _reservedSupply -= quantity;
1587 		_safeMint(msg.sender, quantity);
1588     }
1589 
1590     function presaleMint(bytes32[] calldata merkleProof, uint256 quantity)
1591         external
1592         payable
1593         nonReentrant
1594         callerIsUser
1595         verify(msg.sender, merkleProof, _presaleMerkleRoot)
1596     {
1597         if (!isPresaleActive()) revert("Sale not started");
1598         if (quantity > MAX_MINTS_PER_WHITELIST)
1599             revert("Amount exceeds presale Limit");
1600         if (_whitelistMints[msg.sender] + quantity > MAX_MINTS_PER_WHITELIST)
1601             revert("Amount exceeds your total presale  limit");
1602         if (totalSupply() + quantity > (MAX_SUPPLY - _reservedSupply))
1603             revert("Amount exceeds supply");
1604         if (getPresalePrice() * quantity > msg.value)
1605             revert("Insufficient payment");
1606 
1607         _whitelistMints[msg.sender] += quantity;
1608         _safeMint(msg.sender, quantity);
1609     }
1610 
1611 
1612     function saleMint(uint256 quantity)
1613         external
1614         payable
1615         nonReentrant
1616         callerIsUser
1617     {
1618         if (!isSaleActive()) revert("Sale not started");
1619         if (quantity > MAX_MINTS_PER_TX)
1620             revert("Amount exceeds transaction limit");
1621         if (totalSupply() + quantity > (MAX_SUPPLY - _reservedSupply))
1622             revert("Amount exceeds supply");
1623         if (getSalePrice() * quantity > msg.value)
1624             revert("Insufficient payment");
1625 
1626         _safeMint(msg.sender, quantity);
1627     }
1628 
1629     function walletOfOwner(address _owner)
1630         external
1631         view
1632         returns (uint256[] memory)
1633     {
1634         uint256 ownerTokenCount = balanceOf(_owner);
1635         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1636         uint256 currentTokenId = 0;
1637         uint256 ownedTokenIndex = 0;
1638         while (
1639             ownedTokenIndex < ownerTokenCount && currentTokenId <= totalSupply()
1640         ) {
1641             address currentTokenOwner = ownerOf(currentTokenId);
1642             if (currentTokenOwner == _owner) {
1643                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1644                 ownedTokenIndex++;
1645             }
1646             currentTokenId++;
1647         }
1648         return ownedTokenIds;
1649     }
1650 
1651     function mintToAddress(address to, uint256 quantity) external onlyOwner {
1652         if (totalSupply() + quantity > (MAX_SUPPLY - _reservedSupply))
1653             revert("Amount exceeds supply");
1654 
1655         _safeMint(to, quantity);
1656     }
1657 
1658 	function mintReserveToAddress(address to, uint256 quantity) external onlyOwner {
1659         if (totalSupply() + quantity > MAX_SUPPLY)
1660             revert("Amount exceeds supply");
1661 		if(quantity > _reservedSupply)
1662 			revert("Amount exceeds reserved supply");
1663 		if(_reservedSupply < 1)
1664 			revert("No reserved supply left");
1665 		
1666 		_reservedSupply -= quantity;
1667         _safeMint(to, quantity);
1668     }
1669 
1670     function getClaimMerkleRoot() external view returns (bytes32) {
1671         return _claimMerkleRoot;
1672     }
1673 
1674     function getPresaleMerkleRoot() external view returns (bytes32) {
1675         return _presaleMerkleRoot;
1676     }
1677 
1678     function isClaimActive() public view returns (bool) {
1679         return _claimStatus;
1680     }
1681 
1682     function isPresaleActive() public view returns (bool) {
1683         return _presaleStatus;
1684     }
1685 
1686     function isSaleActive() public view returns (bool) {
1687         return _saleStatus;
1688     }
1689 
1690     function getSalePrice() public view returns (uint256) {
1691         return _salePrice;
1692     }
1693 
1694 	function getPresalePrice() public view returns (uint256) {
1695         return _preSalePrice;
1696     }
1697 
1698 	function mintedWhiteListLeft(address account) external view returns (uint256){
1699 		return _whitelistMints[account];
1700 	}
1701 
1702     function hasMintedClaim(address account) public view returns (bool) {
1703         return _mintedClaim[account];
1704     }
1705 }