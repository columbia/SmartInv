1 //SPDX-License-Identifier: MIT
2 
3 // Okay Doodle Degens contract:
4 
5 /* 
6     uint256 public price = 0 ether;
7     uint256 public priceAfterFreeMint = 0.002 ether;
8     uint256 public maxPerTx = 5;
9     uint256 public totalFree = 1000; //first 1000 free
10     uint256 public maxSupply = 3333;
11     uint256 public maxPerWallet = 5; //will be changed to 100 after first 1000 minted 
12 */
13 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
14 
15 
16 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 
21 abstract contract ReentrancyGuard {
22   
23     uint256 private constant _NOT_ENTERED = 1;
24     uint256 private constant _ENTERED = 2;
25 
26     uint256 private _status;
27 
28     constructor() {
29         _status = _NOT_ENTERED;
30     }
31 
32     /**
33      * @dev Prevents a contract from calling itself, directly or indirectly.
34      * Calling a `nonReentrant` function from another `nonReentrant`
35      * function is not supported. It is possible to prevent this from happening
36      * by making the `nonReentrant` function external, and making it call a
37      * `private` function that does the actual work.
38      */
39     modifier nonReentrant() {
40         // On the first call to nonReentrant, _notEntered will be true
41         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
42 
43         // Any calls to nonReentrant after this point will fail
44         _status = _ENTERED;
45 
46         _;
47 
48         // By storing the original value once again, a refund is triggered (see
49         // https://eips.ethereum.org/EIPS/eip-2200)
50         _status = _NOT_ENTERED;
51     }
52 }
53 
54 // File: @openzeppelin/contracts/utils/Strings.sol
55 
56 
57 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
58 
59 pragma solidity ^0.8.0;
60 
61 /**
62  * @dev String operations.
63  */
64 library Strings {
65     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
69      */
70     function toString(uint256 value) internal pure returns (string memory) {
71         // Inspired by OraclizeAPI's implementation - MIT licence
72         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
73 
74         if (value == 0) {
75             return "0";
76         }
77         uint256 temp = value;
78         uint256 digits;
79         while (temp != 0) {
80             digits++;
81             temp /= 10;
82         }
83         bytes memory buffer = new bytes(digits);
84         while (value != 0) {
85             digits -= 1;
86             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
87             value /= 10;
88         }
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
94      */
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
110      */
111     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
112         bytes memory buffer = new bytes(2 * length + 2);
113         buffer[0] = "0";
114         buffer[1] = "x";
115         for (uint256 i = 2 * length + 1; i > 1; --i) {
116             buffer[i] = _HEX_SYMBOLS[value & 0xf];
117             value >>= 4;
118         }
119         require(value == 0, "Strings: hex length insufficient");
120         return string(buffer);
121     }
122 }
123 
124 // File: @openzeppelin/contracts/utils/Context.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Provides information about the current execution context, including the
133  * sender of the transaction and its data. While these are generally available
134  * via msg.sender and msg.data, they should not be accessed in such a direct
135  * manner, since when dealing with meta-transactions the account sending and
136  * paying for execution may not be the actual sender (as far as an application
137  * is concerned).
138  *
139  * This contract is only required for intermediate, library-like contracts.
140  */
141 abstract contract Context {
142     function _msgSender() internal view virtual returns (address) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view virtual returns (bytes calldata) {
147         return msg.data;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/access/Ownable.sol
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 
159 /**
160  * @dev Contract module which provides a basic access control mechanism, where
161  * there is an account (an owner) that can be granted exclusive access to
162  * specific functions.
163  *
164  * By default, the owner account will be the one that deploys the contract. This
165  * can later be changed with {transferOwnership}.
166  *
167  * This module is used through inheritance. It will make available the modifier
168  * `onlyOwner`, which can be applied to your functions to restrict their use to
169  * the owner.
170  */
171 abstract contract Ownable is Context {
172     address private _owner;
173 
174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
175 
176     /**
177      * @dev Initializes the contract setting the deployer as the initial owner.
178      */
179     constructor() {
180         _transferOwnership(_msgSender());
181     }
182 
183     /**
184      * @dev Returns the address of the current owner.
185      */
186     function owner() public view virtual returns (address) {
187         return _owner;
188     }
189 
190     /**
191      * @dev Throws if called by any account other than the owner.
192      */
193     modifier onlyOwner() {
194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
195         _;
196     }
197 
198     /**
199      * @dev Leaves the contract without owner. It will not be possible to call
200      * `onlyOwner` functions anymore. Can only be called by the current owner.
201      *
202      * NOTE: Renouncing ownership will leave the contract without an owner,
203      * thereby removing any functionality that is only available to the owner.
204      */
205     function renounceOwnership() public virtual onlyOwner {
206         _transferOwnership(address(0));
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Can only be called by the current owner.
212      */
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(newOwner != address(0), "Ownable: new owner is the zero address");
215         _transferOwnership(newOwner);
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Internal function without access restriction.
221      */
222     function _transferOwnership(address newOwner) internal virtual {
223         address oldOwner = _owner;
224         _owner = newOwner;
225         emit OwnershipTransferred(oldOwner, newOwner);
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Address.sol
230 
231 
232 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
233 
234 pragma solidity ^0.8.1;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      *
257      * [IMPORTANT]
258      * ====
259      * You shouldn't rely on `isContract` to protect against flash loan attacks!
260      *
261      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
262      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
263      * constructor.
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies on extcodesize/address.code.length, which returns 0
268         // for contracts in construction, since the code is only stored at the end
269         // of the constructor execution.
270 
271         return account.code.length > 0;
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
457 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @title ERC721 token receiver interface
463  * @dev Interface for any contract that wants to support safeTransfers
464  * from ERC721 asset contracts.
465  */
466 interface IERC721Receiver {
467     /**
468      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
469      * by `operator` from `from`, this function is called.
470      *
471      * It must return its Solidity selector to confirm the token transfer.
472      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
473      *
474      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
475      */
476     function onERC721Received(
477         address operator,
478         address from,
479         uint256 tokenId,
480         bytes calldata data
481     ) external returns (bytes4);
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev Interface of the ERC165 standard, as defined in the
493  * https://eips.ethereum.org/EIPS/eip-165[EIP].
494  *
495  * Implementers can declare support of contract interfaces, which can then be
496  * queried by others ({ERC165Checker}).
497  *
498  * For an implementation, see {ERC165}.
499  */
500 interface IERC165 {
501     /**
502      * @dev Returns true if this contract implements the interface defined by
503      * `interfaceId`. See the corresponding
504      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
505      * to learn more about how these ids are created.
506      *
507      * This function call must use less than 30 000 gas.
508      */
509     function supportsInterface(bytes4 interfaceId) external view returns (bool);
510 }
511 
512 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Implementation of the {IERC165} interface.
522  *
523  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
524  * for the additional interface id that will be supported. For example:
525  *
526  * ```solidity
527  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
529  * }
530  * ```
531  *
532  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
533  */
534 abstract contract ERC165 is IERC165 {
535     /**
536      * @dev See {IERC165-supportsInterface}.
537      */
538     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539         return interfaceId == type(IERC165).interfaceId;
540     }
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
544 
545 
546 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Required interface of an ERC721 compliant contract.
553  */
554 interface IERC721 is IERC165 {
555     /**
556      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
562      */
563     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
567      */
568     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
569 
570     /**
571      * @dev Returns the number of tokens in ``owner``'s account.
572      */
573     function balanceOf(address owner) external view returns (uint256 balance);
574 
575     /**
576      * @dev Returns the owner of the `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function ownerOf(uint256 tokenId) external view returns (address owner);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(
598         address from,
599         address to,
600         uint256 tokenId,
601         bytes calldata data
602     ) external;
603 
604     /**
605      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
606      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must exist and be owned by `from`.
613      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
615      *
616      * Emits a {Transfer} event.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId
622     ) external;
623 
624     /**
625      * @dev Transfers `tokenId` token from `from` to `to`.
626      *
627      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must be owned by `from`.
634      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
635      *
636      * Emits a {Transfer} event.
637      */
638     function transferFrom(
639         address from,
640         address to,
641         uint256 tokenId
642     ) external;
643 
644     /**
645      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
646      * The approval is cleared when the token is transferred.
647      *
648      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
649      *
650      * Requirements:
651      *
652      * - The caller must own the token or be an approved operator.
653      * - `tokenId` must exist.
654      *
655      * Emits an {Approval} event.
656      */
657     function approve(address to, uint256 tokenId) external;
658 
659     /**
660      * @dev Approve or remove `operator` as an operator for the caller.
661      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns the account approved for `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function getApproved(uint256 tokenId) external view returns (address operator);
679 
680     /**
681      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
682      *
683      * See {setApprovalForAll}
684      */
685     function isApprovedForAll(address owner, address operator) external view returns (bool);
686 }
687 
688 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
698  * @dev See https://eips.ethereum.org/EIPS/eip-721
699  */
700 interface IERC721Metadata is IERC721 {
701     /**
702      * @dev Returns the token collection name.
703      */
704     function name() external view returns (string memory);
705 
706     /**
707      * @dev Returns the token collection symbol.
708      */
709     function symbol() external view returns (string memory);
710 
711     /**
712      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
713      */
714     function tokenURI(uint256 tokenId) external view returns (string memory);
715 }
716 
717 // File: erc721a/contracts/IERC721A.sol
718 
719 
720 // ERC721A Contracts v3.3.0
721 // Creator: Chiru Labs
722 
723 pragma solidity ^0.8.4;
724 
725 
726 
727 /**
728  * @dev Interface of an ERC721A compliant contract.
729  */
730 interface IERC721A is IERC721, IERC721Metadata {
731     /**
732      * The caller must own the token or be an approved operator.
733      */
734     error ApprovalCallerNotOwnerNorApproved();
735 
736     /**
737      * The token does not exist.
738      */
739     error ApprovalQueryForNonexistentToken();
740 
741     /**
742      * The caller cannot approve to their own address.
743      */
744     error ApproveToCaller();
745 
746     /**
747      * The caller cannot approve to the current owner.
748      */
749     error ApprovalToCurrentOwner();
750 
751     /**
752      * Cannot query the balance for the zero address.
753      */
754     error BalanceQueryForZeroAddress();
755 
756     /**
757      * Cannot mint to the zero address.
758      */
759     error MintToZeroAddress();
760 
761     /**
762      * The quantity of tokens minted must be more than zero.
763      */
764     error MintZeroQuantity();
765 
766     /**
767      * The token does not exist.
768      */
769     error OwnerQueryForNonexistentToken();
770 
771     /**
772      * The caller must own the token or be an approved operator.
773      */
774     error TransferCallerNotOwnerNorApproved();
775 
776     /**
777      * The token must be owned by `from`.
778      */
779     error TransferFromIncorrectOwner();
780 
781     /**
782      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
783      */
784     error TransferToNonERC721ReceiverImplementer();
785 
786     /**
787      * Cannot transfer to the zero address.
788      */
789     error TransferToZeroAddress();
790 
791     /**
792      * The token does not exist.
793      */
794     error URIQueryForNonexistentToken();
795 
796     // Compiler will pack this into a single 256bit word.
797     struct TokenOwnership {
798         // The address of the owner.
799         address addr;
800         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
801         uint64 startTimestamp;
802         // Whether the token has been burned.
803         bool burned;
804     }
805 
806     // Compiler will pack this into a single 256bit word.
807     struct AddressData {
808         // Realistically, 2**64-1 is more than enough.
809         uint64 balance;
810         // Keeps track of mint count with minimal overhead for tokenomics.
811         uint64 numberMinted;
812         // Keeps track of burn count with minimal overhead for tokenomics.
813         uint64 numberBurned;
814         // For miscellaneous variable(s) pertaining to the address
815         // (e.g. number of whitelist mint slots used).
816         // If there are multiple variables, please pack them into a uint64.
817         uint64 aux;
818     }
819 
820     /**
821      * @dev Returns the total amount of tokens stored by the contract.
822      * 
823      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
824      */
825     function totalSupply() external view returns (uint256);
826 }
827 
828 // File: erc721a/contracts/ERC721A.sol
829 
830 
831 // ERC721A Contracts v3.3.0
832 // Creator: Chiru Labs
833 
834 pragma solidity ^0.8.4;
835 
836 
837 
838 
839 
840 
841 
842 /**
843  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
844  * the Metadata extension. Built to optimize for lower gas during batch mints.
845  *
846  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
847  *
848  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
849  *
850  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
851  */
852 contract ERC721A is Context, ERC165, IERC721A {
853     using Address for address;
854     using Strings for uint256;
855 
856     // The tokenId of the next token to be minted.
857     uint256 internal _currentIndex;
858 
859     // The number of tokens burned.
860     uint256 internal _burnCounter;
861 
862     // Token name
863     string private _name;
864 
865     // Token symbol
866     string private _symbol;
867 
868     // Mapping from token ID to ownership details
869     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
870     mapping(uint256 => TokenOwnership) internal _ownerships;
871 
872     // Mapping owner address to address data
873     mapping(address => AddressData) private _addressData;
874 
875     // Mapping from token ID to approved address
876     mapping(uint256 => address) private _tokenApprovals;
877 
878     // Mapping from owner to operator approvals
879     mapping(address => mapping(address => bool)) private _operatorApprovals;
880 
881     constructor(string memory name_, string memory symbol_) {
882         _name = name_;
883         _symbol = symbol_;
884         _currentIndex = _startTokenId();
885     }
886 
887     /**
888      * To change the starting tokenId, please override this function.
889      */
890     function _startTokenId() internal view virtual returns (uint256) {
891         return 0;
892     }
893 
894     /**
895      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
896      */
897     function totalSupply() public view override returns (uint256) {
898         // Counter underflow is impossible as _burnCounter cannot be incremented
899         // more than _currentIndex - _startTokenId() times
900         unchecked {
901             return _currentIndex - _burnCounter - _startTokenId();
902         }
903     }
904 
905     /**
906      * Returns the total amount of tokens minted in the contract.
907      */
908     function _totalMinted() internal view returns (uint256) {
909         // Counter underflow is impossible as _currentIndex does not decrement,
910         // and it is initialized to _startTokenId()
911         unchecked {
912             return _currentIndex - _startTokenId();
913         }
914     }
915 
916     /**
917      * @dev See {IERC165-supportsInterface}.
918      */
919     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
920         return
921             interfaceId == type(IERC721).interfaceId ||
922             interfaceId == type(IERC721Metadata).interfaceId ||
923             super.supportsInterface(interfaceId);
924     }
925 
926     /**
927      * @dev See {IERC721-balanceOf}.
928      */
929     function balanceOf(address owner) public view override returns (uint256) {
930         if (owner == address(0)) revert BalanceQueryForZeroAddress();
931         return uint256(_addressData[owner].balance);
932     }
933 
934     /**
935      * Returns the number of tokens minted by `owner`.
936      */
937     function _numberMinted(address owner) internal view returns (uint256) {
938         return uint256(_addressData[owner].numberMinted);
939     }
940 
941     /**
942      * Returns the number of tokens burned by or on behalf of `owner`.
943      */
944     function _numberBurned(address owner) internal view returns (uint256) {
945         return uint256(_addressData[owner].numberBurned);
946     }
947 
948     /**
949      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
950      */
951     function _getAux(address owner) internal view returns (uint64) {
952         return _addressData[owner].aux;
953     }
954 
955     /**
956      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
957      * If there are multiple variables, please pack them into a uint64.
958      */
959     function _setAux(address owner, uint64 aux) internal {
960         _addressData[owner].aux = aux;
961     }
962 
963     /**
964      * Gas spent here starts off proportional to the maximum mint batch size.
965      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
966      */
967     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
968         uint256 curr = tokenId;
969 
970         unchecked {
971             if (_startTokenId() <= curr) if (curr < _currentIndex) {
972                 TokenOwnership memory ownership = _ownerships[curr];
973                 if (!ownership.burned) {
974                     if (ownership.addr != address(0)) {
975                         return ownership;
976                     }
977                     // Invariant:
978                     // There will always be an ownership that has an address and is not burned
979                     // before an ownership that does not have an address and is not burned.
980                     // Hence, curr will not underflow.
981                     while (true) {
982                         curr--;
983                         ownership = _ownerships[curr];
984                         if (ownership.addr != address(0)) {
985                             return ownership;
986                         }
987                     }
988                 }
989             }
990         }
991         revert OwnerQueryForNonexistentToken();
992     }
993 
994     /**
995      * @dev See {IERC721-ownerOf}.
996      */
997     function ownerOf(uint256 tokenId) public view override returns (address) {
998         return _ownershipOf(tokenId).addr;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-name}.
1003      */
1004     function name() public view virtual override returns (string memory) {
1005         return _name;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-symbol}.
1010      */
1011     function symbol() public view virtual override returns (string memory) {
1012         return _symbol;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-tokenURI}.
1017      */
1018     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1019         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1020 
1021         string memory baseURI = _baseURI();
1022         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1023     }
1024 
1025     /**
1026      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1027      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1028      * by default, can be overriden in child contracts.
1029      */
1030     function _baseURI() internal view virtual returns (string memory) {
1031         return '';
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-approve}.
1036      */
1037     function approve(address to, uint256 tokenId) public override {
1038         address owner = ERC721A.ownerOf(tokenId);
1039         if (to == owner) revert ApprovalToCurrentOwner();
1040 
1041         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1042             revert ApprovalCallerNotOwnerNorApproved();
1043         }
1044 
1045         _approve(to, tokenId, owner);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-getApproved}.
1050      */
1051     function getApproved(uint256 tokenId) public view override returns (address) {
1052         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1053 
1054         return _tokenApprovals[tokenId];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-setApprovalForAll}.
1059      */
1060     function setApprovalForAll(address operator, bool approved) public virtual override {
1061         if (operator == _msgSender()) revert ApproveToCaller();
1062 
1063         _operatorApprovals[_msgSender()][operator] = approved;
1064         emit ApprovalForAll(_msgSender(), operator, approved);
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-isApprovedForAll}.
1069      */
1070     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1071         return _operatorApprovals[owner][operator];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-transferFrom}.
1076      */
1077     function transferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) public virtual override {
1082         _transfer(from, to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-safeTransferFrom}.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) public virtual override {
1093         safeTransferFrom(from, to, tokenId, '');
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-safeTransferFrom}.
1098      */
1099     function safeTransferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) public virtual override {
1105         _transfer(from, to, tokenId);
1106         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1107             revert TransferToNonERC721ReceiverImplementer();
1108         }
1109     }
1110 
1111     /**
1112      * @dev Returns whether `tokenId` exists.
1113      *
1114      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1115      *
1116      * Tokens start existing when they are minted (`_mint`),
1117      */
1118     function _exists(uint256 tokenId) internal view returns (bool) {
1119         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1120     }
1121 
1122     /**
1123      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1124      */
1125     function _safeMint(address to, uint256 quantity) internal {
1126         _safeMint(to, quantity, '');
1127     }
1128 
1129     /**
1130      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - If `to` refers to a smart contract, it must implement
1135      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1136      * - `quantity` must be greater than 0.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _safeMint(
1141         address to,
1142         uint256 quantity,
1143         bytes memory _data
1144     ) internal {
1145         uint256 startTokenId = _currentIndex;
1146         if (to == address(0)) revert MintToZeroAddress();
1147         if (quantity == 0) revert MintZeroQuantity();
1148 
1149         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1150 
1151         // Overflows are incredibly unrealistic.
1152         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1153         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1154         unchecked {
1155             _addressData[to].balance += uint64(quantity);
1156             _addressData[to].numberMinted += uint64(quantity);
1157 
1158             _ownerships[startTokenId].addr = to;
1159             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             uint256 updatedIndex = startTokenId;
1162             uint256 end = updatedIndex + quantity;
1163 
1164             if (to.isContract()) {
1165                 do {
1166                     emit Transfer(address(0), to, updatedIndex);
1167                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1168                         revert TransferToNonERC721ReceiverImplementer();
1169                     }
1170                 } while (updatedIndex < end);
1171                 // Reentrancy protection
1172                 if (_currentIndex != startTokenId) revert();
1173             } else {
1174                 do {
1175                     emit Transfer(address(0), to, updatedIndex++);
1176                 } while (updatedIndex < end);
1177             }
1178             _currentIndex = updatedIndex;
1179         }
1180         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181     }
1182 
1183     /**
1184      * @dev Mints `quantity` tokens and transfers them to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - `to` cannot be the zero address.
1189      * - `quantity` must be greater than 0.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _mint(address to, uint256 quantity) internal {
1194         uint256 startTokenId = _currentIndex;
1195         if (to == address(0)) revert MintToZeroAddress();
1196         if (quantity == 0) revert MintZeroQuantity();
1197 
1198         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1199 
1200         // Overflows are incredibly unrealistic.
1201         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1202         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1203         unchecked {
1204             _addressData[to].balance += uint64(quantity);
1205             _addressData[to].numberMinted += uint64(quantity);
1206 
1207             _ownerships[startTokenId].addr = to;
1208             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1209 
1210             uint256 updatedIndex = startTokenId;
1211             uint256 end = updatedIndex + quantity;
1212 
1213             do {
1214                 emit Transfer(address(0), to, updatedIndex++);
1215             } while (updatedIndex < end);
1216 
1217             _currentIndex = updatedIndex;
1218         }
1219         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1220     }
1221 
1222     /**
1223      * @dev Transfers `tokenId` from `from` to `to`.
1224      *
1225      * Requirements:
1226      *
1227      * - `to` cannot be the zero address.
1228      * - `tokenId` token must be owned by `from`.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _transfer(
1233         address from,
1234         address to,
1235         uint256 tokenId
1236     ) private {
1237         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1238 
1239         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1240 
1241         bool isApprovedOrOwner = (_msgSender() == from ||
1242             isApprovedForAll(from, _msgSender()) ||
1243             getApproved(tokenId) == _msgSender());
1244 
1245         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1246         if (to == address(0)) revert TransferToZeroAddress();
1247 
1248         _beforeTokenTransfers(from, to, tokenId, 1);
1249 
1250         // Clear approvals from the previous owner
1251         _approve(address(0), tokenId, from);
1252 
1253         // Underflow of the sender's balance is impossible because we check for
1254         // ownership above and the recipient's balance can't realistically overflow.
1255         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1256         unchecked {
1257             _addressData[from].balance -= 1;
1258             _addressData[to].balance += 1;
1259 
1260             TokenOwnership storage currSlot = _ownerships[tokenId];
1261             currSlot.addr = to;
1262             currSlot.startTimestamp = uint64(block.timestamp);
1263 
1264             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1265             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1266             uint256 nextTokenId = tokenId + 1;
1267             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1268             if (nextSlot.addr == address(0)) {
1269                 // This will suffice for checking _exists(nextTokenId),
1270                 // as a burned slot cannot contain the zero address.
1271                 if (nextTokenId != _currentIndex) {
1272                     nextSlot.addr = from;
1273                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1274                 }
1275             }
1276         }
1277 
1278         emit Transfer(from, to, tokenId);
1279         _afterTokenTransfers(from, to, tokenId, 1);
1280     }
1281 
1282     /**
1283      * @dev Equivalent to `_burn(tokenId, false)`.
1284      */
1285     function _burn(uint256 tokenId) internal virtual {
1286         _burn(tokenId, false);
1287     }
1288 
1289     /**
1290      * @dev Destroys `tokenId`.
1291      * The approval is cleared when the token is burned.
1292      *
1293      * Requirements:
1294      *
1295      * - `tokenId` must exist.
1296      *
1297      * Emits a {Transfer} event.
1298      */
1299     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1300         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1301 
1302         address from = prevOwnership.addr;
1303 
1304         if (approvalCheck) {
1305             bool isApprovedOrOwner = (_msgSender() == from ||
1306                 isApprovedForAll(from, _msgSender()) ||
1307                 getApproved(tokenId) == _msgSender());
1308 
1309             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1310         }
1311 
1312         _beforeTokenTransfers(from, address(0), tokenId, 1);
1313 
1314         // Clear approvals from the previous owner
1315         _approve(address(0), tokenId, from);
1316 
1317         // Underflow of the sender's balance is impossible because we check for
1318         // ownership above and the recipient's balance can't realistically overflow.
1319         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1320         unchecked {
1321             AddressData storage addressData = _addressData[from];
1322             addressData.balance -= 1;
1323             addressData.numberBurned += 1;
1324 
1325             // Keep track of who burned the token, and the timestamp of burning.
1326             TokenOwnership storage currSlot = _ownerships[tokenId];
1327             currSlot.addr = from;
1328             currSlot.startTimestamp = uint64(block.timestamp);
1329             currSlot.burned = true;
1330 
1331             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1332             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1333             uint256 nextTokenId = tokenId + 1;
1334             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1335             if (nextSlot.addr == address(0)) {
1336                 // This will suffice for checking _exists(nextTokenId),
1337                 // as a burned slot cannot contain the zero address.
1338                 if (nextTokenId != _currentIndex) {
1339                     nextSlot.addr = from;
1340                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1341                 }
1342             }
1343         }
1344 
1345         emit Transfer(from, address(0), tokenId);
1346         _afterTokenTransfers(from, address(0), tokenId, 1);
1347 
1348         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1349         unchecked {
1350             _burnCounter++;
1351         }
1352     }
1353 
1354     /**
1355      * @dev Approve `to` to operate on `tokenId`
1356      *
1357      * Emits a {Approval} event.
1358      */
1359     function _approve(
1360         address to,
1361         uint256 tokenId,
1362         address owner
1363     ) private {
1364         _tokenApprovals[tokenId] = to;
1365         emit Approval(owner, to, tokenId);
1366     }
1367 
1368     /**
1369      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1370      *
1371      * @param from address representing the previous owner of the given token ID
1372      * @param to target address that will receive the tokens
1373      * @param tokenId uint256 ID of the token to be transferred
1374      * @param _data bytes optional data to send along with the call
1375      * @return bool whether the call correctly returned the expected magic value
1376      */
1377     function _checkContractOnERC721Received(
1378         address from,
1379         address to,
1380         uint256 tokenId,
1381         bytes memory _data
1382     ) private returns (bool) {
1383         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1384             return retval == IERC721Receiver(to).onERC721Received.selector;
1385         } catch (bytes memory reason) {
1386             if (reason.length == 0) {
1387                 revert TransferToNonERC721ReceiverImplementer();
1388             } else {
1389                 assembly {
1390                     revert(add(32, reason), mload(reason))
1391                 }
1392             }
1393         }
1394     }
1395 
1396     /**
1397      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1398      * And also called before burning one token.
1399      *
1400      * startTokenId - the first token id to be transferred
1401      * quantity - the amount to be transferred
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1406      * transferred to `to`.
1407      * - When `from` is zero, `tokenId` will be minted for `to`.
1408      * - When `to` is zero, `tokenId` will be burned by `from`.
1409      * - `from` and `to` are never both zero.
1410      */
1411     function _beforeTokenTransfers(
1412         address from,
1413         address to,
1414         uint256 startTokenId,
1415         uint256 quantity
1416     ) internal virtual {}
1417 
1418     /**
1419      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1420      * minting.
1421      * And also called after one token has been burned.
1422      *
1423      * startTokenId - the first token id to be transferred
1424      * quantity - the amount to be transferred
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` has been minted for `to`.
1431      * - When `to` is zero, `tokenId` has been burned by `from`.
1432      * - `from` and `to` are never both zero.
1433      */
1434     function _afterTokenTransfers(
1435         address from,
1436         address to,
1437         uint256 startTokenId,
1438         uint256 quantity
1439     ) internal virtual {}
1440 }
1441 
1442 // File: contracts/OkayDoodleDegens.sol
1443 
1444 pragma solidity >=0.8.9 <0.9.0;
1445 
1446 
1447 
1448 
1449 contract OkayDoodleDegens is ERC721A, Ownable, ReentrancyGuard {
1450     using Strings for uint256;
1451 
1452     string public uriPrefix = 'ipfs://QmfWUPgFGsDEtTEFnSxsEFvpQNWrwyoHxdK8ZqxyeBSg2G/';
1453     uint256 public price = 0.002 ether;
1454     uint256 public maxPerTx = 5;
1455     uint256 public totalFree = 1000; //first 1000 free
1456     uint256 public maxSupply = 3333;
1457     uint256 public maxPerWallet = 5; //will be changed to 100 after first 1000 minted
1458     bool public paused = true;
1459 
1460     constructor() ERC721A("Okay Doodle Degens", "ODD") {
1461     }
1462 
1463     function mint(uint256 _mintAmount) external payable {
1464         uint256 cost = price;
1465         if (totalSupply() + _mintAmount < totalFree + 1) {
1466             cost = 0;
1467         }
1468 
1469         require(msg.value >= _mintAmount * cost, "Not enough ETH.");
1470         require(totalSupply() + _mintAmount < maxSupply + 1, "No more Okay Doodle Degens");
1471         require(!paused, "Minting is not live yet, hold on Okay Doodle Degens.");
1472         require(_mintAmount < maxPerTx + 1, "Max per TX reached.");
1473         require(
1474             _numberMinted(msg.sender) + _mintAmount <= maxPerWallet,
1475             "Too many per wallet!"
1476         );
1477 
1478         _safeMint(msg.sender, _mintAmount);
1479     }
1480 
1481     function _baseURI() internal view virtual override returns (string memory) {
1482         return uriPrefix;
1483     }
1484 
1485   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1486     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1487 
1488     string memory currentBaseURI = _baseURI();
1489     return bytes(currentBaseURI).length > 0
1490         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1491         : '';
1492   }
1493 
1494     function setFreeAmount(uint256 amount) external onlyOwner {
1495         totalFree = amount;
1496     }
1497 
1498     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1499         maxPerWallet = _maxPerWallet;
1500     }
1501     
1502     function setMaxPerTx(uint256 _maxPerTx) public onlyOwner {
1503         maxPerTx = _maxPerTx;
1504     }
1505 
1506     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1507         maxSupply = _maxSupply;
1508     }
1509 
1510     function ownerAirdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1511         _safeMint(_receiver, _mintAmount);
1512     }
1513 
1514 
1515     function setPrice(uint256 _newPrice) external onlyOwner {
1516         price = _newPrice;
1517     }
1518 
1519     function setPaused(bool _state) public onlyOwner {
1520         paused = _state;
1521     }
1522     
1523     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1524         uriPrefix = _uriPrefix;
1525     }
1526 
1527     function _startTokenId() internal view virtual override returns (uint256) {
1528         return 1;
1529     }
1530 
1531     function withdraw() public onlyOwner nonReentrant {
1532 
1533       (bool hs, ) = payable(0x49Ba7bdDb1d1037532c5f9499c687DacD45f1Fe5).call{value: address(this).balance * 20 / 100}('');
1534       require(hs);
1535       (bool ts, ) = payable(0xa95995c4F283028231B573844035e7D7e014d1eF).call{value: address(this).balance * 25 / 100}('');
1536       require(ts);
1537       (bool rs, ) = payable(0x42b97924aAFFc0dB1EBE612bEfc3E81247991cB4).call{value: address(this).balance * 33 / 100}('');
1538       require(rs);
1539       (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1540       require(os);
1541   }
1542 }