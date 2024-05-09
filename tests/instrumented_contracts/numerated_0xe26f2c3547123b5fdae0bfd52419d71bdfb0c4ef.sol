1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies on extcodesize, which returns 0 for contracts in
33         // construction, since the code is only stored at the end of the
34         // constructor execution.
35 
36         uint256 size;
37         assembly {
38             size := extcodesize(account)
39         }
40         return size > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         (bool success, ) = recipient.call{value: amount}("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain `call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85         return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(
95         address target,
96         bytes memory data,
97         string memory errorMessage
98     ) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but also transferring `value` wei to `target`.
105      *
106      * Requirements:
107      *
108      * - the calling contract must have an ETH balance of at least `value`.
109      * - the called Solidity function must be `payable`.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 value
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
123      * with `errorMessage` as a fallback revert reason when `target` reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but performing a static call.
143      *
144      * _Available since v3.3._
145      */
146     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
147         return functionStaticCall(target, data, "Address: low-level static call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a static call.
153      *
154      * _Available since v3.3._
155      */
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(isContract(target), "Address: delegate call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.delegatecall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
196      * revert reason using the provided one.
197      *
198      * _Available since v4.3._
199      */
200     function verifyCallResult(
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) internal pure returns (bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @title ERC721 token receiver interface
232  * @dev Interface for any contract that wants to support safeTransfers
233  * from ERC721 asset contracts.
234  */
235 interface IERC721Receiver {
236     /**
237      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
238      * by `operator` from `from`, this function is called.
239      *
240      * It must return its Solidity selector to confirm the token transfer.
241      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
242      *
243      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
244      */
245     function onERC721Received(
246         address operator,
247         address from,
248         uint256 tokenId,
249         bytes calldata data
250     ) external returns (bytes4);
251 }
252 
253 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
254 
255 
256 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev Interface of the ERC165 standard, as defined in the
262  * https://eips.ethereum.org/EIPS/eip-165[EIP].
263  *
264  * Implementers can declare support of contract interfaces, which can then be
265  * queried by others ({ERC165Checker}).
266  *
267  * For an implementation, see {ERC165}.
268  */
269 interface IERC165 {
270     /**
271      * @dev Returns true if this contract implements the interface defined by
272      * `interfaceId`. See the corresponding
273      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
274      * to learn more about how these ids are created.
275      *
276      * This function call must use less than 30 000 gas.
277      */
278     function supportsInterface(bytes4 interfaceId) external view returns (bool);
279 }
280 
281 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 
289 /**
290  * @dev Implementation of the {IERC165} interface.
291  *
292  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
293  * for the additional interface id that will be supported. For example:
294  *
295  * ```solidity
296  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
298  * }
299  * ```
300  *
301  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
302  */
303 abstract contract ERC165 is IERC165 {
304     /**
305      * @dev See {IERC165-supportsInterface}.
306      */
307     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
308         return interfaceId == type(IERC165).interfaceId;
309     }
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 
320 /**
321  * @dev Required interface of an ERC721 compliant contract.
322  */
323 interface IERC721 is IERC165 {
324     /**
325      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
326      */
327     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
328 
329     /**
330      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
331      */
332     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
336      */
337     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
338 
339     /**
340      * @dev Returns the number of tokens in ``owner``'s account.
341      */
342     function balanceOf(address owner) external view returns (uint256 balance);
343 
344     /**
345      * @dev Returns the owner of the `tokenId` token.
346      *
347      * Requirements:
348      *
349      * - `tokenId` must exist.
350      */
351     function ownerOf(uint256 tokenId) external view returns (address owner);
352 
353     /**
354      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
355      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
356      *
357      * Requirements:
358      *
359      * - `from` cannot be the zero address.
360      * - `to` cannot be the zero address.
361      * - `tokenId` token must exist and be owned by `from`.
362      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
363      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
364      *
365      * Emits a {Transfer} event.
366      */
367     function safeTransferFrom(
368         address from,
369         address to,
370         uint256 tokenId
371     ) external;
372 
373     /**
374      * @dev Transfers `tokenId` token from `from` to `to`.
375      *
376      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
377      *
378      * Requirements:
379      *
380      * - `from` cannot be the zero address.
381      * - `to` cannot be the zero address.
382      * - `tokenId` token must be owned by `from`.
383      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external;
392 
393     /**
394      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
395      * The approval is cleared when the token is transferred.
396      *
397      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
398      *
399      * Requirements:
400      *
401      * - The caller must own the token or be an approved operator.
402      * - `tokenId` must exist.
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address to, uint256 tokenId) external;
407 
408     /**
409      * @dev Returns the account approved for `tokenId` token.
410      *
411      * Requirements:
412      *
413      * - `tokenId` must exist.
414      */
415     function getApproved(uint256 tokenId) external view returns (address operator);
416 
417     /**
418      * @dev Approve or remove `operator` as an operator for the caller.
419      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
420      *
421      * Requirements:
422      *
423      * - The `operator` cannot be the caller.
424      *
425      * Emits an {ApprovalForAll} event.
426      */
427     function setApprovalForAll(address operator, bool _approved) external;
428 
429     /**
430      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
431      *
432      * See {setApprovalForAll}
433      */
434     function isApprovedForAll(address owner, address operator) external view returns (bool);
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId,
453         bytes calldata data
454     ) external;
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
467  * @dev See https://eips.ethereum.org/EIPS/eip-721
468  */
469 interface IERC721Enumerable is IERC721 {
470     /**
471      * @dev Returns the total amount of tokens stored by the contract.
472      */
473     function totalSupply() external view returns (uint256);
474 
475     /**
476      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
477      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
478      */
479     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
480 
481     /**
482      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
483      * Use along with {totalSupply} to enumerate all tokens.
484      */
485     function tokenByIndex(uint256 index) external view returns (uint256);
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
498  * @dev See https://eips.ethereum.org/EIPS/eip-721
499  */
500 interface IERC721Metadata is IERC721 {
501     /**
502      * @dev Returns the token collection name.
503      */
504     function name() external view returns (string memory);
505 
506     /**
507      * @dev Returns the token collection symbol.
508      */
509     function symbol() external view returns (string memory);
510 
511     /**
512      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
513      */
514     function tokenURI(uint256 tokenId) external view returns (string memory);
515 }
516 
517 // File: @openzeppelin/contracts/utils/Context.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Provides information about the current execution context, including the
526  * sender of the transaction and its data. While these are generally available
527  * via msg.sender and msg.data, they should not be accessed in such a direct
528  * manner, since when dealing with meta-transactions the account sending and
529  * paying for execution may not be the actual sender (as far as an application
530  * is concerned).
531  *
532  * This contract is only required for intermediate, library-like contracts.
533  */
534 abstract contract Context {
535     function _msgSender() internal view virtual returns (address) {
536         return msg.sender;
537     }
538 
539     function _msgData() internal view virtual returns (bytes calldata) {
540         return msg.data;
541     }
542 }
543 
544 // File: @openzeppelin/contracts/access/Ownable.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev Contract module which provides a basic access control mechanism, where
554  * there is an account (an owner) that can be granted exclusive access to
555  * specific functions.
556  *
557  * By default, the owner account will be the one that deploys the contract. This
558  * can later be changed with {transferOwnership}.
559  *
560  * This module is used through inheritance. It will make available the modifier
561  * `onlyOwner`, which can be applied to your functions to restrict their use to
562  * the owner.
563  */
564 abstract contract Ownable is Context {
565     address private _owner;
566 
567     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
568 
569     /**
570      * @dev Initializes the contract setting the deployer as the initial owner.
571      */
572     constructor() {
573         _transferOwnership(_msgSender());
574     }
575 
576     /**
577      * @dev Returns the address of the current owner.
578      */
579     function owner() public view virtual returns (address) {
580         return _owner;
581     }
582 
583     /**
584      * @dev Throws if called by any account other than the owner.
585      */
586     modifier onlyOwner() {
587         require(owner() == _msgSender(), "Ownable: caller is not the owner");
588         _;
589     }
590 
591     /**
592      * @dev Leaves the contract without owner. It will not be possible to call
593      * `onlyOwner` functions anymore. Can only be called by the current owner.
594      *
595      * NOTE: Renouncing ownership will leave the contract without an owner,
596      * thereby removing any functionality that is only available to the owner.
597      */
598     function renounceOwnership() public virtual onlyOwner {
599         _transferOwnership(address(0));
600     }
601 
602     /**
603      * @dev Transfers ownership of the contract to a new account (`newOwner`).
604      * Can only be called by the current owner.
605      */
606     function transferOwnership(address newOwner) public virtual onlyOwner {
607         require(newOwner != address(0), "Ownable: new owner is the zero address");
608         _transferOwnership(newOwner);
609     }
610 
611     /**
612      * @dev Transfers ownership of the contract to a new account (`newOwner`).
613      * Internal function without access restriction.
614      */
615     function _transferOwnership(address newOwner) internal virtual {
616         address oldOwner = _owner;
617         _owner = newOwner;
618         emit OwnershipTransferred(oldOwner, newOwner);
619     }
620 }
621 
622 // File: @openzeppelin/contracts/security/Pausable.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @dev Contract module which allows children to implement an emergency stop
632  * mechanism that can be triggered by an authorized account.
633  *
634  * This module is used through inheritance. It will make available the
635  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
636  * the functions of your contract. Note that they will not be pausable by
637  * simply including this module, only once the modifiers are put in place.
638  */
639 abstract contract Pausable is Context {
640     /**
641      * @dev Emitted when the pause is triggered by `account`.
642      */
643     event Paused(address account);
644 
645     /**
646      * @dev Emitted when the pause is lifted by `account`.
647      */
648     event Unpaused(address account);
649 
650     bool private _paused;
651 
652     /**
653      * @dev Initializes the contract in unpaused state.
654      */
655     constructor() {
656         _paused = false;
657     }
658 
659     /**
660      * @dev Returns true if the contract is paused, and false otherwise.
661      */
662     function paused() public view virtual returns (bool) {
663         return _paused;
664     }
665 
666     /**
667      * @dev Modifier to make a function callable only when the contract is not paused.
668      *
669      * Requirements:
670      *
671      * - The contract must not be paused.
672      */
673     modifier whenNotPaused() {
674         require(!paused(), "Pausable: paused");
675         _;
676     }
677 
678     /**
679      * @dev Modifier to make a function callable only when the contract is paused.
680      *
681      * Requirements:
682      *
683      * - The contract must be paused.
684      */
685     modifier whenPaused() {
686         require(paused(), "Pausable: not paused");
687         _;
688     }
689 
690     /**
691      * @dev Triggers stopped state.
692      *
693      * Requirements:
694      *
695      * - The contract must not be paused.
696      */
697     function _pause() internal virtual whenNotPaused {
698         _paused = true;
699         emit Paused(_msgSender());
700     }
701 
702     /**
703      * @dev Returns to normal state.
704      *
705      * Requirements:
706      *
707      * - The contract must be paused.
708      */
709     function _unpause() internal virtual whenPaused {
710         _paused = false;
711         emit Unpaused(_msgSender());
712     }
713 }
714 
715 // File: @openzeppelin/contracts/utils/Strings.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 /**
723  * @dev String operations.
724  */
725 library Strings {
726     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
730      */
731     function toString(uint256 value) internal pure returns (string memory) {
732         // Inspired by OraclizeAPI's implementation - MIT licence
733         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
734 
735         if (value == 0) {
736             return "0";
737         }
738         uint256 temp = value;
739         uint256 digits;
740         while (temp != 0) {
741             digits++;
742             temp /= 10;
743         }
744         bytes memory buffer = new bytes(digits);
745         while (value != 0) {
746             digits -= 1;
747             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
748             value /= 10;
749         }
750         return string(buffer);
751     }
752 
753     /**
754      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
755      */
756     function toHexString(uint256 value) internal pure returns (string memory) {
757         if (value == 0) {
758             return "0x00";
759         }
760         uint256 temp = value;
761         uint256 length = 0;
762         while (temp != 0) {
763             length++;
764             temp >>= 8;
765         }
766         return toHexString(value, length);
767     }
768 
769     /**
770      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
771      */
772     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
773         bytes memory buffer = new bytes(2 * length + 2);
774         buffer[0] = "0";
775         buffer[1] = "x";
776         for (uint256 i = 2 * length + 1; i > 1; --i) {
777             buffer[i] = _HEX_SYMBOLS[value & 0xf];
778             value >>= 4;
779         }
780         require(value == 0, "Strings: hex length insufficient");
781         return string(buffer);
782     }
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
786 
787 
788 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 
794 
795 
796 
797 
798 
799 /**
800  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
801  * the Metadata extension, but not including the Enumerable extension, which is available separately as
802  * {ERC721Enumerable}.
803  */
804 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
805     using Address for address;
806     using Strings for uint256;
807 
808     // Token name
809     string private _name;
810 
811     // Token symbol
812     string private _symbol;
813 
814     // Mapping from token ID to owner address
815     mapping(uint256 => address) private _owners;
816 
817     // Mapping owner address to token count
818     mapping(address => uint256) private _balances;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     /**
827      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
828      */
829     constructor(string memory name_, string memory symbol_) {
830         _name = name_;
831         _symbol = symbol_;
832     }
833 
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
838         return
839             interfaceId == type(IERC721).interfaceId ||
840             interfaceId == type(IERC721Metadata).interfaceId ||
841             super.supportsInterface(interfaceId);
842     }
843 
844     /**
845      * @dev See {IERC721-balanceOf}.
846      */
847     function balanceOf(address owner) public view virtual override returns (uint256) {
848         require(owner != address(0), "ERC721: balance query for the zero address");
849         return _balances[owner];
850     }
851 
852     /**
853      * @dev See {IERC721-ownerOf}.
854      */
855     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
856         address owner = _owners[tokenId];
857         require(owner != address(0), "ERC721: owner query for nonexistent token");
858         return owner;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-name}.
863      */
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-symbol}.
870      */
871     function symbol() public view virtual override returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-tokenURI}.
877      */
878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
879         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
880 
881         string memory baseURI = _baseURI();
882         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
883     }
884 
885     /**
886      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
887      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
888      * by default, can be overriden in child contracts.
889      */
890     function _baseURI() internal view virtual returns (string memory) {
891         return "";
892     }
893 
894     /**
895      * @dev See {IERC721-approve}.
896      */
897     function approve(address to, uint256 tokenId) public virtual override {
898         address owner = ERC721.ownerOf(tokenId);
899         require(to != owner, "ERC721: approval to current owner");
900 
901         require(
902             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
903             "ERC721: approve caller is not owner nor approved for all"
904         );
905 
906         _approve(to, tokenId);
907     }
908 
909     /**
910      * @dev See {IERC721-getApproved}.
911      */
912     function getApproved(uint256 tokenId) public view virtual override returns (address) {
913         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
914 
915         return _tokenApprovals[tokenId];
916     }
917 
918     /**
919      * @dev See {IERC721-setApprovalForAll}.
920      */
921     function setApprovalForAll(address operator, bool approved) public virtual override {
922         _setApprovalForAll(_msgSender(), operator, approved);
923     }
924 
925     /**
926      * @dev See {IERC721-isApprovedForAll}.
927      */
928     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
929         return _operatorApprovals[owner][operator];
930     }
931 
932     /**
933      * @dev See {IERC721-transferFrom}.
934      */
935     function transferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public virtual override {
940         //solhint-disable-next-line max-line-length
941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
942 
943         _transfer(from, to, tokenId);
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         safeTransferFrom(from, to, tokenId, "");
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) public virtual override {
966         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
967         _safeTransfer(from, to, tokenId, _data);
968     }
969 
970     /**
971      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
972      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
973      *
974      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
975      *
976      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
977      * implement alternative mechanisms to perform token transfer, such as signature-based.
978      *
979      * Requirements:
980      *
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must exist and be owned by `from`.
984      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeTransfer(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) internal virtual {
994         _transfer(from, to, tokenId);
995         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
996     }
997 
998     /**
999      * @dev Returns whether `tokenId` exists.
1000      *
1001      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1002      *
1003      * Tokens start existing when they are minted (`_mint`),
1004      * and stop existing when they are burned (`_burn`).
1005      */
1006     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1007         return _owners[tokenId] != address(0);
1008     }
1009 
1010     /**
1011      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      */
1017     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1018         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1019         address owner = ERC721.ownerOf(tokenId);
1020         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
1044         bytes memory _data
1045     ) internal virtual {
1046         _mint(to, tokenId);
1047         require(
1048             _checkOnERC721Received(address(0), to, tokenId, _data),
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
1075     }
1076 
1077     /**
1078      * @dev Destroys `tokenId`.
1079      * The approval is cleared when the token is burned.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _burn(uint256 tokenId) internal virtual {
1088         address owner = ERC721.ownerOf(tokenId);
1089 
1090         _beforeTokenTransfer(owner, address(0), tokenId);
1091 
1092         // Clear approvals
1093         _approve(address(0), tokenId);
1094 
1095         _balances[owner] -= 1;
1096         delete _owners[tokenId];
1097 
1098         emit Transfer(owner, address(0), tokenId);
1099     }
1100 
1101     /**
1102      * @dev Transfers `tokenId` from `from` to `to`.
1103      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1104      *
1105      * Requirements:
1106      *
1107      * - `to` cannot be the zero address.
1108      * - `tokenId` token must be owned by `from`.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _transfer(
1113         address from,
1114         address to,
1115         uint256 tokenId
1116     ) internal virtual {
1117         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1118         require(to != address(0), "ERC721: transfer to the zero address");
1119 
1120         _beforeTokenTransfer(from, to, tokenId);
1121 
1122         // Clear approvals from the previous owner
1123         _approve(address(0), tokenId);
1124 
1125         _balances[from] -= 1;
1126         _balances[to] += 1;
1127         _owners[tokenId] = to;
1128 
1129         emit Transfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev Approve `to` to operate on `tokenId`
1134      *
1135      * Emits a {Approval} event.
1136      */
1137     function _approve(address to, uint256 tokenId) internal virtual {
1138         _tokenApprovals[tokenId] = to;
1139         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Approve `operator` to operate on all of `owner` tokens
1144      *
1145      * Emits a {ApprovalForAll} event.
1146      */
1147     function _setApprovalForAll(
1148         address owner,
1149         address operator,
1150         bool approved
1151     ) internal virtual {
1152         require(owner != operator, "ERC721: approve to caller");
1153         _operatorApprovals[owner][operator] = approved;
1154         emit ApprovalForAll(owner, operator, approved);
1155     }
1156 
1157     /**
1158      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1159      * The call is not executed if the target address is not a contract.
1160      *
1161      * @param from address representing the previous owner of the given token ID
1162      * @param to target address that will receive the tokens
1163      * @param tokenId uint256 ID of the token to be transferred
1164      * @param _data bytes optional data to send along with the call
1165      * @return bool whether the call correctly returned the expected magic value
1166      */
1167     function _checkOnERC721Received(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) private returns (bool) {
1173         if (to.isContract()) {
1174             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1175                 return retval == IERC721Receiver.onERC721Received.selector;
1176             } catch (bytes memory reason) {
1177                 if (reason.length == 0) {
1178                     revert("ERC721: transfer to non ERC721Receiver implementer");
1179                 } else {
1180                     assembly {
1181                         revert(add(32, reason), mload(reason))
1182                     }
1183                 }
1184             }
1185         } else {
1186             return true;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before any token transfer. This includes minting
1192      * and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1197      * transferred to `to`.
1198      * - When `from` is zero, `tokenId` will be minted for `to`.
1199      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1200      * - `from` and `to` are never both zero.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _beforeTokenTransfer(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) internal virtual {}
1209 }
1210 
1211 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1212 
1213 
1214 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 
1219 
1220 /**
1221  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1222  * enumerability of all the token ids in the contract as well as all token ids owned by each
1223  * account.
1224  */
1225 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1226     // Mapping from owner to list of owned token IDs
1227     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1228 
1229     // Mapping from token ID to index of the owner tokens list
1230     mapping(uint256 => uint256) private _ownedTokensIndex;
1231 
1232     // Array with all token ids, used for enumeration
1233     uint256[] private _allTokens;
1234 
1235     // Mapping from token id to position in the allTokens array
1236     mapping(uint256 => uint256) private _allTokensIndex;
1237 
1238     /**
1239      * @dev See {IERC165-supportsInterface}.
1240      */
1241     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1242         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1247      */
1248     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1249         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1250         return _ownedTokens[owner][index];
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Enumerable-totalSupply}.
1255      */
1256     function totalSupply() public view virtual override returns (uint256) {
1257         return _allTokens.length;
1258     }
1259 
1260     /**
1261      * @dev See {IERC721Enumerable-tokenByIndex}.
1262      */
1263     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1264         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1265         return _allTokens[index];
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before any token transfer. This includes minting
1270      * and burning.
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` will be minted for `to`.
1277      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1278      * - `from` cannot be the zero address.
1279      * - `to` cannot be the zero address.
1280      *
1281      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1282      */
1283     function _beforeTokenTransfer(
1284         address from,
1285         address to,
1286         uint256 tokenId
1287     ) internal virtual override {
1288         super._beforeTokenTransfer(from, to, tokenId);
1289 
1290         if (from == address(0)) {
1291             _addTokenToAllTokensEnumeration(tokenId);
1292         } else if (from != to) {
1293             _removeTokenFromOwnerEnumeration(from, tokenId);
1294         }
1295         if (to == address(0)) {
1296             _removeTokenFromAllTokensEnumeration(tokenId);
1297         } else if (to != from) {
1298             _addTokenToOwnerEnumeration(to, tokenId);
1299         }
1300     }
1301 
1302     /**
1303      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1304      * @param to address representing the new owner of the given token ID
1305      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1306      */
1307     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1308         uint256 length = ERC721.balanceOf(to);
1309         _ownedTokens[to][length] = tokenId;
1310         _ownedTokensIndex[tokenId] = length;
1311     }
1312 
1313     /**
1314      * @dev Private function to add a token to this extension's token tracking data structures.
1315      * @param tokenId uint256 ID of the token to be added to the tokens list
1316      */
1317     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1318         _allTokensIndex[tokenId] = _allTokens.length;
1319         _allTokens.push(tokenId);
1320     }
1321 
1322     /**
1323      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1324      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1325      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1326      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1327      * @param from address representing the previous owner of the given token ID
1328      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1329      */
1330     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1331         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1332         // then delete the last slot (swap and pop).
1333 
1334         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1335         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1336 
1337         // When the token to delete is the last token, the swap operation is unnecessary
1338         if (tokenIndex != lastTokenIndex) {
1339             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1340 
1341             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1342             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1343         }
1344 
1345         // This also deletes the contents at the last position of the array
1346         delete _ownedTokensIndex[tokenId];
1347         delete _ownedTokens[from][lastTokenIndex];
1348     }
1349 
1350     /**
1351      * @dev Private function to remove a token from this extension's token tracking data structures.
1352      * This has O(1) time complexity, but alters the order of the _allTokens array.
1353      * @param tokenId uint256 ID of the token to be removed from the tokens list
1354      */
1355     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1356         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1357         // then delete the last slot (swap and pop).
1358 
1359         uint256 lastTokenIndex = _allTokens.length - 1;
1360         uint256 tokenIndex = _allTokensIndex[tokenId];
1361 
1362         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1363         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1364         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1365         uint256 lastTokenId = _allTokens[lastTokenIndex];
1366 
1367         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1368         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1369 
1370         // This also deletes the contents at the last position of the array
1371         delete _allTokensIndex[tokenId];
1372         _allTokens.pop();
1373     }
1374 }
1375 
1376 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1377 
1378 
1379 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 
1384 /**
1385  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1386  *
1387  * These functions can be used to verify that a message was signed by the holder
1388  * of the private keys of a given address.
1389  */
1390 library ECDSA {
1391     enum RecoverError {
1392         NoError,
1393         InvalidSignature,
1394         InvalidSignatureLength,
1395         InvalidSignatureS,
1396         InvalidSignatureV
1397     }
1398 
1399     function _throwError(RecoverError error) private pure {
1400         if (error == RecoverError.NoError) {
1401             return; // no error: do nothing
1402         } else if (error == RecoverError.InvalidSignature) {
1403             revert("ECDSA: invalid signature");
1404         } else if (error == RecoverError.InvalidSignatureLength) {
1405             revert("ECDSA: invalid signature length");
1406         } else if (error == RecoverError.InvalidSignatureS) {
1407             revert("ECDSA: invalid signature 's' value");
1408         } else if (error == RecoverError.InvalidSignatureV) {
1409             revert("ECDSA: invalid signature 'v' value");
1410         }
1411     }
1412 
1413     /**
1414      * @dev Returns the address that signed a hashed message (`hash`) with
1415      * `signature` or error string. This address can then be used for verification purposes.
1416      *
1417      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1418      * this function rejects them by requiring the `s` value to be in the lower
1419      * half order, and the `v` value to be either 27 or 28.
1420      *
1421      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1422      * verification to be secure: it is possible to craft signatures that
1423      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1424      * this is by receiving a hash of the original message (which may otherwise
1425      * be too long), and then calling {toEthSignedMessageHash} on it.
1426      *
1427      * Documentation for signature generation:
1428      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1429      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1430      *
1431      * _Available since v4.3._
1432      */
1433     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1434         // Check the signature length
1435         // - case 65: r,s,v signature (standard)
1436         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1437         if (signature.length == 65) {
1438             bytes32 r;
1439             bytes32 s;
1440             uint8 v;
1441             // ecrecover takes the signature parameters, and the only way to get them
1442             // currently is to use assembly.
1443             assembly {
1444                 r := mload(add(signature, 0x20))
1445                 s := mload(add(signature, 0x40))
1446                 v := byte(0, mload(add(signature, 0x60)))
1447             }
1448             return tryRecover(hash, v, r, s);
1449         } else if (signature.length == 64) {
1450             bytes32 r;
1451             bytes32 vs;
1452             // ecrecover takes the signature parameters, and the only way to get them
1453             // currently is to use assembly.
1454             assembly {
1455                 r := mload(add(signature, 0x20))
1456                 vs := mload(add(signature, 0x40))
1457             }
1458             return tryRecover(hash, r, vs);
1459         } else {
1460             return (address(0), RecoverError.InvalidSignatureLength);
1461         }
1462     }
1463 
1464     /**
1465      * @dev Returns the address that signed a hashed message (`hash`) with
1466      * `signature`. This address can then be used for verification purposes.
1467      *
1468      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1469      * this function rejects them by requiring the `s` value to be in the lower
1470      * half order, and the `v` value to be either 27 or 28.
1471      *
1472      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1473      * verification to be secure: it is possible to craft signatures that
1474      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1475      * this is by receiving a hash of the original message (which may otherwise
1476      * be too long), and then calling {toEthSignedMessageHash} on it.
1477      */
1478     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1479         (address recovered, RecoverError error) = tryRecover(hash, signature);
1480         _throwError(error);
1481         return recovered;
1482     }
1483 
1484     /**
1485      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1486      *
1487      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1488      *
1489      * _Available since v4.3._
1490      */
1491     function tryRecover(
1492         bytes32 hash,
1493         bytes32 r,
1494         bytes32 vs
1495     ) internal pure returns (address, RecoverError) {
1496         bytes32 s;
1497         uint8 v;
1498         assembly {
1499             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1500             v := add(shr(255, vs), 27)
1501         }
1502         return tryRecover(hash, v, r, s);
1503     }
1504 
1505     /**
1506      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1507      *
1508      * _Available since v4.2._
1509      */
1510     function recover(
1511         bytes32 hash,
1512         bytes32 r,
1513         bytes32 vs
1514     ) internal pure returns (address) {
1515         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1516         _throwError(error);
1517         return recovered;
1518     }
1519 
1520     /**
1521      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1522      * `r` and `s` signature fields separately.
1523      *
1524      * _Available since v4.3._
1525      */
1526     function tryRecover(
1527         bytes32 hash,
1528         uint8 v,
1529         bytes32 r,
1530         bytes32 s
1531     ) internal pure returns (address, RecoverError) {
1532         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1533         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1534         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1535         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1536         //
1537         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1538         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1539         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1540         // these malleable signatures as well.
1541         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1542             return (address(0), RecoverError.InvalidSignatureS);
1543         }
1544         if (v != 27 && v != 28) {
1545             return (address(0), RecoverError.InvalidSignatureV);
1546         }
1547 
1548         // If the signature is valid (and not malleable), return the signer address
1549         address signer = ecrecover(hash, v, r, s);
1550         if (signer == address(0)) {
1551             return (address(0), RecoverError.InvalidSignature);
1552         }
1553 
1554         return (signer, RecoverError.NoError);
1555     }
1556 
1557     /**
1558      * @dev Overload of {ECDSA-recover} that receives the `v`,
1559      * `r` and `s` signature fields separately.
1560      */
1561     function recover(
1562         bytes32 hash,
1563         uint8 v,
1564         bytes32 r,
1565         bytes32 s
1566     ) internal pure returns (address) {
1567         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1568         _throwError(error);
1569         return recovered;
1570     }
1571 
1572     /**
1573      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1574      * produces hash corresponding to the one signed with the
1575      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1576      * JSON-RPC method as part of EIP-191.
1577      *
1578      * See {recover}.
1579      */
1580     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1581         // 32 is the length in bytes of hash,
1582         // enforced by the type signature above
1583         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1584     }
1585 
1586     /**
1587      * @dev Returns an Ethereum Signed Message, created from `s`. This
1588      * produces hash corresponding to the one signed with the
1589      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1590      * JSON-RPC method as part of EIP-191.
1591      *
1592      * See {recover}.
1593      */
1594     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1595         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1596     }
1597 
1598     /**
1599      * @dev Returns an Ethereum Signed Typed Data, created from a
1600      * `domainSeparator` and a `structHash`. This produces hash corresponding
1601      * to the one signed with the
1602      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1603      * JSON-RPC method as part of EIP-712.
1604      *
1605      * See {recover}.
1606      */
1607     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1608         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1609     }
1610 }
1611 
1612 // File: @openzeppelin/contracts/utils/math/Math.sol
1613 
1614 
1615 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
1616 
1617 pragma solidity ^0.8.0;
1618 
1619 /**
1620  * @dev Standard math utilities missing in the Solidity language.
1621  */
1622 library Math {
1623     /**
1624      * @dev Returns the largest of two numbers.
1625      */
1626     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1627         return a >= b ? a : b;
1628     }
1629 
1630     /**
1631      * @dev Returns the smallest of two numbers.
1632      */
1633     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1634         return a < b ? a : b;
1635     }
1636 
1637     /**
1638      * @dev Returns the average of two numbers. The result is rounded towards
1639      * zero.
1640      */
1641     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1642         // (a + b) / 2 can overflow.
1643         return (a & b) + (a ^ b) / 2;
1644     }
1645 
1646     /**
1647      * @dev Returns the ceiling of the division of two numbers.
1648      *
1649      * This differs from standard division with `/` in that it rounds up instead
1650      * of rounding down.
1651      */
1652     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1653         // (a + b - 1) / b can overflow on addition, so we distribute.
1654         return a / b + (a % b == 0 ? 0 : 1);
1655     }
1656 }
1657 
1658 // File: Dreamland.sol
1659 
1660 
1661 /*
1662 
1663 ,------.  ,------. ,------.  ,---.  ,--.   ,--.,--.     ,---.  ,--.  ,--.,------.   ,---.
1664 |  .-.  \ |  .--. '|  .---' /  O  \ |   `.'   ||  |    /  O  \ |  ,'.|  ||  .-.  \ '   .-'
1665 |  |  \  :|  '--'.'|  `--, |  .-.  ||  |'.'|  ||  |   |  .-.  ||  |' '  ||  |  \  :`.  `-.
1666 |  '--'  /|  |\  \ |  `---.|  | |  ||  |   |  ||  '--.|  | |  ||  | `   ||  '--'  /.-'    |
1667 `-------' `--' '--'`------'`--' `--'`--'   `--'`-----'`--' `--'`--'  `--'`-------' `-----'
1668 
1669 https://dreamlandgenesis.com
1670 
1671 */
1672 
1673 pragma solidity ^0.8.7;
1674 
1675 
1676 
1677 
1678 
1679 
1680 
1681 contract Dreamlands is ERC721Enumerable, Ownable, Pausable {
1682     using Strings for uint256;
1683 
1684     uint256 public constant MAX_SUPPLY = 10000;
1685     uint256 public constant GIVEAWAY = 110;
1686     uint256 public constant DEV_AMOUNT = 4 ether;
1687     address public constant DEV_ADDRESS = 0x1C78a76c0B4a4C2f99ad8D0aBB7a1556Fa55Df59;
1688 
1689     bool public freeStarted = false;
1690     bool public saleStarted = false;
1691     bool public whitelistStarted = false;
1692     bool public lock = false;
1693     uint256 public devWithdrawnAmount = 0;
1694     uint256 public currentWave = 0;
1695     uint256 public maxPublicMint = 3;
1696     address private _signerAddress;
1697 
1698     string public prefixURI;
1699     string public commonURI;
1700 
1701     mapping(bytes32 => bool) private _usedHashes;
1702     mapping(uint256 => string) public tokenURIs;
1703 
1704     // Wave Config
1705     mapping(uint256 => uint256) public publicPrices;
1706     mapping(uint256 => uint256) public whitelistPrices;
1707 
1708     mapping(uint256 => uint256) public publicMaxSupply;
1709     mapping(uint256 => uint256) public whitelistMaxSupply;
1710     mapping(uint256 => uint256) public freeMaxSupply;
1711 
1712 
1713     constructor() ERC721("Dreamlands", "DREAM") {
1714         for (uint256 i = 1; i <= GIVEAWAY; i++) {
1715             _safeMint(msg.sender, totalSupply() + 1);
1716         }
1717 
1718         publicPrices[1] = 0.055 ether;
1719         publicPrices[2] = 0.069 ether;
1720         publicPrices[3] = 0.079 ether;
1721         publicPrices[4] = 0.089 ether;
1722         publicPrices[5] = 0.1 ether;
1723 
1724         whitelistPrices[1] = 0.05 ether;
1725         whitelistPrices[2] = 0.065 ether;
1726         whitelistPrices[3] = 0.075 ether;
1727         whitelistPrices[4] = 0.085 ether;
1728         whitelistPrices[5] = 0.095 ether;
1729 
1730         // Wave 1
1731         freeMaxSupply[1] = 160;
1732         whitelistMaxSupply[1] = 760;
1733         publicMaxSupply[1] = 1100;
1734 
1735         // Wave 2
1736         freeMaxSupply[2] = 1210;
1737         whitelistMaxSupply[2] = 1560;
1738         publicMaxSupply[2] = 2110;
1739 
1740         /// Wave 3
1741         freeMaxSupply[3] = 2160;
1742         whitelistMaxSupply[3] = 3160;
1743         publicMaxSupply[3] = 4110;
1744 
1745         // Wave 4
1746         freeMaxSupply[4] = 4160;
1747         whitelistMaxSupply[4] = 5660;
1748         publicMaxSupply[4] = 7110;
1749 
1750         // Wave 5
1751         freeMaxSupply[5] = 7160;
1752         whitelistMaxSupply[5] = 8550;
1753         publicMaxSupply[5] = 10000;
1754     }
1755 
1756     modifier onlyOwnerOrDev {
1757         require(msg.sender == owner() || msg.sender == DEV_ADDRESS, "Ownable: caller is not the owner");
1758         _;
1759     }
1760 
1761     function mintWhitelist(
1762         uint256 _count,
1763         uint256 _maxCount,
1764         uint256 _wave,
1765         bytes memory _sig)
1766         external
1767         payable
1768     {
1769         require(currentWave > 0 && _wave == currentWave, "WAVE_INCORRECT");
1770         require(whitelistStarted || freeStarted, "MINT_NOT_STARTED");
1771         require(_count > 0 && _count <= _maxCount, "COUNT_INVALID");
1772         require(totalSupply() + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1773 
1774         if (whitelistStarted) {
1775             require(totalSupply() + _count <= whitelistMaxSupply[currentWave], "MAX_SUPPLY_REACHED");
1776             require(msg.value == (_count * whitelistPrices[currentWave]), "INVALID_ETH_SENT");
1777         } else {
1778             require(totalSupply() + _count <= freeMaxSupply[currentWave], "MAX_SUPPLY_REACHED");
1779             require(msg.value == 0, "MINT_PRICE_SHOULD_BE_FREE");
1780         }
1781 
1782         bytes32 hash = keccak256(abi.encode(_msgSender(), _maxCount, _wave));
1783         require(!_usedHashes[hash], "HASH_ALREADY_USED");
1784         require(matchSigner(hash, _sig), "INVALID_SIGNER");
1785 
1786         _usedHashes[hash] = true;
1787         for (uint256 i = 1; i <= _count; i++) {
1788             _safeMint(msg.sender, totalSupply() + 1);
1789         }
1790     }
1791 
1792     function mintPublic(
1793         uint256 _count
1794     )
1795         external
1796         payable
1797     {
1798         require(currentWave > 0, "WAVE_INCORRECT");
1799         require(saleStarted, "MINT_NOT_STARTED");
1800         require(_count > 0 && _count <= maxPublicMint, "COUNT_INVALID");
1801         require(totalSupply() + _count <= MAX_SUPPLY, "MAX_SUPPLY_REACHED");
1802         require(totalSupply() + _count <= publicMaxSupply[currentWave], "MAX_SUPPLY_REACHED");
1803         require(msg.value == (_count * publicPrices[currentWave]), "INVALID_ETH_SENT");
1804 
1805         for (uint256 i = 1; i <= _count; i++) {
1806             _safeMint(msg.sender, totalSupply() + 1);
1807         }
1808     }
1809 
1810     function matchSigner(bytes32 _hash, bytes memory _signature) private view returns(bool) {
1811         return _signerAddress == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
1812     }
1813 
1814     function isWhiteList(
1815         address _sender,
1816         uint256 _maxCount,
1817         uint256 _wave,
1818         bytes calldata _sig
1819     ) public view returns(bool) {
1820         bytes32 _hash = keccak256(abi.encode(_sender, _maxCount, _wave));
1821         if (!matchSigner(_hash, _sig)) {
1822             return false;
1823         }
1824         if (_usedHashes[_hash]) {
1825             return false;
1826         }
1827         return true;
1828     }
1829 
1830     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1831         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1832         if (bytes(tokenURIs[tokenId]).length != 0) {
1833             return tokenURIs[tokenId];
1834         }
1835         if (bytes(commonURI).length != 0) {
1836             return commonURI;
1837         }
1838         return string(abi.encodePacked(prefixURI, tokenId.toString()));
1839     }
1840 
1841     // ** Admin Fuctions ** //
1842     function setSaleStarted(bool _hasStarted) external onlyOwnerOrDev {
1843         saleStarted = _hasStarted;
1844     }
1845 
1846     function setWhitelistStarted(bool _hasStarted) external onlyOwnerOrDev {
1847         whitelistStarted = _hasStarted;
1848     }
1849 
1850     function setFreeStarted(bool _hasStarted) external onlyOwnerOrDev {
1851         freeStarted = _hasStarted;
1852     }
1853 
1854     function setSignerAddress(address _signer) external onlyOwnerOrDev {
1855         require(_signer != address(0), "SIGNER_ADDRESS_ZERO");
1856         _signerAddress = _signer;
1857     }
1858 
1859     function lockBaseURI() external onlyOwner {
1860         require(!lock, "ALREADY_LOCKED");
1861         lock = true;
1862     }
1863 
1864     function setPrefixURI(string calldata _uri) external onlyOwnerOrDev {
1865         require(!lock, "ALREADY_LOCKED");
1866         prefixURI = _uri;
1867         commonURI = '';
1868     }
1869 
1870     function setCommonURI(string calldata _uri) external onlyOwnerOrDev {
1871         require(!lock, "ALREADY_LOCKED");
1872         commonURI = _uri;
1873         prefixURI = '';
1874     }
1875 
1876     function setTokenURI(string calldata _uri, uint256 _tokenId) external onlyOwnerOrDev {
1877         require(!lock, "ALREADY_LOCKED");
1878         tokenURIs[_tokenId] = _uri;
1879     }
1880 
1881     function setPublicPrices(uint256 _wave, uint256 _price) external onlyOwnerOrDev {
1882         publicPrices[_wave] = _price;
1883     }
1884 
1885     function setWhitelistPrices(uint256 _wave, uint256 _price) external onlyOwnerOrDev {
1886         whitelistPrices[_wave] = _price;
1887     }
1888 
1889     function setPublicMaxSupply(uint256 _wave, uint256 _supply) external onlyOwnerOrDev {
1890         publicMaxSupply[_wave] = _supply;
1891     }
1892 
1893     function setWhitelistMaxSupply(uint256 _wave, uint256 _supply) external onlyOwnerOrDev {
1894         whitelistMaxSupply[_wave] = _supply;
1895     }
1896 
1897     function setFreeMaxSupply(uint256 _wave, uint256 _supply) external onlyOwnerOrDev {
1898         freeMaxSupply[_wave] = _supply;
1899     }
1900 
1901     function setWave(uint256 _wave) external onlyOwnerOrDev {
1902         require(_wave >= 1 && _wave <= 5, "WAVE_OUT_OF_BOUNDS");
1903         currentWave = _wave;
1904     }
1905 
1906     function setMaxPublicMint(uint256 _maxMint) external onlyOwnerOrDev {
1907         maxPublicMint = _maxMint;
1908     }
1909 
1910     function pause() external onlyOwner {
1911         require(!paused(), "ALREADY_PAUSED");
1912         _pause();
1913     }
1914 
1915     function unpause() external onlyOwner {
1916         require(paused(), "ALREADY_UNPAUSED");
1917         _unpause();
1918     }
1919 
1920     function withdraw() external onlyOwner {
1921         require(address(this).balance > 0, "EMPTY_BALANCE");
1922         require(devWithdrawnAmount >= DEV_AMOUNT, "DEV_WITHDRAWN_FIRST");
1923         payable(msg.sender).transfer(address(this).balance);
1924     }
1925 
1926     function withdrawDev() external {
1927         require(msg.sender == DEV_ADDRESS, "NOT_DEV_ADDRESS");
1928         require(devWithdrawnAmount < DEV_AMOUNT, "DEV_WITHDRAWN_AMOUNT_EXCEED");
1929         uint256 amount = DEV_AMOUNT - devWithdrawnAmount;
1930         require(amount > 0, "AMOUNT_ZERO");
1931         amount = Math.min(amount, address(this).balance);
1932         require(amount > 0, "AMOUNT_ZERO");
1933         devWithdrawnAmount += amount;
1934         payable(msg.sender).transfer(amount);
1935     }
1936 
1937     function _beforeTokenTransfer(
1938         address from,
1939         address to,
1940         uint256 tokenId
1941     ) override internal virtual {
1942         require(!paused(), "TRANSFER_PAUSED");
1943         super._beforeTokenTransfer(from, to, tokenId);
1944     }
1945 }