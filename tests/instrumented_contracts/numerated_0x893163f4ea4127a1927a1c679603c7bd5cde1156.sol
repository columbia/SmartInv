1 // File: Guardian Cat God.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 
9 abstract contract ReentrancyGuard {
10     // Booleans are more expensive than uint256 or any type that takes up a full
11     // word because each write operation emits an extra SLOAD to first read the
12     // slot's contents, replace the bits taken up by the boolean, and then write
13     // back. This is the compiler's defense against contract upgrades and
14     // pointer aliasing, and it cannot be disabled.
15 
16     // The values being non-zero value makes deployment a bit more expensive,
17     // but in exchange the refund on every call to nonReentrant will be lower in
18     // amount. Since refunds are capped to a percentage of the total
19     // transaction's gas, it is best to keep them low in cases like this one, to
20     // increase the likelihood of the full refund coming into effect.
21     uint256 private constant _NOT_ENTERED = 1;
22     uint256 private constant _ENTERED = 2;
23 
24     uint256 private _status;
25 
26     constructor() {
27         _status = _NOT_ENTERED;
28     }
29 
30     /**
31      * @dev Prevents a contract from calling itself, directly or indirectly.
32      * Calling a `nonReentrant` function from another `nonReentrant`
33      * function is not supported. It is possible to prevent this from happening
34      * by making the `nonReentrant` function external, and making it call a
35      * `private` function that does the actual work.
36      */
37     modifier nonReentrant() {
38         // On the first call to nonReentrant, _notEntered will be true
39         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
40 
41         // Any calls to nonReentrant after this point will fail
42         _status = _ENTERED;
43 
44         _;
45 
46         // By storing the original value once again, a refund is triggered (see
47         // https://eips.ethereum.org/EIPS/eip-2200)
48         _status = _NOT_ENTERED;
49     }
50 }
51 
52 // File: @openzeppelin/contracts/utils/Strings.sol
53 
54 
55 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
56 
57 pragma solidity ^0.8.0;
58 
59 /**
60  * @dev String operations.
61  */
62 library Strings {
63     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
67      */
68     function toString(uint256 value) internal pure returns (string memory) {
69         // Inspired by OraclizeAPI's implementation - MIT licence
70         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
71 
72         if (value == 0) {
73             return "0";
74         }
75         uint256 temp = value;
76         uint256 digits;
77         while (temp != 0) {
78             digits++;
79             temp /= 10;
80         }
81         bytes memory buffer = new bytes(digits);
82         while (value != 0) {
83             digits -= 1;
84             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
85             value /= 10;
86         }
87         return string(buffer);
88     }
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
92      */
93     function toHexString(uint256 value) internal pure returns (string memory) {
94         if (value == 0) {
95             return "0x00";
96         }
97         uint256 temp = value;
98         uint256 length = 0;
99         while (temp != 0) {
100             length++;
101             temp >>= 8;
102         }
103         return toHexString(value, length);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
108      */
109     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
110         bytes memory buffer = new bytes(2 * length + 2);
111         buffer[0] = "0";
112         buffer[1] = "x";
113         for (uint256 i = 2 * length + 1; i > 1; --i) {
114             buffer[i] = _HEX_SYMBOLS[value & 0xf];
115             value >>= 4;
116         }
117         require(value == 0, "Strings: hex length insufficient");
118         return string(buffer);
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Context.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes calldata) {
145         return msg.data;
146     }
147 }
148 
149 // File: @openzeppelin/contracts/access/Ownable.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 
157 /**
158  * @dev Contract module which provides a basic access control mechanism, where
159  * there is an account (an owner) that can be granted exclusive access to
160  * specific functions.
161  *
162  * By default, the owner account will be the one that deploys the contract. This
163  * can later be changed with {transferOwnership}.
164  *
165  * This module is used through inheritance. It will make available the modifier
166  * `onlyOwner`, which can be applied to your functions to restrict their use to
167  * the owner.
168  */
169 abstract contract Ownable is Context {
170     address private _owner;
171 
172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174     /**
175      * @dev Initializes the contract setting the deployer as the initial owner.
176      */
177     constructor() {
178         _transferOwnership(_msgSender());
179     }
180 
181     /**
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view virtual returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(owner() == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public virtual onlyOwner {
204         _transferOwnership(address(0));
205     }
206 
207     /**
208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
209      * Can only be called by the current owner.
210      */
211     function transferOwnership(address newOwner) public virtual onlyOwner {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         _transferOwnership(newOwner);
214     }
215 
216     /**
217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
218      * Internal function without access restriction.
219      */
220     function _transferOwnership(address newOwner) internal virtual {
221         address oldOwner = _owner;
222         _owner = newOwner;
223         emit OwnershipTransferred(oldOwner, newOwner);
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/Address.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
231 
232 pragma solidity ^0.8.1;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      *
255      * [IMPORTANT]
256      * ====
257      * You shouldn't rely on `isContract` to protect against flash loan attacks!
258      *
259      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
260      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
261      * constructor.
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize/address.code.length, which returns 0
266         // for contracts in construction, since the code is only stored at the end
267         // of the constructor execution.
268 
269         return account.code.length > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @title ERC721 token receiver interface
461  * @dev Interface for any contract that wants to support safeTransfers
462  * from ERC721 asset contracts.
463  */
464 interface IERC721Receiver {
465     /**
466      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
467      * by `operator` from `from`, this function is called.
468      *
469      * It must return its Solidity selector to confirm the token transfer.
470      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
471      *
472      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
473      */
474     function onERC721Received(
475         address operator,
476         address from,
477         uint256 tokenId,
478         bytes calldata data
479     ) external returns (bytes4);
480 }
481 
482 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
513 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Implementation of the {IERC165} interface.
520  *
521  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
522  * for the additional interface id that will be supported. For example:
523  *
524  * ```solidity
525  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
527  * }
528  * ```
529  *
530  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
531  */
532 abstract contract ERC165 is IERC165 {
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         return interfaceId == type(IERC165).interfaceId;
538     }
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev Required interface of an ERC721 compliant contract.
551  */
552 interface IERC721 is IERC165 {
553     /**
554      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
555      */
556     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
560      */
561     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
565      */
566     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
567 
568     /**
569      * @dev Returns the number of tokens in ``owner``'s account.
570      */
571     function balanceOf(address owner) external view returns (uint256 balance);
572 
573     /**
574      * @dev Returns the owner of the `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function ownerOf(uint256 tokenId) external view returns (address owner);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
584      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Transfers `tokenId` token from `from` to `to`.
604      *
605      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
613      *
614      * Emits a {Transfer} event.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
624      * The approval is cleared when the token is transferred.
625      *
626      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
627      *
628      * Requirements:
629      *
630      * - The caller must own the token or be an approved operator.
631      * - `tokenId` must exist.
632      *
633      * Emits an {Approval} event.
634      */
635     function approve(address to, uint256 tokenId) external;
636 
637     /**
638      * @dev Returns the account approved for `tokenId` token.
639      *
640      * Requirements:
641      *
642      * - `tokenId` must exist.
643      */
644     function getApproved(uint256 tokenId) external view returns (address operator);
645 
646     /**
647      * @dev Approve or remove `operator` as an operator for the caller.
648      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
649      *
650      * Requirements:
651      *
652      * - The `operator` cannot be the caller.
653      *
654      * Emits an {ApprovalForAll} event.
655      */
656     function setApprovalForAll(address operator, bool _approved) external;
657 
658     /**
659      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
660      *
661      * See {setApprovalForAll}
662      */
663     function isApprovedForAll(address owner, address operator) external view returns (bool);
664 
665     /**
666      * @dev Safely transfers `tokenId` token from `from` to `to`.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must exist and be owned by `from`.
673      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
675      *
676      * Emits a {Transfer} event.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId,
682         bytes calldata data
683     ) external;
684 }
685 
686 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
696  * @dev See https://eips.ethereum.org/EIPS/eip-721
697  */
698 interface IERC721Metadata is IERC721 {
699     /**
700      * @dev Returns the token collection name.
701      */
702     function name() external view returns (string memory);
703 
704     /**
705      * @dev Returns the token collection symbol.
706      */
707     function symbol() external view returns (string memory);
708 
709     /**
710      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
711      */
712     function tokenURI(uint256 tokenId) external view returns (string memory);
713 }
714 
715 // File: contracts/ERC721A.sol
716 
717 
718 // Creator: Chiru Labs
719 
720 pragma solidity ^0.8.4;
721 
722 
723 
724 
725 
726 
727 
728 
729 error ApprovalCallerNotOwnerNorApproved();
730 error ApprovalQueryForNonexistentToken();
731 error ApproveToCaller();
732 error ApprovalToCurrentOwner();
733 error BalanceQueryForZeroAddress();
734 error MintToZeroAddress();
735 error MintZeroQuantity();
736 error OwnerQueryForNonexistentToken();
737 error TransferCallerNotOwnerNorApproved();
738 error TransferFromIncorrectOwner();
739 error TransferToNonERC721ReceiverImplementer();
740 error TransferToZeroAddress();
741 error URIQueryForNonexistentToken();
742 
743 /**
744  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
745  * the Metadata extension. Built to optimize for lower gas during batch mints.
746  *
747  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
748  *
749  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
750  *
751  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
752  */
753 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
754     using Address for address;
755     using Strings for uint256;
756 
757     // Compiler will pack this into a single 256bit word.
758     struct TokenOwnership {
759         // The address of the owner.
760         address addr;
761         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
762         uint64 startTimestamp;
763         // Whether the token has been burned.
764         bool burned;
765     }
766 
767     // Compiler will pack this into a single 256bit word.
768     struct AddressData {
769         // Realistically, 2**64-1 is more than enough.
770         uint64 balance;
771         // Keeps track of mint count with minimal overhead for tokenomics.
772         uint64 numberMinted;
773         // Keeps track of burn count with minimal overhead for tokenomics.
774         uint64 numberBurned;
775         // For miscellaneous variable(s) pertaining to the address
776         // (e.g. number of whitelist mint slots used).
777         // If there are multiple variables, please pack them into a uint64.
778         uint64 aux;
779     }
780 
781     // The tokenId of the next token to be minted.
782     uint256 internal _currentIndex;
783 
784     // The number of tokens burned.
785     uint256 internal _burnCounter;
786 
787     // Token name
788     string private _name;
789 
790     // Token symbol
791     string private _symbol;
792 
793     // Mapping from token ID to ownership details
794     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
795     mapping(uint256 => TokenOwnership) internal _ownerships;
796 
797     // Mapping owner address to address data
798     mapping(address => AddressData) private _addressData;
799 
800     // Mapping from token ID to approved address
801     mapping(uint256 => address) private _tokenApprovals;
802 
803     // Mapping from owner to operator approvals
804     mapping(address => mapping(address => bool)) private _operatorApprovals;
805 
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809         _currentIndex = _startTokenId();
810     }
811 
812     /**
813      * To change the starting tokenId, please override this function.
814      */
815     function _startTokenId() internal view virtual returns (uint256) {
816         return 1;
817     }
818 
819     /**
820      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
821      */
822     function totalSupply() public view returns (uint256) {
823         // Counter underflow is impossible as _burnCounter cannot be incremented
824         // more than _currentIndex - _startTokenId() times
825         unchecked {
826             return _currentIndex - _burnCounter - _startTokenId();
827         }
828     }
829 
830     /**
831      * Returns the total amount of tokens minted in the contract.
832      */
833     function _totalMinted() internal view returns (uint256) {
834         // Counter underflow is impossible as _currentIndex does not decrement,
835         // and it is initialized to _startTokenId()
836         unchecked {
837             return _currentIndex - _startTokenId();
838         }
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
845         return
846             interfaceId == type(IERC721).interfaceId ||
847             interfaceId == type(IERC721Metadata).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854     function balanceOf(address owner) public view override returns (uint256) {
855         if (owner == address(0)) revert BalanceQueryForZeroAddress();
856         return uint256(_addressData[owner].balance);
857     }
858 
859     /**
860      * Returns the number of tokens minted by `owner`.
861      */
862     function _numberMinted(address owner) internal view returns (uint256) {
863         return uint256(_addressData[owner].numberMinted);
864     }
865 
866     /**
867      * Returns the number of tokens burned by or on behalf of `owner`.
868      */
869     function _numberBurned(address owner) internal view returns (uint256) {
870         return uint256(_addressData[owner].numberBurned);
871     }
872 
873     /**
874      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
875      */
876     function _getAux(address owner) internal view returns (uint64) {
877         return _addressData[owner].aux;
878     }
879 
880     /**
881      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
882      * If there are multiple variables, please pack them into a uint64.
883      */
884     function _setAux(address owner, uint64 aux) internal {
885         _addressData[owner].aux = aux;
886     }
887 
888     /**
889      * Gas spent here starts off proportional to the maximum mint batch size.
890      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
891      */
892     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
893         uint256 curr = tokenId;
894 
895         unchecked {
896             if (_startTokenId() <= curr && curr < _currentIndex) {
897                 TokenOwnership memory ownership = _ownerships[curr];
898                 if (!ownership.burned) {
899                     if (ownership.addr != address(0)) {
900                         return ownership;
901                     }
902                     // Invariant:
903                     // There will always be an ownership that has an address and is not burned
904                     // before an ownership that does not have an address and is not burned.
905                     // Hence, curr will not underflow.
906                     while (true) {
907                         curr--;
908                         ownership = _ownerships[curr];
909                         if (ownership.addr != address(0)) {
910                             return ownership;
911                         }
912                     }
913                 }
914             }
915         }
916         revert OwnerQueryForNonexistentToken();
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId) public view override returns (address) {
923         return _ownershipOf(tokenId).addr;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-name}.
928      */
929     function name() public view virtual override returns (string memory) {
930         return _name;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-symbol}.
935      */
936     function symbol() public view virtual override returns (string memory) {
937         return _symbol;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
944         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
945 
946         string memory baseURI = _baseURI();
947         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
948     }
949 
950     /**
951      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
952      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
953      * by default, can be overriden in child contracts.
954      */
955     function _baseURI() internal view virtual returns (string memory) {
956         return '';
957     }
958 
959     /**
960      * @dev See {IERC721-approve}.
961      */
962     function approve(address to, uint256 tokenId) public override {
963         address owner = ERC721A.ownerOf(tokenId);
964         if (to == owner) revert ApprovalToCurrentOwner();
965 
966         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
967             revert ApprovalCallerNotOwnerNorApproved();
968         }
969 
970         _approve(to, tokenId, owner);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view override returns (address) {
977         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public virtual override {
986         if (operator == _msgSender()) revert ApproveToCaller();
987 
988         _operatorApprovals[_msgSender()][operator] = approved;
989         emit ApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         _transfer(from, to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         safeTransferFrom(from, to, tokenId, '');
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1032             revert TransferToNonERC721ReceiverImplementer();
1033         }
1034     }
1035 
1036     /**
1037      * @dev Returns whether `tokenId` exists.
1038      *
1039      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1040      *
1041      * Tokens start existing when they are minted (`_mint`),
1042      */
1043     function _exists(uint256 tokenId) internal view returns (bool) {
1044         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1045     }
1046 
1047     /**
1048      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1049      */
1050     function _safeMint(address to, uint256 quantity) internal {
1051         _safeMint(to, quantity, '');
1052     }
1053 
1054     /**
1055      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - If `to` refers to a smart contract, it must implement 
1060      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1061      * - `quantity` must be greater than 0.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _safeMint(
1066         address to,
1067         uint256 quantity,
1068         bytes memory _data
1069     ) internal {
1070         uint256 startTokenId = _currentIndex;
1071         if (to == address(0)) revert MintToZeroAddress();
1072         if (quantity == 0) revert MintZeroQuantity();
1073 
1074         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1075 
1076         // Overflows are incredibly unrealistic.
1077         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1078         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1079         unchecked {
1080             _addressData[to].balance += uint64(quantity);
1081             _addressData[to].numberMinted += uint64(quantity);
1082 
1083             _ownerships[startTokenId].addr = to;
1084             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1085 
1086             uint256 updatedIndex = startTokenId;
1087             uint256 end = updatedIndex + quantity;
1088 
1089             if (to.isContract()) {
1090                 do {
1091                     emit Transfer(address(0), to, updatedIndex);
1092                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1093                         revert TransferToNonERC721ReceiverImplementer();
1094                     }
1095                 } while (updatedIndex != end);
1096                 // Reentrancy protection
1097                 if (_currentIndex != startTokenId) revert();
1098             } else {
1099                 do {
1100                     emit Transfer(address(0), to, updatedIndex++);
1101                 } while (updatedIndex != end);
1102             }
1103             _currentIndex = updatedIndex;
1104         }
1105         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1106     }
1107 
1108     /**
1109      * @dev Mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _mint(address to, uint256 quantity) internal {
1119         uint256 startTokenId = _currentIndex;
1120         if (to == address(0)) revert MintToZeroAddress();
1121         if (quantity == 0) revert MintZeroQuantity();
1122 
1123         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1124 
1125         // Overflows are incredibly unrealistic.
1126         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1127         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1128         unchecked {
1129             _addressData[to].balance += uint64(quantity);
1130             _addressData[to].numberMinted += uint64(quantity);
1131 
1132             _ownerships[startTokenId].addr = to;
1133             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1134 
1135             uint256 updatedIndex = startTokenId;
1136             uint256 end = updatedIndex + quantity;
1137 
1138             do {
1139                 emit Transfer(address(0), to, updatedIndex++);
1140             } while (updatedIndex != end);
1141 
1142             _currentIndex = updatedIndex;
1143         }
1144         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1145     }
1146 
1147     /**
1148      * @dev Transfers `tokenId` from `from` to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _transfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) private {
1162         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1163 
1164         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1165 
1166         bool isApprovedOrOwner = (_msgSender() == from ||
1167             isApprovedForAll(from, _msgSender()) ||
1168             getApproved(tokenId) == _msgSender());
1169 
1170         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1171         if (to == address(0)) revert TransferToZeroAddress();
1172 
1173         _beforeTokenTransfers(from, to, tokenId, 1);
1174 
1175         // Clear approvals from the previous owner
1176         _approve(address(0), tokenId, from);
1177 
1178         // Underflow of the sender's balance is impossible because we check for
1179         // ownership above and the recipient's balance can't realistically overflow.
1180         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1181         unchecked {
1182             _addressData[from].balance -= 1;
1183             _addressData[to].balance += 1;
1184 
1185             TokenOwnership storage currSlot = _ownerships[tokenId];
1186             currSlot.addr = to;
1187             currSlot.startTimestamp = uint64(block.timestamp);
1188 
1189             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1190             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1191             uint256 nextTokenId = tokenId + 1;
1192             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1193             if (nextSlot.addr == address(0)) {
1194                 // This will suffice for checking _exists(nextTokenId),
1195                 // as a burned slot cannot contain the zero address.
1196                 if (nextTokenId != _currentIndex) {
1197                     nextSlot.addr = from;
1198                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1199                 }
1200             }
1201         }
1202 
1203         emit Transfer(from, to, tokenId);
1204         _afterTokenTransfers(from, to, tokenId, 1);
1205     }
1206 
1207     /**
1208      * @dev Equivalent to `_burn(tokenId, false)`.
1209      */
1210     function _burn(uint256 tokenId) internal virtual {
1211         _burn(tokenId, false);
1212     }
1213 
1214     /**
1215      * @dev Destroys `tokenId`.
1216      * The approval is cleared when the token is burned.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1225         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1226 
1227         address from = prevOwnership.addr;
1228 
1229         if (approvalCheck) {
1230             bool isApprovedOrOwner = (_msgSender() == from ||
1231                 isApprovedForAll(from, _msgSender()) ||
1232                 getApproved(tokenId) == _msgSender());
1233 
1234             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1235         }
1236 
1237         _beforeTokenTransfers(from, address(0), tokenId, 1);
1238 
1239         // Clear approvals from the previous owner
1240         _approve(address(0), tokenId, from);
1241 
1242         // Underflow of the sender's balance is impossible because we check for
1243         // ownership above and the recipient's balance can't realistically overflow.
1244         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1245         unchecked {
1246             AddressData storage addressData = _addressData[from];
1247             addressData.balance -= 1;
1248             addressData.numberBurned += 1;
1249 
1250             // Keep track of who burned the token, and the timestamp of burning.
1251             TokenOwnership storage currSlot = _ownerships[tokenId];
1252             currSlot.addr = from;
1253             currSlot.startTimestamp = uint64(block.timestamp);
1254             currSlot.burned = true;
1255 
1256             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1257             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1258             uint256 nextTokenId = tokenId + 1;
1259             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1260             if (nextSlot.addr == address(0)) {
1261                 // This will suffice for checking _exists(nextTokenId),
1262                 // as a burned slot cannot contain the zero address.
1263                 if (nextTokenId != _currentIndex) {
1264                     nextSlot.addr = from;
1265                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(from, address(0), tokenId);
1271         _afterTokenTransfers(from, address(0), tokenId, 1);
1272 
1273         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1274         unchecked {
1275             _burnCounter++;
1276         }
1277     }
1278 
1279     /**
1280      * @dev Approve `to` to operate on `tokenId`
1281      *
1282      * Emits a {Approval} event.
1283      */
1284     function _approve(
1285         address to,
1286         uint256 tokenId,
1287         address owner
1288     ) private {
1289         _tokenApprovals[tokenId] = to;
1290         emit Approval(owner, to, tokenId);
1291     }
1292 
1293     /**
1294      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1295      *
1296      * @param from address representing the previous owner of the given token ID
1297      * @param to target address that will receive the tokens
1298      * @param tokenId uint256 ID of the token to be transferred
1299      * @param _data bytes optional data to send along with the call
1300      * @return bool whether the call correctly returned the expected magic value
1301      */
1302     function _checkContractOnERC721Received(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) private returns (bool) {
1308         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1309             return retval == IERC721Receiver(to).onERC721Received.selector;
1310         } catch (bytes memory reason) {
1311             if (reason.length == 0) {
1312                 revert TransferToNonERC721ReceiverImplementer();
1313             } else {
1314                 assembly {
1315                     revert(add(32, reason), mload(reason))
1316                 }
1317             }
1318         }
1319     }
1320 
1321     /**
1322      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1323      * And also called before burning one token.
1324      *
1325      * startTokenId - the first token id to be transferred
1326      * quantity - the amount to be transferred
1327      *
1328      * Calling conditions:
1329      *
1330      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1331      * transferred to `to`.
1332      * - When `from` is zero, `tokenId` will be minted for `to`.
1333      * - When `to` is zero, `tokenId` will be burned by `from`.
1334      * - `from` and `to` are never both zero.
1335      */
1336     function _beforeTokenTransfers(
1337         address from,
1338         address to,
1339         uint256 startTokenId,
1340         uint256 quantity
1341     ) internal virtual {}
1342 
1343     /**
1344      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1345      * minting.
1346      * And also called after one token has been burned.
1347      *
1348      * startTokenId - the first token id to be transferred
1349      * quantity - the amount to be transferred
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` has been minted for `to`.
1356      * - When `to` is zero, `tokenId` has been burned by `from`.
1357      * - `from` and `to` are never both zero.
1358      */
1359     function _afterTokenTransfers(
1360         address from,
1361         address to,
1362         uint256 startTokenId,
1363         uint256 quantity
1364     ) internal virtual {}
1365 }
1366 // File: contracts/GossamerGods.sol
1367 
1368 
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 
1373 
1374 
1375 
1376 contract GuardianCatGod is ERC721A, Ownable, ReentrancyGuard {
1377   using Address for address;
1378   using Strings for uint;
1379 
1380 
1381   string  public  baseTokenURI = "ipfs://QmeL9xbiiuUBp43SYi6F3Av6dcKaY1GfTEoi6ANvhqj8yj//";
1382   uint256  public  maxSupply = 800;
1383   uint256 public  MAX_MINTS_PER_TX = 5;
1384   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1385   uint256 public  NUM_FREE_MINTS = 500;
1386   uint256 public  MAX_FREE_PER_WALLET = 2;
1387   uint256 public freeNFTAlreadyMinted = 0;
1388   bool public isPublicSaleActive = true;
1389 
1390   constructor() ERC721A("Guardian Cat God", "GCG") {
1391   }
1392 
1393 
1394   function mint(uint256 numberOfTokens)
1395       external
1396       payable
1397   {
1398     require(isPublicSaleActive, "Sale is not open");
1399     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more left");
1400 
1401     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1402         require(
1403             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1404             "Incorrect ETH value sent"
1405         );
1406     } else {
1407         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1408         require(
1409             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1410             "Incorrect ETH value sent"
1411         );
1412         require(
1413             numberOfTokens <= MAX_MINTS_PER_TX,
1414             "Max mints per transaction exceeded"
1415         );
1416         } else {
1417             require(
1418                 numberOfTokens <= MAX_FREE_PER_WALLET,
1419                 "Max mints per transaction exceeded"
1420             );
1421             freeNFTAlreadyMinted += numberOfTokens;
1422         }
1423     }
1424     _safeMint(msg.sender, numberOfTokens);
1425   }
1426 
1427   function setBaseURI(string memory baseURI)
1428     public
1429     onlyOwner
1430   {
1431     baseTokenURI = baseURI;
1432   }
1433 
1434   function treasuryMint(uint quantity)
1435     public
1436     onlyOwner
1437   {
1438     require(
1439       quantity > 0,
1440       "Invalid mint amount"
1441     );
1442     require(
1443       totalSupply() + quantity <= maxSupply,
1444       "Maximum supply exceeded"
1445     );
1446     _safeMint(msg.sender, quantity);
1447   }
1448 
1449   function withdraw()
1450     public
1451     onlyOwner
1452     nonReentrant
1453   {
1454     Address.sendValue(payable(msg.sender), address(this).balance);
1455   }
1456 
1457   function tokenURI(uint _tokenId)
1458     public
1459     view
1460     virtual
1461     override
1462     returns (string memory)
1463   {
1464     require(
1465       _exists(_tokenId),
1466       "ERC721Metadata: URI query for nonexistent token"
1467     );
1468     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1469   }
1470 
1471   function _baseURI()
1472     internal
1473     view
1474     virtual
1475     override
1476     returns (string memory)
1477   {
1478     return baseTokenURI;
1479   }
1480 
1481   function setIsPublicSaleActive(bool _isPublicSaleActive)
1482       external
1483       onlyOwner
1484   {
1485       isPublicSaleActive = _isPublicSaleActive;
1486   }
1487 
1488   function setNumFreeMints(uint256 _numfreemints)
1489       external
1490       onlyOwner
1491   {
1492       NUM_FREE_MINTS = _numfreemints;
1493   }
1494 
1495   function setSalePrice(uint256 _price)
1496       external
1497       onlyOwner
1498   {
1499       PUBLIC_SALE_PRICE = _price;
1500   }
1501 
1502   function setMaxLimitPerTransaction(uint256 _limit)
1503       external
1504       onlyOwner
1505   {
1506       MAX_MINTS_PER_TX = _limit;
1507   }
1508 
1509   function setFreeLimitPerWallet(uint256 _limit)
1510       external
1511       onlyOwner
1512   {
1513       MAX_FREE_PER_WALLET = _limit;
1514   }
1515 }