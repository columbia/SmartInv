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
15 pragma solidity ^0.8.0;
16 //context
17 
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
765 // ERC721Enumerable
766 
767 pragma solidity ^0.8.0;
768 
769 
770 
771 //ERC721
772 
773 pragma solidity ^0.8.0;
774 
775 /**
776  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
777  * the Metadata extension, but not including the Enumerable extension, which is available separately as
778  * {ERC721Enumerable}.
779  */
780 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
781     using Address for address;
782     using Strings for uint256;
783 
784     // Token name
785     string private _name;
786 
787     // Token symbol
788     string private _symbol;
789 
790     // Optional mapping for token URIs
791     mapping (uint256 => string) private _tokenURIs;
792 
793     // Base URI
794     string private _baseURI;
795 
796     // Mapping from token ID to owner address
797     mapping(uint256 => address) private _owners;
798 
799     // Mapping owner address to token count
800     mapping(address => uint256) private _balances;
801 
802     // Mapping from token ID to approved address
803     mapping(uint256 => address) private _tokenApprovals;
804 
805     // Mapping from owner to operator approvals
806     mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808     /**
809      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
810      */
811     constructor(string memory name_, string memory symbol_) {
812         _name = name_;
813         _symbol = symbol_;
814     }
815 
816     /**
817      * @dev See {IERC165-supportsInterface}.
818      */
819     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
820         return
821             interfaceId == type(IERC721).interfaceId ||
822             interfaceId == type(IERC721Metadata).interfaceId ||
823             super.supportsInterface(interfaceId);
824     }
825 
826     /**
827      * @dev See {IERC721-balanceOf}.
828      */
829     function balanceOf(address owner) public view virtual override returns (uint256) {
830         require(owner != address(0), "ERC721: balance query for the zero address");
831         return _balances[owner];
832     }
833 
834     /**
835      * @dev See {IERC721-ownerOf}.
836      */
837     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
838         address owner = _owners[tokenId];
839         require(owner != address(0), "ERC721: owner query for nonexistent token");
840         return owner;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-name}.
845      */
846     function name() public view virtual override returns (string memory) {
847         return _name;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-symbol}.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857 /**
858      * @dev See {IERC721Metadata-tokenURI}.
859      */
860     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
861         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
862 
863         string memory _tokenURI = _tokenURIs[tokenId];
864         string memory base = baseURI();
865 
866         // If there is no base URI, return the token URI.
867         if (bytes(base).length == 0) {
868             return _tokenURI;
869         }
870         // If both are set, connect the baseURI and tokenURI (via abi.encodePacked).
871         if (bytes(_tokenURI).length > 0) {
872             return string(abi.encodePacked(base, _tokenURI));
873         }
874         // If there is a baseURI but no tokenURI, connect the tokenID to the baseURI.
875         return string(abi.encodePacked(base, tokenId.toString()));
876     }
877 
878     /**
879      * @dev Internal function to set the base URI for all token IDs. It is
880      * automatically added as a prefix to the value returned in {tokenURI},
881      * or to the token ID if {tokenURI} is empty.
882      */
883     function _setBaseURI(string memory baseURI_) internal virtual {
884         _baseURI = baseURI_;
885     }
886 
887     /**
888     * @dev Returns the base URI set via {_setBaseURI}. This will be
889     * automatically added as a prefix in {tokenURI} to each token's URI, or
890     * to the token ID if no specific URI is set for that token ID.
891     */
892     function baseURI() public view virtual returns (string memory) {
893         return _baseURI;
894     }
895 
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public virtual override {
901         address owner = ERC721.ownerOf(tokenId);
902         require(to != owner, "ERC721: approval to current owner");
903 
904         require(
905             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
906             "ERC721: approve caller is not owner nor approved for all"
907         );
908 
909         _approve(to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-getApproved}.
914      */
915     function getApproved(uint256 tokenId) public view virtual override returns (address) {
916         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved) public virtual override {
925         require(operator != _msgSender(), "ERC721: approve to caller");
926 
927         _operatorApprovals[_msgSender()][operator] = approved;
928         emit ApprovalForAll(_msgSender(), operator, approved);
929     }
930 
931     /**
932      * @dev See {IERC721-isApprovedForAll}.
933      */
934     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
935         return _operatorApprovals[owner][operator];
936     }
937 
938     /**
939      * @dev See {IERC721-transferFrom}.
940      */
941     function transferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         //solhint-disable-next-line max-line-length
947         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
948 
949         _transfer(from, to, tokenId);
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) public virtual override {
960         safeTransferFrom(from, to, tokenId, "");
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) public virtual override {
972         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
973         _safeTransfer(from, to, tokenId, _data);
974     }
975 
976     /**
977      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
978      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
979      *
980      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
981      *
982      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
983      * implement alternative mechanisms to perform token transfer, such as signature-based.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must exist and be owned by `from`.
990      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _safeTransfer(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) internal virtual {
1000         _transfer(from, to, tokenId);
1001         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1002     }
1003 
1004     /**
1005      * @dev Returns whether `tokenId` exists.
1006      *
1007      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1008      *
1009      * Tokens start existing when they are minted (`_mint`),
1010      * and stop existing when they are burned (`_burn`).
1011      */
1012     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1013         return _owners[tokenId] != address(0);
1014     }
1015 
1016     /**
1017      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1024         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1025         address owner = ERC721.ownerOf(tokenId);
1026         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1027     }
1028 
1029     /**
1030      * @dev Safely mints `tokenId` and transfers it to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must not exist.
1035      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _safeMint(address to, uint256 tokenId) internal virtual {
1040         _safeMint(to, tokenId, "");
1041     }
1042 
1043     /**
1044      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1045      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1046      */
1047     function _safeMint(
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) internal virtual {
1052         _mint(to, tokenId);
1053         require(
1054             _checkOnERC721Received(address(0), to, tokenId, _data),
1055             "ERC721: transfer to non ERC721Receiver implementer"
1056         );
1057     }
1058 
1059     /**
1060      * @dev Mints `tokenId` and transfers it to `to`.
1061      *
1062      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must not exist.
1067      * - `to` cannot be the zero address.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _mint(address to, uint256 tokenId) internal virtual {
1072         require(to != address(0), "ERC721: mint to the zero address");
1073         require(!_exists(tokenId), "ERC721: token already minted");
1074 
1075         _beforeTokenTransfer(address(0), to, tokenId);
1076 
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(address(0), to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Destroys `tokenId`.
1085      * The approval is cleared when the token is burned.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _burn(uint256 tokenId) internal virtual {
1094         address owner = ERC721.ownerOf(tokenId);
1095 
1096         _beforeTokenTransfer(owner, address(0), tokenId);
1097 
1098         // Clear approvals
1099         _approve(address(0), tokenId);
1100 
1101         _balances[owner] -= 1;
1102         delete _owners[tokenId];
1103 
1104         emit Transfer(owner, address(0), tokenId);
1105     }
1106 
1107     /**
1108      * @dev Transfers `tokenId` from `from` to `to`.
1109      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must be owned by `from`.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _transfer(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) internal virtual {
1123         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1124         require(to != address(0), "ERC721: transfer to the zero address");
1125 
1126         _beforeTokenTransfer(from, to, tokenId);
1127 
1128         // Clear approvals from the previous owner
1129         _approve(address(0), tokenId);
1130 
1131         _balances[from] -= 1;
1132         _balances[to] += 1;
1133         _owners[tokenId] = to;
1134 
1135         emit Transfer(from, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Approve `to` to operate on `tokenId`
1140      *
1141      * Emits a {Approval} event.
1142      */
1143     function _approve(address to, uint256 tokenId) internal virtual {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1150      * The call is not executed if the target address is not a contract.
1151      *
1152      * @param from address representing the previous owner of the given token ID
1153      * @param to target address that will receive the tokens
1154      * @param tokenId uint256 ID of the token to be transferred
1155      * @param _data bytes optional data to send along with the call
1156      * @return bool whether the call correctly returned the expected magic value
1157      */
1158     function _checkOnERC721Received(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) private returns (bool) {
1164         if (to.isContract()) {
1165             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1166                 return retval == IERC721Receiver.onERC721Received.selector;
1167             } catch (bytes memory reason) {
1168                 if (reason.length == 0) {
1169                     revert("ERC721: transfer to non ERC721Receiver implementer");
1170                 } else {
1171                     assembly {
1172                         revert(add(32, reason), mload(reason))
1173                     }
1174                 }
1175             }
1176         } else {
1177             return true;
1178         }
1179     }
1180 
1181     /**
1182      * @dev Hook that is called before any token transfer. This includes minting
1183      * and burning.
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` will be minted for `to`.
1190      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1191      * - `from` and `to` are never both zero.
1192      *
1193      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1194      */
1195     function _beforeTokenTransfer(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) internal virtual {}
1200 }
1201 
1202 
1203 /**
1204  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1205  * enumerability of all the token ids in the contract as well as all token ids owned by each
1206  * account.
1207  */
1208 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1209     // Mapping from owner to list of owned token IDs
1210     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1211 
1212     // Mapping from token ID to index of the owner tokens list
1213     mapping(uint256 => uint256) private _ownedTokensIndex;
1214 
1215     // Array with all token ids, used for enumeration
1216     uint256[] private _allTokens;
1217 
1218     // Mapping from token id to position in the allTokens array
1219     mapping(uint256 => uint256) private _allTokensIndex;
1220 
1221     /**
1222      * @dev See {IERC165-supportsInterface}.
1223      */
1224     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1225         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1226     }
1227 
1228     /**
1229      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1230      */
1231     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1232         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1233         return _ownedTokens[owner][index];
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Enumerable-totalSupply}.
1238      */
1239     function totalSupply() public view virtual override returns (uint256) {
1240         return _allTokens.length;
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Enumerable-tokenByIndex}.
1245      */
1246     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1247         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1248         return _allTokens[index];
1249     }
1250 
1251     /**
1252      * @dev Hook that is called before any token transfer. This includes minting
1253      * and burning.
1254      *
1255      * Calling conditions:
1256      *
1257      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1258      * transferred to `to`.
1259      * - When `from` is zero, `tokenId` will be minted for `to`.
1260      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1261      * - `from` cannot be the zero address.
1262      * - `to` cannot be the zero address.
1263      *
1264      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1265      */
1266     function _beforeTokenTransfer(
1267         address from,
1268         address to,
1269         uint256 tokenId
1270     ) internal virtual override {
1271         super._beforeTokenTransfer(from, to, tokenId);
1272 
1273         if (from == address(0)) {
1274             _addTokenToAllTokensEnumeration(tokenId);
1275         } else if (from != to) {
1276             _removeTokenFromOwnerEnumeration(from, tokenId);
1277         }
1278         if (to == address(0)) {
1279             _removeTokenFromAllTokensEnumeration(tokenId);
1280         } else if (to != from) {
1281             _addTokenToOwnerEnumeration(to, tokenId);
1282         }
1283     }
1284 
1285     /**
1286      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1287      * @param to address representing the new owner of the given token ID
1288      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1289      */
1290     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1291         uint256 length = ERC721.balanceOf(to);
1292         _ownedTokens[to][length] = tokenId;
1293         _ownedTokensIndex[tokenId] = length;
1294     }
1295 
1296     /**
1297      * @dev Private function to add a token to this extension's token tracking data structures.
1298      * @param tokenId uint256 ID of the token to be added to the tokens list
1299      */
1300     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1301         _allTokensIndex[tokenId] = _allTokens.length;
1302         _allTokens.push(tokenId);
1303     }
1304 
1305     /**
1306      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1307      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1308      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1309      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1310      * @param from address representing the previous owner of the given token ID
1311      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1312      */
1313     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1314         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1315         // then delete the last slot (swap and pop).
1316 
1317         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1318         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1319 
1320         // When the token to delete is the last token, the swap operation is unnecessary
1321         if (tokenIndex != lastTokenIndex) {
1322             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1323 
1324             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1325             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1326         }
1327 
1328         // This also deletes the contents at the last position of the array
1329         delete _ownedTokensIndex[tokenId];
1330         delete _ownedTokens[from][lastTokenIndex];
1331     }
1332 
1333     /**
1334      * @dev Private function to remove a token from this extension's token tracking data structures.
1335      * This has O(1) time complexity, but alters the order of the _allTokens array.
1336      * @param tokenId uint256 ID of the token to be removed from the tokens list
1337      */
1338     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1339         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1340         // then delete the last slot (swap and pop).
1341 
1342         uint256 lastTokenIndex = _allTokens.length - 1;
1343         uint256 tokenIndex = _allTokensIndex[tokenId];
1344 
1345         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1346         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1347         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1348         uint256 lastTokenId = _allTokens[lastTokenIndex];
1349 
1350         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1351         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1352 
1353         // This also deletes the contents at the last position of the array
1354         delete _allTokensIndex[tokenId];
1355         _allTokens.pop();
1356     }
1357 }
1358 
1359 //SkullIsland
1360 interface IKongKaiju {
1361     function ownerOf(uint id) external view returns (address);
1362     function iskong(uint16 id) external view returns (bool);
1363     function transferFrom(address from, address to, uint tokenId) external;
1364     function safeTransferFrom(address from, address to, uint tokenId, bytes memory _data) external;
1365     function GetTokenIdLevel(uint16 _tokenID) external view returns (uint16);
1366 }
1367 
1368 interface IGamma {
1369     function mint(address account, uint amount) external;
1370 }
1371 
1372 contract SkullIsland is Ownable, IERC721Receiver {
1373     bool private _paused = false;
1374 
1375     uint16 private _randomIndex = 0;
1376     uint private _randomCalls = 0;
1377     mapping(uint => address) private _TopEXAddress;
1378 
1379     struct Stake {
1380         uint16 tokenId;
1381         uint80 value;
1382         address owner;
1383     }
1384 
1385     event TokenStaked(address owner, uint16 tokenId, uint value);
1386     event kaijuClaimed(uint16 tokenId, uint earned, bool unstaked);
1387     event KongClaimed(uint16 tokenId, uint earned, bool unstaked);
1388 
1389     IKongKaiju public KongKaiju;
1390     IGamma public Gamma;
1391 
1392     mapping(uint256 => uint256) public kaijuIndices;
1393     mapping(address => Stake[]) public kaijuStake;
1394 
1395     mapping(uint256 => uint256) public KongIndices;
1396     mapping(address => Stake[]) public KongStake;
1397     address[] public KongHolders;
1398 
1399     // Total staked tokens
1400     uint public totalkaijuStaked;
1401     uint public totalKongStaked = 0;
1402     uint public unaccountedRewards = 0;
1403 
1404     // kaiju earn 10000 $Gamma per day
1405     uint public constant DAILY_Gamma_RATE = 10000 ether;
1406     uint public constant MINIMUM_TIME_TO_EXIT = 2 days;
1407     uint16 public constant TAX_PERCENTAGE = 20;
1408     uint public MAXIMUM_GLOBAL_Gamma = 1700000000 ether;
1409 
1410     uint public totalGammaEarned;
1411 
1412     uint public lastClaimTimestamp;
1413     uint public KongReward = 0;
1414 
1415     // emergency rescue to allow unstaking without any checks but without $Gamma
1416     bool public rescueEnabled = false;
1417 
1418     constructor() {
1419         // Use top exchange addresses to get random number.  Balances change every second
1420         _TopEXAddress[0] = 0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8;
1421         _TopEXAddress[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1422         _TopEXAddress[2] = 0xf66852bC122fD40bFECc63CD48217E88bda12109;
1423         _TopEXAddress[3] = 0x267be1C1D684F78cb4F6a176C4911b741E4Ffdc0;
1424         _TopEXAddress[4] = 0x28C6c06298d514Db089934071355E5743bf21d60;
1425     }
1426 
1427     function paused() public view virtual returns (bool) {
1428         return _paused;
1429     }
1430 
1431     modifier whenNotPaused() {
1432         require(!paused(), "Pausable: paused");
1433         _;
1434     }
1435 
1436     modifier whenPaused() {
1437         require(paused(), "Pausable: not paused");
1438         _;
1439     }
1440 
1441     function setKongKaiju(address _KongKaiju) external onlyOwner {
1442         KongKaiju = IKongKaiju(_KongKaiju);
1443     }
1444 
1445     function setMAXIMUM_GLOBAL_Gamma(uint _MaxGamma) external onlyOwner {
1446         MAXIMUM_GLOBAL_Gamma = _MaxGamma;
1447     }
1448 
1449     function setGamma(address _Gamma) external onlyOwner {
1450         Gamma = IGamma(_Gamma);
1451     }
1452 
1453     function getAccountkaijus(address user) external view returns (Stake[] memory) {
1454         return kaijuStake[user];
1455     }
1456 
1457     function getAccountKongs(address user) external view returns (Stake[] memory) {
1458         return KongStake[user];
1459     }
1460 
1461     function addTokensToStake(address account, uint16[] calldata tokenIds) external {
1462         require(account == msg.sender || msg.sender == address(KongKaiju), "You do not have a permission to do that");
1463 
1464         for (uint i = 0; i < tokenIds.length; i++) {
1465             if (msg.sender != address(KongKaiju)) {
1466                 // dont do this step if its a mint + stake
1467                 require(KongKaiju.ownerOf(tokenIds[i]) == msg.sender, "This NFT does not belong to address");
1468                 KongKaiju.transferFrom(msg.sender, address(this), tokenIds[i]);
1469             } else if (tokenIds[i] == 0) {
1470                 continue; // there may be gaps in the array for stolen tokens
1471             }
1472 
1473             if (KongKaiju.iskong(tokenIds[i])) {
1474                 _stakeKongs(account, tokenIds[i]);
1475             } else {
1476                 _stakekaijus(account, tokenIds[i]);
1477             }
1478         }
1479     }
1480 
1481     function _stakekaijus(address account, uint16 tokenId) internal whenNotPaused _updateEarnings {
1482         totalkaijuStaked += 1;
1483 
1484         kaijuIndices[tokenId] = kaijuStake[account].length;
1485         kaijuStake[account].push(Stake({
1486             owner: account,
1487             tokenId: uint16(tokenId),
1488             value: uint80(block.timestamp)
1489         }));
1490         emit TokenStaked(account, tokenId, block.timestamp);
1491     }
1492 
1493 
1494     function _stakeKongs(address account, uint16 tokenId) internal {
1495         totalKongStaked += 1;
1496 
1497         // If account already has some Kongs no need to push it to the tracker
1498         if (KongStake[account].length == 0) {
1499             KongHolders.push(account);
1500         }
1501 
1502         KongIndices[tokenId] = KongStake[account].length;
1503         KongStake[account].push(Stake({
1504             owner: account,
1505             tokenId: uint16(tokenId),
1506             value: uint80(KongReward)
1507             }));
1508 
1509         emit TokenStaked(account, tokenId, KongReward);
1510     }
1511 
1512 
1513     function claimFromStake(uint16[] calldata tokenIds, bool unstake) external whenNotPaused _updateEarnings {
1514         uint owed = 0;
1515         for (uint i = 0; i < tokenIds.length; i++) {
1516             if (!KongKaiju.iskong(tokenIds[i])) {
1517                 owed += _claimFromKaiju(tokenIds[i], unstake);
1518             } else {
1519                 owed += _claimFromKong(tokenIds[i], unstake);
1520             }
1521         }
1522         if (owed == 0) return;
1523         Gamma.mint(msg.sender, owed);
1524     }
1525 
1526     function _claimFromKaiju(uint16 tokenId, bool unstake) internal returns (uint owed) {
1527         Stake memory stake = kaijuStake[msg.sender][kaijuIndices[tokenId]];
1528         require(stake.owner == msg.sender, "This ID does not belong to address");
1529         require(!(unstake && block.timestamp - stake.value < MINIMUM_TIME_TO_EXIT), "Need to wait 2 days since last stake");
1530 
1531         if (totalGammaEarned < MAXIMUM_GLOBAL_Gamma) {
1532             owed = ((block.timestamp - stake.value) * DAILY_Gamma_RATE) / 1 days;
1533         } else if (stake.value > lastClaimTimestamp) {
1534             owed = 0; // $Gamma production stopped already
1535         } else {
1536             owed = ((lastClaimTimestamp - stake.value) * DAILY_Gamma_RATE) / 1 days; // stop earning additional $Gamma if it's all been earned
1537         }
1538         if (unstake) {
1539             if (getSomeRandomNumber(tokenId, 100) <= 50) {
1540                 _payTax(owed);
1541                 owed = 0;
1542             }
1543             updateRandomIndex();
1544             totalkaijuStaked -= 1;
1545 
1546             Stake memory lastStake = kaijuStake[msg.sender][kaijuStake[msg.sender].length - 1];
1547             kaijuStake[msg.sender][kaijuIndices[tokenId]] = lastStake;
1548             kaijuIndices[lastStake.tokenId] = kaijuIndices[tokenId];
1549             kaijuStake[msg.sender].pop();
1550             delete kaijuIndices[tokenId];
1551 
1552             KongKaiju.safeTransferFrom(address(this), msg.sender, tokenId, "");
1553         } else {
1554             uint16 NewTAX_PERCENTAGE =  TAX_PERCENTAGE - KongKaiju.GetTokenIdLevel(tokenId);
1555             _payTax((owed * NewTAX_PERCENTAGE) / 100); // Pay some $Gamma to Kongs!
1556             owed = (owed * (100 - NewTAX_PERCENTAGE)) / 100;
1557             
1558             uint80 timestamp = uint80(block.timestamp);
1559 
1560             kaijuStake[msg.sender][kaijuIndices[tokenId]] = Stake({
1561                 owner: msg.sender,
1562                 tokenId: uint16(tokenId),
1563                 value: timestamp
1564             }); // reset stake
1565         }
1566 
1567         emit kaijuClaimed(tokenId, owed, unstake);
1568     }
1569 
1570     function _claimFromKong(uint16 tokenId, bool unstake) internal returns (uint owed) {
1571         require(KongKaiju.ownerOf(tokenId) == address(this), "This ID does not belong to address");
1572 
1573         Stake memory stake = KongStake[msg.sender][KongIndices[tokenId]];
1574 
1575         require(stake.owner == msg.sender, "This ID does not belong to address");
1576         //increase reward by Kong level
1577         owed = (KongReward - stake.value)*(100+KongKaiju.GetTokenIdLevel(tokenId))/100; 
1578 
1579         if (unstake) {
1580             totalKongStaked -= 1; // Remove Kong from total staked
1581 
1582             Stake memory lastStake = KongStake[msg.sender][KongStake[msg.sender].length - 1];
1583             KongStake[msg.sender][KongIndices[tokenId]] = lastStake;
1584             KongIndices[lastStake.tokenId] = KongIndices[tokenId];
1585             KongStake[msg.sender].pop();
1586             delete KongIndices[tokenId];
1587             updateKongOwnerAddressList(msg.sender);
1588 
1589             KongKaiju.safeTransferFrom(address(this), msg.sender, tokenId, "");
1590         } else {
1591             KongStake[msg.sender][KongIndices[tokenId]] = Stake({
1592                 owner: msg.sender,
1593                 tokenId: uint16(tokenId),
1594                 value: uint80(KongReward)
1595             }); // reset stake
1596         }
1597         emit KongClaimed(tokenId, owed, unstake);
1598     }
1599 
1600     function updateKongOwnerAddressList(address account) internal {
1601         if (KongStake[account].length != 0) {
1602             return; // No need to update holders
1603         }
1604 
1605         // Update the address list of holders, account unstaked all Kongs
1606         address lastOwner = KongHolders[KongHolders.length - 1];
1607         uint indexOfHolder = 0;
1608         for (uint i = 0; i < KongHolders.length; i++) {
1609             if (KongHolders[i] == account) {
1610                 indexOfHolder = i;
1611                 break;
1612             }
1613         }
1614         KongHolders[indexOfHolder] = lastOwner;
1615         KongHolders.pop();
1616     }
1617 
1618     function rescue(uint16[] calldata tokenIds) external {
1619         require(rescueEnabled, "Rescue disabled");
1620         uint16 tokenId;
1621         Stake memory stake;
1622 
1623         for (uint16 i = 0; i < tokenIds.length; i++) {
1624             tokenId = tokenIds[i];
1625             if (!KongKaiju.iskong(tokenId)) {
1626                 stake = kaijuStake[msg.sender][kaijuIndices[tokenId]];
1627 
1628                 require(stake.owner == msg.sender, "This ID does not belong to address");
1629 
1630                 totalkaijuStaked -= 1;
1631 
1632                 Stake memory lastStake = kaijuStake[msg.sender][kaijuStake[msg.sender].length - 1];
1633                 kaijuStake[msg.sender][kaijuIndices[tokenId]] = lastStake;
1634                 kaijuIndices[lastStake.tokenId] = kaijuIndices[tokenId];
1635                 kaijuStake[msg.sender].pop();
1636                 delete kaijuIndices[tokenId];
1637 
1638                 KongKaiju.safeTransferFrom(address(this), msg.sender, tokenId, "");
1639 
1640                 emit kaijuClaimed(tokenId, 0, true);
1641             } else {
1642                 stake = KongStake[msg.sender][KongIndices[tokenId]];
1643         
1644                 require(stake.owner == msg.sender, "This NFT does not belong to address");
1645 
1646                 totalKongStaked -= 1;                
1647                     
1648                 Stake memory lastStake = KongStake[msg.sender][KongStake[msg.sender].length - 1];
1649                 KongStake[msg.sender][KongIndices[tokenId]] = lastStake;
1650                 KongIndices[lastStake.tokenId] = KongIndices[tokenId];
1651                 KongStake[msg.sender].pop();
1652                 delete KongIndices[tokenId];
1653                 updateKongOwnerAddressList(msg.sender);
1654                 
1655                 KongKaiju.safeTransferFrom(address(this), msg.sender, tokenId, "");
1656                 
1657                 emit KongClaimed(tokenId, 0, true);
1658             }
1659         }
1660     }
1661 
1662     function _payTax(uint _amount) internal {
1663         if (totalKongStaked == 0) {
1664             unaccountedRewards += _amount;
1665             return;
1666         }
1667 
1668         KongReward += (_amount + unaccountedRewards) / totalKongStaked;
1669         unaccountedRewards = 0;
1670     }
1671 
1672 
1673     modifier _updateEarnings() {
1674         if (totalGammaEarned < MAXIMUM_GLOBAL_Gamma) {
1675             totalGammaEarned += ((block.timestamp - lastClaimTimestamp) * totalkaijuStaked * DAILY_Gamma_RATE) / 1 days;
1676             lastClaimTimestamp = block.timestamp;
1677         }
1678         _;
1679     }
1680 
1681     function setRescueEnabled(bool _enabled) external onlyOwner {
1682         rescueEnabled = _enabled;
1683     }
1684 
1685     function setPaused(bool _state) external onlyOwner {
1686         _paused = _state;
1687     }
1688 
1689     function randomkongOwner() external returns (address) {
1690         if (totalKongStaked == 0) return address(0x0);
1691 
1692         uint holderIndex = getSomeRandomNumber(totalKongStaked, KongHolders.length);
1693         updateRandomIndex();
1694 
1695         return KongHolders[holderIndex];
1696     }
1697 
1698     function updateRandomIndex() internal {
1699         _randomIndex += 1;
1700         _randomCalls += 1;
1701         if (_randomIndex > 6) _randomIndex = 0;
1702     }
1703 
1704     function getSomeRandomNumber(uint _seed, uint _limit) internal view returns (uint16) {
1705         uint extra = 0;
1706         for (uint16 i = 0; i < 5; i++) {
1707             extra += _TopEXAddress[_randomIndex].balance;
1708         }
1709 
1710         uint random = uint(
1711             keccak256(
1712                 abi.encodePacked(
1713                     _seed,
1714                     blockhash(block.number - 1),
1715                     block.coinbase,
1716                     block.difficulty,
1717                     msg.sender,
1718                     extra,
1719                     _randomCalls,
1720                     _randomIndex
1721                 )
1722             )
1723         );
1724 
1725         return uint16(random % _limit);
1726     }
1727 
1728     function changeTopEXAddress(uint _id, address _address) external onlyOwner {
1729         _TopEXAddress[_id] = _address;
1730     }
1731 
1732     function shuffleSeeds(uint _seed, uint _max) external onlyOwner {
1733         uint shuffleCount = getSomeRandomNumber(_seed, _max);
1734         _randomIndex = uint16(shuffleCount);
1735         for (uint i = 0; i < shuffleCount; i++) {
1736             updateRandomIndex();
1737         }
1738     }
1739 
1740     function onERC721Received(
1741         address,
1742         address from,
1743         uint,
1744         bytes calldata
1745     ) external pure override returns (bytes4) {
1746         require(from == address(0x0), "Cannot send tokens to this contact directly");
1747         return IERC721Receiver.onERC721Received.selector;
1748     }
1749 }