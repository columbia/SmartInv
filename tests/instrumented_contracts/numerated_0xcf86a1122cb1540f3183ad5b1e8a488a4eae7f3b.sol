1 // File: StonedApez.sol
2 
3 
4 pragma solidity ^0.8.6;
5 
6 abstract contract StonedApez {
7     function ownerOf(uint256 tokenId) public view virtual returns (address);
8     function balanceOf(address account)
9         public
10         view
11         virtual
12         returns (uint256);
13 }
14 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
15 
16 
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Contract module that helps prevent reentrant calls to a function.
22  *
23  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
24  * available, which can be applied to functions to make sure there are no nested
25  * (reentrant) calls to them.
26  *
27  * Note that because there is a single `nonReentrant` guard, functions marked as
28  * `nonReentrant` may not call one another. This can be worked around by making
29  * those functions `private`, and then adding `external` `nonReentrant` entry
30  * points to them.
31  *
32  * TIP: If you would like to learn more about reentrancy and alternative ways
33  * to protect against it, check out our blog post
34  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
35  */
36 abstract contract ReentrancyGuard {
37     // Booleans are more expensive than uint256 or any type that takes up a full
38     // word because each write operation emits an extra SLOAD to first read the
39     // slot's contents, replace the bits taken up by the boolean, and then write
40     // back. This is the compiler's defense against contract upgrades and
41     // pointer aliasing, and it cannot be disabled.
42 
43     // The values being non-zero value makes deployment a bit more expensive,
44     // but in exchange the refund on every call to nonReentrant will be lower in
45     // amount. Since refunds are capped to a percentage of the total
46     // transaction's gas, it is best to keep them low in cases like this one, to
47     // increase the likelihood of the full refund coming into effect.
48     uint256 private constant _NOT_ENTERED = 1;
49     uint256 private constant _ENTERED = 2;
50 
51     uint256 private _status;
52 
53     constructor() {
54         _status = _NOT_ENTERED;
55     }
56 
57     /**
58      * @dev Prevents a contract from calling itself, directly or indirectly.
59      * Calling a `nonReentrant` function from another `nonReentrant`
60      * function is not supported. It is possible to prevent this from happening
61      * by making the `nonReentrant` function external, and make it call a
62      * `private` function that does the actual work.
63      */
64     modifier nonReentrant() {
65         // On the first call to nonReentrant, _notEntered will be true
66         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
67 
68         // Any calls to nonReentrant after this point will fail
69         _status = _ENTERED;
70 
71         _;
72 
73         // By storing the original value once again, a refund is triggered (see
74         // https://eips.ethereum.org/EIPS/eip-2200)
75         _status = _NOT_ENTERED;
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Strings.sol
80 
81 
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev String operations.
87  */
88 library Strings {
89     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
93      */
94     function toString(uint256 value) internal pure returns (string memory) {
95         // Inspired by OraclizeAPI's implementation - MIT licence
96         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
97 
98         if (value == 0) {
99             return "0";
100         }
101         uint256 temp = value;
102         uint256 digits;
103         while (temp != 0) {
104             digits++;
105             temp /= 10;
106         }
107         bytes memory buffer = new bytes(digits);
108         while (value != 0) {
109             digits -= 1;
110             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
111             value /= 10;
112         }
113         return string(buffer);
114     }
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
118      */
119     function toHexString(uint256 value) internal pure returns (string memory) {
120         if (value == 0) {
121             return "0x00";
122         }
123         uint256 temp = value;
124         uint256 length = 0;
125         while (temp != 0) {
126             length++;
127             temp >>= 8;
128         }
129         return toHexString(value, length);
130     }
131 
132     /**
133      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
134      */
135     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
136         bytes memory buffer = new bytes(2 * length + 2);
137         buffer[0] = "0";
138         buffer[1] = "x";
139         for (uint256 i = 2 * length + 1; i > 1; --i) {
140             buffer[i] = _HEX_SYMBOLS[value & 0xf];
141             value >>= 4;
142         }
143         require(value == 0, "Strings: hex length insufficient");
144         return string(buffer);
145     }
146 }
147 
148 // File: @openzeppelin/contracts/utils/Context.sol
149 
150 
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Provides information about the current execution context, including the
156  * sender of the transaction and its data. While these are generally available
157  * via msg.sender and msg.data, they should not be accessed in such a direct
158  * manner, since when dealing with meta-transactions the account sending and
159  * paying for execution may not be the actual sender (as far as an application
160  * is concerned).
161  *
162  * This contract is only required for intermediate, library-like contracts.
163  */
164 abstract contract Context {
165     function _msgSender() internal view virtual returns (address) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view virtual returns (bytes calldata) {
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/security/Pausable.sol
175 
176 
177 
178 pragma solidity ^0.8.0;
179 
180 
181 /**
182  * @dev Contract module which allows children to implement an emergency stop
183  * mechanism that can be triggered by an authorized account.
184  *
185  * This module is used through inheritance. It will make available the
186  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
187  * the functions of your contract. Note that they will not be pausable by
188  * simply including this module, only once the modifiers are put in place.
189  */
190 abstract contract Pausable is Context {
191     /**
192      * @dev Emitted when the pause is triggered by `account`.
193      */
194     event Paused(address account);
195 
196     /**
197      * @dev Emitted when the pause is lifted by `account`.
198      */
199     event Unpaused(address account);
200 
201     bool private _paused;
202 
203     /**
204      * @dev Initializes the contract in unpaused state.
205      */
206     constructor() {
207         _paused = false;
208     }
209 
210     /**
211      * @dev Returns true if the contract is paused, and false otherwise.
212      */
213     function paused() public view virtual returns (bool) {
214         return _paused;
215     }
216 
217     /**
218      * @dev Modifier to make a function callable only when the contract is not paused.
219      *
220      * Requirements:
221      *
222      * - The contract must not be paused.
223      */
224     modifier whenNotPaused() {
225         require(!paused(), "Pausable: paused");
226         _;
227     }
228 
229     /**
230      * @dev Modifier to make a function callable only when the contract is paused.
231      *
232      * Requirements:
233      *
234      * - The contract must be paused.
235      */
236     modifier whenPaused() {
237         require(paused(), "Pausable: not paused");
238         _;
239     }
240 
241     /**
242      * @dev Triggers stopped state.
243      *
244      * Requirements:
245      *
246      * - The contract must not be paused.
247      */
248     function _pause() internal virtual whenNotPaused {
249         _paused = true;
250         emit Paused(_msgSender());
251     }
252 
253     /**
254      * @dev Returns to normal state.
255      *
256      * Requirements:
257      *
258      * - The contract must be paused.
259      */
260     function _unpause() internal virtual whenPaused {
261         _paused = false;
262         emit Unpaused(_msgSender());
263     }
264 }
265 
266 // File: @openzeppelin/contracts/access/Ownable.sol
267 
268 
269 
270 pragma solidity ^0.8.0;
271 
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * By default, the owner account will be the one that deploys the contract. This
279  * can later be changed with {transferOwnership}.
280  *
281  * This module is used through inheritance. It will make available the modifier
282  * `onlyOwner`, which can be applied to your functions to restrict their use to
283  * the owner.
284  */
285 abstract contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev Initializes the contract setting the deployer as the initial owner.
292      */
293     constructor() {
294         _setOwner(_msgSender());
295     }
296 
297     /**
298      * @dev Returns the address of the current owner.
299      */
300     function owner() public view virtual returns (address) {
301         return _owner;
302     }
303 
304     /**
305      * @dev Throws if called by any account other than the owner.
306      */
307     modifier onlyOwner() {
308         require(owner() == _msgSender(), "Ownable: caller is not the owner");
309         _;
310     }
311 
312     /**
313      * @dev Leaves the contract without owner. It will not be possible to call
314      * `onlyOwner` functions anymore. Can only be called by the current owner.
315      *
316      * NOTE: Renouncing ownership will leave the contract without an owner,
317      * thereby removing any functionality that is only available to the owner.
318      */
319     function renounceOwnership() public virtual onlyOwner {
320         _setOwner(address(0));
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Can only be called by the current owner.
326      */
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         _setOwner(newOwner);
330     }
331 
332     function _setOwner(address newOwner) private {
333         address oldOwner = _owner;
334         _owner = newOwner;
335         emit OwnershipTransferred(oldOwner, newOwner);
336     }
337 }
338 
339 // File: @openzeppelin/contracts/utils/Address.sol
340 
341 
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         uint256 size;
372         assembly {
373             size := extcodesize(account)
374         }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         (bool success, ) = recipient.call{value: amount}("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain `call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
482         return functionStaticCall(target, data, "Address: low-level static call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.delegatecall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
531      * revert reason using the provided one.
532      *
533      * _Available since v4.3._
534      */
535     function verifyCallResult(
536         bool success,
537         bytes memory returndata,
538         string memory errorMessage
539     ) internal pure returns (bytes memory) {
540         if (success) {
541             return returndata;
542         } else {
543             // Look for revert reason and bubble it up if present
544             if (returndata.length > 0) {
545                 // The easiest way to bubble the revert reason is using memory via assembly
546 
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
559 
560 
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @title ERC721 token receiver interface
566  * @dev Interface for any contract that wants to support safeTransfers
567  * from ERC721 asset contracts.
568  */
569 interface IERC721Receiver {
570     /**
571      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
572      * by `operator` from `from`, this function is called.
573      *
574      * It must return its Solidity selector to confirm the token transfer.
575      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
576      *
577      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
578      */
579     function onERC721Received(
580         address operator,
581         address from,
582         uint256 tokenId,
583         bytes calldata data
584     ) external returns (bytes4);
585 }
586 
587 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
588 
589 
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Interface of the ERC165 standard, as defined in the
595  * https://eips.ethereum.org/EIPS/eip-165[EIP].
596  *
597  * Implementers can declare support of contract interfaces, which can then be
598  * queried by others ({ERC165Checker}).
599  *
600  * For an implementation, see {ERC165}.
601  */
602 interface IERC165 {
603     /**
604      * @dev Returns true if this contract implements the interface defined by
605      * `interfaceId`. See the corresponding
606      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
607      * to learn more about how these ids are created.
608      *
609      * This function call must use less than 30 000 gas.
610      */
611     function supportsInterface(bytes4 interfaceId) external view returns (bool);
612 }
613 
614 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
615 
616 
617 
618 pragma solidity ^0.8.0;
619 
620 
621 /**
622  * @dev Implementation of the {IERC165} interface.
623  *
624  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
625  * for the additional interface id that will be supported. For example:
626  *
627  * ```solidity
628  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
630  * }
631  * ```
632  *
633  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
634  */
635 abstract contract ERC165 is IERC165 {
636     /**
637      * @dev See {IERC165-supportsInterface}.
638      */
639     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
640         return interfaceId == type(IERC165).interfaceId;
641     }
642 }
643 
644 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
645 
646 
647 
648 pragma solidity ^0.8.0;
649 
650 
651 /**
652  * @dev Required interface of an ERC721 compliant contract.
653  */
654 interface IERC721 is IERC165 {
655     /**
656      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
657      */
658     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
659 
660     /**
661      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
662      */
663     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
664 
665     /**
666      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
667      */
668     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
669 
670     /**
671      * @dev Returns the number of tokens in ``owner``'s account.
672      */
673     function balanceOf(address owner) external view returns (uint256 balance);
674 
675     /**
676      * @dev Returns the owner of the `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function ownerOf(uint256 tokenId) external view returns (address owner);
683 
684     /**
685      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
686      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must exist and be owned by `from`.
693      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
695      *
696      * Emits a {Transfer} event.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId
702     ) external;
703 
704     /**
705      * @dev Transfers `tokenId` token from `from` to `to`.
706      *
707      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `tokenId` token must be owned by `from`.
714      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
715      *
716      * Emits a {Transfer} event.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) external;
723 
724     /**
725      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
726      * The approval is cleared when the token is transferred.
727      *
728      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
729      *
730      * Requirements:
731      *
732      * - The caller must own the token or be an approved operator.
733      * - `tokenId` must exist.
734      *
735      * Emits an {Approval} event.
736      */
737     function approve(address to, uint256 tokenId) external;
738 
739     /**
740      * @dev Returns the account approved for `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function getApproved(uint256 tokenId) external view returns (address operator);
747 
748     /**
749      * @dev Approve or remove `operator` as an operator for the caller.
750      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
751      *
752      * Requirements:
753      *
754      * - The `operator` cannot be the caller.
755      *
756      * Emits an {ApprovalForAll} event.
757      */
758     function setApprovalForAll(address operator, bool _approved) external;
759 
760     /**
761      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
762      *
763      * See {setApprovalForAll}
764      */
765     function isApprovedForAll(address owner, address operator) external view returns (bool);
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes calldata data
785     ) external;
786 }
787 
788 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
789 
790 
791 
792 pragma solidity ^0.8.0;
793 
794 
795 /**
796  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
797  * @dev See https://eips.ethereum.org/EIPS/eip-721
798  */
799 interface IERC721Enumerable is IERC721 {
800     /**
801      * @dev Returns the total amount of tokens stored by the contract.
802      */
803     function totalSupply() external view returns (uint256);
804 
805     /**
806      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
807      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
808      */
809     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
810 
811     /**
812      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
813      * Use along with {totalSupply} to enumerate all tokens.
814      */
815     function tokenByIndex(uint256 index) external view returns (uint256);
816 }
817 
818 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
819 
820 
821 
822 pragma solidity ^0.8.0;
823 
824 
825 /**
826  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
827  * @dev See https://eips.ethereum.org/EIPS/eip-721
828  */
829 interface IERC721Metadata is IERC721 {
830     /**
831      * @dev Returns the token collection name.
832      */
833     function name() external view returns (string memory);
834 
835     /**
836      * @dev Returns the token collection symbol.
837      */
838     function symbol() external view returns (string memory);
839 
840     /**
841      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
842      */
843     function tokenURI(uint256 tokenId) external view returns (string memory);
844 }
845 
846 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
847 
848 
849 
850 pragma solidity ^0.8.0;
851 
852 
853 
854 
855 
856 
857 
858 
859 /**
860  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
861  * the Metadata extension, but not including the Enumerable extension, which is available separately as
862  * {ERC721Enumerable}.
863  */
864 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
865     using Address for address;
866     using Strings for uint256;
867 
868     // Token name
869     string private _name;
870 
871     // Token symbol
872     string private _symbol;
873 
874     // Mapping from token ID to owner address
875     mapping(uint256 => address) private _owners;
876 
877     // Mapping owner address to token count
878     mapping(address => uint256) private _balances;
879 
880     // Mapping from token ID to approved address
881     mapping(uint256 => address) private _tokenApprovals;
882 
883     // Mapping from owner to operator approvals
884     mapping(address => mapping(address => bool)) private _operatorApprovals;
885 
886     /**
887      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
888      */
889     constructor(string memory name_, string memory symbol_) {
890         _name = name_;
891         _symbol = symbol_;
892     }
893 
894     /**
895      * @dev See {IERC165-supportsInterface}.
896      */
897     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
898         return
899             interfaceId == type(IERC721).interfaceId ||
900             interfaceId == type(IERC721Metadata).interfaceId ||
901             super.supportsInterface(interfaceId);
902     }
903 
904     /**
905      * @dev See {IERC721-balanceOf}.
906      */
907     function balanceOf(address owner) public view virtual override returns (uint256) {
908         require(owner != address(0), "ERC721: balance query for the zero address");
909         return _balances[owner];
910     }
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
916         address owner = _owners[tokenId];
917         require(owner != address(0), "ERC721: owner query for nonexistent token");
918         return owner;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-name}.
923      */
924     function name() public view virtual override returns (string memory) {
925         return _name;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-symbol}.
930      */
931     function symbol() public view virtual override returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-tokenURI}.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
940 
941         string memory baseURI = _baseURI();
942         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
943     }
944 
945     /**
946      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
947      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
948      * by default, can be overriden in child contracts.
949      */
950     function _baseURI() internal view virtual returns (string memory) {
951         return "";
952     }
953 
954     /**
955      * @dev See {IERC721-approve}.
956      */
957     function approve(address to, uint256 tokenId) public virtual override {
958         address owner = ERC721.ownerOf(tokenId);
959         require(to != owner, "ERC721: approval to current owner");
960 
961         require(
962             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
963             "ERC721: approve caller is not owner nor approved for all"
964         );
965 
966         _approve(to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view virtual override returns (address) {
973         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public virtual override {
982         require(operator != _msgSender(), "ERC721: approve to caller");
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         //solhint-disable-next-line max-line-length
1004         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1005 
1006         _transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         safeTransferFrom(from, to, tokenId, "");
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) public virtual override {
1029         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1030         _safeTransfer(from, to, tokenId, _data);
1031     }
1032 
1033     /**
1034      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1035      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1036      *
1037      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1038      *
1039      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1040      * implement alternative mechanisms to perform token transfer, such as signature-based.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must exist and be owned by `from`.
1047      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _safeTransfer(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) internal virtual {
1057         _transfer(from, to, tokenId);
1058         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1059     }
1060 
1061     /**
1062      * @dev Returns whether `tokenId` exists.
1063      *
1064      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1065      *
1066      * Tokens start existing when they are minted (`_mint`),
1067      * and stop existing when they are burned (`_burn`).
1068      */
1069     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1070         return _owners[tokenId] != address(0);
1071     }
1072 
1073     /**
1074      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      */
1080     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1081         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1082         address owner = ERC721.ownerOf(tokenId);
1083         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1084     }
1085 
1086     /**
1087      * @dev Safely mints `tokenId` and transfers it to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must not exist.
1092      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _safeMint(address to, uint256 tokenId) internal virtual {
1097         _safeMint(to, tokenId, "");
1098     }
1099 
1100     /**
1101      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1102      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1103      */
1104     function _safeMint(
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) internal virtual {
1109         _mint(to, tokenId);
1110         require(
1111             _checkOnERC721Received(address(0), to, tokenId, _data),
1112             "ERC721: transfer to non ERC721Receiver implementer"
1113         );
1114     }
1115 
1116     /**
1117      * @dev Mints `tokenId` and transfers it to `to`.
1118      *
1119      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1120      *
1121      * Requirements:
1122      *
1123      * - `tokenId` must not exist.
1124      * - `to` cannot be the zero address.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _mint(address to, uint256 tokenId) internal virtual {
1129         require(to != address(0), "ERC721: mint to the zero address");
1130         require(!_exists(tokenId), "ERC721: token already minted");
1131 
1132         _beforeTokenTransfer(address(0), to, tokenId);
1133 
1134         _balances[to] += 1;
1135         _owners[tokenId] = to;
1136 
1137         emit Transfer(address(0), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Destroys `tokenId`.
1142      * The approval is cleared when the token is burned.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _burn(uint256 tokenId) internal virtual {
1151         address owner = ERC721.ownerOf(tokenId);
1152 
1153         _beforeTokenTransfer(owner, address(0), tokenId);
1154 
1155         // Clear approvals
1156         _approve(address(0), tokenId);
1157 
1158         _balances[owner] -= 1;
1159         delete _owners[tokenId];
1160 
1161         emit Transfer(owner, address(0), tokenId);
1162     }
1163 
1164     /**
1165      * @dev Transfers `tokenId` from `from` to `to`.
1166      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1167      *
1168      * Requirements:
1169      *
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must be owned by `from`.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _transfer(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) internal virtual {
1180         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1181         require(to != address(0), "ERC721: transfer to the zero address");
1182 
1183         _beforeTokenTransfer(from, to, tokenId);
1184 
1185         // Clear approvals from the previous owner
1186         _approve(address(0), tokenId);
1187 
1188         _balances[from] -= 1;
1189         _balances[to] += 1;
1190         _owners[tokenId] = to;
1191 
1192         emit Transfer(from, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Approve `to` to operate on `tokenId`
1197      *
1198      * Emits a {Approval} event.
1199      */
1200     function _approve(address to, uint256 tokenId) internal virtual {
1201         _tokenApprovals[tokenId] = to;
1202         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1207      * The call is not executed if the target address is not a contract.
1208      *
1209      * @param from address representing the previous owner of the given token ID
1210      * @param to target address that will receive the tokens
1211      * @param tokenId uint256 ID of the token to be transferred
1212      * @param _data bytes optional data to send along with the call
1213      * @return bool whether the call correctly returned the expected magic value
1214      */
1215     function _checkOnERC721Received(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) private returns (bool) {
1221         if (to.isContract()) {
1222             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1223                 return retval == IERC721Receiver.onERC721Received.selector;
1224             } catch (bytes memory reason) {
1225                 if (reason.length == 0) {
1226                     revert("ERC721: transfer to non ERC721Receiver implementer");
1227                 } else {
1228                     assembly {
1229                         revert(add(32, reason), mload(reason))
1230                     }
1231                 }
1232             }
1233         } else {
1234             return true;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Hook that is called before any token transfer. This includes minting
1240      * and burning.
1241      *
1242      * Calling conditions:
1243      *
1244      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1245      * transferred to `to`.
1246      * - When `from` is zero, `tokenId` will be minted for `to`.
1247      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1248      * - `from` and `to` are never both zero.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _beforeTokenTransfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual {}
1257 }
1258 
1259 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1260 
1261 
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 
1266 
1267 /**
1268  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1269  * enumerability of all the token ids in the contract as well as all token ids owned by each
1270  * account.
1271  */
1272 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1273     // Mapping from owner to list of owned token IDs
1274     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1275 
1276     // Mapping from token ID to index of the owner tokens list
1277     mapping(uint256 => uint256) private _ownedTokensIndex;
1278 
1279     // Array with all token ids, used for enumeration
1280     uint256[] private _allTokens;
1281 
1282     // Mapping from token id to position in the allTokens array
1283     mapping(uint256 => uint256) private _allTokensIndex;
1284 
1285     /**
1286      * @dev See {IERC165-supportsInterface}.
1287      */
1288     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1289         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1294      */
1295     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1296         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1297         return _ownedTokens[owner][index];
1298     }
1299 
1300     /**
1301      * @dev See {IERC721Enumerable-totalSupply}.
1302      */
1303     function totalSupply() public view virtual override returns (uint256) {
1304         return _allTokens.length;
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-tokenByIndex}.
1309      */
1310     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1311         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1312         return _allTokens[index];
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before any token transfer. This includes minting
1317      * and burning.
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1325      * - `from` cannot be the zero address.
1326      * - `to` cannot be the zero address.
1327      *
1328      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1329      */
1330     function _beforeTokenTransfer(
1331         address from,
1332         address to,
1333         uint256 tokenId
1334     ) internal virtual override {
1335         super._beforeTokenTransfer(from, to, tokenId);
1336 
1337         if (from == address(0)) {
1338             _addTokenToAllTokensEnumeration(tokenId);
1339         } else if (from != to) {
1340             _removeTokenFromOwnerEnumeration(from, tokenId);
1341         }
1342         if (to == address(0)) {
1343             _removeTokenFromAllTokensEnumeration(tokenId);
1344         } else if (to != from) {
1345             _addTokenToOwnerEnumeration(to, tokenId);
1346         }
1347     }
1348 
1349     /**
1350      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1351      * @param to address representing the new owner of the given token ID
1352      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1353      */
1354     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1355         uint256 length = ERC721.balanceOf(to);
1356         _ownedTokens[to][length] = tokenId;
1357         _ownedTokensIndex[tokenId] = length;
1358     }
1359 
1360     /**
1361      * @dev Private function to add a token to this extension's token tracking data structures.
1362      * @param tokenId uint256 ID of the token to be added to the tokens list
1363      */
1364     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1365         _allTokensIndex[tokenId] = _allTokens.length;
1366         _allTokens.push(tokenId);
1367     }
1368 
1369     /**
1370      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1371      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1372      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1373      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1374      * @param from address representing the previous owner of the given token ID
1375      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1376      */
1377     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1378         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1379         // then delete the last slot (swap and pop).
1380 
1381         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1382         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1383 
1384         // When the token to delete is the last token, the swap operation is unnecessary
1385         if (tokenIndex != lastTokenIndex) {
1386             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1387 
1388             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1389             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1390         }
1391 
1392         // This also deletes the contents at the last position of the array
1393         delete _ownedTokensIndex[tokenId];
1394         delete _ownedTokens[from][lastTokenIndex];
1395     }
1396 
1397     /**
1398      * @dev Private function to remove a token from this extension's token tracking data structures.
1399      * This has O(1) time complexity, but alters the order of the _allTokens array.
1400      * @param tokenId uint256 ID of the token to be removed from the tokens list
1401      */
1402     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1403         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1404         // then delete the last slot (swap and pop).
1405 
1406         uint256 lastTokenIndex = _allTokens.length - 1;
1407         uint256 tokenIndex = _allTokensIndex[tokenId];
1408 
1409         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1410         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1411         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1412         uint256 lastTokenId = _allTokens[lastTokenIndex];
1413 
1414         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1415         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1416 
1417         // This also deletes the contents at the last position of the array
1418         delete _allTokensIndex[tokenId];
1419         _allTokens.pop();
1420     }
1421 }
1422 
1423 // File: easc.sol
1424 
1425 
1426 pragma solidity ^0.8.6;
1427 
1428 
1429 
1430 
1431 
1432 
1433 
1434 
1435 contract EnlightenedApezSaturnClub is Ownable, ReentrancyGuard, ERC721Enumerable {
1436     uint256 private MAX_TOKENS = 6969;
1437     uint256 private l1Price = 0.12 ether;
1438     uint256 private l2Price = 0.12 ether;
1439     string private baseURI;
1440     StonedApez private immutable sa;
1441 
1442     address public _t1 = 0x828eC8B5C7AA64cfE7aA3E703B6c68C1c617E305;
1443     address public _t2 = 0xBDc01fB114d93380e960a97aBBaC9133017De5C2;
1444     address public _t3 = 0xcE899baf2beC0a66222Dc7389614E711E9858580;
1445     address public _t4 = 0x9CED6C82326c7Dbc222dd17B6573E69cfE3983f2;
1446     address public _t5 = 0xD95D5BD8B4d75590a06dc0701dfb7848C99062bD;
1447     address public _t6 = 0x6b3ba9F0475C646FDaF2Bc207C285a485B88A747;
1448 
1449     bool public active;
1450     bool public openForAll;
1451 
1452 
1453     uint256 public l1Index = 0;
1454     uint256 public l2Index = 6969;
1455 
1456     event MintL1(uint256 indexed stonedApeId, uint256 indexed l1Id);
1457     event MintL2(uint256 indexed stonedApeId, uint256 indexed l2Id);
1458 
1459     mapping(uint256 => uint256) public mutatedL1s;
1460 
1461     mapping(uint256 => uint256) public mutatedL2s;
1462 
1463     modifier whenSaleActive() {
1464         require(active, "Sale is not active");
1465         _;
1466     }
1467 
1468     modifier whenOpenForAll() {
1469         require(openForAll, "Not open for all");
1470         _;
1471     }
1472 
1473     constructor (
1474         address saAddress
1475     ) ERC721("Enlightened Apez Saturn Club", "EASC"){
1476         sa = StonedApez(saAddress);
1477     }
1478 
1479     function startSale() external onlyOwner {
1480         require(!active, "Sale has started");
1481         active = true;
1482     }
1483 
1484     function pauseSale() external onlyOwner whenSaleActive {
1485         active = false;
1486     }
1487 
1488     function makeOpenForAll() external onlyOwner {
1489         require(!openForAll, "Open for all");
1490         openForAll = true;
1491     }
1492 
1493     function pauseOpenForAll() external onlyOwner whenOpenForAll {
1494         openForAll = false;
1495     }
1496 
1497 
1498     function withdraw() external onlyOwner payable {
1499         uint256 _p1 = address(this).balance * 1/10;
1500         uint256 _p2 = address(this).balance * 8/100;
1501         uint256 _p3 = address(this).balance * 27/100;
1502         uint256 _p4 = address(this).balance * 30/100;
1503         uint256 _p5 = address(this).balance * 15/100;
1504         uint256 _p6 = address(this).balance * 1/10;
1505         
1506         Address.sendValue(payable(_t1), _p1);
1507         Address.sendValue(payable(_t2), _p2);
1508         Address.sendValue(payable(_t3), _p3);
1509         Address.sendValue(payable(_t4), _p4);
1510         Address.sendValue(payable(_t5), _p5);
1511         Address.sendValue(payable(_t6), _p6);
1512     }
1513 
1514     function _apeMutatedForL1(uint256 stonedApezId) internal view virtual returns (bool) {
1515         return mutatedL1s[stonedApezId] != 0;
1516     }
1517 
1518     function _apeMutatedForL2(uint256 stonedApezId) internal view virtual returns (bool) {
1519         return mutatedL2s[stonedApezId] != 0;
1520     }
1521 
1522     function mintL1() external payable whenOpenForAll nonReentrant {
1523         require(msg.value >= l1Price, "Not enough ETH");
1524         require(l1Index < MAX_TOKENS, "L1s over");
1525         _safeMint(msg.sender, l1Index);
1526         l1Index = l1Index + 1;
1527     }
1528 
1529     function mintL2() external payable whenOpenForAll nonReentrant {
1530         require(msg.value >= l2Price, "Not enough ETH");
1531         require(l2Index < 6969 + MAX_TOKENS, "L2s over");
1532         _safeMint(msg.sender, l2Index);
1533         l2Index += 1;
1534     }
1535 
1536     function mintL1FromSA(uint256 stonedApezId) external payable whenSaleActive nonReentrant {
1537         require(sa.ownerOf(stonedApezId) == msg.sender, "Not your ape");
1538         require(!_apeMutatedForL1(stonedApezId), "Ape mutated already");
1539         mutatedL1s[stonedApezId] = l1Index + 1;
1540         _safeMint(msg.sender, l1Index);
1541         emit MintL1(stonedApezId, l1Index);
1542         l1Index += 1;
1543     }
1544 
1545     function mintL2FromSA(uint256 stonedApezId) external payable whenSaleActive nonReentrant {
1546         require(sa.ownerOf(stonedApezId) == msg.sender, "Not your ape");
1547         require(!_apeMutatedForL2(stonedApezId), "Ape mutated already");
1548         mutatedL2s[stonedApezId] = l2Index + 1;
1549         // Get list of all L2 tokens for the sender and check if mint is possible
1550         uint256 balance = balanceOf(msg.sender);
1551         uint256 stonedApezBalance = sa.balanceOf(msg.sender);
1552         uint256 l2Tokens = 0;
1553         for (uint256 i = 0; i < balance;  i++) {
1554             // Check if the token is an L2 token
1555             if (tokenOfOwnerByIndex(msg.sender,i) > 6968) {
1556                 l2Tokens++;
1557             }
1558         }
1559         
1560         if (uint256(stonedApezBalance)/uint256(6) <= l2Tokens){
1561             // You need to pay the price.
1562             require(msg.value >= l2Price, "Not enough ETH");
1563         }
1564         _safeMint(msg.sender, l2Index);
1565         emit MintL2(stonedApezId, l2Index);
1566         l2Index += 1;
1567     }
1568 
1569     function isMinted(uint256 tokenId) external view returns (bool) {
1570         require(
1571             tokenId < MAX_TOKENS,
1572             "tokenId outside collection bounds"
1573         );
1574         return _exists(tokenId);
1575     }
1576 
1577     function _baseURI() internal view override returns (string memory) {
1578         return baseURI;
1579     }
1580 
1581     function setBaseURI(string memory uri) external onlyOwner {
1582         baseURI = uri;
1583     }
1584 
1585     function toggleSaleActive() external onlyOwner {
1586         active = !active;
1587     }
1588 
1589     function setL1Price(uint256 price) external onlyOwner {
1590         l1Price = price;
1591     }
1592 
1593     function setL2Price(uint256 price) external onlyOwner {
1594         l2Price = price;
1595     }
1596 }