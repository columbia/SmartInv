1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
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
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _transferOwnership(_msgSender());
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         _checkOwner();
143         _;
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if the sender is not the owner.
155      */
156     function _checkOwner() internal view virtual {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/security/Pausable.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Contract module which allows children to implement an emergency stop
201  * mechanism that can be triggered by an authorized account.
202  *
203  * This module is used through inheritance. It will make available the
204  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
205  * the functions of your contract. Note that they will not be pausable by
206  * simply including this module, only once the modifiers are put in place.
207  */
208 abstract contract Pausable is Context {
209     /**
210      * @dev Emitted when the pause is triggered by `account`.
211      */
212     event Paused(address account);
213 
214     /**
215      * @dev Emitted when the pause is lifted by `account`.
216      */
217     event Unpaused(address account);
218 
219     bool private _paused;
220 
221     /**
222      * @dev Initializes the contract in unpaused state.
223      */
224     constructor() {
225         _paused = false;
226     }
227 
228     /**
229      * @dev Modifier to make a function callable only when the contract is not paused.
230      *
231      * Requirements:
232      *
233      * - The contract must not be paused.
234      */
235     modifier whenNotPaused() {
236         _requireNotPaused();
237         _;
238     }
239 
240     /**
241      * @dev Modifier to make a function callable only when the contract is paused.
242      *
243      * Requirements:
244      *
245      * - The contract must be paused.
246      */
247     modifier whenPaused() {
248         _requirePaused();
249         _;
250     }
251 
252     /**
253      * @dev Returns true if the contract is paused, and false otherwise.
254      */
255     function paused() public view virtual returns (bool) {
256         return _paused;
257     }
258 
259     /**
260      * @dev Throws if the contract is paused.
261      */
262     function _requireNotPaused() internal view virtual {
263         require(!paused(), "Pausable: paused");
264     }
265 
266     /**
267      * @dev Throws if the contract is not paused.
268      */
269     function _requirePaused() internal view virtual {
270         require(paused(), "Pausable: not paused");
271     }
272 
273     /**
274      * @dev Triggers stopped state.
275      *
276      * Requirements:
277      *
278      * - The contract must not be paused.
279      */
280     function _pause() internal virtual whenNotPaused {
281         _paused = true;
282         emit Paused(_msgSender());
283     }
284 
285     /**
286      * @dev Returns to normal state.
287      *
288      * Requirements:
289      *
290      * - The contract must be paused.
291      */
292     function _unpause() internal virtual whenPaused {
293         _paused = false;
294         emit Unpaused(_msgSender());
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
302 
303 pragma solidity ^0.8.1;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      *
326      * [IMPORTANT]
327      * ====
328      * You shouldn't rely on `isContract` to protect against flash loan attacks!
329      *
330      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
331      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
332      * constructor.
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize/address.code.length, which returns 0
337         // for contracts in construction, since the code is only stored at the end
338         // of the constructor execution.
339 
340         return account.code.length > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         (bool success, ) = recipient.call{value: amount}("");
363         require(success, "Address: unable to send value, recipient may have reverted");
364     }
365 
366     /**
367      * @dev Performs a Solidity function call using a low level `call`. A
368      * plain `call` is an unsafe replacement for a function call: use this
369      * function instead.
370      *
371      * If `target` reverts with a revert reason, it is bubbled up by this
372      * function (like regular Solidity function calls).
373      *
374      * Returns the raw returned data. To convert to the expected return value,
375      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
376      *
377      * Requirements:
378      *
379      * - `target` must be a contract.
380      * - calling `target` with `data` must not revert.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionCall(target, data, "Address: low-level call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
390      * `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but also transferring `value` wei to `target`.
405      *
406      * Requirements:
407      *
408      * - the calling contract must have an ETH balance of at least `value`.
409      * - the called Solidity function must be `payable`.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value
417     ) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
423      * with `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 value,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.call{value: value}(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
447         return functionStaticCall(target, data, "Address: low-level static call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
474         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.delegatecall(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
496      * revert reason using the provided one.
497      *
498      * _Available since v4.3._
499      */
500     function verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) internal pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511                 /// @solidity memory-safe-assembly
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
524 
525 
526 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @title ERC721 token receiver interface
532  * @dev Interface for any contract that wants to support safeTransfers
533  * from ERC721 asset contracts.
534  */
535 interface IERC721Receiver {
536     /**
537      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
538      * by `operator` from `from`, this function is called.
539      *
540      * It must return its Solidity selector to confirm the token transfer.
541      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
542      *
543      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
544      */
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Interface of the ERC165 standard, as defined in the
562  * https://eips.ethereum.org/EIPS/eip-165[EIP].
563  *
564  * Implementers can declare support of contract interfaces, which can then be
565  * queried by others ({ERC165Checker}).
566  *
567  * For an implementation, see {ERC165}.
568  */
569 interface IERC165 {
570     /**
571      * @dev Returns true if this contract implements the interface defined by
572      * `interfaceId`. See the corresponding
573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
574      * to learn more about how these ids are created.
575      *
576      * This function call must use less than 30 000 gas.
577      */
578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
579 }
580 
581 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @dev Implementation of the {IERC165} interface.
591  *
592  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
593  * for the additional interface id that will be supported. For example:
594  *
595  * ```solidity
596  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
597  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
598  * }
599  * ```
600  *
601  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
602  */
603 abstract contract ERC165 is IERC165 {
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608         return interfaceId == type(IERC165).interfaceId;
609     }
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
613 
614 
615 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev Required interface of an ERC721 compliant contract.
622  */
623 interface IERC721 is IERC165 {
624     /**
625      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
626      */
627     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
628 
629     /**
630      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
631      */
632     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
633 
634     /**
635      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
636      */
637     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
638 
639     /**
640      * @dev Returns the number of tokens in ``owner``'s account.
641      */
642     function balanceOf(address owner) external view returns (uint256 balance);
643 
644     /**
645      * @dev Returns the owner of the `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function ownerOf(uint256 tokenId) external view returns (address owner);
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
663      *
664      * Emits a {Transfer} event.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes calldata data
671     ) external;
672 
673     /**
674      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
675      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must exist and be owned by `from`.
682      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) external;
692 
693     /**
694      * @dev Transfers `tokenId` token from `from` to `to`.
695      *
696      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must be owned by `from`.
703      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
704      *
705      * Emits a {Transfer} event.
706      */
707     function transferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) external;
712 
713     /**
714      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
715      * The approval is cleared when the token is transferred.
716      *
717      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
718      *
719      * Requirements:
720      *
721      * - The caller must own the token or be an approved operator.
722      * - `tokenId` must exist.
723      *
724      * Emits an {Approval} event.
725      */
726     function approve(address to, uint256 tokenId) external;
727 
728     /**
729      * @dev Approve or remove `operator` as an operator for the caller.
730      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
731      *
732      * Requirements:
733      *
734      * - The `operator` cannot be the caller.
735      *
736      * Emits an {ApprovalForAll} event.
737      */
738     function setApprovalForAll(address operator, bool _approved) external;
739 
740     /**
741      * @dev Returns the account approved for `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function getApproved(uint256 tokenId) external view returns (address operator);
748 
749     /**
750      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
751      *
752      * See {setApprovalForAll}
753      */
754     function isApprovedForAll(address owner, address operator) external view returns (bool);
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
767  * @dev See https://eips.ethereum.org/EIPS/eip-721
768  */
769 interface IERC721Metadata is IERC721 {
770     /**
771      * @dev Returns the token collection name.
772      */
773     function name() external view returns (string memory);
774 
775     /**
776      * @dev Returns the token collection symbol.
777      */
778     function symbol() external view returns (string memory);
779 
780     /**
781      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
782      */
783     function tokenURI(uint256 tokenId) external view returns (string memory);
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
787 
788 
789 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 
795 
796 
797 
798 
799 
800 /**
801  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
802  * the Metadata extension, but not including the Enumerable extension, which is available separately as
803  * {ERC721Enumerable}.
804  */
805 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to owner address
816     mapping(uint256 => address) private _owners;
817 
818     // Mapping owner address to token count
819     mapping(address => uint256) private _balances;
820 
821     // Mapping from token ID to approved address
822     mapping(uint256 => address) private _tokenApprovals;
823 
824     // Mapping from owner to operator approvals
825     mapping(address => mapping(address => bool)) private _operatorApprovals;
826 
827     /**
828      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
829      */
830     constructor(string memory name_, string memory symbol_) {
831         _name = name_;
832         _symbol = symbol_;
833     }
834 
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
839         return
840             interfaceId == type(IERC721).interfaceId ||
841             interfaceId == type(IERC721Metadata).interfaceId ||
842             super.supportsInterface(interfaceId);
843     }
844 
845     /**
846      * @dev See {IERC721-balanceOf}.
847      */
848     function balanceOf(address owner) public view virtual override returns (uint256) {
849         require(owner != address(0), "ERC721: address zero is not a valid owner");
850         return _balances[owner];
851     }
852 
853     /**
854      * @dev See {IERC721-ownerOf}.
855      */
856     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
857         address owner = _owners[tokenId];
858         require(owner != address(0), "ERC721: invalid token ID");
859         return owner;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-name}.
864      */
865     function name() public view virtual override returns (string memory) {
866         return _name;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-symbol}.
871      */
872     function symbol() public view virtual override returns (string memory) {
873         return _symbol;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-tokenURI}.
878      */
879     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
880         _requireMinted(tokenId);
881 
882         string memory baseURI = _baseURI();
883         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
884     }
885 
886     /**
887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
889      * by default, can be overridden in child contracts.
890      */
891     function _baseURI() internal view virtual returns (string memory) {
892         return "";
893     }
894 
895     /**
896      * @dev See {IERC721-approve}.
897      */
898     function approve(address to, uint256 tokenId) public virtual override {
899         address owner = ERC721.ownerOf(tokenId);
900         require(to != owner, "ERC721: approval to current owner");
901 
902         require(
903             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
904             "ERC721: approve caller is not token owner nor approved for all"
905         );
906 
907         _approve(to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId) public view virtual override returns (address) {
914         _requireMinted(tokenId);
915 
916         return _tokenApprovals[tokenId];
917     }
918 
919     /**
920      * @dev See {IERC721-setApprovalForAll}.
921      */
922     function setApprovalForAll(address operator, bool approved) public virtual override {
923         _setApprovalForAll(_msgSender(), operator, approved);
924     }
925 
926     /**
927      * @dev See {IERC721-isApprovedForAll}.
928      */
929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
930         return _operatorApprovals[owner][operator];
931     }
932 
933     /**
934      * @dev See {IERC721-transferFrom}.
935      */
936     function transferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         //solhint-disable-next-line max-line-length
942         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
943 
944         _transfer(from, to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public virtual override {
955         safeTransferFrom(from, to, tokenId, "");
956     }
957 
958     /**
959      * @dev See {IERC721-safeTransferFrom}.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory data
966     ) public virtual override {
967         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
968         _safeTransfer(from, to, tokenId, data);
969     }
970 
971     /**
972      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
973      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
974      *
975      * `data` is additional data, it has no specified format and it is sent in call to `to`.
976      *
977      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
978      * implement alternative mechanisms to perform token transfer, such as signature-based.
979      *
980      * Requirements:
981      *
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must exist and be owned by `from`.
985      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _safeTransfer(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory data
994     ) internal virtual {
995         _transfer(from, to, tokenId);
996         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
997     }
998 
999     /**
1000      * @dev Returns whether `tokenId` exists.
1001      *
1002      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1003      *
1004      * Tokens start existing when they are minted (`_mint`),
1005      * and stop existing when they are burned (`_burn`).
1006      */
1007     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1008         return _owners[tokenId] != address(0);
1009     }
1010 
1011     /**
1012      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      */
1018     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1019         address owner = ERC721.ownerOf(tokenId);
1020         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1021     }
1022 
1023     /**
1024      * @dev Safely mints `tokenId` and transfers it to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must not exist.
1029      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _safeMint(address to, uint256 tokenId) internal virtual {
1034         _safeMint(to, tokenId, "");
1035     }
1036 
1037     /**
1038      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1039      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1040      */
1041     function _safeMint(
1042         address to,
1043         uint256 tokenId,
1044         bytes memory data
1045     ) internal virtual {
1046         _mint(to, tokenId);
1047         require(
1048             _checkOnERC721Received(address(0), to, tokenId, data),
1049             "ERC721: transfer to non ERC721Receiver implementer"
1050         );
1051     }
1052 
1053     /**
1054      * @dev Mints `tokenId` and transfers it to `to`.
1055      *
1056      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must not exist.
1061      * - `to` cannot be the zero address.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _mint(address to, uint256 tokenId) internal virtual {
1066         require(to != address(0), "ERC721: mint to the zero address");
1067         require(!_exists(tokenId), "ERC721: token already minted");
1068 
1069         _beforeTokenTransfer(address(0), to, tokenId);
1070 
1071         _balances[to] += 1;
1072         _owners[tokenId] = to;
1073 
1074         emit Transfer(address(0), to, tokenId);
1075 
1076         _afterTokenTransfer(address(0), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Destroys `tokenId`.
1081      * The approval is cleared when the token is burned.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         address owner = ERC721.ownerOf(tokenId);
1091 
1092         _beforeTokenTransfer(owner, address(0), tokenId);
1093 
1094         // Clear approvals
1095         _approve(address(0), tokenId);
1096 
1097         _balances[owner] -= 1;
1098         delete _owners[tokenId];
1099 
1100         emit Transfer(owner, address(0), tokenId);
1101 
1102         _afterTokenTransfer(owner, address(0), tokenId);
1103     }
1104 
1105     /**
1106      * @dev Transfers `tokenId` from `from` to `to`.
1107      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _transfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) internal virtual {
1121         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1122         require(to != address(0), "ERC721: transfer to the zero address");
1123 
1124         _beforeTokenTransfer(from, to, tokenId);
1125 
1126         // Clear approvals from the previous owner
1127         _approve(address(0), tokenId);
1128 
1129         _balances[from] -= 1;
1130         _balances[to] += 1;
1131         _owners[tokenId] = to;
1132 
1133         emit Transfer(from, to, tokenId);
1134 
1135         _afterTokenTransfer(from, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Approve `to` to operate on `tokenId`
1140      *
1141      * Emits an {Approval} event.
1142      */
1143     function _approve(address to, uint256 tokenId) internal virtual {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Approve `operator` to operate on all of `owner` tokens
1150      *
1151      * Emits an {ApprovalForAll} event.
1152      */
1153     function _setApprovalForAll(
1154         address owner,
1155         address operator,
1156         bool approved
1157     ) internal virtual {
1158         require(owner != operator, "ERC721: approve to caller");
1159         _operatorApprovals[owner][operator] = approved;
1160         emit ApprovalForAll(owner, operator, approved);
1161     }
1162 
1163     /**
1164      * @dev Reverts if the `tokenId` has not been minted yet.
1165      */
1166     function _requireMinted(uint256 tokenId) internal view virtual {
1167         require(_exists(tokenId), "ERC721: invalid token ID");
1168     }
1169 
1170     /**
1171      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1172      * The call is not executed if the target address is not a contract.
1173      *
1174      * @param from address representing the previous owner of the given token ID
1175      * @param to target address that will receive the tokens
1176      * @param tokenId uint256 ID of the token to be transferred
1177      * @param data bytes optional data to send along with the call
1178      * @return bool whether the call correctly returned the expected magic value
1179      */
1180     function _checkOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory data
1185     ) private returns (bool) {
1186         if (to.isContract()) {
1187             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1188                 return retval == IERC721Receiver.onERC721Received.selector;
1189             } catch (bytes memory reason) {
1190                 if (reason.length == 0) {
1191                     revert("ERC721: transfer to non ERC721Receiver implementer");
1192                 } else {
1193                     /// @solidity memory-safe-assembly
1194                     assembly {
1195                         revert(add(32, reason), mload(reason))
1196                     }
1197                 }
1198             }
1199         } else {
1200             return true;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Hook that is called before any token transfer. This includes minting
1206      * and burning.
1207      *
1208      * Calling conditions:
1209      *
1210      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1211      * transferred to `to`.
1212      * - When `from` is zero, `tokenId` will be minted for `to`.
1213      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1214      * - `from` and `to` are never both zero.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _beforeTokenTransfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) internal virtual {}
1223 
1224     /**
1225      * @dev Hook that is called after any transfer of tokens. This includes
1226      * minting and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - when `from` and `to` are both non-zero.
1231      * - `from` and `to` are never both zero.
1232      *
1233      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1234      */
1235     function _afterTokenTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual {}
1240 }
1241 
1242 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1243 
1244 
1245 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 
1250 /**
1251  * @dev ERC721 token with storage based token URI management.
1252  */
1253 abstract contract ERC721URIStorage is ERC721 {
1254     using Strings for uint256;
1255 
1256     // Optional mapping for token URIs
1257     mapping(uint256 => string) private _tokenURIs;
1258 
1259     /**
1260      * @dev See {IERC721Metadata-tokenURI}.
1261      */
1262     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1263         _requireMinted(tokenId);
1264 
1265         string memory _tokenURI = _tokenURIs[tokenId];
1266         string memory base = _baseURI();
1267 
1268         // If there is no base URI, return the token URI.
1269         if (bytes(base).length == 0) {
1270             return _tokenURI;
1271         }
1272         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1273         if (bytes(_tokenURI).length > 0) {
1274             return string(abi.encodePacked(base, _tokenURI));
1275         }
1276 
1277         return super.tokenURI(tokenId);
1278     }
1279 
1280     /**
1281      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1282      *
1283      * Requirements:
1284      *
1285      * - `tokenId` must exist.
1286      */
1287     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1288         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1289         _tokenURIs[tokenId] = _tokenURI;
1290     }
1291 
1292     /**
1293      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1294      * token-specific URI was set for the token, and if so, it deletes the token URI from
1295      * the storage mapping.
1296      */
1297     function _burn(uint256 tokenId) internal virtual override {
1298         super._burn(tokenId);
1299 
1300         if (bytes(_tokenURIs[tokenId]).length != 0) {
1301             delete _tokenURIs[tokenId];
1302         }
1303     }
1304 }
1305 
1306 // File: contracts/NFT.sol
1307 
1308 pragma solidity ^0.8.4;
1309 
1310 
1311 
1312 
1313 
1314 contract OthersideKeys is ERC721, ERC721URIStorage, Pausable, Ownable {
1315     constructor() ERC721("Otherside Keys", "KEYS") {}
1316 
1317     function pause() public onlyOwner {
1318         _pause();
1319     }
1320 
1321     function unpause() public onlyOwner {
1322         _unpause();
1323     }
1324 
1325     function safeMint(address to, uint256 tokenId, string memory uri)
1326         public
1327         onlyOwner
1328     {
1329         _safeMint(to, tokenId);
1330         _setTokenURI(tokenId, uri);
1331     }
1332 
1333     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1334         internal
1335         whenNotPaused
1336         override
1337     {
1338         super._beforeTokenTransfer(from, to, tokenId);
1339     }
1340 
1341     // The following functions are overrides required by Solidity.
1342 
1343     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1344         super._burn(tokenId);
1345     }
1346 
1347     function tokenURI(uint256 tokenId)
1348         public
1349         view
1350         override(ERC721, ERC721URIStorage)
1351         returns (string memory)
1352     {
1353         return super.tokenURI(tokenId);
1354     }
1355 
1356     function contractURI() public view returns (string memory) {
1357         return "https://ipfs.io/ipfs/Qmb6kqGfYtBj3YHvEEKcw3afViGx3j4BjpVX7WC2UU5qxg";
1358     }
1359 }