1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-12
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 // File: @openzeppelin/contracts/utils/Address.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Collection of functions related to the address type
17  */
18 library Address {
19     /**
20      * @dev Returns true if `account` is a contract.
21      *
22      * [IMPORTANT]
23      * ====
24      * It is unsafe to assume that an address for which this function returns
25      * false is an externally-owned account (EOA) and not a contract.
26      *
27      * Among others, `isContract` will return false for the following
28      * types of addresses:
29      *
30      *  - an externally-owned account
31      *  - a contract in construction
32      *  - an address where a contract will be created
33      *  - an address where a contract lived, but was destroyed
34      * ====
35      */
36     function isContract(address account) internal view returns (bool) {
37         // This method relies on extcodesize, which returns 0 for contracts in
38         // construction, since the code is only stored at the end of the
39         // constructor execution.
40 
41         uint256 size;
42         assembly {
43             size := extcodesize(account)
44         }
45         return size > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
232 
233 // pragma solidity ^0.8.0;
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 interface IERC721Receiver {
241     /**
242      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
243      * by `operator` from `from`, this function is called.
244      *
245      * It must return its Solidity selector to confirm the token transfer.
246      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
247      *
248      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
249      */
250     function onERC721Received(
251         address operator,
252         address from,
253         uint256 tokenId,
254         bytes calldata data
255     ) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 // pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC165 standard, as defined in the
267  * https://eips.ethereum.org/EIPS/eip-165[EIP].
268  *
269  * Implementers can declare support of contract interfaces, which can then be
270  * queried by others ({ERC165Checker}).
271  *
272  * For an implementation, see {ERC165}.
273  */
274 interface IERC165 {
275     /**
276      * @dev Returns true if this contract implements the interface defined by
277      * `interfaceId`. See the corresponding
278      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
279      * to learn more about how these ids are created.
280      *
281      * This function call must use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
290 
291 // pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * ```solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * ```
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
321 
322 // pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Required interface of an ERC721 compliant contract.
327  */
328 interface IERC721 is IERC165 {
329     /**
330      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
336      */
337     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
341      */
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of tokens in ``owner``'s account.
346      */
347     function balanceOf(address owner) external view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
360      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external;
377 
378     /**
379      * @dev Transfers `tokenId` token from `from` to `to`.
380      *
381      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
400      * The approval is cleared when the token is transferred.
401      *
402      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
403      *
404      * Requirements:
405      *
406      * - The caller must own the token or be an approved operator.
407      * - `tokenId` must exist.
408      *
409      * Emits an {Approval} event.
410      */
411     function approve(address to, uint256 tokenId) external;
412 
413     /**
414      * @dev Returns the account approved for `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function getApproved(uint256 tokenId) external view returns (address operator);
421 
422     /**
423      * @dev Approve or remove `operator` as an operator for the caller.
424      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
425      *
426      * Requirements:
427      *
428      * - The `operator` cannot be the caller.
429      *
430      * Emits an {ApprovalForAll} event.
431      */
432     function setApprovalForAll(address operator, bool _approved) external;
433 
434     /**
435      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
436      *
437      * See {setApprovalForAll}
438      */
439     function isApprovedForAll(address owner, address operator) external view returns (bool);
440 
441     /**
442      * @dev Safely transfers `tokenId` token from `from` to `to`.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `tokenId` token must exist and be owned by `from`.
449      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId,
458         bytes calldata data
459     ) external;
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
466 
467 // pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Metadata is IERC721 {
475     /**
476      * @dev Returns the token collection name.
477      */
478     function name() external view returns (string memory);
479 
480     /**
481      * @dev Returns the token collection symbol.
482      */
483     function symbol() external view returns (string memory);
484 
485     /**
486      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
487      */
488     function tokenURI(uint256 tokenId) external view returns (string memory);
489 }
490 
491 // File: @openzeppelin/contracts/utils/Context.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
495 
496 // pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Provides information about the current execution context, including the
500  * sender of the transaction and its data. While these are generally available
501  * via msg.sender and msg.data, they should not be accessed in such a direct
502  * manner, since when dealing with meta-transactions the account sending and
503  * paying for execution may not be the actual sender (as far as an application
504  * is concerned).
505  *
506  * This contract is only required for intermediate, library-like contracts.
507  */
508 abstract contract Context {
509     function _msgSender() internal view virtual returns (address) {
510         return msg.sender;
511     }
512 
513     function _msgData() internal view virtual returns (bytes calldata) {
514         return msg.data;
515     }
516 }
517 
518 // File: @openzeppelin/contracts/access/Ownable.sol
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
522 
523 // pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @dev Contract module which provides a basic access control mechanism, where
528  * there is an account (an owner) that can be granted exclusive access to
529  * specific functions.
530  *
531  * By default, the owner account will be the one that deploys the contract. This
532  * can later be changed with {transferOwnership}.
533  *
534  * This module is used through inheritance. It will make available the modifier
535  * `onlyOwner`, which can be applied to your functions to restrict their use to
536  * the owner.
537  */
538 abstract contract Ownable is Context {
539     address private _owner;
540 
541     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
542 
543     /**
544      * @dev Initializes the contract setting the deployer as the initial owner.
545      */
546     constructor() {
547         _transferOwnership(_msgSender());
548     }
549 
550     /**
551      * @dev Returns the address of the current owner.
552      */
553     function owner() public view virtual returns (address) {
554         return _owner;
555     }
556 
557     /**
558      * @dev Throws if called by any account other than the owner.
559      */
560     modifier onlyOwner() {
561         require(owner() == _msgSender(), "Ownable: caller is not the owner");
562         _;
563     }
564 
565     /**
566      * @dev Leaves the contract without owner. It will not be possible to call
567      * `onlyOwner` functions anymore. Can only be called by the current owner.
568      *
569      * NOTE: Renouncing ownership will leave the contract without an owner,
570      * thereby removing any functionality that is only available to the owner.
571      */
572     function renounceOwnership() public virtual onlyOwner {
573         _transferOwnership(address(0));
574     }
575 
576     /**
577      * @dev Transfers ownership of the contract to a new account (`newOwner`).
578      * Can only be called by the current owner.
579      */
580     function transferOwnership(address newOwner) public virtual onlyOwner {
581         require(newOwner != address(0), "Ownable: new owner is the zero address");
582         _transferOwnership(newOwner);
583     }
584 
585     /**
586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
587      * Internal function without access restriction.
588      */
589     function _transferOwnership(address newOwner) internal virtual {
590         address oldOwner = _owner;
591         _owner = newOwner;
592         emit OwnershipTransferred(oldOwner, newOwner);
593     }
594 }
595 
596 // File: @openzeppelin/contracts/security/Pausable.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
600 
601 // pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @dev Contract module which allows children to implement an emergency stop
606  * mechanism that can be triggered by an authorized account.
607  *
608  * This module is used through inheritance. It will make available the
609  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
610  * the functions of your contract. Note that they will not be pausable by
611  * simply including this module, only once the modifiers are put in place.
612  */
613 abstract contract Pausable is Context {
614     /**
615      * @dev Emitted when the pause is triggered by `account`.
616      */
617     event Paused(address account);
618 
619     /**
620      * @dev Emitted when the pause is lifted by `account`.
621      */
622     event Unpaused(address account);
623 
624     bool private _paused;
625 
626     /**
627      * @dev Initializes the contract in unpaused state.
628      */
629     constructor() {
630         _paused = false;
631     }
632 
633     /**
634      * @dev Returns true if the contract is paused, and false otherwise.
635      */
636     function paused() public view virtual returns (bool) {
637         return _paused;
638     }
639 
640     /**
641      * @dev Modifier to make a function callable only when the contract is not paused.
642      *
643      * Requirements:
644      *
645      * - The contract must not be paused.
646      */
647     modifier whenNotPaused() {
648         require(!paused(), "Pausable: paused");
649         _;
650     }
651 
652     /**
653      * @dev Modifier to make a function callable only when the contract is paused.
654      *
655      * Requirements:
656      *
657      * - The contract must be paused.
658      */
659     modifier whenPaused() {
660         require(paused(), "Pausable: not paused");
661         _;
662     }
663 
664     /**
665      * @dev Triggers stopped state.
666      *
667      * Requirements:
668      *
669      * - The contract must not be paused.
670      */
671     function _pause() internal virtual whenNotPaused {
672         _paused = true;
673         emit Paused(_msgSender());
674     }
675 
676     /**
677      * @dev Returns to normal state.
678      *
679      * Requirements:
680      *
681      * - The contract must be paused.
682      */
683     function _unpause() internal virtual whenPaused {
684         _paused = false;
685         emit Unpaused(_msgSender());
686     }
687 }
688 
689 // File: @openzeppelin/contracts/utils/Strings.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
693 
694 // pragma solidity ^0.8.0;
695 
696 /**
697  * @dev String operations.
698  */
699 library Strings {
700     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
704      */
705     function toString(uint256 value) internal pure returns (string memory) {
706         // Inspired by OraclizeAPI's implementation - MIT licence
707         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
708 
709         if (value == 0) {
710             return "0";
711         }
712         uint256 temp = value;
713         uint256 digits;
714         while (temp != 0) {
715             digits++;
716             temp /= 10;
717         }
718         bytes memory buffer = new bytes(digits);
719         while (value != 0) {
720             digits -= 1;
721             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
722             value /= 10;
723         }
724         return string(buffer);
725     }
726 
727     /**
728      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
729      */
730     function toHexString(uint256 value) internal pure returns (string memory) {
731         if (value == 0) {
732             return "0x00";
733         }
734         uint256 temp = value;
735         uint256 length = 0;
736         while (temp != 0) {
737             length++;
738             temp >>= 8;
739         }
740         return toHexString(value, length);
741     }
742 
743     /**
744      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
745      */
746     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
747         bytes memory buffer = new bytes(2 * length + 2);
748         buffer[0] = "0";
749         buffer[1] = "x";
750         for (uint256 i = 2 * length + 1; i > 1; --i) {
751             buffer[i] = _HEX_SYMBOLS[value & 0xf];
752             value >>= 4;
753         }
754         require(value == 0, "Strings: hex length insufficient");
755         return string(buffer);
756     }
757 }
758 
759 
760 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
764 
765 // pragma solidity ^0.8.0;
766 
767 
768 
769 
770 
771 
772 
773 
774 /**
775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
776  * the Metadata extension, but not including the Enumerable extension, which is available separately as
777  * {ERC721Enumerable}.
778  */
779 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
780     using Address for address;
781     using Strings for uint256;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to owner address
790     mapping(uint256 => address) private _owners;
791 
792     // Mapping owner address to token count
793     mapping(address => uint256) private _balances;
794 
795     // Mapping from token ID to approved address
796     mapping(uint256 => address) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     /**
802      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
803      */
804     constructor(string memory name_, string memory symbol_) {
805         _name = name_;
806         _symbol = symbol_;
807     }
808 
809     /**
810      * @dev See {IERC165-supportsInterface}.
811      */
812     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
813         return
814             interfaceId == type(IERC721).interfaceId ||
815             interfaceId == type(IERC721Metadata).interfaceId ||
816             super.supportsInterface(interfaceId);
817     }
818 
819     /**
820      * @dev See {IERC721-balanceOf}.
821      */
822     function balanceOf(address owner) public view virtual override returns (uint256) {
823         require(owner != address(0), "ERC721: balance query for the zero address");
824         return _balances[owner];
825     }
826 
827     /**
828      * @dev See {IERC721-ownerOf}.
829      */
830     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
831         address owner = _owners[tokenId];
832         require(owner != address(0), "ERC721: owner query for nonexistent token");
833         return owner;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-name}.
838      */
839     function name() public view virtual override returns (string memory) {
840         return _name;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-symbol}.
845      */
846     function symbol() public view virtual override returns (string memory) {
847         return _symbol;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-tokenURI}.
852      */
853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
854         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
855 
856         string memory baseURI = _baseURI();
857         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
858     }
859 
860     /**
861      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
862      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
863      * by default, can be overriden in child contracts.
864      */
865     function _baseURI() internal view virtual returns (string memory) {
866         return "";
867     }
868 
869     /**
870      * @dev See {IERC721-approve}.
871      */
872     function approve(address to, uint256 tokenId) public virtual override {
873         address owner = ERC721.ownerOf(tokenId);
874         require(to != owner, "ERC721: approval to current owner");
875 
876         require(
877             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
878             "ERC721: approve caller is not owner nor approved for all"
879         );
880 
881         _approve(to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-getApproved}.
886      */
887     function getApproved(uint256 tokenId) public view virtual override returns (address) {
888         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
889 
890         return _tokenApprovals[tokenId];
891     }
892 
893     /**
894      * @dev See {IERC721-setApprovalForAll}.
895      */
896     function setApprovalForAll(address operator, bool approved) public virtual override {
897         _setApprovalForAll(_msgSender(), operator, approved);
898     }
899 
900     /**
901      * @dev See {IERC721-isApprovedForAll}.
902      */
903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
904         return _operatorApprovals[owner][operator];
905     }
906 
907     /**
908      * @dev See {IERC721-transferFrom}.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         //solhint-disable-next-line max-line-length
916         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
917 
918         _transfer(from, to, tokenId);
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         safeTransferFrom(from, to, tokenId, "");
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) public virtual override {
941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
942         _safeTransfer(from, to, tokenId, _data);
943     }
944 
945     /**
946      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
947      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
948      *
949      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
950      *
951      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
952      * implement alternative mechanisms to perform token transfer, such as signature-based.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must exist and be owned by `from`.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeTransfer(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) internal virtual {
969         _transfer(from, to, tokenId);
970         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
971     }
972 
973     /**
974      * @dev Returns whether `tokenId` exists.
975      *
976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977      *
978      * Tokens start existing when they are minted (`_mint`),
979      * and stop existing when they are burned (`_burn`).
980      */
981     function _exists(uint256 tokenId) internal view virtual returns (bool) {
982         return _owners[tokenId] != address(0);
983     }
984 
985     /**
986      * @dev Returns whether `spender` is allowed to manage `tokenId`.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      */
992     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
993         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
994         address owner = ERC721.ownerOf(tokenId);
995         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
996     }
997 
998     /**
999      * @dev Safely mints `tokenId` and transfers it to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _safeMint(address to, uint256 tokenId) internal virtual {
1009         _safeMint(to, tokenId, "");
1010     }
1011 
1012     /**
1013      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1014      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1015      */
1016     function _safeMint(
1017         address to,
1018         uint256 tokenId,
1019         bytes memory _data
1020     ) internal virtual {
1021         _mint(to, tokenId);
1022         require(
1023             _checkOnERC721Received(address(0), to, tokenId, _data),
1024             "ERC721: transfer to non ERC721Receiver implementer"
1025         );
1026     }
1027 
1028     /**
1029      * @dev Mints `tokenId` and transfers it to `to`.
1030      *
1031      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must not exist.
1036      * - `to` cannot be the zero address.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _mint(address to, uint256 tokenId) internal virtual {
1041         require(to != address(0), "ERC721: mint to the zero address");
1042         require(!_exists(tokenId), "ERC721: token already minted");
1043 
1044         _beforeTokenTransfer(address(0), to, tokenId);
1045 
1046         _balances[to] += 1;
1047         _owners[tokenId] = to;
1048 
1049         emit Transfer(address(0), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         address owner = ERC721.ownerOf(tokenId);
1064 
1065         _beforeTokenTransfer(owner, address(0), tokenId);
1066 
1067         // Clear approvals
1068         _approve(address(0), tokenId);
1069 
1070         _balances[owner] -= 1;
1071         delete _owners[tokenId];
1072 
1073         emit Transfer(owner, address(0), tokenId);
1074     }
1075 
1076     /**
1077      * @dev Transfers `tokenId` from `from` to `to`.
1078      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `tokenId` token must be owned by `from`.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual {
1092         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1093         require(to != address(0), "ERC721: transfer to the zero address");
1094 
1095         _beforeTokenTransfer(from, to, tokenId);
1096 
1097         // Clear approvals from the previous owner
1098         _approve(address(0), tokenId);
1099 
1100         _balances[from] -= 1;
1101         _balances[to] += 1;
1102         _owners[tokenId] = to;
1103 
1104         emit Transfer(from, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Approve `to` to operate on `tokenId`
1109      *
1110      * Emits a {Approval} event.
1111      */
1112     function _approve(address to, uint256 tokenId) internal virtual {
1113         _tokenApprovals[tokenId] = to;
1114         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev Approve `operator` to operate on all of `owner` tokens
1119      *
1120      * Emits a {ApprovalForAll} event.
1121      */
1122     function _setApprovalForAll(
1123         address owner,
1124         address operator,
1125         bool approved
1126     ) internal virtual {
1127         require(owner != operator, "ERC721: approve to caller");
1128         _operatorApprovals[owner][operator] = approved;
1129         emit ApprovalForAll(owner, operator, approved);
1130     }
1131 
1132     /**
1133      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1134      * The call is not executed if the target address is not a contract.
1135      *
1136      * @param from address representing the previous owner of the given token ID
1137      * @param to target address that will receive the tokens
1138      * @param tokenId uint256 ID of the token to be transferred
1139      * @param _data bytes optional data to send along with the call
1140      * @return bool whether the call correctly returned the expected magic value
1141      */
1142     function _checkOnERC721Received(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes memory _data
1147     ) private returns (bool) {
1148         if (to.isContract()) {
1149             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1150                 return retval == IERC721Receiver.onERC721Received.selector;
1151             } catch (bytes memory reason) {
1152                 if (reason.length == 0) {
1153                     revert("ERC721: transfer to non ERC721Receiver implementer");
1154                 } else {
1155                     assembly {
1156                         revert(add(32, reason), mload(reason))
1157                     }
1158                 }
1159             }
1160         } else {
1161             return true;
1162         }
1163     }
1164 
1165     /**
1166      * @dev Hook that is called before any token transfer. This includes minting
1167      * and burning.
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` will be minted for `to`.
1174      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1175      * - `from` and `to` are never both zero.
1176      *
1177      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1178      */
1179     function _beforeTokenTransfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) internal virtual {}
1184 }
1185 
1186 // File: syac.sol
1187 
1188 
1189 // pragma solidity ^0.8.7;
1190 
1191 
1192 contract syac is ERC721, Ownable, Pausable {
1193     using Strings for uint256;
1194     uint256 public constant MAX_SUPPLY = 5555;
1195     uint256 public constant MINT_PRICE = 0.05 ether;
1196     uint256 public constant MAX_MINT_PER_TX = 5;
1197     uint256 constant public LEGENDARY_SUPPLY = 200;
1198     uint256 public totalLegendaryMinted;
1199     mapping(address=>uint) public totalWhiteListMinted;
1200     mapping(address=>uint256) public totalPublicMinted;
1201     mapping(address => bool) public isWhitelisted;
1202     mapping(address=>bool) legandaryAddress;
1203 
1204     mapping(bytes32 => bool) private _usedHashes;
1205     bool public saleStarted = false;
1206     bool public preSaleStarted = false;
1207     bool public lock = false;
1208     uint256 public totalSupply = 0;
1209 
1210     string public prefixURI;
1211     string public commonURI;
1212     
1213     mapping(uint256 => string) public tokenURIs;
1214 
1215     constructor() ERC721("Spoiled Young Ape Club", "SYAC") { 
1216 
1217       mintOwner();
1218     }
1219 
1220         //modifier
1221      modifier onlyLegandry() {
1222        require(legandaryAddress[msg.sender],"Only Legendary Address can call!");
1223         _;
1224     }
1225 
1226 
1227     //function to convert uint into string
1228     function uint2str(
1229      uint256 _i
1230     )
1231      internal
1232      pure
1233      returns (string memory str)
1234     {
1235      if (_i == 0)
1236      {
1237     return "0";
1238       }
1239     uint256 j = _i;
1240     uint256 length;
1241     while (j != 0)
1242     {
1243     length++;
1244     j /= 10;
1245     }
1246     bytes memory bstr = new bytes(length);
1247     uint256 k = length;
1248     j = _i;
1249     while (j != 0)
1250     {
1251     bstr[--k] = bytes1(uint8(48 + j % 10));
1252     j /= 10;
1253     }
1254     str = string(bstr);
1255     }
1256     
1257     //Encoded Token id
1258     function getTokenId(uint256 _value)public pure returns(string memory){
1259      string memory tokenId;
1260      if(_value<10){
1261         tokenId= string(abi.encodePacked("000", _value.toString()));
1262      }else if(_value<100){
1263        tokenId=  string(abi.encodePacked("00", _value.toString()));
1264      }else if(_value<1000){
1265        tokenId=  string(abi.encodePacked("0", _value.toString()));
1266      }else{
1267      tokenId=uint2str(_value);
1268     }
1269     return (tokenId);
1270     }
1271 
1272     function mintOwner() public onlyOwner {
1273         require(totalLegendaryMinted<LEGENDARY_SUPPLY,"Legendary Total Minted Reached");
1274         for(uint256 i=1; i <= LEGENDARY_SUPPLY ; i++){
1275         _safeMint(msg.sender, (totalSupply+i));
1276         
1277         }
1278         totalSupply +=  LEGENDARY_SUPPLY;
1279         totalLegendaryMinted +=  LEGENDARY_SUPPLY;
1280     }
1281 
1282     function mintLegendary(uint256 _count, address _account) external onlyLegandry {
1283         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1284         require(totalLegendaryMinted >= LEGENDARY_SUPPLY, "LEGENDARY_NOT_MINTED");
1285         for (uint256 i = 1; i <= _count; i++) {
1286             _safeMint(_account,(totalSupply + i));
1287         }
1288         totalSupply += _count;
1289     }
1290 
1291     function mintWhitelist(
1292         uint256 _count)
1293         external
1294         payable
1295     {
1296         require(preSaleStarted, "MINT_NOT_STARTED");
1297         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1298         require(totalLegendaryMinted >= LEGENDARY_SUPPLY, "LEGENDARY_NOT_MINTED");
1299         require(msg.value >= (_count * MINT_PRICE), "INVALID_ETH_SENT");
1300         require(_count<=3,"You can't mint more than 3");
1301         require(isWhitelisted[msg.sender],"Address isn't Whitelisted");
1302         require(totalWhiteListMinted[msg.sender]+_count<=3,"you can't mint more than 3");
1303         for (uint256 i = 1; i <= _count; i++) {
1304             _safeMint(msg.sender,(totalSupply + i));
1305         }
1306         totalSupply += _count;
1307         totalWhiteListMinted[msg.sender]+=_count;
1308         
1309     }
1310 
1311 
1312 
1313     // Public Mint
1314     function mint(uint256 _count) public payable {
1315         require(saleStarted, "MINT_NOT_STARTED");
1316         require(_count > 0 && _count <= MAX_MINT_PER_TX, "COUNT_INVALID");
1317         require(totalLegendaryMinted >= LEGENDARY_SUPPLY, "LEGENDARY_NOT_MINTED");
1318         require(totalSupply + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1319         require(msg.value >=(_count * MINT_PRICE), "INVALID_ETH_SENT");
1320         require(totalPublicMinted[msg.sender]+_count<=8,"Maximum NFT Limit reached");
1321 
1322         for (uint256 i = 1; i <= _count; i++) {
1323             _safeMint(msg.sender, (totalSupply + i));
1324         }
1325         totalSupply += _count;
1326         totalPublicMinted[msg.sender]+=_count;
1327     }
1328    function addWhitelist(address[] memory _addresses) external onlyOwner {
1329         for(uint i = 0; i < _addresses.length; i++) {
1330         isWhitelisted[_addresses[i]] = true;
1331         }
1332     }
1333 
1334     function removeWhitelist(address[] memory _addresses) external onlyOwner {
1335             for(uint i = 0; i < _addresses.length; i++) {
1336             isWhitelisted[_addresses[i]] = false;
1337             }
1338     }
1339     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1340         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1341         if (bytes(tokenURIs[tokenId]).length != 0) {
1342             return tokenURIs[tokenId];
1343         }
1344         if (bytes(commonURI).length != 0) {
1345             return commonURI;
1346         }
1347         return string(abi.encodePacked(prefixURI, getTokenId(tokenId)));
1348     }
1349 
1350     // ** Admin Fuctions ** //
1351     function withdraw(address payable _to) external onlyOwner {
1352         require(_to != address(0), "WITHDRAW_ADDRESS_ZERO");
1353         require(address(this).balance > 0, "EMPTY_BALANCE");
1354         _to.transfer(address(this).balance);
1355     }
1356 
1357     function setSaleStarted(bool _hasStarted) external onlyOwner {
1358         require(saleStarted != _hasStarted, "SALE_STARTED_ALREADY_SET");
1359         saleStarted = _hasStarted;
1360     }
1361 
1362         function setLegendary(address[] memory _legandaryAddress) external onlyOwner {
1363 
1364             for(uint8 i=0;i<_legandaryAddress.length;i++){
1365               legandaryAddress[_legandaryAddress[i]]=true;
1366     }
1367         }
1368 
1369     function setPreSaleStarted(bool _hasStarted) external onlyOwner {
1370         require(preSaleStarted != _hasStarted, "SALE_STARTED_ALREADY_SET");
1371         preSaleStarted = _hasStarted;
1372     }
1373     function lockBaseURI() external onlyOwner {
1374         require(!lock, "ALREADY_LOCKED");
1375         lock = true;
1376     }
1377 
1378     function setPrefixURI(string calldata _uri) external onlyOwner {
1379         require(!lock, "ALREADY_LOCKED");
1380         prefixURI = _uri;
1381         commonURI = '';
1382     }
1383 
1384     function setCommonURI(string calldata _uri) external onlyOwner {
1385         require(!lock, "ALREADY_LOCKED");
1386         commonURI = _uri;
1387         prefixURI = '';
1388     }
1389     function setTokenURI(string calldata _uri, uint256 _tokenId) external onlyOwner {
1390         require(!lock, "ALREADY_LOCKED");
1391         tokenURIs[_tokenId] = _uri;
1392     }
1393 
1394     function pause() external onlyOwner {
1395         require(!paused(), "ALREADY_PAUSED");
1396         _pause();
1397     }
1398 
1399     function unpause() external onlyOwner {
1400         require(paused(), "ALREADY_UNPAUSED");
1401         _unpause();
1402     }
1403 
1404     function _beforeTokenTransfer(
1405         address from,
1406         address to,
1407         uint256 tokenId
1408     ) override internal virtual {
1409         require(!paused(), "TRANSFER_PAUSED");
1410         super._beforeTokenTransfer(from, to, tokenId);
1411     }
1412 }