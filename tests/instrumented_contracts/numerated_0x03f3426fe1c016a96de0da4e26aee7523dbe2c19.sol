1 // SPDX-License-Identifier: MIT LICENSE
2 /*
3            _       _      __                  __               _       _            
4           /\_\   /\_\     \ \                / /              /\_\   /\_\
5          / / /  / / /      \ \              / /              / / /  / / /
6         / / /  / / /        \ \            / /              / / /  / / / 
7        / / /__/ / /          \ \          / /              / / /__/ / /
8       / /\_____/ /            \ \        / /              / /\_____/ /
9      / /\_______/              \ \      / /              / /\_______/  
10     / / /\ \ \                  \ \    / /              / / /\ \ \
11    / / /  \ \ \                  \ \  / /              / / /  \ \ \
12   / / /    \ \ \                  \ \/ /              / / /    \ \ \  
13  /_/_/      \_\_\                  \__/              /_/_/      \_\_\         
14  */ 
15 
16 pragma solidity ^0.8.0;
17 //context
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 
39 pragma solidity ^0.8.0;
40 
41 //ownerable
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _setOwner(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _setOwner(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _setOwner(newOwner);
100     }
101 
102     function _setOwner(address newOwner) private {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 
110 
111 pragma solidity ^0.8.0;
112 
113 //pausable
114 
115 /**
116  * @dev Contract module which allows children to implement an emergency stop
117  * mechanism that can be triggered by an authorized account.
118  *
119  * This module is used through inheritance. It will make available the
120  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
121  * the functions of your contract. Note that they will not be pausable by
122  * simply including this module, only once the modifiers are put in place.
123  */
124 abstract contract Pausable is Context {
125     /**
126      * @dev Emitted when the pause is triggered by `account`.
127      */
128     event Paused(address account);
129 
130     /**
131      * @dev Emitted when the pause is lifted by `account`.
132      */
133     event Unpaused(address account);
134 
135     bool private _paused;
136 
137     /**
138      * @dev Initializes the contract in unpaused state.
139      */
140     constructor() {
141         _paused = false;
142     }
143 
144     /**
145      * @dev Returns true if the contract is paused, and false otherwise.
146      */
147     function paused() public view virtual returns (bool) {
148         return _paused;
149     }
150 
151     /**
152      * @dev Modifier to make a function callable only when the contract is not paused.
153      *
154      * Requirements:
155      *
156      * - The contract must not be paused.
157      */
158     modifier whenNotPaused() {
159         require(!paused(), "Pausable: paused");
160         _;
161     }
162 
163     /**
164      * @dev Modifier to make a function callable only when the contract is paused.
165      *
166      * Requirements:
167      *
168      * - The contract must be paused.
169      */
170     modifier whenPaused() {
171         require(paused(), "Pausable: not paused");
172         _;
173     }
174 
175     /**
176      * @dev Triggers stopped state.
177      *
178      * Requirements:
179      *
180      * - The contract must not be paused.
181      */
182     function _pause() internal virtual whenNotPaused {
183         _paused = true;
184         emit Paused(_msgSender());
185     }
186 
187     /**
188      * @dev Returns to normal state.
189      *
190      * Requirements:
191      *
192      * - The contract must be paused.
193      */
194     function _unpause() internal virtual whenPaused {
195         _paused = false;
196         emit Unpaused(_msgSender());
197     }
198 }
199 
200 // address
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208     /**
209      * @dev Returns true if `account` is a contract.
210      *
211      * [IMPORTANT]
212      * ====
213      * It is unsafe to assume that an address for which this function returns
214      * false is an externally-owned account (EOA) and not a contract.
215      *
216      * Among others, `isContract` will return false for the following
217      * types of addresses:
218      *
219      *  - an externally-owned account
220      *  - a contract in construction
221      *  - an address where a contract will be created
222      *  - an address where a contract lived, but was destroyed
223      * ====
224      */
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize, which returns 0 for contracts in
227         // construction, since the code is only stored at the end of the
228         // constructor execution.
229 
230         uint256 size;
231         assembly {
232             size := extcodesize(account)
233         }
234         return size > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 
418 
419 // IERC165
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Interface of the ERC165 standard, as defined in the
425  * https://eips.ethereum.org/EIPS/eip-165[EIP].
426  *
427  * Implementers can declare support of contract interfaces, which can then be
428  * queried by others ({ERC165Checker}).
429  *
430  * For an implementation, see {ERC165}.
431  */
432 interface IERC165 {
433     /**
434      * @dev Returns true if this contract implements the interface defined by
435      * `interfaceId`. See the corresponding
436      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
437      * to learn more about how these ids are created.
438      *
439      * This function call must use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool);
442 }
443 
444 
445 pragma solidity ^0.8.0;
446 //ERC165
447 
448 /**
449  * @dev Implementation of the {IERC165} interface.
450  *
451  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
452  * for the additional interface id that will be supported. For example:
453  *
454  * ```solidity
455  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
457  * }
458  * ```
459  *
460  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
461  */
462 abstract contract ERC165 is IERC165 {
463     /**
464      * @dev See {IERC165-supportsInterface}.
465      */
466     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
467         return interfaceId == type(IERC165).interfaceId;
468     }
469 }
470 
471 
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev String operations.
477  */
478 library Strings {
479     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
483      */
484     function toString(uint256 value) internal pure returns (string memory) {
485         // Inspired by OraclizeAPI's implementation - MIT licence
486         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
487 
488         if (value == 0) {
489             return "0";
490         }
491         uint256 temp = value;
492         uint256 digits;
493         while (temp != 0) {
494             digits++;
495             temp /= 10;
496         }
497         bytes memory buffer = new bytes(digits);
498         while (value != 0) {
499             digits -= 1;
500             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
501             value /= 10;
502         }
503         return string(buffer);
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
508      */
509     function toHexString(uint256 value) internal pure returns (string memory) {
510         if (value == 0) {
511             return "0x00";
512         }
513         uint256 temp = value;
514         uint256 length = 0;
515         while (temp != 0) {
516             length++;
517             temp >>= 8;
518         }
519         return toHexString(value, length);
520     }
521 
522     /**
523      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
524      */
525     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
526         bytes memory buffer = new bytes(2 * length + 2);
527         buffer[0] = "0";
528         buffer[1] = "x";
529         for (uint256 i = 2 * length + 1; i > 1; --i) {
530             buffer[i] = _HEX_SYMBOLS[value & 0xf];
531             value >>= 4;
532         }
533         require(value == 0, "Strings: hex length insufficient");
534         return string(buffer);
535     }
536 }
537 
538 
539 
540 // IERC721
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Required interface of an ERC721 compliant contract.
547  */
548 interface IERC721 is IERC165 {
549     /**
550      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
551      */
552     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
556      */
557     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
561      */
562     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
563 
564     /**
565      * @dev Returns the number of tokens in ``owner``'s account.
566      */
567     function balanceOf(address owner) external view returns (uint256 balance);
568 
569     /**
570      * @dev Returns the owner of the `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function ownerOf(uint256 tokenId) external view returns (address owner);
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
580      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must exist and be owned by `from`.
587      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
589      *
590      * Emits a {Transfer} event.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external;
597 
598     /**
599      * @dev Transfers `tokenId` token from `from` to `to`.
600      *
601      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must be owned by `from`.
608      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
620      * The approval is cleared when the token is transferred.
621      *
622      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
623      *
624      * Requirements:
625      *
626      * - The caller must own the token or be an approved operator.
627      * - `tokenId` must exist.
628      *
629      * Emits an {Approval} event.
630      */
631     function approve(address to, uint256 tokenId) external;
632 
633     /**
634      * @dev Returns the account approved for `tokenId` token.
635      *
636      * Requirements:
637      *
638      * - `tokenId` must exist.
639      */
640     function getApproved(uint256 tokenId) external view returns (address operator);
641 
642     /**
643      * @dev Approve or remove `operator` as an operator for the caller.
644      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
645      *
646      * Requirements:
647      *
648      * - The `operator` cannot be the caller.
649      *
650      * Emits an {ApprovalForAll} event.
651      */
652     function setApprovalForAll(address operator, bool _approved) external;
653 
654     /**
655      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
656      *
657      * See {setApprovalForAll}
658      */
659     function isApprovedForAll(address owner, address operator) external view returns (bool);
660 
661     /**
662      * @dev Safely transfers `tokenId` token from `from` to `to`.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must exist and be owned by `from`.
669      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
671      *
672      * Emits a {Transfer} event.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId,
678         bytes calldata data
679     ) external;
680 }
681 
682 
683 
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @title ERC721 token receiver interface
689  * @dev Interface for any contract that wants to support safeTransfers
690  * from ERC721 asset contracts.
691  */
692 interface IERC721Receiver {
693     /**
694      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
695      * by `operator` from `from`, this function is called.
696      *
697      * It must return its Solidity selector to confirm the token transfer.
698      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
699      *
700      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
701      */
702     function onERC721Received(
703         address operator,
704         address from,
705         uint256 tokenId,
706         bytes calldata data
707     ) external returns (bytes4);
708 }
709 
710 
711 // 
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
718  * @dev See https://eips.ethereum.org/EIPS/eip-721
719  */
720 interface IERC721Metadata is IERC721 {
721     /**
722      * @dev Returns the token collection name.
723      */
724     function name() external view returns (string memory);
725 
726     /**
727      * @dev Returns the token collection symbol.
728      */
729     function symbol() external view returns (string memory);
730 
731     /**
732      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
733      */
734     function tokenURI(uint256 tokenId) external view returns (string memory);
735 }
736 
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Enumerable is IERC721 {
746     /**
747      * @dev Returns the total amount of tokens stored by the contract.
748      */
749     function totalSupply() external view returns (uint256);
750 
751     /**
752      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
753      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
754      */
755     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
756 
757     /**
758      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
759      * Use along with {totalSupply} to enumerate all tokens.
760      */
761     function tokenByIndex(uint256 index) external view returns (uint256);
762 }
763 
764 
765 
766 
767 //ERC721
768 
769 pragma solidity ^0.8.0;
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension, but not including the Enumerable extension, which is available separately as
774  * {ERC721Enumerable}.
775  */
776 /**
777  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
778  * the Metadata extension, but not including the Enumerable extension, which is available separately as
779  * {ERC721Enumerable}.
780  */
781  contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
782     using Address for address;
783     using Strings for uint256;
784 
785     // Token name
786     string private _name;
787 
788     // Token symbol
789     string private _symbol;
790 
791     // Mapping from token ID to owner address
792     mapping(uint256 => address) private _owners;
793 
794     // Mapping owner address to token count
795     mapping(address => uint256) private _balances;
796 
797     // Mapping from token ID to approved address
798     mapping(uint256 => address) private _tokenApprovals;
799 
800     // Mapping from owner to operator approvals
801     mapping(address => mapping(address => bool)) private _operatorApprovals;
802 
803     /**
804      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
805      */
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809     }
810 
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
815         return
816             interfaceId == type(IERC721).interfaceId ||
817             interfaceId == type(IERC721Metadata).interfaceId ||
818             super.supportsInterface(interfaceId);
819     }
820 
821     /**
822      * @dev See {IERC721-balanceOf}.
823      */
824     function balanceOf(address owner) public view virtual override returns (uint256) {
825         require(owner != address(0), "ERC721: balance query for the zero address");
826         return _balances[owner];
827     }
828 
829     /**
830      * @dev See {IERC721-ownerOf}.
831      */
832     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
833         address owner = _owners[tokenId];
834         require(owner != address(0), "ERC721: owner query for nonexistent token");
835         return owner;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-name}.
840      */
841     function name() public view virtual override returns (string memory) {
842         return _name;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-symbol}.
847      */
848     function symbol() public view virtual override returns (string memory) {
849         return _symbol;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-tokenURI}.
854      */
855     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
856         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
857 
858         string memory baseURI = _baseURI();
859         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
860     }
861 
862     /**
863      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
864      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
865      * by default, can be overriden in child contracts.
866      */
867     function _baseURI() internal view virtual returns (string memory) {
868         return "";
869     }
870 
871     /**
872      * @dev See {IERC721-approve}.
873      */
874     function approve(address to, uint256 tokenId) public virtual override {
875         address owner = ERC721.ownerOf(tokenId);
876         require(to != owner, "ERC721: approval to current owner");
877 
878         require(
879             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
880             "ERC721: approve caller is not owner nor approved for all"
881         );
882 
883         _approve(to, tokenId);
884     }
885 
886     /**
887      * @dev See {IERC721-getApproved}.
888      */
889     function getApproved(uint256 tokenId) public view virtual override returns (address) {
890         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved) public virtual override {
899         require(operator != _msgSender(), "ERC721: approve to caller");
900 
901         _operatorApprovals[_msgSender()][operator] = approved;
902         emit ApprovalForAll(_msgSender(), operator, approved);
903     }
904 
905     /**
906      * @dev See {IERC721-isApprovedForAll}.
907      */
908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
909         return _operatorApprovals[owner][operator];
910     }
911 
912     /**
913      * @dev See {IERC721-transferFrom}.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         //solhint-disable-next-line max-line-length
921         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
922 
923         _transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         safeTransferFrom(from, to, tokenId, "");
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) public virtual override {
946         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
947         _safeTransfer(from, to, tokenId, _data);
948     }
949 
950     /**
951      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
952      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
953      *
954      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
955      *
956      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
957      * implement alternative mechanisms to perform token transfer, such as signature-based.
958      *
959      * Requirements:
960      *
961      * - `from` cannot be the zero address.
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must exist and be owned by `from`.
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _safeTransfer(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) internal virtual {
974         _transfer(from, to, tokenId);
975         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
976     }
977 
978     /**
979      * @dev Returns whether `tokenId` exists.
980      *
981      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
982      *
983      * Tokens start existing when they are minted (`_mint`),
984      * and stop existing when they are burned (`_burn`).
985      */
986     function _exists(uint256 tokenId) internal view virtual returns (bool) {
987         return _owners[tokenId] != address(0);
988     }
989 
990     /**
991      * @dev Returns whether `spender` is allowed to manage `tokenId`.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      */
997     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
998         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
999         address owner = ERC721.ownerOf(tokenId);
1000         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1001     }
1002 
1003     /**
1004      * @dev Safely mints `tokenId` and transfers it to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must not exist.
1009      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeMint(address to, uint256 tokenId) internal virtual {
1014         _safeMint(to, tokenId, "");
1015     }
1016 
1017     /**
1018      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1019      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1020      */
1021     function _safeMint(
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) internal virtual {
1026         _mint(to, tokenId);
1027         require(
1028             _checkOnERC721Received(address(0), to, tokenId, _data),
1029             "ERC721: transfer to non ERC721Receiver implementer"
1030         );
1031     }
1032 
1033     /**
1034      * @dev Mints `tokenId` and transfers it to `to`.
1035      *
1036      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must not exist.
1041      * - `to` cannot be the zero address.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _mint(address to, uint256 tokenId) internal virtual {
1046         require(to != address(0), "ERC721: mint to the zero address");
1047         require(!_exists(tokenId), "ERC721: token already minted");
1048 
1049         _beforeTokenTransfer(address(0), to, tokenId);
1050 
1051         _balances[to] += 1;
1052         _owners[tokenId] = to;
1053 
1054         emit Transfer(address(0), to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId) internal virtual {
1068         address owner = ERC721.ownerOf(tokenId);
1069 
1070         _beforeTokenTransfer(owner, address(0), tokenId);
1071 
1072         // Clear approvals
1073         _approve(address(0), tokenId);
1074 
1075         _balances[owner] -= 1;
1076         delete _owners[tokenId];
1077 
1078         emit Transfer(owner, address(0), tokenId);
1079     }
1080 
1081     /**
1082      * @dev Transfers `tokenId` from `from` to `to`.
1083      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must be owned by `from`.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _transfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual {
1097         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1098         require(to != address(0), "ERC721: transfer to the zero address");
1099 
1100         _beforeTokenTransfer(from, to, tokenId);
1101 
1102         // Clear approvals from the previous owner
1103         _approve(address(0), tokenId);
1104 
1105         _balances[from] -= 1;
1106         _balances[to] += 1;
1107         _owners[tokenId] = to;
1108 
1109         emit Transfer(from, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev Approve `to` to operate on `tokenId`
1114      *
1115      * Emits a {Approval} event.
1116      */
1117     function _approve(address to, uint256 tokenId) internal virtual {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1124      * The call is not executed if the target address is not a contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1140                 return retval == IERC721Receiver.onERC721Received.selector;
1141             } catch (bytes memory reason) {
1142                 if (reason.length == 0) {
1143                     revert("ERC721: transfer to non ERC721Receiver implementer");
1144                 } else {
1145                     assembly {
1146                         revert(add(32, reason), mload(reason))
1147                     }
1148                 }
1149             }
1150         } else {
1151             return true;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before any token transfer. This includes minting
1157      * and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1162      * transferred to `to`.
1163      * - When `from` is zero, `tokenId` will be minted for `to`.
1164      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1165      * - `from` and `to` are never both zero.
1166      *
1167      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1168      */
1169     function _beforeTokenTransfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) internal virtual {}
1174 }
1175 
1176 // ERC721Enumerable
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 /**
1181  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1182  * enumerability of all the token ids in the contract as well as all token ids owned by each
1183  * account.
1184  */
1185 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1186     // Mapping from owner to list of owned token IDs
1187     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1188 
1189     // Mapping from token ID to index of the owner tokens list
1190     mapping(uint256 => uint256) private _ownedTokensIndex;
1191 
1192     // Array with all token ids, used for enumeration
1193     uint256[] private _allTokens;
1194 
1195     // Mapping from token id to position in the allTokens array
1196     mapping(uint256 => uint256) private _allTokensIndex;
1197 
1198     /**
1199      * @dev See {IERC165-supportsInterface}.
1200      */
1201     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1202         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1207      */
1208     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1209         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1210         return _ownedTokens[owner][index];
1211     }
1212 
1213     /**
1214      * @dev See {IERC721Enumerable-totalSupply}.
1215      */
1216     function totalSupply() public view virtual override returns (uint256) {
1217         return _allTokens.length;
1218     }
1219 
1220     /**
1221      * @dev See {IERC721Enumerable-tokenByIndex}.
1222      */
1223     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1224         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1225         return _allTokens[index];
1226     }
1227 
1228     /**
1229      * @dev Hook that is called before any token transfer. This includes minting
1230      * and burning.
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` will be minted for `to`.
1237      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      *
1241      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1242      */
1243     function _beforeTokenTransfer(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) internal virtual override {
1248         super._beforeTokenTransfer(from, to, tokenId);
1249 
1250         if (from == address(0)) {
1251             _addTokenToAllTokensEnumeration(tokenId);
1252         } else if (from != to) {
1253             _removeTokenFromOwnerEnumeration(from, tokenId);
1254         }
1255         if (to == address(0)) {
1256             _removeTokenFromAllTokensEnumeration(tokenId);
1257         } else if (to != from) {
1258             _addTokenToOwnerEnumeration(to, tokenId);
1259         }
1260     }
1261 
1262     /**
1263      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1264      * @param to address representing the new owner of the given token ID
1265      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1266      */
1267     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1268         uint256 length = ERC721.balanceOf(to);
1269         _ownedTokens[to][length] = tokenId;
1270         _ownedTokensIndex[tokenId] = length;
1271     }
1272 
1273     /**
1274      * @dev Private function to add a token to this extension's token tracking data structures.
1275      * @param tokenId uint256 ID of the token to be added to the tokens list
1276      */
1277     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1278         _allTokensIndex[tokenId] = _allTokens.length;
1279         _allTokens.push(tokenId);
1280     }
1281 
1282     /**
1283      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1284      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1285      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1286      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1287      * @param from address representing the previous owner of the given token ID
1288      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1289      */
1290     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1291         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1292         // then delete the last slot (swap and pop).
1293 
1294         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1295         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1296 
1297         // When the token to delete is the last token, the swap operation is unnecessary
1298         if (tokenIndex != lastTokenIndex) {
1299             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1300 
1301             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1302             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1303         }
1304 
1305         // This also deletes the contents at the last position of the array
1306         delete _ownedTokensIndex[tokenId];
1307         delete _ownedTokens[from][lastTokenIndex];
1308     }
1309 
1310     /**
1311      * @dev Private function to remove a token from this extension's token tracking data structures.
1312      * This has O(1) time complexity, but alters the order of the _allTokens array.
1313      * @param tokenId uint256 ID of the token to be removed from the tokens list
1314      */
1315     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1316         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1317         // then delete the last slot (swap and pop).
1318 
1319         uint256 lastTokenIndex = _allTokens.length - 1;
1320         uint256 tokenIndex = _allTokensIndex[tokenId];
1321 
1322         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1323         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1324         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1325         uint256 lastTokenId = _allTokens[lastTokenIndex];
1326 
1327         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1328         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1329 
1330         // This also deletes the contents at the last position of the array
1331         delete _allTokensIndex[tokenId];
1332         _allTokens.pop();
1333     }
1334 }
1335 
1336 
1337 //Kong VS Kaiju Game
1338 
1339 interface IGAMMA {
1340     function balanceOf(address owner) external view returns (uint);
1341     function burn(address account, uint amount) external;
1342 }
1343 
1344 interface ISkullisland {
1345     function randomkongOwner() external returns (address);
1346     function addTokensToStake(address account, uint16[] calldata tokenIds) external;
1347 }
1348 
1349 
1350 contract KongKaiju is ERC721Enumerable, Ownable {
1351     uint public MAX_SUPPLY = 4999;
1352     uint constant public MAX_Mint = 5;
1353 
1354     bool public WhiteListIsActive = false;
1355     uint public MAX_WL_PURCHASE = 2;    
1356     uint public MAX_LEVEL = 10;     
1357     uint public tokensMinted = 0;  
1358     uint16 public phase = 1;
1359     uint16 public kongStolen = 0;
1360     uint16 public KaijuStolen = 0;
1361     uint16 public kongMinted = 0;
1362 
1363     bool private _paused = true;
1364 
1365     mapping(uint16 => uint) public phasePrice;
1366 
1367     ISkullisland public skullIsland;
1368     IGAMMA public Gamma;
1369 
1370     string private _baseapiURI;
1371     mapping(uint16 => bool) private _iskong;
1372     mapping (address => bool) whitelist;
1373     mapping (address => bool) OGlist;   
1374     mapping(address => uint256) public minted;
1375     mapping(uint16 => uint16) public TokenIdLevel;
1376 
1377     uint16[] private _availableTokens;
1378     uint16 private _randomIndex = 0;
1379     uint private _randomCalls = 0;
1380     uint public LEVEL_COST = 10000 ether;
1381 
1382     mapping(uint16 => address) private _TopEXAddress;
1383 
1384     event TokenStolen(address owner, uint16 tokenId, address thief);
1385 
1386     constructor() ERC721("Kong VS Kaiju Game - KVK", "KVK") {
1387         // Set mint sales
1388         switchToSalePhase(1, true);
1389 
1390         // Set default price for each phase
1391         phasePrice[1] = 0.05 ether;
1392         phasePrice[2] = 20000 ether;
1393         phasePrice[3] = 40000 ether;
1394         phasePrice[4] = 80000 ether;
1395 
1396         // Use top exchange and miner addresses to get random number.  Changes every second
1397         _TopEXAddress[0] = 0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8;
1398         _TopEXAddress[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1399         _TopEXAddress[2] = 0xf66852bC122fD40bFECc63CD48217E88bda12109;
1400         _TopEXAddress[3] = 0x267be1C1D684F78cb4F6a176C4911b741E4Ffdc0;
1401         _TopEXAddress[4] = 0x28C6c06298d514Db089934071355E5743bf21d60;
1402     }
1403     
1404     function isEligiblePrivateSale(address _wallet) public view virtual returns (bool){
1405         return whitelist[_wallet];
1406     }
1407 
1408     function isEligibleOGSale(address _wallet) public view virtual returns (bool){
1409         return OGlist[_wallet];
1410     }
1411 
1412     function addWalletsToWhiteList(address[] memory _wallets) public onlyOwner{
1413         for(uint i = 0; i < _wallets.length; i++) {
1414             whitelist[_wallets[i]] = true;
1415         }
1416     }
1417     
1418     function addWalletsToOGList(address[] memory _wallets) public onlyOwner{
1419         for(uint i = 0; i < _wallets.length; i++) {
1420             OGlist[_wallets[i]] = true;
1421         }
1422     }
1423 
1424     function getSomeRandomNumber(uint _seed, uint _limit) internal view returns (uint16) {
1425         uint extra = 0;
1426         for (uint16 i = 0; i < 5; i++) {
1427             extra += _TopEXAddress[_randomIndex].balance;
1428         }
1429 
1430         uint random = uint(
1431             keccak256(
1432                 abi.encodePacked(
1433                     _seed,
1434                     blockhash(block.number - 1),
1435                     block.coinbase,
1436                     block.difficulty,
1437                     msg.sender,
1438                     tokensMinted,
1439                     extra,
1440                     _randomCalls,
1441                     _randomIndex
1442                 )
1443             )
1444         );
1445 
1446         return uint16(random % _limit);
1447     }
1448 
1449     function mintPrice(uint _amount) public view returns (uint) {
1450         return _amount * phasePrice[phase];
1451     }
1452 
1453     function iskong(uint16 id) public view returns (bool) {
1454         return _iskong[id];
1455     }
1456 
1457     function flipWLSaleState() public onlyOwner {
1458         WhiteListIsActive = !WhiteListIsActive;
1459     }
1460 
1461     modifier whenNotPaused() {
1462         require(!paused(), "Pausable: paused");
1463         _;
1464     }
1465     modifier whenPaused() {
1466         require(paused(), "Pausable: not paused");
1467         _;
1468     }
1469 
1470     function setPaused(bool _state) external onlyOwner {
1471         _paused = _state;
1472     }
1473 
1474     function setMAX_SUPPLY(uint _max) external onlyOwner {
1475         MAX_SUPPLY = _max;
1476     }
1477 
1478     function setMAX_LEVLE(uint _level) external onlyOwner {
1479         MAX_LEVEL = _level;
1480     }
1481 
1482     function setLEVEL_COST(uint _levelcost) external onlyOwner {
1483         LEVEL_COST = _levelcost;
1484     }
1485 
1486     function paused() public view virtual returns (bool) {
1487         return _paused;
1488     }
1489 
1490     function addAvailableTokens(uint16 _from, uint16 _to) public onlyOwner {
1491         internalAddTokens(_from, _to);
1492     }
1493 
1494     function internalAddTokens(uint16 _from, uint16 _to) internal {
1495         for (uint16 i = _from; i <= _to; i++) {
1496             _availableTokens.push(i);
1497         }
1498     }
1499 
1500     function GetTokenIdLevel(uint16 _tokenID) public view returns (uint16) {
1501         return TokenIdLevel[_tokenID];
1502     }
1503     
1504     function LevelUp(uint16 _tokenID) public payable whenNotPaused {
1505         require(TokenIdLevel[_tokenID] < MAX_LEVEL, "All level reached ");
1506 
1507         uint Gammacost = 0;
1508         Gammacost = (TokenIdLevel[_tokenID] + 1) * LEVEL_COST;
1509         require(Gamma.balanceOf(msg.sender) >= Gammacost, "Not enough GAMMA");
1510 
1511         if (Gammacost > 0) {
1512             Gamma.burn(msg.sender, Gammacost);
1513             TokenIdLevel[_tokenID] ++;
1514         }        
1515     }
1516 
1517     function switchToSalePhase(uint16 _phase, bool _setTokens) public onlyOwner {
1518         phase = _phase;
1519 
1520         if (!_setTokens) {
1521             return;
1522         }
1523 
1524         if (phase == 1) {
1525             internalAddTokens(1, 4999);
1526         } else if (phase == 2) {
1527             internalAddTokens(5000, 10000);
1528         } else if (phase == 3) {
1529             internalAddTokens(10001, 20000);
1530         } else if (phase == 4) {
1531             internalAddTokens(20001, 29999);
1532         }
1533     }
1534 
1535     function Reserve(uint _amount, address _address) public onlyOwner {
1536         require(tokensMinted  + _amount <= MAX_SUPPLY, "All tokens minted");
1537         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1538 
1539         for (uint i = 0; i < _amount; i++) {
1540             uint16 tokenId = getTokenToBeMinted();
1541             _safeMint(_address, tokenId);
1542             tokensMinted ++;            
1543         }
1544     }
1545 
1546     function presaleWL(uint _amount, bool _stake) public payable {
1547         require(WhiteListIsActive, "Pre Sale must be active to mint tokens");
1548         require(whitelist[msg.sender] || OGlist[msg.sender], "You are not in whitelist");      
1549         require(tx.origin == msg.sender, "Only EOA");
1550         require(tokensMinted  + _amount <= MAX_SUPPLY, "All tokens minted");
1551         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1552 
1553         if (OGlist[msg.sender])
1554         {
1555             MAX_WL_PURCHASE = 3;
1556         }
1557         else
1558         {
1559             MAX_WL_PURCHASE = 2;
1560         }
1561 
1562         require(minted[msg.sender] + _amount <= MAX_WL_PURCHASE, "Max 3 mints for OG and 2 mints for WL per wallet");
1563         require(mintPrice(_amount) == msg.value, "Invalid payment amount");
1564  
1565         tokensMinted += _amount;
1566         uint16[] memory tokenIds = _stake ? new uint16[](_amount) : new uint16[](0);
1567         for (uint i = 0; i < _amount; i++) {
1568             uint16 tokenId = getTokenToBeMinted();
1569 
1570             if (getSomeRandomNumber(tokenId, 100) <= 10) {
1571                 _iskong[tokenId] = true; // 10% to be Kong
1572             }
1573 
1574             if (_iskong[tokenId]) {
1575                 kongMinted += 1;
1576             }
1577             
1578             if (!_stake ) {
1579                 _safeMint(msg.sender, tokenId);
1580             } else {
1581                 _safeMint(address(skullIsland), tokenId);
1582                 tokenIds[i] = tokenId;
1583             }
1584 
1585             minted[msg.sender]++;
1586         }
1587         if (_stake) {
1588             skullIsland.addTokensToStake(msg.sender, tokenIds);
1589         }
1590    }
1591 
1592     function mint(uint _amount, bool _stake) public payable whenNotPaused {
1593         require(tx.origin == msg.sender, "Only EOA");
1594         require(tokensMinted  + _amount <= MAX_SUPPLY, "All tokens minted");
1595         require(_amount > 0 && _amount <= MAX_Mint, "Invalid mint amount");
1596         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1597 
1598         uint Gammacost = 0;
1599         if (phase == 1) {
1600             // Mint sales
1601             require(mintPrice(_amount) == msg.value, "Invalid payment amount");
1602         } else {
1603             // Mint via token burn
1604             require(msg.value == 0, "Now minting is done via GAMMA");
1605             Gammacost = mintPrice(_amount);
1606             require(Gamma.balanceOf(msg.sender) >= Gammacost, "Not enough GAMMA");
1607         }
1608 
1609         if (Gammacost > 0) {
1610             Gamma.burn(msg.sender, Gammacost);
1611         }
1612 
1613         tokensMinted += _amount;
1614         uint16[] memory tokenIds = _stake ? new uint16[](_amount) : new uint16[](0);
1615         for (uint i = 0; i < _amount; i++) {
1616             address recipient = selectRecipient();
1617             if (phase != 1) {
1618                 updateRandomIndex();
1619             }
1620 
1621             uint16 tokenId = getTokenToBeMinted();
1622 
1623             if (getSomeRandomNumber(tokenId, 100) <= 10) 
1624             {
1625               _iskong[tokenId] = true; // 10% to be Kong
1626             }
1627 
1628            if (_iskong[tokenId]) {
1629                 kongMinted += 1;
1630             }
1631 
1632             if (recipient != msg.sender) {
1633                 _iskong[tokenId] ? kongStolen += 1 : KaijuStolen += 1;
1634                 emit TokenStolen(msg.sender, tokenId, recipient);
1635             }
1636             
1637             if (!_stake || recipient != msg.sender) {
1638                 _safeMint(recipient, tokenId);
1639             } else {
1640                 _safeMint(address(skullIsland), tokenId);
1641                 tokenIds[i] = tokenId;
1642             }
1643         }
1644         if (_stake) {
1645             skullIsland.addTokensToStake(msg.sender, tokenIds);
1646         }
1647     }
1648 
1649     
1650     function selectRecipient() internal returns (address) {
1651         if (phase == 1) {
1652             return msg.sender; //  no chance to steal NTF during sales
1653         }
1654 
1655         if (getSomeRandomNumber(kongMinted, 100) >= 10) {
1656             return msg.sender; // 90% chance to keep NFT
1657         }
1658 
1659         address thief = skullIsland.randomkongOwner();
1660         if (thief == address(0x0)) {
1661             return msg.sender;
1662         }
1663         return thief;
1664     }
1665     
1666     function changePhasePrice(uint16 _phase, uint _weiPrice) external onlyOwner {
1667         phasePrice[_phase] = _weiPrice;
1668     }
1669 
1670     function getTokenToBeMinted() private returns (uint16) {
1671         uint random = getSomeRandomNumber(_availableTokens.length, _availableTokens.length);
1672         uint16 tokenId = _availableTokens[random];
1673 
1674         _availableTokens[random] = _availableTokens[_availableTokens.length - 1];
1675         _availableTokens.pop();
1676 
1677         return tokenId;
1678     }
1679     
1680     function updateRandomIndex() internal {
1681         _randomIndex += 1;
1682         _randomCalls += 1;
1683         if (_randomIndex > 6) _randomIndex = 0;
1684     }
1685 
1686     function shuffleSeeds(uint _seed, uint _max) external onlyOwner {
1687         uint shuffleCount = getSomeRandomNumber(_seed, _max);
1688         _randomIndex = uint16(shuffleCount);
1689         for (uint i = 0; i < shuffleCount; i++) {
1690             updateRandomIndex();
1691         }
1692     }
1693 
1694     function setskullIsland(address _island) external onlyOwner {
1695         skullIsland = ISkullisland(_island);
1696     }
1697 
1698     function setGamma(address _Gamma) external onlyOwner {
1699         Gamma = IGAMMA(_Gamma);
1700     }
1701 
1702     function setkongId(uint16 id, bool special) external onlyOwner {
1703         _iskong[id] = special;
1704     }
1705 
1706     function setkongIds(uint16[] calldata ids) external onlyOwner {
1707         for (uint i = 0; i < ids.length; i++) {
1708             _iskong[ids[i]] = true;
1709         }
1710     }
1711 
1712     function transferFrom(address from, address to, uint tokenId) public virtual override {
1713         // Hardcode the Manager's approval so that users don't have to waste gas approving
1714         if (_msgSender() != address(skullIsland))
1715             require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1716         _transfer(from, to, tokenId);
1717     }
1718     
1719     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1720        uint256 tokenCount = balanceOf(_owner);
1721        if (tokenCount == 0) {
1722             // Return an empty array
1723             return new uint256[](0);
1724         } else {
1725             uint256[] memory result = new uint256[](tokenCount);
1726             uint256 index;
1727             for (index = 0; index < tokenCount; index++) {
1728                 result[index] = tokenOfOwnerByIndex(_owner, index);
1729             }
1730                 return result;
1731             }
1732     }
1733 
1734     function _baseURI() internal view override returns (string memory) {
1735         return _baseapiURI;
1736     }
1737 
1738     function setBaseURI(string memory uri) external onlyOwner {
1739         _baseapiURI = uri;
1740     }
1741 
1742     function changeTopEXAddress(uint16 _id, address _address) external onlyOwner {
1743         _TopEXAddress[_id] = _address;
1744     }
1745 
1746     function withdraw() external onlyOwner {
1747         uint256 balance = address(this).balance;
1748         payable(msg.sender).transfer(balance);
1749     }
1750 }