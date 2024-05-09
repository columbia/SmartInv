1 // File: Ningen.sol
2 
3 //SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 abstract contract ReentrancyGuard {
8   
9     uint256 private constant _NOT_ENTERED = 1;
10     uint256 private constant _ENTERED = 2;
11 
12     uint256 private _status;
13 
14     constructor() {
15         _status = _NOT_ENTERED;
16     }
17 
18     /**
19      * @dev Prevents a contract from calling itself, directly or indirectly.
20      * Calling a `nonReentrant` function from another `nonReentrant`
21      * function is not supported. It is possible to prevent this from happening
22      * by making the `nonReentrant` function external, and making it call a
23      * `private` function that does the actual work.
24      */
25     modifier nonReentrant() {
26         // On the first call to nonReentrant, _notEntered will be true
27         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
28 
29         // Any calls to nonReentrant after this point will fail
30         _status = _ENTERED;
31 
32         _;
33 
34         // By storing the original value once again, a refund is triggered (see
35         // https://eips.ethereum.org/EIPS/eip-2200)
36         _status = _NOT_ENTERED;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/utils/Strings.sol
41 
42 
43 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @dev String operations.
49  */
50 library Strings {
51     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
55      */
56     function toString(uint256 value) internal pure returns (string memory) {
57         // Inspired by OraclizeAPI's implementation - MIT licence
58         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
59 
60         if (value == 0) {
61             return "0";
62         }
63         uint256 temp = value;
64         uint256 digits;
65         while (temp != 0) {
66             digits++;
67             temp /= 10;
68         }
69         bytes memory buffer = new bytes(digits);
70         while (value != 0) {
71             digits -= 1;
72             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
73             value /= 10;
74         }
75         return string(buffer);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
80      */
81     function toHexString(uint256 value) internal pure returns (string memory) {
82         if (value == 0) {
83             return "0x00";
84         }
85         uint256 temp = value;
86         uint256 length = 0;
87         while (temp != 0) {
88             length++;
89             temp >>= 8;
90         }
91         return toHexString(value, length);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
96      */
97     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
98         bytes memory buffer = new bytes(2 * length + 2);
99         buffer[0] = "0";
100         buffer[1] = "x";
101         for (uint256 i = 2 * length + 1; i > 1; --i) {
102             buffer[i] = _HEX_SYMBOLS[value & 0xf];
103             value >>= 4;
104         }
105         require(value == 0, "Strings: hex length insufficient");
106         return string(buffer);
107     }
108 }
109 
110 // File: @openzeppelin/contracts/utils/Context.sol
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/access/Ownable.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 
145 /**
146  * @dev Contract module which provides a basic access control mechanism, where
147  * there is an account (an owner) that can be granted exclusive access to
148  * specific functions.
149  *
150  * By default, the owner account will be the one that deploys the contract. This
151  * can later be changed with {transferOwnership}.
152  *
153  * This module is used through inheritance. It will make available the modifier
154  * `onlyOwner`, which can be applied to your functions to restrict their use to
155  * the owner.
156  */
157 abstract contract Ownable is Context {
158     address private _owner;
159 
160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162     /**
163      * @dev Initializes the contract setting the deployer as the initial owner.
164      */
165     constructor() {
166         _transferOwnership(_msgSender());
167     }
168 
169     /**
170      * @dev Returns the address of the current owner.
171      */
172     function owner() public view virtual returns (address) {
173         return _owner;
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         require(owner() == _msgSender(), "Ownable: caller is not the owner");
181         _;
182     }
183 
184     /**
185      * @dev Leaves the contract without owner. It will not be possible to call
186      * `onlyOwner` functions anymore. Can only be called by the current owner.
187      *
188      * NOTE: Renouncing ownership will leave the contract without an owner,
189      * thereby removing any functionality that is only available to the owner.
190      */
191     function renounceOwnership() public virtual onlyOwner {
192         _transferOwnership(address(0));
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         require(newOwner != address(0), "Ownable: new owner is the zero address");
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Internal function without access restriction.
207      */
208     function _transferOwnership(address newOwner) internal virtual {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Address.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
219 
220 pragma solidity ^0.8.1;
221 
222 /**
223  * @dev Collection of functions related to the address type
224  */
225 library Address {
226     /**
227      * @dev Returns true if `account` is a contract.
228      *
229      * [IMPORTANT]
230      * ====
231      * It is unsafe to assume that an address for which this function returns
232      * false is an externally-owned account (EOA) and not a contract.
233      *
234      * Among others, `isContract` will return false for the following
235      * types of addresses:
236      *
237      *  - an externally-owned account
238      *  - a contract in construction
239      *  - an address where a contract will be created
240      *  - an address where a contract lived, but was destroyed
241      * ====
242      *
243      * [IMPORTANT]
244      * ====
245      * You shouldn't rely on `isContract` to protect against flash loan attacks!
246      *
247      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
248      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
249      * constructor.
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize/address.code.length, which returns 0
254         // for contracts in construction, since the code is only stored at the end
255         // of the constructor execution.
256 
257         return account.code.length > 0;
258     }
259 
260     /**
261      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262      * `recipient`, forwarding all available gas and reverting on errors.
263      *
264      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265      * of certain opcodes, possibly making contracts go over the 2300 gas limit
266      * imposed by `transfer`, making them unable to receive funds via
267      * `transfer`. {sendValue} removes this limitation.
268      *
269      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270      *
271      * IMPORTANT: because control is transferred to `recipient`, care must be
272      * taken to not create reentrancy vulnerabilities. Consider using
273      * {ReentrancyGuard} or the
274      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275      */
276     function sendValue(address payable recipient, uint256 amount) internal {
277         require(address(this).balance >= amount, "Address: insufficient balance");
278 
279         (bool success, ) = recipient.call{value: amount}("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain `call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, 0, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but also transferring `value` wei to `target`.
322      *
323      * Requirements:
324      *
325      * - the calling contract must have an ETH balance of at least `value`.
326      * - the called Solidity function must be `payable`.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         require(isContract(target), "Address: call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.call{value: value}(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
364         return functionStaticCall(target, data, "Address: low-level static call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.staticcall(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(isContract(target), "Address: delegate call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.delegatecall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
413      * revert reason using the provided one.
414      *
415      * _Available since v4.3._
416      */
417     function verifyCallResult(
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal pure returns (bytes memory) {
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
441 
442 
443 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @title ERC721 token receiver interface
449  * @dev Interface for any contract that wants to support safeTransfers
450  * from ERC721 asset contracts.
451  */
452 interface IERC721Receiver {
453     /**
454      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
455      * by `operator` from `from`, this function is called.
456      *
457      * It must return its Solidity selector to confirm the token transfer.
458      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
459      *
460      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
461      */
462     function onERC721Received(
463         address operator,
464         address from,
465         uint256 tokenId,
466         bytes calldata data
467     ) external returns (bytes4);
468 }
469 
470 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Interface of the ERC165 standard, as defined in the
479  * https://eips.ethereum.org/EIPS/eip-165[EIP].
480  *
481  * Implementers can declare support of contract interfaces, which can then be
482  * queried by others ({ERC165Checker}).
483  *
484  * For an implementation, see {ERC165}.
485  */
486 interface IERC165 {
487     /**
488      * @dev Returns true if this contract implements the interface defined by
489      * `interfaceId`. See the corresponding
490      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
491      * to learn more about how these ids are created.
492      *
493      * This function call must use less than 30 000 gas.
494      */
495     function supportsInterface(bytes4 interfaceId) external view returns (bool);
496 }
497 
498 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev Implementation of the {IERC165} interface.
508  *
509  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
510  * for the additional interface id that will be supported. For example:
511  *
512  * ```solidity
513  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
515  * }
516  * ```
517  *
518  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
519  */
520 abstract contract ERC165 is IERC165 {
521     /**
522      * @dev See {IERC165-supportsInterface}.
523      */
524     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525         return interfaceId == type(IERC165).interfaceId;
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
530 
531 
532 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @dev Required interface of an ERC721 compliant contract.
539  */
540 interface IERC721 is IERC165 {
541     /**
542      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
543      */
544     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
545 
546     /**
547      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
548      */
549     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
550 
551     /**
552      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
553      */
554     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
555 
556     /**
557      * @dev Returns the number of tokens in ``owner``'s account.
558      */
559     function balanceOf(address owner) external view returns (uint256 balance);
560 
561     /**
562      * @dev Returns the owner of the `tokenId` token.
563      *
564      * Requirements:
565      *
566      * - `tokenId` must exist.
567      */
568     function ownerOf(uint256 tokenId) external view returns (address owner);
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId,
587         bytes calldata data
588     ) external;
589 
590     /**
591      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
592      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must exist and be owned by `from`.
599      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
600      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
601      *
602      * Emits a {Transfer} event.
603      */
604     function safeTransferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) external;
609 
610     /**
611      * @dev Transfers `tokenId` token from `from` to `to`.
612      *
613      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      *
622      * Emits a {Transfer} event.
623      */
624     function transferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external;
629 
630     /**
631      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
632      * The approval is cleared when the token is transferred.
633      *
634      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
635      *
636      * Requirements:
637      *
638      * - The caller must own the token or be an approved operator.
639      * - `tokenId` must exist.
640      *
641      * Emits an {Approval} event.
642      */
643     function approve(address to, uint256 tokenId) external;
644 
645     /**
646      * @dev Approve or remove `operator` as an operator for the caller.
647      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
648      *
649      * Requirements:
650      *
651      * - The `operator` cannot be the caller.
652      *
653      * Emits an {ApprovalForAll} event.
654      */
655     function setApprovalForAll(address operator, bool _approved) external;
656 
657     /**
658      * @dev Returns the account approved for `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function getApproved(uint256 tokenId) external view returns (address operator);
665 
666     /**
667      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
668      *
669      * See {setApprovalForAll}
670      */
671     function isApprovedForAll(address owner, address operator) external view returns (bool);
672 }
673 
674 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 
682 /**
683  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
684  * @dev See https://eips.ethereum.org/EIPS/eip-721
685  */
686 interface IERC721Metadata is IERC721 {
687     /**
688      * @dev Returns the token collection name.
689      */
690     function name() external view returns (string memory);
691 
692     /**
693      * @dev Returns the token collection symbol.
694      */
695     function symbol() external view returns (string memory);
696 
697     /**
698      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
699      */
700     function tokenURI(uint256 tokenId) external view returns (string memory);
701 }
702 
703 // File: erc721a/contracts/IERC721A.sol
704 
705 // ERC721A Contracts v3.3.0
706 // Creator: Chiru Labs
707 
708 pragma solidity ^0.8.4;
709 
710 /**
711  * @dev Interface of an ERC721A compliant contract.
712  */
713 interface IERC721A is IERC721, IERC721Metadata {
714     /**
715      * The caller must own the token or be an approved operator.
716      */
717     error ApprovalCallerNotOwnerNorApproved();
718 
719     /**
720      * The token does not exist.
721      */
722     error ApprovalQueryForNonexistentToken();
723 
724     /**
725      * The caller cannot approve to their own address.
726      */
727     error ApproveToCaller();
728 
729     /**
730      * The caller cannot approve to the current owner.
731      */
732     error ApprovalToCurrentOwner();
733 
734     /**
735      * Cannot query the balance for the zero address.
736      */
737     error BalanceQueryForZeroAddress();
738 
739     /**
740      * Cannot mint to the zero address.
741      */
742     error MintToZeroAddress();
743 
744     /**
745      * The quantity of tokens minted must be more than zero.
746      */
747     error MintZeroQuantity();
748 
749     /**
750      * The token does not exist.
751      */
752     error OwnerQueryForNonexistentToken();
753 
754     /**
755      * The caller must own the token or be an approved operator.
756      */
757     error TransferCallerNotOwnerNorApproved();
758 
759     /**
760      * The token must be owned by `from`.
761      */
762     error TransferFromIncorrectOwner();
763 
764     /**
765      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
766      */
767     error TransferToNonERC721ReceiverImplementer();
768 
769     /**
770      * Cannot transfer to the zero address.
771      */
772     error TransferToZeroAddress();
773 
774     /**
775      * The token does not exist.
776      */
777     error URIQueryForNonexistentToken();
778 
779     // Compiler will pack this into a single 256bit word.
780     struct TokenOwnership {
781         // The address of the owner.
782         address addr;
783         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
784         uint64 startTimestamp;
785         // Whether the token has been burned.
786         bool burned;
787     }
788 
789     // Compiler will pack this into a single 256bit word.
790     struct AddressData {
791         // Realistically, 2**64-1 is more than enough.
792         uint64 balance;
793         // Keeps track of mint count with minimal overhead for tokenomics.
794         uint64 numberMinted;
795         // Keeps track of burn count with minimal overhead for tokenomics.
796         uint64 numberBurned;
797         // For miscellaneous variable(s) pertaining to the address
798         // (e.g. number of whitelist mint slots used).
799         // If there are multiple variables, please pack them into a uint64.
800         uint64 aux;
801     }
802 
803     /**
804      * @dev Returns the total amount of tokens stored by the contract.
805      * 
806      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
807      */
808     function totalSupply() external view returns (uint256);
809 }
810 
811 // File: erc721a/contracts/ERC721A.sol
812 
813 
814 // ERC721A Contracts v3.3.0
815 // Creator: Chiru Labs
816 
817 pragma solidity ^0.8.4;
818 
819 /**
820  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
821  * the Metadata extension. Built to optimize for lower gas during batch mints.
822  *
823  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
824  *
825  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
826  *
827  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
828  */
829 contract ERC721A is Context, ERC165, IERC721A {
830     using Address for address;
831     using Strings for uint256;
832 
833     // The tokenId of the next token to be minted.
834     uint256 internal _currentIndex;
835 
836     // The number of tokens burned.
837     uint256 internal _burnCounter;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to ownership details
846     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
847     mapping(uint256 => TokenOwnership) internal _ownerships;
848 
849     // Mapping owner address to address data
850     mapping(address => AddressData) private _addressData;
851 
852     // Mapping from token ID to approved address
853     mapping(uint256 => address) private _tokenApprovals;
854 
855     // Mapping from owner to operator approvals
856     mapping(address => mapping(address => bool)) private _operatorApprovals;
857 
858     constructor(string memory name_, string memory symbol_) {
859         _name = name_;
860         _symbol = symbol_;
861         _currentIndex = _startTokenId();
862     }
863 
864     /**
865      * To change the starting tokenId, please override this function.
866      */
867     function _startTokenId() internal view virtual returns (uint256) {
868         return 0;
869     }
870 
871     /**
872      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
873      */
874     function totalSupply() public view override returns (uint256) {
875         // Counter underflow is impossible as _burnCounter cannot be incremented
876         // more than _currentIndex - _startTokenId() times
877         unchecked {
878             return _currentIndex - _burnCounter - _startTokenId();
879         }
880     }
881 
882     /**
883      * Returns the total amount of tokens minted in the contract.
884      */
885     function _totalMinted() internal view returns (uint256) {
886         // Counter underflow is impossible as _currentIndex does not decrement,
887         // and it is initialized to _startTokenId()
888         unchecked {
889             return _currentIndex - _startTokenId();
890         }
891     }
892 
893     /**
894      * @dev See {IERC165-supportsInterface}.
895      */
896     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
897         return
898             interfaceId == type(IERC721).interfaceId ||
899             interfaceId == type(IERC721Metadata).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         if (owner == address(0)) revert BalanceQueryForZeroAddress();
908         return uint256(_addressData[owner].balance);
909     }
910 
911     /**
912      * Returns the number of tokens minted by `owner`.
913      */
914     function _numberMinted(address owner) internal view returns (uint256) {
915         return uint256(_addressData[owner].numberMinted);
916     }
917 
918     /**
919      * Returns the number of tokens burned by or on behalf of `owner`.
920      */
921     function _numberBurned(address owner) internal view returns (uint256) {
922         return uint256(_addressData[owner].numberBurned);
923     }
924 
925     /**
926      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
927      */
928     function _getAux(address owner) internal view returns (uint64) {
929         return _addressData[owner].aux;
930     }
931 
932     /**
933      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
934      * If there are multiple variables, please pack them into a uint64.
935      */
936     function _setAux(address owner, uint64 aux) internal {
937         _addressData[owner].aux = aux;
938     }
939 
940     /**
941      * Gas spent here starts off proportional to the maximum mint batch size.
942      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
943      */
944     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
945         uint256 curr = tokenId;
946 
947         unchecked {
948             if (_startTokenId() <= curr) if (curr < _currentIndex) {
949                 TokenOwnership memory ownership = _ownerships[curr];
950                 if (!ownership.burned) {
951                     if (ownership.addr != address(0)) {
952                         return ownership;
953                     }
954                     // Invariant:
955                     // There will always be an ownership that has an address and is not burned
956                     // before an ownership that does not have an address and is not burned.
957                     // Hence, curr will not underflow.
958                     while (true) {
959                         curr--;
960                         ownership = _ownerships[curr];
961                         if (ownership.addr != address(0)) {
962                             return ownership;
963                         }
964                     }
965                 }
966             }
967         }
968         revert OwnerQueryForNonexistentToken();
969     }
970 
971     /**
972      * @dev See {IERC721-ownerOf}.
973      */
974     function ownerOf(uint256 tokenId) public view override returns (address) {
975         return _ownershipOf(tokenId).addr;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-name}.
980      */
981     function name() public view virtual override returns (string memory) {
982         return _name;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-symbol}.
987      */
988     function symbol() public view virtual override returns (string memory) {
989         return _symbol;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-tokenURI}.
994      */
995     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
996         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
997 
998         string memory baseURI = _baseURI();
999         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1000     }
1001 
1002     /**
1003      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1004      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1005      * by default, can be overriden in child contracts.
1006      */
1007     function _baseURI() internal view virtual returns (string memory) {
1008         return '';
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-approve}.
1013      */
1014     function approve(address to, uint256 tokenId) public override {
1015         address owner = ERC721A.ownerOf(tokenId);
1016         if (to == owner) revert ApprovalToCurrentOwner();
1017 
1018         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1019             revert ApprovalCallerNotOwnerNorApproved();
1020         }
1021 
1022         _approve(to, tokenId, owner);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-getApproved}.
1027      */
1028     function getApproved(uint256 tokenId) public view override returns (address) {
1029         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1030 
1031         return _tokenApprovals[tokenId];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-setApprovalForAll}.
1036      */
1037     function setApprovalForAll(address operator, bool approved) public virtual override {
1038         if (operator == _msgSender()) revert ApproveToCaller();
1039 
1040         _operatorApprovals[_msgSender()][operator] = approved;
1041         emit ApprovalForAll(_msgSender(), operator, approved);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-isApprovedForAll}.
1046      */
1047     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1048         return _operatorApprovals[owner][operator];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-transferFrom}.
1053      */
1054     function transferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public virtual override {
1059         _transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) public virtual override {
1070         safeTransferFrom(from, to, tokenId, '');
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) public virtual override {
1082         _transfer(from, to, tokenId);
1083         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1084             revert TransferToNonERC721ReceiverImplementer();
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns whether `tokenId` exists.
1090      *
1091      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1092      *
1093      * Tokens start existing when they are minted (`_mint`),
1094      */
1095     function _exists(uint256 tokenId) internal view returns (bool) {
1096         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1097     }
1098 
1099     /**
1100      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1101      */
1102     function _safeMint(address to, uint256 quantity) internal {
1103         _safeMint(to, quantity, '');
1104     }
1105 
1106     /**
1107      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - If `to` refers to a smart contract, it must implement
1112      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1113      * - `quantity` must be greater than 0.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _safeMint(
1118         address to,
1119         uint256 quantity,
1120         bytes memory _data
1121     ) internal {
1122         uint256 startTokenId = _currentIndex;
1123         if (to == address(0)) revert MintToZeroAddress();
1124         if (quantity == 0) revert MintZeroQuantity();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are incredibly unrealistic.
1129         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1130         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1131         unchecked {
1132             _addressData[to].balance += uint64(quantity);
1133             _addressData[to].numberMinted += uint64(quantity);
1134 
1135             _ownerships[startTokenId].addr = to;
1136             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1137 
1138             uint256 updatedIndex = startTokenId;
1139             uint256 end = updatedIndex + quantity;
1140 
1141             if (to.isContract()) {
1142                 do {
1143                     emit Transfer(address(0), to, updatedIndex);
1144                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1145                         revert TransferToNonERC721ReceiverImplementer();
1146                     }
1147                 } while (updatedIndex < end);
1148                 // Reentrancy protection
1149                 if (_currentIndex != startTokenId) revert();
1150             } else {
1151                 do {
1152                     emit Transfer(address(0), to, updatedIndex++);
1153                 } while (updatedIndex < end);
1154             }
1155             _currentIndex = updatedIndex;
1156         }
1157         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1158     }
1159 
1160     /**
1161      * @dev Mints `quantity` tokens and transfers them to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - `to` cannot be the zero address.
1166      * - `quantity` must be greater than 0.
1167      *
1168      * Emits a {Transfer} event.
1169      */
1170     function _mint(address to, uint256 quantity) internal {
1171         uint256 startTokenId = _currentIndex;
1172         if (to == address(0)) revert MintToZeroAddress();
1173         if (quantity == 0) revert MintZeroQuantity();
1174 
1175         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1176 
1177         // Overflows are incredibly unrealistic.
1178         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1179         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1180         unchecked {
1181             _addressData[to].balance += uint64(quantity);
1182             _addressData[to].numberMinted += uint64(quantity);
1183 
1184             _ownerships[startTokenId].addr = to;
1185             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1186 
1187             uint256 updatedIndex = startTokenId;
1188             uint256 end = updatedIndex + quantity;
1189 
1190             do {
1191                 emit Transfer(address(0), to, updatedIndex++);
1192             } while (updatedIndex < end);
1193 
1194             _currentIndex = updatedIndex;
1195         }
1196         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1197     }
1198 
1199     /**
1200      * @dev Transfers `tokenId` from `from` to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - `to` cannot be the zero address.
1205      * - `tokenId` token must be owned by `from`.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _transfer(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) private {
1214         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1215 
1216         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1217 
1218         bool isApprovedOrOwner = (_msgSender() == from ||
1219             isApprovedForAll(from, _msgSender()) ||
1220             getApproved(tokenId) == _msgSender());
1221 
1222         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1223         if (to == address(0)) revert TransferToZeroAddress();
1224 
1225         _beforeTokenTransfers(from, to, tokenId, 1);
1226 
1227         // Clear approvals from the previous owner
1228         _approve(address(0), tokenId, from);
1229 
1230         // Underflow of the sender's balance is impossible because we check for
1231         // ownership above and the recipient's balance can't realistically overflow.
1232         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1233         unchecked {
1234             _addressData[from].balance -= 1;
1235             _addressData[to].balance += 1;
1236 
1237             TokenOwnership storage currSlot = _ownerships[tokenId];
1238             currSlot.addr = to;
1239             currSlot.startTimestamp = uint64(block.timestamp);
1240 
1241             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1242             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1243             uint256 nextTokenId = tokenId + 1;
1244             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1245             if (nextSlot.addr == address(0)) {
1246                 // This will suffice for checking _exists(nextTokenId),
1247                 // as a burned slot cannot contain the zero address.
1248                 if (nextTokenId != _currentIndex) {
1249                     nextSlot.addr = from;
1250                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1251                 }
1252             }
1253         }
1254 
1255         emit Transfer(from, to, tokenId);
1256         _afterTokenTransfers(from, to, tokenId, 1);
1257     }
1258 
1259     /**
1260      * @dev Equivalent to `_burn(tokenId, false)`.
1261      */
1262     function _burn(uint256 tokenId) internal virtual {
1263         _burn(tokenId, false);
1264     }
1265 
1266     /**
1267      * @dev Destroys `tokenId`.
1268      * The approval is cleared when the token is burned.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1277         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1278 
1279         address from = prevOwnership.addr;
1280 
1281         if (approvalCheck) {
1282             bool isApprovedOrOwner = (_msgSender() == from ||
1283                 isApprovedForAll(from, _msgSender()) ||
1284                 getApproved(tokenId) == _msgSender());
1285 
1286             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1287         }
1288 
1289         _beforeTokenTransfers(from, address(0), tokenId, 1);
1290 
1291         // Clear approvals from the previous owner
1292         _approve(address(0), tokenId, from);
1293 
1294         // Underflow of the sender's balance is impossible because we check for
1295         // ownership above and the recipient's balance can't realistically overflow.
1296         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1297         unchecked {
1298             AddressData storage addressData = _addressData[from];
1299             addressData.balance -= 1;
1300             addressData.numberBurned += 1;
1301 
1302             // Keep track of who burned the token, and the timestamp of burning.
1303             TokenOwnership storage currSlot = _ownerships[tokenId];
1304             currSlot.addr = from;
1305             currSlot.startTimestamp = uint64(block.timestamp);
1306             currSlot.burned = true;
1307 
1308             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1309             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1310             uint256 nextTokenId = tokenId + 1;
1311             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1312             if (nextSlot.addr == address(0)) {
1313                 // This will suffice for checking _exists(nextTokenId),
1314                 // as a burned slot cannot contain the zero address.
1315                 if (nextTokenId != _currentIndex) {
1316                     nextSlot.addr = from;
1317                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1318                 }
1319             }
1320         }
1321 
1322         emit Transfer(from, address(0), tokenId);
1323         _afterTokenTransfers(from, address(0), tokenId, 1);
1324 
1325         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1326         unchecked {
1327             _burnCounter++;
1328         }
1329     }
1330 
1331     /**
1332      * @dev Approve `to` to operate on `tokenId`
1333      *
1334      * Emits a {Approval} event.
1335      */
1336     function _approve(
1337         address to,
1338         uint256 tokenId,
1339         address owner
1340     ) private {
1341         _tokenApprovals[tokenId] = to;
1342         emit Approval(owner, to, tokenId);
1343     }
1344 
1345     /**
1346      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1347      *
1348      * @param from address representing the previous owner of the given token ID
1349      * @param to target address that will receive the tokens
1350      * @param tokenId uint256 ID of the token to be transferred
1351      * @param _data bytes optional data to send along with the call
1352      * @return bool whether the call correctly returned the expected magic value
1353      */
1354     function _checkContractOnERC721Received(
1355         address from,
1356         address to,
1357         uint256 tokenId,
1358         bytes memory _data
1359     ) private returns (bool) {
1360         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1361             return retval == IERC721Receiver(to).onERC721Received.selector;
1362         } catch (bytes memory reason) {
1363             if (reason.length == 0) {
1364                 revert TransferToNonERC721ReceiverImplementer();
1365             } else {
1366                 assembly {
1367                     revert(add(32, reason), mload(reason))
1368                 }
1369             }
1370         }
1371     }
1372 
1373     /**
1374      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1375      * And also called before burning one token.
1376      *
1377      * startTokenId - the first token id to be transferred
1378      * quantity - the amount to be transferred
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` will be minted for `to`.
1385      * - When `to` is zero, `tokenId` will be burned by `from`.
1386      * - `from` and `to` are never both zero.
1387      */
1388     function _beforeTokenTransfers(
1389         address from,
1390         address to,
1391         uint256 startTokenId,
1392         uint256 quantity
1393     ) internal virtual {}
1394 
1395     /**
1396      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1397      * minting.
1398      * And also called after one token has been burned.
1399      *
1400      * startTokenId - the first token id to be transferred
1401      * quantity - the amount to be transferred
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1406      * transferred to `to`.
1407      * - When `from` is zero, `tokenId` has been minted for `to`.
1408      * - When `to` is zero, `tokenId` has been burned by `from`.
1409      * - `from` and `to` are never both zero.
1410      */
1411     function _afterTokenTransfers(
1412         address from,
1413         address to,
1414         uint256 startTokenId,
1415         uint256 quantity
1416     ) internal virtual {}
1417 }
1418 
1419 // File: contracts/Ningen.sol
1420 
1421 pragma solidity >=0.8.9 <0.9.0;
1422 
1423 contract Ningen is ERC721A, Ownable, ReentrancyGuard {
1424     using Strings for uint256;
1425     string baseURI;
1426     string public baseExtension = ".json";
1427     uint256 public price = 0.003 ether;
1428     uint256 public maxPerTx = 2;
1429     uint256 public totalFree = 100;
1430     uint256 public maxSupply = 300;
1431     uint256 public maxPerWallet = 15;
1432     bool public paused = true;
1433     
1434     constructor( string memory _initBaseURI) ERC721A("Ningen", "Ningen") { 
1435         setBaseURI(_initBaseURI);
1436         _safeMint(msg.sender, 1);
1437     }
1438 
1439     function _baseURI() internal view virtual override returns (string memory) {
1440         return baseURI;
1441     }
1442 
1443     function mint(uint256 _mintAmount) external payable {
1444         uint256 cost = price;
1445         if (totalSupply() + _mintAmount < totalFree + 1) {
1446             cost = 0;
1447         }
1448         require(msg.value >= _mintAmount * cost, "Not enough ETH.");
1449         require(totalSupply() + _mintAmount < maxSupply + 1, "Exceeds supply.");
1450         require(!paused, "Minting is not live yet.");
1451         require(_mintAmount < maxPerTx + 1, "Max per TX reached.");
1452         require(_numberMinted(msg.sender) + _mintAmount <= maxPerWallet,"Too many per wallet!");
1453         _safeMint(msg.sender, _mintAmount);
1454     }
1455 
1456     function tokenURI(uint256 tokenId)
1457         public
1458         view
1459         virtual
1460         override
1461         returns (string memory)
1462     {
1463         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1464         string memory currentBaseURI = _baseURI();
1465         return bytes(currentBaseURI).length > 0
1466             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1467             : "";
1468     }
1469 
1470     function setFreeAmount(uint256 amount) external onlyOwner {
1471         totalFree = amount;
1472     }
1473 
1474     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1475         maxPerWallet = _maxPerWallet;
1476     }
1477     
1478     function setMaxPerTx(uint256 _maxPerTx) public onlyOwner {
1479         maxPerTx = _maxPerTx;
1480     }
1481 
1482     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1483         maxSupply = _maxSupply;
1484     }
1485 
1486     function ownerAirdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1487         _safeMint(_receiver, _mintAmount);
1488     }
1489 
1490     function setPrice(uint256 _newPrice) external onlyOwner {
1491         price = _newPrice;
1492     }
1493 
1494     function setPaused() public onlyOwner {
1495         paused = !paused;
1496     }
1497 
1498     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1499         baseURI = _newBaseURI;
1500     }
1501 
1502     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1503         baseExtension = _newBaseExtension;
1504     }
1505 
1506     function _startTokenId() internal view virtual override returns (uint256) {
1507         return 1;
1508     }
1509 
1510     function withdraw() external onlyOwner {
1511         uint256 balance = address(this).balance;
1512         (bool success, ) = _msgSender().call{value: balance}("");
1513         require(success, "Failed to send");
1514     }      
1515 }